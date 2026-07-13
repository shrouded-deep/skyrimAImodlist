# Anvil fundamentals gap audit — CORE ↔ User Interface

**Date:** 2026-07-12  
**Context:** User detour before task-0064 (Pandora). Anvil's `---- CORE ---` separator is empty; the **184 enabled mods** in the separator stack *between* `---- USER INTERFACE ---` and `---- CORE ---` are the list's stability/QoL foundation.

**Sources:**
- Anvil: `D:\Skyrim AI Modlist\Anvil\profiles\Anvil - Main Profile\modlist.txt` (lines 1022–1227)
- Keizaal Fork: `E:\Skyrim\profiles\Keizaal - Fork\modlist.txt`
- Post task-0065 Fork state (~967 active plugins)

---

## What this region is

In Anvil's modlist (top = highest priority), the block from **User Interface** down to **CORE** is the inverted “basement” of the list — everything the game needs before content/visuals load:

| Anvil separator | Enabled mods | On Fork (name/alias) | Missing |
|-----------------|-------------:|---------------------:|--------:|
| SkyUI | 3 | 3 | 0 |
| Utilities | 1 | 1 | 0 |
| Frameworks | 19 | 13 | 6 |
| Essentials | 5 | 3 | 2 |
| Console Improvements | 13 | 6 | 7 |
| Better Controls | 6 | 3 | 3 |
| General Fixes | 10 | 3 | 7 |
| Script Fixes | 35 | 3 | 32 |
| SKSE Plugin Fixes | 19 | 0 | 19 |
| SKSE Plugin Tweaks | 39 | 14 | 25 |
| Mod Tools & Resources | 18 | 4 | 14 |
| Alternate Start *(tooling slice)* | 10 | 4 | 6 |
| Skyrim Script Extender (SKSE) | 6 | 0 | 6 |
| **Total** | **184** | **57** | **127** |

Fork **does not mirror** Anvil's separator names — the same role is spread across `Essentials_separator`, `Utilities_separator`, and `User Interface_separator` at the profile bottom. Overlap is real but naming differs (e.g. `Engine Fixes` vs `SSE Engine Fixes`, `JContainers` vs `JContainers AE`).

---

## Already on Fork (good coverage)

Keizaal ships a solid core without copying Anvil wholesale:

- **SKSE + Address Library + SkyUI** (+ SkyUI fix mods in Patches)
- **USSEP + Scrambled Bugs** (base; missing two Scrambled slices)
- **Engine Fixes, Bug Fixes, Display Tweaks, Papyrus Tweaks**
- **SPID, KID, OAR, MCM Helper, PapyrusUtil, JContainers, Base Object Swapper, FormList Manipulator**
- **DynDOLOD DLL + DynDOLOD** (Anvil uses NG DLL naming + separate Resources mod)
- **~25 overlapping SKSE micro-fixes** (Actor Limit, Aurora, Dual Casting, Mfg Fix, etc.)
- **Keizaal-only utilities** Fork should keep: Community Shaders, Custom Skills, Seasonal Weathers, Nemesis/Pandora path, FISSES, etc.

---

## Missing mods — triage

### Phase A — Install (low risk, high stability value)

Copy from Anvil donor; enable on Fork. No strategic pivot.

**Script Fixes (32)** — `.psc` / record micro-fixes; MAST-clean in isolation:
Bleeding Damage Fixes, Hammering Animation and Sound Fixes, Quest Journal Limit Bug Fixer, Hide Quest Items in Container Menu, Nilheim BQ Fix, Dwemer Gates Don't Reset (+ Patches), Arcane Blacksmith's Apron Hood Fixes, Safety of Skuldafn, Solitude Rock Arch LOD Fix, LOD Unloading Bug Fix, Unaggressive Dragon Priests Fix, Durak Teleport Fix, Civil War Intro Scenes Run Only Once, Guild Master's Armor FP Texture Fix, Stuck on Screen Load Door Prompt Fix, NPC Stuck in Bleedout Fix, Zero Bounty Hostility Fix, Rock Traps Trigger Fixes, Dwemer Ballista Crash fix, Universal Cured Serana Eye Fix, Chillwind Depths CTD Fix, Stamina of Steeds, Hearthfires Houses Building Fix, Source of Stalhrim Quest Fix, Proving Honor Companions Fix, Shalidor's Maze Sound Fix, Labyrinthian Shalidor's Maze Fixes, Mannequin Management, Mount Anthor Dragon Fix, Dragon Dies on Touchdown Fix, EMISH Dragon Crash Land Markers Fix, Enchantable Special Item Fix *(if not superseded by Fork Functional Fearsome Fists patches)*.

**SKSE Plugin Fixes (19)** — crash guards:
Simplicity of Seeding, Thieves Guild Missing Items Fix, WI College Student Bug Fix, One Soul Only Mirmulnir, Smoothing of Splices, WIDeadBodyCleanupScript Crash Fix, WE05 Script Fix, TrapSwingingWall Script Fix, Stealth Detection Fixes, Scare my Enemy Bug Fix, Roggvir's Execution Scene Fixes, Optimized USSEP Valdr Quest, OnMagicEffectApply Replacer, Irkngthand's Possible Bugs Fix, Ethereal Immunity, dunPOISoldiersRaidOnStart Tweak, DLC2 Miraak BossFightScript Fix, DLC2 March of the Dead Fix, Delphine Skyhaven Bugfix MQ203.

