# Anvil vs Keizaal — Gap Analysis

**Date:** 2026-07-12  
**Task:** task-0062  
**Sources:**
- Anvil: `D:\Skyrim AI Modlist\Anvil\profiles\Anvil - Main Profile\modlist.txt`
- Keizaal Fork: `E:\Skyrim\profiles\Keizaal - Fork\modlist.txt`

**Method:** Extract enabled mods (`+` prefix), case-insensitive name compare. Filter per task-0050/0051/0055 and `decisions.md`. No MO2 edits.

---

## Summary accounting

| Bucket | Count | Notes |
|--------|------:|-------|
| Anvil enabled (`+`) | **1,095** | 1,094 mods + 1 separator (`[Successor Additions]`) |
| Keizaal Fork enabled (`+`) | **832** | 813 mods + 19 separators |
| **In both lists** (name match) | **~289** | Shared city stack, USSEP/SKSE stack, partial TDM, frameworks, some visuals |
| **Anvil-only raw** | **~806** | Anvil enabled minus Keizaal set |
| Filtered — city stack (task-0051) | 11 | Already on Fork; excluded from candidates |
| Filtered — Spaghetti (task-0055) | 13 | 8 modular cities + 5 AIO world mods; dropped on Fork |
| Filtered — VB stack (task-0050) | 0 | Anvil does not ship VB; N/A |
| Filtered — decisions.md drops | 0 | Constellations not enabled on Anvil |
| Filtered — Anvil list infrastructure | 22 | Outputs, shader cache, Anvil MCM/settings, Pandora, maintenance utils |
| Filtered — separators | 1 | `[Successor Additions]_separator` |
| **Anvil-only candidates (after filters)** | **~759** | See category tables below |

