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
