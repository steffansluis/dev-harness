#!/usr/bin/env bash
# Test: harness/gates/acceptance.md — acceptance test gate
# AC: /harness-work warns when a feature task completes with no acceptance test written

set -euo pipefail

PASS=0
FAIL=0
DIR="$(dirname "$0")"
FILE="$DIR/acceptance.md"

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

echo "=== harness/gates/acceptance.md ==="

[[ -f "$FILE" ]] || { echo "FATAL: acceptance.md missing"; exit 1; }

"$DIR/validate-gate.sh" "$FILE"

# Gate-specific: mentions e2e / acceptance test
if grep -qiE "e2e|acceptance|end.to.end|integration" "$FILE"; then
  pass "e2e/acceptance testing referenced"
else
  fail "e2e/acceptance testing not referenced"
fi

# Gate-specific: tied to harness-work / cc:done transition
if grep -qiE "harness.work|cc:done|feature task|complet" "$FILE"; then
  pass "gate tied to harness-work / cc:done"
else
  fail "gate not linked to harness-work / cc:done"
fi

# Gate-specific: distinguishes feature tasks from chores/fixes
if grep -qiE "feature|chore|bug.?fix|refactor|non.feature|not.*feature" "$FILE"; then
  pass "feature vs non-feature task distinction present"
else
  fail "no feature vs non-feature distinction"
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
