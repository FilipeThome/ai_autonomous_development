# Refactor

Refactor only while a behavior-preserving test is already green.

1. Name the smell: layer leak, null escape, blocking call, derived state stored in an effect, or a duplicated client cache.
2. Change structure without changing behavior. Do not port Kotlin to Java as a cleanup.
3. Re-run the same tests.
4. Stop if the refactor needs a new dependency or a new module. That is a feature and needs an architecture decision.
