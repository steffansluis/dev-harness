# Release Constraints

Defines the conditions for a commit or release to be considered complete.
A commit is not complete until all local gates pass. A release is not complete
until all remote CI gates pass and the changelog and version are updated.

---

## Commit Checklist

A commit is ready when:

- [ ] All `cc:done` tasks in the current batch have passing lint + tests + coverage
- [ ] `/harness-review` returned APPROVE (no CRITICAL or IMPORTANT findings)
- [ ] Commit message follows the project convention (`type: description`)
- [ ] No generated output (coverage/, dist/, reports/) is staged
- [ ] `.gitignore` updated if new generated-output directories were introduced

---

## Remote Gates

**Remote gates** run in CI or on PR open — not on the developer's machine. They are slower
than local gates (build, acceptance suite, visual diffs) and gate merging to `main`, not
`cc:done`. See `harness/work.md` for the local gate contract.

CI runs remote gates in dependency order. Each gate must pass before the next starts:

```
lint  →  test + coverage  →  build  →  smoke-test  →  acceptance tests  →  screenshot diff
```

| Gate | Trigger | Artefact produced |
|------|---------|-------------------|
| lint | push (all branches) | lint report (exit code) |
| test + coverage | push (all branches) | `coverage/` directory |
| build | push (all branches) | `dist/` directory |
| smoke-test | push (all branches) | server reachability (curl exit code) |
| acceptance tests | push to main / PR open | `e2e/report/`, screenshots |
| screenshot diff | PR open (UI projects only) | diff images, visual regression report |

**Rules:**
- CI runs on all branches, not just `main` — catch failures before the PR is opened
- Run a smoke test (`curl -f http://localhost:<port>/`) before acceptance tests to fail fast
  if the server is broken, rather than letting the entire acceptance suite time out
- Upload coverage, dist, and e2e/report as CI artefacts with meaningful retention periods
- A broken CI gate blocks merging to `main`

---

## Changelog

Update `CHANGELOG.md` before tagging a release:

- Follow [Keep a Changelog](https://keepachangelog.com) format
- Group entries under: `Added`, `Changed`, `Fixed`, `Removed`, `Security`
- Each entry references the task number (e.g. `[2.3]`) or PR number
- The `Unreleased` section accumulates entries; move to a version heading on release

---

## Version Bump

Follow [Semantic Versioning](https://semver.org):

| Change type | Version increment |
|-------------|------------------|
| Breaking change to public API | Major (`x.0.0`) |
| New backward-compatible feature | Minor (`0.x.0`) |
| Bug fix, documentation, internal refactor | Patch (`0.0.x`) |

Steps:
1. Update the version field in `package.json` / `Cargo.toml` / `pyproject.toml` / etc.
2. Move the `CHANGELOG.md` `Unreleased` section to the new version heading
3. Tag the commit: `git tag v<version>`
4. Push the tag: `git push origin v<version>`
