# task-0070 post-layout: Ryn's separator + Spaghetti drop on Lost Legacy - Fork
#Requires -Version 5.1
$ErrorActionPreference = 'Stop'

function Assert-Mo2Closed {
    $procs = Get-Process -Name 'ModOrganizer', 'modorganizer' -ErrorAction SilentlyContinue
    if ($procs) { throw 'MO2 is running — close Mod Organizer before running this script.' }
}

Assert-Mo2Closed

$SkyrimMods = 'D:\Skyrim\mods'
$ModlistPath = 'D:\Skyrim\profiles\Lost Legacy - Fork\modlist.txt'
$PluginsPath = 'D:\Skyrim\profiles\Lost Legacy - Fork\plugins.txt'
$LogPath = 'D:\Skyrim AI Modlist\anvil-successor\modlist\exports\apply-ll-0070-layout-run.log'

function Write-Log($msg) {
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $msg"
    Add-Content -Path $LogPath -Value $line
    Write-Host $line
}

if (Test-Path $LogPath) { Remove-Item $LogPath -Force }
Write-Log 'apply-ll-fork-0070-layout starting'

# Separator folders
foreach ($sep in @('City Stack_separator', "Ryn's Mods_separator", 'JKs Skyrim_separator')) {
    $d = Join-Path $SkyrimMods $sep
    if (-not (Test-Path -LiteralPath $d)) {
        New-Item -ItemType Directory -Path $d -Force | Out-Null
        Write-Log "CREATE separator folder: $sep"
    }
}

$spaghettiDisable = @(
    "Spaghetti's Capital Windhelm Expansion",
    "Spaghetti's Cities - Whiterun",
    "Spaghetti's Cities - Windhelm",
    "Spaghetti's Cities - Markarth",
    "Spaghetti's Cities - Solitude",
    "Spaghetti's Cities - Riften",
    "Spaghetti's Towns - Riverwood",
    'CWE Spaghetti Patch',
    'Crossed Daggers - Spaghetti Patch'
)
$spaghettiSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($m in $spaghettiDisable) { [void]$spaghettiSet.Add($m) }

$rynMods = @("Ryn's Locations", "Ryn's Standing Stones Patch Collection")
$rynSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($m in $rynMods) { [void]$rynSet.Add($m) }

$lines = Get-Content -LiteralPath $ModlistPath
$out = New-Object System.Collections.Generic.List[string]
$rynBuf = New-Object System.Collections.Generic.List[string]
$insertedRyn = $false

foreach ($line in $lines) {
    if ($line -match '^[+-](.+)$') {
        $name = $Matches[1].Trim()
        if ($rynSet.Contains($name)) {
            if (-not $rynBuf.Contains($line)) { [void]$rynBuf.Add($line) }
            continue
        }
        if ($name -eq 'City Stack_separator') {
            if (-not $line.StartsWith('-')) { $line = '-City Stack_separator' }
            [void]$out.Add($line)
            if (-not $insertedRyn) {
                foreach ($r in $rynMods) {
                    $existing = $rynBuf | Where-Object { $_ -match [regex]::Escape($r) } | Select-Object -First 1
                    if ($existing) { [void]$out.Add($existing) }
                    else { [void]$out.Add("+$r"); Write-Log "WARN added missing Ryn entry: $r" }
                }
                [void]$out.Add("-Ryn's Mods_separator")
                $insertedRyn = $true
            }
            continue
        }
        if ($name -eq "Ryn's Mods_separator") { continue }
        if ($spaghettiSet.Contains($name)) {
            [void]$out.Add("-$name")
            continue
        }
    }
    [void]$out.Add($line)
}

if (-not $insertedRyn) {
    throw 'City Stack_separator not found in modlist — run install-ll-fork-city-stack.ps1 first'
}

Set-Content -LiteralPath $ModlistPath -Value $out -Encoding UTF8
Write-Log "modlist: Ryn section placed; Spaghetti disabled ($($spaghettiDisable.Count) mods); City Stack_separator prefix fixed"

# Unstar Spaghetti plugins; keep standalone city stack plugins
$spaghettiPlugins = @(
    "Spaghetti's Cities - Whiterun.esp",
    "Spaghetti's Cities - Windhelm.esp",
    "Spaghetti's Capital Windhelm Expansion - Individual.esp",
    "Spaghetti's Cities - Markarth.esp",
    "Spaghetti's Cities - Solitude.esp",
    "Spaghetti's Cities - Riften.esp",
    "Spaghetti's Towns - Riverwood.esp",
    'Captial Whiterun and Spaghetti AIO Patch.esp',
    'Riften Expansion - Spaghetti Cities Riften Patch.esp',
    "Riverwood Has Charm - Spaghetti's Riverwood Patch.esp"
)
$spPluginSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($p in $spaghettiPlugins) { [void]$spPluginSet.Add($p) }

$plugins = Get-Content -LiteralPath $PluginsPath
$plugOut = foreach ($line in $plugins) {
    if ($line -match '^\*(.+)$') {
        $bare = $Matches[1]
        if ($spPluginSet.Contains($bare)) { $bare } else { $line }
    }
    else { $line }
}
Set-Content -LiteralPath $PluginsPath -Value $plugOut -Encoding UTF8
$active = ($plugOut | Where-Object { $_ -match '^\*' }).Count
Write-Log "plugins active: $active (Spaghetti ESPs unstarred)"
Write-Log 'apply-ll-fork-0070-layout complete — reopen MO2 on Lost Legacy - Fork'
