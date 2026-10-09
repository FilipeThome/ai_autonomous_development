# ai_autonomous_development

Autonomous engineering system for Kotlin, Java, and React. One contract drives Cursor, Claude, Codex, Copilot, Gemini, Jules, and Windsurf. The host model does the work. This repository tells it how.

Kotlin stays a primary stack: null safety, structured concurrency, constructor injection, and clean-architecture boundaries. Java and React sit beside it. Adding a stack does not port Kotlin to Java.

This repository is the framework, not a sample application. The contract is [`AGENTS.md`](AGENTS.md). This README is the operator guide: features, daily use, and configuration. The decision record is [`docs/architecture.md`](docs/architecture.md).

**Author:** Filipe de Brito Thomé

## Features

| Feature | What it gives you |
| --- | --- |
| One contract | `AGENTS.md` is the full policy. Adapter files only route to it. |
| Sequential gates | Architecture, one implementer, tests, then review. The next gate starts after the current one passes. |
| Three stacks | Kotlin and Spring Boot, Java and Spring Boot, and React, each with a skill and a copyable template. |
| Skills | Procedures live only in `.agents/skills/`. Routing files name which one to read. |
| One-gate agents | Claude and Copilot each have an architect, three stack engineers, a test engineer, a reviewer, and diagnostics. |
| Incident path | A log or a failing command is diagnosed before anyone edits, then fixed with a regression test. |
| Playbooks | Ticket intake, behavior-preserving refactor, diagnostics, self-healing, and learning. |
| Strict review | A code-review stage and a security-review stage. Accept requires both to pass. |
| Token economy | Durable memory, a short fact cache, a stable prompt prefix, and optional RTK shell compression. |
| Live docs and UI checks | Context7 for current library APIs. Playwright for flows a person can click through. |
| Framework check | `scripts/validate_framework.ps1` fails when the contract, skills, MCP pins, or hooks drift. |

Scripts print a plan. They do not launch a model, and nothing in this repo names a vendor or an `AI_RUNNER`.

## Prerequisites

