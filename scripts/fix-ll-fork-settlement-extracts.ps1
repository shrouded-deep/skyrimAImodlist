# task-0077: Re-extract improperly installed settlement mods (Lost Legacy - Fork)
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

function Clear-ModFolder([string]$FolderPath) {
    if (-not (Test-Path -LiteralPath $FolderPath)) {
        New-Item -ItemType Directory -Path $FolderPath -Force | Out-Null
        return
    }
    Get-ChildItem -LiteralPath $FolderPath -Force | Remove-Item -Recurse -Force
}

function Move-ExtractedContent([string]$Source, [string]$Destination) {
    $top = @(Get-ChildItem -LiteralPath $Source -Force)
    $rootHasData = $top | Where-Object { -not $_.PSIsContainer -and $_.Extension -in '.esp', '.esm', '.esl', '.bsa' }
    if ($top.Count -eq 1 -and $top[0].PSIsContainer -and -not $rootHasData) {
        Get-ChildItem -LiteralPath $top[0].FullName -Force | Move-Item -Destination $Destination -Force
    }
    else {
        Get-ChildItem -LiteralPath $Source -Force | Move-Item -Destination $Destination -Force
    }
}

function Hoist-DataToModRoot([string]$FolderPath, [string]$FolderName) {
    $dataPath = Join-Path $FolderPath 'Data'
    if (-not (Test-Path -LiteralPath $dataPath)) { return $false }
    Get-ChildItem -LiteralPath $dataPath -Force | ForEach-Object {
        $dest = Join-Path $FolderPath $_.Name
        if ($_.PSIsContainer) {
            if (Test-Path -LiteralPath $dest) {
                robocopy $_.FullName $dest /E /MOVE /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
                if (Test-Path -LiteralPath $_.FullName) { Remove-Item -LiteralPath $_.FullName -Recurse -Force }
            }
            else {
                Move-Item -LiteralPath $_.FullName -Destination $FolderPath -Force
            }
        }
        else {
            if (Test-Path -LiteralPath $dest) { Remove-Item -LiteralPath $dest -Force }
            Move-Item -LiteralPath $_.FullName -Destination $FolderPath -Force
        }
    }
    if (Test-Path -LiteralPath $dataPath) { Remove-Item -LiteralPath $dataPath -Recurse -Force }
    Write-Log "HOIST $FolderName : Data\ -> mod root"
    return $true
}

function Normalize-ModStructure([string]$FolderPath, [string]$FolderName) {
    foreach ($fomodName in @('Fomod', 'fomod')) {
        $fomod = Join-Path $FolderPath $fomodName
        if (Test-Path -LiteralPath $fomod) {
            Remove-Item -LiteralPath $fomod -Recurse -Force
            Write-Log "NORMALIZE $FolderName : removed $fomodName installer folder"
        }
    }
    # FOMOD option folders (00 Data / 01 Main) — hoist contents to mod root, never leave Data\
    foreach ($opt in @('00 Data', '01 Main', '02 Patches')) {
        $optPath = Join-Path $FolderPath $opt
        if (-not (Test-Path -LiteralPath $optPath)) { continue }
        if ($opt -eq '02 Patches') {
            Get-ChildItem -LiteralPath $optPath -Filter *.esp -File -ErrorAction SilentlyContinue |
                Move-Item -Destination $FolderPath -Force
            Remove-Item -LiteralPath $optPath -Recurse -Force -ErrorAction SilentlyContinue
            Write-Log "NORMALIZE $FolderName : moved patch ESPs from 02 Patches to mod root"
            continue
        }
        Get-ChildItem -LiteralPath $optPath -Force | ForEach-Object {
            $dest = Join-Path $FolderPath $_.Name
            if ($_.PSIsContainer -and (Test-Path -LiteralPath $dest)) {
                robocopy $_.FullName $dest /E /MOVE /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
                if (Test-Path -LiteralPath $_.FullName) { Remove-Item -LiteralPath $_.FullName -Recurse -Force }
            }
            elseif (Test-Path -LiteralPath $dest) { Remove-Item -LiteralPath $dest -Force }
            else { Move-Item -LiteralPath $_.FullName -Destination $FolderPath -Force }
        }
        Remove-Item -LiteralPath $optPath -Recurse -Force -ErrorAction SilentlyContinue
        Write-Log "NORMALIZE $FolderName : hoisted $opt to mod root"
    }
    [void](Hoist-DataToModRoot $FolderPath $FolderName)
}

function Test-ValidModStructure([string]$FolderPath) {
    if (Test-Path -LiteralPath (Join-Path $FolderPath 'Data')) { return $false }
    $loose = @(Get-ChildItem -LiteralPath $FolderPath -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Extension -in '.esp', '.esm', '.esl', '.bsa' })
    if ($loose.Count -gt 0) { return $true }
    # FOMOD patch collections: ESPs in subfolders until task-0075 selection
    $nestedEsp = @(Get-ChildItem -LiteralPath $FolderPath -Recurse -Include *.esp, *.esm, *.esl -File -ErrorAction SilentlyContinue)
    return ($nestedEsp.Count -gt 0)
}

