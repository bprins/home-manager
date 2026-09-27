---
name: librarian
description: Cache and refresh remote git repositories under ~/.cache/checkouts/<host>/<org>/<repo> so future references can reuse a local copy. Use when the user points to a remote git repository (URL, git@, or owner/repo) as reference, or when you need to read upstream source such as a Helm chart, Nix module, or library.
---

# librarian

## Instructions

1. Resolve the local path with `bash ~/.claude/skills/librarian/checkout.sh <repo> --path-only`; it accepts URLs, `git@` remotes and `owner/repo` (defaults to github.com)
1. Search and read from that path instead of fetching files over the web
1. Call it again on every later reference to the same repo; it clones once, then fetches at most every 5 minutes and fast-forwards when clean
1. Add `--force-update` when the latest upstream state matters, such as a just-published release
1. Don't edit inside the cache; use a separate worktree or copy for changes
