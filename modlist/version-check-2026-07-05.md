# Version Check Report — 2026-07-05

Prioritized version audit of the Anvil-based install at `D:\Skyrim AI Modlist\Anvil`
(task-0008). Source: MO2 `meta.ini` version fields (894 Nexus-tracked mod folders),
cross-checked against Nexus/GitHub for core frameworks and toolchain. **Not an
exhaustive pass** over all 354 plugins — focused on frameworks, flagged mods, and
MO2-detected drift.

MO2's `newestVersion` cache was last refreshed around the April 2025 install
(most `lastNexusQuery` timestamps cluster Jan–May 2025). Where MO2 reports
"current," Nexus was spot-checked for high-impact mods anyway.

---

## Executive summary

| Category | Count / status |
|---|---|
| Core frameworks verified | 35 mods (see Tier 1) |
| **Behind upstream — high caution** | Open Animation Replacer, DynDOLOD toolchain, PGPatcher/ParallaxGen |
| **Behind upstream — routine/always-keep-current** | Community Shaders (runtime shader cache only — update independently, no regen coordination needed) |
| **Behind upstream — routine/medium** | USSEP, USMP, Water for ENB, Faultier PBR suite, several landscape/PBR add-ons |
| Current per MO2 + Nexus spot-check | SKSE, Address Library, Lux suite, SPID/KID, most PO3 libs, RaceMenu, TDM, etc. |
| MO2 stale cache (installed ≠ newestVersion) | **78** mod folders total — mostly texture/misc; full list in Appendix A |
| Abandoned / static | Nemesis (no updates since 2021), several pre-2020 texture mods still present |
| Flagged in decisions.md | MCM Recorder — version current; dirty cell issue is separate |

**Biggest gap:** the **offline generated-output toolchain** (PGPatcher/ParallaxGen,
DynDOLOD) is several major versions behind current upstream. Updating any one piece
requires coordinated regen (ParallaxGen, TexGen/DynDOLOD, Synthesis, Occlusion) —
treat as a planned maintenance window, not drive-by bumps.

**Community Shaders is not part of this coordination risk.** CS is a runtime shader
system — it builds its shader cache on first game launch after an update, with no
offline generation step and no dependency on PGPatcher or DynDOLOD output. Update it
independently whenever a new version is available, same as any other framework mod.

---

## Tier 1 — Core frameworks & toolchain

### SKSE / plugin infrastructure

| Mod | Nexus ID | Installed | Latest available | Update risk |
|---|---|---|---|---|
| Skyrim Script Extender (SKSE64) | 30379 | 2.2.6.0 | 2.2.6.0 | **Current** (game 1.6.1170) |
| Address Library for SKSE | 32444 | 11.0.0.0 | 11.0.0.0 (MO2) | **Current** per MO2; last Nexus activity Feb 2026 |
| SSE Engine Fixes | 17230 | 6.2.0.0 | 6.1.1.0 (MO2 cache) | **Ahead of MO2 cache** — Anvil ships newer than cached newest |
| PapyrusUtil AE | 13048 | 4.6.0.0 | 4.6.0.0 | Current |
| powerofthree's Papyrus Extender | 22854 | 5.10.0.0 | 5.10.0.0 | Current |
| powerofthree's Tweaks | 51073 | 1.13.1.0 | 1.13.1.0 | Current |
| JContainers AE | 16495 | 4.2.9.0 | 4.2.9.0 | Current |
| ConsoleUtilSSE NG | 76649 | 1.5.1.0 | 1.5.1.0 | Current |
| MCM Helper | 53000 | 1.5.0.0 | 1.5.0.0 | Current |

### Distributors & animation framework

