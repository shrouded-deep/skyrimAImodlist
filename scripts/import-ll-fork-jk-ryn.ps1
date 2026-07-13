# task-0073: Import JK's exterior + Ryn's stacks from Anvil onto Lost Legacy - Fork
#Requires -Version 5.1
$ErrorActionPreference = 'Stop'

function Assert-Mo2Closed {
    $procs = Get-Process -Name 'ModOrganizer', 'modorganizer' -ErrorAction SilentlyContinue
    if ($procs) { throw 'MO2 is running - close Mod Organizer before running this script.' }
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

function Get-ModPlugins([string]$ModPath) {
    if (-not (Test-Path -LiteralPath $ModPath)) { return @() }
    Get-ChildItem -LiteralPath $ModPath -Recurse -Include *.esp, *.esm, *.esl -File -EA SilentlyContinue |
        Where-Object { $_.Extension -ne '.mohidden' -and $_.Name -notmatch '\.mohidden$' } |
        Select-Object -ExpandProperty Name
}

$AnvilMods = 'D:\Skyrim AI Modlist\Anvil\mods'
$SkyrimMods = 'D:\Skyrim\mods'
$Profile = 'D:\Skyrim\profiles\Lost Legacy - Fork'
$ModlistPath = Join-Path $Profile 'modlist.txt'
$PluginsPath = Join-Path $Profile 'plugins.txt'
$LoadOrderPath = Join-Path $Profile 'loadorder.txt'
$LogPath = 'D:\Skyrim AI Modlist\anvil-successor\modlist\exports\import-ll-jk-ryn-run.log'

# JK AIO / Reduced Cut - already handled by city stack; never import
$jkExcludePatterns = @(
    "JK's Skyrim all in one",
    "JK's Skyrim AIO",
    "JK's Skyrim - Reduced Cut",
    "JK's Skyrim - Gray Cowl",
    "JK's Skyrim - Fishing",
    'KWF - JK'
)

# JK interiors already present in Fork under same or equivalent folder names
$jkForkEquivalent = @{
    "JK's Angeline's Aromatics"           = "Jk's Angeline's Aromatics"
    "JK's Dark Brotherhood Sanctuaries" = "JK's Dark Brotherhood Sanctuary"
    "JK's Elgrim's Elixirs"             = "JK's Elgrims Elixirs"
    "JK's Sadri's Used Wares"           = "JK's Sadris Used Wares"
    "JK's Thieves Guild HQ"             = "JK's Thieves Guild"
}

# Lost Legacy Ryn's entries to disable (replaced by Anvil individual stack)
$llRynDisableMods = @(
    "Ryn's Locations",
    "Ryn's Standing Stones Patch Collection"
)

# Standing Stones collision: import Anvil copy under renamed folder
$standingStonesAnvilRename = "Ryn's Standing Stones Patch Collection - Anvil"

# Mod order mirrors Anvil - Main Profile (top = higher priority within section)
$jkImportOrder = @(
    "JK's Whiterun Outskirts",
    "JK's Windhelm Outskirts",
    "JK's Riften Outskirts",
    "JK's Markarth Outskirts",
    "JK's Riverfall Cottage",
    "JK's Windhelm Outskirts Patch Collection",
    "JK's Riften Outskirts Patch Collection",
    "JK's Markarth Outskirts Patch Collection"
)

$rynImportOrder = @(
    "Ryn's Farms",
    "Ryn's Standing Stones",
    "Ryn's Dragon Mounds Collection",
    "Ryn's Alchemist's Shack",
    "Ryn's Anise's Cabin",
    "Ryn's Azura's Shrine",
    "Ryn's Bleak Falls Barrow",
    "Ryn's Bleakwind Basin",
    "Ryn's Goldenglow Estate",
    "Ryn's Halted Stream Camp",
    "Ryn's Karthspire",
    "Ryn's Lost Valley Redoubt",
    "Ryn's Lund's Hut",
    "Ryn's Lumber Mills",
    "Ryn's Mehrunes Dagon's Shrine",
    "Ryn's Mistwatch Folly",
    "Ryn's Saarthal",
    "Ryn's Secunda's Kiss",
    "Ryn's Ustengrav",
    "Ryn's Valtheim Towers",
    "Ryn's Western Watchtower",
    "Ryn's Riverwood Trader",
    "Ryn's Sleeping Giant Inn",
    "Ryn's Alvor and Sigrid's House",
    "Ryn's Faendal's House",
    "Ryn's Hod and Gerdur's House",
    "Ryn's Sven's and Hilde's House",
    "Ryn's Whiterun City Limits",
    "Ryn's Skyrim Official Patch Hub",
    "Ryn's Skyrim Patch Collection",
    $standingStonesAnvilRename,
    "Ryn's Riverwood Patch Collection"
)

Assert-Mo2Closed
if (Test-Path $LogPath) { Remove-Item $LogPath -Force }
Write-Log 'task-0073 Lost Legacy - Fork JK exterior + Ryn stack import starting'

$pluginsBefore = (Get-Content $PluginsPath | Where-Object { $_ -match '^\*' }).Count
Write-Log "plugins active before: $pluginsBefore"

# --- Step 1: Inventory JK mods in Anvil ---
$jkAnvilAll = Get-ChildItem -LiteralPath $AnvilMods -Directory |
    Where-Object { $_.Name -match "^JK'?s" } |
    Sort-Object Name | ForEach-Object { $_.Name }

$jkImport = [System.Collections.Generic.List[string]]::new()
$jkSkipped = [System.Collections.Generic.List[string]]::new()
foreach ($name in $jkAnvilAll) {
    $isAio = $false
    foreach ($pat in $jkExcludePatterns) {
        if ($name -like "*$pat*") { $isAio = $true; break }
    }
    if ($isAio) {
        [void]$jkSkipped.Add("$name (AIO/Reduced Cut - excluded)")
        continue
    }
    if ($jkForkEquivalent.ContainsKey($name)) {
        $eq = $jkForkEquivalent[$name]
        if (Test-Path -LiteralPath (Join-Path $SkyrimMods $eq)) {
            [void]$jkSkipped.Add("$name (Fork has equivalent: $eq)")
            continue
        }
    }
    if (Test-Path -LiteralPath (Join-Path $SkyrimMods $name)) {
        [void]$jkSkipped.Add("$name (already in Fork)")
        continue
    }
    if ($jkImportOrder -contains $name) {
        [void]$jkImport.Add($name)
    }
    else {
        [void]$jkSkipped.Add("$name (interior - already in Fork)")
    }
}

Write-Log "JK import list ($($jkImport.Count)): $($jkImport -join '; ')"
foreach ($s in $jkSkipped) { Write-Log "JK SKIP: $s" }

# --- Step 2: Inventory Ryn's mods in Anvil ---
$rynAnvilAll = Get-ChildItem -LiteralPath $AnvilMods -Directory |
    Where-Object { $_.Name -match "^Ryn's" } |
    Sort-Object Name | ForEach-Object { $_.Name }

$rynImport = [System.Collections.Generic.List[string]]::new()
$rynCollisions = [System.Collections.Generic.List[string]]::new()
foreach ($name in $rynImportOrder) {
    if ($name -eq $standingStonesAnvilRename) {
        $srcName = "Ryn's Standing Stones Patch Collection"
        if (Test-Path -LiteralPath (Join-Path $SkyrimMods $srcName)) {
            [void]$rynCollisions.Add("$srcName -> renamed to $standingStonesAnvilRename (LL folder kept; not overwritten)")
        }
        [void]$rynImport.Add($name)
        continue
    }
    if (Test-Path -LiteralPath (Join-Path $SkyrimMods $name)) {
        [void]$rynCollisions.Add("$name (already in Fork - skip copy)")
        continue
    }
    if (-not (Test-Path -LiteralPath (Join-Path $AnvilMods $name))) {
        Write-Log "WARN Ryn's missing on Anvil: $name"
        continue
    }
    [void]$rynImport.Add($name)
}

Write-Log "Ryn import list ($($rynImport.Count)): $($rynImport -join '; ')"
foreach ($c in $rynCollisions) { Write-Log "Ryn COLLISION: $c" }

# --- Step 4: Copy mod folders ---
$copied = 0; $copySkipped = 0
foreach ($folder in ($jkImport + $rynImport)) {
    $srcName = $folder
    if ($folder -eq $standingStonesAnvilRename) {
        $srcName = "Ryn's Standing Stones Patch Collection"
    }
    $src = Join-Path $AnvilMods $srcName
    $dst = Join-Path $SkyrimMods $folder
    if (-not (Test-Path -LiteralPath $src)) {
        Write-Log "WARN missing on Anvil: $srcName"
        continue
    }
    if (Test-Path -LiteralPath $dst) {
        Write-Log "SKIP copy exists: $folder"
        $copySkipped++
        continue
    }
    Write-Log "COPY $srcName -> $folder"
    robocopy $src $dst /E /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "robocopy failed: $folder exit $LASTEXITCODE" }
    $copied++
}

