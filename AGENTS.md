# Agent Instructions

Shared instructions for any AI agent working in this repository
(Cursor, Claude Code, or others). Tool-specific notes live in their own
files (`CLAUDE.md` for Claude Code); this file is the common ground.

## Project

Personal Skyrim SE modlist, built on the **Anvil** Wabbajack list foundation.
Goal: stabilize and curate a personal load order now, produce a distributable
successor list later.

## Roles

- **Cursor**: default agent for research (mod pages, version checks,
  compatibility notes), drafting (INI files, documentation, changelogs),
  and scripting (Wabbajack build config, utility scripts). Also plans and
  writes task files for Claude Code.
- **Claude Code**: only invoked for tasks tagged `requires_housecarl: true`
  in `tasks/queue/` — i.e. anything needing direct read/write access to the
  MO2 load order via houseCARL (record edits, conflict trees, patch
  authoring, distributor grammar validation). Keep these sessions narrow
  and task-scoped to limit usage.

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
- Do not silently change the load order tiering methodology
  (see `modlist/load-order-notes.md`) — flag proposed changes as a task
  for human review instead.
- houseCARL writes always go into a new plugin unless a task explicitly
  says in-place edit is approved.

## File formats

Task files: see `tasks/template.md`.
Decision log entries: dated, one paragraph, state what changed and why.
