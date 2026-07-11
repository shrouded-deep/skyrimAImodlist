# Vokriinator Black + Keizaal — Compatibility Research

**Date:** 2026-07-12  
**Task:** task-0048  
**Profiles inspected:** `Keizaal` / `Keizaal - Fork` (`E:\Skyrim\`), `Nolvus Awakening` (`E:\Nolvus\Nolvus\` — read-only reference)

---

## 1. Executive summary

| Item | Assessment |
|------|------------|
| **Integration difficulty** | **HIGH** |
| **Nolvus stack reusability** | **~65% mod list, ~85% community patches, 0% Nolvus bespoke ESPs** |
| **Recommendation** | VB is achievable on Keizaal but is a **major fork project**, not a plugin swap. Use Nolvus as a **shopping list and load-order template** for the standard VB web; do **not** copy Nolvus integration ESPs. Resolve **Constellations vs Ordinator** and **leveling (no Experience on Keizaal)** before touching VB. |
| **Alternative if scope too large** | (1) **Keizaal SimonRim profile** as gameplay base — already curated, no VB. (2) **Vokrii + Mysticism only** — partial power fantasy without full VB. (3) **Expand Constellations** — keep Keizaal identity, skip Ordinator replacement. |

---

## 2. Vokriinator Black — mod page facts

| Field | Value |
|-------|-------|
| **Nexus** | [Vokriinator - Choice Cuts](https://www.nexusmods.com/skyrimspecialedition/mods/26702) — file **Vokriinator Black** |
| **Nolvus installed version** | **6.14.3** (`meta.ini` on donor instance) |
| **Current Nexus release** | **6.15.2** (changelog on mod page, 2025–2026) |
| **Core merge inputs** | Adamant, SPERG, Path of Sorcery, Vokrii, Ordinator → merged by `Vokriinator Black.esp` |

### Hard requirements (from mod page)

| Mod | Nexus ID | Notes |
|-----|----------|-------|
| Adamant | 30191 | Perk overhaul input |
| SPERG | 14180 | Perk enhancements input |
| Path of Sorcery | 6660 | Magic perk input |
| Vokrii | 26176 | Minimal perks input |
| Ordinator | 1137 | Full perk tree input |
| Ordinator - Combat Styles | 34800 | **weaponspeedmult fix** edition; startup CTD risk |
| Dynamic Animation Casting NG | 73293 | For DAC Improved optional file |
| PO3 Papyrus Extender | 22854 | For DAC Improved |

### Strongly recommended community patches (Nolvus uses most of these)

| Patch | Nexus ID | Nolvus plugin |
|-------|----------|---------------|
| Vokriinator Black - Crash Workaround | 146503 | Not separate plugin — use if CTD |
| Vokriinator Black - Apocalypse patch | (on 26702) | `Vokriinator Black - Apocalypse patch.esp` |
| Vokriinator Black - No Timed Blocking | 77650 | `Vokriinator Black -- No Timed Blocking.esp` |
| Ethereal Arrows Fix | 57281 | `Vokriinator Black Ethereal Arrow Fix.esp` |
| Combat Tweaks | (combatforcaco) | `VokriinatorBlack - combatforcaco.esp` |
| DAC Improved | (on 26702) | `FZmx - DAC - Vokriinator.esp` |
| Discrepancy ISC Patch | 499 | `DISCO_VokriinatorISCPatch.esp` |
| Scrambled Bugs compat | 134590 | Nolvus uses Ordinator + Vokrii SB patches |
| TK Dodge Re Addon | 133318 | Listed mandatory on VB page — **Keizaal has no TK Dodge / MCO** |

### Known failure modes

- **New-game CTD** with Ordinator Combat Styles + certain SKSE plugins → Crash Workaround (146503) or disable Combat Styles per patch author flow.
- **Perk-tree conflicts** with any mod that edits the same perk records (Constellations, Classes Lite, quest perk rewards).
- **Spell mods** need Vokrii + Ordinator dual patches where VB merges both (Apocalypse, Mysticism).

---

## 3. Nolvus VB implementation — plugin inventory

Inspected `E:\Nolvus\Nolvus\MODS\profiles\Nolvus Awakening\plugins.txt` and `modlist.txt`. Active VB-related plugins classified below.

### 3.1 Standard community — copy pattern from Nolvus

**Base frameworks (mods + ESPs):**

| Mod folder (Nolvus) | Active plugin(s) |
|---------------------|------------------|
| Apocalypse - Magic of Skyrim | `Apocalypse - Magic of Skyrim.esp` + AHO/ADF patches |
| Mysticism - A Magic Overhaul | `MysticismMagic.esp` + ~8 Mysticism satellite patches |
| SPERG | `SPERG-SSE.esp` + Apocalypse/USSEP/Thunderchild/ZIA patches |
| Adamant | `Adamant.esp` + Apocalypse/FleshFX/DBM patches |
| Path of Sorcery | `PathOfSorcery.esp` + 9× `PoS_*` CC patches + `DISCO_PathOfSorcery_Mashup.esp` |
| Vokrii | `Vokrii - Minimalistic Perks of Skyrim.esp` + Apocalypse/Mysticism/ASC patches |
| Ordinator | `Ordinator - Perks of Skyrim.esp` + Combat Styles, No Timed Block, Mysticism, Bruma, Apocalypse, ASC |
| MysticOrdinator | `MysticOrdinator.esp` |
| Vokriinator Black | `Vokriinator Black.esp` |
| Vokriinator Black - Apocalypse Patch | `Vokriinator Black - Apocalypse patch.esp` |
| Vokriinator Black - DAC Improved | `FZmx - DAC - Vokriinator.esp` |
| Vokriinator Black - No Timed Blocking | `Vokriinator Black -- No Timed Blocking.esp` |
| Vokriinator Black - Ethereal Arrows Fix | `Vokriinator Black Ethereal Arrow Fix.esp` |
| Vokriinator Black - Combat Tweaks | `VokriinatorBlack - combatforcaco.esp` |
| Vokriinator Black - Discrepancy's ISC Patch | `DISCO_VokriinatorISCPatch.esp` |
| Triumvirate | `Triumvirate - Mage Archetypes.esp` + ISC patch |
| Experience + patches | `Experience.esl` + Ordinator/CC/Sunhelm/quest tweaks — **see §4** |
| CCOR Ordinator | `CCOR_Ordinator.esp` |
| Constellation Magic | Nolvus magic perk satellite (not Keizaal Constellations) |
| YOT suite | `YOT - Apocalypse/Ordinator/Triumvirate/Vokrii.esp` — optional preference pack |

**All of the above are Nexus-available** — none are Nolvus-exclusive mods except the bespoke ESPs in §3.2.

### 3.2 Nolvus-bespoke — do not copy; recreate or omit

| Plugin | Purpose (inferred) | Keizaal action |
|--------|-------------------|----------------|
| `Nolvus Awakening Vokriinator Black Integration.esp` | List glue: VB + Nolvus gameplay/combat/quests | **New Keizaal glue ESP** or SkyPatcher/SPID passes — do not port |
| `Nolvus Awakening Perk Patch.esp` | Perk fixes across Nolvus stack | Audit conflicts on fork; author new patches only where needed |
| `Nolvus Awakening Experience Integration.esp` | Experience + Nolvus content wiring | **Skip** unless Experience is added to Keizaal |
| `Nolvus Awakening Stances Perk System.esp` | Stances NG + perk integration | **Skip** — Keizaal has no Stances/MCO stack |
| `Nolvus Awakening Ashes of War Stance Framework.esp` | Combat stance framework | **Skip** — not on Keizaal |

**Reusability verdict:** Nolvus gives a proven **install order and patch checklist** for the public VB ecosystem. The five Nolvus ESPs are **donor-specific** and align with MCO/Stances/Experience systems Keizaal vanilla+ does not run.

---

## 4. Keizaal vanilla+ — framework overlap

### 4.1 What Keizaal has today (gameplay-relevant)

| Active system | Keizaal state | VB conflict |
|---------------|---------------|-------------|
| **Perk / skill framework** | Vanilla trees + **Constellations** (`ConstellationsNewSkills.esp`, Custom Skills Framework) | **CRITICAL** — Ordinator replaces vanilla trees; Constellations adds parallel custom skills |
| **Magic** | Vanilla spells + **Staff Enchanting Plus** + Mainland Staff Enchanters | VB expects **Mysticism + Apocalypse**; staff-centric Keizaal identity may clash with PoS/Apocalypse mage loop |
| **Combat** | TDM, Precision, Nemesis — **no MCO, no Stances, no TK Dodge** | VB DAC Improved + mandatory dodge patch on Nexus page assume dodge framework; may be optional if dodge mods not installed |
| **Leveling** | **Vanilla level curve** — no Experience | Nolvus runs Experience + `OrdinatorExperiencePatch.esp` + bespoke integration |
| **Survival** | `SurvivalModeImproved.esp` active | Power-fantasy tension; separate from VB but likely candidate for removal |
| **Classes Lite** | Assigned starting skills | May conflict with Ordinator tree design — verify |
| **Bruma / Wyrmstooth / Lucien** | Heavy patch webs (TD + Keizaal patches) | Nolvus uses `Ordinator - Beyond Skyrim Bruma Patch.esp` — **reuse**; other content patches need per-mod VB audit |
| **Scrambled Bugs** | ✅ Already enabled | Good — use VB Scrambled Bugs compat patches like Nolvus |

### 4.2 What Keizaal has disabled (SimonRim profile) — relevant to VB

These are **off** in vanilla+ but overlap VB prerequisites:

| Disabled mod | VB relationship |
|--------------|-----------------|
| Mysticism + patches | **Must install** for Nolvus-style VB stack |
| Adamant + Bard addon | **Must install** — VB hard requirement |
| Sorcerer / Thaumaturgy / Staff paths (SimonRim) | Conflicts with Keizaal's **Staff Enchanting Plus** path — pick one staff philosophy |
| Blade and Blunt, Pilgrim, Mundus, etc. | SimonRim combat/faith — **do not enable alongside VB** |

**SimonRim-disabled content does not simplify VB** — VB is not "enable SimonRim mods"; it is install a **different** EnaiRim-scale stack (Mysticism + Adamant + SPERG + PoS + merge).

### 4.3 Constellations — blocking decision

Keizaal's signature vanilla+ gameplay hook is **Constellations - Additional Player Skills** (Athletics, Hand-to-Hand, Sorcery-style custom skills via CSF).

Vokriinator Black **replaces** the vanilla perk trees Ordinator/Vokrii merge. Constellations **adds** custom skill trees on top. No public "Constellations + Vokriinator Black" patch found; SimonRim profile ships `SimonrimConstellations*.esp` for a **SimonRim** bridge, not VB.

**Options:**

1. **Remove Constellations** from `Keizaal - Fork` when adopting VB (cleanest).
2. **Keep Constellations, skip VB** — expand Constellations instead (alternative path).
3. **Hybrid** — high risk, custom patching required.

---

## 5. Required stack for Keizaal + VB (delta from current fork)

### 5.1 Must add (minimum Nolvus-parity VB web)

Approximate **+25–35 mod folders**, **+40–55 active plugins** (estimate from Nolvus VB block; exact count needs install pass):

1. Mysticism + Keizaal-relevant patches (CC, staves, Bruma if applicable)
2. Apocalypse + creation patches
3. Adamant + Apocalypse patch
4. SPERG + core patches (drop Thunderchild patch if Keizaal lacks Thunderchild)
5. Path of Sorcery + CC patches Keizaal actually uses
6. Vokrii + Apocalypse/Mysticism patches
7. Ordinator + Combat Styles (weaponspeedmult fix) + Mysticism/Apocalypse/Bruma patches
8. MysticOrdinator
9. Vokriinator Black 6.15.x + community patch suite (§2)
10. Triumvirate + ISC patch (if keeping Nolvus mage archetype layer)
11. Crash Workaround on standby

### 5.2 Must remove or disable on Keizaal - Fork

| Item | Reason |
|------|--------|
| `ConstellationsNewSkills.esp` + `Keizaal Patch - Book Covers Skyrim - Constellation.esp` | Perk-tree conflict |
| `Constellations for Simonrim` | Already disabled — keep off |
| Consider: `Classes Lite` | Ordinator overlap |
| Consider: `Survival Mode Improved` | Power-fantasy deprioritize (independent of VB) |

### 5.3 Leveling fork in the road

| Path | Pros | Cons |
|------|------|------|
| **Stay vanilla leveling** | Matches Keizaal today; no Experience patch web | Lose Nolvus `OrdinatorExperiencePatch` + bespoke integration; quest perk rewards need manual audit |
| **Add Experience** (Nolvus pattern) | Proven VB+quest integration template | +mod stack, +patches, +`Nolvus Awakening Experience Integration` equivalent to author |

**Recommendation:** Start **vanilla leveling** on first VB pass; add Experience only if quest/perk pacing feels wrong.

### 5.4 Keizaal content — reuse Nolvus patches where mod overlap exists

| Keizaal content | Nolvus VB patch to reuse |
|-----------------|--------------------------|
| Beyond Skyrim: Bruma | `Ordinator - Beyond Skyrim Bruma Patch.esp` ✅ |
| Wyrmstooth | Check VB Lost Legacy patch (95784); Wyrmstooth-specific VB patches TBD |
| Lucien | Lucien ships own patches — audit perk rewards vs Ordinator |
| Staff Enchanting Plus | **No Nolvus equivalent** — test with Mysticism staff consistency; may conflict with Sorcerer-disabled path |

---

## 6. Integration difficulty breakdown

| Workstream | Effort | Notes |
|------------|--------|-------|
| Install standard VB mod stack | Medium | Nolvus modlist.txt lines 498–551 are a template |
| Community patch load order | Low–Medium | Copy Nolvus plugin order for §3.1 block; verify with LOOT |
| Constellations removal | Low | Design choice + disable ~2–5 plugins |
| Nolvus bespoke ESP replacement | High | Only if quest/combat perks break — houseCARL audit |
| Experience decision | Medium | Optional scope expansion |
| Staff vs magic overhaul alignment | Medium | Keizaal identity risk |
| MCO/Stances/DAC | Low (skip) | Keizaal lacks dodge framework — omit DAC Improved unless adding dodge later |
| New-game stability (Combat Styles CTD) | Medium | Budget time for Crash Workaround |
| Full regression test (Bruma, Lucien, quests) | High | 719 → ~770+ plugins |

**Overall: HIGH** — mostly because Keizaal vanilla+ is intentionally **not** an EnaiRim list, and VB is an EnaiRim-scale transplant.

---

## 7. Nolvus reusability scorecard

| Asset | Reusable? | % effort saved |
|-------|-----------|----------------|
| VB mod folder list | ✅ Yes | ~65% of install research |
| Community patch ESP set | ✅ Yes | ~85% of patch research |
| Plugin load order block | ✅ Template | ~50% of LO work |
| Nolvus bespoke VB ESPs | ❌ No | 0% |
| Experience integration | ❌ Not without adding Experience | 0% |
| Stances/MCO integration | ❌ Keizaal lacks stack | 0% |

---

## 8. Alternatives (if VB scope rejected)

1. **Switch to `Keizaal - SimonRim` profile** — gameplay overhaul already curated; add content on top. No VB. Lowest risk.
2. **Vokrii + Mysticism only** — partial spell/perk upgrade without Ordinator/Adamant/SPERG/PoS merge. Medium scope.
3. **Constellations expansion** — keep Keizaal vanilla+ identity; add skills/perks via CSF-compatible mods. Aligns with original Keizaal design.
4. **Phased VB** — Phase 1 Mysticism + Apocalypse; Phase 2 Vokrii; Phase 3 full VB after Constellations removed and tested.

---

## 9. Recommended next tasks

| Task | Owner | Description |
|------|-------|-------------|
| **Strategic decision** | Human | Constellations stay vs VB — mutually exclusive without custom patch work |
| **task-0049** (proposed) | cursor | Constellations vs Ordinator decision record + disable list if VB proceeds |
| **task-0050** (proposed) | claude-code | Phase 1 VB stack install on `Keizaal - Fork`: Mysticism + Apocalypse + Adamant + SPERG + PoS + Vokrii + Ordinator + VB — copy Nolvus mod list, skip Nolvus ESPs |
| **task-0051** (proposed) | claude-code | Post-VB MAST/conflict audit + new-game smoke test |

---

*Document path: `modlist/vokriinator-black-keizaal-research-2026-07-12.md`*
