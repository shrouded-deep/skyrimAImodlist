# Agent Instructions

Shared instructions for any AI agent working in this repository
(Cursor, Claude Code, or others). Tool-specific notes live in their own
files (`CLAUDE.md` for Claude Code); this file is the common ground.

## Project

Personal Skyrim SE modlist, built on **Keizaal** as the middle-ground Wabbajack
foundation. Approach: fork-and-curate — audit patch lock-in, add content gaps,
and shape toward a power-fantasy build without dismantling the base list's structure.

**Git branch:** `keizaal-fork` (set 2026-07-12). The old `nolvus-successor`
remote branch is a **dead archive** of the abandoned Nolvus project — do **not**
pull, merge, or rebase from it. If your local checkout is still on
`nolvus-successor`, switch: `git fetch && git checkout keizaal-fork`. All work
commits and pushes go to `keizaal-fork`.

**MO2 root:** `E:\Skyrim\`

**MO2 profiles:**
- `Keizaal` — pristine Wabbajack-installed profile, never modify
- `Keizaal - Fork` — working profile; all changes go here

## Roles

- **Claude Code**: primary coordinator and supervisor for this project.
  Owns the task queue, strategy, and git — creates task files, assigns
  work, commits and pushes. Also executes any task tagged
  `requires_housecarl: true` directly (record edits, conflict trees,
  patch authoring, distributor grammar validation).
- **Cursor**: execution agent for research (mod pages, version checks,
  compatibility notes), MO2 folder operations, drafting (INI files,
  documentation, changelogs), and scripting. Takes task files from
  `tasks/queue/` as its work queue.

## Session start protocol

At the start of every session, before accepting any user instruction:

1. `git pull` — get latest; don't act on stale queue state.
2. Read `tasks/queue/` — find your assigned, unblocked tasks.
3. **Auto-execute** the first unblocked task assigned to you, without
   waiting for an explicit "run XXXX" from the user — unless the task is
   marked `requires_human_review: true` or has an approval-phrase gate,
   in which case stop and surface it.
4. For Claude Code specifically: check `git status` after pulling and
   commit any uncommitted Cursor work before starting new work.

## houseCARL version check (Claude Code sessions only)

houseCARL current version: **1.6.0**
GitHub: https://github.com/Avick3110/houseCARL

At the start of each Claude Code session, check the GitHub releases page
for a newer version. If one exists, flag it to the user before proceeding
with any task — don't block on it, just surface it. Update the version
number in this file when the plugin is updated.

## Task-first rule

**No work begins without a committed task file.** Verbal assignments,
chat instructions, or described intent do not count. If Claude Code
assigns work to Cursor (or vice versa), the task file must be written
and pushed to `tasks/queue/` before the executing agent begins.
This prevents the "task went AWOL" failure mode where real work ships
with no paper trail.

## Ground rules

- Never assume context from a previous session. Read `modlist/decisions.md`
  and relevant `tasks/completed/*.md` files before acting.
- **Before starting any task, check for recently-completed work that might
  affect it** — not just your own assigned queue. Scan `tasks/completed/`
  (and recent git history if useful) for anything that touches the same
  mod, record type, or decision your task depends on. If a just-completed
  task contradicts or changes the premise of the one you're about to
  start, stop and flag it rather than proceeding on stale assumptions —
  this applies even if the human explicitly handed you the task, since
  the human may not have seen the other result yet either.
- Pull latest before starting any session's work, not just before
  committing — this is how you actually catch the recently-completed
  work mentioned above.
- One task file = one unit of work. Don't bundle unrelated changes.
- Every completed task must record: what was done, what changed on disk
  (if anything), and any follow-up tasks it implies.
- **Before creating any task file, check the highest existing ID across
  both `tasks/queue/` and `tasks/completed/` on disk (not from session
  memory) and use the next number.** Never reuse or guess an ID — a
  parallel agent may have already claimed the number you think is next.
- **When a task implies follow-up work, create the task file yourself**
  directly in `tasks/queue/` using `tasks/template.md`, with the next
  sequential ID — don't just describe the follow-up in prose and leave it
  for a human to write up. This applies whether the follow-up is assigned
  to yourself or to the other agent. Only stop and ask the human first if
  the follow-up implies a real strategic choice (e.g. changing curation
  philosophy, adding a mod that changes list scope) rather than a
  mechanical continuation of work already in progress.
- **Tasks/plans marked "do not execute without human sign-off" require an
  explicit, unambiguous approval phrase before an execution task is
  created or run: the human must say "Task-XXXX approved" (with the
  actual task/plan ID).** General instructions like "run the next task,"
  "go ahead," "continue," or "what's next" do NOT count as approval for
  anything gated this way, even if said right after the plan was
  presented — treat those as applying only to already-approved or
  routine (non-gated) work. If it's ambiguous whether a message approves
  a specific gated item, stop and ask which task ID is being approved
  rather than inferring it. This applies regardless of which agent is
  operating or who queued the task.
- The approval-phrase requirement above applies to *executing* a gated
  action. **Declining or deferring one does not need the same phrase** —
  if a human directly discusses, questions, or reasons through a gated
  decision and the conclusion is not to proceed, that's a legitimate
  decision on its own terms. Record it plainly in `decisions.md` as the
  human's call, without implying more ceremony was needed to say no than
  to say yes.
- Commit messages reference the task ID, e.g. `[task-0003] disable EVLaS
  (hard-blocked by CS 1.7.x)`.
- **After every completed task, immediately commit and push to GitHub** —
  move the task file to `tasks/completed/`, stage all related file
  changes, and push before starting the next task. Do not batch multiple
  task completions into one commit.
- Do not silently change the load order tiering methodology
  (see `modlist/load-order-notes.md`) — flag proposed changes as a task
  for human review instead.
- houseCARL writes always go into a new plugin unless a task explicitly
  says in-place edit is approved.
- **Any script that edits MO2 profile or config files must enforce
  `Assert-Mo2Closed` from `scripts/Mo2ProfileGuardrails.ps1`, not just
  import the module.** "Dot-sources the module" does not mean "enforces
  it" — check explicitly that the enforcement call is present. This is
  not optional for new scripts.
- **GUI tool execution (Pandora, DynDOLOD, ParallaxGen, Synthesis,
  xEdit) cannot be performed by an agent.** These must be launched by
  the user through MO2's executable interface. Any acceptance criterion
  involving these tools must be written as a human step, not an agent
  step.

## Downloads folder

Mod archives live in `E:\Modding\Skyrim Mods\Downloads\` — flat, no subfolders.

When searching for an archive by Nexus mod ID, **also search by mod name** —
some archives lack the standard `*-<id>-*` filename pattern and will be missed
by ID-only globs. Example: `redbag's rorikstead - fomod.zip` has no ID in the
filename. Always fall back to a name-based search before concluding an archive
is absent.

## Conflict re-audit practice

Re-run a full cross-plugin conflict audit whenever:

- 5 or more mods are added or removed in a single session, OR
- A major structural change lands (worldspace mod, new behavior engine,
  lighting overhaul, Synthesis regen), OR
- A Tier 2 toolchain maintenance window is executed.

Claude Code owns scheduling and executing these re-audits. The re-audit
does not need to be a blocking prerequisite for other work — it can run
in parallel with Cursor tasks — but it should not be deferred
indefinitely. Note the last re-audit date in `decisions.md` each time
one completes.

## Plugin count budget

Pristine `Keizaal` baseline (task-0046): 719 active checked + 54 CC/implicit = 773.

**Working `Keizaal - Fork` state (task-0052, 2026-07-12):** 831 active plugins, all
resolve, 0 missing masters. The number that matters vs the **254 full-weight cap** is
**105 full-weight ESP/ESM — 149 slots headroom.** The other 622 ESL-flagged ESP + 50
`.esl` are free (don't count vs the cap).

Every task that adds or removes plugins must record the new full-weight count in its
Result. **Strongly prefer ESL-flagged mods for additions.** If a change would push
full-weight plugins toward 254 (flag at 240), stop for human review before proceeding.

## Mod placement in MO2 (CRITICAL — modlist.txt is REVERSE-ordered)

**Foundation (as of 2026-07-13): Lost Legacy Fork at `D:\Skyrim\`, profile
`Lost Legacy - Fork`.** Earlier notes referencing `Keizaal` or `E:\Skyrim\` are
historical; the active working path is `D:\Skyrim\`.

### Priority direction (definitive)

**`modlist.txt` is the REVERSE of the MO2 UI. TOP of the file = HIGHEST
mod (asset/loose-file) priority. BOTTOM = LOWEST.**

- The base-game separator sits at the very bottom (base game = lowest priority). Top = highest.
- A separator OWNS the mod lines listed immediately **ABOVE** it in the file
  (up to the previous separator). A mod's category = the first separator line below it.

### Separator rules (CRITICAL — do not guess these)

1. **Separators are ALWAYS prefixed `-` in modlist.txt.** This is correct and
   intentional — MO2 doesn't try to load separators, so they stay disabled.
   Never change a separator line to `+`.

2. **Every separator line requires a matching folder** at
   `D:\Skyrim\mods\<separator_name>_separator\` (may be empty).
   If the folder is missing, MO2 silently drops the separator on next save.

3. **Mods belong ABOVE their separator** in modlist.txt (the separator is the
   last line of the group, not the first):
   ```
   +Mod A              ← enabled mod, owned by separator below
   +Mod B              ← enabled mod, owned by separator below
   -Example_separator  ← always -, owns everything above it in this group
   ```

### City/Ryn's/JK's section order

Within the city area of modlist.txt, sections must appear in this order
(top = higher priority):

```
[City Stack mods]
-City Stack_separator
[Ryn's mods]
-Ryn's Mods_separator
[JK's interior mods]
-JKs Skyrim_separator
```

Lost Legacy ships a custom **Ryn's Locations bundle mod** (many Ryn's ESPs
inside one mod folder) plus **Ryn's Standing Stones Patch Collection** as a
separate entry. Treat the bundle as a single modlist entry — do not unpack it.

**Name-matching trap:** you will NOT find per-location Ryn's mod folders
(`Ryn's GoldenGlow Estate`, `Ryn's Robber's Gorge`, etc.) in Lost Legacy.
Those ESPs live inside `Ryn's Locations` at `D:\Skyrim\mods\Ryn's Locations\`.
Do not search for or install individual Ryn's Nexus folders to "match" the list.

### Where things go (top of file → bottom = highest → lowest priority)

1. **`Outputs` separator** (top, highest priority) — generated tool outputs:
   DynDOLOD Output, TexGen Output, xLODGEN, Synthesis output, etc.
2. **Our addition separators** (City Stack, Ryn's Mods, JKs Skyrim, etc.).
3. Lost Legacy's own category separators.
4. Base-game separator (bottom, lowest priority).

**Do NOT append new mods to the end of `modlist.txt`** — the end is the lowest
priority / base-game tier. Appended mods are overridden by everything and fall
outside any separator.

When adding mods via a task, include placement explicitly in the acceptance
criteria — do not rely on MO2's default append behaviour.

## Curation direction

This list is a **power fantasy** build. Prefer mods that expand player
capability, variety, and spectacle. Deprioritise or remove mods that
impose survival friction, resource scarcity, carry penalties, or
difficulty-through-fragility. When a new mod's fit is ambiguous, apply
this lens before adding it.

## File formats

Task files: see `tasks/template.md`.
Decision log entries: dated, one paragraph, state what changed and why.
