# task-0069: Swap JK's Skyrim AIO for modular city stack on Lost Legacy - Fork
#Requires -Version 5.1
$ErrorActionPreference = 'Stop'

function Assert-Mo2Closed {
    $procs = Get-Process -Name 'ModOrganizer', 'modorganizer' -ErrorAction SilentlyContinue
    if ($procs) { throw 'MO2 is running — close Mod Organizer before running this script.' }
}

function Write-Log($msg) {
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $msg"
    Add-Content -Path $script:LogPath -Value $line
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

function Test-VanillaMaster([string]$m) {
    return $m -match '^(Skyrim|Update|Dawnguard|HearthFires|Dragonborn)\.esm$' -or
           $m -match '^cc[a-zA-Z0-9_-]+\.(esm|esl|esp)$' -or
           $m -eq '_ResourcePack.esl'
}

$AnvilMods = 'D:\Skyrim AI Modlist\Anvil\mods'
$SkyrimMods = 'D:\Skyrim\mods'
$Profile = 'D:\Skyrim\profiles\Lost Legacy - Fork'
$ModlistPath = Join-Path $Profile 'modlist.txt'
$PluginsPath = Join-Path $Profile 'plugins.txt'
$LoadOrderPath = Join-Path $Profile 'loadorder.txt'
$LogPath = 'D:\Skyrim AI Modlist\anvil-successor\modlist\exports\install-ll-city-stack-run.log'

# Task names with Anvil folder name corrections noted in log
$jkDisableMods = @(
    "JK's Skyrim all in one",
    "JK's Skyrim AIO - Reduced Cut",
    "JK's Skyrim - Reduced Cut - Dragon Bridge",
    "JK's Skyrim - Gray Cowl (CC) Patch",
    "JK's Skyrim - Fishing (CC) Patch",
    'KWF - JK''s Skyrim'
)

$cityModFolders = @(
    'Capital Whiterun Expansion',
    'Rob''s Bug Fixes - Capital Whiterun',  # task: Rob's Bug Fixes - Capital Whiterun Expansion
    'Capital Windhelm Expansion',
    'Spaghetti''s Capital Windhelm Expansion',
    'Ultimate Markarth',
    'Ultimate Markarth Expanded',
    'UME Patch Hub',
    'RedBag''s Solitude',
    'RedBag Patch Collection',
    'City of Crossed Daggers - Riften Expansion',
    'Riverwood Has Charm and Walls',
    'Riverwood Has Walls Patch Collection',
    "Spaghetti's Cities - Whiterun",
    "Spaghetti's Cities - Windhelm",
    "Spaghetti's Cities - Markarth",
    "Spaghetti's Cities - Solitude",
    "Spaghetti's Cities - Riften",
    "Spaghetti's Towns - Riverwood",
    'CWE Spaghetti Patch',                    # task: CWE - Spaghetti's Cities Patch
    'Crossed Daggers - Spaghetti Patch',      # task: Crossed Daggers - Spaghetti's Cities Patch
    'Ivy - Whiterun Well Overhaul',
    'Ivy - Riverwood Smelter Addon'
)

$jkDisablePlugins = @(
    'JKs Skyrim.esp',
    'JK''s Skyrim - Lightened.esp',
    'JK''s Skyrim - Reduced Cut - Dragon Bridge.esp',
    'JK''s Skyrim - Lightened - Creation Club.esp',
    'JKs Skyrim - Gray Cowl Patch.esp',
    'JKs Skyrim - Fishing patch.esp',
    'Occ_Skyrim_JK-Skyrim_patch.esp',
    'KWFPatch_JKSkyrim.esp',
    'Lux Via - JK''s Skyrim Patch.esp',
    'Lux Orbis - JK''s Skyrim patch.esp',
    'Lux Orbis - LotD JK''s Skyrim patch.esp',
    'Lux - JK''s Skyrim.esp',
    'Lux Orbis - JK''s Skyrim Reduced Cut.esp',
    'DBM_JKSkyrim_Patch.esp',
    'Nature of the Wild Lands - JKs Skyrim.esp'
)

$cityEnablePlugins = @(
    'SurWR.esp',
    'WindhelmSSE.esp',
    'Ultimate Markarth.esp',
    'Ultimate Markarth Expanded.esp',
    "RedBag's Solitude.esp",
    "USSEP Patch for RedBag's Solitude.esp",
    'Riften Expansion.esp',
    'Riverwood Has Charm.esp',
    'Riverwood Has Walls.esp',
    'Riverwood Has Charm + Walls.esp',
    "Spaghetti's Cities - Whiterun.esp",
    "Spaghetti's Cities - Windhelm.esp",
    "Spaghetti's Capital Windhelm Expansion - Individual.esp",
    "Spaghetti's Cities - Markarth.esp",
    "Spaghetti's Cities - Solitude.esp",
    "Spaghetti's Cities - Riften.esp",
    "Spaghetti's Towns - Riverwood.esp",
    'Captial Whiterun and Spaghetti AIO Patch.esp',
    'Riften Expansion - Spaghetti Cities Riften Patch.esp',
    "Markarth Expanded - JK's Understone Keep.esp",
    'Markarth Expanded - Lux Orbis.esp',
    'Markarth Expanded - Lux.esp',
    "RedBag's Solitude - Lux Via patch.esp",
    "Riverwood Has Charm - Spaghetti's Riverwood Patch.esp",
    'Ivy - Whiterun - Well Overhaul.esp',
    'Ivy - Whiterun - Well Overhaul - Capital Whiterun Patch.esp',
    'Ivy - Riverwood Smelter Addon.esp'
)

Assert-Mo2Closed
if (Test-Path $LogPath) { Remove-Item $LogPath -Force }
Write-Log 'task-0069 Lost Legacy - Fork city stack starting'
Write-Log 'NOTE Anvil name map: Rob''s Bug Fixes - Capital Whiterun; CWE Spaghetti Patch; Crossed Daggers - Spaghetti Patch'

$sepDir = Join-Path $SkyrimMods 'City Stack_separator'
if (-not (Test-Path -LiteralPath $sepDir)) {
    New-Item -ItemType Directory -Path $sepDir -Force | Out-Null
    Write-Log 'CREATE separator folder: City Stack_separator'
}

$copied = 0; $skipped = 0
foreach ($folder in $cityModFolders) {
    $src = Join-Path $AnvilMods $folder
    $dst = Join-Path $SkyrimMods $folder
    if (-not (Test-Path -LiteralPath $src)) {
        Write-Log "WARN missing on Anvil: $folder"
        continue
    }
    if (Test-Path -LiteralPath $dst) { Write-Log "SKIP exists: $folder"; $skipped++; continue }
    Write-Log "COPY $folder"
    robocopy $src $dst /E /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "robocopy failed: $folder exit $LASTEXITCODE" }
    $copied++
}

$jkSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($m in $jkDisableMods) { [void]$jkSet.Add($m) }
$citySet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($m in $cityModFolders) { [void]$citySet.Add($m) }

$modlist = Get-Content $ModlistPath
$newModlist = New-Object System.Collections.Generic.List[string]
$cityInserted = $false
$citySeen = @{}

foreach ($line in $modlist) {
    if ($line -match '^[+-](.+)$') {
        $name = $Matches[1].Trim()
        if ($jkSet.Contains($name)) {
            if (-not $name.EndsWith('_separator')) { $newModlist.Add("-$name") }
            continue
        }
        if ($name -eq "JK's Interiors Patch Collection" -and -not $cityInserted) {
            $newModlist.Add('-City Stack_separator')
            foreach ($mod in $cityModFolders) {
                if (Test-Path -LiteralPath (Join-Path $SkyrimMods $mod)) {
                    $newModlist.Add("+$mod")
                    $citySeen[$mod] = $true
                }
            }
            $cityInserted = $true
            $newModlist.Add($line)
            continue
        }
        if ($citySet.Contains($name)) {
            if (-not $citySeen.ContainsKey($name)) {
                $newModlist.Add("+$name")
                $citySeen[$name] = $true
            }
            $cityInserted = $true
            continue
        }
    }
    $newModlist.Add($line)
}

if (-not $cityInserted) {
    throw "Anchor not found: JK's Interiors Patch Collection"
}

Set-Content -Path $ModlistPath -Value $newModlist -Encoding UTF8
Write-Log "modlist: disabled $($jkDisableMods.Count) JK exterior mods; enabled $($citySeen.Count) city stack mods"

$pluginsBefore = (Get-Content $PluginsPath | Where-Object { $_ -match '^\*' }).Count
Write-Log "plugins active before: $pluginsBefore"

$disablePluginSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($p in $jkDisablePlugins) { [void]$disablePluginSet.Add($p) }
$enablePluginSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($p in $cityEnablePlugins) { [void]$enablePluginSet.Add($p) }

$out = [System.Collections.Generic.List[string]]::new()
foreach ($line in (Get-Content $PluginsPath)) {
    if ($line -match '^\*(.+)$') {
        $bare = $Matches[1]
        if ($disablePluginSet.Contains($bare)) { $out.Add($bare); continue }
    }
    $bare2 = $line.TrimStart('*').Trim()
    if ($enablePluginSet.Contains($bare2) -and $line -notmatch '^\*') {
        $out.Add("*$bare2")
        continue
    }
    [void]$out.Add([string]$line)
}

foreach ($p in $cityEnablePlugins) {
    $found = $false
    foreach ($line in $out) {
        if ($line.TrimStart('*').Trim().Equals($p, [StringComparison]::OrdinalIgnoreCase)) { $found = $true; break }
    }
    if (-not $found) { $out.Add("*$p") }
}

# Build plugin index from enabled mods + game data
$enabledMods = $newModlist | Where-Object { $_ -match '^\+' } | ForEach-Object { $_ -replace '^\+', '' } | Where-Object { $_ -notmatch '_separator$' }
$pluginIndex = @{}
foreach ($mod in $enabledMods) {
    $d = Join-Path $SkyrimMods $mod
    if (-not (Test-Path -LiteralPath $d)) { continue }
    Get-ChildItem -LiteralPath $d -Recurse -Include *.esp, *.esm, *.esl -File -EA SilentlyContinue | ForEach-Object {
        if (-not $pluginIndex.ContainsKey($_.Name)) { $pluginIndex[$_.Name] = $_.FullName }
    }
}
Get-ChildItem 'D:\Skyrim\root\Data' -File -EA SilentlyContinue | Where-Object { $_.Extension -in '.esp', '.esm', '.esl' } | ForEach-Object {
    if (-not $pluginIndex.ContainsKey($_.Name)) { $pluginIndex[$_.Name] = $_.FullName }
}

$disabledMast = [System.Collections.Generic.List[string]]::new()
$pass1 = [System.Collections.Generic.List[string]]::new()
foreach ($line in $out) {
    if ($line -match '^\*(.+)$') { [void]$pass1.Add($Matches[1]) }
    else {
        $bare = $line.TrimStart('*').Trim()
        if ($bare -and $enablePluginSet.Contains($bare)) { [void]$pass1.Add($bare) }
    }
}
$activeNorm = @{}
foreach ($a in $pass1) { $activeNorm[$a.ToLowerInvariant()] = $a }

$final = [System.Collections.Generic.List[string]]::new()
foreach ($line in $out) {
    if ($line -notmatch '^\*(.+)$') {
        [void]$final.Add($line)
        continue
    }
    $bare = $Matches[1]
    $path = $pluginIndex[$bare]
    if (-not $path) {
        [void]$final.Add($line)
        continue
    }
    $missing = @()
    foreach ($m in (Get-PluginMasters $path)) {
        if (Test-VanillaMaster $m) { continue }
        if (-not $activeNorm.ContainsKey($m.ToLowerInvariant())) { $missing += $m }
    }
    if ($missing.Count -gt 0) {
        [void]$final.Add($bare)
        [void]$disabledMast.Add("$bare -> $($missing -join ', ')")
    }
    else {
        [void]$final.Add($line)
    }
}

$disabledSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($d in $disabledMast) {
    $name = ($d -split ' -> ')[0]
    [void]$disabledSet.Add($name)
}
$loadorder = @(Get-Content $LoadOrderPath | Where-Object { -not $disabledSet.Contains($_) })

Set-Content -Path $PluginsPath -Value $final -Encoding UTF8
Set-Content -Path $LoadOrderPath -Value $loadorder -Encoding UTF8

$pluginsAfter = ($final | Where-Object { $_ -match '^\*' }).Count
Write-Log "MAST-disabled $($disabledMast.Count) plugins"
foreach ($d in $disabledMast) { Write-Log "  DISABLE $d" }
Write-Log "plugins active after: $pluginsAfter"
Write-Log 'task-0069 complete — MO2 F5 refresh + in-game spot check'
