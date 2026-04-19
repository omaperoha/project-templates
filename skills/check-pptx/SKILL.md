---
name: check-pptx
description: "Manual trigger to run PPTX quality checks. Use /check-pptx before generating or committing any presentation. Checks dimensions, KPI counts, schema accuracy, and common mistakes."
version: 1.0.0
author: omaperoha
---

# /check-pptx — Presentation Quality Check

When this skill is triggered, run ALL of these checks:

## 1. Slide Dimensions
```python
from pptx import Presentation
prs = Presentation('target.pptx')
w = prs.slide_width / 914400
h = prs.slide_height / 914400
print(f'{w:.2f} x {h:.2f} inches')
```
- CDW template: **13.33 x 7.50** inches
- pptxgenjs: **10.00 x 5.625** inches
- **FAIL if objects are placed for wrong dimensions**

## 2. KPI Counts Match Content
- If KPI says "9 critical" → table/list must show exactly 9 items
- If KPI says "16 warnings" → table must show exactly 16 rows
- **Count and report mismatches**

## 3. Gold Schema Accuracy
- Plan A: 7 dims + 4 facts (constellation)
- Dims must show PKs AND FKs
- Facts must show FKs AND write strategy
- 14 active + 2 inactive relationships
- **FAIL if wrong table names appear**

## 4. No Plan B References (in Plan A)
- Search for: "Plan B", "90h", "MVP scope"
- **FAIL if found**

## 5. Speaker Notes
- Every slide must have notes
- **Count slides vs notes, report gaps**

## 6. Reskin Check
- If adapting from another presentation: layout should be PRESERVED, only colors changed
- **Flag if content was stripped or redesigned**

## 7. File Safety
- Is the user's original file open? Save as v2/v3 instead
- **WARN if overwriting**

Report PASS/FAIL for each check.
