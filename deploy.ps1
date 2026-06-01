$ErrorActionPreference = "Continue"
$env:PATH = "C:\Program Files\Git\cmd;C:\Program Files\Git\bin;C:\Program Files\GitHub CLI;" + $env:PATH
Set-Location $PSScriptRoot

Write-Host "`n=== AUTH STATUS ===" -ForegroundColor Cyan
gh auth status

if ((git branch --show-current) -eq "master") {
  git branch -M main
}

Write-Host "`n=== CREATE / PUSH ===" -ForegroundColor Cyan
$createOutput = gh repo create siren-ai --public --source=. --remote=origin --push 2>&1
Write-Host $createOutput
if ($LASTEXITCODE -ne 0) {
  $remote = git remote get-url origin 2>$null
  if (-not $remote) {
    git remote add origin https://github.com/Blakenstin/siren-ai.git
  }
  git push -u origin main 2>&1
}

Write-Host "`n=== GITHUB PAGES ===" -ForegroundColor Cyan
gh api repos/Blakenstin/siren-ai/pages -X POST -f "build_type=legacy" -f "source[branch]=main" -f "source[path]=/" 2>&1
$pages = gh api repos/Blakenstin/siren-ai/pages 2>&1
Write-Host $pages
Write-Host "`nLive URL: https://blakenstin.github.io/siren-ai/" -ForegroundColor Green
Write-Host "Custom domain: https://siren.ng (after DNS setup)" -ForegroundColor Green
