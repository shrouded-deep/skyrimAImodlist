# MAST scan v2: "present" = active plugins + game Data + ANY master-capable file in an ENABLED mod folder
$modsDir='E:\Skyrim\mods'
$profile='E:\Skyrim\profiles\Keizaal - Fork'
$plugins="$profile\plugins.txt"; $modlist="$profile\modlist.txt"

$active=Get-Content $plugins | Where-Object{$_ -match '^\*'} | ForEach-Object{$_ -replace '^\*',''}
$activeSet=@{}; $active|ForEach-Object{$activeSet[$_]=$true}
$enabledMods=Get-Content $modlist|Where-Object{$_ -match '^\+'}|ForEach-Object{$_ -replace '^\+',''}|Where-Object{$_ -notmatch '_separator$'}

# present = game Data + all esp/esm/esl in enabled mod folders (these are loadable masters)
$present=@{}
Get-ChildItem 'E:\Skyrim\root\Data' -File -EA SilentlyContinue | Where-Object{$_.Extension -in '.esm','.esl','.esp'} | ForEach-Object{$present[$_.Name]=$true}
$index=@{}  # active plugin file paths, for reading masters
foreach($mod in $enabledMods){ $d=Join-Path $modsDir $mod
  if(Test-Path -LiteralPath $d){ Get-ChildItem -LiteralPath $d -File -EA SilentlyContinue|Where-Object{$_.Extension -in '.esp','.esm','.esl'}|ForEach-Object{
      $present[$_.Name]=$true
      if($activeSet.ContainsKey($_.Name) -and -not $index.ContainsKey($_.Name)){$index[$_.Name]=$_.FullName} } } }

function Get-Masters { param($path)
    $b=[System.IO.File]::ReadAllBytes($path);$m=@();$i=24;$e=24+[BitConverter]::ToUInt32($b,4)
    while($i -lt $e-6){$t=[System.Text.Encoding]::ASCII.GetString($b[$i..($i+3)]);$s=[BitConverter]::ToUInt16($b,$i+4)
        if($t -eq 'MAST'){$m+=[System.Text.Encoding]::ASCII.GetString($b[($i+6)..($i+6+$s-2)])};$i+=6+$s};return $m }

$broken=@()
foreach($name in $active){ $p=$index[$name]; if(-not $p){continue}
    $missing=@(Get-Masters $p | Where-Object{ -not $present.ContainsKey($_) })
    if($missing.Count -gt 0){ $broken += [pscustomobject]@{ Plugin=$name; Missing=($missing -join ', ') } } }

Write-Host "=== ACTIVE plugins with MISSING MASTERS ($($broken.Count)) ==="
if($broken.Count -eq 0){ Write-Host "  NONE - load order clean" }
else { $broken | Sort-Object Plugin | ForEach-Object { Write-Host ("  {0,-45} -> {1}" -f $_.Plugin,$_.Missing) } }
Write-Host "`n=== Confirm the 3 restored CC ESLs are seen as present ==="
foreach($c in 'ccbgssse014-spellpack01.esl','cckrtsse001_altar.esl','ccvsvsse003-necroarts.esl'){
  Write-Host ("  {0}: {1}" -f $c, $(if($present.ContainsKey($c)){'PRESENT'}else{'MISSING'})) }