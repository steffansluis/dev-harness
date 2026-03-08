# Development Harness Methodology

Distilled from `HARNESS_ENGINEERING.md` — the full retrospective from the lifetodo project
(Expo + React Native, 6 phases, TDD throughout).

---

## 1. What Is a Development Harness?

A development harness is the scaffolding that makes an agent's output verifiable, correctable,
and consistent across time. It is **not** the code being produced — it is the system of
constraints, feedback loops, and automation that governs *how* code is produced and *what counts
as done*.

In an AI-assisted workflow, harness engineering matters more than in human-only development:

- AI output is high-velocity but fails in subtle, non-obvious ways
- Without gates, errors compound silently across phases
- The agent has no memory of its own mistakes without external records
- Structured review and automated verification catch what the agent cannot self-correct

---

## 2. The TDD Loop

Every task follows this cycle. No business logic is written without a failing test first.

```
Red    → Write a failing test that defines the expected behaviour
Green  → Write the minimum code to make the test pass
Refactor → Clean up; keep tests green
Gate   → Run lint + tests; both must pass before marking cc:done
```

**Rules:**
- Every file of business logic has a corresponding test file (`foo.ts` → `foo.test.ts`)
- Tests live next to source, not in a separate `test/` tree
- Coverage gate: 80% lines/branches minimum (enforced in CI and locally)
- No phase completion without passing lint + tests + coverage threshold

---

## 3. Plans.md as a State Machine

`Plans.md` is the single source of truth for project state. Each task moves through exactly
three states:

```
cc:TODO  →  cc:WIP  →  cc:done
```

**Table format** (AC column is required):

```markdown
## Phase N — Phase Name

| # | Task | AC | Status |
|---|------|----|--------|
| N.1 | Task description | AC: One sentence user-visible outcome | cc:TODO |
| N.2 | Task description | AC: One sentence user-visible outcome | cc:TODO |
```

**Acceptance criteria rules:**
- One sentence, user-visible outcome ("User sees…", "App stores…", "CI fails when…")
- Not a test criterion — a behaviour criterion
- Required for every task; `—` is a placeholder that must be filled before marking cc:WIP
- Warn when 3+ tasks are cc:WIP simultaneously

**Status markers:**
- `cc:TODO` — not started
- `cc:WIP` — in progress (only one or two tasks at a time)
- `cc:done` — lint + tests pass, AC verified

---

## 4. Review Gates

Run `/harness-review` between phases. The review catches what automation cannot:

- Missing error handling
- Incorrect assumptions in test data
- Missing accessibility attributes
- Latent UX issues (e.g. silent truncation)
- Documentation that has drifted from implementation

**Review perspectives:**
1. **Security** — SQL injection, XSS, credential exposure, input validation
2. **Performance** — N+1 queries, unnecessary recomputation, memory leaks
3. **Quality** — naming, single responsibility, test coverage, error handling
4. **Accessibility** — ARIA attributes, keyboard nav, colour contrast (web/mobile only)

**Gate outcome:** APPROVE or REQUEST_CHANGES. REQUEST_CHANGES lists specific issues that must
be resolved before advancing to the next phase.

---

## 5. Patterns of Failure to Avoid

### Silent Correctness Failures
Test fixtures using literal values (timestamps, magic numbers, assumed initial states) pass
all checks while being semantically wrong.

**Rule:** Hard-code test fixtures against the production code's source of truth, not parallel
magic values. When a value appears in both test and documentation, one must be the canonical
source.

### Accepted Constraints Silently Carried
An environment constraint (e.g. test runner incompatibility) was identified in Phase 2 and
carried silently through all six phases. Hook tests and component tests never ran.

**Rule:** When a constraint is accepted rather than resolved, track it explicitly — as a
Plans.md task with `cc:TODO`, or as a known issue comment in CI output. Never silently tolerate
unverified surface area.

### Generated Artifacts in Git
Playwright reports, coverage output, and build artifacts were committed because `.gitignore`
was not updated before the first tool run.

**Rule:** Every tool introduction must include updating `.gitignore` in the same commit.
Add the generated-output directory to `.gitignore` before running the tool for the first time.

### Stale Cross-References
A screenshot was renamed; the README reference was not updated. A CI comment described behaviour
that had changed.

**Rule:** When a constant (filename, URL, behaviour description) appears in more than one place,
one place must be the source of truth. Constants shared between test and documentation; CI steps
that test the behaviour they describe.

---

## 6. Known Stack Gotcha: Node + bun

When the package manager is **bun** and the test script routes to **Jest** (common in
React Native / Expo projects), always use:

```
bun run test        # correct — routes to the package.json script → jest
bun run lint        # correct — routes to the package.json script → eslint
```

Not:

```
bun test            # WRONG — invokes bun's native test runner, which cannot
                    # parse react-native's Flow `import typeof` syntax
```

The package.json script (`"test": "jest"`) routes through Jest properly. Bun's native runner
skips this routing and fails on Flow types in `node_modules/react-native/index.js`.

---

## 7. CI Pipeline Structure

A well-structured CI pipeline runs gates in dependency order:

```
lint → test+coverage → build → smoke-test → acceptance-tests
```

**Critical additions (learned from lifetodo):**

1. **Smoke test before acceptance tests**: Run `curl -f http://localhost:<port>/` as a CI step
   *before* the acceptance test runner starts. A broken server script fails fast with a clear
   error instead of making the entire acceptance suite time out.

2. **Artifacts for every gate output**: Upload `coverage/`, `dist/`, `e2e/screenshots/`, and
   `e2e/report/` (on failure) as CI artifacts with meaningful retention periods.

3. **CI on all branches, not just master**: PR branches need CI too. Add `on: push` (not just
   `on: pull_request`) to catch failures before the PR is even opened.

---

## 8. Accessibility as a First-Class Review Dimension

ARIA attributes (`accessibilityRole`, `accessibilityState`) were caught in review and then
verified by Playwright acceptance tests using `getByRole`. The review and the tests were
complementary: review required them, tests confirmed they worked.

For web and mobile projects, treat accessibility as non-negotiable in the review gate.
For CLI and API projects, skip this dimension.

---

## Reference Implementation

The lifetodo project (Expo + React Native + bun) is the reference implementation of this
methodology. The complete retrospective is in `HARNESS_ENGINEERING.md` in that repository.
