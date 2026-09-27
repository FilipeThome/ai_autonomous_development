@AGENTS.md

## Skills

Discovered from `.agents/skills/`. This index is name and when, not the procedure.

| Name | When |
| --- | --- |
| `kotlin-spring` | Kotlin, Gradle Kotlin DSL, coroutines, Spring Kotlin |
| `java-spring` | Java, Maven or Gradle, Spring Java |
| `react-frontend` | React, JSX, TSX, hooks |
| `architecture-review` | Large work, before code |
| `autonomous-delivery` | A ticket, the test gate, or the review gate |
| `diagnostics-self-heal` | A log or a failing command |
| `token-economy` | Shell output, repeated scans, cache, memory, or RTK |

## Subagents

Delegate one gate in `.claude/agents/`. One implementer writes.

| Gate | Agent |
| --- | --- |
| Architecture, before code on large work | `architect` |
| Kotlin | `kotlin-engineer` |
| Java | `java-engineer` |
| React | `react-engineer` |
| Tests | `test-engineer` |
| Review | `reviewer` |
| Incident, before the implementer | `diagnostics` |

MCP servers for this repo are in `.mcp.json`.
