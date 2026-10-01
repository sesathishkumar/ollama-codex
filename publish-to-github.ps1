param(
    [string]$RepoName = "ollama-codex",
    [ValidateSet("private","public")]
    [string]$Visibility = "private"
)

$ErrorActionPreference = "Stop"

Write-Host "=== Publish Ollama Codex to GitHub ===" -ForegroundColor Cyan

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git is not installed. Install it from https://git-scm.com/download/win" -ForegroundColor Yellow
    exit 1
}

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "GitHub CLI is not installed." -ForegroundColor Yellow
    Write-Host "Install it with:"
    Write-Host "  winget install --id GitHub.cli" -ForegroundColor Cyan
    Write-Host "Then reopen PowerShell and run this script again."
    exit 1
}

Write-Host "Checking GitHub login..."
gh auth status *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Please sign in to GitHub first:" -ForegroundColor Yellow
    Write-Host "  gh auth login" -ForegroundColor Cyan
    exit 1
}

if (-not (Test-Path ".git")) {
    git init
    git branch -M main
}

git add .
$changes = git status --porcelain
if ($changes) {
    git commit -m "Initial Ollama Codex local coding agent"
}

$existing = gh repo view $RepoName 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "Repository '$RepoName' already exists." -ForegroundColor Yellow
    $login = gh api user --jq .login
    $remote = "https://github.com/$login/$RepoName.git"
    if (-not (git remote get-url origin 2>$null)) {
        git remote add origin $remote
    }
    git push -u origin main
}
else {
    Write-Host "Creating GitHub repository '$RepoName'..."
    if ($Visibility -eq "public") {
        gh repo create $RepoName --public --source . --remote origin --push `
            --description "Free local Codex-style coding agent powered by Ollama"
    }
    else {
        gh repo create $RepoName --private --source . --remote origin --push `
            --description "Free local Codex-style coding agent powered by Ollama"
    }
}

$login = gh api user --jq .login
Write-Host ""
Write-Host "Published successfully:" -ForegroundColor Green
Write-Host "https://github.com/$login/$RepoName" -ForegroundColor Cyan
