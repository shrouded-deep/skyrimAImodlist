# Wabbajack Foundation Evaluation — Pivot Decision

**Date:** 2026-07-11 (revised **2026-07-12**)  
**Author:** Cursor (research task)  
**Purpose:** Identify a **middle-ground Wabbajack foundation** for a personal Skyrim SE modlist — expansive scope, but **not** locked down by hand-crafted, unremoveable custom patch webs (Nolvus-class). Reject both extremes:

| Extreme | Problem |
|---------|---------|
| **Bottom-up (Anvil)** | Too much curation gap; visuals-only CS baseline (~1,055 archives); user must assemble quests, gameplay, followers, patches from scratch |
| **Top-down (Nolvus Awakening)** | Nested Nolvus-specific patches, SREX city web, opaque baked Synthesis/DynDOLOD outputs; deconstruction not worth the effort |

**User curation lens (from AGENTS.md):** Power fantasy — expand capability and spectacle; deprioritize survival friction and difficulty-through-fragility.

---

## Hard filters (2026-07-12)

These are **steering constraints**, not scoring weights. A list that fails a hard filter is out of the short-list regardless of scope or patch-lock score.

| Filter | Rule | Effect |
|--------|------|--------|
| **No Requiem** | Requiem is too tightly integrated to remove. Lists with Requiem as **core gameplay** are **disqualified at the outset** — not merely “high lock-in.” | LoreRim, Wildlander, Nolvus, and any other Requiem-core list move to **Disqualified — Requiem**. SimonRim / EnaiRim / Vokriinator lists are **not** Requiem unless they ship `Requiem for the Indifferent.esp` or equivalent. |
| **Target 1.17.0 (1170)** | Prefer lists that natively target Skyrim AE **1.6.1170**. | Non-1170 lists may stay on a **conditional** short-list only with a documented **1170 migration challenge** (SKSE plugin builds, Address Library version, Nemesis/Behavior output, CC file-hash mismatches, pinned DLL mods). |

**Registry note:** Public Wabbajack `modlists.json` entries polled 2026-07-12 expose **no** `gameVersion` / `gameMajor` / `gameMinor` / `gamePatch` fields for any finalist. Target version is sourced from list readmes, changelogs, and registry `description`/`tags` where present.

---

## 1. Executive Summary

After surveying featured/popular Wabbajack SE lists via the public registry JSON (GitHub raw), Nexus pages where accessible, and list readmes, **no single list perfectly matches “Nolvus scope without Nolvus lock-in.”** Applying the **2026-07-12 hard filters** (no Requiem, prefer 1170-native) tightens the field further: Requiem-core lists and the abandoned Nolvus donor are out before patch-lock scoring.

The viable middle ground remains a **two-layer strategy**:

1. **Gameplay/content foundation** — a list built mostly from **published Nexus mods + standard patch conventions**, with limited list-owned ESP glue, **no Requiem**, and **1170-native** tooling where possible.
2. **Optional visual baseline** — a **fork-friendly visual list** (NGVO) if the gameplay foundation’s visuals need upgrading without importing another patch web.

### Recommended short-list (finalists — post-2026-07-12 filters)

| Rank | List | 1170 | Requiem | Role | Why finalist |
|------|------|------|---------|------|--------------|
| 1 | **Keizaal** | ✅ Native (v8.0.0+ changelog) | ❌ None | Primary gameplay foundation | Vanilla+ expansive scope; Tamrielic Distribution glue; ~1,011 archives / ~124 GB |
| 2 | **Gate to Sovngarde (WJ AE)** | ✅ Native (readme) | ❌ None | Conditional expansive alternative | ~2,153 archives; **unofficial** Flimsy WJ port of Nexus Collection; non-featured in WJ gallery; CS-native |
| 3 | **Nordic Souls** | ✅ Native (readme) | ❌ None (SimonRim) | SimonRim middle-ground | Modification Guide + optional CS profile; v3.1.1 (2026-06-24); ~1,732 archives |
| 4 | **NGVO** | ✅ Native (readme) | ❌ None | Visual-only stack layer | <300 plugins, <40 list ESPs; modular — not standalone expansive |
| 5 | **Living Skyrim 4** | ⚠️ Conditional | ❌ None | FG flagship fallback | Broad content + graphics; **1170 not confirmed in readme** — verify on install |

