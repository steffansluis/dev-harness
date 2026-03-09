---
name: harness-cycle
description: Runs the full development cycle for the next cc:TODO task: TDD loop (Red→Green→Refactor→Gate), structured review, and commit — handling fix iterations automatically. Use this whenever the user wants the full loop done end-to-end — 'do the full cycle', 'implement and review the next task', 'work and review', 'automate the work and commit', 'run through the development cycle', 'harness-cycle'. Trigger this as the primary day-to-day command any time the user wants a task implemented and committed without managing each step manually. Do not use for planning (use harness-plan) or isolated review only (use harness-review).
triggers:
  - harness-cycle
  - run the cycle
  - full cycle
  - work and review
  - do the full loop
  - cycle through
license: MIT
compatibility: Claude Code, Claude.ai
metadata:
  author: dev-harness
  version: 1.0.0
  category: productivity
  tags: [tdd, development, review, automation, cycle]
---

# harness-cycle

You execute the full development cycle for the next task: TDD loop → review → fix (if needed) → commit.
This is the primary day-to-day command. Follow these steps in order.

---

## Step 1: Find the Next Task

Read `plans/index.md` to identify the **current active phase**: the lowest-numbered phase that
still contains any `cc:WIP` or `cc:TODO` tasks. Read that phase file.

If 3+ tasks are `cc:WIP`, warn the user and stop — do not start a new task.

If no `cc:TODO` tasks remain in the active phase, print:
```
Phase N is complete. Run /harness-review for a phase-end review before starting Phase N+1.
```
and stop.

Find the next `cc:TODO` task (lowest task number). Mark it `cc:WIP` before starting.

State the task clearly:
1. Task number and description
2. Acceptance criterion
3. What you will build

---

## Step 2: TDD Loop

Execute the full Red → Green → Refactor → Gate loop for this task.

### Detect the Stack

Read `package.json`, `Gemfile`, `go.mod`, `Cargo.toml`, or `pyproject.toml` to determine the
lint and test commands. Use the same detection logic as harness-work:

- **Node/bun+jest:** always run `bun run test` (not `bun test`) to route through package.json
- **Ruby:** `bundle exec rspec` or `bundle exec rails test`; lint: `bundle exec rubocop --no-color`
- **Go:** `go test ./...`; lint: `golangci-lint run` or `go vet ./...`
- **Rust:** `cargo test`; lint: `cargo clippy -- -D warnings`
- **Python:** `pytest --cov` or `python -m unittest discover`; lint: `ruff check .` or `flake8`

### Red — Write a failing test

Write the test first. It must:
- Assert the behaviour described in the AC, not implementation details
- Live next to the source file
- Fail for the right reason (not a syntax error)

Run the test command. Confirm it fails.

### Green — Minimum implementation

Write the minimum code to make the test pass. No gold-plating.

Run the test command. Confirm it passes.

### Refactor — Clean up

Remove duplication, improve naming, extract constants. Do not change behaviour.

Run the test command again. Confirm it still passes.

### Gate — Lint + Tests

Run both:
```
<lint command>
<test command>
```

Both must pass with zero errors before continuing. Fix lint errors; do not suppress with
ignore comments unless genuinely justified (document why inline).

---

## Step 3: Review

Run a structured review of the changes made in Step 2. This mirrors the harness-review
workflow but is scoped to the current task's diff.

Get the diff:
```bash
git diff -- <files changed in this task>
```

Determine if the project has a user-facing UI (web/mobile) or not (CLI/API/library).

Review from up to 4 perspectives:

### Security
- SQL/command injection, XSS, credential exposure, input validation, path traversal, IDOR

### Performance
- N+1 queries, unnecessary recomputation, memory leaks, unbounded payloads, blocking I/O

### Quality
- Naming, single responsibility, error handling, test coverage gaps, cross-reference correctness,
  generated output added to `.gitignore`

### Accessibility (web/mobile only — skip for CLI/API)
- ARIA roles, keyboard navigation, alt text, colour contrast, touch target sizes

For each finding record: **Severity** (CRITICAL / IMPORTANT / MINOR / INFO), file + line, issue, fix.

Output the review table:

```
## Harness Review — Task N.X

**Outcome: APPROVE** or **Outcome: REQUEST_CHANGES**

### Security
| Severity | File | Finding | Fix |
|----------|------|---------|-----|

### Performance
| Severity | File | Finding | Fix |
|----------|------|---------|-----|

### Quality
| Severity | File | Finding | Fix |
|----------|------|---------|-----|
```

**Outcome rules:**
- **APPROVE** — zero CRITICAL or IMPORTANT findings
- **REQUEST_CHANGES** — one or more CRITICAL or IMPORTANT findings

---

## Step 4a: If APPROVE — Commit and Mark Done

Mark the task `cc:done` in the phase file.

Commit the changes:
```bash
git add <changed files>
git commit -m "<type>: <description>"
```

Print the cycle summary:
```
Cycle complete — Task N.X
TDD:    Red → Green → Refactor → Gate ✓
Review: APPROVE
Commit: <commit hash>
AC verified: <restate the AC>
```

---

## Step 4b: If REQUEST_CHANGES — Fix and Re-review

List the CRITICAL/IMPORTANT findings clearly. Fix each one:

1. Apply the fix
2. Re-run the gate (lint + tests) — confirm both still pass
3. Re-run the review (Step 3) on the full diff

Repeat until the review produces APPROVE. Then proceed to Step 4a.

**Maximum iterations:** If after 3 fix attempts the review still returns REQUEST_CHANGES,
stop and report:
```
Cycle blocked — 3 fix iterations completed without reaching APPROVE.
Remaining issues:
  [list findings]
Run /harness-review manually after addressing these issues.
```

---

## Examples

### Example 1: Happy path

User says: "harness-cycle"

Actions:
1. Read `plans/index.md` → find Phase 3 active → next `cc:TODO` is task 3.2 → mark `cc:WIP`
2. Detect stack: Node + bun + jest → `bun run test`, `bun run lint`
3. Write failing test for task 3.2's AC → run → red ✓
4. Write implementation → run → green ✓
5. Refactor → run → green ✓
6. Gate: `bun run lint` ✓, `bun run test` ✓
7. Review diff → no CRITICAL/IMPORTANT findings → APPROVE
8. Mark 3.2 `cc:done`, commit, print summary

Result: Task 3.2 moves from `cc:WIP` to `cc:done` with a commit. User sees the full cycle summary.

---

### Example 2: Review requests changes

User says: "harness-cycle"

Actions:
1–6: Same as Example 1 (TDD + Gate pass)
7. Review diff → finds IMPORTANT: missing input validation in `createUser`
8. Output: REQUEST_CHANGES with the finding
9. Fix: add validation, re-run gate (passes)
10. Re-review → no findings → APPROVE
11. Mark `cc:done`, commit

Result: Task completes after one fix iteration. User sees the fix was caught and addressed before commit.

---

## Notes

- This skill orchestrates harness-work and harness-review in a single loop. For isolated
  use cases (work-only or review-only), use `/harness-work` or `/harness-review` directly.
- The review in Step 3 is task-scoped (this task's diff only), not a full phase-end review.
  Run `/harness-review` at the end of a phase for the broader multi-commit review.
- Commit messages follow the same conventions as harness-review: `<type>: <description>`
  where type is `feat`, `fix`, `refactor`, `test`, `docs`, or `chore`.
