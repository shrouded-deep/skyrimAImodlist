# task-0054 folder integrity: compare Keizaal copies vs their true source
$SkyrimMods = 'E:\Skyrim\mods'
$NolvusMods = 'E:\Nolvus\Nolvus\MODS\mods'
$AnvilMods  = 'D:\Skyrim AI Modlist\Anvil\mods'

# VB robocopy folders (source: Nolvus) + the special Vokriinator Black folder
$vbFolders = @(
 'Apocalypse - Magic of Skyrim','Apocalypse - Additional Dremora Faces Patch','Mysticism - Additional Dremora Faces Patch',
 'Mysticism - Jump Spell Addon','Mysticism - USSEP Container Patch','Mysticism - The Cause Rebalance','Mysticism - Lower Charge Time',
 'Mysticism - No Projectile Weight','Mysticism - Spells For Npcs','Mysticism - Deadly Spell Impacts','Mysticism - Cleaned and Upscaled [2K]',
 'SPERG - Skyrim Perk Enhancements and Rebalanced Gameplay','SPERG - Optimised Scripts','Adamant - Apocalypse Patch',
 'Path of Sorcery - Magic Perk Overhaul','Path of Sorcery - Apocalypse Patch','Path of Sorcery - Arcane Accessories Patch',
 'Path of Sorcery - Bittercup Patch','Path of Sorcery - Necromantic Grimoire Patch','Path of Sorcery - Plague of the Dead Patch',
 'Path of Sorcery - Saints and Seducers Patch','Path of Sorcery - The Cause Patch','Path of Sorcery - Creation Club Leveled List Patch',
 "Path of Sorcery - Discrepancy's PoS Mashup Patch",'Vokrii - Minimalistic Perks of Skyrim','Vokrii - Apocalypse Patch',
 'Vokrii - Mysticism Patch','Vokrii - Scrambled Bugs Compatibility','Vokrii - Optimised Scripts','Ordinator','Ordinator - Mysticism Patch',
 'Ordinator - Apocalypse Patch','Ordinator - Beyond Skyrim Patch','Ordinator - Combat Styles','Ordinator - No Timed Block',
 'Ordinator - Scrambled Bugs compatibility','Ordinator - Optimised Scripts','Ordinator Reworked - Combat Mod Compatibility',
 'Vokriinator Black - Apocalypse Patch','Vokriinator Black - No Timed Blocking','Vokriinator Black - Ethereal Arrows Fix',
 'Vokriinator Black - Combat Tweaks',"Vokriinator Black - Discrepancy's ISC Patch",'Vokriinator Black'
)
# City folders currently ENABLED (skip dropped Spaghetti) — source: Anvil
$cityFolders = @(
 'Capital Whiterun Expansion','Capital Windhelm Expansion','Ultimate Markarth','Ultimate Markarth Expanded',
 "RedBag's Solitude",'City of Crossed Daggers - Riften Expansion','Riverwood Has Charm and Walls',
 "Rob's Bug Fixes - Capital Whiterun",'RedBag Patch Collection','Riverwood Has Walls Patch Collection','UME Patch Hub'
)

function Measure-Folder($path){
 if(-not (Test-Path -LiteralPath $path)){ return $null }
 $files = Get-ChildItem -LiteralPath $path -Recurse -File -ErrorAction SilentlyContinue
 $sum = ($files | Measure-Object -Property Length -Sum).Sum
 return [pscustomobject]@{ Count=$files.Count; Bytes=[long]($sum) }
}

$problems = @()
function Check($folder,$srcRoot){
 $dst = Join-Path $SkyrimMods $folder
 $src = Join-Path $srcRoot $folder
 $d = Measure-Folder $dst
 $s = Measure-Folder $src
 if(-not $d){ Write-Host "MISSING DST: $folder"; $script:problems += "MISSING DST: $folder"; return }
 if(-not $s){ Write-Host "  (no source to compare): $folder"; return }
 $flag = ''
 if($d.Count -lt $s.Count -or $d.Bytes -lt $s.Bytes){ $flag=' <<< INCOMPLETE'; $script:problems += "INCOMPLETE: $folder (dst $($d.Count)f/$($d.Bytes)b vs src $($s.Count)f/$($s.Bytes)b)" }
 if($flag){ Write-Host ("{0,-55} dst {1,4}f/{2,10}b  src {3,4}f/{4,10}b{5}" -f $folder,$d.Count,$d.Bytes,$s.Count,$s.Bytes,$flag) }
}

Write-Host "=== VB folders (vs Nolvus) ==="
foreach($f in $vbFolders){ Check $f $NolvusMods }
Write-Host "=== City folders (vs Anvil) ==="
foreach($f in $cityFolders){ Check $f $AnvilMods }

Write-Host ""
if($problems.Count -eq 0){ Write-Host "RESULT: all copied folders complete (dst >= src for count and bytes)" }
else { Write-Host "RESULT: $($problems.Count) problem folder(s):"; $problems | ForEach-Object { Write-Host "  $_" } }