---
name: harness-setup
description: Scaffolds a development harness for a new or existing project: creates plans/, generates a CI config, and prints a .gitignore checklist. Accepts --paradigm flag (web-app, api-service, cli-tool). Use this whenever someone is starting a new project or adding the harness to an existing one — 'set up a harness for my project', 'scaffold this project', 'initialize harness', 'new project setup', 'harness-setup', 'I just started a new project'. Trigger this for any request to bootstrap the dev harness — even without the skill name. Do not use for creating harness/ directory only (use harness-init) or CI alone (use harness-ci).
triggers:
  - setup harness
  - init project
  - scaffold
  - new project
  - initialize harness
license: MIT
compatibility: Claude Code, Claude.ai
metadata:
  author: dev-harness
  version: 1.0.0
  category: productivity
  tags: [setup, scaffolding, ci, project-init]
---

# harness-setup

You are setting up a development harness for this project. Follow these steps in order.

Optionally accepts `--paradigm <name>` (e.g. `--paradigm api-service`). When supplied,
the harness gate set is pre-selected from the named paradigm without manual editing.
Available paradigms: `web-app`, `api-service`, `cli-tool` (see `skills/harness-init/paradigms/`).

---

## Step 1: Detect the Stack

Read the project root for these files (in priority order):

1. `package.json` — Node/TS/JS project
   - Check `packageManager` field for `bun`, `npm`, `yarn`, `pnpm`
   - Check `dependencies`/`devDependencies` for `expo`, `react-native`, `next`, `vite`, etc.
   - Check `scripts.test` and `scripts.lint` for the actual commands
2. `Gemfile` — Ruby project
   - Check for `rspec` → test runner is RSpec (`bundle exec rspec`)
   - Otherwise → test runner is Minitest (`bundle exec rails test` or `ruby -Itest`)
3. `go.mod` — Go project
   - Test runner: `go test ./...`
   - Lint: `golangci-lint run` (if present) or `go vet ./...`
4. `Cargo.toml` — Rust project
   - Test runner: `cargo test`
   - Lint: `cargo clippy`
5. `pyproject.toml` or `requirements.txt` — Python project
   - Check for `pytest` → `pytest --cov`
   - Otherwise → `python -m unittest discover`
   - Lint: `ruff check .` or `flake8`

Record: **stack name**, **package manager**, **test command**, **lint command**.

---

## Step 2: Create the plans/ directory

**New project (no plans/ and no Plans.md):**

1. Create the `plans/` directory.
2. Create `plans/index.md` using the template at
   `skills/harness-setup/references/index-template.md`.
   Replace `<Project Name>` and `<Phase 1 Name>` with real values.
3. Create `plans/phase-1.md` using the template at
   `skills/harness-setup/references/phase-template.md`.
   Replace `N` with `1` and fill in `<Phase Name>`.

**Existing project with flat Plans.md (migration):**

If `Plans.md` already exists but `plans/` does not:
1. Tell the user: "I found a flat Plans.md. I'll scaffold the plans/ directory and migrate
   all phases. You can delete Plans.md once you've verified the migration."
2. Read all phases from `Plans.md`.
3. Create `plans/` and `plans/index.md`, listing every phase found with its name and status
   (`active` for the lowest phase with any `cc:WIP`/`cc:TODO` tasks; `complete` for all-done
   phases; `upcoming` for phases not yet started).
4. Create a `plans/phase-N.md` file for **every phase** found in `Plans.md`, copying all
   task rows and preserving their status markers.
5. Leave the flat `Plans.md` in place; the user decides when to delete it.

**Both plans/ and Plans.md exist:**

If `plans/index.md` already exists, the setup is complete. Report its current state and skip
this step.

---

## Step 2c: Apply Paradigm Gate Set (if --paradigm supplied)

If `--paradigm <name>` was supplied, read the matching paradigm file from
`skills/harness-init/paradigms/<name>.md` and use its gate enabled/disabled table to
configure which gates are active in the generated `harness/`. This means the developer
gets the correct gate set without manually editing any gate files.

If no `--paradigm` flag was given, skip this step and generate the default harness
(all gates opt-in, no gates pre-enabled).

---

## Step 3: Generate CI Config

