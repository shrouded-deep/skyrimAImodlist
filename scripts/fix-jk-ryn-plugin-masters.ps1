# Fix JK/Ryn missing masters on Keizaal - Fork (post task-0065)
# Root cause: task-0065 enabled .bsa archives as "plugins" instead of .esp masters;
# Ryn location base ESPs were never activated.
#Requires -Version 5.1
$ErrorActionPreference = 'Stop'

function Assert-Mo2Closed {
    $procs = Get-Process -Name 'ModOrganizer','modorganizer' -ErrorAction SilentlyContinue
    if ($procs) { throw 'MO2 is running — close Mod Organizer before running this script.' }
}

$modsDir   = 'E:\Skyrim\mods'
$profile   = 'E:\Skyrim\profiles\Keizaal - Fork'
$pluginsPath = Join-Path $profile 'plugins.txt'
$loadOrderPath = Join-Path $profile 'loadorder.txt'
$logPath   = 'D:\Skyrim AI Modlist\anvil-successor\modlist\exports\fix-jk-ryn-masters-run.log'

function Write-Log($msg) {
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $msg"
    Add-Content -Path $logPath -Value $line
    Write-Host $line
}

function Get-PluginMasters([string]$FilePath) {
    $masters = [System.Collections.Generic.List[string]]::new()
    try {
        $b = [System.IO.File]::ReadAllBytes($FilePath)
        if ($b.Length -lt 28) { return $masters }
        $i = 24
        $e = 24 + [BitConverter]::ToUInt32($b, 4)
        if ($e -gt $b.Length) { $e = $b.Length }
        while ($i -lt $e - 6) {
            if ($i + 6 -gt $b.Length) { break }
            $t = [System.Text.Encoding]::ASCII.GetString($b[$i..($i + 3)])
            $s = [BitConverter]::ToUInt16($b, $i + 4)
            if ($t -eq 'MAST' -and $s -gt 0 -and ($i + 6 + $s) -le $b.Length) {
                [void]$masters.Add([System.Text.Encoding]::ASCII.GetString($b[($i + 6)..($i + 6 + $s - 2)]))
            }
            $i += 6 + $s
            if ($s -eq 0) { break }
        }
    }
    catch { }
    return $masters
}

function Normalize-PluginName([string]$Name) {
    return $Name.ToLowerInvariant()
}

function Test-VanillaMaster([string]$m) {
    return $m -match '^(Skyrim|Update|Dawnguard|HearthFires|Dragonborn)\.esm$' -or
           $m -match '^cc[a-zA-Z0-9_-]+\.(esm|esl|esp)$' -or
           $m -eq '_ResourcePack.esl'
}

# Never auto-disable foundation plugins — implicit masters (e.g. _ResourcePack.esl) are
# satisfied by the game install and MO2 does not require them starred in plugins.txt.
$protectedPlugins = [System.Collections.Generic.HashSet[string]]::new(
    [StringComparer]::OrdinalIgnoreCase)
[void]$protectedPlugins.Add('unofficial skyrim special edition patch.esp')

Assert-Mo2Closed
if (Test-Path $logPath) { Remove-Item $logPath -Force }
Write-Log 'fix-jk-ryn-plugin-masters starting'

# --- Build mod-folder -> primary ESP map for JK/Ryn base mods ---
$baseEspByFolder = @{}
$skipBaseEspFolders = [System.Collections.Generic.HashSet[string]]::new(
    [StringComparer]::OrdinalIgnoreCase)
[void]$skipBaseEspFolders.Add("JK's Warmaiden's")  # patch-only; base JK's Warmaiden's.esp not on Fork/Anvil
Get-ChildItem -LiteralPath $modsDir -Directory | Where-Object { $_.Name -match "^JK's Ryn|^Ryn's|^JK's" } | ForEach-Object {
    $folder = $_.Name
    if ($folder -match 'Patch (Collection|Hub)') { return }
    if ($skipBaseEspFolders.Contains($folder)) { return }
    $esps = @(Get-ChildItem -LiteralPath $_.FullName -File -Filter '*.esp' -ErrorAction SilentlyContinue)
    if ($esps.Count -eq 1) {
        $baseEspByFolder[$folder] = $esps[0].Name
    }
}

