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

### Full manual audit — Cell (task-0005)

All **13,588 Cell conflicts** individually checked (same method as
task-0004: grouped by winning plugin, every non-obvious winner
individually inspected via `conflict_tree`).

**Confirmed healthy (13,587 of 13,588):**

| Winner | Count | Why expected |
|---|---|---|
| `Occlusion.esp` | 10,695 | Generated occlusion-data output |
| `ANV_SynWorldPatcher.esp` | 1,518 | Generated Synthesis patcher output |
| `Lux.esp` | 929 | Lighting overhaul — owns the cells it relights |
| `ANV_SynW4ENBPatcher.esp` | 189 | Generated Synthesis patcher output |
| `DynDOLOD.esm` | 76 | Generated LOD output |
| `Dawnguard.esm` | 38 | DLC master override |
| `Lux - USSEP patch.esp` / `Lux - Embers XD patch.esp` / `Lux Orbis.esp` / `Lux - CC Fish patch.esp` / `Lux - Saints and Seducers patch.esp` / `Lux - SLaWF patch.esp` | 61 combined | Named Lux compatibility patches |
| `unofficial skyrim special edition patch.esp` | 13 | USSEP |
| `DynDOLOD.esp` | 19 | Generated LOD output |
| `IcyFixes.esm` | 8 | Spot-checked (cell `00385D`): standard exterior grid/landscape override, normal pattern |
| `Dragonborn.esm` / `Update.esm` / `ccbgssse001-fish.esm` / `ccbgssse025-advdsgs.esm` | 15 combined | Master/CC overrides |
| `Aspens Ablaze.esp` | 6 | Named visual mod, owns its own cells |
| `Navigator-NavFixes.esl` | 4 | Named navmesh fix, plausible for cell/navmesh conflicts |
| `Lightened Skyrim - merged.esp` | 4 | Spot-checked (cell `020EE3`): standard region/grid data carried by a merged patch, normal pattern |
| `Landscape and Water Fixes.esp` / `Landscape Fixes For Grass Mods.esp` | 3 combined | Named landscape fix mods |
| `DwemerGatesNoRelock.esl` | 2 | Named tweak, touches Dwemer ruin cells it's built for |
| `shalidor's maze fixes.esp` | 1 | Named fix, touches a Labyrinthian cell (Shalidor's Maze) |
| `man_malacathShrine.esp` | 1 | Own shrine-mod cell |
| `PraedysElderScrollSoulCairnFix.esp` | 1 | Named fix, touches a Soul Cairn cell |
| `Spaghetti's Faction Halls - AIO.esp` | 1 | Spot-checked (cell `007BC0`): adds furniture/placed objects to a Dawnguard cell, normal pattern for a content-adding mod |
| `Water for ENB (Shades of Skyrim).esp` | 1 | Named water/ENB visual patch |
| `ANV_Lux - Volkihar Soundscape Overhaul - W4ENB.esp` | 1 | Wins `DLC1VampireCastleDungeon02` — matches its name exactly |

**Needs attention (1 of 13,588):**

`McmRecorder.esp` wins cell `0BBCB2:Skyrim.esm` (editorID
`WEMerchantChests`, name "Warehouse Bookshelves") over `Update.esm`.
Inspected the full diff — this is **not** a routine field tweak:
- `NavigationMeshes` goes from 1 item (vanilla) to **0 items** in
  McmRecorder.esp's version — the cell's navmesh data is dropped.
- The cell's `Persistent` placed-reference list is swapped: vanilla has a
  reference to `00327E:Update.esm`; McmRecorder.esp's version instead
  places its own reference to `000D65:McmRecorder.esp`, a `MiscItem`
  named `McmRecorder_MessageText` (an MCM-helper debug item).

`McmRecorder.esp` is a lightweight MCM-recording/debug utility — not a
mod with any obvious reason to touch a vanilla warehouse cell's navmesh or
persistent references. This has the signature of an **accidental/dirty
edit** (e.g. the mod author had this cell open in the Creation Kit while
testing and it got saved into the distributed plugin), not an intentional
compatibility patch. Flagged as a follow-up task (task-0009) rather than
fixed here, per this task's audit-only scope.

### Not individually audited (out of scope for this baseline pass)

### Full manual audit — Armor, Weapon, ConstructibleObject, LeveledItem (task-0006)

All conflicts in these four categories individually checked: Armor (662),
Weapon (607), ConstructibleObject (36), LeveledItem (137) — **1,442
total.**

**Confirmed healthy (1,438 of 1,442):**

| Category | Winner(s) | Count | Why expected |
|---|---|---|---|
| Armor | USSEP | 474 | USSEP |
| Armor | `Update.esm` | 105 | Master override |
| Armor | `JS Unique Utopia SE - Rings - Johnskyrim.esp` + `ANV_JS Unique Utopia Rings - USSEP.esp` | 27 | Named ring mod + its USSEP patch |
| Armor | `JS Vanilla Circlets SE.esp` + `ANV_JS Vanilla Circlets - USSEP.esp` | 18 | Named circlet mod + its USSEP patch |
| Armor | USMP | 11 | USMP |
| Armor | `SurvivalModeImproved.esp` | 11 | Survival mod adding stats to armor — plausible for its domain |
| Armor | `BeardMaskFix.esp` | 5 | Spot-checked: wins only `DBArmorHelmet*` (Dark Brotherhood masks) — exact name match |
| Armor | `PraedysSkeletons.esp` | 3 | Spot-checked: wins `ClothesWarlockHoodUnplayable` variants + `DLC2MiraakSkeleton` — matches its scope |
| Armor | `ForswornRetexture Unique Armor of the Old Gods.esp` + `ANV_Xavbio's Armor of the Old Gods - USSEP.esp` | 4 | Named retexture mod + patch |
| Armor | `EnchantableSpecialItemFix_USSEP.esp` | 3 | Named fix |
| Armor | `ArcaneBlacksmithHoodFix.esp` | 1 | Spot-checked: wins `ccBGSSSE025_ClothesBlackSmith` — exact match |
| Weapon | USSEP | 517 | USSEP |
| Weapon | `Praedy's StavesAIO.esp` + `Praedystaves - USSEP patch.esp` | 64 | Named staff mod + its USSEP patch |
| Weapon | `Update.esm` / `Dragonborn.esm` | 12 | Master overrides |
| Weapon | `EnchantableSpecialItemFix_USSEP.esp` | 6 | Named fix |
| Weapon | `JS Unique Utopia SE - Daggers - Johnskyrim.esp` + `ANV_JS Unique Utopia Daggers - USSEP.esp` | 7 | Named dagger mod + patch |
| Weapon | USMP | 1 | USMP |
| ConstructibleObject | USSEP / USMP | 17 | USSEP/USMP fixing crafting recipes |
| ConstructibleObject | `Update.esm` / `HearthFires.esm` | 2 | Master overrides |
| ConstructibleObject | `Hearthfires Houses Building Fix.esp` | 11 | Named fix, all `BYOHHouseRecipe*` building-material recipes — exact match |
| LeveledItem | USSEP | 106 | USSEP |
| LeveledItem | `Update.esm` / `Dawnguard.esm` / `HearthFires.esm` / `Dragonborn.esm` | 12 | Master overrides |
| LeveledItem | USMP | 12 | USMP |
| LeveledItem | `SurvivalModeImproved.esp` | 2 | Wins `LItemFoodSalt(Small)` — matches survival-mod domain |

**Needs verification (low severity) — 4 of 1,442:**

`Lux Orbis.esp` wins 4 `LeveledItem` conflicts unrelated to its lighting
purpose: `GuardGear`, `CWSoldierImperialGear`, `CWSoldierSonsGear`,
`CWSoldierSonsGear1H`. Inspected the diff for `GuardGear`
(`100561:Skyrim.esm`): vanilla has 5 entries, Lux Orbis's version has 4 —
it removes the `12x SteelArrow` entry. This is a real content change, not
metadata noise, and the other three follow the same pattern.

Lux Orbis (Nexus id 56095) is a large, actively-maintained exterior
lighting overhaul (5M+ downloads) whose FOMOD explicitly bundles "patches
and improvements for a lot of modded content," so a gear-list tweak being
a selected FOMOD patch option is plausible — but it's still an odd thing
for a lighting mod to touch, and unlike the other findings in this audit
it isn't traceable to an obviously-named dedicated patch. Marked
"needs verification" rather than "unintentional," since it's low severity
(a guard not getting 12 arrows is a minor balance nuance, not a functional
break) and very likely intentional given the mod's popularity and scope.
Flagged as task-0010 (assigned to Cursor) to confirm via the mod's
documentation rather than treating it as a bug.

### Full manual audit — Quest, Perk, MagicEffect, Spell (task-0007)

All conflicts in these four categories individually checked: Quest (576),
Perk (151), MagicEffect (492), Spell (343) — **1,562 total.**

**Confirmed healthy — all 1,562.** Winners across all four types:

| Category | Winner(s) | Count | Why expected |
|---|---|---|---|
| Quest | USSEP | 492 | USSEP |
| Quest | `Update.esm` / `HearthFires.esm` / `Dawnguard.esm` / `Dragonborn.esm` | 50 | Master overrides |
| Quest | USMP | 12 | USMP |
| Quest | `SurvivalModeImproved.esp` | 9 | Survival mod's own quest logic |
| Quest | `AdoptionAndMovingFix.esp` | 5 | Named fix, same adoption scope as task-0004's dialogue finding |
| Quest | `OnlyOnce.esp` | 2 | Spot-checked: wins Civil War map-table scene quests it's designed to touch (adds a "RunOnce" flag) |
| Quest | `SeranaHoodFixWithAnim.esp` / `Praedy's SoulEssenceGem.esp` / `DLC2MarchoftheDeadFix.esp` / `ANV_Quick Start - SE - USSEP.esp` / `ANV_Praedy's Azura's Realm - USSEP.esp` / `ANV_Dragon dies on Touchdown - fix - USSEP.esp` | 6 | Named quest-specific fixes, each spot-checked via `conflict_tree` — see script/alias note below |
| Perk | USSEP | ~140 (bulk) | USSEP |
| Perk | `Update.esm` / `Dawnguard.esm` / `Dragonborn.esm` | 14 | Master overrides |
| Perk | `ccqdrsse001-survivalmode.esl` / USMP | 2 | CC/USMP |
| Perk | `eve - bleeding damage fixes.esp` | 6 | Named fix, all `*_EVE` bleed-damage perks — exact match |
| MagicEffect | USSEP | 396 | USSEP |
| MagicEffect | `SurvivalModeImproved.esp` / `ccqdrsse001-survivalmode.esl` | 37 | Survival mod's own effects |
| MagicEffect | `Update.esm` / `Dawnguard.esm` / `Dragonborn.esm` | 29 | Master overrides |
| MagicEffect | USMP | 19 | USMP |
| MagicEffect | `FleshFX.esp` / `LuminousAtronachs.esp` | 8 | Named visual-effect mods matching their scope |
| MagicEffect | `eve - bleeding damage fixes.esp` / `Audio Overhaul Skyrim.esp` | 3 | Named fixes |
| Spell | USSEP | ~230 (bulk) | USSEP |
| Spell | `Update.esm` / `Dawnguard.esm` / `Dragonborn.esm` | ~60 | Master overrides |
| Spell | `ccqdrsse001-survivalmode.esl` / `SurvivalModeImproved.esp` | ~45 | Survival mod's own spells/diseases |
| Spell | USMP | 5 | USMP |
| Spell | `eve - bleeding damage fixes.esp` | ~20 | Named fix, matches bleed-perk pattern above |

**Script fragment / alias override check (per task requirement):** all 7
named quest-fix winners above (`SeranaHoodFixWithAnim.esp`, `Praedy's
SoulEssenceGem.esp`, `OnlyOnce.esp` ×2, `DLC2MarchoftheDeadFix.esp`, and
the two `ANV_*-USSEP.esp` patches) do carry `VirtualMachineAdapter`
(script) and/or `Aliases` diffs against the other plugins touching the
same quest. This is expected, not a red flag: each is a purpose-built
patch whose entire job is to forward two other plugins' script/alias
changes into one winning record (that's literally what the `ANV_*-USSEP`
naming convention means on this list). No case was found where a winner
touched script fragments/aliases without an obvious reason to.

### Full manual audit — FormList, GameSettingString, Keyword, Global (task-0012)

All four remaining top-20 categories audited: FormList (40), GameSettingString
(51), Keyword (2), Global (27) — **120 total. All 120 confirmed healthy.**

**FormList (40):**

| Winner | Count | Why expected |
|---|---|---|
| `unofficial skyrim special edition patch.esp` | 22 | USSEP — diverse vanilla list fixes |
| `Update.esm` | 2 | Master override |
| `Dawnguard.esm` | 2 | DLC master override |
| `ccbgssse001-fish.esm` | 1 | CC content |
| `Audio Overhaul Skyrim.esp` | 3 | Wins `TrapGasOnHit`, `TrapGasOnEnter`, `trapGasWeapon` — AOS alters trap-gas sound/effect chains, owning these lists is expected |
| `SurvivalModeImproved.esp` | 2 | Wins `Survival_ColdWeakRacesMajor`, `Survival_OblivionLocations` — its own CC survival-mode lists |
| `Embers XD - Patch - Survival Mode Improved.esp` | 1 | Wins `Survival_WarmUpObjectsList` — named compatibility patch for exactly these two mods |
| `Unofficial Skyrim Modders Patch.esp` | 1 | USMP — `HairColorList` |
| `Landscape and Water Fixes.esp` | 2 | Wins two tavern lock-list FormLists (`FalkreathDeadMansDrinkLockList`, `SolitudeWinkingSkeeverLockList`) — named landscape/fix mod, plausible cell-object scope |
| `FacegenForKids.esp` | 1 | Wins `HeadPartsChildren` — named child-facegen fix, exact match |
| `sbbe.esp` | 3 | Wins `AAAMothPlantTypes`, `critterMothTypes`, `critterInsectsDiurnal` — confirmed via `conflict_tree`: sbbe.esp is a butterfly/moth critter variety expansion (editorIDs include `CritterMothAgraulisVanillae`, `CritterMothBattusPhilenor`, `CritterMothKaisermantel`, etc. — real butterfly species names); it adds 16+ new moth species and registers them in these critter-type FormLists so they spawn in-world. 622 total records touched by the plugin, all within its own critter domain. Note: sbbe.esp is active as a plugin but has no matching MO2 mod folder name — it is probably bundled under a differently-named folder (not investigated further here). |

**GameSettingString / Float / Int (51):**

| Winner | Count | Why expected |
|---|---|---|
| `Update.esm` | 8 | Master override — system strings and `fTemperingSkillUseMult` |
| `unofficial skyrim special edition patch.esp` | 1 | USSEP — `iDeathDropWeaponChance` |
| `Unofficial Skyrim Modders Patch.esp` | 5 | USMP — bump-reaction timers, `fSandboxCylinderBottom`, voice-file padding |
| `Revert Runandwalkpaces.esp` | 2 | Wins `fFastWalkInterpolationBetweenWalkAndRun`, `fJogInterpolationBetweenWalkAndRun` — named mod whose stated purpose is reverting run/walk pace changes; exact match |
| `XPMSE.esp` | 9 | Wins death-force physics globals (`fDeathForce*`) and `fZKeyMaxForce*` — XP32 Maximum Skeleton adjusts physics settings for its skeleton system; documented XPMSE behaviour |
| `dD - Enhanced Blood Main LITE.esp` | 10 | Wins all blood-splatter settings (`fBloodSplatter*`, `iBloodSplatterMaxCount`) — Enhanced Blood Textures mod; exact domain match |
| `MoonsAndStars.esp` | 7 | Wins moon/star fade-angle and rotation-axis settings — named sky-visual mod; exact domain match |
| `NAT-ENB.esp` | 3 | Wins `fSunDirXExtreme`, `fAutoraFadeIn/Out` — Natural and Atmospheric Tamriel weather mod; sun direction and aurora controls are its domain |
| `MoonGlowSize.esp` | 2 | Wins `iMasserSize`, `iSecundaSize` — named mod, exact match |
| `Water for ENB (Shades of Skyrim).esp` | 1 | Wins `sDefaultCubeMap` — named water/ENB mod setting its own cube-map path |

**Keyword (2):**

| Winner | Count | Why expected |
|---|---|---|
| `Audio Overhaul Skyrim.esp` | 2 | Wins `USLEEPArmorMaterialBlackguard`, `USKPArmorMaterialLinwe` (USSEP-added material keywords for Blackguard and Linwe's armors) — AOS modifies armor material keywords to point to its custom impact-sound descriptors; this is standard, documented AOS behaviour for its USSEP compatibility layer |

**Global (27):**

| Winner | Count | Why expected |
|---|---|---|
| `SurvivalModeImproved.esp` | 27 | Wins every single `Survival_*` global from `ccqdrsse001-survivalmode.esl` (hunger stages, cold levels, exhaustion rates, racial bonuses, etc.) — SurvivalModeImproved's entire purpose is tuning CC survival-mode values; winning all 27 is exactly what it is designed to do |

### Not individually audited (out of scope for this baseline pass)

All top-20 conflict categories from the original baseline are now fully audited
(task-0002 through task-0007 and task-0012). Categories outside the top-20
sample (NAVI, LAND, REFR-level cell forwarding, and other smaller record types
representing the remaining ~98k of 129,515 total conflicts) remain unaudited;
treat as a future task only if a specific problem is suspected there.

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
| Conflicts individually audited | 31,377 (Race/Faction/Class/Worldspace: 327; NPC_/Dialogue: 14,338 — task-0004; Cell: 13,588 — task-0005; Armor/Weapon/ConstructibleObject/LeveledItem: 1,442 — task-0006; Quest/Perk/MagicEffect/Spell: 1,562 — task-0007; FormList/GameSettingString/Keyword/Global: 120 — task-0012) — all top-20 conflict categories from original baseline now fully audited |
| Unintentional conflicts found | 1 (Cell) — `McmRecorder.esp` on `WEMerchantChests`, flagged as task-0009 |
| Needs verification (low severity) | 4 (LeveledItem) — `Lux Orbis.esp` gear-list edits, flagged as task-0010 |
| Bashed/Smashed patch present | No — discrepancy with documented methodology |
