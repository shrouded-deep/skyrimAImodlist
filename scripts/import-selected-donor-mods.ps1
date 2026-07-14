# Copy donor mods selected in donor-ae-mod-picker.html export JSON into Lost Legacy Fork mods folder.
# Folder names copied AS-IS (list prefixes kept) — rename when enabling by separator in a follow-up task.
#
# Collision behaviour (destination folder already exists under the same name):
#   default     — skip (log SKIP exists)
#   -Replace    — delete the existing target folder, then copy donor over it
#   -Force      — alias for -Replace
#Requires -Version 5.1
param(
    [string]$SelectionJson = 'D:\Skyrim AI Modlist\anvil-successor\modlist\exports\donor-ae-import-selection.json',
    [string]$DonorMods = 'D:\Skyrim AE\mods',
    [string]$TargetMods = 'D:\Skyrim\mods',
    [switch]$WhatIf,
    [Alias('Force')][switch]$Replace
)

$ErrorActionPreference = 'Stop'

function Assert-Mo2Closed {
    $procs = Get-Process -Name 'ModOrganizer', 'modorganizer' -ErrorAction SilentlyContinue
    if ($procs) { throw 'MO2 is running — close Mod Organizer before copying mod folders.' }
}

function Write-Log($msg) {
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $msg"
    try {
        [System.IO.File]::AppendAllText($script:LogPath, $line + [Environment]::NewLine, [System.Text.UTF8Encoding]::new($false))
    }
    catch {
        # Never abort the copy over a log write failure
        Write-Warning "log write failed: $($_.Exception.Message)"
    }
    Write-Host $line
}

Assert-Mo2Closed
if (-not (Test-Path -LiteralPath $SelectionJson)) {
    throw "Selection file not found: $SelectionJson`nExport from donor-ae-mod-picker.html first."
}

$LogPath = 'D:\Skyrim AI Modlist\anvil-successor\modlist\exports\import-selected-donor-run.log'
Write-Log 'import-selected-donor-mods resuming'

$payload = Get-Content -LiteralPath $SelectionJson -Raw -Encoding UTF8 | ConvertFrom-Json
$folders = @($payload.folders)
if ($folders.Count -eq 0) { throw 'No folders in selection JSON.' }
Write-Log "selection: $($folders.Count) folders (exported $($payload.exported))"

$copied = 0; $replaced = 0; $skipped = 0; $missing = 0
foreach ($name in $folders) {
    $src = Join-Path $DonorMods $name
    $dst = Join-Path $TargetMods $name
    if (-not (Test-Path -LiteralPath $src)) {
        Write-Log "MISSING donor: $name"
        $missing++
        continue
    }
    $exists = Test-Path -LiteralPath $dst
    if ($exists -and -not $Replace) {
        Write-Log "SKIP exists: $name"
        $skipped++
        continue
    }
    if ($WhatIf) {
        if ($exists) { Write-Log "WHATIF replace: $name" } else { Write-Log "WHATIF copy: $name" }
        if ($exists) { $replaced++ } else { $copied++ }
        continue
    }
    if ($exists) {
        Write-Log "REPLACE $name"
        Remove-Item -LiteralPath $dst -Recurse -Force
        $replaced++
    }
    else {
        Write-Log "COPY $name"
        $copied++
    }
    New-Item -ItemType Directory -Path $dst -Force | Out-Null
    robocopy $src $dst /E /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "robocopy failed: $name exit $LASTEXITCODE" }
}

$mode = if ($Replace) { 'replace-on' } else { 'skip-on-collision' }
Write-Log "done ($mode): copied=$copied replaced=$replaced skipped_exists=$skipped missing=$missing"
Write-Log 'Prefixes unchanged — enable in modlist by separator in a follow-up task.'
