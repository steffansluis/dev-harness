#!/usr/bin/env bash
# Test: harness-work SKILL.md locates next task from plans/ directory
# AC: Running /harness-work picks the correct next cc:TODO task from the active phase file

set -euo pipefail

PASS=0
FAIL=0

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

SKILL="$(dirname "$0")/../SKILL.md"

echo "=== harness-work skill validation ==="

# 1. SKILL.md exists
if [[ -f "$SKILL" ]]; then pass "SKILL.md exists"; else fail "SKILL.md missing"; exit 1; fi

# 2. Description/frontmatter no longer says "Plans.md"
if grep -q "^description:.*Plans\.md" "$SKILL"; then
  fail "frontmatter description still references Plans.md"
else
  pass "frontmatter description does not reference Plans.md"
fi

# 3. Step 1 reads from plans/ not Plans.md
if grep -qE "^Read \`?Plans\.md" "$SKILL"; then
  fail "Step 1 still reads flat Plans.md"
else
  pass "Step 1 does not read flat Plans.md"
fi

# 4. Skill references plans/ directory for finding the next task
if grep -q "plans/" "$SKILL"; then pass "skill references plans/ directory"; else fail "skill does not reference plans/ directory"; fi

# 5. Skill explains how to find the active phase file
if grep -qiE "active phase|current phase|phase file|plans/phase-" "$SKILL"; then
  pass "skill explains how to find the active phase file"
else
  fail "skill does not explain how to find the active phase file"
fi

# 6. WIP marking targets a phase file, not flat Plans.md
if grep -qE "cc:WIP.*phase|phase.*cc:WIP|plans/phase" "$SKILL"; then
  pass "WIP marking targets the phase file"
else
  fail "WIP marking does not reference the phase file"
fi

# 7. cc:done marking updates the phase file
if grep -qE "cc:done.*phase|phase.*cc:done|plans/phase" "$SKILL"; then
  pass "cc:done marking targets the phase file"
else
  fail "cc:done marking does not reference the phase file"
fi

# 8. Skill handles co-existence of plans/ and Plans.md
if grep -qiE "both|Plans\.md.*exist|coexist|co-exist|fallback|migration|prefer.*plans" "$SKILL"; then
  pass "skill handles plans/ + Plans.md co-existence"
else
  fail "skill does not handle plans/ + Plans.md co-existence"
fi

# 9. TDD loop steps still present (Red/Green/Refactor)
if grep -q "TDD Loop" "$SKILL" && grep -q "Red" "$SKILL" && grep -q "Green" "$SKILL"; then
  pass "TDD loop steps present"
else
  fail "TDD loop steps missing"
fi

# 10. Stack detection reference still present
if grep -q "stack-detection" "$SKILL"; then pass "stack detection reference present"; else fail "stack detection reference missing"; fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
