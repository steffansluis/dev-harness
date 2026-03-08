#!/usr/bin/env bash
# Test: plans/phase-1.md exists and has the correct format
# AC: User can navigate to plans/phase-1.md and see only Phase 1 tasks with correct format

set -euo pipefail

PASS=0
FAIL=0

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

PHASE1="$(dirname "$0")/phase-1.md"
INDEX="$(dirname "$0")/index.md"

echo "=== plans structure validation ==="

# 1. plans/index.md exists
if [[ -f "$INDEX" ]]; then pass "index.md exists"; else fail "index.md missing"; fi

# 2. plans/phase-1.md exists
if [[ -f "$PHASE1" ]]; then pass "phase-1.md exists"; else fail "phase-1.md missing"; fi

# 3. phase-1.md contains the Phase 1 header (h1, since it is a standalone document)
if grep -q "^# Phase 1" "$PHASE1" 2>/dev/null; then pass "Phase 1 header present"; else fail "Phase 1 header missing"; fi

# 4. phase-1.md has the correct table columns
if grep -q "| # | Task | AC | Status |" "$PHASE1" 2>/dev/null; then pass "table columns correct"; else fail "table columns missing or wrong"; fi

# 5. phase-1.md contains at least one Phase 1 task row (1.N)
if grep -qE "^\| 1\.[0-9]+" "$PHASE1" 2>/dev/null; then pass "Phase 1 task rows present"; else fail "no Phase 1 task rows found"; fi

# 6. phase-1.md does NOT contain Phase 2+ task rows (2.N, 3.N, etc.)
if grep -qE "^\| [2-9]\.[0-9]+" "$PHASE1" 2>/dev/null; then fail "phase-1.md contains cross-phase rows"; else pass "no cross-phase rows"; fi

# 7. phase-1.md status markers are valid (cc:TODO, cc:WIP, or cc:done only)
INVALID=$(grep -E "^\| [0-9]+\.[0-9]+" "$PHASE1" 2>/dev/null | grep -vE "(cc:TODO|cc:WIP|cc:done)" || true)
if [[ -z "$INVALID" ]]; then pass "all status markers valid"; else fail "invalid status markers: $INVALID"; fi

# 8. index.md links to phase-1.md
if grep -q "phase-1" "$INDEX" 2>/dev/null; then pass "index.md links to phase-1"; else fail "index.md does not link to phase-1"; fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
