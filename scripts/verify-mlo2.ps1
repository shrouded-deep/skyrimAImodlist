# Preflight MLO2 + profile guardrails. Safe to run anytime (read-only except -Repair).
#
#   powershell -ExecutionPolicy Bypass -File scripts/verify-mlo2.ps1
#   powershell -ExecutionPolicy Bypass -File scripts/verify-mlo2.ps1 -Repair

param(
    [switch]$Repair
)

$ErrorActionPreference = 'Stop'
. "$PSScriptRoot/Mo2ProfileGuardrails.ps1"

$failures = @()

try {
    Assert-Mo2Closed
    Write-Host '[ok] MO2 is not running.'
}
catch {
    $failures += $_.Exception.Message
    Write-Host "[FAIL] $($_.Exception.Message)"
}

if (Test-Mlo2Healthy) {
    Write-Host '[ok] MLO.dll present.'
}
elseif ($Repair) {
    try {
        Ensure-Mlo2Healthy -Repair
        Write-Host '[ok] MLO.dll repaired.'
    }
    catch {
        $failures += $_.Exception.Message
        Write-Host "[FAIL] $($_.Exception.Message)"
    }
}
else {
    $msg = 'MLO.dll missing under mods/Modern Lighting Overhaul 2/SKSE/Plugins/'
    $failures += $msg
    Write-Host "[FAIL] $msg (re-run with -Repair if archive 160748 is in Downloads)"
}

if (Test-ModlistContains -Line $script:Mlo2ModlistLine) {
    Write-Host '[ok] MLO2 enabled in modlist.txt.'
}
else {
    $msg = "modlist.txt missing $($script:Mlo2ModlistLine)"
    $failures += $msg
    Write-Host "[FAIL] $msg"
}

if ($failures.Count -gt 0) {
    Write-Host ""
    Write-Host "$($failures.Count) check(s) failed."
    exit 1
}

Write-Host ""
Write-Host "All MLO2 preflight checks passed."
exit 0
