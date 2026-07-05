@AGENTS.md

## Claude Code specific

- houseCARL should already be registered as an MCP server for this host.
  If tools aren't available, check with `/mcp` before doing anything else.
- MO2 instance folder: D:\Skyrim AI Modlist\Anvil
- **Before running any houseCARL task, call `load_order_status` and confirm
  the reported instance/profile name actually matches the Anvil-based
  instance above.** If it doesn't match, switch instances first and
  re-verify — do not proceed with a task, and do not write any output
  files, until the instance is confirmed correct. If a task's frontmatter
  includes `expected_mo2_instance`, that name must match exactly.
- On starting a session: list `tasks/queue/*.md`, filter to files with
  `assigned_to: claude-code` and `status: queued`. Work through them one
  at a time, moving each to `tasks/completed/` when done (see
  `tasks/README.md` for the exact process).
- Do not pick up tasks assigned to `cursor` — leave them in the queue.
- If a queued task doesn't actually require houseCARL, say so in the task
  file instead of doing it — it should be reassigned to Cursor.
