---
name: remind-rules
description: "Manual trigger to print ALL presentation rules, dimension requirements, and common mistakes. Use /remind-rules when starting PPTX work or when you suspect rules are being forgotten."
version: 1.0.0
author: omaperoha
---

# /remind-rules — Print All Rules

When this skill is triggered, print this COMPLETE list:

## Slide Dimensions
- **CDW template**: 13.33" x 7.50" (12192000 x 6858000 EMU)
- **pptxgenjs**: 10.00" x 5.625" (9144000 x 5143500 EMU)
- ALWAYS verify before placing ANY object

## Content Rules
1. Never reference Plan B in Plan A (and vice versa)
2. Show 338h total — never split into 250h DE + 30h AE
3. Copilot readiness is ALWAYS in scope (not deferred)
4. Neutral file delivery: "Files arrive in Landing Zone" not "customer/Paycom delivers"
5. Never cite user notes as sources
6. "Accept risk" is never an option for PII — defense-in-depth is default
7. KPI counts MUST match table rows exactly (9 critical = 9 items, 16 warnings = 16 rows)

## Architecture Accuracy
- Plan A Gold: 7 dims + 4 facts (constellation schema)
- Gold dims MUST show PKs AND FKs
- Gold facts MUST show FKs AND write strategy (MERGE vs Snapshot)
- 14 active + 2 inactive relationships (16 total)
- SFTP Pipeline is IN SCOPE for Plan A (Stage 0)
- Security: 5 layers (Landing → Bronze → Silver → Gold → Semantic Model)
- Only 2 CSVs from Paycom SFTP. XLSX is customer-maintained.

## Design Rules
- **Reskin, don't redesign** — if a slide looked great, keep the layout, just swap colors
- Don't force/deform images
- Tables must be legible at presentation distance
- Max 6-8 items per slide
- Fill the canvas — no 75% dead space from dimension mismatch

## CDW Brand Colors
| CDW Red | CC0000 | CDW Red 2 | EE2737 |
| Dark Grey | 54565B | Dark Grey 2 | 3D2E2D (NOT for backgrounds — looks brown) |
| Light Grey | 888B8F | White | FFFFFF |

## File Safety
- Save as NEW file (v2/v3) when original may be open
- Windows locks open files

## Common Mistakes to Avoid
1. Placing 10" objects on 13.33" canvas
2. Redesigning slides instead of reskinning
3. Consolidating KPI items (16 warnings shown as 10)
4. Missing FKs in Gold schema
5. Using CDW_DARK2 (3D2E2D) for backgrounds (looks brown)
6. Overwriting user's open PPTX file
7. Forgetting speaker notes
8. Not running skill-builder before commits