# Known multi-esp folders: pick Anvil's primary
$primaryOverrides = @{
    "JK's The Drunken Huntsman" = "JKs The Drunken Huntsman.esp"
    "JK's Whiterun Outskirts" = "JK's Whiterun's Outskirts.esp"
    "JK's Windhelm Outskirts" = "JK's Windhelm's Outskirts.esp"
    "Ryn's Valtheim Towers" = "ValtheimKeepRecovered.esp"
    "Ryn's Bleak Falls Barrow" = "BleakFallsReCovered.esp"
    "Ryn's Goldenglow Estate" = "Ryn's GoldenGlow Estate.esp"
    "Ryn's Mehrunes Dagon's Shrine" = "Ryn's Mehrunes Dagon Shrine.esp"
}
foreach ($kv in $primaryOverrides.GetEnumerator()) {
    $baseEspByFolder[$kv.Key] = $kv.Value
}

# BSA -> ESP swaps (active .bsa lines copied from Anvil plugins.txt mistake)
$bsaToEsp = @{
    "JK's Haelga's Bunkhouse.bsa" = "JK's Haelga's Bunkhouse.esp"
    "JK's New Gnisis Cornerclub - Textures.bsa" = "JK's New Gnisis Cornerclub.esp"
    "JK's Nightgate Inn.bsa" = "JK's Nightgate Inn.esp"
    "JK's Radiant Raiment.bsa" = "JK's Radiant Raiment.esp"
    "JKs The Drunken Huntsman.bsa" = "JKs The Drunken Huntsman.esp"
    "JK's The Winking Skeever.bsa" = "JK's The Winking Skeever.esp"
    "JK's Blue Palace.bsa" = "JK's Blue Palace.esp"
    "JK's Dragonsreach.bsa" = "JK's Dragonsreach.esp"
    "JK's Palace of the Kings.bsa" = "JK's Palace of the Kings.esp"
    "JK's Understone Keep.bsa" = "JK's Understone Keep.esp"
    "JK's Castle Dour.bsa" = "JK's Castle Dour.esp"
    "JK's Castle Volkihar.bsa" = "JK's Castle Volkihar.esp"
    "JK's College of Winterhold - Textures.bsa" = "JK's College of Winterhold.esp"
    "JK's Dark Brotherhood Sanctuary.bsa" = "JK's Dark Brotherhood Sanctuary.esp"
    "JK's Fort Dawnguard.bsa" = "JK's Fort Dawnguard.esp"
    "JK's Sky Haven Temple.bsa" = "JK's Sky Haven Temple.esp"
    "JK's The Bards College - Textures.bsa" = "JK's The Bards College.esp"
    "JK's Thieves Guild.bsa" = "JK's Thieves Guild.esp"
    "JK's Whiterun's Outskirts.bsa" = "JK's Whiterun's Outskirts.esp"
    "JK's Windhelm's Outskirts.bsa" = "JK's Windhelm's Outskirts.esp"
    "JK's Riften Outskirts.bsa" = "JK's Riften Outskirts.esp"
    "JK's Markarth Outskirts.bsa" = "JK's Markarth Outskirts.esp"
    "JK's Sinderion's Field Laboratory.bsa" = "JK's Sinderion's Field Laboratory.esp"
    "JK's Septimus Signus's Outpost.bsa" = "JK's Septimus Signus's Outpost.esp"
    "JK's Riverfall Cottage.bsa" = "JK's Riverfall Cottage.esp"
}

$plugins = @(Get-Content -LiteralPath $pluginsPath -Encoding UTF8)
$loadorder = @(Get-Content -LiteralPath $loadOrderPath -Encoding UTF8)

# Remove non-plugin active entries (SWF/DLL mistaken as plugins)
$badActive = @('BTPS_menu.swf','BTPS_overlay_menu.swf','ELIF.dll','meta.ini')
$plugins = @($plugins | Where-Object {
    $bare = $_.TrimStart('*').Trim()
    $badActive -notcontains $bare
})

$swapped = 0
$newPlugins = [System.Collections.Generic.List[string]]::new()
$activeSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)

