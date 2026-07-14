# Install a batch of donor AE mods into Lost Legacy Fork: rename, modlist, plugins.
#Requires -Version 5.1
param(
    [Parameter(Mandatory)][string]$TaskId,
    [Parameter(Mandatory)][string[]]$Prefixes,          # e.g. '005.','006.'
    [Parameter(Mandatory)][string]$SeparatorName,       # without _separator suffix OR with - full name before _separator
    [string]$InsertMode = 'above-separator',            # above-separator | create-below-anchor
    [string]$AnchorSeparator = '',                      # for create-below-anchor: new section goes AFTER this sep
    [string[]]$PrefixPriority = @(),                    # legacy: all groups piled just above separator (highest first)
    [string[]]$PrefixTop = @(),                         # e.g. '016' — insert at TOP of existing section
    [string[]]$PrefixMiddle = @(),                      # e.g. '017','018' — after top, before existing section body
    [string[]]$PrefixBottom = @(),                      # e.g. '004' — just above separator (lowest in section)
    [switch]$FixSeparatorPlusToMinus
)

$ErrorActionPreference = 'Stop'

function Assert-Mo2Closed {
    $procs = Get-Process -Name 'ModOrganizer', 'modorganizer' -ErrorAction SilentlyContinue
    if ($procs) { throw 'MO2 is running — close Mod Organizer before running this script.' }
}

function Write-Log($msg) {
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $msg"
    try {
        [System.IO.File]::AppendAllText($script:LogPath, $line + [Environment]::NewLine, [System.Text.UTF8Encoding]::new($false))
    } catch { }
    Write-Host $line
}

function Get-CleanFolderName([string]$Raw) {
    $n = $Raw.Trim()
    $n = [regex]::Replace($n, '\[NoDelete\]\s*', '', 'IgnoreCase')
    $n = [regex]::Replace($n, '^\d+\.\d+\s*\u25C9\s*', '')
    $n = [regex]::Replace($n, '^\d+\.\d+\s+', '')
    return $n.Trim()
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
    } catch { }
    return $masters
}

function Test-VanillaMaster([string]$m) {
    return $m -match '^(Skyrim|Update|Dawnguard|HearthFires|Dragonborn)\.esm$' -or
           $m -match '^cc[a-zA-Z0-9_-]+\.(esm|esl|esp)$' -or
           $m -eq '_ResourcePack.esl'
}

Assert-Mo2Closed

$SkyrimMods    = 'D:\Skyrim\mods'
$Profile       = 'D:\Skyrim\profiles\Lost Legacy - Fork'
$ModlistPath   = Join-Path $Profile 'modlist.txt'
$PluginsPath   = Join-Path $Profile 'plugins.txt'
$SelectionJson = 'D:\Skyrim AI Modlist\anvil-successor\modlist\exports\donor-ae-import-selection.json'
$ResultJson    = "D:\Skyrim AI Modlist\anvil-successor\modlist\exports\$TaskId-result.json"
$LogPath       = "D:\Skyrim AI Modlist\anvil-successor\modlist\exports\$TaskId-install.log"

if (Test-Path $LogPath) { Remove-Item $LogPath -Force }
Write-Log "$TaskId starting"

$sepLine = if ($SeparatorName -match '_separator$') { $SeparatorName } else { "${SeparatorName}_separator" }
$sepFolder = Join-Path $SkyrimMods $sepLine

$payload = Get-Content -LiteralPath $SelectionJson -Raw -Encoding UTF8 | ConvertFrom-Json
$selected = @()
foreach ($f in $payload.folders) {
    foreach ($p in $Prefixes) {
        if ($f.StartsWith($p)) { $selected += $f; break }
    }
}
$selected = $selected | Sort-Object
Write-Log "matched $($selected.Count) selection entries for prefixes: $($Prefixes -join ', ')"

$renamed = [System.Collections.Generic.List[object]]::new()
$fomods = [System.Collections.Generic.List[string]]::new()
$collisions = [System.Collections.Generic.List[string]]::new()
$missingSrc = [System.Collections.Generic.List[string]]::new()

