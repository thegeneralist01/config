---
description: l-scout → l-planner → l-worker full implementation
---
Sequential `task` chain for:

$@

1. `agent: "l-scout"` — find all code relevant to the task.
2. `agent: "l-planner"` — implementation plan from scout context (no edits).
3. `agent: "l-worker"` — implement the plan from planner output.

Pass each step's result into the next task instructions.
After the worker finishes, briefly summarize what changed.
