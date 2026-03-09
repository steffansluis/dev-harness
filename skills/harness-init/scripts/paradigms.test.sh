#!/usr/bin/env bash
# Test: all three built-in paradigm files exist and are readable without further context
# AC: Each paradigm file lists which gates are enabled by default and why,
#     readable without further context

set -euo pipefail

PASS=0
FAIL=0
DIR="$(dirname "$0")"
PARADIGMS_DIR="$DIR/../paradigms"

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

echo "=== built-in paradigms validation ==="

# 1. All three paradigm files exist
for p in web-app api-service cli-tool; do
  if [[ -f "$PARADIGMS_DIR/${p}.md" ]]; then
    pass "${p}.md exists"
  else
    fail "${p}.md missing"
  fi
done

# 2. All three pass the shared structure validator
for p in web-app api-service cli-tool; do
  f="$PARADIGMS_DIR/${p}.md"
  [[ -f "$f" ]] || continue
  if bash "$DIR/validate-paradigm.sh" "$f" > /dev/null 2>&1; then
    pass "${p}.md passes structural validation"
  else
    fail "${p}.md fails structural validation"
    bash "$DIR/validate-paradigm.sh" "$f" || true
  fi
done

# 3. api-service: acceptance gate enabled, screenshots disabled
if [[ -f "$PARADIGMS_DIR/api-service.md" ]]; then
  if grep -iE "^\| acceptance\s*\| yes" "$PARADIGMS_DIR/api-service.md" > /dev/null 2>&1; then
    pass "api-service: acceptance gate enabled"
  else
    fail "api-service: acceptance gate should be enabled"
  fi
  if grep -iE "^\| screenshots\s*\| no" "$PARADIGMS_DIR/api-service.md" > /dev/null 2>&1; then
    pass "api-service: screenshots gate disabled (no UI)"
  else
    fail "api-service: screenshots gate should be disabled (no UI)"
  fi
fi

# 4. cli-tool: screenshots and i18n disabled
if [[ -f "$PARADIGMS_DIR/cli-tool.md" ]]; then
  if grep -iE "^\| screenshots\s*\| no" "$PARADIGMS_DIR/cli-tool.md" > /dev/null 2>&1; then
    pass "cli-tool: screenshots gate disabled"
  else
    fail "cli-tool: screenshots gate should be disabled"
  fi
  if grep -iE "^\| i18n\s*\| no" "$PARADIGMS_DIR/cli-tool.md" > /dev/null 2>&1; then
    pass "cli-tool: i18n gate disabled (no user-facing strings)"
  else
    fail "cli-tool: i18n gate should be disabled"
  fi
fi

# 5. web-app: all gates enabled
if [[ -f "$PARADIGMS_DIR/web-app.md" ]]; then
  ALL_YES=true
  for gate in design readme acceptance screenshots i18n; do
    if ! grep -iE "^\| $gate\s*\| yes" "$PARADIGMS_DIR/web-app.md" > /dev/null 2>&1; then
      ALL_YES=false
      fail "web-app: gate '$gate' should be enabled"
    fi
  done
  $ALL_YES && pass "web-app: all 5 gates enabled"
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
