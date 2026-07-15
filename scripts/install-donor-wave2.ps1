# task-0098: second donor wave — graphics replace (016-066) + disabled staging (068-094)
#Requires -Version 5.1
param(
    [switch]$SkipCopy,   # rename/modlist/plugins only (copy already done)
    [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'
$Root = 'D:\Skyrim AI Modlist\anvil-successor'
$SelectionJson = Join-Path $Root 'modlist\exports\donor-ae-import-selection.json'
$SkyrimMods = 'D:\Skyrim\mods'
$Profile = 'D:\Skyrim\profiles\Lost Legacy - Fork'
$ModlistPath = Join-Path $Profile 'modlist.txt'
$PluginsPath = Join-Path $Profile 'plugins.txt'
$ResultJson = Join-Path $Root 'modlist\exports\task-0098-result.json'
$LogPath = Join-Path $Root 'modlist\exports\task-0098-install.log'
$ImportScript = Join-Path $Root 'scripts\import-selected-donor-mods.ps1'

function Assert-Mo2Closed {
    if (Get-Process -Name 'ModOrganizer', 'modorganizer' -EA SilentlyContinue) {
        throw 'MO2 is running — close Mod Organizer before running this script.'
    }
}
function Write-Log([string]$msg) {
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $msg"
    try { [System.IO.File]::AppendAllText($LogPath, $line + [Environment]::NewLine, [System.Text.UTF8Encoding]::new($false)) } catch {}
    Write-Host $line
}
function Get-CleanFolderName([string]$Raw) {
    $n = $Raw.Trim()
    $n = [regex]::Replace($n, '\[NoDelete\]\s*', '', 'IgnoreCase')
    $n = [regex]::Replace($n, '^\d+\.\d+\s*\u25C9\s*', '')
    $n = [regex]::Replace($n, '^\d+\.\d+\s+', '')
    return $n.Trim()
}
function Get-PrefixInt([string]$Raw) {
    if ($Raw -match '^(\d+)\.') { return [int]$Matches[1] }
    return -1
}
function Get-PluginMasters([string]$FilePath) {
    $masters = [System.Collections.Generic.List[string]]::new()
    try {
        $b = [System.IO.File]::ReadAllBytes($FilePath)
        if ($b.Length -lt 28) { return $masters }
        $i = 24; $e = 24 + [BitConverter]::ToUInt32($b, 4); if ($e -gt $b.Length) { $e = $b.Length }
        while ($i -lt $e - 6) {
            $t = [System.Text.Encoding]::ASCII.GetString($b[$i..($i + 3)])
            $s = [BitConverter]::ToUInt16($b, $i + 4)
            if ($t -eq 'MAST' -and $s -gt 0 -and ($i + 6 + $s) -le $b.Length) {
                [void]$masters.Add([System.Text.Encoding]::ASCII.GetString($b[($i + 6)..($i + 6 + $s - 2)]))
            }
            $i += 6 + $s; if ($s -eq 0) { break }
        }
    } catch {}
    return $masters
}
function Test-VanillaMaster([string]$m) {
    return $m -match '^(Skyrim|Update|Dawnguard|HearthFires|Dragonborn)\.esm$' -or
           $m -match '^cc[a-zA-Z0-9_-]+\.(esm|esl|esp)$' -or
           $m -eq '_ResourcePack.esl'
}

Assert-Mo2Closed
if (Test-Path $LogPath) { Remove-Item $LogPath -Force }
Write-Log 'task-0098 starting'

$payload = Get-Content -LiteralPath $SelectionJson -Raw -Encoding UTF8 | ConvertFrom-Json
$folders = @($payload.folders)
if ($folders.Count -ne 907) { Write-Log "WARN: expected 907 folders, got $($folders.Count)" }

# --- Step 1: copy with overwrite ---
if (-not $SkipCopy) {
    Write-Log 'Step 1: import-selected-donor-mods.ps1 -Replace'
    if (-not $WhatIf) {
        & $ImportScript -SelectionJson $SelectionJson -Replace
        # import script ends successfully even when $LASTEXITCODE reflects robocopy's
        # bitwise success codes (0-7). Only treat real script failure as fatal.
        if (-not $?) { throw 'import script reported failure' }
    }
} else {
    Write-Log 'Step 1: SKIPPED (-SkipCopy)'
}

# --- Step 2: rename ---
Write-Log 'Step 2: rename (strip prefix / [NoDelete])'
$renamed = [System.Collections.Generic.List[object]]::new()
$renameCollisions = [System.Collections.Generic.List[string]]::new()
$missing = [System.Collections.Generic.List[string]]::new()

foreach ($raw in $folders) {
    $prefix = Get-PrefixInt $raw
    $clean = Get-CleanFolderName $raw
    $src = Join-Path $SkyrimMods $raw
    $dst = Join-Path $SkyrimMods $clean
    $isSep = $clean -match '_separator$'

    if (-not (Test-Path -LiteralPath $src)) {
        if (Test-Path -LiteralPath $dst) {
            Write-Log "ALREADY renamed: $raw -> $clean"
            [void]$renamed.Add([pscustomobject]@{ Raw = $raw; Clean = $clean; Prefix = $prefix; IsSeparator = $isSep })
            continue
        }
        Write-Log "MISSING: $raw"
        [void]$missing.Add($raw)
        continue
    }

    if ($clean -eq $raw) {
        Write-Log "NOOP rename: $raw"
    }
    elseif (Test-Path -LiteralPath $dst) {
        Write-Log "REPLACE rename: $raw -> $clean"
        if (-not $WhatIf) {
            Remove-Item -LiteralPath $dst -Recurse -Force
            Rename-Item -LiteralPath $src -NewName $clean
        }
        [void]$renameCollisions.Add("$raw -> $clean (replaced)")
    }
    else {
        Write-Log "RENAME $raw -> $clean"
        if (-not $WhatIf) { Rename-Item -LiteralPath $src -NewName $clean }
    }

    if ($isSep -and -not (Test-Path -LiteralPath $dst) -and -not $WhatIf) {
        # ensure separator folder exists after rename path edge cases
        if (-not (Test-Path -LiteralPath (Join-Path $SkyrimMods $clean))) {
            New-Item -ItemType Directory -Path (Join-Path $SkyrimMods $clean) -Force | Out-Null
        }
    }
    [void]$renamed.Add([pscustomobject]@{ Raw = $raw; Clean = $clean; Prefix = $prefix; IsSeparator = $isSep })
}

# Ensure all separator folders exist
foreach ($r in $renamed) {
    if (-not $r.IsSeparator) { continue }
    $p = Join-Path $SkyrimMods $r.Clean
    if (-not (Test-Path -LiteralPath $p) -and -not $WhatIf) {
        New-Item -ItemType Directory -Path $p -Force | Out-Null
        Write-Log "CREATE sep folder: $($r.Clean)"
    }
}

Write-Log "renamed=$($renamed.Count) missing=$($missing.Count) renameReplace=$($renameCollisions.Count)"

$gfxItems = @($renamed | Where-Object { $_.Prefix -ge 16 -and $_.Prefix -le 66 })
$stageItems = @($renamed | Where-Object { $_.Prefix -ge 68 -and $_.Prefix -le 94 })
$prefix065 = @($gfxItems | Where-Object { $_.Prefix -eq 65 -and -not $_.IsSeparator } | ForEach-Object { $_.Clean })

# --- Step 3+4: modlist ---
Write-Log 'Step 3-4: modlist surgery'
$modlist = [System.Collections.Generic.List[string]]::new()
Get-Content -LiteralPath $ModlistPath -Encoding UTF8 | ForEach-Object { [void]$modlist.Add($_) }

# Drop any existing lines for our clean names (and raw, if somehow present)
$drop = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($r in $renamed) {
    [void]$drop.Add($r.Clean)
    [void]$drop.Add($r.Raw)
}
$filtered = [System.Collections.Generic.List[string]]::new()
foreach ($line in $modlist) {
    if ($line -match '^[+-](.+)$') {
        $name = $Matches[1]
        if ($drop.Contains($name)) { continue }
    }
    [void]$filtered.Add($line)
}
$modlist = $filtered

# Find Graphics Improvements_separator and section start
$giIdx = -1
for ($i = 0; $i -lt $modlist.Count; $i++) {
    if (($modlist[$i] -replace '^[+-]', '') -eq 'Graphics Improvements_separator') { $giIdx = $i; break }
}
if ($giIdx -lt 0) { throw 'Graphics Improvements_separator not found' }
$sectionStart = 0
for ($i = 0; $i -lt $giIdx; $i++) {
    if ($modlist[$i] -match '_separator$') { $sectionStart = $i + 1 }
}

# Disable existing LL graphics section mods (+ -> -), keep separators as -
$disabledExisting = 0
for ($i = $sectionStart; $i -lt $giIdx; $i++) {
    if ($modlist[$i] -match '^\+(.+)$') {
        $name = $Matches[1]
        if ($name -match '_separator$') {
            $modlist[$i] = "-$name"
        } else {
            $modlist[$i] = "-$name"
            $disabledExisting++
        }
    }
}
Write-Log "disabled existing GI-section mods: $disabledExisting"

# Build graphics block: prefixes 16..66 ascending; within each: mods (selection order) then separator
$gfxByPrefix = @{}
foreach ($r in $gfxItems) {
    $p = $r.Prefix
    if (-not $gfxByPrefix.ContainsKey($p)) { $gfxByPrefix[$p] = [System.Collections.Generic.List[object]]::new() }
    [void]$gfxByPrefix[$p].Add($r)
}

$gfxBlock = [System.Collections.Generic.List[string]]::new()
foreach ($p in ($gfxByPrefix.Keys | Sort-Object { [int]$_ })) {
    $group = $gfxByPrefix[$p]
    # preserve selection JSON order: order of appearance in $folders
    $orderMap = @{}
    for ($fi = 0; $fi -lt $folders.Count; $fi++) { $orderMap[$folders[$fi]] = $fi }
    $sorted = @($group | Sort-Object { $orderMap[$_.Raw] })
    $sep = @($sorted | Where-Object { $_.IsSeparator }) | Select-Object -First 1
    $mods = @($sorted | Where-Object { -not $_.IsSeparator })
    foreach ($m in $mods) { [void]$gfxBlock.Add("+$($m.Clean)") }
    if ($sep) { [void]$gfxBlock.Add("-$($sep.Clean)") }
}
Write-Log "graphics block lines: $($gfxBlock.Count)"

# Rebuild modlist: before sectionStart | old section (now disabled) | gfxBlock | GI separator | after GI
# Task: new graphics goes ABOVE Graphics Improvements_separator.
# Keep disabled old mods also above GI separator (below new donor block) so old content isn't lost.
$out = [System.Collections.Generic.List[string]]::new()
for ($i = 0; $i -lt $sectionStart; $i++) { [void]$out.Add($modlist[$i]) }
foreach ($l in $gfxBlock) { [void]$out.Add($l) }
for ($i = $sectionStart; $i -lt $giIdx; $i++) { [void]$out.Add($modlist[$i]) }
[void]$out.Add('-Graphics Improvements_separator')
for ($i = $giIdx + 1; $i -lt $modlist.Count; $i++) { [void]$out.Add($modlist[$i]) }
$modlist = $out

# Staging: disabled at bottom above list-name separator
$listNameSep = 'Lost Legacy - Revenge of the Curator - 2.0.0_separator'
$stageOrder = @($stageItems | Sort-Object { $orderMap = @{}; for ($fi=0;$fi -lt $folders.Count;$fi++){ $orderMap[$folders[$fi]]=$fi }; $orderMap[$_.Raw] })
# Fix order map properly
$selOrder = @{}
for ($fi = 0; $fi -lt $folders.Count; $fi++) { $selOrder[$folders[$fi]] = $fi }
$stageSorted = @($stageItems | Sort-Object { if ($selOrder.ContainsKey($_.Raw)) { $selOrder[$_.Raw] } else { 999999 } }, Prefix, Raw)

$stageBlock = [System.Collections.Generic.List[string]]::new()
foreach ($s in $stageSorted) {
    # separators in staging: keep as disabled separator lines
    [void]$stageBlock.Add("-$($s.Clean)")
}

$final = [System.Collections.Generic.List[string]]::new()
$stageInserted = $false
foreach ($line in $modlist) {
    $bare = $line -replace '^[+-]', ''
    if ($bare -eq $listNameSep -and -not $stageInserted) {
        foreach ($l in $stageBlock) { [void]$final.Add($l) }
        $stageInserted = $true
    }
    [void]$final.Add($line)
}
if (-not $stageInserted) {
    Write-Log "WARN: list-name separator not found; appending staging at end"
    foreach ($l in $stageBlock) { [void]$final.Add($l) }
}
Write-Log "staging disabled lines: $($stageBlock.Count)"

if (-not $WhatIf) {
    Set-Content -LiteralPath $ModlistPath -Value $final -Encoding UTF8
}

# --- Step 3c: enable graphics plugins only ---
Write-Log 'Step 3c: enable graphics plugins'
$pluginsBefore = @(Get-Content $PluginsPath | Where-Object { $_ -match '^\*' }).Count
$pluginLines = [System.Collections.Generic.List[string]]::new()
Get-Content $PluginsPath -Encoding UTF8 | ForEach-Object { [void]$pluginLines.Add($_) }
$existingBare = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
$active = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($line in $pluginLines) {
    $b = $line.TrimStart('*').Trim()
    if ($b) { [void]$existingBare.Add($b) }
    if ($line -match '^\*(.+)$') { [void]$active.Add($Matches[1]) }
}
Get-ChildItem 'D:\Skyrim\root\Data' -File -EA SilentlyContinue |
    Where-Object { $_.Extension -in '.esp', '.esm', '.esl' } |
    ForEach-Object { [void]$existingBare.Add($_.Name); [void]$active.Add($_.Name) }

$newPlugins = [System.Collections.Generic.List[object]]::new()
foreach ($r in $gfxItems) {
    if ($r.IsSeparator) { continue }
    $modPath = Join-Path $SkyrimMods $r.Clean
    if (-not (Test-Path -LiteralPath $modPath)) { continue }
    Get-ChildItem -LiteralPath $modPath -File -EA SilentlyContinue |
        Where-Object { $_.Extension -in '.esp', '.esm', '.esl' -and $_.Name -notmatch '\.mohidden$' } |
        ForEach-Object { [void]$newPlugins.Add([pscustomobject]@{ Name = $_.Name; Path = $_.FullName; Mod = $r.Clean }) }
}

foreach ($p in $newPlugins) { [void]$active.Add($p.Name) }
$enabled = [System.Collections.Generic.List[string]]::new()
$mastOff = [System.Collections.Generic.List[string]]::new()
foreach ($p in $newPlugins) {
    if ($existingBare.Contains($p.Name)) {
        for ($i = 0; $i -lt $pluginLines.Count; $i++) {
            if ($pluginLines[$i] -eq $p.Name) {
                $pluginLines[$i] = "*$($p.Name)"
                [void]$enabled.Add($p.Name)
            }
        }
        continue
    }
    $missingM = @(Get-PluginMasters $p.Path | Where-Object { -not (Test-VanillaMaster $_) -and -not $active.Contains($_) })
    if ($missingM.Count -gt 0) {
        [void]$pluginLines.Add($p.Name)
        [void]$existingBare.Add($p.Name)
        [void]$mastOff.Add("$($p.Name) -> $($missingM -join ', ')")
        [void]$active.Remove($p.Name)
    } else {
        [void]$pluginLines.Add("*$($p.Name)")
        [void]$existingBare.Add($p.Name)
        [void]$enabled.Add($p.Name)
    }
}

# Pass 2: demote if masters inactive
$finalPl = [System.Collections.Generic.List[string]]::new()
$activeNow = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($line in $pluginLines) { if ($line -match '^\*(.+)$') { [void]$activeNow.Add($Matches[1]) } }
foreach ($line in $pluginLines) {
    if ($line -notmatch '^\*(.+)$') { [void]$finalPl.Add($line); continue }
    $bare = $Matches[1]
    $pinfo = $newPlugins | Where-Object { $_.Name -eq $bare } | Select-Object -First 1
    if (-not $pinfo) { [void]$finalPl.Add($line); continue }
    $missingActive = @(Get-PluginMasters $pinfo.Path | Where-Object {
        -not (Test-VanillaMaster $_) -and -not $activeNow.Contains($_)
    })
    if ($missingActive.Count -gt 0) {
        [void]$finalPl.Add($bare)
        if (-not ($mastOff | Where-Object { $_ -like "$bare ->*" })) {
            [void]$mastOff.Add("$bare -> $($missingActive -join ', ')")
        }
        [void]$activeNow.Remove($bare)
    } else {
        [void]$finalPl.Add($line)
    }
}

if (-not $WhatIf) {
    Set-Content -LiteralPath $PluginsPath -Value $finalPl -Encoding UTF8
}
$pluginsAfter = @($finalPl | Where-Object { $_ -match '^\*' }).Count
Write-Log "plugins: before=$pluginsBefore after=$pluginsAfter enabled=$($enabled.Count) mast_off=$($mastOff.Count)"

$result = [ordered]@{
    taskId              = 'task-0098'
    selected            = $folders.Count
    renamed             = $renamed.Count
    missing             = @($missing)
    renameReplaced      = @($renameCollisions)
    graphicsCount       = $gfxItems.Count
    stagingCount        = $stageItems.Count
    disabledExistingGI  = $disabledExisting
    graphicsBlockLines  = $gfxBlock.Count
    stagingBlockLines   = $stageBlock.Count
    pluginsBefore       = $pluginsBefore
    pluginsAfter        = $pluginsAfter
    pluginsEnabledCount = @($enabled | Select-Object -Unique).Count
    pluginsMastOff      = @($mastOff)
    prefix065_ENB_ParticleLights_review = @($prefix065)
    audio068_staging    = @($stageItems | Where-Object { $_.Prefix -eq 68 } | ForEach-Object { $_.Clean })
}
$result | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $ResultJson -Encoding UTF8
Write-Log "task-0098 complete - $ResultJson"
