param(
    [string]$GitHubUser = "sesathishkumar",
    [string]$RepoName = "ollama-codex",
    [string]$Destination = "$HOME\ollama-codex"
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git is required. Install it first from https://git-scm.com/download/win."
    exit 1
}

if (Test-Path $Destination) {
    Write-Host "Destination already exists: $Destination"
    exit 1
}

$repoUrl = "https://github.com/$GitHubUser/$RepoName.git"
git clone $repoUrl $Destination
Set-Location $Destination

Write-Host "Project cloned to $Destination" -ForegroundColor Green
Write-Host "Next run:"
Write-Host "  Set-ExecutionPolicy -Scope Process Bypass"
Write-Host "  .\setup.ps1"
