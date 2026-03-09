---
name: harness-init
description: Generate the initial harness/ directory for a project, tailored to the detected stack.
triggers:
  - harness-init
  - init harness
  - create harness
  - setup harness directory
  - initialise harness
---

# harness-init

You generate a `harness/` directory for this project. The harness defines work, review,
and release constraints separate from the `plans/` state machine.

Follow these steps in order.

---

## Step 1: Check for Existing harness/

If `harness/work.md` already exists, the harness is already initialised. Report its current
state and ask the user whether they want to:
- **Skip** — do nothing
- **Regenerate** — overwrite with fresh defaults (warn: existing customisations will be lost)
- **Audit** — compare current files against the default templates and report gaps

If no `harness/` directory exists, proceed to Step 2.

---

## Step 2: Detect the Stack

Read the project root for these files (in priority order):
`package.json`, `Gemfile`, `go.mod`, `Cargo.toml`, `pyproject.toml`, `requirements.txt`

Record: **stack name**, **test command**, **lint command**, **coverage command**.

This information is used to tailor the harness content to the project's actual tooling.
See `skills/harness-work/references/stack-detection.md` for the full detection algorithm.

---

## Step 3: Generate harness/

Create the following structure:

```
harness/
  work.md
  review.md
  release.md
  gates/
    README.md
```

Use the following templates as the starting point for each file:

| Output file | Template |
|-------------|----------|
| `harness/work.md` | `skills/harness-init/references/work.md` |
| `harness/review.md` | `skills/harness-init/references/review.md` |
| `harness/release.md` | `skills/harness-init/references/release.md` |
| `harness/gates/README.md` | `skills/harness-init/references/gates-README.md` |

Substitute the detected stack's actual commands for every placeholder in the templates:
`<lint command>`, `<test command>`, `<coverage command>`.

**Stack-specific tailoring:**

- **Node/TS**: substitute `bun run lint` / `npm run lint`, `bun run test` / `npm run test`
- **Ruby**: substitute `bundle exec rubocop --no-color`, `bundle exec rspec`
- **Go**: substitute `go vet ./...` or `golangci-lint run`, `go test ./...`
- **Rust**: substitute `cargo clippy -- -D warnings`, `cargo test`
- **Python**: substitute `ruff check .` or `flake8 .`, `pytest --cov --cov-fail-under=80`
- **Unknown stack**: leave placeholders and note them in the output summary

For projects with **no UI** (CLI, API, library): add a note in `harness/review.md` that the
Accessibility perspective is skipped.

---

## Step 4: Inform the User

Print a summary of what was created:

```
harness/ initialised for <stack name>:

  harness/work.md     — TDD loop, lint/test/coverage gates
  harness/review.md   — Security, Performance, Quality[, Accessibility] perspectives
  harness/release.md  — commit checklist, CI pipeline, changelog, version bump
  harness/gates/      — gate definitions (populated in Phase 3)

Lint command:     <detected or placeholder>
Test command:     <detected or placeholder>
Coverage command: <detected or placeholder>

Next: run /harness-work to execute the next task.
```

If any commands could not be detected, list them explicitly so the user can fill them in.
