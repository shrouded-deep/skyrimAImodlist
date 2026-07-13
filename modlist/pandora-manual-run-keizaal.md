# Pandora Manual Run Checklist — Keizaal - Fork

MO2 prep for **task-0064** is complete. **Pandora must be launched manually**
through MO2's executable toolbar — agents cannot run it (`AGENTS.md`).

**Instance:** `E:\Skyrim\`  
**Profile:** `Keizaal - Fork`  
**MO2 tool:** `#6 Pandora` (toolbar)  
**Output mod:** `Keizaal - Pandora Output` (empty until regen)

Adapted from Anvil `pandora-manual-run.md` (git `d19c733`).

---

## Gotchas (read first)

### Settings.json is global

`%LocalAppData%\Pandora Behaviour Engine\Settings.json` is **not per MO2 instance**.
If you last ran Pandora on Anvil or another list, paths may point elsewhere.

**Before every Keizaal run**, confirm:

| Key | Required value |
|---|---|
| `gameDataPath` | `E:\Skyrim\root\Data` |
| `outputPath` | `E:\Skyrim\mods\Keizaal - Pandora Output` |

Close Pandora before editing JSON. Wrong paths = empty patcher or output in wrong folder.

### MO2 tool must point at tools folder exe

Binary: `E:\Skyrim\tools\Pandora\Pandora Behaviour Engine+.exe`  
Working directory: `E:\Skyrim\tools\Pandora`  
Arguments: **empty** (no batch wrapper)

If MO2 reverts executable settings after hand-editing `modorganizer.ini`, use **Edit
Executables** in MO2 UI instead.

### ActiveMods.json schema

If Pandora crashes on startup with `ArgumentNullException` in `ApplySettings`, delete
`Keizaal - Pandora Output\Pandora_Engine\ActiveMods.json` and relaunch. Correct entry
shape: `{ "code": "colis", "active": true, "priority": 0 }` (camelCase only).

### Do not launch the game before regen

Nemesis output is disabled and cleared. Without Pandora `.hkx` in `Keizaal - Pandora
Output`, expect broken/T-pose animations.

---

## Pre-flight checklist

1. **MO2 closed during prep** — reopen MO2 on `Keizaal - Fork`; press **F5** to refresh.
2. Confirm modlist state:
   - **Enabled:** `Keizaal - Pandora Output`, `Universal Behaviour Runtime - Auto Skeleton Patch`, `Bundled Behaviour Patches (Nemesis legacy)`, all Nemesis patch-input mods (TDM, Precision, Weapon Switch, Hammering, Offset Movement, etc.)
   - **Disabled:** `Pandora Behaviour Engine+` (MO2 mod), Nemesis Engine, Nemesis Output, Nemesis Creature mods
3. Edit `Settings.json` (see table above).
4. Optional: clear MO2 overwrite `meshes/actors/**/behaviors/` if stale Nemesis files remain.

---

## Run Pandora

1. Select profile **Keizaal - Fork**.
2. Click MO2 toolbar **Pandora** (executable #6).
3. In Patcher UI, enable patches per `modlist/pandora-migration-plan-keizaal-2026-07-12.md` § Pandora patch manifest:
   - Core: `pandora`
   - Bundled: `rthf`, `turn`, `pscd`
   - TDM: `tdmv`, `tdmlen`, `tdmh`
   - Fork-specific: `colis`, `colisc`, `wsaf`, `haasf`, `gpma` (if listed)
   - **Leave unchecked:** demo/sample patches (`zcbe`, `gender`, `amco`, …), XPMSSE patch (UBR handles skeleton)
4. Click **Launch** / generate.
5. Check `Keizaal - Pandora Output\Pandora_Engine\Engine.log` for errors.
6. Verify output mod contains `.hkx` under `meshes/actors/**/behaviors/`.

---

## In-game smoke test

Minimum checks after regen:

| Test | What to verify |
|---|---|
| 3P movement | TDM 360° move, procedural lean, horse archery |
| Draw / sheath | Weapon switch while moving (`wsaf`) |
| Combat | Precision hit detection, recoil, upper-body pitch |
| Crafting | Hammering loop (`haasf`) |
| Werewolf | Transform + combat (replaces Nemesis Creature addons) |
| OAR idle | Random idle from animation replacer stack still plays |

If T-pose or frozen combat: re-check Settings.json paths and that `Keizaal - Pandora
Output` is **enabled** and high in modlist (Outputs separator).

---

## After success

- Keep Nemesis Engine mod folder archived or remove from MO2 (optional).
- Log outcome in playtest notes; report Precision/Offset Movement issues if patches were missing from Patcher UI.
