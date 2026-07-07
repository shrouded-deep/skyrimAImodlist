#Requires -Version 5.1
<#
.SYNOPSIS
  task-0038: Successor Additions separator for MO2.

  MO2 rules (Anvil instance):
  - Separator requires empty mod folder in mods/ with EXACT same name as modlist entry.
  - modlist.txt order is reversed vs UI: put separator line AFTER its mods in the file
    so the header displays above them in MO2.
  - Edit modlist.txt while MO2 is open, then Refresh (F5). Restarting MO2 closed
    regenerates modlist from internal state and drops unknown separators.
#>
param(
    [string]$Mo2Root = 'D:\Skyrim AI Modlist\Anvil',
    [string]$ProfileName = 'Anvil - Main Profile',
    [string]$BaselinePath = '',
    [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'

if (-not $BaselinePath) {
    $BaselinePath = Join-Path $PSScriptRoot '..\modlist\exports\mlo2-pre-migration-2026-07-07\modlist.txt'
}

$ModsDir = Join-Path $Mo2Root 'mods'
$modlistPath = Join-Path $Mo2Root "profiles\$ProfileName\modlist.txt"
$finishingSep = '---- FINISHING LINE ---_separator'
$successorSepName = '[Successor Additions]_separator'
$successorSepLine = "+$successorSepName"
$cheatsSepName = 'Cheats_separator'
$cheatsSepLine = "-$cheatsSepName"
$successorModFolder = Join-Path $ModsDir $successorSepName

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

# Ensure separator mod folder exists (MO2 ignores modlist line without this)
if (-not (Test-Path -LiteralPath $successorModFolder)) {
    if (-not $WhatIf) {
        New-Item -ItemType Directory -Force -LiteralPath $successorModFolder | Out-Null
        $metaPath = Join-Path $successorModFolder 'meta.ini'
        @"
[General]
modid=0
gameName=SkyrimSE
hasCustomURL=true
notes=Post-Anvil successor additions (task-0038). Empty separator mod.
color=@Variant(\0\0\0\x43\x1\xff\xff\x4a\x4a\xd4\xd4\xff\xff\0\0)
[installedFiles]
size=0
"@ | Out-File -LiteralPath $metaPath -Encoding utf8
    }
    Write-Host "Created separator folder: $successorModFolder"
}

$baseline = Get-BaselineNames $BaselinePath
$lines = [System.Collections.Generic.List[string]]::new()
(Get-Content $modlistPath -Encoding UTF8) | ForEach-Object { $lines.Add($_) }

$enabledBefore = ($lines | Where-Object { $_ -match '^\+' }).Count

$successorByName = @{}
$stripNames = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
[void]$stripNames.Add($successorSepName)
[void]$stripNames.Add('---- SUCCESSOR ADDITIONS ---_separator')
[void]$stripNames.Add('--- SUCCESSOR ADDITIONS ---_separator')
[void]$stripNames.Add('-DLC: [Successor Additions]_separator')
[void]$stripNames.Add($cheatsSepName)

foreach ($line in $lines) {
    $name = Get-ModName $line
    if (-not $name) { continue }
    if ($stripNames.Contains($name)) { continue }
    if ($name -match '_separator$') { continue }
    if ($baseline.Contains($name)) { continue }
    if ($baselineCc -contains $name) { continue }
    $successorByName[$name] = $line
}

# Remove successor mods and stale separator lines from current positions
for ($i = $lines.Count - 1; $i -ge 0; $i--) {
    $name = Get-ModName $lines[$i]
    if ($name -and $successorByName.ContainsKey($name)) { $lines.RemoveAt($i); continue }
    if ($name -and $stripNames.Contains($name)) { $lines.RemoveAt($i) }
}

# Build successor block: mods first, separators after (MO2 display order)
$block = [System.Collections.Generic.List[string]]::new()

foreach ($name in $cheatNames) {
    if ($successorByName.ContainsKey($name)) { [void]$block.Add($successorByName[$name]) }
}
[void]$block.Add($cheatsSepLine)

foreach ($name in $mloMods) {
    if ($successorByName.ContainsKey($name)) { [void]$block.Add($successorByName[$name]) }
}

$ccNames = $successorByName.Keys | Where-Object { $_ -like 'Creation Club - *' } | Sort-Object
foreach ($name in $ccNames) { [void]$block.Add($successorByName[$name]) }

foreach ($name in ($successorByName.Keys | Sort-Object)) {
    if ($cheatNames -contains $name) { continue }
    if ($mloMods -contains $name) { continue }
    if ($name -like 'Creation Club - *') { continue }
    [void]$block.Add($successorByName[$name])
}

[void]$block.Add($successorSepLine)

$finIdx = $lines.IndexOf($finishingSep)
if ($finIdx -lt 0) { throw "Finishing Line separator not found" }

$newLines = [System.Collections.Generic.List[string]]::new()
for ($i = 0; $i -lt $finIdx; $i++) { [void]$newLines.Add($lines[$i]) }
foreach ($line in $block) { [void]$newLines.Add($line) }
for ($i = $finIdx; $i -lt $lines.Count; $i++) { [void]$newLines.Add($lines[$i]) }

$enabledAfter = ($newLines | Where-Object { $_ -match '^\+' }).Count
if ($enabledAfter -ne ($enabledBefore + 1)) {
    throw "Enabled count unexpected: before=$enabledBefore after=$enabledAfter (expected +1 for +[Successor Additions]_separator)"
}

Write-Host "Successor mods: $($successorByName.Count); block lines: $($block.Count)"
Write-Host "Enabled unchanged: $enabledBefore"
Write-Host 'After edit: press F5 in MO2 (keep MO2 open; do not restart).'

if (-not $WhatIf) {
    $newLines | Out-File -FilePath $modlistPath -Encoding utf8
}

return @{
    SuccessorModCount = $successorByName.Count
    EnabledCount      = $enabledBefore
    SuccessorFolder   = $successorModFolder
}
