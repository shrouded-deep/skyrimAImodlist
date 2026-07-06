# Pandora Manual Run Checklist

MO2 prep for task-0018 is complete. **Pandora must be launched manually**
through MO2's executable toolbar — do not use `--auto_run` or external shortcuts.

**Instance:** `D:\Skyrim AI Modlist\Anvil`  
**Profile:** `Anvil - Main Profile`  
**MO2 tool:** `#6 Pandora` (toolbar enabled)

---

## Gotchas — symptom → cause → fix

**Read this first** if Pandora misbehaves. Each entry is standalone — no need to
re-derive from session history. Procedural checklists are below.

### Empty Patcher / **0 patches** / FATAL `ArgumentNullException` in `ApplySettings`

| | |
|---|---|
| **Symptom** | Patcher list empty or startup crash; `Engine.log` has `Startup failed` / `ArgumentNullException` in `ModService.ApplySettings`. |
| **Cause** | `ActiveMods.json` uses wrong JSON keys. Pandora v4 requires **camelCase** `code`, `active`, `priority`. Nemesis-style `id`/`enabled`, PascalCase `Code`/`Active`, or any other shape deserializes as null and crashes load. |
| **Fix** | Delete or rewrite `mods/Pandora Output/Pandora_Engine/ActiveMods.json`. Correct entry: `{ "code": "ussep", "active": true, "priority": 0 }`. Relaunch Pandora. If file was deleted, all patches default **checked** — uncheck the [13 engine samples](#patch-count-why-28-patcher-rows-but-only-15-to-enable) before Launch. |

> **ActiveMods.json schema is non-negotiable:** only **`code` / `active` / `priority`** (camelCase). Wrong keys = **full startup crash**, not a soft warning.

---

### Output in wrong folder / overwrite / another modlist's `Pandora Output`

| | |
|---|---|
| **Symptom** | Regen writes elsewhere; Anvil `Pandora Output` stays empty; or patches missing because Pandora scanned the wrong Data tree. |
| **Cause** | **`Settings.json` is global**, not per MO2 instance — `%LocalAppData%\Pandora Behaviour Engine\Settings.json`. Whichever list last opened Pandora (or edited Settings UI) wins. Saved paths **override** MO2 CLI / batch `-o` when those folders still exist on disk. |
| **Fix** | Close Pandora. Open Settings.json; set `gameDataPath` → `D:\Skyrim AI Modlist\Anvil\Stock Game\Data` and `outputPath` → `D:\Skyrim AI Modlist\Anvil\mods\Pandora Output`. Re-check **before every Anvil run** after using Pandora on another list. See [§2 pre-flight](#2-pre-flight--verify-settingsjson-required-every-run). |

---

### Pandora **closes instantly** from MO2 (no process, stale `Engine.log`)

| | |
|---|---|
| **Symptom** | MO2 toolbar launch dies immediately; direct double-click of the same exe works; `ActiveMods.json` not created/updated. |
| **Cause** | Pandora exe lives **inside MO2 `mods/`** while launched through USVFS — [Pandora #385](https://github.com/Monitor221hz/Pandora-Behaviour-Engine-Plus/issues/385). |
| **Fix** | Engine install at **`tools/Pandora/`** (outside `mods/`). MO2 tool #6 binary → `tools/Pandora/Pandora Behaviour Engine+.exe`, start-in → `tools/Pandora`. Set via [Edit Executables only](#mo2-tool-config-reverts-after-editing-modorganizerini-by-hand). |

---

### `No known mod manager detected` / far fewer patches than expected / vanilla-only scan

| | |
|---|---|
| **Symptom** | `Engine.log` says mod manager not detected; Patcher missing Anvil patch mods; only ~14 rows instead of 28. |
| **Cause** | MO2 tool points at **`Pandora MO2 Launch.bat`** (or other batch wrapper) instead of the **`.exe` directly**. Batch parent breaks MO2 VFS injection — Pandora sees plain `Stock Game\Data`, not virtual merged Data. |
| **Fix** | Edit Executables → Binary = **`.exe`**, Arguments = **empty**. Paths come from Settings.json (§2), not the batch file. **`Pandora MO2 Launch.bat` is obsolete and harmful** — do not use it. |

---

### MO2 tool config **reverts** after editing `ModOrganizer.ini` by hand

| | |
|---|---|
| **Symptom** | Ini shows correct binary/paths; next MO2 exit restores old bat path or wrong folder. |
| **Cause** | MO2 loads `[customExecutables]` at startup and **rewrites the whole ini from memory on exit**. Hand-edits while MO2 is open (or with a stale session) do not stick. |
| **Fix** | **Edit Executables dialog only** (toolbar gears → Pandora → OK → close MO2 cleanly). Verify after restart. Ini read is optional sanity-check, not the edit path. See [§4](#4-mo2-tool). |

---

### Patch count: why **28 Patcher rows** but only **15 to enable**

| | |
|---|---|
| **Symptom** | "I see 28 patches — which do I tick?" or "Where is the 16th / Serana row?" |
| **Cause** | Pandora merges **two scan sources**: (1) MO2 virtual Data — 11 Anvil patch-input mods + 3 bundled (`rthf`/`turn`/`pscd`); (2) **`tools/Pandora/` install folder** — always scanned, adds **`pandora` core + 13 demo/sample patches** (`zcbe`, `gender`, `amco`, …) for mods Anvil does **not** ship. **FNIS lists** (Serana hood) are **not** Patcher rows — logged as `FNIS Mod N` after Launch. |
| **Fix** | Enable **exactly these 15** Patcher IDs: `pandora`, `rthf`, `turn`, `pscd`, `ussep`, `tdmv`, `tdmlen`, `tdmh`, `bseaf`, `gmill`, `evegif`, `wsaf`, `tpbgfx`, `htwfmt`, `haasf`. Leave all **13 samples** unchecked. Confirm Serana via `FNIS Mod … SeranaHoodFixWithAnim` in `Engine.log`. Full table: [§5 manifest](#5-full-patch-manifest--28-patcher-rows--fnis-audit-before-launch). |

---

### TDM: only **3** patches — `tdmv` log line says **"Headtracking"** (not a missing 4th patch)

| | |
|---|---|
| **Symptom** | "TDM should have four patches" or "`tdmv` doesn't match Headtracking in the log." |
| **Cause** | Patch **ID** = folder under `Nemesis_Engine/mod/<id>/` (shown as **Code** in UI). **`Engine.log`** prints `name=` from `info.ini`. TDM ships three folders: `tdmv` → *Headtracking*, `tdmlen` → *Procedural Leaning*, `tdmh` → *360 Horse Archery*. Same patch, two labels. |
| **Fix** | Enable all three TDM rows. Do not hunt for a fourth. |

---

### Serana hood **missing from Patcher** DataGrid

| | |
|---|---|
| **Symptom** | No SeranaHoodFixWithAnim checkbox. |
| **Cause** | FNIS animlists are auto-applied in v4, not listed as Patcher modules. |
| **Fix** | After Launch, confirm `FNIS Mod … SeranaHoodFixWithAnim` in `Engine.log`. If in-game animation fails, reinstall Nexus **80336** — folder must include `.esp` and `.hkx`, not just the FNIS list file. |

---

## Before you launch

### 1. Confirm installed mods (prep complete)

| Mod | Status |
|---|---|
| Pandora Behaviour Engine+ (133232, v4.3.1-beta) | Installed at **`tools/Pandora/`** — MO2 mod entry **disabled** (tool binary only) |
| Universal Behaviour Runtime — Auto Skeleton Patch (176724, v1.0.4) | Installed — **enabled** (`SkeletonAutoPatch.dll`) |
| Bundled Behaviour Patches (Nemesis legacy) | Installed — **enabled** (nemesis/rthf/turn/pscd) |
| Pandora Output | Empty — **enabled**, high in modlist |

No additional downloads required unless you want to refresh from Nexus.

**Enabled:**

- `Pandora Output` (top of list — empty until regen)
- `Bundled Behaviour Patches (Nemesis legacy)`
- `Universal Behaviour Runtime - Auto Skeleton Patch` (after install)
- All 12 Nemesis patch-input mods (USSEP Behaviour Patch, TDM, Barstool Exit,
  Grain Mill, Bards Ghostly, Weapon Switch, First Person Teleport Bug Fix,
  Horsemen Torch, Hammering, Serana Hood, etc.)

**Disabled (tool-only or removed):**

- `Pandora Behaviour Engine+` (MO2 tool binary only — not mounted in game)
- `Project New Reign - Nemesis Unlimited Behavior Engine`
- `Anvil - Nemesis Output` (folder removed)
- `Nemesis Creature Behaviour Compatibility` (folder removed)
- Broken animation mods: Super Fast Get Up, 1st Person Greatsword, Unique
  Animations Reworked, TDM Tail Animation Fix

### 2. Pre-flight — verify Settings.json (required every run)

> **Gotcha:** [Settings.json is global, not per-instance](#output-in-wrong-folder--overwrite--another-modlists-pandora-output) — stale paths from another list silently break Anvil runs.

Pandora v4.x stores game/output paths in a **global** file (not per MO2 instance):

```
%LocalAppData%\Pandora Behaviour Engine\Settings.json
```

(`C:\Users\<you>\AppData\Local\Pandora Behaviour Engine\Settings.json`)

**Run this check before every Anvil Pandora launch** — including after using
Pandora on another modlist, after a Pandora update, or if output lands in the
wrong folder. A one-time fix does **not** persist if another list overwrites
Settings or you edit paths in Pandora's Settings UI for a different instance.

1. **Close Pandora** if it is open (it writes Settings on exit).
2. Open `Settings.json` and confirm `games.SkyrimSE` contains **exactly**:

   | Key | Required value |
   |---|---|
   | `gameDataPath` | `D:\Skyrim AI Modlist\Anvil\Stock Game\Data` |
   | `outputPath` | `D:\Skyrim AI Modlist\Anvil\mods\Pandora Output` |

3. **Reject stale values** — if either path points elsewhere (e.g. `E:\Modlists\…`,
   `D:\Anvil\…`, `Nemesis Output`, or any non-Anvil Stock Game / Pandora Output
   folder), fix before launching:
   - Edit the JSON directly (Pandora closed), **or**
   - Set paths once in Pandora → **Settings** after launch, then verify the file
     on disk matches the table above.
4. Optional: cross-check in Pandora **Settings** after launch — game data should
   show the **Data** folder (not Stock Game root); output should show
   `mods\Pandora Output`.

**Why:** Saved Settings **override** MO2 CLI / batch `-o` and `--tesv` when the
saved paths still exist on disk. Wrong Settings = wrong virtual Data scan and/or
output written to another list's folder.

### 3. Paths — Pandora v4.x Settings (reference)

Since **v4.0** (Settings page added in v4.2 UI), paths are stored in:

```
%LocalAppData%\Pandora Behaviour Engine\Settings.json
```

The **Settings** page in Pandora reads/writes this file. It persists across
Pandora updates and **overrides MO2 CLI args** when saved paths still validate.

| Setting | Anvil value |
|---|---|
| Game data | `D:\Skyrim AI Modlist\Anvil\Stock Game\Data` |
| Output | `D:\Skyrim AI Modlist\Anvil\mods\Pandora Output` |

**Note:** CLI `--tesv` points at the **Stock Game root**; Settings stores the
**Data** subfolder — they will not match string-for-string in the UI even when
both are correct.

Anvil `Settings.json` was corrected from a stale `E:\Modlists\Skyrim AE\…`
entry (prior modlist). If the Settings page still shows wrong paths, set them
there once with Pandora closed, or edit the JSON above directly.

### 4. MO2 tool

> **Gotchas:** [Edit Executables dialog only](#mo2-tool-config-reverts-after-editing-modorganizerini-by-hand) · [exe not bat](#no-known-mod-manager-detected--far-fewer-patches-than-expected--vanilla-only-scan) · [engine outside `mods/`](#pandora-closes-instantly-from-mo2-no-process-stale-enginelog)

**Change this only through MO2's Edit Executables dialog** (toolbar gears → select
**Pandora** → OK). MO2 loads `[customExecutables]` from `ModOrganizer.ini` at startup
and **rewrites the whole file from its in-memory copy on exit**. Hand-editing the ini
while MO2 is open (or starting MO2 with an old session still in memory) gets
overwritten — that is why tool #6 kept reverting to `Pandora MO2 Launch.bat`.

**Correct values (set in Edit Executables, then OK and close MO2 cleanly):**

| Field | Value |
|---|---|
| **Title** | `Pandora` |
| **Binary** | `D:\Skyrim AI Modlist\Anvil\tools\Pandora\Pandora Behaviour Engine+.exe` |
| **Start in** | `D:\Skyrim AI Modlist\Anvil\tools\Pandora` |
| **Arguments** | *(empty — paths come from Settings.json §2)* |

Do **not** point MO2 at `Pandora MO2 Launch.bat`. The batch workaround predates
Pandora v4 Settings.json and is **obsolete and actively harmful** — it breaks MO2
VFS detection (`No known mod manager detected` in `Engine.log`; Pandora sees vanilla
Data only). Paths belong in Settings.json (§2); MO2 Arguments stay empty.

**After changing:** close MO2, reopen, gears → Pandora → confirm Binary still shows
the `.exe`. Optional: open `ModOrganizer.ini` `[customExecutables]` and verify
`6\binary=` matches (read-only check — edit via UI if wrong).

Optional CLI fallback (only if Settings.json is empty):

```
--tesv "D:\Skyrim AI Modlist\Anvil\Stock Game" -o "D:\Skyrim AI Modlist\Anvil\mods\Pandora Output"
```

### 5. Full patch manifest — 28 Patcher rows + FNIS (audit before launch)

> **Gotcha:** [28 rows vs 15 to enable](#patch-count-why-28-patcher-rows-but-only-15-to-enable) · [TDM `tdmv` = Headtracking](#tdm-only-3-patches--tdmv-log-line-says-headtracking-not-a-missing-4th-patch) · [FNIS not in DataGrid](#serana-hood-missing-from-patcher-datagrid)

Pandora scans **two locations** and merges them into one list:

1. **MO2 virtual Data** — `Nemesis_Engine/mod/<id>/` and FNIS animlists from
   **enabled** mods only.
2. **Pandora install folder** — `tools/Pandora/` next to the exe (**outside**
   MO2 `mods/` — required for MO2 launch; see [Gotcha: instant close](#pandora-closes-instantly-from-mo2-no-process-stale-enginelog)).
   Always scanned. Adds **13 sample/demo patches** for mods Anvil does **not** ship.
   The MO2 mod **`Pandora Behaviour Engine+`** stays **disabled** (tool-only; not
   the launch path).

**Patcher UI count: 28 rows** = 1 engine core + 13 install-folder samples + 3 bundled
core patches + 11 Anvil patch-mod inputs. (`nemesis` / Nemesis Base has `hidden=true`
and usually **does not appear** in the UI — do not hunt for it.)

**FNIS is separate from Patcher rows.** Pandora v4 does **not** show FNIS animlists
as checkboxes in the DataGrid. They are picked up automatically from enabled mods
(e.g. `fnis_*_list.txt` under `meshes/actors/character/animations/`) and reported
in **`Engine.log` after Launch** as `FNIS Mod N : FNIS_<name>_List` — not as
`Pandora Mod N`. Anvil has one FNIS input: **Serana's Hood Fix with Animation**
(`FNIS_SeranaHoodFixWithAnim_List`). No checkbox to tick; confirm that line appears
in the log on a successful run.

**Enable in Patcher for Anvil:** **15** rows marked ✅ below.  
**Leave disabled:** 13 rows marked ❌ — Pandora engine samples, not Anvil content.

| # | ID | UI display name | Source | Anvil checklist | Enable? |
|---|---|---|---|:---:|:---:|
| 1 | `pandora` | Pandora Base | Pandora engine install (`Pandora_Engine/mod/pandora/`) | No | ✅ |
| 2 | `rthf` | Retimed Hit Frame | Bundled Behaviour Patches (Nemesis legacy) | Yes | ✅ |
| 3 | `turn` | Turning Animation Won't Affect UpperBody | Bundled Behaviour Patches | Yes | ✅ |
| 4 | `pscd` | Proper Spell Cast Direction | Bundled Behaviour Patches | Yes | ✅ |
| 5 | `ussep` | USSEP Behaviour Patch | USSEP Behaviour Patch | Yes | ✅ |
| 6 | `tdmv` | True Directional Movement - Headtracking | True Directional Movement - Modernized Third Person Gameplay (`Nemesis_Engine/mod/tdmv/`) | Yes | ✅ |
| 7 | `tdmlen` | True Directional Movement - Procedural Leaning | True Directional Movement - Modernized Third Person Gameplay | Yes | ✅ |
| 8 | `tdmh` | True Directional Movement - 360 Horse Archery | True Directional Movement - Modernized Third Person Gameplay | Yes | ✅ |
| 9 | `bseaf` | Barstool Exit Animation Fix | Barstool Exit Animation Fix | Yes | ✅ |
| 10 | `gmill` | Grain Mill Animation Fix | Grain Mill Animation Fix | Yes | ✅ |
| 11 | `evegif` | EVE Ghostly Instruments Fix | Bards Ghostly Instruments Fix | Yes | ✅ |
| 12 | `wsaf` | Weapon Switch Animation Fix - Behavior Patch Version | Weapon Switch Animation Fix - Behavior Patch Version | Yes | ✅ |
| 13 | `tpbgfx` | Animation Teleport Bug Fix | First Person Animation Teleport Bug Fix | Yes | ✅ |
| 14 | `htwfmt` | Horsemen Torch Wield Fix & Mount Tweaks SE | Horsemen Torch Wield Fix and Mount Tweaks SE | Yes | ✅ |
| 15 | `haasf` | Hammering Animation and Sound Fixes | Hammering Animation and Sound Fixes | Yes | ✅ |
| | | **— FNIS (not a Patcher row; auto-applied on Launch) —** | | | |
| — | SeranaHoodFixWithAnim | *(not in DataGrid)* | Serana's Hood Fix with Animation — `fnis_SeranaHoodFixWithAnim_list.txt`; confirm `FNIS Mod … SeranaHoodFixWithAnim` in `Engine.log` | Yes | auto |
| | | **— not in §15 checklist (13 install-folder samples) —** | | | |
| 17 | `zcbe` | Character Behaviors Enhanced | Pandora engine install only — [Zartar sample](https://www.nexusmods.com/skyrim/mods/90552) | No | ❌ |
| 18 | `gender` | Gender Specific Animations | Pandora engine install only — Nemesis sample | No | ❌ |
| 19 | `amco` | Attack - Distar Experience | Pandora engine install only — MCO/ACOT-style sample | No | ❌ |
| 20 | `hmce` | Horsemen Mounted Combat Enhanced | Pandora engine install only — *not* `htwfmt` | No | ❌ |
| 21 | `momo` | Momo Acrobatic Jump | Pandora engine install only | No | ❌ |
| 22 | `bcbi` | Blocking Combat Behavior Improvement For Skyrim | Pandora engine install only | No | ❌ |
| 23 | `skice` | Infinite Combat Engine | Pandora engine install only — ICE sample | No | ❌ |
| 24 | `cbbi` | Combat Behavior Improved | Pandora engine install only | No | ❌ |
| 25 | `aaaaa` | GunMod | Pandora engine install only | No | ❌ |
| 26 | `na1w` | New Animation for 1H Weapon | Pandora engine install only | No | ❌ |
| 27 | `sscb` | Super Serious Crossbows | Pandora engine install only | No | ❌ |
| 28 | `tkuc` | Ultimate Combat / TK Dodge | Pandora engine install only | No | ❌ |
| 29 | `tudm` | The Ultimate Dodge Mod | Pandora engine install only — *not* TDM | No | ❌ |

**Not in UI (hidden core):** `nemesis` / Nemesis Base — bundled in both Pandora
engine and Bundled Behaviour Patches; `hidden=true` in `info.ini`. Treat as
implicit; no checkbox to tick.

**Patch ID vs log display name:** the **Code** column and folder name under
`Nemesis_Engine/mod/<id>/` are the patch ID (e.g. `tdmv`). **`Engine.log`** prints
the `name=` field from that folder's `info.ini` (e.g. `True Directional Movement -
Headtracking` for `tdmv`) — same patch, not two different modules.

**If your Patcher count ≠ 28:** a patch-input MO2 mod is disabled, Settings.json
points at the wrong Data tree, or a mod was added/removed since this audit
(2026-07-07). Re-scan `Nemesis_Engine/mod/*/info.ini` under enabled mods before
launching.

---

## Pandora v4 UI reference (v4.3.1-beta)

Pandora v4 uses a **Fluent NavigationView** — not Nemesis's single-window layout.
There is **no "Update Engine" button** anywhere in Pandora.

| Area | What you see |
|---|---|
| **Left nav** | **Engine** (main patcher page). Footer: **About**, **Settings**. |
| **Engine page title** | **Patcher** (top-left heading on the main page). |
| **Patch list** | **DataGrid** with per-row **checkboxes** (Active column). Columns: Name, Author, Version, Code. Header checkbox = select/deselect all non-engine rows. Drag rows to reorder priority; `[+]` / `[-]` keys also move selection. |
| **Search** | Expandable **Search** box (`Ctrl+F` to show; `Esc` to hide). |
| **Menu** (top-right) | **Config** submenu — engine mode (**Skyrim SE/AE** vs **Skyrim SE/AE Debug**). Leave on **Skyrim SE/AE** for normal play. |
| **Log pane** (bottom) | Collapsible **InfoBar** + monospace log viewer. Status titles: *Ready to launch*, *Running…*, *Success*, *Error*. |
| **Launch control** | **Play-icon accent button** in the InfoBar (no text label). Official docs/README call this **Launch** — it is the only run action; there is no separate Patch/Generate button. |
| **Log toolbar** | **Open Output Folder** (folder icon) and **Copy text** (clipboard icon). |

**Settings page** (left nav → **Settings**): **Skyrim Data** and **Output Folder**
paths (with **Change** buttons), plus **Application theme**. These read/write
`Settings.json` in `%LocalAppData%`.

**Checkbox defaults on first open:**

- If `{outputPath}/Pandora_Engine/ActiveMods.json` **exists**, saved Active/Priority
  values are restored; mods **not** in the file start **unchecked**.
- If that file is **missing**, Pandora enables **all** discovered patches by default
  (`ResetToAlphanumeric`) — bad for Anvil because the 13 engine samples would tick on.
  Anvil prep may seed **`mods/Pandora Output/Pandora_Engine/ActiveMods.json`**
  (15 enabled patch IDs + hidden `nemesis`; 13 install-folder samples omitted →
  unchecked). FNIS lists are **not** stored there. Still **spot-check** the
  DataGrid against §5 on first launch.

**ActiveMods.json schema (Pandora v4 — not Nemesis):**

> **Wrong keys crash startup** — see [Gotcha: 0 patches / FATAL](#empty-patcher--0-patches--fatal-argumentnullexception-in-applysettings).

Each entry must use **camelCase** `code`, `active`, `priority` only. Nemesis
`id`/`enabled`, PascalCase `Code`/`Active`, or other shapes → `ArgumentNullException`
→ **0 patches**. Example:

```json
{ "code": "ussep", "active": true, "priority": 0 }
```

If unsure, **delete** `mods/Pandora Output/Pandora_Engine/ActiveMods.json` and relaunch
(all patches default checked — then uncheck the 13 engine samples per [§5](#5-full-patch-manifest--28-patcher-rows--fnis-audit-before-launch)).

**MO2 tool must launch the `.exe` directly** — see [Gotcha: batch launcher](#no-known-mod-manager-detected--far-fewer-patches-than-expected--vanilla-only-scan).
Paths come from Settings.json (§2); CLI args optional.

**No auto-run in the UI.** `--auto_run` / `--auto_close` are **CLI-only** (MO2 tool
args). Anvil deliberately omits them — you must click Launch yourself.

### What Launch does (one click — no second step)

**Launch is the entire job.** There is no confirmation dialog, preview pane, or
follow-up "Apply"/"Export" button. One click on the play icon immediately:

1. Collects **checked** rows from the Patcher DataGrid (plus implicit `pandora` core).
2. Applies all enabled patch modules (`UpdateAsync` — merge Nemesis/FNIS edits into
   behavior graphs).
3. Validates and **writes compiled `.hkx` files** to the configured output folder
   (`RunAsync` — full export).

That is the same pipeline Nemesis called "Update Engine" — Pandora just names the
single control **Launch**.

**Do not confuse with startup preload:** when Pandora first opens, the InfoBar may
show *Preloading…* / *Preparing resources* while vanilla templates load. That happens
**before** you click Launch and does **not** write behavior output. Wait until the
InfoBar reads *Ready to launch*, audit checkboxes (§5), then click Launch.

**While running:** InfoBar title *Running…* (warning severity), subtitle shows live
elapsed time; log says *Do not exit before the launch is finished.* Leave Pandora
open until it finishes.

### How to tell you're done (Success)

| Signal | Success | Failure |
|---|---|---|
| **InfoBar title** | **Success** (green) | **Error** (red) |
| **InfoBar subtitle** | *Launch completed successfully* | *See log for details* |
| **Log pane (last lines)** | Post-run summary + `Launch finished in XX.XX seconds.` | `Update failed` or critical error text |
| **`Engine.log`** | No **FATAL** lines; `Pandora Mod N` for each enabled patch; `FNIS Mod N` for each FNIS list | **FATAL** or hard **ERROR** on export |
| **Disk — output mod** | `.hkx` under `meshes/actors/character/Behaviors/` and `_1stperson/Behaviors/` | Missing or zero-size behavior folders |
| **Disk — cache** | `Pandora_Engine/ActiveMods.json` updated (checkbox state saved) | May still save checkbox state; output may be incomplete |

**WARN lines in `Engine.log` are often normal:** individual Nemesis patch edits that
failed validation (Pandora reverts those nodes); `Previous output file not found` on
first run; `FNIS Parser > Scan FNIS Animations > … > FAILED` when probing
OAR/DAR/NickNak folders that are not FNIS lists. Treat **FATAL** or InfoBar **Error**
as a failed run.

After **Success**, you may close Pandora. No further UI action is required before
launching Skyrim (see in-game smoke test below).

**Log file on disk:** `{outputPath}/Engine.log` (for Anvil:
`mods/Pandora Output/Engine.log`). The bottom pane mirrors this stream live.

---

## Launch steps

0. **Pre-flight:** complete [§2 Settings.json check](#2-pre-flight--verify-settingsjson-required-every-run) above.
1. Open MO2 → select **Anvil - Main Profile**.
2. Click the **Pandora** toolbar button (tool #6).
3. Confirm the left nav shows **Engine** (not **Settings**). If Pandora opened on
   **Settings** because paths were unset, fix paths there, then switch to **Engine**.
4. On the **Patcher** page, cross-check the patch DataGrid against the
   [full manifest (§5)](#5-full-patch-manifest--28-patcher-rows--fnis-audit-before-launch) —
   enable **15 ✅**, leave **13 ❌** unchecked. Do **not** expect a Serana hood row.
5. Quick reference — **enable only these 15 Patcher rows** (same as §5):

   | ID | Source mod |
   |---|---|
   | `pandora` | Pandora engine core (`tools/Pandora/`) |
   | `rthf` | Bundled Behaviour Patches |
   | `turn` | Bundled Behaviour Patches |
   | `pscd` | Bundled Behaviour Patches |
   | `ussep` | USSEP Behaviour Patch |
   | `tdmv` | True Directional Movement (Headtracking) |
   | `tdmlen` | True Directional Movement (Procedural Leaning) |
   | `tdmh` | True Directional Movement (360 Horse Archery) |
   | `bseaf` | Barstool Exit Animation Fix |
   | `gmill` | Grain Mill Animation Fix |
   | `evegif` | Bards Ghostly Instruments Fix |
   | `wsaf` | Weapon Switch Animation Fix |
   | `tpbgfx` | First Person Animation Teleport Bug Fix |
   | `htwfmt` | Horsemen Torch Wield Fix |
   | `haasf` | Hammering Animation and Sound Fixes |

   **FNIS (no checkbox):** Serana hood — verify `FNIS Mod … SeranaHoodFixWithAnim`
   in `Engine.log` after Launch.

6. **Do NOT enable:**
   - The **13 install-folder samples** (`zcbe`, `gender`, `amco`, `hmce`, `momo`,
     `bcbi`, `skice`, `cbbi`, `aaaaa`, `na1w`, `sscb`, `tkuc`, `tudm`) — see §5
   - Nemesis Creature Behaviour Compatibility (removed)
   - Pandora XPMSSE / skeleton patch (UBR handles this)

7. Click the **Launch** button (play icon in the bottom InfoBar) and wait until the
   status shows **Success** (or review **Error** / log output).
8. Check the log pane and `mods/Pandora Output/Engine.log` — no **FATAL** lines.
9. Optional: **Open Output Folder** (folder icon in the log toolbar) to confirm
   `.hkx` files landed under `meshes/actors/character/`.
10. Close Pandora. A successful run writes `mods/Pandora Output/Pandora_Engine/ActiveMods.json`
    with your checkbox selection for the next launch.

---

## After regen — verify output

Confirm `mods/Pandora Output/` contains compiled behaviors:

```
meshes/actors/character/Behaviors/*.hkx
meshes/actors/character/_1stperson/Behaviors/*.hkx
```

(`PreviousOutput.txt` in `Pandora_Engine/` lists paths from the last successful run.)

The output mod should remain **high in the modlist** (same position as the old
Nemesis output mod).

---

## In-game smoke test

Launch Skyrim through MO2 and spot-check:

| Test | What to verify |
|---|---|
| TDM 360° movement | Smooth omnidirectional locomotion |
| TDM lock-on | Target lock works in 3rd person |
| TDM horse archery | Mounted archery animations |
| Barstool exit | Exit barstool facing forward, not backward |
| Weapon switch | Draw/sheath while moving looks correct |
| Grain mill | Mill crank animation loops cleanly |
| Serana hood | Hood animation plays when equipped |
| Horse torch | Torch wield on horseback |
| First-person interact | No teleport/snap on activation (tpbgfx) |
| Hammering | Forge hammer animation + sound sync |

---

## Troubleshooting

**Start with [Gotchas — symptom → cause → fix](#gotchas--symptom--cause--fix)** above.
Remaining edge cases:

- **XPMSSE glitches (T-pose, broken blends):** confirm UBR (176724) is installed
  and enabled; confirm Pandora XPMSSE patch is **not** ticked.
- **Stale Nemesis artifacts:** `Anvil - Nemesis Output` folder was removed;
  overwrite has no `Nemesis_Engine/` remnants.
- **Benign WARN lines in `Engine.log`:** individual patch edit failures (Pandora
  reverts nodes); `Previous output file not found` on first run; FNIS-parser probes
  on OAR/DAR folders. **FATAL** or InfoBar **Error** = failed run.
