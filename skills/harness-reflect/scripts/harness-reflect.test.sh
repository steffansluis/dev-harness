#!/usr/bin/env bash
# Test: harness-reflect SKILL.md reads harness, collects feedback, proposes a diff
# AC: Running /harness-reflect produces a diff of proposed harness changes
#     that the user can accept or reject

set -euo pipefail

PASS=0
FAIL=0
SKILL="$(dirname "$0")/../SKILL.md"

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

echo "=== harness-reflect skill validation ==="

[[ -f "$SKILL" ]] || { echo "FATAL: SKILL.md missing"; exit 1; }

# 1. Skill reads the current harness/ directory
if grep -qE "harness/" "$SKILL"; then
  pass "skill reads harness/ directory"
else
  fail "skill does not read harness/ directory"
fi

# 2. Skill collects retrospective feedback from the user
if grep -qiE "feedback|retrospective|reflect|prompt|ask" "$SKILL"; then
  pass "skill collects retrospective feedback"
else
  fail "skill does not collect retrospective feedback"
fi

# 3. Skill proposes targeted amendments (not a full rewrite)
if grep -qiE "amend|amendment|targeted|specific|propose|change" "$SKILL"; then
  pass "skill proposes targeted amendments"
else
  fail "skill does not propose targeted amendments"
fi

# 4. Output is a diff the user can accept or reject
if grep -qiE "diff|accept|reject|approve|discard|apply" "$SKILL"; then
  pass "output is a diff the user can accept or reject"
else
  fail "accept/reject mechanism not described"
fi

# 5. Skill can amend gate files specifically
if grep -qiE "gate|harness/gates" "$SKILL"; then
  pass "skill can amend gate files"
else
  fail "skill does not reference gate file amendments"
fi

# 6. Skill can amend work.md, review.md, release.md
if grep -qiE "work\.md|review\.md|release\.md" "$SKILL"; then
  pass "skill can amend work/review/release files"
else
  fail "skill does not cover work/review/release amendments"
fi

# 7. Skill asks structured retrospective questions (not freeform)
if grep -qiE "question|what.*work|what.*not|slow|friction|missing|pain" "$SKILL"; then
  pass "structured retrospective questions present"
else
  fail "no structured retrospective questions"
fi

# 8. Skill does not apply changes without user confirmation
if grep -qiE "confirm|accept|approve|user.*decide|before.*apply|do not.*apply" "$SKILL"; then
  pass "changes require user confirmation before applying"
else
  fail "skill may apply changes without user confirmation"
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
