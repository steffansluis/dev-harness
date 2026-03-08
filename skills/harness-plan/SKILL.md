---
name: harness-plan
description: Create or update Plans.md tasks with proper acceptance criteria and status tracking.
triggers:
  - add task
  - create plan
  - update Plans.md
  - what's next
  - harness-plan
  - new task
  - plan next phase
---

# harness-plan

You manage the Plans.md state machine. Follow these steps.

---

## Step 1: Read Plans.md

Read the current `Plans.md`. If it does not exist, tell the user to run `/harness-setup` first.

Identify:
- The current phase (last phase with any cc:WIP or cc:TODO tasks)
- All cc:WIP tasks (there should be 0–2; warn if 3+)
- All cc:TODO tasks (the backlog)
- The next task to work on

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

**WIP limit warning:** If 3+ tasks are already cc:WIP, warn:
```
Warning: 3 tasks are currently cc:WIP. Finish or descope one before adding more.
```

After agreeing on the task text, write it to `Plans.md` in the correct phase table.

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

If all tasks in the current phase are cc:done, say:
```
Phase N is complete. Run /harness-review before starting Phase N+1.
```

---

## Case C: Status Update

If the user says a task is done, move it to cc:done in Plans.md.
If they are starting a task, move it from cc:TODO to cc:WIP.

Remind them: cc:done requires lint + tests to pass, not just implementation complete.

---

## Plans.md Format

Always maintain this exact table format:

```markdown
| # | Task | AC | Status |
|---|------|----|--------|
| 1.1 | Task description | AC: One sentence user-visible outcome | cc:TODO |
```

Status values: `cc:TODO`, `cc:WIP`, `cc:done`

Never use other status formats (not ✓, not DONE, not [x]).
