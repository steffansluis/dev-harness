# Gate: Design Artefact

A design artefact (mockup, wireframe, spec, or Figma link) must be linked in the task row
before a task moves to `cc:WIP`. Prevents implementation starting without a shared visual
or written specification to verify against.

**Enabled:** opt-in — add this gate when your project requires design sign-off before coding.

---

## What It Checks

When a task transitions from `cc:TODO` to `cc:WIP`, the task row in the active
`plans/phase-N.md` must contain a link or reference to a design artefact. Accepted forms:

- A URL to a Figma frame, Notion doc, or hosted spec: `[Design](https://...)`
- A relative path to a local spec file: `[Spec](docs/design/feature-x.md)`
- An inline note referencing a named artefact: `Design: Feature X spec v2`

The gate fails when the task row contains no such reference and the task is being
moved to `cc:WIP`.

---

## Pass

The task row in `plans/phase-N.md` contains a linked or named design artefact before
the task is marked `cc:WIP`.

## Fail

A task is marked `cc:WIP` with no design artefact linked in its task row and the design
gate is enabled. CI fails the `cc:WIP` transition check with:

```
Design gate: task N.X has no linked design artefact.
Add a mockup, spec link, or Figma URL to the task row before marking cc:WIP.
```

---

## Skipping

If a task is a bug fix, chore, or refactor — not a new user-visible feature — the design
gate may be skipped by adding `[no-design]` to the task row and a brief justification.
