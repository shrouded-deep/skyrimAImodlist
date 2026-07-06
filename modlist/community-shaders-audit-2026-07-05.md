# Community Shaders Ecosystem Audit — 2026-07-05

Post–task-0013 audit (task-0017). CS core updated to **1.7.3**; this pass
cross-referenced every CS-adjacent mod in the Anvil profile against the
[Community Shaders Nexus page](https://www.nexusmods.com/skyrimspecialedition/mods/86492)
“Always included” / version-tier lists, [modding.wiki CS FAQ](https://modding.wiki/en/skyrim/developers/community-shaders/faq),
and CS **v1.7.3** GitHub release feature metadata.

**Profile:** `Anvil - Main Profile` · **Instance:** `D:\Skyrim AI Modlist\Anvil`

---

## Executive summary

| Finding | Count |
|---|---|
| Core-merged separate mods now **disabled** | 9 |
| Incompatible DLL mods **disabled** | 1 (EVLaS) |
| Separate features **updated** for CS 1.7.3 | 3 |
| Separate features already current | 2 |
| Optional overlap (no change) | 1 |
| Missing masters after changes | **0** |

**Sky Sync:** bundled in CS 1.7.3 core (`Shaders/Features/SkySync.ini` v1-3-0).
Anvil `Community Shaders - Anvil Settings` already has `"Sky Sync": { "Enabled": true }`.
No separate Nexus “Sky Sync” mod folder required. EVLaS disabled — no startup block.

---

## CS core inclusion reference (Nexus 86492)

Features below ship **inside** the Community Shaders DLL/mod folder. Keeping
the old standalone Nexus plugin folders enabled causes duplicate/conflicting
shader registration on CS ≥ the version shown.

| Feature | In core since |
|---|---|
| Extended Materials, LOD Blending, Performance Overlay, Volumetric Lighting, Weather Picker, Dynamic Cubemaps, Light Limit Fix, Unified Water | Always (1.0+) |
| Terrain Shadows, Inverse Square Lighting, Water Effects, Interior Sun, Extended Translucency | 1.4.7+ |
| Screen-Space Shadows, Grass Collision, Grass Lighting, Subsurface Scattering | 1.5.0+ |
| **Sky Sync** | **1.7.0+** |

Hard **incompatible** (CS blocks at startup): EVLaS, AELAS, Skyrim Upscaler,
SSE ReShade Helper, Shader Tools, ENB, etc. (see modding.wiki FAQ).

---

## Findings table — Anvil CS-adjacent mods

| MO2 mod folder | Ver (after audit) | Verdict | Action taken |
|---|---|---|---|
| **Community Shaders** | 1.7.3 | (d) Core — unaffected | Already updated (task-0013) |
| **Community Shaders - Anvil Settings** | — | (d) INI overrides | Preserved; Sky Sync **Enabled: true** confirmed |
| **Anvil - Community Shaders ShaderCache Output** | — | (d) Output mod | Cleared (task-0013); regen on launch |
| **Light Limit Fix** | 2.0.1 | **(a) Core since 1.4+** | **Disabled** in modlist |
| **Terrain Shadows** | 1.0.0 | **(a) Core since 1.4.7+** | **Disabled** |
| **Terrain Shadows - Heightmaps** | — | **(a) Core companion** | **Disabled** |
| **Water Effects** | 1.0.1 | **(a) Core since 1.4.7+** | **Disabled** |
| **Subsurface Scattering** | 2.0.2 | **(a) Core since 1.5.0+** | **Disabled** |
| **Screen Space Shadows** | 2.0.0 | **(a) Core since 1.5.0+** | **Disabled** |
| **Grass Collision** | 3.0.2 | **(a) Core since 1.5.0+** | **Disabled** *(task-0013 updated folder unnecessarily)* |
| **Grass Lighting** | 2.0.0 | **(a) Core since 1.5.0+** | **Disabled** *(task-0013 updated folder unnecessarily)* |
| **Frame Generation** | — | **(a) Merged into Upscaling 1.4+** | Already **disabled** |
| **Enhanced Volumetric Lighting and Shadows (EVLaS)** | 1.3.1 | **(c) Blocked by CS 1.7.x** | **Disabled** (live launch error) |
| **Sky Sync** | 1-3-0 (in CS core) | **(a) Core since 1.7.0+** | No folder needed; enable in CS menu *(already on in Anvil settings)* |
| **Wetness Effects** | **3.1.0** | **(b) Requires bump for 1.7.3** | **Updated** from 2.0.1 |
| **Cloud Shadows** | **1.4.0** | **(b) Match CS 1.7.3 line** | **Updated** from 1.2.0 |
| **Skylighting** | **1.4.0** | **(b) Match CS 1.7.3 line; NAT.CS req.** | **Updated** from 1.1.0 |
| **Screen Space Global Illumination (SSGI)** | 4.2.0 | **(d) Still separate feature** | Keep enabled; updated task-0013 |
| **Grass Sampler Fix** | 1.0.1 | **(d) Utility; not core-merged** | Keep enabled |
| **NAT.CS III** | 1.5.0 | **(d) Weather patch for CS** | Keep enabled |
| **NAT.ENB III - Weather Plugin** | 3.1.1C-F | **(d) Required by NAT.CS** | Keep enabled |
| **CS Light** | 1.5.1 | **(d) Light Placer framework for CS** | Keep enabled |
| **Splashes of Storms** | 1.3.1 | **Optional overlap** | **Keep enabled** — CS FAQ: Wetness covers similar ground but look differs; subjective Anvil choice |
| **Splashes Of Skyrim** | 1.4.0 | **(d) Different mod (not Storms)** | Keep enabled |

---

## task-0013 corrections

1. **EVLaS** was left enabled → CS 1.7.3 hard-blocks `EVLaS.dll` at startup.
   Fixed by disabling EVLaS; Sky Sync (core) replaces its function.
2. **Six core-merged plugin folders** (Light Limit Fix, Terrain Shadows,
   Water Effects, SSS, Grass Collision/Lighting, Subsurface Scattering) should
   have been **disabled**, not version-bumped. Folders updated in task-0013 are
   harmless while disabled but should not be re-enabled without downgrading CS.
3. **Wetness Effects, Cloud Shadows, Skylighting** needed version bumps — not
   done in task-0013. Fixed in this audit (CS 1.7.3 GitHub release zips).
4. **Sky Sync** does not need a separate mod install on CS ≥ 1.7.0; Anvil
   settings already enable it.

---

## USSEP / USMP / SSGI second look

| Item | Re-audit result |
|---|---|
| **USSEP 4.3.8a** | Still valid; routine ESP swap, no CS interaction |
| **USMP 2.6.8** | Still valid; no CS interaction |
| **SSGI 4.2.0** | Still valid; remains a **separate** CS feature (not core-merged) |

No rollback or re-run of task-0013 USSEP/USMP work warranted.

---

## User verification checklist (first launch after this audit)

1. Launch via MO2 → expect shader compile (cache was cleared earlier).
2. Press **END** → Community Shaders menu → **Feature Issues** tab: should show
   no obsolete/duplicate feature warnings.
3. Confirm **Sky Sync** appears and is enabled (Anvil preset expects this).
4. Confirm no “Incompatible DLL EVLaS.dll” error.
5. Re-tune Wetness / Skylighting / Cloud Shadows in CS menu if visuals shifted
   after feature version bumps.

---

## Sources

- [Community Shaders Nexus 86492](https://www.nexusmods.com/skyrimspecialedition/mods/86492) — core inclusion tiers (user-provided excerpt)
- [CS FAQ — obsolete features & incompatible mods](https://modding.wiki/en/skyrim/developers/community-shaders/faq)
- [CS v1.7.3 release](https://github.com/community-shaders/skyrim-community-shaders/releases/tag/v1.7.3) — feature version audit table
- On-disk: `Community Shaders/Shaders/Features/*.ini`, `Community Shaders - Anvil Settings/.../SettingsUser.json`