**Dropped from short-list by Requiem filter:** LoreRim, Wildlander (were already patch-lock rejects).

**Conditional / honorable (non-Requiem, not primary):** Phoenix Flavour (no Requiem; **no full AE/CC integration**; lighter scope), Anvil (1170 CS baseline only — scope too thin).

### Top fork-test recommendation (install first)

**Install and fork-test in this order:**

1. **Keizaal** — lowest gameplay lock-in among expansive non-Requiem lists; 1170-native per v8.0.0 changelog; best fit for power-fantasy curation.
2. **Gate to Sovngarde (AE Wabbajack)** — only if Keizaal feels too conservative **and** unofficial-port risk is acceptable (Flimsy conversion of Vortex-first collection; may lag updates).

**Do not install as foundation:** Nolvus (**Requiem + patch web**), LoreRim, Wildlander, Do Not Go Gentle, Nocturnia, Apostasy, FILFY, Twisted Skyrim — Requiem disqualification and/or patch/combat/survival lock-in.

---

## 2. Methodology

### Data sources

| Source | URL / path | Used for |
|--------|------------|----------|
| Wabbajack registry | `raw.githubusercontent.com/wabbajack-tools/mod-lists/master/modlists.json` | Archive counts, install sizes, versions (partial — main file is not exhaustive) |
| Repository manifests | Per-list GitHub `modlists.json` (LoreRim, Wildlander, Keizaal, NGVO, Apostasy, Nordic Souls, etc.) | Full metadata for featured lists |
| Featured index | `featured_lists.json` | Popularity / curation signal |
| Nexus mod pages | Known mod IDs from prior research | Unique DL counts, scope descriptions |
| List readmes / sites | lorerim.com, themoddingbungalo.com/ngvo, keiza.al, GtS WJ README, FG docs | Fork claims, plugin budgets, gameplay lock-in |
| Prior project work | `modlist/decisions.md`, `modlist/enb-cs-audit-2026-07-09.md`, Nolvus task history | Nolvus pain points, Anvil baseline |

### Limitations (honest data gaps)

- **Nexus unique DL counts** often show `--` without login; only some values confirmed in this pass (Apostasy 35,300; Anvil 7,520; SME 27,887). LoreRim ~178k and others rely on **prior confirmed research** where noted.
- **Wabbajack Gallery API** may return 403 from some environments; **raw GitHub registry JSON succeeded** — gallery API is not required for archive/size metadata.
- **Path of the Dovahkiin** — Wabbajack metadata not found in current registry repos polled; FG docs only (v1.3.0). Archive count **unknown** (GitHub issue referenced ~735 hashed files in one install attempt — not authoritative).
- **Wildlander** — Wabbajack manifest last updated **2024-05-17**; may understate current list; no dedicated Nexus *list* page (resources mod 70016 is not the list).
- **Nolvus** — not on Wabbajack; evaluated from project experience and published mod inventory only.
- **Plugin / list-ESP counts** — confirmed only for NGVO (<300 / <40); other lists need in-MO2 inspection post-install.
- **Custom patch counts** — rarely published; inferred from readme language (“hundreds of custom patches”) and list author ecosystem.

### Scoring: patch-lock (1 = fork-friendly → 5 = Nolvus-class)

Subjective composite of: list-specific ESPs, bespoke patch webs, baked tool outputs (Synthesis/DynDOLOD/ParallaxGen), gameplay framework lock-in (Requiem, survival), and documented removability.

**2026-07-12:** Requiem-core lists are **disqualified before** patch-lock scoring. Version fit (1170-native vs migration) is a separate column in the finalist table below.

### Finalist & candidate version matrix (registry + readme, 2026-07-12)

