# Phase 4 — Local vs Remote Gates

Split gate execution so fast local gates run pre-commit/pre-push and slow remote gates run in CI or on PR open.

---

| # | Task | AC | Status |
|---|------|----|--------|
| 4.1 | Define local-gate contract in `harness/work.md`: which gates run locally before `cc:done` (lint, unit tests, coverage) | AC: A developer running the local gate command sees pass/fail within 30 seconds for a typical project | cc:TODO |
| 4.2 | Define remote-gate contract in `harness/release.md`: which gates run in CI or on PR (build, acceptance tests, screenshot diffs) | AC: `harness/release.md` lists each remote gate, its trigger (push/PR), and the artefact it produces | cc:TODO |
| 4.3 | Update `harness-ci` skill to read `harness/gates/` and emit CI steps only for enabled gates | AC: Running `/harness-ci` after enabling the i18n gate adds an i18n-check step to the generated CI YAML | cc:TODO |
| 4.4 | Document gate locality (local vs remote) in each `harness/gates/*.md` file with a `Runs: local | remote | both` header | AC: Every gate file declares its locality so contributors know where the check will fire | cc:TODO |

---

<!--
AC guidelines:
- One sentence, user-visible outcome
- "User sees…", "App stores…", "CI fails when…"
- Not a test criterion — a behaviour criterion
- Required before a task can move to cc:WIP
-->
