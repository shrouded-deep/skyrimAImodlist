#Requires -Version 5.1
<#
.SYNOPSIS
  task-0042: Per-city exterior expansion stack + Spaghetti AIO migration.

  Run after MO2 downloads required Nexus archives to Anvil/Downloads/:
    powershell -ExecutionPolicy Bypass -File scripts/install-city-overhaul-stack.ps1

  Closes MO2 (Assert-Mo2Closed), installs from archives, disables VPCE + FYX Riften Canal,
  migrates Spaghetti Cities AIO to modular ESPs, re-runs SB/Ivy/Lux FOMOD selections,
  places new mods in [Successor Additions], MAST-scans active plugins.
#>
param(
    [switch]$SkipInstall,
    [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'
. "$PSScriptRoot/Mo2ProfileGuardrails.ps1"

$ProfileDir = Join-Path $script:AnvilRoot "profiles\$script:AnvilProfile"
$pluginsPath = Join-Path $ProfileDir 'plugins.txt'
$loadorderPath = Join-Path $ProfileDir 'loadorder.txt'
$successorSepLine = '+[Successor Additions]_separator'
$finishingSep = '---- FINISHING LINE ---_separator'

# --- Mod catalog (Nexus mod ID -> folder name) ---
$CityMods = @(
    @{ Id = '37982'; Folder = 'Capital Whiterun Expansion'; Esp = "Capital Whiterun Expansion.esp" }
    @{ Id = '42990'; Folder = 'Capital Windhelm Expansion'; Esp = 'Capital Windhelm.esp' }
    @{ Id = '66024'; Folder = 'Ultimate Markarth'; Esp = 'Ultimate Markarth.esp' }
    @{ Id = '153484'; Folder = 'Ultimate Markarth Expanded'; Esp = 'Ultimate Markarth Expanded.esp' }
    @{ Id = '42052'; Folder = "RedBag's Solitude"; Esp = "RedBag's Solitude.esp" }
    @{ Id = '168629'; Folder = 'City of Crossed Daggers - Riften Expansion'; Esp = 'City of Crossed Daggers.esp' }
    @{ Id = '146520'; Folder = 'Riverwood Has Walls'; Esp = 'Riverwood Has Walls.esp' }
)

$PatchMods = @(
    @{ Id = '63355'; Folder = "Rob's Bug Fixes - Capital Whiterun"; EspLike = @('*CWE*', '*Capital Whiterun*') }
    @{ Id = '116487'; Folder = 'CWE Spaghetti Patch'; EspLike = @('*Spaghetti*', '*CWE*') }
    @{ Id = '154715'; Folder = "Spaghetti's Capital Windhelm Expansion"; EspLike = @('*Windhelm*') }
    @{ Id = '155426'; Folder = 'UME Patch Hub'; EspLike = @('*UME*', '*Markarth*') }
    @{ Id = '51450'; Folder = 'RedBag Patch Collection'; EspLike = @('*RedBag*', '*Spaghetti*') }
    @{ Id = '147419'; Folder = 'Riverwood Has Walls Patch Collection'; EspLike = @('*Riverwood*', '*Spaghetti*') }
)

$SpaghettiModular = @(
    @{ Id = '80778'; Folder = "Spaghetti's Cities - Whiterun"; Esp = "Spaghetti's Cities - Whiterun.esp"; Hold = 'Whiterun' }
    @{ Id = '82820'; Folder = "Spaghetti's Cities - Windhelm"; Esp = "Spaghetti's Cities - Windhelm.esp"; Hold = 'Windhelm' }
    @{ Id = '81200'; Folder = "Spaghetti's Cities - Markarth"; Esp = "Spaghetti's Cities - Markarth.esp"; Hold = 'Markarth' }
    @{ Id = '80986'; Folder = "Spaghetti's Cities - Solitude"; Esp = "Spaghetti's Cities - Solitude.esp"; Hold = 'Solitude' }
    @{ Id = '82228'; Folder = "Spaghetti's Cities - Riften"; Esp = "Spaghetti's Cities - Riften.esp"; Hold = 'Riften' }
    @{ Id = '85356'; Folder = "Spaghetti's Towns - Riverwood"; Esp = "Spaghetti's Towns - Riverwood.esp"; Hold = 'Riverwood' }
)

$DisableMods = @(
    'Vanilla Plus City Entrances'
    'FYX - Riften Canal and Round Posts'
)

$script:InstallLog = [System.Collections.Generic.List[string]]::new()
$script:MissingDownloads = [System.Collections.Generic.List[string]]::new()

function Write-Log([string]$Message) {
    Write-Host $Message
    [void]$script:InstallLog.Add($Message)
}

function Read-ActivePluginNames([string]$Path) {
    Get-Content -LiteralPath $Path -Encoding UTF8 |
        Where-Object { $_ -match '^\*(.+\.(esp|esm|esl))$' } |
        ForEach-Object { if ($_ -match '^\*(.+)$') { $Matches[1] } }
}

function Get-PluginMasters([string]$FilePath) {
    $bytes = [System.IO.File]::ReadAllBytes($FilePath)
    $masters = [System.Collections.Generic.List[string]]::new()
    $i = 0
    while ($i -lt ($bytes.Length - 4)) {
        if ($bytes[$i] -eq 77 -and $bytes[$i + 1] -eq 65 -and $bytes[$i + 2] -eq 83 -and $bytes[$i + 3] -eq 84) {
            $i += 4
            if ($i + 2 -gt $bytes.Length) { break }
            $len = $bytes[$i] + ($bytes[$i + 1] -shl 8)
            $i += 2
            if ($len -gt 0 -and ($i + $len) -le $bytes.Length) {
                [void]$masters.Add([System.Text.Encoding]::ASCII.GetString($bytes, $i, $len))
            }
            $i += $len
            continue
        }
        $i++
    }
    return $masters
}

function Invoke-MastScan {
    $pluginIndex = @{}
    Get-ChildItem -LiteralPath $script:AnvilMods -Recurse -Include *.esp, *.esm, *.esl -File -ErrorAction SilentlyContinue |
        ForEach-Object {
            $key = $_.Name.ToLowerInvariant()
            if (-not $pluginIndex.ContainsKey($key)) { $pluginIndex[$key] = $_.FullName }
        }

    $gameMasters = @(
        'skyrim.esm', 'update.esm', 'dawnguard.esm', 'hearthfires.esm', 'dragonborn.esm',
        'ccbgssse001-fish.esm', 'ccqdrsse001-survivalmode.esl', 'ccbgssse037-curios.esl',
        'ccbgssse025-advdsgs.esm', '_resourcepack.esl'
    )

    $active = @(Read-ActivePluginNames $pluginsPath)
    $available = @{}
    foreach ($k in $pluginIndex.Keys) { $available[$k] = $true }
    foreach ($p in $active) { $available[$p.ToLowerInvariant()] = $true }
    foreach ($g in $gameMasters) { $available[$g] = $true }

    $missing = @()
    foreach ($p in $active) {
        $path = $pluginIndex[$p.ToLowerInvariant()]
        if (-not $path) {
            $missing += [pscustomobject]@{ Plugin = $p; Master = '(plugin file not found)'; Path = '' }
            continue
        }
        foreach ($m in (Get-PluginMasters $path)) {
            if (-not $available.ContainsKey($m.ToLowerInvariant())) {
                $missing += [pscustomobject]@{ Plugin = $p; Master = $m; Path = $path }
            }
        }
    }

    return @{ Active = $active.Count; Missing = $missing }
}

function Set-ModEnabledState {
    param(
        [string[]]$ModlistLines,
        [string[]]$ModNames,
        [bool]$Enable
    )
    $prefix = if ($Enable) { '+' } else { '-' }
    foreach ($name in $ModNames) {
        $pos = "+$name"
        $neg = "-$name"
        $idx = [array]::IndexOf($ModlistLines, $neg)
        if ($idx -ge 0) {
            if ($Enable) { $ModlistLines[$idx] = $pos }
        }
        else {
            $idx = [array]::IndexOf($ModlistLines, $pos)
            if ($idx -ge 0) {
                if (-not $Enable) { $ModlistLines[$idx] = $neg }
            }
            elseif ($Enable) {
                throw "Mod not found in modlist.txt: $name"
            }
        }
    }
    return $ModlistLines
}

function Remove-PluginsFromProfile {
    param([string[]]$PluginNames)
    $plugins = @(Get-Content -LiteralPath $pluginsPath -Encoding UTF8)
    $loadorder = @(Get-Content -LiteralPath $loadorderPath -Encoding UTF8)
    $removed = @()
    foreach ($pl in $PluginNames) {
        $star = "*$pl"
        if ($plugins -contains $star) {
            $plugins = @($plugins | Where-Object { $_ -ne $star })
            $removed += $pl
        }
        if ($loadorder -contains $pl) {
            $loadorder = @($loadorder | Where-Object { $_ -ne $pl })
        }
    }
    if ($removed.Count -gt 0 -and -not $WhatIf) {
        $plugins | Set-Content -LiteralPath $pluginsPath -Encoding UTF8
        $loadorder | Set-Content -LiteralPath $loadorderPath -Encoding UTF8
    }
    return $removed
}

function Add-PluginsToProfile {
    param(
        [string[]]$PluginNames,
        [string]$InsertAfter = 'Spaghetti''s Cities - AIO.esp'
    )
    $plugins = @(Get-Content -LiteralPath $pluginsPath -Encoding UTF8)
    $loadorder = @(Get-Content -LiteralPath $loadorderPath -Encoding UTF8 | Where-Object { $_ -notmatch '^\s*$' -or $_ -match '^#' })
    $loIdx = [array]::IndexOf($loadorder, $InsertAfter)
    if ($loIdx -lt 0) { $loIdx = [array]::IndexOf($loadorder, 'Lux.esp') }
    if ($loIdx -lt 0) { throw "Load order anchor not found for plugin insert." }

    $added = @()
    foreach ($pl in $PluginNames) {
        $star = "*$pl"
        if ($plugins -notcontains $star) { $plugins += $star; $added += $pl }
        if ($loadorder -notcontains $pl) { $added += $pl }
    }
    $toInsert = @($PluginNames | Where-Object { $loadorder -notcontains $_ } | Select-Object -Unique)
    if ($toInsert.Count -gt 0) {
        $loadorder = @($loadorder[0..$loIdx] + $toInsert + $loadorder[($loIdx + 1)..($loadorder.Length - 1)])
    }
    if ($added.Count -gt 0 -and -not $WhatIf) {
        $plugins | Set-Content -LiteralPath $pluginsPath -Encoding UTF8
        $loadorder | Set-Content -LiteralPath $loadorderPath -Encoding UTF8
    }
    return @($PluginNames | Where-Object { $plugins -contains "*$_" -or $added -contains $_ })
}

function Disable-PluginsInProfile {
    param([string[]]$PluginNames)
    $plugins = @(Get-Content -LiteralPath $pluginsPath -Encoding UTF8)
    $changed = $false
    for ($i = 0; $i -lt $plugins.Count; $i++) {
        foreach ($pl in $PluginNames) {
            if ($plugins[$i] -eq "*$pl") {
                $plugins[$i] = $pl
                $changed = $true
            }
        }
    }
    if ($changed -and -not $WhatIf) {
        $plugins | Set-Content -LiteralPath $pluginsPath -Encoding UTF8
    }
}

function Ensure-SuccessorModlistBlock {
    param([Parameter(Mandatory)][string[]]$NewModLines)

    $existing = @(Get-Content -LiteralPath $script:AnvilModlist -Encoding UTF8)
    $newNames = @($NewModLines | ForEach-Object { if ($_ -match '^[\+\-](.+)$') { $Matches[1] } })

    $scrubbed = @($existing | Where-Object {
            if ($_ -match '^[\+\-](.+)$') { return ($Matches[1] -notin $newNames) }
            return $true
        })

    $sepIdx = [array]::IndexOf($scrubbed, $successorSepLine)
    if ($sepIdx -lt 0) { throw "Successor separator not found: $successorSepLine" }

    $before = $scrubbed[0..($sepIdx - 1)]
    $after = if ($sepIdx -lt $scrubbed.Count) { $scrubbed[$sepIdx..($scrubbed.Count - 1)] } else { @($successorSepLine) }
    $next = @($before + $NewModLines + $after)

    if (-not $WhatIf) {
        $next | Set-Content -LiteralPath $script:AnvilModlist -Encoding UTF8
    }
    Write-Log "Successor block: $($NewModLines.Count) mod line(s) before separator."
}

function Install-SbWindhelmCweVariant {
    param([switch]$RequireCwePresent)

    $archive = Find-NexusArchive -ModId '73058'
    if (-not $archive) {
        [void]$script:MissingDownloads.Add('73058 SB Fixed Windhelm Entrance')
        return $false
    }

    $cweFolder = Join-Path $script:AnvilMods 'Capital Windhelm Expansion'
    $useCwe = (Test-Path -LiteralPath $cweFolder)
    if ($RequireCwePresent -and -not $useCwe) {
        Write-Log 'SB Fixed Windhelm (73058): CWE variant deferred — Capital Windhelm Expansion not installed (WindhelmSSE.esp master).'
        $useCwe = $false
    }

    $7z = Get-SevenZipPath
    $dest = Join-Path $script:AnvilMods 'SB - Fixed Windhelm Entrance'
    $metaPath = Join-Path $dest 'meta.ini'
    $savedMeta = if (Test-Path -LiteralPath $metaPath) { Get-Content -LiteralPath $metaPath -Raw } else { $null }

    $temp = Join-Path $env:TEMP "sb-windhelm-cwe-$(Get-Random)"
    New-Item -ItemType Directory -Path $temp -Force | Out-Null
    try {
        $espPath = if ($useCwe) {
            Write-Log 'SB Fixed Windhelm (73058): extracting Capital Windhelm variant + Lux Orbis patch.'
            'Main Version Capital Windhelm\SB_WindhelmEntrance.esp'
        } else {
            Write-Log 'SB Fixed Windhelm (73058): keeping Main Version ESP until Capital Windhelm Expansion is installed.'
            'Main Version\SB_WindhelmEntrance.esp'
        }

        & $7z x $archive.FullName "-o$temp" $espPath -y | Out-Null
        & $7z x $archive.FullName "-o$temp" 'Patches\SB_WindhelmEntrance_LuxOrbisPatch.esp' -y | Out-Null

        $folderName = if ($useCwe) { 'Main Version Capital Windhelm' } else { 'Main Version' }
        $espSrc = Join-Path $temp "$folderName\SB_WindhelmEntrance.esp"
        if (-not (Test-Path -LiteralPath $espSrc)) { throw "SB Windhelm ESP not found: $espPath" }

        New-Item -ItemType Directory -Path $dest -Force | Out-Null
        Get-ChildItem -LiteralPath $dest -Force | Where-Object { $_.Name -ne 'meta.ini' } | Remove-Item -Recurse -Force
        Copy-Item -LiteralPath $espSrc -Destination (Join-Path $dest 'SB_WindhelmEntrance.esp') -Force
        $luxPatch = Join-Path $temp 'Patches\SB_WindhelmEntrance_LuxOrbisPatch.esp'
        if (Test-Path -LiteralPath $luxPatch) {
            Copy-Item -LiteralPath $luxPatch -Destination (Join-Path $dest 'SB_WindhelmEntrance_LuxOrbisPatch.esp') -Force
        }
        if ($savedMeta) { Set-Content -LiteralPath $metaPath -Value $savedMeta -NoNewline }
        Write-Mo2MetaIniFromArchive -ModFolder $dest -Archive $archive
    }
    finally {
        if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Recurse -Force }
    }
    return $true
}

function Install-IvyCwePatch {
    $archive = Find-NexusArchive -ModId '125955'
    if (-not $archive) {
        [void]$script:MissingDownloads.Add('125955 Ivy - Whiterun Well Overhaul')
        return $false
    }

    $7z = Get-SevenZipPath
    $dest = Join-Path $script:AnvilMods 'Ivy - Whiterun Well Overhaul'
    $patchRel = "patches\Ivy - Whiterun - Well Overhaul - Capital Whiterun Patch.esp"
    $temp = Join-Path $env:TEMP "ivy-cwe-$(Get-Random)"
    New-Item -ItemType Directory -Path $temp -Force | Out-Null
    try {
        Write-Log 'Ivy Well (125955): adding Capital Whiterun (CWE) patch file.'
        & $7z x $archive.FullName "-o$temp" $patchRel -y | Out-Null
        $src = Join-Path $temp 'patches\Ivy - Whiterun - Well Overhaul - Capital Whiterun Patch.esp'
        if (-not (Test-Path -LiteralPath $src)) { throw 'Ivy CWE patch not found in archive.' }
        New-Item -ItemType Directory -Path $dest -Force | Out-Null
        Copy-Item -LiteralPath $src -Destination (Join-Path $dest 'Ivy - Whiterun - Well Overhaul - Capital Whiterun Patch.esp') -Force
    }
    finally {
        if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Recurse -Force }
    }
    return $true
}

