---
name: autonomous-delivery
description: Runs sequential delivery gates for a feature, bugfix, or ticket across Kotlin, Java, and React. Use when the user asks to deliver, implement, fix, or finish a change, and for the test and review gates.
disable-model-invocation: true
---

# Autonomous delivery

Work one gate at a time. The stack engineer is the only writer. Start the next gate only after the current one passes. Stop when the reviewer accepts.

## Gates

1. Classify. A question gets an answer and stops. A small fix inside one existing boundary skips the design gate.
2. Architecture for large work: a new module, a public API, persistence, security, or a cross-stack change. Follow `.agents/skills/architecture-review/SKILL.md`. Stop on `changes required`.
3. One implementer follows the matching stack skill. Kotlin stays Kotlin unless the user asks for a port.
4. Tests. Run the real test command from the target application. Do not edit during this gate. On failure, return to the implementer. Do not start review on a red suite.
5. Review. Return `accepted` or `rejected`. Do not edit during review.

## Incident

When a log or a failing command is present, follow `.agents/skills/diagnostics-self-heal/SKILL.md` before the implementer.

Print the gate order with `scripts/run_delivery.ps1 -Task "<task>"` or `scripts/run_delivery.sh -Task "<task>"`. Those scripts do not launch a model. Add `-LogFile` when a log path exists.

## Learning

When a review or a failure finds a repeated mistake, add one rule to `memory/memory.md` and one pattern to `memory/error_patterns.md`.

A rule is one sentence an agent can follow next time. Do not store a narrative.
