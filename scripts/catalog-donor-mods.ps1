# Catalog donor MO2 mods; cross-ref Lost Legacy Fork. Prefixes kept on disk until import tasks rename.
# Report-only — does not copy or rename folders.
#Requires -Version 5.1
param(
    [string]$DonorMods = 'D:\Skyrim AE\mods',
    [string]$ExistingMods = 'D:\Skyrim\mods',
    [string]$OutHtml = 'D:\Skyrim AI Modlist\anvil-successor\modlist\exports\donor-ae-mod-catalog.html',
    [string]$OutPickerHtml = 'D:\Skyrim AI Modlist\anvil-successor\modlist\exports\donor-ae-mod-picker.html',
    [string]$OutCsv = 'D:\Skyrim AI Modlist\anvil-successor\modlist\exports\donor-ae-mod-catalog.csv'
)

$ErrorActionPreference = 'Stop'

function Get-ListTier([string]$RawName) {
    if ($RawName -match '^(\d+\.\d+)') { return $Matches[1] }
    return ''
}

function Escape-Js([string]$s) {
    if (-not $s) { return '' }
    return ($s -replace '\\', '\\\\' -replace "'", "\'" -replace "`r", '' -replace "`n", '\n')
}
function Get-CleanModName([string]$RawName) {
    $n = $RawName.Trim()
    # [NoDelete] / [nodelete] anywhere (MO2 sometimes embeds mid-name)
    $n = [regex]::Replace($n, '\[NoDelete\]\s*', '', 'IgnoreCase')
    # List tier prefix: 005.006 ◉ (U+25C9 FISHEYE)
    $n = [regex]::Replace($n, '^\d+\.\d+\s*\u25C9\s*', '')
    # Fallback if symbol mangled: digits.digits + whitespace
    $n = [regex]::Replace($n, '^\d+\.\d+\s+', '')
    return $n.Trim()
}

function Read-MetaIni([string]$ModPath) {
    $metaPath = Join-Path $ModPath 'meta.ini'
    if (-not (Test-Path -LiteralPath $metaPath)) { return $null }
    $result = @{
        ModId = $null
        Version = $null
        InstallationFile = $null
        Url = $null
        Repository = $null
        HasMeta = $true
    }
    foreach ($line in Get-Content -LiteralPath $metaPath -Encoding UTF8) {
        if ($line -match '^modid=(\d+)\s*$') { $result.ModId = [int]$Matches[1] }
        elseif ($line -match '^version=(.+)$') { $result.Version = $Matches[1].Trim() }
        elseif ($line -match '^installationFile=(.+)$') { $result.InstallationFile = $Matches[1].Trim() }
        elseif ($line -match '^url=(.+)$') { $result.Url = $Matches[1].Trim() }
        elseif ($line -match '^repository=(.+)$') { $result.Repository = $Matches[1].Trim() }
    }
    return $result
}

# Standard MO2/Nexus archive: ModName-{modid}-{ver}-{fileid}.7z
function Get-NexusIdFromInstallFile([string]$InstallationFile) {
    if (-not $InstallationFile) { return $null }
    $base = [System.IO.Path]::GetFileName($InstallationFile)
    if ($base -match '-(\d{2,6})-\d+[\d.]*-\d+\.(7z|zip|rar)$') {
        return [int]$Matches[1]
    }
    return $null
}

function Get-ResolutionStatus([bool]$IsSeparator, $Meta, [int]$EffectiveModId, [string]$CleanName) {
    if ($IsSeparator) { return 'separator' }
    if (-not $Meta) { return 'no_meta' }
    if ($EffectiveModId -gt 0) { return 'nexus' }
    $inst = $Meta.InstallationFile
    if ($inst -match '^[A-Za-z]:[/\\]') { return 'local_manual' }
    if ($CleanName -match 'Nolvus Settings|ModGroups|Output$|_separator') { return 'list_custom' }
    if (-not $inst) { return 'unresolved_meta' }
    return 'unresolved_other'
}

