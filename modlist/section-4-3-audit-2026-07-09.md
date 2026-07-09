# Section 4.3 Audit — New Quests, Worlds & Addons

**Date:** 2026-07-09  
**Donor profile:** Nolvus Awakening (read-only)  
**Section boundary:** modlist.txt lines 3128–3381 (between `+5.1 BASE TEXTURES` at 3127 and `+4.3 NEW QUESTS WORLDS & ADDONS_separator` at 3382)  
**Mods audited:** 254 enabled entries  
**Plugin baseline:** 228 / 254 active (Nolvus Awakening V6)

## Methodology

| Check | Status |
|---|---|
| `housecarl_load_order_status` on Successor | **Confirmed** — task-0003 (Claude Code, 2026-07-09); instance `E:\Nolvus\Nolvus\MO2`, profile `Successor` |
| Worldspace (WRLD) classification | **Confirmed via houseCARL** — task-0003 ran `housecarl_cross_plugin_query(type=WRLD)` against all main ESPs. See `## houseCARL WRLD verification` section for corrections. |
| Patch orphan scan | **Confirmed** — sourced from `plugins.txt` keyword scan of all 3,823 enabled plugins plus modlist.txt cross-reference for section-local patches |
| Master-record verification | **Name-based** — binary master parsing of 3,800+ plugins exceeded time budget; orphans identified via enabled plugin names and modlist patch entries |

---

## Section 4.3 mod list (254 mods found)

Mods are grouped under their parent quest/worldspace mod. Satellite folders in section 4.3 roll up to the parent row; patch orphans list enabled plugins **outside** section 4.3 that reference the parent.

### Major worldspace / quest mods

