# Error Patterns

## Validation

- Pattern: premature completion
- Rule: enforce validation loop

## Architecture

- Pattern: implementing without design
- Rule: require architect approval

## Testing

- Pattern: missing tests
- Rule: tests are mandatory

## Kotlin

- Pattern: `!!`, request-path `runBlocking`, or `GlobalScope`
- Rule: encode absence in the type and keep coroutines structured

## Stack rewrite

- Pattern: porting Kotlin to Java while adding Java or React support
- Rule: leave Kotlin modules in Kotlin unless the user asks for a port

## Two writers

- Pattern: the test gate edits production code
- Rule: return the failure to the stack engineer

## Fan-out

- Pattern: implementing, testing, and reviewing the same change in parallel
- Rule: sequential gates

## Token spend

- Pattern: pasting a full log or repeating a scan already stored in `memory/cache.md`
- Rule: keep one fact in the cache and compress shell output with RTK

## Instructions

- Pattern: copying the full policy into every tool file
- Rule: one contract in AGENTS.md, thin adapters, procedures in skills
