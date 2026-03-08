# Phase 5 — Paradigms and /harness-reflect

Introduce paradigms (named gate bundles) and a `/harness-reflect` skill that amends the harness based on retrospective feedback.

---

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
-->
