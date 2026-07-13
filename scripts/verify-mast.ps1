#Requires -Version 5.1
param(
    [string]$Profile = 'D:\Skyrim\profiles\Lost Legacy - Fork',
    [string]$SkyrimMods = 'D:\Skyrim\mods'
)

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

$modlist = Get-Content (Join-Path $Profile 'modlist.txt')
$active = Get-Content (Join-Path $Profile 'plugins.txt') | Where-Object { $_ -match '^\*' } | ForEach-Object { $_ -replace '^\*', '' }
$enabledMods = $modlist | Where-Object { $_ -match '^\+' } | ForEach-Object { $_ -replace '^\+', '' } | Where-Object { $_ -notmatch '_separator$' }
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

$activeNorm = @{}
foreach ($a in $active) { $activeNorm[$a.ToLowerInvariant()] = $a }
$violations = [System.Collections.Generic.List[string]]::new()
foreach ($p in $active) {
    $path = $pluginIndex[$p]
    if (-not $path) {
        [void]$violations.Add("$p -> FILE NOT FOUND")
        continue
    }
    foreach ($m in (Get-PluginMasters $path)) {
        if (Test-VanillaMaster $m) { continue }
        if (-not $activeNorm.ContainsKey($m.ToLowerInvariant())) {
            [void]$violations.Add("$p -> $m")
        }
    }
}

Write-Host "Active plugins: $($active.Count)"
Write-Host "MAST violations: $($violations.Count)"
$violations | Select-Object -First 50
