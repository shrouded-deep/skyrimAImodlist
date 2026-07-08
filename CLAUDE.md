# Claude Code Instructions

## Project

Nolvus Successor — personal Skyrim SE modlist curated top-down from
Nolvus Awakening V6. See `AGENTS.md` for shared agent instructions.

## MO2 instance

- **Instance path:** (update when Nolvus install is complete)
- **Working profile:** Successor
- **Pristine reference profile:** Nolvus (never modify)

## Key paths

- **Project root:** `E:\Skyrim AI Modlist\nolvus-successor\`
- **Reference material:** `E:\Skyrim AI Modlist\anvil-successor\modlist\`
- **Lessons learned:** `E:\Skyrim AI Modlist\lessons-learned.md`
- **MO2ProfileGuardrails.ps1:** copy from anvil-successor when first needed

## houseCARL

houseCARL must be pointed at the Nolvus MO2 instance before any record
reads or writes. Verify with `housecarl_load_order_status` at the start
of any `requires_housecarl: true` task and confirm it reports the
Successor profile.
