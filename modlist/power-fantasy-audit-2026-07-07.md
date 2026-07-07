# Power-fantasy audit — survival / restriction mods (2026-07-07)

**Task:** task-0033 (audit only — no MO2 changes executed)  
**Profile:** `Anvil - Main Profile` on `D:\Skyrim AI Modlist\Anvil`  
**Direction:** List curation is moving to **power fantasy**, not survival/realism. Survival Mode Improved (SMI-SKSE) and CC Survival Mode are scoped for removal pending explicit human sign-off.

---

## Executive summary

| Item | Count / note |
|---|---|
| Active survival stack | **2 MO2 mods** + **1 named patch ESP** |
| Direct SMI patch/dependency (must not orphan) | **1** (`Embers XD - Patch - Survival Mode Improved.esp`) |
| Tool-output survival reference | **1** (`PG_1.esp` — ParallaxGen; regen on Tier 2) |
| Other installed mods with **active** survival/restriction mechanics | **0** beyond the CC/SMI stack |
| Survival-adjacent / optional / cosmetic entries cataloged | **8** (see catalog below) |
| Cheat-mod batch entries whose Survival clash objection drops if SMI goes | **6** (4× Infinite OOC + Handy Crafting + Smart Harvest) |

Anvil is overwhelmingly a visuals/audio/immersion list. The **only** substantial gameplay-friction layer is **CC Survival Mode + Survival Mode Improved - SKSE**. Everything else is either cosmetic, a dormant framework, an optional Scrambled Bugs patch (all friction patches **off**), or **anti-friction** QoL.

---

## 1. Survival Mode Improved + CC Survival Mode — removal scope

### 1.1 Installed stack (profile)

| MO2 mod | Plugin(s) | Load-order notes |
|---|---|---|
| **Creation Club - Survival Mode** | `ccqdrsse001-survivalmode.esl` (+ `ccqdrsse001-survivalmode.bsa` in profile `archives.txt`) | ESL at line 8 of `loadorder.txt`. MO2 folder is a **placeholder** (meta.ini only); CC asset delivery is via CC archive / Stock Game Data, not a loose mod tree. |
| **Survival Mode Improved - SKSE** | `SurvivalModeImproved.esp` + `SurvivalModeImproved.dll` + `SKSE/Plugins/SurvivalModeImproved.ini` | Nexus 78244 v1.6.0.0. **Hard-requires** `ccqdrsse001-survivalmode.esl`. |

**Masters / requirements (SMI-SKSE):**

- `Skyrim.esm`, `Update.esm`, and DLC masters as shipped in the ESP (standard CC survival patch set).
- **`ccqdrsse001-survivalmode.esl`** — mandatory per mod page and implementation; SMI pulls CC survival forms and retunes them.
- SKSE + Address Library (already on list).
- **Do not** install legacy ESP-only “Survival Mode Improved” (56374) alongside SMI-SKSE.

**Active INI friction toggles** (`SurvivalModeImproved.ini` on disk):

| Setting | Current | Effect |
|---|---|---|
| `bDisableFastTravel` | `1` | Fast travel disabled while survival active |
| `bAutoEnableSMOnNewGame` | `0` | Survival not auto-started on new game (player must enable) |
| `bDisableCarryWeightPenalty` | `0` | Carry-weight penalty **on** |
| `bDisableDiseaseApplication` | `0` | Survival disease hit events **on** |
| Injury AV penalties | 10% / 25% / 50% | Combat injury debuffs |

### 1.2 What SMI + CC touch (conflict-audit baseline: tasks 0004–0007, 0012)

From `modlist/baseline-scan-2026-07-05.md` and task-0012 — all winners were **healthy and intentional** for survival domain:

