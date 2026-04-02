---
name: team-status
description: "Show the status of all specialist agents/subagents. Use /team-status to see which agents are available, running, or idle. Also reports if skill-builder has been running this session."
---

# /team-status — Agent Team Status

When triggered, report the status of EVERY specialist agent:

## Agent Roster

| Agent | Skill | Role | Status |
|-------|-------|------|--------|
| **Architect** | `fabric-architect` | Medallion design, schema decisions, pipeline architecture | ? |
| **PPTX Builder** | `pptx-builder` | Build/fix presentations (pptxgenjs + python-pptx) | ? |
| **Presentation Reviewer** | `presentation-reviewer` | QA audit before commit (dimensions, KPIs, schema) | ? |
| **Nano Banana** | `nano-banana` | Generate infographics via Replicate API | ? |
| **Security IT** | `security-reviewer` | PII masking, OLS/RLS, compliance review | ? |
| **Doc Sync** | `doc-sync` | Keep all 13+ markdown docs consistent | ? |
| **Skill Builder** | `skill-builder` | Capture patterns, save lessons, update skills | ? |
| **Save Context** | `save-context` | Memory save, session state, CLAUDE.md update | ? |
| **Check PPTX** | `check-pptx` | Dimension checks, KPI validation, file safety | ? |
| **Remind Rules** | `remind-rules` | Print all rules and common mistakes | ? |

## For Each Agent, Report:

1. **Last used this session?** (Yes/No + what task)
2. **Currently running?** (Check background tasks)
3. **Skill file up to date?** (Check last modified date)
4. **Any pending work?** (Unfinished tasks from this agent)

## Automatic Checks:

1. **Skill Builder**: Has it run this session? If NO → flag as "ON VACATION — needs to be invoked"
2. **Background tasks**: List any running agent tasks with their IDs
3. **Stale skills**: Any skill files older than 2 days that should be updated?

## Quick Actions:
- If skill-builder hasn't run → offer to invoke it
- If presentation-reviewer hasn't checked the latest PPTX → offer to run /check-pptx
- If save-context hasn't saved this session → offer to run /save-context
