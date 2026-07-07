# Decision Log

Running rationale log for this Skyrim SE modlist (built on the Anvil
Wabbajack foundation). One entry per meaningful decision — trims,
additions, load-order changes, corrections to prior assumptions. Newest
entry at the top.

---

### 2026-07-07 — AE/CC import research complete; scope locked (task-0027)

Research-only AE/CC pass scoped — **no installs executed.** Profile has **4 of 73**
CC gameplay packs (Fishing, Survival Mode, Rare Curios, Saints & Seducers) plus
`_ResourcePack.esl`; **69 absent** (full Anvil baseline = free CC only).

**Import when human approves execution:** Tier A/B/C ranked list in
[`ae-cc-import-research-2026-07-07.md`](ae-cc-import-research-2026-07-07.md) —
priority quests/dungeons/magic (GOT, Cause, Forgotten Seasons, Farming, Umbra, etc.),
homes, Alternative Armors batch. **Skip:** Camping (`ccqdrsse002-firewood.esl`).
**Defer:** CC Staves — Praedy's Staves AIO already active.

**CC Survival Mode retained** (`ccqdrsse001-survivalmode.esl`) — disable in-game after
SMI removal; not excluded from AE scope. **Task-0034 NO CONFLICT** with import plan
(SMI-only removal compatible; proceed when approved). Tier 2 regen required after
bulk import. No execution task queued — human sign-off required before imports.

---

### 2026-07-07 — Successor Additions separator in MO2 modlist (task-0038)

Added `-DLC: [Successor Additions]_separator` above Finishing Line; moved
**97** post-baseline entries (cheat batch, disabled MLO2/WSU stack, 68 imported
CC mods) under it. Baseline from
`modlist/exports/mlo2-pre-migration-2026-07-07/modlist.txt` — Pandora, original
Anvil tiers, and 4 baseline CC mods untouched. **990** enabled mods unchanged
(reorder only). `scripts/reorganize-successor-mods.ps1`.

---

### 2026-07-07 — Cheat-mod QoL batch enabled (task-0036)

Enabled **13** approved cheat/QoL mods from task-0032 batch (Infinite OOC
cluster, enchantment bypasses, Reading Is Bad, Jewelry of Power, Shadow
Merchant, Detect Levers, Equipment Editor, Signature Equipment; DLL-only:
No Enchantment Restriction NG 3.0.1, NPC Stats Editor). **Six do-not-enable
mods untouched.** MAST clean.

**Caveats:** **NPC Stats Editor** — runtime NPC edits on a mid-save save are
hard to undo. **Signature Equipment** — weapons/armor gain persistent instance
stat scaling with use (save-affecting).

---

### 2026-07-07 — Puzzle-skip cheat mods enabled (task-0037)

Enabled **Dragon Claws Auto-Unlock** (claw doors) and **Puzzle Pillar
Auto-Solve** (pillar scripts) from cheat batch; **Puzzle Solver** left off
(redundant). `Dragon Claws Auto-Unlock.esp` active after USMP; pillar mod is
script-only. MAST clean.

---

### 2026-07-07 — AE/CC content imported (68 packs; task-0035)

Executed Anniversary Upgrade CC import from Steam Data into MO2 per
[`ae-cc-import-research-2026-07-07.md`](ae-cc-import-research-2026-07-07.md).
**68** new `Creation Club - *` mods; **4** baseline packs retained unchanged
(Fishing, **Survival Mode** esl, Rare Curios, Saints & Seducers). **Skipped:**
Camping, CC Staves. Profile updated (`modlist.txt`, `plugins.txt`, `loadorder.txt`,
`archives.txt`); CC MAST **0 missing masters**. Script: `scripts/import-ae-cc.ps1`.
**Tier 2 regen + Lux/CC Asset Patch FOMOD re-run required** before treating output
plugins as current. Full log: [`ae-cc-import-execution-2026-07-07.md`](ae-cc-import-execution-2026-07-07.md).

---

### 2026-07-07 — Power-fantasy direction; Survival Mode removal scoped (task-0033)

List curation direction set to **power fantasy** (not survival/realism). **Audit only**
— nothing disabled in MO2.

**Survival stack to remove (pending sign-off):** Survival Mode Improved - SKSE +
`ccqdrsse001-survivalmode.esl` / CC archive. **Only hard patch dependency:**
`Embers XD - Patch - Survival Mode Improved.esp` (disable with SMI). **`PG_1.esp`**
(ParallaxGen output) references survival forms — regen on Tier 2, not a blocker.
**OnMagicEffectApply Replacer** ships survival script overrides — inert after removal.

**No other active restriction mods** (no SunHelm/Frostfall/Requiem/perk overhaul).
Item Equip Restrictor is installed but has **no KID rules** in profile. Scrambled Bugs
optional friction patches are **all off**. Stamina of Steeds is anti-friction QoL.

**Cheat batch (task-0032):** Survival clash objection drops for Infinite * OOC (×4),
Handy Crafting, Smart Harvest — other risk factors unchanged; not auto-approved.

Full report: [`power-fantasy-audit-2026-07-07.md`](power-fantasy-audit-2026-07-07.md).
**Execution queued as task-0034 — requires `Task-0034 approved`.**

---

### 2026-07-07 — MO2 profile script guardrails (task-0028)

After task-0022 MLO2 profile clobber, added shared `scripts/Mo2ProfileGuardrails.ps1`
(`Assert-Mo2Closed`, MLO2 repair, modlist block, snapshots) + `verify-mlo2.ps1`;
refactored `install-wsu-stack.ps1`. Rule: any script mutating `modlist.txt` /
`plugins.txt` / `loadorder.txt` must hard-stop if MO2 is running. Rollback scripts
from task-0030 brought into compliance same session. Task file was written
retroactively to `tasks/completed/task-0028.md`.

---

### 2026-07-07 — Externally-sourced cheat-mod batch vetted; none enabled (task-0032)

