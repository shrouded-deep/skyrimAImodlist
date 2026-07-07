#Requires -Version 5.1
<#
.SYNOPSIS
  task-0038: Add [Successor Additions] separator and move new mods above Finishing Line.
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
$successorSep = '-DLC: [Successor Additions]_separator'

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

$baseline = Get-BaselineNames $BaselinePath
$lines = Get-Content $modlistPath -Encoding UTF8

$enabledBefore = ($lines | Where-Object { $_ -match '^\+' }).Count

$moveLines = [System.Collections.Generic.List[string]]::new()
$keepLines = [System.Collections.Generic.List[string]]::new()

foreach ($line in $lines) {
    if ($line -match '^#') {
        $keepLines.Add($line)
        continue
    }
    $name = Get-ModName $line
    if (-not $name) {
        $keepLines.Add($line)
        continue
    }
    if ($name -eq 'DLC: [Successor Additions]') { continue }
    if ($baseline.Contains($name)) {
        $keepLines.Add($line)
    } else {
        $moveLines.Add($line)
    }
}

$finIdx = $keepLines.IndexOf($finishingSep)
if ($finIdx -lt 0) { throw "Finishing Line separator not found in modlist.txt" }

# Remove existing successor separator if present
$keepArr = @($keepLines)
if ($finIdx -gt 0 -and $keepArr[$finIdx - 1] -eq $successorSep) {
    $keepArr = $keepArr[0..($finIdx - 2)] + $keepArr[$finIdx..($keepArr.Length - 1)]
    $finIdx--
}

$insertBlock = @($successorSep) + @($moveLines)
$newLines = @()
if ($keepArr.Count -gt 0) {
    $newLines += $keepArr[0..($finIdx - 1)]
}
$newLines += $insertBlock
$newLines += $keepArr[$finIdx..($keepArr.Length - 1)]

$enabledAfter = ($newLines | Where-Object { $_ -match '^\+' }).Count
if ($enabledBefore -ne $enabledAfter) {
    throw "Enabled count changed: before=$enabledBefore after=$enabledAfter"
}

Write-Host "Moved $($moveLines.Count) entries under $successorSep"
Write-Host "Enabled mods unchanged: $enabledBefore"

if (-not $WhatIf) {
    $newLines | Set-Content $modlistPath -Encoding UTF8
}

return @{
    MovedCount    = $moveLines.Count
    EnabledBefore = $enabledBefore
    EnabledAfter  = $enabledAfter
    Moved         = @($moveLines)
}
