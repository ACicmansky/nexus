# Journal Entry: Systematic Deep Rebrand to Nexus

**Date:** 2026-10-02
**Context:** Comprehensive, systematic rebranding of over 4,100 mentions of Firstmate across all code, documentation, skills, tests, and harness extensions.

## Changes Implemented
1. **Skills & Mods Rebranding:**
   - Renamed skill folders: `firstmate-calm` -> `nexus-calm`, `firstmate-codexapp` -> `nexus-codexapp`, `firstmate-coding-guidelines` -> `nexus-coding-guidelines`, `firstmate-orca` -> `nexus-orca`, `updatefirstmate` -> `updatenexus`.
   - Updated git symlinks for `.agents/skills/nexus-calm`, `.claude/skills`, and `.pi/extensions/lib/` to point to `.claude/mods/nexus-calm`.
2. **Documentation & Architecture Specs:**
   - 100% of references in `docs/*.md`, `CONTRIBUTING.md`, `GROK_BOT.md`, `.greptile/rules.md` updated to Nexus.
3. **Core Scripts & Wire Protocols:**
   - `bin/` scripts, policies (`.mjs`), and backends systematically updated: `FIRSTMATE_OP` -> `NEXUS_OP`, `## Firstmate spec` -> `## Nexus spec`, `{FIRSTMATE_SPEC}` -> `{NEXUS_SPEC}`.
   - Herdr session labels (`nexus`), tmux session names, AFK daemon labels (`nexus-afk-daemon`).
4. **Test Suites & Fixtures:**
   - All 170+ test suites in `tests/` systematically updated to assert `nexus`, `Nexus`, `NEXUS_OP`, `## Nexus spec`, and `{NEXUS_SPEC}`.
   - Verified tests: `tests/fm-theme.test.sh` (100% pass) and `tests/fm-brief.test.sh` (34/34 assertions pass).
5. **Remaining References:**
   - 0 active code references remaining. Only historical mock test capture replays (`tests/captures/`) and the explicit `personas/nautical.md` definition retain historical references.