Write-Log "Copied $copied folders; skipped $copySkipped existing"

# Plugins to disable from LL Ryn's bundle + LL Standing Stones
$llDisablePlugins = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($mod in $llRynDisableMods) {
    $modPath = Join-Path $SkyrimMods $mod
    foreach ($p in (Get-ModPlugins $modPath)) { [void]$llDisablePlugins.Add($p) }
}
Write-Log "LL Ryn plugins to unstar: $($llDisablePlugins.Count)"

# Plugins to enable from newly imported mods
$enablePlugins = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($mod in ($jkImport + $rynImport)) {
    $modPath = Join-Path $SkyrimMods $mod
    foreach ($p in (Get-ModPlugins $modPath)) { [void]$enablePlugins.Add($p) }
}

# --- Step 5: Update modlist.txt ---
$jkSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($m in $jkImport) { [void]$jkSet.Add($m) }
$rynSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($m in $rynImport) { [void]$rynSet.Add($m) }
$llRynSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($m in $llRynDisableMods) { [void]$llRynSet.Add($m) }

$modlist = Get-Content $ModlistPath
$newModlist = [System.Collections.Generic.List[string]]::new()
$rynInserted = $false
$jkInserted = $false
$rynSeen = @{}
$jkSeen = @{}

foreach ($line in $modlist) {
    if ($line -match '^[+-](.+)$') {
        $name = $Matches[1].Trim()

        if ($llRynSet.Contains($name)) {
            $newModlist.Add("-$name")
            continue
        }

        if ($rynSet.Contains($name)) {
            if (-not $rynSeen.ContainsKey($name)) {
                $newModlist.Add("+$name")
                $rynSeen[$name] = $true
            }
            continue
        }

        if ($name -eq "Ryn's Mods_separator" -and -not $rynInserted) {
            foreach ($mod in $rynImportOrder) {
                if ($rynSet.Contains($mod) -and (Test-Path -LiteralPath (Join-Path $SkyrimMods $mod))) {
                    if (-not $rynSeen.ContainsKey($mod)) {
                        $newModlist.Add("+$mod")
                        $rynSeen[$mod] = $true
                    }
                }
            }
            $rynInserted = $true
            $newModlist.Add($line)
            continue
        }

        if ($jkSet.Contains($name)) {
            if (-not $jkSeen.ContainsKey($name)) {
                $newModlist.Add("+$name")
                $jkSeen[$name] = $true
            }
            continue
        }

        if ($name -eq 'JKs Skyrim_separator' -and -not $jkInserted) {
            foreach ($mod in $jkImportOrder) {
                if ($jkSet.Contains($mod) -and (Test-Path -LiteralPath (Join-Path $SkyrimMods $mod))) {
                    if (-not $jkSeen.ContainsKey($mod)) {
                        $newModlist.Add("+$mod")
                        $jkSeen[$mod] = $true
                    }
                }
            }
            $jkInserted = $true
            $newModlist.Add($line)
            continue
        }
    }
    $newModlist.Add($line)
}

