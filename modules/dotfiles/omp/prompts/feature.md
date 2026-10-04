---
description: "Full feature cycle: recon → plan → plan review → approval → implement (parallel when worthwhile) → review/fix loop"
---
Feature workflow for:

$@

You are the orchestrator. Run each stage with the `task` tool and the named agent. Hand off through `local://` files, not pasted text; subagents share your `local://` root.

Caps are ceilings, not targets. Take the shortest path the exit conditions allow; the expected path is one pass with no loops.

## 0. Intake (you)
- Restate the goal as numbered acceptance criteria. Ask only if ambiguity would change the plan.
- Detect VCS: jj if `jj root` succeeds, else git.
- Record the base revision (jj: `jj log -r @- --no-graph -T commit_id`; git: `git rev-parse HEAD`) and any files already changed before starting (jj: `jj diff --name-only`; git: `git status --porcelain`).
- Size the feature: **small** (one area, few files) or **large**. Size drives scout count, plan-review skip, and parallelism.
- Write goal, criteria, VCS, base revision, and pre-existing changes to `local://feature-brief.md`.

## 1. Recon
- `l-scout-handoff`: one per distinct code area for large features (parallel, one `task` batch); one for small features.
- Merge results into `local://feature-recon.md`.

## 2. Plan
`l-planner` with brief + recon. In addition to its standard format, require:
- **Slices**: id, files owned (each file in at most one slice), depends-on, acceptance check.
- **Shared contracts**: types/interfaces/signatures used by more than one slice; "none" if none.
- **Validation**: exact build/test/lint commands.

Write to `local://feature-plan.md`.

## 3. Plan review
- Skip for small, low-risk plans (single slice, no shared contracts, no public API/schema/migration changes); say you skipped and why.
- Otherwise `l-expert` reviews the plan against brief and recon. Its output must start with `VERDICT: APPROVE` or `VERDICT: REVISE`, then **blocking issues** (only what would make the implementation wrong, unsafe, or incomplete) and **non-blocking notes**. APPROVE is the expected verdict when nothing is blocking.
- REVISE → `l-planner` addresses the blocking issues only → `l-expert` re-reviews. Max 2 review rounds; unresolved issues go to the checkpoint.
- Append non-blocking notes to the plan under "Notes for implementers".

## 4. Checkpoint
Show: slices and waves, execution mode (single/parallel) and why, risks, unresolved blocking issues, pre-existing changes, plan path.

Then use `ask` with options:
- **Approve & implement** → continue to stage 5.
- **Stop at plan** → end with the plan as the deliverable.
- Revision feedback arrives as custom input → `l-planner` revises; re-run `l-expert` only if the change is substantial; ask again.

If `ask` is unavailable, end the turn with the same summary and resume from the user's reply.

## 5. Implement
Choose the mode:
- **Single** (default): one `l-worker` executes the whole plan.
- **Parallel**: only if ≥2 slices own disjoint files and each is substantial. Then:
  - Wave 0: shared contracts, one `l-worker` (skip if none).
  - Waves 1..N in dependency order; slices within a wave run as parallel `l-worker`s in one `task` batch.
  - Each worker gets the plan path, its slice, and its owned files. It must not edit files outside its ownership; if it needs to, it stops and reports, and you reassign.
  - Between waves, run a quick typecheck/build only when the next wave depends on this wave's code.

All workers: no builds, tests, or formatters mid-flight; report files changed and key symbols touched.

## 6. Integrate
Run the plan's validation commands once (yourself or one `l-worker`). Fix integration failures with one `l-worker` until green; if blocked, report exactly what fails.

## 7. Review / fix loop
- `l-reviewer` gets brief, plan, VCS, base revision, and pre-existing changes to exclude. It reviews the diff from base for bugs, security, maintainability, and conformance to plan and acceptance criteria. An empty Critical section is a normal outcome.
- No Critical and no Warnings → done.
- Otherwise one `l-worker` fixes Critical and Warnings only (not Suggestions), then reruns validation.
- Re-review only if a Critical was fixed, ≥3 Warnings were fixed, or the fix diff goes beyond localized edits. Re-review scope: previous findings + fix diff; it verifies resolution, and only new Critical issues reopen the loop.
- Max 3 review rounds. If Criticals remain after round 2, use `l-expert` for the final round. After the cap, stop and report unresolved issues.

## 8. Report
- Files changed and what changed.
- Acceptance criteria status, one line each.
- Validation commands run and results.
- Review rounds and outcome; unresolved issues and risks.

Do not commit, squash, describe, or push; leave VCS state to the user.
