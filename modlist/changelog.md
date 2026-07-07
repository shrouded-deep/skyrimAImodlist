# Changelog

Dated, terse entries. This is the "what changed" log; see decisions.md for
the "why."

---

### 2026-07-07

- **Lux rollback** (task-0030): restored Lux + Lux Orbis + patch hubs; removed
  MLO2/True Light/Dust/DIAL/WSU stack from profile. CS Light Lux JSONs back;
  DynDOLOD.esp + Occlusion.esp + four Lux frozen outputs re-enabled. **343**
  active plugins, **0 missing masters**. Snapshot reference:
  `modlist/exports/mlo2-pre-migration-2026-07-07/`. Automation:
  `scripts/rollback-lux-from-mlo2.ps1`.
- **True Light / WSU plugin LO corrected:** per Nexus 135488 — Shadows and Ambient
  early; WSU before TL Bulbs; CS Light after TL Bulbs. Supersedes inferred “Placed Light
  before WSU” wording in task-0026.
- **WSU + MLO2 prep** (task-0026): MLO2 re-enabled in profile; `MLO.dll` re-extracted.
  WSU stack (150494 + deps) — download via MO2, run `scripts/install-wsu-stack.ps1`
  before interior spot tests. Nexus ID corrected (66665 was wrong).
- **Open cities deferred** (sign-off): both SREX and OCS off the table until list stabilizes.
- **Synthesis W4ENB patcher fixed** (task-0024): `PipelineSettings.json` now points at
  GitHub `panthuncia/WaterForENBPatcher` instead of `F:\...\Fixed\`. Output ESP frozen
  until Tier 2 regen.
- **SR Exterior Cities research** (task-0020): compatibility doc at
  `modlist/sr-exterior-cities-compatibility.md` — execution not queued; sign-off required.
- **MLO2 installed** (task-0022): extracted from Downloads; enabled after Base
  Object Swapper; `MLO.ini` pre-seeded with `enableColorConsistency=false`.
- **Lux Via re-enabled — signed off** (task-0023): archives extracted; master scan
  confirms no Lux/Orbis ESM deps. **`Lux - Resources.esp`** re-added to profile
  (Via FOMOD resource pack, not Lux core). 7 Via-related plugins active.
- **Lux-generated disabled flags** (user 2026-07-07): 4 disabled xEdit/Lux optional
  plugins with expected missing masters. **`DynDOLOD.esp` / `Occlusion.esp`** also
  disabled (stale Lux bake); regen deferred Tier 2 (task-0025). task-0024 for Synthesis
  `F:\` path.
- **Lux → MLO2 MO2 prep** (task-0021): disabled Lux trilogy + patch hubs (7 MO2
  mods); removed **36** Lux-named plugins from profile. CS Light: moved 6 Lux JSONs
  aside; restored vanilla set. Snapshot:
  `modlist/exports/mlo2-pre-migration-2026-07-07/`. In-game QA pending.
- **Pandora behavior regen** (task-0018): first successful MO2 Launch; engine at
  `tools/Pandora/` (MO2 #385 fix). Output in `Pandora Output`; FNIS Serana hood
  logged separately from Patcher rows. Smoke test pending.
- **`pandora-manual-run.md`:** added **Gotchas** section (symptom → cause → fix);
  28 vs 15 patch count; FNIS vs Patcher; `tdmv`=Headtracking; batch launcher obsolete.

### 2026-07-06

- **Pandora Output mod:** created empty MO2 mod `Pandora Output`; MO2 tool #6 `-o`
  path and modlist updated (replaces `Anvil - Pandora Output` placeholder).
- **Nemesis → Pandora MO2 prep** (task-0018): installed Pandora 4.3.1-beta + UBR
  skeleton patch; disabled Nemesis; cleared/renamed output mod; bundled legacy
  patches. Behavior regen **not run** — user launches Pandora from MO2 manually.
  Steps: `modlist/pandora-manual-run.md`.
- **Nemesis → Pandora research** (task-0016): full compatibility audit of 15
  Nemesis patch inputs; migration plan at `modlist/pandora-migration-plan.md`.
  Execution deferred pending sign-off (task-0018).
- **SPID + OAR** (task-0015): SPID **7.2.0 RC11 → 7.3.1** (AE DLL); OAR
  **2.3.6 → 3.1.6** after full OAR/DAR audit (6 replacer mods, all compatible).
  Audit report: `modlist/oar-audit-2026-07-06.md`. No plugin/load-order changes.
- **CS 1.7.3 ecosystem audit** (task-0017): disabled 9 core-merged / incompatible
  CS-adjacent mods; updated Wetness Effects, Cloud Shadows, Skylighting; confirmed
  Sky Sync enabled via core + Anvil settings. Full table:
  `modlist/community-shaders-audit-2026-07-05.md`.
- Updated **SkyUI** 5.2 SE → **6.11** in MO2; disabled seven redundant
  satellite mods integrated into SkyUI 6 (task-0014). 0 missing masters.
  MCM/favourites may reset on first launch.
- Disabled **EVLaS** — incompatible with Community Shaders 1.7.3; install
  Sky Sync CS plugin as replacement (see decisions.md).
- Repo scaffold created (README, AGENTS.md, CLAUDE.md, task queue
  structure, decision log, changelog).
- Removed **MCM Recorder** (`McmRecorder.esp`) from the load order —
  disabled the mod in MO2 and removed its plugin from `plugins.txt`/
  `loadorder.txt` (task-0011). Superseded by a newer MCM-recording
  approach; confirmed no other plugin depended on it. Its one flagged
  conflict (task-0005, cell `WEMerchantChests`) is now resolved by
  `Update.esm` instead.
