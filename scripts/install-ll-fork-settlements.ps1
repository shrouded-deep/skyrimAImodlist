# task-0074: Settlement overhaul stack for Lost Legacy - Fork
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

function Test-VanillaMaster([string]$m) {
    return $m -match '^(Skyrim|Update|Dawnguard|HearthFires|Dragonborn)\.esm$' -or
           $m -match '^cc[a-zA-Z0-9_-]+\.(esm|esl|esp)$' -or
           $m -eq '_ResourcePack.esl'
}

function Get-ModPlugins([string]$ModPath) {
    if (-not (Test-Path -LiteralPath $ModPath)) { return @() }
    Get-ChildItem -LiteralPath $ModPath -Recurse -Include *.esp, *.esm, *.esl -File -EA SilentlyContinue |
        Where-Object { $_.Extension -ne '.mohidden' -and $_.Name -notmatch '\.mohidden$' } |
        Select-Object -ExpandProperty Name
}

function Find-Archive([int]$NexusId, [string]$PreferPattern) {
    $hits = @(Get-ChildItem -LiteralPath $Downloads -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Extension -in '.7z', '.zip', '.rar' -and $_.Name -match "-$NexusId-" })
    if ($hits.Count -eq 0) { return $null }
    if ($PreferPattern) {
        $preferred = @($hits | Where-Object { $_.Name -match $PreferPattern } | Sort-Object Name -Descending)
        if ($preferred.Count -gt 0) { return $preferred[0] }
    }
    return ($hits | Sort-Object Name -Descending | Select-Object -First 1)
}

function Hoist-DataToModRoot([string]$FolderPath) {
    $dataPath = Join-Path $FolderPath 'Data'
    if (-not (Test-Path -LiteralPath $dataPath)) { return }
    Get-ChildItem -LiteralPath $dataPath -Force | ForEach-Object {
        $dest = Join-Path $FolderPath $_.Name
        if ($_.PSIsContainer) {
            if (Test-Path -LiteralPath $dest) {
                robocopy $_.FullName $dest /E /MOVE /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
                if (Test-Path -LiteralPath $_.FullName) { Remove-Item -LiteralPath $_.FullName -Recurse -Force }
            }
            else { Move-Item -LiteralPath $_.FullName -Destination $FolderPath -Force }
        }
        else {
            if (Test-Path -LiteralPath $dest) { Remove-Item -LiteralPath $dest -Force }
            Move-Item -LiteralPath $_.FullName -Destination $FolderPath -Force
        }
    }
    if (Test-Path -LiteralPath $dataPath) { Remove-Item -LiteralPath $dataPath -Recurse -Force }
}

function Install-ArchiveMod([string]$FolderName, [int]$NexusId, [string]$PreferPattern) {
    $dst = Join-Path $SkyrimMods $FolderName
    if (Test-Path -LiteralPath $dst) {
        Write-Log "SKIP exists: $FolderName"
        return @{ Status = 'skipped'; Archive = $null }
    }
    $archive = Find-Archive $NexusId $PreferPattern
    if (-not $archive) {
        Write-Log "MISSING archive Nexus $NexusId for $FolderName"
        return @{ Status = 'missing'; Archive = $null }
    }

    $tmp = Join-Path $env:TEMP "ll-settlements-$NexusId"
    if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
    New-Item -ItemType Directory -Path $tmp -Force | Out-Null
    Write-Log "EXTRACT $($archive.Name) -> $FolderName"
    & $SevenZip x $archive.FullName "-o$tmp" -y | Out-Null
    if ($LASTEXITCODE -gt 1) { throw "7z extract failed for $($archive.Name) exit $LASTEXITCODE" }

    $top = @(Get-ChildItem $tmp -Force)
    $rootHasData = $top | Where-Object { -not $_.PSIsContainer -and $_.Extension -in '.esp', '.esm', '.esl', '.bsa' }
    New-Item -ItemType Directory -Path $dst -Force | Out-Null
    if ($top.Count -eq 1 -and $top[0].PSIsContainer -and -not $rootHasData) {
        Get-ChildItem $top[0].FullName -Force | Move-Item -Destination $dst -Force
    }
    else {
        Get-ChildItem $tmp -Force | Move-Item -Destination $dst -Force
    }
    Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
    Hoist-DataToModRoot $dst
    return @{ Status = 'installed'; Archive = $archive.Name }
}

