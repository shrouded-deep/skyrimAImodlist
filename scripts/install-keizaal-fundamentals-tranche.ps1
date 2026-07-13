# task-0067: Anvil fundamentals Phase A for Keizaal - Fork
#Requires -Version 5.1
$ErrorActionPreference = 'Stop'

function Assert-Mo2Closed {
    $procs = Get-Process -Name 'ModOrganizer','modorganizer' -ErrorAction SilentlyContinue
    if ($procs) { throw 'MO2 is running — close Mod Organizer before running this script.' }
}

$AnvilMods    = 'D:\Skyrim AI Modlist\Anvil\mods'
$AnvilProfile = 'D:\Skyrim AI Modlist\Anvil\profiles\Anvil - Main Profile'
$SkyrimMods   = 'E:\Skyrim\mods'
$Profile      = 'E:\Skyrim\profiles\Keizaal - Fork'
$ModlistPath  = Join-Path $Profile 'modlist.txt'
$PluginsPath  = Join-Path $Profile 'plugins.txt'
$LoadOrderPath = Join-Path $Profile 'loadorder.txt'
$LogPath      = 'D:\Skyrim AI Modlist\anvil-successor\modlist\exports\install-fundamentals-run.log'

function Write-Log($msg) {
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $msg"
    Add-Content -Path $LogPath -Value $line
    Write-Host $line
}

function Get-PluginMasters([string]$FilePath) {
    $masters = [System.Collections.Generic.List[string]]::new()
    try {
        $b = [System.IO.File]::ReadAllBytes($FilePath)
        if ($b.Length -lt 28) { return $masters }
        $i = 24
        $e = 24 + [BitConverter]::ToUInt32($b, 4)
        if ($e -gt $b.Length) { $e = $b.Length }
        while ($i -lt $e - 6) {
            if ($i + 6 -gt $b.Length) { break }
            $t = [System.Text.Encoding]::ASCII.GetString($b[$i..($i + 3)])
            $s = [BitConverter]::ToUInt16($b, $i + 4)
            if ($t -eq 'MAST' -and $s -gt 0 -and ($i + 6 + $s) -le $b.Length) {
                [void]$masters.Add([System.Text.Encoding]::ASCII.GetString($b[($i + 6)..($i + 6 + $s - 2)]))
            }
            $i += 6 + $s
            if ($s -eq 0) { break }
        }
    }
    catch { }
    return $masters
}

function Test-MastersAvailable([string]$PluginPath, [hashtable]$Present) {
    foreach ($m in (Get-PluginMasters $PluginPath)) {
        if (-not $Present.ContainsKey($m)) { return $false }
    }
    return $true
}

