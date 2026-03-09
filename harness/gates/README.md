# Gates

A gate is a named check that must pass before a task, phase, or release can advance.
Gates can be local (run on the developer's machine) or remote (run in CI or on PR open).

Each gate file in this directory defines:
- What the gate checks
- When it runs (local / remote / both)
- What constitutes a pass or fail

---

## Available Gates

| Gate file | What it checks | Runs | Enabled by default |
|-----------|---------------|------|-------------------|
| [design.md](design.md) | Design artefact linked before `cc:WIP` | local | opt-in |
| [readme.md](readme.md) | `README.md` updated when public API surface changes | both | opt-in |
| [acceptance.md](acceptance.md) | At least one e2e test per feature task | remote | opt-in |
| [screenshots.md](screenshots.md) | Before/after screenshots linked for UI tasks | remote | opt-in |
| [i18n.md](i18n.md) | User-visible strings wrapped in localisation helper | both | opt-in |

---

## Gate Contract

A gate **passes** when its check exits with code 0.
A gate **fails** when its check exits non-zero or produces the defined failure output.
A failing gate blocks the associated transition (`cc:WIP → cc:done`, phase completion, or release).
