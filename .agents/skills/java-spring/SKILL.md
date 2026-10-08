---
name: java-spring
description: Implements Java and Spring Boot with constructor injection, records, and the build the repo already uses. Use when the task touches Java, Maven, Spring Java, JUnit, or when the user mentions Java.
disable-model-invocation: true
---

# Java and Spring Boot

Shared JVM boundaries: [REFERENCE.md](../jvm-clean-architecture/REFERENCE.md).

Do not rewrite a neighboring Kotlin module into Java. You are the only writer for this task.

## Build

Use the build file that is already present (`pom.xml` or Gradle). Run `mvn -q test` or the Gradle test task. Run a formatter or Checkstyle task only when the build already defines it.

Query Context7 for a Spring or Jakarta API you are not sure of. Do not send secrets or private source.

## Language

- Target the Java version the build already sets. When nothing is set, use Java 21.
- Constructor injection. Do not annotate fields with `@Autowired`.
- Prefer records for request and response DTOs. Do not add a mutable bean with the same shape.
- Do not store `Optional` in fields.
- Failures the domain understands are typed. Do not throw a bare `RuntimeException` from deep in the domain.
- Tests use JUnit 5. Use AssertJ when it is already a dependency. Use Testcontainers only when the project already uses them and the test needs a real dependency.
