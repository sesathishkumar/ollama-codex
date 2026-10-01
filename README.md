# Ollama Codex

A free, local Codex-style coding assistant for Windows using Ollama and Python.

## What it can do

- Read project files
- Create and edit files
- List project files
- Run terminal commands
- Inspect command output and errors
- Iterate on coding tasks

## Requirements

- Windows 10/11
- Python 3.11+
- Git
- Ollama
- Recommended: 16 GB RAM or more for the 7B model

## One-time setup

Open PowerShell in this folder:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\setup.ps1
```

The script creates a Python virtual environment, installs dependencies, verifies Ollama, and downloads:

```text
qwen2.5-coder:7b
```

If the 7B model is too slow for your laptop, edit `config.py` and change:

```python
MODEL = "qwen2.5-coder:7b"
```

to a smaller model that you have installed, such as `qwen2.5-coder:3b`.

## Run

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\run.ps1
```

Example:

```text
Create a Python file hello.py that prints Hello Sathish and run it.
```

Other examples:

```text
Analyze this project and explain the structure.
```

```text
Find the cause of this Python error and fix it.
```

```text
Create a FastAPI CRUD API in a new folder named customer-api and test that it imports successfully.
```

## Important safety note

This agent can execute terminal commands on your machine. Review important changes and use Git for projects you care about. The prompt blocks deletion unless explicitly requested, but a local LLM can still make mistakes.

## Files

- `agent.py` - agent loop and tool orchestration
- `ollama_client.py` - Ollama API client
- `tools.py` - local file and shell tools
- `config.py` - model and runtime settings
- `setup.ps1` - Windows setup
- `run.ps1` - launcher
- `install-from-github.ps1` - helper for deployment from the GitHub repository


## Publish to your own GitHub repository

Install GitHub CLI if needed:

```powershell
winget install --id GitHub.cli
```

Sign in:

```powershell
gh auth login
```

Then, from this project folder:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\publish-to-github.ps1
```

By default this creates a private repository named `ollama-codex`. To create a public repository:

```powershell
.\publish-to-github.ps1 -Visibility public
```
