#Requires -Version 5.1
<#
.SYNOPSIS
  Import AE/CC Creation Club packs into MO2 mods from Steam game Data folder.
  Scope: task-0035 / ae-cc-import-research-2026-07-07.md
#>
param(
    [string]$SteamData = 'D:\Steam\steamapps\common\Skyrim Special Edition\Data',
    [string]$Mo2Root = 'D:\Skyrim AI Modlist\Anvil',
    [string]$ProfileName = 'Anvil - Main Profile',
    [switch]$WhatIf,
    [switch]$ModsOnly,
    [switch]$ProfileOnly
)

$ErrorActionPreference = 'Stop'
. "$PSScriptRoot\Mo2ProfileGuardrails.ps1"
if (-not $ModsOnly) { Assert-Mo2Closed }

$ProfileDir = Join-Path $Mo2Root "profiles\$ProfileName"
$ModsDir = Join-Path $Mo2Root 'mods'

# Plugin base name -> MO2 mod folder suffix (Creation Club - <Name>)
$CcMap = [ordered]@{
    'ccvsvsse004-beafarmer'           = 'Farming'
    'ccasvsse001-almsivi'             = 'Ghosts of the Tribunal'
    'ccbgssse067-daedinv'             = 'The Cause'
    'cctwbsse001-puzzledungeon'       = 'Forgotten Seasons'
    'ccbgssse016-umbra'               = 'Umbra'
    'ccbgssse031-advcyrus'            = 'Dead Man''s Dread'
    'ccvsvsse003-necroarts'           = 'Necromantic Grimoire'
    'ccpewsse002-armsofchaos'         = 'Arms of Chaos'
    'ccbgssse014-spellpack01'         = 'Arcane Accessories'
    'ccbgssse002-exoticarrows'        = 'Arcane Archer Pack'
    'ccfsvsse001-backpacks'           = 'Adventurer''s Backpack'
    'ccbgssse040-advobgobs'           = 'Goblins'
    'ccbgssse005-goldbrand'           = 'Goldbrand'
    'ccmtysse001-knightsofthenine'    = 'Divine Crusader'
    'ccedhsse002-splkntset'           = 'Spell Knight Armor'
    'ccmtysse002-ve'                  = 'Vigil Enforcer Armor Set'
    'ccedhsse003-redguard'            = 'Redguard Elite Armaments'
    'ccbgssse018-shadowrend'          = 'Shadowrend'
    'ccbgssse007-chrysamere'          = 'Chrysamere'
    'ccbgssse008-wraithguard'         = 'Sunder and Wraithguard'
    'ccbgssse020-graycowl'            = 'The Gray Cowl Returns'
    'ccbgssse034-mntuni'              = 'Wild Horses'
    'ccvsvsse002-pets'                = 'Pets of Skyrim'
    'ccffbsse001-imperialdragon'      = 'Civil War Champions'
    'ccffbsse002-crossbowpack'        = 'Expanded Crossbow Pack'
    'ccbgssse043-crosselv'            = 'Elite Crossbows'
    'cceejsse001-hstead'              = 'Tundra Homestead'
    'cceejsse005-cave'                = 'Bloodchill Manor'
    'ccafdsse001-dwesanctuary'        = 'Nchuanthumz Dwarven Home'
    'cceejsse002-tower'               = 'Myrwatch'
    'cceejsse004-hall'                = 'Hendraheim'
    'cceejsse003-hollow'              = 'Shadowfoot Sanctum'
    'ccrmssse001-necrohouse'          = 'Gallows Hall'
    'cckrtsse001_altar'               = 'Bittercup'
    'ccbgssse013-dawnfang'            = 'Dawnfang and Duskfang'
    'ccbgssse038-bowofshadows'        = 'Bow of Shadows'
    'ccbgssse021-lordsmail'           = 'Lord''s Mail'
    'ccbgssse003-zombies'             = 'Plague of the Dead'
    'ccbgssse004-ruinsedge'           = 'Ruin''s Edge'
    'ccbgssse006-stendarshammer'      = 'Stendarr''s Hammer'
    'ccbgssse019-staffofsheogorath'   = 'Staff of Sheogorath'
    'ccbgssse045-hasedoki'            = 'Staff of Hasedoki'
    'ccbgssse069-contest'             = 'The Contest'
    'ccbgssse068-bloodfall'           = 'Headman''s Cleaver'
    'cccbhsse001-gaunt'               = 'Fearsome Fists'
    'ccbgssse041-netchleather'        = 'Netch Leather Armor'
    'ccedhsse001-norjewel'            = 'Nordic Jewelry'
    'ccbgssse036-petbwolf'            = 'Bone Wolf'
    'ccbgssse035-petnhound'           = 'Nix-Hound'
    'ccbgssse010-petdwarvenarmoredmudcrab' = 'Dwarven Armored Mudcrab'
    'ccbgssse011-hrsarmrelvn'          = 'Horse Armor - Elven'
    'ccbgssse012-hrsarmrstl'          = 'Horse Armor - Steel'
    'ccvsvsse001-winter'              = 'Saturalia Holiday Pack'
    'ccbgssse051-ba_daedricmail'      = 'Alternative Armors - Daedric Mail'
    'ccbgssse050-ba_daedric'          = 'Alternative Armors - Daedric Plate'
    'ccbgssse059-ba_dragonplate'      = 'Alternative Armors - Dragon Plate'
    'ccbgssse060-ba_dragonscale'      = 'Alternative Armors - Dragonscale'
    'ccbgssse062-ba_dwarvenmail'      = 'Alternative Armors - Dwarven Mail'
    'ccbgssse061-ba_dwarven'          = 'Alternative Armors - Dwarven Plate'
    'ccbgssse063-ba_ebony'            = 'Alternative Armors - Ebony Plate'
    'ccbgssse064-ba_elven'            = 'Alternative Armors - Elven Hunter'
    'ccbgssse052-ba_iron'             = 'Alternative Armors - Iron'
    'ccbgssse053-ba_leather'          = 'Alternative Armors - Leather'
    'ccbgssse054-ba_orcish'           = 'Alternative Armors - Orcish Plate'
    'ccbgssse055-ba_orcishscaled'     = 'Alternative Armors - Orcish Scaled'
    'ccbgssse056-ba_silver'           = 'Alternative Armors - Silver'
    'ccbgssse057-ba_stalhrim'         = 'Alternative Armors - Stalhrim Fur'
    'ccbgssse058-ba_steel'            = 'Alternative Armors - Steel Soldier'
}

