# Phase 8 — harness-cycle Skill

Introduce `/harness-cycle`, a meta-skill that encapsulates the full work → review → fix → commit loop, giving users a single command to drive a phase to completion.

---

| # | Task | AC | Status |
|---|------|----|--------|
| 8.1 | Write `harness-cycle` SKILL.md that encapsulates the work → review → fix → commit loop | AC: User can invoke `/harness-cycle` and Claude executes the full loop for the active phase: picks the next `cc:TODO` task, runs the TDD loop, reviews, commits on APPROVE, or fixes and re-reviews on REQUEST_CHANGES | cc:done |
| 8.2 | Add `harness-cycle` to the existing test suites (description-quality, frontmatter-metadata, skill-creator-audit, examples) | AC: All project-level test scripts pass with `harness-cycle` included; no regressions in existing 295 assertions | cc:TODO |
| 8.3 | Add `evals/evals.json` for `harness-cycle` and update `evals-coverage.test.sh` to include it | AC: `harness-cycle` has 2+ eval prompts covering realistic cycle invocations; `evals-coverage.test.sh` passes with the new skill included | cc:TODO |
| 8.4 | Update README and `plans/index.md` to document `/harness-cycle` | AC: A developer reading the README understands what `/harness-cycle` does and when to use it vs the individual skills | cc:TODO |

---

<!--
AC guidelines:
- One sentence, user-visible outcome
- "User sees…", "App stores…", "CI fails when…"
- Not a test criterion — a behaviour criterion
- Required before a task can move to cc:WIP
-->
