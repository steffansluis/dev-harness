#!/usr/bin/env bash
# Test: harness-init and harness-setup both accept --paradigm and apply the gate set
# AC: A new project set up with --paradigm api-service has the correct gates enabled
#     without manual editing

set -euo pipefail

PASS=0
FAIL=0
INIT_SKILL="$(dirname "$0")/../SKILL.md"
SETUP_SKILL="$(dirname "$0")/../../harness-setup/SKILL.md"

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

echo "=== --paradigm flag validation ==="

# harness-init checks
if [[ -f "$INIT_SKILL" ]]; then
  # 1. Accepts --paradigm flag
  if grep -qiE "\-\-paradigm" "$INIT_SKILL"; then
    pass "harness-init: accepts --paradigm flag"
  else
    fail "harness-init: --paradigm flag not documented"
  fi

  # 2. Reads the paradigm file to determine gate selection
  if grep -qiE "paradigm.*file|paradigms/|read.*paradigm" "$INIT_SKILL"; then
    pass "harness-init: reads paradigm file for gate selection"
  else
    fail "harness-init: does not describe reading paradigm file"
  fi

  # 3. Applies gate enabled/disabled state without manual editing
  if grep -qiE "enabled|disabled|gate.*set|pre.select|without.*manual|no.*manual" "$INIT_SKILL"; then
    pass "harness-init: applies gate set automatically"
  else
    fail "harness-init: no description of automatic gate application"
  fi

  # 4. Falls back to stack detection when no --paradigm given
  if grep -qiE "if.*no.*paradigm|without.*paradigm|no.*flag|default|fallback|stack.*detect" "$INIT_SKILL"; then
    pass "harness-init: fallback to stack detection documented"
  else
    fail "harness-init: no fallback behaviour documented"
  fi
else
  fail "harness-init SKILL.md not found at expected path"
fi

# harness-setup checks
if [[ -f "$SETUP_SKILL" ]]; then
  # 5. Accepts --paradigm flag
  if grep -qiE "\-\-paradigm" "$SETUP_SKILL"; then
    pass "harness-setup: accepts --paradigm flag"
  else
    fail "harness-setup: --paradigm flag not documented"
  fi

  # 6. Delegates harness generation to /harness-init or applies paradigm
  if grep -qiE "harness.init|paradigm|gate.*set" "$SETUP_SKILL"; then
    pass "harness-setup: delegates harness init or applies paradigm"
  else
    fail "harness-setup: no paradigm integration described"
  fi
else
  fail "harness-setup SKILL.md not found at expected path"
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
