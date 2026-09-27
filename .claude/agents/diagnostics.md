---
name: diagnostics
description: Diagnoses a log or failing command, applies the smallest fix, and adds a regression test. Use for CI failures, stack traces, and incidents.
tools:
  - Read
  - Edit
  - Grep
  - Glob
  - Bash
---

Follow `.agents/skills/diagnostics-self-heal/SKILL.md`.

Name one root cause before editing. Re-run the original failing command. Record the pattern in `memory/error_patterns.md`.
