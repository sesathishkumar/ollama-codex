import json
from rich.console import Console
from rich.markdown import Markdown

from config import MAX_ITERATIONS
from ollama_client import chat
from tools import read_file, write_file, list_files, run_command

console = Console()

SYSTEM_PROMPT = """
You are a local coding agent inspired by Codex.

You can:
- inspect project files
- create and edit files
- run terminal commands
- read command output and errors
- iterate until the requested task is complete

Available tools:
read_file
write_file
list_files
run_command

When you need to use a tool, respond ONLY with one valid JSON object.

Examples:
{"tool":"read_file","path":"app.py"}
{"tool":"write_file","path":"app.py","content":"print('hello')"}
{"tool":"list_files","path":"."}
{"tool":"run_command","command":"python app.py","cwd":"."}

When finished, respond with:
DONE:
<short explanation>

Safety rules:
- Never delete files unless the user explicitly asks.
- Avoid destructive shell commands.
- Do not expose secrets or credentials.
- Prefer inspecting files before changing them.
- After changing code, run a relevant test or command when practical.
"""

def execute_tool(data):
    tool = data.get("tool")
    if tool == "read_file":
        return read_file(data["path"])
    if tool == "write_file":
        return write_file(data["path"], data["content"])
    if tool == "list_files":
        return list_files(data.get("path", "."))
    if tool == "run_command":
        return run_command(data["command"], data.get("cwd", "."))
    return f"Unknown tool: {tool}"

def run_agent(user_request):
    messages = [
        {"role": "system", "content": SYSTEM_PROMPT},
        {"role": "user", "content": user_request},
    ]

    for iteration in range(MAX_ITERATIONS):
        console.print(f"\n[bold]Agent iteration {iteration + 1}[/bold]")
        response = chat(messages)
        console.print(Markdown(response))

        if response.lstrip().startswith("DONE:"):
            return

        try:
            data = json.loads(response)
        except json.JSONDecodeError:
            messages.append({"role": "assistant", "content": response})
            messages.append({
                "role": "user",
                "content": "Your last response was not valid tool JSON and was not DONE. "
                           "Return exactly one valid tool JSON object, or DONE if finished."
            })
            continue

        result = execute_tool(data)
        console.print("\n[cyan]Tool result[/cyan]")
        console.print(result[:12000])

        messages.append({"role": "assistant", "content": response})
        messages.append({"role": "user", "content": "Tool result:\n" + result[:12000]})

    console.print("[yellow]Maximum agent iterations reached.[/yellow]")

def main():
    console.print("[bold green]Ollama Codex - Local Coding Agent[/bold green]")
    console.print("Type 'exit' to quit.\n")
    while True:
        request = console.input("[bold blue]> [/bold blue]").strip()
        if request.lower() in {"exit", "quit"}:
            break
        if request:
            run_agent(request)

if __name__ == "__main__":
    main()
