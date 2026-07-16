# Decisions Log

Dated entries recording what changed and why. Most recent first.

---

## 2026-07-16 — Alphabetize separator groups (task-0100)

Sorted mods A–Z within separator groups for **oStim→JKs Skyrim** and
**Audio→Core & Frameworks** on `Lost Legacy - Fork`. Donor graphics sub-separators
from task-0099 left unchanged.

## 2026-07-15 — Donor wave 2 graphics replace + staging (task-0098)

Copied/renamed **907** donor AE folders into `Lost Legacy - Fork` with overwrite.
**Graphics 016–066** (793 entries including donor sub-separators) enabled above
`-Graphics Improvements_separator`, replacing the prior GI block (48 leftover LL
graphics mods disabled beneath the new stack). **Non-graphics 068–094** (114)
staged **disabled** at the bottom for task-0075. Plugins 2031 → 2249. Prefix **065
ENB Particle Lights** flagged for CS compatibility review before launch.

## 2026-07-14 — ModEx + Cheats stack from Anvil (task-0097)

Added Anvil Dev Tools (ModEx, Debug Menu) and 14 cheat/utility mods into
`Lost Legacy - Fork` as new `-Dev Tools_separator` / `-Cheats_separator` sections
immediately above `-MCMs_separator` (below oStim). Prisma UI Additem Menu was
already present; ModEx still installed as a separate explorer menu. Active plugins
2018 → 2031.

## 2026-07-14 — Donor AE import installed (tasks 0078–0095)

