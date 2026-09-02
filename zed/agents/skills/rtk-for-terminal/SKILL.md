---
name: rtk-for-terminal
description: Enforce RTK command usage in this repository by prefixing shell commands with `rtk`,
             including chained commands, and using RTK-native filters when available.
---

# RTK Workflow (Project Skill)

Use this skill whenever you are going to run shell commands in this repository.

## Scope clarification

This workflow applies specifically to **shell/terminal commands** you execute in this repository.

- Use normal agent/file tools to inspect project files (for example, reading, searching,
   and navigating files).
- Apply the `rtk` prefix rule when you are going to run a command in the terminal.
- Do **not** force `rtk` wording for non-terminal actions; keep those instructions tool-native and
  clear.

In short: file inspection can use agent tools directly, while terminal execution must follow RTK
rules.

## Core rule

Always prefix terminal commands with `rtk`.

- Correct: `rtk git status`
- Wrong: `git status`

This also applies to command chains:

- Correct: `rtk git add . && rtk git commit -m "msg" && rtk git push`
- Wrong: `git add . && git commit -m "msg" && git push`

## Practical execution guidelines

1. Prefer RTK-native commands when available (examples: `rtk git status`,
   `rtk tsc`, `rtk lint`, `rtk rspec`, `rtk grep`, `rtk find`, `rtk read`).
2. If RTK has no dedicated filter for a command, still run it through `rtk` (passthrough behavior).
3. For debugging full/raw output, use `rtk proxy <cmd>`.
4. When checking failures only, prefer `rtk err <cmd>` or `rtk test <cmd>` when appropriate.

## Common commands in this project

- Git: `rtk git status`, `rtk git diff`, `rtk git log`, `rtk git push`
- Search/files: `rtk ls`, `rtk read <file>`, `rtk grep <pattern>`, `rtk find <pattern>`

Always run rspec, rubocop and other project related commands (ROR) with bundle and with
DISABLE_SPRING=1 env, in the same command, e.g.:

```sh
DISABLE_SPRING=1 rtk bundle exec rspec spec/lib
```

## Verification

When relevant, verify RTK availability before heavy command usage:

- `rtk --version`
- `rtk gain`
- `rtk init --show`

If `rtk` is unavailable, report clearly and ask whether to proceed without RTK.
