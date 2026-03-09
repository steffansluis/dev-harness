---
name: harness-ci
description: Generates or audits a CI configuration for the detected stack, covering lint → test+coverage → build → smoke-test → acceptance pipeline. Maps enabled harness gates to CI steps. Use this whenever the user wants to set up, generate, or audit CI — 'generate a GitHub Actions pipeline', 'set up CI for my project', 'create CI config', 'audit my CI', 'harness-ci', 'I need a CI workflow'. Trigger this for any CI generation or audit request, even if the user just says 'I need CI for my project' without naming the skill. Do not use for initial harness scaffolding (use harness-setup).
triggers:
  - generate CI
  - setup CI
  - audit CI
  - GitHub Actions
  - harness-ci
  - fix CI
  - add CI
license: MIT
compatibility: Claude Code, Claude.ai
metadata:
  author: dev-harness
  version: 1.0.0
  category: devops
  tags: [ci, github-actions, automation, testing]
---

# harness-ci

You generate or audit CI configuration for this project. Follow these steps.

---

## Step 1: Detect the Stack

Read project root files to detect the stack (see `skills/harness-work/references/stack-detection.md`).

Record: stack, package manager, lint command, test command, build command, server start command,
e2e command, port, dist directory.

---

## Step 2: Check Existing CI

Read `.github/workflows/ci.yml` (or any files in `.github/workflows/`).

If no CI config exists → go to Step 3 (Generate).
If CI config exists → go to Step 4 (Audit).

---

## Step 2b: Read harness/gates/

If `harness/gates/` exists, read each gate file and check whether it is **enabled** for
this project (gate file contains `Enabled: default` or the project's `harness/work.md` /
`harness/release.md` explicitly lists the gate as active).

Build a list of **enabled remote gates** — gates with `Runs: remote` or `Runs: both` that
are enabled. These gates get additional CI steps added after the standard pipeline.

**Gate → CI step mapping:**

| Gate file | CI step name | Slot in pipeline | Trigger |
|-----------|-------------|-----------------|---------|
| `design.md` | `design-check` | after lint | push (all branches) |
| `readme.md` | `readme-check` | after build | push (all branches) |
| `acceptance.md` | `acceptance-tests` | after build | push to main / PR open |
| `screenshots.md` | `screenshot-diff` | after acceptance-tests | PR open only |
| `i18n.md` | `i18n-check` | after lint | push (all branches) |

Only emit a gate's CI step when that gate is enabled. If the i18n gate is enabled, add an
`i18n-check` job to the generated CI YAML after the lint job. If no optional gates are
enabled, generate the standard pipeline without extra steps.

---

## Step 3: Generate CI Config

Select the matching template from `skills/harness-setup/references/`:
- Node/TS → `ci-node.yml`
- Ruby → `ci-ruby.yml`
- Python → `ci-python.yml`
- Go → `ci-go.yml`
- Unknown/other → `ci-generic.yml`

Substitute all placeholders with the detected values.

**Always include these elements (learned from lifetodo):**

**Element 1 — Server smoke test before acceptance tests:**
```yaml
- name: Wait for server (smoke test)
  run: |
    for i in $(seq 1 30); do
      curl -sf http://localhost:<PORT>/ && echo "Server ready" && exit 0
      echo "Waiting… ($i)"
      sleep 1
    done
    echo "Server did not start in time" && exit 1
```
This step runs *before* the acceptance test runner. A broken server script fails fast (seconds)
rather than timing out across all acceptance tests (minutes).

**Element 2 — Artifact uploads for every gate output:**
- `coverage/` → `coverage-report` artifact, 30-day retention
- `dist/` → `build-${{ github.sha }}` artifact, 30-day retention
- `e2e/screenshots/` → `e2e-output-${{ github.sha }}` artifact, 90-day retention
- `e2e/report/` → `playwright-report-${{ github.sha }}` artifact, 30-day retention, `if: failure()`

**Element 3 — CI on all branches:**
```yaml
on:
  push:
  pull_request:
    branches: [main, master]
```
The `push:` with no branch filter runs CI on every push, catching failures before a PR is opened.

Write the generated config to `.github/workflows/ci.yml`.

---

## Step 4: Audit Existing CI

Check the existing CI config against this checklist. Report each item as PASS / FAIL / MISSING:

```
CI Audit Report
===============

Pipeline structure:
  [PASS/FAIL] lint job exists
  [PASS/FAIL] test + coverage job exists
  [PASS/FAIL] build job exists (if project has a build step)
  [PASS/FAIL] acceptance test job exists (if project has e2e tests)
  [PASS/FAIL] jobs run in dependency order (test after lint, build after test, e2e after build)

CI triggers:
  [PASS/FAIL] runs on push (all branches, not just master/main)
  [PASS/FAIL] runs on pull_request

Smoke test:
  [PASS/FAIL] server smoke test step exists before acceptance tests
              FAIL = acceptance tests may time out instead of failing fast on server errors

Artifacts:
  [PASS/FAIL] coverage report uploaded as artifact
  [PASS/FAIL] build output uploaded as artifact
  [PASS/FAIL] e2e screenshots/output uploaded as artifact
  [PASS/FAIL] playwright/e2e report uploaded on failure

Commands:
  [PASS/FAIL] install command matches detected package manager
  [PASS/FAIL] test command matches scripts in package.json / Gemfile / go.mod
  [PASS/FAIL] lint command matches scripts in package.json / rubocop / golangci-lint
```

