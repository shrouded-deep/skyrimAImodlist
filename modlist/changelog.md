# Changelog

Dated, terse entries. This is the "what changed" log; see decisions.md for
the "why."

---

### 2026-07-05

- Repo scaffold created (README, AGENTS.md, CLAUDE.md, task queue
  structure, decision log, changelog).
- Removed **MCM Recorder** (`McmRecorder.esp`) from the load order —
  disabled the mod in MO2 and removed its plugin from `plugins.txt`/
  `loadorder.txt` (task-0011). Superseded by a newer MCM-recording
  approach; confirmed no other plugin depended on it. Its one flagged
  conflict (task-0005, cell `WEMerchantChests`) is now resolved by
  `Update.esm` instead.
