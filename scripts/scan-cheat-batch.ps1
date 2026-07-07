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
  Write-Output "=== $m ==="
  if (-not (Test-Path $path)) { Write-Output 'MISSING FOLDER'; continue }
  if (Test-Path (Join-Path $path 'meta.ini')) {
    Get-Content (Join-Path $path 'meta.ini') | Select-String -Pattern '^(modid|version|newestVersion|nexusLastModified)=' | ForEach-Object { $_.Line }
  }
  $files = Get-ChildItem -Path $path -Recurse -Include *.esp,*.esm,*.esl,*.dll,*.psc -ErrorAction SilentlyContinue
  if ($files) { $files | ForEach-Object { $_.FullName.Substring($path.Length+1) } } else { Write-Output '(no esp/esm/esl/dll/psc)' }
  Write-Output ''
}
