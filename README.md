# dev-harness

A language-agnostic Claude Code plugin that provides a rigorous development methodology:
Plans.md state machine, TDD loop, structured review gates, and CI scaffold.

Works with Node/TypeScript, Ruby, Python, Go, Rust, or any stack.

---

## Install

```bash
# Install from GitHub (once published)
claude plugin install steffan/dev-harness

# Install from local path (for development or testing)
claude plugin install /path/to/dev-harness
```

---

## Quick Start

After installing, in any project:

```
/harness-setup     # scaffold Plans.md, generate CI, print .gitignore checklist
/harness-plan      # add tasks with acceptance criteria
/harness-work      # execute next task (TDD loop: Red → Green → Refactor → Gate)
/harness-review    # structured review (Security / Performance / Quality / Accessibility)
/harness-ci        # generate or audit CI config
```

---

## Skills

### `/harness-setup`
Detects your stack, creates `Plans.md` from template, generates `.github/workflows/ci.yml`
for your language, and prints a `.gitignore` checklist of generated-output directories.

### `/harness-plan`
Manages the Plans.md state machine. Adds tasks with acceptance criteria, warns on WIP overload,
and tracks `cc:TODO → cc:WIP → cc:done` transitions.

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
- **Quality** — naming, SRP, error handling, cross-reference correctness, generated artifacts
- **Accessibility** — ARIA, keyboard nav, colour contrast (web/mobile projects only)

Outcome: **APPROVE** (auto-commit offered) or **REQUEST_CHANGES** (specific issues listed).

### `/harness-ci`
Generates a full lint → test+coverage → build → smoke-test → acceptance CI pipeline.
Or audits an existing CI config against a checklist.

---

## Methodology

See [METHODOLOGY.md](./METHODOLOGY.md) for the full methodology guide, including:
- What a development harness is and why it matters for AI-assisted development
- The TDD loop and Plans.md state machine
- Patterns of failure to avoid (silent correctness failures, accepted constraints, generated
  artifacts in git, stale cross-references)
- The known Node+bun gotcha (`bun run test` vs `bun test`)

---

## Plans.md Format

```markdown
## Phase N — Phase Name

| # | Task | AC | Status |
|---|------|----|--------|
| N.1 | Task description | AC: One sentence user-visible outcome | cc:TODO |
| N.2 | Task description | AC: One sentence user-visible outcome | cc:WIP |
| N.3 | Task description | AC: One sentence user-visible outcome | cc:done |
```

Status values: `cc:TODO` → `cc:WIP` → `cc:done`

---

## Reference Implementation

[lifetodo](https://github.com/steffan/lifetodo) — a gamified household task app built with
Expo + React Native + bun across 6 phases using this methodology. The full retrospective
is in `HARNESS_ENGINEERING.md` in that repository.

---

## License

MIT