| Mod (parent + 4.3 satellites) | Main ESP/ESM | Worldspace | Removal complexity | Patch orphans (enabled plugins.txt) |
|---|---|---|---|---|
| **Beyond Skyrim — Bruma** (+ Assets, DLC Integration, Cyrodiil Patch, Misc Fixes, Ayleid Ruins HD, LOTD Synergy, 4× DBVO) — 9 mods | `BSHeartland.esm`, `BSAssets.esm` | **New** — Cyrodiil/Bruma (*pending houseCARL*) | **Complex** | `DBM_BSHeartlandPatch - Main.esp`, `QAPP - Beyond Skyrim Bruma.esp`, `Bruma Misc Fixes.esp`, `Bruma Name Patch.esp`, `BS Bruma Patch.esp`, `Missives - Heartland.esp`, `BountiesRedone_Missives_Bruma.esp`, `Northern Roads - BS Bruma Patch.esp`, `Northern Roads - BS Bruma Patch - Nolvus.esp`, `Lux`/`Lux Orbis`/`Lux Via` none for Bruma; **no SREX patch** |
| **Wyrmstooth** (+ 12 satellites: DBVO, integration, LOTD armory, fixes, textures) — 12 mods | `Wyrmstooth.esp` | **New** — Wyrmstooth island (*pending*) | **Complex** | `QAPP - Wyrmstooth Patch.esp`, `DBM_Wyrmstooth_Patch.esp`, `LOTD_TCC_Wyrmstooth.esp`, `WyrmstoothIntegration.esp`, `Missives - Wyrmstooth.esp`, `Lux - Wyrmstooth.esp`, `Lux Via - Wyrmstooth addon.esp`, `Lux Orbis - Wyrmstooth.esp`, `SunHelmWyrmstoothPatch.esp`, `Gourmet - Wyrmstooth.esp`, `Apothecary - Wyrmstooth Patch.esp`, `Northern Roads` none; **no SREX** |
| **Vigilant** (+ 42 satellites: DBVO, Xtudo, HD, textures, tweaks) — 43 mods | `Vigilant.esm` | **New** — Coldharbour + edited Skyrim cells (*pending*) | **Complex** | `QAPP - VIGILANT Patch.esp`, `DBM_Vigilant_Patch.esp`, `LOTD_TCC_Vigilant.esp`, `KRI_VIGILANT_ArtifactImmersionPatch.esp`, `3DNPC - Vigilant Patch.esp`, `Lux - Vigilant patch.esp`, `Northern Roads - Vigilant patch.esp`, `Northern Roads - Vigilant patch - Nolvus.esp`, `Gourmet - Vigilant.esp`, `YOT - Vigilant.esp`, 15+ Xtudo/Voice/NavFix plugins; **no SREX** |
| **Unslaad** (+ 8 satellites) — 9 mods | `Unslaad.esm` | **New** — Sovngarde-like realm (*pending*) | **Moderate** | `DBM_Unslaad_Display_Patch.esp`, `unslaadstartmod.esp`, `Lux - Unslaad.esp`, `YOT - Unslaad.esp`; **no SREX** |
| **The Wheels of Lull** (+ 4 satellites) — 5 mods | `WheelsOfLull.esp` | **New** — Lull worldspace (*pending*) | **Moderate** | `DBM_WheelsofLull_Patch.esp`, `LOTD_TCC_WheelsOfLull.esp`, `Lux - Legacy of the Dragonborn - Wheels of Lull.esp`; **no SREX** |
| **Falskaar** (+ 8 satellites) — 9 mods | `Falskaar.esm` | **New** — Falskaar valley (*pending*) | **Complex** | `QAPP - Falskaar Patch.esp`, `DBM_Falskaar_Patch.esp`, `LOTD_TCC_Falskaar.esp`, `Falskaar - Bruma Patch.esp`, `Missives - Falskaar Patch.esp`, `SREX_Falskaar Patch.esp`, `Lux - Falskaar patch.esp`, `SunHelm_Falskaar.esp`, `Gourmet Falskaar.esp`, `TradeRoutes-Patch-Falskaar.esp`; **SREX** |
| **Midwood Isle** (+ 13 satellites) — 14 mods | `Midwood Isle.esp` | **New** — Midwood Isle (*pending*) | **Complex** | `QAPP - Midwood Isle.esp`, `DBM_MidwoodIsle_Patch.esp`, `LOTD_TCC_MidwoodIsle.esp`, `Midwood Isle BS Bruma Patch.esp`, `Missives - Midwood Isle.esp`, `Water for ENB - Patch - Midwood Isle.esp`; **no SREX** |
| **Moonpath to Elsweyr** (+ 12 satellites) — 13 mods | `moonpath.esp` | **New** — Elsweyr segment (*pending*) | **Complex** | `QAPP - Moonpath.esp`, `DBM_Moonpath_Patch.esp`, `LOTD_TCC_Moonpath.esp`, `JRMoonpathBrumaPatch.esp`, `Moonpath - Bruma Map Marker.esp`, `KRI_Moonpath_ArtifactImmersionPatch.esp`, `SunHelm_moonpath.esp`, `Gourmet - Moonpath.esp`; **no SREX** |
| **The Gray Cowl of Nocturnal** (+ 13 satellites) — 14 mods | `Gray Fox Cowl.esm` | **New** — Hammerfell/Abagar (*pending*) | **Complex** | `DBM_TheGrayCowlofNocturnal_Patch.esp`, `LOTD_TCC_GrayCowl.esp`, `Missives - Gray Cowl Patch.esp`, `GrayCowlMissivesNoNoticeBoard.esp`, `Lux - The Gray Cowl of Nocturnal patch.esp`, `Lux - Legacy of the Dragonborn - Gray Cowl.esp`, `YOT - Gray Fox.esp`; **no SREX** |
| **SirenRoot — Deluge of Deceit** (+ 3 DBVO) — 4 mods | `evgSIRENROOT.esm` | **New** — SirenRoot region (*pending*) | **Moderate** | `DBM_HUB_SirenRoot_Patch.esp`, `LOTD_TCC_SirenRoot.esp`, `evgSIRENROOTthecausepatch.esp`, `evgSIRENROOTtraversalpatch.esp`, `Lux - Sirenroot patch.esp`; **no SREX** |
| **Clockwork** (+ Additional Clockwork, Nolvus Settings, 7 satellites) — 11 mods | `Clockwork.esp` | **Edit** — Brass Fortress interior linked to Skyrim (*pending*) | **Moderate** | `DBM_Clockwork_Patch.esp`, `LOTD_TCC_Clockwork.esp`, `lotd_clockwork_patch.esp`, `JKs Markarth Outskirts - Clockwork patch.esp`, `JKs Skyrim_Clockwork_Patch.esp`, `COTN Morthal - Clockwork Patch.esp`, `TGC Winterhold - Clockwork Patch.esp`, `Lux - Clockwork.esp`, `SunHelm_Clockwork.esp`, `YOT - Clockwork.esp`; **no SREX** |
| **The Forgotten City** (+ 8 satellites) — 9 mods | `ForgottenCity.esp` | **Edit** — Undriel interior + Skyrim edits (*pending*) | **Moderate** | `QAPP - Forgotten City.esp`, `DBM_ForgottenCity_Patch.esp`, `ForgottenCity_USSEP.esp`, `Tools of Kagrenac - Forgotten Cities patch.esp`, `Lux - Forgotten City.esp`, `SunHelm_ForgottenCity.esp`; **no SREX** |
| **Project AHO** (+ 19 satellites) — 20 mods | `Dwarfsphere.esp` | **None** — Skyrim quest (*pending*) | **Moderate** | `QAPP - Project AHO.esp`, `DwarfsphereImprovedPatch.esp`, `SunHelm_Dwarfsphere.esp`; **no SREX** |
| **Undeath** (Remastered + Classical Lichdom + 10 satellites) — 13 mods | `Undeath.esp`, `UndeathFixes.esp` | **Edit** — crypts/cells in Skyrim (*pending*) | **Complex** | `DBM_Undeath_Patch.esp`, `LOTD_TCC_Undeath.esp`, `MoonAndStar_Undeath_compat.esp`, `SREX_Skyrim Sewers Undeath Patch.esp`, `Lux - Undeath patch.esp`, `Lux Orbis - Undeath patch.esp`, `Northern Roads - Undeath patch.esp`, `Northern Roads - Undeath patch - Nolvus.esp`, 4× JKs/SSewers patches; **SREX** |
| **Moon and Star** (+ 7 satellites) — 8 mods | `MoonAndStar_MAS.esp` | **Edit** — small exterior near Riften (*pending*) | **Moderate** | `QAPP - Moon and Star.esp`, `MoonAndStar_ImmersionPatch.esp`, `SREX_MoonAndStar_MAS Patch.esp`, `Lux - Moon and Star patch.esp`, `Lux Orbis - Moon and Star.esp`; **SREX** |
| **Missives** (+ 8 section patches + Notes Retexture 3) — 12 mods | `Missives.esp` | **None** — notice-board framework (*pending*) | **Moderate** | `DBM_Missives_Patch.esp`, `SREX_Missives Patch.esp`, `BountiesRedone_MissivesExtension.esp`, per-worldspace Missives plugins (Bruma, Falskaar, Wyrmstooth, Midwood, Gray Cowl, Solstheim); **SREX** |

