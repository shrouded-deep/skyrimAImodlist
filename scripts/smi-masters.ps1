$ErrorActionPreference = 'Stop'
$p = 'D:\Skyrim AI Modlist\Anvil\mods\Survival Mode Improved - SKSE\SurvivalModeImproved.esp'
$bytes = [IO.File]::ReadAllBytes($p)
$text = [Text.Encoding]::ASCII.GetString($bytes)
$masters = [regex]::Matches($text, '[A-Za-z0-9_\-\''& ]+\.(esp|esm|esl)') |
    ForEach-Object { $_.Value.Trim() } |
    Where-Object { $_ -match '\.(esp|esm|esl)$' } |
    Sort-Object -Unique
Write-Output 'SurvivalModeImproved.esp likely masters/refs:'
$masters | ForEach-Object { Write-Output "  $_" }
