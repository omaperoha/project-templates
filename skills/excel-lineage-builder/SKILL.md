---
name: Excel Field Lineage Builder
description: Generate multi-sheet Excel field lineage trackers with openpyxl for data platform projects
---

# Excel Field Lineage Builder

Build source-to-Gold column-level traceability workbooks for Medallion architecture projects.

## When to Use
- After architecture plan is finalized (Gold schema, relationships, DAX measures defined)
- Before development starts — validates every source column has a destination
- For customer sign-off on field-by-field transformation logic

## Output Structure (6 sheets)

### Sheet 1: Summary
- Source column counts per file
- Status breakdown: MAPPED / DERIVED / GENERATED / PENDING / DISCARDED / METADATA
- PII classification counts
- Gold layer stats (columns, relationships, measures)
- Color legend and usage instructions

### Sheet 2: Full Lineage (main tracker)
One row per source column with 19 attributes:
```
source_file, source_column_name, source_column_group,
bronze_column_name, silver_table, silver_column_name,
silver_data_type, silver_transformation,
gold_table, gold_column_name, gold_data_type, gold_transformation,
is_fk, fk_target, pii_class, pii_treatment,
status, pending_decision, notes
```

**Special rows:**
- Pivoted date columns → collapse to 1 UNPIVOT row with note
- Derived columns (surrogate keys, is_active, FK lookups) → source_file="DERIVED"
- Generated reference tables (dim_date, dim_leave_type) → source_file="GENERATED"

### Sheet 3: Gold Schema + Copilot Readiness
One row per Gold column with Copilot metadata:
```
copilot_description (max 200 chars), copilot_synonyms,
display_folder, data_category, default_summarization,
is_featured_table, is_hidden_from_copilot, ols_hidden,
copilot_ready_status
```

### Sheet 4: Relationships
All star schema relationships with cardinality, cross-filter, active/inactive, DAX USERELATIONSHIP.

### Sheet 5: DAX Measures
All measures with folder, formula summary, description, referenced tables/columns.

### Sheet 6: Pending Decisions
Filtered view of PENDING_CUSTOMER items with impact and priority.

## Implementation Pattern

### 1. Use helper functions for repetitive column groups
```python
def _ben(src_file, silver_tbl, name, code, pfx, has_cov, note):
    """Generate 4-5 lineage rows for a benefit group."""
    rows = []
    if has_cov:
        rows.append([...coverage row...])
    rows.append([...plan row...])
    rows.append([...benefit_status row...])
    rows.append([...ee_per_pay_period row...])
    rows.append([...monthly_premium row...])
    return rows
```

### 2. CDW-branded formatting
```python
CDW_DARK_BLUE = "112E66"  # Header background
CDW_LIGHT_BLUE = "E8F0FE"  # Alternating rows
HDR_FONT = Font(name="Source Sans Pro", size=10, bold=True, color="FFFFFF")
```

### 3. Conditional formatting by status
- GREEN (#C6EFCE) → MAPPED / COMPLETE
- YELLOW (#FFEB9C) → DERIVED / GENERATED / NEEDS_*
- RED (#FFC7CE) → PENDING_CUSTOMER
- GRAY (#D9D9D9) → DISCARDED / METADATA

### 4. PII border highlighting
- Orange left border → HIGH PII columns
- Yellow left border → MEDIUM PII columns

### 5. Freeze panes + auto-filter on all sheets

## QA Verification Checklist
1. **No orphans:** Every source column has a status (never blank)
2. **HIGH PII coverage:** Every HIGH PII column has pii_treatment != N/A
3. **FK integrity:** Every is_fk=YES has a valid fk_target table in Gold schema
4. **Row counts match:** Source file counts match architecture plan
5. **Gold column count:** Cross-reference with architecture plan
6. **Relationship count:** Active + Inactive matches plan

## Dependencies
- `openpyxl` (pip install openpyxl)
- All data hardcoded inline (no dynamic markdown parsing) for reliability

## Reference Implementation
See `Fabric-Datalake/scripts/build_field_lineage.py` (~1250 lines, generates 48KB xlsx with 230 lineage rows).
