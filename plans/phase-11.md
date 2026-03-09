# Phase 11 — Hook Guardrails

| # | Task | AC | Status |
|---|------|----|--------|
| 11.1 | Add PostToolUseFailure escalation hook | AC: After 3 consecutive tool failures Claude pauses and explains the blocker instead of silently retrying | cc:TODO |
| 11.2 | Add pre-tool-use block rules for destructive commands | AC: `sudo`, `rm -rf /`, `git push --force`, and `.env` writes are blocked at the hook level with a clear error | cc:TODO |
| 11.3 | Add post-tool-use warning for assertion tampering | AC: `it.skip` and `expect(true).toBe(true)` patterns trigger a warning in the hook output | cc:TODO |
