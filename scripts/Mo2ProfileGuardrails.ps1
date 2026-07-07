# Shared MO2 profile / instance guardrails for Anvil automation scripts.
# Dot-source from repo scripts: . "$PSScriptRoot/Mo2ProfileGuardrails.ps1"
#
# Any script that writes modlist.txt, plugins.txt, or loadorder.txt MUST call
# Assert-Mo2Closed (unconditional throw) before edits — same as install-wsu-stack.ps1.
# Read-only diagnostics (e.g. verify-mlo2.ps1) may catch and report instead.

$script:AnvilRoot = 'D:\Skyrim AI Modlist\Anvil'
$script:AnvilProfile = 'Anvil - Main Profile'
$script:AnvilModlist = Join-Path $script:AnvilRoot "profiles\$script:AnvilProfile\modlist.txt"
$script:AnvilDownloads = Join-Path $script:AnvilRoot 'Downloads'
$script:AnvilMods = Join-Path $script:AnvilRoot 'mods'
$script:Mlo2Folder = 'Modern Lighting Overhaul 2'
$script:Mlo2ModId = '160748'
$script:Mlo2ModlistLine = '+Modern Lighting Overhaul 2'
$script:ModlistAnchor = '+Base Object Swapper'

function Get-SevenZipPath {
    foreach ($p in @(
            'C:\Program Files\7-Zip\7z.exe',
            'C:\Program Files (x86)\7-Zip\7z.exe'
        )) {
        if (Test-Path $p) { return $p }
    }
    throw '7-Zip not found (install 7-Zip or add to PATH).'
}

function Assert-Mo2Closed {
    $procs = Get-Process -ErrorAction SilentlyContinue | Where-Object {
        $_.ProcessName -match '^(ModOrganizer|ModOrganizer\.exe)$'
    }
    if ($procs) {
        throw @(
            'MO2 is running - close Mod Organizer completely before this script edits the profile.'
            'If MO2 saves on exit it can overwrite modlist.txt changes (same failure mode as task-0022 MLO2 drop).'
        ) -join ' '
    }
}

function Find-NexusArchive {
    param(
        [Parameter(Mandatory)]
        [string]$ModId,
        [string]$DownloadsPath = $script:AnvilDownloads
    )
    Get-ChildItem -LiteralPath $DownloadsPath -File -ErrorAction SilentlyContinue | Where-Object {
        $_.Name -match "-$([regex]::Escape($ModId))-" -and $_.Extension -match '\.(zip|7z|rar)$'
    } | Sort-Object LastWriteTime -Descending | Select-Object -First 1
}

function Test-ModlistContains {
    param([Parameter(Mandatory)][string]$Line)
    $lines = Get-Content -LiteralPath $script:AnvilModlist
    return ($lines -contains $Line)
}

function Get-ModContentRoot {
    param([Parameter(Mandatory)][string]$TempRoot)

    $topDirs = @(Get-ChildItem -LiteralPath $TempRoot -Directory -ErrorAction SilentlyContinue)
    $topFiles = @(Get-ChildItem -LiteralPath $TempRoot -File -ErrorAction SilentlyContinue)

    if ($topDirs.Count -eq 1 -and $topFiles.Count -eq 0) {
        $inner = $topDirs[0].FullName
        $innerData = Join-Path $inner 'Data'
        if (Test-Path -LiteralPath $innerData) { return $innerData }
        return $inner
    }

    $dataDirs = @(Get-ChildItem -LiteralPath $TempRoot -Recurse -Directory -Filter 'Data' -ErrorAction SilentlyContinue)
    foreach ($dataDir in $dataDirs) {
        $hasPlugin = @(Get-ChildItem -LiteralPath $dataDir.FullName -Recurse -Include *.esp, *.esm, *.esl -File -ErrorAction SilentlyContinue).Count -gt 0
        if ($hasPlugin) { return $dataDir.FullName }
    }

    return $TempRoot
}

