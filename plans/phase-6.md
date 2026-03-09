# Phase 6 — Guide Compliance and Distribution Readiness

Apply improvements derived from Anthropic's "Complete Guide to Building Skills for Claude" to bring all 7 skills into alignment with official best practices and prepare the plugin for public distribution.

---

| # | Task | AC | Status |
|---|------|----|--------|
| 6.1 | Enrich `description` fields in all 7 skill frontmatters to follow guide formula: [What it does] + [When to use it] + [concrete trigger phrases] | AC: Each skill description explicitly states what it does, when to invoke it, and includes 2+ concrete user-phrased triggers; no description reads as vague or trigger-free | cc:done |
| 6.2 | Add `metadata` (version, author, category, tags), `license`, and `compatibility` fields to all 7 skill frontmatters | AC: Every SKILL.md frontmatter includes `metadata.version`, `metadata.category`, `license`, and `compatibility`; the plugin is ready to submit to a public skill directory without missing distribution metadata | cc:done |
| 6.3 | Add `## Common Issues` (Error / Cause / Solution) section to `harness-work`, `harness-init`, `harness-setup`, and `harness-ci` | AC: Each of those 4 skills includes a troubleshooting section covering at least 2 realistic failure modes (e.g. missing stack file, unrecognised paradigm), so a user can self-diagnose without external help | cc:done |
| 6.4 | Add `## Examples` section to each of the 7 skills showing one concrete scenario (user request → actions → result) | AC: Each SKILL.md contains at least one complete example following the guide's recommended structure, giving new users an immediate mental model of the skill's output | cc:done |
| 6.5 | Move `.sh` executables from skill directories into `scripts/` subdirectories per official file structure | AC: Every `.sh` script that was co-located with a SKILL.md now lives in `scripts/` within the same skill folder; all existing test-runner invocations continue to pass with updated paths | cc:done |
| 6.6 | Write a repo-level README.md for GitHub distribution covering installation, what each skill does, and a quick-start guide | AC: A developer finding the repo on GitHub can install all skills and invoke their first harness workflow within 5 minutes using only the README, without reading any SKILL.md directly | cc:done |
| 6.7 | Use `skill-creator` to audit all 7 skills and address any CRITICAL or IMPORTANT findings on description quality, triggering accuracy, or structural completeness | AC: skill-creator review of each skill returns no CRITICAL or IMPORTANT findings; any MINOR findings are either resolved or explicitly accepted with a note | cc:done |

---

<!--
AC guidelines:
- One sentence, user-visible outcome
- "User sees…", "App stores…", "CI fails when…"
- Not a test criterion — a behaviour criterion
- Required before a task can move to cc:WIP
-->
