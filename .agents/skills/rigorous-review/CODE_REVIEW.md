# Code review

Apply every section the diff can trigger. When a section cannot apply, say so under `Not claimed`.

Severity:

- **Blocker**: wrong behavior, broken invariant, data loss, swallowed failure, missing test for new behavior, or a public name that lies.
- **Major**: the design will spread complexity, an unrelated refactor hides the behavior, a new failure is invisible in production, or a public contract can break callers.
- **Nit**: do not report.

## Intent

- One sentence describes the behavior change.
- A behavior change mixed with an unrelated refactor is a major. It is a blocker when the mix hides the behavior a test would need to pin.
- Dead code, commented-out code, and debug output added by the diff are blockers.

## Design

Prefer a deep module: a small interface that hides the complexity behind it. A new wrapper that adds a name and no policy is a major.

- The change sits on a boundary the repository already has. A new boundary is explicit in the change, or it is a major.
- Knowledge that must stay in sync lives in one place. Duplicated text that will not change together is not a finding.
- The general case got simpler or stayed as simple. A new special case piled onto an open-coded chain of conditions is a major.
- An invariant the type system can express is encoded in the type. A comment is not the enforcement mechanism.
- Pull complexity toward the implementation. Do not push a new mode flag through every caller when one module can decide.

## Correctness

Trace the happy path and each new branch.

- Empty, zero, maximum, duplicate, and absent inputs that the type still allows have a defined result.
- Values are initialized before use. Bounds and integer conversions cannot truncate a size, a count, or an index taken from outside the module.
- Every state the change introduces has a next step, including failure. A partial update leaves a named state, not a half-applied invariant.
- Ordering, retries, and time are explicit. A retried write is idempotent, or the caller cannot retry it.
- Concurrency: shared mutable state has an owner. A check-then-act sequence states what makes it atomic.
- A comparison or a sort key matches the equality the type claims.

## Errors

- A failure is returned or raised to a caller that handles it. An empty catch, a logged-and-ignored error, or a default success on failure is a blocker.
- The error carries the context an operator needs and does not carry a secret.
- A new call to another process, service, or disk has a timeout. A retry is bounded and backed off. An unbounded retry or an unbounded queue is a blocker.
- Destroy the error only at a boundary that turns it into a user-visible result or an operational signal.

## Tests

- New behavior has a test that fails when that behavior is removed. Asserting only that no exception was thrown is a blocker unless that is the contract.
- A bug fix includes a test that fails for the reported reason.
- Changing untested code: pin the current behavior you are about to change, or the change is a blocker.
- The test names the outcome. A weakened, deleted, or skipped assertion is a blocker.
- Sleep, wall-clock races, and order-dependent tests are blockers.
- A security-sensitive denial added in the diff is tested in the security stage.

## API and stored data

Apply when a signature, a persisted schema, an event, or a wire contract changes.

- A break of an existing caller or consumer is versioned or migrated in the same change. A silent break is a blocker.
- A stored or replicated schema expands before it removes. The interim state is valid.
- A migration that can lose or rewrite data states what is irreversible. Omitting that is a major. Losing data without a stated migration is a blocker.
- A write that another system may replay has an idempotency key or a natural unique constraint.

## Operability

- A new failure path is visible from logs or metrics without dumping a payload or a secret.
- A change that can stick in production has a rollback or a flag. Missing that on a risky path is a major.
- No new path retains unbounded memory, tasks, or connections.
- An operator can tell success from failure without a debugger.

## Names and comments

- A name that states the wrong unit, polarity, or scope is a blocker.
- A new public name that forces a reader to open the body is a major.
- A comment that restates the next line is not required. A comment that explains a non-obvious invariant the code cannot express is required; its absence is a major when a wrong edit would look locally fine.
- A comment that disagrees with the code is a blocker.

## Sources

These rules are the working form of Google's code-review standard (design, functionality, complexity, tests, naming, comments, consistency, documentation; read the change; the diff stands alone), *Software Engineering at Google*, Ousterhout's *A Philosophy of Software Design* (deep modules, complexity, define errors out of existence), McConnell's *Code Complete* (defensive checks at boundaries, initialization, control flow), Fowler's *Refactoring* (keep behavior changes separate from structure changes), Feathers's *Working Effectively with Legacy Code* (pin behavior, introduce a seam), Kernighan and Pike's *The Practice of Programming* (clarity and simplicity), Hunt and Thomas's *The Pragmatic Programmer* (one source of knowledge, fail fast), Nygard's *Release It!* and Google's SRE guidance (timeouts, bounded retries, operable failure), and Kleppmann's *Designing Data-Intensive Applications* (compatibility and idempotency of stored or replicated state).

Style preference that a style guide leaves open is not a finding. That is the same limit Google uses. It is not permission to waive a blocker or a major.
