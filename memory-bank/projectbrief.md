# Project Brief: Nexus

## Overview
`nexus` is an agent distro for running a fleet/crew of coding agents. It provides a supervisory layer between an individual human operator ("captain") and multiple parallel coding agents ("crewmates", "secondmates", "scouts"). It turns high-level intent into delegated, supervised, evidence-backed software changes across multiple projects.

## Core Requirements & Scope
- **Single Point of Contact:** The user interacts exclusively with the supervisor agent. Subordinate workers never communicate directly with the user.
- **Supervisor Role:** The supervisor plans, dispatches, monitors, guides, and reports outcomes. It does not do project-level implementation directly (preserving bandwidth and attention).
- **Subordinate Workers:** Dispatched into isolated Git worktrees (via treehouse/git worktree or backend worktrees) so parallel work never collides.
- **Task Shapes:**
  - *Ship Tasks:* Deliver code changes via configured pipelines (`no-mistakes`, `direct-PR`, `local-only`).
  - *Scout Tasks:* Perform research, audits, planning, or reproductions, outputting standalone markdown reports.
- **Event-Driven Supervision:** Token-efficient background monitoring wakes the supervisor only when action or human decision is needed.
- **Restart-Proof Durability:** State, backlogs, locks, and task metadata reside deterministically on disk (`data/`, `state/`, `config/`), ensuring recovery across session crashes.
