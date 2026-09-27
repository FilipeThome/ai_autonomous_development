---
applyTo: "**/*.kt,**/*.kts"
---

# Kotlin

Follow `stacks/kotlin/AGENTS.template.md` and `.agents/skills/kotlin-spring/SKILL.md`.

- Keep this code in Kotlin.
- Constructor injection. No `!!`. No `runBlocking` on a request path. No `GlobalScope`.
- Domain code does not import Spring.
- Test behavior with JUnit 5, MockK, and `runTest`.