function Copy-Mo2ModTree {
    param(
        [Parameter(Mandatory)][string]$SourceRoot,
        [Parameter(Mandatory)][string]$DestRoot
    )

    if (-not (Test-Path -LiteralPath $DestRoot)) {
        New-Item -ItemType Directory -Path $DestRoot -Force | Out-Null
    }

    $dataPath = Join-Path $SourceRoot 'Data'
    if (Test-Path -LiteralPath $dataPath) {
        Copy-Item -Path (Join-Path $dataPath '*') -Destination $DestRoot -Recurse -Force
    }
    else {
        Copy-Item -Path (Join-Path $SourceRoot '*') -Destination $DestRoot -Recurse -Force
    }

    foreach ($assetDir in @('SKSE', 'meshes', 'textures', 'interface', 'scripts', 'tools', 'seq')) {
        $assetPath = Join-Path $SourceRoot $assetDir
        if (Test-Path -LiteralPath $assetPath) {
            Copy-Item -LiteralPath $assetPath -Destination $DestRoot -Recurse -Force
        }
    }
}

function Clear-Mo2ModFolderContents {
    param([Parameter(Mandatory)][string]$ModFolder)

    if (-not (Test-Path -LiteralPath $ModFolder)) {
        New-Item -ItemType Directory -Path $ModFolder -Force | Out-Null
        return
    }

    $metaPath = Join-Path $ModFolder 'meta.ini'
    $savedMeta = if (Test-Path -LiteralPath $metaPath) { Get-Content -LiteralPath $metaPath -Raw } else { $null }
    Get-ChildItem -LiteralPath $ModFolder -Force | Remove-Item -Recurse -Force
    if ($savedMeta) {
        Set-Content -LiteralPath $metaPath -Value $savedMeta -NoNewline
    }
}

function Write-Mo2MetaIniFromArchive {
    param(
        [Parameter(Mandatory)][string]$ModFolder,
        [Parameter(Mandatory)]$Archive
    )

    $metaSrc = "$($Archive.FullName).meta"
    $destMeta = Join-Path $ModFolder 'meta.ini'
    if (Test-Path -LiteralPath $metaSrc) {
        $content = Get-Content -LiteralPath $metaSrc -Raw
        $content = $content -replace '(?m)^installed=false', 'installed=true'
        $content = $content -replace '(?m)^removed=false', 'removed=false'
        Set-Content -LiteralPath $destMeta -Value $content -NoNewline
        return
    }

    $modId = if ($Archive.Name -match '-(\d+)-') { $Matches[1] } else { '' }
    $folderName = Split-Path $ModFolder -Leaf
    @(
        '[General]'
        'gameName=SkyrimSE'
        "modID=$modId"
        "modName=$folderName"
        "installationFile=$($Archive.Name)"
        'repository=Nexus'
    ) | Set-Content -LiteralPath $destMeta
}

function Merge-WsuHubPatchFolder {
    param(
        [Parameter(Mandatory)][string]$PatchDir,
        [Parameter(Mandatory)][string]$DestRoot,
        [string]$MeshBrightness = 'Brighter'
    )

    foreach ($item in @(Get-ChildItem -LiteralPath $PatchDir -Force)) {
        if ($item.Name -eq 'meshes') {
            $brightnessMeshes = Join-Path $item.FullName "$MeshBrightness\meshes"
            $meshDest = Join-Path $DestRoot 'meshes'
            New-Item -ItemType Directory -Path $meshDest -Force | Out-Null
            if (Test-Path -LiteralPath $brightnessMeshes) {
                Copy-Item -Path (Join-Path $brightnessMeshes '*') -Destination $meshDest -Recurse -Force
            }
            else {
                Copy-Item -LiteralPath $item.FullName -Destination $meshDest -Recurse -Force
            }
            continue
        }

        $target = Join-Path $DestRoot $item.Name
        if ($item.PSIsContainer) {
            Copy-Item -LiteralPath $item.FullName -Destination $target -Recurse -Force
        }
        else {
            Copy-Item -LiteralPath $item.FullName -Destination $target -Force
        }
    }
}

