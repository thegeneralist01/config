---
description: l-worker implements → l-reviewer reviews → l-worker applies feedback
---
Sequential `task` chain for:

$@

1. `agent: "l-worker"` — implement the request.
2. `agent: "l-reviewer"` — review the implementation (read-only); use worker summary + paths.
3. `agent: "l-worker"` — apply reviewer feedback only (minimal fixes).

Pass outputs between steps. End with a short summary of changes + remaining risks.
