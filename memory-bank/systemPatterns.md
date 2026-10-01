# System Patterns

## System Architecture
Nexus operates as an "Agent Distro" consisting of:
- **Contract & Supervisor Directives (`AGENTS.md`):** Instructions binding the primary supervisor agent.
- **Deterministic Scripts (`bin/`):** Shell scripts controlling session starts (`fm-session-start.sh`), task brief generation (`fm-brief.sh`), worker spawning (`fm-spawn.sh`), state reconciliation (`fm-crew-state.sh`), and teardown (`fm-teardown.sh`).
- **Skills (`.agents/skills/`, `skills/`):** Modular on-demand agent behaviors (e.g. `ship-landing`, `scout-completion`, `afk`, `bearings`, `bootstrap-diagnostics`).
- **Data & State Model (`data/`, `state/`, `config/`):**
  - `data/backlog.md`: Persistent task backlog.
  - `data/<task-id>/brief.md`: Written launch brief for subordinate workers.
  - `data/<task-id>/report.md`: Deliverable for scout/research tasks.
  - `state/<task-id>.status`: Event wakes / progress stamps.
  - `config/`: Instance-specific configuration and pins.

## Key Design Patterns & Principles
1. **Script Mechanics vs. Agent Judgment:** Deterministic operations (locking, git branch creation, file parsing, process management) are owned strictly by shell scripts. The agent exercises judgment, planning, and evaluation.
2. **Strict Project Isolation:** The supervisor reads projects but does not edit project worktrees directly (with explicit narrow exceptions). Sub-workers perform actual code edits in isolated worktrees.
3. **Flat Command Hierarchy:** Depth is strictly capped (Supervisor -> Worker, or Supervisor -> Secondmate -> Worker).
4. **House Persona / Metaphor Layer:** Currently, naval maritime metaphor ("captain", "Nexus", "crewmate", "ship", "scout", "ahoy", "shipshape") is hardcoded in `AGENTS.md`, brief templates in `bin/fm-brief.sh`, and status/log utilities. Abstracting this requires separating the functional orchestration layer from the behavioral/thematic presentation layer.
