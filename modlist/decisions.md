# Decision Log

Running rationale log for this Skyrim SE modlist (built on the Anvil
Wabbajack foundation). One entry per meaningful decision — trims,
additions, load-order changes, corrections to prior assumptions. Newest
entry at the top.

---

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
