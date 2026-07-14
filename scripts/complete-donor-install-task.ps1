# Fill task Result from install result JSON and move queue -> completed.
#Requires -Version 5.1
param(
    [Parameter(Mandatory)][string]$TaskId,
    [string]$ExtraNotes = ''
)

$ErrorActionPreference = 'Stop'
$Root = 'D:\Skyrim AI Modlist\anvil-successor'
$Queue = Join-Path $Root "tasks\queue\$TaskId.md"
$Done  = Join-Path $Root "tasks\completed\$TaskId.md"
$Json  = Join-Path $Root "modlist\exports\$TaskId-result.json"

if (-not (Test-Path -LiteralPath $Queue)) { throw "Missing queue task: $Queue" }
if (-not (Test-Path -LiteralPath $Json)) { throw "Missing result JSON: $Json" }

$r = Get-Content -LiteralPath $Json -Raw -Encoding UTF8 | ConvertFrom-Json
$body = Get-Content -LiteralPath $Queue -Raw -Encoding UTF8

# Mark acceptance criteria done
$body = $body -replace '(?m)^- \[ \] ', '- [x] '
$body = $body -replace '(?m)^status:\s*queued', 'status: done'

$fomodList = if ($r.fomods -and @($r.fomods).Count -gt 0) {
    (@($r.fomods) | ForEach-Object { "- $_" }) -join "`n"
} else { '(none)' }

$mastList = if ($r.pluginsMastOff -and @($r.pluginsMastOff).Count -gt 0) {
    (@($r.pluginsMastOff) | ForEach-Object { "- $_" }) -join "`n"
} else { '(none)' }

$collisionList = if ($r.collisions -and @($r.collisions).Count -gt 0) {
    (@($r.collisions) | ForEach-Object { "- $_" }) -join "`n"
} else { '(none)' }

$resultBlock = @"
## Result

Completed $(Get-Date -Format 'yyyy-MM-dd') via ``scripts/install-donor-batch.ps1``.

### What was done
- Matched **$($r.selected)** selection folders for separator ``$($r.separator)``.
- Renamed / integrated **$((@($r.renamed)).Count)** mods into modlist above ``-$($r.separator)``.
- Enabled **$((@($r.pluginsEnabled)).Count)** root-level plugins (plugins before=$($r.pluginsBefore) after=$($r.pluginsAfter)).
$ExtraNotes

### Collisions
$collisionList

### FOMOD mods (not run)
$fomodList

### Plugins left inactive (missing masters)
$mastList

### Artifacts
- ``modlist/exports/$TaskId-result.json``
- ``modlist/exports/$TaskId-install.log``
"@

if ($body -match '(?ms)^## Result\s*\r?\n.*') {
    $body = $body -replace '(?ms)^## Result\s*\r?\n.*', $resultBlock.TrimEnd() + "`r`n"
} else {
    $body = $body.TrimEnd() + "`r`n`r`n" + $resultBlock
}

Set-Content -LiteralPath $Done -Value $body -Encoding UTF8
Remove-Item -LiteralPath $Queue -Force
Write-Host "Completed $TaskId -> tasks/completed/" -ForegroundColor Green
