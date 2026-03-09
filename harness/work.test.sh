#!/usr/bin/env bash
# Test: harness/work.md defines all gates required before cc:done
# AC: harness/work.md defines the gates that must pass before a task moves to cc:done

set -euo pipefail

PASS=0
FAIL=0
FILE="$(dirname "$0")/work.md"

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

echo "=== harness/work.md validation ==="

[[ -f "$FILE" ]] || { echo "FATAL: work.md missing"; exit 1; }

# 1. Describes the TDD loop (Red / Green / Refactor)
if grep -qiE "\bRed\b" "$FILE" && grep -qiE "\bGreen\b" "$FILE" && grep -qiE "\bRefactor\b" "$FILE"; then
  pass "TDD loop (Red/Green/Refactor) documented"
else
  fail "TDD loop incomplete"
fi

# 2. Lint gate defined
if grep -qiE "lint" "$FILE"; then pass "lint gate present"; else fail "lint gate missing"; fi

# 3. Test gate defined
if grep -qiE "test" "$FILE"; then pass "test gate present"; else fail "test gate missing"; fi

# 4. Coverage gate defined with a threshold
if grep -qiE "coverage" "$FILE" && grep -qiE "[0-9]+%" "$FILE"; then
  pass "coverage gate with threshold present"
else
  fail "coverage gate or threshold missing"
fi

# 5. cc:done transition is explicitly gated
if grep -qE "cc:done" "$FILE"; then pass "cc:done referenced as the gate target"; else fail "cc:done not referenced"; fi

# 6. Both lint AND tests must pass (not one-or-the-other)
if grep -qiE "both|&&|and.*pass|lint.*test|test.*lint" "$FILE"; then
  pass "both lint and tests required"
else
  fail "requirement that both lint and tests pass is not stated"
fi

# 7. No stub placeholders remain
if grep -qiE "_To be defined|TODO|PLACEHOLDER" "$FILE"; then
  fail "work.md still contains stub placeholders"
else
  pass "no stub placeholders"
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