- A host that reads `AGENTS.md`: Cursor, Claude Code, Codex, Copilot, Gemini CLI, Jules, or Windsurf.
- PowerShell for `scripts/*.ps1` on Windows. Bash for `scripts/run_delivery.sh`.
- Node.js on `PATH` so `npx` can start the MCP servers.
- Optional: [Rust Token Killer](https://github.com/rtk-ai/rtk) on `PATH`. The hooks no-op until `rtk` exists. Confirm the binary with `rtk gain` so it is Rust Token Killer and not the unrelated Rust Type Kit package.

## Quick start

Open this repository in the host. The rules, skills, and MCP config are already wired.

Validate the framework:

```powershell
powershell -File scripts/validate_framework.ps1
```

Print the gates for a task:

```powershell
powershell -File scripts/run_delivery.ps1 -Task "describe the change"
```

An incident starts from the log:

```powershell
powershell -File scripts/run_delivery.ps1 -Task "describe the failure" -LogFile .\failure.log
```

`scripts/run_delivery.sh` takes the same `-Task` and `-LogFile` (`--task` and `--log-file` also work). Diagnostics is gate 0 only when a log path is set.

Check RTK:

```powershell
powershell -File scripts/setup_rtk.ps1
powershell -File scripts/setup_rtk.ps1 -Apply
```

`-Apply` runs `rtk init` for this project and exits with an error when the binary is missing. Restart the agent after init.

## How to use it

Tell the host the outcome in plain language. It classifies the task, then walks the gates.

| You are doing | What happens |
| --- | --- |
| Asking a question | The agent answers and stops. No design gate, no edit. |
| A small fix inside one existing boundary | Implementation, then the real test command, then review. |
| A feature, a new module, a public API, persistence, security, or a cross-stack change | Architecture first. Code starts after the decision is `approved`. |
| A red command, a CI log, or a stack trace | Diagnostics states one root cause, then the implementer applies the smallest fix and a regression test. |
| A refactor | Structure changes only while a behavior-preserving test is already green. |
| A code review or a security review | Review only. The agent does not edit the change under review. |

Examples you can paste to the agent:

```text
Add a Kotlin endpoint that creates an order. Keep the existing module boundaries.
```

```text
This command failed. Diagnose it, fix the cause, and add a regression test.
powershell -File scripts/validate_framework.ps1
```

```text
Review the current diff. Run the code-review stage, then the security-review stage.
```

In Claude Code, `/deliver` follows `AGENTS.md` and `.agents/skills/autonomous-delivery/SKILL.md`. `/devin` follows the same command and keeps the gates sequential.

### Definition of done

- The change compiles.
- The real test command for that stack passes.
- Architecture boundaries hold.
- Memory rules hold.
- The reviewer accepts.

A repeated mistake becomes one sentence in `memory/memory.md` and one pattern in `memory/error_patterns.md`.

### Use it in an application

This repo has no sample app. Copy the system into the application you want the agent to build.

Copy these into the application (or the monorepo root):

- `memory/` including `memory/cache.md`
- `.agents/skills/`
- `.cursor/mcp.json`, `.mcp.json`, and `.vscode/mcp.json`
- `.cursor/hooks.json` and `.cursor/hooks/rtk-rewrite.ps1` when shell output should be compressed in Cursor
- `.claude/hooks/rtk-rewrite.ps1` and the hook block in `.claude/settings.json` when using Claude Code
- `.cursor/rules/` for Cursor, `.github/` for Copilot, `.claude/` for Claude Code, `.gemini/settings.json` for Gemini CLI

Then copy one stack template to that application's root and name it `AGENTS.md`:

- `stacks/kotlin/AGENTS.template.md`
- `stacks/java/AGENTS.template.md`
- `stacks/react/AGENTS.template.md`

Those templates are not contracts while they still live under `stacks/`. In a monorepo, put the template next to the app. The nearest `AGENTS.md` wins, and its build and test commands are the ones to run. The framework contract can stay at the monorepo root; the app template sits closer to the code.

Replace the facts in `memory/cache.md` with facts about that application. Keep the cache under 40 lines. Leave tokens out of git.

## How a change is delivered

Gates run in order. One implementer writes. Tests do not edit production code; a failure goes back to that implementer. Review starts only after the suite is green.

0. **Diagnostics**, only when the task includes a log or a failing command. Read `ai/observability/diagnostics.md` and `.agents/skills/diagnostics-self-heal/SKILL.md`.
1. **Architect**, except for a question or a small fix inside an existing boundary. Reply shape is in `.agents/skills/architecture-review/SKILL.md`. `changes required` stops the work.
2. **Implement** with `kotlin-engineer`, `java-engineer`, or `react-engineer`. Existing Kotlin stays Kotlin unless you ask for a port.
3. **Test** with the command in the target application's `AGENTS.md`. This framework's command is `powershell -File scripts/validate_framework.ps1`.
4. **Review**. The delivery reviewer rejects architecture, test, or memory-rule failures. A request for a code review or a security review also runs `.agents/skills/rigorous-review/SKILL.md`.

Use the host's strongest model for architecture and review. Use the host's selected model for everything else. Do not hardcode a vendor.

## Stacks

| Stack | Skill | Copy into an app as `AGENTS.md` | Test command in the template |
| --- | --- | --- | --- |
| Kotlin and Spring Boot | `.agents/skills/kotlin-spring/SKILL.md` | `stacks/kotlin/AGENTS.template.md` | `gradlew.bat test` or `./gradlew test` |
| Java and Spring Boot | `.agents/skills/java-spring/SKILL.md` | `stacks/java/AGENTS.template.md` | `mvn -q test`, or the Gradle test task the repo already has |
| React | `.agents/skills/react-frontend/SKILL.md` | `stacks/react/AGENTS.template.md` | The package manager that matches the lockfile: `npm test` and `npm run build` |

JVM module boundaries are shared in `.agents/skills/jvm-clean-architecture/REFERENCE.md`. Domain stays free of Spring, JPA, and HTTP. Application owns use cases and the unit of work. Infrastructure owns persistence and clients. API maps transport and status codes. Follow the split the target repo already has.

Kotlin rules the agent will enforce: no `!!`, no `runBlocking` on a request path, no `GlobalScope`, constructor injection, JUnit 5, MockK, and `runTest`. Run `detekt` or `ktlintCheck` only when that Gradle task already exists.

Java rules: the Java version from the build file (21 only when the build has not chosen), constructor injection, records for DTOs, JUnit 5, and AssertJ when it is already on the classpath.

React rules: function components, the framework already in `package.json`, TypeScript kept when `tsconfig.json` exists, one server-state library, derived data computed during render, React Testing Library, and Playwright for a click-through flow.

## Skills

Skills stay in `.agents/skills/` only. They are not copied into `.claude/skills/`, so Cursor does not load each skill twice. Each `SKILL.md` sets `name`, `description`, and `disable-model-invocation: true`. That flag stops Claude Code from auto-loading the skill. The agent reads the file when `CLAUDE.md`, a Cursor rule, or a Copilot instruction names it.

| Skill | When to read it |
| --- | --- |
| `kotlin-spring` | Kotlin, Gradle Kotlin DSL, coroutines, Spring Kotlin |
| `java-spring` | Java, Maven or Gradle, Spring Java |
| `react-frontend` | React components, hooks, Vite or Next |
| `architecture-review` | Large work, before code |
| `autonomous-delivery` | A ticket, the test gate, or the review gate |
| `diagnostics-self-heal` | A failing command, a CI log, or a stack trace |
| `token-economy` | Repeated scans, shell output, cache, memory, or RTK |
| `rigorous-review` | A code review or a security review, any language |

`rigorous-review` reads `CODE_REVIEW.md`, then `SECURITY_REVIEW.md`. `LANGUAGE_HAZARDS.md` is read only for languages present in the diff. A blocker or a major fails that stage. `Verdict: accept` requires both stages to pass. Findings use `path:line — blocker | major — rule — why it fails — required change`.

## Agents

Delegate one gate. Implementation, tests, and review never run in parallel on the same change.

| Gate | Claude (`.claude/agents/`) | Copilot (`.github/agents/`) |
| --- | --- | --- |
| Architecture, before code on large work | `architect.md` | `architect.agent.md` |
| Kotlin | `kotlin-engineer.md` | `kotlin-engineer.agent.md` |
| Java | `java-engineer.md` | `java-engineer.agent.md` |
| React | `react-engineer.md` | `react-engineer.agent.md` |
| Tests | `test_engineer.md` | `test-engineer.agent.md` |
| Review | `reviewer.md` | `reviewer.agent.md` |
| Incident, before the implementer | `diagnostics.md` | `diagnostics.agent.md` |

The architect and the reviewer do not edit application code. The test engineer runs the suite and returns failures. The stack engineer is the only writer.

Claude commands live in `.claude/commands/`:

| Command | Effect |
| --- | --- |
| `/deliver` | Read memory, architecture when the change crosses a boundary, implement with the matching skill, run tests, review. |
| `/devin` | The same delivery path, with the gates kept sequential. |

## Playbooks

Short procedures under `ai/`. The skills are the full version. These files are the checklist the validator requires to stay substantive.

| Playbook | Use it when |
| --- | --- |
| `ai/tickets/ticket_processor.md` | Turning a ticket into one stack, one boundary, and the smallest change. |
| `ai/refactoring/auto_refactor.md` | Renaming structure while a behavior-preserving test stays green. A new module or dependency stops the refactor and becomes a feature. |
| `ai/observability/diagnostics.md` | Capturing the failing command and naming one root cause. |
| `ai/observability/self_healing.md` | Applying the smallest fix, adding a regression test, and recording the pattern. |
| `ai/memory/learning_system.md` | Promoting a repeated mistake into one memory rule. Stack-wide lessons move into the matching skill only when every future change in that stack should follow them. |

## Configuration

The files below are already set for this repository. Copy the same set into a target application, then point that app's `AGENTS.md` at its own build and test commands.

### Hosts

| Host | How it loads the contract | What else to keep |
| --- | --- | --- |
| Cursor | `AGENTS.md`, plus `.cursor/rules/orchestrator.mdc` (`alwaysApply: true`) | Glob rules, `rigorous-review.mdc`, `.cursor/hooks.json`, `.cursor/mcp.json` |
| Claude Code | `CLAUDE.md` imports `AGENTS.md` and indexes skills and subagents | `.claude/agents/`, `.claude/commands/`, `.claude/settings.json`, `.mcp.json` |
| Codex | Reads `AGENTS.md` and discovers `.agents/skills/` | Skills only; do not restate the contract |
| Copilot | `.github/copilot-instructions.md` points at `AGENTS.md` | `.github/instructions/`, `.github/agents/`, `.vscode/mcp.json` |
| Gemini CLI | `.gemini/settings.json` sets `context.fileName` to `AGENTS.md` | There is no `GEMINI.md` |
| Jules | Reads `AGENTS.md` | No extra adapter in this repo |
| Windsurf | Reads `AGENTS.md` | No extra adapter in this repo |

Cursor rules are path-scoped so a Kotlin file does not pull React rules:

| Rule | Applies |
| --- | --- |
| `.cursor/rules/orchestrator.mdc` | Every chat. One line: follow `AGENTS.md`. |
| `.cursor/rules/kotlin-spring.mdc` | `**/*.{kt,kts}` |
| `.cursor/rules/java.mdc` | `**/*.java` |
| `.cursor/rules/react.mdc` | `**/*.{tsx,jsx}` |
| `.cursor/rules/rigorous-review.mdc` | When you ask for a review. It is not `alwaysApply`, and it has no file glob. |

Copilot path instructions match those stacks: `.github/instructions/kotlin.instructions.md` (`**/*.kt,**/*.kts`), `java.instructions.md` (`**/*.java`), and `react.instructions.md` (`**/*.{tsx,jsx}`).

### MCP

Context7 and Playwright are enabled with no token, in three files because the hosts read different shapes:

| File | Key | Hosts |
| --- | --- | --- |
| `.cursor/mcp.json` | `mcpServers` | Cursor |
| `.mcp.json` | `mcpServers` | Claude Code and other hosts that read the repo MCP file |
| `.vscode/mcp.json` | `servers` | VS Code and Copilot |

Both servers are pinned. Do not switch them to `@latest`.

- Context7 is `npx -y @upstash/context7-mcp@4.1.1`. Use it for a current Spring, Gradle, React, or Jakarta API. Queries stay free of secrets and private source.
- Playwright is `npx -y @playwright/mcp@0.0.82`. Use it for a React flow a person can click through.

GitHub stays optional. `mcp/optional.github.json` calls `https://api.githubcopilot.com/mcp/` with `Authorization: Bearer ${env:GITHUB_PERSONAL_ACCESS_TOKEN}`. Enable it only after that variable is set in the environment:

1. Set `GITHUB_PERSONAL_ACCESS_TOKEN` in the environment. `.env.example` names the variable and ships with an empty value.
2. Merge the `github` server from `mcp/optional.github.json` into the MCP file your host reads.
3. Keep the token out of git. `.gitignore` ignores `.env` and `.env.*` except `.env.example`.

The validator rejects MCP files that contain a token-shaped string or `@latest`.

### RTK hooks

[Rust Token Killer](https://github.com/rtk-ai/rtk) compresses shell output before a model reads it.

| Host | Hook |
| --- | --- |
| Cursor | `.cursor/hooks.json` runs `.cursor/hooks/rtk-rewrite.ps1` on `preToolUse` for `Shell` and `Bash`. |
| Claude Code | `.claude/settings.json` runs `.claude/hooks/rtk-rewrite.ps1` on `PreToolUse` for `Bash`. |

Both hooks look for `rtk` on `PATH`, then at `%USERPROFILE%\.local\bin\rtk.exe`. Both pass the command through when the binary is missing.

The Cursor hook calls `rtk rewrite` and replaces only the command. It leaves the command unchanged when rewrite fails, when the result is not a single line, or when the command already starts with `rtk`. The Claude hook sends the payload to `rtk hook claude` and lets that binary speak Claude's hook protocol.

On failure, RTK prints a tee path. Store that path in `memory/cache.md` if you must remember the failure. Do not paste the log.

Manual forms when the hook does not run:

| Need | Command |
| --- | --- |
| git status, diff, log | `rtk git …` |
| tests | `rtk test <command>` |
| search | `rtk grep <pattern> <path>` |
| a file | `rtk read <file> -l aggressive` |
| a log | `rtk log <file>` |
| failures only | `rtk err <command>` |
| anything else | `rtk proxy <command>` |

`rtk gain` estimates bash-output savings as bytes/4. It is not the provider invoice. The procedure is `.agents/skills/token-economy/SKILL.md`.

### Memory files

Read these before coding. Leave them unchanged during an unrelated edit so provider prompt caches can reuse the prefix.

| File | What to put there |
| --- | --- |
| `memory/memory.md` | One durable rule per bullet. One sentence an agent can follow next time. |
| `memory/context.md` | Project name and stacks. |
| `memory/error_patterns.md` | A pattern, the rule, and the check that would have caught it. |
| `memory/cache.md` | One `key: value` fact per line. Replace a line when the fact changes. Under 40 lines. No secrets, source, or logs. |

### IntelliJ

The project name inside `.idea/` is `ai_autonomous_development` (`.idea/.name` and `.idea/ai_autonomous_development.iml`). Open the repository as that project.

### Boundaries

- Tokens stay in the environment.
- Context7 queries stay free of secrets and private source.
- Do not add a sample application to this repository.
- Do not add `GEMINI.md`, a parallel agent runner, or a second copy of the skills under `.claude/skills/`.
- `AGENTS.md` stays at or under 160 lines. Put procedures in skills.

## Commands

```powershell
powershell -File scripts/validate_framework.ps1
powershell -File scripts/run_delivery.ps1 -Task "<task>"
powershell -File scripts/run_delivery.ps1 -Task "<task>" -LogFile .\failure.log
powershell -File scripts/setup_rtk.ps1
powershell -File scripts/setup_rtk.ps1 -Apply
```

```bash
scripts/run_delivery.sh -Task "<task>"
scripts/run_delivery.sh -Task "<task>" -LogFile ./failure.log
```

## Layout

| Path | Role |
| --- | --- |
| `AGENTS.md` | Contract for every coding agent |
| `CLAUDE.md` | Claude routing: skill index and subagents |
| `README.md` | This guide |
| `docs/architecture.md` | Accepted decisions |
| `.gemini/settings.json` | Points Gemini CLI at `AGENTS.md` |
| `.cursor/rules/` | Cursor rules. Orchestrator always applies; stack rules are glob-scoped |
| `.cursor/hooks.json` | Cursor hook entry |
| `.cursor/hooks/rtk-rewrite.ps1` | Rewrites a shell command through RTK, or leaves it unchanged |
| `.claude/agents/` | Claude gates |
| `.claude/commands/` | `/deliver` and `/devin` |
| `.claude/settings.json` | Claude RTK hook |
| `.github/copilot-instructions.md` | Copilot pointer at the contract |
| `.github/instructions/` | Path-scoped Copilot instructions |
| `.github/agents/` | The same gates for Copilot |
| `.agents/skills/` | Procedures, loaded when the task matches |
| `ai/` | Ticket, refactor, diagnostics, self-healing, and learning checklists |
| `memory/` | Rules, context, error patterns, and the fact cache |
| `stacks/` | Templates to copy into a target application |
| `mcp/optional.github.json` | GitHub MCP snippet. Needs a token in the environment |
| `.env.example` | Names `GITHUB_PERSONAL_ACCESS_TOKEN`. Value stays empty |
| `scripts/validate_framework.ps1` | Fails when this framework drifts |
| `scripts/run_delivery.ps1` | Prints the ordered gates |
| `scripts/run_delivery.sh` | Same plan on bash |
| `scripts/setup_rtk.ps1` | Checks RTK and optionally runs `rtk init` |

## What validation checks

`powershell -File scripts/validate_framework.ps1` is the test command for this repository. It checks that:

- The contract, adapters, skills, agents, playbooks, memory files, stack templates, and scripts exist.
- Each skill's front matter `name` matches its directory and a `description` is set.
- `AGENTS.md` names Kotlin, Java, React, and `ai_autonomous_development`, stays within 160 lines, and does not require a model runner.
- MCP files pin Context7 `4.1.1` and Playwright `0.0.82`, contain no `@latest`, and contain no token-shaped strings.
- Removed files stay deleted, including `GEMINI.md`, `scripts/run_parallel_agents.sh`, and stack `AGENTS.md` files under `stacks/`.
- `scripts/run_delivery.sh` prints gates and does not launch a model.
- `memory/cache.md` stays within 40 lines.
- The Cursor RTK hook passes a command through, or returns one rewritten command. It does not wrap a command that already starts with `rtk`.

A passing run prints `Framework validation passed.`

## Project name

The name inside the repository is `ai_autonomous_development`. The folder on disk can remain `kotlin_ai_autonomous` while this workspace is open. Rename that directory after closing it if the path should match.

## License

No license file yet.
