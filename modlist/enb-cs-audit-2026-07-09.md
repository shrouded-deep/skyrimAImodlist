# ENB vs Community Shaders — Nolvus Awakening V6 Feasibility Audit

**Date:** 2026-07-09  
**Task:** task-0001 (research only — no MO2/profile changes)  
**Method:** On-disk scan of live MO2 instance (not web/training-data inference)

---

## Methodology (disk evidence)

| Source | Path |
|---|---|
| Donor profile modlist | `E:\Nolvus\Nolvus\MODS\profiles\Nolvus Awakening\modlist.txt` |
| Donor profile plugins | `E:\Nolvus\Nolvus\MODS\profiles\Nolvus Awakening\plugins.txt` |
| Working profile (same state) | `E:\Nolvus\Nolvus\MODS\profiles\Successor\` |
| Stock-game ENB/ReShade | `E:\Nolvus\Nolvus\STOCK GAME\enbseries.ini`, `ReShade.ini`, `Nolvus Reshade.ini` |
| MO2 mod folders | `E:\Nolvus\Nolvus\MODS\mods\` |
| CS hard-block reference | `E:\Skyrim AI Modlist\lessons-learned.md`, [modding.wiki CS FAQ](https://modding.wiki/en/skyrim/developers/community-shaders/faq) |

**Profile stats (2026-07-09 scan):**

| Metric | Value |
|---|---|
| Enabled mod folders (`+` lines in modlist) | **3,808** |
| Active plugin entries in `plugins.txt` | **3,823** (3,753 ESP/ESM + 70 ESL) |
| ENB-tagged enabled mod folders (see export) | **63** |
| `Community Shaders` mod folder | **Not present** |
| `Skyrim Upscaler` mod folder | **Not present** |
| Standalone CS-merged mods (LLF, Terrain Shadows, etc.) | **Not present** |

Export of ENB-tagged modlist lines: [`modlist/exports/task-0001-enb-mod-scan.txt`](exports/task-0001-enb-mod-scan.txt)

> **Note on plugin budget:** `modlist/decisions.md` records **228 / 254** as baseline headroom. The on-disk `plugins.txt` lists **3,823** active entries — consistent with **SSE Engine Fixes** raising the plugin cap. Treat 228/254 as the human/MO2 UI budget target if applicable; the physical profile is much larger.

---

## Executive summary

| Verdict | **Major** |
|---|---|
| One-line | This install is built around **Amon ENB + Nolvus ReShade + NAT-ENB weather + Lux (100+ patches) + 63 ENB-linked mod folders**; CS migration is a full visual-stack rebuild, not a binary swap. |

---

## 1. ENB preset identity

### Installed on this machine (disk)

| Item | Evidence |
|---|---|
| **Active ENB preset** | **Amon ENB for NAT III** — `STOCK GAME\Nolvus Reshade.ini` header: `NOLVUS RESHADE 2026 For AMON ENB - NAT III` |
| **ENB config** | `STOCK GAME\enbseries.ini` + `enblocal.ini`; `enbseries\` contains Reforged shader tree |
| **ReShade** | `ReShade.ini` → `PresetPath=.\Nolvus Reshade.ini` (paired post stack) |
| **MO2 ENB support** | `Amon ENB - NAT III Esp Fix`, `Subtle eye cubemap`, `ENB - ShaderCache`, `ENB Dynamic Cubemaps`, `ENB Anti-Aliasing`, `ENB Helper`, `ENB Input Disabler` (all enabled in modlist) |
| **Active weather ESPs** | `NAT-ENB.esp`, `Amon NAT III Esp Fix.esp`, `Seasonal Weathers Framework - NAT-ENB III.esp`, `Lux - NAT ENB.esp` (all active in plugins.txt) |

### Installer options (not necessarily this install)

Nolvus Awakening V6 Wabbajack also offers Cabbage, Cabbaval, Kauz, Pi-Cho, Rudy, Bjorn ENB ([installer docs](https://www.nolvus.net/appendix/installer/install)). **This disk scan confirms Amon ENB**, not Cabbage/Kauz.

### CS equivalents

No Nolvus CS preset. Documented community path: **Community Shaders 1.7.x** + **NAT.CS III** (139567) + optional INI tuning. No Amon→CS port; full re-tune required.

---

## 2. Weather and lighting stack

### Weather (exterior) — from modlist + plugins

| Mod (enabled) | Role |
|---|---|
| **Natural Atmospheric Tamriel III** | Core weather framework |
| **NAT III - Seasonal Weathers** | NAT-ENB-branded seasonal plugin |
| **Nolvus Awakening Weather Patch** | Nolvus integration layer |
| **Seasons of Nolvus / Seasons of Skyrim / Seasonal Weathers Framework** | Season system |
| **Supreme Blizzards**, **Morning Fogs**, **Storm Lightning**, **R.A.S.S.**, **Splashes of Storms** (+ **ENB Fix**) | Weather FX stack |
| **Enhanced Volumetric Lighting and Shadows** | EVLaS config present (`MODS\mods\Enhanced Volumetric Lighting and Shadows\SKSE\Plugins\EVLaS.cfg`); **EVLaS.dll not found** under MO2 mods tree on this scan |
| **Water for ENB [4K]**, **Water Effects Brightness and Reflection Fix**, **SR Exterior Cities - Water For ENB Patch** | Water tuned for ENB |

**ENB-tuned?** Yes — NAT-ENB ESP chain, Lux-NAT bridge plugin, Splashes ENB Fix, Water for ENB patches, Amon ENB ESP fix, and paired Nolvus ReShade.

### Interiors / exteriors — Lux ecosystem (disk)

Enabled mod folders include **Lux**, **Lux Via** (+ updates/hubs), **Lux Orbis** (+ SREX patch hub), **Lux Variants**, **Lux Interiora Distincta**, **Embers XD**, **Nolvus Awakening Lighting Patch** (+ SREX patch).

**Active Lux-related plugins:** 200+ lines in `plugins.txt` (Lux master ESMs, Lux.esp, Lux Via plugin, Lux Orbis, and extensive patch ESPs including JK's, Ryn's, SREX, LOTD, CC, etc.).

Lux is authored for ENB Light / particle lights. CS path per [ENB Migration Guide](https://modding.wiki/en/skyrim/developers/community-shaders/ENB-Migration-Guide): **Lux CS** (153919) + reinstall Lux FOMOD without ENB-optimized mesh options.

### CS-compatible weather/lighting (not installed)

| Add | Notes |
|---|---|
| **Community Shaders 1.7.x** | Core — not on disk |
| **NAT.CS III** | Keep NAT-ENB ESP; replaces weather tuning for CS |
| **Skylighting + Cloud Shadows + Wetness Effects** | Required by NAT.CS III |
| **Lux CS + CS Light** | Replace ENB particle-light mesh strategy |

---

## 3. ENB light mesh exposure

**63 enabled mod folders** tagged ENB-related (full list in export file). Highlights from `modlist.txt`:

### Section 5.17 — core particle / ENB Light mods (all enabled)

- **ENB Particle Lights** (19 mods): Dwemer Lanterns, Bugs in a Jar, Undead Creatures, Staff Enchanter, Nordic Ruins Candles, Effect Shaders, Dragon Fly, Light Orbs, Wisps, Lava, Moon Crests, Dwarven Spiders, Falmer Drips, Fire Traps, Spectral Warhound Eyes, Riekling Outposts, Ayleid Ruins, Gemstones, Alchemy/Enchanting Tables, Rudy Candle patch
- **ENB Light** + variants (Apocrypha, Elytra, Misc Effects, Dark Elf Lantern, Awesome Potions)
- **Rudy HQ - More Lights for ENB** (Deathbells, Mushrooms, Moths, Decal Fix, Daedric weapons)
- **Particle Patch for ENB**
- **Embers XD** (+ SREX patch)
- **Hot Lava - Heat Distortion - ENB Light**

### Scattered ENB-light clutter (enabled)

| Mod | CS replacer notes |
|---|---|
| Particle Lights for ENB - Falmer Things | CS Light partial |
| Dwemer Fairies - ENB Particles | CS Light partial |
| Sprites or Specters - ENB Light | CS Light partial |
| Stalhrim Source - ENB Light Patch | Manual / CS Light |
| Dwemer Tech Glowmapped - ENB Light (+ patch) | CS Light partial |
| Skyshards - ENB Light Addon | CS Light partial |
| Mundus Standing Stones - ENB Light Patch | CS Light partial |
| GIST Soul Trap - ENB Lights Patch | CS Light partial |
| Unique Barbas - ENB Light Addon | CS Light partial |
| Project AHO - ENB Patch | CS Light / Lux CS |
| Vigilant - Chest ENB Patch | Unknown |
| Icy Mesh Remaster - ENB Addon | CS feature parity TBD |

### ENB Complex Grass (4 enabled)

Tamrielic Grass, Folkvangr Summer Tundra, Origins of Forest, Cathedral 3D Pine Grass — each has **ENB Complex Grass** slice enabled. CS uses core **Grass Collision/Lighting** instead.

**CS replacer strategy:** Install **CS Light** with Lux-only FOMOD selections; disable all ENB Particle Lights / ENB Light / Rudy ENB light mods. Expect gaps for **Nolvus Awakening Lighting Patch** combos (untested).

---

## 4. ENB-specific shader / rendering features

| Nolvus mod / feature (enabled on disk) | CS 1.7.x parity |
|---|---|
| **ENB binaries** (stock game `enbseries/`) | Remove; install CS |
| **ENB Dynamic Cubemaps** | CS core Dynamic Cubemaps |
| **ENB - ShaderCache** | N/A under CS |
| **Subtle eye cubemap** | CS cubemap path differs |
| **ENB Anti-Aliasing** | CS TAA / upscaling mods |
| **Nolvus ReShade 2026 (Amon)** | **Remove** — CS FAQ: ReShade depth effects conflict |
| **ENB Complex Grass** (×4) | CS core grass features |
| **Particle Patch for ENB** | Not used under CS |
| **Water for ENB [4K]** + patches | CS core Water Effects + NAT.CS water options |
| **Splashes of Storms - ENB Fix** | Re-evaluate with CS Wetness Effects |
| **Word Wall Transparency Fix for ENB** | CS-specific fix may differ |
| **Extensive Complex Parallax** (Auto Parallax, SR Exterior Cities parallax, terrain parallax packs, etc.) | Validated under **ENB POM**; CS **Extended Materials** needs in-game QA |
| **EVLaS** (folder enabled; cfg only on disk) | If DLL deployed at runtime: **hard-block vs CS Sky Sync** — disable |

---

## 5. CS 1.7.x hard-block check (Nolvus on disk)

Cross-reference against `lessons-learned.md` and CS FAQ.

| Hard-block / obsolete standalone | Present in Nolvus modlist? | Scan result |
|---|---|---|
| **ENBSeries** | Yes (stock game + MO2 ENB mods) | Active |
| **Community Shaders** | No | **Absent** — must add |
| **EVLaS** | Yes (mod folder enabled) | cfg present; **dll not found** in mods tree |
| **Skyrim Upscaler** | No | **Absent** |
| **ReShade Helper** | No | **Absent** (ReShade itself **is** active via stock game) |
| **Light Limit Fix standalone** | No | **Absent** (use CS core) |
| **Terrain Shadows standalone** | No | **Absent** |
| **Water Effects standalone** | No | Only brightness fix mod |
| **Subsurface Scattering / SSS standalone** | No | **Absent** |
| **Screen Space Shadows standalone** | No | **Absent** |
| **Grass Collision / Grass Lighting standalone** | No | **Absent** (ENB Grass via ENB ini flags + Complex Grass mods) |
| **NAT.CS III / Lux CS / CS Light** | No | **Absent** — required for migration |

---

## 6. Complexity verdict

### **Major**

**Reasoning (from disk, not inference):**

1. **Preset + post stack is load-bearing** — Amon ENB + Nolvus ReShade 2026 are deployed to stock game; not MO2-toggleable like a normal mod.
2. **Weather is NAT-ENB wired** — active ESP chain (`NAT-ENB.esp`, seasonal framework, Amon fix, Lux-NAT bridge) assumes ENB post-processing.
3. **Lux depth is extreme** — 200+ active Lux/Via/Orbis patch plugins; Lux CS + hub re-runs would be a large FOMOD pass.
4. **63 ENB-linked mod folders** — particle lights, ENB Light meta-mod, Rudy ENB lights, water/grass ENB slices.
5. **No CS infrastructure** — zero Community Shaders mods on disk; full stack install from scratch on **Successor** profile only.
6. **Parallax ecosystem** — list is parallax-heavy; validated under ENB POM, not CS Extended Materials.
7. **SREX + Lux Orbis patch web** — city exterior lighting patches tie into ENB-era Lux Orbis; CS migration must not break SREX integration (project constraint).

### Recommended next steps

| Human GO on CS | Human NO-GO (stay ENB) |
|---|---|
| Create execution task: Successor profile only | Document Amon ENB + ReShade as baseline |
| Phase 1: CS core; remove ENB/ReShade from stock game; disable EVLaS folder | Keep Nolvus Awakening donor pristine |
| Phase 2: NAT.CS III + Skylighting/Cloud Shadows/Wetness | |
| Phase 3: Lux CS + CS Light; strip 63 ENB-light mods systematically | |
| Phase 4: Re-run Lux/Lux Orbis/Lux Via patch hubs for CS slices | |
| Phase 5: Extended in-game QA (seasons, SREX holds, interiors, parallax) | |

---

## Sources

- On-disk: `E:\Nolvus\Nolvus\` MO2 instance (paths in Methodology table)
- [ENB Migration Guide](https://modding.wiki/en/skyrim/developers/community-shaders/ENB-Migration-Guide)
- [Community Shaders FAQ](https://modding.wiki/en/skyrim/developers/community-shaders/faq)
- [NAT.CS III (139567)](https://www.nexusmods.com/skyrimspecialedition/mods/139567)
- [Lux CS (153919)](https://www.nexusmods.com/skyrimspecialedition/mods/153919)
- [CS Light (138443)](https://www.nexusmods.com/skyrimspecialedition/mods/138443)
- `E:\Skyrim AI Modlist\lessons-learned.md`