For any FAIL or MISSING item, provide the specific fix.

---

## Step 5: Gitignore Check

Remind the user to verify these directories are in `.gitignore`:

```
  [ ] coverage/          (test coverage — uploaded as CI artifact, not committed)
  [ ] dist/              (build output — uploaded as CI artifact, not committed)
  [ ] e2e/report/        (Playwright report — uploaded as CI artifact, not committed)
  [ ] test-results/      (Playwright test-results/)
  [ ] playwright-report/ (alternate Playwright report dir)
```

**Rule:** If any of these directories are tracked by git, remove them from git and add them
to `.gitignore` immediately. Generated output in git creates noise in diffs and inflates
repository size.

Check with:
```bash
git ls-files coverage/ dist/ e2e/report/ test-results/ playwright-report/
# Any output means those files are tracked and should be removed
```

---

## Step 6: Web Project — Static File Server

For Node/TS projects that export a static web build (e.g. Expo + `expo export --platform web`,
Next.js static export), a custom static server with `COOP/COEP` headers may be required
if the app uses `SharedArrayBuffer` (e.g. SQLite WASM).

If the project uses `expo-sqlite` v15+, `sql.js`, or any WASM module that requires
`SharedArrayBuffer`, generate a minimal serve script at `scripts/serve-web.mjs`:

```js
#!/usr/bin/env node
// Serves dist/ with COOP/COEP headers required for SharedArrayBuffer (SQLite WASM, etc.)
import { createServer } from 'http';
import { readFileSync, statSync } from 'fs';
import { resolve, extname, join } from 'path';
import { fileURLToPath } from 'url';

const PORT = Number(process.env.PORT ?? 4173);
const DIST = resolve(fileURLToPath(import.meta.url), '../../dist');

const MIME = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'application/javascript',
  '.mjs': 'application/javascript',
  '.css': 'text/css',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.svg': 'image/svg+xml',
  '.wasm': 'application/wasm',
  '.ico': 'image/x-icon',
  '.ttf': 'font/ttf',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2',
};

function isFile(p) {
  try { return statSync(p).isFile(); } catch { return false; }
}

function resolveFile(urlPath) {
  const exact = join(DIST, urlPath);
  if (isFile(exact)) return exact;
  const withHtml = exact.replace(/\/$/, '') + '.html';
  if (isFile(withHtml)) return withHtml;
  return join(DIST, 'index.html'); // SPA fallback
}

createServer((req, res) => {
  res.setHeader('Cross-Origin-Opener-Policy', 'same-origin');
  res.setHeader('Cross-Origin-Embedder-Policy', 'require-corp');

  const filePath = resolveFile((req.url ?? '/').split('?')[0]);
  const mime = MIME[extname(filePath)] ?? 'application/octet-stream';

  try {
    const content = readFileSync(filePath);
    res.writeHead(200, { 'Content-Type': mime });
    res.end(content);
  } catch {
    if (!res.headersSent) { res.writeHead(404); res.end('Not found'); }
  }
}).listen(PORT, () => console.log(`Serving ${DIST} at http://localhost:${PORT}`));
```

**Note:** The critical bug to avoid — do NOT use `filePath === DIST` to detect root requests.
`path.join` returns a path with a trailing slash for directory matches, so the equality always
fails. Use `isFile()` checks instead.

---

## Common Issues

**Error:** Generated CI config references a test command that doesn't match `package.json`.
**Cause:** Stack detection read `scripts.test` but the project overrides the command with a workspace-level runner (e.g. `turbo test`).
**Solution:** Read `package.json` scripts carefully and prefer the exact string in `scripts.test`; do not substitute a guessed runner.

**Error:** Gate step for an enabled gate is missing from the generated CI pipeline.
**Cause:** `harness/gates/` was not read, or the gate's `Enabled:` field was not checked before emitting steps.
**Solution:** Re-read each gate file in `harness/gates/`, check `Enabled: yes` before including the corresponding CI step, and verify the gate → CI step mapping table is complete.

**Error:** Existing `ci.yml` audit reports false positives (missing steps that actually exist under a different name).
**Cause:** Step detection used a too-narrow pattern (e.g. looking for literal `run: npm run lint` instead of any lint invocation).
**Solution:** Search for the lint/test/build commands detected from the stack manifest rather than hard-coded strings.

---

## Examples

### Example 1: Generating CI for a Go project with acceptance gate enabled

User says: "harness-ci"

Actions:
1. Check `.github/workflows/ci.yml` — does not exist
2. Read `go.mod` → detect Go stack; lint: `go vet ./...`, test: `go test ./...`
3. Read `harness/gates/acceptance.md` → `Enabled: yes`, `Runs: remote`
4. Generate `ci.yml` with lint → test → acceptance steps; skip screenshot and i18n steps (not enabled)

Result: User sees a new `.github/workflows/ci.yml` with correctly mapped steps and a note on what to customise (e.g. Go version, environment variables).
