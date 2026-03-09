# Plans — dev-harness

Created: 2026-03-08

Each phase lives in its own file. This index links to all phases.

---

## Phases

| Phase | Name | Status |
|-------|------|--------|
| [Phase 1](phase-1.md) | Plans Directory Structure | complete |
| [Phase 2](phase-2.md) | Dynamic Harness Directory | complete |
| [Phase 3](phase-3.md) | Extended Gate Set | complete |
| [Phase 4](phase-4.md) | Local vs Remote Gates | complete |
| [Phase 5](phase-5.md) | Paradigms and /harness-reflect | complete |
| [Phase 6](phase-6.md) | Guide Compliance and Distribution Readiness | complete |
| [Phase 7](phase-7.md) | Skill-Creator Compliance and Eval Coverage | complete |
| [Phase 8](phase-8.md) | harness-cycle Skill | complete |
| [Phase 9](phase-9.md) | Description Optimization | upcoming |
| [Phase 10](phase-10.md) | `/harness-release` skill | upcoming |
| [Phase 11](phase-11.md) | Hook Guardrails | upcoming |
| [Phase 12](phase-12.md) | Quick-win skill improvements | upcoming |
| [Phase 13](phase-13.md) | Comparative benchmark documentation | upcoming |

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
Phase guidelines:
- Each phase should be small enough to complete in one session
- End each phase with /harness-review before starting the next
- Add a PR/branch boundary between phases when possible
-->