# Phase A mod folders (exact Anvil names). Skips: already on Fork or Phase C/deferred.
$fundamentalModFolders = @(
    # Script Fixes
    'Bleeding Damage Fixes',
    'Hammering Animation and Sound Fixes',
    'Quest Journal Limit Bug Fixer - Recover Disappeared Quests',
    'Hide Quest Items in Container Menu',
    'Nilheim BQ Fix',
    'Dwemer Gates Don''t Reset - Patches',
    'Dwemer Gates Don''t Reset',
    'Arcane Blacksmith''s Apron - Hood Fixes',
    'Safety of Skuldafn - Railing and Small Fixes',
    'Solitude Rock Arch LOD Fix (By force)',
    'LOD Unloading Bug Fix',
    'Unaggressive Dragon Priests Fix',
    'Durak Teleport Fix',
    'Civil War Intro Scenes Run Only Once',
    'Guild Master''s Armor First Person Texture Fix',
    'Stuck on Screen Load Door Prompt Fix',
    'NPC Stuck in Bleedout Fix',
    'Zero Bounty Hostility Fix',
    'Rock Traps Trigger Fixes',
    'Dwemer Ballista Crash fix',
    'Universal Cured Serana Eye Fix',
    'Chillwind Depths CTD Fix',
    'Stamina of Steeds',
    'Hearthfires Houses Building Fix',
    'Source of Stalhrim Quest Fix',
    'Proving Honor Companions Quest Progression Fix',
    'Shalidor''s Maze Sound Fix',
    'Labyrinthian Shalidor''s Maze Fixes',
    'Mannequin Management',
    'Mount Anthor Dragon Fix',
    'Dragon Dies on Touchdown Fix',
    'EMISH - Dragon Crash Land Markers Fix',
    # SKSE Plugin Fixes
    'Simplicity of Seeding - Better Hearthfires and Farming CC Planter Scripts',
    'Thieves Guild - A Proper Missing Items Fix',
    'WI College Student Bug Fix',
    'One Soul Only Mirmulnir',
    'Smoothing of Splices',
    'WIDeadBodyCleanupScript Crash Fix',
    'WE05 Script Fix',
    'TrapSwingingWall Script Fix',
    'Stealth Detection Fixes',
    'Scare my Enemy Bug Fix',
    'Roggvir''s Execution Scene Fixes',
    'Optimized USSEP Valdr Quest',
    'OnMagicEffectApply Replacer',
    'Irkngthand''s Possible Bugs Fix',
    'Ethereal Immunity',
    'dunPOISoldiersRaidOnStart Script Tweak',
    'DLC2 Miraak BossFightScript Fix',
    'DLC2 March of the Dead Fix',
    'Delphine Skyhaven Bugfix MQ203',
    # Scrambled Bugs slices
    'Scrambled Bugs - Vendor Respawn Fix',
    'Scrambled Bugs - Script Effect Archetype Crash Fix',
    # General Fixes
    'Better Third Person Selection - BTPS',
    'Toggle Dialogue Camera',
    'Better Jumping AE',
    'Sprint Stuttering Fix',
    'First Person Sneak Strafe - Walk Stutter Fix',
    'Fix Toggle Walk Run (SKSE)',
    'Keyboard Shortcuts Fix',
    # Better Controls
    'No Console Spam',
    'Kill Caps Lock NG',
    'Console Commands Extender - Anniversary Edition Update',
    # Mod Tools NG QoL
    'Yes Im Sure NG',
    'Whose Quest is it Anyway NG',
    'Which Key NG',
    'Wash That Blood Off 2',
    'Stay At The System Page NG',
    'Skyrim Priority - CPU Performance FPS Optimizer',
    'Remember Lockpick Angle - Updated',
    'Mum''s the Word NG',
    'Menu Zoom',
    'I''m Walkin'' Here NG with Pets',
    'Hair Colour Sync',
    'Essential Favorites',
    'Mute On Focus Loss',
    'Better AltTab',
    # SKSE Plugin Tweaks (safe subset — skip Fork duplicates)
    'Savefile Grouping Fix',
    'Mu Joint Fix',
    'LeveledList Crash Fix',
    'Game Settings Override - Collection',
    'Game Settings Override',
    'Female Equipment Scale Fix',
    'Equip Enchantment Fix',
    'Enhanced Reanimation',
    'Enhanced Invisibility',
    'Bash Bug Fix',
    'Barter Limit Fix',
    'Alt-Tab Stuck Key Fix NG',
    'Absorb Spell XP Fix',
    'Alchemy XP Fix',
    'ENB Light Inventory Fix (ELIF)',
    'Vampires Cast No Shadow 2',
    'Stagger Effect Fix',
    'SMP-NPC Crash Fix',
    'Don''t Stay in The Water - NPC Water AI Fix',
    'Better Combat Escape - NG',
    'Better Combat Escape - SSE',
    'Camera Persistence Fixes',
    # Essentials gap
    'Light Placer',
    'Mu Skeleton Editor'
)

Assert-Mo2Closed
if (Test-Path $LogPath) { Remove-Item $LogPath -Force }
Write-Log 'task-0067 fundamentals Phase A install starting'

$copied = 0; $skipped = 0; $missing = 0
foreach ($folder in $fundamentalModFolders) {
    $src = Join-Path $AnvilMods $folder
    $dst = Join-Path $SkyrimMods $folder
    if (-not (Test-Path -LiteralPath $src)) {
        Write-Log "WARN missing on Anvil: $folder"
        $missing++
        continue
    }
    if (Test-Path -LiteralPath $dst) {
        Write-Log "SKIP exists: $folder"
        $skipped++
        continue
    }
    Write-Log "COPY $folder"
    robocopy $src $dst /E /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "robocopy failed $folder exit $LASTEXITCODE" }
    $copied++
}

# --- modlist: enable above Essentials_separator (basement) ---
$enableSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($m in $fundamentalModFolders) { [void]$enableSet.Add($m) }

$modlist = Get-Content $ModlistPath
$newModlist = New-Object System.Collections.Generic.List[string]
$seen = @{}
$anchorSep = 'Essentials_separator'

foreach ($line in $modlist) {
    if ($line -match '^[+-](.+)$') {
        $name = $Matches[1].Trim()
        if ($enableSet.Contains($name)) {
            if (-not $seen.ContainsKey($name)) {
                $newModlist.Add("+$name")
                $seen[$name] = $true
            }
            continue
        }
        if ($name -eq $anchorSep) {
            foreach ($mod in $fundamentalModFolders) {
                if (-not $seen.ContainsKey($mod) -and (Test-Path -LiteralPath (Join-Path $SkyrimMods $mod))) {
                    $newModlist.Add("+$mod")
                    $seen[$mod] = $true
                }
            }
            $newModlist.Add($line)
            continue
        }
    }
    $newModlist.Add($line)
}
Set-Content -Path $ModlistPath -Value $newModlist -Encoding UTF8
Write-Log "modlist.txt: $($seen.Count) fundamentals enabled above Essentials"

