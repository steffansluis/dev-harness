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

```
<lint command>
```

**Gate rules:**
- Zero errors and zero warnings
- Do not suppress lint errors with ignore comments unless genuinely justified; document why inline
- Lint must pass on every file touched by the task, not just new files

---

## Test Gate

```
<test command>
```

**Gate rules:**
- All tests must pass — no skipped tests introduced by this task without a tracked reason
- A test that fails intermittently is not cc:done

---

## Coverage Gate

Minimum: **80% line and branch coverage**.

```
<coverage command>
```

**Gate rules:**
- Coverage must not drop below 80% after this task
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