If `.github/workflows/ci.yml` does not exist:

1. Select the matching CI template from `skills/harness-setup/references/`:
   - Node/TS with bun → `ci-node.yml`
   - Node/TS with npm/yarn/pnpm → `ci-node.yml` (adjust install command)
   - Ruby → `ci-ruby.yml`
   - Python → `ci-python.yml`
   - Go → `ci-go.yml`
   - Unknown/generic → `ci-generic.yml`

2. Create `.github/workflows/` directory if it doesn't exist.

3. Write the CI config, substituting the actual lint and test commands detected in Step 1.

4. Inform the user what was generated and what they may need to customise.

If `.github/workflows/ci.yml` already exists, read it and report whether it has:
- [ ] lint step
- [ ] test + coverage step
- [ ] build step
- [ ] smoke test before acceptance tests (if e2e tests are present)
- [ ] artifact uploads

---

## Step 4: Print .gitignore Checklist

Print the following checklist. Tell the user to verify these entries are in `.gitignore`
**before running any of the tools that generate them**:

```
Generated-output directories to add to .gitignore:
  [ ] coverage/          (test coverage output)
  [ ] dist/              (build output)
  [ ] .expo/             (Expo cache, if Expo project)
  [ ] test-results/      (Playwright/test runner output)
  [ ] e2e/report/        (Playwright HTML report)
  [ ] *.report/          (generic report directories)
  [ ] node_modules/      (if not already present)
  [ ] __pycache__/       (Python, if applicable)
  [ ] target/            (Rust/Java, if applicable)
```

**Rule:** Every tool introduction must include updating `.gitignore` in the same commit
as the tool configuration. Add directories to `.gitignore` before running the tool for
the first time.

---

## Step 5: Explain the Workflow

Print a short summary:

```
Harness set up. Your development workflow:

1. plans/ is your state machine:
   plans/index.md → active phase → plans/phase-N.md
   cc:TODO → cc:WIP → cc:done

2. TDD loop (per task):
   Red: write failing test
   Green: minimum code to pass
   Refactor: clean up
   Gate: [lint command] && [test command] — both must pass before cc:done

3. Between phases: run /harness-review
   (Security / Performance / Quality / Accessibility perspectives)

4. CI runs: lint → test+coverage → build → acceptance tests

Skills available:
  /harness-plan   — add tasks to plans/ with acceptance criteria
  /harness-work   — execute the next cc:TODO task (TDD loop)
  /harness-review — structured multi-perspective code review
  /harness-ci     — generate or audit CI config
```

---

## Common Issues

**Error:** `plans/index.md` already exists but phase statuses are stale (all show `upcoming` after work is done).
**Cause:** Phase statuses in `plans/index.md` are not updated automatically; they must be maintained manually or by `harness-work`.
**Solution:** Read each `plans/phase-N.md`, check whether all tasks are `cc:done`, and update `plans/index.md` statuses to `complete` / `active` / `upcoming` accordingly.

**Error:** `.github/workflows/ci.yml` already exists but is missing a lint or test step.
**Cause:** The CI file was created manually or by an older version of the skill.
**Solution:** Do not overwrite — instead report the audit checklist (lint step, test+coverage step, build step, smoke test, artifact uploads) and let the user decide which gaps to fix.

**Error:** Migration from flat `Plans.md` produces a `plans/phase-1.md` that is missing later phases.
**Cause:** The migration logic only created a file for Phase 1 rather than one file per phase found.
**Solution:** Re-read `Plans.md`, identify every phase heading, and create a `plans/phase-N.md` for each one, copying all task rows and preserving their status markers.

---

## Examples

### Example 1: Setting up a new Node.js API project

User says: "setup harness --paradigm api-service"

Actions:
1. Read `package.json` → detect Node stack with `npm run test` and `npm run lint`
2. Create `plans/index.md` and `plans/phase-1.md` from templates
3. Read `skills/harness-init/paradigms/api-service.md` → enable readme + acceptance gates only
4. Generate `.github/workflows/ci.yml` using the Node CI template
5. Print .gitignore checklist

Result: User sees a complete `plans/` directory, a working CI config with lint and test steps, and a checklist of .gitignore entries to verify — ready to start the first task.
