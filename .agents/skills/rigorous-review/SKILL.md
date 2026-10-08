---
name: rigorous-review
description: Reviews a change in any language against a strict code-review bar and a separate, equally strict security-review stage. Use when the user asks for a code review, security review, PR review, diff review, revisão de código, or revisão de segurança.
disable-model-invocation: true
---

# Rigorous review

Review only. Do not edit the change under review.

This skill applies to every language. Repository memory and stack skills still apply. A pass here does not waive them, and it does not replace a green test run.

A blocker or a major fails the stage. A nit does not. Leave unreported any style a formatter or the repository style guide already owns. Do not pass a stage that still has a major because the change is an improvement. Judge correctness, design, tests, operability, and security.

## Method

Use this method for both stages:

1. Read every line of application, test, configuration, and infrastructure code in the diff before writing a finding. For a lockfile, review which dependencies changed and why, not every checksum.
2. State the intended behavior in one sentence. If you cannot, the stage fails.
3. If you cannot account for every new branch and every new public function, stop. `Verdict: reject` with the reason `not reviewable`, and name a split that would make the change reviewable.
4. Write a finding only when you can point at a location, a rule in the stage file, why it fails, and the required change.
5. Do not claim a defect you did not trace. Put an unverified suspicion under `Not claimed`.

## Stages

Run both, in order. Do not skip security because the change looks safe.

1. Code review. Read [CODE_REVIEW.md](CODE_REVIEW.md). Read [LANGUAGE_HAZARDS.md](LANGUAGE_HAZARDS.md) only for languages present in the diff. A language with no section there is reviewed with the two stage files only.
2. Security review. Read [SECURITY_REVIEW.md](SECURITY_REVIEW.md). Same method, same severities, same finding shape.

## Verdict

- `Code review: pass` only when that stage has no blocker and no major.
- `Security review: pass` only when every changed trust boundary has a named threat and a control, no security blocker or major remains, and the diff does not weaken an existing control.
- `Verdict: accept` only when both stages pass.
- Otherwise `Verdict: reject`. The verdict is the worse stage.

A fail with no finding is invalid. Either name the finding or reject as `not reviewable`.

## Finding

`path:line — blocker | major — rule — why it fails — required change`

Comment on the code, not the author. Do not demand a rewrite into a different framework.

## Reply

```text
Code review: pass | fail
Security review: pass | fail
Verdict: accept | reject

Intent: <one sentence, or "unclear">

Blockers:
- path:line — blocker — rule — why it fails — required change

Majors:
- path:line — major — rule — why it fails — required change

Attack surface:
- <boundary> — <threat> — <control, or missing>

Not claimed:
- <what this review did not see>
```

Omit an empty `Blockers` or `Majors` section. `Attack surface` is required. Use `none` only after the security stage checked that no existing control was weakened.
