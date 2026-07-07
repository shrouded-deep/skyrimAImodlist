# Nemesis → Pandora Behaviour Engine+ Migration Plan

Research for task-0016. **Do not execute from this document** — human sign-off
required before task-0018 runs (list-wide behavior output regeneration).

**Instance:** `D:\Skyrim AI Modlist\Anvil` · Profile: `Anvil - Main Profile`  
**Current engine:** Project New Reign - Nemesis **v0.84** (Nexus 60033, last update Dec 2021)  
**Target engine:** [Pandora Behaviour Engine+](https://www.nexusmods.com/skyrimspecialedition/mods/133232) **v4.3.1-beta** (Nexus, Apr 2026)

---

## Executive summary

Anvil is a **lightweight Nemesis list** — no MCO, SkySA, Precision, or FNIS engine.
There are **15 Nemesis patch inputs** (12 MO2 mods + 3 bundled inside the Nemesis
engine mod). Pandora consumes **the same Nemesis patch folder format** (`Nemesis_Engine/mod/<id>/`)
and is intended as a **full replacement**, not a parallel runtime.

**Compatibility verdict:** all installed Nemesis patch mods are expected to work in
Pandora unchanged. **Two additions** are required for Pandora + XPMSSE: Universal
Behaviour Runtime — Auto Skeleton Patch (176724). **One removal:** Nemesis Creature
Behaviour Compatibility (45966) — mod page explicitly says not needed for Pandora.

**Critical pre-existing issue:** `Anvil - Nemesis Output` is **stale** — last
PatchLog (2025-07-04) used path `D:\Anvil\Stock Game\data\` (pre-move instance)
and only 7 of 15 current patch sources were checked. Output mod lacks compiled
`.hkx` behaviors; migration must include a **clean output wipe + full regen**.

**DynDOLOD / Synthesis / ParallaxGen:** no dependency on Nemesis/Pandora behavior
output. No regen required for those tools after migration (unless unrelated maintenance
is scheduled).

---

## Pandora compatibility model

| Question | Answer |
|---|---|
| Same inputs as Nemesis? | **Yes** — Pandora reads Nemesis `Nemesis_Engine/mod/` patch layout; wiki states *"all Nemesis mods"* cross-compatible |
| FNIS animlists? | Pandora registers FNIS-style `fnis_*_list.txt` animation lists (e.g. Serana Hood mod) without FNIS.exe |
| Pandora-native format? | Optional; existing Anvil patches don't use it |
| Creature support | **Built into Pandora** — no separate creature compat resource needed |
| Coexist with Nemesis? | **No for production** — install guide: uninstall Nemesis output, don't run both; delete old engine output before first Pandora run |
| XPMSSE | Requires **Universal Behaviour Runtime — Auto Skeleton Patch** (176724); **do not** enable Pandora's legacy XPMSSE patch checkbox when UBR is installed |
| LE animation compat | **A-Pose Bug Fix — Universal Behavior Runtime** only if using LE-format animations — Anvil is SE-native; likely **not needed** |
| Known gaps | Pandora wiki: doesn't support obsolete FNIS features replaced by OAR (PCEA, Sexy Move, etc.) — **not used in Anvil** |

Sources: [Pandora Nexus 133232](https://www.nexusmods.com/skyrimspecialedition/mods/133232), [Installation Guide (article 11067)](https://www.nexusmods.com/skyrimspecialedition/articles/11067), [GitHub wiki compatibility table](https://github.com/Monitor221hz/Pandora-Behaviour-Engine-Plus/wiki).

---

## Current Nemesis state

### Engine & output

| Mod | Role | Notes |
|---|---|---|
| Project New Reign - Nemesis Unlimited Behavior Engine | Tool (v0.84) | **Disable + remove** after Pandora installed |
| Anvil - Nemesis Output | Pre-generated output | **Delete contents / replace** with Pandora output mod; rename to `Anvil - Pandora Output` recommended |

**Last successful Nemesis run (PatchLog.txt):** 2025-07-04, v0.84, output path
`D:\Anvil\Stock Game\data\` (wrong for current MO2 instance).

**Patches checked in that run (7):**

| Engine ID | Source |
|---|---|
| `nemesis` | Bundled (engine core) |
| `tdmv` | True Directional Movement (360° movement only) |
| `turn` | Bundled — Turning Animation Won't Affect UpperBody |
| `pscd` | Bundled — Proper Spell Cast Direction |
| `rthf` | Bundled — Retimed Hit Frame |
| `tpbgfx` | First Person Animation Teleport Bug Fix |
| `bseaf` | Barstool Exit Animation Fix |

**Installed but NOT in last run (8)** — output does not reflect current load order:

| Engine ID | Mod |
|---|---|
| `ussep` | USSEP Behaviour Patch |
| `wsaf` | Weapon Switch Animation Fix - Behavior Patch Version |
| `gmill` | Grain Mill Animation Fix |
| `evegif` | Bards Ghostly Instruments Fix |
| `htwfmt` | Horsemen Torch Wield Fix and Mount Tweaks SE |
| `haasf` | Hammering Animation and Sound Fixes |
| `tdmlen` | TDM — procedural leaning |
| `tdmh` | TDM — 360 horse archery |

Plus **SeranaHoodFixWithAnim** custom animation registration (FNIS-style list).

---

## Nemesis-dependent mods — compatibility matrix

### Behavior patches (require engine regen)

| Mod | Nexus | Pandora status | Notes |
|---|---|---|---|
| USSEP Behaviour Patch | — | **Compatible** | Standard Nemesis patch; required so Nemesis/Pandora output doesn't clobber USSEP behavior fixes |
| True Directional Movement - Modernized Third Person Gameplay | 74800 | **Compatible** | 3 sub-patches: `tdmv`, `tdmlen`, `tdmh`; author ships Nemesis modules |
| Barstool Exit Animation Fix | 144556 | **Compatible** | Nemesis required per mod page |
| Grain Mill Animation Fix | 94629 | **Compatible** | FOMOD installed Nemesis variant |
| Bards Ghostly Instruments Fix | 114777 | **Compatible** | Installed Nemesis variant |
| Weapon Switch Animation Fix - Behavior Patch Version | 125415 | **Compatible** | Mod page: Nemesis **or** Pandora |
| First Person Animation Teleport Bug Fix | — | **Compatible** | Tiny Nemesis patch |
| Horsemen Torch Wield Fix and Mount Tweaks SE | 77303 | **Compatible** | Mod page: Nemesis **or** Pandora |
| Hammering Animation and Sound Fixes | 142807 | **Compatible** | Install file explicitly "NEMESI or PANDORA" |
| Serana's Hood Fix with Animation | 80336 | **Compatible (expected)** | Nemesis required; uses `fnis_SeranaHoodFixWithAnim_list.txt` — Pandora registers FNIS-style lists; author hasn't explicitly tested Pandora in meta |

### Bundled inside Nemesis engine mod

| Patch | Nexus | Pandora status |
|---|---|---|
| Retimed Hit Frame (`rthf`) | 26876 | **Compatible (expected)** — standard Nemesis patch format |
| Turning Animation Won't Affect UpperBody (`turn`) | 85083 | **Compatible (expected)** |
| Proper Spell Cast Direction (`pscd`) | 68794 | **Compatible (expected)** |

### Remove on migration

| Mod | Nexus | Action |
|---|---|---|
| Nemesis Creature Behaviour Compatibility | 45966 | **Disable + remove** — mod page: *"IF YOU'RE USING PANDORA YOU DO NOT NEED THIS MOD"*; Pandora has native creature support |

### Skeleton / runtime (new for Pandora)

| Mod | Nexus | Action |
|---|---|---|
| Universal Behaviour Runtime — Auto Skeleton Patch | 176724 | **Install + enable** — Pandora hard requirement when XPMSSE is present |
| A-Pose Bug Fix — Universal Behavior Runtime | (see Pandora reqs) | **Skip** unless LE-format behavior/animation compat needed |

### Enabled animation mods — NOT Nemesis-dependent

These do **not** ship `Nemesis_Engine/mod/` patches and are unaffected by engine swap
(OAR/DAR/SKSE-only):

- Conditional Tavern Cheering, Lively Children, Lively Cart Driver, Torch Sprint (OAR)
- Flute Animation Fix, Serana Fixed Crossed Arms (DAR legacy — OAR reads these)
- TDM satellite plugins (First Person Target Locking, Lock-on Fixes, Simpler Dragon Targeting)
- Enhanced Reanimation, Better Jumping AE, Classic Sprinting Redone, sprint fixes
- Open Animation Replacer, Animation Queue Fix

### Direct animation replacers (no behavior patch)

| Mod | Status | Notes |
|---|---|---|
| Super Fast Get Up Animation | **Broken install** | Folder appears empty (meta only) — reinstall before migration or disable |
| 1st Person Greatsword Idle Animation Fix | **Broken install** | Meta only — reinstall or disable |
| Unique Animations Reworked | **Broken install** | Meta only — reinstall or disable |
| True Directional Movement - Tail Animation Fix | **Broken install** | Meta only — direct `TailBehavior.hkx` override per description; reinstall or disable |

### Skeleton mods (present, not engine-patched)

| Mod | Notes |
|---|---|
| XP32 Maximum Skeleton Special Extended - XPMSSE | Installed (Extended variant per Anvil); UBR replaces Nemesis skeleton patching |
| XPMSSE Spazzing Skeleton and Corpse Fix | Mesh fix; no Nemesis patch |

---

## Other toolchain dependencies

| Tool | Nemesis dependency? |
|---|---|
| DynDOLOD / TexGen / Occlusion | **No** — LOD/mesh generation only |
| Synthesis patchers | **No** |
| ParallaxGen / PGPatcher | **No** |
| Reqtificator | **No** |
| OAR / SPID / KID | **No** — separate runtime systems |

---

## Recommended migration step order

### Phase 0 — Human sign-off

User has stated intent to migrate; **confirm explicitly** before execution because
behavior output affects every humanoid/creature animation graph in-game.

### Phase 1 — Pre-flight (Cursor / MO2)

1. **Reinstall or disable** broken animation mods (Super Fast Get Up, 1st Person
   Greatsword, Unique Animations Reworked, TDM Tail Fix) — empty folders won't
   affect Pandora but indicate incomplete Anvil install.
2. **Install** Pandora Behaviour Engine+ (133232, latest primary).
3. **Install** Universal Behaviour Runtime — Auto Skeleton Patch (176724).
4. Snapshot current `modlist.txt` / plugin list (git commit or export).

### Phase 2 — Remove Nemesis artifacts

1. **Disable** `Project New Reign - Nemesis Unlimited Behavior Engine`.
2. **Disable + remove** `Nemesis Creature Behaviour Compatibility`.
3. **Clear** `Anvil - Nemesis Output` entirely (or delete mod and create fresh
   `Anvil - Pandora Output`).
4. **Clear MO2 overwrite** `meshes/` (and any `Nemesis_Engine/` remnants) per
   [Pandora Installation Guide](https://www.nexusmods.com/skyrimspecialedition/articles/11067).
5. Search `Stock Game\Data\` and old `D:\Anvil\` paths for stale Nemesis output
   if present from pre-move runs.

### Phase 3 — Configure Pandora in MO2

1. Add Pandora as **MO2 executable tool** pointing at `Pandora Behaviour Engine+\Pandora.exe`
   (or manual install under Stock Game\Data per guide — team recommends manual + tool entry).
2. Set output to dedicated mod folder (MO2: **do not** use "Create files in mod
   instead of overwrite" for Pandora — per install guide).
3. Pass `--tesv` if auto-detection fails (Wabbajack Stock Game layout):
   `D:\Skyrim AI Modlist\Anvil\Stock Game`
4. Pass `-o` output path to the Pandora output mod folder.

### Phase 4 — Patch selection

Enable **all** patch modules matching installed mods:

- Bundled: `rthf`, `turn`, `pscd` (may appear from patch mods or need re-install
  without bundling in engine — verify Pandora lists them from source mods)
- `ussep`, `tdmv`, `tdmlen`, `tdmh`, `bseaf`, `gmill`, `evegif`, `wsaf`, `tpbgfx`,
  `htwfmt`, `haasf`
- SeranaHoodFixWithAnim (animation registration)
- **Do not** enable Nemesis Creature Behaviour Compatibility
- **Do not** enable Pandora XPMSSE patch (UBR handles skeleton)

Run Pandora; verify `Engine.log` shows no fatal errors.

### Phase 5 — MO2 load order

1. Place **Pandora output mod** high in modlist (Anvil currently has Nemesis Output
   near top — keep same convention).
2. Confirm output contains compiled `.hkx` under `meshes/actors/**/behaviors/`.
3. Launch game — smoke test (**fresh save required** — see
   [`pandora-manual-run.md` § In-game smoke test](pandora-manual-run.md#in-game-smoke-test);
   do not validate on a pre-regen save):
   - Furniture sit + horse mount (first — catches stale-save false negatives)
   - TDM 360° movement, lock-on, horse archery
   - Barstool exit forward
   - Weapon switch while moving
   - Grain mill loop
   - Serana hood animation
   - Horse torch wield
   - First-person interact (teleport bug fix)

### Phase 6 — Cleanup

1. Remove Nemesis engine mod folder from MO2 (optional archive first).
2. Update `meta.ini` / version-check report.
3. Log outcome in `decisions.md` + `changelog.md`.

---

## Risk register

| Risk | Severity | Mitigation |
|---|---|---|
| Stale Nemesis output already wrong for 8 patches | **High** | Full regen; treat current output as untrusted |
| Wrong Stock Game path in old PatchLog | **Medium** | Use `--tesv` + verify output lands in MO2 mod |
| Pandora beta stability | **Medium** | Use Nexus stable release (4.3.1-beta); read Engine.log |
| Broken empty animation mods | **Low** | Reinstall or disable before run |
| TDM complexity | **Medium** | Test all 3 TDM Nemesis modules in-game |
| UBR / XPMSSE misconfiguration | **Medium** | Install UBR; don't double-patch XPMSSE in Pandora UI |

---

## Follow-up execution task

See **`tasks/queue/task-0018.md`** — execution after human sign-off.

Task-0016 originally specified `requires_housecarl: true`; **reassigned to Cursor**
because migration is MO2 folder management + external tool run, not ESP/record
editing (per `AGENTS.md` role split).
