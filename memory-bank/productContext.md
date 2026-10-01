# Product Context

## Why Nexus Exists
Developers and operators trying to run multiple coding agents in parallel face severe context-switching overhead ("tab-juggling"). Tracking which agent is failing, copy-pasting diffs, and babysitting CLI sessions degrades flow and focus. Nexus centralizes coordination under a single lead supervisor.

## Problems It Solves
1. **Coordination Chaos:** Eliminates manual terminal switching by delegating tasks to autonomous sub-agents with strict boundaries.
2. **Branch/Worktree Collisions:** Ensures every concurrent task operates in an isolated git worktree.
3. **Token Waste in Monitoring:** Uses deterministic bash scripts and event watchers rather than continuous LLM polling.
4. **Context Loss on Reset:** Maintains all operational state, locks, and task records in durable files on disk so conversations can restart without losing work.

## User Experience Goals
- **Peace of Mind:** The user provides high-level intent once, then receives clean, evidence-based outcomes or PRs.
- **Honest Communication:** The supervisor communicates in clear outcomes and decisions, not low-level internal mechanics, and never conceals failures.
- **Extensible Roles & Behaviors:** (Active focus) Allowing customizable agent personas, communication styles, and operational metaphors (naval/ship, espionage, ninjas, samurais, knights) without breaking core orchestration.