function Install-WsuForAnvil {
    param(
        [Parameter(Mandatory)]
        $Archive,
        [string]$MeshBrightness = 'Brighter'
    )

    # Nexus 150494 is FOMOD. Anvil path: MAIN + CS Add-On + Brighter mesh/FX beam defaults.
    $7z = Get-SevenZipPath
    $dest = Join-Path $script:AnvilMods 'Window Shadows Ultimate'
    Clear-Mo2ModFolderContents -ModFolder $dest

    $temp = Join-Path $env:TEMP "wsu-anvil-$(Get-Random)"
    New-Item -ItemType Directory -Path $temp -Force | Out-Null
    $prefix = 'Window Shadows Ultimate'

    try {
        Write-Host "Installing WSU (150494) MAIN + CS Add-On + $MeshBrightness defaults -> Window Shadows Ultimate"
        $paths = @(
            "$prefix\MAIN\*",
            "$prefix\CS Add-On\*",
            "$prefix\meshes\$MeshBrightness\meshes\*",
            "$prefix\FXAmbBeam\$MeshBrightness\textures\*"
        )
        foreach ($p in $paths) {
            & $7z x $Archive.FullName "-o$temp" $p -y | Out-Null
        }

        $root = Join-Path $temp $prefix
        if (-not (Test-Path -LiteralPath $root)) {
            throw 'WSU archive layout changed — expected top folder Window Shadows Ultimate.'
        }

        Copy-Item -Path (Join-Path $root 'MAIN\*') -Destination $dest -Recurse -Force
        Copy-Item -Path (Join-Path $root 'CS Add-On\*') -Destination $dest -Recurse -Force

        $meshSrc = Join-Path $root "meshes\$MeshBrightness\meshes"
        if (Test-Path -LiteralPath $meshSrc) {
            $meshDest = Join-Path $dest 'meshes'
            New-Item -ItemType Directory -Path $meshDest -Force | Out-Null
            Copy-Item -Path (Join-Path $meshSrc '*') -Destination $meshDest -Recurse -Force
        }

        $fxSrc = Join-Path $root "FXAmbBeam\$MeshBrightness\textures"
        if (Test-Path -LiteralPath $fxSrc) {
            $texDest = Join-Path $dest 'textures'
            New-Item -ItemType Directory -Path $texDest -Force | Out-Null
            Copy-Item -Path (Join-Path $fxSrc '*') -Destination $texDest -Recurse -Force
        }

        Write-Mo2MetaIniFromArchive -ModFolder $dest -Archive $Archive

        if (-not (Test-ModInstallHealth -ModFolder $dest `
                -RequiredEspLike @('Window Shadows Ultimate.esp') `
                -RequiredRelativePaths @('Window Shadows Ultimate.ini', 'WSU_SWAP.ini') `
                -MinFileCount 20)) {
            $count = @(Get-ChildItem -LiteralPath $dest -Recurse -File -ErrorAction SilentlyContinue).Count
            throw "WSU install verification failed ($count files). Expected flattened MAIN + CS Add-On at mod root."
        }
    }
    finally {
        if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Recurse -Force }
    }
}

function Install-WsuPatchHubForAnvil {
    param(
        [Parameter(Mandatory)]
        $Archive,
        [string]$MeshBrightness = 'Brighter'
    )

    # Nexus 151548 is FOMOD. Flatten Patches/* to mod root; skip fomod/Images/CS Add-On wrapper junk.
    $7z = Get-SevenZipPath
    $dest = Join-Path $script:AnvilMods 'Window Shadows Ultimate - Patch Hub'
    Clear-Mo2ModFolderContents -ModFolder $dest

    $temp = Join-Path $env:TEMP "wsu-hub-$(Get-Random)"
    New-Item -ItemType Directory -Path $temp -Force | Out-Null
    $prefix = 'Window Shadows Ultimate - Patch Hub'

    try {
        Write-Host 'Installing WSU Patch Hub (151548) - flattening Patches to mod root'
        & $7z x $Archive.FullName "-o$temp" "$prefix\Patches\*" -y | Out-Null

        $patchesRoot = Join-Path $temp "$prefix\Patches"
        if (-not (Test-Path -LiteralPath $patchesRoot)) {
            throw 'Patch Hub archive layout changed — expected Patches folder.'
        }

        foreach ($patchDir in @(Get-ChildItem -LiteralPath $patchesRoot -Directory)) {
            Merge-WsuHubPatchFolder -PatchDir $patchDir.FullName -DestRoot $dest -MeshBrightness $MeshBrightness
        }

        Write-Mo2MetaIniFromArchive -ModFolder $dest -Archive $Archive

        $espCount = @(Get-ChildItem -LiteralPath $dest -Filter 'WSU - *.esp' -File -ErrorAction SilentlyContinue).Count
        if ($espCount -lt 1) {
            throw 'Patch Hub install verification failed: no WSU - *.esp plugins at mod root.'
        }
        if (Test-Path -LiteralPath (Join-Path $dest 'fomod')) {
            throw 'Patch Hub install verification failed: fomod/ folder should not be present after flatten.'
        }

        Write-Host "Patch Hub OK ($espCount patch ESP(s) at mod root; enable only patches for mods you use)."
    }
    finally {
        if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Recurse -Force }
    }
}

function Test-ModMarkers {
    param(
        [Parameter(Mandatory)][string]$ModFolder,
        [Parameter(Mandatory)][string[]]$EspLikePatterns
    )

    foreach ($pattern in $EspLikePatterns) {
        $hit = Get-ChildItem -LiteralPath $ModFolder -Recurse -File -ErrorAction SilentlyContinue |
            Where-Object { $_.Extension -match '\.(esp|esm|esl)$' -and $_.Name -like $pattern } |
            Select-Object -First 1
        if ($hit) { return $true }
    }
    return $false
}

function Test-ModInstallHealth {
    param(
        [Parameter(Mandatory)][string]$ModFolder,
        [string[]]$RequiredEspLike = @(),
        [string[]]$RequiredRelativePaths = @(),
        [int]$MinJsonCount = 0,
        [int]$MinFileCount = 0
    )

    if (-not (Test-Path -LiteralPath $ModFolder)) { return $false }

    $fileCount = @(Get-ChildItem -LiteralPath $ModFolder -Recurse -File -ErrorAction SilentlyContinue).Count
    if ($fileCount -eq 0) { return $false }
    if ($MinFileCount -gt 0 -and $fileCount -lt $MinFileCount) { return $false }

    foreach ($pattern in $RequiredEspLike) {
        if (-not (Test-ModMarkers -ModFolder $ModFolder -EspLikePatterns @($pattern))) {
            return $false
        }
    }

    foreach ($rel in $RequiredRelativePaths) {
        if (-not (Test-Path -LiteralPath (Join-Path $ModFolder $rel))) { return $false }
    }

    if ($MinJsonCount -gt 0) {
        $jsonCount = @(Get-ChildItem -LiteralPath $ModFolder -Recurse -Filter '*.json' -File -ErrorAction SilentlyContinue).Count
        if ($jsonCount -lt $MinJsonCount) { return $false }
    }

    return $true
}

function Install-TrueLightForWsu {
    param(
        [Parameter(Mandatory)]
        $Archive
    )

    # Nexus 135488 ships as "True Light" (rebrand of legacy Placed Light name).
    # Hybrid mod: Light Placer JSON + ESPs. FOMOD defaults for WSU stack:
    #   Main Files + WSU Yes (WSU\TL Bulbs ISL.esp) + Interior Window Lights Yes.
    $7z = Get-SevenZipPath
    $dest = Join-Path $script:AnvilMods 'True Light'
    $metaPath = Join-Path $dest 'meta.ini'
    $savedMeta = if (Test-Path -LiteralPath $metaPath) { Get-Content -LiteralPath $metaPath -Raw } else { $null }

    $legacyFolder = Join-Path $script:AnvilMods 'Placed Light'
    if (Test-Path -LiteralPath $legacyFolder) {
        $legacyCount = @(Get-ChildItem -LiteralPath $legacyFolder -Recurse -File -ErrorAction SilentlyContinue).Count
        if ($legacyCount -eq 0) {
            Remove-Item -LiteralPath $legacyFolder -Recurse -Force
            Write-Host 'Removed empty legacy mods/Placed Light folder (135488 is True Light on Nexus).'
        }
    }

    New-Item -ItemType Directory -Path $dest -Force | Out-Null
    $temp = Join-Path $env:TEMP "true-light-wsu-$(Get-Random)"
    New-Item -ItemType Directory -Path $temp -Force | Out-Null

    try {
        Write-Host "Installing True Light (135488) WSU FOMOD defaults -> True Light"
        $prefix = 'True Light'
        $paths = @(
            "$prefix\Main\True Light - Shadows and Ambient.esp",
            "$prefix\WSU\TL Bulbs ISL.esp",
            "$prefix\LightPlacer\*",
            "$prefix\Interior window lights\*",
            "$prefix\TL_SWAP.ini"
        )
        foreach ($p in $paths) {
            & $7z x $Archive.FullName "-o$temp" $p -y | Out-Null
        }

        $root = Join-Path $temp $prefix
        if (-not (Test-Path -LiteralPath $root)) {
            throw 'True Light archive layout changed — expected top folder True Light.'
        }

        Copy-Item -LiteralPath (Join-Path $root 'Main\True Light - Shadows and Ambient.esp') -Destination $dest -Force
        Copy-Item -LiteralPath (Join-Path $root 'WSU\TL Bulbs ISL.esp') -Destination (Join-Path $dest 'TL Bulbs ISL.esp') -Force
        Copy-Item -Path (Join-Path $root 'LightPlacer\*') -Destination $dest -Recurse -Force
        $interiorLp = Join-Path $root 'Interior window lights\LightPlacer\True Light'
        if (Test-Path -LiteralPath $interiorLp) {
            $interiorDest = Join-Path $dest 'LightPlacer\True Light'
            New-Item -ItemType Directory -Path $interiorDest -Force | Out-Null
            Copy-Item -Path (Join-Path $interiorLp '*') -Destination $interiorDest -Force
        }
        Copy-Item -LiteralPath (Join-Path $root 'TL_SWAP.ini') -Destination $dest -Force

        if ($savedMeta) {
            Set-Content -LiteralPath $metaPath -Value $savedMeta -NoNewline
        }

        $ok = Test-ModInstallHealth -ModFolder $dest `
            -RequiredEspLike @('True Light*.esp', 'TL Bulbs ISL.esp') `
            -RequiredRelativePaths @('LightPlacer\True Light.ini', 'TL_SWAP.ini', 'LightPlacer\True Light\True Light -  Interior Windows Whiterun.json') `
            -MinJsonCount 16

        if (-not $ok) {
            $count = @(Get-ChildItem -LiteralPath $dest -Recurse -File -ErrorAction SilentlyContinue).Count
            throw @(
                "True Light install verification failed under mods/True Light ($count files on disk)."
                'Expected WSU FOMOD bundle: True Light - Shadows and Ambient.esp, TL Bulbs ISL.esp (WSU variant), LightPlacer JSONs.'
                'Requires +Light Placer already enabled in profile. Use MO2 FOMOD if archive layout changed.'
            ) -join ' '
        }
    }
    finally {
        if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Recurse -Force }
    }
}

function Install-DialForAnvil {
    param(
        [Parameter(Mandatory)]
        $Archive,
        [string]$WeatherPatchEsp = 'DIAL_NAT.esp'
    )

    # Nexus 149920 is FOMOD-only (MAIN + weather patch folders). Anvil uses NAT.ENB -> DIAL_NAT.esp.
    $7z = Get-SevenZipPath
    $dest = Join-Path $script:AnvilMods 'Dynamic Interior Ambient Lighting'
    $metaPath = Join-Path $dest 'meta.ini'
    $savedMeta = if (Test-Path -LiteralPath $metaPath) { Get-Content -LiteralPath $metaPath -Raw } else { $null }

    New-Item -ItemType Directory -Path $dest -Force | Out-Null
    $temp = Join-Path $env:TEMP "dial-anvil-$(Get-Random)"
    New-Item -ItemType Directory -Path $temp -Force | Out-Null

    try {
        Write-Host "Installing DIAL (149920) MAIN + $WeatherPatchEsp -> Dynamic Interior Ambient Lighting"
        $prefix = 'Dynamic Interior Ambient Lighting (DIAL)'
        $paths = @(
            "$prefix\MAIN\*",
            "$prefix\Weather Patches\$WeatherPatchEsp"
        )
        foreach ($p in $paths) {
            & $7z x $Archive.FullName "-o$temp" $p -y | Out-Null
        }

        $root = Join-Path $temp $prefix
        if (-not (Test-Path -LiteralPath $root)) {
            throw 'DIAL archive layout changed — expected top folder "Dynamic Interior Ambient Lighting (DIAL)".'
        }

        Copy-Item -Path (Join-Path $root 'MAIN\*') -Destination $dest -Recurse -Force
        Copy-Item -LiteralPath (Join-Path $root "Weather Patches\$WeatherPatchEsp") -Destination $dest -Force

        if ($savedMeta) {
            Set-Content -LiteralPath $metaPath -Value $savedMeta -NoNewline
        }

        $ok = Test-ModInstallHealth -ModFolder $dest `
            -RequiredEspLike @('DIAL.esp', $WeatherPatchEsp) `
            -RequiredRelativePaths @('SKSE\Plugins\SkyPatcher\cell\ZZZzzzDynamic Interior Ambient Lighting') `
            -MinFileCount 10

        if (-not $ok) {
            $count = @(Get-ChildItem -LiteralPath $dest -Recurse -File -ErrorAction SilentlyContinue).Count
            throw @(
                "DIAL install verification failed under mods/Dynamic Interior Ambient Lighting ($count files on disk)."
                "Expected MAIN (DIAL.esp, Scripts, SkyPatcher) + weather patch $WeatherPatchEsp."
                'Use MO2 FOMOD if archive layout changed.'
            ) -join ' '
        }
    }
    finally {
        if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Recurse -Force }
    }
}

function Repair-Mlo2 {
    param([switch]$Quiet)

    $7z = Get-SevenZipPath
    $dest = Join-Path $script:AnvilMods $script:Mlo2Folder
    $archive = Find-NexusArchive -ModId $script:Mlo2ModId
    if (-not $archive) {
        throw "Cannot repair MLO2: Nexus archive *-$($script:Mlo2ModId)-* not found in Downloads."
    }

    $temp = Join-Path $env:TEMP "mlo2-repair-$(Get-Random)"
    New-Item -ItemType Directory -Path $temp -Force | Out-Null
    try {
        & $7z x $archive.FullName "-o$temp" '00 Main Module\*' -y | Out-Null
        if (-not (Test-Path -LiteralPath (Join-Path $temp '00 Main Module'))) {
            throw 'MLO2 archive layout changed — expected FOMOD folder 00 Main Module.'
        }

        New-Item -ItemType Directory -Path $dest -Force | Out-Null
        Copy-Item -LiteralPath (Join-Path $temp '00 Main Module\*') -Destination $dest -Recurse -Force

        $nested = Join-Path $dest '00 Main Module'
        if (Test-Path -LiteralPath $nested) {
            Remove-Item -LiteralPath $nested -Recurse -Force
        }

        $iniTemp = Join-Path $env:TEMP "mlo2-ini-$(Get-Random)"
        New-Item -ItemType Directory -Path $iniTemp -Force | Out-Null
        try {
            & $7z x $archive.FullName "-o$iniTemp" '02 MLO.ini Whitelist\01 Shadow Casters On\SKSE\Plugins\MLO.ini' -y | Out-Null
            $iniSrc = Join-Path $iniTemp '02 MLO.ini Whitelist\01 Shadow Casters On\SKSE\Plugins\MLO.ini'
            if (Test-Path -LiteralPath $iniSrc) {
                $iniDestDir = Join-Path $dest 'SKSE\Plugins'
                New-Item -ItemType Directory -Path $iniDestDir -Force | Out-Null
                $iniContent = (Get-Content -LiteralPath $iniSrc -Raw) -replace 'enableColorConsistency=true', 'enableColorConsistency=false'
                Set-Content -LiteralPath (Join-Path $iniDestDir 'MLO.ini') -Value $iniContent -NoNewline
            }
        }
        finally {
            if (Test-Path -LiteralPath $iniTemp) { Remove-Item -LiteralPath $iniTemp -Recurse -Force }
        }

        if (-not $Quiet) { Write-Host "Repaired MLO2 from $($archive.Name)" }
    }
    finally {
        if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Recurse -Force }
    }
}

function Test-Mlo2Healthy {
    $dll = Join-Path $script:AnvilMods "$($script:Mlo2Folder)\SKSE\Plugins\MLO.dll"
    return (Test-Path -LiteralPath $dll)
}

function Ensure-Mlo2Healthy {
    param([switch]$Repair)

    if (Test-Mlo2Healthy) { return }

    if (-not $Repair) {
        throw 'MLO2 SKSE plugin missing: mods/Modern Lighting Overhaul 2/SKSE/Plugins/MLO.dll — re-run with repair or restore from Downloads.'
    }

    Write-Host 'MLO2.dll missing — repairing from Downloads archive (task-0022 flatten extract)...'
    Repair-Mlo2
    if (-not (Test-Mlo2Healthy)) {
        throw 'MLO2 repair failed: MLO.dll still missing after re-extract.'
    }
}

function Install-ModFromArchive {
    param(
        [Parameter(Mandatory)]
        $Archive,
        [Parameter(Mandatory)]
        [string]$FolderName,
        [string[]]$EspLikePatterns = @(),
        [string[]]$RequiredRelativePaths = @(),
        [int]$MinFileCount = 0
    )

    if ($EspLikePatterns.Count -eq 0 -and $RequiredRelativePaths.Count -eq 0 -and $MinFileCount -le 0) {
        throw "Install-ModFromArchive '$FolderName': specify EspLikePatterns, RequiredRelativePaths, and/or MinFileCount."
    }

    $7z = Get-SevenZipPath
    $dest = Join-Path $script:AnvilMods $FolderName
    $metaPath = Join-Path $dest 'meta.ini'
    $savedMeta = if (Test-Path -LiteralPath $metaPath) { Get-Content -LiteralPath $metaPath -Raw } else { $null }

    $temp = Join-Path $env:TEMP "mod-extract-$(Get-Random)"
    New-Item -ItemType Directory -Path $temp -Force | Out-Null
    try {
        Write-Host "Extracting $($Archive.Name) -> $FolderName"
        & $7z x $Archive.FullName "-o$temp" -y | Out-Null

        $contentRoot = Get-ModContentRoot -TempRoot $temp
        Copy-Mo2ModTree -SourceRoot $contentRoot -DestRoot $dest

        if ($savedMeta) {
            Set-Content -LiteralPath $metaPath -Value $savedMeta -NoNewline
        }

        if (-not (Test-ModInstallHealth -ModFolder $dest `
                -RequiredEspLike $EspLikePatterns `
                -RequiredRelativePaths $RequiredRelativePaths `
                -MinFileCount $MinFileCount)) {
            $count = @(Get-ChildItem -LiteralPath $dest -Recurse -File -ErrorAction SilentlyContinue).Count
            $expect = @()
            if ($EspLikePatterns.Count -gt 0) { $expect += "ESP like: $($EspLikePatterns -join ', ')" }
            if ($RequiredRelativePaths.Count -gt 0) { $expect += "paths: $($RequiredRelativePaths -join ', ')" }
            if ($MinFileCount -gt 0) { $expect += "min files: $MinFileCount" }
            throw "Extract verification failed for '$FolderName': $count file(s) on disk but expected $($expect -join '; '). Use MO2 FOMOD install instead."
        }
    }
    finally {
        if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Recurse -Force }
    }
}

