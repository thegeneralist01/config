---
description: l-scout recon → l-expert plan/review (no implementation)
---
Run a sequential two-agent advisory flow using the `task` tool (not parallel).

Task:
$@

Flow:
1. Spawn `task` with `agent: "l-scout"` — cheap recon: relevant files, constraints, findings for the task above.
2. When scout returns, spawn `task` with `agent: "l-expert"` — plan/review/recommendation. Include the scout output in full (or via a `local://` path if huge) as context.

Rules:
- Do **not** implement or edit files unless the user already explicitly asked for implementation.
- Return the expert recommendation clearly; ask before making changes if they did not request implementation.