$Downloads   = 'E:\Modding\Skyrim Mods\Downloads'
$SkyrimMods  = 'D:\Skyrim\mods'
$Profile     = 'D:\Skyrim\profiles\Lost Legacy - Fork'
$ModlistPath = Join-Path $Profile 'modlist.txt'
$PluginsPath = Join-Path $Profile 'plugins.txt'
$LoadOrderPath = Join-Path $Profile 'loadorder.txt'
$LogPath     = 'D:\Skyrim AI Modlist\anvil-successor\modlist\exports\install-ll-settlements-run.log'
$SevenZip    = 'C:\Program Files\7-Zip\7z.exe'

# COTN Morthal (34168) — not used; Fortified Morthal instead
$CotnMorthalMaster = 'COTN - Morthal.esp'
$SkipPluginNames = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
@(
    "RedBag's Rorikstead - Brighter Interiors.esp",
    "RedBag's Rorikstead - Even Brighter Interiors.esp"
) | ForEach-Object { [void]$SkipPluginNames.Add($_) }

# Shared TGC/TGV/TGT voice + asset master (Nexus 104373) — not in task table but required
$settlementModOrder = @(
  @{ Folder = 'The Great Cities - Resources'; Id = 104373; Prefer = $null },
  @{ Folder = 'Cities of the North - Dawnstar'; Id = 28952; Prefer = '28952-1-4' },
  @{ Folder = 'COTN Dawnstar Patch Collection'; Id = 30885; Prefer = '30885-5-7' },
  @{ Folder = 'Cities of the North - Falkreath'; Id = 56731; Prefer = '56731-1-3' },
  @{ Folder = 'COTN Falkreath Patch Collection'; Id = 56734; Prefer = '56734-1-27' },
  @{ Folder = 'The Great City of Winterhold'; Id = 17127; Prefer = '4\.1\.1-17127-4-1-1' },
  @{ Folder = 'The Great City of Winterhold Patch Collection'; Id = 74560; Prefer = '74560-2-9' },
  @{ Folder = 'The Great City of Dragon Bridge'; Id = 19962; Prefer = $null },
  @{ Folder = "Rob's Bug Fixes - TGC Dragon Bridge"; Id = 68412; Prefer = $null },
  @{ Folder = "JK's Solitude Outskirts"; Id = 103209; Prefer = '103209-1-2-2' },
  @{ Folder = "JK's Solitude Outskirts Patch Collection"; Id = 103927; Prefer = '103927-1-9' },
  @{ Folder = "Skyfall's Fortified Morthal"; Id = 126871; Prefer = $null },
  @{ Folder = 'Fortified Morthal Patch Collection'; Id = 126697; Prefer = '126697-2-4-1' },
  @{ Folder = "Thuldor's Ivarstead"; Id = 99494; Prefer = 'Thuldor''s Ivarstead-99494-1-1' },
  @{ Folder = "Thuldor's Ivarstead Patch Collection"; Id = 99494; Prefer = 'Patch Collection-99494-1-2' },
  @{ Folder = "Thuldor's Ivarstead - Tweaks and Fixes"; Id = 113706; Prefer = '113706-1-02' },
  @{ Folder = 'The Great Village of Kynesgrove'; Id = 42639; Prefer = $null },
  @{ Folder = 'The Great Village of Kynesgrove Patch Collection'; Id = 42957; Prefer = '42957-1-9' },
  @{ Folder = 'The Great Village of Mixwater Mill'; Id = 36350; Prefer = 'Mixwater Mill 1\.1' },
  @{ Folder = 'The Great Village of Mixwater Mill Patch Collection'; Id = 37414; Prefer = $null },
  @{ Folder = 'The Great Village of Old Hroldan'; Id = 33189; Prefer = $null },
  @{ Folder = 'The Great Village of Old Hroldan Patch Collection'; Id = 37650; Prefer = $null },
  @{ Folder = 'Darkwater Crossing - Eastmarch Addon'; Id = 64266; Prefer = $null },
  @{ Folder = 'Darkwater Crossing - Eastmarch Addon Patch Collection'; Id = 64382; Prefer = $null },
  @{ Folder = "RedBag's Rorikstead"; Id = 56114; Prefer = $null },
  @{ Folder = "Some Useful Patches"; Id = 64187; Prefer = $null },
  @{ Folder = 'The Great Town of Karthwasten'; Id = 33032; Prefer = '33032-2-0' },
  @{ Folder = 'The Great Town of Karthwasten Patch Collection'; Id = 37471; Prefer = '37471-2-6-1' },
  @{ Folder = "The Great Town of Shor's Stone"; Id = 35977; Prefer = $null },
  @{ Folder = "The Great Town of Shor's Stone Patch Collection"; Id = 36462; Prefer = '36462-2-4-1-1739138674' },
  @{ Folder = "Anga's Mill - COTN Addon"; Id = 64398; Prefer = $null },
  @{ Folder = "Anga's Mill - COTN Addon Patch Collection"; Id = 64685; Prefer = '64685-1-4-2' },
  @{ Folder = 'Half-Moon Mill - COTN Addon'; Id = 64360; Prefer = '64360-1-5' },
  @{ Folder = 'Half-Moon Mill - COTN Addon Patch Collection'; Id = 64522; Prefer = $null },
  @{ Folder = 'Settlements Expanded'; Id = 7777; Prefer = '7777-1-4' }
)