function Get-ExcludeReason([string]$Resolution, [string]$CleanName, [string]$RawName, $Meta) {
    if ($Resolution -eq 'separator') { return 'separator' }
    if ($Resolution -eq 'local_manual') { return 'loverslab_or_manual' }
    if ($Resolution -in @('no_meta','unresolved_meta','unresolved_other','list_custom')) { return $Resolution }
    $hay = @($CleanName, $RawName)
    if ($Meta) {
        $hay += $Meta.InstallationFile, $Meta.Url, $Meta.Repository
    }
    $blob = ($hay | Where-Object { $_ }) -join ' '
    if ($blob -match 'loverslab|LL/|SexLab|Schlong|OSLAL|Anub|FNIS.*SE') { return 'loverslab_or_manual' }
    if ($blob -match 'patreon\.com|Patreon') { return 'patreon' }
    return $null
}

function Get-NexusNameFromInstallFile([string]$InstallationFile, [int]$ModId) {
    if (-not $InstallationFile -or -not $ModId) { return $null }
    $pattern = [regex]::Escape("-$ModId-")
    $m = [regex]::Match($InstallationFile, "^(.+?)$pattern")
    if ($m.Success) { return $m.Groups[1].Value }
    return $null
}

function Get-NexusUrl([int]$ModId, [string]$MetaUrl) {
    if ($MetaUrl -and $MetaUrl -match 'nexusmods\.com/skyrimspecialedition/mods/(\d+)') {
        return "https://www.nexusmods.com/skyrimspecialedition/mods/$($Matches[1])"
    }
    if ($ModId) {
        return "https://www.nexusmods.com/skyrimspecialedition/mods/$ModId"
    }
    return $null
}

function Escape-Html([string]$s) {
    if (-not $s) { return '' }
    return [System.Net.WebUtility]::HtmlEncode($s)
}

Write-Host "Indexing existing mods: $ExistingMods"
$llByModId = @{}
$llByCleanName = @{}
Get-ChildItem -LiteralPath $ExistingMods -Directory -EA SilentlyContinue | ForEach-Object {
    $clean = Get-CleanModName $_.Name
    $meta = Read-MetaIni $_.FullName
    $entry = @{ Folder = $_.Name; Clean = $clean; ModId = $meta.ModId }
    if ($meta.ModId -and $meta.ModId -gt 0) {
        if (-not $llByModId.ContainsKey($meta.ModId)) { $llByModId[$meta.ModId] = @() }
        $llByModId[$meta.ModId] += $entry
    }
    $key = $clean.ToLowerInvariant()
    if (-not $llByCleanName.ContainsKey($key)) { $llByCleanName[$key] = @() }
    $llByCleanName[$key] += $entry
}

