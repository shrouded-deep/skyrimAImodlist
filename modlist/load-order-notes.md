# Load Order Notes

Working notes on tiering/ordering methodology for this list. Keep this
current — Claude Code and Cursor should both check here before proposing
reordering.

## Tiering methodology

1. **Framework mods first** — SKSE, USSEP/USMP, core libraries (e.g.
   Community Shaders, PapyrusUtil, SPID/KID distributors), and other
   infrastructure that downstream mods depend on.
2. **Preserve the Anvil base load order** unless a task explicitly
   documents a deliberate change. This list is a curated successor to
   Anvil, not a greenfield reorder.
3. **Named compatibility patches** sit immediately after the mods they
   patch (Lux/Lux Orbis chains, USSEP/USMP patches, etc.).
4. **Final generated-output tier** — run and load in this order:
   - `ParallaxGen.esp` / `PG_1.esp`
   - Synthesis output (see below)
   - `DynDOLOD.esp`
   - `Occlusion.esp`

   **Current profile (2026-07-07):** `DynDOLOD.esm` enabled; **`DynDOLOD.esp`** and
   **`Occlusion.esp` disabled** — stale Lux-mastered bake post task-0021. Regenerate both
   during **Tier 2 toolchain maintenance** (task-0025 deferred), not while modlist is
   still in active flux.

There is **no bashed or smashed patch** in this list, and none is part
of the inherited Anvil methodology. Wrye Bash is not installed as an MO2
tool in the Anvil instance (`D:\Skyrim AI Modlist\Anvil\tools\` has
Synthesis, xEdit, DynDOLOD, ParallaxGen, etc., but no Wrye Bash).

## Synthesis output (verified 2026-07-05)

Four pre-generated plugins ship in the `Anvil - Synthesis Output` mod
(positions 349–352 in `modlist/baseline-plugins-2026-07-05.txt`). Profile
config: `Anvil\tools\Synthesis\PipelineSettings.json`.

| Output plugin | Patchers | Purpose |
|---|---|---|
| `ANV_SynHPHRaceMenuPatcher.esp` | HighPolyHead-RaceMenuPatcher | RaceMenu / High Poly Head record compatibility |
| `ANV_SynNPCPatcher.esp` | NoDragonLODs, Followers-are-Sneaky, HighPolyHeadVampireFix | NPC/appearance fixes (dragon LODs, follower sneak, vampire HPH) |
| `ANV_SynWorldPatcher.esp` | SSBGPatcher, RemoveLandscapeVertexColor | Stretched Snow Begone forwarding; landscape vertex-color cleanup |
| `ANV_SynW4ENBPatcher.esp` | [panthuncia/WaterForENBPatcher](https://github.com/panthuncia/WaterForENBPatcher) (GitHub; was `F:\...\Fixed\` local path) | Water for ENB cell/worldspace water forwarding |

These are **specialized, task-specific patchers**. They do not perform the
global leveled-list / container / NPC-inventory merging that a Wrye Bash
Bashed Patch or Mator Smash patch traditionally handles.

### Synthesis vs bashed/smashed — relationship

- **Complement, not substitute.** [Synthesis docs](https://mutagen-modding.github.io/Synthesis/Other-Dynamic-Mod-Generators/) recommend placing a Bashed Patch *before* Synthesis in load order when both exist, because Bash processes leveled lists and can revert Synthesis changes if run after.
- **Anvil's approach:** rely on curated named patches, pre-merged plugins (e.g. `SMIM-SE-Merged-All.esp`, `Lightened Skyrim - merged.esp`), and load-order discipline instead of a global merge patch. The baseline scan (task-0002) found no unintentional conflicts in the manually audited record categories.
- **If heavy customization adds many leveled-list or inventory mods:** evaluate adding a targeted merge step (Synthesis [Fusion Patcher](https://www.nexusmods.com/skyrimspecialedition/mods/96297) or LeveledListResolver, or Wrye Bash) as a deliberate follow-up — not as a default restore of generic "bashed last" guidance.

Regenerate Synthesis output through MO2's Synthesis executable after load-order changes that affect the patchers above. Treat all four `ANV_Syn*.esp` files as tool output (see tool-output-awareness skill).

## Known conflicts

We use Community Shaders. ENB mods should not be used.

## Open questions

(none — bashed/smashed question resolved in task-0003, 2026-07-05)
