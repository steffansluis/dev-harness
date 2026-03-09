#!/usr/bin/env bash
# Test: harness/ directory has the correct structure and each file explains
#       its role in the work/review/release cycle.
# AC: A contributor reading harness/ understands the full cycle of constraints
#     for work, review, and release.

set -euo pipefail

PASS=0
FAIL=0
DIR="$(dirname "$0")"

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

echo "=== harness/ structure validation ==="

# 1–3. Required files exist
for f in work.md review.md release.md; do
  if [[ -f "$DIR/$f" ]]; then pass "$f exists"; else fail "$f missing"; fi
done

# 4. gates/ subdirectory exists
if [[ -d "$DIR/gates" ]]; then pass "gates/ subdirectory exists"; else fail "gates/ subdirectory missing"; fi

# 5. gates/ has a README explaining the gate concept
if [[ -f "$DIR/gates/README.md" ]]; then pass "gates/README.md exists"; else fail "gates/README.md missing"; fi

# 6. work.md declares what it governs (work/task execution)
if grep -qiE "work|task|tdd|lint|coverage" "$DIR/work.md" 2>/dev/null; then
  pass "work.md describes work constraints"
else
  fail "work.md does not describe work constraints"
fi

# 7. review.md declares what it governs (review cycle)
if grep -qiE "review|security|performance|quality|accessibility" "$DIR/review.md" 2>/dev/null; then
  pass "review.md describes review constraints"
else
  fail "review.md does not describe review constraints"
fi

# 8. release.md declares what it governs (release/commit cycle)
if grep -qiE "release|commit|ci|changelog|version" "$DIR/release.md" 2>/dev/null; then
  pass "release.md describes release constraints"
else
  fail "release.md does not describe release constraints"
fi

# 9. gates/README.md explains what a gate is
if grep -qiE "gate|check|pass|fail" "$DIR/gates/README.md" 2>/dev/null; then
  pass "gates/README.md explains the gate concept"
else
  fail "gates/README.md does not explain gates"
fi

# 10. Each top-level file has an h1 header
for f in work.md review.md release.md; do
  if grep -q "^# " "$DIR/$f" 2>/dev/null; then
    pass "$f has an h1 header"
  else
    fail "$f missing h1 header"
  fi
done

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
