#!/usr/bin/env bash
# Test: All 7 skills have a ## Examples section with a complete scenario
# AC: Each SKILL.md contains user request → actions → result structure
# Ref: "The Complete Guide to Building Skills for Claude" p.12

set -euo pipefail

PASS=0
FAIL=0
SKILLS_DIR="$(dirname "$0")"

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

echo "=== examples section validation ==="

SKILLS=(
  harness-plan
  harness-work
  harness-review
  harness-setup
  harness-ci
  harness-init
  harness-reflect
)

for skill in "${SKILLS[@]}"; do
  FILE="$SKILLS_DIR/$skill/SKILL.md"

  if [[ ! -f "$FILE" ]]; then
    fail "$skill: SKILL.md not found"
    continue
  fi

  # 1. Has a ## Examples section
  if grep -qE "^## Examples?" "$FILE"; then
    pass "$skill: has ## Examples section"
  else
    fail "$skill: missing ## Examples section"
  fi

  # 2. Has a user request line (User says / User asks / User runs)
  if grep -qiE "user says|user asks|user runs|user wants|user types" "$FILE"; then
    pass "$skill: example has user request"
  else
    fail "$skill: example missing user request line"
  fi

  # 3. Has a result line (Result: ...)
  if grep -qiE "^Result:|result:" "$FILE"; then
    pass "$skill: example has Result line"
  else
    fail "$skill: example missing Result: line"
  fi
done

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
