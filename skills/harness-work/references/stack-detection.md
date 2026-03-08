# Stack Detection Reference

Use this reference when `/harness-work` or `/harness-ci` needs to determine the project's
stack, package manager, test runner, and lint command.

---

## Detection Order

Check these files in order. Stop at the first match.

### 1. `package.json` → Node / TypeScript / JavaScript

```js
// Read package.json and extract:
const pkg = JSON.parse(readFileSync('package.json'));

const packageManager = pkg.packageManager ?? 'npm'; // e.g. "bun@1.x", "npm", "yarn@4.x"
const testScript    = pkg.scripts?.test;             // e.g. "jest", "vitest run", "bun test"
const lintScript    = pkg.scripts?.lint;             // e.g. "eslint . --max-warnings 0"
const framework     = detectFramework(pkg.dependencies, pkg.devDependencies);
```

**Package manager detection:**
- `packageManager` starts with `bun` → bun (`bun install`, `bun run <script>`)
- `packageManager` starts with `yarn` → yarn (`yarn install`, `yarn <script>`)
- `packageManager` starts with `pnpm` → pnpm (`pnpm install`, `pnpm run <script>`)
- Otherwise → npm (`npm ci`, `npm run <script>`)
- Fallback: check for lockfile — `bun.lockb`, `yarn.lock`, `pnpm-lock.yaml`, `package-lock.json`

**CRITICAL — bun + jest interop:**
If package manager is bun AND `scripts.test` routes to jest (contains "jest"), always invoke
tests as `bun run test`, never as `bun test`. Reason: bun's native test runner cannot parse
react-native's Flow `import typeof` syntax in `node_modules/react-native/index.js`. The `bun run`
prefix routes through the package.json script entry, which calls jest directly.

```
# CORRECT
bun run test
bun run lint
bun run test:coverage

# WRONG (when test script routes to jest)
bun test
bun jest
```

**Framework detection (from dependencies):**
| Dependency present | Framework |
|--------------------|-----------|
| `expo` | Expo / React Native |
| `react-native` (without expo) | React Native CLI |
| `next` | Next.js |
| `vite` | Vite (SPA or SSR) |
| `@nestjs/core` | NestJS |
| `express` or `fastify` | Node API |
| `electron` | Electron |

**Test runner detection (from devDependencies):**
| Dependency present | Test runner | Test command |
|--------------------|-------------|--------------|
| `jest` or `jest-expo` | Jest | `bun run test` / `npm run test` |
| `vitest` | Vitest | `bun run test` / `npm run test` |
| `@playwright/test` | Playwright | `bun run test:e2e` |
| `mocha` | Mocha | `bun run test` / `npm run test` |
| None / unknown | Use scripts.test as-is | `npm run test` |

---

### 2. `Gemfile` → Ruby

**Test runner:**
```ruby
# Gemfile
gem 'rspec-rails'  → bundle exec rspec
gem 'minitest'     → bundle exec rails test
# no test gem      → ruby -Itest test/**/*_test.rb
```

**Lint:**
```ruby
gem 'rubocop'      → bundle exec rubocop --no-color --format progress
gem 'standardrb'   → bundle exec standardrb
```

**Commands:**
```bash
bundle install   # install
bundle exec rspec                    # test (RSpec)
bundle exec rails test               # test (Minitest / Rails)
bundle exec rubocop --no-color       # lint
```

---

### 3. `go.mod` → Go

```bash
go mod download   # install (or go mod tidy)
go test ./...     # test
go test -coverprofile=coverage.out ./...  # test + coverage
go vet ./...      # basic lint (always available)
golangci-lint run # extended lint (check for .golangci.yml or golangci-lint binary)
```

**Coverage check:**
```bash
go tool cover -func=coverage.out | grep total
# Parse the percentage; fail if below 80%
```

---

### 4. `Cargo.toml` → Rust

```bash
cargo build       # install / build check
cargo test        # test
cargo test --all  # test all workspace members
cargo clippy -- -D warnings   # lint (treat warnings as errors)
cargo fmt --check              # format check
```

Coverage: use `cargo tarpaulin --out Html` if tarpaulin is installed.

---

### 5. `pyproject.toml` or `requirements.txt` → Python

**Package manager:**
- `pyproject.toml` with `[tool.poetry]` → poetry (`poetry install`, `poetry run <cmd>`)
- `pyproject.toml` with `[build-system]` using `hatchling`/`flit` → pip (`pip install -e .`)
- `requirements.txt` only → pip (`pip install -r requirements.txt`)
- `Pipfile` → pipenv (`pipenv install`, `pipenv run <cmd>`)

**Test runner:**
```python
# pyproject.toml or requirements.txt contains:
pytest → pytest --cov --cov-fail-under=80
unittest (stdlib, no dep) → python -m unittest discover
```

**Lint:**
```python
ruff    → ruff check .
flake8  → flake8 .
pylint  → pylint src/
```

---

## Summary Table

| File found | Stack | Install | Test | Lint |
|-----------|-------|---------|------|------|
| `package.json` (bun) | Node/TS | `bun install` | `bun run test` | `bun run lint` |
| `package.json` (npm) | Node/TS | `npm ci` | `npm run test` | `npm run lint` |
| `package.json` (yarn) | Node/TS | `yarn install` | `yarn test` | `yarn lint` |
| `Gemfile` (rspec) | Ruby | `bundle install` | `bundle exec rspec` | `bundle exec rubocop` |
| `Gemfile` (minitest) | Ruby | `bundle install` | `bundle exec rails test` | `bundle exec rubocop` |
| `go.mod` | Go | `go mod download` | `go test ./...` | `go vet ./...` |
| `Cargo.toml` | Rust | `cargo build` | `cargo test` | `cargo clippy` |
| `pyproject.toml` (pytest) | Python | `pip install -e .` | `pytest --cov` | `ruff check .` |
| `requirements.txt` (pytest) | Python | `pip install -r requirements.txt` | `pytest --cov` | `flake8 .` |

---

## Fallback

If no stack file is found, or the stack is ambiguous:
1. Ask the user: "What language/framework is this project? What are your lint and test commands?"
2. Record the answer and proceed
