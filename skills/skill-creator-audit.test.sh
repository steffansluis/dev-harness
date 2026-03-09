#!/usr/bin/env bash
# Test: All 8 skills pass the skill-creator audit checklist
# AC: No CRITICAL or IMPORTANT findings on description quality, triggering accuracy,
#     or structural completeness
# Ref: "The Complete Guide to Building Skills for Claude" p.30 (Reference A: Quick checklist)

set -euo pipefail

PASS=0
FAIL=0
SKILLS_DIR="$(dirname "$0")"

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

echo "=== skill-creator audit checklist (Reference A, p.30) ==="

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

  FRONTMATTER=$(awk '/^---/{count++; if(count==2) exit; next} count==1{print}' "$FILE")

  # --- CRITICAL checks (from Reference A "During development") ---

  # Folder named in kebab-case
  if echo "$skill" | grep -qE "^[a-z][a-z0-9-]+$"; then
    pass "$skill: folder name is kebab-case"
  else
    fail "$skill: folder name is not kebab-case (CRITICAL)"
  fi

  # SKILL.md file exists (exact spelling)
  if [[ -f "$FILE" ]]; then
    pass "$skill: SKILL.md exists (exact spelling)"
  else
    fail "$skill: SKILL.md missing (CRITICAL)"
  fi

  # YAML frontmatter has --- delimiters
  FIRST_LINE=$(head -1 "$FILE")
  if [[ "$FIRST_LINE" == "---" ]]; then
    pass "$skill: YAML frontmatter has --- delimiter"
  else
    fail "$skill: YAML frontmatter missing --- delimiter (CRITICAL)"
  fi

  # name field is kebab-case
  NAME=$(echo "$FRONTMATTER" | awk '/^name:/{sub(/^name:[[:space:]]*/, ""); print}')
  if echo "$NAME" | grep -qE "^[a-z][a-z0-9-]+$"; then
    pass "$skill: name field is kebab-case ($NAME)"
  else
    fail "$skill: name field is not kebab-case: '$NAME' (CRITICAL)"
  fi

  # name matches folder name
  if [[ "$NAME" == "$skill" ]]; then
    pass "$skill: name matches folder name"
  else
    fail "$skill: name '$NAME' does not match folder name '$skill' (CRITICAL)"
  fi

  # description includes WHAT and WHEN
  DESC=$(echo "$FRONTMATTER" | awk '/^description:/{sub(/^description:[[:space:]]*/, ""); print}')
  if echo "$DESC" | grep -qiE "use when|when user|use this when|trigger this"; then
    pass "$skill: description includes WHEN clause"
  else
    fail "$skill: description missing WHEN clause (IMPORTANT — vague description)"
  fi

  # No XML angle brackets
  if ! echo "$DESC" | grep -qE "[<>]"; then
    pass "$skill: no XML angle brackets in description"
  else
    fail "$skill: XML angle brackets in description (CRITICAL — security)"
  fi

  # Instructions are present (skill body is non-trivial)
  BODY_LINES=$(awk '/^---/{count++; next} count>=2{print}' "$FILE" | grep -c "^#" || true)
  if [[ "$BODY_LINES" -ge 2 ]]; then
    pass "$skill: instructions are present ($BODY_LINES headings)"
  else
    fail "$skill: instructions appear sparse (IMPORTANT)"
  fi

  # References clearly linked (if references/ dir exists, skill mentions it)
  if [[ -d "$SKILLS_DIR/$skill/references" ]]; then
    if grep -qiE "references/" "$FILE"; then
      pass "$skill: references/ directory is referenced in SKILL.md"
    else
      fail "$skill: references/ directory exists but not mentioned in SKILL.md (MINOR)"
    fi
  else
    pass "$skill: no references/ directory (none needed)"
  fi

  # No README.md inside skill folder (guide p.10: forbidden)
  if [[ ! -f "$SKILLS_DIR/$skill/README.md" ]]; then
    pass "$skill: no README.md inside skill folder"
  else
    fail "$skill: README.md found inside skill folder (CRITICAL — not allowed per guide)"
  fi
done

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
