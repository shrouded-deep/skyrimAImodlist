# MLO2 migration — manual steps (post task-0021)

Lux suite disabled and CS Light reverted to vanilla JSON configs on **2026-07-07**.
**Modern Lighting Overhaul 2 (Nexus 160748) was not present** in MO2 downloads or
mods — install it before first in-game launch.

Pre-migration profile snapshot:
`modlist/exports/mlo2-pre-migration-2026-07-07/`

---

## 1. Install MLO2 via MO2

1. Open MO2 → **Anvil** instance → profile **Anvil - Main Profile**.
2. Download [Modern Lighting Overhaul 2](https://www.nexusmods.com/skyrimspecialedition/mods/160748) (Mod ID **160748**).
3. Install from MO2 downloads pane (FOMOD: accept defaults unless you know you need an option).
4. **Enable** the mod in the left pane.
5. **Placement (conflict priority):** drag MLO2 **low** — it must load **after** (be overridden by nothing except tool outputs):
   - Base Object Swapper
   - Embers XD stack
   - Static Mesh Improvement Mod (SMIM)
   - Swaps of Skyrim - Candles-Dwemer Lights-Lanterns  
   …and **above** generated outputs only:
   - Anvil - DynDOLOD Output
   - Anvil - ParallaxGen Output
   - Anvil - Synthesis Output  
   In `modlist.txt` terms: place **`+Modern Lighting Overhaul 2`** immediately **after** `+Base Object Swapper` (near the Utilities section, ~line 996).
6. Launch once to generate `SKSE/Plugins/MLO.ini` if missing.

### MLO.ini tuning (NAT.CS path)

Path after install: `mods/Modern Lighting Overhaul 2/SKSE/Plugins/MLO.ini`

Community NAT+MLO2 guidance (see migration plan): start with **`colorConsistency=false`** if interiors read too flat or uniformly tinted. Adjust RGB / flicker only after the spot-test pass below.

---

## 2. Launch sanity check

1. Launch Skyrim from MO2.
2. **Community Shaders → Feature Issues** tab: confirm no new errors (CS Light + MLO2 should both load).
3. **Missing masters:** MO2 plugin pane should show **0 missing masters** (36 Lux plugins removed; CS Light mod stays enabled).

---

## 3. In-game spot-test matrix (Phase 5)

Visit each location at **day and night** where practical. Note: interiors will be **darker / less cinematic** than Lux until you tune CS + MLO2.ini.

| Location | What to check |
|---|---|
| **Bannered Mare / any Whiterun inn** | Interior ambient, candle/torch brightness, window spill (no WSU installed) |
| **Riften** | Sconces, tavern lighting, canal exteriors (Lux Orbis grading gone) |
| **Whiterun / Riverwood forge** | Embers XD fires + MLO2 point sources; no double-stacked orange glow |
| **Meridia shrine** (Mandragora / pedestal) | Beacon mesh + shrine lighting without Lux Orbis patch |
| **Volkihar Castle** | Interior mood + audio (ANV Lux W4ENB patch removed) |
| **CC Fishing** spot | CC Fish area lighting (Lux patches dropped; MLO2 native CC support) |
| **Ivy Whiterun well** | Well lantern mesh without Orbis patch |
| **Northern Marsh bridge** | Bridge lanterns (Via/Orbis alignment gone) |
| **Vanilla + modded dungeon** | e.g. Bleak Falls or a Praedy dungeon — dungeon darkness, extinguished fires |

Log obvious regressions as follow-up tasks (houseCARL only if a record fix is needed).

---

## 4. CS menu retune (post-Lux)

Lux no longer sets interior ambient baseline. Revisit after spot tests:

| CS feature | Action |
|---|---|
| **Wetness Effects** | Optional intensity pass — outdoor skin/armor wetness may read differently |
| **Skylighting / Cloud Shadows** | Optional — paired with NAT.CS; not Lux-dependent |
| **SSGI** | Watch interiors — bounce may expose darker vanilla cells |
| **Splashes of Storms** | Keep enabled; retune if outdoor rain feels busier without Orbis grading |
| **CS Light** | Confirmed on **vanilla** JSON set (Lux JSONs moved to `_disabled_lux_mlo2_migration/`) |

---

## 5. Optional (deferred)

- **Window Shadows Ultimate** (66665) — major window-light gap per migration plan
- **Dark Crypts MLO2 addon** (145789) — philosophy choice for dungeon candles
- **MLO Patch Hub** (141249) — only if native detection misses JS Shrines / horn candles / Skeleton HD meshes

---

## CS Light change log (task-0021)

- **Moved aside:** 6 files `Lux CS Light - *.json` →  
  `mods/CS Light/LightPlacer/CS Light/_disabled_lux_mlo2_migration/`
- **Restored from** `downloads/CS Light-138443-1-5-1-1743796775.zip`:  
  `CS Light - Candles.json`, `Chandeliers.json`, `Fires.json`, `Lanterns.json`, `Nordic Halls.json`, `Torches.json`
- **CS Light MO2 mod:** left **enabled** (not disabled)
