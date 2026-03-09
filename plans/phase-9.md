# Phase 9 — Description Optimization

Run the skill-creator description optimization loop on all 8 skills to maximise triggering accuracy, then strengthen any remaining gaps in description "pushiness".

---

| # | Task | AC | Status |
|---|------|----|--------|
| 9.1 | Run description optimization (`run_loop.py`) on all 8 skills | AC: Each skill's description is updated to the best-scoring variant from the optimization run; before/after trigger accuracy scores are recorded | cc:done |
| 9.2 | Strengthen description "pushiness" on skills where optimization doesn't fully close gaps | AC: All 8 skill descriptions proactively encourage triggering on natural-language requests, not just explicit slash-command invocations | cc:done |

---

<!--
AC guidelines:
- One sentence, user-visible outcome
- "User sees…", "App stores…", "CI fails when…"
- Not a test criterion — a behaviour criterion
- Required before a task can move to cc:WIP
-->
