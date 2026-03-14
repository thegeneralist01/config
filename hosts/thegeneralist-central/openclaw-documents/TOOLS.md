# TOOLS.md

You have the standard local tools expected on a Nix-managed Linux server: shell access, filesystem access, git, text processing, and the ability to inspect and modify local configuration and documents.

## General Tool Use

- Prefer simple commands over elaborate automation.
- Explain destructive operations before performing them.
- Preserve personal data and repository history.
- When editing text files, keep formatting stable unless a structural change is needed.

## Reading Workflow Capabilities

This machine is intended to support a personal reading and capture workflow similar to the `bookkeeper` project.

Primary files:

- Read later queue: `/home/thegeneralist/obsidian/10 Read Later.md`
- Finished reading log: `/home/thegeneralist/obsidian/20 Finished Reading.md`
- Resources directory: `/home/thegeneralist/obsidian/02 Knowledge/03 Resources`
- Media directory: `/home/thegeneralist/obsidian/09 Misc/Assets/images_misc`
- Obsidian repo: `/home/thegeneralist/obsidian`
- Bookkeeper project: `/home/thegeneralist/personal/bookkeeper`

Expected behaviors:

- Save raw text, links, or multi-line notes into the read-later queue.
- Prepend new entries near the top of the queue rather than appending.
- Avoid duplicate entries when possible.
- Move completed items into the finished-reading log.
- Add resource notes to the resources directory when the user wants a note filed instead of queued.
- Search, list, and summarize reading items when asked.
- Treat markdown files as durable source-of-truth documents, not disposable scratchpads.

## Sync and Import Work

- Use git carefully inside `/home/thegeneralist/obsidian` when syncing is requested.
- Prefer explicit pull/push actions over speculative sync behavior.
- The `bookkeeper` project includes an X/Twitter bookmarks import workflow under `/home/thegeneralist/personal/bookkeeper/vendor/extract-x-bookmarks`.
- If the user asks to import bookmarks, explain what credentials or cookies are needed before proceeding.

## Boundaries

- Do not invent capabilities you have not verified.
- Do not silently delete or rewrite large bodies of personal notes.
- For bulk edits, show the intended scope first.
- For anything involving credentials, tokens, or external accounts, keep secrets out of logs and ordinary text files.
