# task-0050: Install Vokriinator Black core stack on Keizaal - Fork
#Requires -Version 5.1
$ErrorActionPreference = 'Stop'

$NolvusMods   = 'E:\Nolvus\Nolvus\MODS\mods'
$SkyrimMods   = 'E:\Skyrim\mods'
$Downloads    = 'E:\Modding\Skyrim Mods\Downloads'
$Profile      = 'E:\Skyrim\profiles\Keizaal - Fork'
$ModlistPath  = Join-Path $Profile 'modlist.txt'
$PluginsPath  = Join-Path $Profile 'plugins.txt'
$LoadOrderPath = Join-Path $Profile 'loadorder.txt'
$LogPath      = 'D:\Skyrim AI Modlist\anvil-successor\modlist\exports\install-vb-stack-run.log'

function Write-Log($msg) {
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $msg"
    Add-Content -Path $LogPath -Value $line
    Write-Host $line
}

if (Test-Path $LogPath) { Remove-Item $LogPath -Force }
Write-Log 'task-0050 VB stack install starting'

$vbModFolders = @(
    'Apocalypse - Magic of Skyrim',
    'Apocalypse - Additional Dremora Faces Patch',
    'Mysticism - Additional Dremora Faces Patch',
    'Mysticism - Jump Spell Addon',
    'Mysticism - USSEP Container Patch',
    'Mysticism - The Cause Rebalance',
    'Mysticism - Lower Charge Time',
    'Mysticism - No Projectile Weight',
    'Mysticism - Spells For Npcs',
    'Mysticism - Deadly Spell Impacts',
    'Mysticism - Cleaned and Upscaled [2K]',
    'SPERG - Skyrim Perk Enhancements and Rebalanced Gameplay',
    'SPERG - Optimised Scripts',
    'Adamant - Apocalypse Patch',
    'Path of Sorcery - Magic Perk Overhaul',
    'Path of Sorcery - Apocalypse Patch',
    'Path of Sorcery - Arcane Accessories Patch',
    'Path of Sorcery - Bittercup Patch',
    'Path of Sorcery - Necromantic Grimoire Patch',
    'Path of Sorcery - Plague of the Dead Patch',
    'Path of Sorcery - Saints and Seducers Patch',
    'Path of Sorcery - The Cause Patch',
    'Path of Sorcery - Creation Club Leveled List Patch',
    "Path of Sorcery - Discrepancy's PoS Mashup Patch",
    'Vokrii - Minimalistic Perks of Skyrim',
    'Vokrii - Apocalypse Patch',
    'Vokrii - Mysticism Patch',
    'Vokrii - Scrambled Bugs Compatibility',
    'Vokrii - Optimised Scripts',
    'Ordinator',
    'Ordinator - Mysticism Patch',
    'Ordinator - Apocalypse Patch',
    'Ordinator - Beyond Skyrim Patch',
    'Ordinator - Combat Styles',
    'Ordinator - No Timed Block',
    'Ordinator - Scrambled Bugs compatibility',
    'Ordinator - Optimised Scripts',
    'Ordinator Reworked - Combat Mod Compatibility',
    'Vokriinator Black - Apocalypse Patch',
    'Vokriinator Black - No Timed Blocking',
    'Vokriinator Black - Ethereal Arrows Fix',
    'Vokriinator Black - Combat Tweaks',
    "Vokriinator Black - Discrepancy's ISC Patch"
)

$enableExisting = @(
    'Mysticism - A Magic Overhaul',
    'Adamant - A Perk Overhaul',
    'Additional Dremora Faces'
)

$SevenZip = 'C:\Program Files\7-Zip\7z.exe'
if (-not (Test-Path $SevenZip)) { throw "7-Zip not found at $SevenZip" }
foreach ($folder in $vbModFolders) {
    $src = Join-Path $NolvusMods $folder
    $dst = Join-Path $SkyrimMods $folder
    if (-not (Test-Path -LiteralPath $src)) {
        Write-Log "WARN missing on Nolvus: $folder"
        continue
    }
    if (Test-Path $dst) {
        Write-Log "SKIP exists: $folder"
        continue
    }
    Write-Log "COPY $folder"
    robocopy $src $dst /E /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "robocopy failed for $folder exit $LASTEXITCODE" }
}

# Vokriinator Black 6.15.x from downloads archive
$vbArchive = Get-ChildItem $Downloads -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Extension -in '.7z','.zip' -and $_.Name -match 'Vokriinator Black-26702-6-15' } |
    Sort-Object LastWriteTime -Descending | Select-Object -First 1
