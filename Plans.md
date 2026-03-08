# Plans — dev-harness

Created: 2026-03-08

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

## Phase 1 — Plans Directory Structure

Replace the single `Plans.md` file with a `plans/` directory so each phase and its history can be managed independently.

| # | Task | AC | Status |
|---|------|----|--------|
| 1.1 | Define `plans/` directory layout: index file, one file per phase (e.g. `plans/phase-1.md`) | AC: User can navigate to `plans/phase-1.md` and see only Phase 1 tasks with correct format | cc:done |
| 1.2 | Update `harness-plan` skill to read/write from `plans/` dir instead of `Plans.md` | AC: Running `/harness-plan` reads the current phase from `plans/` and correctly identifies WIP and TODO tasks | cc:TODO |
| 1.3 | Update `harness-work` skill to locate the next task from `plans/` directory | AC: Running `/harness-work` picks the correct next `cc:TODO` task from the active phase file | cc:TODO |
| 1.4 | Update `harness-setup` to scaffold `plans/` directory with `plans/phase-1.md` instead of `Plans.md` | AC: Running `/harness-setup` on a new project creates `plans/phase-1.md` with the standard template | cc:TODO |

---

## Phase 2 — Dynamic Harness Directory

Introduce a `harness/` directory that defines the project-specific work, review, and release constraints separate from the plans state machine.

| # | Task | AC | Status |
|---|------|----|--------|
| 2.1 | Design `harness/` directory layout: `harness/work.md`, `harness/review.md`, `harness/release.md`, `harness/gates/` subdir | AC: A contributor reading `harness/` understands the full cycle of constraints for work, review, and release | cc:TODO |
| 2.2 | Create `/harness-init` skill that generates the initial `harness/` directory from a template, optionally guided by project context | AC: Running `/harness-init` produces a populated `harness/` directory tailored to the detected stack | cc:TODO |
| 2.3 | Write default `harness/work.md` template (TDD loop, lint gate, coverage gate) | AC: `harness/work.md` defines the gates that must pass before a task moves to `cc:done` | cc:TODO |
| 2.4 | Write default `harness/review.md` template (Security, Performance, Quality, Accessibility perspectives) | AC: `harness/review.md` specifies the review gates that run between phases | cc:TODO |
| 2.5 | Write default `harness/release.md` template (CI gates, changelog, version bump) | AC: `harness/release.md` defines the conditions for a commit/release to be considered complete | cc:TODO |

---

## Phase 3 — Extended Gate Set

Add richer gate types to `harness/gates/` so projects can opt into Design, README, acceptance-test, screenshot, and i18n verification.

| # | Task | AC | Status |
|---|------|----|--------|
| 3.1 | Create `harness/gates/design.md` — gate that verifies a design artefact (mockup, spec) exists before implementation | AC: CI fails when a task is marked `cc:WIP` without a linked design artefact and the design gate is enabled | cc:TODO |
| 3.2 | Create `harness/gates/readme.md` — gate that requires `README.md` to be updated when public API surface changes | AC: The review step flags a failing README gate when exported APIs changed but `README.md` was not updated | cc:TODO |
| 3.3 | Create `harness/gates/acceptance.md` — gate that requires at least one acceptance (e2e) test per feature task | AC: `/harness-work` warns when a feature task completes with no acceptance test written | cc:TODO |
| 3.4 | Create `harness/gates/screenshots.md` — gate requiring before/after screenshots for UI tasks | AC: UI tasks cannot move to `cc:done` without screenshot artefacts linked in the task row | cc:TODO |
| 3.5 | Create `harness/gates/i18n.md` — gate requiring all user-facing strings to use a localisation helper | AC: The i18n gate fails when a task introduces a hardcoded user-visible string outside a localisation call | cc:TODO |

---

## Phase 4 — Local vs Remote Gates

Split gate execution so fast local gates run pre-commit/pre-push and slow remote gates run in CI or on PR open.

| # | Task | AC | Status |
|---|------|----|--------|
| 4.1 | Define local-gate contract in `harness/work.md`: which gates run locally before `cc:done` (lint, unit tests, coverage) | AC: A developer running the local gate command sees pass/fail within 30 seconds for a typical project | cc:TODO |
| 4.2 | Define remote-gate contract in `harness/release.md`: which gates run in CI or on PR (build, acceptance tests, screenshot diffs) | AC: `harness/release.md` lists each remote gate, its trigger (push/PR), and the artefact it produces | cc:TODO |
| 4.3 | Update `harness-ci` skill to read `harness/gates/` and emit CI steps only for enabled gates | AC: Running `/harness-ci` after enabling the i18n gate adds an i18n-check step to the generated CI YAML | cc:TODO |
| 4.4 | Document gate locality (local vs remote) in each `harness/gates/*.md` file with a `Runs: local | remote | both` header | AC: Every gate file declares its locality so contributors know where the check will fire | cc:TODO |

---

## Phase 5 — Paradigms and /harness-reflect

Introduce paradigms (named gate bundles) and a `/harness-reflect` skill that amends the harness based on retrospective feedback.

| # | Task | AC | Status |
|---|------|----|--------|
| 5.1 | Define paradigm format: a named set of gates (e.g. `web-app`, `api-service`, `cli-tool`) that pre-selects relevant gates | AC: Running `/harness-init --paradigm web-app` generates a `harness/` directory with the web-app gate set pre-enabled | cc:TODO |
| 5.2 | Write built-in paradigm definitions for `web-app`, `api-service`, and `cli-tool` | AC: Each paradigm file lists which gates are enabled by default and why, readable without further context | cc:TODO |
| 5.3 | Create `/harness-reflect` skill: reads current harness, prompts for retrospective feedback, and proposes targeted amendments to gate files | AC: Running `/harness-reflect` produces a diff of proposed harness changes that the user can accept or reject | cc:TODO |
| 5.4 | Update `harness-setup` and `harness-init` to accept a `--paradigm` flag and apply the appropriate gate set | AC: A new project set up with `--paradigm api-service` has the correct gates enabled without manual editing | cc:TODO |

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
