# Phase 12 — Quick-win skill improvements

| # | Task | AC | Status |
|---|------|----|--------|
| 12.1 | Update all skills to use `${CLAUDE_SKILL_DIR}` for stable path references | AC: Skill instructions reference their own files via `${CLAUDE_SKILL_DIR}` so they work regardless of install path | cc:TODO |
| 12.2 | Add effort-level escalation to harness-work | AC: harness-work injects `ultrathink` for tasks flagged as complex (multiple files, architectural changes) | cc:TODO |
| 12.3 | Add `/sync-status` command to harness-plan | AC: Running `/harness-plan --sync` reports tasks marked `cc:done` whose files have no recent commits, flagging potential drift | cc:TODO |