if ($vbArchive) {
    $vbDest = Join-Path $SkyrimMods 'Vokriinator Black'
    if (Test-Path $vbDest) { Remove-Item $vbDest -Recurse -Force }
    $tmp = Join-Path $env:TEMP 'vb-extract'
    if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
    New-Item -ItemType Directory -Path $tmp | Out-Null
    Write-Log "EXTRACT $($vbArchive.Name) -> Vokriinator Black"
    & $SevenZip x $vbArchive.FullName "-o$tmp" -y | Out-Null
    if ($LASTEXITCODE -gt 1) { throw "7z extract failed exit $LASTEXITCODE" }
    # Determine the mod root. Only descend into a wrapper dir if $tmp contains
    # EXACTLY one item and it is a directory. If $tmp holds plugin/data files at
    # root (esp/esm/bsa) or multiple items, $tmp itself IS the mod root — moving a
    # single 'scripts'/'source' subfolder here silently drops the .esp (task-0052 bug).
    $top = Get-ChildItem $tmp -Force
    $rootHasData = $top | Where-Object { $_.PSIsContainer -eq $false -and $_.Extension -in '.esp','.esm','.esl','.bsa' }
    if ($top.Count -eq 1 -and $top[0].PSIsContainer -and -not $rootHasData) {
        Move-Item $top[0].FullName $vbDest
    } else {
        New-Item -ItemType Directory -Path $vbDest -Force | Out-Null
        Move-Item (Join-Path $tmp '*') $vbDest -Force
    }
    # Post-copy verification: the core merge plugin MUST be present
    if (-not (Test-Path (Join-Path $vbDest 'Vokriinator Black.esp'))) {
        throw "VB install verify FAILED: Vokriinator Black.esp missing in $vbDest after extract"
    }
} else {
    Write-Log 'WARN VB 6.15 archive not found; copying Nolvus Vokriinator Black folder'
    $src = Join-Path $NolvusMods 'Vokriinator Black'
    $dst = Join-Path $SkyrimMods 'Vokriinator Black'
    if (-not (Test-Path $dst)) { robocopy $src $dst /E /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null }
}

# Crash Workaround — stage disabled mod if archive present
$crashArchive = Get-ChildItem $Downloads -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -match '146503|Crash Workaround' } | Select-Object -First 1
if ($crashArchive) {
    $cwDest = Join-Path $SkyrimMods 'Vokriinator Black - Crash Workaround'
    if (-not (Test-Path $cwDest)) {
        $tmp = Join-Path $env:TEMP 'vb-crash-extract'
        if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
        New-Item -ItemType Directory -Path $tmp | Out-Null
        Write-Log "EXTRACT crash workaround $($crashArchive.Name)"
        & $SevenZip x $crashArchive.FullName "-o$tmp" -y | Out-Null
        $inner = Get-ChildItem $tmp -Directory | Select-Object -First 1
        if ($inner) { Move-Item $inner.FullName $cwDest } else { Move-Item (Join-Path $tmp '*') $cwDest }
    }
} else {
    Write-Log 'NOTE Crash Workaround archive not found — download Nexus 146503 before smoke test if CTD'
}

# --- modlist.txt ---
$modlist = Get-Content $ModlistPath
$allEnable = $vbModFolders + $enableExisting + @('Vokriinator Black')
$allEnable += @('Vokriinator Black - Crash Workaround')

$newModlist = New-Object System.Collections.Generic.List[string]
$seen = @{}
foreach ($line in $modlist) {
    if ($line -match '^[+-](.+)$') {
        $name = $Matches[1].Trim()
        if ($allEnable -contains $name) {
            if (-not $seen.ContainsKey($name)) {
                $newModlist.Add("+$name")
                $seen[$name] = $true
            }
            continue
        }
    }
    $newModlist.Add($line)
}

if (-not ($newModlist -match '\[Keizaal Additions\]')) {
    $newModlist.Add('[Keizaal Additions]_separator')
}
foreach ($name in ($allEnable | Sort-Object -Unique)) {
    if (-not $seen.ContainsKey($name)) {
        if (Test-Path (Join-Path $SkyrimMods $name)) {
            $newModlist.Add("+$name")
            $seen[$name] = $true
        }
    }
}

Set-Content -Path $ModlistPath -Value $newModlist -Encoding UTF8
Write-Log "modlist.txt updated ($($seen.Count) VB mods enabled)"