22 folders copied from another modlist into `Anvil/mods/` (Lazy Modlist Rename
`[NoDelete]` prefixes stripped; slot **086.022** absent). **None** appear in
`Anvil - Main Profile` `modlist.txt` or `plugins.txt` — identification/risk
assessment only.

**Do not enable without staged review:** Skyrim Cheat Engine (overlaps **Modex**),
RMX Actor Value Book (**GameSetting** / progression stomp vs task-0012 baseline),
Handy Crafting and Spells (script override + economy bypass), Smart Harvest NG
(load-order-wide autoloot + Survival clash), Smart Cast Turbo (**missing Smart Cast
base**), Soarin' Over Skyrim (flight + DAR dependency unverified on OAR list).

**Needs review if any cheat QoL wanted:** Detect Levers and Keys, Reading Is Bad,
No Enchantment Restriction, Infinite * Out of Combat cluster (Survival clash),
puzzle-skip trio (pick at most one), Jewelry of Power, Signature Equipment, others.

Full per-mod table: [`cheat-mods-batch-2026-07-07.md`](cheat-mods-batch-2026-07-07.md).

---

### 2026-07-07 — Pandora furniture/mount silence diagnosed; fix deferred (task-0029)

Live test: **chair/stool/bench sit and horse mount produce no camera change and
no animation**; TDM (headtracking, leaning, horse archery) and Community Shaders
work — not a wholesale behavior regen failure.

**Ruled out (high confidence):** `turn` WARN (`PlayerBowModList` on
`defaultfemale~1hm_behavior` only); XPMSSE double-patch (`xpmsse` absent from
`ActiveMods.json`, UBR enabled); bseaf/gmill patch failures (both applied in
`Engine.log`); missing core behavior HKX (Output present, first in MO2 priority;
only Serana FNIS behavior overrides later).

**Compiled output (ASCII scan):** `IdleFurnitureStart` / `HorseEnter` /
`to_FurnitureState` / `FurnitureState` counts match Pandora template HKX and
Nemesis SSE cache — **not** a missing-string defect. `Nemesis_Furniture*` absent
(expected without FNIS `fu` mods). Nemesis `behavior templates/fu/` lives only
in the **disabled** Nemesis engine MO2 mod; absent from `tools/Pandora/`.

**Root cause (resolved):** Initial report was on an **existing save**. After
documenting the **fresh-save requirement** in `pandora-manual-run.md`, user
confirmed **sit and mount work on a new save** — stale save-side
animation/furniture state, not a confirmed Pandora HKX defect. task-0029's
graph-wiring hypothesis was **never verified** (string scan only).

**task-0031 superseded** — confirm-then-fix work not executed; see
`tasks/completed/task-0031.md`.

**Workflow lesson:** Always run Pandora post-regen smoke tests (furniture sit,
horse mount first) on a **new game or new test save** — see
`pandora-manual-run.md` § Fresh save required.

---

### 2026-07-07 — Lux restored; MLO2/WSU stack removed (task-0030)

Live testing after task-0022/0026 showed **Modern Lighting Overhaul 2 +
Window Shadows Ultimate** did not justify replacing Lux's patch ecosystem
for this list. **Rollback executed:** re-enabled Lux, Lux Orbis, and both
patch hubs in MO2 (Lux Via + hub left as-is from task-0023); restored **36**
Lux-named plugins from `modlist/exports/mlo2-pre-migration-2026-07-07/`;
re-enabled **DynDOLOD.esp**, **Occlusion.esp**, and four Lux-dependent
frozen outputs; CS Light switched back to **6 Lux FOMOD JSONs** (vanilla
core set archived under `_disabled_vanilla_mlo2_migration/`). **Disabled**
MLO2, True Light, Dust not Clouds, DIAL, WSU, and WSU Patch Hub.

