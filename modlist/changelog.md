# Changelog

Dated, terse entries. This is the "what changed" log; see decisions.md for
the "why."

---

### 2026-07-06

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
