# Gate: README Currency

`README.md` must be updated whenever the public API surface of the project changes.
Prevents documentation drift where exported functions, CLI flags, or configuration options
are modified but the README still describes the old behaviour.

**Enabled:** opt-in — add this gate when your project has a documented public API,
CLI interface, or configuration surface that contributors rely on.

---

## What It Checks

At the review step (`/harness-review`), compare the set of changes in the current task
against `README.md`. The gate fails when all of the following are true:

1. The diff contains changes to exported symbols, public functions, CLI commands, config
   keys, or environment variables
2. `README.md` was **not** modified in the same task or phase

Examples of API surface changes that trigger this gate:
- A new exported function, class, or type added to the public module
- A CLI flag renamed, added, or removed
- A configuration key added, removed, or given a new default value
- An environment variable that the project reads changed in name or meaning

---

## Pass

One of the following is true:
- No public API surface was changed in this task
- `README.md` was updated in the same task or phase to reflect the change

## Fail

The review step flags a failing README gate when exported APIs changed but `README.md`
was not updated. The review output includes:

```
README gate: public API surface changed but README.md was not updated.
Changed surface: <list of changed exports / flags / config keys>
Action: update README.md before marking this phase complete.
```

---

## Skipping

If the API change is internal and not yet part of the documented public surface, add
`[readme-skip: internal]` to the task row with a brief justification.
