# task-0065: JK/Ryn + location detail stack for Keizaal - Fork
#Requires -Version 5.1
$ErrorActionPreference = 'Stop'

function Assert-Mo2Closed {
    $procs = Get-Process -Name 'ModOrganizer','modorganizer' -ErrorAction SilentlyContinue
    if ($procs) { throw 'MO2 is running — close Mod Organizer before running this script.' }
}

$AnvilMods    = 'D:\Skyrim AI Modlist\Anvil\mods'
$AnvilProfile = 'D:\Skyrim AI Modlist\Anvil\profiles\Anvil - Main Profile'
$SkyrimMods   = 'E:\Skyrim\mods'
$Profile      = 'E:\Skyrim\profiles\Keizaal - Fork'
$ModlistPath  = Join-Path $Profile 'modlist.txt'
$PluginsPath  = Join-Path $Profile 'plugins.txt'
$LoadOrderPath = Join-Path $Profile 'loadorder.txt'
$LogPath      = 'D:\Skyrim AI Modlist\anvil-successor\modlist\exports\install-jk-ryn-keizaal-run.log'

function Write-Log($msg) {
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $msg"
    Add-Content -Path $LogPath -Value $line
    Write-Host $line
}

function Get-PluginMasters([string]$FilePath) {
    $b = [System.IO.File]::ReadAllBytes($FilePath)
    $masters = [System.Collections.Generic.List[string]]::new()
    $i = 24
    $e = 24 + [BitConverter]::ToUInt32($b, 4)
    while ($i -lt $e - 6) {
        $t = [System.Text.Encoding]::ASCII.GetString($b[$i..($i + 3)])
        $s = [BitConverter]::ToUInt16($b, $i + 4)
        if ($t -eq 'MAST') {
            [void]$masters.Add([System.Text.Encoding]::ASCII.GetString($b[($i + 6)..($i + 6 + $s - 2)]))
        }
        $i += 6 + $s
    }
    return $masters
}

function Test-MastersAvailable([string]$PluginPath, [hashtable]$Present) {
    foreach ($m in (Get-PluginMasters $PluginPath)) {
        if (-not $Present.ContainsKey($m)) { return $false }
    }
    return $true
}

function Test-ExcludedPlugin([string]$Name) {
    if ($Name -match 'Spaghetti') { return $true }
    if ($Name -match 'Lux Via|Lux Orbis|\bLux - |SPO Lux| - Lux patch| - Lux Orbis') { return $true }
    return $false
}

$jkRynModFolders = @(
    "JK's Angeline's Aromatics","JK's Arcadia's Cauldron","JK's Arnleif and Sons Trading Company",
    "JK's Belethor's General Goods","JK's Bits and Pieces","JK's Elgrim's Elixirs",
    "JK's Haelga's Bunkhouse","JK's New Gnisis Cornerclub","JK's Nightgate Inn",
    "JK's Radiant Raiment","JK's Sadri's Used Wares","JK's Silver-Blood Inn",
    "JK's The Bannered Mare","JK's The Bee and Barb","JK's The Drunken Huntsman",
    "JK's The Hag's Cure","JK's The Pawned Prawn","JK's The Ragged Flagon",
    "JK's The Temple of Mara","JK's The Winking Skeever","JK's Warmaiden's","JK's White Phial",
    "JK's Blue Palace","JK's Candlehearth Hall","JK's Dragonsreach","JK's Mistveil Keep",
    "JK's Palace of the Kings","JK's Temple of Dibella","JK's Temple of Kynareth",
    "JK's Temple of Talos","JK's Temple of the Divines","JK's Understone Keep",
    "JK's Castle Dour","JK's Castle Volkihar","JK's College of Winterhold",
    "JK's Dark Brotherhood Sanctuaries","JK's Fort Dawnguard","JK's Jorrvaskr",
    "JK's Nightingale Hall","JK's Sky Haven Temple","JK's The Bards College","JK's Thieves Guild HQ",
    "JK's Whiterun Outskirts","JK's Windhelm Outskirts","JK's Riften Outskirts","JK's Markarth Outskirts",
    "JK's Sinderion's Field Laboratory","JK's Septimus Signus's Outpost","JK's Riverfall Cottage",
    "Ryn's Dragon Mounds Collection","Ryn's Farms","Ryn's Standing Stones",
    "Ryn's Alchemist's Shack","Ryn's Anise's Cabin","Ryn's Azura's Shrine","Ryn's Bleak Falls Barrow",
    "Ryn's Bleakwind Basin","Ryn's Goldenglow Estate","Ryn's Halted Stream Camp",
    "Ryn's Lost Valley Redoubt","Ryn's Lund's Hut","Ryn's Lumber Mills","Ryn's Mehrunes Dagon's Shrine",
    "Ryn's Mistwatch Folly","Ryn's Saarthal","Ryn's Secunda's Kiss","Ryn's Ustengrav",
    "Ryn's Valtheim Towers","Ryn's Western Watchtower","Ryn's Whiterun City Limits",
    "Ryn's Riverwood Trader","Ryn's Sleeping Giant Inn","Ryn's Alvor and Sigrid's House",
    "Ryn's Faendal's House","Ryn's Hod and Gerdur's House","Ryn's Sven's and Hilde's House",
    "JK's Interiors Patch Collection","JK's Guild HQ Interiors Patch Collection",
    'Whiterun Exteriors Patch Hub',"JK's Windhelm Outskirts Patch Collection",
    "JK's Riften Outskirts Patch Collection","JK's Markarth Outskirts Patch Collection",
    "Ryn's Skyrim Official Patch Hub","Ryn's Skyrim Patch Collection",
    "Ryn's Standing Stones Patch Collection","Ryn's Riverwood Patch Collection",
    'Ivy - Whiterun Well Overhaul','Ivy - Riverwood Smelter Addon',
    'FYX - Windhelm Graveyard','FYX - Temple of Mara Ornament - Particle Lights for CS or ENB',
    'FYX - The Temple of Mara','FYX - Jorrvaskr','FYX - RowBoat',
    "FYX - 3D Shack Kit Walls - aljo's Abandoned Shack Interior Fix",
    'FYX - 3D Shack Kit Walls - BOS','FYX - 3D Shack Kit Walls','FYX - 3D Shack Kit Roofs',
    'FYX - RavenRock Docks and Fences Round Posts'
)