| Record type | Winner | Count | Domain |
|---|---|---|---|
| **Global** | `SurvivalModeImproved.esp` | 27 | All `Survival_*` globals from CC esl (hunger/cold/exhaustion rates, racial tuning) |
| **FormList** | `SurvivalModeImproved.esp` | 2 | `Survival_ColdWeakRacesMajor`, `Survival_OblivionLocations` |
| **FormList** | `Embers XD - Patch - Survival Mode Improved.esp` | 1 | `Survival_WarmUpObjectsList` |
| **Armor** | `SurvivalModeImproved.esp` | 11 | Warmth ratings on armor |
| **LeveledItem** | `SurvivalModeImproved.esp` | 2 | e.g. `LItemFoodSalt(Small)` |
| **Quest** | `SurvivalModeImproved.esp` | 9 | Survival quest logic |
| **MagicEffect / Spell** | SMI + `ccqdrsse001-survivalmode.esl` | ~37 / ~45 | Needs, diseases, survival spells |
| **Perk** | `ccqdrsse001-survivalmode.esl` / USMP | 2 | CC/USMP |

**Gameplay systems enabled when survival is on (SMI-SKSE):**

- **Hunger** — stamina/attack penalties when unfed; food categories; optional food poisoning.
- **Cold** — health/movement penalties by stage; weather/season/region; warmth from armor + heat sources.
- **Fatigue (exhaustion)** — magicka/skill-rate penalties; sleep/rest bonuses; well-rested gates.
- **Fast travel** — disabled (INI).
- **Carry weight** — penalty spell active.
- **Survival diseases** — hit-event application; shrine gold offerings (remaining Papyrus).
- **Injury** — staged AV penalties after combat hits.
- **CC arrow weight** — inherited from CC survival when enabled.

**Removal impact on audited baseline:** Disabling SMI + CC survival removes all 27 Global winners and survival-domain Armor/LL/Quest/MGEF/Spell winners from the load order. No other audited category winner **depends** on those records for non-survival behavior. **ParallaxGen** output may still reference survival forms until regen (see §1.3).

### 1.3 Direct patch / dependency on Survival Mode Improved (not thematic overlap)

ASCII scan of active plugins under `Anvil/mods/` (`scripts/scan-survival-deps.ps1`, 2026-07-07):

| Plugin | MO2 folder | Relationship | Action on SMI removal |
|---|---|---|---|
| **`Embers XD - Patch - Survival Mode Improved.esp`** | Embers XD | **Hard patch** — masters SMI; wins `Survival_WarmUpObjectsList` | **Disable plugin** (FOMOD patch selected at install). Embers XD core unchanged. |
| **`PG_1.esp`** | Anvil - ParallaxGen Output | **Tool output** — references survival forms | **Regenerate** ParallaxGen on Tier 2 maintenance (same class as stale Lux masters). Not a hand patch. |
| **`unofficial skyrim special edition patch.esp`** | USSEP | Incidental string/reference scan hit | **Keep** — not an SMI patch mod. |
| **`SurvivalModeImproved.esp`** | SMI-SKSE | Self | **Disable** mod + plugin + DLL/ini. |

**No other active plugin** declares `SurvivalModeImproved.esp` as a master.

**Script-layer coupling (not a master, but review on removal):**

| Mod | Notes |
|---|---|
| **OnMagicEffectApply Replacer** | Ships optimized replacements for `Survival_HungerEatingDetection`, `Survival_PlayerMagicHitInfo`, `Survival_ResistDiseaseWatchScript`. These targeted **CC survival Papyrus** VM load. SMI-SKSE moved needs to C++; with survival removed, these overrides are **inert** but harmless. Optional cleanup when disabling SMI. |
| **Stamina of Steeds** | Bugfix when player stamina is 0 (often under survival/vampire). **No master** on SMI; **keep** — still valid vanilla bugfix. |

**Disabled widescreen mods** (not in profile) contain optional SkyUI SWF patches for `SurvivalModeImproved.esp` — irrelevant while disabled.

**Not installed:** Survival Control Panel (41891), SunHelm, Frostfall, Campfire, legacy SMI ESP — no orphan risk from those.

### 1.4 Recommended removal bundle (execution — not done here)

