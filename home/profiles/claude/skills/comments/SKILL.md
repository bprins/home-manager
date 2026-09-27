---
name: comments
description: How to comment code in this user's projects — one line, naming why the code deviates from the obvious choice, never explaining it. Use when writing new code, editing existing code, reviewing a diff for comment quality, or when asked to trim, clean up, or add comments.
---

# comments

## Instructions

1. Only comment where the code deviates from the obvious choice, and name why: `# /usr/local because of Landlock rules in the sandbox`
1. Keep it to one line; two only for two unrelated reasons, never a paragraph
1. Name the constraint, don't explain it: no allowed paths, error text, or consequences of getting it wrong
1. Don't enumerate lists, gotchas, or env vars; if they matter they are in the code
1. Don't restate the code (`# install packages` above `apt-get install`)
1. Don't write session history ("verified in Phase 3", "learned the hard way", "see FINDINGS.md"); state the durable fact or nothing
1. No banners or decorative rules
1. Worth a line: pinned versions, a path or flag chosen against the obvious one, something deliberately absent, ordering that matters, placement for cache reasons
1. Not worth a line: anything a reader would work out themselves, or that was merely hard to discover
1. When editing existing code, trim by these rules but keep every distinct why, compressed to one line, and match the file's comment density
