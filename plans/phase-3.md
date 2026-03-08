# Phase 3 — Extended Gate Set

Add richer gate types to `harness/gates/` so projects can opt into Design, README, acceptance-test, screenshot, and i18n verification.

---

| # | Task | AC | Status |
|---|------|----|--------|
| 3.1 | Create `harness/gates/design.md` — gate that verifies a design artefact (mockup, spec) exists before implementation | AC: CI fails when a task is marked `cc:WIP` without a linked design artefact and the design gate is enabled | cc:TODO |
| 3.2 | Create `harness/gates/readme.md` — gate that requires `README.md` to be updated when public API surface changes | AC: The review step flags a failing README gate when exported APIs changed but `README.md` was not updated | cc:TODO |
| 3.3 | Create `harness/gates/acceptance.md` — gate that requires at least one acceptance (e2e) test per feature task | AC: `/harness-work` warns when a feature task completes with no acceptance test written | cc:TODO |
| 3.4 | Create `harness/gates/screenshots.md` — gate requiring before/after screenshots for UI tasks | AC: UI tasks cannot move to `cc:done` without screenshot artefacts linked in the task row | cc:TODO |
| 3.5 | Create `harness/gates/i18n.md` — gate requiring all user-facing strings to use a localisation helper | AC: The i18n gate fails when a task introduces a hardcoded user-visible string outside a localisation call | cc:TODO |

---

<!--
AC guidelines:
- One sentence, user-visible outcome
- "User sees…", "App stores…", "CI fails when…"
- Not a test criterion — a behaviour criterion
- Required before a task can move to cc:WIP
-->
