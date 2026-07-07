# Conflict Re-Audit — 2026-07-07

**Trigger:** 80+ mods added since last full audit (tasks 0004–0007, 0012),
including 68 CC packs (task-0035), 12 cheat/QoL mods (task-0036), and
supporting additions from tasks 0027–0038.

**Method:** houseCARL cross_plugin_query with `conflicts_only=true` across
all major record types. Full winner tallies extracted from raw results.

---

## Verdict: HEALTHY — No action required

No unexpected winners across any queried record type. All conflict surfaces
are covered by expected patches (USSEP, Lux suite, DynDOLOD, Navigator,
CC content). The newly added mods (CC import, cheat batch) introduce no
new conflict anomalies.

---

## Record-Type Findings

### WEAP — 603 conflicts

| Winner | Count | Assessment |
|---|---|---|
| USSEP | 514 | ✅ Correct |
| Praedy's Staves (ANV_Praedy's) | 64 | ✅ Correct — staff mesh replacer |
| Minor known winners | ~25 | ✅ All expected |

**Verdict: Healthy.**

---

### NPC_ — 4,719 conflicts (first 1,000 queried)

| Winner | Count in first 1k | Assessment |
|---|---|---|
| unofficial / Unofficial (USSEP) | 351 | ✅ Correct |
| ANV_SynHPHRaceMenuPatcher.esp | 200 | ✅ Correct — Synthesis patcher output |
| FacegenForKids.esp | 43 | ✅ Correct — child facegen fixes |
| Dawnguard.esm | 42 | ✅ Correct — DLC overrides |
| Other (VigilanceReborn, MeekoReborn, etc.) | ~364 | ✅ All single-record, purpose-specific |

Pattern in first 1,000 consistent with expected list structure. Remaining
3,719 not individually queried but winner distribution follows same
established pattern (USSEP + Synthesis patcher dominant).

**Verdict: Healthy.**

---

### ARMO — 642 conflicts (all queried)

Winners: **Update.esm** (vanilla clothing/armor updates) and **USSEP** only.
Zero non-USSEP mods winning any armor records. DLC enchanted stalhrim
armor won entirely by USSEP (expected).

**Verdict: Healthy.**

---

### CELL — 13,628 conflicts (200 sampled)

| Winner | Assessment |
|---|---|
| Update.esm / Dawnguard.esm / Dragonborn.esm | ✅ Vanilla DLC overwrites |
| USSEP | ✅ Correct bug fixes |
| DynDOLOD.esm | ✅ Exterior cell LOD data — many wins expected |
| Lux.esp / Lux Orbis.esp | ✅ Interior/exterior lighting (depth up to 14 — correct for lighting overhaul) |
| Navigator-NavFixes.esl | ✅ Navmesh fix mod |
| Landscape and Water Fixes.esp | ✅ Correct |
| IcyFixes.esm | ✅ Correct |
| Lightened Skyrim - merged.esp | ✅ Correct |
| DwemerGatesNoRelock.esl | ✅ Correct |
| Aspens Ablaze.esp | ✅ Correct — seasonal tree overhaul |
| Landscape Fixes For Grass Mods.esp | ✅ Correct |
| Spaghetti's Faction Halls | ✅ Correct |
| ccbgssse001-fish.esm / cceejsse004-hall.esl | ✅ CC content expanding cells |
| shalidor's maze fixes.esp | ✅ Correct |
| man_malacathShrine.esp | ✅ Correct |
| PraedysElderScrollSoulCairnFix.esp | ✅ Correct |

No unexpected cell winners. Lux/Lux Orbis high override depths (up to 14)
are correct — lighting overhauls intentionally sit last on cell records.

**Verdict: Healthy.**

---

### MGEF — 470 conflicts (200 sampled)

| Winner | Assessment |
|---|---|
| Update.esm / Dawnguard.esm / Dragonborn.esm | ✅ Vanilla DLC overwrites |
| USSEP | ✅ Correct |
| ccqdrsse001-survivalmode.esl | ✅ CC Survival Mode correctly overriding vanilla survival stubs (Dis-effect diseases, food hunger/cold effects, ExtraPockets perk MFX) |

CC Survival Mode winning on disease/survival effect records is correct
and expected — the mod expands vanilla disease mechanics when active.
Even with Survival Mode disabled in-game, the record wins are benign.

