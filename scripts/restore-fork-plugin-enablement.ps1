# Restore Keizaal - Fork plugins.txt enable flags after MO2 F5 stripped all asterisks.
#Requires -Version 5.1
$ErrorActionPreference = 'Stop'

function Assert-Mo2Closed {
    $procs = Get-Process -Name 'ModOrganizer', 'modorganizer' -ErrorAction SilentlyContinue
    if ($procs) { throw 'MO2 is running — close Mod Organizer before running this script.' }
}

function Write-Log($msg) {
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $msg"
    Add-Content -Path $script:LogPath -Value $line
    Write-Host $line
}

function Add-ToSet([System.Collections.Generic.HashSet[string]]$set, [string[]]$items) {
    foreach ($item in $items) {
        if ($item) { [void]$set.Add($item) }
    }
}

$Profile = 'E:\Skyrim\profiles\Keizaal - Fork'
$KeizaalProfile = 'E:\Skyrim\profiles\Keizaal'
$PluginsPath = Join-Path $Profile 'plugins.txt'
$ModlistPath = Join-Path $Profile 'modlist.txt'
$PluginGroupsPath = Join-Path $Profile 'plugingroups.txt'
$ModsDir = 'E:\Skyrim\mods'
$LogPath = 'D:\Skyrim AI Modlist\anvil-successor\modlist\exports\restore-fork-plugins-run.log'

Assert-Mo2Closed
if (Test-Path $LogPath) { Remove-Item $LogPath -Force }
Write-Log 'restore-fork-plugin-enablement starting'

$backup = Join-Path $Profile ("plugins.txt.bak-{0}" -f (Get-Date -Format 'yyyy-MM-dd-HHmmss'))
Copy-Item -LiteralPath $PluginsPath -Destination $backup
Write-Log "backup: $backup"

$enable = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
$disable = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)

Add-ToSet $disable @(
    'ConstellationsNewSkills.esp',
    'Keizaal Patch - Book Covers Skyrim - Constellation.esp',
    'DISCO_VokriinatorISCPatch.esp',
    'Description Framework - Keizaal Cut.esp',
    'Dwemer Gates Don''t Reset - Navigator Patch.esp',
    'JKs Warmaiden''s Harvestable Statics.esp',
    "Markarth Expanded - Spaghetti's Markarth.esp",
    "Riverwood Has Charm - Spaghetti's Riverwood Patch.esp",
    "Spaghetti's Cities - Whiterun.esp",
    "Spaghetti's Cities - Windhelm.esp",
    "Spaghetti's Capital Windhelm Expansion - Individual.esp",
    "Spaghetti's Cities - Markarth.esp",
    "Spaghetti's Cities - Solitude.esp",
    "Spaghetti's Cities - Riften.esp",
    "Spaghetti's Towns - Riverwood.esp",
    'Captial Whiterun and Spaghetti AIO Patch.esp',
    'Riften Expansion - Spaghetti Cities Riften Patch.esp',
    'JKs Ryns Whiterun Exterior - CC Tundra Homestead patch.esp',
    'JKs Silver-Blood Inn - Alt Dwarven Plate Patch.esp',
    'JKs Silver-Blood Inn - Spell Knight Armor Patch.esp',
    'JKs Whiterun Outskirts - Tundra Homestead Patch.esp',
    'Ryns Whiterun City Limits - Tundra Homestead Patch.esp'
)

# Keizaal pristine starred baseline
Add-ToSet $enable (Get-Content $KeizaalProfile\plugins.txt | Where-Object { $_ -match '^\*(.+)$' } | ForEach-Object { $Matches[1] })

# plugingroups snapshot (pre-JK, still useful for VB/city/gameplay additions)
if (Test-Path $PluginGroupsPath) {
    Add-ToSet $enable (Get-Content $PluginGroupsPath | Where-Object { $_ -match '\|' } | ForEach-Object { ($_ -split '\|', 2)[0].Trim() })
}

