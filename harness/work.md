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

## Gate — Bash Test Suite

This project is a markdown-only Claude Code plugin with no build toolchain. The gate is
the project's bash test suite:

```bash
bash skills/*.test.sh
```

All assertions must pass (0 failed). This replaces the generic lint, test, and coverage
gates — those do not apply to this project.

**Gate rules:**
- Before writing a new skill's SKILL.md, add it to the relevant SKILLS arrays in the test
  scripts first — this creates the failing (Red) state
- All assertions must pass before marking `cc:done`
- New skills that have evals must also be added to `evals-coverage.test.sh`
- The gate must complete without error; a non-zero exit code is not `cc:done`

---

## Local Gate Sequence

```
bash skills/*.test.sh  →  cc:done
```

**Remote gates** (CI skill-structure check) run on push and are defined in
`harness/release.md`. They do not block `cc:done` locally but must pass before merging.
