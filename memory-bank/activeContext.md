# Active Context

## Current Work Focus
Implementing the Persona Engine to decouple ship-specific mechanics and enable extensible agent behaviors and personas:
- `nautical` (Classic default)
- `star-trek` (Starfleet: Captain & Number One - "Make it so")
- `matrix` (The One & Operator)
- `cyberpunk` (Fixer & Edgerunners/Solos)
- `ghost-in-the-shell` (Chief Aramaki & Section 9 / Major)
- `secret-agent` (Director & Field Operatives)
- `ninja` (Sensei & Shinobi)
- `samurai` (Daimyo & Bushi)
- `knight` (Sire & Knights Errant)
- `rastaman` (Bredren & Elder / Rootsman)
- `kitchen` (Chef & Sous Chef - "Yes, Chef!")
- `mob` (Don & Consigliere)
- `space-western` (Guildmaster & Gunslingers - "This is the way")
- `mad-scientist` (Mastermind & Igor)
- `noir` (Chief & Gumshoe)
- `apollo` (Flight & CAPCOM)
- `helldivers` (Super Earth: Commander & Democracy Officer - "Sweet Liberty!")
- `minimal` (Lead & Orchestrator)

## Key Objectives
1. Create `personas/` directory with complete persona definitions.
2. Implement `bin/fm-theme.sh` helper to query persona properties.
3. Update `bin/fm-dod-lib.sh` to inject dynamic worker identities in briefs.
4. Update `AGENTS.md` supervisor contract to support dynamic personas, address titles, and idle acknowledgments.
5. Update `bin/fm-session-start.sh` to display the active persona in the session start digest.
6. Verify implementation with tests and maintain 100% backward compatibility.

## Next Steps
- Analyze codebase to catalog all theme-coupled components.
- Present architectural options to the captain.
- Finalize implementation plan.
