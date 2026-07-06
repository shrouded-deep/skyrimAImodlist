# Decision Log

Running rationale log for this Skyrim SE modlist (built on the Anvil
Wabbajack foundation). One entry per meaningful decision — trims,
additions, load-order changes, corrections to prior assumptions. Newest
entry at the top.

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