$SkipPlugins = @(
    'ccqdrsse002-firewood.esl'   # Camping — power-fantasy skip
    'ccbgssse066-staves.esl'     # Praedy's redundancy — defer
)

$AlreadyPresent = @(
    'ccbgssse001-fish.esm'
    'ccqdrsse001-survivalmode.esl'
    'ccbgssse037-curios.esl'
    'ccbgssse025-advdsgs.esm'
)

function Read-Lines([string]$Path) {
    if (-not (Test-Path $Path)) { return @() }
    return Get-Content $Path -Encoding UTF8 | Where-Object { $_ -notmatch '^\s*$' -or $_ -match '^\#' }
}

function Write-Lines([string]$Path, [string[]]$Lines) {
    $Lines | Set-Content -Path $Path -Encoding UTF8
}

# Validate survival retained
foreach ($p in $AlreadyPresent) {
    $lo = Read-Lines (Join-Path $ProfileDir 'loadorder.txt')
    if ($lo -notcontains $p) { throw "Expected existing CC plugin missing from loadorder: $p" }
}
Write-Host "Confirmed 4 baseline CC packs present in loadorder (Survival retained, not reinstalling)."

$imported = @()
$skipped = @()
$errors = @()

if ($ProfileOnly) {
    Assert-Mo2Closed
    $logPath = "$PSScriptRoot\..\modlist\exports\ae-cc-import-log.json"
    if (-not (Test-Path $logPath)) { throw "ProfileOnly requires modlist/exports/ae-cc-import-log.json from a prior ModsOnly run." }
    $imported = Get-Content $logPath -Raw | ConvertFrom-Json
} else {
foreach ($entry in $CcMap.GetEnumerator()) {
    $base = $entry.Key
    $modSuffix = $entry.Value
    $modName = "Creation Club - $modSuffix"
    $modPath = Join-Path $ModsDir $modName

    $plugin = Get-ChildItem $SteamData -Filter "$base.es*" -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $plugin) {
        $errors += "Missing in Steam Data: $base"
        continue
    }

    $pluginName = $plugin.Name
    if ($SkipPlugins -contains $pluginName) {
        $skipped += $pluginName
        continue
    }
    if ($AlreadyPresent -contains $pluginName) {
        $skipped += "$pluginName (already present)"
        continue
    }

    $bsaName = [System.IO.Path]::ChangeExtension($pluginName, '.bsa')
    $bsaPath = Join-Path $SteamData $bsaName
    if (-not (Test-Path $bsaPath)) {
        $errors += "Missing BSA for $pluginName"
        continue
    }

    if (-not $WhatIf) {
        New-Item -ItemType Directory -Force -Path $modPath | Out-Null
        Copy-Item $plugin.FullName (Join-Path $modPath $pluginName) -Force
        Copy-Item $bsaPath (Join-Path $modPath $bsaName) -Force
    }

    $imported += [pscustomobject]@{
        ModName = $modName
        Plugin  = $pluginName
        Bsa     = $bsaName
    }
    Write-Host "Imported: $modName ($pluginName)"
}

} # end if not ProfileOnly

