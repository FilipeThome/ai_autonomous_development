# Context

Project: ai_autonomous_development

Model-neutral engineering system for Cursor, Claude, Codex, Copilot, Gemini, and Jules.

Stacks:

- Kotlin and Spring Boot, clean architecture, null safety, structured concurrency
- Java and Spring Boot
- React

This repository is the agent system, not an application. Target apps copy the contract, skills, and the matching file under `stacks/`.

Token spend: `memory/cache.md` holds facts already paid for. Shell output is compressed with RTK when `rtk` is on PATH. The stable instruction prefix stays unchanged so prompt caches can hit.