1. Disable MO2 mods: **Survival Mode Improved - SKSE**, **Creation Club - Survival Mode** (and remove/disable CC esl + archive if fully dropping CC survival).
2. Remove **`SurvivalModeImproved.esp`** and **`Embers XD - Patch - Survival Mode Improved.esp`** from `plugins.txt` / `loadorder.txt`.
3. MAST scan — expect **`Embers XD - Patch - Survival Mode Improved.esp`** missing master if left enabled.
4. Schedule **`PG_1.esp`** regen with Tier 2 toolchain.
5. **New game / existing save:** SMI page requires new game when **first installing** SMI; removing mid-save should drop survival needs via CC teardown, but spot-test hunger/cold widgets and carry-weight spell on a backup save.
6. Review **OnMagicEffectApply Replacer** priority — optional, low priority.

---

## 2. Broader survival / restriction mod catalog

Mechanical review: `modlist.txt`, `plugins.txt`, Nexus `meta.ini`, FOMOD notes, SKSE JSON/INI — not title grep alone.

### Tier A — Active survival / friction (remove for power fantasy)

| Mod | What it does | Case for keeping | Case against (power fantasy) |
|---|---|---|---|
| **Survival Mode Improved - SKSE** | Full needs + fast-travel lock + carry/disease/injury layer (§1) | Only list-wide “hardcore” gameplay pillar; tuned vs raw CC | Constant AV penalties, travel lock, encumbrance, food/sleep/cold upkeep — core anti-power-fantasy |
| **Creation Club - Survival Mode** | CC esl/esm foundation for survival | Required for SMI; hot stews CC content | Enables entire friction stack; no reason to keep if SMI goes |

### Tier B — Direct SMI patch (remove with Tier A)

| Mod | What it does | Case for keeping | Case against |
|---|---|---|---|
| **Embers XD — Patch — Survival Mode Improved** | Adds embers/fire sources to `Survival_WarmUpObjectsList` | Correct warmth detection near modded fires | **Orphan patch** without SMI; no standalone benefit |

### Tier C — Survival-adjacent (human call)

| Mod | What it does | Case for keeping | Case against |
|---|---|---|---|
| **OnMagicEffectApply Replacer** | VM perf fix; includes 3 survival script overrides | Helps if any CC survival scripts still run | Inert after survival removal; tiny loose-script clutter |
| **Stamina of Steeds** | Restores 1 player stamina on mount if 0 | Fixes vanilla horse-sprint bug | None — **pro-power-fantasy** QoL |
| **Survival Stews - SMIM Meshes** | SMIM mesh replacer for CC hot-stew bowls | Visual polish | Meaningless without CC survival stews; safe to drop with CC survival |

### Tier D — Restriction-capable but **not actively restricting**

| Mod | What it does | Case for keeping | Case against |
|---|---|---|---|
| **Item Equip Restrictor** | SKSE framework for `RestrictEquip:` / `RestrictCast:` keywords via KID | Future curated gates (gender/skill gear) | **No `_KID.ini` rules** found in active mods — zero current friction |
| **Scrambled Bugs** (+ Vendor Respawn optional) | Engine bugfixes; **optional friction patches all disabled** in `ScrambledBugs.json` (`powerAttackStamina`, `steepSlopes`, soul-gem strictness, etc.) | Stability | No active optional friction enabled |
| **powerofthree's Tweaks** (Anvil Settings) | `Faction Stealing=false`, `Sit To Wait=false`, `Grabbing Is Stealing=false` | Already anti-friction | N/A — aligns with power fantasy |

### Tier E — Misleading keywords / **not** player restrictions