function Get-ModPlugins([string]$ModPath) {
    if (-not (Test-Path -LiteralPath $ModPath)) { return @() }
    Get-ChildItem -LiteralPath $ModPath -Recurse -Include *.esp, *.esm, *.esl -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Extension -ne '.mohidden' -and $_.Name -notmatch '\.mohidden$' } |
        Select-Object -ExpandProperty Name
}

function Reinstall-Mod([hashtable]$Entry) {
    $dst = Join-Path $SkyrimMods $Entry.Folder
    $archive = Find-Archive $Entry.Id $Entry.Prefer
    if (-not $archive) {
        Write-Log "MISSING archive Nexus $($Entry.Id) for $($Entry.Folder)"
        return @{ Status = 'missing'; Archive = $null }
    }

    Clear-ModFolder $dst
    $tmp = Join-Path $env:TEMP "ll-fix-0077-$($Entry.Id)"
    if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
    New-Item -ItemType Directory -Path $tmp -Force | Out-Null

    Write-Log "EXTRACT $($archive.Name) -> $($Entry.Folder)"
    & $SevenZip x $archive.FullName "-o$tmp" -y | Out-Null
    if ($LASTEXITCODE -gt 1) { throw "7z extract failed for $($archive.Name) exit $LASTEXITCODE" }

    New-Item -ItemType Directory -Path $dst -Force | Out-Null
    Move-ExtractedContent $tmp $dst
    Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue

    if ($Entry.Normalize) {
        Normalize-ModStructure $dst $Entry.Folder
    }
    else {
        [void](Hoist-DataToModRoot $dst $Entry.Folder)
    }

    if (-not (Test-ValidModStructure $dst)) {
        throw "Invalid mod structure after extract: $($Entry.Folder)"
    }

    return @{ Status = 'installed'; Archive = $archive.Name }
}

$Downloads   = 'E:\Modding\Skyrim Mods\Downloads'
$SkyrimMods  = 'D:\Skyrim\mods'
$Profile     = 'D:\Skyrim\profiles\Lost Legacy - Fork'
$PluginsPath = Join-Path $Profile 'plugins.txt'
$ModlistPath = Join-Path $Profile 'modlist.txt'
$LogPath     = 'D:\Skyrim AI Modlist\anvil-successor\modlist\exports\fix-ll-fork-settlement-extracts.log'
$SevenZip    = 'C:\Program Files\7-Zip\7z.exe'

$fixMods = @(
    @{ Folder = "The Great Town of Shor's Stone"; Id = 35977; Prefer = $null; Normalize = $false },
    @{ Folder = "RedBag's Rorikstead"; Id = 56114; Prefer = $null; Normalize = $true },
    @{ Folder = 'The Great Village of Old Hroldan'; Id = 33189; Prefer = $null; Normalize = $false },
    @{ Folder = "Thuldor's Ivarstead - Tweaks and Fixes"; Id = 113706; Prefer = '113706-1-02'; Normalize = $true }
)

$corePlugins = @(
    "The Great Town of Shor's Stone.esp",
    "RedBag's Rorikstead.esp",
    'The Great Village of Old Hroldan.esp',
    "Thuldor's Ivarstead - Tweaks and Fixes.esp"
)

$skipPlugins = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
@(
    "RedBag's Rorikstead - Brighter Interiors.esp",
    "RedBag's Rorikstead - Even Brighter Interiors.esp"
) | ForEach-Object { [void]$skipPlugins.Add($_) }

Assert-Mo2Closed
if (-not (Test-Path $SevenZip)) { throw "7-Zip not found at $SevenZip" }
if (Test-Path $LogPath) { Remove-Item $LogPath -Force }
Write-Log 'task-0077 fix settlement extracts starting'

$pluginsBefore = (Get-Content $PluginsPath | Where-Object { $_ -match '^\*' }).Count
Write-Log "plugins active before: $pluginsBefore"

$results = [System.Collections.Generic.List[string]]::new()
foreach ($entry in $fixMods) {
    $r = Reinstall-Mod $entry
    if ($r.Status -eq 'installed') {
        [void]$results.Add("$($entry.Folder) <= $($r.Archive)")
    }
    else {
        [void]$results.Add("MISSING $($entry.Folder) (Nexus $($entry.Id))")
    }
}

# --- Remove empty City Stack separator ---
$modlist = @(Get-Content $ModlistPath)
$newModlist = $modlist | Where-Object { $_ -notmatch '^-City Stack_separator\s*$' }
if ($newModlist.Count -ne $modlist.Count) {
    Set-Content -Path $ModlistPath -Value $newModlist -Encoding UTF8
    Write-Log 'modlist: removed -City Stack_separator'
}
$cityStackDir = Join-Path $SkyrimMods 'City Stack_separator'
if (Test-Path -LiteralPath $cityStackDir) {
    Remove-Item -LiteralPath $cityStackDir -Recurse -Force
    Write-Log 'deleted City Stack_separator folder'
}

# --- Enable core plugins for fixed mods ---
$enablePlugins = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
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
Set-Content -Path $PluginsPath -Value $out -Encoding UTF8
Write-Log "plugins enabled for core settlement mods: $($enablePlugins.Count)"

$pluginsAfter = ($out | Where-Object { $_ -match '^\*' }).Count
Write-Log "plugins active after: $pluginsAfter"
foreach ($r in $results) { Write-Log "  $r" }
Write-Log 'task-0077 extract fix complete — run verify-mast.ps1 next'
