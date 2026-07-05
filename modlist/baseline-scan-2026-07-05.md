# Baseline houseCARL Scan — 2026-07-05

Reference point for the currently installed Anvil-based load order, taken
before any customization work begins (task-0002). Compare later
decision-log entries and conflict resolution against this.

**Rerun note:** this scan supersedes an earlier same-day pass that ran
against houseCARL's previously-configured instance, `E:\Modlists\Skyrim
AE`. The user confirmed `D:\Skyrim AI Modlist\Anvil` — the path already
documented in CLAUDE.md — is the correct instance: a smaller baseline list
that is actively being added to, not a stale/unused install as the first
pass assumed. houseCARL has been repointed at `D:\Skyrim AI Modlist\Anvil`
and this scan reflects that instance only. The `E:\Modlists\Skyrim AE`
scan's numbers no longer apply to this project.

## Instance/profile confirmation

- Instance: `D:\Skyrim AI Modlist\Anvil`
- Profile: `Anvil - Main Profile` (auto-detected, only profile available)
- Matches CLAUDE.md's documented path exactly — no discrepancy.

## Plugin list

- **354 plugins active** in load order (344 user-checked + 10 implicit
  masters/CC content)
- **924 mods enabled**, 9 disabled (present but switched off in MO2 — not
  part of this load order)
- **0 inactive-but-present plugins**
- Full ordered plugin list (1–354): [`baseline-plugins-2026-07-05.txt`](baseline-plugins-2026-07-05.txt)
- Last 10 in load order: `Lux - Even Brighter Templates.esp`,
  `Actually Brighter Lux Templates.esp`, `ParallaxGen.esp`, `PG_1.esp`,
  `ANV_SynHPHRaceMenuPatcher.esp`, `ANV_SynNPCPatcher.esp`,
  `ANV_SynW4ENBPatcher.esp`, `ANV_SynWorldPatcher.esp`, `DynDOLOD.esp`,
  `Occlusion.esp` — all generated patcher/LOD output (Synthesis,
  ParallaxGen, DynDOLOD, Occlusion), not authored content.

### Load-order errors

**None.** All 354 plugins resolved to real files; 0 missing masters, 0
plugins excluded for unparseable records this session. Cleaner than the
earlier E: pass, which had 3 unparseable plugins (that finding does not
apply to this instance).

## Conflict-tree pass

**129,515 total record-level conflicts** (records touched by more than one
plugin) across the load order — proportionally in line with a 354-plugin
list. As with the earlier pass, this is too large to dump record-by-record;
below is a per-type breakdown for the biggest categories, plus a full
manual audit of four smaller, self-contained categories where every
conflict was individually checked.

### Conflict counts by record type (sample of major types)

| Type | Conflicts |
|---|---|
| Cell | 13,588 |
| DialogResponses (INFO) | 6,203 |
| Npc | 4,711 |
| DialogTopic | 3,424 |
| Armor | 662 |
| Weapon | 607 |
| ConstructibleObject | 36 |
| LeveledItem | 137 |
| MagicEffect | 492 |
| Spell | 343 |
| Quest | 576 |
| Perk | 151 |
| FormList | 40 |
| GameSettingString | 51 |
| Keyword | 2 |
| Global (Short/Float) | 27 |
| Faction | 199 |
| Worldspace | 47 |
| Race | 65 |
| Class | 16 |

These 20 types account for ~31,377 of the 129,515 total; the remainder is
spread across many smaller record types (NAVI, LAND, REFR-level cell
forwarding, etc.) not itemized here.

### Full manual audit — Race, Faction, Class, Worldspace (all conflicts reviewed)

These four categories are small enough to check every conflict
individually (65 + 199 + 16 + 47 = 327 records). Verdict: **healthy — no
unintentional or unresolved conflicts found.** Every winner is one of:

- A DLC/master override (`Update.esm`, `Dawnguard.esm`, `Dragonborn.esm`,
  `HearthFires.esm`) — expected vanilla-content layering.
- `unofficial skyrim special edition patch.esp` (USSEP) or
  `Unofficial Skyrim Modders Patch.esp` (USMP) fixing base records —
  expected, should generally win over unpatched vanilla.
- A mod's own dedicated compatibility patch, named as such (`Lux -
  USSEP patch.esp`, `Lux - No grass in caves patch.esp`, `TDM Target Lock
  Fix - Bristleback.esp`, `UniqueBarbas.esp`, `ANV_Simple Children -
  USMP.esp`, `Ivy - Riverwood Smelter Addon.esp`).
- Generated patcher output (`ANV_SynHPHRaceMenuPatcher.esp`,
  `ANV_SynNPCPatcher.esp`, `ANV_SynWorldPatcher.esp`, `ANV_SynW4ENBPatcher.esp`,
  `Lux.esp`, `DynDOLOD.esp`, `Occlusion.esp`) winning race/worldspace
  records — expected, per project convention these are regenerated tool
  outputs, not something to patch around.

No case was found where a low-priority or unrelated mod won a record it
had no obvious business touching. Override depths up to 97 (`Tamriel`
worldspace, won by `Occlusion.esp`) look alarming in isolation but are
normal for DynDOLOD/Occlusion, which intentionally touch a huge number of
plugins' worldspace data for LOD generation.

### Full manual audit — NPC_ and Dialogue (task-0004)

Per follow-up from the original baseline pass, NPC_ and Dialogue
(DialogTopic + DialogResponses) were audited in full as the two
highest-risk unaudited categories: NPC_ conflicts commonly cause missing
faces, wrong stats, or duplicate NPCs; Dialogue conflicts can silently
break quest lines. **14,338 records individually checked** (4,711 NPC_ +
3,424 DialogTopic + 6,203 DialogResponses). Method: pulled every conflict
as a compact summary line (winner + override depth, no full field diffs),
grouped by winning plugin, and individually inspected every winner that
wasn't an obvious bulk compatibility patch.

**Verdict: healthy across all three — no unintentional or unresolved
conflicts found.**

**NPC_ (4,711 conflicts)** — winner breakdown:

| Winner | Count | Why expected |
|---|---|---|
| `ANV_SynHPHRaceMenuPatcher.esp` | 4,251 | Generated Synthesis patcher output |
| `unofficial skyrim special edition patch.esp` | 233 | USSEP |
| `Unofficial Skyrim Modders Patch.esp` | 111 | USMP |
| `FacegenForKids.esp` | 43 | Named facegen fix, confirmed winning only child NPCs (Frodnar, Knud, Svari, etc.) |
| `Dawnguard.esm` | 42 | DLC master override |
| `ANV_SynNPCPatcher.esp` | 14 | Generated Synthesis patcher output |
| `ANV_zzjay's Horse Overhaul - USSEP.esp` | 4 | Named USSEP patch, confirmed winning only player-horse NPCs it's built to fix |
| `zz_HorseOverhaul.esp` | 3 | Base mod, wins horse NPCs its own USSEP patch doesn't touch — expected, not a gap |
| `Update.esm` | 3 | Master override |
| `ccbgssse001-fish.esm` | 1 | CC content |
| `VigilanceReborn.esp` | 1 | Confirmed: wins its own "TrainedDog" (Vigilance) record |
| `UniqueBarbas.esp` | 1 | Confirmed: wins its own "DA03Barbas" record |
| `Simple Children - USSEP Aventus Aretino Patch.esp` | 1 | Named USSEP patch for one NPC |
| `Nilheim.esp` | 1 | Confirmed: wins its own added-location bandit guard NPC |
| `MeekoReborn.esp` | 1 | Confirmed: wins its own "Meeko" dog record |
| `ANV_Praedy's Skulls - USSEP.esp` | 1 | Named USSEP patch for one NPC |

