#!/usr/bin/env bash
# Test: paradigm format is defined — validator exists and a sample paradigm satisfies it
# AC: Running /harness-init --paradigm web-app generates a harness/ directory
#     with the web-app gate set pre-enabled

set -euo pipefail

PASS=0
FAIL=0
DIR="$(dirname "$0")"
PARADIGMS_DIR="$DIR/../paradigms"

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

echo "=== paradigm format definition ==="

# 1. Paradigms directory exists
if [[ -d "$PARADIGMS_DIR" ]]; then pass "paradigms/ directory exists"; else fail "paradigms/ directory missing"; fi

# 2. Shared validator exists and is executable
if [[ -x "$DIR/validate-paradigm.sh" ]]; then
  pass "validate-paradigm.sh exists and is executable"
else
  fail "validate-paradigm.sh missing or not executable"
fi

# 3. At least one paradigm file exists
PARADIGM_COUNT=$(find "$PARADIGMS_DIR" -maxdepth 1 -name "*.md" | wc -l)
if [[ "$PARADIGM_COUNT" -gt 0 ]]; then
  pass "at least one paradigm file present ($PARADIGM_COUNT found)"
else
  fail "no paradigm files found"
fi

# 4. All paradigm .md files pass the shared validator
FAILED_PARADIGMS=0
for pf in "$PARADIGMS_DIR"/*.md; do
  [[ -f "$pf" ]] || continue
  if bash "$DIR/validate-paradigm.sh" "$pf" > /dev/null 2>&1; then
    pass "$(basename "$pf") passes structural validation"
  else
    fail "$(basename "$pf") fails structural validation"
    bash "$DIR/validate-paradigm.sh" "$pf" || true
    FAILED_PARADIGMS=$((FAILED_PARADIGMS+1))
  fi
done

# 5. harness-init SKILL.md references the paradigms directory
SKILL="$DIR/../SKILL.md"  # scripts/../SKILL.md = harness-init/SKILL.md
if grep -qiE "paradigm" "$SKILL" 2>/dev/null; then
  pass "harness-init skill references paradigms"
else
  fail "harness-init skill does not reference paradigms"
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
