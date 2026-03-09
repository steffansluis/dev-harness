# Review Constraints

Specifies the review gates that run between phases. Run `/harness-review` after all tasks
in a phase are `cc:done` and before starting the next phase.

---

## When to Run

- After every phase is fully `cc:done`
- Before starting the next phase
- Optionally mid-phase after a large or risky task

---

## Outcome

Every review produces one of two outcomes:

- **APPROVE** — zero CRITICAL or IMPORTANT findings; MINOR/INFO items listed but do not block
- **REQUEST_CHANGES** — one or more CRITICAL or IMPORTANT findings; must be resolved and re-reviewed

---

## Severity Levels

| Level | Meaning |
|-------|---------|
| **CRITICAL** | Security vulnerability, data loss risk, or correctness bug — blocks immediately |
| **IMPORTANT** | Bug, accessibility blocker, or significant quality issue — must be fixed before next phase |
| **MINOR** | Naming, clarity, or small quality issue — fix recommended but does not block |
| **INFO** | Observation or suggestion — no action required |

---

## Perspectives

### 1. Security

Applies to all stacks. Check for:
- SQL injection: raw string interpolation in queries
- Command injection: user input passed to shell commands
- XSS: user-controlled content rendered as raw HTML
- Credential exposure: secrets hard-coded or logged
- Input validation: boundaries (user input, external APIs) validated
- Path traversal: file paths derived from user input without sanitisation
- IDOR: user can access resources belonging to another user
- Newly added packages with known CVEs

### 2. Performance

Applies to all stacks. Check for:
- N+1 queries: loop executing a query per iteration
- Unnecessary recomputation: values recomputed every request/render that could be cached
- Memory leaks: listeners, timers, or subscriptions created but never cleaned up
- Large unbounded payloads returned from API or loaded into memory
- Blocking synchronous I/O on the main thread

React / React Native additions:
- Missing `useMemo` / `useCallback` for expensive component computations
- Inline object/function literals in JSX props causing unnecessary re-renders

### 3. Quality

Applies to all stacks. Check for:
- **Naming**: functions, variables, and types communicate intent clearly
- **Single responsibility**: each function/class does one thing
- **Error handling**: errors caught and handled meaningfully; no silent swallows
- **Test coverage**: new code paths covered; branch gaps identified
- **Cross-references**: documentation, comments, and README match the implementation
- **Accepted constraints**: unresolved environment constraints tracked explicitly
- **Generated output**: new tools that produce output have entries in `.gitignore`

### 4. Accessibility

**Skip for CLI, API, and library projects** — applies to web and mobile (React, React Native,
Rails views, Django templates) only.

React Native:
- Interactive elements have `accessibilityRole`
- State-bearing elements have `accessibilityState`
- Images have `accessibilityLabel` or `accessible={false}`
- Touch targets ≥ 44×44 pts
- Text contrast meets WCAG AA (4.5:1 for normal text)

Web (HTML/React):
- Interactive elements are keyboard-navigable
- Form inputs have associated `<label>` elements
- Images have `alt` text or `aria-hidden="true"` for decorative images
- Colour is not the only means of conveying information
- Dynamic content updates announced via `aria-live`

---

## Review Output Format

```
## Harness Review

Outcome: APPROVE | REQUEST_CHANGES

### Security
| Severity | File | Finding | Fix |

### Performance
| Severity | File | Finding | Fix |

### Quality
| Severity | File | Finding | Fix |

### Accessibility  (omit section for CLI/API projects)
| Severity | File | Finding | Fix |
```
