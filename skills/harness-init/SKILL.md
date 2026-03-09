---
name: harness-init
description: Generates the harness/ directory for a project with work.md, review.md, release.md, and gates/ — tailored to the detected stack. Accepts --paradigm flag (web-app, api-service, cli-tool). Use when user says 'harness-init', 'create harness', 'init harness', 'setup harness directory', or 'initialise harness'.
triggers:
  - harness-init
  - init harness
  - create harness
  - setup harness directory
  - initialise harness
license: MIT
compatibility: Claude Code, Claude.ai
metadata:
  author: dev-harness
  version: 1.0.0
  category: productivity
  tags: [setup, harness, gates, paradigms]
---

# harness-init

You generate a `harness/` directory for this project. The harness defines work, review,
and release constraints separate from the `plans/` state machine.

Optionally accepts a `--paradigm <name>` flag. Available paradigms are defined in
`skills/harness-init/paradigms/`. Each paradigm pre-selects which gates are enabled.

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

## Step 2: Resolve Paradigm and Stack

**If `--paradigm <name>` was supplied:**

1. Read `skills/harness-init/paradigms/<name>.md`.
2. Use the gate enabled/disabled table from the paradigm file — this pre-selects which
   gates are active without manual editing.
3. Still detect the stack (below) to substitute concrete commands into templates.

Available paradigms: `web-app`, `api-service`, `cli-tool`
(see `skills/harness-init/paradigms/` for the full list and their gate sets).

If an unrecognised paradigm name is supplied, list the available paradigms and ask the
user to choose one or proceed without a paradigm.

**If no `--paradigm` flag is supplied (default):**

Determine gate selection from the detected stack: infer a paradigm from the dependencies
(e.g. `react`/`next` → `web-app`; no UI deps → `api-service` or `cli-tool`). Ask the
user to confirm if the inferred paradigm is not obvious.

**Detect the stack** (for all cases):

Read the project root for these files (in priority order):
`package.json`, `Gemfile`, `go.mod`, `Cargo.toml`, `pyproject.toml`, `requirements.txt`

Record: **stack name**, **test command**, **lint command**, **coverage command**.

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

---

## Common Issues

**Error:** Unrecognised paradigm name supplied with `--paradigm`.
**Cause:** The value passed does not match any file in `skills/harness-init/paradigms/`.
**Solution:** List the available paradigms (`web-app`, `api-service`, `cli-tool`) and ask the user to choose one, or proceed without the `--paradigm` flag to use stack-inferred defaults.

**Error:** `harness/work.md` already exists but is outdated (missing `## Local Gate Sequence` section).
**Cause:** The harness was generated by an older version of the skill.
**Solution:** Offer the user the three options: Skip, Regenerate (overwrites customisations), or Audit (diff current vs template). Do not silently overwrite.

**Error:** Stack cannot be detected — no recognised manifest file found.
**Cause:** Project root lacks `package.json`, `Gemfile`, `go.mod`, `Cargo.toml`, or `pyproject.toml`.
**Solution:** Leave command placeholders (`<lint command>`, `<test command>`, `<coverage command>`) in the generated files and note them explicitly in the summary so the user knows what to fill in.

---

## Examples

### Example 1: Initialising a harness for a web-app project

User says: "harness-init --paradigm web-app"

Actions:
1. Check `harness/work.md` — does not exist; proceed to generate
2. Read `skills/harness-init/paradigms/web-app.md` → all 5 gates enabled
3. Detect stack: `package.json` → Next.js; lint: `npm run lint`, test: `npm run test`, coverage: `npm run test -- --coverage`
4. Generate `harness/work.md`, `harness/review.md`, `harness/release.md`, `harness/gates/README.md` with substituted commands

Result: User sees a complete `harness/` directory with all 5 gates pre-enabled and concrete npm commands already filled in, ready to use without further configuration.