| List | WJ version | Registry `gameVersion`* | Readme / changelog target | Requiem? | Short-list |
|------|------------|---------------------------|---------------------------|----------|------------|
| **Keizaal** | 8.0.1.1 | — | **1.6.1170** (v8.0.0 changelog) | No | **#1** |
| **Gate to Sovngarde AE** | 0.104.0 | — | **1.6.1170** (WJ readme) | No | **#2** |
| **Nordic Souls** | 3.1.1 | — | **1.6.1170** (readme) | No (SimonRim) | **#3** |
| **NGVO** | 7.1† | — | **1.6.1170** (readme) | No | **#4 visual** |
| **Living Skyrim 4** | 4.3.0.1 | — | *Not stated in docs fetched* | No | **#5 conditional** |
| **Phoenix Flavour** | 4.20 | — | Current Steam SE; **no AE/CC integration** | No | Honorable |
| **Anvil** | 3.1.1 | — | **1.6.1170** (registry description + readme) | No | Baseline only |
| **Apostasy** | 3.2.3 | — | **1.6.1170** (readme) | No | Patch-lock reject |
| **Elysium Remastered** | 3.3.1 | — | AE/CC required; version not explicit in readme | No (EnaiRim) | LOTD/survival reject |
| **Tempus Maledictum** | 8.0.6 | — | Latest AE Steam; version not explicit | No (Enairim) | LOTD borderline |
| **LoreRim** | 5.0.4.3 | — | AE; Requiem tag | **Yes** | **Disqualified** |
| **Wildlander** | 1.1.12§ | — | Requiem tag | **Yes** | **Disqualified** |
| **Nolvus Awakening V6** | (installer) | — | AE; Requiem + JK-Requiem patches | **Yes** | **Disqualified** |
| **Do Not Go Gentle** | 2.8.5 | — | AE; Requiem tag | **Yes** | **Disqualified** |
| **Nocturnia** | 2.0.2 | — | Requiem tag | **Yes** | **Disqualified** |
| **Masterstroke** | 2.3.0.1 | — | Survival/NSFW beta | No | NSFW/survival reject |
| **NEFARAM** | 17.0.7 | — | Survival/NSFW | No | NSFW/survival reject |

\* No finalist exposed `gameVersion` / `gameMajor` / `gameMinor` / `gamePatch` in polled registry JSON.  
† NGVO v7.1 per prior research; `biggie-boss/NGVO` registry repo currently hosts **Do Not Go Gentle** only — NGVO metadata from readme + featured index.  
§ Wildlander WJ manifest last updated **2024-05-17**; may understate current list.

---

## 3. Comparison Table

Sorted by **Nexus unique DLs** where known; otherwise by **Wabbajack archive count** (proxy for scope/popularity).

