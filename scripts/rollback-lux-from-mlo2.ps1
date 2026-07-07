# task-0030: Roll back MLO2/WSU lighting migration — restore Lux suite.
#   powershell -ExecutionPolicy Bypass -File scripts/rollback-lux-from-mlo2.ps1

$ErrorActionPreference = 'Stop'
. "$PSScriptRoot/Mo2ProfileGuardrails.ps1"

$repoRoot = Split-Path $PSScriptRoot -Parent
$snapDir = Join-Path $repoRoot 'modlist\exports\mlo2-pre-migration-2026-07-07'
$profileDir = Join-Path $script:AnvilRoot "profiles\$script:AnvilProfile"
$pluginsPath = Join-Path $profileDir 'plugins.txt'
$loadorderPath = Join-Path $profileDir 'loadorder.txt'
$csLightDir = Join-Path $script:AnvilMods 'CS Light\LightPlacer\CS Light'
$luxDisabledDir = Join-Path $csLightDir '_disabled_lux_mlo2_migration'
$vanillaDisabledDir = Join-Path $csLightDir '_disabled_vanilla_mlo2_migration'

function Get-PluginBaseName {
    param([string]$Line)
    if ($Line -match '^\*?(.+\.(esp|esm|esl))$') { return $Matches[1] }
    return $null
}

function Read-ProfilePluginNames {
    param([string]$Path)
    Get-Content -LiteralPath $Path |
        Where-Object { $_ -notmatch '^#' -and $_.Trim() -ne '' } |
        ForEach-Object { Get-PluginBaseName $_ } |
        Where-Object { $_ }
}

function Read-ActivePluginNames {
    param([string]$Path)
    Get-Content -LiteralPath $Path |
        Where-Object { $_ -match '^\*' } |
        ForEach-Object { Get-PluginBaseName $_ } |
        Where-Object { $_ }
}

function Set-PluginEnabled {
    param(
        [ref]$Lines,
        [Parameter(Mandatory)][string]$Name,
        [bool]$Enabled = $true
    )
    for ($i = 0; $i -lt $Lines.Value.Count; $i++) {
        $base = Get-PluginBaseName $Lines.Value[$i]
        if ($base -eq $Name) {
            if ($Enabled) {
                if ($Lines.Value[$i] -notmatch '^\*') { $Lines.Value[$i] = "*$Name" }
            }
            else {
                $Lines.Value[$i] = $Name
            }
            return $true
        }
    }
    if ($Enabled) {
        $Lines.Value += "*$Name"
        return $true
    }
    return $false
}

function Remove-PluginLine {
    param(
        [ref]$Lines,
        [Parameter(Mandatory)][string]$Name
    )
    $Lines.Value = @($Lines.Value | Where-Object {
            $base = Get-PluginBaseName $_
            $base -ne $Name
        })
}

$mlo2PluginPatterns = @(
    '^DIAL\.esp$',
    '^DIAL_NAT\.esp$',
    '^True Light - Shadows and Ambient\.esp$',
    '^Window Shadows Ultimate\.esp$',
    '^Window Shadows Ultimate Supplement\.esp$',
    '^TL Bulbs ISL\.esp$',
    '^WSU - '
)

function Test-Mlo2StackPlugin {
    param([string]$Name)
    foreach ($pat in $mlo2PluginPatterns) {
        if ($Name -match $pat) { return $true }
    }
    return $false
}

Write-Host '=== task-0030 Lux rollback ==='

Assert-Mo2Closed
Write-Host '[preflight] MO2 is not running.'

# --- modlist.txt ---
$modlistLines = @(Get-Content -LiteralPath $script:AnvilModlist)
$enableMods = @(
    'Actually Brighter Lux Templates',
    'Lux - Patch Hub',
    'Lux',
    'Lux Orbis - Patch Hub',
    'Lux Orbis'
)
$disableMods = @(
    'Modern Lighting Overhaul 2',
    'True Light',
    'Placed Light',
    'Dust by FrankBlack aka Dust not Clouds',
    'Dynamic Interior Ambient Lighting',
    'Window Shadows Ultimate',
    'Window Shadows Ultimate - Patch Hub'
)

for ($i = 0; $i -lt $modlistLines.Count; $i++) {
    if ($modlistLines[$i] -match '^[\+\-](.+)$') {
        $name = $Matches[1]
        if ($name -in $enableMods) { $modlistLines[$i] = "+$name" }
        elseif ($name -in $disableMods) { $modlistLines[$i] = "-$name" }
    }
}

$modlistLines | Set-Content -LiteralPath $script:AnvilModlist
Write-Host '[ok] modlist.txt: Lux suite enabled, MLO2/WSU stack disabled.'