# Keizaal already ships Karthspire with custom tweaks — do not overwrite mod folder.
$skipCopyIfExists = @("Ryn's Karthspire") | ForEach-Object { $_.ToLowerInvariant() }

$forceEnablePlugins = @(
    "Markarth Expanded - JK's Understone Keep.esp",
    "Markarth Expanded - PCE - JK's Understone Keep.esp"
)

Assert-Mo2Closed
if (Test-Path $LogPath) { Remove-Item $LogPath -Force }
Write-Log 'task-0065 JK/Ryn stack install starting'

# --- copy mod folders from Anvil donor ---
$copied = 0; $skipped = 0; $missing = 0
foreach ($folder in $jkRynModFolders) {
    $src = Join-Path $AnvilMods $folder
    $dst = Join-Path $SkyrimMods $folder
    if (-not (Test-Path -LiteralPath $src)) {
        Write-Log "WARN missing on Anvil: $folder"
        $missing++
        continue
    }
    if (Test-Path -LiteralPath $dst) {
        Write-Log "SKIP exists: $folder"
        $skipped++
        continue
    }
    Write-Log "COPY $folder"
    robocopy $src $dst /E /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "robocopy failed $folder exit $LASTEXITCODE" }
    $copied++
}

if (-not (Test-Path -LiteralPath (Join-Path $AnvilMods "JK's High Hrothgar"))) {
    Write-Log 'NOTE skipped JK''s High Hrothgar — not on Anvil donor (Nexus 62219)'
}

# --- modlist.txt: enable above Uncategorized_separator ---
$enableSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($m in $jkRynModFolders) { [void]$enableSet.Add($m) }

$modlist = Get-Content $ModlistPath
$newModlist = New-Object System.Collections.Generic.List[string]
$seen = @{}
$uncatMarker = 'Uncategorized_separator'

foreach ($line in $modlist) {
    if ($line -match '^[+-](.+)$') {
        $name = $Matches[1].Trim()
        if ($enableSet.Contains($name)) {
            if (-not $seen.ContainsKey($name)) {
                $newModlist.Add("+$name")
                $seen[$name] = $true
            }
            continue
        }
        if ($name -eq $uncatMarker) {
            foreach ($mod in $jkRynModFolders) {
                if (-not $seen.ContainsKey($mod) -and (Test-Path -LiteralPath (Join-Path $SkyrimMods $mod))) {
                    $newModlist.Add("+$mod")
                    $seen[$mod] = $true
                }
            }
            $newModlist.Add($line)
            continue
        }
    }
    $newModlist.Add($line)
}
Set-Content -Path $ModlistPath -Value $newModlist -Encoding UTF8
Write-Log "modlist.txt: $($seen.Count) JK/Ryn-related mods enabled above Uncategorized"

