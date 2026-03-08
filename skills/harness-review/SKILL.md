---
name: harness-review
description: Structured multi-perspective code review (Security, Performance, Quality, Accessibility). Run between phases or after completing a feature.
triggers:
  - review
  - harness-review
  - check my code
  - code review
  - phase review
  - review this
---

# harness-review

You perform a structured multi-perspective review of recent changes. Follow these steps.

---

## Step 1: Get the Diff

Run:
```bash
git diff HEAD~1 --stat
git diff HEAD~1 -- <changed files>
```

If the user wants to review a specific set of changes (e.g. a branch):
```bash
git diff main...HEAD --stat
git diff main...HEAD
```

Read every changed file in full if the diff is not sufficient for context.

---

## Step 2: Determine Project Type

Read `package.json`, `Gemfile`, `go.mod`, or `Cargo.toml` to determine the project type.

This affects which review dimensions apply:
- **Web / mobile projects** (React, React Native, Rails views, Django templates): all 4 dimensions
- **CLI / API / library projects** (no user-facing UI): skip Accessibility dimension

---

## Step 3: Review from 4 Perspectives

Evaluate each perspective systematically. For each finding, record:
- Severity: **CRITICAL** / **IMPORTANT** / **MINOR** / **INFO**
- File + line number (where applicable)
- What the issue is
- What the fix is

### Perspective 1: Security

All stacks:
- SQL injection: raw string interpolation in queries? Use parameterised queries / ORM
- Command injection: user input passed to shell commands?
- XSS: user-controlled content rendered as raw HTML?
- Credential exposure: secrets, API keys, tokens hard-coded or logged?
- Input validation: are inputs validated at system boundaries (user input, external APIs)?
- Path traversal: file paths derived from user input without sanitisation?
- IDOR: can a user access resources belonging to another user?
- Dependency vulnerabilities: newly added packages with known CVEs?

### Perspective 2: Performance

All stacks:
- N+1 queries: does a loop execute queries inside it? Use eager loading / batch queries
- Unnecessary recomputation: values recomputed on every render/request that could be cached?
- Memory leaks: event listeners, timers, subscriptions created but never cleaned up?
- Large payloads: unbounded data returned from API or loaded into memory?
- Blocking operations: synchronous I/O on the main thread?

React / React Native specific:
- Missing `useMemo` / `useCallback` for expensive computations in components
- Re-renders caused by inline object/function literals in JSX props

### Perspective 3: Quality

All stacks:
- **Naming**: do function, variable, and type names communicate intent clearly?
- **Single responsibility**: does each function/class do one thing?
- **Error handling**: are errors caught and handled meaningfully? No silent swallows
- **Test coverage**: are new code paths covered by tests? Check for gaps in branches
- **Accepted constraints**: are unresolved environment constraints tracked in Plans.md or comments?
- **Cross-references**: does documentation/README/comments match the implementation?
  - Filenames referenced in documentation exist
  - Behaviour descriptions in comments match actual code behaviour
  - Constants shared between tests and docs use a single source of truth
- **Generated output**: if a new tool was introduced, is its output in `.gitignore`?

### Perspective 4: Accessibility (web / mobile only — skip for CLI/API)

React Native:
- Interactive elements have `accessibilityRole` set (button, checkbox, link, etc.)
- State-bearing elements have `accessibilityState` (checked, disabled, selected, expanded)
- Images have `accessibilityLabel` or `accessible={false}` for decorative images
- Touch targets are at least 44×44 pts
- Text colour has sufficient contrast against background (WCAG AA: 4.5:1 for normal text)

Web (HTML/React):
- Interactive elements are keyboard-navigable (focusable, logical tab order)
- Form inputs have associated `<label>` elements
- Images have `alt` text or `aria-hidden="true"` for decorative images
- Colour is not the only means of conveying information
- Dynamic content updates are announced via `aria-live` where appropriate

---

## Step 4: Output

Format the review as:

```
## Harness Review

**Outcome: APPROVE** or **Outcome: REQUEST_CHANGES**

### Security
| Severity | File | Finding | Fix |
|----------|------|---------|-----|
| CRITICAL | src/api.ts:42 | User input interpolated into SQL query | Use parameterised query |
| INFO     | — | No issues found | — |

### Performance
| Severity | File | Finding | Fix |
|----------|------|---------|-----|
| IMPORTANT | src/RolesList.tsx:18 | Inline object literal in JSX prop causes unnecessary re-renders | Extract to constant or useMemo |

### Quality
| Severity | File | Finding | Fix |
|----------|------|---------|-----|
| IMPORTANT | src/hooks/useCompleteTask.ts:55 | Error handler swallows failure without resetting `completing` state | Add `setCompleting(false)` in catch block |

### Accessibility
| Severity | File | Finding | Fix |
|----------|------|---------|-----|
| IMPORTANT | app/onboarding.tsx:33 | Role chip Pressable missing accessibilityRole and accessibilityState | Add `accessibilityRole="checkbox"` and `accessibilityState={{ checked }}` |
```

**Outcome rules:**
- **APPROVE** — zero CRITICAL or IMPORTANT findings; MINOR/INFO findings listed but do not block
- **REQUEST_CHANGES** — one or more CRITICAL or IMPORTANT findings

---

## Step 5: After Review

**If APPROVE:**
Offer to commit the changes:
```
git add -A
git commit -m "<type>: <description>"
```
Unless the user passes `--no-commit`.

**If REQUEST_CHANGES:**
List the issues clearly. The user should run `/harness-work` to fix each issue.
After fixes, re-run `/harness-review`.

---

## Notes

- This review is a complement to automated tools, not a replacement. It catches what
  automation cannot: wrong comments, incorrect assumptions, missing semantic attributes,
  documentation drift.
- Be specific and actionable. "Consider refactoring" is not a finding. "Function X does Y
  and Z; extract Z into its own function" is a finding.
- Do not flag stylistic preferences as IMPORTANT. Reserve IMPORTANT for bugs, security issues,
  accessibility blockers, and correctness problems.