if (-not $ProfileOnly -and $errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ }
    throw "Import had $($errors.Count) error(s)."
}

if ($ModsOnly) {
    Write-Host "`nModsOnly: $($imported.Count) mod folders written; profile not updated."
    $imported | ConvertTo-Json -Depth 3 | Out-File "$PSScriptRoot\..\modlist\exports\ae-cc-import-log.json" -Encoding UTF8
    return @{ ImportedCount = $imported.Count; Imported = $imported; Skipped = $skipped }
}

if ($ProfileOnly -and (Get-Process -Name 'ModOrganizer' -ErrorAction SilentlyContinue)) {
    Assert-Mo2Closed
}

# Profile updates
$modlistPath = Join-Path $ProfileDir 'modlist.txt'
$pluginsPath = Join-Path $ProfileDir 'plugins.txt'
$loadorderPath = Join-Path $ProfileDir 'loadorder.txt'
$archivesPath = Join-Path $ProfileDir 'archives.txt'

$modlist = Read-Lines $modlistPath
$plugins = Read-Lines $pluginsPath
$loadorder = Read-Lines $loadorderPath
$archives = Read-Lines $archivesPath

# Insert CC mods above existing CC block (before Survival Mode line)
$ccAnchor = '+Creation Club - Survival Mode'
$anchorIdx = [array]::IndexOf($modlist, $ccAnchor)
if ($anchorIdx -lt 0) { throw "Could not find CC anchor in modlist.txt: $ccAnchor" }

$newModLines = $imported | ForEach-Object { "+$($_.ModName)" }
$modlist = @(
    $modlist[0..($anchorIdx - 1)]
    $newModLines
    $modlist[$anchorIdx..($modlist.Length - 1)]
) | ForEach-Object { $_ }

# CC plugins load after vanilla masters, before _ResourcePack (match Anvil order)
$loAnchor = '_ResourcePack.esl'
$loIdx = [array]::IndexOf($loadorder, $loAnchor)
if ($loIdx -lt 0) { throw "Could not find loadorder anchor: $loAnchor" }

$newPlugins = $imported.Plugin | Sort-Object
$loadorder = @(
    $loadorder[0..($loIdx - 1)]
    $newPlugins
    $loadorder[$loIdx..($loadorder.Length - 1)]
) | ForEach-Object { $_ }

foreach ($pl in $newPlugins) {
    if ($plugins -notcontains "*$pl") {
        $plugins += "*$pl"
    }
}

# Archives: insert CC BSAs after existing CC BSAs block
$archAnchor = 'ccqdrsse001-survivalmode.bsa'
$archIdx = [array]::IndexOf($archives, $archAnchor)
if ($archIdx -lt 0) { throw "Could not find archives anchor: $archAnchor" }

$newBsas = ($imported | ForEach-Object { $_.Bsa }) | Sort-Object -Unique
$archives = @(
    $archives[0..$archIdx]
    $newBsas
    $archives[($archIdx + 1)..($archives.Length - 1)]
) | ForEach-Object { $_ }

if (-not $WhatIf) {
    Write-Lines $modlistPath $modlist
    Write-Lines $pluginsPath $plugins
    Write-Lines $loadorderPath $loadorder
    Write-Lines $archivesPath $archives
}

Write-Host "`nImport summary: $($imported.Count) mods, skipped $($skipped.Count), errors $($errors.Count)"
$imported | ConvertTo-Json -Depth 3 | Out-File "$PSScriptRoot\..\modlist\exports\ae-cc-import-log.json" -Encoding UTF8

return @{
    ImportedCount = $imported.Count
    Imported      = $imported
    Skipped       = $skipped
}
