# Claude Code Instructions

## Project

Nolvus Successor — personal Skyrim SE modlist curated top-down from
Nolvus Awakening V6. See `AGENTS.md` for shared agent instructions.

## MO2 instance

- **MO2 root:** `E:\Nolvus\Nolvus\`
- **Mods folder:** `E:\Nolvus\Nolvus\MODS\`
- **Profiles path:** `E:\Nolvus\Nolvus\MODS\profiles\`
- **Pristine reference profile:** `Nolvus Awakening` — never modify
- **Working profile:** `Successor` — copy of Nolvus Awakening; all changes go here

## Key paths

- **Project root:** `E:\Nolvus\nolvus-successor\`
- **Reference material:** `E:\Skyrim AI Modlist\anvil-successor\modlist\`
- **Lessons learned:** `E:\Skyrim AI Modlist\lessons-learned.md`
- **MO2ProfileGuardrails.ps1:** copy from `E:\Skyrim AI Modlist\anvil-successor\scripts\` when first needed

## houseCARL

houseCARL must be pointed at the Nolvus MO2 instance before any record
reads or writes. Verify with `housecarl_load_order_status` at the start
of any `requires_housecarl: true` task and confirm it reports the
Successor profile.
