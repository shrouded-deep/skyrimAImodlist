# Decision Log

Running rationale log for this Skyrim SE modlist (built on the Anvil
Wabbajack foundation). One entry per meaningful decision — trims,
additions, load-order changes, corrections to prior assumptions. Newest
entry at the top.

---

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