### Medium quest mods (no new exterior worldspace)

| Mod (parent + satellites) | Main ESP/ESM | Worldspace | Removal complexity | Patch orphans |
|---|---|---|---|---|
| **Carved Brink** (+ DBVO×2, unofficial patch) — 4 mods | `Haem Projects Goblands.esp` | **New** — Goblands (*pending*) | **Moderate** | `QAPP - Carved Brink.esp`, `Lux - Carved Brink.esp`; **no SREX** |
| **Darkend** (+ DBVO, hotfix, facegen) — 4 mods | `Darkend.esp` | **Edit** — Pale Pass cells (*pending*) | **Clean–Moderate** | `Darkend Paper Map for FWMF.esp`, `FWMF_Darkend.esp`; **no SREX** |
| **Identity Crisis** (+ DBVO, LOTD, Bruma patch) — 4 mods | `Identity Crisis.esp` | **None** — quest in Skyrim (*pending*) | **Moderate** | `Lux - Identity Crisis patch.esp`, `Lux Orbis - Identity Crisis patch.esp`; Bruma cross-patch in section 4.3 only |
| **Teldryn Serious** (+ 3 patches) — 4 mods | `TSR_TeldrynSerious.esp` | **None** — backstory quest (*pending*) | **Moderate** | `DBM_TeldrynSerious_Patch.esp`, `LOTD_TCC_TeldrynSerious.esp`, `TSR_TeldrynSeriousPatch.esp` |
| **Konahrik's Accoutrements** (+ 4 fixes/textures) — 5 mods | `konahrik_accoutrements.esp` | **None** — armor quest (*pending*) | **Moderate** | `JKs Dragonsreach/Temple/College - Konahrik` patches, `Lux - Konahrik Accoutrements.esp`, `Apothecary - Konahrik's Accoutrements Patch.esp` |
| **The Tools of Kagrenac** (+ 2 patches) — 3 mods | `Tools of Kagrenac.esp` | **None** — quest (*pending*) | **Moderate** | `LOTD_TCC_Kagrenac.esp`, `Lux - Tools of Kagrenac patch.esp`, `Lux Orbis - Tools of Kagrenac patch.esp` |
| **Curse of the Hound Amulet** (+ 3 patches) — 4 mods | `CurseOfTheHoundAmulet.esp` | **None** — quest (*pending*) | **Moderate** | `LOTD_TCC_CurseOfTheHoundAmulet.esp`, `SREX_CurseOfTheHoundAmulet.esp`, `Lux - CurseOfTheHoundAmulet patch.esp`; **SREX** |
| **Belethor's Sister** (+ 2 DBVO) — 3 mods | `Belethor's Sister.esp` | **None** — shop quest (*pending*) | **Clean** | None beyond base plugin |
| **Cheesemod for Everyone** (+ clean patch) — 2 mods | `yumcheese.esp` | **None** — micro quest (*pending*) | **Moderate** | `SREX_yumcheese.esp`, `JKEEKBelethor - Cheesemod patch.esp`; **SREX** |
| **Baba Yaga and the Labyrinth** — 1 mod | `ksws03_quest.esp` | **Edit** — labyrinth dungeon (*pending*) | **Clean** | `ksws03.esp` (companion, outside 4.3) |
| **Leaps of Faith** — 1 mod | `LeapsOfFaith.esp` | **None** — misc quest (*pending*) | **Clean** | None found |
| **Nolvus Awakening DLC Patch** — 1 mod | `Nolvus Awakening DLC Patch.esp` | N/A — meta patch | **Complex** | Masters many DLC/quest plugins; do not remove in isolation |
| **Quests Award Perk Points — Quest Patches** — 1 mod (13 plugins) | `QAPP - *.esp` (13) | N/A — perk framework | **Moderate** | Disable per-quest QAPP slice when removing that quest |

