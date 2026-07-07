# MLO2 migration — manual steps (post task-0021)

Lux suite disabled and CS Light reverted to vanilla JSON configs on **2026-07-07**.
**Lux Via re-enabled** (task-0023) for road/lantern content alongside MLO2 — Lux/Lux
Orbis core stay off. **Modern Lighting Overhaul 2 (Nexus 160748)** is installed (task-0022); **Window Shadows Ultimate**
stack pending Nexus download (task-0026) — install §0.5 before in-game spot tests.

Pre-migration profile snapshot:
`modlist/exports/mlo2-pre-migration-2026-07-07/`

---

## 0. Lux Via + MLO2 install status (task-0022)

Archives are in **`Anvil/Downloads/`** and extracted to **`mods/`** (2026-07-07):

| Mod | Archive | Install notes |
|---|---|---|
| Lux Via main | `Lux Via (main)-63588-2-2-1713094342.rar` | FOMOD choices from prior `meta.ini`: **Lux Resource Pack (ENB Light)**, **Blended Roads bridges**, **More Lantern Posts** |
| Lux Via patch hub | `Lux Via (patch hub)-116722-2-2-1713093664.rar` | **More Wooden Bridges** patch only |
| MLO2 | `Modern Lighting Overhaul 2 (MLO2)-160748-5-3-1774317366.zip` | `00 Main Module` → `mods/Modern Lighting Overhaul 2/`; enabled after **Base Object Swapper** in `modlist.txt` |

**Via plugins on disk:** `Lux - Resources.esp` (Via FOMOD resource pack — **not** Lux core),
`Lux Via.esp`, `Lux Via - plugin.esp`, Blended Roads bridge texture sets, More Lantern Posts,
More Wooden Bridges patch.
**Synthesis/xEdit patch:** `ANV_Lux Via - HPP Firewood Snow.esp` lives in
`mods/Anvil - xEdit Output/` (regenerate on next Synthesis pass if missing).

**MLO.ini:** Pre-seeded from FOMOD whitelist (Shadow Casters On) with
**`enableColorConsistency=false`** for NAT.CS. **`MLO.dll`** must exist under
`SKSE/Plugins/` — re-extract main-module zip if missing (task-0026).

**Missing masters (task-0023):** Via stack verified **0 unresolved** via MAST header parse + plugins.txt cross-check (2026-07-07); confirm in MO2 plugin pane before launch.

**Master check (task-0023):** core Via uses **`Lux Via.esp`** + **`Lux Via - plugin.esp`**
only — **not** `Lux.esp`, `Lux - Master plugin.esm`, or `Lux Orbis - Master plugin.esm`.
Lighting was co-designed with Orbis/Lux but Via runs without them; expect different
exterior lantern color/brightness vs full trilogy (MLO2 + Via + untested combo).

---

## 0.5 Window Shadows Ultimate stack (task-0026 — before spot tests)

Install **before** §3 interior checks so QA covers **MLO2 + WSU**, not MLO2 alone.

### Nexus downloads (MO2 → Anvil/Downloads)

