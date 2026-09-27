# Java application template

Copy this file to the target application root as `AGENTS.md`. It is not a contract for ai_autonomous_development.

Do not convert Kotlin sources that live beside this application.

## Build

Use the file that exists:

```text
mvn -q test
gradlew.bat test
./gradlew test
```

## Layout

Follow the packages that already exist. Controllers translate HTTP. Services own transactions. Persistence types stay in the persistence adapter.

## Language

- Java version from the build file. Default to 21 only when the build has not chosen.
- Constructor injection. No field `@Autowired`.
- Records for DTOs.
- JUnit 5. AssertJ when it is already on the classpath.

A new module, public API, persistence change, security change, or cross-stack change needs an architecture decision before code.
