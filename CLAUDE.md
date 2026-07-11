# Claude Code Instructions

## Project

Keizaal foundation fork — personal Skyrim SE modlist built on Keizaal as the
middle-ground Wabbajack foundation. See `AGENTS.md` for shared agent instructions.

## MO2 instance

- **MO2 root:** `E:\Skyrim\`
- **MO2 executable:** `E:\Skyrim\ModOrganizer.exe` (verify path on first session)
- **Pristine reference profile:** `Keizaal` — never modify
- **Working profile:** `Keizaal - Fork` — all changes go here (create before first edit)

## Key paths

- **Project root:** `D:\Skyrim AI Modlist\anvil-successor\`
- **Lessons learned:** `E:\Skyrim AI Modlist\lessons-learned.md`
- **MO2ProfileGuardrails.ps1:** `scripts/Mo2ProfileGuardrails.ps1` (copy here when first needed)

## houseCARL

houseCARL must be pointed at the Keizaal MO2 instance before any record
reads or writes. Verify with `housecarl_load_order_status` at the start
of any `requires_housecarl: true` task and confirm it reports the
correct profile.