Write-Host "Scanning donor mods: $DonorMods"
$rows = [System.Collections.Generic.List[object]]::new()
$donorDirs = @(Get-ChildItem -LiteralPath $DonorMods -Directory -EA SilentlyContinue)
$i = 0
foreach ($dir in $donorDirs) {
    $i++
    if ($i % 500 -eq 0) { Write-Host "  $i / $($donorDirs.Count)" }
    $raw = $dir.Name
    $clean = Get-CleanModName $raw
    $isSeparator = $clean -match '_separator$' -or $raw -match '_separator$'
    $hasNoDelete = $raw -match '\[NoDelete\]' -or $raw -match '\[nodelete\]'
    $meta = Read-MetaIni $dir.FullName
    $metaModId = if ($meta -and $null -ne $meta.ModId) { $meta.ModId } else { 0 }
    $parsedModId = if ($meta) { Get-NexusIdFromInstallFile $meta.InstallationFile } else { $null }
    $modId = if ($metaModId -gt 0) { $metaModId } elseif ($parsedModId) { $parsedModId } else { 0 }
    $resolution = Get-ResolutionStatus $isSeparator $meta $modId $clean
    $nexusName = $null
    $identSource = 'folder_name'
    if ($meta) {
        if ($modId -gt 0) {
            $nexusName = Get-NexusNameFromInstallFile $meta.InstallationFile $modId
            if ($nexusName) {
                $identSource = if ($metaModId -gt 0) { 'meta.ini' } else { 'installationFile (parsed modid)' }
            }
            else { $identSource = 'meta.ini (modid only)' }
        }
        elseif ($resolution -eq 'local_manual') { $identSource = 'local install (modid=0)' }
        elseif ($resolution -eq 'no_meta') { $identSource = 'no meta.ini' }
        else { $identSource = 'unresolved (modid=0)' }
    }
    else { $identSource = 'no meta.ini' }
    if (-not $nexusName) { $nexusName = $clean }
    $nexusUrl = if ($modId -gt 0) { Get-NexusUrl $modId $meta.Url } else { $null }
    $dupModId = ($modId -gt 0) -and $llByModId.ContainsKey($modId)
    $dupName = $llByCleanName.ContainsKey($clean.ToLowerInvariant())
    $dupNote = @()
    if ($dupModId) {
        $matches = $llByModId[$modId] | ForEach-Object { $_.Folder }
        $dupNote += "modid $modId -> LL: $($matches -join '; ')"
    }
    if ($dupName) {
        $matches = $llByCleanName[$clean.ToLowerInvariant()] | ForEach-Object { $_.Folder }
        $llModIdFolders = if ($modId -gt 0 -and $llByModId.ContainsKey($modId)) {
            @($llByModId[$modId] | ForEach-Object { $_.Folder })
        } else { @() }
        $nameHits = @($matches | Where-Object { $_ -notin $llModIdFolders })
        if ($nameHits.Count -gt 0 -or -not $dupModId) {
            $dupNote += "name -> LL: $($matches -join '; ')"
        }
    }
    $excludeReason = Get-ExcludeReason $resolution $clean $raw $meta
    $excludeFromImport = [bool]$excludeReason
    $listTier = Get-ListTier $raw
    $rows.Add([pscustomobject]@{
        RawFolder          = $raw
        ListTier           = $listTier
        CleanName          = $clean
        IsSeparator        = $isSeparator
        HasNoDelete        = $hasNoDelete
        ModId              = if ($modId -gt 0) { $modId } else { $null }
        MetaModId          = if ($metaModId -gt 0) { $metaModId } else { $null }
        Resolution         = $resolution
        ExcludeFromImport  = $excludeFromImport
        ExcludeReason      = $excludeReason
        NexusName          = $nexusName
        NexusUrl           = $nexusUrl
        Version            = if ($meta) { $meta.Version } else { $null }
        Repository         = if ($meta) { $meta.Repository } else { $null }
        IdentSource        = $identSource
        DuplicateInLL      = ($dupModId -or $dupName)
        DuplicateDetail    = ($dupNote -join ' | ')
        InstallationFile   = if ($meta) { $meta.InstallationFile } else { $null }
    })
}

$stats = @{
    Total           = $rows.Count
    NexusResolved   = @($rows | Where-Object { $_.Resolution -eq 'nexus' }).Count
    LocalManual     = @($rows | Where-Object { $_.Resolution -eq 'local_manual' }).Count
    NoMeta          = @($rows | Where-Object { $_.Resolution -eq 'no_meta' }).Count
    UnresolvedMeta  = @($rows | Where-Object { $_.Resolution -in 'unresolved_meta','unresolved_other' }).Count
    ListCustom      = @($rows | Where-Object { $_.Resolution -eq 'list_custom' }).Count
    Separators      = @($rows | Where-Object { $_.Resolution -eq 'separator' }).Count
    NoDelete        = @($rows | Where-Object { $_.HasNoDelete }).Count
    DupAny          = @($rows | Where-Object { $_.DuplicateInLL -and $_.Resolution -ne 'separator' }).Count
    ImportCandidates = @($rows | Where-Object {
        $_.Resolution -eq 'nexus' -and -not $_.DuplicateInLL -and -not $_.ExcludeFromImport
    }).Count
    ExcludedNonNexus = @($rows | Where-Object { $_.ExcludeFromImport -and $_.Resolution -ne 'separator' }).Count
}

$unresolvedRows = @($rows | Where-Object {
    $_.Resolution -in @('no_meta','local_manual','unresolved_meta','unresolved_other') -and -not $_.IsSeparator
} | Sort-Object Resolution, CleanName)

Write-Host "Writing CSV: $OutCsv"
$rows | Sort-Object CleanName | Export-Csv -Path $OutCsv -NoTypeInformation -Encoding UTF8

