# Anvil Successor — Modlist Development Repo

Personal Skyrim SE modlist project, built on top of the **Anvil** Wabbajack list,
developed with a two-agent workflow:

- **Cursor** — planning, research, drafting, scripting, documentation
- **Claude Code + houseCARL** — anything requiring direct load-order access
  (record reads/writes, conflict resolution, patch authoring, distributor
  grammar validation)

This repo is the shared memory between sessions and tools. Neither agent
carries context between runs — the files here are the only persistent state.
Commit often, in small units, tagged with the relevant task ID.

## Status

Currently a personal test-bed. A cleaned-up successor list is planned for
public distribution once the workflow and load order are stable.

## Where things live

- `AGENTS.md` — shared working instructions for any AI agent touching this repo
- `CLAUDE.md` — Claude Code-specific notes (houseCARL setup, MO2 instance path)
- `tasks/` — the task queue that connects Cursor and Claude Code sessions
- `modlist/` — decision log, changelog, and load-order working notes

## Workflow (short version)

1. **Cursor session**: review `modlist/decisions.md` and `tasks/completed/`,
   plan next steps, write new task files into `tasks/queue/`, do any task
   *not* requiring houseCARL directly.
2. **Claude Code session**: pick up queued tasks with `requires_housecarl: true`,
   execute via houseCARL, move the task file to `tasks/completed/` with
   results appended, commit.
3. **Back to Cursor**: read completed tasks, update `modlist/decisions.md`
   and `modlist/changelog.md`, plan the next round.

See `tasks/README.md` for the full task-file workflow and format.
"# skyrimAImodlist" 
