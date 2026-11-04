# Global agent defaults

- Prefer `jj` for version-control operations in repos that are JJ-backed.
- Avoid mutating `git` commands unless explicitly asked for git or the repo is plain Git.
- Keep edits focused and minimal; explain intent briefly before major changes.
- Run relevant checks/tests after code changes when practical.
- If scope is ambiguous, ask clarifying questions before editing.

## Filesystem hygiene

- Avoid broad recursive scans of `$HOME` or `/`.
- Do not traverse `node_modules/`, `.git/`, build outputs, or other large generated directories unless specifically needed.
- When looking for config files, check known paths directly instead of scanning unrelated directories.

## Browser

Use only the browser inside Tern. Do not use Chrome MCP, headless Chromium, relay Chrome, or any other browser automation, unless the user directs otherwise or it's in your best interests to do so.

Before any browser work, read `omp://tools/browser.md` for the in-Tern browser instructions (the Eval `browser` facade with `app.tern: true`), and follow them.

## Academic / preprint style

When drafting or editing scientific papers and preprints:

- Use precise scientific tone; avoid colloquialisms, idioms, and storytelling language.
- Replace defensive hedging with direct claims bounded by the evidence.
- Remove empty boilerplate, placeholders, `TODO`/`FIXME`, and draft apologies before final compilation.
- Prefer exact structural verbs and adjectives over generic wording.