### Section 4.3 SREX patch summary

| SREX plugin | Parent mod | Notes |
|---|---|---|
| `SREX_Falskaar Patch.esp` | Falskaar | Exterior integration — **city-stack adjacent**; flag for human review |
| `SREX_MoonAndStar_MAS Patch.esp` | Moon and Star | Small exterior near Riften |
| `SREX_Missives Patch.esp` | Missives | Notice boards in holds |
| `SREX_yumcheese.esp` | Cheesemod | Minor |
| `SREX_CurseOfTheHoundAmulet.esp` | Curse of Hound Amulet | Minor |
| `SREX_Skyrim Sewers Undeath Patch.esp` | Undeath | Sewer integration |

**Bruma has no SREX patch** — removal does not touch the non-alterable city/SREX stack.

### Section 4.3 Lux / Lux Via / Lux Orbis patch summary

| Lux family plugin | Parent mod |
|---|---|
| `Lux - Wyrmstooth.esp` | Wyrmstooth |
| `Lux Via - Wyrmstooth addon.esp` | Wyrmstooth |
| `Lux Orbis - Wyrmstooth.esp` | Wyrmstooth |
| `Lux - Vigilant patch.esp` | Vigilant |
| `Lux - Unslaad.esp` | Unslaad |
| `Lux - Falskaar patch.esp` | Falskaar |
| `Lux - Forgotten City.esp` | Forgotten City |
| `Lux - Clockwork.esp` | Clockwork |
| `Lux - Carved Brink.esp` | Carved Brink |
| `Lux - Sirenroot patch.esp` | SirenRoot |
| `Lux - Identity Crisis patch.esp` | Identity Crisis |
| `Lux Orbis - Identity Crisis patch.esp` | Identity Crisis |
| `Lux - Undeath patch.esp` + Orbis + JK alternatives (3) | Undeath |
| `Lux - Moon and Star patch.esp` + Orbis | Moon and Star |
| `Lux - Tools of Kagrenac patch.esp` + Orbis | Tools of Kagrenac |
| `Lux - CurseOfTheHoundAmulet patch.esp` | Curse of Hound Amulet |
| `Lux - The Gray Cowl of Nocturnal patch.esp` + LOTD Gray Cowl | Gray Cowl |
| `Lux - Legacy of the Dragonborn - Wheels of Lull.esp` | Wheels of Lull |
| `Lux - Konahrik Accoutrements.esp` | Konahrik |

