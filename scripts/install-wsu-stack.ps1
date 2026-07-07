# Install Window Shadows Ultimate stack for Anvil MLO2 live testing (task-0026)
#
# Guardrails: MO2 must be closed; MLO2.dll verified/repaired; post-install modlist snapshot.
# Run from repo root after MO2 downloads archives to Anvil/Downloads/:
#
#   powershell -ExecutionPolicy Bypass -File scripts/install-wsu-stack.ps1
#
# Nexus mods (66665 is NOT WSU):
#   150494  Window Shadows Ultimate
#   135488  True Light (legacy docs name: Placed Light — no Placed Light*.esp plugins)
#   133368  Dust by FrankBlack aka Dust not Clouds
#   149920  Dynamic Interior Ambient Lighting (DIAL)
# Optional: 151548  Window Shadows Ultimate - Patch Hub

$ErrorActionPreference = 'Stop'
. "$PSScriptRoot/Mo2ProfileGuardrails.ps1"

Write-Host '=== WSU stack install (with MO2 profile guardrails) ==='

# --- Preflight ---
Assert-Mo2Closed
Write-Host '[preflight] MO2 is not running.'

Ensure-Mlo2Healthy -Repair
Write-Host '[preflight] MLO2 SKSE plugin OK.'

if (-not (Test-ModlistContains -Line '+Light Placer')) {
    Write-Host '[warn] +Light Placer not found in modlist — True Light (135488) requires Light Placer at runtime.'
}

if (-not (Test-ModlistContains -Line $script:ModlistAnchor)) {
    throw "Preflight failed: anchor '$($script:ModlistAnchor)' not found in modlist.txt."
}

$required = @(
    @{ Id = 135488; Label = 'True Light' },
    @{
        Id = 133368
        Label = 'Dust by FrankBlack aka Dust not Clouds'
        Folder = 'Dust by FrankBlack aka Dust not Clouds'
        RequiredPaths = @('meshes\effects\ambient\fxambbeamdust00.nif')
        MinFileCount = 20
    },
    @{ Id = 149920; Label = 'Dynamic Interior Ambient Lighting' },
    @{ Id = 150494; Label = 'Window Shadows Ultimate'; Folder = 'Window Shadows Ultimate'; EspLike = @('Window Shadows Ultimate.esp') }
)

$missing = @()
foreach ($r in $required) {
    if (-not (Find-NexusArchive -ModId $r.Id)) {
        $missing += "$($r.Id) $($r.Label)"
    }
}
if ($missing.Count -gt 0) {
    Write-Host 'MISSING DOWNLOADS — install via MO2/Nexus first:'
    $missing | ForEach-Object { Write-Host "  $_" }
    exit 1
}

# --- Install ---
Install-TrueLightForWsu -Archive (Find-NexusArchive -ModId '135488')
Install-DialForAnvil -Archive (Find-NexusArchive -ModId '149920')
Install-WsuForAnvil -Archive (Find-NexusArchive -ModId '150494')

foreach ($r in $required | Where-Object { $_.Id -notin @('135488', '149920', '150494') }) {
    $installParams = @{
        Archive    = (Find-NexusArchive -ModId $r.Id)
        FolderName = $r.Folder
    }
    if ($r.EspLike) { $installParams['EspLikePatterns'] = $r.EspLike }
    if ($r.RequiredPaths) { $installParams['RequiredRelativePaths'] = $r.RequiredPaths }
    if ($r.MinFileCount) { $installParams['MinFileCount'] = $r.MinFileCount }
    Install-ModFromArchive @installParams
}

$stack = @(
    '+Modern Lighting Overhaul 2',
    '+True Light',
    '+Dust by FrankBlack aka Dust not Clouds',
    '+Dynamic Interior Ambient Lighting',
    '+Window Shadows Ultimate'
)

$hub = Find-NexusArchive -ModId '151548'
if ($hub) {
    Install-WsuPatchHubForAnvil -Archive $hub
    $stack += '+Window Shadows Ultimate - Patch Hub'
}
else {
    Write-Host 'Optional: 151548 Patch Hub not in Downloads — skipping.'
}

Ensure-ModlistBlockAfterAnchor -Lines $stack

# --- Postflight ---
Assert-WsuPostInstall -ModlistLines $stack
Write-ProfileSnapshot -Label 'wsu-stack-post-install'

Write-Host @'

Done.
Next: start MO2 -> Refresh -> enable plugins per True Light Nexus Load Order (135488):
  Early: True Light - Shadows and Ambient.esp
  Late: Window Shadows Ultimate.esp (before TL Bulbs)
  Very late: TL Bulbs ISL.esp; then CS Light.esp after TL Bulbs if CS Light is enabled
  True Light patch ESPs after WSU. WSU page: no LO requirements.
Enable DIAL plugins: DIAL.esp + DIAL_NAT.esp (script default for NAT.ENB on Anvil).
Patch Hub: enable only WSU - *.esp patches matching mods you actually have (hub has no Spaghetti patches).
Confirm 0 missing masters on enabled plugins, then run modlist/mlo2-manual-run.md section 3.
'@