**Not a wasted detour** — it was a deliberate experiment with a documented
snapshot. **Going forward:** mods without a Lux patch get a reactive
**houseCARL** patch, not another wholesale lighting swap. **task-0024**
Synthesis W4ENB GitHub source was re-verified on disk (had reverted to `F:\`
locally; restored to pinned GitHub). Profile: **343 active plugins**, **0
missing masters** (MAST scan 2026-07-07). **Close MO2 before profile edits**
or refresh after exit so MO2 does not overwrite `modlist.txt`.

---

### 2026-07-07 — True Light / WSU plugin order corrected (post task-0026)

Earlier repo notes (task-0026, `decisions.md`) said “Placed Light ESPs before WSU” /
`TL Bulbs ISL.esp` before `Window Shadows Ultimate.esp` before `Shadows and Ambient` —
**inferred from obsolete “Placed Light” naming**, not Nexus text.

**Correct (author):** [True Light 135488](https://www.nexusmods.com/skyrimspecialedition/mods/135488)
*Load Order* — `True Light - Shadows and Ambient.esp` **very early**; WSU ESPs **late
but not later than** `TL Bulbs ISL.esp`; `TL Bulbs ISL.esp` **very late** (before
`CS Light.esp` if used); True Light patches **after WSU**. [WSU 150494](https://www.nexusmods.com/skyrimspecialedition/mods/150494):
“No load order requirements.” See `mlo2-manual-run.md` §0.5.

---

### 2026-07-07 — Window Shadows Ultimate + MLO2 re-enable (task-0026)

User sign-off to add **Window Shadows Ultimate** ([150494](https://www.nexusmods.com/skyrimspecialedition/mods/150494))
before MLO2 live spot tests. **MLO2 re-enabled** in profile (`MLO.dll` re-extracted;
was missing from `SKSE/Plugins/`). WSU requires **True Light** (135488; Nexus name —
not `Placed Light*.esp` plugins), **Dust not Clouds**, **DIAL** — install via MO2 then
run `scripts/install-wsu-stack.ps1`. Optional Patch Hub 151548. **MO2 mod priority:**
MLO2 after BOS, then True Light → WSU stack. **Plugin LO:** True Light author rules
(§0.5; corrected same day — see entry above).

---

**Human sign-off:** defer **both** [SR Exterior Cities](https://www.nexusmods.com/skyrimspecialedition/mods/87954) and [Open Cities Skyrim](https://www.nexusmods.com/skyrimspecialedition/mods/87707). Neither framework is worth pursuing while the list is still in flux — SREX hub is WIP/stale; OCS is better maintained but still needs heavy patch work against Spaghetti NavCuts, Navigator, and city mesh stack. **No MO2 install, no execution task** for either mod. Tier 2 DynDOLOD/Occlusion regen (task-0025) proceeds **without** bundling open cities. Revisit only if open cities becomes an explicit successor-list goal after curation stabilizes. See [`sr-exterior-cities-compatibility.md`](sr-exterior-cities-compatibility.md).

---

### 2026-07-07 — Synthesis W4ENB patcher portable path (task-0024)

`ANV_SynW4ENBPatcher` in `Anvil\tools\Synthesis\PipelineSettings.json` referenced a
**non-portable** local path (`F:\...\WaterForENBPatcherFixed\`). Classified as **(b)**
maintainer-local clone of public [panthuncia/WaterForENBPatcher](https://github.com/panthuncia/WaterForENBPatcher)
(W4ENB page–recommended). Replaced with **GitHub patcher settings** (pinned main
`111d09c8`). **`ANV_SynW4ENBPatcher.esp` not regenerated** — frozen until Tier 2;
compare output if regen differs from legacy "Fixed" fork.

---

### 2026-07-07 — SR Exterior Cities research (task-0020)

Scoped [SR Exterior Cities 2.0](https://www.nexusmods.com/skyrimspecialedition/mods/87954)
for eventual addition. All **five capitals** → Tamriel exteriors; **new game** required.
J3W3LS Synthesis patcher covers object moves only — **navmesh needs CK**. Anvil conflict
hotspots: Spaghetti's Cities, SB Windhelm, Ivy Whiterun, Lux Via (hub patches).
**Superseded:** human sign-off defer **both** SREX and OCS — see entry above.
See [`sr-exterior-cities-compatibility.md`](sr-exterior-cities-compatibility.md).

---

### 2026-07-07 — DynDOLOD.esp / Occlusion.esp disabled; regen deferred (task-0025)

Stale Lux-mastered **`DynDOLOD.esp`** and **`Occlusion.esp`** disabled in profile.
Regeneration folded into **Tier 2 toolchain maintenance** (with Synthesis, ParallaxGen,
DynDOLOD Resources/DLL updates) — not worth running while modlist is still in flux.
**`DynDOLOD.esm`** stays enabled. In-game: vanilla-ish distant LOD / no occlusion culling
until Tier 2 regen.

---

### 2026-07-07 — MLO2 installed; Lux Via files restored (task-0022)

**Modern Lighting Overhaul 2 (160748)** extracted from Downloads to
`mods/Modern Lighting Overhaul 2/`, enabled in `modlist.txt` immediately after
**Base Object Swapper**. `MLO.ini` pre-seeded from FOMOD whitelist (Shadow Casters
On) with **`enableColorConsistency=false`** for NAT.CS.

**Lux Via (63588) + patch hub (116722)** re-extracted to match prior FOMOD
choices (ENB Light resource pack, Blended Roads bridges, More Lantern Posts, More
Wooden Bridges patch). Via + MLO2 combo still **untested in-game** — run spot-test
matrix in [`mlo2-manual-run.md` §3](mlo2-manual-run.md#3-in-game-spot-test-matrix-phase-5).

---

### 2026-07-07 — Lux suite disabled; MLO2 install pending user download (task-0021)

Executed MO2 prep per sign-off: **7 Lux-related mods disabled**, **36 Lux-named
plugins removed** from `Anvil - Main Profile`, CS Light reverted from Lux FOMOD
JSONs to vanilla core configs (Lux JSONs archived under
`_disabled_lux_mlo2_migration/`). Snapshot:
`modlist/exports/mlo2-pre-migration-2026-07-07/`.

**MLO2 (160748) was not in MO2 downloads or mods** — could not install without
Nexus auth. User must download/install via MO2 and place per
[`mlo2-manual-run.md`](mlo2-manual-run.md). Optional WSU / Dark Crypts still
deferred.

Research reference: [`mlo2-migration-plan.md`](mlo2-migration-plan.md).

---

### 2026-07-07 — Lux Via kept alongside MLO2 (task-0023)

User chose to **re-enable Lux Via** (roads/lanterns/bridges) while Lux/Lux Orbis
core remain removed for MLO2. Verified at documentation level: **`Lux Via.esp` /
`Lux Via - plugin.esp` do not require Lux or Orbis master plugins** — only Via's
dual-master pair. Re-enabled MO2 mods + six Via plugins; **mod folders empty on
disk** — reinstall via Nexus before play. Via + MLO2 exterior combo is **untested**;
spot-test roads at night. See [`mlo2-manual-run.md` §0](mlo2-manual-run.md#0-lux-via-reinstall-if-mo2-shows-missing-masters).

---

### 2026-07-07 — Lux → MLO2 migration sign-off; execution queued (task-0021)

User approved **bold Lux removal** and MLO2 install after task-0019 research.
Execution task **task-0021** queued (Cursor, MO2 folder/plugin work). Optional
adds (Window Shadows Ultimate, Dark Crypts) **deferred** unless user requests later.

Research reference: [`mlo2-migration-plan.md`](mlo2-migration-plan.md).

---

### 2026-07-07 — Lux suite → MLO2 migration researched; execution needs sign-off (task-0019)

**Research only** — no MO2 changes. User intent: **bold full replacement** of Lux +
Lux Orbis + Lux Via (113002/56095/63588) with [Modern Lighting Overhaul 2](https://www.nexusmods.com/skyrimspecialedition/mods/160748).

**Findings:** Anvil has **7 Lux-suite MO2 mods**, **35 active Lux-named plugins**, and
**22 content mods** with installed Lux/Orbis/Via patches (plus **CS Light** on Lux
FOMOD configs). MLO2 native integration matches most of Anvil's Embers/SMIM/Swaps/CC
Fishing stack; **Window Shadows Ultimate is not installed** (major window-light gap).
Removing Lux does **not** remove Splashes of Storms or Sky Sync (task-0017); **CS Light
must be reinstalled on Vanilla configs** before MLO2.

Full plan: [`mlo2-migration-plan.md`](mlo2-migration-plan.md). **Do not execute**
until explicit human sign-off — same bar as Pandora migration.

---

### 2026-07-07 — Pandora migration: three independent fixes before first clean run (task-0018)

Nemesis → Pandora **prep looked complete on paper** but the first successful MO2
**Launch** required **three unrelated fixes** — any one alone left Pandora broken.
Do not skim "migration complete" and assume plug-and-play.

| # | Blocker | Symptom (short) | Fix (short) |
|---:|---|---|---|
| 1 | **`ActiveMods.json` schema** | 0 patches / FATAL `ArgumentNullException` | camelCase `code`/`active`/`priority` only — wrong keys **crash startup** |
| 2 | **`Settings.json` global scope** | Wrong output path / wrong Data scan | Pre-flight `%LocalAppData%\Pandora Behaviour Engine\Settings.json` every Anvil run |
| 3 | **Engine path + MO2 launch** | Instant close (#385) or VFS broken (bat) | Exe at `tools/Pandora/`; MO2 → `.exe` direct; **Edit Executables only**; no batch launcher |

**Outcome (2026-07-07):** clean regen — 15 `Pandora Mod` lines + FNIS Serana in
`Engine.log`; `.hkx` in `Pandora Output`. In-game smoke test still pending.

**Full diagnostic reference (symptom → cause → fix, not chronology):**
[`pandora-manual-run.md` § Gotchas](pandora-manual-run.md#gotchas--symptom--cause--fix).

Also documented there: 28 Patcher rows vs 15 to enable (install-folder samples);
FNIS separate from checkboxes; **`tdmv` = Headtracking** (ID vs log display name);
batch launcher obsolete now that Settings holds paths.

---

### 2026-07-07 — Pandora regen succeeded; FNIS vs Patcher UI clarified (task-0018)

*(Superseded by entry above — detail lives in Gotchas section.)*

First successful MO2 Pandora **Launch** after moving the engine to `tools/Pandora/`.
`Engine.log` shows 15 `Pandora Mod` lines + `FNIS Mod 1 : FNIS_SeranaHoodFixWithAnim_List`;
output `.hkx` under `Pandora Output/meshes/actors/character/Behaviors/`. In-game
smoke test still pending.

---

### 2026-07-07 — Pandora engine moved out of `mods/` for MO2 launch (task-0018)

*(Folded into "three independent fixes" entry above.)*

Pandora **instant-closed** when launched from MO2 (no process, stale `Engine.log`,
`ActiveMods.json` not regenerated) while direct exe launch worked. Root cause:
[Pandora #385](https://github.com/Monitor221hz/Pandora-Behaviour-Engine-Plus/issues/385)
— exe inside MO2 `mods/` + USVFS = silent exit.

**Fix:** copied engine to `Anvil/tools/Pandora/`; MO2 tool #6 binary + working
directory updated to that path. MO2 mod `Pandora Behaviour Engine+` remains
disabled (legacy folder under `mods/` can be removed later). User must confirm
tool paths in **Edit Executables** after MO2 restart, then run **Launch**.

---

### 2026-07-06 — Nemesis → Pandora MO2 prep complete; regen deferred to user (task-0018)

MO2 folder prep for Nemesis → Pandora migration is **complete**. Behavior
regeneration was **not run** — Pandora must be launched manually through MO2's
executable toolbar (not automatable from Cursor).

**Done on disk:**
- Installed **Pandora Behaviour Engine+** v4.3.1-beta; MO2 tool #6 configured
  (`--tesv` + `-o` to `Pandora Output`; no `--auto_run`)
- Installed **Universal Behaviour Runtime — Auto Skeleton Patch** (176724)
- Created **Bundled Behaviour Patches (Nemesis legacy)** (nemesis/rthf/turn/pscd
  copied from old Nemesis engine)
- Created empty **`Pandora Output`** mod (Pandora's standard output target; replaces
  the never-created `Anvil - Pandora Output` placeholder)
- **Disabled** Nemesis engine; **removed** Nemesis Creature Behaviour Compatibility
- **Disabled** four broken empty animation mods
- Pre-seeded `mods/Pandora Output/Pandora_Engine/ActiveMods.json` (16 Anvil patches +
  `nemesis`; 13 engine install samples left out so UI defaults unchecked)

**User action:** follow [`pandora-manual-run.md`](pandora-manual-run.md) — launch
Pandora from MO2, verify patch checkboxes on the **Patcher** page, click **Launch**
(play icon), in-game smoke test.

**Pandora Settings.json is global (not MO2-scoped):** v4.x stores
`gameDataPath` and `outputPath` in
`%LocalAppData%\Pandora Behaviour Engine\Settings.json`. That file is shared
across all MO2 instances on this PC. Anvil paths were corrected 2026-07-06 after
stale `E:\Modlists\Skyrim AE\…` values caused a mismatch with MO2 CLI args.
**This is not permanent** — running Pandora for another list, editing Settings
in the Pandora UI, or a bad auto-detect can overwrite Anvil paths again.
**Every future Anvil Pandora run** must pre-flight Settings.json per
[`pandora-manual-run.md` §2](pandora-manual-run.md#2-pre-flight--verify-settingsjson-required-every-run).
Saved Settings override MO2 `-o` / `--tesv` when the stored folders still exist.

---

### 2026-07-06 — Nemesis → Pandora migration research (task-0016)

User intent: transition Anvil from **Project New Reign - Nemesis** (v0.84, static
since 2021) to **Pandora Behaviour Engine+** (133232, v4.3.1-beta).

**Research outcome:** migration is **feasible with low patch-mod risk** for this
list. Anvil has **no MCO/SkySA/Precision/FNIS engine** — only **15 Nemesis patch
inputs** (12 MO2 mods + 3 bundled in engine). Pandora reads the same Nemesis
`Nemesis_Engine/mod/` format; all installed patch mods are **compatible or
expected compatible**. DynDOLOD/Synthesis/ParallaxGen have **no** Nemesis output
dependency.

**Required changes beyond engine swap:**
- **Add:** Universal Behaviour Runtime — Auto Skeleton Patch (176724) for XPMSSE
- **Remove:** Nemesis Creature Behaviour Compatibility (45966) — not needed for Pandora
- **Replace:** stale `Anvil - Nemesis Output` (last run 2025-07-04 used wrong
  `D:\Anvil\Stock Game\` path; 8 of 15 patches never applied)

**Do not execute yet** — list-wide behavior regen needs explicit sign-off.
Full plan: [`pandora-migration-plan.md`](pandora-migration-plan.md).
Execution queued as **task-0018** (Cursor, not houseCARL).

---

### 2026-07-06 — OAR 3.x audit + SPID bump (task-0015)

**SPID:** updated **7.2.0.0.RC11 → 7.3.1** (AE / 1.6.629+ DLL from GitHub
FOMOD). Six `_DISTR.ini` files in the install — all use standard Spell/Skin
distribution syntax; no grammar changes needed for 7.3.x. In-game distribution
log check recommended on next launch (`po3_SpellPerkItemDistributor.log`).

**OAR audit:** full mod-folder scan found **six** replacer dependents (four
native OAR JSON, two DAR legacy `_conditions.txt`). No Dynamic Animation
Replacer mod installed; no OAR custom-condition SKSE plugins (Math Plugin,
Payload Interpreter, etc.). OAR 3.x API changes affect extending plugins only —
not this list's replacers. All six mods confirmed compatible via mod-page
descriptions + OAR author's documented DAR backwards compatibility.

**Decision:** proceed with **Open Animation Replacer 2.3.6.0 → 3.1.6** (Nexus
92109, file 768987). Full per-mod table:
[`oar-audit-2026-07-06.md`](oar-audit-2026-07-06.md).

---

### 2026-07-06 — Full CS 1.7.3 ecosystem audit; corrects task-0013 oversights (task-0017)

task-0013 updated Community Shaders to **1.7.3** but only bumped a handful of
labeled “CS plugin” folders. It missed that CS 1.7.x **merges many former
standalone features into core** and **hard-blocks** others at startup.

**Corrections applied** (see [`community-shaders-audit-2026-07-05.md`](community-shaders-audit-2026-07-05.md)):

- **Disabled** core-merged standalone folders: Light Limit Fix, Terrain Shadows
  (+ Heightmaps), Water Effects, Subsurface Scattering, Screen Space Shadows,
  Grass Collision, Grass Lighting. Frame Generation was already off.
- **Disabled** EVLaS (incompatible DLL — caused live launch failure).
- **Updated** still-separate features to CS 1.7.3 line: Wetness Effects **3.1.0**,
  Cloud Shadows **1.4.0**, Skylighting **1.4.0** (from CS GitHub release zips).
- **Sky Sync:** confirmed **core since CS 1.7.0** — no Nexus folder needed.
  `Community Shaders - Anvil Settings` already has Sky Sync **Enabled: true**.
- **0 missing masters** after all modlist changes.

**Left enabled (intentional):** SSGI 4.2.0, Grass Sampler Fix, NAT.CS III,
NAT.ENB weather plugin, CS Light, Splashes of Storms (subjective overlap with
Wetness Effects — Anvil aesthetic choice).

**USSEP/USMP/SSGI from task-0013:** re-checked — still valid; no rollback needed.

---

Updated **SkyUI** (Nexus 12604) from 5.2 SE to **6.11** (doodlum community
line, same mod page). Research found no blocking compatibility risk for this
list — official SkyUI 6 article states backwards compatibility with SkyUI 5.2
dependents; expected side effect is MCM/favourites settings reset (light-plugin
conversion).

**List-specific findings:**
- `Complete Widescreen Fix` (21x9/32x9) was already **disabled** — SkyUI 6
  adds native 16:9/21:9/32:9/4:3 aspect-ratio support.
- Seven satellite mods **disabled** as redundant with SkyUI 6 integrations:
  `SkyUI - ESL Plugin with Master Added` (native Skyrim.esm master + ESL flag),
  `SkyUI - Ghost Item Bug Fix`, `Quest Journal Fix for SkyUI`, `SkyUI - 3D Item
  Offset Fix`, `Wider MCM Menu for SkyUI`, `SkyUI - Fix Note Icon`, `Widescreen
  Scale Removed`. No UI reskin mods (Dear Diary, Nordic UI, etc.) in the active
  list that would need aspect-ratio SWF updates.
- `SkyUI_SE.esp` verified: **ESL-flagged**, masters `Skyrim.esm` only.
- Missing masters after update: **0** (343 active plugins).

**User action:** reconfigure SkyUI MCM/favourites after first launch if settings
reset. Watch for menu scaling issues on non-16:9 — re-enable widescreen helpers
only if needed.

### 2026-07-05 — EVLaS disabled for Community Shaders 1.7.x compatibility (post-task-0013)

Launch error: CS 1.7.3 detects `EVLaS.dll` as an **incompatible DLL** and refuses
to load (hard block since CS PR #1477). Anvil had `Enhanced Volumetric Lighting
and Shadows (EVLaS)` enabled alongside CS — valid under CS 1.2.1, broken under
1.7.3.

**Fix applied:** disabled EVLaS in MO2 `modlist.txt`. Sky Sync (the CS
equivalent of EVLaS's sun/moon volumetric sync) is **built into CS core since
1.7.0** — no separate install needed. `Community Shaders - Anvil Settings`
already has Sky Sync `Enabled: true` (confirmed in task-0017). NAT.CS III's
optional `EVLaS.cfg` no longer applies now that EVLaS.dll is absent — no
action needed there either.

---

### 2026-07-05 — USSEP, USMP, and Community Shaders updated; sbbe.esp folder identified (task-0013)

Updated three routine framework mods on the D: Anvil MO2 instance (`Anvil -
Main Profile`) ahead of the DynDOLOD/PGPatcher maintenance window. All are
runtime/in-place mod-folder replacements — no load-order or plugin-list edits.

**USSEP 4.3.8a** (was 4.3.4a): Nexus page requires Skyrim **1.6.1130+**;
install is on **1.6.1170 / SKSE 2.2.6** — compatible. ESP dated 2026-03-21.

**USMP 2.6.8** (was 2.6.3; task specified 2.6.7 but 2.6.8 was latest on
Nexus at install time): Nexus requirements table confirms **powerofthree's
Papyrus Extender is no longer required** as of 2.6.7+ (was only mandatory
for 2.6.4–2.6.6 due to the removed UOSC bundle). USMP still masters
`Unofficial Skyrim Special Edition Patch.esp` — load order unchanged. ESP
dated 2026-07-02.

**Community Shaders 1.7.3** (was 1.2.1): DLL dated 2026-06-27. CS plugin
submods in the Anvil CS block updated where newer Nexus MAIN files existed:
Grass Collision **3.0.2**, SSGI **4.2.0**. Verified unchanged/current:
Grass Lighting 2.0.0, Grass Sampler Fix 1.0.1, Screen Space Shadows 2.0.0,
Terrain Shadows 1.0.0, NAT.CS III 1.5.0.0. **Community Shaders - Anvil
Settings** INI overrides preserved (not overwritten). **Anvil - Community
Shaders ShaderCache Output** cleared (meta.ini only remains) — disk cache
will rebuild on next game launch.

**Missing masters:** binary scan of all 343 active plugins against 361
available plugin files → **0 missing masters**.

**sbbe.esp hygiene (from task-0012):** plugin lives in MO2 folder
`SpiRally's Beautiful Butterflies Enhanced`
(`D:\Skyrim AI Modlist\Anvil\mods\SpiRally's Beautiful Butterflies Enhanced\sbbe.esp`).
Benign critter FormList expansion — no action needed.

**Post-update re-audit:** **Low priority.** USSEP/USMP historically win their
records cleanly in this list. Optional spot-check if gameplay issues appear:
USSEP 4.3.8a changelog (Mar 2026) for any removed/replaced records that could
shift conflict winners; USMP 2.6.8 for script/quest fixes affecting mods that
patch the same records. No immediate houseCARL conflict pass warranted unless
something breaks in testing. **First launch after CS update will compile
shaders** — expect one-time "Compiling Shaders" delay.

---

The version-check report (task-0008) and the initial task-0013 scope both
grouped Community Shaders with PGPatcher/DynDOLOD as part of a "coordinated
regen" maintenance window. This was incorrect. Community Shaders is a
**runtime shader system** — it builds its shader cache on first game launch
after an update; there is no offline generation step, and it has no
dependency on PGPatcher or DynDOLOD output. It can be updated at any time,
independently, the same as any other framework mod.

Corrected in:
- `version-check-2026-07-05.md`: executive summary, "Biggest gap" paragraph,
  Tier 1 table (CS moved to its own "Runtime shader system" subsection, out
  of "Generated-output toolchain"), and recommended update order (CS now
  listed with the SKSE-DLL batch, not between PGPatcher and DynDOLOD).
- `tasks/queue/task-0013.md`: CS added to scope alongside USSEP/USMP.

**Rule for future maintenance planning:** CS plugin submods (individual
shader feature modules) should be updated alongside CS itself to stay on
compatible versions — but this is still a routine "update and relaunch"
operation, not a regen event.

---

### 2026-07-05 — FormList, GameSettingString, Keyword, Global audit complete; all top-20 categories now audited (task-0012)

Individually audited the four remaining top-20 conflict categories from the
original baseline scan: FormList (40), GameSettingString (51), Keyword (2),
Global (27) — 120 records total. **All 120 confirmed healthy.** Notable
findings: `sbbe.esp` wins three insect/moth FormLists by adding 16+ new
butterfly species entries — confirmed to be a critter variety expansion mod
(species names: AgraulisVanillae, BattusPhilenor, Kaisermantel, etc.); its
plugin has no matching MO2 mod-folder name (likely bundled under a differently-
named folder) but the conflict is benign. `Audio Overhaul Skyrim.esp` wins
two USSEP armor material Keywords (`USLEEPArmorMaterialBlackguard`,
`USKPArmorMaterialLinwe`) — confirmed standard AOS behaviour for applying
custom impact-sound descriptors. `SurvivalModeImproved.esp` wins all 27 CC
Survival globals — its entire purpose.

This completes the conflict audit of all top-20 categories from the original
baseline (31,377 total records individually checked across task-0002,
task-0004 through task-0007, and task-0012). Remaining ~98k conflicts are
outside the top-20 sample (NAVI, LAND, REFR, etc.) and are not audited
unless a specific problem is identified.

---

### 2026-07-05 — McmRecorder.esp removed from the load order (task-0011)

Despite task-0009's "keep it, document as harmless" conclusion, the
decision was made to remove `McmRecorder.esp` entirely — it's an older
approach to recording MCM settings, superseded by a newer method. Before
removing, independently re-verified (not just trusting the prior session)
that nothing depends on it: grepped every plugin binary in the install for
the literal master-reference string `McmRecorder.esp` — zero matches,
meaning no other plugin declares it as a master, which structurally means
none can reference its forms. Confirmed clean.

**Correction to the task-0005 finding:** re-examining the `WEMerchantChests`
cell diff before removing turned up that the dropped navmesh (1 entry →
0) was **not** McmRecorder's doing — `Update.esm` (the immediate
predecessor in the override chain) already had 0 navmesh entries for this
cell, independent of McmRecorder. Only the swapped persistent reference
(vanilla merchant-chest object → McmRecorder's own debug `MiscItem`) was
actually McmRecorder's change. This doesn't change the removal decision,
but the earlier "drops the cell's navmesh" framing was inaccurate — flag
this correction if referencing task-0005 later.

Removed by disabling the mod in `modlist.txt` and removing its plugin
entry from `plugins.txt`/`loadorder.txt` in the `Anvil - Main Profile`
(354 → 353 active plugins, 924 → 923 enabled mods). Verified post-removal:
`housecarl_load_order_status` reports 0 missing masters, 353/353 resolved;
the `WEMerchantChests` cell now resolves cleanly to `Update.esm` with the
original persistent reference restored. `modlist/baseline-plugins-
2026-07-05.txt` was left as-is (annotated with a note) since it's a
historical baseline snapshot, not current-state tracking.

### 2026-07-05 — Lux Orbis guard/Civil War leveled-list edits confirmed intentional (task-0010)

task-0006 flagged four `LeveledItem` wins by `Lux Orbis.esp` (`GuardGear`,
`CWSoldierImperialGear`, `CWSoldierSonsGear`, `CWSoldierSonsGear1H`) that
remove ammo entries (e.g. 12× Steel Arrow from `GuardGear`). The Lux Orbis
Nexus description (mod 56095) explicitly states: *"Guards levelled list has
been edited so that they stop using torches all around, pretty much
destroying all meshes nearby"* and *"Most civil war content has been
reworked."* These are **core Lux Orbis design choices**, not a stray FOMOD
patch option or an accidental conflict. No patch or revert recommended —
reverting would restore guard torch/gear behaviour that conflicts with Lux
Orbis lighting. Low-severity balance nuance only.

### 2026-07-05 — McmRecorder.esp WEMerchantChests edit confirmed harmless (task-0009)

task-0005 flagged `McmRecorder.esp` winning cell `WEMerchantChests`
(`0BBCB2`) with dropped navmesh and a swapped persistent ref to
`McmRecorder_MessageText`. Research confirms: (1) the Nexus page and GitHub
repo describe MCM recording only — no stated reason to edit world cells;
(2) `WEMerchantChests` is an [inaccessible developer test
cell](https://en.uesp.net/wiki/Skyrim:Inaccessible_Cells) (peddler merchant
chest storage, reachable only via console `coc`); (3) the edit matches
accidental CK dirt, not mod functionality. **Decision: (c) document as
confirmed-harmless — no patch task, do not disable the mod** (Anvil keeps
`McmRecorder.esp` active for list MCM automation). Optional list-hygiene
patch is low priority if ever desired.

### 2026-07-05 — Full Quest/Perk/MagicEffect/Spell audit; all baseline categories now audited (task-0007)

Individually audited all 1,562 conflicts across Quest (576), Perk (151),
MagicEffect (492), and Spell (343) — **all confirmed healthy, nothing
flagged.** Winners are USSEP/USMP, DLC/master overrides, survival-mod
content, and named fix mods (`eve - bleeding damage fixes.esp`,
`FleshFX.esp`, `LuminousAtronachs.esp`, `AdoptionAndMovingFix.esp`,
`OnlyOnce.esp`, and several `ANV_*-USSEP.esp` quest patches), each
confirmed to match its own domain.

Per this task's specific requirement, checked whether any Quest winners
involve script-fragment or alias overrides (higher risk than plain field
changes): 7 named quest-fix winners do carry `VirtualMachineAdapter`/
`Aliases` diffs, but this is expected — each is a purpose-built patch
whose entire job is forwarding two other plugins' script changes into one
record (the `ANV_*-USSEP` naming convention on this list means exactly
that). No winner touched script/alias data without an obvious reason to.

This closes out the full audit series started in task-0004: **all ~20
largest conflict categories from the original task-0002 baseline (31,257
of 129,515 total conflicts) have now been individually checked.** Two
findings remain open from this series: task-0009 (McmRecorder.esp Cell
finding, unintentional) and task-0010 (Lux Orbis.esp LeveledItem finding,
needs verification). Categories outside the original top-20 sample
remain unaudited; only worth a follow-up task if a specific problem is
suspected there.

### 2026-07-05 — Baseline version audit (task-0008)

Prioritized version check of the D: Anvil install against Nexus/GitHub (Jul 2026).
Most core DLL frameworks (SKSE, Address Library, Lux suite, SPID/KID, PO3 libs,
RaceMenu, TDM) are current. **Largest gaps are in the generated-output toolchain:**
Community Shaders 1.2.1 → 1.7.3, PGPatcher/ParallaxGen (Apr 2025 binary → 1.1.4),
DynDOLOD standalone/resources/DLL far behind current Alpha-204/Alpha-59 line. USSEP
(4.3.4a → 4.3.8a) and USMP (2.6.3 → 2.6.7) also have routine updates pending.
78 MO2-tracked mod folders show version drift in cached metadata — mostly
textures/misc. Nemesis is static since 2021 (Pandora is the active successor).
MCM Recorder is version-current; its task-0005 cell issue is separate. Full
detail: [`version-check-2026-07-05.md`](version-check-2026-07-05.md). No update
tasks queued — human review first.

### 2026-07-05 — Full Armor/Weapon/ConstructibleObject/LeveledItem audit (task-0006)

Individually audited all 1,442 conflicts across Armor (662), Weapon (607),
ConstructibleObject (36), and LeveledItem (137). **1,438 confirmed
healthy** — USSEP/USMP, DLC/master overrides, and named mods paired with
their own USSEP patches (JS Unique Utopia rings/daggers, JS Vanilla
Circlets, Praedy's StavesAIO, Hearthfires Houses Building Fix, etc.), each
spot-checked to confirm they only touch records in their own domain.

**4 flagged as "needs verification" (low severity):** `Lux Orbis.esp`
wins 4 `LeveledItem` conflicts unrelated to lighting (`GuardGear`,
`CWSoldierImperialGear`, `CWSoldierSonsGear`, `CWSoldierSonsGear1H`) —
each removes an ammo entry (e.g. 12x Steel Arrow) from vanilla. Lux Orbis
is a large, actively-maintained lighting overhaul whose FOMOD bundles
patches for a lot of modded content, so this is plausibly an intended
FOMOD patch option, but it isn't traceable to an obviously-named dedicated
patch, so it's not being assumed safe outright. Lower severity than the
task-0005 McmRecorder finding — this is a minor loot/balance nuance, not a
functional break. Created **task-0010** (assigned to Cursor) to confirm
via the mod's documentation rather than filing it as a bug.

### 2026-07-05 — Full Cell conflict audit; first unintentional-conflict finding (task-0005)

Individually audited all 13,588 Cell conflicts. **13,587 confirmed
healthy** — winners are generated tool output (Occlusion/DynDOLOD/
Synthesis), Lux and its named compatibility patches, USSEP, DLC/master
overrides, or named single/small-count fix mods, each spot-checked and
confirmed to only touch cells matching their own purpose.

**One flagged for attention:** `McmRecorder.esp` (an MCM-recording/debug
utility mod) wins cell `0BBCB2:Skyrim.esm` (`WEMerchantChests` /
"Warehouse Bookshelves") over `Update.esm`, and the diff isn't a routine
field tweak — it drops the cell's navmesh to 0 entries and replaces the
vanilla persistent placed reference with the mod's own debug `MiscItem`.
This looks like an accidental/dirty CK edit carried in the distributed
plugin, not an intentional patch. Not fixed here (audit-only task) —
created **task-0009** (assigned to Cursor) to research the mod and decide
whether a corrective patch is warranted. (Originally filed as task-0008;
renumbered after Cursor independently created a different task-0008 —
mod version-check — in parallel.)

### 2026-07-05 — Full NPC_ and Dialogue conflict audit (task-0004)

Individually audited all 14,338 conflicts in the two highest-risk
categories left unchecked by the baseline scan: NPC_ (4,711), DialogTopic
(3,424), and DialogResponses (6,203). Confirmed instance/profile
(`D:\Skyrim AI Modlist\Anvil`, `Anvil - Main Profile`) before starting, per
the new CLAUDE.md pre-flight rule. **All healthy — no unintentional or
unresolved conflicts.** Every winner is USSEP/USMP, a DLC/master override,
generated Synthesis patcher output, or a named fix/replacer mod confirmed
to be winning only records in its own domain (e.g. `FacegenForKids.esp`
only wins child-NPC records, `AdoptionAndMovingFix.esp` only wins adoption
dialogue). Full breakdown appended to
[`baseline-scan-2026-07-05.md`](baseline-scan-2026-07-05.md).

No follow-up issues raised by this audit — this was audit-only per the
task, and nothing needing attention was found.

### 2026-07-05 — No bashed/smashed patch; Synthesis final tier is intentional (task-0003)

The stale "bashed/smashed patches last" line in `load-order-notes.md` was
generic boilerplate, not Anvil's actual methodology. Verified against the
installed D: instance: no `Bashed Patch*.esp` or Mator Smash output exists;
Wrye Bash is not even present in `Anvil\tools\`. The load order ends
ParallaxGen → four `ANV_Syn*.esp` Synthesis outputs → DynDOLOD →
Occlusion.

The four Synthesis groups (HPH/RaceMenu, NPC fixes, world/SSBG+landscape,
Water-for-ENB) address specialized compatibility — not global leveled-list
merging. Anvil instead relies on named patches, pre-merged plugins, and
load-order curation. **Decision: keep the current setup; do not add a
bashed/smashed patch by default.** If future customization adds many
leveled-list or inventory mods, revisit with Fusion Patcher / LeveledListResolver
or Wrye Bash as an explicit follow-up task. Updated
`modlist/load-order-notes.md` with the verified tiering.

### 2026-07-05 — Baseline houseCARL scan corrected to D: instance (task-0002 rerun)

The same-day baseline scan below (originally run against `E:\Modlists\
Skyrim AE`) was rerun against `D:\Skyrim AI Modlist\Anvil` — the user
confirmed this is the correct instance (a baseline list actively being
added to, not a stale/unused install as first assumed) and it's the path
CLAUDE.md already documented. houseCARL was repointed at it
(`housecarl_set_mo2_instance`, persists across restarts).

Corrected baseline: 354 active plugins (924 mods enabled / 9 disabled), 0
missing masters, 0 unparseable plugins, 129,515 total record-level
conflicts. Full manual audit of Race/Faction/Class/Worldspace conflicts
(327 records) found no unintentional conflicts — every winner is USSEP/
USMP, a DLC/master override, a named compatibility patch, or expected
generated output (Synthesis/DynDOLOD/Occlusion/ParallaxGen/Lux). Full
detail: [`baseline-scan-2026-07-05.md`](baseline-scan-2026-07-05.md);
`baseline-plugins-2026-07-05.txt` also regenerated against this instance.

The E:\ instance's numbers from the original pass no longer apply to this
project and should not be referenced going forward.

The no-Bashed/Smashed-Patch finding flagged here has since been resolved
as intentional — see the task-0003 entry above.

### 2026-07-05 — Repo created

Scaffold set up. No modlist-specific decisions logged yet — add entries
here as you and the agents make them. Suggested first entry: baseline
state of the installed Anvil list before any customization begins (mod
count, any known issues going in).
