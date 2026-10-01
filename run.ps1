$ErrorActionPreference = "Stop"

if (-not (Test-Path ".\.venv\Scripts\python.exe")) {
    Write-Host "Virtual environment not found. Run .\setup.ps1 first." -ForegroundColor Yellow
    exit 1
}

try {
    Invoke-RestMethod -Uri "http://localhost:11434/api/tags" -Method Get | Out-Null
}
catch {
    Write-Host "Ollama is not running." -ForegroundColor Yellow
    Write-Host "Start Ollama or run 'ollama serve' in another PowerShell window."
    exit 1
}

& ".\.venv\Scripts\python.exe" ".\agent.py"
