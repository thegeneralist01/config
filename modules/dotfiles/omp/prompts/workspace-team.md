---
description: l-scout + l-expert in a specific workspace (first arg = cwd)
---
Run a two-agent advisory flow in this workspace:

Workspace (cwd):
$1

Task:
${@:2}

Sequential `task` spawns, each with working directory / focus on `"$1"`:
1. `agent: "l-scout"` — cheap recon for the task in that workspace.
2. `agent: "l-expert"` — recommendation/review using scout output.

Do **not** implement automatically.
Final output: relevant files, recommendation, validation steps, remaining risks.
