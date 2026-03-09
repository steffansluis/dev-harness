#!/usr/bin/env bash
set -euo pipefail

SKILLS_DIR="$(dirname "$0")"
PASS=0; FAIL=0

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

echo "=== evals coverage validation ==="

EVAL_SKILLS=(harness-work harness-review harness-plan harness-cycle)

for skill in "${EVAL_SKILLS[@]}"; do
  evals_file="$SKILLS_DIR/$skill/evals/evals.json"

  # File exists
  if [[ -f "$evals_file" ]]; then
    pass "$skill: evals/evals.json exists"
  else
    fail "$skill: evals/evals.json missing"
    continue
  fi

  # Valid JSON
  if python3 -c "import json,sys; json.load(open('$evals_file'))" 2>/dev/null; then
    pass "$skill: evals.json is valid JSON"
  else
    fail "$skill: evals.json is not valid JSON"
    continue
  fi

  # Has skill_name field
  skill_name=$(python3 -c "import json; d=json.load(open('$evals_file')); print(d.get('skill_name',''))" 2>/dev/null)
  if [[ -n "$skill_name" ]]; then
    pass "$skill: has skill_name field ('$skill_name')"
  else
    fail "$skill: missing skill_name field"
  fi

  # Has evals array with 2+ entries
  eval_count=$(python3 -c "import json; d=json.load(open('$evals_file')); print(len(d.get('evals',[])))" 2>/dev/null)
  if [[ "$eval_count" -ge 2 ]]; then
    pass "$skill: has $eval_count evals (>= 2)"
  else
    fail "$skill: only $eval_count evals (need >= 2)"
  fi

  # Each eval has id, prompt, expected_output
  missing_fields=$(python3 -c "
import json
d = json.load(open('$evals_file'))
missing = []
for e in d.get('evals', []):
    for f in ['id', 'prompt', 'expected_output']:
        if f not in e:
            missing.append(f'eval {e.get(\"id\",\"?\")}: missing {f}')
print('\n'.join(missing))
" 2>/dev/null)
  if [[ -z "$missing_fields" ]]; then
    pass "$skill: all evals have required fields (id, prompt, expected_output)"
  else
    fail "$skill: evals missing fields — $missing_fields"
  fi

  # Each prompt is substantive (> 50 chars)
  short_prompts=$(python3 -c "
import json
d = json.load(open('$evals_file'))
short = [str(e.get('id','?')) for e in d.get('evals', []) if len(e.get('prompt','')) <= 50]
print('\n'.join(short))
" 2>/dev/null)
  if [[ -z "$short_prompts" ]]; then
    pass "$skill: all prompts are substantive (> 50 chars)"
  else
    fail "$skill: prompts too short (eval ids: $short_prompts)"
  fi
done

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
