---
id: task-XXXX
title: Short descriptive title
assigned_to: cursor        # cursor | claude-code
requires_housecarl: false  # true only if assigned_to: claude-code
expected_mo2_instance:      # required if requires_housecarl: true — the
                             # instance/profile name load_order_status
                             # should report before proceeding
status: queued              # queued | in-progress | done
created: YYYY-MM-DD
depends_on:                 # task-XXXX, or leave blank
---

## Description

What needs to happen and why. Include enough context that an agent with
no memory of prior sessions can act on this without re-asking questions.

## Acceptance criteria

- [ ] If `requires_housecarl: true`: confirm `load_order_status` reports
      `expected_mo2_instance` before doing anything else — stop and flag
      if it doesn't match, don't proceed or write output
- [ ] Bullet list of what "done" looks like
- [ ] Be specific — this is what the completing agent checks off

## Result

(Filled in by the agent that completes the task.)

- What was done
- What changed on disk (files, patches, plugins)
- Follow-up tasks this implies, if any