foreach ($line in $plugins) {
    if ($line -match '^\*(.+)$') {
        $bare = $Matches[1]
        if ($bsaToEsp.ContainsKey($bare)) {
            $esp = $bsaToEsp[$bare]
            $newPlugins.Add("*$esp")
            [void]$activeSet.Add($esp)
            $swapped++
            Write-Log "SWAP bsa->esp: $bare -> $esp"
            continue
        }
        [void]$activeSet.Add($bare)
        [void]$newPlugins.Add($line)
    }
    else {
        [void]$newPlugins.Add($line)
    }
}
$plugins = @($newPlugins)

# Enable Ryn/JK base ESPs from installed base mods
$baseToEnable = @($baseEspByFolder.Values | Select-Object -Unique)
$addedBase = 0
foreach ($esp in $baseToEnable) {
    if ($activeSet.Contains($esp)) { continue }
  $path = Get-ChildItem -LiteralPath $modsDir -Recurse -Filter $esp -File -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $path) { continue }
    $plugins += "*$esp"
    [void]$activeSet.Add($esp)
    if ($loadorder -notcontains $esp) { $loadorder += $esp }
    $addedBase++
    Write-Log "ENABLE base: $esp"
}

# MO2-style check: every master of every ACTIVE plugin must be ACTIVE (case-insensitive)
$pluginIndex = @{}
Get-ChildItem -LiteralPath $modsDir -Recurse -Include *.esp,*.esm,*.esl -File -ErrorAction SilentlyContinue | ForEach-Object {
    $key = Normalize-PluginName $_.Name
    if (-not $pluginIndex.ContainsKey($key)) { $pluginIndex[$key] = $_.FullName }
}
Get-ChildItem 'E:\Skyrim\root\Data' -File -ErrorAction SilentlyContinue | Where-Object { $_.Extension -in '.esp','.esm','.esl' } | ForEach-Object {
    $key = Normalize-PluginName $_.Name
    if (-not $pluginIndex.ContainsKey($key)) { $pluginIndex[$key] = $_.FullName }
}

$activeNorm = @{}
foreach ($a in $activeSet) { $activeNorm[(Normalize-PluginName $a)] = $a }

$disabled = [System.Collections.Generic.List[string]]::new()
$finalPlugins = [System.Collections.Generic.List[string]]::new()
foreach ($line in $plugins) {
    if ($line -notmatch '^\*(.+)$') {
        [void]$finalPlugins.Add($line)
        continue
    }
    $bare = $Matches[1]
    $path = $pluginIndex[(Normalize-PluginName $bare)]
    if (-not $path) {
        [void]$finalPlugins.Add($line)
        continue
    }
    $missing = @()
    foreach ($m in (Get-PluginMasters $path)) {
        if (Test-VanillaMaster $m) { continue }
        if (-not $activeNorm.ContainsKey((Normalize-PluginName $m))) {
            $missing += $m
        }
    }
    if ($missing.Count -gt 0) {
        if ($protectedPlugins.Contains($bare)) {
            [void]$finalPlugins.Add($line)
            Write-Log "KEEP protected (missing implicit master): $bare -> $($missing -join ', ')"
            continue
        }
        [void]$finalPlugins.Add($bare)
        [void]$disabled.Add($bare)
        Write-Log "DISABLE (MO2 MAST): $bare -> $($missing -join ', ')"
    }
    else {
        [void]$finalPlugins.Add($line)
    }
}

# Remove disabled from loadorder
$disabledSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($d in $disabled) { [void]$disabledSet.Add($d) }
$loadorder = @($loadorder | Where-Object { -not $disabledSet.Contains($_) })

Set-Content -LiteralPath $pluginsPath -Value $finalPlugins -Encoding UTF8
Set-Content -LiteralPath $loadOrderPath -Value $loadorder -Encoding UTF8

$activeAfter = ($finalPlugins | Where-Object { $_ -match '^\*' }).Count
Write-Log "bsa->esp swaps: $swapped; base esps enabled: $addedBase; plugins disabled: $($disabled.Count)"
Write-Log "active plugins after fix: $activeAfter"
Write-Log 'fix-jk-ryn-plugin-masters complete'
