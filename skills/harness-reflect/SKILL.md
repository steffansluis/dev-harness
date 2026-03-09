---
name: harness-reflect
description: Read the current harness, collect retrospective feedback, and propose targeted amendments to gate files and constraint documents.
triggers:
  - harness-reflect
  - reflect on harness
  - update harness
  - amend harness
  - harness retrospective
  - retrospective
---

# harness-reflect

You read the current `harness/` directory, collect structured retrospective feedback
from the user, and propose targeted amendments to harness files. You do not apply
any changes without user confirmation.

Follow these steps in order.

---

## Step 1: Read the Current Harness

Read all files in `harness/`:
- `harness/work.md` — current local gate contract
- `harness/review.md` — current review constraints
- `harness/release.md` — current remote gate and release contract
- `harness/gates/*.md` — each enabled or available gate

Summarise the current state in one paragraph: which gates are enabled, what
locality they run at, and any obvious gaps.

---

## Step 2: Collect Retrospective Feedback

Ask the user the following structured questions. Wait for their answers before
proceeding to Step 3.

```
Retrospective questions:

1. What is working well in the current harness?
   (gates that catch real issues, gates that feel appropriately fast)

2. What is creating friction or slowing you down?
   (gates that feel too slow, too strict, rarely triggered, or hard to satisfy)

3. What issues reached review or CI that the harness should have caught earlier?
   (bugs, regressions, missing docs, or quality problems that slipped through)

4. Are there any gates you wish were enabled but aren't?

5. Are there any gates that feel unnecessary for this project?
```

If the user provides only partial answers, ask follow-up questions for the
unanswered ones before proceeding.

---

## Step 3: Propose Targeted Amendments

Based on the feedback, propose specific amendments to harness files. Each amendment
must be targeted — change only what the feedback justifies. Do not rewrite files
wholesale.

Format each proposed amendment as a diff block:

```
## Proposed Amendment 1 — <file>: <one-line reason>

File: harness/gates/acceptance.md

- **Runs: remote** — the acceptance suite is too slow ...
+ **Runs: both** — the acceptance suite can run locally for feature tasks
+                   using `playwright test --headed` in under 30 seconds.
```

After listing all proposed amendments, ask:

```
Accept changes? Reply with:
  all       — apply all amendments
  <numbers> — apply only listed amendments (e.g. "1 3")
  none      — discard all and exit
```

---

## Step 4: Apply Accepted Amendments

Apply only the amendments the user accepted. For each accepted amendment:
1. Read the target file
2. Apply the change precisely as specified in the diff
3. Confirm the edit was applied: "Applied amendment N to <file>"

Do not apply any amendment the user did not explicitly accept.

---

## Step 5: Confirm and Summarise

Print a summary of what changed:

```
harness-reflect complete.

Amendments applied:
  harness/gates/acceptance.md — Runs: changed from remote to both
  harness/work.md — coverage threshold raised from 80% to 90%

Amendments discarded:
  harness/gates/i18n.md — user chose not to enable

Next: run /harness-work to continue with the next task.
```
