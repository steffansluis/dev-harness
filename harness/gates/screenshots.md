# Gate: Screenshots

UI tasks must include before/after screenshot artefacts linked in the task row before
moving to `cc:done`. Provides a visual record of what changed and makes regressions
visible during review.

**Enabled:** opt-in — add this gate for web and mobile projects where tasks produce
visible UI changes. Skip for CLI, API, and library projects with no user interface.

**Runs: remote** — screenshot diff requires a full build and baseline; runs in CI on PR open.

---

## What It Checks

When `/harness-work` reaches Step 8 (mark `cc:done`) for a **UI task**, it checks that
the task row in `plans/phase-N.md` contains at least two linked screenshot artefacts:
one taken before the change and one after.

A task is treated as a UI task when its description contains `UI`, `screen`, `view`,
`page`, `component`, `layout`, `style`, or `design`, or when the design gate is enabled
for the task.

Screenshots must be stored in the project's artefact directory (e.g. `docs/screenshots/`
or `e2e/screenshots/`) and linked from the task row:

```
2.3 | Add dark mode toggle | AC: User sees... | cc:done [before](docs/screenshots/2.3-before.png) [after](docs/screenshots/2.3-after.png)
```

**`.gitignore` note:** Do NOT add the screenshots artefact directory to `.gitignore`.
These are intentional, committed artefacts. Only add auto-generated Playwright/tool
output directories (e.g. `e2e/report/`) to `.gitignore`.

---

## Pass

The task row in `plans/phase-N.md` contains links to at least one before screenshot and
one after screenshot before the task is marked `cc:done`.

## Fail

A UI task is marked `cc:done` with no screenshot artefacts linked in the task row:

```
Screenshots gate: UI task N.X has no before/after screenshots linked.
Action: capture screenshots and link them in the task row before marking cc:done.
```

---

## Skipping

Add `[no-screenshots: <reason>]` to the task row for UI tasks where screenshots are
impractical. Valid reasons: `automated visual diff in CI`, `no visual change`, `internal tooling only`.