Assert-Mo2Closed
if (-not (Test-Path $SevenZip)) { throw "7-Zip not found at $SevenZip" }
if (Test-Path $LogPath) { Remove-Item $LogPath -Force }
Write-Log 'task-0074 Lost Legacy - Fork settlements stack starting'

$pluginsBefore = (Get-Content $PluginsPath | Where-Object { $_ -match '^\*' }).Count
Write-Log "plugins active before: $pluginsBefore"

$sepDir = Join-Path $SkyrimMods 'Settlements_separator'
if (-not (Test-Path -LiteralPath $sepDir)) {
    New-Item -ItemType Directory -Path $sepDir -Force | Out-Null
    Write-Log 'CREATE separator folder: Settlements_separator'
}

$installed = [System.Collections.Generic.List[string]]::new()
$archivesUsed = [System.Collections.Generic.List[string]]::new()
$missingArchives = [System.Collections.Generic.List[string]]::new()

foreach ($entry in $settlementModOrder) {
    if ($entry.Folder -eq 'The Great City of Winterhold') {
        $wh = Join-Path $SkyrimMods $entry.Folder
        if (Test-Path -LiteralPath $wh) {
            Write-Log 'REINSTALL The Great City of Winterhold (ensure 4.1.1 archive)'
            Remove-Item -LiteralPath $wh -Recurse -Force
        }
    }
    $result = Install-ArchiveMod $entry.Folder $entry.Id $entry.Prefer
    switch ($result.Status) {
        'installed' {
            [void]$installed.Add($entry.Folder)
            [void]$archivesUsed.Add("$($entry.Folder) <= $($result.Archive)")
        }
        'missing' {
            [void]$missingArchives.Add("$($entry.Folder) (Nexus $($entry.Id))")
        }
    }
}

$enableSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($entry in $settlementModOrder) {
    if (Test-Path -LiteralPath (Join-Path $SkyrimMods $entry.Folder)) {
        [void]$enableSet.Add($entry.Folder)
    }
}