foreach ($raw in $selected) {
    $src = Join-Path $SkyrimMods $raw
    if (-not (Test-Path -LiteralPath $src)) {
        # already renamed?
        $already = Get-CleanFolderName $raw
        if (Test-Path -LiteralPath (Join-Path $SkyrimMods $already)) {
            Write-Log "ALREADY renamed: $raw -> $already"
            [void]$renamed.Add([pscustomobject]@{ Raw = $raw; Clean = $already; Prefix = if ($raw -match '^(\d+\.\d+)') { $Matches[1] } else { '' } })
            if (Test-Path -LiteralPath (Join-Path $SkyrimMods "$already\fomod\ModuleConfig.xml")) {
                [void]$fomods.Add($already)
            } elseif (Test-Path -LiteralPath (Join-Path $SkyrimMods "$already\Fomod\ModuleConfig.xml")) {
                [void]$fomods.Add($already)
            }
            continue
        }
        Write-Log "MISSING: $raw"
        [void]$missingSrc.Add($raw)
        continue
    }
    $clean = Get-CleanFolderName $raw
    $dst = Join-Path $SkyrimMods $clean
    if ($clean -eq $raw) {
        Write-Log "NOOP rename: $raw"
    }
    elseif (Test-Path -LiteralPath $dst) {
        Write-Log "COLLISION (kept donor name): $raw -> $clean exists"
        [void]$collisions.Add("$raw -> $clean")
        $clean = $raw  # keep as-is to not lose content
        $dst = $src
    }
    else {
        Rename-Item -LiteralPath $src -NewName $clean
        Write-Log "RENAME $raw -> $clean"
    }
    [void]$renamed.Add([pscustomobject]@{
        Raw = $raw
        Clean = $clean
        Prefix = if ($raw -match '^(\d+\.\d+)') { $Matches[1] } else { '' }
    })
    if ((Test-Path -LiteralPath (Join-Path $dst 'fomod\ModuleConfig.xml')) -or
        (Test-Path -LiteralPath (Join-Path $dst 'Fomod\ModuleConfig.xml'))) {
        [void]$fomods.Add($clean)
        Write-Log "FOMOD: $clean"
    }
}

# Ensure separator folder
if (-not (Test-Path -LiteralPath $sepFolder)) {
    New-Item -ItemType Directory -Path $sepFolder -Force | Out-Null
    Write-Log "CREATE sep folder: $sepLine"
}

# Modlist
$modlist = [System.Collections.Generic.List[string]]::new()
Get-Content -LiteralPath $ModlistPath -Encoding UTF8 | ForEach-Object { [void]$modlist.Add($_) }

if ($FixSeparatorPlusToMinus) {
    for ($i = 0; $i -lt $modlist.Count; $i++) {
        if ($modlist[$i] -eq "+$sepLine") {
            $modlist[$i] = "-$sepLine"
            Write-Log "FIX separator + -> -: $sepLine"
        }
    }
}

# Remove clean + raw names, and any leftover MO2-discovered prefixed lines for this batch
$dropNames = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($r in $renamed) {
    [void]$dropNames.Add($r.Clean)
    [void]$dropNames.Add($r.Raw)
}
$prefixNeedle = @(
    foreach ($p in $Prefixes) {
        if ($p -match '^(\d+)\.') { $Matches[1] }
        elseif ($p -match '^(\d+)$') { $Matches[1] }
        else { $null }
    }
) | Where-Object { $_ } | Select-Object -Unique
$filtered = [System.Collections.Generic.List[string]]::new()
$droppedStale = 0
foreach ($line in $modlist) {
    if ($line -match '^[+-](.+)$') {
        $name = $Matches[1]
        if ($name.EndsWith('_separator')) { [void]$filtered.Add($line); continue }
        if ($dropNames.Contains($name)) { $droppedStale++; continue }
        $stalePrefix = $false
        foreach ($pn in $prefixNeedle) {
            if ($name -match ("^" + [regex]::Escape($pn) + "\.\d+")) { $stalePrefix = $true; break }
        }
        if ($stalePrefix) { $droppedStale++; continue }
    }
    [void]$filtered.Add($line)
}
$modlist = $filtered
if ($droppedStale -gt 0) { Write-Log "Dropped $droppedStale stale/duplicate modlist lines" }

function New-ModLines([object[]]$Items) {
    $lines = [System.Collections.Generic.List[string]]::new()
    foreach ($r in ($Items | Sort-Object { $_.Raw })) {
        [void]$lines.Add("+$($r.Clean)")
    }
    return $lines
}

function Get-PrefixGroupMap([object[]]$Items) {
    $groups = @{}
    foreach ($r in $Items) {
        $g = if ($r.Prefix -match '^(\d+)\.') { $Matches[1] } else { 'zzz' }
        if (-not $groups.ContainsKey($g)) { $groups[$g] = [System.Collections.Generic.List[object]]::new() }
        [void]$groups[$g].Add($r)
    }
    return $groups
}

function Add-GroupLines($OutList, $Groups, [string[]]$Keys) {
    foreach ($pg in $Keys) {
        if ($Groups.ContainsKey($pg)) {
            foreach ($l in (New-ModLines $Groups[$pg])) { [void]$OutList.Add($l) }
            $Groups.Remove($pg)
        }
    }
}

