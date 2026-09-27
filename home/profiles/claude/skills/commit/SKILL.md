---
name: commit
description: Skill for commiting code with git commit
---

# commit

## Instructions

1. Review `git status` and `git diff` to understand the changes; if specific files are named, only stage and commit those
1. Ask which files to include when it is unclear
1. The commit message should be structured as follows: `<type>(<optional scope>): <description>`
1. Create a git commit for the current changes using a concise Conventional Commits-style message
1. Reuse scopes the repo already uses, from `git log -n 50 --pretty=format:%s`
1. Keep the description imperative, at most 72 characters, without a trailing period
1. Don't add `Co-Authored-By` footers
1. End the message with an `Assisted-by: Claude:<model-id>` trailer, using your exact model ID (e.g. `Assisted-by: Claude:claude-opus-5-5`)
1. Never add `Signed-off-by` or use `git commit -s`; the user signs off after reviewing the commit
1. Only commit and don't push
