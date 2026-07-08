#Requires -Version 5.1
<#
.SYNOPSIS
  task-0043: JK's non-city ecosystem + Ryn's series install.

  Run after MO2 downloads required Nexus archives to Anvil/Downloads/:
    powershell -ExecutionPolicy Bypass -File scripts/install-jk-ryn-stack.ps1

  Assert-Mo2Closed, installs from archives with FOMOD flattening, enables UME
  JK Understone patches when JK's Understone Keep is present, places mods in
  [Successor Additions], MAST-scans active plugins.
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

$script:InstallLog = [System.Collections.Generic.List[string]]::new()
$script:MissingDownloads = [System.Collections.Generic.List[string]]::new()
$script:InstalledFolders = [System.Collections.Generic.List[string]]::new()
$script:FomodChoices = [System.Collections.Generic.List[string]]::new()

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
                [void]$masters.Add([System.Text.Encoding]::ASCII.GetString($bytes, $i, $len).TrimEnd([char]0))
            }
            $i += $len
            continue
        }
        $i++
    }
    return $masters
}

function Get-AvailablePluginSet {
    param([switch]$ActiveOnly)

    $gameMasters = @(
        'skyrim.esm', 'update.esm', 'dawnguard.esm', 'hearthfires.esm', 'dragonborn.esm',
        'ccbgssse001-fish.esm', 'ccqdrsse001-survivalmode.esl', 'ccbgssse037-curios.esl',
        'ccbgssse025-advdsgs.esm', '_resourcepack.esl'
    )

    $set = @{}
    foreach ($g in $gameMasters) { $set[$g.ToLowerInvariant()] = $true }

    if (-not $ActiveOnly) {
        Get-ChildItem -LiteralPath $script:AnvilMods -Recurse -Include *.esp, *.esm, *.esl -File -ErrorAction SilentlyContinue |
            ForEach-Object { $set[$_.Name.ToLowerInvariant()] = $true }
    }

    foreach ($p in (Read-ActivePluginNames $pluginsPath)) {
        $set[$p.ToLowerInvariant()] = $true
    }

    return $set
}

function Test-PluginMastersAvailable {
    param(
        [Parameter(Mandatory)][string]$PluginPath,
        [hashtable]$Available
    )
    foreach ($m in (Get-PluginMasters $PluginPath)) {
        if (-not $Available.ContainsKey($m.ToLowerInvariant())) { return $false }
    }
    return $true
}

