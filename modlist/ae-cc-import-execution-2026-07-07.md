# AE / CC import execution (2026-07-07)

**Task:** task-0035  
**Approved via:** Task-0027 approved for AE import execution  
**Profile:** `Anvil - Main Profile` on `D:\Skyrim AI Modlist\Anvil`  
**Source:** `D:\Steam\steamapps\common\Skyrim Special Edition\Data\`  
**Script:** `scripts/import-ae-cc.ps1`

---

## Summary

| Item | Result |
|---|---|
| New MO2 mods created | **68** |
| Baseline CC retained (not reinstalled) | **4** (Fishing, Survival Mode, Rare Curios, Saints & Seducers) |
| Total CC mods in instance | **72** |
| Skipped | Camping, CC Staves |
| CC plugins in load order | **72** |
| CC MAST check | **0 missing masters** |

---

## Retained baseline (confirmed, not touched)

| Mod | Plugin |
|---|---|
| Creation Club - Fishing | `ccbgssse001-fish.esm` |
| Creation Club - Survival Mode | `ccqdrsse001-survivalmode.esl` |
| Creation Club - Rare Curios | `ccbgssse037-curios.esl` |
| Creation Club - Saints & Seducers | `ccbgssse025-advdsgs.esm` |

CC Survival gameplay should remain **disabled in-game** (Settings → Gameplay → Survival Mode).

---

## Skipped (per task-0027 research)

| CC | Plugin | Reason |
|---|---|---|
| Camping | `ccqdrsse002-firewood.esl` | Survival friction — power-fantasy skip |
| Staves (Creation) | `ccbgssse066-staves.esl` | Praedy's Staves AIO redundancy |

---

## Profile changes

Updated via `import-ae-cc.ps1 -ProfileOnly` (after `-ModsOnly` folder copy):

- `modlist.txt` — 68 new `+Creation Club - …` entries above existing CC block
- `plugins.txt` — 68 new `*cc….esl/esm` entries
- `loadorder.txt` — CC plugins inserted after vanilla masters, before `_ResourcePack.esl`
- `archives.txt` — 68 new `cc….bsa` entries after existing CC BSAs

Import log JSON: `modlist/exports/ae-cc-import-log.json`

---

## Post-import human steps (not in task scope)

1. **Reopen MO2** to refresh profile state.
2. **Quick Auto Clean** CC plugins if desired (Anvil baseline note on existing CC mods).
3. **Re-run FOMODs:** Creation Club Asset Patch, Lux / Lux Orbis / Lux Via patch hubs for newly present CC.
4. **Tier 2 toolchain regen:** TexGen → DynDOLOD → Occlusion → Synthesis → ParallaxGen (`PG_1.esp` will stale further).
5. **Conflict re-audit** recommended per AGENTS.md (5+ mods added in one session).

---

## Methods

- Steam AE Data folder scan (74 CC plugins on disk)
- `scripts/import-ae-cc.ps1` with `Assert-Mo2Closed` on profile phase
- CC-only MAST scan: all 72 load-order CC plugins vs `loadorder.txt` master set
