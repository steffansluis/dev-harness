#!/usr/bin/env bash
# Test: Complex skills have a ## Common Issues section with Error/Cause/Solution entries
# AC: harness-work, harness-init, harness-setup, harness-ci each have at least 2 failure modes
# Ref: "The Complete Guide to Building Skills for Claude" p.12-13

set -euo pipefail

PASS=0
FAIL=0
SKILLS_DIR="$(dirname "$0")"

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

echo "=== common issues section validation ==="

SKILLS=(
  harness-work
  harness-init
  harness-setup
  harness-ci
)

for skill in "${SKILLS[@]}"; do
  FILE="$SKILLS_DIR/$skill/SKILL.md"

  if [[ ! -f "$FILE" ]]; then
    fail "$skill: SKILL.md not found"
    continue
  fi

  # 1. Has a ## Common Issues section
  if grep -qE "^## Common Issues" "$FILE"; then
    pass "$skill: has ## Common Issues section"
  else
    fail "$skill: missing ## Common Issues section"
  fi

  # 2. Has at least 2 Error: entries
  ERROR_COUNT=$(grep -cE "^\*\*Error:|^Error:" "$FILE" || true)
  if [[ "$ERROR_COUNT" -ge 2 ]]; then
    pass "$skill: has 2+ Error entries ($ERROR_COUNT found)"
  else
    fail "$skill: fewer than 2 Error entries ($ERROR_COUNT found)"
  fi

  # 3. Has Cause entries matching the Error count
  CAUSE_COUNT=$(grep -cE "^\*\*Cause:|^Cause:" "$FILE" || true)
  if [[ "$CAUSE_COUNT" -ge 2 ]]; then
    pass "$skill: has 2+ Cause entries ($CAUSE_COUNT found)"
  else
    fail "$skill: fewer than 2 Cause entries ($CAUSE_COUNT found)"
  fi

  # 4. Has Solution entries
  SOLUTION_COUNT=$(grep -cE "^\*\*Solution:|^Solution:" "$FILE" || true)
  if [[ "$SOLUTION_COUNT" -ge 2 ]]; then
    pass "$skill: has 2+ Solution entries ($SOLUTION_COUNT found)"
  else
    fail "$skill: fewer than 2 Solution entries ($SOLUTION_COUNT found)"
  fi
done

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