function Invoke-MastScan {
    $pluginIndex = @{}
    Get-ChildItem -LiteralPath $script:AnvilMods -Recurse -Include *.esp, *.esm, *.esl -File -ErrorAction SilentlyContinue |
        ForEach-Object {
            $key = $_.Name.ToLowerInvariant()
            if (-not $pluginIndex.ContainsKey($key)) { $pluginIndex[$key] = $_.FullName }
        }

    $available = Get-AvailablePluginSet
    $active = @(Read-ActivePluginNames $pluginsPath)
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

function Find-NexusArchivePrefer {
    param(
        [Parameter(Mandatory)][string]$ModId,
        [string]$NameLike = ''
    )
    $candidates = @(Get-ChildItem -LiteralPath $script:AnvilDownloads -File -ErrorAction SilentlyContinue | Where-Object {
            $_.Name -match "-$([regex]::Escape($ModId))-" -and $_.Extension -match '\.(zip|7z|rar)$'
        })
    if ($NameLike) {
        $filtered = @($candidates | Where-Object { $_.Name -match $NameLike })
        if ($filtered.Count -gt 0) { $candidates = $filtered }
    }
    $candidates | Sort-Object LastWriteTime -Descending | Select-Object -First 1
}

function Find-AllNexusArchives {
    param([Parameter(Mandatory)][string]$ModId)
    @(Get-ChildItem -LiteralPath $script:AnvilDownloads -File -ErrorAction SilentlyContinue | Where-Object {
            $_.Name -match "-$([regex]::Escape($ModId))-" -and $_.Extension -match '\.(zip|7z|rar)$'
        } | Sort-Object Name)
}

function Install-SimpleMod {
    param(
        [Parameter(Mandatory)][hashtable]$Entry
    )

    $archive = Find-NexusArchive -ModId $Entry.Id
    if (-not $archive) {
        [void]$script:MissingDownloads.Add("$($Entry.Id) $($Entry.Folder)")
        return $false
    }

    $patterns = if ($Entry.EspLike) { @($Entry.EspLike) } else { @('*.esp') }
    if (-not $WhatIf) {
        Install-ModFromArchive -Archive $archive -FolderName $Entry.Folder `
            -EspLikePatterns $patterns -MinFileCount 1
        Write-Mo2MetaIniFromArchive -ModFolder (Join-Path $script:AnvilMods $Entry.Folder) -Archive $archive
    }
    Write-Log "Installed $($Entry.Folder) ($($Entry.Id)) from $($archive.Name)"
    [void]$script:InstalledFolders.Add($Entry.Folder)
    return $true
}

function Install-HubFlatten {
    param(
        [Parameter(Mandatory)][string]$ModId,
        [Parameter(Mandatory)][string]$FolderName,
        [string]$LogLabel = '',
        [string[]]$RelativeExtractPaths = @(),
        [switch]$AllPlugins
    )

    $archive = Find-NexusArchive -ModId $ModId
    if (-not $archive) {
        [void]$script:MissingDownloads.Add("$ModId $FolderName")
        return @()
    }

    $7z = Get-SevenZipPath
    $dest = Join-Path $script:AnvilMods $FolderName
    $temp = Join-Path $env:TEMP "jk-ryn-hub-$ModId-$(Get-Random)"
    New-Item -ItemType Directory -Path $temp -Force | Out-Null
    $copied = @()

    try {
        $label = if ($LogLabel) { $LogLabel } else { "$FolderName ($ModId)" }
        Write-Log "$label : extracting patch hub."
        if ($RelativeExtractPaths.Count -gt 0) {
            foreach ($p in $RelativeExtractPaths) {
                & $7z x $archive.FullName "-o$temp" $p -y 2>$null | Out-Null
            }
        }
        else {
            & $7z x $archive.FullName "-o$temp" -y | Out-Null
        }

        if (-not $WhatIf) {
            New-Item -ItemType Directory -Path $dest -Force | Out-Null
        }

        $pluginFiles = if ($AllPlugins) {
            @(Get-ChildItem -LiteralPath $temp -Recurse -Include *.esp, *.esl -File -ErrorAction SilentlyContinue)
        }
        else {
            @(Get-ChildItem -LiteralPath $temp -Recurse -Filter '*.esp' -File -ErrorAction SilentlyContinue)
        }

        foreach ($esp in $pluginFiles) {
            if ($esp.FullName -match '\\fomod\\|\\docs\\|\\screenshots\\') { continue }
            $target = Join-Path $dest $esp.Name
            if (-not $WhatIf) {
                Copy-Item -LiteralPath $esp.FullName -Destination $target -Force
            }
            $copied += $esp.Name
        }

        if (-not $WhatIf) {
            Write-Mo2MetaIniFromArchive -ModFolder $dest -Archive $archive
        }
        [void]$script:InstalledFolders.Add($FolderName)
        [void]$script:FomodChoices.Add("$label -> $($copied.Count) plugin(s) flattened to mod root")
    }
    finally {
        if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Recurse -Force }
    }

    return @($copied | Select-Object -Unique)
}

function Install-RynDragonMounds {
    $archive = Find-NexusArchive -ModId '85647'
    if (-not $archive) {
        [void]$script:MissingDownloads.Add("85647 Ryn's Dragon Mounds Collection")
        return $false
    }

    $7z = Get-SevenZipPath
    $dest = Join-Path $script:AnvilMods "Ryn's Dragon Mounds Collection"
    $temp = Join-Path $env:TEMP "ryn-dragon-mounds-$(Get-Random)"
    New-Item -ItemType Directory -Path $temp -Force | Out-Null

    try {
        Write-Log "Ryn's Dragon Mounds (85647): FOMOD install all ESL modules."
        & $7z x $archive.FullName "-o$temp" -y | Out-Null
        $esls = @(Get-ChildItem -LiteralPath $temp -Recurse -Filter '*.esl' -File -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -notmatch '\\fomod\\' })
        if ($esls.Count -lt 1) { throw 'No ESL files found in 85647 archive.' }

        if (-not $WhatIf) {
            New-Item -ItemType Directory -Path $dest -Force | Out-Null
            foreach ($esl in $esls) {
                Copy-Item -LiteralPath $esl.FullName -Destination (Join-Path $dest $esl.Name) -Force
            }
            Write-Mo2MetaIniFromArchive -ModFolder $dest -Archive $archive
        }
        [void]$script:InstalledFolders.Add("Ryn's Dragon Mounds Collection")
        [void]$script:FomodChoices.Add("85647 Ryn's Dragon Mounds -> all $($esls.Count) ESL(s)")
    }
    finally {
        if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Recurse -Force }
    }
    return $true
}

function Enable-PluginsWithMasterCheck {
    param(
        [Parameter(Mandatory)][string[]]$PluginNames,
        [string]$InsertAfter = 'Lux.esp'
    )

    $plugins = @(Get-Content -LiteralPath $pluginsPath -Encoding UTF8)
    $loadorder = @(Get-Content -LiteralPath $loadorderPath -Encoding UTF8 | Where-Object { $_ -notmatch '^\s*$' -or $_ -match '^#' })
    $available = Get-AvailablePluginSet
    $enabled = @()
    $deferred = @()

    $loIdx = [array]::IndexOf($loadorder, $InsertAfter)
    if ($loIdx -lt 0) { $loIdx = [array]::IndexOf($loadorder, 'Requiem for the Indifferent.esp') }
    if ($loIdx -lt 0) { $loIdx = $loadorder.Count - 1 }

    foreach ($pl in ($PluginNames | Select-Object -Unique)) {
        $hit = Get-ChildItem -LiteralPath $script:AnvilMods -Recurse -Filter $pl -File -ErrorAction SilentlyContinue | Select-Object -First 1
        if (-not $hit) { continue }

        if (-not (Test-PluginMastersAvailable -PluginPath $hit.FullName -Available $available)) {
            $deferred += $pl
            $star = "*$pl"
            if ($plugins -contains $star) {
                $plugins = @($plugins | ForEach-Object { if ($_ -eq $star) { $pl } else { $_ } })
            }
            continue
        }

        $star = "*$pl"
        if ($plugins -notcontains $star) { $plugins += $star }
        if ($loadorder -notcontains $pl) {
            $loadorder = @($loadorder[0..$loIdx] + $pl + $loadorder[($loIdx + 1)..($loadorder.Length - 1)])
            $loIdx++
        }
        $enabled += $pl
    }

    if (-not $WhatIf) {
        $plugins | Set-Content -LiteralPath $pluginsPath -Encoding UTF8
        $loadorder | Set-Content -LiteralPath $loadorderPath -Encoding UTF8
    }

    foreach ($e in $enabled) { Write-Log "Enabled plugin: $e" }
    foreach ($d in $deferred) { Write-Log "Deferred plugin (missing masters): $d" }

    return @{ Enabled = $enabled; Deferred = $deferred }
}

function Enable-UmeUnderstonePatches {
    $jkFolder = Join-Path $script:AnvilMods "JK's Understone Keep"
    $jkEsp = Join-Path $jkFolder "JK's Understone Keep.esp"
    if (-not (Test-Path -LiteralPath $jkEsp)) {
        Write-Log 'UME JK Understone patches deferred: JK''s Understone Keep (55571) not installed.'
        return @()
    }

    $umeHub = Join-Path $script:AnvilMods 'UME Patch Hub'
    $targets = @(
        "Markarth Expanded - JK's Understone Keep.esp",
        "Markarth Expanded - PCE - JK's Understone Keep.esp"
    )
    $present = @($targets | Where-Object { Test-Path -LiteralPath (Join-Path $umeHub $_) })
    if ($present.Count -eq 0) {
        Write-Log 'UME JK Understone patch ESPs not found in UME Patch Hub folder.'
        return @()
    }

    $result = Enable-PluginsWithMasterCheck -PluginNames $present -InsertAfter 'Ultimate Markarth Expanded.esp'
    [void]$script:FomodChoices.Add("UME Patch Hub -> enabled JK Understone patches: $($result.Enabled -join ', ')")
    return $result.Enabled
}

function Enable-HubPluginsFromFolder {
    param(
        [Parameter(Mandatory)][string]$FolderName,
        [string]$InsertAfter = 'Lux.esp'
    )

    $folder = Join-Path $script:AnvilMods $FolderName
    if (-not (Test-Path -LiteralPath $folder)) { return @() }

    $names = @(Get-ChildItem -LiteralPath $folder -Include *.esp, *.esl -File -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Name)
    if ($names.Count -eq 0) { return @() }

    $result = Enable-PluginsWithMasterCheck -PluginNames $names -InsertAfter $InsertAfter
    return $result.Enabled
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

# --- Mod catalog ---
$JkInteriors35910 = @(
    @{ Id = '44482'; Folder = "JK's Angeline's Aromatics"; EspLike = @("*Angeline*") }
    @{ Id = '33565'; Folder = "JK's Arcadia's Cauldron"; EspLike = @("*Arcadia*") }
    @{ Id = '54166'; Folder = "JK's Arnleif and Sons Trading Company"; EspLike = @("*Arnleif*") }
    @{ Id = '33636'; Folder = "JK's Belethor's General Goods"; EspLike = @("*Belethor*") }
    @{ Id = '44642'; Folder = "JK's Bits and Pieces"; EspLike = @("*Bits and Pieces*") }
    @{ Id = '49934'; Folder = "JK's Elgrim's Elixirs"; EspLike = @("*Elgrim*") }
    @{ Id = '60085'; Folder = "JK's Haelga's Bunkhouse"; EspLike = @("*Haelga*") }
    @{ Id = '48293'; Folder = "JK's New Gnisis Cornerclub"; EspLike = @("*Gnisis*") }
    @{ Id = '161218'; Folder = "JK's Nightgate Inn"; EspLike = @("*Nightgate*") }
    @{ Id = '44858'; Folder = "JK's Radiant Raiment"; EspLike = @("*Radiant Raiment*") }
    @{ Id = '47942'; Folder = "JK's Sadri's Used Wares"; EspLike = @("*Sadri*") }
    @{ Id = '53554'; Folder = "JK's Silver-Blood Inn"; EspLike = @("*Silver-Blood*") }
    @{ Id = '33845'; Folder = "JK's The Bannered Mare"; EspLike = @("*Bannered Mare*") }
    @{ Id = '49516'; Folder = "JK's The Bee and Barb"; EspLike = @("*Bee and Barb*") }
    @{ Id = '33783'; Folder = "JK's The Drunken Huntsman"; EspLike = @("*Drunken Huntsman*") }
    @{ Id = '54587'; Folder = "JK's The Hag's Cure"; EspLike = @("*Hag*Cure*") }
    @{ Id = '50135'; Folder = "JK's The Pawned Prawn"; EspLike = @("*Pawned Prawn*") }
    @{ Id = '50765'; Folder = "JK's The Ragged Flagon"; EspLike = @("*Ragged Flagon*") }
    @{ Id = '52724'; Folder = "JK's The Temple of Mara"; EspLike = @("*Temple of Mara*") }
    @{ Id = '43991'; Folder = "JK's The Winking Skeever"; EspLike = @("*Winking Skeever*") }
    @{ Id = '33685'; Folder = "JK's Warmaiden's"; EspLike = @("*Warmaiden*") }
    @{ Id = '47713'; Folder = "JK's White Phial"; EspLike = @("*White Phial*") }
    @{ Id = '45324'; Folder = "JK's Blue Palace"; EspLike = @("*Blue Palace*") }
    @{ Id = '45617'; Folder = "JK's Candlehearth Hall"; EspLike = @("*Candlehearth*") }
    @{ Id = '34000'; Folder = "JK's Dragonsreach"; EspLike = @("*Dragonsreach*") }
    @{ Id = '52462'; Folder = "JK's Mistveil Keep"; EspLike = @("*Mistveil*") }
    @{ Id = '48902'; Folder = "JK's Palace of the Kings"; EspLike = @("*Palace of the Kings*") }
    @{ Id = '56371'; Folder = "JK's Temple of Dibella"; EspLike = @("*Temple of Dibella*") }
    @{ Id = '56737'; Folder = "JK's Temple of Kynareth"; EspLike = @("*Temple of Kynareth*") }
    @{ Id = '56971'; Folder = "JK's Temple of Talos"; EspLike = @("*Temple of Talos*") }
    @{ Id = '57304'; Folder = "JK's Temple of the Divines"; EspLike = @("*Temple of the Divines*") }
    @{ Id = '55571'; Folder = "JK's Understone Keep"; EspLike = @("*Understone*") }
)

$JkGuild61416 = @(
    @{ Id = '74309'; Folder = "JK's Castle Dour"; EspLike = @("*Castle Dour*") }
    @{ Id = '116314'; Folder = "JK's Castle Volkihar"; EspLike = @("*Castle Volkihar*") }
    @{ Id = '65676'; Folder = "JK's College of Winterhold"; EspLike = @("*College of Winterhold*") }
    @{ Id = '121950'; Folder = "JK's Dark Brotherhood Sanctuaries"; EspLike = @("*Dark Brotherhood*") }
    @{ Id = '110645'; Folder = "JK's Fort Dawnguard"; EspLike = @("*Fort Dawnguard*") }
    @{ Id = '62219'; Folder = "JK's High Hrothgar"; EspLike = @("*High Hrothgar*") }
    @{ Id = '60738'; Folder = "JK's Jorrvaskr"; EspLike = @("*Jorrvaskr*") }
    @{ Id = '128116'; Folder = "JK's Nightingale Hall"; EspLike = @("*Nightingale Hall*") }
    @{ Id = '63039'; Folder = "JK's Sky Haven Temple"; EspLike = @("*Sky Haven*") }
    @{ Id = '71054'; Folder = "JK's The Bards College"; EspLike = @("*Bards College*") }
    @{ Id = '133787'; Folder = "JK's Thieves Guild HQ"; EspLike = @("*Thieves Guild*") }
)

$JkOutskirts = @(
    @{ Id = '78351'; Folder = "JK's Whiterun Outskirts"; EspLike = @("*Whiterun Outskirts*") }
    @{ Id = '86975'; Folder = "JK's Windhelm Outskirts"; EspLike = @("*Windhelm Outskirts*") }
    @{ Id = '90864'; Folder = "JK's Riften Outskirts"; EspLike = @("*Riften Outskirts*") }
    @{ Id = '93006'; Folder = "JK's Markarth Outskirts"; EspLike = @("*Markarth Outskirts*") }
)

$JkLocations = @(
    @{ Id = '68154'; Folder = "JK's Sinderion's Field Laboratory"; EspLike = @("*Sinderion*") }
    @{ Id = '66915'; Folder = "JK's Septimus Signus's Outpost"; EspLike = @("*Septimus*") }
    @{ Id = '34542'; Folder = "JK's Riverfall Cottage"; EspLike = @("*Riverfall*") }
)

$RynAio = @(
    @{ Id = '72305'; Folder = "Ryn's Farms"; EspLike = @("*Farms*") }
    @{ Id = '64969'; Folder = "Ryn's Standing Stones"; EspLike = @("*Standing Stones*") }
)

$RynLandmarks = @(
    @{ Id = '71485'; Folder = "Ryn's Alchemist's Shack"; EspLike = @("*Alchemist*Shack*") }
    @{ Id = '75056'; Folder = "Ryn's Anise's Cabin"; EspLike = @("*Anise*") }
    @{ Id = '86592'; Folder = "Ryn's Azura's Shrine"; EspLike = @("*Azura*") }
    @{ Id = '70984'; Folder = "Ryn's Bleak Falls Barrow"; EspLike = @("*Bleak Falls*") }
    @{ Id = '73141'; Folder = "Ryn's Bleakwind Basin"; EspLike = @("*Bleakwind*") }
    @{ Id = '72926'; Folder = "Ryn's Goldenglow Estate"; EspLike = @("*Goldenglow*") }
    @{ Id = '73907'; Folder = "Ryn's Halted Stream Camp"; EspLike = @("*Halted Stream*") }
    @{ Id = '77059'; Folder = "Ryn's Karthspire"; EspLike = @("*Karthspire*") }
    @{ Id = '102676'; Folder = "Ryn's Lost Valley Redoubt"; EspLike = @("*Lost Valley*") }
    @{ Id = '75304'; Folder = "Ryn's Lund's Hut"; EspLike = @("*Lund*") }
    @{ Id = '115134'; Folder = "Ryn's Lumber Mills"; EspLike = @("*Lumber Mills*") }
    @{ Id = '88451'; Folder = "Ryn's Mehrunes Dagon's Shrine"; EspLike = @("*Mehrunes*") }
    @{ Id = '79739'; Folder = "Ryn's Mistwatch Folly"; EspLike = @("*Mistwatch*") }
    @{ Id = '74785'; Folder = "Ryn's Saarthal"; EspLike = @("*Saarthal*") }
    @{ Id = '73265'; Folder = "Ryn's Secunda's Kiss"; EspLike = @("*Secunda*") }
    @{ Id = '86149'; Folder = "Ryn's Ustengrav"; EspLike = @("*Ustengrav*") }
    @{ Id = '63761'; Folder = "Ryn's Valtheim Towers"; EspLike = @("*Valtheim*") }
    @{ Id = '74070'; Folder = "Ryn's Western Watchtower"; EspLike = @("*Western Watchtower*") }
)

$RynRiverwood = @(
    @{ Id = '89113'; Folder = "Ryn's Riverwood Trader"; EspLike = @("*Riverwood Trader*") }
    @{ Id = '89519'; Folder = "Ryn's Sleeping Giant Inn"; EspLike = @("*Sleeping Giant*") }
    @{ Id = '89187'; Folder = "Ryn's Alvor and Sigrid's House"; EspLike = @("*Alvor*") }
    @{ Id = '89222'; Folder = "Ryn's Faendal's House"; EspLike = @("*Faendal*") }
    @{ Id = '89297'; Folder = "Ryn's Hod and Gerdur's House"; EspLike = @("*Hod*") }
    @{ Id = '89236'; Folder = "Ryn's Sven's and Hilde's House"; EspLike = @("*Sven*") }
)

$RynWhiterun = @(
    @{ Id = '65661'; Folder = "Ryn's Whiterun City Limits"; EspLike = @("*Whiterun City Limits*") }
)

$PatchHubs = @(
    @{ Id = '35910'; Folder = "JK's Interiors Patch Collection"; Label = '35910 JK Interiors Patch Collection -> flatten all applicable ESPs; enable by master check' }
    @{ Id = '61416'; Folder = "JK's Guild HQ Interiors Patch Collection"; Label = '61416 JK Guild HQ Patch Collection -> flatten all applicable ESPs' }
    @{ Id = '78920'; Folder = 'Whiterun Exteriors Patch Hub'; Label = '78920 Whiterun Exteriors -> JK Outskirts + Ryn City Limits + CWE + Spaghetti Whiterun combo patches' }
    @{ Id = '87964'; Folder = "JK's Windhelm Outskirts Patch Collection"; Label = '87964 Windhelm Outskirts -> Ryn Farms patch' }
    @{ Id = '91642'; Folder = "JK's Riften Outskirts Patch Collection"; Label = '91642 Riften Outskirts -> Ryn Farms patch' }
    @{ Id = '95750'; Folder = "JK's Markarth Outskirts Patch Collection"; Label = '95750 Markarth Outskirts -> stack patches (no Ryn Farms patch)' }
    @{ Id = '73778'; Folder = "Ryn's Skyrim Official Patch Hub"; Label = '73778 Ryn Official Patch Hub -> flatten applicable patches' }
    @{ Id = '128196'; Folder = "Ryn's Skyrim Patch Collection"; Label = '128196 Ryn community patch collection -> flatten applicable patches' }
    @{ Id = '76913'; Folder = "Ryn's Standing Stones Patch Collection"; Label = '76913 Ryn Standing Stones patches' }
    @{ Id = '89511'; Folder = "Ryn's Riverwood Patch Collection"; Label = '89511 Ryn Riverwood patches' }
)

# --- Main ---
Write-Host '=== JK + Ryn stack install (task-0043) ==='
Assert-Mo2Closed
Write-Log '[preflight] MO2 closed.'

$successorLines = [System.Collections.Generic.List[string]]::new()
$installedCount = 0

if (-not $SkipInstall) {
    foreach ($entry in $JkInteriors35910) {
        if (Install-SimpleMod -Entry $entry) {
            [void]$successorLines.Add("+$($entry.Folder)")
            $installedCount++
        }
    }
    foreach ($entry in $JkGuild61416) {
        if (Install-SimpleMod -Entry $entry) {
            [void]$successorLines.Add("+$($entry.Folder)")
            $installedCount++
        }
    }
    foreach ($entry in $JkOutskirts) {
        if (Install-SimpleMod -Entry $entry) {
            [void]$successorLines.Add("+$($entry.Folder)")
            $installedCount++
        }
    }
    foreach ($entry in $JkLocations) {
        if (Install-SimpleMod -Entry $entry) {
            [void]$successorLines.Add("+$($entry.Folder)")
            $installedCount++
        }
    }
    foreach ($entry in $RynAio) {
        if (Install-SimpleMod -Entry $entry) {
            [void]$successorLines.Add("+$($entry.Folder)")
            $installedCount++
        }
    }
    if (Install-RynDragonMounds) {
        [void]$successorLines.Add("+Ryn's Dragon Mounds Collection")
        $installedCount++
    }
    foreach ($entry in $RynLandmarks) {
        if (Install-SimpleMod -Entry $entry) {
            [void]$successorLines.Add("+$($entry.Folder)")
            $installedCount++
        }
    }
    foreach ($entry in $RynRiverwood) {
        if (Install-SimpleMod -Entry $entry) {
            [void]$successorLines.Add("+$($entry.Folder)")
            $installedCount++
        }
    }
    foreach ($entry in $RynWhiterun) {
        if (Install-SimpleMod -Entry $entry) {
            [void]$successorLines.Add("+$($entry.Folder)")
            $installedCount++
        }
    }
    foreach ($hub in $PatchHubs) {
        $plugins = Install-HubFlatten -ModId $hub.Id -FolderName $hub.Folder -LogLabel $hub.Label
        if ($plugins.Count -gt 0) {
            [void]$successorLines.Add("+$($hub.Folder)")
            $installedCount++
        }
    }
}

if ($successorLines.Count -gt 0) {
    Ensure-SuccessorModlistBlock -NewModLines @($successorLines | Select-Object -Unique)
}

# Enable main mod plugins (non-hub)
$mainFolders = @($JkInteriors35910 + $JkGuild61416 + $JkOutskirts + $JkLocations + $RynAio + $RynLandmarks + $RynRiverwood + $RynWhiterun)
$mainPlugins = @()
foreach ($entry in $mainFolders) {
    $folder = Join-Path $script:AnvilMods $entry.Folder
    if (-not (Test-Path -LiteralPath $folder)) { continue }
    $esp = Get-ChildItem -LiteralPath $folder -Recurse -Include *.esp, *.esl -File -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -notmatch '\\fomod\\' } |
        Select-Object -First 1
    if ($esp) { $mainPlugins += $esp.Name }
}
$dragonFolder = Join-Path $script:AnvilMods "Ryn's Dragon Mounds Collection"
if (Test-Path -LiteralPath $dragonFolder) {
    $mainPlugins += @(Get-ChildItem -LiteralPath $dragonFolder -Filter '*.esl' -File | Select-Object -ExpandProperty Name)
}
if ($mainPlugins.Count -gt 0) {
    Enable-PluginsWithMasterCheck -PluginNames $mainPlugins -InsertAfter 'Lux.esp' | Out-Null
}

# Hub plugins — master-gated enable
foreach ($hub in $PatchHubs) {
    $enabled = Enable-HubPluginsFromFolder -FolderName $hub.Folder -InsertAfter 'Lux.esp'
    if ($enabled.Count -gt 0) {
        [void]$script:FomodChoices.Add("$($hub.Folder) enabled $($enabled.Count) plugin(s) with resolved masters")
    }
}

Enable-UmeUnderstonePatches | Out-Null

Write-ProfileSnapshot -Label 'task-0043-jk-ryn-stack'

$mast = Invoke-MastScan
Write-Host ''
Write-Host "Installed mod folders this run: $installedCount"
Write-Host "Active plugins: $($mast.Active)"
Write-Host "Missing master refs: $($mast.Missing.Count)"
if ($mast.Missing.Count -gt 0) {
    $mast.Missing | Sort-Object Plugin, Master | Format-Table -AutoSize | Out-String | Write-Host
}

if ($script:MissingDownloads.Count -gt 0) {
    Write-Host ''
    Write-Host 'MISSING DOWNLOADS - install via MO2/Nexus then re-run this script:'
    $script:MissingDownloads | Sort-Object -Unique | ForEach-Object { Write-Host "  $_" }
}

$majorGap = ($script:MissingDownloads.Count -ge 10)
if ($majorGap) {
    Write-Host ''
    Write-Host "BLOCKED: $($script:MissingDownloads.Count) archives missing - task-0043 install pass incomplete."
}

if ($mast.Missing.Count -gt 0) { exit 2 }
if ($majorGap) { exit 3 }
exit 0
