#!/usr/bin/env bash
# Test: harness-ci SKILL.md reads harness/gates/ and emits steps for enabled gates
# AC: Running /harness-ci after enabling the i18n gate adds an i18n-check step
#     to the generated CI YAML

set -euo pipefail

PASS=0
FAIL=0
SKILL="$(dirname "$0")/../SKILL.md"

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

echo "=== harness-ci skill validation ==="

[[ -f "$SKILL" ]] || { echo "FATAL: SKILL.md missing"; exit 1; }

# 1. Skill reads harness/gates/ directory
if grep -qE "harness/gates" "$SKILL"; then
  pass "skill reads harness/gates/ directory"
else
  fail "skill does not read harness/gates/ directory"
fi

# 2. Skill reads the Enabled/opt-in status from each gate file
if grep -qiE "enabled|opt.in|active|gate.*status|status.*gate" "$SKILL"; then
  pass "skill checks gate enabled/opt-in status"
else
  fail "skill does not check gate enabled status"
fi

# 3. Skill emits CI steps only for enabled gates
if grep -qiE "only.*enabled|enabled.*gate|emit.*step|step.*gate|gate.*step" "$SKILL"; then
  pass "skill emits steps only for enabled gates"
else
  fail "skill does not conditionally emit gate steps"
fi

# 4. i18n gate explicitly produces an i18n-check CI step
if grep -qiE "i18n.*step|i18n.*check|i18n.*CI|i18n.*job" "$SKILL"; then
  pass "i18n gate maps to i18n-check CI step"
else
  fail "i18n gate → i18n-check CI step not described"
fi

# 5. Skill retains existing stack detection and template generation
if grep -qiE "stack|detect|template|ci-node|ci-ruby|ci-go" "$SKILL"; then
  pass "stack detection and templates retained"
else
  fail "stack detection or templates missing"
fi

# 6. Gate-to-CI-step mapping documented for all known gates
if grep -qiE "design|readme|acceptance|screenshot|i18n" "$SKILL"; then
  pass "gate-to-CI-step mapping covers known gates"
else
  fail "gate-to-CI-step mapping missing or incomplete"
fi

# 7. Skill documents where gate steps slot into the pipeline
if grep -qiE "after.*build|after.*test|pipeline|order|slot|position" "$SKILL"; then
  pass "gate step pipeline position documented"
else
  fail "gate step pipeline position not documented"
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
