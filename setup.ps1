$ErrorActionPreference = "Stop"

Write-Host "=== Ollama Codex Setup ===" -ForegroundColor Cyan

function Require-Command($Name, $InstallHint) {
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        Write-Host "$Name is not installed." -ForegroundColor Yellow
        Write-Host $InstallHint -ForegroundColor Yellow
        exit 1
    }
}

Require-Command "python" "Install Python 3.11+ from https://www.python.org/downloads/ and enable 'Add Python to PATH'."
Require-Command "ollama" "Install Ollama from https://ollama.com/download/windows."
Require-Command "git" "Install Git from https://git-scm.com/download/win."

Write-Host "Creating Python virtual environment..."
python -m venv .venv

Write-Host "Activating virtual environment..."
& ".\.venv\Scripts\Activate.ps1"

Write-Host "Upgrading pip..."
python -m pip install --upgrade pip

Write-Host "Installing Python dependencies..."
pip install -r requirements.txt

Write-Host "Checking Ollama service..."
try {
    Invoke-RestMethod -Uri "http://localhost:11434/api/tags" -Method Get | Out-Null
}
catch {
    Write-Host "Ollama does not appear to be running." -ForegroundColor Yellow
    Write-Host "Open Ollama, or run 'ollama serve' in another PowerShell window, then rerun this script."
    exit 1
}

Write-Host "Pulling qwen2.5-coder:7b (this may take a while on first setup)..."
ollama pull qwen2.5-coder:7b

Write-Host ""
Write-Host "Setup complete." -ForegroundColor Green
Write-Host "Run the coding agent with:"
Write-Host "  .\run.ps1" -ForegroundColor Cyan
