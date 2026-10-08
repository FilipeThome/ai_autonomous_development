---
name: architecture-review
description: Reviews a design and returns approval or required changes before cross-module implementation. Use when adding a feature, a dependency, a module, or a new boundary in Kotlin, Java, or React.
disable-model-invocation: true
---

# Architecture review

Read memory and the stack playbook. Do not edit application code in this gate.

## Approve only when all are true

- The change fits the current module boundaries, or the new boundary is explicit.
- Kotlin modules stay Kotlin unless the user asked to port them.
- Domain code stays free of framework types when the app is already split that way.
- The new dependency has a caller and no duplicate of an existing library.
- The test boundary is named (unit, slice, or UI).

## Reply in this shape

```text
Decision: approved | changes required
Stack: kotlin | java | react | mixed
Boundaries: which modules may change
Data flow: who calls whom
Unchanged: what this change must not rewrite
Risk: one concrete risk and how the test will catch it
```

If the boundary is unclear, the decision is `changes required`. Do not invent a module layout the repository does not already use.