$out = [System.Collections.Generic.List[string]]::new()
$inserted = $false
$useTiered = ($PrefixTop.Count + $PrefixMiddle.Count + $PrefixBottom.Count) -gt 0

if ($InsertMode -eq 'create-below-anchor') {
    # Insert new section immediately ABOVE the anchor separator line (higher UI priority
    # than the anchor's owned mods). Used for AI / Combat / oStim create tasks.
    if (-not $AnchorSeparator) { throw 'AnchorSeparator required for create-below-anchor' }
    $anchor = if ($AnchorSeparator -match '_separator$') { $AnchorSeparator } else { "${AnchorSeparator}_separator" }
    foreach ($line in $modlist) {
        $bare = $line -replace '^[+-]', ''
        if ($bare -eq $sepLine) { continue }
        if ($bare -eq $anchor -and -not $inserted) {
            foreach ($l in (New-ModLines $renamed)) { [void]$out.Add($l) }
            [void]$out.Add("-$sepLine")
            $inserted = $true
        }
        [void]$out.Add($line)
    }
    if (-not $inserted) { throw "Anchor separator not found: $anchor" }
}
elseif ($useTiered) {
    # Graphics Improvements style: top of section / middle / just-above-separator
    $groups = Get-PrefixGroupMap $renamed
    # Find index of target separator and start of its owned block (after previous sep)
    $sepIdx = -1
    for ($i = 0; $i -lt $modlist.Count; $i++) {
        if (($modlist[$i] -replace '^[+-]', '') -eq $sepLine) { $sepIdx = $i; break }
    }
    if ($sepIdx -lt 0) { throw "Separator not found in modlist: $sepLine" }
    $sectionStart = 0
    for ($i = 0; $i -lt $sepIdx; $i++) {
        if ($modlist[$i] -match '_separator$') { $sectionStart = $i + 1 }
    }
    for ($i = 0; $i -lt $modlist.Count; $i++) {
        if ($i -eq $sectionStart -and -not $inserted) {
            Add-GroupLines $out $groups $PrefixTop
            Add-GroupLines $out $groups $PrefixMiddle
        }
        if ($i -eq $sepIdx -and -not $inserted) {
            Add-GroupLines $out $groups $PrefixBottom
            # leftovers (unlisted prefixes) go with bottom
            foreach ($k in @($groups.Keys | Sort-Object)) {
                foreach ($l in (New-ModLines $groups[$k])) { [void]$out.Add($l) }
            }
            $line = $modlist[$i]
            if ($line -match '^[+-]') { [void]$out.Add("-$sepLine") } else { [void]$out.Add("-$sepLine") }
            $inserted = $true
            continue
        }
        if ($i -ge $sectionStart -and $i -lt $sepIdx) {
            [void]$out.Add($modlist[$i])
            continue
        }
        if ($i -lt $sectionStart -or $i -gt $sepIdx) {
            [void]$out.Add($modlist[$i])
        }
    }
    if (-not $inserted) { throw "Tiered insert failed for: $sepLine" }
}
elseif ($PrefixPriority.Count -gt 0) {
    $groups = Get-PrefixGroupMap $renamed
    foreach ($line in $modlist) {
        $bare = $line -replace '^[+-]', ''
        if ($bare -eq $sepLine -and -not $inserted) {
            Add-GroupLines $out $groups $PrefixPriority
            foreach ($k in @($groups.Keys | Sort-Object)) {
                foreach ($l in (New-ModLines $groups[$k])) { [void]$out.Add($l) }
            }
            [void]$out.Add("-$sepLine")
            $inserted = $true
            continue
        }
        [void]$out.Add($line)
    }
    if (-not $inserted) { throw "Separator not found in modlist: $sepLine" }
}
else {
    foreach ($line in $modlist) {
        $bare = $line -replace '^[+-]', ''
        if ($bare -eq $sepLine -and -not $inserted) {
            foreach ($l in (New-ModLines $renamed)) { [void]$out.Add($l) }
            [void]$out.Add("-$sepLine")
            $inserted = $true
            continue
        }
        [void]$out.Add($line)
    }
    if (-not $inserted) { throw "Separator not found in modlist: $sepLine" }
}

Set-Content -LiteralPath $ModlistPath -Value $out -Encoding UTF8
Write-Log "modlist: inserted $($renamed.Count) mods above -$sepLine"

# Plugins
$pluginsBefore = @(Get-Content $PluginsPath | Where-Object { $_ -match '^\*' }).Count
$pluginLines = [System.Collections.Generic.List[string]]::new()
Get-Content $PluginsPath -Encoding UTF8 | ForEach-Object { [void]$pluginLines.Add($_) }

$existingBare = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($line in $pluginLines) {
    $b = $line.TrimStart('*').Trim()
    if ($b) { [void]$existingBare.Add($b) }
}