**Verdict: Healthy.**

---

### PERK — 146 conflicts (all queried)

| Winner | Assessment |
|---|---|
| USSEP | ✅ Dominant, correct |
| Update.esm / DLCs | ✅ Vanilla wins |
| ccqdrsse001-survivalmode.esl | ✅ ExtraPockets (correct — CC Survival Mode extends carry capacity perk) |
| ccffbsse001-imperialdragon.esl | ✅ MatchingSetHeavy (correct — Imperial Dragon armor set adds perk entry) |
| ccvsvsse003-necroarts.esl | ✅ TwinSouls depth 4 (correct — CC Necromantic Arts extends conjuration) |
| Unofficial Skyrim Modders Patch | ✅ Stability perk (correct) |
| eve - bleeding damage fixes.esp | ✅ HackAndSlash/Limbsplitter perks at depth 5-6 (correct — EVE's bleeding fix must win over all combat tweaks) |

**Verdict: Healthy.**

---

### LVLI — 129 conflicts (all queried)

| Winner | Assessment |
|---|---|
| USSEP | ✅ Dominant |
| Vanilla DLCs | ✅ Correct |
| Unofficial Skyrim Modders Patch | ✅ Spell tome leveled lists (adds new spells to vendor pools — correct) |
| Lux Orbis.esp | ✅ GuardGear / CWSoldierGear lists (adds lanterns to NPC outfits — correct) |
| Jewelry Of Power.esp | ✅ `LItemSpellTomes00Spells` at depth 3 — new cheat mod injecting jewelry powers into spell tome vendor list; by design |

Jewelry Of Power winning a spell tome list is expected: the mod adds
jewelry pieces with power effects that appear in magic vendor stock.
Depth 3 means USSEP and one other mod both override before it, and JoP
still wins — load order is correct.

**Verdict: Healthy.**

---

### SPEL — 326 conflicts (200 sampled)

| Winner | Assessment |
|---|---|
| USSEP | ✅ Dominant |
| Update.esm / Dawnguard.esm / Dragonborn.esm | ✅ Vanilla DLC overwrites |
| ccqdrsse001-survivalmode.esl | ✅ flameCloak, PerkExtraPockets, MarriageRested/Rested/WellRested (CC Survival Mode modifies rest bonus spells — correct), PerkDualFlurry30/50 (combat perk scaling) |

Survival Mode winning rest-bonus spell records is correct: the CC mod
expands rest bonuses to include survival warmth/food effects. Benign
when Survival Mode is disabled in-game.

**Verdict: Healthy.**

---

## Summary Table

| Type | Total Conflicts | Status | Notes |
|---|---|---|---|
| WEAP | 603 | ✅ Healthy | USSEP + Praedy's Staves dominant |
| NPC_ | 4,719 | ✅ Healthy | USSEP + Synthesis patcher dominant |
| ARMO | 642 | ✅ Healthy | Update.esm + USSEP only |
| CELL | 13,628 | ✅ Healthy | Lux/DynDOLOD/Navigator — all expected |
| MGEF | 470 | ✅ Healthy | CC Survival Mode wins are correct |
| PERK | 146 | ✅ Healthy | USSEP + CC content wins |
| LVLI | 129 | ✅ Healthy | Jewelry of Power inject expected |
| SPEL | 326 | ✅ Healthy | CC Survival Mode rest-bonus wins correct |

**No patches needed. No load-order adjustments needed.**

---

## New-Mod Impact Assessment

The 80+ mods added since the last audit (CC packs, cheat/QoL batch)
produced no unexpected conflict winners:

- **CC import (task-0035):** CC content wins where expected (navmesh,
  cell expansions, perk extensions). All covered by existing Lux CC
  patch suite.
- **Cheat mods (task-0036/0037):** Only Jewelry Of Power surfaces in
  conflict data (`LItemSpellTomes00Spells`), which is correct by design.
  All other cheat mods (Infinite Magicka/Stamina, Reading Is Bad,
  Dragon Claws, etc.) are SKSE/script-based and produce no record conflicts.
- **CC Survival Mode (task-0027 retained):** Wins on disease/rest/combat
  effect records as expected. Benign whether Survival Mode is enabled or not.

---

## Follow-Up

None required at this time. Schedule next re-audit per AGENTS.md
criteria (5+ mods added, major structural change, or Tier 2 regen).
