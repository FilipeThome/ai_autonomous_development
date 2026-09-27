# Ticket processing

1. Restate the outcome and name the stack: Kotlin, Java, React, or a mix.
2. Find the existing boundary the change belongs to. Kotlin files stay in the Kotlin boundary.
3. If the ticket crosses modules or adds a dependency, stop for architecture approval.
4. Read the matching skill in `.agents/skills/` and implement the smallest change that satisfies the ticket.
5. Run that stack's tests.
6. Record a new error pattern in `memory/error_patterns.md` when the ticket exposed one.
