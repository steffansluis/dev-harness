---
name: harness-work
description: Execute the next plans/ task using the TDD loop. Stack-aware: detects test runner, lint command, and package manager automatically.
triggers:
  - implement
  - execute task
  - harness-work
  - do the work
  - next task
  - build this
  - work on
---

# harness-work

You execute tasks from the `plans/` directory using a strict TDD loop. Follow these steps in order.

---

## Step 1: Read the plans/ directory

Read `plans/index.md` to identify the **current active phase**: the lowest-numbered phase that
still contains any `cc:WIP` or `cc:TODO` tasks. Read that phase file (e.g. `plans/phase-1.md`).

Find the next `cc:TODO` task (lowest task number in the active phase file).
Mark it `cc:WIP` in the phase file (e.g. `plans/phase-1.md`) before starting any implementation.

**Co-existence:** If both `plans/index.md` and a flat `Plans.md` exist, always prefer `plans/`.
Do not read from or write to the flat `Plans.md`.

If 3+ tasks are already `cc:WIP`, warn the user and do not start a new one.

---

## Step 2: Detect the Stack

Read `skills/harness-work/references/stack-detection.md` for the full detection algorithm.

Summary:

**Node / TypeScript / JavaScript:**
- Read `package.json`
- `packageManager` field → `bun` / `npm` / `yarn` / `pnpm`
- `scripts.test` → the test command (e.g. `jest`, `vitest run`)
- `scripts.lint` → the lint command
- **CRITICAL (bun+jest):** If `packageManager` contains `bun` AND `scripts.test` invokes `jest`,
  always run `bun run test` (not `bun test`). Bun's native test runner cannot parse
  react-native's Flow `import typeof` syntax. The `bun run` prefix routes through the
  package.json script → jest, which handles it correctly.
- Check `dependencies`/`devDependencies` for `expo`, `react-native`, `next`, `vite`

**Ruby:**
- Read `Gemfile`
- `gem 'rspec-rails'` → `bundle exec rspec`
- Otherwise → `bundle exec rails test` or `ruby -Itest test/**/*_test.rb`
- Lint: `bundle exec rubocop --no-color`

**Go:**
- Read `go.mod`
- Test: `go test ./...`
- Lint: `golangci-lint run` (if `.golangci.yml` exists) else `go vet ./...`

**Rust:**
- Read `Cargo.toml`
- Test: `cargo test`
- Lint: `cargo clippy -- -D warnings`

**Python:**
- Read `pyproject.toml` or `requirements.txt`
- `pytest` in deps → `pytest --cov`
- Otherwise → `python -m unittest discover`
- Lint: `ruff check .` (if `ruff` in deps) else `flake8`

Record: **lint command** and **test command**.

---

## Step 3: State the Task Clearly

Before writing any code, state:
1. The task number and description from the active `plans/phase-N.md`
2. The acceptance criterion
3. The test file you will create first
4. What the failing test will assert

---

## Step 4: TDD Loop — Red

Write the failing test first. The test must:
- Live next to the source file (`foo.ts` → `foo.test.ts`, `foo.rb` → `foo_test.rb`, etc.)
- Assert the behaviour described in the AC, not implementation details
- Fail for the right reason (not because of a syntax error or missing import)
- Use the detected test framework's idioms

Run the test command. Confirm it fails with the expected error.

**Do not write any implementation code until the test is failing.**

---

## Step 5: TDD Loop — Green

Write the minimum code to make the test pass. No gold-plating.

Run the test command. Confirm it passes.

---

## Step 6: TDD Loop — Refactor

Clean up:
- Remove duplication
- Improve naming
- Extract constants
- Do not change behaviour

Run the test command again. Confirm it still passes.

---

## Step 7: Gate — Lint + Tests

Run both commands:

```
<lint command>
<test command>
```

Both must pass with zero errors/warnings before marking cc:done.

If lint fails: fix the lint errors, do not suppress them with ignore comments unless
the suppression is genuinely justified (document why inline).

If tests fail: do not mark cc:done. Investigate the failure.

**Coverage:** If the project has a coverage threshold, the gate includes coverage.
A test that passes but reduces coverage below the threshold is not done.

---

## Step 8: Mark cc:done

Update the active `plans/phase-N.md`: change `cc:WIP` → `cc:done` for this task.

Print a summary:
```
Task N.X — cc:done
Lint: passed
Tests: passed (coverage: N%)
AC verified: <restate the AC>
```

---

## Known Failure Patterns to Avoid

**Silent correctness failures:** When writing test fixtures, derive values from the same
source as production code. Do not hard-code parallel magic values (timestamps, counts,
assumed initial states) that could be semantically wrong while the test passes.

**Accepted constraints:** If you encounter an environment constraint (test runner
incompatibility, missing dependency) that you cannot resolve, do NOT silently continue.
Add a task to the active `plans/phase-N.md` to track it explicitly.

**Generated output:** If this task introduces a new tool that generates output
(reports, screenshots, build artifacts), update `.gitignore` in the same commit.
