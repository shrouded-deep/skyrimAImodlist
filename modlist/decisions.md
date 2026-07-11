# Decisions Log

Dated entries recording what changed and why. Most recent first.

---

## 2026-07-12 — Spaghetti's Cities dropped (task-0055)

Spaghetti's Cities was only in the city stack because the Anvil reference list
(task-0044) shipped it natively. On Keizaal it's redundant — the standalone city mods
stand on their own. **Decision: drop Spaghetti entirely.**

Disabled on `Keizaal - Fork`: 8 mods (Spaghetti's Cities Whiterun/Windhelm/Markarth/
Solitude/Riften, Spaghetti's Towns Riverwood, Spaghetti's Capital Windhelm Expansion,
Crossed Daggers - Spaghetti Patch) + 2 bridge plugins deactivated inside kept mods
(UME Patch Hub's `Markarth Expanded - Spaghetti's Markarth.esp`, Riverwood Has Walls
Patch Collection's `Riverwood Has Charm - Spaghetti's Riverwood Patch.esp`).

Standalone city mods retained: Capital Whiterun Expansion, Capital Windhelm Expansion,
Ultimate Markarth (+Expanded), RedBag's Solitude, City of Crossed Daggers (Riften
Expansion), Riverwood Has Charm + Walls.

**`Keizaal - Fork`: 831 → 821 active plugins, 0 missing masters. Full-weight unchanged
at 105/254** (all Spaghetti plugins were ESL-flagged). task-0053 (modular CWE×Spaghetti
patch) cancelled as moot.

---

## 2026-07-12 — Vokriinator Black chosen over Constellations (task-0049)

task-0048 identified a critical conflict: Constellations (custom skill trees via CSF —
Athletics, Hand-to-Hand, Sorcery) cannot coexist with Vokriinator Black's Ordinator
perk tree replacement without custom patch work that doesn't yet exist publicly.

**Decision: Option A — remove Constellations, proceed with full VB stack.**

Disabled on `Keizaal - Fork` (pristine `Keizaal` profile untouched):
- `Constellations - Additional Player Skills` mod — disabled in modlist.txt
- `ConstellationsNewSkills.esp` — deactivated in plugins.txt
- `Keizaal Patch - Book Covers Skyrim - Constellation.esp` — deactivated in plugins.txt
- `Constellations for Simonrim` — was already disabled

Active plugin count: 719 → **717** (2 full-weight ESPs removed).

Next: task-0050 — Phase 1 VB stack install (Mysticism + Apocalypse + Adamant + SPERG +
Path of Sorcery + Vokrii + Ordinator + Vokriinator Black), using Nolvus modlist as
install order template and skipping all 5 Nolvus-bespoke ESPs.

**Update 2026-07-12:** task-0050 and task-0051 complete (Cursor). Install via
`scripts/install-keizaal-vb-stack.ps1` and `scripts/install-keizaal-city-stack.ps1`; VB
6.15.3. No Nolvus bespoke ESPs, DAC Improved omitted. Keizaal has no Lux/Orbis/Via, so
no Lux Patch Hub pass was needed.

**Update 2026-07-12 (task-0052 MAST audit):** houseCARL audit on `Keizaal - Fork` found
and fixed **3 defects** — see task-0052 for detail:
1. **`Vokriinator Black.esp` was missing** (install script did a partial folder copy —
   got the `.pex` scripts but not the core 529 KB merge plugin). Restored from Nolvus.
2. Wrong-variant `CWE Spaghetti Patch` (AIO patch on a modular Spaghetti setup) —
   disabled; task-0053 to source the modular variant.
3. Stale `Description Framework - Keizaal Cut.esp` active line — deactivated.

**Final `Keizaal - Fork` state: 831 active plugins, all resolve, 0 missing masters.**
Budget: **105 full-weight ESP/ESM vs the 254 cap — 149 slots headroom** (Keizaal is
heavily ESL-ified: 622 ESL-flagged ESP + 50 .esl are free). task-0054 queued to verify
no other script-copied folders are missing assets (the partial-copy bug is systemic).

Still pending (human): VB new-game smoke test (enable Crash Workaround 146503 if Combat
Styles CTD). **Before launching, run MO2 once on the `Keizaal - Fork` profile and F5** so
MO2 rewrites the profile files with the fixes applied.

---

## 2026-07-12 — Keizaal adopted as foundation (task-0046 audit complete)

Fork-test audit passed. Full findings in `modlist/keizaal-fork-test-audit-2026-07-12.md`.

- 1170-native confirmed (`SkyrimSE.exe 1.6.1170.0`)
- No Requiem anywhere in the load order
- Community Shaders confirmed; no ENB
- 719 active plugins baseline (+ 54 CC/implicit = 773 total)
- List glue: ~66 plugins (Keizaal Patches/Tweaks + Tamrielic Distribution) — modular and legible
- One parse error flagged: `Description Framework - Keizaal Cut.esp` — investigation needed, not a blocker
- Plugin budget rule updated in AGENTS.md to reflect 719-plugin baseline

**Verdict: ADOPT.** `Keizaal - Fork` profile is the working foundation going forward.

---

## 2026-07-12 — Keizaal fork profile created; Vokriinator Black as gameplay target

