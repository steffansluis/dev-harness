#!/usr/bin/env bash
# Test: harness/gates/readme.md — README currency gate
# AC: The review step flags a failing README gate when exported APIs changed
#     but README.md was not updated

set -euo pipefail

PASS=0
FAIL=0
DIR="$(dirname "$0")"
FILE="$DIR/readme.md"

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

echo "=== harness/gates/readme.md ==="

[[ -f "$FILE" ]] || { echo "FATAL: readme.md missing"; exit 1; }

"$DIR/validate-gate.sh" "$FILE"

# Gate-specific: mentions public API / exported surface
if grep -qiE "public API|exported|API surface|public.*function|export" "$FILE"; then
  pass "public API surface referenced"
else
  fail "public API surface not referenced"
fi

# Gate-specific: ties to review step
if grep -qiE "review|harness.review" "$FILE"; then
  pass "gate tied to review step"
else
  fail "gate not linked to review step"
fi

# Gate-specific: README.md referenced as the artefact to check
if grep -qE "README\.md|README" "$FILE"; then
  pass "README.md referenced"
else
  fail "README.md not referenced"
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
