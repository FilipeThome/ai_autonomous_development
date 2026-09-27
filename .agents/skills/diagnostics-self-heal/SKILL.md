---
name: diagnostics-self-heal
description: Finds the root cause of a failing command, stack trace, or log, applies the smallest fix, and adds a regression test. Use when CI is red, a command failed, or the user pastes a log.
---

# Diagnostics and self-healing

## Find the cause

1. Record the exact command and the first error line.
2. Walk to the first frame that explains the failure. Ignore wrapper frames that only rethrow.
3. State one cause. If you have two, the diagnosis is not done.

## Fix

1. Change the boundary that produced the bad state. Do not patch the symptom in a caller and leave the producer broken.
2. Add a regression test that fails for that cause and passes after the fix.
3. Re-run the original command. Quote its result.
4. Append one entry to `memory/error_patterns.md`: the pattern, the rule, and the check that would have caught it.

Do not declare the incident finished while the original command is still failing.
