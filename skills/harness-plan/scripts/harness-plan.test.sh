#!/usr/bin/env bash
# Test: harness-plan SKILL.md reads/writes from plans/ directory, not Plans.md
# AC: Running /harness-plan reads the current phase from plans/ and correctly
#     identifies WIP and TODO tasks

set -euo pipefail

PASS=0
FAIL=0

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

SKILL="$(dirname "$0")/../SKILL.md"

echo "=== harness-plan skill validation ==="

# 1. SKILL.md exists
if [[ -f "$SKILL" ]]; then pass "SKILL.md exists"; else fail "SKILL.md missing"; exit 1; fi

# 2. Skill no longer tells the agent to read a flat Plans.md
if grep -q "Read.*Plans\.md\b" "$SKILL"; then
  fail "skill still references reading Plans.md directly"
else
  pass "skill does not read flat Plans.md"
fi

# 3. Skill no longer tells the agent to write to a flat Plans.md
# Match imperative write instructions only; exclude negations ("Do not write to Plans.md")
if grep -iE "^[^#]*write (it |changes |tasks? )?to.*Plans\.md|^[^#]*(update|append|add).*Plans\.md" "$SKILL" 2>/dev/null | grep -qiv "do not\|don't\|never\|avoid"; then
  fail "skill still references writing to Plans.md directly"
else
  pass "skill does not write to flat Plans.md"
fi

# 4. Skill references the plans/ directory
if grep -q "plans/" "$SKILL"; then pass "skill references plans/ directory"; else fail "skill does not reference plans/ directory"; fi

# 5. Skill explains how to identify the current active phase file
if grep -qiE "active phase|current phase|phase file|plans/phase-" "$SKILL"; then
  pass "skill explains how to find the active phase file"
else
  fail "skill does not explain how to find the active phase file"
fi

# 6. Skill instructs writing changes back to the phase file (not Plans.md)
if grep -qE "phase-[0-9N]+\.md|plans/phase" "$SKILL"; then
  pass "skill references per-phase file for writes"
else
  fail "skill does not reference per-phase file for writes"
fi

# 7. Skill still enforces the WIP limit warning
if grep -q "cc:WIP" "$SKILL"; then pass "WIP marker still referenced"; else fail "WIP marker missing"; fi

# 8. Skill still describes the status markers (cc:TODO / cc:WIP / cc:done)
if grep -q "cc:TODO" "$SKILL" && grep -q "cc:done" "$SKILL"; then
  pass "status markers documented"
else
  fail "status markers incomplete"
fi

# 9. Skill handles co-existence of plans/ and Plans.md (migration scenario)
if grep -qiE "both|Plans\.md.*exist|exist.*Plans\.md|coexist|co-exist|fallback|migration|if Plans\.md" "$SKILL"; then
  pass "skill handles plans/ + Plans.md co-existence"
else
  fail "skill does not handle plans/ + Plans.md co-existence"
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
