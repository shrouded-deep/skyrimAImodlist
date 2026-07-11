# task-0051: City expansion stack for Keizaal - Fork (from Anvil install)
#Requires -Version 5.1
$ErrorActionPreference = 'Stop'

$AnvilMods  = 'D:\Skyrim AI Modlist\Anvil\mods'
$SkyrimMods = 'E:\Skyrim\mods'
$Profile    = 'E:\Skyrim\profiles\Keizaal - Fork'
$ModlistPath = Join-Path $Profile 'modlist.txt'
$PluginsPath = Join-Path $Profile 'plugins.txt'
$LoadOrderPath = Join-Path $Profile 'loadorder.txt'
$LogPath = 'D:\Skyrim AI Modlist\anvil-successor\modlist\exports\install-city-stack-run.log'

function Write-Log($msg) {
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $msg"
    Add-Content -Path $LogPath -Value $line
    Write-Host $line
}
if (Test-Path $LogPath) { Remove-Item $LogPath -Force }
Write-Log 'task-0051 city stack install starting'

$cityModFolders = @(
    'Capital Whiterun Expansion',
    'Capital Windhelm Expansion',
    'Ultimate Markarth',
    'Ultimate Markarth Expanded',
    "RedBag's Solitude",
    'City of Crossed Daggers - Riften Expansion',
    'Riverwood Has Charm and Walls',
    "Rob's Bug Fixes - Capital Whiterun",
    'CWE Spaghetti Patch',
    "Spaghetti's Capital Windhelm Expansion",
    'RedBag Patch Collection',
    'Riverwood Has Walls Patch Collection',
    'UME Patch Hub',
    'Crossed Daggers - Spaghetti Patch',
    "Spaghetti's Cities - Whiterun",
    "Spaghetti's Cities - Windhelm",
    "Spaghetti's Cities - Markarth",
    "Spaghetti's Cities - Solitude",
    "Spaghetti's Cities - Riften",
    "Spaghetti's Towns - Riverwood"
)

foreach ($folder in $cityModFolders) {
    $src = Join-Path $AnvilMods $folder
    $dst = Join-Path $SkyrimMods $folder
    if (-not (Test-Path -LiteralPath $src)) { Write-Log "WARN missing on Anvil: $folder"; continue }
    if (Test-Path -LiteralPath $dst) { Write-Log "SKIP exists: $folder"; continue }
    Write-Log "COPY $folder"
    robocopy $src $dst /E /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "robocopy failed $folder" }
}

# Ensure Spaghetti AIO not enabled (copy optional for reference but disable)
if (Test-Path (Join-Path $SkyrimMods "Spaghetti's Cities - AIO")) {
    Write-Log 'NOTE Spaghetti AIO folder present — keeping disabled in modlist'
}

$cityPlugins = @(
    'SurWR.esp',
    'WindhelmSSE.esp',
    'Ultimate Markarth.esp',
    'Ultimate Markarth Expanded.esp',
    "Markarth Expanded - Spaghetti's Markarth.esp",
    "RedBag's Solitude.esp",
    "USSEP Patch for RedBag's Solitude.esp",
    'Riften Expansion.esp',
    'Riften Expansion - Spaghetti Cities Riften Patch.esp',
    'Riverwood Has Charm.esp',
    'Riverwood Has Walls.esp',
    'Riverwood Has Charm + Walls.esp',
    "Riverwood Has Charm - Spaghetti's Riverwood Patch.esp",
    "Spaghetti's Cities - Whiterun.esp",
    "Spaghetti's Cities - Windhelm.esp",
    "Spaghetti's Capital Windhelm Expansion - Individual.esp",
    "Spaghetti's Cities - Markarth.esp",
    "Spaghetti's Cities - Solitude.esp",
    "Spaghetti's Cities - Riften.esp",
    "Spaghetti's Towns - Riverwood.esp",
    'Captial Whiterun and Spaghetti AIO Patch.esp'
)

$pluginsBefore = (Get-Content $PluginsPath | Where-Object { $_ -like '*.*' }).Count

# modlist
$modlist = Get-Content $ModlistPath
$enableSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($m in $cityModFolders) { [void]$enableSet.Add($m) }
[void]$enableSet.Add("Spaghetti's Cities - AIO")

$newModlist = New-Object System.Collections.Generic.List[string]
$seen = @{}
foreach ($line in $modlist) {
    if ($line -match '^[+-](.+)$') {
        $name = $Matches[1].Trim()
        if ($name -eq "Spaghetti's Cities - AIO") { $newModlist.Add("-$name"); $seen[$name]=$true; continue }
        if ($enableSet.Contains($name)) {
            if (-not $seen.ContainsKey($name)) { $newModlist.Add("+$name"); $seen[$name]=$true }
            continue
        }
    }
    $newModlist.Add($line)
}
if (-not ($newModlist -match '\[Keizaal Additions\]')) { $newModlist.Add('[Keizaal Additions]_separator') }
foreach ($name in $cityModFolders) {
    if (-not $seen.ContainsKey($name) -and (Test-Path -LiteralPath (Join-Path $SkyrimMods $name))) {
        $newModlist.Add("+$name"); $seen[$name]=$true
    }
}
Set-Content $ModlistPath $newModlist -Encoding UTF8

# plugins — append new active only
$plugins = Get-Content $PluginsPath
$existing = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($line in $plugins) {
    $bare = $line.TrimStart('*').Trim()
    if ($bare) { [void]$existing.Add($bare) }
}
$out = [System.Collections.Generic.List[string]]::new()
foreach ($line in $plugins) { [void]$out.Add([string]$line) }
foreach ($esp in $cityPlugins) {
    if (-not $existing.Contains($esp)) { $out.Add("*$esp"); [void]$existing.Add($esp) }
}
Set-Content $PluginsPath $out -Encoding UTF8
$pluginsAfter = ($out | Where-Object { $_ -like '*.*' }).Count

# loadorder — append city block before Keizaal Maintenance
$lo = Get-Content $LoadOrderPath
$anchor = 'Keizaal Maintenance.esp'
$idx = [array]::IndexOf($lo, $anchor)
if ($idx -lt 0) { $idx = $lo.Count }
$toInsert = $cityPlugins | Where-Object { $_ -notin $lo }
$newLo = if ($idx -ge 0) { $lo[0..($idx-1)] + $toInsert + $lo[$idx..($lo.Count-1)] } else { $lo + $toInsert }
Set-Content $LoadOrderPath $newLo -Encoding UTF8

Write-Log "plugins active: $pluginsBefore -> $pluginsAfter (+$($pluginsAfter-$pluginsBefore))"
Write-Log "city plugins inserted before $anchor : $($toInsert.Count)"
Write-Log 'NOTE: Keizaal has no Lux — Lux Patch Hub FOMOD step N/A; no Lux/Orbis/Via patches enabled'
Write-Log 'task-0051 complete — MO2 F5 + MAST check required'