function Install-LuxCityPatchHubSlices {
    $archive = Find-NexusArchive -ModId '113002'
    if (-not $archive) {
        $archive = Get-ChildItem -LiteralPath $script:AnvilDownloads -File | Where-Object {
            $_.Name -match '-113002-' -and $_.Extension -match '\.(zip|7z|rar)$'
        } | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    }
    if (-not $archive) {
        [void]$script:MissingDownloads.Add('113002 Lux Patch Hub')
        return @()
    }

    $7z = Get-SevenZipPath
    $dest = Join-Path $script:AnvilMods 'Lux - Patch Hub'
    New-Item -ItemType Directory -Path $dest -Force | Out-Null

    $paths = @(
        'Lux (patch hub)\00 Data\Lux - Capital Whiterun patch.esp'
        'Lux (patch hub)\00 Data\Lux - RedBag''s Solitude patch.esp'
        'Lux (patch hub)\00 Data\Great City of JK''s Redbag Solitude patch.esp'
    )

    $temp = Join-Path $env:TEMP "lux-hub-city-$(Get-Random)"
    New-Item -ItemType Directory -Path $temp -Force | Out-Null
    $installed = @()
    try {
        Write-Log 'Lux Patch Hub (113002): staging Capital Whiterun + RedBag Solitude patch ESPs.'
        foreach ($p in $paths) {
            & $7z x $archive.FullName "-o$temp" $p -y 2>$null | Out-Null
        }
        $candidates = Get-ChildItem -LiteralPath $temp -Recurse -Filter '*.esp' -File -ErrorAction SilentlyContinue
        foreach ($esp in $candidates) {
            $target = Join-Path $dest $esp.Name
            Copy-Item -LiteralPath $esp.FullName -Destination $target -Force
            $installed += $esp.Name
        }
    }
    finally {
        if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Recurse -Force }
    }
    return @($installed | Select-Object -Unique)
}

