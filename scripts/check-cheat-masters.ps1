$plugins = @(
  @{ Plugin = 'Detect Lever.esp'; Folder = 'Detect Levers and Keys' },
  @{ Plugin = 'Dragon Claws Auto-Unlock.esp'; Folder = 'Dragon Claws Auto-Unlock' },
  @{ Plugin = 'IA710_HandyCraftingAndSpells.esp'; Folder = 'Handy Crafting and Spells - Crafting Storage and Travel Enhancements' },
  @{ Plugin = 'EquipmentStateCopy&Rename.esl'; Folder = 'In-Game Equipment Editor SE' },
  @{ Plugin = 'infiniteCharge.esp'; Folder = 'Infinite Enchantment Charges' },
  @{ Plugin = 'InfiniteHorseStaminaOutofCombat.esp'; Folder = 'Infinite Horse Stamina Out of Combat' },
  @{ Plugin = 'Infinite Magicka Out of Combat.esp'; Folder = 'Infinite Magicka Out of Combat' },
  @{ Plugin = 'Infinite Shouting Out of Combat.esp'; Folder = 'Infinite Shouting Out of Combat' },
  @{ Plugin = 'Infinite Stamina Out of Combat.esp'; Folder = 'Infinite Stamina Out of Combat' },
  @{ Plugin = 'Jewelry Of Power.esp'; Folder = 'Jewelry of Power' },
  @{ Plugin = 'PuzzleSolver.esp'; Folder = 'Puzzle Solver' },
  @{ Plugin = 'ReadingIsBad.esp'; Folder = 'Reading Is Bad SKSE' },
  @{ Plugin = 'RMXActorValueBook.esp'; Folder = 'RMX Actor Value Book' },
  @{ Plugin = 'SignatureEquipment.esp'; Folder = 'Signature Equipment' },
  @{ Plugin = 'Skyrim Cheat Engine.esp'; Folder = 'Skyrim Cheat Engine' },
  @{ Plugin = 'SmartCast_1_0.esp'; Folder = 'Smart Cast - Faster checks edition (Turbo mod)' },
  @{ Plugin = 'SmartHarvestSE.esp'; Folder = 'Smart Harvest NG AutoLoot' },
  @{ Plugin = 'Levitate Toggle-able Spell.esp'; Folder = 'Soarin'' Over Skyrim - A flying mod' },
  @{ Plugin = 'SummonShadowMERCHANT.esp'; Folder = 'Summon Shadow MERCHANT' }
)

$base = 'D:\Skyrim AI Modlist\Anvil\mods'
$profilePlugins = Get-Content 'D:\Skyrim AI Modlist\Anvil\profiles\Anvil - Main Profile\plugins.txt' | ForEach-Object { $_.Trim('*') }

foreach ($entry in $plugins) {
  $p = $entry.Plugin
  $folder = $entry.Folder
  $path = Join-Path $base $folder
  Write-Output "=== $p ($folder) ==="
  $file = Get-ChildItem -Path $path -Recurse -Filter $p -ErrorAction SilentlyContinue | Select-Object -First 1
  if (-not $file) { Write-Output 'PLUGIN NOT FOUND'; Write-Output ''; continue }
  $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
  $text = [System.Text.Encoding]::ASCII.GetString($bytes)
  $matches = [regex]::Matches($text, '(Skyrim\.esm|Update\.esm|Dawnguard\.esm|HearthFires\.esm|Dragonborn\.esm|Unofficial Skyrim Special Edition Patch\.esp|[A-Za-z0-9_\-''& ]+\.(esp|esm|esl))')
  $uniq = $matches | ForEach-Object { $_.Value.Trim() } | Where-Object { $_ -notmatch '^(esp|esm|esl)$' } | Select-Object -Unique
  Write-Output 'Likely masters:'
  $uniq | ForEach-Object { Write-Output "  $_" }
  $missing = @()
  foreach ($m in $uniq) {
    if ($m -match '\.(esp|esm|esl)$' -and $m -ne $p) {
      if ($profilePlugins -notcontains $m) { $missing += $m }
    }
  }
  if ($missing.Count -gt 0) {
    Write-Output 'MISSING from profile plugins.txt:'
    $missing | ForEach-Object { Write-Output "  $_" }
  } else {
    Write-Output 'All non-vanilla masters appear in profile (or none beyond vanilla/DLC).'
  }
  Write-Output ''
}
