# Phase 7 — Skill-Creator Compliance and Eval Coverage

Apply skill-creator best practices to the 7 dev-harness skills: write eval test cases, run the eval loop, review outputs, apply improvements, and run description optimization to maximise triggering accuracy.

---

| # | Task | AC | Status |
|---|------|----|--------|
| 7.1 | Write `evals/evals.json` test cases for `harness-work`, `harness-review`, and `harness-plan` (2–3 prompts each) | AC: User sees a populated `evals/evals.json` per skill covering realistic trigger scenarios; prompts are substantive enough to require skill consultation | cc:done |
| 7.2 | Run skill-creator eval loop for `harness-work`, `harness-review`, and `harness-plan`; review results in eval viewer | AC: User has reviewed qualitative outputs for all 3 skills in the eval viewer and recorded feedback | cc:TODO |
| 7.3 | Apply improvements from eval feedback to `harness-work`, `harness-review`, and `harness-plan` | AC: Each revised skill addresses at least one concrete issue identified in the eval review; all existing test assertions still pass | cc:TODO |
| 7.4 | Run description optimization (`run_loop.py`) on all 7 skills | AC: Each skill's description is updated to the best-scoring variant from the optimization run; before/after trigger accuracy scores are recorded | cc:TODO |
| 7.5 | Strengthen description "pushiness" on skills where optimization doesn't fully close gaps | AC: All 7 skill descriptions proactively encourage triggering on natural-language requests, not just explicit slash-command invocations | cc:TODO |

---

<!--
AC guidelines:
- One sentence, user-visible outcome
- "User sees…", "App stores…", "CI fails when…"
- Not a test criterion — a behaviour criterion
- Required before a task can move to cc:WIP
-->
