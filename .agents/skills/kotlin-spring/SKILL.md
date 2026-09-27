---
name: kotlin-spring
description: Implements Kotlin and Spring Boot with null safety, structured concurrency, and Gradle. Use when the task touches Kotlin, Gradle Kotlin DSL, coroutines, MockK, Spring Kotlin, or when the user mentions Kotlin.
---

# Kotlin and Spring Boot

Shared JVM boundaries: [REFERENCE.md](../jvm-clean-architecture/REFERENCE.md).

Kotlin stays Kotlin. Do not port a module to Java unless the user asks. You are the only writer for this task.

## Build

Use the Gradle Kotlin DSL build that is already present. Run `gradlew.bat test` or `./gradlew test`, and `detekt` or `ktlintCheck` when that task already exists. Do not add a linter during an unrelated change.

Query Context7 for a Spring, coroutine, or Gradle API you are not sure of. Do not send secrets or private source. Do not invent the current signature.

## Language

- `val` unless the binding truly changes.
- Constructor injection. Collaborators are constructor `val`s. No field injection. No `lateinit` for collaborators.
- Model absence in the type. `!!` is a defect.
- At Java boundaries, wrap platform types so nullability is explicit.
- Domain failures are sealed types. Only `api` maps them to HTTP.
- Prefer `internal` for types that are not a supported API.
- Request and response types are data classes or value types, not JavaBeans.
- If JSON binding fails for Kotlin types, add `jackson-module-kotlin` only when it is missing.

```kotlin
fun requireEmail(value: String?): String =
    value?.takeIf { it.contains('@') } ?: throw BadRequestException("email is required")
```

## Coroutines

- Non-blocking I/O is `suspend`.
- If the module is still servlet-style, do not add `runBlocking` to make it look asynchronous.
- Do not add `runBlocking` on a request path.
- Do not use `GlobalScope`.
- Child work uses `coroutineScope` or `supervisorScope`.
- Tests use JUnit 5, MockK, and `runTest`.

Kotlin Multiplatform is out of scope unless a `kotlin.multiplatform` block already exists. If it does, keep common code free of JVM-only APIs.