if (-not $rynInserted) { throw "Anchor not found: Ryn's Mods_separator" }
if (-not $jkInserted) { throw "Anchor not found: JKs Skyrim_separator" }

Set-Content -Path $ModlistPath -Value $newModlist -Encoding UTF8
Write-Log "modlist: disabled $($llRynDisableMods.Count) LL Ryn entries; added $($rynSeen.Count) Ryn + $($jkSeen.Count) JK mods"

# --- Step 6: Update plugins.txt ---
$out = [System.Collections.Generic.List[string]]::new()
foreach ($line in (Get-Content $PluginsPath)) {
    if ($line -match '^\*(.+)$') {
        $bare = $Matches[1]
        if ($llDisablePlugins.Contains($bare) -and -not $enablePlugins.Contains($bare)) {
            $out.Add($bare)
            continue
        }
    }
    $bare2 = $line.TrimStart('*').Trim()
    if ($enablePlugins.Contains($bare2)) {
        if ($line -notmatch '^\*') { $out.Add("*$bare2") }
        else { $out.Add($line) }
        continue
    }
    [void]$out.Add([string]$line)
}

foreach ($p in $enablePlugins) {
    $found = $false
    foreach ($line in $out) {
        if ($line.TrimStart('*').Trim().Equals($p, [StringComparison]::OrdinalIgnoreCase)) { $found = $true; break }
    }
    if (-not $found) { $out.Add("*$p") }
}

# Build plugin index
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

# --- Step 7: MAST scan ---
$disabledMast = [System.Collections.Generic.List[string]]::new()
$pass1 = [System.Collections.Generic.List[string]]::new()
foreach ($line in $out) {
    if ($line -match '^\*(.+)$') { [void]$pass1.Add($Matches[1]) }
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
Write-Log 'task-0073 complete - MO2 F5 refresh recommended'