> **Note:** ~620 of the candidates are **visual retexture/mesh/flora** mods (Anvil's core identity). Tables below highlight **triage-worthy** entries; bulk visual layers are summarized per subsection with representative samples rather than all 600+ rows.

---

## Top 10 interesting finds

| # | Mod | Why it matters |
|---|-----|----------------|
| 1 | **JK's interiors + outskirts suite** (~45 mods) | Largest content gap vs Keizaal; pairs with installed city stack; heavy patch web |
| 2 | **Ryn's statics suite** (~24 mods, Fork has only Karthspire) | Dungeon/landmark detail; Jelidity already ships Karthspire tweaks on Fork |
| 3 | **Anvil cheat/QoL block** (15 mods) | Pure power-fantasy: infinite pools OOC, auto-puzzles, equipment editors |
| 4 | **Lux + Orbis + Via + Patch Hubs** | Anvil lighting backbone; Fork uses CS Light + Classic Weathers — major pivot |
| 5 | **Nature of the Wild Lands 3.0 cluster** | Flagship tree replacer; conflicts with Keizaal Happy Little Trees |
| 6 | **NAT.CS III / NAT-ENB III** | CS-native weather; Fork uses Classic Weathers Extended |
| 7 | **Skyrim 3D Trees and Plants (Bingus' Cut)** | 3D tree meshes; perf + LOD regen cost; overlaps Fork tree choices |
| 8 | **ParallaxGen + output pipeline** | PBR parallax layer; requires CS/toolchain audit before adoption |
| 9 | **Embers XD + FYX fire patches** | High-impact VFX; CS ENB-light compat generally good |
| 10 | **Pandora Behaviour Engine** | Anvil animation compiler; Fork uses Nemesis (PNR) — mutually exclusive path |

---

## Gameplay

**Must-have (power-fantasy QoL):** cheat block, puzzle bypasses, equipment freedom.  
**Obvious reject:** none in this section (Anvil disabled true cheat engine / flying / smart harvest in `-` state).

| Mod name | What it does | Lens fit | Compat notes | ESL? |
|----------|-------------|----------|--------------|------|
| Summon Shadow MERCHANT | Summon a merchant anywhere to trade | ✓ | SKSE QoL; no VB conflict | no (SKSE) |
| Signature Equipment | Mark favourite gear as "signature" with bonuses | ✓ | Check SPID/KID overlap; light plugin possible | ? |
| Jewelry of Power | Buffs for jewelry slot items | ✓ | May touch leveled lists; audit vs Tamrielic Distribution | ? |
| Infinite Stamina Out of Combat | Regen stamina outside combat | ✓ | SKSE; stacks with Fork survival-off baseline | no |
| Infinite Magicka Out of Combat | Regen magicka outside combat | ✓ | SKSE; fine with Mysticism/VB | no |
| Infinite Shouting Out of Combat | Regen shout cooldowns OOC | ✓ | SKSE | no |
| Infinite Horse Stamina Out of Combat | Horse stamina regen OOC | ✓ | SKSE | no |
| Infinite Enchantment Charges | Weapons stay charged | ✓ | SKSE; power-fantasy aligned | no |
| No Enchantment Restriction SKSE Remake | Removes enchant-restriction rules | ✓ | SKSE; pairs with VB enchanting | no |
| In-Game Equipment Editor SE | Edit worn gear stats in UI | ✓ | SKSE; may overlap Fork IED presets | no |
| NPC Stats Editor | Edit NPC stats live | ✓ | SKSE utility | no |
| Dragon Claws Auto-Unlock | Auto-rotate claw door rings | ✓ | QoL; no conflict | no |
| Puzzle Pillar Auto-Solve | Auto-solve pillar puzzles | ✓ | QoL | no |
| Detect Levers and Keys | Highlights levers/keys | ✓ | QoL exploration aid | ? |
| Reading Is Bad SKSE | Instant book reading | ✓ | QoL; no friction | no |
| True Directional Movement suite (4 patches) | Modern lock-on 3P combat | ✓ | Fork has TDM base + diagonal fix; merge patch set carefully | no |
| Classic Sprinting Redone (AE) | Better sprint feel | ✓ | Fork has sprint fixes; verify overlap | ? |
| Oxygen Meter 2 | Breath meter UI | ? | Adds friction underwater; optional | ? |

---

## Content / Quests

Anvil is **visuals-first** — almost no quest/expansion mods vs Keizaal's deep quest layer (Wyrmstooth, Lucien, OCW, SEC, etc.). Anvil-only entries here are sparse.

**Must-have:** none identified (Keizaal already exceeds Anvil on quests).  
**Obvious reject:** N/A — Anvil ships few quest mods.

| Mod name | What it does | Lens fit | Compat notes | ESL? |
|----------|-------------|----------|--------------|------|
| *(none triage-worthy)* | Keizaal Fork already carries 30+ quest expansions Anvil lacks | — | Anvil gap runs the other direction for quests | — |

**Accounting:** All enabled Anvil quest-sized mods are either absent (Anvil doesn't enable them) or already on Keizaal under different list curation. No Anvil-only quest candidates require action.

---

## Cities / Locations

**Must-have:** JK's + Ryn's suites (if pursuing Anvil-level world detail).  
**Obvious reject:** all Spaghetti variants (filtered — task-0055).

| Mod name | What it does | Lens fit | Compat notes | ESL? |
|----------|-------------|----------|--------------|------|
| **JK's shop interiors** (20 mods) | High-detail shop interiors | ✓ | Needs patch hub pass; no Lux on Fork simplifies vs Anvil | mostly ESL |
| **JK's guild/HQ interiors** (12 mods) | Palace, college, guild HQ overhauls | ✓ | Conflicts with Keizaal "Great Cities" / OCW in Winterhold; patch audit required | mixed |
| **JK's outskirts** (4 mods) | City outskirts meshes | ✓ | Pairs with installed CWE/CWE-adjacent stack; patch hubs exist on Anvil | mixed |
| **JK's patch collections** (4 hubs) | JK×city/Ryn/Lux cross-patches | ✓ | Lux-free Fork needs hub re-run without Lux slices | no/patch |
| **Ryn's landmarks** (~20 mods) | Bleak Falls, Saarthal, Valtheim, etc. | ✓ | Jelidity's Karthspire Tweaks already on Fork; install rest + Ryn patch hub | mostly ESL |
| **Ryn's Riverwood houses** (4 mods) | Detail homes in Riverwood | ✓ | Overlaps Riverwood Has Charm — use Ryn Riverwood Patch Collection | ESL |
| **Ryn's patch collections** (4 hubs) | Ryn×JK×city patches | ✓ | Required if adding Ryn/JK body | patch ESPs |
| Whiterun Exteriors Patch Hub | Patches for CWE exterior | ✓ | Directly relevant to installed CWE | patch |
| Ivy - Whiterun Well / Riverwood Smelter | Small exterior clutter | ✓ | Minor; verify CWE mesh overlap | ? |
| FYX architecture cluster (~15) | Mesh fixes for cities/settlements | ✓ | Complements city stack; many are mesh-only | mostly no |
| Spaghetti's Solstheim/Faction Halls/Orc Strongholds/Palaces/Towns AIO | Spaghetti world expansions | ✗ | **Filtered** — Spaghetti dropped on Fork | ESL |
| Spaghetti's Cities - Clutter / NavCut addons | City clutter/navcuts for Spaghetti | ✗ | **Filtered** — requires Spaghetti masters | ESL |

**Already on both (not candidates):** Capital Whiterun/Windhelm, Ultimate Markarth (+Expanded), RedBag's Solitude, Crossed Daggers, Riverwood Has Charm+Walls, Rob's CWE fixes, RedBag/UME/Riverwood patch hubs.

---

## Visuals

**Must-have (if pursuing Anvil visual parity):** NOTWL or S3DPT, Embers XD, water/sky suite.  
**Obvious reject:** EVLaS (disabled on Anvil too), Survival Stews retexture, duplicate tree/grass stacks without removing Fork picks.

### Lighting & weather

| Mod name | What it does | Lens fit | Compat notes | ESL? |
|----------|-------------|----------|--------------|------|
| Lux + Lux Orbis + Lux Via (+ 3 patch hubs) | Interior/exterior lighting overhauls | ✓ spectacle | **Major fork pivot** — Keizaal has no Lux; hundreds of patches on Anvil | mixed |
| Actually Brighter Lux Templates | Brighter Lux presets | ✓ | Lux-dependent only | no |
| Lightened Skyrim | Global light intensity tweak | ✓ | Lux-dependent | no |
| CS Light | CS-compatible light mesh tweaks | ✓ | Fork lacks CS Light; lighter lift than full Lux | ? |
| NAT.CS III + NAT-ENB III + patches | Natural Atmospheric Tamriel for CS/ENB | ✓ | Replaces Classic Weathers on Fork; regen grass/LOD | yes/mixed |
| Splashes of Skyrim / Splashes of Storms | Rain/splash VFX | ✓ | Fork has Splashes of Storms already | ? |

### Trees, flora, landscape

| Mod name | What it does | Lens fit | Compat notes | ESL? |
|----------|-------------|----------|--------------|------|
| Nature of the Wild Lands 3.0 (+ addons) | Photoreal tree replacer | ✓ spectacle | **Conflicts** with Happy Little Trees; heavy perf | mostly no |
| Skyrim 3D Trees and Plants (Bingus' Cut) | 3D tree meshes | ✓ | Overlaps Fork trees; DynDOLOD regen required | no |
| Aspens Ablaze (+ DynDOLOD addon) | Aspen autumn replacer | ✓ | Season/GPU cost | no |
| Enhanced Landscapes - Dead Marsh (+ fixes) | Dead Marsh terrain | ✓ | Fork only has EL grass mix, not standalone | ? |
| Freak's Floral Fields / Solstheim | Cathedral grass density | ? | Grass conflict risk with Fork cathedral grass | no |
| Cathedral 3D plants (~15 Anvil-only) | 3D lavender, deathbell, etc. | ✓ | Partial overlap; dedupe before install | mostly no |
| Tomato/Faultier PBR city architecture | PBR textures for holds | ✓ | Pairs with city stack; texture-only | no |

### Effects, materials, parallax

| Mod name | What it does | Lens fit | Compat notes | ESL? |
|----------|-------------|----------|--------------|------|
| Embers XD (+ torch/spark patches) | Particle embers/fire | ✓ spectacle | CS ENB-light friendly; popular Anvil pick | no |
| Water for ENB | High-quality water | ✓ | Fork uses Cathedral Water; pick one | no |
| Parallax Spell Impacts (+ patches) | Parallax spell hit FX | ✓ | CS shader compat generally OK | ? |
| Praedy's Repository / Skyking AIOs | Curated texture AIOs | ✓ | Large; install selectively | no |
| Rudification / Glorious Gradients / Quality CubeMaps | Material/lighting enhancers | ✓ | CS-era staples | no |

### Bulk visual layer (representative — ~620 mods)

Anvil-only retexture/mesh mods not individually triaged. Grouped for accounting:

| Group | ~Count | Lens | Compat | ESL |
|-------|-------:|------|--------|-----|
| Armor/weapon retextures (Rustic, JS, Elytra, etc.) | ~45 | ✓ spectacle | Texture-only; safe if perf OK | mostly no |
| Creature/animal replacers (RUSTIC, Bellyaches, etc.) | ~55 | ✓ | Fork shares some (Falmer, Barbas); dedupe | mostly no |
| Character visuals (HPH, Xenius, eyes/hair/skin) | ~40 | ✓ | Fork has Tempered/HLG different path | mostly no |
| Clutter/dungeon meshes (JS series, SMIM-adjacent) | ~80 | ✓ | Fork has SMIM; additive | mostly no |
| Food/ingredient retextures | ~35 | ✓ | Low risk | no |
| Architecture/landscape textures (Rudy, Rally, Tomato) | ~120 | ✓ | Pairs with city/LOD regen | no |
| Audio-visual FX (blood, magic, snow, water ice) | ~40 | ✓ | Check CS feature overlap | no |
| Seasonal/sky meshes (Picta, Praedy sky, etc.) | ~25 | ✓ | Weather synergy audit | mixed |
| Misc mesh fixes (Assorted Mesh Fixes, SLAWF, etc.) | ~30 | ✓ | Often overlap Fork fixes — compare before adding | no |
| Remaining one-off retextures | ~150 | ✓ | Low priority singles | mostly no |

---

## Utilities / Tools

**Must-have:** none (Fork frameworks are more complete).  
**Obvious reject:** Pandora Behaviour Engine (Nemesis path locked in on Fork).

| Mod name | What it does | Lens fit | Compat notes | ESL? |
|----------|-------------|----------|--------------|------|
| Modex - A Mod Explorer Menu | In-game mod/item browser (AddItemMenu) | ✓ | Dev/power fantasy; SKSE | no |
| Debug Menu - Navmesh Viewer | In-game debug overlay | ? | Dev tool; not player-facing | no |
| Pandora Output + UBR Auto Skeleton Patch | Pandora behaviour pipeline | ✗ | **Reject** — Fork uses PNR/Nemesis; incompatible path | no |
| Bundled Behaviour Patches (Nemesis legacy) | Legacy behaviour patches | ? | Superseded by Fork DAR/OAR stack | no |
| Dynamic Interface Patcher (DIP) | UI texture patching | ? | Utility | no |
| YAR - Yuril's Additional Resources | Resource pack for FYX/mods | ? | Dependency for some mesh mods | no |
| Anvil - Dummy Plugins / Maintenance Utility / Update Checker | List-specific tooling | ✗ | **Filtered** — Anvil infrastructure | yes/no |
| Anvil outputs (DynDOLOD/TexGen/xLODGen/PG/Synthesis/BS/CK) | Generated outputs | ✗ | **Filtered** — Fork has own Outputs separator | output |
| Community Shaders - Anvil Settings | Tuned CS INI presets | ? | Reference only; don't copy blindly onto Fork | no |
| Creation Club - Survival Mode (enabled on Anvil) | Bethesda survival mode | ✗ | Friction; Fork uses Survival Mode Improved differently | yes |

**Already on both:** SKSE, Address Library, OAR, SPID, KID, JContainers, MCM Helper, BOS, FLM, RaceMenu (Fork disabled SimonRim RaceMenu), SmoothCam, Photo Mode, DynDOLOD DLL, Community Shaders, Nemesis/PNR (different compiler path).

---

## Filtered mod list (accounting reference)

### City stack — already on Fork (task-0051)

Capital Whiterun Expansion, Capital Windhelm Expansion, Ultimate Markarth, Ultimate Markarth Expanded, RedBag's Solitude, City of Crossed Daggers - Riften Expansion, Riverwood Has Charm and Walls, Rob's Bug Fixes - Capital Whiterun, RedBag Patch Collection, Riverwood Has Walls Patch Collection, UME Patch Hub.

### Spaghetti — dropped (task-0055)

Spaghetti's Cities - Whiterun/Windhelm/Markarth/Solitude/Riften, Spaghetti's Towns - Riverwood, Spaghetti's Capital Windhelm Expansion, Crossed Daggers - Spaghetti Patch, CWE Spaghetti Patch, Spaghetti's Cities - Clutter Addons, Spaghetti's Mods - NavCut Addon, Spaghetti's Solstheim - AIO, Spaghetti's Faction Halls - AIO, Spaghetti's Orc Strongholds - AIO, Spaghetti's Palaces - AIO, Spaghetti's Towns - AIO.

### Anvil infrastructure (not transferable)

Anvil - DynDOLOD/TexGen/xLODGen/ParallaxGen/Synthesis/xEdit/Bodyslide/CK/Grass Cache/Misc/ShaderCache Outputs, Anvil - MCM Output, Community Shaders - Anvil Settings, NGIO/PO3/SSE EF/SDT - Anvil Settings, Pandora Output, Modlist Maintenance Utility, Modlist Update Checker, Anvil - Dummy Plugins, Desktop Splash Screen (Fork has own), `[Successor Additions]_separator`.

---

## Recommendations for human triage

1. **High value / manageable scope:** Anvil **cheat/QoL block** (15 SKSE mods) — pure power fantasy, low patch cost.
2. **High value / high scope:** **JK's + Ryn's** location suites — biggest world-detail gap; queue as dedicated install task with patch hub pass (no Lux on Fork simplifies vs Anvil task-0045).
3. **Strategic choice (not a mod pick):** Adopt **Lux stack** OR **stay CS Light + Classic Weathers** — determines whether Anvil lighting/weather candidates are worth researching further.
4. **Defer bulk visuals:** Import Anvil's 600+ retextures only after toolchain/regen window (task-0060) — otherwise LOD/grass conflicts accumulate.
5. **Do not import:** Spaghetti (decided), Pandora behaviour path, Survival friction mods.

---

## Plugin budget note

Current Fork: **105 / 254 full-weight** (task-0052). JK's + Ryn's together add ~30–50 record plugins (many ESL-flagged). Cheat block is SKSE-only. Lux/NOTWL/S3DPT add full-weight plugins — run `scripts/full-mast-scan.ps1` before any batch install.

---

*Research only. No MO2 files modified. Not committed per user instruction (task acceptance "committed" deferred).*
