# AE / Creation Club import research (2026-07-07)

**Task:** task-0027 (research only — no installs)  
**Profile:** `Anvil - Main Profile` on `D:\Skyrim AI Modlist\Anvil`  
**Direction:** Power fantasy (see `AGENTS.md`, `modlist/power-fantasy-audit-2026-07-07.md`)  
**Scope note:** CC Survival Mode (`ccqdrsse001-survivalmode.esl`) is **retained** for the AE pass. Task-0034 removes **only** Survival Mode Improved - SKSE and its Embers patch — not the CC base mod. Disable survival gameplay in Settings → Gameplay → Survival Mode after SMI removal.

---

## Executive summary

| Category | Count |
|---|---|
| CC plugins present (enabled) | **4** (+ `_ResourcePack.esl`) |
| CC plugins absent | **69** |
| List mods already expecting absent CC | **6+** (see §5) |
| Recommended skip (power-fantasy friction) | **1** (Camping) |
| Redundancy skip / defer | **1** (CC Staves vs Praedy's Staves AIO) |
| ESM load-order slots used / free | **2 / 8** (of 10 CC `.esm` cap) |

**Anvil baseline:** Wabbajack Anvil ships only the four **free** CC packs (Fishing, Rare Curios, Survival Mode, Saints & Seducers). No other CC files appear in `Stock Game\Data\` (empty — delivery is MO2 CC placeholders + profile `archives.txt`). A full AE import requires obtaining Anniversary Upgrade files from the Steam/GOG Creations download and splitting them into MO2 mods (Curation Club plugin, AE CC File Organizer, or manual).

**Task-0034 conflict check:** **NO CONFLICT.** Removing SMI-SKSE while keeping `ccqdrsse001-survivalmode.esl` is compatible with this import plan. SMI was the friction layer; CC survival retained disabled in-game satisfies master requirements without reintroducing survival mechanics. Task-0034 should proceed when approved.

---

## 1. Inventory — already present

All four are **enabled** in `modlist.txt` (`+Creation Club - …`), active in `loadorder.txt`, and BSAs listed in `archives.txt`. MO2 folders under `Anvil\mods\Creation Club - *` are **meta.ini placeholders only** (standard Anvil CC layout).

| CC name | Plugin | BSA in archives | MO2 mod | Power-fantasy verdict |
|---|---|---|---|---|
| Fishing | `ccbgssse001-fish.esm` | Yes | Creation Club - Fishing | **Already present — keep.** Quest/content variety; Lux + Orbis CC Fish patches already active. |
| Survival Mode | `ccqdrsse001-survivalmode.esl` | Yes | Creation Club - Survival Mode | **Already present — keep.** Disable gameplay in settings; retain as AE master. Remove SMI-SKSE per task-0034. |
| Rare Curios | `ccbgssse037-curios.esl` | Yes | Creation Club - Rare Curios | **Already present — keep.** Alchemy/poison variety; CC Poison Apple texture fix installed. |
| Saints & Seducers | `ccbgssse025-advdsgs.esm` | Yes | Creation Club - Saints & Seducers | **Already present — keep.** Sheogorath quest line, gear, pets; CC footstep + mushroom retexture patches installed. |

Also present (not CC gameplay packs):

| Item | Notes |
|---|---|
| `_ResourcePack.esl` | AE resource pack; always on; line 11 of load order. |
| `Creation Club - RCPA fix.esl` | Third-party CC mesh fix; active. |
| `Creation Club Asset Patch` | Nexus 65084; FOMOD installed for Rare Curios mesh fixes only — most CC patches **not** installed (homes, etc. absent). |
| `Faithful Faces - Creation Club.esp` | Active; overhauls CC NPC faces — full benefit unlocks as CC homes/dungeons import. |
| `JS Dragon Claws AE` | AE dragon-claw meshes; independent of CC pack import. |
| `Simplicity of Seeding` | Script patch for Hearthfires + **Farming CC** planters — Farming CC (`ccvsvsse004-beafarmer.esl`) is **absent**; Hearthfires half works, Farming half dormant. |

---

## 2. Inventory — entirely absent (69 CC packs)

Source: LOOT SSE masterlist CC section (complete plugin list). All below are **absent** from `loadorder.txt`, `archives.txt`, and `Stock Game\Data\`.

### 2.1 Tier A — import (high fit; list already partially prepared)

| Rank | CC name | Plugin | Rationale |
|---|---|---|---|
| A1 | **Farming** | `ccvsvsse004-beafarmer.esl` | **Simplicity of Seeding** already installed and references this master; Lux Via patch hub has CC Farming entry; Creation Club Asset Patch documents Hearthfire-adjacent fixes. Power-fantasy base-building, not survival friction. |
| A2 | **Ghosts of the Tribunal** | `ccasvsse001-almsivi.esm` | **MLO2** whitelists this plugin in `MLO.ini`; major Solstheim dungeon + Tribunal gear; Faithful Faces CC coverage. Uses 1 of 8 free `.esm` slots. |
| A3 | **The Cause** | `ccbgssse067-daedinv.esm` | Large multi-layer dungeon, Daedric horse, weapons; strong power-fantasy spectacle. Uses `.esm` slot. |
| A4 | **Forgotten Seasons** | `cctwbsse001-puzzledungeon.esm` | Dungeon + mount + armor; Creation Club Asset Patch has mesh fix entry. Uses `.esm` slot. |
| A5 | **Umbra** | `ccbgssse016-umbra.esm` | Daedric dungeon quest + artifact sword. Uses `.esm` slot. |
| A6 | **Dead Man's Dread** | `ccbgssse031-advcyrus.esm` | Cyrus quest, weapons, naval home. Uses `.esm` slot. |
| A7 | **Necromantic Grimoire** | `ccvsvsse003-necroarts.esl` | Necromancy spell pack + robe; power-fantasy magic expansion. |
| A8 | **Arms of Chaos** | `ccpewsse002-armsofchaos.esl` | Chaos staves + amulet quest. |
| A9 | **Arcane Accessories** | `ccbgssse014-spellpack01.esl` | Robes + spells (Paralysis Rune, etc.). |
| A10 | **Arcane Archer Pack** | `ccbgssse002-exoticarrows.esl` | Elemental / telekinesis arrows; CC Asset Patch fixes bone-arrow normals. |
| A11 | **Adventurer's Backpack** | `ccfsvsse001-backpacks.esl` | 16 craftable backpacks — carry QoL aligned with power fantasy (not survival friction). |
| A12 | **Goblins** | `ccbgssse040-advobgobs.esl` | New enemies + recruitable goblin follower. |
| A13 | **Goldbrand** | `ccbgssse005-goldbrand.esl` | Artifact katana quest. |
| A14 | **Divine Crusader** | `ccmtysse001-knightsofthenine.esl` | Knights of the Nine armor + Chrysamere-adjacent power set. |
| A15 | **Spell Knight Armor** | `ccedhsse002-splkntset.esl` | Armor set + quest. |
| A16 | **Vigil Enforcer Armor Set** | `ccmtysse002-ve.esl` | Paladin armor sets + quest. |
| A17 | **Redguard Elite Armaments** | `ccedhsse003-redguard.esl` | Light armor + Boneshaver-style weapons. |
| A18 | **Shadowrend** | `ccbgssse018-shadowrend.esl` | Dual-form artifact weapon. |
| A19 | **Chrysamere** | `ccbgssse007-chrysamere.esl` | Legendary claymore. |
| A20 | **Sunder & Wraithguard** | `ccbgssse008-wraithguard.esl` | Tools of Kagrenac quest. |
| A21 | **The Gray Cowl Returns!** | `ccbgssse020-graycowl.esl` | Thief identity / Nocturnal quest. |
| A22 | **Wild Horses** | `ccbgssse034-mntuni.esl` | Mount variety + unicorn quest; complements Stamina of Steeds QoL. |
| A23 | **Pets of Skyrim** | `ccvsvsse002-pets.esl` | Multiple recruitable pets. |
| A24 | **Civil War Champions** | `ccffbsse001-imperialdragon.esl` | Faction champion armor/weapons. |
| A25 | **Expanded Crossbow Pack** | `ccffbsse002-crossbowpack.esl` | High-tier crossbows. |
| A26 | **Elite Crossbows** | `ccbgssse043-crosselv.esl` | Ebony/Elven crossbow quest. |

### 2.2 Tier B — import (homes & secondary content)

| Rank | CC name | Plugin | Rationale |
|---|---|---|---|
| B1 | **Tundra Homestead** | `cceejsse001-hstead.esm` | Player home; CC Asset Patch + Faithful Faces; uses `.esm` slot. |
| B2 | **Bloodchill Manor** | `cceejsse005-cave.esm` | Vampire player home; uses `.esm` slot. |
| B3 | **Nchuanthumz: Dwarven Home** | `ccafdsse001-dwesanctuary.esm` | Dwemer automaton home; uses `.esm` slot. |
| B4 | **Myrwatch** | `cceejsse002-tower.esl` | Mage tower home; CC Asset Patch clutter fixes. |
| B5 | **Hendraheim** | `cceejsse004-hall.esl` | Nordic hall home; CC Asset Patch. |
| B6 | **Shadowfoot Sanctum** | `cceejsse003-hollow.esl` | Thief hideout; CC Asset Patch. |
| B7 | **Gallows Hall** | `ccrmssse001-necrohouse.esl` | Necromancer home + Mannimarco artifacts. |
| B8 | **Bittercup** | `cckrtsse001_altar.esl` | Boons/adventure fork. |
| B9 | **Dawnfang & Duskfang** | `ccbgssse013-dawnfang.esl` | Dual-form sword quest. |
| B10 | **Bow of Shadows** | `ccbgssse038-bowofshadows.esl` | Assassin artifact. |
| B11 | **Lord's Mail** | `ccbgssse021-lordsmail.esl` | Imperial relic quest. |
| B12 | **Plague of the Dead** | `ccbgssse003-zombies.esl` | Night zombie encounters + loot (combat variety, not needs/cold). |
| B13 | **Ruin's Edge** | `ccbgssse004-ruinsedge.esl` | Enchanted bow. |
| B14 | **Stendarr's Hammer** | `ccbgssse006-stendarshammer.esl` | Two-handed artifact. |
| B15 | **Staff of Sheogorath** | `ccbgssse019-staffofsheogorath.esl` | Artifact staff + Fork of Horripilation. |
| B16 | **Staff of Hasedoki** | `ccbgssse045-hasedoki.esl` | Artifact staff quest. |
| B17 | **The Contest** | `ccbgssse069-contest.esl` | Fists of Randagulf + Ice Blade. |
| B18 | **Headman's Cleaver** | `ccbgssse068-bloodfall.esl` | CC Asset Patch cubemap fix. |
| B19 | **Fearsome Fists** | `cccbhsse001-gaunt.esl` | Unarmed gauntlet variants. |
| B20 | **Netch Leather Armor** | `ccbgssse041-netchleather.esl` | Light armor quest (Solstheim). |
| B21 | **Nordic Jewelry** | `ccedhsse001-norjewel.esl` | Craftable jewelry. |
| B22 | **Bone Wolf** | `ccbgssse036-petbwolf.esl` | Undead pet follower. |
| B23 | **Nix-Hound** | `ccbgssse035-petnhound.esl` | Solstheim pet. |
| B24 | **Dwarven Armored Mudcrab** | `ccbgssse010-petdwarvenarmoredmudcrab.esl` | Pet. |
| B25 | **Horse Armor - Elven / Steel** | `ccbgssse011-hrsarmrelvn.esl`, `ccbgssse012-hrsarmrstl.esl` | Cosmetic horse armor. |
| B26 | **Saturalia Holiday Pack** | `ccvsvsse001-winter.esl` | Cosmetic holiday outfit + reindeer; low priority but harmless. |

### 2.3 Tier C — import (Alternative Armors — 16 Blades-style packs)

All `.esl`; no `.esm` slot cost. List already runs extensive **armor retexture** mods (Elven, Daedric, etc.) but CC Alternative Armors add **distinct Blades-derived meshes**, not duplicates of those retextures. **Creation Club Asset Patch** fixes Iron Plate cubemaps; Daedric retexture FOMOD lists CC alt-armor patches as **not installed** — import is safe but revisit retexture FOMOD selections after CC import.

| CC name | Plugin |
|---|---|
| Alternative Armors - Daedric Mail | `ccbgssse051-ba_daedricmail.esl` |
| Alternative Armors - Daedric Plate | `ccbgssse050-ba_daedric.esl` |
| Alternative Armors - Dragon Plate | `ccbgssse059-ba_dragonplate.esl` |
| Alternative Armors - Dragonscale | `ccbgssse060-ba_dragonscale.esl` |
| Alternative Armors - Dwarven Mail | `ccbgssse062-ba_dwarvenmail.esl` |
| Alternative Armors - Dwarven Plate | `ccbgssse061-ba_dwarven.esl` |
| Alternative Armors - Ebony Plate | `ccbgssse063-ba_ebony.esl` |
| Alternative Armors - Elven Hunter | `ccbgssse064-ba_elven.esl` |
| Alternative Armors - Iron | `ccbgssse052-ba_iron.esl` |
| Alternative Armors - Leather | `ccbgssse053-ba_leather.esl` |
| Alternative Armors - Orcish Plate | `ccbgssse054-ba_orcish.esl` |
| Alternative Armors - Orcish Scaled | `ccbgssse055-ba_orcishscaled.esl` |
| Alternative Armors - Silver | `ccbgssse056-ba_silver.esl` |
| Alternative Armors - Stalhrim Fur | `ccbgssse057-ba_stalhrim.esl` |
| Alternative Armors - Steel Soldier | `ccbgssse058-ba_steel.esl` |

**Verdict:** Import as a batch during AE pass; low conflict risk with USSEP/CS; Pandora indifferent (no behavior records).

### 2.4 Skip / defer

| CC name | Plugin | Verdict | Reason |
|---|---|---|---|
| **Camping** | `ccqdrsse002-firewood.esl` | **Skip** | Survival-bundle DNA: lean-to, warmth cooking, portable fast-travel marker — friction-adjacent; conflicts with power-fantasy direction more than other CC. |
| **Staves (Creation)** | `ccbgssse066-staves.esl` | **Defer / likely skip** | **Praedy's Staves AIO** (`Praedy's StavesAIO.esp`) already active with USSEP patch — functional redundancy; Daedric retexture FOMOD also lists CC Staves patch as not installed. Import only if Praedy's is removed later. |
| **Survival Mode** | `ccqdrsse001-survivalmode.esl` | **Already present — retain, disable in-game** | Not absent; do not re-import. SMI removal (task-0034) does not remove this. |

---

## 3. Compatibility with major list mods

| System | Assessment |
|---|---|
| **USSEP / USMP** | CC content is official; USSEP documents CC support. No blocker. Quick Auto Clean CC plugins during MO2 setup (Anvil meta.ini notes). Re-run MAST after bulk import. |
| **Community Shaders** | CC adds meshes/textures; CS handles generically. No known list-wide CS blockers for CC import. |
| **Lux / Lux Orbis / Lux Via** | **Fishing CC:** Lux + Orbis CC Fish patches **already active** — keep. **Saints & Seducers:** Lux/Orbis SaS patches likely needed post-import (MLO2 migration plan notes SaS as unconfirmed). **Farming CC:** Lux Via hub has `ccvsvsse004-beafarmer.esl` patch option — install when Farming imports. **Homes/dungeons:** expect Lux patch hub FOMOD re-run for imported `.esm`/home CC; MLO2 (disabled `-Modern Lighting Overhaul 2` in modlist) whitelists GOT — revisit if MLO2 re-enabled. |
| **Pandora / Nemesis** | CC adds minimal new animation behavior; no Pandora blockers identified. CC fish/SaS already in DynDOLOD output without issues. |
| **SPID / OAR** | No list-wide requirement for CC masters beyond survival esl (retained). CC import does not force SPID/OAR changes. |
| **DynDOLOD / ParallaxGen / Synthesis** | **Tier 2 regen required** after bulk CC import (5+ mods). Current DynDOLOD output references Fishing + SaS forms only; full AE pass will stale `PG_1.esp` further (already noted for survival forms post-SMI removal). Schedule TexGen → DynDOLOD → Occlusion → Synthesis after human approves import execution. |
| **Faithful Faces CC** | Already active; benefits scale with imported CC NPC locations (homes, GOT, etc.). |
| **Embers XD** | Post task-0034: remove **Survival Mode Improved** patch only; CC survival esl retained — no Embers conflict if SMI patch removed. |

---

## 4. Nexus / list redundancy flags

| CC content | List equivalent already installed | Recommendation |
|---|---|---|
| **Staves (Creation)** | Praedy's Staves AIO + Patch Hub | Skip CC Staves unless Praedy's removed |
| **Survival Mode gameplay** | SMI-SKSE (to be removed task-0034) | Keep CC esl; remove SMI; disable survival in settings |
| **Dragon claws** | JS Dragon Claws AE | Complementary (meshes for vanilla+CC claws); not redundant |
| **Armor visuals** | Multiple `*Retexture SE` packs | Complementary to CC Alternative Armors (unique meshes) |
| **Hearthfires planters** | Simplicity of Seeding | Complements Hearthfires; **requires Farming CC** for full function |
| **Fishing** | None | Already present; Lux patches installed |

---

## 5. Ranked import plan (summary)

| Verdict | Count | Notes |
|---|---|---|
| **Already present** | 4 | Fishing, Survival (retain), Rare Curios, Saints & Seducers |
| **Import — Tier A** | 26 | Priority quests, magic, weapons, pets, mounts |
| **Import — Tier B** | 26 | Homes, secondary artifacts, pets, cosmetics |
| **Import — Tier C** | 15 | Alternative Armors batch |
| **Skip** | 1 | Camping |
| **Defer** | 1 | CC Staves (Praedy's redundancy) |

**Suggested execution order (when human approves — not in scope for this task):**

1. Obtain AE CC files from platform Creations download.
2. Split into MO2 mods (Curation Club or AE CC File Organizer).
3. Run task-0034 first (SMI removal) — **compatible, recommended before or in parallel with import prep**.
4. Import Tier A + Farming + GOT first (unblocks Simplicity of Seeding, MLO2 whitelist, Faithful Faces).
5. Import Tier B homes (watch `.esm` slot budget: 2 used, 8 free — 6 `.esm` in Tier A/B combined if all imported).
6. Import Tier C alt-armors batch.
7. Re-run Creation Club Asset Patch + Lux patch hub FOMODs for newly present CC.
8. Tier 2 toolchain regen (DynDOLOD stack + Synthesis + ParallaxGen).

---

## 6. Task-0034 conflict check

**Question:** Can task-0034 (remove SMI-SKSE + Embers SMI patch only; **keep** `ccqdrsse001-survivalmode.esl`) run immediately without disrupting AE/CC import scope?

**Answer: NO CONFLICT.**

| Criterion | Finding |
|---|---|
| AE import plan requires SMI to stay? | **No.** Plan requires CC survival **esl retained**, explicitly **not** SMI-SKSE. |
| Removing SMI blocks planned CC imports? | **No.** SMI hard-requires CC survival esl — removing SMI **reduces** friction while keeping the master for future mods. |
| Research contradicts task-0034 scope? | **No.** This research aligns with task-0034: retain CC survival, remove SMI only, disable survival in game settings. |

**Recommendation:** Task-0034 **should proceed** when the human says `Task-0034 approved`. It is a sensible prerequisite to the AE pass (drops active survival friction globals/quests from `SurvivalModeImproved.esp` while preserving CC esl for masters and optional future use).

**Stale note:** `modlist/decisions.md` task-0033 entry mentions removing CC survival esl — superseded by task-0027 / task-0034 revised scope (CC survival retained). This research and the new decisions entry reflect the current plan.

---

## 7. Methods

- `Anvil - Main Profile`: `modlist.txt`, `plugins.txt`, `loadorder.txt`, `archives.txt`
- `Anvil\Stock Game\Data\`: no loose `cc*` files (CC via MO2 archive system)
- `Anvil\mods\Creation Club - *\meta.ini`: placeholder confirmation
- Repo: `baseline-scan-2026-07-05.md`, `power-fantasy-audit-2026-07-07.md`, `mlo2-migration-plan.md`, MO2 mod FOMOD notes (Lux hubs, CC Asset Patch, Simplicity of Seeding, MLO2.ini)
- LOOT SSE masterlist CC plugin registry (complete filename ↔ content name mapping)
- UESP Creation Club catalog (74 Creations in AE)

**No execution task created** — human sign-off required before any CC import (per task-0027 acceptance criteria).