# --- modlist.txt: insert Settlements section above City Stack ---
$modlist = Get-Content $ModlistPath
$newModlist = [System.Collections.Generic.List[string]]::new()
$settlementsInserted = $false
$seen = @{}

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
        if ($name -eq 'Settlements_separator' -and -not $settlementsInserted) {
            foreach ($entry in $settlementModOrder) {
                $mod = $entry.Folder
                if ($enableSet.Contains($mod) -and -not $seen.ContainsKey($mod)) {
                    $newModlist.Add("+$mod")
                    $seen[$mod] = $true
                }
            }
            $newModlist.Add('-Settlements_separator')
            $settlementsInserted = $true
            $newModlist.Add($line)
            continue
        }
        if ($name -eq 'Ryn''s Mods_separator' -and -not $settlementsInserted) {
            foreach ($entry in $settlementModOrder) {
                $mod = $entry.Folder
                if ($enableSet.Contains($mod) -and -not $seen.ContainsKey($mod)) {
                    $newModlist.Add("+$mod")
                    $seen[$mod] = $true
                }
            }
            $newModlist.Add('-Settlements_separator')
            $settlementsInserted = $true
            $newModlist.Add($line)
            continue
        }
    }
    $newModlist.Add($line)
}

if (-not $settlementsInserted) { throw 'Anchor not found: Settlements_separator or Ryn''s Mods_separator' }
Set-Content -Path $ModlistPath -Value $newModlist -Encoding UTF8
Write-Log "modlist: enabled $($seen.Count) settlement mods above Settlements_separator"

# --- plugins.txt: enable new mod plugins (MAST + COTN Morthal filter) ---
$enablePlugins = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($mod in $enableSet) {
    foreach ($p in (Get-ModPlugins (Join-Path $SkyrimMods $mod))) {
        if ($SkipPluginNames.Contains($p)) { continue }
        [void]$enablePlugins.Add($p)
    }
}

$corePlugins = @(
    'Resources - The Great Cities.esp',
    'COTN - Dawnstar.esp',
    'COTN - Falkreath.esp',
    'The Great City of Winterhold v4.esp',
    'The Great City of Dragon Bridge.esp',
    "RedBag's Rorikstead.esp",
    'Fortified Morthal.esp',
    "JK's Solitude Outskirts.esp",
    "Thuldor's Ivarstead.esp",
    'The Great Village of Kynesgrove.esp',
    'The Great Village of Mixwater Mill.esp',
    'The Great Village of Old Hroldan.esp',
    'Darkwater Crossing - TGC Addon.esp',
    'The Great Town of Karthwasten.esp',
    "The Great Town of Shor's Stone.esp",
    'COTN Addon - Anga''s Mill.esp',
    'Half-Moon Mill - COTNed.esp',
    'Settlements Expanded SE.esp'
)
foreach ($core in $corePlugins) { [void]$enablePlugins.Add($core) }

$out = [System.Collections.Generic.List[string]]::new()
foreach ($line in (Get-Content $PluginsPath)) {
    if ($line -match '^\*(.+)$') {
        $bare = $Matches[1]
        if ($enablePlugins.Contains($bare)) { $out.Add($line); continue }
    }
    $bare2 = $line.TrimStart('*').Trim()
    if ($enablePlugins.Contains($bare2) -and $line -notmatch '^\*') {
        $out.Add("*$bare2")
        continue
    }
    [void]$out.Add([string]$line)
}
foreach ($p in $enablePlugins) {
    $found = $false
    foreach ($line in $out) {
        if ($line.TrimStart('*').Trim().Equals($p, [StringComparison]::OrdinalIgnoreCase)) { $found = $true; break }
    }
    if (-not $found) { $out.Add("*$p") }
}