| Nexus ID | Mod | Role |
|---|---|---|
| [150494](https://www.nexusmods.com/skyrimspecialedition/mods/150494) | Window Shadows Ultimate | Window shadow casting (CS + BOS) |
| [135488](https://www.nexusmods.com/skyrimspecialedition/mods/135488) | **True Light** (legacy name: Placed Light) | Light Placer JSON + ESPs — **not** `Placed Light*.esp`; needs **+Light Placer** |
| [133368](https://www.nexusmods.com/skyrimspecialedition/mods/133368) | Dust by FrankBlack (Dust not Clouds) | Mesh/texture replacer — **no ESP** to enable |
| [149920](https://www.nexusmods.com/skyrimspecialedition/mods/149920) | Dynamic Interior Ambient Lighting | FOMOD — enable **`DIAL.esp`** + **`DIAL_NAT.esp`** (Anvil weather) |
| [151548](https://www.nexusmods.com/skyrimspecialedition/mods/151548) | WSU Patch Hub | **Optional** — script flattens all `Patches/*` to mod root; enable only ESPs for interiors you use (Anvil/Spaghetti: often **none**; no Spaghetti-specific patches in hub) |

**Note:** Nexus **66665** is not WSU.

**Already on list:** CS, SSGI, Light Placer, BOS. Light Limit Fix disabled (CS 1.7 core merge).

### Install

After required archives are in `Anvil/Downloads/`:

1. **Close MO2 completely** (script aborts if ModOrganizer is running — avoids modlist clobber).
2. Run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/install-wsu-stack.ps1
```

Preflight-only (MLO2 + modlist, no WSU extract):

```powershell
powershell -ExecutionPolicy Bypass -File scripts/verify-mlo2.ps1
powershell -ExecutionPolicy Bypass -File scripts/verify-mlo2.ps1 -Repair   # restore MLO.dll from 160748 zip
```

The install script verifies/repairs **`MLO.dll`**, flattens FOMOD-style archives to MO2 layout, checks
marker ESPs on disk, updates `modlist.txt`, and writes a post-install snapshot under
`modlist/exports/wsu-stack-post-install-*`.

### MO2 priority (after `+Base Object Swapper`)

**Conflict priority only** — not the same as plugin load order below.

`MLO2` → **`True Light`** → `Dust not Clouds` → `DIAL` → `Window Shadows Ultimate` → Patch Hub (optional).

MLO2 before WSU in modlist matches MLO2 BOS/mesh conflict guidance (migration plan); MLO2 `MLO.ini` whitelists `Window Shadows Ultimate.esp` at runtime. True Light vs WSU mod-folder order is **project convention**, not stated on either Nexus page.

True Light installs to **`mods/True Light/`** (script applies WSU FOMOD defaults: main shadows ESP, WSU-variant `TL Bulbs ISL.esp`, interior window JSONs).

### Plugin load order (sourced)

**Author guidance:** [True Light (135488)](https://www.nexusmods.com/skyrimspecialedition/mods/135488) — *Load Order* + install steps.

| Relative position | Plugin |
|---|---|
| **Very early** | `True Light - Shadows and Ambient.esp` |
| **Late** | `Window Shadows Ultimate.esp` (+ supplement if enabled) |
| **Very late** (after WSU, before CS Light) | `TL Bulbs ISL.esp` |
| **After TL Bulbs** (if enabled) | `CS Light.esp` |
| **After WSU** | True Light **patch** ESPs (if any) |

**WSU (150494):** Patch Hub lists “**No load order requirements**” — no author rule beyond compatibility.

**MLO2:** No ESP — SKSE-only; not part of plugin ordering.

**Wrong (do not use):** older repo notes that put `TL Bulbs ISL.esp` before WSU or `Shadows and Ambient` after WSU — that inverted True Light’s rules.

---

## 1. MLO2 install (done — task-0022)

1. Open MO2 → **Anvil** instance → profile **Anvil - Main Profile**.
2. ~~Download MLO2~~ — **done** (archive in Downloads, extracted to `mods/Modern Lighting Overhaul 2/`).
3. ~~Install + enable~~ — **done** (`+Modern Lighting Overhaul 2` in `modlist.txt` after Base Object Swapper).
4. **Placement (conflict priority)** — already set; MLO2 loads **after** (be overridden by nothing except tool outputs):
   - Base Object Swapper
   - Embers XD stack
   - Static Mesh Improvement Mod (SMIM)
   - Swaps of Skyrim - Candles-Dwemer Lights-Lanterns  
   …and **above** generated outputs only:
   - Anvil - DynDOLOD Output
   - Anvil - ParallaxGen Output
   - Anvil - Synthesis Output  
   In `modlist.txt` terms: **`+Modern Lighting Overhaul 2`** is immediately **after** `+Base Object Swapper` (~line 997).
5. Launch once — `MLO.ini` is pre-seeded (see §0); launch may refresh it.

### MLO.ini tuning (NAT.CS path)

Path after install: `mods/Modern Lighting Overhaul 2/SKSE/Plugins/MLO.ini`

Community NAT+MLO2 guidance (see migration plan): **`enableColorConsistency=false`**
(pre-set in task-0022) if interiors read too flat or uniformly tinted. Adjust RGB /
flicker only after the spot-test pass below.

---

## 2. Launch sanity check

1. Launch Skyrim from MO2.
2. **Community Shaders → Feature Issues** tab: confirm no new errors (CS Light + MLO2 should both load).
3. **Missing masters:** Full profile scan (2026-07-07) finds **four disabled** plugins
   with unresolved Lux masters (OK to leave off):

   - `Actually Brighter Lux Templates.esp` → `Lux.esp`
   - `ANV_Lux Orbis - SB Windhelm Entrance.esp` → `Lux Orbis.esp`
   - `ANV_Lux - W4ENB - No Grass in Caves.esp` → `Lux.esp`
   - `ANV_Lux - Volkihar Soundscape Overhaul - W4ENB.esp` → `Lux.esp`

   **`DynDOLOD.esp`** and **`Occlusion.esp`** also had stale Lux masters — **disabled**
   in profile (2026-07-07). Regen deferred to **Tier 2** toolchain maintenance
   (task-0025). **`DynDOLOD.esm`** remains enabled (valid Via masters).

   Enabled stack should otherwise show **0 missing masters**.

---

## 3. In-game spot-test matrix (Phase 5)

Visit each location at **day and night** where practical. Note: interiors will be **darker / less cinematic** than Lux until you tune CS + MLO2.ini.

| Location | What to check |
|---|---|
| **Bannered Mare / any Whiterun inn** | **Daytime:** sharp window light shafts + shadow patterns on floor/walls (WSU). Candle/torch brightness (MLO2). No flat grey interiors. |
| **Dragonsreach / Jorrvaskr** | WSU changelog targets — verify window shadows; Palaces may need Patch Hub 151548 |
| **Riften** | Sconces, tavern lighting, canal exteriors (Lux Orbis grading gone) |
| **Whiterun / Riverwood forge** | Embers XD fires + MLO2 point sources; no double-stacked orange glow |
| **Meridia shrine** (Mandragora / pedestal) | Beacon mesh + shrine lighting without Lux Orbis patch |
| **Volkihar Castle** | Interior mood + audio (ANV Lux W4ENB patch removed) |
| **CC Fishing** spot | CC Fish area lighting (Lux patches dropped; MLO2 native CC support) |
| **Ivy Whiterun well** | Well lantern mesh without Orbis patch |
| **Main road (hold border)** | Lux Via lantern posts / bridge lighting at night (task-0023) |
| **Blended Roads bridge** | Via bridge texture set + lanterns; mesh swap `_SWAP.ini` on Nordic Stonewalls if present |
| **Northern Marsh bridge** | Via lanterns without Orbis patch — compare to pre-migration if needed |
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

- **Dark Crypts MLO2 addon** (145789) — philosophy choice for dungeon candles
- **MLO Patch Hub** (141249) — only if native detection misses JS Shrines / horn candles / Skeleton HD meshes

*(Window Shadows Ultimate moved to §0.5 — required before spot tests, task-0026.)*

---

## CS Light change log (task-0021)

- **Moved aside:** 6 files `Lux CS Light - *.json` →  
  `mods/CS Light/LightPlacer/CS Light/_disabled_lux_mlo2_migration/`
- **Restored from** `downloads/CS Light-138443-1-5-1-1743796775.zip`:  
  `CS Light - Candles.json`, `Chandeliers.json`, `Fires.json`, `Lanterns.json`, `Nordic Halls.json`, `Torches.json`
- **CS Light MO2 mod:** left **enabled** (not disabled)