function Ensure-ModlistBlockAfterAnchor {
    param(
        [Parameter(Mandatory)]
        [string[]]$Lines
    )

    if (-not (Test-Path -LiteralPath $script:AnvilModlist)) {
        throw "Profile modlist not found: $script:AnvilModlist"
    }

    $stackModNames = @(
        'Modern Lighting Overhaul 2',
        'True Light',
        'Placed Light',
        'Dust by FrankBlack aka Dust not Clouds',
        'Dynamic Interior Ambient Lighting',
        'Window Shadows Ultimate',
        'Window Shadows Ultimate - Patch Hub'
    )

    $existing = @(Get-Content -LiteralPath $script:AnvilModlist)

    # Strip every +/- stack mod anywhere in the profile, then rewrite the block in order.
    # Avoids a bug where an existing stack line was removed from $after but not re-inserted.
    $scrubbed = @($existing | Where-Object {
            if ($_ -match '^[\+\-](.+)$') {
                return ($Matches[1] -notin $stackModNames)
            }
            return $true
        })

    $idx = [array]::IndexOf($scrubbed, $script:ModlistAnchor)
    if ($idx -lt 0) {
        throw "Anchor line not found in modlist: $($script:ModlistAnchor)"
    }

    $before = $scrubbed[0..$idx]
    $after = if ($idx + 1 -lt $scrubbed.Count) { $scrubbed[($idx + 1)..($scrubbed.Count - 1)] } else { @() }
    $next = @($before + $Lines + $after)

    if (($next.Count -ne $existing.Count) -or (Compare-Object -ReferenceObject $existing -DifferenceObject $next)) {
        $next | Set-Content -LiteralPath $script:AnvilModlist
        Write-Host "Modlist updated (WSU/MLO2 stack block after BOS anchor, $($Lines.Count) lines)."
    }
    else {
        Write-Host 'Modlist stack block already correct after BOS anchor.'
    }
}

