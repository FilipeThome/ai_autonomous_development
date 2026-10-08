# Language hazards

Read only the sections for languages in the diff. These are blockers unless a line says major. A hazard that does not apply to the diff is not a finding.

If the language has no section, review it with `CODE_REVIEW.md` and `SECURITY_REVIEW.md` only and say that under `Not claimed`.

## C and C++

- Undefined behavior, including signed overflow used as a bound, strict-aliasing violations, use after free, double free, and a missing return.
- A copy or an index whose length comes from outside the function and is not checked against the destination.
- An integer conversion that can truncate a size, a length, or an allocation count.
- A pointer, reference, or iterator that outlives the allocation, or that is used after the container mutates.
- A data race on a non-atomic object.
- A format string that is not a literal.
- A check on a path, a handle, or a permission that is repeated later without holding the resource the check covered.
- A bare `new`/`delete` or a manual lock in code that already uses RAII for that resource.

## Rust

- `unsafe` that widens into a safe API without stating the invariant that makes the safe API sound.
- `unwrap` or `expect` on a value from outside the module, or in a library path that already returns `Result`.
- A blocking call on an async runtime without a dedicated blocking boundary.
- A lock held across `.await`.
- `mem::forget` or `ManuallyDrop` on a guard that exists to uphold a safety or security invariant.

## Go

- An ignored error from I/O, parsing, cryptography, or authorization.
- `context.Background` or a detached context on a request path. The inbound context is the one that cancels the work.
- A goroutine with no cancellation and no bounded lifetime.
- A map or slice shared across goroutines without synchronization.
- An HTTP or RPC client with no timeout.
- An error compared by string when the package already uses wrapped errors.

## Java, Kotlin, and Scala

- A caught exception that is discarded, or a failure turned into a success value.
- Java serialization (`ObjectInputStream` or a registered gadget-friendly format) of untrusted bytes.
- A query, a path, or a command built by concatenating untrusted text.
- A new value type used in a hash collection whose equality and hash code disagree.
- A shared mutable static that holds request or security state.
- A closeable resource that can exit the scope without closing.
- Kotlin: `!!` on a value from outside the module, `runBlocking` on a request path, or `GlobalScope`.
- Scala: a `null` introduced as a domain signal, or `asInstanceOf` on untrusted input.

## C# and F#

- `async void` outside a UI event handler that the framework requires to be void.
- BinaryFormatter or another untrusted general deserializer.
- A caught exception that is discarded.
- A secret compared with ordinary string equality.
- A query or a command built by concatenating untrusted text.

## JavaScript and TypeScript

- `eval`, `new Function`, `innerHTML`, `document.write`, or a raw HTML sink fed by anything other than a constant the module owns.
- A recursive merge of untrusted JSON into an object that can change its prototype.
- `any`, or a cast, on a value that crossed a trust boundary.
- A promise whose failure is not handled on a path that must finish or report the error.
- `postMessage` without an origin check when the listener was added by the diff.
- `==` on an authentication decision, an identifier, or a permission.
- A regular expression built from untrusted input.

## Python

- `eval`, `exec`, `pickle`, `yaml.load`, or `subprocess` with `shell=True` on data from outside the module.
- `assert` as the only check on a security decision or on an invariant that must hold in production.
- `except Exception` or a bare `except` that discards the failure.
- A mutable default argument that shares state across calls when that state can affect a later request.
- A filesystem path joined with untrusted input and used without a jail.
- TLS verification disabled on a client the diff adds.

## Ruby

- `eval`, `send` or `public_send` with an untrusted name, `constantize` of user input, `YAML.unsafe_load`, or a shell string built from input.
- Mass assignment that can set a protected attribute from request parameters.

## PHP

- `unserialize` of untrusted data, `include` or `require` of a user-controlled path, or `extract` on request data.
- `==` on a secret, a hash, or an authentication decision where `===` is the comparison that does not coerce type.

## Swift

- A force unwrap or `try!` on input from outside the module.
- A URL session delegate or an App Transport Security exception that accepts any certificate.

## SQL

- Query text built by concatenation or interpolation of untrusted data.
- A column name, an order by, or another identifier taken from input without an allow-list.
- A new query that reads tenant- or owner-scoped data without that predicate.
- A migration that rewrites or locks a large table with no stated plan is a major.

## Shell

- An unquoted expansion, in a new script, of a variable that can contain spaces or glob characters.
- A download piped into a shell.
- A new Bash script that can fail in the middle and continue, because `set -euo pipefail` is absent.
- `rm`, `chmod`, or `chown` on a path taken from outside the script without checking it stays inside the intended directory.

## Terraform and other infrastructure code

- `0.0.0.0/0` or `::/0` on an administration port.
- A new store that is world-readable, or an identity policy with action `*` and principal `*`.
- A secret in plaintext in the diff.
- Encryption disabled on a new datastore.
