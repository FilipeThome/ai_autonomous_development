# Architecture

Status: accepted for ai_autonomous_development.

This repository is an agent operating system. It is not a sample Kotlin, Java, or React application.

## Decisions

1. `AGENTS.md` is the only full contract. Cursor, Codex, Copilot, Claude, Jules, and Windsurf read it. Gemini CLI is pointed at it from `.gemini/settings.json`.
2. `CLAUDE.md` and `.github/copilot-instructions.md` only route. Gemini CLI reads `AGENTS.md` via `.gemini/settings.json`. There is no `GEMINI.md`.
3. Path-specific conventions live in `.cursor/rules/*.mdc` and `.github/instructions/*.instructions.md`, so a Kotlin file does not pull React rules into context.
4. Procedures live in `.agents/skills/*/SKILL.md` (Agent Skills). Cursor, Codex, and Copilot discover that directory. Claude is routed there from `CLAUDE.md`. Skills are not copied into `.claude/skills/`, because Cursor would load both trees.
5. Subagents are one gate each. Implementation, tests, and review never run in parallel on the same change. The old parallel runner was removed for that reason.
6. Kotlin stays a primary stack next to Java and React. Adding a stack is not permission to rewrite an existing one.
7. MCP is for live systems, not for longer instructions. Context7 `@4.1.1` and Playwright `@0.0.82` are pinned. GitHub is an optional snippet that requires `GITHUB_PERSONAL_ACCESS_TOKEN`.
8. The workspace directory on disk may still be named `kotlin_ai_autonomous` while this session is open. The project identity inside the repo is `ai_autonomous_development`.

## Standards this follows

- [AGENTS.md](https://agents.md/) as the cross-tool repo contract, kept short, with commands and boundaries first
- [Agent Skills](https://agentskills.io/specification) for on-demand workflows
- Cursor rules for glob-scoped policy, and Cursor MCP project config
- Claude Code subagents under `.claude/agents/`
- Copilot custom agents under `.github/agents/*.agent.md` and path instructions under `.github/instructions/`
- Gemini CLI `context.fileName`

## What a target application copies

Copy the root contract, `memory/`, `.agents/skills/`, and the MCP files into the application. Copy `stacks/kotlin/AGENTS.template.md`, `stacks/java/AGENTS.template.md`, or `stacks/react/AGENTS.template.md` to that application's root and name it `AGENTS.md`. Those templates are not contracts while they still live under `stacks/`. In a monorepo, the nearest `AGENTS.md` wins.
