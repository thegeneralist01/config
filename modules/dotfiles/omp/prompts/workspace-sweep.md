---
description: Audit current jj workspace state and propose next actions
---
Audit the current workspace with a jj-first workflow.

Use read-only inspection and summarize:
1. Current workspace/change state
2. Files changed and risk hotspots
3. Suggested next actions (commit/split/rebase/test)

Suggested commands:
- `jj workspace list --color=never`
- `jj status --color=never`
- `jj log -r @-::@ --no-graph`
- `jj diff --color=never`

No file edits unless the user asks.