| List | Nexus ID | Unique DLs | WJ archives | Total size (WJ meta) | Scope summary | Patch-lock (1=good) | 1170 | Requiem | Verdict |
|------|----------|------------|-------------|----------------------|---------------|---------------------|------|---------|---------|
| **LoreRim** | 112590 | ~178,432† | 4,402 | ~577 GB | Full overhaul: Requiem, MCO, LOTD-scale quests, EnaiRim, city/world expansion | **5** | AE | **Yes** | **Disqualified — Requiem** |
| **Apostasy** | 118893 | 35,300 | 3,441 | ~484 GB | Modern action combat (MCO suite), visuals, quests, followers | **5** | ✅ | No | **Reject** — patch web; not Requiem |
| **Twisted Skyrim** | (collection) | — | 6,031 | ~1.36 TB | Personal magnum opus; BFCO/DMCO/Precision stack; NSFW | **5** | ? | No | **Reject** — largest archive count |
| **FILFY** | — | — | 4,318 | ~786 GB | Kitchen-sink total overhaul; seasons | **5** | ? | No | **Reject** — FILFY-scale integration |
| **Wildlander** | —‡ | — | 567§ | ~137 GB§ | Requiem + survival hardcore “life sim” | **4** | ? | **Yes** | **Disqualified — Requiem** |
| **Elysium Remastered** | 65080¶ | — | 2,542 | ~541 GB | Visual-first + full EnaiRim + LOTD + Bruma + survival tone | **4** | ? | No | **Reject** — LOTD lock-in (not Requiem) |
| **NEFARAM** | — | — | 2,334 | ~553 GB | NSFW survival, new lands, seasons | **4** | ? | No | **Reject** — NSFW + survival |
| **Tempus Maledictum** | — | — | 2,140 | ~471 GB | LOTD + Enairim power fantasy (author intent) | **3–4** | ? | No | **Borderline** — LOTD lock-in |
| **Gate to Sovngarde (AE WJ)** | 172373 / coll. | — | 2,153 | ~217 GB | All-in-one collection; CS, gameplay, visuals, JaySerpa ecosystem | **2–3** | ✅ | No | **Finalist #2** |
| **Living Skyrim 4** | — | — | 1,439 | ~433 GB | FG flagship: quests, worldspaces, NPCs, graphics | **3** | ⚠️ | No | **Finalist #5 conditional** |
| **Nordic Souls** | 77497 | — | 1,732 | ~319 GB | SimonRim + quests + Bruma/Vigilant tier; ENB or CS profile | **2–3** | ✅ | No | **Finalist #3** |
| **NGVO** | 149209 | —†† | 1,690 | ~309 GB | Visual-only baseline; modular separators | **1** | ✅ | No | **Finalist (visual layer)** |
| **Masterstroke** | — | — | 1,377 | ~557 GB | NSFW + survival + FG ecosystem | **3** | ? | No | **Reject** — NSFW/survival beta |
| **Keizaal** | 68997††† | — | 1,011 | ~124 GB | Vanilla+ expansion; Tamrielic Distribution glue | **2** | ✅ | No | **Finalist #1** |
| **The Phoenix Flavour** | — | — | 901 | ~146 GB | ~700 mods; SimonRim visuals + gameplay | **2–3** | ⚠️†††† | No | **Honorable** — no AE integration |
| **Anvil** | 147302 | 7,520 | 1,055 | ~202 GB | CS visuals-only foundation (1170) | **1** | ✅ | No | **Baseline (reject as foundation)** |
| **Do Not Go Gentle** | — | — | 2,007 | ~446 GB | AVO-AE + Requiem personal list | **4** | AE | **Yes** | **Disqualified — Requiem** |
| **Skyrim Modding Essentials** | 71689 | 27,887 | 301 | ~38 GB | Utility/tooling starter | **1** | 640+††††† | No | **Not a foundation** |
| **Path of the Dovahkiin** | — | — | ? | ? | ARPG grind: Vokriinator, loot engines, ENB | **3** | ? | No | **Reject** — niche ARPG loop |
| **Nolvus Awakening V6** | (installer) | — | — | ~similar tier to LoreRim | Full curated top-down; SREX; Requiem; Nolvus patches | **5** | AE | **Yes** | **Disqualified — Requiem** (donor abandoned) |

† Prior session confirmed; Nexus page showed `--` without login (2026-07-11).  
‡ Wildlander resources: Nexus 70016 — not the list itself.  
§ Wildlander WJ manifest possibly stale (last updated 2024-05-17).  
¶ 65080 is Elysium **output repository**, not a list landing page.  
†† NGVO Nexus fetch timed out; plugin claims from official readme.  
††† Keizaal Nexus 68997 not re-verified this session (fetch timeout); WJ lists Nexus collection 446937.  
†††† TPF readme: “does not yet support any of the Anniversary Edition content”; targets current Steam SE without AE CC integration.  
††††† SME changelog references upgrade to **1.6.640.0** (utility list, not a foundation candidate).

---

## 4. Deep Dives — Finalists vs Nolvus and Anvil

### 4.1 Keizaal (recommended primary)

**Wabbajack:** v8.0.1.1 | 1,011 archives | ~124 GB total | Last updated 2024-11-02  
**Registry:** `Keizaal/Keizaal/main/modlists.json` — no `gameVersion` field; tags: Steam, DLC Required, Vanilla+  
**Target version:** **1.6.1170** — v8.0.0 changelog: “Moved Keizaal to Skyrim version 1.6.1170”; v8.0.1.x maintenance releases follow 1170 patch cycles.  
**Requiem:** None (Vanilla+ / optional SimonRim secondary profile).  
**Gameplay:** Vanilla+ — Constellations (Athletics/H2H/Sorcery), staff enchanting overhaul, quest expansions (DB, House of Horrors), Lawbringer, Lucien, CoMAP, Bruma, Wyrmstooth, Cities of the North.  
**List glue:** **Tamrielic Distribution** — author-written integration mod; removable in principle (revert leveled-list/worldspace integration manually).  
**vs Nolvus:** ~40% of Nolvus scope at much lower patch entropy. No SREX web, no Nolvus Ascension patch stack, no baked unknown Synthesis pipeline.  
**vs Anvil:** Adds complete gameplay + quest + follower layer Anvil lacks.  
**Lock-in risks:** ENB-forward presentation; not CS-native (CS migration would be a project). Integration mod touches many records — plan removal tests.  
**Power fantasy fit:** Strong — expands player capability without Requiem/survival punishment.

