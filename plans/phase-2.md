# Phase 2 — Dynamic Harness Directory

Introduce a `harness/` directory that defines the project-specific work, review, and release constraints separate from the plans state machine.

---

| # | Task | AC | Status |
|---|------|----|--------|
| 2.1 | Design `harness/` directory layout: `harness/work.md`, `harness/review.md`, `harness/release.md`, `harness/gates/` subdir | AC: A contributor reading `harness/` understands the full cycle of constraints for work, review, and release | cc:done |
| 2.2 | Create `/harness-init` skill that generates the initial `harness/` directory from a template, optionally guided by project context | AC: Running `/harness-init` produces a populated `harness/` directory tailored to the detected stack | cc:done |
| 2.3 | Write default `harness/work.md` template (TDD loop, lint gate, coverage gate) | AC: `harness/work.md` defines the gates that must pass before a task moves to `cc:done` | cc:done |
| 2.4 | Write default `harness/review.md` template (Security, Performance, Quality, Accessibility perspectives) | AC: `harness/review.md` specifies the review gates that run between phases | cc:done |
| 2.5 | Write default `harness/release.md` template (CI gates, changelog, version bump) | AC: `harness/release.md` defines the conditions for a commit/release to be considered complete | cc:done |

---

<!--
AC guidelines:
- One sentence, user-visible outcome
- "User sees…", "App stores…", "CI fails when…"
- Not a test criterion — a behaviour criterion
- Required before a task can move to cc:WIP
-->