# --- build plugin index for installed stack mods ---
$pluginIndex = @{}
$enabledMods = $newModlist | Where-Object { $_ -match '^\+' } | ForEach-Object { $_ -replace '^\+','' } | Where-Object { $_ -notmatch '_separator$' }
foreach ($mod in $enabledMods) {
    $d = Join-Path $SkyrimMods $mod
    if (-not (Test-Path -LiteralPath $d)) { continue }
    Get-ChildItem -LiteralPath $d -Recurse -Include *.esp,*.esm,*.esl -File -EA SilentlyContinue | ForEach-Object {
        if (-not $pluginIndex.ContainsKey($_.Name)) { $pluginIndex[$_.Name] = $_.FullName }
    }
}

# present masters = game Data + all plugins in enabled mod folders
$present = @{}
Get-ChildItem 'E:\Skyrim\root\Data' -File -EA SilentlyContinue | Where-Object { $_.Extension -in '.esm','.esl','.esp' } | ForEach-Object { $present[$_.Name] = $true }
foreach ($p in $pluginIndex.Values) { $present[[IO.Path]::GetFileName($p)] = $true }

# candidate plugins = Anvil active JK/Ryn/FYX/Ivy/UME-JK set
$anvilActive = Get-Content (Join-Path $AnvilProfile 'plugins.txt') | Where-Object { $_ -match '^\*' } | ForEach-Object { $_ -replace '^\*','' }
$candidatePlugins = [System.Collections.Generic.List[string]]::new()
foreach ($pl in $anvilActive) {
    if (Test-ExcludedPlugin $pl) { continue }
    if ($pl -notmatch "JK|Ryn|FYX|Ivy|BleakFallsReCovered|Markarth Expanded - JK") { continue }
    if (-not $pluginIndex.ContainsKey($pl)) { continue }
    [void]$candidatePlugins.Add($pl)
}
foreach ($pl in $forceEnablePlugins) {
    if ($pluginIndex.ContainsKey($pl)) { [void]$candidatePlugins.Add($pl) }
}

# --- plugins.txt + loadorder.txt ---
$pluginsBefore = (Get-Content $PluginsPath | Where-Object { $_ -like '*.*' }).Count
$plugins = Get-Content $PluginsPath
$loadorder = @(Get-Content $LoadOrderPath)
$existing = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($line in $plugins) {
    $bare = $line.TrimStart('*').Trim()
    if ($bare) { [void]$existing.Add($bare) }
}

$out = [System.Collections.Generic.List[string]]::new()
$activateSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($pl in ($candidatePlugins | Select-Object -Unique)) { [void]$activateSet.Add($pl) }
foreach ($pl in $forceEnablePlugins) { [void]$activateSet.Add($pl) }

$anchor = 'Keizaal Maintenance.esp'
$loIdx = [array]::IndexOf($loadorder, $anchor)
if ($loIdx -lt 0) { $loIdx = $loadorder.Count }

$enabled = 0; $deferred = 0; $excluded = 0; $upgraded = 0
foreach ($line in $plugins) {
    $bare = $line.TrimStart('*').Trim()
    if ($bare -and $activateSet.Contains($bare) -and $line -notmatch '^\*') {
        if (Test-ExcludedPlugin $bare) { [void]$out.Add($line); continue }
        $path = $pluginIndex[$bare]
        if ($path -and (Test-MastersAvailable $path $present)) {
            [void]$out.Add("*$bare")
            $upgraded++
            $present[$bare] = $true
            continue
        }
    }
    [void]$out.Add([string]$line)
}

foreach ($pl in ($candidatePlugins | Select-Object -Unique)) {
    if (Test-ExcludedPlugin $pl) { $excluded++; continue }
    $path = $pluginIndex[$pl]
    if (-not $path) { continue }
    if (-not (Test-MastersAvailable $path $present)) {
        Write-Log "DEFER (MAST): $pl"
        $deferred++
        continue
    }
    $star = "*$pl"
    if (-not $existing.Contains($pl)) {
        $out.Add($star)
        [void]$existing.Add($pl)
        $enabled++
    }
    if ($loadorder -notcontains $pl) {
        $loadorder = @($loadorder[0..($loIdx - 1)] + $pl + $loadorder[$loIdx..($loadorder.Count - 1)])
        $loIdx++
    }
    $present[$pl] = $true
}

Set-Content -Path $PluginsPath $out -Encoding UTF8
Set-Content -Path $LoadOrderPath $loadorder -Encoding UTF8
$pluginsAfter = ($out | Where-Object { $_ -like '*.*' }).Count

Write-Log "folders: copied=$copied skipped=$skipped missing=$missing"
Write-Log "plugins active: $pluginsBefore -> $pluginsAfter (+$enabled new, $upgraded upgraded inactive, $deferred deferred, $excluded excluded-by-pattern)"
Write-Log 'task-0065 install pass complete — run full-mast-scan.ps1'