# --- CS Light JSON swap ---
New-Item -ItemType Directory -Path $vanillaDisabledDir -Force | Out-Null
$vanillaJsons = @(
    'CS Light - Candles.json',
    'CS Light - Chandeliers.json',
    'CS Light - Fires.json',
    'CS Light - Lanterns.json',
    'CS Light - Nordic Halls.json',
    'CS Light - Torches.json'
)
foreach ($vj in $vanillaJsons) {
    $src = Join-Path $csLightDir $vj
    if (Test-Path -LiteralPath $src) {
        Move-Item -LiteralPath $src -Destination (Join-Path $vanillaDisabledDir $vj) -Force
    }
}
$luxJsons = @(Get-ChildItem -LiteralPath $luxDisabledDir -Filter 'Lux CS Light - *.json' -File -ErrorAction SilentlyContinue)
foreach ($lj in $luxJsons) {
    Move-Item -LiteralPath $lj.FullName -Destination (Join-Path $csLightDir $lj.Name) -Force
}
Write-Host "[ok] CS Light: restored $($luxJsons.Count) Lux JSON(s); archived vanilla core set."

# --- plugins.txt / loadorder.txt ---
$snapLoad = @(Get-Content (Join-Path $snapDir 'loadorder.txt') | Where-Object { $_ -notmatch '^#' -and $_.Trim() -ne '' })
$snapActive = Read-ActivePluginNames (Join-Path $snapDir 'plugins.txt')

$luxFromSnap = @($snapActive | Where-Object { $_ -match 'Lux|Actually Brighter' })
$mlo2FromCur = @(Read-ProfilePluginNames $pluginsPath | Where-Object { Test-Mlo2StackPlugin $_ })

$pluginLines = @(Get-Content -LiteralPath $pluginsPath)
foreach ($rm in $mlo2FromCur) { Remove-PluginLine -Lines ([ref]$pluginLines) -Name $rm }
foreach ($add in $luxFromSnap) {
    $found = $false
    foreach ($line in $pluginLines) {
        if ((Get-PluginBaseName $line) -eq $add) { $found = $true; break }
    }
    if (-not $found) { $pluginLines += "*$add" }
    [void](Set-PluginEnabled -Lines ([ref]$pluginLines) -Name $add -Enabled $true)
}

# Ensure DynDOLOD / Occlusion / frozen Lux outputs enabled
$mustEnable = @(
    'DynDOLOD.esp',
    'Occlusion.esp',
    'Actually Brighter Lux Templates.esp',
    'ANV_Lux Orbis - SB Windhelm Entrance.esp',
    'ANV_Lux - W4ENB - No Grass in Caves.esp',
    'ANV_Lux - Volkihar Soundscape Overhaul - W4ENB.esp'
)
foreach ($p in $mustEnable) {
    if (-not (Set-PluginEnabled -Lines ([ref]$pluginLines) -Name $p -Enabled $true)) {
        $pluginLines += "*$p"
    }
    else {
        [void](Set-PluginEnabled -Lines ([ref]$pluginLines) -Name $p -Enabled $true)
    }
}

$pluginLines | Set-Content -LiteralPath $pluginsPath
Write-Host '[ok] plugins.txt updated.'

# loadorder: remove MLO2, merge Lux ordering from snapshot
$curLoad = @(Get-Content -LiteralPath $loadorderPath | Where-Object { $_ -notmatch '^#' -and $_.Trim() -ne '' })
$curLoad = @($curLoad | Where-Object { -not (Test-Mlo2StackPlugin $_) })

$activeSet = @{}
foreach ($p in (Read-ActivePluginNames $pluginsPath)) { $activeSet[$p.ToLowerInvariant()] = $p }

# Plugins in snapshot order that should appear in LO (active + game masters already in curLoad)
$luxBlock = @($snapLoad | Where-Object { $_ -match 'Lux|Actually Brighter' })
$tailFromSnap = @('ParallaxGen.esp', 'PG_1.esp', 'ANV_SynHPHRaceMenuPatcher.esp', 'ANV_SynNPCPatcher.esp',
    'ANV_SynW4ENBPatcher.esp', 'ANV_SynWorldPatcher.esp', 'DynDOLOD.esp', 'Occlusion.esp')

$ordered = [System.Collections.Generic.List[string]]::new()
$seen = @{}

foreach ($p in $curLoad) {
    if ($p -match 'Lux|Actually Brighter') { continue }
    if ($p -in $tailFromSnap) { continue }
    if (-not $seen.ContainsKey($p.ToLowerInvariant())) {
        [void]$ordered.Add($p)
        $seen[$p.ToLowerInvariant()] = $true
    }
}