Working profile `Keizaal - Fork` created as a copy of the pristine `Keizaal`
(vanilla+) profile at `E:\Skyrim\profiles\`. `Keizaal` and `Keizaal - SimonRim`
remain untouched as reference baselines.

**Gameplay foundation choice:** Starting from the vanilla+ profile rather than
SimonRim. Long-term gameplay overhaul target is **Vokriinator Black** — the
comprehensive character system overhaul built on Ordinator + Vokrii + Apocalypse
+ Odin ecosystem. This is a deliberate start-small approach: establish the fork,
audit lock-in, then layer Vokriinator Black and its patch requirements once the
base is understood.

---

## 2026-07-12 — Foundation filters: no Requiem; target Skyrim 1.17.0 (1170)

Two hard filters now steer Wabbajack foundation selection (see updated
`modlist/wabbajack-foundation-evaluation-2026-07-11.md`):

1. **No Requiem lists** — Requiem is too tightly integrated to remove. Lists with
   Requiem as core gameplay are **disqualified at the outset**, not merely scored
   as high lock-in. Borderline cases need an explicit caveat.

2. **Target game version 1.17.0** — Prefer lists that natively target Skyrim AE
   **1.6.1170**. Non-1170 finalists may remain on a **conditional** short-list only
   if the **1170 migration challenge** is documented (SKSE plugins, Address Library,
   DLL builds, Nemesis/Behavior, CC file hashes, etc.).

**Short-list tightened (2026-07-12):** Keizaal, Gate to Sovngarde (WJ AE), Nordic
Souls, NGVO (visual layer), Living Skyrim 4 (conditional — 1170 not confirmed in
readme; verify on install).

**Disqualified — Requiem:** LoreRim, Wildlander, Nolvus Awakening (donor — Requiem +
JK-Requiem patch web confirmed in project logs), Do Not Go Gentle, Nocturnia.

**1170-native (readme/changelog confirmed):** Keizaal (v8.0.0+), Gate to Sovngarde AE,
Nordic Souls, NGVO, Anvil, Apostasy.

**Fork-test order unchanged:** Keizaal first (task-0046).

**Gate to Sovngarde caveat:** No official Wabbajack list from JaySerpa — only FlimsyParking's
unofficial port of the Nexus Collection. Treat as conditional co-test, not a native WJ
foundation like Keizaal.

---

## 2026-07-11 — Pivot: abandon Nolvus top-down; evaluate Wabbajack middle-ground foundations

After four days of Nolvus Successor top-down curation (2026-07-08 → 2026-07-11), the
Nolvus Awakening donor approach is rejected as a long-term foundation. Nolvus's nested
custom patches (Ascension patches, SREX city web, ENB stack, opaque baked Synthesis
outputs) make deconstruction and personal curation not worth the effort — the same
failure mode that makes bottom-up Anvil too gap-heavy, but from the opposite direction.

**Decision:** Pursue a **middle-ground Wabbajack foundation** — expansive installed scope,
but built from standard Nexus mods and fork-friendly list architecture rather than
Nolvus-class bespoke patch webs.

**Desk research deliverable:** `modlist/wabbajack-foundation-evaluation-2026-07-11.md`

**Short-list (finalists):** Keizaal, Gate to Sovngarde (WJ AE), Nordic Souls, NGVO
(visual layer only), Living Skyrim 4.

**Recommended fork-test order:**
1. **Keizaal** — primary (Vanilla+ expansive, Tamrielic Distribution glue, no Requiem/MCO).
2. **Gate to Sovngarde WJ AE** — alternate if Keizaal scope too conservative.

**Explicit rejects as foundation:** Nolvus Awakening, LoreRim, Apostasy, Wildlander,
FILFY, Twisted Skyrim, Anvil-as-foundation (visuals-only gap), Elysium (LOTD lock-in).

**Obsolete:** Nolvus Synthesis pipeline investigation (task-0008) — moot if Nolvus donor
is abandoned; cancel in `nolvus-successor` if still queued.

**Power fantasy lens unchanged** (see AGENTS.md). **Nolvus city/SREX stack** is no longer
a constraint once off Nolvus donor — future city decisions are open, not read-only.

Prior Anvil Successor reference material and lessons-learned remain at
`E:\Skyrim AI Modlist\anvil-successor\` and `E:\Skyrim AI Modlist\lessons-learned.md`.

---

## 2026-07-09 — Plugin count baseline recorded

Nolvus Awakening V6 ships with **228 of 254 active plugins** — 26 slots of headroom. This is the baseline for the Successor profile before any additions or removals. Every task that adds or removes plugins must record the new count in its Result. Prefer ESL-flagged mods for additions; flag any task that would push the count above 245 for human review before proceeding.

---

## 2026-07-08 — Project created; Nolvus Awakening V6 as donor list

Pivoting from the bottom-up Anvil Successor build to a top-down approach
using Nolvus Awakening V6 as the donor. Nolvus already includes ~99% of
desired content and ships with deep SR Exterior Cities (SREX) integration
across all hold exteriors. The Nolvus city stack is treated as
non-alterable — the SREX patch web is load-bearing and will not be
disrupted. Curation work will focus on trimming unwanted mods and adding
genuine gaps that do not touch the city/exterior ecosystem.

Reference material from the Anvil Successor project is preserved at
`E:\Skyrim AI Modlist\anvil-successor\` and `E:\Skyrim AI Modlist\lessons-learned.md`.
