# task-0063: Anvil gameplay QoL tranche for Keizaal - Fork
#Requires -Version 5.1
$ErrorActionPreference = 'Stop'

function Assert-Mo2Closed {
    $procs = Get-Process -Name 'ModOrganizer','modorganizer' -ErrorAction SilentlyContinue
    if ($procs) { throw 'MO2 is running — close Mod Organizer before running this script.' }
}

$AnvilMods   = 'D:\Skyrim AI Modlist\Anvil\mods'
$SkyrimMods  = 'E:\Skyrim\mods'
$Profile     = 'E:\Skyrim\profiles\Keizaal - Fork'
$ModlistPath = Join-Path $Profile 'modlist.txt'
$PluginsPath = Join-Path $Profile 'plugins.txt'
$LoadOrderPath = Join-Path $Profile 'loadorder.txt'
$LogPath = 'D:\Skyrim AI Modlist\anvil-successor\modlist\exports\install-gameplay-tranche-run.log'

function Write-Log($msg) {
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $msg"
    Add-Content -Path $LogPath -Value $line
    Write-Host $line
}

Assert-Mo2Closed
if (Test-Path $LogPath) { Remove-Item $LogPath -Force }
Write-Log 'task-0063 gameplay tranche install starting'

$gameplayModFolders = @(
    'Summon Shadow MERCHANT',
    'Signature Equipment',
    'Reading Is Bad SKSE',
    'Puzzle Pillar Auto-Solve',
    'NPC Stats Editor',
    'No Enchantment Restriction SKSE Remake',
    'Jewelry of Power',
    'Infinite Stamina Out of Combat',
    'Infinite Shouting Out of Combat',
    'Infinite Magicka Out of Combat',
    'Infinite Horse Stamina Out of Combat',
    'Infinite Enchantment Charges',
    'In-Game Equipment Editor SE',
    'Dragon Claws Auto-Unlock',
    'Detect Levers and Keys',
    'TDM - First Person Target Locking Fix',
    'Simpler Dragon Targeting - True Directional Movement',
    'True Directional Movement - Tail Animation Fix',
    'True Directional Movement Lock-on Fixes',
    'Classic Sprinting Redone (Anniversary Edition)'
)

$gameplayPlugins = @(
    'SummonShadowMERCHANT.esp',
    'SignatureEquipment.esp',
    'ReadingIsBad.esp',
    'Jewelry Of Power.esp',
    'Infinite Stamina Out of Combat.esp',
    'Infinite Shouting Out of Combat.esp',
    'Infinite Magicka Out of Combat.esp',
    'InfiniteHorseStaminaOutofCombat.esp',
    'infiniteCharge.esp',
    'EquipmentStateCopy&Rename.esl',
    'Dragon Claws Auto-Unlock.esp',
    'DetectLever.esp',
    'TDM Target Lock Fix - Bristleback.esp'
)

$enableSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($m in $gameplayModFolders) { [void]$enableSet.Add($m) }

$copied = 0
$skipped = 0
$missing = 0
foreach ($folder in $gameplayModFolders) {
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

# --- modlist.txt: enable + insert above Uncategorized_separator ---
$modlist = Get-Content $ModlistPath
$newModlist = New-Object System.Collections.Generic.List[string]
$seen = @{}
$uncatMarker = 'Uncategorized_separator'

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
        if ($name -eq $uncatMarker) {
            foreach ($mod in $gameplayModFolders) {
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
Write-Log "modlist.txt: $($seen.Count) gameplay mods enabled above Uncategorized"

# --- plugins.txt ---
$pluginsBefore = (Get-Content $PluginsPath | Where-Object { $_ -like '*.*' }).Count
$plugins = Get-Content $PluginsPath
$existing = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($line in $plugins) {
    $bare = $line.TrimStart('*').Trim()
    if ($bare) { [void]$existing.Add($bare) }
}
$out = [System.Collections.Generic.List[string]]::new()
foreach ($line in $plugins) { [void]$out.Add([string]$line) }
$addedPlugins = 0
foreach ($esp in $gameplayPlugins) {
    if (-not $existing.Contains($esp)) {
        $out.Add("*$esp")
        [void]$existing.Add($esp)
        $addedPlugins++
    }
}
Set-Content -Path $PluginsPath $out -Encoding UTF8
$pluginsAfter = ($out | Where-Object { $_ -like '*.*' }).Count

# --- loadorder.txt ---
$lo = Get-Content $LoadOrderPath
$anchor = 'Keizaal Maintenance.esp'
$idx = [array]::IndexOf($lo, $anchor)
if ($idx -lt 0) { $idx = $lo.Count }
$toInsert = $gameplayPlugins | Where-Object { $_ -notin $lo }
$newLo = if ($idx -ge 0) { $lo[0..($idx-1)] + $toInsert + $lo[$idx..($lo.Count-1)] } else { $lo + $toInsert }
Set-Content -Path $LoadOrderPath $newLo -Encoding UTF8

Write-Log "folders: copied=$copied skipped=$skipped missing=$missing"
Write-Log "plugins active: $pluginsBefore -> $pluginsAfter (+$addedPlugins new)"
Write-Log "loadorder: $($toInsert.Count) plugins inserted before $anchor"
Write-Log 'task-0063 complete — run full-mast-scan.ps1'
