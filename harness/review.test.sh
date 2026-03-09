#!/usr/bin/env bash
# Test: harness/review.md specifies the review gates that run between phases
# AC: harness/review.md specifies the review gates that run between phases

set -euo pipefail

PASS=0
FAIL=0
FILE="$(dirname "$0")/review.md"

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

echo "=== harness/review.md validation ==="

[[ -f "$FILE" ]] || { echo "FATAL: review.md missing"; exit 1; }

# 1. All four review perspectives present
for perspective in Security Performance Quality Accessibility; do
  if grep -qi "$perspective" "$FILE"; then
    pass "$perspective perspective present"
  else
    fail "$perspective perspective missing"
  fi
done

# 5. Defines when the review runs (between phases)
if grep -qiE "between phase|phase.*complet|end.*phase|before.*phase" "$FILE"; then
  pass "review timing (between phases) specified"
else
  fail "review timing not specified"
fi

# 6. Defines outcome states (APPROVE / REQUEST_CHANGES)
if grep -qiE "APPROVE|REQUEST_CHANGES|approve|request.changes" "$FILE"; then
  pass "outcome states defined"
else
  fail "outcome states (APPROVE/REQUEST_CHANGES) missing"
fi

# 7. Severity levels defined
if grep -qiE "CRITICAL|IMPORTANT|severity" "$FILE"; then
  pass "severity levels defined"
else
  fail "severity levels missing"
fi

# 8. Accessibility is marked skip-able for non-UI projects
if grep -qiE "skip|CLI|API|not applicable|non.UI|no.*UI" "$FILE"; then
  pass "accessibility skip condition documented"
else
  fail "no guidance on when to skip Accessibility"
fi

# 9. No stub placeholders
if grep -qiE "_To be defined|TODO|PLACEHOLDER" "$FILE"; then
  fail "review.md still contains stub placeholders"
else
  pass "no stub placeholders"
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