# Insert Lux block at snapshot-relative anchor: after bingus hates spiders.esp
$insertAfter = 'bingus hates spiders.esp'
$arr = $ordered.ToArray()
$idx = [array]::IndexOf($arr, $insertAfter)
$newOrdered = [System.Collections.Generic.List[string]]::new()
if ($idx -lt 0) {
    [void]$newOrdered.AddRange($arr)
}
else {
    for ($j = 0; $j -le $idx; $j++) { [void]$newOrdered.Add($arr[$j]) }
    foreach ($lp in $luxBlock) {
        if ($activeSet.ContainsKey($lp.ToLowerInvariant()) -and -not $seen.ContainsKey($lp.ToLowerInvariant())) {
            [void]$newOrdered.Add($activeSet[$lp.ToLowerInvariant()])
            $seen[$lp.ToLowerInvariant()] = $true
        }
    }
    for ($j = $idx + 1; $j -lt $arr.Length; $j++) { [void]$newOrdered.Add($arr[$j]) }
}
$ordered = $newOrdered

# Re-append tail plugins in snapshot order
foreach ($tp in $tailFromSnap) {
    if ($activeSet.ContainsKey($tp.ToLowerInvariant()) -and -not $seen.ContainsKey($tp.ToLowerInvariant())) {
        [void]$ordered.Add($activeSet[$tp.ToLowerInvariant()])
        $seen[$tp.ToLowerInvariant()] = $true
    }
}

# Any remaining active plugins not yet in LO
foreach ($p in $activeSet.Values) {
    if (-not $seen.ContainsKey($p.ToLowerInvariant())) {
        [void]$ordered.Add($p)
        $seen[$p.ToLowerInvariant()] = $true
    }
}

@('# This file was automatically generated by Mod Organizer.') + $ordered | Set-Content -LiteralPath $loadorderPath
Write-Host '[ok] loadorder.txt updated (basic merge; running snapshot fix next).'

& (Join-Path $PSScriptRoot 'fix-loadorder-post-0030.ps1')

# --- Missing masters scan ---
function Get-PluginMasters {
    param([string]$FilePath)
    $bytes = [System.IO.File]::ReadAllBytes($FilePath)
    $masters = [System.Collections.Generic.List[string]]::new()
    $i = 0
    while ($i -lt ($bytes.Length - 4)) {
        if ($bytes[$i] -eq 77 -and $bytes[$i + 1] -eq 65 -and $bytes[$i + 2] -eq 83 -and $bytes[$i + 3] -eq 84) {
            $i += 4
            if ($i + 2 -gt $bytes.Length) { break }
            $len = $bytes[$i] + ($bytes[$i + 1] -shl 8)
            $i += 2
            if ($len -gt 0 -and ($i + $len) -le $bytes.Length) {
                $name = [System.Text.Encoding]::ASCII.GetString($bytes, $i, $len)
                [void]$masters.Add($name)
            }
            $i += $len
            continue
        }
        $i++
    }
    return $masters
}

$pluginIndex = @{}
Get-ChildItem -LiteralPath $script:AnvilMods -Recurse -Include *.esp, *.esm, *.esl -File -ErrorAction SilentlyContinue |
    ForEach-Object {
        $key = $_.Name.ToLowerInvariant()
        if (-not $pluginIndex.ContainsKey($key)) { $pluginIndex[$key] = $_.FullName }
    }

$gameMasters = @(
    'skyrim.esm', 'update.esm', 'dawnguard.esm', 'hearthfires.esm', 'dragonborn.esm',
    'ccbgssse001-fish.esm', 'ccqdrsse001-survivalmode.esl', 'ccbgssse037-curios.esl',
    'ccbgssse025-advdsgs.esm', '_resourcepack.esl'
)

$active = Read-ActivePluginNames $pluginsPath
$available = @{}
foreach ($k in $pluginIndex.Keys) { $available[$k] = $true }
foreach ($p in $active) { $available[$p.ToLowerInvariant()] = $true }
foreach ($g in $gameMasters) { $available[$g] = $true }

$missing = @()
foreach ($p in $active) {
    $path = $pluginIndex[$p.ToLowerInvariant()]
    if (-not $path) {
        $missing += [pscustomobject]@{ Plugin = $p; Master = '(plugin file not found on disk)'; Path = '' }
        continue
    }
    foreach ($m in (Get-PluginMasters $path)) {
        if (-not $available.ContainsKey($m.ToLowerInvariant())) {
            $missing += [pscustomobject]@{ Plugin = $p; Master = $m; Path = $path }
        }
    }
}

Write-Host ''
Write-Host "Active plugins: $($active.Count)"
Write-Host "Missing master refs: $($missing.Count)"
if ($missing.Count -gt 0) {
    $missing | Sort-Object Plugin, Master | Format-Table -AutoSize | Out-String | Write-Host
    exit 2
}

Write-Host 'Missing masters: 0'
exit 0