| Mod | Nexus ID | Installed | Latest available | Update risk |
|---|---|---|---|---|
| Spell Perk Item Distributor (SPID) | 36869 | **7.3.1** | 7.3.1 | **Current** (updated task-0015) |
| Keyword Item Distributor (KID) | 55728 | 3.4.0.0 | 3.4.0.0 | Current |
| Open Animation Replacer | 92109 | **3.1.6.0** | 3.1.6 | **Current** (updated task-0015) |
| Project New Reign - Nemesis | 60033 | 0.84.0.0b- (disabled) | — | **Replaced** — Pandora Behaviour Engine+ 4.3.1-beta installed; MO2 prep done (task-0018); behavior regen pending manual MO2 launch |
| Pandora Behaviour Engine+ | 133232 | **4.3.1-beta** (tool-only, disabled in modlist) | 4.3.1-beta | Installed — awaiting first manual regen |

### Patches & lighting stack

| Mod | Nexus ID | Installed | Latest available | Update risk |
|---|---|---|---|---|
| USSEP | 266 | 4.3.4.0a | **4.3.8a** (Mar 2026) | **Medium** — routine patch release; re-check conflict winners after update |
| USMP | 49616 | 2.6.3.0 | **2.6.7** | **Medium** — several minor releases; 2.6.7 drops Papyrus Extender requirement |
| Lux (Patch Hub) | 113002 | 6.8.0.0 | 6.8.0.0 | **Disabled** 2026-07-07 (task-0021) — replaced by MLO2 pending install |
| Lux Orbis | 56095 | 4.5.0.0 | 4.5.0.0 | **Disabled** 2026-07-07 (task-0021) |
| Lux Via | 63588 | 2.2.0.0 | 2.2.0.0 | **Disabled** 2026-07-07 (task-0021) |
| Modern Lighting Overhaul 2 | 160748 | — | latest | **Not installed** — user download required (task-0021) |
| Embers XD | 37085 | 3.1.2.0 | 3.1.2.0 | Current |
| Audio Overhaul Skyrim | 12466 | 4.1.3.0 | 4.1.3.0 | Current |

### Weather / water / landscape (high conflict surface)

| Mod | Nexus ID | Installed | Latest available | Update risk |
|---|---|---|---|---|
| NAT.ENB III (weather) | 27141 | 3.1.1.0C-F | 3.1.1.0C-F | Current (Anvil-pinned variant) |
| NAT.CS III | 139567 | 1.5.0.0 | 1.5.0.0 | Current |
| Water for ENB | 37061 | f2.04 | **f2.05** (Apr 2026) | **Low** — patch release; regen W4ENB Synthesis patcher after update |
| Skyrim Landscape and Water Fixes | 26138 | 9.3.0.0 | 9.2.0.0 (MO2) | **Ahead of MO2 cache** — installed newer than cached newest |
| Nature of the Wild Lands | 63604 | 3.12.0.0 | 3.12.0.0 | Current |
| NOTWL Floating Beehive Fixes | 144553 | 1.0.0.0 | 1.0.1.0 | **Low** — minor fix mod |

### UI / character frameworks

| Mod | Nexus ID | Installed | Latest available | Update risk |
|---|---|---|---|---|
| SkyUI | 12604 | **6.11.0.0** | **6.11.0.0** | **Updated** (task-0014) — was 5.2 SE; community SkyUI 6 line (doodlum). Light ESL plugin; native aspect-ratio support |
| RaceMenu | 19080 | 0.4.19.16 | 0.4.19.16 | Current |
| True Directional Movement | 51614 | 2.2.6.0 | 2.2.6.0 | Current |
| SmoothCam | 41252 | 1.7.0.0 | 1.7.0.0 | Current |
| TrueHUD | 62775 | 1.1.9.0 | 1.1.9.0 | Current |

### Runtime shader system

Community Shaders generates its shader cache at game launch — no offline regen step,
no coordination with DynDOLOD or PGPatcher. Update independently, keep current.

| Component | Installed | Latest available | Update risk |
|---|---|---|---|
| **Community Shaders** (86492) | 1.2.1.0 | **1.7.3** (Jun 2026) | **Routine** — update independently; CS plugin submods (listed in MO2 under the CS section) should be updated at the same time to stay compatible with the new CS version |

### Generated-output toolchain (highest maintenance cost)