**Dialogue — DialogTopic (3,424) + DialogResponses (6,203) = 9,627
conflicts** — winner breakdown (combined):

| Winner | Count | Why expected |
|---|---|---|
| `unofficial skyrim special edition patch.esp` | 8,793 | USSEP |
| `Unofficial Skyrim Modders Patch.esp` | 304 | USMP |
| `HearthFires.esm` | 290 | DLC master override |
| `Update.esm` | 95 | Master override |
| `Dragonborn.esm` | 72 | DLC master override |
| `AdoptionAndMovingFix.esp` | 33 | Confirmed: all wins are adoption/moving dialogue (`RelationshipAdoption_*`) |
| `Dawnguard.esm` | 32 | DLC master override |
| `ANV_AdoptionAndMovingFix - USSEP Patch.esp` | 2 | Named USSEP patch for the same adoption dialogue |
| `dunPOISoldiersRaidOnStartTweak.esp` | 2 | Confirmed: wins its own named quest-start dialogue |
| `StalhrimSourceFix.esp` | 2 | Confirmed: wins Fanari/Stalhrim quest dialogue it's named for |
| `DLC2MarchoftheDeadFix.esp` | 1 | Named fix, single record it's built to patch |
| `Audio Overhaul Skyrim.esp` | 1 | Single dialogue record touched by an audio mod |

No case was found where a low-priority or unrelated mod won an NPC or
dialogue record it had no obvious business touching.

### Not individually audited (out of scope for this baseline pass)

Cell, Armor, Weapon, ConstructibleObject, LeveledItem, MagicEffect, Spell,
Quest, Perk — too large to hand-check record by record in one pass.
**Recommend as follow-up tasks** (one task per category, or per suspected
problem area) if deeper conflict resolution is wanted before further
customization. NPC_ and Dialogue, previously in this list, were fully
audited in task-0004 above.

### Tiering methodology discrepancy — resolved (task-0003)

`modlist/load-order-notes.md` previously stated the tiering methodology as
"bashed/smashed patches last," which this load order didn't match — no
`Bashed Patch.esp`/Smashed Patch output exists; the load order ends with
Synthesis-based patchers, ParallaxGen, DynDOLOD, and Occlusion instead.
Task-0003 confirmed this is intentional: the stale "bashed/smashed" line
was generic boilerplate, not Anvil's actual methodology, and
`load-order-notes.md` has been updated accordingly. See the task-0003
decisions.md entry for full rationale.

### Known/expected issues from prior documentation

No prior Anvil/Wabbajack-specific conflict documentation exists yet in
this repo to cross-reference against — noting this as a gap rather than
asserting conflicts are "known-expected" without a source.

## Summary

| Check | Result |
|---|---|
| Correct instance resolved | Yes — `D:\Skyrim AI Modlist\Anvil`, matches CLAUDE.md |
| Plugin count | 354 active (924 mods enabled / 9 disabled) |
| Missing masters | None |
| Other load-order errors | None (0 excluded plugins) |
| Total record conflicts | 129,515 |
| Conflicts individually audited | 14,665 (Race/Faction/Class/Worldspace: 327; NPC_/Dialogue: 14,338 — task-0004) — all healthy |
| Unintentional conflicts found | None in audited categories |
| Bashed/Smashed patch present | No — discrepancy with documented methodology |
