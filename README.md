# dev-harness

A language-agnostic Claude Code plugin that provides a rigorous development methodology:
structured TDD loop, `plans/` state machine, harness gates, structured review, and CI scaffold.

Works with Node/TypeScript, Ruby, Python, Go, Rust, or any stack.

---

## Install

**Claude Code (plugin — recommended):**

```bash
# Start Claude Code in your project
claude

# Add the marketplace & install
/plugin marketplace add steffansluis/dev-harness
/plugin install dev-harness@dev-harness-marketplace

# Initialize your project
/harness-setup
```

**Claude Code (manual):**

```bash
git clone https://github.com/steffansluis/dev-harness ~/.claude/plugins/dev-harness
```

**Claude.ai:**

1. Download or clone this repo
2. Zip the `skills/` folder
3. Open Claude.ai → Settings → Capabilities → Skills → Upload skill

---

## Quick Start

After installing, open any project in Claude Code and run:

```
/harness-setup          # scaffold plans/, generate CI config, print .gitignore checklist
/harness-init           # generate harness/ directory (work.md, review.md, release.md, gates/)
/harness-plan           # add tasks with acceptance criteria to the active phase
/harness-cycle          # full loop: TDD → review → fix → commit (primary day-to-day command)
/harness-work           # TDD loop only (Red → Green → Refactor → Gate), no auto-commit
/harness-review         # structured review only — use between phases or on specific diffs
/harness-ci             # generate or audit CI config
/harness-reflect        # retrospective: propose amendments to harness gates
```

**First time on a new project:**

```
/harness-setup --paradigm api-service
```

This detects your stack, scaffolds `plans/phase-1.md`, generates CI, and pre-selects the
appropriate gate set — ready to start your first task in under 5 minutes.

---

## Skills

### `/harness-cycle`
The primary day-to-day command. Runs the full development cycle for the next `cc:TODO` task:
1. **TDD loop** — Red → Green → Refactor → Gate (lint + tests)
2. **Review** — Security, Performance, Quality perspectives
3. **Fix loop** — if REQUEST_CHANGES, fixes issues and re-reviews (up to 3 iterations)
4. **Commit** — marks `cc:done` and commits on APPROVE

Use `/harness-cycle` for normal development. Use the individual skills when you need
isolated control — e.g. `/harness-work` alone to implement without auto-committing, or
`/harness-review` alone to review a branch diff.

### `/harness-setup`
Scaffolds a development harness for a new or existing project. Creates the `plans/` directory,
generates `.github/workflows/ci.yml` for your stack, and prints a `.gitignore` checklist.
Accepts `--paradigm <name>` to pre-select the gate set.

### `/harness-init`
Generates the `harness/` directory with `work.md`, `review.md`, `release.md`, and `gates/` —
tailored to your detected stack and optional `--paradigm` flag.

**Available paradigms:** `web-app` · `api-service` · `cli-tool`

### `/harness-plan`
Manages the `plans/` task state machine. Adds tasks with acceptance criteria, warns on WIP
overload, and tracks `cc:TODO → cc:WIP → cc:done` transitions.

### `/harness-work`
Executes the next `cc:TODO` task using the TDD loop:
1. **Red** — write failing test
2. **Green** — minimum code to pass
3. **Refactor** — clean up
4. **Gate** — lint + tests must both pass before `cc:done`

Stack-aware: reads `package.json`, `Gemfile`, `go.mod`, etc. to detect lint and test commands.

### `/harness-review`
Structured code review from four perspectives:
- **Security** — injection, XSS, credential exposure, input validation
- **Performance** — N+1, recomputation, memory leaks
- **Quality** — naming, SRP, error handling, cross-reference correctness
- **Accessibility** — ARIA, keyboard nav, colour contrast (web/mobile only)

Outcome: **APPROVE** (commit offered) or **REQUEST_CHANGES** (issues listed).

### `/harness-ci`
Generates a full lint → test+coverage → build → smoke-test → acceptance CI pipeline,
mapping enabled harness gates to their CI steps. Or audits an existing config against a checklist.

### `/harness-reflect`
Runs a structured retrospective: reads `harness/`, asks five feedback questions, and proposes
targeted diff-format amendments to gate files — applied only after explicit acceptance.

---

## plans/ Format

```markdown
# Phase N — Phase Name

| # | Task | AC | Status |
|---|------|----|--------|
| N.1 | Task description | AC: One sentence user-visible outcome | cc:TODO |
| N.2 | Task description | AC: One sentence user-visible outcome | cc:WIP |
| N.3 | Task description | AC: One sentence user-visible outcome | cc:done |
```

Status values: `cc:TODO` → `cc:WIP` → `cc:done`

`plans/index.md` lists all phases with `active` / `complete` / `upcoming` status.

---

## Methodology

See [METHODOLOGY.md](./METHODOLOGY.md) for the full methodology guide, including:
- What a development harness is and why it matters for AI-assisted development
- The TDD loop and `plans/` state machine
- Patterns of failure to avoid (silent correctness failures, accepted constraints)
- The known Node+bun gotcha (`bun run test` vs `bun test`)

---

## Acknowledgments

Inspired by [claude-code-harness](https://github.com/Chachamaru127/claude-code-harness) by Chachamaru.

---

## License

MIT