867 selected folders from `D:\Skyrim AE\mods` were copied into `D:\Skyrim\mods\`
earlier; tasks **0078–0095** renamed them (strip `NNN.NNN ◉` + `[NoDelete]`),
placed them into `Lost Legacy - Fork` sections, and enabled root-level plugins.

**New separators:** `AI` (above NPCs), `Combat` (above Followers), `oStim` (above MCMs).
**Plugin count:** ~1584 → **2018** active after a selective re-enable of 12 donor
MAST-off plugins whose masters arrived later in the batch (DBVO/AYOP, IMMORTAN peers,
AelaRevoicedOStimVoice). Remaining MAST-off plugins stay off (missing masters).
**Do not** bulk-star inactive LL plugins — many are intentionally unused optionals.

FOMODs were flagged only, not run (see task-0075). Spaghetti cities remain disabled.

## 2026-07-12 — Engine Fixes was wiping plugins.txt on every game exit (Fork crash root cause)

MO2 maps `AppData\Local\Skyrim Special Edition\Plugins.txt` → profile `plugins.txt`
(USVFS). **SSE Engine Fixes** with `EnableAchievementsWithMods = true` causes the game
to rewrite that file on launch/exit, stripping all mod plugin `*` flags. MO2 then
imports the emptied list — plugins look checked before launch, all unchecked after crash.

**Fix:** `overwrite\skse\plugins\EngineFixes.toml` override on Fork:
`EnableAchievementsWithMods = false`, `SaveAddedSoundCategories = false`,
`SaveScreenshots = false` (STEP recommendation for AE 1.6.1170 + MO2). Restore plugins
from `plugins.txt.good-2026-07-12` after any launch that still clears them.

**Note:** Initial diagnosis blamed MO2 F5 refresh; user confirmed plugins were checked
at launch and cleared *after* crash — Engine Fixes write-back is the actual mechanism.
Restore scripts remain useful if enablement is lost for any reason:
`scripts\restore-fork-plugins-all.ps1`.

## 2026-07-12 — Game Settings Override incompatible on Fork (Win11 24H2 + MO2 USVFS)

**Game Settings Override** (114911) + **Collection** (119358) were installed from Anvil
fundamentals tranche (task-0067). **Not on pristine Keizaal.** On this host (Win11 24H2,
MO2 2.5.2, usvfs 0.5.6.1), GSO fatals at launch: TOML files cannot be opened through MO2's
virtual filesystem ([MO2 #2174](https://github.com/ModOrganizer2/modorganizer/issues/2174)).
Upgrade 2.5.0→2.5.2 and multiple file-layout workarounds did not fix it.

**Decision:** **Disable both GSO mods** on `Keizaal - Fork`. No gameplay regression vs
original Keizaal. Anvil parity for GSO **deferred** until official MO2 USVFS fix lands.
Documented in `modlist/mo2-upgrade-plan-keizaal-2026-07-12.md`. Collection tweaks can be
replaced later via standalone Nexus ports if wanted.

## 2026-07-12 — Pandora migration rolled back (post-load crash)

After task-0064, user ran Pandora but game **crashes after splash** with no Crash Logger
output. `Keizaal - Pandora Output/Engine.log` shows **Precision Creatures parser errors**
and incomplete regen (**33** `.hkx` only). Nemesis output `.hkx` had been **cleared** (0
remain). **Rolled back modlist:** Pandora Output / UBR / Bundled Behaviour Patches
**disabled**; Nemesis Engine + Output + creature compat **re-enabled**; MO2 toolbar #6
restored to Nemesis. **Human:** run Nemesis → Update Engine before launching SKSE.
Pandora migration **deferred** until clean full regen is verified.

## 2026-07-12 — Nemesis → Pandora MO2 prep on Keizaal - Fork (task-0064)

Mirrors Anvil's Pandora toolchain (task-0018) with **Fork-specific audit deltas**:

- **Precision + Precision Creatures** added to Pandora patch manifest (`colis`/`colisc`) —
  not on Anvil; author documents Nemesis; Pandora reads same patch format — smoke-test
  combat after regen.
- **Offset Movement Animation** (`gpma`) flagged unknown — modders resource not on Anvil
  list; enable in Pandora if listed.
- **Nemesis Creature Werewolf Addon** disabled with compat mod; Pandora native creatures
  — werewolf smoke test replaces Nemesis creature stack.
- Nemesis output (2024-09-30 PatchLog) cleared and disabled; empty **`Keizaal - Pandora
  Output`** at Outputs separator top; UBR + Bundled Behaviour Patches enabled.
- Pandora exe at `E:\Skyrim\tools\Pandora\` (MO2 #6); engine MO2 mod disabled.
- **Regen deferred to human** — do not launch game until Pandora fills output mod.

Plan: `modlist/pandora-migration-plan-keizaal-2026-07-12.md` · Manual run:
`modlist/pandora-manual-run-keizaal.md`

## 2026-07-12 — Outputs category at highest priority; regen deferred (task-0061)

**Priority direction (definitive):** `modlist.txt` TOP = HIGHEST priority, BOTTOM = LOWEST
(base-game separator is at the file bottom). This is the reverse of the MO2 UI.

Keizaal ships its generated LOD outputs (`DynDOLOD Output`, `TexGen Output`, `xLODGEN`)
near the file BOTTOM = LOW priority. With our additions now under `Uncategorized` (top =
high priority), the additions were overriding the outputs' loose LOD files (user spotted).

**Fix (task-0061):** Created an `Outputs` separator at the very top of the file (highest
priority) and moved the 3 generated outputs there, above the Uncategorized additions.
Left `DynDOLOD DLL` / `DynDOLOD` (Resources) in place — runtime inputs, not outputs.
Backup: `modlist.backup-outputs-2026-07-12.txt`.

**Deferred (task-0060, user-gated):** the outputs are also STALE — the city expansions add
worldspace buildings with no generated LOD. A Tier-2 regen (xLODGen → TexGen → DynDOLOD +
grass cache) is required, run via the GUI tools by the user. **Deferred by user for now.**

**Correction:** the task-0058 decision note (below) originally stated the priority
direction backwards. Top of file = HIGHEST, not lowest.

## 2026-07-12 — Fixed addition placement; additions go under Uncategorized (task-0058)

The VB/city install scripts appended additions to the END of `modlist.txt`, outside any
separator — they showed ungrouped at the MO2 UI top. Moved all 65 additions under the
`Uncategorized` separator (above the `+Uncategorized_separator` line, since a separator
owns the mods above it). First attempt put them BELOW the separator → landed in `SimonRim`;
corrected to above. Only mod/asset priority changed; loadorder.txt untouched (MAST
unchanged). Backup: `modlist.backup-reorg-2026-07-12.txt`.

**Rule restored** in AGENTS.md ("Mod placement in MO2"): additions → Uncategorized; never
append to end. This rule had been genericized/lost across the Nolvus→Keizaal pivot.

---

## 2026-07-12 — Restored 3 omitted CC creations for PoS patches (task-0057)

The VB stack (copied from Nolvus) shipped Path of Sorcery patches for 3 Creation Club
creations Keizaal curates OUT — leaving missing masters that would CTD at load. User
spotted the MO2 warning icons; houseCARL's summary had NOT caught them (it verifies
plugin files exist but tolerates missing master references — use
`scripts/full-mast-scan.ps1` for real MAST audits).

**Decision:** Restore the CC content rather than disable the patches — keeps PoS's
balancing and gives the player the content. New standalone mod `Restored CC - Arcane
Accessories, Bittercup, Necromantic Grimoire` (3 esl + 3 bsa from the user's own AE
install), enabled at top priority; Keizaal's own mods untouched (pristine). The one
patch needing Immersive Sounds Compendium (`DISCO_VokriinatorISCPatch.esp`, not CC) was
disabled instead.

**Result:** `Keizaal - Fork` **824 active, 0 missing masters, load order clean.** 3 CC
now force-loaded as implicit masters (54 → 57). Full-weight unchanged (~104/254). Re-adds
gameplay Keizaal cut (Bittercup, Necromancy, Arcane staves) — deliberate; watch in smoke
test.

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

**Also applied to `Lost Legacy - Fork` (2026-07-13):** same 8 Spaghetti/CWE-bridge mods
disabled in modlist after task-0069 city-stack install (folders remain on disk; modlist
`-` prefix). Standalone expansions retained per table above. CWE Spaghetti Patch and
Crossed Daggers - Spaghetti Patch disabled with the Spaghetti drop. Confirmed intentional
by human — not a task-0070 regression.

---

## 2026-07-13 — JK exteriors + Anvil Ryn stack on Lost Legacy Fork (task-0073)

Replaced Lost Legacy's packaged `Ryn's Locations` bundle with Anvil's individual Ryn's
location mods (32 folders). Disabled LL `Ryn's Locations` and `Ryn's Standing Stones
Patch Collection` in modlist; Anvil Standing Stones hub imported as
`Ryn's Standing Stones Patch Collection - Anvil` (name collision — LL folder kept on
disk, not overwritten).