| Component | Installed | Latest available | Update risk |
|---|---|---|---|
| **PGPatcher / ParallaxGen** (120946) | tool binary dated **2025-04-19** | **1.1.4** (Jun 2026) | **High** — regen `ParallaxGen.esp` / `PG_1.esp` after update |
| **DynDOLOD Standalone** (68518) | tool binary dated **2025-02-24** | **Alpha-204** (Jun 2026) | **High** — full TexGen + DynDOLOD regen |
| **DynDOLOD Resources SE 3** (52897) | Alpha-55 | **Alpha-59** (May 2026) | **High** — must match standalone version |
| **DynDOLOD DLL NG** (97720) | Alpha-33 | Bundled with current standalone (Alpha-204 line) | **High** — far behind |
| **Synthesis** (tool) | 0.33.3 | Check [releases](https://github.com/Mutagen-Modding/Synthesis/releases) before regen | Medium — regen all four `ANV_Syn*.esp` after load-order changes |
| **Occlusion** | generated | regen after DynDOLOD | follows DynDOLOD update |

---

## Tier 2 — Flagged in `decisions.md`

| Mod | Nexus ID | Installed | Latest | Notes |
|---|---|---|---|---|
| **MCM Recorder** | 61719 | 1.0.7.0 | 1.0.7.0 | Version is current. task-0005 flagged a **dirty cell override** on `WEMerchantChests` — that is a plugin-quality issue, not a stale-version issue. Consider disabling the mod or patching the cell if the debug reference is unintentional. |

---

## Tier 3 — Other MO2-detected updates (prioritized subset)

78 mod folders have `version ≠ newestVersion` in MO2. Most are low-risk texture or mesh swaps. Notable entries beyond Tier 1:

| Mod | Installed | MO2 newestVersion | Risk |
|---|---|---|---|
| Faultier's PBR suite (125308) — 7 folders | 1.0.0.0 / f1.02 | **2.0.0.0** | **High** — major PBR rework; regen ParallaxGen after |
| Nordic Stonewalls (57686) | 2.12.0.0 | 3.10.0.0 | **High** — major version |
| Icy Mesh Remaster (73381) | 2.38.0.0 | 2.41.0.0 | Medium |
| Skyrim 202X Smaller Packages (58370) | 10.0.0.0 | 10.5.1.0 | Medium — large texture pack |
| No Grass In Objects (42161) | 1.3.3.0 | 1.4.0.0 | Medium — regen grass/occlusion interactions |
| Book Covers Skyrim Updated (58376) | 3.5.2.0 | 0.0.0.0 (MO2 glitch) | Unknown — verify manually on Nexus |
| Simple Children (22789) | 1.1.0.0 | 1.1.0.0 | **Static** — Nexus page last updated Feb 2019 |
| Dark Brotherhood Armor Replacer (56903) | d2025.3.16.0 | 5.0.0.0 | Verify — version strings non-standard |
| zzjay's Horse Overhaul (63640) | 1.5.2.0 | 1.5.3.0 | Low |
| Lore-Friendly Load Screen Compendium (138294) | 2.0.0.0 | 2.0.1.0 | Low |
| Vanilla Hair Remake HPH Patch (117861) | 3.2.0.0 | 3.3.0.0 | Low–medium |

Full MO2 stale list: Appendix A (78 entries).

---

## Tier 4 — Confirmed current (spot-checked)

These carry high downstream conflict weight and matched latest upstream at audit time:

SKSE 2.2.6, Address Library 11, PapyrusUtil 4.6, PO3 Papyrus Extender 5.10,
JContainers 4.2.9, KID 3.4, Lux 6.8 / Lux Orbis 4.5 / Lux Via 2.2, Embers XD 3.1.2,
RaceMenu 0.4.19.16, TDM 2.2.6, SmoothCam 1.7, TrueHUD 1.1.9, NOTWL 3.12,
AOS 4.1.3, MCM Helper 1.5.

---

## Abandoned, static, or successor-noted

| Mod | Status |
|---|---|
| **Nemesis** (60033) | No updates since Dec 2021. Still at 0.84-beta. Community successor: **Pandora Behaviour Engine+** (133232). Anvil ships pre-generated Nemesis output — engine update only matters if animation mods change. |
| **Simple Children** (22789) | Nexus page unchanged since 2019. Works but unmaintained. |
| **SkyUI** (12604) | **Updated to 6.11** (task-0014). Same Nexus page received major community update Mar 2026 after 9 years — version-check spot-check missed it. |
| **Better Dialogue / MessageBox Controls** (1429/1428) | Nexus pages from 2016 — stable utilities, not actively maintained. |
| **Ultimate HD Torch** (28060) | Nexus page from 2013; Anvil uses a dated custom build string (`d2025.3.11.0`). |

Nothing checked appears **removed from Nexus**. No hard 404s on priority mod IDs.

---

## Recommended update order (if proceeding — human decision)

Report only; no tasks queued. If you choose to update, this order minimizes breakage:

1. **USSEP → USMP** (plugin-level; no tool regen)
2. **Community Shaders + CS plugin submods** (runtime only; no regen; update independently at any time — listed here for ordering convenience only)
3. **SKSE-dependent DLLs** as a batch (OAR, SPID, W4ENB, etc.) after verifying each supports your game runtime
4. **PGPatcher** → regen ParallaxGen output
5. **DynDOLOD Resources + Standalone + DLL** (matched versions) → TexGen → DynDOLOD → Occlusion
6. **Synthesis** profile regen (four `ANV_Syn*.esp`)
7. **Cosmetic/texture stale mods** (Faultier PBR, 202X packages, etc.) — any time, but regen ParallaxGen if PBR meshes change

**Defer without strong reason:** Nemesis → Pandora migration (list-wide behaviour impact), Open Animation Replacer v2→v3 (audit every OAR/DAR mod first).

---

## Appendix A — Full MO2 stale list (78 mods)

Mods where MO2 `version` ≠ `newestVersion` (Apr 2025 install cache). Low-priority texture/misc mods included for completeness.

| Mod | Installed | MO2 newest |
|---|---|---|
| Ancient AF Windhelm PBR | 1.0.0.0-PBR | 1.0.0.0 |
| Book Covers Skyrim Updated | 3.5.2.0 | 0.0.0.0 |
| Carrots Remade | 2.1.0.0 | f1.02 |
| Cathedral - 3D Deathbell | 1.1.0.0 | 1.0.0.0 |
| CC Rare Curios Poison Apple Fix | 1.1.0.0 | 1.0.0.0 |
| Complete Widescreen Fix (21x9 / 32x9) | 3.9.1.0 | 3.9.0.0 |
| Dark Brotherhood Armor Replacer | d2025.3.16.0 | 5.0.0.0 |
| Disable USSEP Book | 1.1.0.0 | 1.0.0.0 |
| DynDOLOD 3 Resources | Alpha-55 | Alpha-54 |
| ElSopa Quivers Redone | 1.0.0.0 | 1.1.0.0 |
| Faultier's PBR (×7 folders) | 1.0.0.0 / f1.02 | 2.0.0.0 |
| Forgotten Herbs / Plants | 1.1.0.0 | 1.0.0.0 |
| Forgotten Retex Project | 8.4.0.0 | 8.3.0.0 |
| Golden Saint Armory Revamped | 1.0.0.0a | 1.0.0.0 |
| Halffaces 3D Windmill | 1.0.0.0 | 1.2.0.0 |
| HD Glaze JS Shrines | 1.4.0.0 | 1.2.0.0 |
| HFs Whiterun Shields | 1.0.0.0 | f1.01 |
| High Hrothgar Material Fix | 1.16.0.0 | 1.16.1.0 |
| High Poly DB Ingredients | f1.01 | 1.0.0.0 |
| High Poly Vanilla Hair | 3.0.0.0f | 3.0.0.0 |
| Icy Mesh Remaster | 2.38.0.0 | 2.41.0.0 |
| Kanjs Chaurus Eggs | 1.0.0.0 | 1.1.0.0 |
| Kill Caps Lock NG | 1.0.0.1 | 1.0.0.0 |
| Large Nordic Tent | 1.0.0.0 | 0.0.0.0 |
| Load Screen Compendium | 2.0.0.0 | 2.0.1.0 |
| Luminous Atronachs | 2.0.0.0ESPLite | 2.0.0.0 |
| Mannequin Management | 4.2.0.0 | 4.1.0.0 |
| Mari's Flora | 1.2.0.0 | 1.0.0.0 |
| Markarth Fixed AF | 1.4.1.0 | 1.4.0.0 |
| Masculine Khajiit Textures | 2.1.0.0 | 2.2.0.0 |
| Metallurgy Ingot Fix | 1.0.0.0a | 1.0.0.0 |
| Mute On Focus Loss | 6.0.0.0 | 5.0.0.0 |
| NOTWL Beehive Fixes | 1.0.0.0 | 1.0.1.0 |
| No Grass In Objects | 1.3.3.0 | 1.4.0.0 |
| Nordic Stonewalls v2 | 2.12.0.0 | 3.10.0.0 |
| Orc Brow Horns HPH Fix | 1.0.0.0 | 1.1.0.0 |
| Ore Deposit Metallurgy Patch | 2.2.0.0 | 2.3.0.0 |
| PBR Gold/Silverware (+ patch) | 3.1.0.0 / 1.1.0.0 | 3.2.0.0 / 1.0.0.0 |
| Real Rabbits HD | 1.0.0.0 | 1.3.0.0 |
| Retexture for Soup | 1.3.0.0 | 1.4.0.0 |
| Sanguine Enhanced Blood | 1.4.2.0 | 1.4.0.0 |
| SC Horses Mane Fix | 1.0.1.0 | 2.0.0.0 |
| Skyrim 202X Caves/Mines | 10.0.0.0 | 10.5.1.0 |
| Skyrim 3D Misc (×2) | 1.0.x | 1.0.2.0 |
| SLaWF | 9.3.0.0 | 9.2.0.0 |
| SLaWF Assorted Mesh Fixes | 1.1.0.0 | 1.16.1.0 |
| SkyUI ESL Master plugin | — | **Disabled** — native in SkyUI 6 (task-0014) |
| slightly Better EVIL Rock Cairns | 1.1.0.0 | 1.0.0.0 |
| SmoothCam Octavian Preset | 1.1.2.0 | 1.1.1.0 |
| Snowy Tree Swapper | 2.0.0.0 | 1.0.0.0 |
| Sowables Potatoes Alt Textures | 1.15.0.0 | 2.1.1.0 |
| SSE Engine Fixes | 6.2.0.0 | 6.1.1.0 |
| Stretched Snow Begone | f5.01 | f5.00 |
| Survival Mode Improved | 1.6.0.0 | 1.5.2.0 |
| Survival Stews SMIM | 1.1.0.0 | 1.0.0.0 |
| Thalmor Embassy Mesh Fixes | 1.0.0.0 | f1.01 |
| To Your Face AE | 1.0.0.0u | 1.0.0.0r |
| Tomato's PBR Farmhouses/Solitude/Whiterun | various | various |
| Ultimate HD Torch | d2025.3.11.0 | 1.3.0.0 |
| Unofficial Skyrim Modder's Patch | 2.6.3.0 | 2.6.4.0 |
| Upgraded Slaughterfish | 1.1.0.0 | 1.0.0.0 |
| Vanilla Hair Remake HPH Patch | 3.2.0.0 | 3.3.0.0 |
| Wall Mounted Dead Animals | 1.0.0.0 | 1.1.0.0 |
| Water for ENB | f2.04 | f2.05 |
| zzjay's Horse Overhaul | 1.5.2.0 | 1.5.3.0 |

*(Some rows collapsed — Faultier PBR counted once in summary.)*

---

## Methodology notes

- Installed versions: MO2 `meta.ini` `version=` field per mod folder.
- MO2 drift: automated compare of `version` vs `newestVersion` across 894 tracked mods.
- Nexus/GitHub verification: manual spot-check for Tier 1 and high-risk stale entries (Jul 2026).
- Plugins in `baseline-plugins-2026-07-05.txt` map to mod folders via MO2; multi-plugin mods counted once at folder level.
