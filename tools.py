from pathlib import Path
import subprocess
from config import COMMAND_TIMEOUT_SECONDS

def read_file(path):
    p = Path(path)
    if not p.exists():
        return f"File does not exist: {p}"
    if not p.is_file():
        return f"Not a file: {p}"
    return p.read_text(encoding="utf-8", errors="ignore")

def write_file(path, content):
    p = Path(path)
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(content, encoding="utf-8")
    return f"Saved {p}"

def list_files(path="."):
    base = Path(path)
    if not base.exists():
        return f"Path does not exist: {base}"
    files = []
    for item in base.rglob("*"):
        if item.is_file() and ".venv" not in item.parts and ".git" not in item.parts:
            files.append(str(item))
    return "\n".join(files[:1000])

def run_command(command, cwd="."):
    try:
        result = subprocess.run(
            command,
            cwd=cwd,
            shell=True,
            capture_output=True,
            text=True,
            timeout=COMMAND_TIMEOUT_SECONDS,
        )
        return (
            f"Exit code: {result.returncode}\n\n"
            f"STDOUT:\n{result.stdout}\n\n"
            f"STDERR:\n{result.stderr}"
        )
    except subprocess.TimeoutExpired:
        return f"Command timed out after {COMMAND_TIMEOUT_SECONDS} seconds."
    except Exception as exc:
        return f"Command error: {exc}"
