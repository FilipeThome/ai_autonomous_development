# Kotlin application template

Copy this file to the target application root as `AGENTS.md`. It is not a contract for ai_autonomous_development.

Kotlin in that application stays Kotlin.

## Build

```text
gradlew.bat test
./gradlew test
```

Run `detekt` or `ktlintCheck` when the Gradle task already exists.

## Layout

Follow the modules that already exist. When they are split, domain is pure Kotlin, application owns use cases and transactions, infrastructure owns persistence and clients, and api maps transport and status codes.

## Language

- Null safety. No `!!`. Platform types from Java are wrapped at the edge.
- Coroutines. No `runBlocking` on a request path. No `GlobalScope`. Tests use `runTest`.
- Constructor injection. No `lateinit` collaborators.

## Tests

JUnit 5 and MockK. Domain tests do not start Spring. A bug fix starts from a failing test.
