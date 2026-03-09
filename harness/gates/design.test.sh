#!/usr/bin/env bash
# Test: harness/gates/design.md — design artefact gate
# AC: CI fails when a task is marked cc:WIP without a linked design artefact
#     and the design gate is enabled

set -euo pipefail

PASS=0
FAIL=0
DIR="$(dirname "$0")"
FILE="$DIR/design.md"

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

echo "=== harness/gates/design.md ==="

[[ -f "$FILE" ]] || { echo "FATAL: design.md missing"; exit 1; }

# Shared structure checks
"$DIR/validate-gate.sh" "$FILE"

# Gate-specific: mentions design artefact (mockup, spec, figma, etc.)
if grep -qiE "design|mockup|spec|figma|artefact|artifact|wireframe" "$FILE"; then
  pass "design artefact referenced"
else
  fail "design artefact not referenced"
fi

# Gate-specific: ties to cc:WIP transition
if grep -qiE "cc:WIP|WIP|before.*implement|before.*start" "$FILE"; then
  pass "gate tied to cc:WIP / pre-implementation"
else
  fail "no link to cc:WIP transition"
fi

# Gate-specific: describes how the artefact is linked (task row / comment)
if grep -qiE "link|task row|plans|phase|comment|reference" "$FILE"; then
  pass "artefact linking mechanism described"
else
  fail "artefact linking mechanism not described"
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
