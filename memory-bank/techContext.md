# Technical Context

## Technologies Used
- **Agent Harnesses:** Claude Code, Codex, Pi, `pi-signed`, Grok, Kimi, Cursor Agent CLI, Oh My Pi (`omp`), Gemini, Muse, Rovo, Antigravity (`agy`), Devin.
- **Shell & Tooling:** Bash (POSIX / Bash 4+ compatible scripts in `bin/`), Git (worktrees, branches, diffs), GitHub CLI (`gh`).
- **Terminal & Multiplexer Backends:** tmux (default), Herdr, Zellij, cmux, Orca.
- **Operating Environment:** Windows host running PowerShell 7 / Git Bash / WSL environment.
- **Configuration & Data Formats:** Markdown (`.md`), YAML (`.yaml`), TOML (`.toml`), Shell (`.sh`), JSON.

## Technical Constraints
- Scripts must remain ShellCheck-clean.
- Windows and cross-platform compatibility: Path handling, CRLF line endings on Windows vs LF in bash scripts.
- Memory Bank Integration: Self-contained markdown files in `memory-bank/`.
- Word budget on core supervisor contracts (`AGENTS.md` ~9,000 words limit).