# --- plugins ---
$vbPlugins = @(
    'Apocalypse - Magic of Skyrim.esp',
    'Additional Dremora Faces - Apocalypse Patch.esp',
    'MysticismMagic.esp',
    'Additional Dremora Faces - Mysticism Patch.esp',
    'MysticismJumpSpells.esp',
    'MysticismUSSEPContainerPatch.esp',
    'Mysticism - Spell Charge Time Lowered.esp',
    'SPERG-SSE.esp',
    'SPERG_ApocalypsePatch.esp',
    'SPERG_USSEPPatch.esp',
    'Adamant.esp',
    'Adamant - Apocalypse Patch.esp',
    'PathOfSorcery.esp',
    'PoS_Apocalypse_Patch.esp',
    'PoS_ArcaneAccessories_Patch.esp',
    'PoS_Bittercup_Patch.esp',
    'PoS_NecromanticGrimoire_Patch.esp',
    'PoS_PlagueOfTheDead_Patch.esp',
    'PoS_Saints&Seducers_Patch.esp',
    'PoS_TheCause_Patch.esp',
    'PoS_CreationClub_LList_Patch.esp',
    'DISCO_PathOfSorcery_Mashup.esp',
    'Vokrii - Minimalistic Perks of Skyrim.esp',
    'Apocalypse - Vokrii Compatibility Patch.esp',
    'Mysticism - Vokrii Compatibility Patch.esp',
    'Vokrii - Apply Spell Conditions Fix.esp',
    'Ordinator - Perks of Skyrim.esp',
    'Ordinator - No Directional Power Attacks - Balanced.esp',
    'Ordinator - Apply Spell Conditions Fix.esp',
    'Ordinator - Beyond Skyrim Bruma Patch.esp',
    'MysticOrdinator.esp',
    'Mysticism - No Projectile Weight.esp',
    'Ordinator - Combat Styles.esp',
    'Ordinator - No Timed Block.esp',
    'Apocalypse - Ordinator Compatibility Patch.esp',
    'Vokriinator Black.esp',
    'Vokriinator Black - Apocalypse patch.esp',
    'Vokriinator Black -- No Timed Blocking.esp',
    'Vokriinator Black Ethereal Arrow Fix.esp',
    'VokriinatorBlack - combatforcaco.esp',
    'DISCO_VokriinatorISCPatch.esp'
)

$plugins = Get-Content $PluginsPath
$activeBefore = ($plugins | Where-Object { $_ -like '*.*' }).Count
$vbSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($e in $vbPlugins) { [void]$vbSet.Add($e) }
$inactive = @('ConstellationsNewSkills.esp','Keizaal Patch - Book Covers Skyrim - Constellation.esp')

$newPlugins = New-Object System.Collections.Generic.List[string]
foreach ($line in $plugins) {
    $bare = $line.TrimStart('*').Trim()
    if ($inactive -contains $bare) { $newPlugins.Add($bare); continue }
    if ($line.StartsWith('#')) { $newPlugins.Add($line); continue }
    if ($vbSet.Contains($bare)) {
        $newPlugins.Add("*$bare")
        [void]$vbSet.Remove($bare)
        continue
    }
    $newPlugins.Add($line)
}
foreach ($esp in $vbSet) { $newPlugins.Add("*$esp") }
Set-Content -Path $PluginsPath -Value $newPlugins -Encoding UTF8
$activeAfter = ($newPlugins | Where-Object { $_ -like '*.*' }).Count
Write-Log "plugins.txt: active $activeBefore -> $activeAfter (+$($activeAfter - $activeBefore) VB)"

# --- loadorder ---
$lo = Get-Content $LoadOrderPath
$lo = $lo | Where-Object {
    $_ -notin @('ConstellationsNewSkills.esp','Keizaal Patch - Book Covers Skyrim - Constellation.esp')
}
$insertAfter = 'StaffEnchanting.esp'
$idx = [array]::IndexOf($lo, $insertAfter)
if ($idx -lt 0) { $idx = $lo.Count - 1 }
$before = $lo[0..$idx]
$after = if ($idx -lt $lo.Count - 1) { $lo[($idx + 1)..($lo.Count - 1)] } else { @() }
$newLo = $before + $vbPlugins + $after
Set-Content -Path $LoadOrderPath -Value $newLo -Encoding UTF8
Write-Log "loadorder.txt: inserted $($vbPlugins.Count) VB plugins after $insertAfter"

Write-Log 'task-0050 complete — MO2 F5 refresh required'