$newPlugins = [System.Collections.Generic.List[object]]::new()
foreach ($r in $renamed) {
    $modPath = Join-Path $SkyrimMods $r.Clean
    if (-not (Test-Path -LiteralPath $modPath)) { continue }
    # Root-level plugins only — never recurse (FOMOD option trees / loose assets)
    Get-ChildItem -LiteralPath $modPath -File -EA SilentlyContinue |
        Where-Object { $_.Extension -in '.esp', '.esm', '.esl' -and $_.Name -notmatch '\.mohidden$' } |
        ForEach-Object {
            [void]$newPlugins.Add([pscustomobject]@{ Name = $_.Name; Path = $_.FullName; Mod = $r.Clean })
        }
}

# Build present set for MAST: active + about-to-enable + root Data
$present = @{}
foreach ($n in $existingBare) { $present[$n] = $true }
Get-ChildItem 'D:\Skyrim\root\Data' -File -EA SilentlyContinue |
    Where-Object { $_.Extension -in '.esp', '.esm', '.esl' } |
    ForEach-Object { $present[$_.Name] = $true }

$enabled = [System.Collections.Generic.List[string]]::new()
$mastDisabled = [System.Collections.Generic.List[string]]::new()

foreach ($p in $newPlugins) {
    $present[$p.Name] = $true
}

foreach ($p in $newPlugins) {
    if ($existingBare.Contains($p.Name)) {
        # ensure starred
        for ($i = 0; $i -lt $pluginLines.Count; $i++) {
            if ($pluginLines[$i] -eq $p.Name) { $pluginLines[$i] = "*$($p.Name)"; [void]$enabled.Add($p.Name) }
        }
        continue
    }
    $missing = @(Get-PluginMasters $p.Path | Where-Object { -not (Test-VanillaMaster $_) -and -not $present.ContainsKey($_) })
    if ($missing.Count -gt 0) {
        [void]$pluginLines.Add($p.Name)  # present but inactive
        [void]$existingBare.Add($p.Name)
        [void]$mastDisabled.Add("$($p.Name) -> $($missing -join ', ')")
        Write-Log "MAST-off $($p.Name) -> $($missing -join ', ')"
    }
    else {
        [void]$pluginLines.Add("*$($p.Name)")
        [void]$existingBare.Add($p.Name)
        [void]$enabled.Add($p.Name)
    }
}

# Pass 2 MAST on newly enabled (in case of peer masters)
$final = [System.Collections.Generic.List[string]]::new()
$activeNow = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($line in $pluginLines) {
    if ($line -match '^\*(.+)$') { [void]$activeNow.Add($Matches[1]) }
}
foreach ($line in $pluginLines) {
    if ($line -notmatch '^\*(.+)$') { [void]$final.Add($line); continue }
    $bare = $Matches[1]
    $pinfo = $newPlugins | Where-Object { $_.Name -eq $bare } | Select-Object -First 1
    if (-not $pinfo) { [void]$final.Add($line); continue }
    $missing = @(Get-PluginMasters $pinfo.Path | Where-Object {
        -not (Test-VanillaMaster $_) -and -not $activeNow.Contains($_) -and -not $present.ContainsKey($_)
    })
    # present inactive masters still fail game load — check active set primarily
    $missingActive = @(Get-PluginMasters $pinfo.Path | Where-Object {
        -not (Test-VanillaMaster $_) -and -not $activeNow.Contains($_)
    })
    if ($missingActive.Count -gt 0) {
        [void]$final.Add($bare)
        if (-not ($mastDisabled | Where-Object { $_ -like "$bare ->*" })) {
            [void]$mastDisabled.Add("$bare -> $($missingActive -join ', ')")
        }
        [void]$activeNow.Remove($bare)
    }
    else {
        [void]$final.Add($line)
    }
}

Set-Content -LiteralPath $PluginsPath -Value $final -Encoding UTF8
$pluginsAfter = @($final | Where-Object { $_ -match '^\*' }).Count
Write-Log "plugins: before=$pluginsBefore after=$pluginsAfter enabled=$($enabled.Count) mast_off=$($mastDisabled.Count)"

$result = [ordered]@{
    taskId           = $TaskId
    separator        = $sepLine
    selected         = $selected.Count
    renamed          = @($renamed | ForEach-Object { $_.Clean })
    collisions       = @($collisions)
    missingSrc       = @($missingSrc)
    fomods           = @($fomods)
    pluginsEnabled   = @($enabled | Select-Object -Unique)
    pluginsMastOff   = @($mastDisabled)
    pluginsBefore    = $pluginsBefore
    pluginsAfter     = $pluginsAfter
}
$result | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $ResultJson -Encoding UTF8
Write-Log "$TaskId complete - result $ResultJson"
