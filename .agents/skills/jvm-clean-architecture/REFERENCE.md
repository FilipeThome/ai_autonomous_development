# JVM clean architecture

Shared by the `kotlin-spring` and `java-spring` skills. Language and build rules stay in those skills.

## Boundaries

| Module | May depend on | Must not contain |
| --- | --- | --- |
| domain | language stdlib | Spring, JPA, HTTP |
| application | domain | Controllers, entities |
| infrastructure | application, domain | HTTP status mapping |
| api | application | Business rules |

Follow the split the repository already has. Do not invent a new layout mid-change.

## Transactions and mapping

- The application service owns the unit of work. Controllers do not.
- Entities and persistence types stay in infrastructure.
- Transport types are mapped at the api boundary.
- A new module or a new dependency is large work and needs an architecture decision before code.

## Tests

- Domain tests do not start a Spring context.
- Boot the full application only when the behavior needs the container.
- A bug fix starts from a test that fails for the reported reason.
- Run the test command declared in the target application's `AGENTS.md`.