**Scrambled Bugs slices (2):** Vendor Respawn Fix, Script Effect Archetype Crash Fix.

**General Fixes (7):** BTPS, Toggle Dialogue Camera, Better Jumping AE, Sprint Stuttering Fix, First Person Sneak Strafe Walk Stutter Fix, Fix Toggle Walk Run, Keyboard Shortcuts Fix.

**Better Controls (3):** No Console Spam, Kill Caps Lock NG, Console Commands Extender AE.

**Mod Tools NG QoL (14):** Yes Im Sure NG, Whose Quest is it Anyway NG, Which Key NG, Wash That Blood Off 2, Stay At The System Page NG, Skyrim Priority, Remember Lockpick Angle, Mum's the Word NG, Menu Zoom, I'm Walkin' Here NG with Pets, Hair Colour Sync, Essential Favorites, Mute On Focus Loss, Better AltTab.

**SKSE Plugin Tweaks — safe subset (~15):** Savefile Grouping Fix, Mu Joint Fix, LeveledList Crash Fix, ~~Game Settings Override (+ Collection)~~ **GSO deferred — incompatible Win11 24H2 + MO2 USVFS on Fork** (see `mo2-upgrade-plan-keizaal-2026-07-12.md`), Female Equipment Scale Fix, Equip Enchantment Fix, Enhanced Reanimation, Enhanced Invisibility, Bash Bug Fix, Barter Limit Fix, Alt-Tab Stuck Key Fix NG, Absorb Spell XP Fix, Alchemy XP Fix, ENB Light Inventory Fix (ELIF), Vampires Cast No Shadow 2, Stagger Effect Fix, SMP-NPC Crash Fix, Don't Stay in the Water, Better Combat Escape (both), Camera Persistence Fixes, DPI Scaling Fix *(Fork has DPI in Visuals — verify no duplicate)*.

**Essentials gap (2):** Light Placer, Mu Skeleton Editor.

**Estimated Phase A:** ~95 mod folders, ~80–100 new plugins (many ESL/no-ESP).

---

### Phase B — Framework gaps (install if downstream mods need them)

| Mod | Why |
|-----|-----|
| Fuz Ro D'oh | Voiced player grunts; optional immersion |
| Scaleform Translation Plus Plus NG | SFUI translation layer; some UI mods expect it |
| Sound Record Distributor | Audio distribution framework |
| Item Equip Restrictor | Slot restriction framework |
| Andrealphus' Papyrus Functions | Papyrus helper library |
| FSMP - Faster HDT-SMP | Cloth physics — **verify** against Keizaal's SMP/HDT choices first |

---

### Phase C — Needs human decision before install

| Mod / group | Issue |
|-------------|-------|
| **USMP** (2 slices) + full USMP | Large record patch; Keizaal may rely on USSEP+USCCP only |
| **Navigator - Navmesh Fixes** | Big navmesh pass; can fight quest/city mods — high test cost |
| **No Grass In Objects** | Grass culling tool; Fork uses Cathedral grass stack — different pipeline |
| **YAR - Yuril's Additional Resources** | LOD/resource pack for city mods; useful post-JK/Ryn but heavy |
| **Cleaned Base Game Masters + Resource Pack + CC esl pack** | Keizaal uses own CC curation (task-0057); don't blindly copy Anvil CC framework |
| **Creation Club - Survival Mode** | Survival friction — conflicts with power-fantasy lens |

---

### Deferred — already queued or tool-gated

| Item | Task |
|------|------|
| BodySlide and Outfit Studio | task-0059 |
| Dynamic Interface Patcher (DIP) | task-0059 |
| DynDOLOD The Little Things, LOD Model Library | task-0060 regen |
| Nemesis vs Pandora tooling | task-0064 |

---

## Fork extras Anvil doesn't have (keep)

Do not remove to “match Anvil”: Community Shaders, Custom Skills Framework, Seasonal Weathers, Nemesis output mods, NVIDIA Reflex, Discord Rich Presence, Vanilla Script microOptimizations, Comprehensive Attack Speed Patch, Constructible Object Custom Keyword System, etc.

---

## Recommended order

1. **task-0067** — Phase A fundamentals tranche (script + SKSE fixes + QoL NG + control fixes)
2. **Human call** on USMP / Navigator / NGIO / YAR (Phase C)
3. **task-0059** — BodySlide + DIP executables (pairs with fundamentals tooling)
4. **task-0064** — Pandora migration (replaces Nemesis in same stack region)
5. **task-0060** — LOD regen (DynDOLOD Little Things + Model Library after regen)

---

## Placement note

Fundamentals should land in Fork's **Essentials / Utilities** zone (profile bottom), not `Uncategorized`. Unlike content tranches (0063/0065), these are low-priority basement mods — match Keizaal's existing separator structure rather than Anvil's literal CORE/UI labels.
