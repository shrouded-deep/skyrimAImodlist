# Keizaal Fork-Test Audit

**Date:** 2026-07-12  
**Task:** task-0046  
**Profile audited:** `Keizaal` (pristine Wabbajack install)  
**Working fork profile:** `Keizaal - Fork` (identical copy, no changes yet)  
**MO2 instance:** `E:\Skyrim\`  
**Verdict:** ✅ **ADOPT** — proceed with Keizaal as foundation

---

## 1. Hard filter confirmation

| Filter | Result |
|--------|--------|
| **No Requiem** | ✅ Confirmed — no Requiem plugin anywhere in load order or disabled mods |
| **1170-native** | ✅ Confirmed — `SkyrimSE.exe` version `1.6.1170.0` |
| **Community Shaders** | ✅ Confirmed — CS mod enabled; no ENB DLLs in `E:\Skyrim\root\` |

---

## 2. Plugin count baseline

| Metric | Count |
|--------|-------|
| Total plugins in load order | **773** |
| Active checked (.esp/.esm/.esl) | **719** |
| Implicit masters / CC plugins | **54** |
| Inactive plugins | 0 |
| `.esl` files (active) | 50 |
| `.esp` files (active) | 665 |
| `.esm` files (active) | 4 |
| Disabled mods | 78 (SimonRim profile content — see §4) |

**Plugin budget note:** The 254-plugin hard limit applies to full-weight ESP/ESM only (ESL-flagged plugins don't count toward it). With 665 active .esp + 4 .esm = **669 full-weight plugins** already active, the project's prior "flag above 245" rule is not directly applicable here as stated — Keizaal is already a much larger list than Nolvus. The budget rule should be updated: track **total active plugins** (currently 719) and flag any addition that is not ESL-flagged for human review.

---

## 3. List-specific ESP footprint (Keizaal glue)

### Keizaal-owned plugins (~42)

Plugins with `Keizaal` in the name — list-authored patches, tweaks, and utility files:

| Category | Count | Examples |
|----------|-------|---------|
| `Keizaal Patch - *` | ~28 | Bruma-EVG Traversal, CoMAP-LCO, Enchanted Item Name-TD, Wares of Wyrmstooth-TD |
| `Keizaal Tweaks - *` | ~11 | Fancy Fishing, Mainland Staff Enchanters, Shirley, Wyrmstooth |
| Core | 3 | `Keizaal Maintenance.esp`, `Keizaal Presets.esp`, `Optional Quick Start - Keizaal Cut.esp` |
| Parse error | 1 | `Description Framework - Keizaal Cut.esp` (see §6) |

### Tamrielic Distribution plugins (~24)

TD is Keizaal's primary list-glue mechanism — it handles leveled-list distribution for added armor/weapon/item mods. Each integration is a **separate plugin per supported mod**, making the footprint modular:

| Plugin | What it distributes |
|--------|---------------------|
| `Tamrielic Distribution.esp` | Core framework |
| `Tamrielic Distribution - Lucien.esp` | Lucien follower items |
| `Tamrielic Distribution - Wyrmstooth.esp` | Wyrmstooth loot |
| `Tamrielic Distribution - BS Cyrodiil.esp` | Beyond Skyrim: Bruma loot |
| `Tamrielic Distribution - Rare Curios.esp` | CC Rare Curios |
| `Tamrielic Distribution - Crossbow Collection.esp` | Crossbow loot |
| + 18 more | One plugin per supported mod |

**Modularity assessment:** TD's per-mod plugin structure is fork-friendly. Adding a mod = enable the corresponding TD plugin (or author one). Removing a mod = disable its TD plugin without cascading breakage. This is the opposite of a Nolvus-style baked patch web.

**Total list glue: ~66 plugins.** Substantial but legible and modular. Nolvus had hundreds of opaque, interdependent patches — Keizaal's glue is comprehensible.

---

## 4. Disabled mods (SimonRim profile content)

All 78 disabled mods in the `Keizaal` vanilla+ profile are SimonRim-specific content — the alternate gameplay framework for the `Keizaal - SimonRim` profile. These include Adamant, Mysticism, Blade & Blunt, Apothecary, Pilgrim, Mundus, Manbeast, Aetherius, Scion, Arena, and their respective patches.

**These are not a concern for our fork.** They are already segregated by MO2 profile and will remain disabled in `Keizaal - Fork`.

---

## 5. Removability sample

### Mod 1: Wyrmstooth (quest/worldspace)

**Patches that would break on removal (12 plugins):**

- `LCO_Wyrmstooth.esp`
- `Rise of Wyrmstooth.esp`
- `WaresOfWyrmstooth.esp`
- `Blackreach Mudcrabs - Wyrmstooth Patch.esp`
- `AdamantiumAddon - Wyrmstooth Addon.esp`
- `Wyrmstooth - EECO Building Navmesh Patch.esp`
- `Tamrielic Distribution - Wyrmstooth.esp`
- `BURP_Wyrmstooth.esp`
- `WyrmstoothMapTweaks.esp`
- `Keizaal Tweaks - Wyrmstooth.esp`
- `Keizaal Patch - Wares of Wyrmstooth - Tamrielic Distribution.esp`

**Assessment:** Moderate web — 12 dependents, but all are clearly Wyrmstooth-scoped and can be disabled together. No hidden surprises. **Removable with discipline.**

### Mod 2: Lucien (follower)

**Patches that would break on removal (24 plugins):**

The bulk are from Lucien's own official patch pack (standard for this follower — the author ships patches for all common mods). Keizaal-specific additions: `COTN Falkreath - Lucien Patch.esp`, `Tamrielic Distribution - Lucien.esp`, `The Jelidity Mixtape - Lucien Patch.esp`.

**Assessment:** Large patch count but almost entirely from Lucien's own bundled patches — this is normal for Lucien, not a Keizaal-specific problem. Removing Lucien means disabling his patch pack as a block. **Removable, just noisy.**

### Mod 3: Happy Little Trees (visual)

**Patches:** 1 plugin (`HappyLittleTrees.esp`), no dependents found.

**Assessment:** Clean, isolated visual mod. **Trivially removable.**

**Overall removability verdict:** Keizaal's patch structure is standard and well-scoped. No hidden load-bearing mega-patches. The Keizaal Patch/Tweaks files are the only real list-owned glue, and they each address a specific mod pair — they're not opaque multi-mod integration ESPs.

---

## 6. Issues and flags

### Parse error: `Description Framework - Keizaal Cut.esp`

houseCARL cannot parse this plugin (missing EDID subrecord on a GameSetting record). houseCARL excludes it from record resolution this session. Impact: records in this plugin are not visible to houseCARL. **Action:** Investigate whether this plugin is load-bearing or can be replaced/removed. Do not block fork work on this — it predates our fork.

### Plugin budget rule update needed

The existing AGENTS.md budget rule ("flag above 245 active plugins") was written for Nolvus (228 baseline). Keizaal's baseline is **719 active plugins**. The rule needs updating to reflect the new list scale. See decisions.md update.

---

## 7. Verdict

**ADOPT — Keizaal is the foundation.**

- ✅ 1170-native
- ✅ No Requiem
- ✅ Community Shaders (no ENB migration needed)
- ✅ List glue is modular and legible (~66 plugins, not a Nolvus-class baked web)
- ✅ Removability confirmed on all three sample mods
- ✅ SimonRim content cleanly segregated and already disabled
- ⚠️ `Description Framework - Keizaal Cut.esp` parse error — flag for investigation, not a blocker
- ⚠️ Plugin budget rule needs updating for 719-plugin baseline

**Next steps:**
- Update AGENTS.md plugin budget rule (task implied by this audit)
- Investigate `Description Framework - Keizaal Cut.esp` parse error
- Begin Vokriinator Black compatibility research (long-term gameplay overhaul target)