# VB stack
Add-ToSet $enable @(
    'Apocalypse - Magic of Skyrim.esp', 'Additional Dremora Faces - Apocalypse Patch.esp',
    'MysticismMagic.esp', 'Additional Dremora Faces - Mysticism Patch.esp', 'MysticismJumpSpells.esp',
    'MysticismUSSEPContainerPatch.esp', 'Mysticism - Spell Charge Time Lowered.esp',
    'SPERG-SSE.esp', 'SPERG_ApocalypsePatch.esp', 'SPERG_USSEPPatch.esp',
    'Adamant.esp', 'Adamant - Apocalypse Patch.esp', 'PathOfSorcery.esp', 'PoS_Apocalypse_Patch.esp',
    'PoS_ArcaneAccessories_Patch.esp', 'PoS_Bittercup_Patch.esp', 'PoS_NecromanticGrimoire_Patch.esp',
    'PoS_PlagueOfTheDead_Patch.esp', 'PoS_Saints&Seducers_Patch.esp', 'PoS_TheCause_Patch.esp',
    'PoS_CreationClub_LList_Patch.esp', 'DISCO_PathOfSorcery_Mashup.esp',
    'Vokrii - Minimalistic Perks of Skyrim.esp', 'Apocalypse - Vokrii Compatibility Patch.esp',
    'Mysticism - Vokrii Compatibility Patch.esp', 'Vokrii - Apply Spell Conditions Fix.esp',
    'Ordinator - Perks of Skyrim.esp', 'Ordinator - No Directional Power Attacks - Balanced.esp',
    'Ordinator - Apply Spell Conditions Fix.esp', 'Ordinator - Beyond Skyrim Bruma Patch.esp',
    'MysticOrdinator.esp', 'Mysticism - No Projectile Weight.esp', 'Ordinator - Combat Styles.esp',
    'Ordinator - No Timed Block.esp', 'Apocalypse - Ordinator Compatibility Patch.esp',
    'Vokriinator Black.esp', 'Vokriinator Black - Apocalypse patch.esp',
    'Vokriinator Black -- No Timed Blocking.esp', 'Vokriinator Black Ethereal Arrow Fix.esp',
    'VokriinatorBlack - combatforcaco.esp'
)

# City stack (standalone cities only — Spaghetti entries in $disable)
Add-ToSet $enable @(
    'SurWR.esp', 'WindhelmSSE.esp', 'Ultimate Markarth.esp', 'Ultimate Markarth Expanded.esp',
    "RedBag's Solitude.esp", "USSEP Patch for RedBag's Solitude.esp",
    'Riften Expansion.esp', 'Riverwood Has Charm.esp', 'Riverwood Has Walls.esp', 'Riverwood Has Charm + Walls.esp'
)

# Gameplay tranche
Add-ToSet $enable @(
    'SummonShadowMERCHANT.esp', 'SignatureEquipment.esp', 'ReadingIsBad.esp', 'Jewelry Of Power.esp',
    'Infinite Stamina Out of Combat.esp', 'Infinite Shouting Out of Combat.esp',
    'Infinite Magicka Out of Combat.esp', 'InfiniteHorseStaminaOutofCombat.esp', 'infiniteCharge.esp',
    'EquipmentStateCopy&Rename.esl', 'Dragon Claws Auto-Unlock.esp', 'DetectLever.esp',
    'TDM Target Lock Fix - Bristleback.esp'
)

# JK/Ryn: do NOT bulk-import Anvil active hub patches (Embers/NOTWL/LAWF/Aspens etc.).
# Base ESPs are enabled by fix-jk-ryn-plugin-masters.ps1 after restore.
# Only force-enable UME bridge patches that Keizaal task-0065 expects when masters exist.
Add-ToSet $enable @(
    "Markarth Expanded - JK's Understone Keep.esp"
)

