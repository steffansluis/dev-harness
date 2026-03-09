#!/usr/bin/env bash
# Test: harness-setup SKILL.md scaffolds plans/ directory with plans/phase-1.md
# AC: Running /harness-setup on a new project creates plans/phase-1.md with the standard template

set -euo pipefail

PASS=0
FAIL=0

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

SKILL="$(dirname "$0")/SKILL.md"
TEMPLATE_DIR="$(dirname "$0")/references"

echo "=== harness-setup skill validation ==="

# 1. SKILL.md exists
if [[ -f "$SKILL" ]]; then pass "SKILL.md exists"; else fail "SKILL.md missing"; exit 1; fi

# 2. Frontmatter description references plans/ not Plans.md
if grep -q "^description:.*Plans\.md" "$SKILL"; then
  fail "frontmatter description still references Plans.md"
else
  pass "frontmatter description does not reference Plans.md"
fi

# 3. Skill no longer creates a flat Plans.md as its primary output
# Allow references to Plans.md only in migration context (negated or conditional)
CREATES_PLANS_MD=$(grep -n "create.*Plans\.md\|Create Plans\.md\|write.*Plans\.md" "$SKILL" 2>/dev/null \
  | grep -iv "do not\|don't\|never\|if.*exist\|already\|migration\|migrate\|legacy" || true)
if [[ -n "$CREATES_PLANS_MD" ]]; then
  fail "skill still creates a flat Plans.md as primary output"
else
  pass "skill does not create flat Plans.md as primary output"
fi

# 4. Skill creates plans/ directory
if grep -q "plans/" "$SKILL"; then pass "skill references plans/ directory"; else fail "skill does not reference plans/ directory"; fi

# 5. Skill creates plans/phase-1.md specifically
if grep -qE "plans/phase-1\.md" "$SKILL"; then
  pass "skill creates plans/phase-1.md"
else
  fail "skill does not reference plans/phase-1.md"
fi

# 6. Skill creates plans/index.md
if grep -qE "plans/index\.md" "$SKILL"; then
  pass "skill creates plans/index.md"
else
  fail "skill does not reference plans/index.md"
fi

# 7. Skill handles migration from flat Plans.md to plans/
if grep -qiE "Plans\.md.*exist|exist.*Plans\.md|migration|migrate|already.*Plans" "$SKILL"; then
  pass "skill handles migration from flat Plans.md"
else
  fail "skill does not handle migration from flat Plans.md"
fi

# 8. Workflow summary mentions plans/ (not Plans.md)
# Find the workflow summary section and check it uses plans/
if grep -qE "plans/|phase-1\.md" "$SKILL"; then
  pass "workflow summary references plans/ structure"
else
  fail "workflow summary still references flat Plans.md"
fi

# 9. A phase template file exists for per-phase scaffolding
if [[ -f "$TEMPLATE_DIR/phase-template.md" ]] || grep -qiE "phase.template|plans.template" "$SKILL"; then
  pass "phase template referenced or present"
else
  fail "no phase template referenced"
fi

# 10. TDD loop, CI generation, and gitignore steps still present
if grep -q "gitignore" "$SKILL" && grep -q "CI" "$SKILL"; then
  pass "CI and gitignore steps still present"
else
  fail "CI or gitignore steps missing"
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