ENB is retained per `decisions.md`; Lux patches are part of non-alterable lighting infrastructure — disable alongside parent mod, not in isolation.

---

## Bruma — detailed removal assessment

**Confirmed removal candidate.** Bruma is the largest Cyrodiil worldspace addition and is not part of the SREX/city stack.

### Core plugins to disable

| Plugin | Mod folder (4.3) |
|---|---|
| `BSHeartland.esm` | Beyond Skyrim - Bruma |
| `BSAssets.esm` | Beyond Skyrim - Assets |

Plus section 4.3 satellites: DLC Integration, Cyrodiil Patch, Misc Fixes, Ayleid Ruins HD Parallax, LOTD Synergy, 4× DBVO, and any Bruma-only mesh/map mods outside 4.3 (e.g. `Beyond Skyrim Bruma Paper Map`, `Assorted Bruma Mesh Fixes`).

### Enabled patch orphans (32 plugins referencing Bruma/Heartland in plugins.txt)

**LOTD / QAPP / core fixes**
- `DBM_BSHeartlandPatch - Main.esp`
- `QAPP - Beyond Skyrim Bruma.esp`
- `Bruma Misc Fixes.esp`
- `Bruma Name Patch.esp`
- `BS Bruma Patch.esp`

**Cross-quest synergy (disable if removing Bruma; parent quests remain playable)**
- `Midwood Isle BS Bruma Patch.esp` — Midwood Isle keeps working
- `Falskaar - Bruma Patch.esp` — Falskaar keeps working
- `JRMoonpathBrumaPatch.esp`, `Moonpath - Bruma Map Marker.esp`, `Moonpath Music, Weather and Other Fixes - JRMoonpathBrumaPatch.esp` — Moonpath keeps working
- Section 4.3: `Midwood Isle - Beyond Skyrim Bruma patch fix`, `Moonpath to Elsweyr - Bruma Synergy Patch`, `Moonpath to Elsweyr - Caravan Map Marker for Bruma`, `Identity Crisis - Beyond Skyrim Brum Patch`, `Missives - Bruma Patch`, `Missives Notes Retexture - Bruma Patch`

**Framework / gameplay patches (safe to disable with Bruma)**
- `Missives - Heartland.esp`, `BountiesRedone_Missives_Bruma.esp`
- `Ordinator - Beyond Skyrim Bruma Patch.esp`, `Sunhelm_Bruma_Patch.esp`
- `Beyond Skyrim Bruma_CCOR_Patch.esp`
- `Apothecary - Bruma Patch.esp`, `Apothecary Bruma Rare Curios.esp`
- `Gourmet - Bruma.esp`, `Taberu Animation - Gourmet - Bruma Patch.esp`, `Taberu Animation - BSBruma Patch.esp`
- `Bandit War - Bruma.esp`, `YOT - Bruma.esp`
- `Embers XD - Patch - Beyond Skyrim - Bruma.esp`
- `Simplicity of Snow - BSBruma Patch.esp`, `Rainbows over Waterfalls - Bruma addon.esp`
- `Bruma Bears of the North Patch.esp`, `RSChildren Patch - BS Bruma.esp`
- `Lucien-Bruma-Patch.esp`, `Project ja-Kha'jay - Bruma - FC - Patch.esp`
- `Northern Roads - BS Bruma Patch.esp`, `Northern Roads - BS Bruma Patch - Nolvus.esp`
- `Beyond Bruma by Mirhayasu for FWMF.esp`

