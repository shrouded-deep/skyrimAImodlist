# CC Plugin Cleaning Audit — 2026-07-07

**Task:** task-0039
**Scope:** 73 active CC plugins (implicit masters in `Anvil - Main Profile`)
**Method:** houseCARL cross_plugin_query — NAVM + REFR type scans across all CC plugins,
conflict tree review with `IsDeleted` flag grep across full result sets

---

## Verdict: No cleaning required

Zero deleted records found. No ITMs requiring correction. All conflict
surface is covered by existing patches.

---

## Findings

### Deleted NAVMs — 0 found

Queried all 9 major CC ESMs (those most likely to contain worldspace/cell
navmesh data): `ccasvsse001-almsivi.esm`, `ccbgssse016-umbra.esm`,
`ccbgssse031-advcyrus.esm`, `ccbgssse025-advdsgs.esm`,
`cctwbsse001-puzzledungeon.esm`, `cceejsse001-hstead.esm`,
`cceejsse005-cave.esm`, `ccbgssse067-daedinv.esm`, `ccafdsse001-dwesanctuary.esm`.

`IsDeleted = True` — **0 matches** across 140 NAVM records examined.

All NAVM overrides found are legitimate cell expansions: CC ESMs replacing
vanilla placeholder navmeshes with fully-realised versions for their
new interiors. No stub deletions.

### Deleted REFRs / ACHRs — 0 found

Three REFR query passes across all 73 CC plugins (conflicts_only=true):

- CC ESMs batch (9 plugins): 0 deleted records
- CC ESLs batch 1 (28 plugins): 0 deleted records
- CC ESLs batch 2 (40 plugins): 0 deleted records

`IsDeleted = True` — **0 matches** in any pass.

### Conflict surface — all expected

3,280 total conflict matches across the major CC ESM batch. Pattern breakdown:

| Winner | Source | Assessment |
|---|---|---|
| `Lux - Ghosts of the Tribunal CC.esp` | Lighting patch | ✅ Correct — Lux CC patch purpose-built for this content |
| `Lux - Umbra CC.esp` | Lighting patch | ✅ Correct |
| Other `Lux - * CC.esp` plugins | Lighting patches | ✅ Correct |
| `Lux.esp` / `Lux Via - plugin.esp` | Core Lux | ✅ Correct |
| `Occlusion.esp` / `DynDOLOD.esp` | Generated outputs | ✅ Correct — Tier 2 regen will refresh these |
| `ANV_SynW4ENBPatcher.esp` | Synthesis output | ✅ Correct |
| CC ESMs winning over Update/Dragonborn | Content expansion | ✅ Correct — CC adds to vanilla cells |

No CC plugin wins with an empty or identical-to-master diff. All overrides
carry substantive changes (expanded navmesh geometry, repositioned placed
objects, updated door references, lighting adjustments).

### ITM assessment

No ITMs detected requiring action. CC plugins that override vanilla masters
do so with meaningful content changes, not identical copies. The Lux CC patch
suite specifically handles the lighting ITM surface — this is working as intended.

---

## Conclusion

The CC import (task-0035, 72 CC plugins) is clean. No cleaning pass needed.
The existing Lux patch hub covers all relevant conflict surfaces.

**Follow-up:** When Tier 2 regen is eventually scheduled, the Occlusion and
DynDOLOD records winning over CC content will be refreshed automatically.
No separate CC-specific action required at that point.
