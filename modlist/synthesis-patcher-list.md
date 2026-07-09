# Nolvus Awakening V6 — Synthesis patcher research

**Task:** task-0007 · **Date:** 2026-07-09  
**Donor mod:** `Synthesis Patch` v6.0.15 (Ultimate, SREX) · **Successor output target:** `Successor - Synthesis Patch` (task-0006)

---

## Bottom line

**The full Nolvus Awakening V6 Synthesis pipeline is not published and was not found on this machine.** The list ships a **pre-baked** `Synthesis.esp` (~124 MB) with only `meta.ini` in the mod folder — no `PipelineSettings.json`, no patcher settings, no Nolvus-specific Synthesis tool install under `E:\Nolvus\Nolvus\TOOLS\`.

Public Nolvus web docs describe a **manual, two-patcher** workflow from the older **Nolvus Ascension** guide. That cannot account for a 124 MB bake and is **not authoritative for Awakening V6**.

**Confidence:** Official patcher **names/order for V6 = unknown (low)**. Bruma-related **content in the baked ESP = confirmed (high)** via prior houseCARL work (task-0004/0005).

---

## Sources checked

| Source | Result |
|---|---|
| [Nolvus Ascension Synthesis guide](https://www.nolvus.net/guide/asc/output/synthesis) | Documents **2 patchers** + xEdit clean + ESLify (legacy manual path) |
| `https://www.nolvus.net/guide/awakening/output/synthesis` | **404** — no Awakening-specific Synthesis page |
| [Nolvus Awakening mod list page](https://www.nolvus.net/awakening) | Lists `Synthesis Patch` v6.0.15 variants (Ultimate/Ultra/Redux/GO × SREX/NOSREX); **no patcher list** |
| [Nolvus Dashboard GitHub](https://github.com/vektor9999/NolvusDashboard) | Installer source; **no public Synthesis pipeline config found** |
| `C:\Users\steve\AppData\Roaming\Synthesis\` | **Missing** |
| `C:\Users\steve\AppData\Local\Synthesis\` | **Missing** |
| `E:\Nolvus\Nolvus\TOOLS\Synthesis\` | **Not installed** on Nolvus instance |
| `E:\Nolvus\Nolvus\MODS\mods\Synthesis Patch\` | `Synthesis.esp` (124,190,501 bytes) + `meta.ini` only |
| `E:\Modding\Skyrim Mods\tools\Synthesis\PipelineSettings.json` | **Different project** (Anvil / Skyrim AE path) — **4 patchers**, not Nolvus |

---

## Official Nolvus documentation (Ascension manual path)

From [10.1 Synthesis (Nolvus Ascension)](https://www.nolvus.net/guide/asc/output/synthesis):

| Order | Patcher | Notes |
|---|---|---|
| 1 | **Water Does Damage Patcher** | Add via Synthesis UI; compile before run |
| 2 | **Remove Landscape Vertex Color** | Second patcher in same group |

**Post-run steps (documented):**

1. Create MO2 mod `Synthesis Patch` from overwrite output.
2. **Manual xEdit clean:** In `Synthesis.esp`, delete the override of `ccKRTSSE001QNWorld` under `cckrtsse001_altar.esl`.
3. **ESLify** with R88 ESLify (flag as ESL).

**Caveat:** Awakening V6 uses the **Nolvus Dashboard** auto-installer, which pre-generates outputs. The homepage states Awakening is **beta with no manual install guide yet**. Treat the Ascension two-patcher list as a **minimum documented subset**, not the full V6 bake recipe.

---

## Machine-local pipeline (not Nolvus — do not copy)

Found at `E:\Modding\Skyrim Mods\tools\Synthesis\PipelineSettings.json` (Data path: `E:\Modlists\Skyrim AE\Stock Game\Data`):

| Order | Nickname | GitHub repo |
|---|---|---|
| 1 | ExperienceMutagenPatcher | `https://github.com/tr4wzified/ExperienceMutagenPatcher` |
| 2 | SynBookSmart | `https://github.com/Synthesis-Collective/SynBookSmart` |
| 3 | DisplaySpellTomeLevelPatcher | `https://github.com/tr4wzified/DisplaySpellTomeLevelPatcher` |
| 4 | SynSetESL1 | `https://github.com/Michael-wigontherun/SynSetESL` |

This is a **personal/Anvil pipeline**. It is **not** the Nolvus Awakening V6 bake (124 MB vs tiny output; different data folder; missing masters like `AI Overhaul.esp`, `BSHeartland.esm`, `Personalized Music v 6.0.esp`).

---

## Baked `Synthesis.esp` analysis (Nolvus donor)

| Property | Value |
|---|---|
| File | `E:\Nolvus\Nolvus\MODS\mods\Synthesis Patch\Synthesis.esp` |
| Size | 124,190,501 bytes (~118 MiB) |
| Package version | 6.0.15 (`meta.ini`) |
| Install source | `E:/Modding/Skyrim Mods/Downloads/10. OUTPUTS/Synthesis Patch-v6.0.15.7z` |

### Master plugins (55, from TES4 header scan)

These are **content dependencies** of the baked patch, not patcher names:

```
AI Overhaul.esp
Amber Guard.esp
AnotherOakwood.esp
BluePalaceDomeLight.esp
BSAssets.esm
BSHeartland.esm
ccafdsse001-dwesanctuary.esm
ccbgssse031-advcyrus.esm
ccbgssse067-daedinv.esm
cceejsse001-hstead.esm
cceejsse002-tower.esl
cceejsse004-hall.esl
cckrtsse001_altar.esl
ccrmssse001-necrohouse.esl
ccvsvsse004-beafarmer.esl
Cutting Room Floor.esp
Dawnguard.esm
Deadly Shadows of  Riften.esp
DOS - Grey Quarter Overhaul Patch.esp
Dragonborn.esm
Dunpar Wall.esp
Dwarfsphere.esp
EpicSolitude.esp
Falskaar.esm
FlyingCrowsSSE.esp
HearthFires.esm
Inigo.esp
Lainalten.esp
Landscape and Water Fixes.esp
Landscape Fixes For Grass Mods.esp
LegacyoftheDragonborn.esm
Lux.esp
MoonAndStar_MAS.esp
Nolvus Awakening Seasonal Ground.esp
Nolvus Northern Roads Patch.esp
Northern Roads.esp
Personalized Music v 6.0.esp
RYFTEN - Defenses Canal West Side North.esp
Seasonal Landscapes - Solstheim.esp
Skyrim.esm
Southfringe Crash Fix.esp
Sunthgat.esp
The Great City of Winterhold v4.esp
The Great Village of Kynesgrove.esp
Tools of Kagrenac.esp
TreasureHunter.esp
Update.esm
Vernim Wood.esp
Water for ENB - Patch - Atlas Map Markers.esp
Water for ENB - Patch - Beyond Skyrim.esp
Water for ENB - Patch - Falskaar.esp
Water for ENB (Shades of Skyrim).esp
WheelsOfLull.esp
WindPath.esp
WiZkiD Signs - Interesting NPC patch.esp
```

### Patcher hypotheses from masters (medium confidence — unverified)

| Master signal | Plausible Synthesis patcher | Repo (if known) |
|---|---|---|
| `AI Overhaul.esp` | AI Overhaul Patcher | `https://github.com/Excinerus/AI-Overhaul-Patcher` |
| `Personalized Music v 6.0.esp` | Music / cell forwarding patcher (e.g. KmrMusicCellsPatcher) | Community patchers vary |
| `Experience` mod present in load order | ExperienceMutagenPatcher | `https://github.com/tr4wzified/ExperienceMutagenPatcher` |
| Landscape / water masters | Remove Landscape Vertex Color, Water Does Damage, or similar | Per Ascension docs |
| `Northern Roads.esp`, `Nolvus Northern Roads Patch.esp` | Unknown NR-related synthesis patcher | — |
| `Water for ENB *.esp` masters | May be forwarded by a water/worldspace patcher | Separate from `Water for ENB - Patch - Beyond Skyrim.esp` plugin |

**Do not treat this table as the Nolvus V6 pipeline.** It is inference from masters only. The actual patcher count, order, and settings remain unknown until a `PipelineSettings.json` is obtained from Nolvus build sources or Discord.

---

## Bruma — flags for Successor regen

Bruma was removed from Successor (task-0004). The **Nolvus donor** `Synthesis.esp` still contains Bruma data.

| Item | Detail | Action for Successor regen |
|---|---|---|
| **Masters** | `BSHeartland.esm`, `BSAssets.esm` in baked `Synthesis.esp` | New output must **not** list these masters |
| **WRLD winners** (task-0004 houseCARL) | `CYRCrowsWoodWorld`, `CYRGreenLeafGlade` on `BSHeartland.esm` | Regen without Bruma in load order; verify no CYR worldspace overrides remain |
| **Related plugin** | `Water for ENB - Patch - Beyond Skyrim.esp` | Already disabled with Bruma stack — keep disabled |
| **Patcher exclusion** | Any patcher that scans all worldspaces or Bruma cells | Disable or configure to skip BSHeartland if the patcher supports it; otherwise expect run failures until pipeline is trimmed |

After regen: ESLify per Nolvus docs; apply ccKRTSSE001QNWorld xEdit delete if that override reappears.

---

## Successor regen workflow (when pipeline is known)

1. Install Synthesis to `E:\Nolvus\Nolvus\TOOLS\Synthesis\` (Dashboard does not ship it on this install).
2. Add MO2 executable pointing at `Synthesis.exe`; **run from MO2** on **Successor** profile.
3. Set profile data path to `E:\Nolvus\Nolvus\STOCK GAME\Data` (or MO2 virtual merge root).
4. Import or rebuild `PipelineSettings.json` from Nolvus sources (see follow-ups).
5. Set output folder to `E:\Nolvus\Nolvus\MODS\mods\Successor - Synthesis Patch\`.
6. Run pipeline; enable `Successor - Synthesis Patch`, keep `Synthesis Patch` (Nolvus original) disabled.
7. Add `Synthesis.esp` to Successor `plugins.txt` via MO2; post-process (xEdit clean, ESLify).

---

## Follow-up tasks implied

1. **Obtain Nolvus V6 `PipelineSettings.json`** — Nolvus Discord / Patreon / maintainer request (blocking for equivalent regen).
2. **Optional:** Mutagen record-type diff — donor `Synthesis.esp` vs post-regen Successor output — to validate coverage once a candidate pipeline exists.
3. **Optional:** If pipeline never surfaces, incremental regen experiment starting from Ascension two-patcher base + adding patchers suggested by master-hypothesis table until master set stabilizes (high effort).

---

## Information confidence summary

| Claim | Confidence |
|---|---|
| Nolvus V6 ships pre-baked Synthesis only | **High** |
| Full V6 patcher list publicly documented | **Low (not found)** |
| Ascension two-patcher list exists | **High** (legacy guide) |
| Two patchers alone reproduce V6 bake | **Low** (size/master count mismatch) |
| Baked ESP masters Bruma (`BSHeartland`, `BSAssets`) | **High** |
| Baked ESP wins Bruma worldspaces (`CYRCrowsWood*`, `CYRGreenLeaf*`) | **High** (task-0004 houseCARL) |
| `E:\Modding\...\PipelineSettings.json` is Nolvus pipeline | **High negative** (wrong profile/path) |
