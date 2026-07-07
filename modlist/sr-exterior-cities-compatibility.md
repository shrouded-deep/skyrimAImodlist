# SR Exterior Cities — compatibility research (task-0020)

Research-only scoping for open-cities frameworks on the Anvil successor list. **Human sign-off (2026-07-07): defer both [SR Exterior Cities](https://www.nexusmods.com/skyrimspecialedition/mods/87954) and [Open Cities Skyrim](https://www.nexusmods.com/skyrimspecialedition/mods/87707).** No install, no execution task. Recorded in [`decisions.md`](decisions.md).

Supporting tools:
- [SR Exterior Cities — Synthesis Patcher](https://www.nexusmods.com/skyrimspecialedition/mods/89066) (J3W3LS)
- [SR Exterior Cities Series Official Patch HUB 2.0](https://www.nexusmods.com/skyrimspecialedition/mods/88072)
- [Patching guide](https://www.nexusmods.com/skyrimspecialedition/mods/88430)
- DynDOLOD note: [Open Exterior Cities](https://dyndolod.info/Mods/Open-Exterior-Cities)

---

## Mod scope (confirmed)

**All five hold capitals** are moved from interior worldspaces into **Tamriel** as open exteriors:

| City | Interior worldspace (vanilla) | Notes |
|---|---|---|
| Whiterun | `WhiterunWorld` | Wall collision/landscape tweaks at gates; Whiterun Trees patch (121100) recommended with Spaghetti |
| Windhelm | `WindhelmWorld` | Dock/gate navmesh fixes in 2.0 changelog |
| Solitude | `SolitudeWorld` | Landscape meshes, LOD `.bto`, NPC fall-death fixes |
| Markarth | `MarkarthWorld` | Plane marker / CTD hotfixes in changelog |
| Riften | `RiftenWorld` | Canal navmesh, dock gate, exterior lake connection |

**Requires new game** (hard requirement per mod page). Not Open Cities — built from scratch.

**Compatible in principle:** exterior city mesh/texture overhauls, small landscape edits at gates, follower mods using interior house cells, most occlusion add-ons (watch gate overlap).

**Incompatible without patching:** anything editing **interior city worldspaces** (objects, navmesh, lighting tied to interior cells). Anything changing Tamriel placement near cities needs a patch.

---

## Synthesis patcher — what it fixes automatically

Source: Nexus 89066 + [GitHub SR-Exterior-Cities-Patcher](https://github.com/TheOneAndOnlyJ3w3ls/SR-Exterior-Cities-Patcher)

| Automatic (default settings) | Manual / CK required |
|---|---|
| Moves **REFR**, statics, and non-navmesh records from interior city worldspaces → correct Tamriel cells per SREX | Mods with **navmesh (NAVM) edits** in interior city worldspaces |
| Single unified output patch (not 255-plugin limited like zEdit workflows) | **NAVI** (Navigation Info Map) — **only CK can generate** on save |
| Replaces many per-mod patches for **object-only** conflicts | Patch makers may use Synthesis **“Enable navmesh modification”** to *prepare* navmeshes, then **finalize in CK** |
| | Capital / JK-scale mods may leave Tamriel clipping — manual CK cleanup per J3W3LS article |

**User’s navmesh concern is valid:** Synthesis alone is **not sufficient** for navmesh-heavy city edits. Expect **Creation Kit** work (or hub navmesh patches where provided) for high-touch mods.

**Other commonly cited gaps (not fully automatic):**

- Quest markers / packages still pointing at interior worldspace refs (author fixed some, e.g. Vilkas Whiterun package in 2.0 changelog)
- NPC schedules / linked references in interior cells — interior-only follower homes OK; city-bound AI may need verification
- Exterior **lighting** placed for interior cells — Lux Orbis/Via hub patches exist; MLO2 is interior-only (less direct overlap)
- **DynDOLOD / distant LOD / occlusion** — geometry change → full DynDOLOD + Occlusion regen (see below)

---

## Anvil list — city-touching mods (cross-reference)

Profile: `Anvil - Main Profile` · research date 2026-07-07 · Lux Orbis **disabled**, Lux Via **enabled**, MLO2 **enabled**.

### High priority — navmesh / worldspace overlap likely

| Mod (MO2 folder) | Cities | Navmesh risk | Hub / Synthesis | Notes |
|---|---|---|---|---|
| **Spaghetti's Cities — AIO** (+ Clutter, NavCuts) | All five | **High** — NavCut addons explicit | **Hub:** Spaghetti patches (88072 v1.3+) | Core exterior conflict; hub + Synthesis AIO patch expected |
| **Spaghetti's Palaces — AIO** (+ NavCuts) | All five palace interiors | **High** | **Hub:** Spaghetti suite | **Active plugins** — interior palace cells SREX externalizes |
| **Spaghetti's Faction Halls — AIO** (+ NavCuts) | Whiterun, Riften, Solitude, etc. | **High** | **Hub:** Spaghetti suite | **Active plugins** — Jorrvaskr / TG / Bard College–type halls |
| **Spaghetti's Towns / Orc Strongholds / Solstheim AIO** (+ NavCuts) | Towns / Orc / Solstheim | Medium–High | Hub (Spaghetti) | Lower priority than capitals but NavCut pattern same |
| **Spaghetti's Mods — NavCut Addon** | Cities | **High** | Via Spaghetti hub | Navmesh/cutting |
| **SB — Fixed Windhelm Entrance** | Windhelm | **Medium–High** | Was **ANV_Lux Orbis — SB Windhelm** (disabled); check hub for non-Lux SREX patch | Active: `SB_WindhelmEntrance.esp` |
| **Vanilla Plus City Entrances** | Gates | Medium | Unknown — verify hub | Active plugin |
| **Ivy — Whiterun Well Overhaul** (+ Normal Lantern, Spaghetti patch, USSEP) | Whiterun | Medium | Ivy/Lux patches in hub history; **Lux Orbis Ivy patch disabled** | Mesh + possible nav touch near well |
| **Ivy — Riverwood Smelter Addon** | (Riverwood, not capital) | Low for SREX | N/A | Orbis patch disabled |
| **FYX — Windhelm Graveyard** (+ Spaghetti patch) | Windhelm | Medium | Verify hub | Active |
| **FYX — Riften Canal and Round Posts** | Riften | Low–Medium | Verify hub | Active |
| **Navigator — Navmesh Fixes** (`Navigator-NavFixes.esl`) | Global (all capitals) | **High** | **Not in hub** | Broad navmesh edits — **not covered by J3W3LS object-only Synthesis**; needs xEdit/CK review |
| **Skyrim Road Reconstruction Project** | City road networks | Medium | Not in hub | Road ESL — verify Tamriel overlap |
| **Thalmor Embassy mesh fixes** (`ThalmorRefrs.esp`) | Solitude embassy | Medium | Not in hub | Active exterior embassy cells |

### Exterior mesh / PBR / clutter (lower navmesh risk — hub or Synthesis often enough)

| Mod | Cities | Navmesh risk | Hub / Synthesis | Notes |
|---|---|---|---|---|
| **Tomato's / Faultier's PBR** (Whiterun, Solitude, Markarth) | 3 | Low | Blubbo-style patches in hub for other packs; verify Tomato/Faultier | Texture/mesh swaps |
| **Ancient AF Windhelm** (+ PBR, Windhelm Retextured) | Windhelm | Low | Verify | |
| **Riverbord's Riften Revival**, **Riften of Reverie**, **Riften Canals Rounded** | Riften | Low–Medium | **Ultimate Riften — Dawn of JK's** optional in hub | |
| **ALT — Markarth's Forge**, **Markarth Fixed AF**, **Markarth Exterior 01 River Water Fix** | Markarth | Low | | |
| **Solitude** mesh fixes (Objects SMIMed, Arch, Empty Landscape, Stones, Braziers, etc.) | Solitude | Low | | |
| **Whiterun** mesh fixes (Objects SMIMed, Fence Seam, Wall Rubble, HFs Shields) | Whiterun | Low | | |
| **Lux Via** + patch hub (Blended Roads, Wooden Bridges, etc.) | Roads / gates | Medium at **hold borders & bridges** | **Hub: Lux Via patch remade 2.0** | Via **enabled** — use hub Via patch, not disabled Orbis |
| **Lux Orbis** + hub | City exteriors | Medium (lighting refs) | **Hub: Orbis patches remade** | **Disabled** on this list — re-evaluate if Orbis returns |
| **Water for ENB** (+ Shades, landscape patches) | Water cells | Low–Medium | **Hub: W4ENB patches remade 1.3+** | Tamriel water/worldspace records |
| **MLO2** | Interiors | **Low direct** | N/A | Interior lighting; city *interiors* less relevant once exteriors move |
| **Pandora / animation** | Indirect | Low for placement | N/A | Behavior; not primary SREX conflict type |

### Plugins still active that reference disabled Lux Orbis (SREX irrelevant until Orbis re-enabled)

- `Ivy - Whiterun - Well Overhaul - Normal Lantern - Lux Orbis Patch.esp` — **disabled**
- `Lux Orbis - Riften Sconce Patch.esp` — **disabled**
- `ANV_Lux Orbis - SB Windhelm Entrance.esp` — **disabled**

---

## Toolchain interaction

| Tool | SREX impact |
|---|---|
| **DynDOLOD + Occlusion** | **Mandatory regen** after SREX install — see [DynDOLOD Open Exterior Cities](https://dyndolod.info/Mods/Open-Exterior-Cities). Current list has **`DynDOLOD.esp` / `Occlusion.esp` disabled** (stale Lux bake; task-0025 deferred). **Sequence SREX install → Tier 2 regen** in one maintenance window. |
| **ParallaxGen** | Regen after major mesh/landscape changes near cities |
| **Synthesis (Anvil `ANV_Syn*`)** | Separate from J3W3LS SREX patcher; run SREX Synthesis patch **after** load order includes SREX + hub patches |
| **J3W3LS SREX Synthesis patcher** | List-wide object move patch; navmesh mods need CK follow-up |

---

## Sequencing vs MLO2 / Pandora / current work

| When | Rationale |
|---|---|
| **After** MLO2 + Lux Via smoke tests (task-0022/0023) | Confirm exterior road + interior baseline before worldspace surgery |
| **After** Pandora smoke test (task-0018) | Behavior engine stable; unrelated but avoids debugging multiple overhauls at once |
| **Before / bundled with Tier 2** DynDOLOD · PG · Synthesis regen | ~~SREX changes worldspace → regen would be wasted if done first~~ **Deferred (2026-07-07):** Tier 2 regen no longer tied to open cities |
| **Not parallel with** heavy load-order churn | Author recommends new game; plan as a **major milestone**, not incremental tweak |

**Pandora vs SREX navmesh:** Pandora affects behavior graphs, not city NAVM/NAVI. SREX navmesh work is **CK / hub patch / J3W3LS Synthesis prep** — orthogonal to Pandora migration.

---

## What Synthesis fixes vs what needs manual / houseCARL verification

### Synthesis (J3W3LS) — automatic

- Object-only mods across the load order (no interior-city NAVM)
- Unified patch replacing many single-mod patches for REFR/static moves

### Manual / CK / hub patches

- **Spaghetti's** full stack (**Cities + Palaces + Faction Halls** NavCuts — all **active** in profile)
- **Navigator — Navmesh Fixes** — global NAVM; no hub patch; high houseCARL verification risk
- **SB Windhelm Entrance**, **Vanilla Plus City Entrances**, **Ivy Whiterun well**
- Any mod flagged with NAVM in interior city worldspaces after xEdit filter
- Gate occlusion plane overlap (author documents rare “acid trip” disappearing objects — CK disable/fix)

### houseCARL likely in execution phase

Task-0020 does **not** create an execution task. If sign-off proceeds, expect **`requires_housecarl: true`** follow-up for:

- Record-level verification where hub lacks patches (Tomato/Faultier PBR packs, FYX, ANV xEdit patches)
- Conflict tree inspection for quest/NPC packages tied to interior city cells
- Validating Synthesis output vs hub patches (no double patches, correct load order)

---

## SREX maintenance status & list-fit verdict

Research date for this section: **2026-07-07**. SREX is the **compatibility multiplier** on Anvil — not the choice of city overhaul alone. Any heavy city stack becomes a worldspace-migration + navmesh + patch-coverage project once SREX is added.

### Update cadence (Nexus + tooling)

| Component | Last Nexus update | Version | Verdict |
|---|---|---|---|
| [SREX 2.0 core](https://www.nexusmods.com/skyrimspecialedition/mods/87954) | **15 Oct 2024** | 2.1.5 | Maintenance-only since late 2024 (Blue Palace landscape, GDOS doors). **No 2025–2026 releases.** |
| [Patch Hub 2.0](https://www.nexusmods.com/skyrimspecialedition/mods/88072) | **18 Sep 2024** | 2.0.0.52 | Authors still label FOMOD **“beta and WIP.”** |
| [J3W3LS Synthesis patcher](https://www.nexusmods.com/skyrimspecialedition/mods/89066) | **12 Apr 2023** | 1.0.0 | Nexus file **frozen**; [GitHub repo](https://github.com/TheOneAndOnlyJ3w3ls/SR-Exterior-Cities-Patcher) had commits **Feb 2026** (tooling, not a new Nexus release). |

Hub description (paraphrased): maintainers burn out, **no patch requests**, community submissions welcome — “meant to get things rolling.” Changelog still notes **JK interior patches not all ready**, navmesh patches **disabled/remade**, auto-recognition **incomplete** for newer patches.

### Structural limits (not fixable by faster updates)

- Interior-city **NAVM + NAVI** still requires **Creation Kit** finalization; J3W3LS Synthesis can *prepare* navmeshes but cannot fully automate them.
- **New game** required per SREX author (hard requirement).
- Ecosystem moves faster than hub coverage: Spaghetti suite updates, Lux/MLO2 churn, Navigator, PBR/FYX/Ivy layers, DynDOLOD/Occlusion — hub requirements table is a **2023–2024 snapshot**, not a living matrix for this list.

### List-fit verdict for Anvil

| Factor | Assessment |
|---|---|
| **Maintenance vs list velocity** | **Poor fit** — list still actively curated; SREX is in community-patch / maintenance mode. |
| **Spaghetti full stack** | Hub covers Cities AIO; **Palaces / Faction Halls / NavCuts** remain high CK risk; not hub-complete for Anvil as-is. |
| **Navigator — Navmesh Fixes** | **Not in hub** — list-specific gap regardless of city overhaul choice. |
| **DynDOLOD / Occlusion** | Mandatory regen; currently deferred (task-0025). SREX should only land in that Tier-2 window. |
| **Strategic recommendation** | **Defer SREX** until willing to accept list-specific CK/houseCARL work *and* a new-game milestone. Swapping city overhauls does **not** remove this tax — it only changes which stale patches you chase. |

**Bottom line:** SREX is viable for static, hub-covered load orders. Anvil is not that profile today.

---

## Alternative: Open Cities Skyrim — is it better maintained?

[Open Cities Skyrim](https://www.nexusmods.com/skyrimspecialedition/mods/87707) (OCS, Arthmoor) pursues the same player goal (walk into cities without loading screens) via a **different, older architecture**. For **maintenance and ecosystem depth**, OCS is clearly ahead of SREX.

### Maintenance comparison

| | SREX (1990SRider) | OCS (Arthmoor) |
|---|---|---|
| **Last core update** | Oct 2024 | **27 Feb 2026** (v3.2.3) |
| **Update pattern** | Sporadic bugfixes post-2.0 | Regular USSEP parity, quest fixes, navmesh sync |
| **Endorsements** | ~713 (87954) | ~4,300+ (87707) |
| **Patch ecosystem** | Single WIP hub; no requests; incomplete auto-detect | Built-in patch archive, **LOOT** rules, large third-party patch network |
| **Active patch authors** | Hub team (burnout noted) | Jonado ([84822](https://www.nexusmods.com/skyrimspecialedition/mods/84822) updated **Jun 2025**), RedBag OCS collection, Capital OCS ports, Blubbos OCS patches, etc. |
| **Author tooling** | J3W3LS Synthesis patcher (Nexus stale) | [Hishy converter script](https://www.nexusmods.com/skyrimspecialedition/mods/87707) for mod authors; documented compatibility tiers |

**Yes — Open Cities is materially better maintained** as a framework: active core author, frequent USSEP-driven fixes, mature LOOT integration, and a broader living patch ecosystem.

### Technical approach (why “better maintained” ≠ “easier on Anvil”)

| | SREX | OCS |
|---|---|---|
| **Worldspace model** | Moves city exteriors into Tamriel; **interior city worldspaces largely removed** | Dual model: open Tamriel cells **plus retained closed interior worldspaces** (AI doors for edge cases) |
| **Civil War** | Built with CW quest compatibility as a design focus | **Battles still in closed worldspaces** — load-door transitions during sieges ([documented known issue](https://www.nexusmods.com/skyrimspecialedition/mods/87707?tab=docs)) |
| **New game** | **Required** | Not required to install; **mid-game uninstall strongly discouraged** (save permanence) |
| **Mod compatibility rule** | Anything touching interior city worldspaces needs patch | Texture/mesh replacers: **100% OK**; mods adding to closed cities: **generally incompatible** without patch |
| **DynDOLOD** | [Open Exterior Cities](https://dyndolod.info/Mods/Open-Exterior-Cities) guidance applies | Same DynDOLOD regen category — geometry/worldspace change |

OCS is **less invasive** architecturally (closed cells remain), which is partly why its patch ecosystem survived longer. SREX’s full externalization is more ambitious — and more brittle when the hub stalls.

### Anvil-specific OCS fit

**Better than SREX for this list:**

- **Spaghetti's Cities AIO** — additive-only (no vanilla record edits); community [Spaghetti + OCS patch](https://gamer-mods.ru/load/skyrim_se/patchi/patch_spaghetti_cities_aio_open_cities/153-1-0-15810) exists; Spaghetti author documents broad compatibility philosophy.
- **Lux Via / W4ENB / many mesh-only city mods** — OCS has years of gate/road patch precedent.
- **LOOT placement** — documented “load OCS late” rule reduces guesswork vs SREX hub FOMOD roulette.

**Still hard on Anvil (same class of problem as SREX):**

- **Spaghetti Palaces / Faction Halls / NavCut addon** — interior/navmesh-heavy; need OCS-specific patches or CK work, not covered by a single turnkey patch.
- **Navigator — Navmesh Fixes** — global NAVM edits; no standard OCS patch.
- **SB Windhelm Entrance, Ivy well, FYX, city entrance mods** — patch-hunt or custom work either way.
- **Civil War immersion** — OCS is a **regression** vs SREX if seamless siege battles matter.

**Not a free win:** OCS trades SREX’s maintenance stagnation for a **different** cost model — broader patch library, but still per-mod coverage for navmesh-heavy stack pieces. The list’s pain is **open-cities architecture × heavy city stack**, not SREX authorship alone.

### SREX vs OCS — strategic choice for successor list

| If priority is… | Lean toward… |
|---|---|
| Seamless Civil War in open cities | SREX (when/if hub catches up) |
| Active maintenance, LOOT, patch ecosystem | **OCS** |
| Minimal list surgery | **Neither** — defer open cities entirely |
| Spaghetti Cities only (drop NavCuts/Palaces/Faction Halls for milestone) | **OCS** has the clearer path |
| Full Spaghetti suite as-is | **Neither is turnkey**; budget custom patches either way |

---

## Recommendation

**Status: deferred (2026-07-07).** Both SREX and OCS are off the table until the list stabilizes and open cities is explicitly re-scoped as a successor-list goal.

1. **Do not install** SREX or OCS; **no execution task** for either framework.
2. **Tier 2 DynDOLOD/Occlusion regen** (task-0025) is **not** gated on open cities — proceed when the list is ready, without bundling SREX/OCS.
3. **If revisited later:** OCS is the better-maintained track; SREX only worth reconsidering if seamless Civil War in open cities outweighs ecosystem health. Either path still budgets CK/houseCARL for Spaghetti NavCuts, Palaces/Faction Halls, and Navigator.
4. Research in this document remains valid reference material for that future decision.

**Execution task: not created** — deferred by human sign-off.