Imported 8 JK **exterior** worldspace mods from Anvil (outskirts ×4, Riverfall
Cottage, three Outskirts patch hubs). JK interiors already in Fork were skipped; AIO
remains disabled per city-stack swap.

**`Lost Legacy - Fork`: 1452 → 1679 active plugins, 0 MAST violations** (331 optional
hub patches auto-disabled for absent masters).

---

## 2026-07-13 — Settlement overhaul stack on Lost Legacy Fork (task-0074)

Installed hold towns, villages, and hamlets into new `-Settlements_separator`
section (above City Stack): COTN Dawnstar/Falkreath, TGC Winterhold/Dragon Bridge,
JK's Solitude Outskirts, Fortified Morthal, Thuldor's Ivarstead, TGV/TGT village
set, Anga's/Half-Moon COTN addons, Settlements Expanded, RedBag's Rorikstead (base
only). **34 mod folders** from `E:\Modding\Skyrim Mods\Downloads\`; implicit TGC
Resources (104373) pulled as master dependency.

Spaghetti remains dropped. COTN Morthal plugins skipped (Fortified Morthal used
instead). **64187** (Rorikstead FOMOD patches) missing from Downloads — task-0076
(download) + task-0075 (FOMOD once archive present).

**Update (task-0077):** Five settlement mods re-extracted (bad archive dumps); empty
`City Stack_separator` removed — all city + settlement mods under `Settlements_separator`
only. 1676 → 1680 active plugins; 0 MAST violations.

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
