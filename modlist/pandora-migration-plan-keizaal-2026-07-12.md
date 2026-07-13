# Nemesis → Pandora Migration Plan — Keizaal - Fork

Research and MO2 prep for **task-0064**. **Do not run Pandora.exe from this document**
— human runs regen via MO2 toolbar (see `modlist/pandora-manual-run-keizaal.md`).

**Instance:** `E:\Skyrim\` · Profile: `Keizaal - Fork`  
**Current engine (pre-migration):** Project New Reign - Nemesis v0.84  
**Target engine:** [Pandora Behaviour Engine+](https://www.nexusmods.com/skyrimspecialedition/mods/133232) v4.3.1-beta  
**Anvil reference:** task-0016 / task-0018, archived `modlist/pandora-migration-plan.md` (git `77080bf`)

---

## Executive summary

Keizaal - Fork is a **deep animation list** (OAR/DAR, VB combat, Precision, TDM, 40+
animation replacers). Unlike Anvil's lightweight 15-input Nemesis stack, Fork has **7
enabled Nemesis patch-input mods** plus engine-bundled samples — and **Precision** (not
present on Anvil) as the highest-risk input.

**Compatibility verdict:** Standard Nemesis-format patches (TDM, Weapon Switch, Hammering,
Precision) are **expected compatible** with Pandora (reads same `Nemesis_Engine/mod/`
layout). **UBR** (176724) and **Bundled Behaviour Patches** are installed. Nemesis
engine, output, and creature-compat mods are **disabled**. Empty **`Keizaal - Pandora
Output`** is enabled at top of Outputs separator.

**Critical:** `Project New Reign - Nemesis Output` was **stale** (last PatchLog
2024-09-30; 40 `.hkx` cleared during prep). Treat all Nemesis output as untrusted until
Pandora regen completes.

**DynDOLOD / Synthesis / ParallaxGen:** no Nemesis dependency (same as Anvil).

---

## Fork Nemesis input audit

Scan method: all **enabled** mods in `profiles/Keizaal - Fork/modlist.txt` checked for
`Nemesis_Engine/` folder presence (2026-07-12).

| Mod | Enabled | Has `Nemesis_Engine/mod/` | Engine ID(s) | Pandora coverage | Notes |
|---|---|---|---|---|---|
| True Directional Movement - Modernized Third Person Gameplay | Yes | Yes | `tdmv`, `tdmlen`, `tdmh` | **Yes** | Same as Anvil; 3 patches only (log `name=` may differ from ID) |
| Weapon Switch Animation Fix - Behavior Patch Version | Yes | Yes | `wsaf` | **Yes** | Mod page: Nemesis or Pandora |
| Hammering Animation and Sound Fixes | Yes | Yes | `haasf` | **Yes** | Install file: NEMESIS or PANDORA |
| Precision | Yes | Yes | `colis` | **Expected yes** | Author recommends Nemesis; Pandora reads Nemesis format — **smoke-test combat pitch/recoil** |
| Precision Creatures | Yes | Yes | `colisc` | **Expected yes** | Creature behaviour patch; Pandora has native creature support |
| Offset Movement Animation - Nemesis - Modders Resource | Yes | Yes | `gpma` | **Unknown** | Modders resource; not on Anvil list — enable in Pandora if listed; flag if missing |
| Project New Reign - Nemesis Unlimited Behavior Engine | **Disabled** | Yes | `nemesis`, `pscd`, `rthf`, `turn` + 11 demo samples | N/A (tool) | Production patches moved to **Bundled Behaviour Patches**; do **not** enable demo IDs (`zcbe`, `gender`, `tudm`, etc.) |
| Project New Reign - Nemesis Output | **Disabled** | No (output only) | — | N/A | Contents cleared (0 `.hkx`); mod disabled |
| Nemesis Creatures Behaivour Compatibility | **Disabled** | No | — | **Remove** | Pandora native creatures — not needed (Anvil precedent) |
| Nemesis Creature Behaivour - Werewolf Addon | **Disabled** | No | — | **Human decision** | Werewolf-specific Nemesis-era addon; likely obsolete with Pandora — confirm in werewolf smoke test |
| Retimed Hit Frames | Yes | No | — (mesh override) | N/A | Direct `meshes/` override; behaviour side covered by bundled `rthf` in **Bundled Behaviour Patches** |

### Engine-bundled samples (in Nemesis engine mod — do NOT enable in Pandora)

When Pandora scans `tools/Pandora/` it may also list demo patches (`zcbe`, `gender`,
`amco`, etc.). **Leave unchecked.** Production bundled patches (`rthf`, `turn`, `pscd`,
`nemesis`) come from **Bundled Behaviour Patches (Nemesis legacy)**.

### Enabled animation mods — NOT Nemesis-dependent

OAR/DAR replacers, Immersive Animations DAR, Classic Sprinting Redone, TDM satellite
plugins (Lock-on Fixes, Tail Animation Fix, Diagonal Sprinting, etc.), Open Animation
Replacer, and the ~40 mods under Keizaal's `Animations_separator` do **not** ship
`Nemesis_Engine/mod/` and are unaffected by the engine swap (same as Anvil).

### Anvil inputs NOT on Fork

Fork does **not** ship: USSEP Behaviour Patch, Barstool Exit, Grain Mill, Bards
Ghostly, Horsemen Torch, First Person Teleport Bug Fix, Serana Hood anim. No action
needed.

---

## Phase B — MO2 prep (completed 2026-07-12)

| Component | Action | Status |
|---|---|---|
| Pandora Behaviour Engine+ | Copied from Anvil `mods\`; **disabled** in modlist (exe at `E:\Skyrim\tools\Pandora\`) | Done |
| Universal Behaviour Runtime - Auto Skeleton Patch | Copied from Anvil; **enabled** | Done |
| Bundled Behaviour Patches (Nemesis legacy) | Copied from Anvil; **enabled** (`nemesis`, `rthf`, `turn`, `pscd`) | Done |
| Keizaal - Pandora Output | Created empty; **enabled** in Outputs separator | Done |
| Nemesis Engine + Output | **Disabled**; output `.hkx` cleared | Done |
| Nemesis Creature mods | **Disabled** | Done |
| MO2 executable #6 | Updated to Pandora at `E:\Skyrim\tools\Pandora\` | Done |

### Modlist placement

```
+Outputs_separator
+Keizaal - Pandora Output          ← empty until regen
+DynDOLOD Output / TexGen / xLODGEN
+Universal Behaviour Runtime - Auto Skeleton Patch
+Bundled Behaviour Patches (Nemesis legacy)
-Pandora Behaviour Engine+          ← tool mod, not mounted
```

---

## Fork-only inputs — human decisions

| Item | Risk | Recommendation |
|---|---|---|
| **Precision + Precision Creatures** | High — core combat mod | Enable `colis` + `colisc` in Pandora; full 3P combat + hit-stop smoke test |
| **Offset Movement Animation (`gpma`)** | Medium — unknown on Pandora | Enable if Pandora lists it; if absent, test offset movement anims in-game |
| **Nemesis Creature Werewolf Addon** | Low — disabled | Likely drop permanently; test werewolf transform/combat after regen |
| **Retimed Hit Frames** (mesh mod) | Low | Keep enabled; distinct from bundled `rthf` behaviour patch |
| **Deep OAR stack** | Low for migration | No Pandora action; watch for T-pose if regen incomplete |

---

## Stale output risk

| Risk | Severity | Detail |
|---|---|---|
| Nemesis output from 2024-09-30 | **High** | 40 `.hkx` removed; mod disabled — game must not launch until Pandora regen |
| Wrong Settings.json from another list | **High** | Global `%LocalAppData%\Pandora Behaviour Engine\Settings.json` — verify Fork paths every run |
| Precision without behaviour patch | **High** | Collisions/recoil degrade without `colis`/`colisc` in output |
| DynDOLOD outputs also stale (task-0060) | **Medium** | Unrelated to Pandora; LOD regen still deferred |

---

## Pandora patch manifest (Fork)

Enable in Pandora Patcher UI after launch (exact row count may vary; engine demos appear — leave unchecked):

| Code | Source mod |
|---|---|
| `pandora` | Core (from `tools/Pandora/`) |
| `rthf`, `turn`, `pscd` | Bundled Behaviour Patches |
| `tdmv`, `tdmlen`, `tdmh` | True Directional Movement - Modernized Third Person Gameplay |
| `wsaf` | Weapon Switch Animation Fix |
| `haasf` | Hammering Animation and Sound Fixes |
| `colis` | Precision |
| `colisc` | Precision Creatures |
| `gpma` | Offset Movement Animation (if listed) |

**Do not enable:** Nemesis Creature Compatibility, Pandora XPMSSE checkbox (UBR handles XPMSSE), engine demo patches.

---

## Settings.json — Keizaal - Fork paths

File: `%LocalAppData%\Pandora Behaviour Engine\Settings.json`

| Key | Required value |
|---|---|
| `gameDataPath` | `E:\Skyrim\root\Data` |
| `outputPath` | `E:\Skyrim\mods\Keizaal - Pandora Output` |

Verify before **every** Pandora run on this profile (global file shared across modlists).

---

## Phase C — Human only

See **`modlist/pandora-manual-run-keizaal.md`** for step-by-step regen and smoke test.

---

## Acceptance

- [x] This plan written with full audit table
- [x] Phase B MO2 prep on Keizaal - Fork
- [x] Nemesis output cleared/disabled; Pandora output empty and enabled
- [x] Manual run doc written
- [x] No Pandora.exe execution by agent
- [x] `decisions.md` entry added
