---
name: doc-sync
description: Documentation synchronization agent for data platform projects. Use this skill when updating, auditing, or ensuring consistency across multiple markdown documents in the docs/ folder. Trigger whenever multiple documents need to be updated together, when a decision changes that affects multiple files, or when verifying all docs are aligned on key facts (hours, approach, scope, customer questions).
version: 1.0.0
author: omaperoha
---

# Doc Sync — Documentation Consistency Agent

## Process
1. **Read EVERY file before editing** — never make assumptions about current content
2. **Apply changes across ALL affected files** — never update just one
3. **Verify consistency after edits** — spot-check key facts across files

## Universal Consistency Checks

### Effort / Hours
- Verify all hour totals are consistent across all documents
- Check for stale values that predate the last architecture revision
- Never split totals in a way that contradicts the agreed plan

### Security / PII Approach
- **Defense-in-depth** is the default — mask HIGH at Bronze, pseudonymize MEDIUM at Silver, Gold fully masked
- **"Accept risk" is NOT an option** anywhere
- Remove all "Option A/B/C" language — replace with the agreed default

### Scope Statements
- Verify scope boundary is stated consistently (e.g., what is in/out of scope for each plan)
- Confirm all docs reflect the latest confirmed scope decisions

### File Delivery Language
- Use neutral language: "Files arrive in the Landing Zone"
- Avoid asserting who delivers (customer, vendor, system) unless confirmed

### Open Questions / Customer Questions
- All question lists must be present and numbered consistently
- Summary tables must match individual question sections
- Must-resolve items must be flagged consistently

### Gold Schema
- Table names must match the architecture plan exactly
- Fact/dim counts must be consistent across all documents
- Never mix schema variants between plan documents

### Copilot / AI Readiness
- Copilot readiness scope must be stated consistently across all docs
- If column descriptions are in scope, all docs must reflect that

## How to Use in a Project

In your project's `CLAUDE.md` or a project-level skill override, add:

```markdown
## Doc Sync File List
| File | Key Content |
|------|-------------|
| docs/01_discovery.md | ... |
| docs/02_schema.md    | ... |
```

The doc-sync skill will use that file list. If none is defined, it will scan all `docs/*.md` files automatically.
