---
name: rtk-for-terminal
description: Prefer RTK-native commands in this repository when RTK explicitly supports them. Use normal shell commands for commands without an RTK-native equivalent.
---

# RTK Workflow (Project Skill)

Use this skill whenever you are going to run shell/terminal commands in this repository.

## Scope clarification

This workflow applies specifically to **shell/terminal commands** you execute in this repository.

* Use normal agent/file tools to inspect project files (for example, reading, searching, and navigating files).
* When executing a terminal command, use an RTK-native command **if RTK explicitly supports that operation**.
* If RTK does not provide a supported equivalent, execute the original command normally.
* Do **not** force `rtk` as a generic prefix for every terminal command.
* Do **not** invent RTK commands for operations that RTK does not support.

In short:

> Use RTK when it has a native command for the operation; otherwise use the normal terminal command.

## Core rule

Prefer RTK-native commands when available.

Examples:

```sh
git status
```

becomes:

```sh
rtk git status
```

and:

```sh
grep "some pattern" app/
```

becomes:

```sh
rtk grep "some pattern" app/
```

However, if RTK does not support the command, run it normally:

```sh
ruby script/foo.rb
```

```sh
bundle install
```

```sh
docker compose up
```

Do not turn unsupported commands into:

```sh
rtk ruby script/foo.rb
rtk bundle install
rtk docker compose up
```

## Command chains

Apply the RTK rule independently to each command in a chain.

Use RTK for supported commands and normal shell commands for unsupported ones.

Correct:

```sh
rtk git status && rtk git diff && ruby script/foo.rb
```

Correct:

```sh
rtk git status && bundle install
```

Incorrect:

```sh
rtk git status && rtk bundle install
```

Do not prefix an entire shell chain with `rtk`. Each command should be evaluated independently.

## Determining RTK support

Only use an RTK command when it is actually supported by the installed RTK version.

If you are unsure whether RTK supports an operation, check its available commands/help first:

```sh
rtk --help
```

You may also use:

```sh
rtk --version
```

Do not assume that an arbitrary shell command can be passed through `rtk`.

If no RTK-native command exists for an operation, use the original command normally.

## Practical execution guidelines

1. Prefer RTK-native commands when available.
2. Use normal shell commands when RTK does not provide a supported equivalent.
3. Do not invent RTK subcommands.
4. Do not use `rtk` as a generic passthrough wrapper.
5. When RTK has a dedicated filter or optimized command, prefer it over the equivalent raw shell command.
6. For debugging where full/raw output from an RTK-supported command is specifically needed, use `rtk proxy <cmd>`.
7. When checking failures only, prefer `rtk err <cmd>` or `rtk test <cmd>` when appropriate and supported.
8. Keep the original command semantics unchanged when switching between RTK and normal shell execution.

## Common RTK commands in this project

### Git

Use RTK for Git operations supported by RTK:

```sh
rtk git status
rtk git diff
rtk git log
rtk git push
```

### Search and files

Prefer RTK-native search/file commands when available:

```sh
rtk ls
rtk read <file>
rtk grep <pattern>
rtk find <pattern>
```

### Ruby / Rails

Always run RSpec, RuboCop, and other project-related Ruby/Rails commands with Bundler and `DISABLE_SPRING=1`.

For commands supported by RTK, use:

```sh
DISABLE_SPRING=1 rtk bundle exec rspec spec/lib
```

```sh
DISABLE_SPRING=1 rtk bundle exec rubocop
```

If a Ruby/Rails command is **not supported by RTK**, keep the same Bundler and Spring requirements but execute it normally:

```sh
DISABLE_SPRING=1 bundle exec rake some_task
```

```sh
DISABLE_SPRING=1 bin/rails db:migrate
```

Do not use `rtk` simply because the command is Ruby/Rails-related. RTK support must be determined separately.

## RTK passthrough

Do not rely on RTK passthrough behavior as the default workflow.

If RTK does not have a native command for an operation, the preferred behavior is:

```sh
<original command>
```

not:

```sh
rtk <original command>
```

`rtk proxy <cmd>` may be used when you explicitly need raw/full output from a command and the use case calls for it, but it should not be used merely to satisfy the RTK workflow.

## Verification

When relevant, verify RTK availability before heavy RTK usage:

```sh
rtk --version
```

You may also inspect the available RTK commands with:

```sh
rtk --help
```

If RTK is unavailable, use the normal shell commands instead. Do not block the task solely because RTK is unavailable.

## Summary

For every terminal command:

1. Determine whether RTK has a native command for that operation.
2. If yes, use the RTK-native command.
3. If no, use the normal shell command.
4. Never invent an RTK command.
5. Never assume `rtk` can or should prefix arbitrary commands.
6. For command chains, make the decision independently for each command.
7. Preserve project-specific requirements such as `DISABLE_SPRING=1` and `bundle exec`.
