# Agent Instructions

Shared instructions for any AI agent working in this repository
(Cursor, Claude Code, or others). Tool-specific notes live in their own
files (`CLAUDE.md` for Claude Code); this file is the common ground.

## Project

Personal Skyrim SE modlist, built on **Keizaal** as the middle-ground Wabbajack
foundation. Approach: fork-and-curate — audit patch lock-in, add content gaps,
and shape toward a power-fantasy build without dismantling the base list's structure.

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

Keizaal baseline (task-0046, 2026-07-12): **719 active checked plugins** (+ 54
CC/implicit = 773 total). Of the 719: 50 `.esl`, 665 `.esp`, 4 `.esm`.

Every task that adds or removes plugins must record the new count in its Result.
**Strongly prefer ESL-flagged mods for any additions** — the full-weight plugin
count is already large. Flag any non-ESL addition for human review before
proceeding; do not assume the user has accounted for the slot cost.

## Mod placement in MO2

New mods added to the list must be placed in a dedicated separator zone
named `[Keizaal Additions]`. Exact placement (relative to which Keizaal
separator) to be established during task-0046 fork-test once the list
structure is understood. Do not append outside a named zone, and do not
sort new mods into the main Keizaal sections until a deliberate placement
decision is recorded in `modlist/decisions.md`.

When adding mods via a task, include this placement explicitly in the
acceptance criteria — do not rely on MO2's default append behaviour.

## Curation direction

This list is a **power fantasy** build. Prefer mods that expand player
capability, variety, and spectacle. Deprioritise or remove mods that
impose survival friction, resource scarcity, carry penalties, or
difficulty-through-fragility. When a new mod's fit is ambiguous, apply
this lens before adding it.

## File formats

Task files: see `tasks/template.md`.
Decision log entries: dated, one paragraph, state what changed and why.
