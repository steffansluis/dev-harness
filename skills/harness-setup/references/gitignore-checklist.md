# .gitignore Checklist for Generated Output

**Rule:** Add generated-output directories to `.gitignore` in the **same commit** as
the tool that generates them — before running the tool for the first time.

---

## Universal (all projects)

```gitignore
# Dependencies
node_modules/
vendor/
.venv/
__pycache__/

# Test output
coverage/
.coverage
htmlcov/
test-results/
*.lcov

# Build output
dist/
build/
out/
target/
bin/
obj/

# Editors and OS
.DS_Store
Thumbs.db
*.swp
.idea/
.vscode/
```

---

## Node / TypeScript

```gitignore
# Expo / React Native
.expo/
web-build/
android/
ios/

# Build
dist/
.next/
.nuxt/
.output/
```

---

## Playwright / E2E Testing

```gitignore
# Playwright
e2e/report/
e2e/screenshots/
playwright-report/
test-results/
```

Note: Only add `e2e/screenshots/` here if you are NOT committing screenshots to the repo.
If screenshots are committed as living documentation, remove that line.

---

## CI Artifacts (local dev)

These are uploaded as CI artifacts and should never be committed:

```gitignore
# CI artifacts (uploaded separately)
coverage/
dist/
e2e/report/
playwright-report/
```

---

## Verification

After adding to `.gitignore`, confirm with:

```bash
git status  # should not show generated dirs as untracked
git check-ignore -v coverage/ dist/ e2e/report/  # should show matched rule
```