# --- present masters for MAST (full enabled mod set) ---
$allPluginIndex = @{}
$enabledMods = $newModlist | Where-Object { $_ -match '^\+' } | ForEach-Object { $_ -replace '^\+','' } | Where-Object { $_ -notmatch '_separator$' }
foreach ($mod in $enabledMods) {
    $d = Join-Path $SkyrimMods $mod
    if (-not (Test-Path -LiteralPath $d)) { continue }
    Get-ChildItem -LiteralPath $d -Recurse -Include *.esp,*.esm,*.esl -File -EA SilentlyContinue | ForEach-Object {
        if (-not $allPluginIndex.ContainsKey($_.Name)) { $allPluginIndex[$_.Name] = $_.FullName }
    }
}
$present = @{}
Get-ChildItem 'E:\Skyrim\root\Data' -File -EA SilentlyContinue | Where-Object { $_.Extension -in '.esm','.esl','.esp' } | ForEach-Object { $present[$_.Name] = $true }
foreach ($p in $allPluginIndex.Values) { $present[[IO.Path]::GetFileName($p)] = $true }

# Candidates: plugins only from Phase A mod folders (never JK/Lux hub slices)
$candidatePlugins = [System.Collections.Generic.List[string]]::new()
$fundamentalPluginIndex = @{}
foreach ($mod in $fundamentalModFolders) {
    $d = Join-Path $SkyrimMods $mod
    if (-not (Test-Path -LiteralPath $d)) { continue }
    Get-ChildItem -LiteralPath $d -Recurse -Include *.esp,*.esm,*.esl -File -EA SilentlyContinue | ForEach-Object {
        if (-not $candidatePlugins.Contains($_.Name)) { [void]$candidatePlugins.Add($_.Name) }
        $fundamentalPluginIndex[$_.Name] = $_.FullName
    }
}
$pluginIndex = $fundamentalPluginIndex

$pluginsBefore = (Get-Content $PluginsPath | Where-Object { $_ -like '*.*' }).Count
$plugins = Get-Content $PluginsPath
$loadorder = @(Get-Content $LoadOrderPath)
$existing = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($line in $plugins) {
    $bare = $line.TrimStart('*').Trim()
    if ($bare) { [void]$existing.Add($bare) }
}

$out = [System.Collections.Generic.List[string]]::new()
$activateSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($pl in ($candidatePlugins | Select-Object -Unique)) { [void]$activateSet.Add($pl) }

$loAnchor = 'unofficial skyrim special edition patch.esp'
$loIdx = [array]::IndexOf($loadorder, $loAnchor)
if ($loIdx -lt 0) { $loIdx = 0 }

$enabled = 0; $upgraded = 0; $deferred = 0
foreach ($line in $plugins) {
    $bare = $line.TrimStart('*').Trim()
    if ($bare -and $activateSet.Contains($bare) -and $line -notmatch '^\*') {
        $path = $pluginIndex[$bare]
        if ($path -and (Test-MastersAvailable $path $present)) {
            [void]$out.Add("*$bare")
            $upgraded++
            $present[$bare] = $true
            continue
        }
    }
    [void]$out.Add([string]$line)
}

foreach ($pl in ($candidatePlugins | Select-Object -Unique)) {
    $path = $pluginIndex[$pl]
    if (-not $path) { continue }
    if (-not (Test-MastersAvailable $path $present)) {
        Write-Log "DEFER (MAST): $pl"
        $deferred++
        continue
    }
    if (-not $existing.Contains($pl)) {
        $out.Add("*$pl")
        [void]$existing.Add($pl)
        $enabled++
    }
    if ($loadorder -notcontains $pl) {
        $loadorder = @($loadorder[0..($loIdx - 1)] + $pl + $loadorder[$loIdx..($loadorder.Count - 1)])
        $loIdx++
    }
    $present[$pl] = $true
}

Set-Content -Path $PluginsPath $out -Encoding UTF8
Set-Content -Path $LoadOrderPath $loadorder -Encoding UTF8
$pluginsAfter = ($out | Where-Object { $_ -like '*.*' }).Count

Write-Log "folders: copied=$copied skipped=$skipped missing=$missing"
Write-Log "plugins active: $pluginsBefore -> $pluginsAfter (+$enabled new, $upgraded upgraded, $deferred deferred)"
Write-Log 'task-0067 complete — run full-mast-scan.ps1'
