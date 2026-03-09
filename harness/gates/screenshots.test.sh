#!/usr/bin/env bash
# Test: harness/gates/screenshots.md — screenshot artefact gate
# AC: UI tasks cannot move to cc:done without screenshot artefacts linked in the task row

set -euo pipefail

PASS=0
FAIL=0
DIR="$(dirname "$0")"
FILE="$DIR/screenshots.md"

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

echo "=== harness/gates/screenshots.md ==="

[[ -f "$FILE" ]] || { echo "FATAL: screenshots.md missing"; exit 1; }

"$DIR/validate-gate.sh" "$FILE"

# Gate-specific: before/after screenshots required
if grep -qiE "before|after|screenshot" "$FILE"; then
  pass "before/after screenshots referenced"
else
  fail "before/after screenshots not referenced"
fi

# Gate-specific: linked in the task row
if grep -qiE "task row|plans|link|artefact|artifact" "$FILE"; then
  pass "task row linking requirement present"
else
  fail "task row linking requirement missing"
fi

# Gate-specific: applies to UI tasks only
if grep -qiE "UI task|visual|user interface|non.UI|CLI|API|skip" "$FILE"; then
  pass "UI-task scope defined"
else
  fail "UI-task scope not defined"
fi

# Gate-specific: .gitignore note (screenshots are generated output)
if grep -qiE "gitignore|generated|artefact.*path|screenshot.*path|where.*store" "$FILE"; then
  pass "screenshot storage / gitignore guidance present"
else
  fail "no screenshot storage or gitignore guidance"
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
