<!-- DEPRECATED: superseded by index-template.md + phase-template.md (Phase 1 migration).
     Kept for reference only. Do not use for new scaffolding. -->

# Plans — <Project Name>

Created: <YYYY-MM-DD>

---

## Development Workflow

Every feature follows a strict TDD cycle. No business logic is written without a failing test first.

### TDD Cycle (per task)

1. **Red** — write a failing test that defines the expected behaviour
2. **Green** — write the minimum code to make the test pass
3. **Refactor** — clean up, keeping tests green

### Rules

- Every file of business logic must have a corresponding test file
- Coverage gate: **80% lines/branches minimum** (enforced in CI and locally)
- No phase completion without passing lint + tests + coverage threshold
- Tests live alongside source: `src/foo/bar.ts` → `src/foo/bar.test.ts`

### Status Markers

- `cc:TODO` — not started
- `cc:WIP` — in progress (limit: 1–2 tasks at a time)
- `cc:done` — lint + tests pass, AC verified

---

## Phase 1 — <Phase Name>

| # | Task | AC | Status |
|---|------|----|--------|
| 1.1 | <Task description> | AC: <One sentence user-visible outcome> | cc:TODO |
| 1.2 | <Task description> | AC: <One sentence user-visible outcome> | cc:TODO |
| 1.3 | <Task description> | AC: <One sentence user-visible outcome> | cc:TODO |

---

## Phase 2 — <Phase Name>

| # | Task | AC | Status |
|---|------|----|--------|
| 2.1 | <Task description> | AC: <One sentence user-visible outcome> | cc:TODO |
| 2.2 | <Task description> | AC: <One sentence user-visible outcome> | cc:TODO |

---

<!--
AC guidelines:
- One sentence, user-visible outcome
- "User sees…", "App stores…", "CI fails when…"
- Not a test criterion — a behaviour criterion
- Required before a task can move to cc:WIP

Phase guidelines:
- Each phase should be small enough to complete in one session
- End each phase with /harness-review before starting the next
- Add a PR/branch boundary between phases when possible
-->
