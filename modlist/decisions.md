# Decisions Log

Dated entries recording what changed and why. Most recent first.

---

## 2026-07-09 — Post-Bruma conflict re-audit: CLEAN (task-0005)

houseCARL WRLD re-audit run after Bruma removal. Checked all kept worldspace mods (Falskaar, Wyrmstooth, Midwood Isle, Moonpath, Vigilant, Unslaad, Gray Fox Cowl, Darkend) for orphan masters and unexpected record winners. All winners are appropriate Lux/FWMF/Water-for-ENB patches. No active plugin retains BSHeartland.esm as a live master. 5 stale CYR worldspace records remain in houseCARL's index (Water for ENB - Patch - Beyond Skyrim.esp file present on disk but not loaded); no gameplay impact. 17 stale loadorder.txt warnings will clear on MO2 refresh. Next re-audit after Tier 2 regen (Synthesis + DynDOLOD + TexGen + ParallaxGen).

---

## 2026-07-09 — DynDOLOD and Synthesis output layer disabled (pre-regen state)

User manually disabled `DynDOLOD - Output - Ultimate`, `DynDOLOD - Textures - Ultimate`, and `Synthesis Patch` mod folders on Successor. Plugins `DynDOLOD.esm`, `DynDOLOD.esp`, `Occlusion.esp`, and `Synthesis.esp` removed from `plugins.txt`. This brings the list to a known-clean state for loading without stale Bruma LOD/synthesis data. The runtime input mods (DLL, Resources, TexGen Fixes) remain enabled. These outputs must be regenerated as part of Tier 2 regen after the current curation pass is complete.

---

## 2026-07-09 — Beyond Skyrim Bruma removed from Successor

First section 4.3 content-width cut executed on the Successor profile (task-0004): 27 mod folders disabled, 37 Bruma/BSHeartland plugins removed (~3823 → ~3786 active plugins). Nolvus Awakening donor profile unchanged. Rationale: user-confirmed removal candidate; task-0002/0003 audit showed no SREX, Lux, or ENB dependency; disable-only with no ESP surgery. **Before first launch:** human must regenerate Synthesis.esp (BSHeartland worldspace winners); DynDOLOD/TexGen/ParallaxGen regen recommended for Cyrodiil border. Post-removal houseCARL conflict re-audit queued as task-0005.

---

## 2026-07-09 — ENB retained; Community Shaders transition declined

Task-0001 audit found the transition would be Major complexity: Amon ENB + Nolvus ReShade 2026 are deployed to the stock game folder (not MO2-toggleable), 63 ENB-linked mod folders, 200+ Lux/Via/Orbis patches tuned for ENB, and the SREX+Lux Orbis patch web is a project constraint that cannot be broken. Decision: retain Amon ENB as-is. Community Shaders is not installed and will not be added. ENB is treated as non-alterable infrastructure alongside the city/SREX stack.

---

## 2026-07-09 — Plugin count baseline recorded

Nolvus Awakening V6 ships with **228 of 254 active plugins** — 26 slots of headroom. This is the baseline for the Successor profile before any additions or removals. Every task that adds or removes plugins must record the new count in its Result. Prefer ESL-flagged mods for additions; flag any task that would push the count above 245 for human review before proceeding.

---

## 2026-07-08 — Project created; Nolvus Awakening V6 as donor list

Pivoting from the bottom-up Anvil Successor build to a top-down approach
using Nolvus Awakening V6 as the donor. Nolvus already includes ~99% of
desired content and ships with deep SR Exterior Cities (SREX) integration
across all hold exteriors. The Nolvus city stack is treated as
non-alterable — the SREX patch web is load-bearing and will not be
disrupted. Curation work will focus on trimming unwanted mods and adding
genuine gaps that do not touch the city/exterior ecosystem.

Reference material from the Anvil Successor project is preserved at
`E:\Skyrim AI Modlist\anvil-successor\` and `E:\Skyrim AI Modlist\lessons-learned.md`.
