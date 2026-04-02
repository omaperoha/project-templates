---
name: presentation-reviewer
description: QA reviewer for PPTX presentations in the Fabric Datalake project. Use this skill to audit a presentation for accuracy, consistency, and compliance with project rules before it goes to the customer. Trigger when a presentation needs review, when slides need checking, or before any commit that includes a .pptx file.
---

# Presentation Reviewer — QA Agent

## Review Process
1. Read the generator script (`.js` file) that produces the PPTX
2. Run all checks below against the script content
3. Report PASS/FAIL for each check with evidence
4. Flag any issues that need fixing

## Mandatory Checks

### 1. Plan B References (Plan A presentations only)
- Search for: "Plan B", "plan_b", "90h", "90 hours", "budget-constrained", "MVP scope"
- **Expected**: ZERO occurrences
- **Exception**: None

### 2. Hour Totals
- Plan A: **338h** (or "338 hours")
- Search for stale values: "280h", "280 hours", "250h", "30h", "250 hours", "30 hours"
- **Expected**: Only 338h references (280h acceptable only when explicitly labeled as "base before security")

### 3. Gold Schema Accuracy
- Plan A must show: dim_employee, dim_department, dim_supervisor, dim_job, dim_date, dim_leave_type, dim_benefit_category (7 dims)
- Plan A must show: fact_hours_worked, fact_leave_accruals, fact_benefits, fact_employee_period_totals (4 facts)
- Search for wrong names: "Fact Sales", "Fact Inventory", "FactOrders", "dim_store", "dim_product"
- **Expected**: ZERO wrong names

### 4. Customer Questions Q1-Q13
- All 13 questions must be present
- Q13 (XLSX delivery method) must be included
- Must-resolve items: Q1, Q2, Q3, Q4, Q13
- **Expected**: 13 questions, 5 red/must-resolve

### 5. Speaker Notes
- Count `addSlide()` calls and `addNotes()` calls
- **Expected**: Equal counts (every slide has notes)

### 6. Copilot Status
- Search for: "deferred", "future" near "Copilot"
- **Expected**: Copilot described as IN SCOPE, not deferred
- F64 is a runtime requirement, but data preparation is always in scope

### 7. File Delivery Language
- Search for: "customer delivers", "Paycom delivers", "[Customer] delivers"
- **Expected**: Neutral language — "files arrive", "files land", "SFTP connector pulls"

### 8. PII / Security
- Search for: "accept risk", "Option A", "no masking"
- **Expected**: ZERO occurrences
- Must show defense-in-depth (Landing → Bronze → Silver → Gold → Semantic)

### 9. SFTP Pipeline (Plan A only)
- Must show SFTP as Stage 0 in pipeline
- Must have dedicated slide for SFTP ingestion
- **Expected**: SFTP clearly in scope

### 10. Infographic Placement
- If infographics are included, they must be AFTER their corresponding content slide
- NOT appended at the end in a loop
- **Expected**: Interleaved, not batched

### 11. Readability
- No slide should have font size < 8pt
- Tables should have colW that fits content
- No overlapping text elements (check y positions)

### 12. Silver Tables (Plan A)
- Must list all 5: silver_accruals, silver_supervisors, silver_hours_worked, silver_employee_period_totals, silver_change_log
- **Expected**: 5 Silver tables

### 13. CDW Template Placeholders (python-pptx)
- Title layout (index 0): text set WITHOUT font color overrides
- Agenda: uses BLANK layout (index 26) with manual boxes, NOT AG_LY (index 3)
- Closing layout (index 29): text set WITHOUT font color overrides
- **Expected**: No `p.font.color.rgb` on CDW layout placeholders

### 14. Competitive Claims Accuracy (AI Enablement presentations)
- MCP: Copilot NOW HAS MCP (GA VS Code, March 2026) — don't claim "competitors have 0 MCP"
- Skills: Copilot NOW HAS skills and reads .claude/skills — don't claim exclusive
- Harness is the differentiator, NOT the model — Copilot can use Opus 4.6 too
- **Expected**: Claims verified against March 2026 data

### 15. ROI Math Correctness
- Formula must be: (annual savings - annual cost) / annual cost
- NOT: one-time savings / monthly cost (unit mismatch)
- Numbers must be internally consistent across all slides
- **Expected**: Correct formula, consistent numbers

## Report Format
```
## Presentation Review Report
Date: YYYY-MM-DD
File: <generator script path>

| # | Check | Result | Evidence |
|---|-------|--------|----------|
| 1 | Plan B references | PASS/FAIL | count found |
...

OVERALL: PASS / FAIL (X issues)
```
