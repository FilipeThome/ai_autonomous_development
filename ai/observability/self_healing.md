# Self-healing

After a confirmed root cause:

1. Apply the smallest fix at the boundary that failed.
2. Add a regression test that failed before the fix.
3. Re-run that test and the original command.
4. Append the pattern to `memory/error_patterns.md`: pattern, rule, and the check that would have caught it.

Do not mark the incident done while the original command still fails.