function Write-ProfileSnapshot {
    param([string]$Label)

    $exports = Join-Path (Split-Path $PSScriptRoot -Parent) 'modlist\exports'
    if (-not (Test-Path -LiteralPath $exports)) {
        New-Item -ItemType Directory -Path $exports -Force | Out-Null
    }

    $stamp = Get-Date -Format 'yyyy-MM-dd-HHmmss'
    $safeLabel = ($Label -replace '[^\w\-]', '-')
    $destDir = Join-Path $exports "$safeLabel-$stamp"
    New-Item -ItemType Directory -Path $destDir -Force | Out-Null

    Copy-Item -LiteralPath $script:AnvilModlist -Destination (Join-Path $destDir 'modlist.txt')
    Write-Host "Profile snapshot: modlist/exports/$safeLabel-$stamp/modlist.txt"
}

function Assert-WsuPostInstall {
    param([string[]]$ModlistLines)

    foreach ($line in $ModlistLines) {
        if (-not (Test-ModlistContains -Line $line)) {
            throw "Post-install check failed: modlist missing '$line' after Ensure-ModlistBlockAfterAnchor."
        }
    }

    Ensure-Mlo2Healthy -Repair:$true
    if (-not (Test-ModlistContains -Line $script:Mlo2ModlistLine)) {
        throw "Post-install check failed: modlist missing '$($script:Mlo2ModlistLine)'."
    }

    if (-not (Test-ModInstallHealth -ModFolder (Join-Path $script:AnvilMods 'True Light') `
            -RequiredEspLike @('TL Bulbs ISL.esp') `
            -RequiredRelativePaths @('LightPlacer\True Light.ini'))) {
        throw 'Post-install check failed: True Light (135488) incomplete under mods/True Light/.'
    }

    Write-Host 'Post-install checks passed (modlist lines + MLO.dll + True Light).'
}