**1170 migration challenge:** **N/A** — list is 1170-native. Fork-test (task-0046) should still confirm Stock Game exe version and absence of Requiem plugins.

### 4.2 Gate to Sovngarde — Wabbajack AE (conditional — unofficial port)

**Wabbajack:** v0.104.0 | 2,153 archives | ~217 GB total  
**Registry:** `FlimsyParking/Gate-to-Sovngarde-Wabbajack/main/modlists.json` — no `gameVersion` field  
**Target version:** **1.6.1170** — WJ readme REQUIREMENTS: “Skyrim SE 1.6.1170”; AE and Non-AE variants (AE = paid Anniversary Upgrade DLC).  
**Requiem:** None.  
**Origin:** JaySerpa Nexus **Collection** ([`qdurkx`](https://www.nexusmods.com/games/skyrimspecialedition/collections/qdurkx)) is the **canonical** install (Vortex). The Wabbajack build is an **unofficial community port** by FlimsyParking ([Nexus 172373](https://www.nexusmods.com/skyrimspecialedition/mods/172373)); **not featured** — tick **Show Unofficial Lists** in Wabbajack. Port may **lag** collection updates (WJ v0.104 tracks collection V104).  
**Tech:** Community Shaders (END menu, DLSS/FG options), Stock Game, Root Builder, locked LOOT sort (intentional).  
**Fork posture:** WJ readme — fork allowed with distinct name; JaySerpa permission needed for collection-level fork; `[NoDelete]` prefix for added mods on update. **Customization voids official support** but structure is standard mods + patches, not list-owned mega-ESP web.  
**vs Nolvus:** No Nolvus-specific ESPs; no SREX. Comparable breadth at collection scale.  
**vs Anvil:** Full game experience vs visuals-only.  
**Lock-in risks:** “Do not drag mods/plugins” discipline; pinned mod versions; JaySerpa ecosystem density (Skyrim Souls, CS tuning). Still **far more legible** than Nolvus patch archaeology.  
**Power fantasy fit:** Good — “Fair and Balanced” collection tag; not survival-hardcore.

**1170 migration challenge:** **N/A** — 1170-native. Non-AE variant exists for users without paid AE DLC but still targets 1170 runtime.

### 4.3 Nordic Souls (SimonRim alternative)

**Wabbajack:** v3.1.1 | 1,732 archives | ~319 GB | Updated 2026-06-24  
**Registry:** `Geborgen/modlists/main/modlists.json` — tags: Anniversary Edition, Creation Club, SimonRim; no `gameVersion` field  
**Target version:** **1.6.1170** — readme: “latest version of Skyrim, version `1.6.1170`”; full AE/CC required.  
**Requiem:** **None** — SimonRim gameplay (Mysticism, Blade & Blunt, etc.). Name evokes “Souls” but list is **not** a Requiem list.  
**Gameplay:** Full SimonRim; traits; Lawless; Dragon War; Sentinel loot; Bruma, Wyrmstooth, Vigilant, Unslaad, Forgotten City, Inigo/Auri/Xelzaz.  
**Fork posture:** Dedicated **Modification Guide**; CS alternate profile; optional files separators. Author warns support void on changes — same as most lists, but documentation is above average.  
**vs Nolvus:** No bespoke city/exterior patch matrix; SimonRim is a **published ecosystem** with community patches.  
**vs Anvil:** Complete game; optional CS path aligns with Anvil tech choices.  
**Lock-in risks:** SimonRim + ENB default; load-order rules (plugins above Water for ENB).  
**Power fantasy fit:** Moderate-good — harder than Keizaal but not Requiem/survival.

**1170 migration challenge:** **N/A** — 1170-native; actively maintained (2026-06-24).

### 4.4 NGVO (visual layer — not standalone)

**Wabbajack:** v7.1 | 1,690 archives | ~309 GB  
**Registry:** Featured index `GhoulifiedReality/NGVO`; `biggie-boss/NGVO` repo hosts readme + **Do Not Go Gentle** (separate Requiem list — do not confuse).  
**Target version:** **1.6.1170** — readme: “NGVO REQUIRES YOUR SKYRIM VERSION TO BE UPDATED TO 1.6.1170”; full AE upgrade required.  
**Requiem:** None in NGVO. (**Do Not Go Gentle** in same author org is Requiem — disqualified.)  
**Design:** “Making it as moddable as possible” — **<300 plugins, <40 ESP/ESM**, 210+ free slots. Modular separators (e.g. swap Northern Roads ↔ Blended Roads).  
**Nexus author note (LoreRim page):** “NGVO is designed to be forked… No need to ask permissions.”  
**vs Nolvus:** Opposite philosophy — minimal list ESP footprint.  
**vs Anvil:** Similar CS/ENB modern visuals; NGVO is more “complete visual baseline,” Anvil is leaner CS lab.  
**Use case:** Install **on top of** Keizaal only after fork-test proves plugin budget; or merge visual separators selectively — **do not** treat as full content foundation.

**1170 migration challenge:** **N/A** — 1170-native.

### 4.5 Living Skyrim 4 (fallback flagship — conditional 1170)

**Wabbajack:** v4.3.0.1 | 1,439 archives | ~433 GB | Last updated 2025-04-25  
**Registry:** `wabbajack-tools/mod-lists/master/modlists.json` — tags: Official, NeverNude; no `gameVersion` field  
**Target version:** **Not confirmed** in readme/docs fetched (FG site install pages returned homepage only). WJ v4.3.0.1 era suggests **likely 1170-class** but requires install verification.  
**Requiem:** None (FG ecosystem; EnaiRim-adjacent mods possible but not Requiem-core).  
**Scope:** FG flagship — bustling settlements, quests, worldspaces, performance-minded graphics. LS5 announced (2024-12-27).  
**vs Nolvus:** Less opaque than Nolvus; FG patch mods exist but community understands them.  
**vs Anvil:** Full content vs visuals-only.  
**Lock-in risks:** FG separator/patch conventions; less explicit fork docs than Nordic Souls/NGVO.  
**Power fantasy fit:** Good generalist; verify survival/friction mods in LO post-install.

**1170 migration challenge:** **Medium (if not 1170)** — would require auditing SKSE plugin builds, Address Library, Nemesis/Behavior outputs, DynDOLOD/TexGen regen, and any pinned pre-1170 DLL mods across ~1,439 archives. Confirm during fork-test before adopting as foundation.

---

## 5. Disqualified — Requiem (2026-07-12 hard filter)

Lists below ship **Requiem as core gameplay**. Removing Requiem would break rebalance, loot, encounter, and patch webs — same failure mode as Nolvus top-down curation. **Do not install** for this pivot.

| List | Evidence | Notes |
|------|----------|-------|
| **LoreRim** | Registry tag `Requiem`; description: modern action RPG with Requiem + MCO | ~178k Nexus DLs; 4,402 archives; also patch-lock reject |
| **Wildlander** | Registry tags `Requiem`, `Survival`, `Hardcore` | Survival philosophy also opposite power-fantasy lens; WJ meta stale (2024-05-17) |
| **Nolvus Awakening V6** | Project install logs: `JKs * - Requiem patch.esp` deferred plugins; Requiem integration across holds | Not on Wabbajack; donor **abandoned** 2026-07-11; also patch-lock reject |
| **Do Not Go Gentle** | `biggie-boss/NGVO` registry: tags `Requiem`; “built off of AVO-AE with Requiem” | **Surprise finding** — same author org as NGVO; not NGVO itself |
| **Nocturnia** | `AnimonculoryWJLists` registry: tags `Requiem`; “lightweight Requiem list” | Not previously in comparison table |

**Verified NOT Requiem (checked 2026-07-12):**

| List | Framework instead of Requiem |
|------|------------------------------|
| **Nordic Souls** | SimonRim suite |
| **Keizaal** | Vanilla+ (optional SimonRim profile) |
| **Gate to Sovngarde** | JaySerpa collection / standard mods |
| **Elysium Remastered** | EnaiRim (still reject for LOTD/survival) |
| **Tempus Maledictum** | Enairim + LOTD (borderline; not Requiem) |
| **Masterstroke** | Survival/NSFW (no Requiem tag) |
| **NEFARAM** | Survival/NSFW (no Requiem tag) |
| **Apostasy** | MCO action combat (no Requiem; patch-lock reject) |

---

## 6. Explicit Rejection Rationale — Nolvus-Class and Adjacent

### Nolvus Awakening V6 (contrast — project donor; **Disqualified — Requiem**)

| Pain point | Detail |
|------------|--------|
| **Requiem core** | Requiem for the Indifferent + JK's Requiem patch web (e.g. Dragonsreach, Nightgate Inn, Bards College, Fort Dawnguard, Sky Haven Temple patches observed in project install logs) |
| Nolvus-specific patches | Nolvus Ascension Lighting/Weathers patches, curated ENB-light mesh web |
| SREX city stack | Load-bearing SR Exterior Cities integration — **explicitly non-alterable** per project decisions (moot post-pivot) |
| Baked tool outputs | Synthesis output with unknown pipeline (task-0008 research never landed in this repo — **obsolete** given pivot) |
| ENB lock-in | Full ENB + ReShade + NAT.ENB stack; CS migration = rebuild (`modlist/enb-cs-audit-2026-07-09.md`) |
| Deconstruction cost | Top-down trim still leaves nested dependencies; user conclusion: **not worth deconstructing** |

### LoreRim (~178k Nexus DLs — **Disqualified — Requiem**)

- Registry tags: **Requiem**, MCO, Anniversary Edition.
- Readme: **“HUNDREDS of custom addons, patches & more”** with Requiem + MCO + EnaiRim full stack.
- 4,402 archives / ~577 GB — largest mainstream contender.
- **Same failure mode as Nolvus:** removing Requiem or a major city mod breaks rebalance web; list-specific patches undocumented outside Discord/loadorderlibrary.

### Wildlander (**Disqualified — Requiem**)

- Registry tags: **Requiem**, Survival, Hardcore.
- Requiem + survival hardcore — **opposite** power-fantasy curation lens.
- WJ metadata stale; philosophy is friction-forward.

### Apostasy (35,300 unique DLs)

- 3,441 archives; readme/Nexus: **“hundreds of custom patches and tweaks”**; custom DLLs.
- MCO + Poise + Stances combat stack — removing one mod cascades.
- Official support **voided on modification** (modifications channel only).

### Twisted Skyrim / FILFY

- **Twisted Skyrim:** 6,031 archives, ~1.36 TB — personal patch opus.
- **FILFY:** 4,318 archives — kitchen-sink “touches all aspects”; seasons + massive integration.

### Wildlander

*(Moved to §5 Disqualified — Requiem.)*

### Anvil (current baseline — reject as foundation)

- Explicitly visuals-only CS list; 7,520 Nexus unique DLs.
- User already hit **curation gap** building bottom-up (task-0042/0043/0044 city stack work incomplete).
- Keep as **reference** for CS/visual choices, not as scope foundation.

### Others (brief)

| List | Reject reason |
|------|---------------|
| **Elysium Remastered** | LOTD + EnaiRim + survival/challenge framing |
| **Tempus Maledictum** | LOTD + 2 dozen quest mods — good power fantasy intent but LOTD lock-in |
| **Path of the Dovahkiin** | ARPG grind loop (Vokriinator, Halgari loot) — niche |
| **Masterstroke / NEFARAM** | NSFW + survival |
| **Phoenix Flavour** | Solid but lighter scope; ENB SimonRim; **no AE/CC integration**; 1170-compatible Steam but not AE-native | **Honorable** |
| **Do Not Go Gentle** | Requiem + AVO-AE personal list (biggie-boss org) | **Disqualified — Requiem** |
| **SME** | Utility only; targets 1.6.640 per changelog | **Not a foundation** |

---

## 7. Recommendation — Install & Fork-Test Plan

### Phase 1 — Install (pick one first)

1. **Keizaal** (~124 GB, ~1,011 archives)  
   - **Test:** Remove 5 “nice to have” mods (e.g. a follower, a city mod, a gameplay tweak). Re-run LOOT/xEdit smoke test. Document broken refs.  
   - **Success criterion:** Game launches; no cascade of list-ESP errors; Tamrielic Distribution understood.

2. **Gate to Sovngarde WJ AE** (~217 GB) — conditional; unofficial WJ port only, not JaySerpa's canonical Collection install.  
   - **Test:** Add one `[NoDelete]` mod in `[Nolvus Additions]`-style separator; remove one optional visual mod from its patch separator per JaySerpa conventions.  
   - **Success criterion:** Fork feels legible; patch count stays mostly third-party.

### Phase 2 — Optional visual upgrade (only after Phase 1 pass)

3. **NGVO** — evaluate merging visual separators into chosen foundation **only if** plugin budget allows (<245 active plugins project rule).

### Do not install for this pivot

Nolvus (**Requiem**), LoreRim, Wildlander, Do Not Go Gentle, Nocturnia, Apostasy, FILFY, Twisted Skyrim, Elysium (unless LOTD is explicitly desired).

### Obsolete project work

- **task-0008 (Nolvus Synthesis pipeline)** — not present in `anvil-successor` repo; moot if abandoning Nolvus top-down donor. Cancel / archive in `nolvus-successor` if still queued there.

---

## 8. Criteria Scorecard (finalists only — post-Requiem filter)

Scores 1–5 (5 = best for that criterion). Patch-lock inverted: lower patch-lock raw score = better fork-friendliness.

| Criterion | Keizaal | Gate to Sovngarde | Nordic Souls | NGVO | Living Skyrim |
|-----------|---------|-------------------|--------------|------|---------------|
| Scope | 3 | 4 | 4 | 1 | 4 |
| Low patch-lock | 4 | 3 | 3 | 5 | 3 |
| Removability | 4 | 3 | 3 | 5 | 3 |
| Maintenance | 3 | 4 | 5 | 4 | 4 |
| Low gameplay lock-in | 4 | 4 | 3 | 5 | 4 |
| **No Requiem** | 5 | 5 | 5 | 5 | 5 |
| **1170-native fit** | 5 | 5 | 5 | 5 | 2† |
| Install simplicity | 5 | 3 | 3 | 3 | 3 |
| Power fantasy fit | 4 | 4 | 3 | N/A | 4 |

† Living Skyrim: 1170 not confirmed in docs — score reflects uncertainty pending install check.

---

## 9. Key Data Gaps (for follow-up)

1. In-MO2 **active plugin counts** for Keizaal, GtS, Nordic Souls post-install.  
2. **Living Skyrim 4** — confirm Stock Game **1.6.1170** on install (FG docs not fetchable).  
3. **Keizaal fork-test** — task-0046: confirm 1170 + no Requiem in active plugins.  
4. Keizaal Nexus **68997** unique DLs — verify when Nexus accessible.  
5. NGVO Nexus **149209** stats + confirm current plugin count on v7.1.  
6. Wildlander current archive count / update status (WJ manifest stale).  
7. Path of the Dovahkiin Wabbajack archive metadata (may need FG Discord or `.wabbajack` file inspect).  
8. Gate to Sovngarde collection **mod count** from Nexus collection API when logged in.  
9. Whether Wabbajack will add `gameVersion` fields to registry JSON (none present 2026-07-12).  
10. Hands-on fork tests — this document is **desk research only**; removability scores are inferred until tested.

---

## Appendix — Registry fetch notes

- Main `modlists.json` on wabbajack-tools/mod-lists contains a **subset** of all lists; full metadata pulled from per-author repos listed in `repositories.json`.
- **2026-07-12:** Polled registry JSON for all finalists — **`gameVersion` / `gameMajor` / `gameMinor` / `gamePatch` not present** in any entry. Version data sourced from readmes/changelogs.
- Featured SE lists (2026-07-11): includes LoreRim, Wildlander, Keizaal, NGVO, Apostasy, Anvil, Nordic Souls, NEFARAM, Gate to Sovngarde (via SkyrimUnificationProject entry separate), Tempus Maledictum (main json), Living Skyrim, Phoenix Flavour, SME, FILFY, Twisted Skyrim, Elysium.
- **Phoenix Flavour** is Wabbajack (v4.20, 901 archives) — not guide-only; smaller than Keizaal; no full AE integration.
- **NGVO registry quirk:** `biggie-boss/NGVO/main/modlists.json` currently lists **Do Not Go Gentle** (Requiem), not NGVO — NGVO version/readme from `biggie-boss/NGVO` README; featured index points to `GhoulifiedReality/NGVO` (repo 404 at fetch time).

---

*Document path: `modlist/wabbajack-foundation-evaluation-2026-07-11.md`*  
*Revised: 2026-07-12 (Requiem + 1170 hard filters)*
