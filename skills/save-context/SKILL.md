---
name: save-context
description: "Manual trigger to save all memory, session state, and run skill-builder. Use /save-context when you want to force a context save. Also triggers automatically before git commits via hook."
---

# /save-context — Force Context Save

When this skill is triggered, immediately perform ALL of the following:

1. **Update session state** — Write/update `project_session_state_YYYYMMDD.md` in memory directory with:
   - What was done this session
   - Current git status (branch, last commit)
   - Key decisions made
   - Pending items

2. **Update MEMORY.md index** — Ensure all memory files are listed

3. **Update CLAUDE.md** — Update the "Current Work Status" section with latest completions, decisions, and pending items

4. **Run skill-builder** — Check if any new patterns, API workflows, or lessons need to be captured as skills

5. **Verify skills are current** — Check that pptx-builder, presentation-reviewer, nano-banana, and other project skills reflect the latest learnings

6. **Report** — Tell the user what was saved and what's current

**DO NOT SKIP ANY STEP.** This is the user's backup for when automatic saves fail.
