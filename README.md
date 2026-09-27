# ai_autonomous_development

Autonomous engineering system for Kotlin, Java, and React. One contract drives Cursor, Claude, Codex, Copilot, Gemini, and Jules. The host model does the work. This repository tells it how.

Kotlin stays a primary stack: null safety, structured concurrency, constructor injection, and clean-architecture boundaries. Java and React sit beside it. Adding a stack does not port Kotlin to Java.

This repository is the framework, not a sample application.

**Author:** Filipe de Brito Thomé

## How a change is delivered

Gates run in order. One implementer writes. The next gate starts only after the current one passes.

1. Read `memory/memory.md`, `memory/context.md`, `memory/error_patterns.md`, and `memory/cache.md`.
2. Large work stops for an architecture decision before code. Large work means a new module, a public API, persistence, security, or a cross-stack change.
3. A small fix inside an existing boundary goes straight to implementation.
4. An incident with a log runs diagnostics before the implementer.
5. Tests run for real. Review starts only after they pass.
6. The reviewer accepts, or the change goes back. A new mistake becomes one rule in memory.

The full contract is [`AGENTS.md`](AGENTS.md). The decision record is [`docs/architecture.md`](docs/architecture.md).

## Stacks

| Stack | What the agent follows | Copy into an app as `AGENTS.md` |
| --- | --- | --- |
| Kotlin and Spring Boot | `.agents/skills/kotlin-spring/SKILL.md` | `stacks/kotlin/AGENTS.template.md` |
| Java and Spring Boot | `.agents/skills/java-spring/SKILL.md` | `stacks/java/AGENTS.template.md` |
| React | `.agents/skills/react-frontend/SKILL.md` | `stacks/react/AGENTS.template.md` |

JVM module boundaries are shared in `.agents/skills/jvm-clean-architecture/REFERENCE.md`. Kotlin and Java skills keep only the language and build rules.

## Layout

| Path | Role |
| --- | --- |
| `AGENTS.md` | Contract for every coding agent |
| `CLAUDE.md` | Claude routing: skill index and subagents |
| `.gemini/settings.json` | Points Gemini CLI at `AGENTS.md` |
| `.cursor/rules/` | Short rules, some limited to Kotlin, Java, or React files |
| `.github/copilot-instructions.md` | Copilot pointer at the contract |
| `.github/instructions/` | Path-scoped Copilot instructions |
| `.agents/skills/` | Procedures, loaded when the task matches |
| `.claude/agents/` | Claude gates: architect, stack engineers, tests, review, diagnostics |
| `.github/agents/` | The same gates for Copilot |
| `memory/memory.md` | Durable rules |
| `memory/context.md` | Project and stacks |
| `memory/error_patterns.md` | Failures already explained |
| `memory/cache.md` | Facts already paid for, one line each |
| `.cursor/hooks.json` | Cursor hook entry |
| `.cursor/hooks/rtk-rewrite.ps1` | Rewrites a shell command through RTK, or leaves it unchanged |
| `stacks/` | Templates to copy into a target application |
| `mcp/` | Optional integrations that need a token |

Skills stay in `.agents/skills/` only. They are not copied into `.claude/skills/`, so Cursor does not load each skill twice.

## Skills

| Skill | When it loads |
| --- | --- |
| `kotlin-spring` | Kotlin, Gradle Kotlin DSL, coroutines, Spring Kotlin |
| `java-spring` | Java, Maven or Gradle, Spring Java |
| `react-frontend` | React components, hooks, Vite or Next |
| `architecture-review` | Large work, before code |
| `autonomous-delivery` | A ticket, the test gate, or the review gate |
| `diagnostics-self-heal` | A failing command, a CI log, or a stack trace |
| `token-economy` | Repeated scans, shell output, cache, memory, or RTK |

## Token spend

Three layers keep the context small. The procedure is `.agents/skills/token-economy/SKILL.md`.

### Memory

`memory/memory.md`, `memory/context.md`, and `memory/error_patterns.md` are the durable record. Read them before coding. A mistake that should not recur becomes one sentence in `memory/memory.md` and one pattern in `memory/error_patterns.md`.

### Cache

`memory/cache.md` stores facts already paid for. Each fact is one `key: value` line. Read it before scanning the repo or repeating a command. Replace a line when the fact changes. The file stays under 40 lines and holds no secrets, source, or logs. A failed RTK command stores its tee path here, not the log text.

### RTK

[Rust Token Killer](https://github.com/rtk-ai/rtk) compresses shell output before a model reads it. `.cursor/hooks.json` runs `.cursor/hooks/rtk-rewrite.ps1` before Cursor shell commands. The hook calls `rtk rewrite` when `rtk` is on PATH and leaves the command unchanged when it is not. It does not wrap a command that already starts with `rtk`.

```powershell
powershell -File scripts/setup_rtk.ps1
```

That check prints install steps when the binary is missing. After RTK is on PATH, `rtk gain` confirms it is Rust Token Killer and not the unrelated Rust Type Kit package. `powershell -File scripts/setup_rtk.ps1 -Apply` runs `rtk init` for this project. Restart the agent after that.

`rtk git`, `rtk test`, `rtk grep`, and `rtk read` are the manual forms when the hook does not run. `rtk gain` estimates bash-output savings as bytes/4. It is not the provider invoice.

Leave `AGENTS.md` and the memory files unchanged during an unrelated edit. That stable prefix is what provider prompt caches reuse.

## MCP

Context7 and Playwright are enabled with no token, in `.cursor/mcp.json`, `.mcp.json`, and `.vscode/mcp.json`.

- Context7 (`@upstash/context7-mcp@4.1.1`) answers current library APIs. Queries stay free of secrets and private source.
- Playwright (`@playwright/mcp@0.0.82`) checks React flows a person can click through. Versions are pinned. Do not switch them to `@latest`.

GitHub stays in `mcp/optional.github.json` until `GITHUB_PERSONAL_ACCESS_TOKEN` is set in the environment. Do not commit the token. Node.js is required for `npx`.

## Use it in an application

Copy `AGENTS.md`, `memory/` (including `memory/cache.md`), `.agents/skills/`, and the MCP files into the application. Copy `.cursor/hooks.json` and `.cursor/hooks/rtk-rewrite.ps1` when that application should compress shell output the same way. Copy one stack template to that application's root and name it `AGENTS.md`. In a monorepo, put the template next to the app. The nearest `AGENTS.md` wins, and its build and test commands are the ones to run.

## Commands

Validate this framework:

```powershell
powershell -File scripts/validate_framework.ps1
```

Print the delivery gates for a task:

```powershell
powershell -File scripts/run_delivery.ps1 -Task "describe the change"
powershell -File scripts/run_delivery.ps1 -Task "describe the change" -LogFile .\failure.log
```

`scripts/run_delivery.sh` takes the same `-Task` and `-LogFile`. Both print the ordered gates. They do not launch a model. Diagnostics is the first gate only when `-LogFile` is set.

Check RTK:

```powershell
powershell -File scripts/setup_rtk.ps1
```

## Project name

The name inside the repository is `ai_autonomous_development`. The folder on disk can remain `kotlin_ai_autonomous` while this workspace is open. Rename that directory after closing it if the path should match.

## License

No license file yet.