| Mod | Why listed | Verdict |
|---|---|---|
| **Bleeding Damage Fixes** (`eve - bleeding damage fixes.esp`) | “Bleeding” in name | **Buffs axe DoT** for player — power increase, not survival |
| **Alchemy XP Fix** | Crafting | Fixes vanilla XP bug — **easier** progression |
| **Scrambled Bugs — Vendor Respawn Fix** | “Vendor” | Prevents merchant **inventory reset on load** — reduces scarcity |
| **Better Combat Escape** | “Combat” | Easier escape from combat — anti-friction |
| **Barter Limit Fix / Actor Limit Fix** | “Limit” | Engine limit **bugfixes**, not gameplay gates |
| **Revert Runandwalkpaces.esp** (USMP) | GameSetting walk/run interpolation | Movement feel only — not survival |
| **Skyking Potent Potables** | “Potions” | **Meshes/textures only** — no effect changes |
| **More Realistic Fur…**, **Arctic - Frost Effects**, **Kabu's Frost Salts** | “Realistic/frost/cold” | **Visuals only** |
| **FYX - Campfire Reacts to the Wind** | “Campfire” | Embers XD companion visual — no needs |
| **Simplicity of Seeding** | Farming CC | Planter script QoL — not scarcity |

### Tier F — Hygiene note (not survival)

| Item | Issue |
|---|---|
| **`Heartbeat.esp`** | Active in `plugins.txt` but **no matching MO2 mod folder** and **no file** under `Anvil/mods/` — ghost plugin; resolve in execution pass (separate from survival). |

**Catalog count:** **12** entries across Tier A–E (2 active friction mods + 1 patch + 9 adjacent/optional/dormant). **Zero** additional hunger/thirst/cold/fast-travel/difficulty-overhaul mods (no SunHelm, Frostfall, Requiem, Adamant, etc.).

---

## 3. Cheat-mod batch re-read (task-0032)

Source: `modlist/cheat-mods-batch-2026-07-07.md`. Batch mods remain **disabled** on disk only.

### Survival clash objection **removed** if SMI goes

| Mod | Prior Survival objection | Still applies independently |
|---|---|---|
| **Infinite Stamina Out of Combat** | Nullifies survival movement/exhaustion costs OOC | Abandoned 2022; Thunderchild altar note; general regen cheat |
| **Infinite Magicka Out of Combat** | Nullifies fatigue/magicka pressure OOC | Abandoned; magic-cost bypass philosophy |
| **Infinite Shouting Out of Combat** | Shout cooldown bypass vs survival pacing | Abandoned; shout progression |
| **Infinite Horse Stamina OOC** | Travel friction bypass | Abandoned; SPID on horses |
| **Handy Crafting and Spells** | Carry-weight bypass + economy/teleport | **Do not enable** — script override surface, container/planter scripts, MO2 priority |
| **Smart Harvest NG AutoLoot** | Carry-weight waiver + encumbrance bypass | **Do not enable** — DLL/cosave footprint, CTD history, load-order-wide autoloot |

**Verdict wording change:** These six may graduate from “Survival clash” to **“power-fantasy aligned but still needs review”** for the four Infinite OOC mods and Detect Levers / Reading Is Bad tier — **not** automatic enable. Handy Crafting and Smart Harvest retain **do not enable** for non-survival reasons.

### Unchanged by Survival removal

All **do not enable** rows (Skyrim Cheat Engine, RMX Actor Value Book, Smart Cast Turbo, Soarin' Over Skyrim) — unchanged. Puzzle-skip trio redundancy unchanged.

---

## 4. Human decisions pending

1. **Confirm removal bundle** — SMI-SKSE + CC Survival esl (+ optional Survival Stews cosmetic, Embers patch, PG regen).
2. **Per Tier C items** — keep Stamina of Steeds (recommended yes); drop Survival Stews with CC survival?
3. **Cheat batch** — whether any Infinite OOC mod fits power-fantasy direction after SMI removal (staged enable + MAST/xEdit still required).
4. **Ghost plugin** — `Heartbeat.esp` cleanup.

**Execution requires explicit sign-off:** `Task-0034 approved` (see queued task-0034).

---

## References

- `modlist/cheat-mods-batch-2026-07-07.md` (task-0032)
- `modlist/baseline-scan-2026-07-05.md` (tasks 0004–0007, 0012)
- `modlist/decisions.md`
- Profile: `D:\Skyrim AI Modlist\Anvil\profiles\Anvil - Main Profile\`
- Scan: `scripts/scan-survival-deps.ps1`, output `modlist/exports/survival-scan-output.txt`
