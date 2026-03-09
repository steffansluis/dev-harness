# Gates

A gate is a named check that must pass before a task, phase, or release can advance.
Gates can be local (run on the developer's machine) or remote (run in CI or on PR open).

Each gate file in this directory defines:
- What the gate checks
- When it runs (local / remote / both)
- What constitutes a pass or fail

---

## Available Gates

_(Gates are added here as they are defined in Phase 3.)_

---

## Gate Contract

A gate **passes** when its check exits with code 0.
A gate **fails** when its check exits non-zero or produces the defined failure output.
A failing gate blocks the associated transition (`cc:WIP → cc:done`, phase completion, or release).
