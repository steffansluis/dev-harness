---
name: harness-setup
description: Scaffold a development harness for a new or existing project. Creates Plans.md, generates CI config, and prints .gitignore checklist.
triggers:
  - setup harness
  - init project
  - scaffold
  - new project
  - initialize harness
---

# harness-setup

You are setting up a development harness for this project. Follow these steps in order.

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

## Step 2: Create Plans.md

If `Plans.md` does not exist, create it using the template at
`skills/harness-setup/references/plans-template.md`.

Replace `<Project Name>` with the actual project name (from `package.json` name field,
directory name, or ask the user).

If `Plans.md` already exists, check whether it has an `AC` column in its task tables.
If not, add the `AC` column and populate existing rows with `—` as a placeholder.

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

1. Plans.md is your state machine:
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
  /harness-plan   — add tasks to Plans.md with acceptance criteria
  /harness-work   — execute the next cc:TODO task (TDD loop)
  /harness-review — structured multi-perspective code review
  /harness-ci     — generate or audit CI config
```
