#!/usr/bin/env bash
# Test: harness/gates/i18n.md — i18n / localisation gate
# AC: The i18n gate fails when a task introduces a hardcoded user-visible string
#     outside a localisation call

set -euo pipefail

PASS=0
FAIL=0
DIR="$(dirname "$0")"
FILE="$DIR/i18n.md"

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

echo "=== harness/gates/i18n.md ==="

[[ -f "$FILE" ]] || { echo "FATAL: i18n.md missing"; exit 1; }

"$DIR/validate-gate.sh" "$FILE"

# Gate-specific: hardcoded string detection
if grep -qiE "hardcoded|hard.coded|literal string|raw string" "$FILE"; then
  pass "hardcoded string detection referenced"
else
  fail "hardcoded string detection not referenced"
fi

# Gate-specific: localisation helper / i18n function
if grep -qiE "localisation|localization|i18n|t\(|translate|helper" "$FILE"; then
  pass "localisation helper referenced"
else
  fail "localisation helper not referenced"
fi

# Gate-specific: user-visible / user-facing strings in scope
if grep -qiE "user.visible|user.facing|UI string|display" "$FILE"; then
  pass "user-visible string scope defined"
else
  fail "user-visible string scope not defined"
fi

# Gate-specific: what strings are exempt (error codes, keys, logs)
if grep -qiE "exempt|except|log|error code|key|identifier|non.user" "$FILE"; then
  pass "exempt string categories defined"
else
  fail "exempt string categories not defined"
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
