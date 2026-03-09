# Gate: Acceptance Tests

Every feature task must have at least one acceptance (e2e) test that exercises the
user-visible behaviour described in the task's AC. Prevents features from reaching
`cc:done` with only unit tests and no end-to-end verification.

**Enabled:** opt-in — add this gate when your project has an e2e test runner
(Playwright, Cypress, Detox, etc.) and feature tasks have user-visible outcomes
that can be driven through the UI or API boundary.

**Runs: remote** — the acceptance suite is too slow for local pre-`cc:done` use; runs in CI on push to main or PR open.

---

## What It Checks

When `/harness-work` reaches Step 8 (mark `cc:done`) for a **feature task**, it checks
whether at least one acceptance test file was created or modified in the same task:

- Acceptance test files are identified by path pattern: `e2e/`, `acceptance/`,
  `*.spec.ts`, `*.e2e.ts`, `*.feature` (Cucumber), or the pattern configured in
  the project's e2e runner config
- The test must reference the feature being delivered (matched by task number,
  AC keyword, or file path overlap with changed source files)

Non-feature tasks (bug fixes, chores, refactors, documentation) are **exempt** from
this gate. A task is treated as a feature task when its description does not begin with
`fix:`, `chore:`, `docs:`, or `refactor:`.

---

## Pass

At least one acceptance test file was added or modified in the same task, and the test
exercises the user-visible behaviour from the task's AC.

## Fail

`/harness-work` warns at Step 8 when a feature task completes with no acceptance test:

```
Acceptance gate: no e2e/acceptance test found for feature task N.X.
AC: <task AC>
Action: write at least one acceptance test before marking cc:done,
        or mark the task as non-feature with [no-e2e: <reason>].
```

---

## Skipping

Add `[no-e2e: <reason>]` to the task row to acknowledge the missing acceptance test.
Valid reasons: `no e2e runner configured`, `covered by existing e2e suite`, `internal only`.
