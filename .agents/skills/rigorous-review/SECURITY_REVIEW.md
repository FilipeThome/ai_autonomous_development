# Security review

Use the same method as [CODE_REVIEW.md](CODE_REVIEW.md): read the applicable lines first, fail the stage on any blocker or major, and do not report nits.

This stage is engineering security. It is not a legal or compliance sign-off.

A control the type system or the API can make mandatory is mandatory. A comment, a convention, or a hidden UI path is not a control.

## Changed trust boundary

List every boundary the diff adds or changes: user input, another service, a queue, a file, a database row another tenant can influence, a parser, a subprocess, a deserialize step, a secret, a cryptographic operation, an authorization decision, or a new dependency.

For each boundary, name the STRIDE threats that apply and the control that addresses each one:

- Spoofing: the actor is authenticated at the enforcement point.
- Tampering: integrity is checked, or the write is authorized and validated.
- Repudiation: a security-sensitive action has an audit event that does not contain the secret.
- Information disclosure: the response, log, and error expose only what that actor may see.
- Denial of service: size, count, depth, time, and fan-out from untrusted input are bounded.
- Elevation of privilege: the server decides authority. The client cannot choose its role, owner, or tenant.

A changed boundary with no named threat and no control fails the stage.

If nothing above changed, write `none — no changed trust boundary` only after you have checked the diff for a weakened control: a removed check, a broader allow-list, disabled verification, a logged secret, a loosened permission, or a dependency bump that drops a pin or pulls a new install script.

## Data flow

For each untrusted value, name the sink it reaches: query, command, HTML, path, redirect, deserializer, outbound request, log, or authorization decision.

An untrusted value that reaches a sink without a control at the boundary is a blocker. A constant that never leaves the module is not untrusted. Say which one you traced.

## Fail closed

Missing authentication, missing authorization, a parse failure, an unknown type, or a failed dependency denies the action. A default of allow, a fallback to a privileged identity, or an empty catch on a security check is a blocker.

## Controls

Apply only the controls the diff touches. A missing primary control is a blocker. Extra defense in depth, when the primary control is present, is not a finding.

### Authentication and session

- Credentials are not in source, logs, URLs, or tickets.
- A password is stored with a password hash (argon2id, scrypt, or bcrypt), not a fast hash.
- Login creates a new session. Logout invalidates server-side session state.
- A session cookie set by the diff is `Secure` and `HttpOnly`, with an explicit `SameSite` choice.

### Access control

- Every new read and write checks the actor on the server. An identifier in the request is not authority.
- Deny is the default. A new route that omits the check used by its neighbours is a blocker.
- The client cannot set a privilege, owner, tenant, or price field the server should own.
- A check-then-act authorization decision is atomic with the action, or a race is a blocker.

### Input and injection

- Queries use parameters. Identifiers such as column or sort field come from an allow-list.
- A process is started from an argument array. A shell string built from input is a blocker.
- A path is canonicalized and kept inside a jail. A redirect or an outbound URL uses an allow-list.
- HTML and related sinks encode for the context. A raw HTML sink of untrusted data is a blocker.
- Untrusted deserialization of a general object graph is a blocker. A typed format with an allow-list is the replacement.
- A user-controlled URL cannot reach link-local, loopback, or private addresses unless an allow-list says so.
- Untrusted input does not select a regular expression with nested quantifiers.

### Cryptography

- No new primitive, mode, or protocol invented in the diff. No ECB. No MD5 or SHA-1 as a security mechanism. No static IV. No hardcoded key.
- Confidentiality that also needs integrity uses an authenticated encryption mode.
- A secret comparison does not return on the first differing byte.
- A new network channel verifies TLS. Disabling verification is a blocker.

### Secrets and personal data

- The diff contains no secret, token, or private key.
- Logs, errors, and traces do not contain secrets or raw credentials.
- A new field that returns or stores personal data is required by the feature. Returning a broader record than the caller needs is a major.

### Files and parsers

- An upload has a size limit, is not executed, and is not stored where the server will interpret it as code.
- A parser of untrusted input bounds recursion, size, and element count.

### Dependencies and configuration

- A new dependency has a caller and a pinned version. An install or postinstall script is a blocker unless the change states why it is required and what it runs.
- A security-sensitive library bump names the advisory or the behavior that changed. A silent bump is a major.
- Defaults that ship in the diff are safe: authentication on, debug off, CORS not reflective of any origin, no public admin listener.

### Business logic

- A limit, quota, price, or permission is enforced on the server and survives a repeated or reordered call.
- A client-supplied step, status, or amount that skips an intermediate state is a blocker.

## Tests

A new or changed security control has a test that the forbidden action is rejected. Missing that test is a blocker when the repository has a test suite. A repository with no test suite still fails the control itself; record the missing test as a major only when there is no suite to add it to, and say that under `Not claimed`.

## Sources

These rules are the working form of Microsoft's SDL (threat model on new attack surface, banned weak crypto, fail closed), STRIDE, Shostack's *Threat Modeling*, OWASP ASVS as the control bar, the OWASP Top 10 and API Security Top 10 as the minimum scan rather than the bar, the CWE/SANS Top 25, *Building Secure and Reliable Systems* (least privilege, small trusted computing base, safe defaults), *Secure by Design* (invalid and unauthorized states are hard to represent), and Latacora's *Cryptographic Right Answers* (use a standard construction, authenticate ciphertext, compare secrets in constant time).
