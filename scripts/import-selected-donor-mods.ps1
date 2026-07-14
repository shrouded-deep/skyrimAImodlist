# Copy donor mods selected in donor-ae-mod-picker.html export JSON into Lost Legacy Fork mods folder.
# Folder names copied AS-IS (list prefixes kept) — rename when enabling by separator in a follow-up task.
#Requires -Version 5.1
param(
    [string]$SelectionJson = 'D:\Skyrim AI Modlist\anvil-successor\modlist\exports\donor-ae-import-selection.json',
    [string]$DonorMods = 'D:\Skyrim AE\mods',
    [string]$TargetMods = 'D:\Skyrim\mods',
    [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'

function Assert-Mo2Closed {
    $procs = Get-Process -Name 'ModOrganizer', 'modorganizer' -ErrorAction SilentlyContinue
    if ($procs) { throw 'MO2 is running — close Mod Organizer before copying mod folders.' }
}

function Write-Log($msg) {
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $msg"
    Add-Content -Path $script:LogPath -Value $line
    Write-Host $line
}

Assert-Mo2Closed
if (-not (Test-Path -LiteralPath $SelectionJson)) {
    throw "Selection file not found: $SelectionJson`nExport from donor-ae-mod-picker.html first."
}

$LogPath = 'D:\Skyrim AI Modlist\anvil-successor\modlist\exports\import-selected-donor-run.log'
if (Test-Path $LogPath) { Remove-Item $LogPath -Force }
Write-Log 'import-selected-donor-mods starting'

$payload = Get-Content -LiteralPath $SelectionJson -Raw -Encoding UTF8 | ConvertFrom-Json
$folders = @($payload.folders)
if ($folders.Count -eq 0) { throw 'No folders in selection JSON.' }
Write-Log "selection: $($folders.Count) folders (exported $($payload.exported))"

$copied = 0; $skipped = 0; $missing = 0; $collision = 0
foreach ($name in $folders) {
    $src = Join-Path $DonorMods $name
    $dst = Join-Path $TargetMods $name
    if (-not (Test-Path -LiteralPath $src)) {
        Write-Log "MISSING donor: $name"
        $missing++
        continue
    }
    if (Test-Path -LiteralPath $dst) {
        Write-Log "SKIP exists: $name"
        $collision++
        continue
    }
    if ($WhatIf) {
        Write-Log "WHATIF copy: $name"
        $copied++
        continue
    }
    Write-Log "COPY $name"
    New-Item -ItemType Directory -Path $dst -Force | Out-Null
    robocopy $src $dst /E /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "robocopy failed: $name exit $LASTEXITCODE" }
    $copied++
}

Write-Log "done: copied=$copied skipped_exists=$collision missing=$missing"
Write-Log 'Prefixes unchanged — enable in modlist by separator in a follow-up task.'
