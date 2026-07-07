$mods = @(
  'Detect Levers and Keys',
  'Dragon Claws Auto-Unlock',
  'Handy Crafting and Spells - Crafting Storage and Travel Enhancements',
  'In-Game Equipment Editor SE',
  'Infinite Enchantment Charges',
  'Infinite Horse Stamina Out of Combat',
  'Infinite Magicka Out of Combat',
  'Infinite Shouting Out of Combat',
  'Infinite Stamina Out of Combat',
  'Jewelry of Power',
  'No Enchantment Restriction SKSE Remake',
  'Puzzle Pillar Auto-Solve',
  'Puzzle Solver',
  'Reading Is Bad SKSE',
  'RMX Actor Value Book',
  'Signature Equipment',
  'Skyrim Cheat Engine',
  'Smart Cast - Faster checks edition (Turbo mod)',
  'Smart Harvest NG AutoLoot',
  'Soarin'' Over Skyrim - A flying mod',
  'Summon Shadow MERCHANT',
  'NPC Stats Editor'
)
foreach ($m in $mods) {
  $path = Join-Path 'D:\Skyrim AI Modlist\Anvil\mods' $m
  $esp = @(Get-ChildItem $path -Recurse -Include *.esp,*.esm,*.esl -ErrorAction SilentlyContinue).Count
  $dll = @(Get-ChildItem $path -Recurse -Filter *.dll -ErrorAction SilentlyContinue).Count
  $pex = @(Get-ChildItem $path -Recurse -Filter *.pex -ErrorAction SilentlyContinue).Count
  $psc = @(Get-ChildItem $path -Recurse -Filter *.psc -ErrorAction SilentlyContinue).Count
  Write-Output ("{0} | esp={1} dll={2} pex={3} psc={4}" -f $m,$esp,$dll,$pex,$psc)
}
