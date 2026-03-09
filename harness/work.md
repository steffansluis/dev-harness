# Work Constraints

Defines the gates that must pass before any task moves to `cc:done`.

---

## TDD Loop

Every task follows this cycle. No production code is written before a failing test exists.

```
Red      → Write a failing test that asserts the AC behaviour
Green    → Write the minimum code to make the test pass
Refactor → Clean up: naming, duplication, constants — no behaviour changes
Gate     → Run lint AND tests; both must pass before marking cc:done
```

**Rules:**
- Test file lives next to source (`foo.ts` → `foo.test.ts`)
- Test asserts the AC (user-visible behaviour), not implementation details
- Refactor does not change test outcomes

---

## Lint Gate

Run the project's lint command (detected by `/harness-work` from the stack):

| Stack | Lint command |
|-------|-------------|
| Node/TS (bun) | `bun run lint` |
| Node/TS (npm) | `npm run lint` |
| Ruby | `bundle exec rubocop --no-color` |
| Go | `golangci-lint run` or `go vet ./...` |
| Rust | `cargo clippy -- -D warnings` |
| Python | `ruff check .` or `flake8 .` |

**Gate rules:**
- Zero errors and zero warnings (or warnings-as-errors where configured)
- Do not suppress lint errors with ignore comments unless genuinely justified; document why inline
- Lint must pass on every file touched by the task, not just new files

---

## Test Gate

Run the project's test command:

| Stack | Test command |
|-------|-------------|
| Node/TS (bun + jest) | `bun run test` |
| Node/TS (npm) | `npm run test` |
| Ruby (RSpec) | `bundle exec rspec` |
| Go | `go test ./...` |
| Rust | `cargo test` |
| Python | `pytest` |

**Gate rules:**
- All tests must pass — no skipped tests introduced by this task without a tracked reason
- A test that fails intermittently is not cc:done

---

## Coverage Gate

Minimum: **80% line and branch coverage** across all files touched by the task.

| Stack | Coverage command |
|-------|----------------|
| Node/TS | `bun run test -- --coverage` or `npm run test -- --coverage` |
| Ruby (SimpleCov) | coverage reported by `bundle exec rspec` |
| Go | `go test -coverprofile=coverage.out ./...` |
| Rust | `cargo tarpaulin` (if installed) |
| Python | `pytest --cov --cov-fail-under=80` |

**Gate rules:**
- Coverage must not drop below 80% after this task
- A task that adds code but no tests, reducing coverage below 80%, is not cc:done
- New branches introduced by the task must be tested

---

## Gate Sequence

Both lint AND tests (with coverage) must pass before marking `cc:done`:

```
lint  →  test + coverage  →  cc:done
```

If lint fails: fix the errors — do not suppress or skip.
If tests fail: do not mark cc:done; investigate the failure.
If coverage drops below 80%: add the missing tests before proceeding.
