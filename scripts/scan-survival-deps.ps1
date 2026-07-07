$ErrorActionPreference = 'SilentlyContinue'
$modsDir = 'D:\Skyrim AI Modlist\Anvil\mods'
$profilePlugins = @(Get-Content 'D:\Skyrim AI Modlist\Anvil\profiles\Anvil - Main Profile\plugins.txt' |
    Where-Object { $_ -match '^\*' } | ForEach-Object { $_.TrimStart('*').ToLower() })

Write-Output '=== SurvivalModeImproved.esp locations ==='
Get-ChildItem -Path $modsDir -Recurse -Filter 'SurvivalModeImproved.esp' | ForEach-Object { $_.FullName }

Write-Output ''
Write-Output '=== Plugins referencing Survival masters (ASCII scan) ==='
Get-ChildItem -Path $modsDir -Recurse -Include *.esp,*.esm,*.esl | ForEach-Object {
    $bytes = [System.IO.File]::ReadAllBytes($_.FullName)
    $text = [System.Text.Encoding]::ASCII.GetString($bytes)
    if ($text -match 'SurvivalModeImproved\.esp' -or $text -match 'ccqdrsse001-survivalmode\.esl') {
        $active = if ($profilePlugins -contains $_.Name.ToLower()) { 'ACTIVE' } else { 'inactive' }
        $folder = ($_.FullName.Substring($modsDir.Length).TrimStart('\') -split '\\')[0]
        Write-Output "$active`t$($_.Name)`t$folder"
    }
}
