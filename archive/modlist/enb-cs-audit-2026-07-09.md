# ENB vs Community Shaders — Nolvus Awakening V6 Feasibility Audit

**Date:** 2026-07-09  
**Task:** task-0001 (research only — no MO2/profile changes)  
**Donor list:** Nolvus Awakening V6 (Nolvus Ascension mod inventory per [nolvus.net/ascension](https://www.nolvus.net/ascension))  
**Reference:** Anvil Successor CS migration lessons in `E:\Skyrim AI Modlist\lessons-learned.md` and [modding.wiki CS FAQ](https://modding.wiki/en/skyrim/developers/community-shaders/faq)

---

## Executive summary

| Verdict | **Major** |
|---|---|
| One-line | Nolvus is architected around ENB + ReShade + NAT.ENB + Lux (ENB-tuned) + dozens of ENB particle-light mesh mods; CS migration is a full visual-stack rebuild, not a binary swap. |

CS and ENB cannot coexist. Nolvus ships **zero** Community Shaders infrastructure. Removing ENB would disable or require replacements across weather tuning, interior lighting, grass, parallax, particle lights, splashes, and the paired ReShade stack. Documented CS migration paths exist (NAT.CS III, Lux CS, CS Light) but none are integrated into Nolvus today.

---

## 1. ENB preset identity

### What Nolvus ships

| Item | Detail |
|---|---|
| **Primary framework** | ENBSeries binaries **0.494** + ENB feature DLLs (Grass Collisions, Parallax Occlusion Mapping, Dynamic Cubemaps) |
| **Awakening V6 presets (installer choice)** | **Cabbage ENB**, **Cabbaval ENB** (Cabbage edit), **Kauz ENB**, or **Pi-Cho ENB** — selected at Wabbajack install; **not changeable post-install** except manual swap ([installer docs](https://www.nolvus.net/appendix/installer/install)) |
| **Ascension mod-list alternatives (same ecosystem)** | Pi-Cho ENB 8.1, Rudy ENB 1.1a (+ NAT addons), Bjorn ENB (+ Dark Ages / White Wolf variants) — each with matching **Nolvus Reshade** preset |
| **ReShade** | Reshade Binaries 5.6.0 + **Nolvus Reshade 3.0** variants paired to chosen ENB (incl. RT options for Pi-Cho / Rudy) |
| **SKSE helpers** | ENB Helper 1.5, ENB Helper Plus 1.0.4, ENB Input Disabler 1.0.2 |
| **Maintenance** | Nolvus Awakening actively maintained (v6.0.20 as of 2026-01-27 per [nolvus.net](https://www.nolvus.net/)); ENB presets are third-party (Cabbage, Kauz, Pi-Cho, Rudy, Bjorn) — maintained on Nexus, tuned for NAT 3 |
| **CS equivalents** | No Nolvus-authored CS preset. Community path: **Community Shaders 1.7.x** + optional INI preset + **NAT.CS III** (139567) for weather parity. No documented Nolvus→CS migration guide exists. Cabbage/Kauz have no direct CS ports; aesthetic re-tune from scratch. |

---

## 2. Weather and lighting stack

### Weather (exterior)

| Mod | Version (Nolvus) | ENB coupling |
|---|---|---|
| **Natural Atmospheric Tamriel III** | 3.1.0 | Base weather framework |
| **NAT III - Seasonal Weathers** | NATENBIII 3.0.2 | **NAT.ENB-branded** seasonal plugin — imagespace tuned for ENB post-processing |
| **Nolvus Ascension Weathers Patch** | 5.0 | Integrates Seasons of Skyrim, Supreme Blizzards/Fog, RASS, Morning Fogs, Storm Lightning, etc. around NAT |
| **Splashes of Storms - ENB Fix** | 1.2 | Explicit ENB fix slice |
| **Enhanced Volumetric Lighting and Shadows (EVLaS)** | 1.3.1 | ENB-era volumetrics; **hard-incompatible with CS Sky Sync** |

Supporting: Seasons of Skyrim/Nolvus, RASS, Wet and Cold, Obsidian Mountain Fogs Tweaked, Storm Lightning, Morning Fogs, Supreme Blizzards, Supreme and Volumetric Fog.

### Interiors / exteriors (lighting overhauls)

| Mod | Version | ENB coupling |
|---|---|---|
| **Lux** | 6.3 (Redux option) | Authored for ENB Light / particle lights; Lux page lists many ENB presets as soft/hard requirements |
| **Lux Via** | 1.7 | Road/street lighting — ENB particle integration in Nolvus stack |
| **Lux Orbis** | 3.1.1 | Exterior orb lighting |
| **Lux Variants + Interiora Distincta** | various | JK/distinct interior variants |
| **Nolvus Ascension Lighting Patch** | 5.13 | Curated patch layer across above |
| **Embers XD** | 2.8.6 | Fireplace/ember effects; CS Light FOMOD has Embers/Lux cross-options |
| **ENB Light** | 0.98α2 | Meta-mod adding ENB lights to many effects |

**ENB-tuned imagespace?** Yes — NAT.ENB III seasonal plugin, EVLaS, Splashes ENB Fix, and Lux's optimized ENB meshes/textures all assume ENB post-processing and ENB particle lights. Nolvus Reshade adds another post layer tied to ENB preset choice.

### CS-compatible weather/lighting path (not in Nolvus)

Per [ENB Migration Guide](https://modding.wiki/en/skyrim/developers/community-shaders/ENB-Migration-Guide) and [NAT.CS III](https://www.nexusmods.com/skyrimspecialedition/mods/139567):

| Replace / add | Notes |
|---|---|
| **NAT.CS III** | Ports NAT.ENB look to CS; **keep** NAT.ENB ESP weather plugin (ESP only) |
| **Skylighting + Cloud Shadows** | Required CS feature mods for NAT.CS |
| **Lux CS** (153919) | Adapts Lux + Lux Orbis for CS; reinstall Lux FOMOD without ENB-optimized mesh options per Lux author guidance |
| **CS Light** (138443) | Light Placer configs replacing ENB Light / particle-light mods |
| **Disable EVLaS** | Use CS Sky Sync (core in CS ≥1.7.0) instead |
| **Disable ENB + ReShade** | CS blocks ENB at startup |

---

## 3. ENB light mesh exposure

Nolvus section **5.17 Lighting Effects & Particles** and scattered clutter patches ship extensive ENB particle-light mesh replacers. These `.nif` mods add ENB light nodes; **CS does not render ENB particle lights** (CS 1.4+ uses Light Placer instead).

### Core ENB particle-light mods (section 5.17)

| Mod | CS replacer availability |
|---|---|
| Rudy HQ - More Lights for ENB (Deathbells, Mushrooms, Decal Fix) | Partial — CS Light may cover some flora; not 1:1 |
| ENB Particle Lights - Dwemer Lanterns | CS Light / Lux CS FOMOD slices |
| ENB Particle Lights - Bugs in a Jar | CS Light |
| ENB Particle Lights - Undead Creatures | CS Light |
| ENB Particle Lights - Staff Enchanter | CS Light |
| ENB Particle Lights - Nordic Ruins Candles | CS Light |
| ENB Particle Lights - Effect Shaders | Overlaps CS Light "Magic FX" — careful FOMOD dedup |
| ENB Particle Lights - Dragon Fly, Light Orbs, Wisps, Lava, Moon Crests, Dwarven Spiders, Falmer Drips, Fire Traps, Spectral Warhound Eyes, Riekling Outposts, Ayleid Ruins, Gemstones, Alchemy/Enchanting Tables | CS Light partial coverage; audit each in FOMOD |
| ENB Particle Lights - Rudy Candle And Smoking Torch Patch | CS Light + Smoking Torches coexistence |
| ENB Light (+ Dark Elf Lantern, Apocrypha, Elytra, Misc Effects variants) | CS Light replaces many; risk of double-lighting if both enabled |
| Hot Lava - Heat Distortion **ENB Light** patch | CS path unclear — may lose effect or need manual LP config |
| Awesome Potions Simplified **ENB Lights** patch | CS Light / Lux CS |

### Additional ENB-light clutter (elsewhere in list)

| Mod | Notes |
|---|---|
| **Particle Patch for ENB** 1.1.9 | ENB-specific; CS uses different particle/light path |
| Dwemer Tech Glowmapped - **ENB Light** (+ patches) | Mesh ENB lights |
| Stalhrim Source - **ENB Light Patch** | |
| Sprites or Specters - **ENB Light** | |
| Dwemer Fairies - **ENB Particles** | |
| Particle Lights for ENB - Falmer Things | |
| Iconic's Paragon Gems - **Particle Light Patch** | |
| Rudy HQ - More lights for ENB - **Daedric weapons** | |
| Multiple **ENB Complex Grass** slices (Tamrielic, Folkvangr, Origins of Forest, Cathedral Pine) | ENB grass feature — CS has core Grass Collision/Lighting instead |

**CS replacer strategy:** [CS Light](https://www.nexusmods.com/skyrimspecialedition/mods/138443) FOMOD with Lux-only selections; disable all ENB Particle Lights / ENB Light / Rudy HQ ENB light mods to avoid doubles. Expect **gaps** for niche Nolvus-specific combos (Nolvus Ascension Lighting Patch interactions untested).

---

## 4. ENB-specific shader / rendering features

| Nolvus mod / feature | CS 1.7.x parity |
|---|---|
| **ENB Binaries + d3d11.dll injection** | Remove entirely; install CS |
| **ENB Grass Collisions** 1.3 | CS core **Grass Collision** (disable standalone) |
| **ENB Parallax Occlusion Mapping** 2.0 | CS **Extended Materials** / terrain parallax — re-verify parallax texture packs (Nolvus uses extensive complex parallax) |
| **ENB Dynamic Cubemaps** 1.0 | CS core **Dynamic Cubemaps** |
| **ENB Complex Grass** (4 grass mods) | Disable ENB slices; use CS grass features + existing grass textures |
| **ReShade + Nolvus Reshade** | **Incompatible** with CS depth-dependent effects + framegen; must remove ([CS FAQ](https://modding.wiki/en/skyrim/developers/community-shaders/faq)) |
| **EVLaS** 1.3.1 | Replace with CS **Sky Sync** (core); disable EVLaS |
| **Splashes of Storms - ENB Fix** | Re-evaluate under CS Wetness Effects; may keep base Splashes of Storms |
| **Water Effects Brightness and Reflection Fix** 0.5 | CS core Water Effects supersedes; NAT.CS may require specific water shadow meshes |
| **Assorted Mesh Fixes Parallax** + widespread **Complex Parallax** assets | CS POM path differs from ENB POM mod — visual QA pass required |
| **Skyrim Upscaler** (in SKSE section) | **Hard incompatible** — use CS Upscaling mod instead if needed |
| **Display Tweaks** borderless upscale (if present) | Partial conflict — CS FAQ notes framegen/upscale constraints |

Nolvus marketing highlights "**latest complex parallax features**" — much of this stack was validated under **ENB POM**, not CS Extended Materials. Parallax-heavy holds (farmhouses, caves, LOTD museum, etc.) need in-game CS validation.

---

## 5. CS 1.7.x hard-block check (Nolvus inventory)

Cross-reference against [lessons-learned.md](E:\Skyrim AI Modlist\lessons-learned.md) and CS FAQ obsolete-feature list.

| Hard-block / obsolete standalone | Present in Nolvus? | Action on CS migration |
|---|---|---|
| **ENBSeries** | Yes (core) | Remove |
| **EVLaS** | Yes (1.3.1) | **Disable** — CS blocks vs Sky Sync |
| **Skyrim Upscaler** | Yes (SKSE plugins section) | **Disable** — use CS Upscaling |
| **ReShade Helper** | Not listed | N/A |
| **Light Limit Fix standalone** | Not listed (EVLaS used instead) | Do not add standalone; use CS core LLF |
| **Terrain Shadows standalone** | Not listed | Do not add; CS core |
| **Water Effects standalone** | Not listed (fix mod only) | Do not add; CS core |
| **Subsurface Scattering standalone** | Not listed | Do not add; CS core |
| **Screen Space Shadows standalone** | Not listed | Do not add; CS core |
| **Grass Collision / Grass Lighting standalone** | Not listed (ENB Grass Collisions instead) | Do not add; CS core |
| **Community Shaders** | **Not present** | **Add** as new foundation |
| **NAT.CS III** | Not present | Add for weather |
| **Lux CS** | Not present | Add for interior CS adaptation |
| **CS Light / Light Placer** | Not present | Add to replace ENB lights |
| **Skylighting, Cloud Shadows, Wetness Effects** (separate CS features) | Not present | Add at versions matching CS 1.7.x |

**Additional Nolvus ENB-only mods to disable (not hard-blocks but non-functional under CS):** entire section 11 ENB & ReShade, all ENB Particle Lights listed above, ENB Light suite, Particle Patch for ENB, ENB Helper SKSE plugins (optional keep for menu if CS adds equivalent — currently ENB-specific).

---

## 6. Complexity verdict

### **Major**

**Reasoning:**

1. **Rendering framework swap** — ENB + paired ReShade is not optional garnish; it is the chosen post-processing path for the whole list aesthetic (photorealistic Nolvus Awakening identity).

2. **Weather re-tune** — NAT.ENB III + Nolvus Ascension Weathers Patch + EVLaS + ENB-specific splash/fog fixes must be rebuilt around **NAT.CS III** + CS feature mods. Seasons integration adds testing surface.

3. **Lighting rebuild** — Lux 6.3 + Via + Orbis + Nolvus Lighting Patch + ~25 ENB Particle Lights mods + ENB Light meta-mod + scattered ENB-light clutter patches. Migration requires **Lux CS + CS Light** with careful FOMOD deduplication; Lux author warns optimized ENB meshes may need re-install decisions (performance vs fidelity).

4. **No turnkey path** — modding.wiki ENB Migration Guide covers vanilla-ish lists; Nolvus's curated ENB-light density and custom patches (Nolvus Ascension Lighting Patch 5.13) have **no documented CS migration**.

5. **Parallax / grass / water** — ENB POM, ENB Complex Grass, and parallax texture ecosystem need CS Extended Materials validation; visual regressions likely without dedicated QA.

6. **ReShade loss** — Nolvus Reshade RT variants cannot carry over; accept CS-native look or lose post layer.

7. **Plugin/mod count** — disabling ENB-only mods and adding CS stack is net-neutral to slightly heavier; within Nolvus headroom (228/254 baseline per decisions.md) but requires Successor-profile execution task, not this research pass.

### What "straightforward" would have looked like

Swap ENB binary for CS, install NAT.CS, enable existing LLF — **none apply**; Nolvus already exceeds that scope.

### What "moderate" would have looked like

ENB preset + weather only, minimal particle lights, no ReShade pairing — **Nolvus exceeds this** by an order of magnitude in ENB-light mod count.

### Recommended next steps (human go/no-go)

| If GO on CS | If NO-GO (stay ENB) |
|---|---|
| Create **task-0002** execution plan: Successor profile only; never touch Nolvus donor | Document ENB preset choice (Cabbage/Kauz/etc.) in Successor baseline |
| Phase 1: CS core + disable EVLaS/Upscaler/ENB/ReShade | Keep Nolvus Reshade paired to ENB |
| Phase 2: NAT.CS III + Skylighting/Cloud Shadows/Wetness | |
| Phase 3: Lux CS + CS Light; strip ENB particle mods systematically | |
| Phase 4: Extended in-game QA (interiors, seasons, parallax holds, water) | |
| Budget multiple sessions; treat as **list philosophy change** comparable to Anvil task-0013/0017 CS migration but larger due to Lux depth + ENB-light density | |

---

## Sources

- [Nolvus Awakening homepage](https://www.nolvus.net/)
- [Nolvus Ascension mod list](https://www.nolvus.net/ascension) (2026-07-09 fetch)
- [Nolvus installer — ENB selection](https://www.nolvus.net/appendix/installer/install)
- [Nolvus lighting guide (Lux, ENB Particle Lights)](https://www.nolvus.net/guide/natl/visuals/lighting)
- [Community Shaders FAQ](https://modding.wiki/en/skyrim/developers/community-shaders/faq)
- [ENB Migration Guide](https://modding.wiki/en/skyrim/developers/community-shaders/ENB-Migration-Guide)
- [NAT.CS III (139567)](https://www.nexusmods.com/skyrimspecialedition/mods/139567)
- [Lux CS (153919)](https://www.nexusmods.com/skyrimspecialedition/mods/153919)
- [CS Light (138443)](https://www.nexusmods.com/skyrimspecialedition/mods/138443)
- Anvil Successor: `modlist/community-shaders-audit-2026-07-05.md`, `lessons-learned.md`
