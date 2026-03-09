#!/usr/bin/env bash
# Test: harness-init SKILL.md generates a harness/ directory tailored to the detected stack
# AC: Running /harness-init produces a populated harness/ directory tailored to the detected stack

set -euo pipefail

PASS=0
FAIL=0
SKILL="$(dirname "$0")/SKILL.md"

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

echo "=== harness-init skill validation ==="

[[ -f "$SKILL" ]] || { echo "FATAL: SKILL.md missing"; exit 1; }

# 1. Skill detects the stack (tailored to project context)
if grep -qiE "detect.*stack|stack.*detect|package\.json|Gemfile|go\.mod|Cargo\.toml" "$SKILL"; then
  pass "skill detects the project stack"
else
  fail "skill does not detect the project stack"
fi

# 2. Skill generates harness/work.md
if grep -qE "harness/work\.md|work\.md" "$SKILL"; then pass "generates harness/work.md"; else fail "does not generate harness/work.md"; fi

# 3. Skill generates harness/review.md
if grep -qE "harness/review\.md|review\.md" "$SKILL"; then pass "generates harness/review.md"; else fail "does not generate harness/review.md"; fi

# 4. Skill generates harness/release.md
if grep -qE "harness/release\.md|release\.md" "$SKILL"; then pass "generates harness/release.md"; else fail "does not generate harness/release.md"; fi

# 5. Skill creates harness/gates/ subdirectory
if grep -qiE "gates/" "$SKILL"; then pass "creates gates/ subdirectory"; else fail "does not create gates/ subdirectory"; fi

# 6. Skill uses reference templates from skills/harness-init/
if grep -qiE "template|reference|harness-init" "$SKILL"; then
  pass "references templates"
else
  fail "does not reference templates"
fi

# 7. Skill is idempotent — handles existing harness/ gracefully
if grep -qiE "already exist|exist.*harness|harness.*exist|skip|idempotent" "$SKILL"; then
  pass "handles existing harness/ gracefully"
else
  fail "no guidance for existing harness/ directory"
fi

# 8. Skill adapts content based on the detected stack (tailoring)
if grep -qiE "stack|tailor|adapt|based on|if.*node|if.*ruby|if.*go|if.*python|if.*rust" "$SKILL"; then
  pass "content tailored to detected stack"
else
  fail "content not tailored to stack"
fi

# 9. Skill informs the user what was created
if grep -qiE "inform|print|summary|created|generated|output" "$SKILL"; then
  pass "user informed of what was created"
else
  fail "no user output step"
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
