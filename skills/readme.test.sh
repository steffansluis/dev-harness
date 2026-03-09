#!/usr/bin/env bash
# Test: repo-level README.md exists and covers installation + all 7 skills + quick-start
# AC: A developer can install and start their first workflow in 5 minutes using only the README
# Ref: "The Complete Guide to Building Skills for Claude" p.20

set -euo pipefail

PASS=0
FAIL=0
README="$(dirname "$0")/../README.md"

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

echo "=== repo-level README validation ==="

# 1. README.md exists at repo root
if [[ -f "$README" ]]; then
  pass "README.md exists at repo root"
else
  fail "README.md missing at repo root"
fi

[[ -f "$README" ]] || { echo "Results: $PASS passed, $FAIL failed"; exit 1; }

# 2. Has an installation section
if grep -qiE "^## Install|^## Getting Started|^## Setup|^## Quick.?start" "$README"; then
  pass "README has installation/quick-start section"
else
  fail "README missing installation or quick-start section"
fi

# 3. Each of the 7 skills is mentioned
SKILLS=(harness-plan harness-work harness-review harness-setup harness-ci harness-init harness-reflect)
for skill in "${SKILLS[@]}"; do
  if grep -qE "$skill" "$README"; then
    pass "README mentions $skill"
  else
    fail "README does not mention $skill"
  fi
done

# 4. Has a concrete step-by-step install instruction
if grep -qiE "git clone|download|upload|Settings.*Skills|Claude Code.*skills" "$README"; then
  pass "README has concrete install steps"
else
  fail "README missing concrete install steps (git clone / upload to Claude)"
fi

# 5. Has a quick-start showing a first command
if grep -qE "/harness-setup|/harness-init|/harness-work|/harness-plan" "$README"; then
  pass "README shows at least one slash command to get started"
else
  fail "README does not show any slash commands"
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
