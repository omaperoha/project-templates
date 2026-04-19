---
name: presentation-reviewer
description: QA reviewer for PPTX presentations. Use this skill to audit a presentation for accuracy, consistency, and compliance with project rules before it goes to the customer. Trigger when a presentation needs review, when slides need checking, or before any commit that includes a .pptx file.
version: 1.0.0
author: omaperoha
---

# Presentation Reviewer — QA Agent

## Review Process
1. Read the generator script (`.js` or `.py` file) that produces the PPTX
2. Run all checks below against the script content
3. Report PASS/FAIL for each check with evidence
4. Flag any issues that need fixing

## Universal Checks (all presentations)

### 1. Cross-Plan Contamination
- If this is a specific plan/option, search for references to other plans/options
- **Expected**: ZERO cross-contamination between plan variants

### 2. Hour/Effort Totals
- Verify all hour totals are internally consistent across slides
- Search for stale or conflicting values
- **Expected**: Single consistent total throughout

### 3. Schema Accuracy
- Verify all table/entity names match the architecture plan exactly
- Search for placeholder names (e.g., "Fact Sales", "dim_store", "FactOrders")
- **Expected**: ZERO wrong or placeholder names

### 4. Speaker Notes
- Count `addSlide()` calls and `addNotes()` calls
- **Expected**: Equal counts (every slide has notes)

### 5. Security / PII Language
- Search for: "accept risk", "no masking", "Option A"
- **Expected**: ZERO occurrences — defense-in-depth is always the answer

### 6. Readability
- No slide should have font size < 8pt
- Tables should have column widths that fit content
- No overlapping text elements (check y positions)

### 7. Infographic Placement
- If infographics are included, they must be AFTER their corresponding content slide
- NOT appended at the end in a loop
- **Expected**: Interleaved with content, not batched

### 8. Competitive / Factual Claims
- Any competitive claims must be verified against current (within 30 days) documentation
- ROI formulas must be unit-consistent (annual vs annual, not one-time vs monthly)
- Numbers must be internally consistent across all slides

### 9. Template Compliance
- Slide dimensions match the target template (CDW=13.33×7.50, pptxgenjs default=10×5.625)
- Customer branding/logo present where expected
- No layout placeholder overrides that break template styling

## Report Format
```
## Presentation Review Report
Date: YYYY-MM-DD
File: <generator script path>

| # | Check | Result | Evidence |
|---|-------|--------|----------|
| 1 | Cross-plan contamination | PASS/FAIL | count found |
...

OVERALL: PASS / FAIL (X issues)
```

## Project-Specific Checks
Add project-specific checks in the project's own `.claude/CLAUDE.md` or a project-level skill override. Examples:
- Specific schema table names
- Required question lists
- Customer-specific terminology rules
