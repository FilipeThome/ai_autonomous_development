---
applyTo: "**/*.java"
---

# Java

Follow `stacks/java/AGENTS.template.md` and `.agents/skills/java-spring/SKILL.md`.

- Constructor injection. No field `@Autowired`.
- Do not rewrite a neighboring Kotlin module into Java.
- Map transport types at the boundary. Keep Spring out of domain types when the module is split that way.
- Test with JUnit 5. Use AssertJ when it is already on the classpath.