**Mods outside section 4.3 (modlist.txt) tied to Bruma**
- `Beyond Skyrim Bruma Paper Map`, `Assorted Bruma Mesh Fixes`, `Apothecary - Bruma Patch`, `SunHelm - Bruma Patch`, `Bears of the North - Bruma Patch`, `Lucien - Beyond Skyrim - Bruma Patch`, `Footprints - Beyond Skyrim Bruma Patch`, `Lawless - Bruma Patch`, `Complete Crafting Overhaul Remastered - Beyond Skyrim - Bruma Patch`

### Patches that touch other kept mods

| Patch | Keeps working without Bruma? | Impact |
|---|---|---|
| Midwood / Falskaar / Moonpath Bruma synergy | Yes | Lose fast-travel/map links only |
| Northern Roads - BS Bruma Patch - Nolvus | Yes | Road mesh revert to non-Bruma NR slice |
| Gourmet / Apothecary / SunHelm Bruma | Yes | Lose Bruma-region recipes/needs only |
| DBM_BSHeartlandPatch | Yes | Lose Bruma museum displays only |
| Missives - Heartland | Yes | Lose Bruma notice-board quests |

**No patch orphan exclusively blocks another major quest mod from loading.**

### SREX / Lux / ENB involvement

- **SREX:** None — Bruma removal is safe relative to the city-stack constraint.
- **Lux / Lux Orbis / Lux Via:** No Bruma-specific Lux plugins found in plugins.txt.
- **ENB:** No Bruma-only ENB dependency identified.

### Clean removal without houseCARL record edits?

**Yes.** All identified orphans are standalone patch plugins. Removal is a disable-list exercise in MO2 plus regenerating DynDOLOD/TexGen/ParallaxGen as needed for Cyrodiil border cells. No in-place ESP surgery required unless the user wants to prune dead navmesh/LOD artifacts at the border (optional, not blocking).

### Estimated plugin savings

Disabling Bruma core + identified orphans recovers **~35–40 active plugin slots** (core 2 + ~32 orphans + section satellites).

---

## Recommended removal candidates (Clean or Moderate only)

Prioritized for content-width reduction without entering Complex/SREX-heavy territory.

| Priority | Mod | Complexity | Rationale |
|---|---|---|---|
| **1 (confirmed)** | **Beyond Skyrim — Bruma** (+ Assets) | Complex overall, but **mechanically clean** | User-confirmed target; no SREX; no Lux; large worldspace savings |
| 2 | **Leaps of Faith** | Clean | Single plugin, no orphans |
| 3 | **Belethor's Sister — Quest** | Clean | Single plugin, no orphans |
| 4 | **Baba Yaga and the Labyrinth** | Clean | One plugin in 4.3; minor companion plugin outside |
| 5 | **Darkend** | Clean–Moderate | Small quest; only FWMF map orphans |
| 6 | **Cheesemod for Everyone** | Moderate | Tiny quest; one SREX + JK Belethor patch |
| 7 | **Curse of the Hound Amulet** | Moderate | SREX + Lux + LOTD; still smaller than worldspace mods |
| 8 | **Identity Crisis** | Moderate | Skyrim-only quest; Lux slices only |
| 9 | **Teldryn Serious** | Moderate | Backstory DLC-sized but no worldspace |
| 10 | **Konahrik's Accoutrements** | Moderate | Armor quest; JK/Lux patches |

**Defer (Complex — poor first cuts):** Vigilant, Wyrmstooth, Falskaar, Midwood Isle, Moonpath, Gray Cowl, Undeath, Missives framework, Nolvus DLC Patch.

