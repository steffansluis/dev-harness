---
name: harness-release
description: Prepares a versioned release: generates a CHANGELOG entry from git commits, proposes a semver tag, bumps plugin.json version, and prints a GitHub Release checklist. Use this whenever the user wants to cut a release, tag a version, or publish — 'harness-release', 'cut a release', 'tag this version', 'bump the version', 'prepare a release', 'create a changelog'. Trigger this for any request about releasing or tagging a new version — even without naming the skill. Do not use for planning work (use harness-plan) or reviewing code (use harness-review).
triggers:
  - harness-release
  - cut a release
  - tag a version
  - bump the version
  - prepare a release
  - create a changelog
license: MIT
compatibility: Claude Code, Claude.ai
metadata:
  author: dev-harness
  version: 1.0.0
  category: productivity
  tags: [release, changelog, versioning, git, publishing]
---

# harness-release

You prepare a versioned release for the project. Follow these steps in order.

---

## Step 1: Determine the Next Version

Read `.claude-plugin/plugin.json` (or `package.json` if no plugin.json exists) to get the
current version.

Ask the user which semver bump to apply if not specified:

- **patch** (x.y.Z+1) — bug fixes, doc updates, minor tweaks
- **minor** (x.Y+1.0) — new skills, new features, backwards-compatible
- **major** (X+1.0.0) — breaking changes to skill APIs or workflow

Propose the next version number. Wait for confirmation before proceeding if the bump type
was not supplied by the user.

---

## Step 2: Generate CHANGELOG Entry

Run:
```bash
git log --oneline <last-tag>..HEAD
```

If no tags exist yet, use:
```bash
git log --oneline
```

Group commits by type prefix:
- `feat:` → **Added**
- `fix:` → **Fixed**
- `refactor:`, `chore:` → **Changed**
- `docs:` → **Documentation**
- `test:` → skip (internal)

Output a CHANGELOG entry in Keep a Changelog format:

```markdown
## [X.Y.Z] — YYYY-MM-DD

### Added
- ...

### Fixed
- ...

### Changed
- ...
```

---

## Step 3: Update plugin.json

Update the `version` field in `.claude-plugin/plugin.json` to the new version number.

Confirm the change with the user before writing if the version bump is major.

---

## Step 4: Update CHANGELOG.md

If `CHANGELOG.md` exists, prepend the new entry after the `# Changelog` heading.
If `CHANGELOG.md` does not exist, create it with the new entry as the first release.

---

## Step 5: Print GitHub Release Checklist

```
Release checklist — vX.Y.Z

  [ ] Verify all Phase tasks are cc:done in plans/
  [ ] Gate passes: bash skills/*.test.sh
  [ ] plugin.json version updated to X.Y.Z
  [ ] CHANGELOG.md entry added
  [ ] Commit: git add .claude-plugin/plugin.json CHANGELOG.md
              git commit -m "chore: bump version to X.Y.Z"
  [ ] Tag:    git tag vX.Y.Z
  [ ] Push:   git push && git push --tags
  [ ] GitHub Release: gh release create vX.Y.Z --title "vX.Y.Z" --notes-from-tag
  [ ] Reinstall plugin in Claude Code:
              /plugin uninstall dev-harness
              /plugin install dev-harness@dev-harness-marketplace
```

---

## Common Issues

**Error:** `git log <last-tag>..HEAD` returns nothing.
**Cause:** The tag does not exist locally or no commits since the tag.
**Solution:** Run `git tag` to check existing tags. If none, use the full git log.

**Error:** Commits have no type prefix (`feat:`, `fix:`, etc.).
**Cause:** Commit messages don't follow Conventional Commits.
**Solution:** Group untyped commits under **Changed** and note the missing convention.

**Error:** User wants to release mid-phase (some tasks still `cc:TODO`).
**Cause:** Releasing before a phase is complete.
**Solution:** Warn the user, list the incomplete tasks, and confirm they want to proceed.

---

## Examples

### Example 1: Minor release after Phase 10

User says: "harness-release"

Actions:
1. Read `plugin.json` → current version is `1.1.0`
2. Propose `1.2.0` (minor — new harness-release skill added)
3. Run `git log v1.1.0..HEAD --oneline` → 6 commits
4. Group: Added (harness-release skill), Changed (description updates)
5. Prepend CHANGELOG.md entry for `1.2.0`
6. Update `plugin.json` version to `1.2.0`
7. Print release checklist with exact git tag and gh release commands

Result: User has a CHANGELOG entry, updated plugin.json, and a step-by-step checklist to tag and publish the release.

---

## Notes

- This skill does not push or tag automatically — the checklist keeps the user in control.
- After reinstalling, ask the user to verify the new skill appears with `/plugin list`.
- If the project uses a flat `version` field in `package.json` instead of `plugin.json`,
  update that file instead and adjust the reinstall instruction accordingly.
