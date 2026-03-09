#!/usr/bin/env bash
# Test: All skill frontmatters include distribution-ready metadata fields
# AC: Every SKILL.md has metadata.version, metadata.category, license, compatibility
# Ref: "The Complete Guide to Building Skills for Claude" p.11, p.19, p.31

set -euo pipefail

PASS=0
FAIL=0
SKILLS_DIR="$(dirname "$0")"

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

echo "=== frontmatter metadata validation ==="

SKILLS=(
  harness-plan
  harness-work
  harness-review
  harness-setup
  harness-ci
  harness-init
  harness-reflect
  harness-cycle
  harness-release
)

for skill in "${SKILLS[@]}"; do
  FILE="$SKILLS_DIR/$skill/SKILL.md"

  if [[ ! -f "$FILE" ]]; then
    fail "$skill: SKILL.md not found"
    continue
  fi

  # Extract the YAML frontmatter block (between first pair of ---)
  FRONTMATTER=$(awk '/^---/{count++; if(count==2) exit; next} count==1{print}' "$FILE")

  # 1. Has license field
  if echo "$FRONTMATTER" | grep -qE "^license:"; then
    pass "$skill: license field present"
  else
    fail "$skill: missing license field"
  fi

  # 2. Has compatibility field
  if echo "$FRONTMATTER" | grep -qE "^compatibility:"; then
    pass "$skill: compatibility field present"
  else
    fail "$skill: missing compatibility field"
  fi

  # 3. Has metadata block
  if echo "$FRONTMATTER" | grep -qE "^metadata:"; then
    pass "$skill: metadata block present"
  else
    fail "$skill: missing metadata block"
  fi

  # 4. metadata includes version
  if echo "$FRONTMATTER" | grep -qE "^\s+version:"; then
    pass "$skill: metadata.version present"
  else
    fail "$skill: missing metadata.version"
  fi

  # 5. metadata includes category
  if echo "$FRONTMATTER" | grep -qE "^\s+category:"; then
    pass "$skill: metadata.category present"
  else
    fail "$skill: missing metadata.category"
  fi

  # 6. metadata includes tags
  if echo "$FRONTMATTER" | grep -qE "^\s+tags:"; then
    pass "$skill: metadata.tags present"
  else
    fail "$skill: missing metadata.tags"
  fi
done

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