function Test-UmePatchHubSpaghettiMarkarth {
    param($Archive)
    $7z = Get-SevenZipPath
    $temp = Join-Path $env:TEMP "ume-hub-inspect-$(Get-Random)"
    New-Item -ItemType Directory -Path $temp -Force | Out-Null
    try {
        & $7z x $Archive.FullName "-o$temp" -y | Out-Null
        $hits = @(Get-ChildItem -LiteralPath $temp -Recurse -File -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -match 'Spaghetti|81200|Markarth' })
        $espHits = @($hits | Where-Object { $_.Extension -eq '.esp' })
        return @{
            Covered     = ($espHits.Count -gt 0)
            EspNames    = @($espHits | ForEach-Object { $_.Name })
            AllMatches  = @($hits | ForEach-Object { $_.FullName.Replace($temp, '') })
        }
    }
    finally {
        if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Recurse -Force }
    }
}

function Install-ArchiveMod {
    param(
        $Entry,
        [string[]]$EspLikePatterns = @(),
        [string]$RequiredEsp = ''
    )
    $archive = Find-NexusArchive -ModId $Entry.Id
    if (-not $archive) {
        [void]$script:MissingDownloads.Add("$($Entry.Id) $($Entry.Folder)")
        return $false
    }

    $patterns = if ($RequiredEsp) { @($RequiredEsp) } elseif ($Entry.Esp) { @($Entry.Esp) } else { $EspLikePatterns }
    Install-ModFromArchive -Archive $archive -FolderName $Entry.Folder `
        -EspLikePatterns $patterns -MinFileCount 1
    Write-Log "Installed $($Entry.Folder) ($($Entry.Id)) from $($archive.Name)"
    return $true
}

function Migrate-SpaghettiToModular {
    param([bool]$KeepMarkarth = $true)

    $installed = @()
    foreach ($m in $SpaghettiModular) {
        if (-not $KeepMarkarth -and $m.Hold -eq 'Markarth') { continue }
        if (Install-ArchiveMod -Entry $m -RequiredEsp $m.Esp) { $installed += $m }
    }

    if ($installed.Count -eq 0) {
        Write-Log 'Spaghetti modular migration: no modular archives in Downloads — skipped.'
        return @{ Migrated = $false; Installed = @(); DisabledAio = $false }
    }

    $newPlugins = @($installed | ForEach-Object { $_.Esp })
    $citySlices = @($installed | Where-Object { $_.Hold -ne 'Riverwood' })
    $riverwoodSlice = @($installed | Where-Object { $_.Hold -eq 'Riverwood' })

    foreach ($m in $installed) {
        [void]$successorLines.Add("+$($m.Folder)")
    }

    if ($citySlices.Count -ge 5 -and $riverwoodSlice.Count -ge 1) {
        Disable-PluginsInProfile -PluginNames @(
            "Spaghetti's Cities - AIO.esp"
            "Spaghetti's Cities - AIO - NavCuts.esp"
        )
        Add-PluginsToProfile -PluginNames $newPlugins | Out-Null
        Write-Log "Spaghetti migration: enabled $($newPlugins.Count) modular ESP(s); AIO disabled."
        return @{
            Migrated    = $true
            Installed   = $installed
            DisabledAio = $true
            DisableAioMod = $true
        }
    }

    Write-Log 'Spaghetti migration: partial modular set — AIO left enabled until all city slices present.'
    return @{ Migrated = $false; Installed = $installed; DisabledAio = $false; DisableAioMod = $false }
}

# --- Main ---
Write-Host '=== City overhaul stack install (task-0042) ==='
Assert-Mo2Closed
Write-Log '[preflight] MO2 closed.'

$modlist = @(Get-Content -LiteralPath $script:AnvilModlist -Encoding UTF8)
$successorLines = [System.Collections.Generic.List[string]]::new()

# Disable VPCE + FYX Riften Canal
$modlist = Set-ModEnabledState -ModlistLines $modlist -ModNames $DisableMods -Enable $false
$removedVpce = Remove-PluginsFromProfile -PluginNames @('Vanilla Plus City Entrances.esp')
Write-Log "Disabled: $($DisableMods -join ', '). Removed VPCE plugin: $($removedVpce -join ', ')."

# FOMOD re-runs (archives on disk)
$sbOk = Install-SbWindhelmCweVariant -RequireCwePresent
$ivyOk = Install-IvyCwePatch
$luxPatches = Install-LuxCityPatchHubSlices

# Install city + patch mods when archives present
if (-not $SkipInstall) {
    foreach ($c in $CityMods) {
        if (Install-ArchiveMod -Entry $c) {
            [void]$successorLines.Add("+$($c.Folder)")
        }
    }
    foreach ($p in $PatchMods) {
        if (Install-ArchiveMod -Entry $p -EspLikePatterns $p.EspLike) {
            [void]$successorLines.Add("+$($p.Folder)")
        }
    }
}

# UME Patch Hub FOMOD inspection
$umeArchive = Find-NexusArchive -ModId '155426'
$umeInspection = @{ Covered = $false; EspNames = @(); Note = 'UME Patch Hub archive not in Downloads.' }
if ($umeArchive) {
    $umeInspection = Test-UmePatchHubSpaghettiMarkarth -Archive $umeArchive
    $umeInspection.Note = if ($umeInspection.Covered) {
        "Spaghetti Markarth covered: $($umeInspection.EspNames -join ', ')"
    } else {
        'No Spaghetti Markarth patch found in UME Patch Hub — drop modular Markarth at migration.'
    }
    Write-Log "UME Patch Hub inspection: $($umeInspection.Note)"
}

$keepMarkarth = $umeInspection.Covered
$migration = Migrate-SpaghettiToModular -KeepMarkarth:$keepMarkarth
if ($migration.DisableAioMod) {
    $modlist = Set-ModEnabledState -ModlistLines $modlist -ModNames @("Spaghetti's Cities - AIO") -Enable $false
    foreach ($m in $migration.Installed) {
        $modlist = Set-ModEnabledState -ModlistLines $modlist -ModNames @($m.Folder) -Enable $true
    }
}
elseif (-not $keepMarkarth) {
    Write-Log "Spaghetti Markarth: modular slice skipped (UME hub lacks coverage)."
}

# Place new mods in Successor Additions (dedupe, preserve order: cities then patches)
if ($successorLines.Count -gt 0) {
    Ensure-SuccessorModlistBlock -NewModLines @($successorLines | Select-Object -Unique)
    $modlist = @(Get-Content -LiteralPath $script:AnvilModlist -Encoding UTF8)
}

# Persist disable lines
if (-not $WhatIf) {
    $modlist | Set-Content -LiteralPath $script:AnvilModlist -Encoding UTF8
}

# Enable city plugins only when mod folders exist
$cityPlugins = @(
    @{ Mod = 'Capital Whiterun Expansion'; Plugins = @('Capital Whiterun Expansion.esp') }
    @{ Mod = 'Capital Windhelm Expansion'; Plugins = @('Capital Windhelm.esp') }
    @{ Mod = 'Ultimate Markarth'; Plugins = @('Ultimate Markarth.esp') }
    @{ Mod = 'Ultimate Markarth Expanded'; Plugins = @('Ultimate Markarth Expanded.esp') }
    @{ Mod = "RedBag's Solitude"; Plugins = @("RedBag's Solitude.esp") }
    @{ Mod = 'City of Crossed Daggers - Riften Expansion'; Plugins = @('City of Crossed Daggers.esp') }
    @{ Mod = 'Riverwood Has Walls'; Plugins = @('Riverwood Has Walls.esp') }
)
$enabledCityPlugins = @()
foreach ($c in $cityPlugins) {
    $folder = Join-Path $script:AnvilMods $c.Mod
    if (Test-Path -LiteralPath $folder) {
        $enabledCityPlugins += Add-PluginsToProfile -PluginNames $c.Plugins
    }
}

# Ivy CWE patch — enable only when CWE installed
if ($ivyOk -and (Test-Path -LiteralPath (Join-Path $script:AnvilMods 'Capital Whiterun Expansion'))) {
    [void](Add-PluginsToProfile -PluginNames @('Ivy - Whiterun - Well Overhaul - Capital Whiterun Patch.esp'))
    Write-Log 'Ivy CWE patch plugin enabled (CWE present).'
}
elseif ($ivyOk) {
    Write-Log 'Ivy CWE patch file staged; plugin left disabled until Capital Whiterun Expansion is installed.'
}

# Lux city patches — enable when masters present
foreach ($lp in $luxPatches) {
    $hubPath = Join-Path (Join-Path $script:AnvilMods 'Lux - Patch Hub') $lp
    if (-not (Test-Path -LiteralPath $hubPath)) { continue }
    $masters = Get-PluginMasters $hubPath
    $lo = @(Read-ActivePluginNames $pluginsPath) + @(Get-ChildItem $script:AnvilMods -Recurse -Include *.esp,*.esm,*.esl -File | ForEach-Object { $_.Name })
    $ok = $true
    foreach ($m in $masters) {
        if ($lo -notcontains $m) { $ok = $false; break }
    }
    if ($ok) {
        Add-PluginsToProfile -PluginNames @($lp) -InsertAfter 'Lux.esp' | Out-Null
        Write-Log "Lux hub patch enabled: $lp"
    }
    else {
        Write-Log "Lux hub patch staged (disabled until masters present): $lp"
    }
}

Write-ProfileSnapshot -Label 'task-0042-city-stack'

$mast = Invoke-MastScan
Write-Host ''
Write-Host "Active plugins: $($mast.Active)"
Write-Host "Missing master refs: $($mast.Missing.Count)"
if ($mast.Missing.Count -gt 0) {
    $mast.Missing | Sort-Object Plugin, Master | Format-Table -AutoSize | Out-String | Write-Host
}

if ($script:MissingDownloads.Count -gt 0) {
    Write-Host ''
    Write-Host 'MISSING DOWNLOADS — install via MO2/Nexus then re-run this script:'
    $script:MissingDownloads | Sort-Object -Unique | ForEach-Object { Write-Host "  $_" }
}

$result = @{
    MissingDownloads   = @($script:MissingDownloads | Select-Object -Unique)
    SbCweVariant       = $sbOk
    IvyCwePatch        = $ivyOk
    LuxPatchesStaged   = $luxPatches
    UmeInspection      = $umeInspection
    KeepMarkarth       = $keepMarkarth
    SpaghettiMigration = $migration
    MastMissing        = $mast.Missing.Count
    Log                = @($script:InstallLog)
}

if ($mast.Missing.Count -gt 0) { exit 2 }
exit 0
