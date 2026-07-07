# Lux Suite → Modern Lighting Overhaul 2 (MLO2) Migration Plan

Research for task-0019. **Do not execute from this document** — human sign-off
required before any MO2 install/removal (list-wide visual philosophy change on
the same order as the Pandora migration).

**Instance:** `D:\Skyrim AI Modlist\Anvil` · Profile: `Anvil - Main Profile`  
**Current lighting:** [Lux](https://www.nexusmods.com/skyrimspecialedition/mods/43158) **6.8** (patch hub [113002](https://www.nexusmods.com/skyrimspecialedition/mods/113002)) · [Lux Orbis](https://www.nexusmods.com/skyrimspecialedition/mods/56095) **4.5** (hub [114169](https://www.nexusmods.com/skyrimspecialedition/mods/114169)) · [Lux Via](https://www.nexusmods.com/skyrimspecialedition/mods/63588) **2.2**  
**Target:** [Modern Lighting Overhaul 2 (MLO2)](https://www.nexusmods.com/skyrimspecialedition/mods/160748) — patchless SKSE dynamic light-source tuning (no cell/mesh ESP edits)

---

## Executive summary

Anvil runs the **full Lux trilogy** plus three patch hubs, **35 active Lux-named
plugins**, and **22 content mods** that currently depend on Lux/Orbis/Via
compatibility patches (or Lux-specific CS Light configs). Lux owns **929+ record
wins** in the baseline scan; Orbis deliberately edits guard gear leveled lists
(task-0010 — intentional).

**Philosophy change:** Lux = hand-placed interior/exterior cell rework + huge patch
ecosystem. MLO2 = runtime detection of placed light refs + Base Object Swapper
(BOS) mesh swaps; **no Lux-style patches**. User intent is **bold full replacement**
(not Lux-as-fallback).

**Compatibility verdict:** Most Anvil content mods become **patchless-by-design**
under MLO2 for *light placement* — but **lose Lux's cinematic cell lighting,
Orbis exterior rework, and Via road/lantern world edits**. Expect a visible
regression in curated mood unless paired mods (e.g. Window Shadows Ultimate,
ambient templates) are added separately.

**CS stack:** Anvil is on **Community Shaders 1.7.3** (task-0017). MLO2 targets
CS + Light Limit Fix (core-merged in CS 1.7.x). **CS Light** is installed with
**Lux FOMOD configs** — must be reinstalled or retuned for Vanilla/MLO2 on migration.

**Critical gap (resolved task-0026):** [Window Shadows Ultimate](https://www.nexusmods.com/skyrimspecialedition/mods/150494)
was not in Anvil; now scheduled via `scripts/install-wsu-stack.ps1` after Nexus download.
(Nexus **66665** is an unrelated mod — do not use that ID.)

**DynDOLOD / Synthesis / ParallaxGen:** no regen required solely for Lux→MLO2 swap
(unless unrelated maintenance scheduled). Remove Lux plugins before next tool run so
generators do not treat `Lux*.esp` as winners.

---

## MLO2 compatibility model

| Question | Answer |
|---|---|
| ESP/plugins required? | **No** — MLO2 is SKSE (`MLO.ini` + BOS `_SWAP.ini` files); no Lux-style patch ESPs |
| Replaces Lux interiors? | **No** — MLO2 tunes existing light refs; it does **not** rebuild cells, templates, or image spaces like Lux |
| Replaces Lux Orbis exteriors? | **No** — Orbis cell/template/guard-torch design goes away; MLO2 only affects detectable mesh light sources outdoors |
| Replaces Lux Via roads? | **No** — Via's road lanterns, bridges, and resources are separate world/mesh content |
| Works with Embers XD? | **Yes — native integration** (Anvil has full Embers stack) |
| Works with NAT? | **Partial** — no `Lux - NAT ENB.esp` equivalent; tune via MLO2.ini + NAT.CS / weather INIs |
| Lux + MLO2 together? | **User rejected** — full Lux removal; old "MLO Lux tweak patch" (140886) is **obsolete** per MLO2 docs |
| Load order | MLO2 BOS swaps must **win mesh conflicts** — place MLO2 **low** in modlist (above outputs only) |
| CS 1.7.3 | **Compatible** — Anvil already runs CS 1.7.3 + core Light Limit Fix; do **not** re-enable standalone LLF folder |
| ENB vs CS | Anvil uses **NAT.CS III** (CS weather), not ENB runtime — MLO2 CS path is the relevant one |

Sources: [MLO2 Nexus 160748](https://www.nexusmods.com/skyrimspecialedition/mods/160748), [MLO (v1) changelog / integration list 132920](https://www.nexusmods.com/skyrimspecialedition/mods/132920), [MLO Patch Hub 141249](https://www.nexusmods.com/skyrimspecialedition/mods/141249), [Dark Crypts MLO2 addon 145789](https://www.nexusmods.com/skyrimspecialedition/mods/145789), task-0017 CS audit.

---

## Current Lux suite state (Anvil)

### MO2 mods (7 folders + separators)

| Mod folder | Nexus | Role |
|---|---|---|
| Lux | 43158 / hub 113002 | Interior lighting overhaul + main FOMOD mesh options |
| Lux - Patch Hub | 113002 | Official Lux patches (FOMOD auto-detect) |
| Lux Orbis | 56095 / hub 114169 | Exterior lighting overhaul |
| Lux Orbis - Patch Hub | 114169 | Official Orbis patches |
| Lux Via | 63588 | Road/lantern exterior overhaul + resources |
| Lux via - Patch Hub | 63588 | Via compatibility patches |
| Actually Brighter Lux Templates | (Lux optional) | Brighter template global replacer |
| Meridia's Luxon Beacon Replacer | 34782 | Meridia beacon mesh; compatible with Lux Orbis per shrine patches |

### Active plugins (35 Lux-named, profile `plugins.txt`)

**Masters / core:** `Lux - Master plugin.esm`, `Lux Orbis - Master plugin.esm`,
`Lux - Resources.esp`, `Lux Via.esp`, `Lux Via - plugin.esp`, `Lux Orbis.esp`, `Lux.esp`

**Lux Via options:** Blended Roads bridges texture sets, More Lantern Posts, More
Wooden Bridges, `ANV_Lux Via - HPP Firewood Snow.esp`

**Lux Orbis patches:** CC Fish, Saints and Seducers, USSEP, USMP, Embers XD,
Mandragora Meridia Shrine, Northern Marsh Bridges, Riften Sconce, Ivy Well + Ivy
Smelter (bundled in Ivy mods), `ANV_Lux Orbis - SB Windhelm Entrance.esp`

**Lux patches:** CC Fish, Saints and Seducers, USSEP, Embers XD, NAT ENB, SLaWF,
Water for ENB ×2, Volkihar Soundscape (ANV), No grass in caves ×2 (ANV W4ENB),
Brighter interior nights, Even Brighter Templates, Actually Brighter Templates

**Synthesis note:** `Lux.esp` is treated as generated-tool-class output in baseline
scan (929 wins) — it is author-maintained but list convention treats it as a
high-priority lighting owner.

---

## Lux-dependent mods — compatibility matrix

**Count:** **22 installed content mods** with an active Lux/Orbis/Via patch or
Lux-specific companion config (excluding the Lux suite folders themselves).  
**Plus:** **CS Light** (Lux FOMOD JSON profile — not a Lux patch ESP but hard
dependency on Lux tuning).

Legend: **MLO2 status** = documented native / patchless-by-design / unconfirmed.

### Patched content mods (active plugins today)

| Base mod (MO2 folder) | Lux patch(es) active | MLO2 status | Notes |
|---|---|---|---|
| Unofficial Skyrim Special Edition Patch | Lux + Orbis USSEP | **Patchless-by-design** | Drop both Lux USSEP patches; USSEP stays |
| Unofficial Skyrim Modders Patch | Orbis USMP | **Patchless-by-design** | Drop Orbis USMP patch |
| Embers XD (+ Fire Them Sparks, Torch Edit, FYX satellites) | Lux + Orbis Embers XD | **Documented native** | Keep Embers; remove Lux patches only; MLO2 auto-detects Embers mesh family |
| Creation Club - Fishing | Lux + Orbis CC Fish | **Documented native** (MLO v1 list; MLO2 inherits) | Drop Lux CC Fish patches |
| Saints and Seducers (CC) | Lux + Orbis SaS | **Unconfirmed** | No explicit MLO2 SaS entry; likely patchless for light refs |
| NAT.ENB III - Weather Plugin | Lux - NAT ENB.esp | **Unconfirmed / retune** | Patch was Lux interior image-space tuning for NAT; revisit NAT.CS + MLO2.ini color consistency |
| Skyrim Landscape and Water Fixes | Lux - SLaWF | **Patchless-by-design** | SLaWF mesh fixes unrelated to Lux lighting; drop patch |
| Water for ENB | Lux W4ENB + Shades + ANV no-grass | **Unconfirmed** | W4ENB patches were Lux interior compatibility; keep W4ENB mod, drop Lux patches |
| Volkihar Soundscape Overhaul | ANV_Lux - Volkihar… | **Unconfirmed** | ANV synthesis patch — drop with Lux; verify castle audio/lighting in-game |
| Ivy - Whiterun Well Overhaul | Ivy… Lux Orbis Patch (FOMOD) | **Unconfirmed** | Bundled Orbis patch for well lantern; well mesh stays, Orbis light edits revert |
| Ivy - Riverwood Smelter Addon | Ivy… Lux Orbis Patch (FOMOD) | **Unconfirmed** | Same as above |
| Daedric Shrines - Meridia / Mandragora | Orbis Meridia Shrine | **Unconfirmed** | Shrine statue mesh; Meridia Luxon Beacon Replacer notes Orbis compat — no MLO2 note |
| Northern Marsh Bridges | Orbis Northern Marsh | **Unconfirmed** | Bridge mesh; Via/Orbis lantern alignment lost |
| SB - Fixed Windhelm Entrance | ANV_Lux Orbis - SB Windhelm | **Unconfirmed** | Custom ANV patch — drop with Lux |
| Riften sconce patch (Orbis hub) | Lux Orbis - Riften Sconce | **Unconfirmed** | Plugin in load order; source mod is Orbis patch hub |
| Blended Roads (+ Redone/Less Bumpiness) | Lux Via bridge texture sets | **Unconfirmed** | Via bridge meshes/textures removed with Via — roads revert unless kept separate |
| HPP Firewood Snow (ANV) | ANV_Lux Via - HPP | **Patchless-by-design** | Drop ANV patch; HPP meshes unaffected |
| Nordic Stonewalls - Version 2 | Lux Via BOS patch (FOMOD) | **Unconfirmed** | Installed Via patch via FOMOD; stonewall meshes remain |
| Spaghetti's Cities - AIO | via Ivy Well FOMOD patch | **Unconfirmed** | Only Ivy well patch installed for Spaghetti's AIO |
| CS Light | Lux JSON configs (FOMOD) | **Needs reconfig** | Reinstall FOMOD → **Vanilla** (or MLO2-appropriate) configs; remove `Lux CS Light - *.json` |
| Meridia's Luxon Beacon Replacer | (none — design note only) | **Compatible-as-is** | Shrine page cites Orbis compat; no Lux plugin required |

### Lux suite options (not separate content mods)

| Item | Action on migration |
|---|---|
| Actually Brighter Lux Templates / Brighter nights / Even Brighter | **Remove** with Lux |
| Lux - No grass in caves (+ ANV W4ENB variant) | **Remove** — revisit cave grass separately if desired |
| Lux master ESMs + Resources + Via core | **Remove all** |

### Installed mods with Lux patch **available but not active**

| Mod | Evidence | MLO2 note |
|---|---|---|
| Windhelm Objects SMIMed | FOMOD `hasPatchFor:Lux Orbis.esp`, not installed | Patchless-by-design if meshes unchanged |
| High Hrothgar Fixed | Nexus hosts Orbis patch (per community patch collections) | Unconfirmed — mesh replacer may need visual check |
| Riften Canals Rounded | Mod page: "override Lux" | Patchless-by-design (mesh-only) |

### Broader list context (not individually patched in Anvil)

Lux Patch Hub FOMOD detects **hundreds** of Nexus mods (JK's, Spaghetti's, CC,
dungeons, player homes). Anvil's **Spaghetti's AIO town/city suite**, **Praedy**
dungeons, **3DNPC**, etc. are in the modlist but do **not** have separate Lux
patch plugins enabled beyond what the hub FOMOD installed into `Lux*.esp` /
patch-hub ESPs. Under MLO2 those locations revert to **vanilla + mod mesh** lighting
unless individually verified in-game.

---

## MLO2 native integration — documented list vs Anvil

MLO2 (and MLO v1 changelog) documents auto-detection / patch-hub support for mesh
families. Cross-check against **`Anvil - Main Profile` modlist.txt**:

| MLO2 integration target | In Anvil? | Notes |
|---|---|---|
| **Base Object Swapper** | **Yes** (996) | Hard requirement |
| **Embers XD** (+ Inferno/HD/FTS/Torch Edit variants) | **Yes** — full stack | Primary native pairing |
| **Swaps of Skyrim** (candles/lanterns/dwemer BOS) | **Yes** | |
| **SMIM** | **Yes** | |
| **Particle Patch** | **Yes** | Compatible with CS (inactive pp_black by default) |
| **Sconces of Solitude** | **Yes** | |
| **CC Fishing** | **Yes** | |
| **Skeleton Replacer HD** (+ PatchCollection) | **Yes** | MLO patch hub meshes for rudified candles |
| **FYX Campfire Reacts to Wind** (EmbersXD) | **Yes** | |
| **Fire Them Sparks - Embers XD** | **Yes** | |
| **EmbersXD Torch Edit** | **Yes** | |
| **Rudy HQ Miscellaneous / Silverware** | **Partial** — Misc + Silverware + PBR patches | Patch hub STAC/rudy patches exist |
| **JS Shrines / Horn Candles** | **Yes** | Hub patches for horn candles + shrines |
| **Campfire (Complete Camping System)** | **No** | |
| **Beyond Skyrim - Bruma** | **No** | |
| **ELFX / ELFX Shadows** | **No** | |
| **Lantern of Skyrim II** | **No** | |
| **Showers in Inns SSE** | **No** | |
| **Diverse Campfires / Smoking Torches** | **No** | |
| **High Poly Torch Sconce** | **No** | |
| **Window Shadows Ultimate** | **No** | **Major gap** — MLO2 docs + community guides treat WSU as primary window-light partner |
| **Lux / Lux Orbis / Lux Via** | **Yes (to be removed)** | MLO2 detects Lux **when present**; irrelevant after removal |
| **Light Limit Fix** (standalone) | Disabled folder | Core-merged in CS 1.7.3 — correct for Anvil |
| **Community Shaders** | **Yes 1.7.3** | Required path for this list |

**Optional MLO2 addons (not installed):** [Dark Crypts 145789](https://www.nexusmods.com/skyrimspecialedition/mods/145789) (extinguish dungeon candles — philosophy choice), MLO Patch Hub 141249 (BOS mesh swaps for mods **not** in native list).

---

## Community Shaders interaction (task-0017)

Post–task-0017 Anvil CS state is **CS 1.7.3** with core-merged LLF/Terrain Shadows/
Water Effects/etc. disabled as separate plugins.

| CS feature | Lux migration impact |
|---|---|
| **Sky Sync** (core, enabled in Anvil settings) | **Keep — no change** | Independent of Lux; replaces EVLaS sky coupling |
| **Wetness Effects 3.1.0** | **Keep — optional retune** | Lux no longer sets interior ambient baseline; wetness on skin/armor may read differently outdoors — re-tune in CS menu after migration |
| **Splashes of Storms 1.3.1** | **Keep** | task-0017 kept it for optional overlap with Lux/Wetness **rain surface look**, not Lux lighting. Removing Lux **does not** make Splashes redundant — it adds rain splash particles distinct from Wetness shader. Re-tune intensity if outdoor scenes feel busier without Lux Orbis exterior grading |
| **Skylighting / Cloud Shadows 1.4.0** | **Keep — optional retune** | Paired with NAT.CS; not Lux-dependent |
| **CS Light 1.5.1 (Lux profile)** | **Must change** | FOMOD installed **Lux** JSON set (`Lux CS Light - *.json`). Reinstall **Vanilla** configs or manually remove Lux JSONs to avoid double-stacked point lights with MLO2 |
| **NAT.CS III 1.5.0** | **Keep** | Drop `Lux - NAT ENB.esp`; verify weather/interior balance with MLO2 `colorConsistency` (ini) |
| **SSGI 4.2.0** | **Keep — watch interiors** | Interior bounce may expose darker vanilla cells once Lux cell lighting removed |

**Summary:** No CS submod should be **removed** solely because Lux is dropped.
**Splashes of Storms stays.** Plan for **CS Light reconfig** + post-migration
Wetness/Skylighting/SSGI menu pass.

---

## ENB / weather — NAT.ENB III + NAT.CS III

Anvil runs **NAT.ENB III** weather plugin + **NAT.CS III** (CS integration), **not**
a live ENB preset at runtime.

| Item | Current Lux role | MLO2 migration |
|---|---|---|
| `Lux - NAT ENB.esp` | Lux author's NAT-interior tuning | **Remove** — no MLO2 equivalent ESP |
| NAT.CS III | Weather + CS feature bridge | **Keep** — primary weather authority |
| INFUSED / community NAT+MLO2 guidance | External presets recommend MLO2 with `colorConsistency=false` for dark interiors | Adopt as **starting ini tuning** for Anvil CS path; verify in-game |
| Water for ENB + Lux W4ENB patches | Lux cell compatibility for water interiors | Keep **Water for ENB** mod; drop Lux patches; spot-check underwater/interior water cells |
| Lux Via exterior grading | Orbis/Via ENB-ish exterior lantern color | **Gone with Via/Orbis** — exteriors revert; MLO2 unifies **point** source color only |

**Pairing implication:** NAT + MLO2 is a **supported community stack** (see e.g.
[INFUSED ENB II for NAT 147911](https://www.nexusmods.com/skyrimspecialedition/mods/147911)
MLO2 recommendations). Anvil's CS variant needs **manual** validation — no Lux
author-maintained NAT.CS+MLO2 patch exists.

---

## MLO2 maturity and stability

| Factor | Assessment |
|---|---|
| **Age vs Lux** | MLO2 is **newer** (Nexus 160748; active development into 2026 per community mirrors) vs Lux suite matured over years |
| **Design** | Patchless SKSE + BOS — smaller ESP surface than Lux, but **mesh conflict sensitivity** (must win swaps) |
| **MLO v1 → MLO2** | MLO1 (132920) obsolete; old **Lux tweak patch 140886 hidden**; patch hub 141249 still serves BOS mesh add-ons |
| **Reported issues** | Community reports: interiors **too dark** without WSU/ambient partner; **orange glow on extinguished fires** (Dark Crypts 2.0 changelog fix class); **lights not applying** if MLO2 loses mesh conflicts; ESLifier/GitHub [issue #135](https://github.com/MaskPlague/ESLifier/issues/135) shows `MLO.ini` whitelist model (Lux/WSU/ELFX entries) |
| **CS version folklore** | Some older forum posts claim CS ≥1.4 dropped particle lights — **does not apply to MLO2's model on CS 1.7.3** per current MLO2 intent; still verify on first launch |
| **VR** | MLO2 claims VR support — not relevant to this desktop Anvil profile |

**Recommendation:** Treat MLO2 as **production-usable but younger** — budget
extended in-game QA (interiors, Embers-heavy scenes, Spaghetti's cities, dungeons)
before calling migration complete.

---

## Recommended migration step order

### Phase 0 — Human sign-off (mandatory)

Confirm **bold Lux removal** understanding:

- Interiors lose Lux hand-placed bulbs/templates (darker vanilla cells unless WSU/other added).
- Exteriors lose Orbis rework + Via road lanterns.
- **22** patch relationships and **CS Light Lux profile** must be unwound.
- No execution task until explicit approval (same bar as Pandora).

### Phase 1 — Pre-flight (research → execution task)

1. Snapshot `modlist.txt`, `plugins.txt`, `loadorder.txt` (git or export).
2. Decide optional adds: **Window Shadows Ultimate?** **Dark Crypts?** **Ambient template mod?**
3. Download latest **MLO2 160748** + review FOMOD options / `MLO.ini` defaults.
4. Read MLO2 `colorConsistency`, `disableShadowCasters`, RGB tuning for NAT.CS look.

### Phase 2 — Remove Lux suite

1. **Disable** all 7 Lux-related MO2 mods (+ `Lighting_separator` if empty).
2. **Disable/remove plugins:** all 35 Lux-named ESPs/ESMs (verify **0 missing masters**).
3. Remove or disable **ANV_** Lux synthesis patches if regenerated later without Lux.
4. Clear any Lux BSA archives from profile if MO2 leaves stale entries.

### Phase 3 — CS Light + CS tuning

1. **Reinstall CS Light** FOMOD → select **Vanilla** main configs (not Lux).
2. Delete leftover `Lux CS Light - *.json` from CS Light mod folder if FOMOD doesn't.
3. Document pre-migration CS menu sliders for Wetness / Skylighting / SSGI to compare.

### Phase 4 — Install MLO2

1. Install **MLO2** after **Base Object Swapper**, **Embers XD** stack, **SMIM**, **Swaps of Skyrim**.
2. Place MLO2 **low in modlist** (above DynDOLOD/Occlusion/ParallaxGen outputs only).
3. Install **MLO Patch Hub 141249** meshes only if needed for JS Shrines / Horn Candles / Skeleton HD rudification (evaluate FOMOD vs native detection).
4. Configure `SKSE/Plugins/MLO.ini` — start with community NAT+MLO2 guidance (`colorConsistency=false` if interiors too uniform).

### Phase 5 — Verification pass

1. Launch → CS Feature Issues tab clean.
2. Spot-test matrix: Whiterun inn, Riften, Embers-heavy forge, Meridia shrine, Volkihar,
   CC Fishing location, Ivy well, Northern Marsh bridge, dungeon (vanilla + modded).
3. Re-tune CS Wetness / Skylighting / SSGI / Splashes if needed.
4. Log outcome in `decisions.md` + `changelog.md`.

### Phase 6 — Cleanup

1. Optionally uninstall Lux mod folders from MO2 (archive first).
2. Update version-check report.
3. Remove obsolete Lux plugin groups from `plugingroups.txt`.

---

## Risk register

| Risk | Severity | Mitigation |
|---|---|---|
| **Loss of Lux/Orbis/Via curated lighting** — interiors/exteriors/roads visually flatter or darker | **High** | Sign-off; consider WSU + ambient template; extended QA |
| **CS Light Lux JSON double-stacking with MLO2** | **High** | Reinstall CS Light Vanilla profile before first MLO2 launch |
| **MLO2 mesh conflict losses** — BOS swaps don't win vs SMIM/Embers/custom city meshes | **High** | Low modlist placement; test Embers + Spaghetti's + Ivy locations |
| **NAT interior balance without `Lux - NAT ENB.esp`** | **Medium** | Tune MLO2.ini + NAT.CS; compare INFUSED/community presets |
| **Unconfirmed modded locations** (22 patch former-deps) | **Medium** | Structured spot-test list; file houseCARL tasks only if record fixes needed |
| **Lux Via road lantern removal** — night travel visibility | **Medium** | Accept or add alternative road lighting mod (strategic choice) |
| **MLO2 youth / bug reports** (dark dungeons, orange glow) | **Medium** | Read latest MLO2 changelog; keep Lux folders archived until QA passes |
| **Plugin count / LOOT** — 35 plugins removed | **Low** | Refresh LOOT; verify 0 missing masters |
| **Synthesis ANV patches referencing Lux** | **Low** | Regenerate or disable ANV_Lux* patches on next Synthesis run |

---

## Do-not-execute-without-signoff

This migration is a **deliberate visual philosophy shift** affecting the entire list
(equivalent scope to Nemesis→Pandora). **Do not** install, remove, or disable Lux/MLO2
mods from this plan until the user explicitly approves an execution task.

Per `AGENTS.md`, execution follow-up should be a **separate queued task** after sign-off
(not created automatically from this research task).

---

## Follow-up execution task (not created)

After human approval, create **`task-0020`** (or next ID) assigned to **cursor** —
MO2 folder/plugin work, CS Light FOMOD rerun, MLO2 install, no houseCARL unless
spot-fixes require record edits.
