#!/usr/bin/env bash
# Test: All skill description fields follow guide formula: WHAT + WHEN + trigger phrases
# AC: Each description states what it does, when to invoke it, and includes 2+ trigger phrases
# Ref: "The Complete Guide to Building Skills for Claude" p.10-11

set -euo pipefail

PASS=0
FAIL=0
SKILLS_DIR="$(dirname "$0")"

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

echo "=== description field quality validation ==="

SKILLS=(
  harness-plan
  harness-work
  harness-review
  harness-setup
  harness-ci
  harness-init
  harness-reflect
  harness-cycle
)

for skill in "${SKILLS[@]}"; do
  FILE="$SKILLS_DIR/$skill/SKILL.md"

  if [[ ! -f "$FILE" ]]; then
    fail "$skill: SKILL.md not found"
    continue
  fi

  # Extract description value (single line between --- delimiters)
  DESC=$(awk '/^---/{found++; next} found==1 && /^description:/{sub(/^description:[[:space:]]*/, ""); print}' "$FILE")

  if [[ -z "$DESC" ]]; then
    fail "$skill: description field is empty or missing"
    continue
  fi

  # 1. Contains WHAT language (non-empty prefix before any "Use when")
  WHAT=$(echo "$DESC" | sed 's/Use when.*//')
  if [[ -n "${WHAT// /}" ]]; then
    pass "$skill: description has WHAT clause"
  else
    fail "$skill: description missing WHAT clause (starts directly with 'Use when')"
  fi

  # 2. Contains WHEN language
  if echo "$DESC" | grep -qiE "use when|when user|trigger"; then
    pass "$skill: description has WHEN clause"
  else
    fail "$skill: description missing WHEN clause ('Use when...' or 'when user...')"
  fi

  # 3. Contains at least 2 quoted trigger phrases or specific verb triggers
  TRIGGER_COUNT=$(echo "$DESC" | { grep -oE "'[^']+'" 2>/dev/null; true; } | wc -l | tr -d ' ')
  if [[ "$TRIGGER_COUNT" -ge 2 ]]; then
    pass "$skill: description has 2+ quoted trigger phrases ($TRIGGER_COUNT found)"
  else
    fail "$skill: description has fewer than 2 quoted trigger phrases ($TRIGGER_COUNT found)"
  fi

  # 4. Under 1024 characters
  LEN=${#DESC}
  if [[ "$LEN" -le 1024 ]]; then
    pass "$skill: description under 1024 chars ($LEN)"
  else
    fail "$skill: description exceeds 1024 chars ($LEN)"
  fi

  # 5. No XML angle brackets (security restriction)
  if ! echo "$DESC" | grep -qE "[<>]"; then
    pass "$skill: no XML angle brackets"
  else
    fail "$skill: description contains XML angle brackets (< or >) — forbidden in frontmatter"
  fi
done

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
