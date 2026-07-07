#Requires -Version 5.1
<#
.SYNOPSIS
  task-0038: Add Successor Additions separator and move new mods above Finishing Line.
  Uses MO2 major-tier separator format (---- NAME ---_separator) like Finishing Line.
#>
param(
    [string]$Mo2Root = 'D:\Skyrim AI Modlist\Anvil',
    [string]$ProfileName = 'Anvil - Main Profile',
    [string]$BaselinePath = '',
    [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'
. "$PSScriptRoot\Mo2ProfileGuardrails.ps1"
Assert-Mo2Closed

if (-not $BaselinePath) {
    $BaselinePath = Join-Path $PSScriptRoot '..\modlist\exports\mlo2-pre-migration-2026-07-07\modlist.txt'
}

$modlistPath = Join-Path $Mo2Root "profiles\$ProfileName\modlist.txt"
$finishingSep = '---- FINISHING LINE ---_separator'
$successorSep = '---- SUCCESSOR ADDITIONS ---_separator'
$cheatsSep = '-Cheats_separator'

$baselineCc = @(
    'Creation Club - Fishing'
    'Creation Club - Survival Mode'
    'Creation Club - Rare Curios'
    'Creation Club - Saints & Seducers'
)

$mloMods = @(
    'Modern Lighting Overhaul 2'
    'True Light'
    'Dust by FrankBlack aka Dust not Clouds'
    'Dynamic Interior Ambient Lighting'
    'Window Shadows Ultimate'
    'Window Shadows Ultimate - Patch Hub'
)

function Get-ModName([string]$Line) {
    if ($Line -match '^[\+\-](.+)$') { return $Matches[1] }
    return $null
}

function Get-BaselineNames([string]$Path) {
    $names = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($line in Get-Content $Path -Encoding UTF8) {
        $n = Get-ModName $line
        if ($n) { [void]$names.Add($n) }
    }
    return $names
}

function Get-LineForMod([System.Collections.Generic.List[string]]$Lines, [string]$ModName) {
    foreach ($line in $Lines) {
        if ((Get-ModName $line) -eq $ModName) { return $line }
    }
    return $null
}

$baseline = Get-BaselineNames $BaselinePath
$lines = [System.Collections.Generic.List[string]]::new()
(Get-Content $modlistPath -Encoding UTF8) | ForEach-Object { $lines.Add($_) }

$enabledBefore = ($lines | Where-Object { $_ -match '^\+' }).Count

# Collect all lines that belong in Successor block (not in baseline), keyed by mod name
$successorByName = @{}
$toRemove = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)

foreach ($line in $lines) {
    $name = Get-ModName $line
    if (-not $name) { continue }
    if ($name -match '_separator$') { continue }
    if ($baseline.Contains($name)) { continue }
    if ($baselineCc -contains $name) { continue }
    $successorByName[$name] = $line
    [void]$toRemove.Add($line)
}

# Also remove old failed separator variants and misplaced Cheats separator from body
$stripSeparators = @(
    $successorSep
    '-DLC: [Successor Additions]_separator'
    $cheatsSep
)
foreach ($line in @($lines)) {
    if ($stripSeparators -contains $line) {
        $lines.Remove($line)
    }
}

# Remove successor mod lines from current positions
for ($i = $lines.Count - 1; $i -ge 0; $i--) {
    if ($toRemove.Contains($lines[$i])) {
        $lines.RemoveAt($i)
    }
}

# Build ordered Successor block
$cheatNames = @(
    'Summon Shadow MERCHANT'
    "Soarin' Over Skyrim - A flying mod"
    'Smart Harvest NG AutoLoot'
    'Smart Cast - Faster checks edition (Turbo mod)'
    'Skyrim Cheat Engine'
    'Signature Equipment'
    'RMX Actor Value Book'
    'Reading Is Bad SKSE'
    'Puzzle Solver'
    'Puzzle Pillar Auto-Solve'
    'NPC Stats Editor'
    'No Enchantment Restriction SKSE Remake'
    'Jewelry of Power'
    'Infinite Stamina Out of Combat'
    'Infinite Shouting Out of Combat'
    'Infinite Magicka Out of Combat'
    'Infinite Horse Stamina Out of Combat'
    'Infinite Enchantment Charges'
    'In-Game Equipment Editor SE'
    'Handy Crafting and Spells - Crafting Storage and Travel Enhancements'
    'Dragon Claws Auto-Unlock'
    'Detect Levers and Keys'
)

$successorBlock = [System.Collections.Generic.List[string]]::new()
[void]$successorBlock.Add($successorSep)
[void]$successorBlock.Add($cheatsSep)

foreach ($name in $cheatNames) {
    if ($successorByName.ContainsKey($name)) {
        [void]$successorBlock.Add($successorByName[$name])
    }
}

foreach ($name in $mloMods) {
    if ($successorByName.ContainsKey($name)) {
        [void]$successorBlock.Add($successorByName[$name])
    }
}

$ccNames = $successorByName.Keys | Where-Object { $_ -like 'Creation Club - *' } | Sort-Object
foreach ($name in $ccNames) {
    [void]$successorBlock.Add($successorByName[$name])
}

# Any remaining successor mods not categorized
foreach ($name in ($successorByName.Keys | Sort-Object)) {
    if ($cheatNames -contains $name) { continue }
    if ($mloMods -contains $name) { continue }
    if ($name -like 'Creation Club - *') { continue }
    [void]$successorBlock.Add($successorByName[$name])
}

$finIdx = $lines.IndexOf($finishingSep)
if ($finIdx -lt 0) { throw "Finishing Line separator not found" }

# Insert Successor block immediately before Finishing Line
$newLines = [System.Collections.Generic.List[string]]::new()
for ($i = 0; $i -lt $finIdx; $i++) { [void]$newLines.Add($lines[$i]) }
foreach ($line in $successorBlock) { [void]$newLines.Add($line) }
for ($i = $finIdx; $i -lt $lines.Count; $i++) { [void]$newLines.Add($lines[$i]) }

$enabledAfter = ($newLines | Where-Object { $_ -match '^\+' }).Count
if ($enabledBefore -ne $enabledAfter) {
    throw "Enabled count changed: before=$enabledBefore after=$enabledAfter"
}

Write-Host "Successor block: $($successorBlock.Count) lines (incl. separators)"
Write-Host "Successor mods: $($successorByName.Count)"
Write-Host "Enabled unchanged: $enabledBefore"

if (-not $WhatIf) {
    $newLines | Set-Content $modlistPath -Encoding UTF8
}

return @{
    SuccessorModCount = $successorByName.Count
    EnabledCount      = $enabledBefore
}
