---
id: task-XXXX
title: Short descriptive title
assigned_to: cursor        # cursor | claude-code
requires_housecarl: false  # true only if assigned_to: claude-code
status: queued              # queued | in-progress | done
created: YYYY-MM-DD
depends_on:                 # task-XXXX, or leave blank
---

## Description

What needs to happen and why. Include enough context that an agent with
no memory of prior sessions can act on this without re-asking questions.

## Acceptance criteria

- [ ] Bullet list of what "done" looks like
- [ ] Be specific — this is what the completing agent checks off

## Result

(Filled in by the agent that completes the task.)

- What was done
- What changed on disk (files, patches, plugins)
- Follow-up tasks this implies, if any
