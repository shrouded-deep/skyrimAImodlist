# Agent Instructions

Shared instructions for any AI agent working in this repository
(Cursor, Claude Code, or others). Tool-specific notes live in their own
files (`CLAUDE.md` for Claude Code); this file is the common ground.

## Project

Personal Skyrim SE modlist, built on the **Anvil** Wabbajack list foundation.
Goal: stabilize and curate a personal load order now, produce a distributable
successor list later.

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
- Commit messages reference the task ID, e.g. `[task-0007] resolve ACOT/
  Kasako Core Framework conflict`.
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

Re-run a full cross-plugin conflict audit (following the baseline scan
methodology from tasks 0004–0007, 0012) whenever:

- 5 or more mods are added or removed in a single session, OR
- A major structural change lands (worldspace mod, new behavior engine,
  lighting overhaul, Synthesis regen), OR
- A Tier 2 toolchain maintenance window is executed.

Claude Code owns scheduling and executing these re-audits. The re-audit
does not need to be a blocking prerequisite for other work — it can run
in parallel with Cursor tasks — but it should not be deferred
indefinitely. Note the last re-audit date in `decisions.md` each time
one completes.

## Curation direction

This list is a **power fantasy** build. Prefer mods that expand player
capability, variety, and spectacle. Deprioritise or remove mods that
impose survival friction, resource scarcity, carry penalties, or
difficulty-through-fragility. When a new mod's fit is ambiguous, apply
this lens before adding it.

The long-term goal is a distributable successor list — prefer portable
fixes (record patches, SPID/OAR distributions) over personal-preference
hacks that would confuse other users.

## File formats

Task files: see `tasks/template.md`.
Decision log entries: dated, one paragraph, state what changed and why.
