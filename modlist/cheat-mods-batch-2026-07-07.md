# Cheat-mod batch vet (2026-07-07)

Identification and risk assessment only — **nothing in this batch was enabled**
(task-0032). Source: 22 folders copied from another modlist into
`D:\Skyrim AI Modlist\Anvil\mods\` (Lazy Modlist Rename `[NoDelete]` prefix
stripped 2026-07-07). Slot **086.022** was not in the rename batch.

## Profile status

| Check | Result |
|---|---|
| MO2 instance | `D:\Skyrim AI Modlist\Anvil` |
| Profile | `Anvil - Main Profile` |
| Listed in `modlist.txt` | **None** of the 22 — not enabled, not disabled; folders exist on disk only |
| Listed in `plugins.txt` | **None** |
| Active plugins (profile) | 343 (per task-0030 rollback notes) |

Refresh MO2 after external folder edits so `modlist.txt` is not overwritten
on exit.

## Conflict-audit baseline (tasks 0004–0007, 0012)

Perks, leveled lists, globals, and GameSettings were individually audited and
confirmed healthy **without** this batch. Enabling mods below that edit perks,
LLs, globals, or GameSettings would introduce **new** categories of winners
outside the audited baseline — flag those explicitly.

## Shared Anvil overlap (redundancy)

| Existing Anvil mod | Batch mods that overlap |
|---|---|
| **Modex — A Mod Explorer Menu (AddItemMenu)** | Skyrim Cheat Engine (full item/spell/perk/shout/NPC spawn menus) |
| **Debug Menu — In-Game Navmesh Viewer and More** | NPC Stats Editor, In-Game Equipment Editor, Skyrim Cheat Engine |
| **Survival Mode Improved + CC Survival Mode** | All “Infinite * Out of Combat” mods; Handy Crafting carry-weight bypass; Smart Harvest carry-weight waiver |
| **UIExtensions, JContainers AE, SPID, KID, BOS, PapyrusUtil, PO3 Papyrus Extender, powerofthree's Tweaks** | Satisfy deps for several batch mods (notably Skyrim Cheat Engine, Handy Crafting, Infinite Horse Stamina) |
| **Open Animation Replacer** (DAR legacy folders) | Soarin' Over Skyrim lists DAR as a requirement; OAR may suffice — still untested on this list |
| **JS Dragon Claws AE** | Cosmetic claws only; no conflict with Dragon Claws Auto-Unlock puzzle logic |

No Smart Cast base mod ([LE 43123](https://www.nexusmods.com/skyrim/mods/43123) +
[SSE patch 32847](https://www.nexusmods.com/skyrimspecialedition/mods/32847)) in
the profile — Turbo file alone is non-functional.

## Per-mod risk table

Nexus links use verified `modid=` from each folder's `meta.ini`.

| Mod (folder name) | Nexus | What it does | Type | Maint. | Masters / deps vs Anvil | Broad record conflict risk | Redundancy | Verdict |
|---|---|---|---|---|---|---|---|---|
| Detect Levers and Keys | [77938](https://www.nexusmods.com/skyrimspecialedition/mods/77938) | Detect Life–style spell highlighting levers, chains, keys | `DetectLever.esp` + SKSE scripts | Abandoned (LE port, 2022; author: no further work planned) | Skyrim.esm only; SKSE | **Low** — isolated spell quest/perk; v1.3 may touch **LeveledItem** for spell tomes | None | **Needs review** — exploration cheat; minor LL risk vs audited baseline |
| Dragon Claws Auto-Unlock | [47329](https://www.nexusmods.com/skyrimspecialedition/mods/47329) | Auto-solve claw doors when claw in inventory (perk + entry point) | `Dragon Claws Auto-Unlock.esp` | Abandoned (2021) | Skyrim.esm, Update, Dragonborn | **None** (author: no vanilla record edits) | Overlaps Puzzle Solver / Puzzle Pillar Auto-Solve | **Needs review** — pick at most one puzzle-skip approach |
| Handy Crafting and Spells | [59258](https://www.nexusmods.com/skyrimspecialedition/mods/59258) | Cloud crafting storage, autostore, teleport, sell chest, BoH | `IA710_HandyCraftingAndSpells.esp` (ESPFE) + heavy scripts; KID + FLM ini | **Active** (v4.0, 2026-05) | SKSE, SkyUI, PapyrusUtil, KID, BOS, UIExtensions — **all present**; bundled Ordinator/Hunterborn/LotD/CC script patches — **targets not in profile** | **High** — overrides vanilla/CC **container and planter scripts**; carry-weight buff; merchant integration perk; KID keyword injection; not a simple isolated feature | None exact; philosophically opposite Survival encumbrance | **Do not enable** — script surface + economy bypass; MO2 priority must win all conflicts |
| In-Game Equipment Editor SE | [23615](https://www.nexusmods.com/skyrimspecialedition/mods/23615) | Edit/copy equipment stats on dropped gear (transmog/balance cheat) | `EquipmentStateCopy&Rename.esl` | Abandoned (2020) | Skyrim.esm; PO3 Papyrus Extender **present** | **Low** at plugin layer — runtime property copies (200-item cap) | Debug Menu / console | **Needs review** — save-persisted stat edits; dev-tool overlap |
| Infinite Enchantment Charges | [7054](https://www.nexusmods.com/skyrimspecialedition/mods/7054) | Near-infinite weapon/staff charge on equip | `infiniteCharge.esp` (ESL) | Maintained (2023) | Skyrim.esm; SKSE for pillar rename only | **Low** — adds spells/MGEF; places tomes in College (cell edit) | Scrambled Bugs has enchantment-cost fix (different axis) | **Needs review** — combat/economy cheat; minor world edit |
| Infinite Horse Stamina OOC | [70181](https://www.nexusmods.com/skyrimspecialedition/mods/70181) | Infinite horse stamina outside combat | `InfiniteHorseStaminaOutofCombat.esp` + SPID `_DISTR.ini` | Abandoned (2022) | Skyrim.esm, Dawnguard; **SPID present** | **Low** — SPID spell on `ActorTypeHorse` | None | **Needs review** — clashes with Survival travel friction |
| Infinite Magicka OOC | [78425](https://www.nexusmods.com/skyrimspecialedition/mods/78425) | Free spellcasting OOC (not raised max magicka) | `Infinite Magicka Out of Combat.esp` (ESL) | Abandoned (2022) | Skyrim.esm, Dawnguard | **Low** — perk/MGEF only (author: scriptless) | None | **Needs review** — Survival / magic cost philosophy |
| Infinite Shouting OOC | [88819](https://www.nexusmods.com/skyrimspecialedition/mods/88819) | No shout cooldown OOC | `Infinite Shouting Out of Combat.esp` (ESL) | Abandoned (2023) | Skyrim.esm, Dawnguard | **Low** | Thunderchild / shout overhauls (not in profile) | **Needs review** |
| Infinite Stamina OOC | [70134](https://www.nexusmods.com/skyrimspecialedition/mods/70134) | Infinite stamina OOC (sprint variant optional) | `Infinite Stamina Out of Combat.esp` (ESL) | Abandoned (2022) | Skyrim.esm, Dawnguard | **Low** | Survival movement costs | **Needs review** — author notes Thunderchild altar conflict |
| Jewelry of Power | [19566](https://www.nexusmods.com/skyrimspecialedition/mods/19566) | Craftable faction-themed OP jewelry (Unlocked FOMOD installed) | `Jewelry Of Power.esp` | Maintained (2024) | Skyrim.esm, Update, Dawnguard | **Low** — crafted items + recipes; **no LL distribution** (Nexus) | Gemling Queen / other jewelry on list are separate | **Needs review** — power creep; unlocked version skips quest gates |
| No Enchantment Restriction SKSE Remake | [34175](https://www.nexusmods.com/skyrimspecialedition/mods/34175) | Unlock enchantment slot/type rules via SKSE | `NoEnchantmentRestrictionRemake.dll` only | Stale (2022; installed **3.0.1 NG**, meta newest **3.0.0 AE**) | SKSE + Address Library (standard on list) | **None** in records — runtime hook | None | **Needs review** — strong enchanting bypass; verify DLL variant vs 1.6.1170 |
| Puzzle Pillar Auto-Solve | [125875](https://www.nexusmods.com/skyrimspecialedition/mods/125875) | Vanilla puzzle-pillar scripts start solved | **Script overrides only** (11 `.pex`, no ESP) | Recent (2024) | None | **None** — replaces `.pex` on vanilla script names | Puzzle Solver, Dragon Claws Auto-Unlock | **Needs review** — dungeon skip; MO2 must load after any mod shipping same script names |
| Puzzle Solver | [28516](https://www.nexusmods.com/skyrimspecialedition/mods/28516) | Shout opens claw doors + solves pillar puzzles in radius | `PuzzleSolver.esp` | Abandoned (2019) | Skyrim.esm | **Low** — shout + quest script | Other puzzle-skip mods | **Needs review** — redundant with pillar auto-solve |
| Reading Is Bad SKSE | [92524](https://www.nexusmods.com/skyrimspecialedition/mods/92524) | Mass-mark books read in radius (DLL scan) | `ReadingIsBad.esp` + `ReadingIsBad.dll` | **Active** (2024) | Skyrim.esm; CommonLib NG | **None** | None | **Needs review** — QoL cheat; safe install/remove per author; load before Lux if enabled |
| RMX Actor Value Book | [157037](https://www.nexusmods.com/skyrimspecialedition/mods/157037) | MCM book: stats, perks, skills, **GameSettings**, quick unlock, crafting chests | `RMXActorValueBook.esp` + scripts | **Active** (v1.7 patch, 2025-11) | Skyrim.esm + DLC masters | **Very high** — **GameSetting** toggles (26 options), perk points, dragon souls, carry weight, regen rates, shout cooldown; auto-granted book on new game | Modex / Debug Menu / entire batch of “infinite” mods | **Do not enable** — stomps audited Global/GameSetting baseline; meta says v1.7 is **patch only** needing v1.6 main — verify install completeness before any test |
| Signature Equipment | [16190](https://www.nexusmods.com/skyrimspecialedition/mods/16190) | Weapons/armor scale with use (kill/use tracking) | `SignatureEquipment.esp` + scripts | Abandoned (2022) | Skyrim.esm, Update | **Low** at record level — runtime stat mutation on instances | Requiem-style fixed tiers (if added later) | **Needs review** — power creep; persistent instance edits |
| Skyrim Cheat Engine | [70159](https://www.nexusmods.com/skyrimspecialedition/mods/70159) | Proteus-based spawn menu: items, spells, perks, shouts, NPCs, perk points | `Skyrim Cheat Engine.esp` + `Proteus.dll` | Stale (2023) | UIExtensions, JContainers, PO3 Extender, SkyUI — **present** | **Medium** — adds quest/MCM; grants spells; perk-point script hooks | **Modex** (near duplicate) | **Do not enable** — redundant with Modex; broad progression cheat |
| Smart Cast — Turbo | [84336](https://www.nexusmods.com/skyrimspecialedition/mods/84336) | Faster polling for Smart Cast auto-cast rules | `SmartCast_1_0.esp` | Abandoned (2023) | **Requires Smart Cast + SSE patch 32847 — not installed** | Depends on base mod records | N/A | **Do not enable** — **missing hard dependency** |
| Smart Harvest NG AutoLoot | [37091](https://www.nexusmods.com/skyrimspecialedition/mods/37091) | Auto-loot/harvest/mine; carry-weight waiver; cosave timeline | `SmartHarvestSE.esp` + `SmartHarvestSE.dll` (v6.3.4) | **Active** (2026-02) | SKSE, SkyUI; scans **entire load order** for loot taxonomy | **High indirect** — no classic LL merge, but DLL reads all plugins; carry-weight SPEL; economy/loot flood | None in profile (no autoloot mod today) | **Do not enable** without staged test — known CTD history; Survival/encumbrance clash; cosave bloat |
| Soarin' Over Skyrim | [49160](https://www.nexusmods.com/skyrimspecialedition/mods/49160) | Toggle levitation spell/power (invisible platform + hover anims) | `Levitate Toggle-able Spell.esp` | Abandoned (2021; installed **1.4.6** vs meta newest **1.4.2**) | Skyrim.esm, Update; **DAR required** (page) — OAR present, not verified | **Low** — spell/MGEF | None | **Do not enable** — movement/exploration break; confirm DAR/OAR conditions; mid-game uninstall unsafe per author |
| Summon Shadow MERCHANT | [2177](https://www.nexusmods.com/skyrimspecialedition/mods/2177) | Summon 30k-gold merchant + vampire wine | `SummonShadowMERCHANT.esp` | **Ancient** (2016 SE port) | Skyrim.esm only | **Low** — isolated NPC/spell | Handy sell / cheat economy mods | **Needs review** — stale; economy cheat |
| NPC Stats Editor | [178712](https://www.nexusmods.com/skyrimspecialedition/mods/178712) | DLL menu to edit NPC base stats/classes | `NPCStats.dll` only | **Active** (2026-04) | SKSE | **None** in load order — runtime NPC edits | Debug Menu | **Needs review** — dev tool; mid-save NPC edits are hard to undo |

## Highlights (executive)

**Do not enable without explicit staged review**

- **Skyrim Cheat Engine** — duplicates **Modex**; grants perks/items/NPCs at scale.
- **RMX Actor Value Book** — **GameSetting** and progression cheats; conflicts the task-0012 global/GameSetting audit baseline; confirm main-file vs patch-only install.
- **Handy Crafting and Spells** — large script override footprint + crafting/economy/teleport bypass.
- **Smart Harvest NG AutoLoot** — load-order-wide loot automation; Survival/weight clash; heavy DLL/cosave footprint.
- **Smart Cast Turbo** — **broken install** until Smart Cast + SSE patch are added.
- **Soarin' Over Skyrim** — flight breaks list exploration/combat assumptions; DAR dependency unverified on OAR-only setup.

**Lower-risk QoL (still “needs review” for a Survival curated list)**

- **Detect Levers and Keys**, **Reading Is Bad SKSE** — isolated, small footprint; best candidates if any cheat QoL is desired.
- **No Enchantment Restriction** — no ESP conflicts; strong enchanting bypass only.

**Pick at most one puzzle-skip path**

- Dragon Claws Auto-Unlock, Puzzle Pillar Auto-Solve (script), Puzzle Solver (shout) — mutually redundant.

**Infinite * Out of Combat cluster**

- Four player regen + horse SPID mod — all clash with **Survival Mode Improved** design even though perk-level conflict risk is low.

## Install hygiene notes

| Mod | Issue |
|---|---|
| RMX Actor Value Book | `installationFile` is **v1.7 patch**; Nexus text says main **v1.6** required — folder contains ESP/scripts; treat as **verify before any enable test** |
| No Enchantment Restriction | Installed **NG 3.0.1**; meta `newestVersion` shows **AE 3.0.0** — confirm correct binary for 1.6.1170 |
| Soarin' Over Skyrim | Installed version **newer** than meta `newestVersion` (likely fine; note for MO2 update checks) |
| Puzzle Pillar Auto-Solve | No ESP — wins only if MO2 priority places `Scripts/` over other overrides |
| Batch slot 086.022 | Not in rename batch — if a 23rd cheat mod was expected, locate separately |

## Recommended next steps (not executed)

1. Human picks zero or one mod per **category** (puzzle skip, autoloot, spawn menu, regen cheats, flight).
2. Any enable candidate: add to MO2 profile **disabled**, run MAST scan, then spot-check xEdit for **LeveledItem / Perk / GameSetting** winners if not already covered above.
3. Delete or quarantine mods marked **do not enable** if they were copied accidentally from the donor list.

## References

- Conflict audit: tasks 0004–0007, 0012 (`modlist/decisions.md`)
- MO2 mods path: `D:\Skyrim AI Modlist\Anvil\mods\`
- Scan scripts used: `scripts/scan-cheat-batch.ps1`, `scripts/check-cheat-masters.ps1`, `scripts/count-cheat-files.ps1`