$enabledMods = $newModlist | Where-Object { $_ -match '^\+' } | ForEach-Object { $_ -replace '^\+', '' } | Where-Object { $_ -notmatch '_separator$' }
$pluginIndex = @{}
foreach ($mod in $enabledMods) {
    $d = Join-Path $SkyrimMods $mod
    if (-not (Test-Path -LiteralPath $d)) { continue }
    Get-ChildItem -LiteralPath $d -Recurse -Include *.esp, *.esm, *.esl -File -EA SilentlyContinue | ForEach-Object {
        if (-not $pluginIndex.ContainsKey($_.Name)) { $pluginIndex[$_.Name] = $_.FullName }
    }
}
Get-ChildItem 'D:\Skyrim\root\Data' -File -EA SilentlyContinue | Where-Object { $_.Extension -in '.esp', '.esm', '.esl' } | ForEach-Object {
    if (-not $pluginIndex.ContainsKey($_.Name)) { $pluginIndex[$_.Name] = $_.FullName }
}

function Test-PluginMastersActive([string]$PluginName, [hashtable]$ActiveNorm, [hashtable]$PluginIndex) {
    $path = $PluginIndex[$PluginName]
    if (-not $path) { return $false }
    foreach ($m in (Get-PluginMasters $path)) {
        if (Test-VanillaMaster $m) { continue }
        if ($m.Equals($CotnMorthalMaster, [StringComparison]::OrdinalIgnoreCase)) { return $false }
        if (-not $ActiveNorm.ContainsKey($m.ToLowerInvariant())) { return $false }
    }
    return $true
}

$disabledMast = [System.Collections.Generic.List[string]]::new()
$starred = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($line in $out) {
    if ($line -match '^\*(.+)$') { [void]$starred.Add($Matches[1]) }
}
foreach ($p in $enablePlugins) { [void]$starred.Add($p) }

for ($pass = 0; $pass -lt 15; $pass++) {
    $activeNorm = @{}
    foreach ($a in $starred) { $activeNorm[$a.ToLowerInvariant()] = $a }
    $changed = $false
    foreach ($p in @($starred)) {
        if (-not (Test-PluginMastersActive $p $activeNorm $pluginIndex)) {
            [void]$starred.Remove($p)
            [void]$disabledMast.Add("$p -> missing master(s)")
            $changed = $true
        }
    }
    if (-not $changed) { break }
}

$final = [System.Collections.Generic.List[string]]::new()
$seenPlugins = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($line in $out) {
    if ($line -match '^\*(.+)$' -or ($line.TrimStart('*').Trim() -match '\.(esp|esm|esl)$')) {
        $bare = $line.TrimStart('*').Trim()
        if ($seenPlugins.Contains($bare)) { continue }
        [void]$seenPlugins.Add($bare)
        if ($starred.Contains($bare)) { $final.Add("*$bare") }
        else { $final.Add($bare) }
        continue
    }
    [void]$final.Add([string]$line)
}
foreach ($p in $starred) {
    if (-not $seenPlugins.Contains($p)) {
        $final.Add("*$p")
        [void]$seenPlugins.Add($p)
    }
}

$disabledSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($d in $disabledMast) {
    $name = ($d -split ' -> ')[0]
    [void]$disabledSet.Add($name)
}
$loadorder = @(Get-Content $LoadOrderPath | Where-Object { -not $disabledSet.Contains($_) })

Set-Content -Path $PluginsPath -Value $final -Encoding UTF8
Set-Content -Path $LoadOrderPath -Value $loadorder -Encoding UTF8

$pluginsAfter = ($final | Where-Object { $_ -match '^\*' }).Count
Write-Log "installed mods: $($installed.Count)"
foreach ($a in $archivesUsed) { Write-Log "  ARCHIVE $a" }
foreach ($m in $missingArchives) { Write-Log "  MISSING $m" }
Write-Log "MAST-disabled $($disabledMast.Count) plugins"
foreach ($d in $disabledMast) { Write-Log "  DISABLE $d" }
Write-Log "plugins active after: $pluginsAfter"
Write-Log 'task-0074 complete — MO2 F5 refresh + in-game spot check'
