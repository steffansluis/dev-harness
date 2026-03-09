#!/usr/bin/env bash
# Shared paradigm structure validator.
# Usage: validate-paradigm.sh <paradigm-file.md>
# Checks that a paradigm file has the required structure and content.
# Exit 0 if all structural checks pass; non-zero otherwise.

set -euo pipefail

FILE="${1:-}"
if [[ -z "$FILE" || ! -f "$FILE" ]]; then
  echo "Usage: validate-paradigm.sh <paradigm-file.md>"
  exit 1
fi

PASS=0
FAIL=0

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

# 1. Has a Paradigm: h1 header
if grep -qE "^# Paradigm:" "$FILE"; then pass "h1 Paradigm: header present"; else fail "h1 Paradigm: header missing"; fi

# 2. Has a description paragraph (non-header non-empty line near top)
if awk '/^# Paradigm:/{found=1; next} found && /^[^#\-\|]/{print; exit}' "$FILE" | grep -q '.'; then
  pass "description paragraph present"
else
  fail "description paragraph missing"
fi

# 3. Has an Enabled Gates section (table listing gates)
if grep -qiE "^## Enabled Gates|^## Gates" "$FILE"; then
  pass "Enabled Gates section present"
else
  fail "Enabled Gates section missing"
fi

# 4. Gate table has Gate, Enabled, and Reason columns
if grep -qE "\| Gate\s*\|" "$FILE" && grep -qE "\| Reason" "$FILE"; then
  pass "gate table has Gate and Reason columns"
else
  fail "gate table missing required columns"
fi

# 5. Each of the 5 known gates appears in the table
for gate in design readme acceptance screenshots i18n; do
  if grep -qiE "^\| $gate" "$FILE"; then
    pass "gate '$gate' listed"
  else
    fail "gate '$gate' missing from table"
  fi
done

# 6. Has a Stack note (what kind of project uses this paradigm)
if grep -qiE "^## Stack|typical.*stack|project.*type|use.*when|when.*to.*use" "$FILE"; then
  pass "stack / use-case guidance present"
else
  fail "stack / use-case guidance missing"
fi

echo "  [paradigm structure: $PASS passed, $FAIL failed]"
[[ $FAIL -eq 0 ]]
