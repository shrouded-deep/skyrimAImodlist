# Decisions Log

Dated entries recording what changed and why. Most recent first.

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
