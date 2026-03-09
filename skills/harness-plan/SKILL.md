---
name: harness-plan
description: Manages the plans/ task state machine — adds tasks with acceptance criteria, updates task status, and reports phase progress. Use when user says 'add task', 'new task', 'plan next phase', 'what's next', 'harness-plan', or wants to track a new piece of work. Do not use for executing tasks (use harness-work) or reviewing code (use harness-review).
triggers:
  - add task
  - create plan
  - update plans
  - what's next
  - harness-plan
  - new task
  - plan next phase
license: MIT
compatibility: Claude Code, Claude.ai
metadata:
  author: dev-harness
  version: 1.0.0
  category: productivity
  tags: [planning, tdd, task-management]
---

# harness-plan

You manage the `plans/` state machine. Follow these steps.

---

## Step 1: Read the plans/ directory

Read `plans/index.md` to get the list of phase files.

Identify the **current active phase**: the lowest-numbered phase file that still contains any `cc:WIP` or `cc:TODO` tasks. Read that phase file (e.g. `plans/phase-1.md`).

From the active phase file, identify:
- All `cc:WIP` tasks (there should be 0–2; warn if 3+)
- All `cc:TODO` tasks (the backlog)
- The next task to work on (first `cc:TODO` by task number)

**Co-existence / migration:** If both `plans/index.md` and a flat `Plans.md` exist, always
prefer `plans/`. Treat the flat `Plans.md` as a legacy file and do not read or write to it.
If only `Plans.md` exists (no `plans/` directory), tell the user to run `/harness-setup` to
migrate to the directory layout before continuing.

If neither `plans/index.md` nor `Plans.md` exists, tell the user to run `/harness-setup` first.

---

## Step 2: Determine the User's Intent

The user may want to:

**A. Add a new task or phase** — they describe new work to be done
**B. Review current status** — they want to see what's next or what's in progress
**C. Update a task's status** — they've completed something or are starting something

Handle each case below.

---

## Case A: Adding a New Task

Guide the user to write a well-formed task entry:

```
| N.X | <Task description> | AC: <One sentence user-visible outcome> | cc:TODO |
```

**Acceptance criteria rules:**
- One sentence describing a user-visible outcome
- Starts with a perspective: "User sees…", "App stores…", "CI fails when…", "Page loads…"
- Describes behaviour, not implementation ("User sees a confirmation toast" not "useNotification hook returns true")
- Cannot be "tests pass" — that is the gate, not the AC

If the user provides a task without an AC, ask: "What does a user see or experience when this task is complete?"

**WIP limit warning:** If 3+ tasks are already `cc:WIP`, warn:
```
Warning: 3 tasks are currently cc:WIP. Finish or descope one before adding more.
```

After agreeing on the task text, write it to the correct phase file in `plans/` (e.g. `plans/phase-1.md`). Do not write to a flat `Plans.md`.

If adding a new phase, also add a row to the `plans/index.md` phase table.

---

## Case B: Status Review

Print a summary:

```
## Current Status

Phase N — <Phase Name>
  cc:WIP  (N.X): <task description>
  cc:TODO (N.Y): <task description>
  cc:TODO (N.Z): <task description>

Next action: run /harness-work to execute task N.Y
```

If all tasks in the current phase are `cc:done`, say:
```
Phase N is complete. Run /harness-review before starting Phase N+1.
```

---

## Examples

### Example 1: Adding a new task mid-phase

User says: "Add a task to cache API responses in Redis."

Actions:
1. Read `plans/index.md` to find the active phase file
2. Check for existing `cc:WIP` tasks (warn if 3+)
3. Ask: "What does a user see or experience when caching is working?"
4. Write the agreed task row to the active `plans/phase-N.md`

Result: A new `cc:TODO` row appears in the active phase file with a one-sentence user-visible AC.

---

## Case C: Status Update

If the user says a task is done, move it to `cc:done` in the correct `plans/phase-N.md` file.
If they are starting a task, move it from `cc:TODO` to `cc:WIP` in the correct `plans/phase-N.md` file.

Remind them: `cc:done` requires lint + tests to pass, not just implementation complete.

---

## Phase File Format

Always maintain this exact table format within each `plans/phase-N.md`:

```markdown
| # | Task | AC | Status |
|---|------|----|--------|
| 1.1 | Task description | AC: One sentence user-visible outcome | cc:TODO |
```

Status values: `cc:TODO`, `cc:WIP`, `cc:done`

Never use other status formats (not ✓, not DONE, not [x]).
