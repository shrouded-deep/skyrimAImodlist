# JK Outskirts × Ryn's city overlap — research (2026-07-07)

Research-only pass for **task-0043 pre-install blocker**. No mods installed.

**Sources:** Nexus mod pages and patch hubs (78920, 87964, 91642, 95750, 73778, 128196, 35910, 72305, 65661), task-0041 catalog, live MO2 profile `Anvil - Main Profile`.

---

## Executive summary

| Finding | Detail |
|---|---|
| **Ryn "City Limits" beyond Whiterun** | **None published.** Only [Ryn's Whiterun City Limits (65661)](https://www.nexusmods.com/skyrimspecialedition/mods/65661) exists. Author text on [Ryn's Farms (72305)](https://www.nexusmods.com/skyrimspecialedition/mods/72305) describes future "City Limits" mods for hold-adjacent farms, but no Windhelm / Riften / Markarth / Solitude City Limits pages were found. |
| **Real overlap outside Whiterun** | **JK's Outskirts × Ryn's Farms AIO (72305)**, not a second Ryn outskirts mod. Farms near Windhelm (Brandy-Mug, Hlaalu/Hollyfrost), Riften (Snow-Shod, Merryfair), and Whiterun-adjacent (Loreius) share cells with JK Outskirts. |
| **Per-hold "pick one?"** | Only **Whiterun** has a true dual-outskirts stack (JK Outskirts + Ryn City Limits). **Patch exists (78920)** — both can run. Other holds: **install JK Outskirts + Ryn's Farms together** with hub patches; no Ryn city-limits alternative to drop. |
| **Markarth** | JK Markarth Outskirts edits Salvius / stables / Left Hand Mine. **Sarethi Farm is not in Ryn's Farms AIO** and no Ryn Markarth outskirts mod exists. **No documented JK×Ryn conflict** for the task stack; 95750 has no Ryn's Farms entry (87262 Markarth patch targets GGUNIT Markarth Outskirts, not JK's). |
| **Solitude** | No Ryn city/outskirts mod. Task-0043 does not include JK's Solitude Outskirts ([103209](https://www.nexusmods.com/skyrimspecialedition/mods/103209)). RedBag Solitude (task-0042) is the exterior layer. |
| **JK's Nightgate Inn** | **Resolved: [161218](https://www.nexusmods.com/skyrimspecialedition/mods/161218)** — listed in [35910](https://www.nexusmods.com/skyrimspecialedition/mods/35910) requirements; 35910 v5.29+ adds Nightgate patches (incl. Spaghetti Towns AIO). |
| **MO2 state (2026-07-07, re-verified)** | **Task-0042 Spaghetti migration incomplete** per [task-0042 Result](../tasks/completed/task-0042.md): `Spaghetti's Cities - AIO.esp` still active in `Anvil - Main Profile`; modular city ESPs not downloaded. **Ryn's Whiterun City Limits (65661) not installed** — no `+Ryn*` mod folder or plugin in profile. Task-0043 text ("installed by task-0042") is **incorrect**; 65661 is a **new install** during task-0043. |

---

## Per-hold table

| Hold | JK mod (task-0043) | Ryn mod(s) in scope | Patch hub | JK × Ryn coexist? | Recommendation |
|---|---|---|---|---|---|
| **Whiterun** | [JK's Whiterun Outskirts (78351)](https://www.nexusmods.com/skyrimspecialedition/mods/78351) | [Ryn's Whiterun City Limits (65661)](https://www.nexusmods.com/skyrimspecialedition/mods/65661) — **not yet in MO2** | [78920](https://www.nexusmods.com/skyrimspecialedition/mods/78920) Whiterun Exteriors (JK × Ryn × Capital × HS) | **Yes — patch exists** | **Install both** + CWE (37982) + 78920 FOMOD (select JK, Ryn, Capital Whiterun, Spaghetti Whiterun when modular). Also pair [Ryn's Halted Stream (73907)](https://www.nexusmods.com/skyrimspecialedition/mods/73907) per author narrative. |
| **Windhelm** | [JK's Windhelm Outskirts (86975)](https://www.nexusmods.com/skyrimspecialedition/mods/86975) | **No City Limits.** [Ryn's Farms AIO (72305)](https://www.nexusmods.com/skyrimspecialedition/mods/72305) — Brandy-Mug, Hlaalu/Hollyfrost farms | [87964](https://www.nexusmods.com/skyrimspecialedition/mods/87964) — **Ryn's Farms** patch | **Yes — patch exists** | **Install both.** Run 87964 FOMOD → Ryn's Farms. [128196](https://www.nexusmods.com/skyrimspecialedition/mods/128196) optional: Unique Windhelm Farmhouses patch if that mod is added later. CWE (42990): load `WindhelmSSE.esp` after Ryn's Farms per 128196 FAQ. |
| **Riften** | [JK's Riften Outskirts (90864)](https://www.nexusmods.com/skyrimspecialedition/mods/90864) | **No City Limits.** Ryn's Farms — Snow-Shod, Merryfair | [91642](https://www.nexusmods.com/skyrimspecialedition/mods/91642) — **Ryn's Farms** patch | **Yes — patch exists** | **Install both.** Run 91642 FOMOD → Ryn's Farms. Crossed Daggers (168629) has its own JK Riften Outskirts patch — stack after 91642. If Riften Extension Southwoods/Northshore ever added, use [128196](https://www.nexusmods.com/skyrimspecialedition/mods/128196) instead of outdated 73778 patches. |
| **Markarth** | [JK's Markarth Outskirts (93006)](https://www.nexusmods.com/skyrimspecialedition/mods/93006) | **No City Limits.** Ryn's Farms has **no Markarth-hold farm** in AIO | [95750](https://www.nexusmods.com/skyrimspecialedition/mods/95750) — **no Ryn's Farms patch listed** | **No direct conflict identified** | **Install both** JK Outskirts + Ryn's Farms AIO. Run 95750 for UM/UME/Lux Via/Northern Roads/etc. No pick-one decision. In-game QA near Salvius if clipping appears. |
| **Solitude** | *(not in task-0043)* — [JK's Solitude Outskirts (103209)](https://www.nexusmods.com/skyrimspecialedition/mods/103209) exists separately | **None** | N/A for JK×Ryn | N/A | **No decision.** Task installs RedBag (42052) for city exterior; full Ryn catalog + JK interiors only. |

---

## Nexus search log (Ryn city limits / outskirts)

Searches performed: `"Ryn's Windhelm"`, `"Ryn's Riften"`, `"Ryn's Markarth"`, `"Ryn's Solitude"`, `"Ryn's city limits"`, `"Ryn's outskirts"`, author Ryn2g file list, site:nexusmods `"City Limits"` + hold names.

| Query | Result |
|---|---|
| Ryn's Whiterun City Limits | [65661](https://www.nexusmods.com/skyrimspecialedition/mods/65661) — only published City Limits mod |
| Ryn's Windhelm / Riften / Markarth / Solitude City Limits | **No SSE mod pages found** |
| Ryn's city outskirts (generic) | No separate mod family; outskirts coverage is **JK's Outskirts** + **Ryn's Farms** for farm cells |
| Ryn's Farms "City Limits" note | Author: hold-adjacent farms (e.g. Whiterun Pelagia/Battleborn/Chillfurrow) live in City Limits mods; other AIO farms are in [72305](https://www.nexusmods.com/skyrimspecialedition/mods/72305) |

---

## Patch hub cross-check (task-specified hubs)

| Hub | Nexus | JK Outskirts × Ryn content |
|---|---|---|
| Whiterun Exteriors | [78920](https://www.nexusmods.com/skyrimspecialedition/mods/78920) | **Core hub.** Requires JK Whiterun Outskirts + Ryn Whiterun City Limits. JK-only, Ryn-only, and **JK+Ryn combo** patches. Also Capital Whiterun, HS Battle-Born, Lux Via, Spaghetti paths. Active (v1.7, May 2026). |
| JK Windhelm Outskirts patches | [87964](https://www.nexusmods.com/skyrimspecialedition/mods/87964) | **Ryn's Farms** patch (mix'n'match CR, landscape, navmesh). Not a Ryn City Limits patch — none exists. |
| JK Riften Outskirts patches | [91642](https://www.nexusmods.com/skyrimspecialedition/mods/91642) | **Ryn's Farms** patch (v2.0 checked). Combo patches with Enhanced Landscapes, Lux Via, Northern Roads + Ryn's Farms. |
| JK Markarth Outskirts patches | [95750](https://www.nexusmods.com/skyrimspecialedition/mods/95750) | Patches for Lux Via, CACO, Northern Roads, UM-adjacent mods, etc. **No Ryn's Farms / Ryn City Limits patch.** |
| Ryn's Official Patch Hub | [73778](https://www.nexusmods.com/skyrimspecialedition/mods/73778) | Ryn↔Ryn and misc; author does **not** patch third-party mods. **Not** the JK×Ryn outskirts hub. Some entries superseded by 128196. |
| Ryn's community patch collection | [128196](https://www.nexusmods.com/skyrimspecialedition/mods/128196) | **Ryn's Farms** patches: USSEP, LAWF, Unique Windhelm Farmhouses, Riften Extension Southwoods/Northshore, IC, Mihail Haystacks. Windhelm load-order note for CWE + Ryn's Farms. Does **not** replace 87964/91642 JK Outskirts patches. |

**Related (not in task hub list):** [87262](https://www.nexusmods.com/skyrimspecialedition/mods/87262) CACO Farm Overhaul × JK Outskirts × Ryn's Farms — only if CACO Farm Overhaul is installed. Anvil stack does not include CACO; **do not use** unless CACO is added.

---

## JK's Nightgate Inn — Nexus ID resolution

| Field | Value |
|---|---|
| **Mod** | JK's Nightgate Inn |
| **Nexus ID** | **[161218](https://www.nexusmods.com/skyrimspecialedition/mods/161218)** |
| **Author** | jkrojmal |
| **Evidence** | Listed in [35910](https://www.nexusmods.com/skyrimspecialedition/mods/35910) requirements table; 35910 changelog v5.29+ adds extensive Nightgate patches; [Welcoming Inns (149239)](https://www.nexusmods.com/skyrimspecialedition/mods/149239) documents JK Nightgate compatibility; [Northern Roads (77386)](https://www.nexusmods.com/skyrimspecialedition/mods/77386) v1.38+ adds JK Nightgate patch. |
| **Install note** | Roadside inn west of Windhelm — **no hold-outskirts overlap** with Ryn City Limits or JK Outskirts. Patch via 35910 FOMOD after install. |

---

## MO2 / task-0042 verification

Checked `D:\Skyrim AI Modlist\Anvil\profiles\Anvil - Main Profile\` (modlist.txt, loadorder.txt, plugins.txt) and `mods/` folder.

| Check | Expected (task-0043) | Actual |
|---|---|---|
| Spaghetti Cities AIO → modular migration | AIO disabled; per-hold modular ESPs enabled | **`Spaghetti's Cities - AIO` still enabled** in loadorder/plugins. Modular city ESPs not present. Task-0042 status: partial (downloads blocked). |
| Ryn's Whiterun City Limits (65661) | Present from task-0042 | **Not installed** — no `+Ryn*` mod folder, no plugin in profile. Task-0043 assumption is **wrong**; install during task-0043. |
| Capital Whiterun / other city expansions | From task-0042 | **Not installed** (same download blocker as task-0042 result). |

**Implication:** Task-0043 installs remain blocked on (1) **Task-0043 approved**, (2) **task-0042 Spaghetti migration + city mod downloads**, (3) per-hold decisions below (mostly confirm "install both" — no major pick-one forks).

---

## Decisions needed from user (before installs)

### Blockers (must resolve first)

1. **Task-0043 approval** — user must say **"Task-0043 approved"** (`requires_human_review: true`).
2. **Task-0042 completion** — finish Spaghetti AIO → modular migration and city expansion downloads (see task-0044) before JK Outskirts, which conflict with Spaghetti AIO if both touch the same hold outskirts without modular setup.

### Per-city JK vs Ryn (research conclusion)

| Hold | User decision needed? | Suggested default |
|---|---|---|
| **Whiterun** | **Confirm intent to run triple stack:** CWE + Ryn City Limits + JK Outskirts (78920). Not a pick-one — all three patched. | **Yes to all three** (matches task-0040/0042 stack design). |
| **Windhelm** | **No pick-one.** Confirm JK Outskirts + Ryn's Farms AIO together. | **Install both** + 87964 Ryn's Farms patch + CWE/154715 Spaghetti integration already planned. |
| **Riften** | **No pick-one.** Confirm JK Outskirts + Ryn's Farms AIO together. | **Install both** + 91642 Ryn's Farms patch + Crossed Daggers JK patch from 168629. |
| **Markarth** | **No pick-one.** No Ryn outskirts mod; minimal farm overlap. | **Install both** JK Outskirts + Ryn's Farms AIO; 95750 for non-Ryn compat. |
| **Solitude** | **None** for JK×Ryn. | N/A |

### Optional scope questions (not blockers)

- **Ryn's Whiterun City Limits:** Task assumed already installed — **confirm install** as part of task-0043 (required for 78920).
- **Ryn's Halted Stream Camp (73907):** Whiterun narrative companion to City Limits — task-0043 includes it in worldspace list; no extra JK conflict.
- **JK's Solitude Outskirts (103209):** Exists on Nexus but **excluded from task-0043** — confirm intentional (RedBag is city exterior).

---

## Install sequencing notes (for post-approval pass)

1. Complete task-0042 migration first.
2. Install Ryn's Whiterun City Limits (65661) — **new install**, not confirmation.
3. Install JK Outskirts (78351, 86975, 90864, 93006) + Ryn's Farms AIO (72305) + rest of task-0043 catalog.
4. Run patch FOMODs in order: **78920** (after CWE + Ryn CL + JK Whiterun Outskirts) → **87964 / 91642 / 95750** → **73778 + 128196** (Ryn hub last).
5. For Whiterun: select JK + Ryn + Capital + Spaghetti modular options in 78920.

---

## Research limits

- Nexus age-gates / timeouts on some author file-list pages; hold-level conclusion does not depend on them (65661 is the only City Limits hit across all search terms).
- Markarth JK×Ryn marked **no direct conflict** from mod descriptions; Salvius-area QA still recommended in-game.
- JK Nightgate 161218 inferred from 35910 requirements + third-party compat pages; direct mod page fetch timed out this session.

**No installation performed.**
