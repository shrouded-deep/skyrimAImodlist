# City overhaul stack — compatibility research (2026-07-07)

Research-only pass for **task-0040**. No installs performed.

**Proposed stack:** per-city exterior expansions to replace JK's Skyrim AIO as the city content layer.

**Anvil baseline:** Spaghetti's full suite (Cities / Palaces / Faction Halls / Towns / Orc / Solstheim + NavCut addons), plus city-touching mods listed in task-0040.

**Status key:** `PATCH EXISTS` · `NO PATCH NEEDED` · `NO PATCH — RISK` · `UNKNOWN`

Sources: Nexus mod pages, patch hubs, J3w3ls compatibility article ([7025](https://www.nexusmods.com/skyrimspecialedition/articles/7025)), author compatibility lists. Where Nexus is silent, marked `UNKNOWN` — not assumed compatible.

---

## Spaghetti modular map (for cherry-pick / drop decisions)

Anvil runs **AIO plugins**, not individual city ESPs. You cannot drop one capital from `Spaghetti's Cities - AIO.esp` without either (a) migrating to modular Cities ESPs, or (b) using published patches that disable conflicting Spaghetti objects. NavCut addons mirror the same scope — drop the matching city slice from NavCut when dropping a modular city ESP.

| Hold / settlement | Spaghetti's Cities module | Nexus | Spaghetti's Palaces module | Nexus | Spaghetti's Faction Halls (in hold) | Nexus |
|---|---|---|---|---|---|---|
| **Whiterun** | Spaghetti's Cities — Whiterun | [80778](https://www.nexusmods.com/skyrimspecialedition/mods/80778) | Spaghetti's Palaces — Dragonsreach | [91781](https://www.nexusmods.com/skyrimspecialedition/mods/91781) | Companions (Jorrvaskr) | [96419](https://www.nexusmods.com/skyrimspecialedition/mods/96419) |
| **Windhelm** | Spaghetti's Cities — Windhelm | [82820](https://www.nexusmods.com/skyrimspecialedition/mods/82820) | Spaghetti's Palaces — Palace of the Kings | [93732](https://www.nexusmods.com/skyrimspecialedition/mods/93732) | — (exterior stack) | — |
| **Markarth** | Spaghetti's Cities — Markarth | [81200](https://www.nexusmods.com/skyrimspecialedition/mods/81200) | Spaghetti's Palaces — Understone Keep | [92767](https://www.nexusmods.com/skyrimspecialedition/mods/92767) | — | — |
| **Solitude** | Spaghetti's Cities — Solitude | [80986](https://www.nexusmods.com/skyrimspecialedition/mods/80986) | Spaghetti's Palaces — Blue Palace | [92284](https://www.nexusmods.com/skyrimspecialedition/mods/92284) | Bard's College, Castle Dour (in AIO) | [106054](https://www.nexusmods.com/skyrimspecialedition/mods/106054) AIO |
| **Riften** | Spaghetti's Cities — Riften | [82228](https://www.nexusmods.com/skyrimspecialedition/mods/82228) | Spaghetti's Palaces — Mistveil Keep | [93229](https://www.nexusmods.com/skyrimspecialedition/mods/93229) | Thieves Guild | [97051](https://www.nexusmods.com/skyrimspecialedition/mods/97051) |
| **Riverwood** | Spaghetti's Towns — Riverwood | [85356](https://www.nexusmods.com/skyrimspecialedition/mods/85356) | — | — | — | — |

**AIO umbrella plugins (Anvil active):** Cities [84735](https://www.nexusmods.com/skyrimspecialedition/mods/84735), Palaces [93733](https://www.nexusmods.com/skyrimspecialedition/mods/93733), Faction Halls [106054](https://www.nexusmods.com/skyrimspecialedition/mods/106054), Towns [89775](https://www.nexusmods.com/skyrimspecialedition/mods/89775), Orc [95926](https://www.nexusmods.com/skyrimspecialedition/mods/95926), Solstheim [91263](https://www.nexusmods.com/skyrimspecialedition/mods/91263), NavCut addon [120793](https://www.nexusmods.com/skyrimspecialedition/mods/120793).

**Palaces / Faction Halls vs exterior overhauls:** These edit **interior cells only** (additive clutter). Capital expansions that leave vanilla interiors untouched (CWE, Crossed Daggers, RedBag) → generally **NO PATCH NEEDED** for Palaces/Faction Halls. Ultimate Markarth edits Understone-adjacent exteriors heavily; palace interior clutter may still clip at door thresholds — low risk, in-game QA.

---

## Spaghetti drop / keep summary (by proposed city mod)

| City | Recommendation | Rationale |
|---|---|---|
| **Whiterun (CWE + WHWR)** | **Keep** Spaghetti Whiterun via patches; do **not** drop unless abandoning clutter | [116487](https://www.nexusmods.com/skyrimspecialedition/mods/116487) (CWE×Spaghetti AIO); WHWR Patch Hub patches for Spaghetti Whiterun + AIO ([article 7025](https://www.nexusmods.com/skyrimspecialedition/articles/7025)) |
| **Windhelm (CWE)** | **Keep** + install [Spaghetti's Capital Windhelm Expansion](https://www.nexusmods.com/skyrimspecialedition/mods/154715) | Purpose-built integration; drops/adjusts conflicting Spaghetti objects while re-cluttering |
| **Markarth (UM + UME)** | **Patch first**; drop `Spaghetti's Cities — Markarth` only if clipping persists | UME Patch Hub [155426](https://www.nexusmods.com/skyrimspecialedition/mods/155426) WIP; Medieval Markets includes Spaghetti Markarth patch for Ultimate Markarth |
| **Solitude (RedBag)** | **Keep** + [RedBag Patch Collection](https://www.nexusmods.com/skyrimspecialedition/mods/51450) Spaghetti AIO patch | Documented conflict resolution |
| **Riften (Crossed Daggers)** | **Keep** + author Spaghetti patch (optional files) | Mod page: patch provided for AIO and Riften module |
| **Riverwood (Has Walls)** | **Keep** + [Riverwood Has Walls Patch Collection](https://www.nexusmods.com/skyrimspecialedition/mods/147419) | Spaghetti Towns AIO + Riverwood patches listed |

**If migrating off AIO:** disable modular equivalents above per city; disable matching NavCut slices from `Spaghetti's Mods - NavCut Addon`; keep Palaces/Faction Halls for all holds unless an expansion replaces those interiors (none of the proposed stack do).

---

## Full compatibility matrix

Columns abbreviated: **SC** = Spaghetti's Cities (exterior clutter for that hold) · **SP** = Spaghetti's Palaces · **SFH** = Spaghetti's Faction Halls · **SN** = Spaghetti NavCut addons · **ST** = Spaghetti's Towns/Orc/Solstheim · **SB** = SB Fixed Windhelm Entrance · **VPCE** = Vanilla Plus City Entrances · **Ivy** = Ivy Whiterun Well · **FYX-W** = FYX Windhelm Graveyard · **FYX-R** = FYX Riften Canal · **Nav** = Navigator-NavFixes · **LV** = Lux Via · **LFFGM** = Landscape Fixes for Grass Mods · **AAF** = Ancient AF Windhelm · **SRRP** = Skyrim Road Reconstruction Project

### Capital Whiterun Expansion — [37982](https://www.nexusmods.com/skyrimspecialedition/mods/37982)

| Anvil mod | Status | Notes |
|---|---|---|
| SC (Whiterun) | **PATCH EXISTS** | [116487](https://www.nexusmods.com/skyrimspecialedition/mods/116487) — required on CWE page |
| SP (Dragonsreach) | **NO PATCH NEEDED** | Interior-only; CWE does not replace Dragonsreach layout |
| SFH (Jorrvaskr) | **NO PATCH NEEDED** | Interior-only |
| SN | **UNKNOWN** | NavCut may slice Whiterun gates post-expansion; no CWE-specific NavCut patch found |
| ST / Orc / Solst | **NO PATCH NEEDED** | No Riverwood/orc overlap |
| SB | **NO PATCH NEEDED** | Windhelm-only |
| VPCE | **NO PATCH — RISK** | No documented VPCE×CWE patch; VPCE author: compatible unless same area heavily edited — CWE edits Whiterun exterior/gates |
| Ivy Well | **PATCH EXISTS** | Ivy FOMOD includes Capital Whiterun patch ([125955](https://www.nexusmods.com/skyrimspecialedition/mods/125955)) |
| FYX-W / FYX-R | **NO PATCH NEEDED** | Other holds |
| Nav | **NO PATCH — RISK** | CWE edits Whiterun navmesh; Navigator edits Whiterun cells — no documented joint patch |
| LV | **PATCH EXISTS** | Lux Patch Hub lists Capital Whiterun; Ultimate Whiterun patch collection confirms Lux Via exterior patch path |
| LFFGM | **UNKNOWN** | Open Capital Whiterun patch chain mentions LFFGM; standard CWE path unclear |
| AAF / SRRP | **NO PATCH NEEDED** / **UNKNOWN** | Windhelm-only / road ESL may touch Whiterun approach cells |

**Mandatory companions:** [Rob's Bug Fixes — CWE](https://www.nexusmods.com/skyrimspecialedition/mods/63355) (CWE 1.5+).

---

### Whiterun Has Walls Redone — [119229](https://www.nexusmods.com/skyrimspecialedition/mods/119229)

| Anvil mod | Status | Notes |
|---|---|---|
| SC (Whiterun) | **PATCH EXISTS** | WHWR Patch Hub + [article 7025](https://www.nexusmods.com/skyrimspecialedition/articles/7025): Spaghetti Whiterun + AIO patches ("very minor") |
| SP / SFH | **NO PATCH NEEDED** | Interiors |
| SN | **UNKNOWN** | WHWR uses navcut walls; interaction with Spaghetti NavCut unlisted |
| ST / Orc / Solst | **NO PATCH NEEDED** | — |
| SB | **NO PATCH NEEDED** | — |
| VPCE | **NO PATCH — RISK** | No WHWR×VPCE patch in hub or article 7025 |
| Ivy Well | **UNKNOWN** | Ivy documents CWE patch only; no WHWR-specific Ivy patch found |
| FYX-W / FYX-R | **NO PATCH NEEDED** | — |
| Nav | **NO PATCH — RISK** | WHWR article lists navmesh patches for CWE/JK/Ryn combos — not Navigator |
| LV | **PATCH EXISTS** | Article 7025: JK Outskirts + Lux Via patch in WHWR hub; direct WHWR+Lux Via not explicitly named — treat gate lighting as **UNKNOWN** until hub FOMOD checked at install |
| LFFGM | **UNKNOWN** | — |
| AAF / SRRP | **NO PATCH NEEDED** / **UNKNOWN** | — |

**CWE + WHWR together:** requires WHWR hub Capital patch + [PseudoLoadDoors CWE×WHWR](https://www.nexusmods.com/skyrimspecialedition/mods/140034). **Do not install WHWR FOMOD occlusion patch** (Ultimate Whiterun docs: crash risk).

---

### Capital Windhelm Expansion — [42990](https://www.nexusmods.com/skyrimspecialedition/mods/42990)

| Anvil mod | Status | Notes |
|---|---|---|
| SC (Windhelm) | **PATCH EXISTS** | [Spaghetti's Capital Windhelm Expansion](https://www.nexusmods.com/skyrimspecialedition/mods/154715) — integration patch for AIO or Windhelm module |
| SP (Palace of Kings) | **NO PATCH NEEDED** | Interior clutter; CWE expands exterior |
| SFH | **NO PATCH NEEDED** | — |
| SN | **NO PATCH — RISK** | CWE rewrites bridge/harbour navmesh; NavCut + Navigator stacking unverified |
| ST / Orc / Solst | **NO PATCH NEEDED** | — |
| SB | **PATCH EXISTS** | SB FOMOD includes Capital Windhelm variant ([73058](https://www.nexusmods.com/skyrimspecialedition/mods/73058)) |
| VPCE | **NO PATCH — RISK** | Anvil uses **Vanilla Plus** entrances, not City Entrances Overhaul. CWE has CEO patch [47186](https://www.nexusmods.com/skyrimspecialedition/mods/47186) — **does not apply to VPCE**. VPCE author: no patches planned |
| Ivy | **NO PATCH NEEDED** | Whiterun-only |
| FYX-W | **UNKNOWN** | Anvil uses FYX Graveyard + Spaghetti patch; CWE page silent on FYX; 154715 lists other Windhelm mesh mods, not FYX |
| FYX-R | **NO PATCH NEEDED** | — |
| Nav | **NO PATCH — RISK** | CWE author: navmesh edits likely need patches; none for Navigator |
| LV | **PATCH EXISTS** | Lux Patch Hub includes Capital Windhelm (Lux master page compatibility list) |
| LFFGM | **UNKNOWN** | — |
| AAF | **NO PATCH NEEDED** | 154715 lists Ancient AF Windhelm Complex Material as compatible; texture/mesh layer |
| SRRP | **UNKNOWN** | Road ESL + expanded harbour approach — verify in-game |

**Note:** Rob's Bug Fixes for CWE×CEO exists — irrelevant if staying on VPCE; gate-area QA required.

---

### Ultimate Markarth — [66024](https://www.nexusmods.com/skyrimspecialedition/mods/66024)

Prerequisite for Ultimate Markarth Expanded. Use **both** for the proposed Markarth stack.

| Anvil mod | Status | Notes |
|---|---|---|
| SC (Markarth) | **PATCH EXISTS** (partial) | Medieval Markets Patches [161664](https://www.nexusmods.com/skyrimspecialedition/mods/161664) includes Spaghetti Markarth + Ultimate Markarth; no author-native UM×Spaghetti patch on UM page |
| SP (Understone Keep) | **NO PATCH NEEDED** | UM reworks exteriors; Understone interior layout largely vanilla-friendly |
| SFH | **NO PATCH NEEDED** | — |
| SN | **NO PATCH — RISK** | UM heavily edits Markarth navmesh/landscape |
| ST / Orc / Solst | **NO PATCH NEEDED** | — |
| SB / Ivy / FYX | **NO PATCH NEEDED** | Other holds |
| VPCE | **NO PATCH — RISK** | VPCE Markarth entrance vs UM gate rework — undocumented |
| Nav | **NO PATCH — RISK** | — |
| LV | **UNKNOWN** | Lux hub covers many cities; UM-specific Lux Via patch not confirmed in this pass |
| LFFGM | **UNKNOWN** | — |
| AAF / SRRP | **NO PATCH NEEDED** / **UNKNOWN** | — |

UM author invites community patches; clipping workaround: disable conflicting Spaghetti objects in CK/console.

---

### Ultimate Markarth Expanded — [153484](https://www.nexusmods.com/skyrimspecialedition/mods/153484)

Requires Ultimate Markarth. Adds further Markarth exterior content.

| Anvil mod | Status | Notes |
|---|---|---|
| SC (Markarth) | **UNKNOWN** | [UME Patch Hub](https://www.nexusmods.com/skyrimspecialedition/mods/155426) WIP (Morrigan0crow); Spaghetti not confirmed in hub description — use hub FOMOD at install + Medieval Markets Spaghetti Markarth as fallback |
| SP / SFH | **NO PATCH NEEDED** | Interiors |
| SN | **NO PATCH — RISK** | Expanded exterior/navmesh surface |
| ST / Orc / Solst | **NO PATCH NEEDED** | — |
| SB / Ivy / FYX | **NO PATCH NEEDED** | — |
| VPCE | **NO PATCH — RISK** | — |
| Nav | **NO PATCH — RISK** | — |
| LV | **UNKNOWN** | Lux lists UME Patch Hub as related; Via coverage unconfirmed |
| LFFGM / AAF / SRRP | **UNKNOWN** | — |

---

### RedBag's Solitude — [42052](https://www.nexusmods.com/skyrimspecialedition/mods/42052)

| Anvil mod | Status | Notes |
|---|---|---|
| SC (Solitude) | **PATCH EXISTS** | [RedBag Patch Collection](https://www.nexusmods.com/skyrimspecialedition/mods/51450) — Spaghetti Cities AIO patch; Medieval Markets also lists RedBag×Spaghetti |
| SP (Blue Palace) | **NO PATCH NEEDED** | RedBag page: interior overhauls generally compatible; Blue Palace is separate interior |
| SFH (Bard's College, Castle Dour) | **NO PATCH NEEDED** | RedBag compatibility spoiler lists many mods; Spaghetti faction halls additive |
| SN | **NO PATCH — RISK** | RedBag reworks walls/docks/navmesh |
| ST / Orc / Solst | **NO PATCH NEEDED** | — |
| SB / Ivy / FYX-W | **NO PATCH NEEDED** | — |
| FYX-R | **NO PATCH NEEDED** | — |
| VPCE | **NO PATCH — RISK** | RedBag overhauls Solitude walls/entrances; no VPCE patch |
| Nav | **NO PATCH — RISK** | — |
| LV | **PATCH EXISTS** | RedBag Patch Collection includes Lux Via record fixes; Lux hub also lists RedBag Solitude |
| LFFGM | **UNKNOWN** | RedBag patch hub includes Landscape and Water Fixes — LFFGM is separate mod |
| AAF / SRRP | **NO PATCH NEEDED** / **UNKNOWN** | SRRP may touch Solitude road approach |

RedBag page: incompatible with anything that heavily changes Solitude — expect patch-driven integration, not plug-and-play.

---

### City of Crossed Daggers — Riften Expansion — [168629](https://www.nexusmods.com/skyrimspecialedition/mods/168629)

| Anvil mod | Status | Notes |
|---|---|---|
| SC (Riften) | **PATCH EXISTS** | Mod page: patch for AIO + Riften module (optional files) |
| SP (Mistveil Keep) | **NO PATCH NEEDED** | Mod does not edit vanilla interiors |
| SFH (Thieves Guild) | **NO PATCH NEEDED** | Interior-only |
| SN | **NO PATCH — RISK** | Mod edits Riften worldspace + navmesh (v1.5–1.8 changelog: repeated navmesh fixes) |
| ST / Orc / Solst | **NO PATCH NEEDED** | — |
| SB / Ivy / FYX-W | **NO PATCH NEEDED** | — |
| FYX-R | **NO PATCH — RISK** | Mod edits Plankside/canals; FYX Riften Canal touches same district — **not on author compatibility list** |
| VPCE | **NO PATCH — RISK** | Riften gate fortifications vs VPCE Riften entrance |
| Nav | **NO PATCH — RISK** | Active navmesh editor + expansion navmesh |
| LV | **UNKNOWN** | Lux + Lux Orbis patches listed; **Lux Via not listed** on mod page |
| LFFGM | **UNKNOWN** | — |
| AAF / SRRP | **NO PATCH NEEDED** / **UNKNOWN** | — |

Northern Roads patch provided ([169238](https://www.nexusmods.com/skyrimspecialedition/mods/169238) ecosystem).

---

### Riverwood Has Walls — [146520](https://www.nexusmods.com/skyrimspecialedition/mods/146520)

| Anvil mod | Status | Notes |
|---|---|---|
| SC | **NO PATCH NEEDED** | Riverwood is Towns scope, not Cities |
| SP / SFH | **NO PATCH NEEDED** | — |
| SN | **NO PATCH NEEDED** | Author: walls are navcut — "no navmesh patching if you merely move palisades" |
| ST (Riverwood) | **PATCH EXISTS** | [Patch Collection 147419](https://www.nexusmods.com/skyrimspecialedition/mods/147419): Walls — Spaghetti Towns AIO + Spaghetti Riverwood |
| ST (other towns) / Orc / Solst | **NO PATCH NEEDED** | — |
| SB / Ivy / FYX / VPCE | **NO PATCH NEEDED** | Whiterun/Windhelm/Riften scope (Ivy is Whiterun well) |
| Nav | **NO PATCH — RISK** | Lower than capitals; landscape edits near Riverwood still overlap Navigator cells |
| LV | **UNKNOWN** | Not in Riverwood patch hub listing |
| LFFGM | **UNKNOWN** | — |
| AAF / SRRP | **NO PATCH NEEDED** / **UNKNOWN** | SRRP passes Riverwood road |

---

## Per-city executive summary

### Whiterun — CWE + WHWR (dual mod)

**Patch ecosystem: mature but fiddly.**

- Spaghetti: keep with [116487](https://www.nexusmods.com/skyrimspecialedition/mods/116487) + WHWR hub Spaghetti patches.
- Ivy Well: CWE patch in Ivy FOMOD; **WHWR×Ivy undocumented** — human QA at the well plaza.
- VPCE + Navigator: highest Anvil-specific risks for this hold.
- **Human flags:** (1) Confirm VPCE Whiterun gate vs CWE+WHWR in-game or drop VPCE Whiterun slice; (2) PseudoLoadDoors 140034 if running both CWE and WHWR; (3) Rob's Bug Fixes mandatory; (4) never install WHWR occlusion FOMOD option.

### Windhelm — Capital Windhelm Expansion

**Patch ecosystem: good for Spaghetti + SB; weak for VPCE.**

- Install Spaghetti's Capital Windhelm Expansion [154715](https://www.nexusmods.com/skyrimspecialedition/mods/154715) rather than dropping Spaghetti Windhelm.
- SB: use CWE-specific FOMOD variant.
- VPCE vs expanded bridge/harbour: **NO PATCH — RISK** (CEO patch does not apply).
- FYX Graveyard: **UNKNOWN** with CWE — keep existing Spaghetti FYX patch; test graveyard cell transition.

### Markarth — Ultimate Markarth + Expanded

**Patch ecosystem: emerging (UME Patch Hub WIP).**

- Spaghetti Markarth: patch via UME hub and/or Medieval Markets; be ready to drop `Spaghetti's Cities — Markarth` if hub lacks coverage.
- Navigator + VPCE: expect manual QA or xEdit work.
- **Human flag:** Confirm UME Patch Hub FOMOD contents at install time before committing to keep Spaghetti Markarth.

### Solitude — RedBag's Solitude

**Patch ecosystem: solid for Spaghetti + Lux Via.**

- Keep Spaghetti Solitude with RedBag Patch Collection.
- VPCE Solitude entrance vs RedBag walls: **NO PATCH — RISK**.
- Palaces/Faction Halls: keep (interior additive).

### Riften — City of Crossed Daggers

**Patch ecosystem: good author patches; FYX gap.**

- Spaghetti: author patch in optional files — install.
- **FYX Riften Canal: NO PATCH — RISK** — both edit canal/plankside; human must choose keep/patch/drop FYX or accept clipping/nav bugs.
- Lux Via not on author list (Lux/Orbis are) — check Lux Via Patch Hub at install.

### Riverwood — Riverwood Has Walls

**Patch ecosystem: good for Spaghetti Towns.**

- Patch hub covers Spaghetti Towns AIO + Riverwood module.
- Lower conflict tier than capitals; Navigator still worth spot-checking.

---

## Cross-cutting Anvil mods (all proposed cities)

| Anvil mod | Overall assessment |
|---|---|
| **Navigator-NavFixes** | **NO PATCH — RISK** for every capital expansion that edits city navmesh (all five capitals + Riverwood). Navigator Patch Collection [111379](https://www.nexusmods.com/skyrimspecialedition/mods/111379) has no entries for these proposed mods. Plan in-game follower/pathing QA or accept Navigator losses in edited cells. |
| **Vanilla Plus City Entrances** | **NO PATCH — RISK** at every hold gate where a proposed expansion also reworks walls/bridges. Author explicitly does not plan patches. Strong candidate to **drop VPCE per hold** as expansions land, or budget custom patches. |
| **Lux Via** | **PATCH EXISTS** for CWE, CWE Windhelm, RedBag (via RedBag hub); **UNKNOWN** for UM/UME, WHWR direct, Crossed Daggers (Via not listed). Use Lux Via Patch Hub at install. |
| **Landscape Fixes for Grass Mods** | Mostly **UNKNOWN**; tangential unless expansions touch same landscape vertices as LFFGM grass fixes. |
| **Skyrim Road Reconstruction Project** | **UNKNOWN** — ESL road network may intersect city approach cells for Whiterun/Windhelm/Solitude; no patches found. |
| **Ancient AF Windhelm** | **NO PATCH NEEDED** with CWE per Spaghetti CWE integration list; mesh/texture layer. |

---

## Human decision flags (install blockers)

| # | Decision | Why |
|---|---|---|
| **H1** | **Whiterun: run CWE + WHWR together or pick one?** | Together needs PseudoLoadDoors 140034 + multiple hub patches + Rob's; occlusion FOMOD is dangerous. |
| **H2** | **Drop or keep Vanilla Plus City Entrances per hold?** | No patches for any proposed expansion; gate overlap is structural. |
| **H3** | **Navigator: accept nav conflicts or disable Navigator slices / regenerate after city installs?** | No turnkey patches for this stack. |
| **H4** | **Markarth: keep Spaghetti Markarth clutter or drop modular Markarth pending UME Patch Hub coverage?** | Hub WIP; Medieval Markets patch is partial coverage. |
| **H5** | **Riften: keep FYX Riften Canal with Crossed Daggers?** | Not on author compatibility list; canal district overlap. |
| **H6** | **Whiterun: Ivy Well + WHWR — accept UNKNOWN or test-first?** | Ivy documents CWE patch only. |
| **H7** | **Windhelm: FYX Graveyard + CWE — in-game QA required** | No documented patch; Spaghetti×FYX patch already in Anvil. |
| **H8** | **Migrate Spaghetti Cities AIO → modular per hold?** | Required if human wants clean per-city drops without carrying other holds' clutter in AIO. |

---

## Required patches checklist (if stack approved)

| Patch | Nexus | When |
|---|---|---|
| CWE × Spaghetti AIO | [116487](https://www.nexusmods.com/skyrimspecialedition/mods/116487) | CWE + Spaghetti |
| Rob's Bug Fixes — CWE | [63355](https://www.nexusmods.com/skyrimspecialedition/mods/63355) | CWE (mandatory) |
| WHWR Patch Hub | [119229](https://www.nexusmods.com/skyrimspecialedition/mods/119229) files | WHWR + anything |
| PseudoLoadDoors CWE×WHWR | [140034](https://www.nexusmods.com/skyrimspecialedition/mods/140034) | CWE + WHWR together |
| Ivy Well patches (FOMOD) | [125955](https://www.nexusmods.com/skyrimspecialedition/mods/125955) | Ivy + CWE + Spaghetti |
| Spaghetti's Capital Windhelm Expansion | [154715](https://www.nexusmods.com/skyrimspecialedition/mods/154715) | CWE + Spaghetti Windhelm |
| SB Fixed Windhelm (CWE FOMOD) | [73058](https://www.nexusmods.com/skyrimspecialedition/mods/73058) | SB + CWE |
| UME Patch Hub | [155426](https://www.nexusmods.com/skyrimspecialedition/mods/155426) | UM + UME stack |
| RedBag Patch Collection | [51450](https://www.nexusmods.com/skyrimspecialedition/mods/51450) | RedBag + Spaghetti/Lux Via/etc. |
| Crossed Daggers × Spaghetti | [168629](https://www.nexusmods.com/skyrimspecialedition/mods/168629) optional | Riften expansion |
| Riverwood Has Walls Patch Collection | [147419](https://www.nexusmods.com/skyrimspecialedition/mods/147419) | Riverwood walls + Spaghetti Towns |
| Lux / Lux Via Patch Hubs | via Lux [43158](https://www.nexusmods.com/skyrimspecialedition/mods/43158) | Per selected city mods |

**No installation task created** — research only per task-0040 scope.

---

## Research limits

- Nexus fetch timeouts on some hub pages (UME 155426, RedBag 51450, article 7025 full text) — conclusions from search snippets, cached agent-tool extracts, and mod requirement tables.
- WHWR Patch Hub FOMOD option list not exhaustively enumerated option-by-option; article 7025 used as secondary source for Spaghetti/Ivy/Lux claims.
- Navigator Patch Collection not line-audited against each expansion plugin — absence of named patches treated as **NO PATCH — RISK**, not proof of breakage.
