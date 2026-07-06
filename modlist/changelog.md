# Changelog

Dated, terse entries. This is the "what changed" log; see decisions.md for
the "why."

---

### 2026-07-07

- **Lux → MLO2 MO2 prep** (task-0021): disabled Lux trilogy + patch hubs +
  Meridia's Luxon Beacon Replacer (7 MO2 mods); removed **36** Lux-named
  plugins from profile (0 active Lux masters/patches). CS Light: moved 6
  `Lux CS Light - *.json` aside; restored 6 vanilla `CS Light - *.json` from
  CS Light 1.5.1 archive. Pre-migration snapshot:
  `modlist/exports/mlo2-pre-migration-2026-07-07/`. **MLO2 (160748) not in
  downloads** — user must install via MO2; steps: `modlist/mlo2-manual-run.md`.
  In-game QA + CS Wetness/Skylighting/SSGI retune pending.
- **Pandora behavior regen** (task-0018): first successful MO2 Launch; engine at
  `tools/Pandora/` (MO2 #385 fix). Output in `Pandora Output`; FNIS Serana hood
  logged separately from Patcher rows. Smoke test pending.
- **`pandora-manual-run.md`:** added **Gotchas** section (symptom → cause → fix);
  28 vs 15 patch count; FNIS vs Patcher; `tdmv`=Headtracking; batch launcher obsolete.

### 2026-07-06

- **Pandora Output mod:** created empty MO2 mod `Pandora Output`; MO2 tool #6 `-o`
  path and modlist updated (replaces `Anvil - Pandora Output` placeholder).
- **Nemesis → Pandora MO2 prep** (task-0018): installed Pandora 4.3.1-beta + UBR
  skeleton patch; disabled Nemesis; cleared/renamed output mod; bundled legacy
  patches. Behavior regen **not run** — user launches Pandora from MO2 manually.
  Steps: `modlist/pandora-manual-run.md`.
- **Nemesis → Pandora research** (task-0016): full compatibility audit of 15
  Nemesis patch inputs; migration plan at `modlist/pandora-migration-plan.md`.
  Execution deferred pending sign-off (task-0018).
- **SPID + OAR** (task-0015): SPID **7.2.0 RC11 → 7.3.1** (AE DLL); OAR
  **2.3.6 → 3.1.6** after full OAR/DAR audit (6 replacer mods, all compatible).
  Audit report: `modlist/oar-audit-2026-07-06.md`. No plugin/load-order changes.
- **CS 1.7.3 ecosystem audit** (task-0017): disabled 9 core-merged / incompatible
  CS-adjacent mods; updated Wetness Effects, Cloud Shadows, Skylighting; confirmed
  Sky Sync enabled via core + Anvil settings. Full table:
  `modlist/community-shaders-audit-2026-07-05.md`.
- Updated **SkyUI** 5.2 SE → **6.11** in MO2; disabled seven redundant
  satellite mods integrated into SkyUI 6 (task-0014). 0 missing masters.
  MCM/favourites may reset on first launch.
- Disabled **EVLaS** — incompatible with Community Shaders 1.7.3; install
  Sky Sync CS plugin as replacement (see decisions.md).
- Repo scaffold created (README, AGENTS.md, CLAUDE.md, task queue
  structure, decision log, changelog).
- Removed **MCM Recorder** (`McmRecorder.esp`) from the load order —
  disabled the mod in MO2 and removed its plugin from `plugins.txt`/
  `loadorder.txt` (task-0011). Superseded by a newer MCM-recording
  approach; confirmed no other plugin depended on it. Its one flagged
  conflict (task-0005, cell `WEMerchantChests`) is now resolved by
  `Update.esm` instead.
