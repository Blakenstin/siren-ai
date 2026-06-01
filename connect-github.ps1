# One-time: create GitHub repo, push, then open in Cursor
$ErrorActionPreference = "Stop"
$env:PATH = "C:\Program Files\Git\cmd;C:\Program Files\Git\bin;C:\Program Files\GitHub CLI;" + $env:PATH
Set-Location $PSScriptRoot

Write-Host "Checking GitHub login..." -ForegroundColor Cyan
gh auth status

Write-Host "`nCreating repo and pushing (skip if already exists)..." -ForegroundColor Cyan
$remote = git remote get-url origin 2>$null
if (-not $remote) {
  git remote add origin https://github.com/Blakenstin/siren-ai.git
}

gh repo view Blakenstin/siren-ai 2>$null
if ($LASTEXITCODE -ne 0) {
  gh repo create siren-ai --public --source=. --remote=origin --push
} else {
  git push -u origin main
}

Write-Host "`nRepo: https://github.com/Blakenstin/siren-ai" -ForegroundColor Green
Write-Host "Opening project in Cursor..." -ForegroundColor Cyan
$cursor = @(
  "$env:LOCALAPPDATA\Programs\cursor\Cursor.exe",
  "$env:LOCALAPPDATA\Programs\Cursor\cursor.exe",
  "cursor"
) | Where-Object { Test-Path $_ -or $_ -eq "cursor" } | Select-Object -First 1

if ($cursor -eq "cursor") {
  Start-Process cursor -ArgumentList "`"$PSScriptRoot\siren-ai.code-workspace`""
} elseif ($cursor) {
  Start-Process $cursor -ArgumentList "`"$PSScriptRoot\siren-ai.code-workspace`""
} else {
  Write-Host "Open manually: File -> Open Workspace from File -> siren-ai.code-workspace"
}
