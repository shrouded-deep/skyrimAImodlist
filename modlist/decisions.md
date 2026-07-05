# Decision Log

Running rationale log for this Skyrim SE modlist (built on the Anvil
Wabbajack foundation). One entry per meaningful decision — trims,
additions, load-order changes, corrections to prior assumptions. Newest
entry at the top.

---

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

One thing still needs attention, unchanged from the original pass:
**No Bashed or Smashed Patch exists in this load order**, despite
`load-order-notes.md` documenting "bashed/smashed patches last" as the
tiering methodology. The load order ends with Synthesis-based patchers,
ParallaxGen, DynDOLOD, and Occlusion instead. Not changing anything here
per the no-silent-tiering-changes rule — flagging for a decision on
whether this is intentional.

### 2026-07-05 — Repo created

Scaffold set up. No modlist-specific decisions logged yet — add entries
here as you and the agents make them. Suggested first entry: baseline
state of the installed Anvil list before any customization begins (mod
count, any known issues going in).
