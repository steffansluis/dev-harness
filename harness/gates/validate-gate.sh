#!/usr/bin/env bash
# Shared gate structure validator.
# Usage: validate-gate.sh <gate-file.md>
# Checks that a gate file has the required structure.
# Exit 0 if all structural checks pass; non-zero otherwise.

set -euo pipefail

FILE="${1:-}"
if [[ -z "$FILE" || ! -f "$FILE" ]]; then
  echo "Usage: validate-gate.sh <gate-file.md>"
  exit 1
fi

PASS=0
FAIL=0

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

# 1. Has an h1 header
if grep -q "^# " "$FILE"; then pass "h1 header present"; else fail "h1 header missing"; fi

# 2. Has a description paragraph (non-empty line after the header)
if awk '/^# /{found=1; next} found && /^[^#\-]/{print; exit}' "$FILE" | grep -q '.'; then
  pass "description paragraph present"
else
  fail "description paragraph missing"
fi

# 3. Defines what the gate checks
if grep -qiE "^## What|check|verif|detect|inspect|require" "$FILE"; then
  pass "gate check behaviour described"
else
  fail "gate check behaviour not described"
fi

# 4. Defines a Pass condition
if grep -qiE "^## Pass|Pass:|pass when|passes when" "$FILE"; then
  pass "Pass condition defined"
else
  fail "Pass condition missing"
fi

# 5. Defines a Fail condition
if grep -qiE "^## Fail|Fail:|fails when|fail when" "$FILE"; then
  pass "Fail condition defined"
else
  fail "Fail condition missing"
fi

# 6. Declares whether the gate is opt-in or default
if grep -qiE "opt.in|default|enabled" "$FILE"; then
  pass "gate enabled/opt-in status declared"
else
  fail "gate enabled/opt-in status not declared"
fi

echo "  [structure: $PASS passed, $FAIL failed]"
[[ $FAIL -eq 0 ]]
