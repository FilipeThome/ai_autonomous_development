---
name: token-economy
description: Cuts token use with a fact cache, persistent memory, prompt-cache stability, and RTK shell compression. Use when running shell commands, re-reading the repo, handling logs, or when the user mentions tokens, cache, memory, or RTK.
disable-model-invocation: true
---

# Token economy

Spend tokens on the change, not on repeated scans or raw command output.

## Cache and memory

Read these before a scan or a second run of the same command:

- `memory/memory.md` — rules that must hold
- `memory/context.md` — project and stacks
- `memory/error_patterns.md` — failures already explained
- `memory/cache.md` — facts already paid for

`memory/cache.md` is one fact per line, `key: value`. Replace a line when the fact changes. Do not append history. No secrets, source, or logs. Keep it under 40 lines. If a command failed under RTK, store the tee path instead of the log text.

A new lasting rule goes to `memory/memory.md` as one sentence. A repeated failure goes to `memory/error_patterns.md` as pattern plus rule.

## Prompt cache

Leave `AGENTS.md`, `CLAUDE.md`, `.cursor/rules/`, and the memory headers unchanged during an unrelated task. Those files are the stable prefix. Put command output and diffs after that prefix, never inside it.

## RTK

[RTK](https://github.com/rtk-ai/rtk) (Rust Token Killer) compresses shell output before the model reads it. Confirm the binary with `rtk gain`. Another project named rtk does not have that command.

When `rtk` is on PATH, the Cursor hook in `.cursor/hooks.json` rewrites shell commands. If the hook did not run, prefix yourself:

| Need | Command |
| --- | --- |
| git status, diff, log, push, pull | `rtk git …` |
| tests | `rtk test <command>` |
| search | `rtk grep <pattern> <path>` |
| directory | `rtk ls <path>` |
| scout a file | `rtk read <file> -l aggressive` |
| a log file | `rtk log <file>` |
| failures only | `rtk err <command>` |
| no dedicated filter | `rtk proxy <command>` |

Do not wrap a command that already starts with `rtk`. Do not add a second shell compressor in front of RTK.

On failure, RTK stores the full output and prints a tee path. Read that file instead of running the command again. `rtk gain` reports bash-output savings estimated as bytes/4. It is not the provider invoice.

If `rtk` is missing, run the command once, keep the conclusion, and do not paste the raw log into memory. Install steps are `scripts/setup_rtk.ps1`.
