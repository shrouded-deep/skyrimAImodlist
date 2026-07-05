@AGENTS.md

## Claude Code specific

- houseCARL should already be registered as an MCP server for this host.
  If tools aren't available, check with `/mcp` before doing anything else.
- MO2 instance folder: D:\Skyrim AI Modlist\Anvil
- On starting a session: list `tasks/queue/*.md`, filter to files with
  `assigned_to: claude-code` and `status: queued`. Work through them one
  at a time, moving each to `tasks/completed/` when done (see
  `tasks/README.md` for the exact process).
- Do not pick up tasks assigned to `cursor` — leave them in the queue.
- If a queued task doesn't actually require houseCARL, say so in the task
  file instead of doing it — it should be reassigned to Cursor.
