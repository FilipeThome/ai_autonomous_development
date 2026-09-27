# ai_autonomous_development

Model-neutral engineering system for Kotlin, Java, and React. Cursor, Claude, Codex, Copilot, Gemini, and Jules follow this file. Adapter files must not restate it.

## Before coding

Read `memory/memory.md`, `memory/context.md`, `memory/error_patterns.md`, and `memory/cache.md`.

## Orchestration

1. Classify the task: question, small fix, feature, or incident.
2. Large work needs an architecture decision before code. Large work is a new module, a public API, persistence, security, or a cross-stack change.
3. A small fix inside an existing boundary does not need a new design.
4. An incident with a log runs diagnostics before the implementer.
5. One implementer writes the change. Kotlin stays Kotlin unless the user asks for a port.
6. Run the real test command. Review only after it passes.
7. Stop when the reviewer accepts. Stop and re-plan when the boundary is unclear.
8. When a mistake should not recur, add one rule to memory.

Gates are sequential.

## Stacks

Kotlin, Java, and React are first-class. Copy a template to the target application root as `AGENTS.md`:

- `stacks/kotlin/AGENTS.template.md`
- `stacks/java/AGENTS.template.md`
- `stacks/react/AGENTS.template.md`

Those templates are not contracts for this repository. Build and test commands live there.

## Definition of done

- The change compiles
- The real test command passes
- Architecture is clean
- Memory rules hold
- The reviewer accepts

## Commands

```powershell
powershell -File scripts/validate_framework.ps1
powershell -File scripts/run_delivery.ps1 -Task "<task>"
```

`scripts/run_delivery.sh -Task "<task>"` prints the same gates. Add `-LogFile` when the task starts from a log. Both scripts print the plan. They do not launch a model.

## Models

Use the host's selected model. Do not hardcode a vendor. Use the host's strongest model for architecture and review.

## Token spend

Read `memory/cache.md` before scanning the repo or repeating a command. When `rtk` is on PATH, shell output goes through RTK. The Cursor hook rewrites those commands and leaves them unchanged when RTK is absent. Keep this file and `memory/` stable so prompt caches can hit. Do not paste logs or secrets into memory.

## Boundaries

- No secrets in git. Tokens stay in the environment.
- Context7 queries stay free of secrets and private source.
- Do not add a sample application to this repository.
- The decision record is `docs/architecture.md`.
