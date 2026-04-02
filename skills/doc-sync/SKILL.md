---
name: doc-sync
description: Documentation synchronization agent for the Fabric Datalake project. Use this skill when updating, auditing, or ensuring consistency across all 13+ markdown documents in the docs/ folder. Trigger whenever multiple documents need to be updated together, when a decision changes that affects multiple files, or when verifying all docs are aligned on key facts (hours, PII approach, SFTP scope, customer questions).
---

# Doc Sync — Documentation Consistency Agent

## Process
1. **Read EVERY file before editing** — never make assumptions about current content
2. **Apply changes across ALL affected files** — never update just one
3. **Verify consistency after edits** — spot-check key facts across files

## Files to Sync (13+ documents)

| File | Key Content |
|---|---|
| `docs/01_discovery_context.md` | Scope, customer profile, source files, design decisions |
| `docs/02_source_schema_analysis.md` | 227 columns, 3 files, data types |
| `docs/03_assumptions_and_questions.md` | Confirmed facts (C1-C10), open questions |
| `docs/04_architecture_plan.md` | **Plan A** — 338h, full scope, SFTP in scope |
| `docs/04b_architecture_plan_90h.md` | **Plan B** — 90h MVP, SFTP NOT in scope |
| `docs/05_peer_review_consolidated.md` | Plan A review findings |
| `docs/05b_peer_review_plan_b.md` | Plan B review findings |
| `docs/06_data_validation_checklist.md` | Column-by-column Silver transformations |
| `docs/07_fabric_notebook_instructions.md` | Fabric execution guide |
| `docs/08_customer_questions.md` | Q1-Q13, prioritized |
| `docs/09_copilot_claude_workflow.md` | AI tool usage per phase |
| `docs/10_work_summary.md` | Time comparison, deliverables |
| `docs/11_customer_requirements.md` | Technical prerequisites |
| `docs/12_sftp_source_analysis.md` | SFTP architecture, file mapping |

## Consistency Checks

### Hours
- Plan A = **338h** (280h base + 58h security). Never show as 280h alone.
- Plan B = **~90h** with Copilot
- Never split Plan A into DE/AE in any doc

### PII Approach
- **Defense-in-depth** — mask HIGH at Bronze, pseudonymize MEDIUM at Silver, Gold fully masked
- **"Accept risk" is NOT an option** anywhere
- Remove all "Option A/B/C" language — replace with defense-in-depth default
- Q2 in customer questions: confirm scope, not choose option

### SFTP Scope
- **Plan A**: SFTP ingestion IS in scope (Data Factory connector)
- **Plan B**: SFTP is NOT in scope (customer/another entity delivers files)
- `01_discovery_context.md` must reflect SFTP in scope for Plan A

### Critical Illness
- **3 different CI plan types** offered by employer (confirmed)
- NOT tiers (Employee/Spouse/Child), NOT plan years
- Pending: official plan names to replace _1/_2/_3 suffixes
- Consistent across all docs

### File Delivery Language
- **Neutral**: "Files arrive in the Landing Zone"
- Never say "customer delivers" or "Paycom delivers"
- SFTP pipeline pulls files (Plan A); another entity delivers (Plan B)

### Customer Questions
- **Q1-Q13** must all be present in `08_customer_questions.md`
- Q13 is NEW: XLSX overtime file delivery method
- Summary table must match individual question sections

### Gold Schema
- Plan A: 7 dims + 4 facts (constellation schema)
- Plan B: 4 dims + 3 facts (simplified star)
- Never mix schemas between plans

### Copilot
- Copilot readiness is ALWAYS in scope
- ALL Gold layer columns need descriptions, not just DAX measures
- F64 is needed for runtime Copilot, but data preparation is in scope regardless