# Fundamentals Phase A ESPs (folders already on disk)
$fundamentalFolders = @(
    'Bleeding Damage Fixes', 'Hammering Animation and Sound Fixes',
    'Quest Journal Limit Bug Fixer - Recover Disappeared Quests',
    'Hide Quest Items in Container Menu', 'Nilheim BQ Fix',
    'Dwemer Gates Don''t Reset - Patches', 'Dwemer Gates Don''t Reset',
    'Arcane Blacksmith''s Apron - Hood Fixes', 'Safety of Skuldafn - Railing and Small Fixes',
    'Solitude Rock Arch LOD Fix (By force)', 'LOD Unloading Bug Fix',
    'Unaggressive Dragon Priests Fix', 'Durak Teleport Fix',
    'Civil War Intro Scenes Run Only Once', 'Guild Master''s Armor First Person Texture Fix',
    'Stuck on Screen Load Door Prompt Fix', 'NPC Stuck in Bleedout Fix',
    'Zero Bounty Hostility Fix', 'Rock Traps Trigger Fixes', 'Dwemer Ballista Crash fix',
    'Universal Cured Serana Eye Fix', 'Chillwind Depths CTD Fix', 'Stamina of Steeds',
    'Hearthfires Houses Building Fix', 'Source of Stalhrim Quest Fix',
    'Proving Honor Companions Quest Progression Fix', 'Shalidor''s Maze Sound Fix',
    'Labyrinthian Shalidor''s Maze Fixes', 'Mannequin Management', 'Mount Anthor Dragon Fix',
    'Dragon Dies on Touchdown Fix', 'EMISH - Dragon Crash Land Markers Fix',
    'Simplicity of Seeding - Better Hearthfires and Farming CC Planter Scripts',
    'Thieves Guild - A Proper Missing Items Fix', 'WI College Student Bug Fix',
    'One Soul Only Mirmulnir', 'Smoothing of Splices', 'WIDeadBodyCleanupScript Crash Fix',
    'WE05 Script Fix', 'TrapSwingingWall Script Fix', 'Stealth Detection Fixes',
    'Scare my Enemy Bug Fix', 'Roggvir''s Execution Scene Fixes', 'Optimized USSEP Valdr Quest',
    'OnMagicEffectApply Replacer', 'Irkngthand''s Possible Bugs Fix', 'Ethereal Immunity',
    'dunPOISoldiersRaidOnStart Script Tweak', 'DLC2 Miraak BossFightScript Fix',
    'DLC2 March of the Dead Fix', 'Delphine Skyhaven Bugfix MQ203',
    'Scrambled Bugs - Vendor Respawn Fix', 'Scrambled Bugs - Script Effect Archetype Crash Fix',
    'Better Third Person Selection - BTPS', 'Toggle Dialogue Camera', 'Better Jumping AE',
    'Sprint Stuttering Fix', 'First Person Sneak Strafe - Walk Stutter Fix',
    'Fix Toggle Walk Run (SKSE)', 'Keyboard Shortcuts Fix', 'No Console Spam',
    'Kill Caps Lock NG', 'Console Commands Extender - Anniversary Edition Update',
    'Yes Im Sure NG', 'Whose Quest is it Anyway NG', 'Which Key NG', 'Wash That Blood Off 2',
    'Stay At The System Page NG', 'Skyrim Priority - CPU Performance FPS Optimizer',
    'Remember Lockpick Angle - Updated', 'Mum''s the Word NG', 'Menu Zoom',
    'I''m Walkin'' Here NG with Pets', 'Hair Colour Sync', 'Essential Favorites',
    'Mute On Focus Loss', 'Better AltTab', 'Savefile Grouping Fix', 'Mu Joint Fix',
    'LeveledList Crash Fix', 'Female Equipment Scale Fix', 'Equip Enchantment Fix',
    'Enhanced Reanimation', 'Enhanced Invisibility', 'Bash Bug Fix', 'Barter Limit Fix',
    'Alt-Tab Stuck Key Fix NG', 'Absorb Spell XP Fix', 'Alchemy XP Fix',
    'ENB Light Inventory Fix (ELIF)', 'Vampires Cast No Shadow 2', 'Stagger Effect Fix',
    'SMP-NPC Crash Fix', 'Don''t Stay in The Water - NPC Water AI Fix',
    'Better Combat Escape - NG', 'Camera Persistence Fixes', 'Light Placer', 'Mu Skeleton Editor'
)
foreach ($folder in $fundamentalFolders) {
    $d = Join-Path $ModsDir $folder
    if (-not (Test-Path -LiteralPath $d)) { continue }
    Get-ChildItem -LiteralPath $d -Recurse -Include *.esp, *.esm, *.esl -File -ErrorAction SilentlyContinue | ForEach-Object {
        [void]$enable.Add($_.Name)
    }
}

# GSO intentionally disabled on Fork
[void]$disable.Add('Game Settings Override.esp')
[void]$disable.Add('Game Settings Override - Collection.esp')

$plugins = Get-Content -LiteralPath $PluginsPath -Encoding UTF8
$activeBefore = ($plugins | Where-Object { $_ -match '^\*' }).Count
$out = [System.Collections.Generic.List[string]]::new()
$starred = 0

foreach ($line in $plugins) {
    if ($line -match '^#' -or -not $line.Trim()) {
        [void]$out.Add([string]$line)
        continue
    }
    $bare = $line.TrimStart('*').Trim()
    if ($enable.Contains($bare) -and -not $disable.Contains($bare)) {
        [void]$out.Add("*$bare")
        $starred++
    }
    else {
        [void]$out.Add($bare)
    }
}

Set-Content -LiteralPath $PluginsPath -Value $out -Encoding UTF8
Write-Log "plugins active: $activeBefore -> $starred (enable-set size $($enable.Count), disable-set size $($disable.Count))"

# Disable legacy SKSE duplicates only (NOT patch+base pairs like QUI / QuickLoot / FISSES).
$legacySkseDupes = @(
    'Better Jumping', 'Better Combat Escape - SSE',
    'Stagger Direction Fix', 'Simple Block Sparks- Script Free', 'Wade In Water',
    'Better Third Person Selection'
)
$modlist = Get-Content $ModlistPath
$newModlist = foreach ($line in $modlist) {
    if ($line -match '^\+(.+)$') {
        $name = $Matches[1].Trim()
        if ($legacySkseDupes -contains $name) { "-$name" } else { $line }
    }
    else { $line }
}
Set-Content -LiteralPath $ModlistPath -Value $newModlist -Encoding UTF8
Write-Log "modlist: disabled $($legacySkseDupes.Count) legacy SKSE duplicate folders"
Write-Log 'restore-fork-plugin-enablement complete — run fix-jk-ryn-plugin-masters.ps1 next, then verify MAST in MO2'
