#Requires -Version 5.1
<#
.SYNOPSIS
  Enable MO2 mods and profile plugins for task-0037 / task-0036 cheat batch.
#>
param(
    [ValidateSet('0037', '0036', 'all')]
    [string]$Task = 'all',
    [string]$Mo2Root = 'D:\Skyrim AI Modlist\Anvil',
    [string]$ProfileName = 'Anvil - Main Profile'
)

$ErrorActionPreference = 'Stop'
. "$PSScriptRoot\Mo2ProfileGuardrails.ps1"
Assert-Mo2Closed

$ProfileDir = Join-Path $Mo2Root "profiles\$ProfileName"
$modlistPath = Join-Path $ProfileDir 'modlist.txt'
$pluginsPath = Join-Path $ProfileDir 'plugins.txt'
$loadorderPath = Join-Path $ProfileDir 'loadorder.txt'

$Task0037Mods = @(
    'Dragon Claws Auto-Unlock',
    'Puzzle Pillar Auto-Solve'
)
$Task0037Plugins = @(
    'Dragon Claws Auto-Unlock.esp'
)

$Task0036Mods = @(
    'Infinite Magicka Out of Combat',
    'Infinite Stamina Out of Combat',
    'Infinite Shouting Out of Combat',
    'Infinite Horse Stamina Out of Combat',
    'Infinite Enchantment Charges',
    'No Enchantment Restriction SKSE Remake',
    'Reading Is Bad SKSE',
    'Jewelry of Power',
    'Summon Shadow MERCHANT',
    'Detect Levers and Keys',
    'In-Game Equipment Editor SE',
    'NPC Stats Editor',
    'Signature Equipment'
)
$Task0036Plugins = @(
    'Infinite Magicka Out of Combat.esp',
    'Infinite Stamina Out of Combat.esp',
    'Infinite Shouting Out of Combat.esp',
    'InfiniteHorseStaminaOutofCombat.esp',
    'infiniteCharge.esp',
    'ReadingIsBad.esp',
    'Jewelry Of Power.esp',
    'SummonShadowMERCHANT.esp',
    'DetectLever.esp',
    'EquipmentStateCopy&Rename.esl',
    'SignatureEquipment.esp'
)

function Enable-ModLines {
    param([string[]]$Lines, [string[]]$ModNames)
    foreach ($name in $ModNames) {
        $neg = "-$name"
        $pos = "+$name"
        $idx = [array]::IndexOf($Lines, $neg)
        if ($idx -ge 0) {
            $Lines[$idx] = $pos
        } elseif ($Lines -notcontains $pos) {
            throw "Mod not found in modlist.txt: $name"
        }
    }
    return $Lines
}

function Add-Plugins {
    param([string[]]$PluginsLines, [string[]]$LoadorderLines, [string[]]$NewPlugins, [string]$InsertAfter)
    $loIdx = [array]::IndexOf($LoadorderLines, $InsertAfter)
    if ($loIdx -lt 0) { throw "Loadorder anchor not found: $InsertAfter" }
    $toAdd = @()
    foreach ($pl in $NewPlugins) {
        if ($PluginsLines -notcontains "*$pl") { $PluginsLines += "*$pl" }
        if ($LoadorderLines -notcontains $pl) { $toAdd += $pl }
    }
    if ($toAdd.Count -gt 0) {
        $LoadorderLines = @(
            $LoadorderLines[0..$loIdx]
            $toAdd
            $LoadorderLines[($loIdx + 1)..($LoadorderLines.Length - 1)]
        )
    }
    return @{ Plugins = $PluginsLines; Loadorder = $LoadorderLines; Added = $toAdd }
}

$modlist = Get-Content $modlistPath -Encoding UTF8
$plugins = Get-Content $pluginsPath -Encoding UTF8
$loadorder = Get-Content $loadorderPath -Encoding UTF8 | Where-Object { $_ -notmatch '^\s*$' -or $_ -match '^#' }

$addedPlugins = @()

if ($Task -eq '0037' -or $Task -eq 'all') {
    $modlist = Enable-ModLines $modlist $Task0037Mods
    $r = Add-Plugins $plugins $loadorder $Task0037Plugins 'Unofficial Skyrim Modders Patch.esp'
    $plugins = $r.Plugins
    $loadorder = $r.Loadorder
    $addedPlugins += $r.Added
    Write-Host "task-0037: enabled $($Task0037Mods.Count) mods, added plugins: $($r.Added -join ', ')"
}

if ($Task -eq '0036' -or $Task -eq 'all') {
    $modlist = Enable-ModLines $modlist $Task0036Mods
    $anchor = if ($loadorder -contains 'Dragon Claws Auto-Unlock.esp') {
        'Dragon Claws Auto-Unlock.esp'
    } else {
        'Unofficial Skyrim Modders Patch.esp'
    }
    $r = Add-Plugins $plugins $loadorder $Task0036Plugins $anchor
    $plugins = $r.Plugins
    $loadorder = $r.Loadorder
    $addedPlugins += $r.Added
    Write-Host "task-0036: enabled $($Task0036Mods.Count) mods, added plugins: $($r.Added -join ', ')"
}

$modlist | Set-Content $modlistPath -Encoding UTF8
$plugins | Set-Content $pluginsPath -Encoding UTF8
$loadorder | Set-Content $loadorderPath -Encoding UTF8

# MAST check for newly added plugins
$loSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
$loadorder | ForEach-Object { if ($_ -match '\.(esp|esm|esl)$') { [void]$loSet.Add($_) } }
$modsDir = Join-Path $Mo2Root 'mods'
$missing = @()
foreach ($pl in ($addedPlugins | Select-Object -Unique)) {
    $path = Get-ChildItem $modsDir -Recurse -Filter $pl -File -ErrorAction SilentlyContinue |
        Where-Object { $_.DirectoryName -notmatch '\\Source\\' } | Select-Object -First 1
    if (-not $path) { $missing += "$pl : file not found"; continue }
    $bytes = [IO.File]::ReadAllBytes($path.FullName)
    $text = [Text.Encoding]::ASCII.GetString($bytes)
    $masters = [regex]::Matches($text, '[\x20-\x7E]{1,120}\.(esp|esm|esl)\x00') |
        ForEach-Object { ($_.Value -replace '\x00', '').Trim() } | Select-Object -Unique
    foreach ($m in $masters) {
        if ($m -and -not $loSet.Contains($m)) { $missing += "$pl requires $m" }
    }
}
if ($missing.Count -gt 0) {
    $missing | ForEach-Object { Write-Warning $_ }
    throw "MAST failures: $($missing.Count)"
}
Write-Host "MAST: 0 missing masters for added plugins ($($addedPlugins.Count) plugins)"

return @{ AddedPlugins = $addedPlugins }