**Defer (SREX involvement — needs human review per AGENTS.md):** Falskaar, Moon and Star, Missives, Cheesemod, Curse of Hound Amulet, Undeath.

---

## houseCARL WRLD verification (task-0003, 2026-07-09)

**Instance:** `E:\Nolvus\Nolvus\MO2` · **Profile:** Successor  
**Method:** `housecarl_cross_plugin_query(type=WRLD, plugins=[...], fields=[Name, EditorID])`

### Confirmed classifications (matching inference)

| Mod | Confirmed WRLD | Notes |
|---|---|---|
| Beyond Skyrim — Bruma | **New** — `BSHeartland` (Cyrodiil), Crow's Wood, Frostfire Glade, etc. | Confirmed new worldspace |
| Wyrmstooth | **New** — `WyrmstoothWorld`, `Dimfrost` | Confirmed new worldspace |
| Vigilant | **New** — Coldharbour (`zCHMolagWorld`), Stuhn Ravine, Lamae's Dream, Bruiant Estate, etc. Also edits `EldergleamSanctuaryWorld` | Confirmed; larger scope than inferred |
| Unslaad | **New** — `zzzCrbUllissWorld` (Unslaad), Lost Unslaad, Dragon's Peak, Frozen Abyss, etc. | Confirmed new worldspace |
| Falskaar | **New** — `Falskaar`, `FalskaarStargazerGroveWorld`. Also edits `RiftenWorld`. | Confirmed |
| Midwood Isle | **New** — `MidwoodIsle`, `Lastendell`, multiple Oblivion realms | Confirmed; large scope |
| Gray Cowl of Nocturnal | **New** — `mannyGFDesert` (Alik'r Desert), `mannyGFL` (Ancestral Cheetahs), `mannyGFO` (Coldharbour) | Confirmed new worldspaces |
| Clockwork | **New** — `CLWCastleExtWorld` (Clockwork Castle Grounds). Also edits Solstheim. | Confirmed; exterior grounds worldspace |
| Darkend | **New** — `XJKislandWorld` (Pharos), `XJKislandWorld2` (Forgotten Mountain), `XJKDarkendTower` | Confirmed new worldspaces |
| Moon and Star | **Edit** — `WindhelmWorld` only | Confirmed edit, no new worldspace |
| Forgotten City | **None** — no WRLD records | Confirmed no exterior worldspace |
| Project AHO | **None** — no WRLD records | Confirmed |
| Identity Crisis | **None** — no WRLD records | Confirmed |

### Corrections from inference

| Mod | Inferred | Confirmed | Impact |
|---|---|---|---|
| **Moonpath to Elsweyr** | New — Elsweyr segment | **Edit (Tamriel only)** — no dedicated worldspace, content placed in Tamriel cells | No new worldspace; removal complexity unchanged (still Complex due to patch count) |
| **Wheels of Lull** | New — Lull worldspace | **None** — no WRLD records found | Downgrade scope; interior-only world; removal remains Moderate |
| **SirenRoot (evgSIRENROOT.esm)** | New — SirenRoot region | **Edit (Soul Cairn DLC)** — only WRLD record touches `DLC01SoulCairn` | Not a new exterior; Soul Cairn content only |
| **Undeath** | Edit — crypts/cells in Skyrim | **New** — `NecroDragontailMountains` (Dragontail Mountains) | Upgrade: has exterior worldspace; removal remains Complex (SREX patch present) |
| **Carved Brink (Haem Projects Goblands)** | New — Goblands | **None** — no WRLD records | Downgrade; interior/dungeon content only; simplifies removal to Clean–Moderate |

---

## Follow-up tasks implied

1. ~~houseCARL WRLD verification~~ — **Complete** (task-0003).
2. **task-0004 (Bruma removal execution)** — build disable list from this doc; human approves. Bruma confirmed clear of SREX/Lux/ENB.
3. **Conflict re-audit** after Bruma removal (~35+ plugin changes) per AGENTS.md threshold.
