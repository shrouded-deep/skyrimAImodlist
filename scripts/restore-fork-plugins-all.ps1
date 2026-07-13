# One-shot: restore Fork plugins.txt after MO2 F5 stripped enable flags, then MAST-clean.
#Requires -Version 5.1
$ErrorActionPreference = 'Stop'
& (Join-Path $PSScriptRoot 'restore-fork-plugin-enablement.ps1')
& (Join-Path $PSScriptRoot 'fix-jk-ryn-plugin-masters.ps1')
$profile = 'E:\Skyrim\profiles\Keizaal - Fork'
$good = Join-Path $profile 'plugins.txt.good-2026-07-12'
Copy-Item (Join-Path $profile 'plugins.txt') $good -Force
$active = (Select-String -Path (Join-Path $profile 'plugins.txt') -Pattern '^\*').Count
Write-Host "Snapshot written: $good ($active active)"
