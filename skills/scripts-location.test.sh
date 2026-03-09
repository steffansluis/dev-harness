#!/usr/bin/env bash
# Test: Executable .sh scripts live in scripts/ subdirectories, not co-located with SKILL.md
# AC: Every .sh co-located with a SKILL.md is now in scripts/ within the same skill folder
# Ref: "The Complete Guide to Building Skills for Claude" p.5, p.10

set -euo pipefail

PASS=0
FAIL=0
SKILLS_DIR="$(dirname "$0")"

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

echo "=== scripts/ subdirectory location validation ==="

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
  DIR="$SKILLS_DIR/$skill"

  # 1. No .sh files directly in the skill directory (co-located with SKILL.md)
  COLOCATED=$(find "$DIR" -maxdepth 1 -name "*.sh" | wc -l | tr -d ' ')
  if [[ "$COLOCATED" -eq 0 ]]; then
    pass "$skill: no .sh files co-located with SKILL.md"
  else
    fail "$skill: $COLOCATED .sh file(s) still co-located with SKILL.md"
  fi
done

# 2. Skills with test scripts have a scripts/ directory
SKILLS_WITH_SCRIPTS=(harness-plan harness-work harness-setup harness-ci harness-init harness-reflect)
for skill in "${SKILLS_WITH_SCRIPTS[@]}"; do
  SCRIPTS_DIR="$SKILLS_DIR/$skill/scripts"
  if [[ -d "$SCRIPTS_DIR" ]]; then
    pass "$skill: scripts/ directory exists"
  else
    fail "$skill: scripts/ directory missing"
  fi

  # 3. Verify the test script is executable in scripts/
  TEST_SCRIPT="$SCRIPTS_DIR/${skill}.test.sh"
  if [[ -x "$TEST_SCRIPT" ]]; then
    pass "$skill: ${skill}.test.sh is executable in scripts/"
  else
    fail "$skill: ${skill}.test.sh missing or not executable in scripts/"
  fi
done

# 4. harness-init/scripts/ contains paradigm scripts (moved from paradigms/)
INIT_SCRIPTS="$SKILLS_DIR/harness-init/scripts"
for script in validate-paradigm.sh paradigm-format.test.sh paradigms.test.sh paradigm-flag.test.sh; do
  if [[ -f "$INIT_SCRIPTS/$script" ]]; then
    pass "harness-init/scripts/$script present"
  else
    fail "harness-init/scripts/$script missing"
  fi
done

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
