# Task Queue Workflow

This folder is the handoff mechanism between Cursor and Claude Code sessions.

## Lifecycle

1. A task is created (usually by Cursor) as a new file in `queue/`, using
   `template.md` as the starting point. Give it the next sequential ID.
2. When an agent starts working a task, move the file to `in-progress/`
   and update `status: in-progress`.
3. When done, fill in the **Result** section, update `status: done`, and
   move the file to `completed/`.
4. Commit each state change separately if practical, tagged with the task
   ID, e.g. `git commit -m "[task-0012] in-progress: patch AoT/Kasako conflict"`.

## Assignment

- `assigned_to: cursor` — research, drafting, scripting, documentation.
- `assigned_to: claude-code` — requires houseCARL (set
  `requires_housecarl: true`). Claude Code should only ever pick up tasks
  matching both fields.

## Numbering

Use zero-padded 4-digit IDs (`task-0001`, `task-0002`, ...) so files sort
correctly. Check the highest existing ID across all three subfolders before
creating a new one.

## Dependencies

If a task depends on another task's output, set `depends_on: task-XXXX`.
Don't start a task whose dependency isn't in `completed/` yet.
