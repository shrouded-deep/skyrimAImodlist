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

### Not individually audited (out of scope for this baseline pass)

Cell, NPC_, dialogue (INFO/DIAL), Armor, Weapon, ConstructibleObject,
LeveledItem, MagicEffect, Spell, Quest, Perk — too large to hand-check
record by record in one pass. **Recommend as follow-up tasks** (one task
per category, or per suspected problem area) if deeper conflict resolution
is wanted before further customization.

### Tiering methodology discrepancy

`modlist/load-order-notes.md` states the tiering methodology as "bashed/
smashed patches last." **This load order has neither** — no plugin named
`Bashed Patch.esp` or similar exists anywhere in the 354-plugin list. The
last plugins are Synthesis-based patchers, ParallaxGen, DynDOLOD, and
Occlusion — not a bashed/smashed leveled-list/inventory merge patch. Same
finding as the earlier (E:) pass — this is a property of the Anvil
methodology itself, not specific to one instance.

Not treating this as a bug to fix — flagging per project convention (do
not silently change tiering methodology). **Follow-up: confirm with the
user/Cursor whether a bashed or smashed patch is intentionally absent
(e.g. Synthesis modules cover its role) or genuinely missing.**

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
| Conflicts individually audited | 327 (Race/Faction/Class/Worldspace) — all healthy |
| Unintentional conflicts found | None in audited categories |
| Bashed/Smashed patch present | No — discrepancy with documented methodology |
