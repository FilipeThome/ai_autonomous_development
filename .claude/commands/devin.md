@CLAUDE.md
@memory/memory.md
@memory/context.md
@memory/error_patterns.md

MANDATORY EXECUTION:

1. Read memory + patterns
2. Reject any violating solution
3. Classify task complexity
4. If large → Architect approval REQUIRED before implementation

5. Execute agents:
   Architect → Backend → Test → Reviewer

6. If logs detected:
   run diagnostics → self-healing

7. QUALITY LOOP:
   Repeat until:
   - tests pass
   - architecture approved
   - no violations
   - no improvements remain

8. FAIL-FAST:
   If uncertain → STOP and re-plan

9. MEMORY UPDATE:
   store mistake + fix + rule