$dupRows = @($rows | Where-Object { $_.DuplicateInLL -and -not $_.IsSeparator } | Sort-Object ModId, CleanName)
$noMetaRows = @($rows | Where-Object { $_.Resolution -eq 'no_meta' })
$excludedRows = @($rows | Where-Object { $_.ExcludeFromImport -and $_.Resolution -ne 'separator' } | Sort-Object ExcludeReason, CleanName)
$candidateRows = @($rows | Where-Object {
    $_.Resolution -eq 'nexus' -and -not $_.DuplicateInLL -and -not $_.ExcludeFromImport
} | Sort-Object CleanName)

$html = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8"/>
<title>Donor AE Mod Catalog vs Lost Legacy Fork</title>
<style>
body { font-family: system-ui, sans-serif; margin: 1.5rem; background: #1a1a1e; color: #e8e8ec; }
h1,h2 { color: #c9a227; }
.stats { display: flex; flex-wrap: wrap; gap: 1rem; margin: 1rem 0; }
.stat { background: #2a2a32; padding: 0.75rem 1rem; border-radius: 6px; }
table { border-collapse: collapse; width: 100%; margin: 1rem 0 2rem; font-size: 0.85rem; }
th, td { border: 1px solid #444; padding: 0.35rem 0.5rem; text-align: left; vertical-align: top; }
th { background: #333; position: sticky; top: 0; }
tr:nth-child(even) { background: #222228; }
tr.dup { background: #3a2820; }
tr.nometa { background: #28283a; }
tr.sep { color: #888; }
a { color: #6eb5ff; }
.raw { font-size: 0.75rem; color: #999; }
nav a { margin-right: 1rem; }
</style>
</head>
<body>
<h1>Donor AE Mod Catalog</h1>
<p>Source: <code>$(Escape-Html $DonorMods)</code> &mdash; cross-ref: <code>$(Escape-Html $ExistingMods)</code> (Lost Legacy Fork)</p>
<p>Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') &mdash; report only, no renames applied.</p>
<div class="stats">
<div class="stat"><strong>$($stats.Total)</strong> donor folders</div>
<div class="stat"><strong>$($stats.NexusResolved)</strong> Nexus resolved</div>
<div class="stat"><strong>$($stats.LocalManual)</strong> local / LoversLab (modid=0)</div>
<div class="stat"><strong>$($stats.NoMeta)</strong> no meta.ini</div>
<div class="stat"><strong>$($unresolvedRows.Count)</strong> unresolved (non-separator)</div>
<div class="stat"><strong>$($stats.ListCustom)</strong> list custom / tool</div>
<div class="stat"><strong>$($stats.Separators)</strong> separators</div>
<div class="stat"><strong>$($stats.NoDelete)</strong> [NoDelete] tagged</div>
<div class="stat"><strong>$($stats.DupAny)</strong> duplicates in LL</div>
<div class="stat"><strong>$($stats.ExcludedNonNexus)</strong> excluded (LL/Patreon/manual/etc.)</div>
<div class="stat"><strong>$($stats.ImportCandidates)</strong> Nexus import candidates</div>
</div>
<nav>
<a href="#excluded">Excluded</a>
<a href="#candidates">Nexus import candidates</a>
<a href="#duplicates">Duplicates</a>
<a href="#nometa">No meta.ini</a>
<a href="#all">All mods</a>
</nav>
"@

function Table-Rows($items, [string]$RowClass) {
    $sb = [System.Text.StringBuilder]::new()
    [void]$sb.AppendLine('<table><thead><tr>')
    foreach ($h in @('Clean name','Exclude','Resolution','Nexus ID','Nexus name','Link','ID source','Install file','LL duplicate','Raw folder')) {
        [void]$sb.AppendLine("<th>$h</th>")
    }
    [void]$sb.AppendLine('</tr></thead><tbody>')
    foreach ($r in $items) {
        $cls = $RowClass
        if ($r.IsSeparator) { $cls = 'sep' }
        elseif ($r.IdentSource -eq 'no meta.ini') { $cls = 'nometa' }
        elseif ($r.DuplicateInLL) { $cls = 'dup' }
        $link = if ($r.NexusUrl) { "<a href=`"$($r.NexusUrl)`" target=`"_blank`">$($r.NexusUrl)</a>" } else { '—' }
        $modId = if ($r.ModId) { $r.ModId } else { '—' }
        $excl = if ($r.ExcludeReason) { Escape-Html $r.ExcludeReason } else { '—' }
        [void]$sb.AppendLine("<tr class=`"$cls`"><td>$(Escape-Html $r.CleanName)</td><td>$excl</td><td>$(Escape-Html $r.Resolution)</td><td>$modId</td><td>$(Escape-Html $r.NexusName)</td><td>$link</td><td>$(Escape-Html $r.IdentSource)</td><td class=`"raw`">$(Escape-Html $r.InstallationFile)</td><td>$(Escape-Html $r.DuplicateDetail)</td><td class=`"raw`">$(Escape-Html $r.RawFolder)</td></tr>")
    }
    [void]$sb.AppendLine('</tbody></table>')
    return $sb.ToString()
}

$html += "<h2 id=`"excluded`">Excluded from import ($($excludedRows.Count))</h2>"
$html += '<p>LoversLab, Patreon, manual/local installs, tool outputs, list-only presets — not candidates for Lost Legacy Fork.</p>'
$html += (Table-Rows $excludedRows 'nometa')

$html += "<h2 id=`"candidates`">Nexus import candidates ($($candidateRows.Count))</h2>"
$html += '<p>Nexus modid resolved and not already in Lost Legacy Fork.</p>'
$html += (Table-Rows $candidateRows '')

$html += "<h2 id=`"duplicates`">Already in Lost Legacy Fork ($($dupRows.Count))</h2>"
$html += (Table-Rows $dupRows 'dup')

$html += "<h2 id=`"nometa`">No meta.ini ($($noMetaRows.Count))</h2>"
$html += (Table-Rows $noMetaRows 'nometa')

$html += "<h2 id=`"all`">All donor mods ($($stats.Total))</h2>"
$html += (Table-Rows ($rows | Sort-Object CleanName) '')

$html += '</body></html>'

$outDir = Split-Path $OutHtml -Parent
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir -Force | Out-Null }
[System.IO.File]::WriteAllText($OutHtml, $html, [System.Text.UTF8Encoding]::new($false))
Write-Host "Wrote HTML: $OutHtml"

# --- Interactive picker (raw names, checkboxes, export JSON for import script) ---
$pickerRows = $candidateRows | Sort-Object ListTier, RawFolder
$pickerBody = [System.Text.StringBuilder]::new()
foreach ($r in $pickerRows) {
    $fid = [System.Guid]::NewGuid().ToString('N')
    $link = if ($r.NexusUrl) { "<a href=`"$($r.NexusUrl)`" target=`"_blank`">$($r.ModId)</a>" } else { '—' }
    [void]$pickerBody.AppendLine(@"
<tr data-tier="$(Escape-Html $r.ListTier)">
  <td><input type="checkbox" class="pick" data-folder="$(Escape-Html $r.RawFolder)" id="pick-$fid"/></td>
  <td class="tier">$(Escape-Html $r.ListTier)</td>
  <td><label for="pick-$fid">$(Escape-Html $r.RawFolder)</label></td>
  <td>$link</td>
  <td>$(Escape-Html $r.NexusName)</td>
  <td class="raw">$(Escape-Html $r.CleanName)</td>
</tr>
"@)
}

$pickerHtml = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8"/>
<title>Donor AE — Import Picker</title>
<style>
body { font-family: system-ui, sans-serif; margin: 1.5rem; background: #1a1a1e; color: #e8e8ec; }
h1 { color: #c9a227; }
.toolbar { margin: 1rem 0; display: flex; flex-wrap: wrap; gap: 0.5rem; align-items: center; }
button { padding: 0.4rem 0.8rem; cursor: pointer; }
table { border-collapse: collapse; width: 100%; font-size: 0.85rem; }
th, td { border: 1px solid #444; padding: 0.35rem 0.5rem; text-align: left; vertical-align: top; }
th { background: #333; position: sticky; top: 0; }
tr:nth-child(even) { background: #222228; }
label { cursor: pointer; }
.tier { font-family: monospace; color: #c9a227; white-space: nowrap; }
.raw { color: #888; font-size: 0.8rem; }
a { color: #6eb5ff; }
#filter { padding: 0.35rem; min-width: 16rem; }
#count { margin-left: auto; color: #aaa; }
</style>
</head>
<body>
<h1>Donor AE Import Picker</h1>
<p>Nexus candidates only. <strong>Folder names are as-is</strong> (list tier prefix kept for category sorting).
Check mods to import, export JSON, save to <code>modlist/exports/donor-ae-import-selection.json</code>,
then run <code>scripts/import-selected-donor-mods.ps1</code>. Rename prefixes when installing by separator.</p>
<p>Source: <code>$(Escape-Html $DonorMods)</code> &mdash; $($pickerRows.Count) selectable rows</p>
<div class="toolbar">
  <button type="button" id="btnAll">Select all</button>
  <button type="button" id="btnNone">Clear all</button>
  <input type="text" id="filter" placeholder="Filter by name or tier…"/>
  <button type="button" id="btnExport">Export selection JSON</button>
  <span id="count"></span>
</div>
<table>
<thead><tr>
  <th></th><th>Tier</th><th>Donor folder (raw)</th><th>Nexus</th><th>Nexus name</th><th>Clean name (ref)</th>
</tr></thead>
<tbody>
$($pickerBody.ToString())
</tbody>
</table>
<script>
const DONOR = $(ConvertTo-Json -Compress $DonorMods);
const STORE_KEY = 'donor-ae-picker-selection-v1';
const boxes = () => [...document.querySelectorAll('input.pick')];
const visible = () => boxes().filter(b => b.closest('tr').style.display !== 'none');
function updateCount() {
  const sel = boxes().filter(b => b.checked).length;
  document.getElementById('count').textContent = sel + ' selected';
}
function saveLocal() {
  try {
    const folders = boxes().filter(b => b.checked).map(b => b.dataset.folder);
    localStorage.setItem(STORE_KEY, JSON.stringify(folders));
  } catch (e) {}
}
function restoreLocal() {
  try {
    const saved = JSON.parse(localStorage.getItem(STORE_KEY) || '[]');
    if (!Array.isArray(saved) || !saved.length) return;
    const set = new Set(saved);
    boxes().forEach(b => { if (set.has(b.dataset.folder)) b.checked = true; });
  } catch (e) {}
}
function exportSelection() {
  try {
    const folders = boxes().filter(b => b.checked).map(b => b.dataset.folder);
    if (!folders.length) {
      alert('No mods selected.');
      return;
    }
    const payload = { exported: new Date().toISOString(), donor: DONOR, folders: folders };
    const text = JSON.stringify(payload, null, 2);
    const blob = new Blob([text], { type: 'application/json' });
    const a = document.createElement('a');
    a.href = URL.createObjectURL(blob);
    a.download = 'donor-ae-import-selection.json';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(a.href);
    saveLocal();
    alert('Exported ' + folders.length + ' mods.');
  } catch (e) {
    alert('Export failed: ' + e.message);
  }
}
document.getElementById('btnAll').onclick = () => { visible().forEach(b => b.checked = true); updateCount(); saveLocal(); };
document.getElementById('btnNone').onclick = () => { boxes().forEach(b => b.checked = false); updateCount(); saveLocal(); };
document.getElementById('filter').oninput = (e) => {
  const q = e.target.value.toLowerCase();
  document.querySelectorAll('tbody tr').forEach(tr => {
    const text = tr.textContent.toLowerCase();
    tr.style.display = (!q || text.includes(q)) ? '' : 'none';
  });
};
boxes().forEach(b => b.addEventListener('change', () => { updateCount(); saveLocal(); }));
document.getElementById('btnExport').onclick = exportSelection;
restoreLocal();
updateCount();
</script>
</body>
</html>
"@

[System.IO.File]::WriteAllText($OutPickerHtml, $pickerHtml, [System.Text.UTF8Encoding]::new($false))
Write-Host "Wrote picker: $OutPickerHtml"
Write-Host "Done. Nexus resolved: $($stats.NexusResolved) | Excluded: $($stats.ExcludedNonNexus) | Candidates: $($stats.ImportCandidates)"
