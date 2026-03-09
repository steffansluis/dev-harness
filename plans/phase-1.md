# Phase 1 — Plans Directory Structure

Replace the single `Plans.md` file with a `plans/` directory so each phase and its history can be managed independently.

---

| # | Task | AC | Status |
|---|------|----|--------|
| 1.1 | Define `plans/` directory layout: index file, one file per phase (e.g. `plans/phase-1.md`) | AC: User can navigate to `plans/phase-1.md` and see only Phase 1 tasks with correct format | cc:done |
| 1.2 | Update `harness-plan` skill to read/write from `plans/` dir instead of `Plans.md` | AC: Running `/harness-plan` reads the current phase from `plans/` and correctly identifies WIP and TODO tasks | cc:done |
| 1.3 | Update `harness-work` skill to locate the next task from `plans/` directory | AC: Running `/harness-work` picks the correct next `cc:TODO` task from the active phase file | cc:done |
| 1.4 | Update `harness-setup` to scaffold `plans/` directory with `plans/phase-1.md` instead of `Plans.md` | AC: Running `/harness-setup` on a new project creates `plans/phase-1.md` with the standard template | cc:done |

---

<!--
AC guidelines:
- One sentence, user-visible outcome
- "User sees…", "App stores…", "CI fails when…"
- Not a test criterion — a behaviour criterion
- Required before a task can move to cc:WIP
-->
