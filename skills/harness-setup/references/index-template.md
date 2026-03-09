# Plans — <Project Name>

Created: <YYYY-MM-DD>

Each phase lives in its own file. This index links to all phases.

---

## Phases

| Phase | Name | Status |
|-------|------|--------|
| [Phase 1](phase-1.md) | <Phase 1 Name> | active |

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

<!--
Phase status values (index.md):
- active   — lowest-numbered phase with any cc:WIP or cc:TODO tasks
- complete — all tasks are cc:done
- upcoming — not yet started
-->
