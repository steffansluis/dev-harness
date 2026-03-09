#!/usr/bin/env bash
# Test: harness/release.md defines the conditions for a commit/release to be complete
# AC: harness/release.md defines the conditions for a commit/release to be considered complete

set -euo pipefail

PASS=0
FAIL=0
FILE="$(dirname "$0")/release.md"

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

echo "=== harness/release.md validation ==="

[[ -f "$FILE" ]] || { echo "FATAL: release.md missing"; exit 1; }

# 1. CI gates section present
if grep -qiE "CI|continuous integration|pipeline" "$FILE"; then
  pass "CI gates section present"
else
  fail "CI gates section missing"
fi

# 2. Changelog requirement present
if grep -qiE "changelog|CHANGELOG" "$FILE"; then
  pass "changelog requirement present"
else
  fail "changelog requirement missing"
fi

# 3. Version bump requirement present
if grep -qiE "version|semver|bump" "$FILE"; then
  pass "version bump requirement present"
else
  fail "version bump requirement missing"
fi

# 4. Specifies what must pass before a commit is complete
if grep -qiE "commit.*complet|complet.*commit|before.*commit|commit.*pass|pass.*commit" "$FILE"; then
  pass "commit completion conditions stated"
else
  fail "commit completion conditions not stated"
fi

# 5. Specifies the CI pipeline order/stages
if grep -qiE "lint|test|build|smoke|acceptance" "$FILE"; then
  pass "CI pipeline stages referenced"
else
  fail "CI pipeline stages not referenced"
fi

# 6. Artifacts mentioned (coverage, dist, reports)
if grep -qiE "artifact|coverage|dist|report" "$FILE"; then
  pass "CI artifacts referenced"
else
  fail "CI artifacts not referenced"
fi

# 7. No stub placeholders
if grep -qiE "_To be defined|TODO|PLACEHOLDER" "$FILE"; then
  fail "release.md still contains stub placeholders"
else
  pass "no stub placeholders"
fi

# 8. (Phase 4.2) Remote gate framing explicit
if grep -qiE "remote gate|remote.*gate" "$FILE"; then
  pass "remote gate framing present"
else
  fail "remote gate framing missing"
fi

# 9. (Phase 4.2) Each remote gate entry has a trigger (push/PR)
if grep -qiE "push|pull.request|PR open|on.*push|trigger" "$FILE"; then
  pass "remote gate triggers documented"
else
  fail "remote gate triggers missing"
fi

# 10. (Phase 4.2) Screenshot diff gate listed as remote
if grep -qiE "screenshot.*diff|screenshot.*remote|visual.*diff|diff.*screenshot" "$FILE"; then
  pass "screenshot diff gate listed as remote"
else
  fail "screenshot diff gate not listed as remote"
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
