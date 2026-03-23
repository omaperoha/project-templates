# {{PROJECT_NAME}} — Architecture Plan

> **Version:** {{VERSION}}
> **Author:** {{AUTHOR}}
> **Date:** {{DATE}}
> **Budget:** {{TOTAL_HOURS}}h
> **Status:** Draft / Peer-Reviewed / Customer-Approved

---

## 1. Executive Summary

{{2-3 sentence overview of what this plan delivers, for whom, and why.}}

---

## 2. Scope & Boundaries

### 2.1 In Scope
- {{List what this project delivers}}

### 2.2 Out of Scope
- {{List what is explicitly excluded}}

### 2.3 Assumptions
- {{List key assumptions that, if wrong, change the plan}}

### 2.4 Data Sensitivity & PII Risk
<!-- If the project handles PII, document it here for customer sign-off -->

| PII Field | Category | Exposure Risk | Mitigation |
|-----------|----------|--------------|-----------|
| {{field}} | High/Medium/Low | {{who can see it}} | {{OLS/RLS/encryption}} |

**Customer must select a mitigation option before development begins:**
- **Option A:** {{description}}
- **Option B:** {{description}}
- **Option C:** {{description}}

---

## 3. Source Data

### 3.1 Source Files

| # | File | Format | Rows (est.) | Columns | Frequency |
|---|------|--------|------------|---------|-----------|
| 1 | {{file1}} | CSV | {{N}} | {{N}} | {{weekly/daily}} |
| 2 | {{file2}} | CSV | {{N}} | {{N}} | {{weekly/daily}} |

### 3.2 Known Data Quality Issues
<!-- Populated after running data profiling notebook -->

---

## 4. Architecture Overview

### 4.1 Medallion Layers

```
Source Files -> [Bronze] -> [Silver] -> [Gold] -> [Semantic Model] -> [BI / Copilot]
                Raw copy    Cleaned     Star        Direct Lake       Reports
                Append      Typed       Schema      Measures          Dashboards
                            Deduped     Aggregated  RLS               AI queries
```

### 4.2 Technology Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| Storage | {{Fabric Lakehouse / Databricks / etc.}} | Delta Lake tables |
| Compute | {{PySpark Notebooks / dbt / etc.}} | Transformations |
| Orchestration | {{Data Factory / Airflow / etc.}} | Pipeline scheduling |
| Semantic | {{Direct Lake / Import / etc.}} | BI consumption |
| Security | {{OLS / RLS / etc.}} | Access control |

---

## 5. Bronze Layer

### 5.1 Design Principles
- Exact copy of source — no transformations
- Append-only with metadata columns: `_load_timestamp`, `_source_filename`
- Schema = source schema + metadata columns

### 5.2 Bronze Tables

| Table | Source | Load Strategy | Notes |
|-------|--------|--------------|-------|
| `bronze_{{table1}}` | {{File 1}} | Full refresh | {{notes}} |

### 5.3 Known Challenges
<!-- e.g., duplicate headers, encoding issues, XLSX reading -->

---

## 6. Silver Layer

### 6.1 Design Principles
- Cleansed, conformed, typed — single source of truth
- Deduplicated using `_row_hash` (SHA-256 of business columns)
- Null normalization per column (see data validation checklist)

### 6.2 Silver Tables

| Table | Source | Key Transformations |
|-------|--------|-------------------|
| `silver_{{table1}}` | `bronze_{{table1}}` | {{type casting, null normalization, dedup}} |

### 6.3 Row Hash Specification
```
SHA256(CONCAT_WS('|', COALESCE(col1,''), COALESCE(col2,''), ...))
```
- All business columns (exclude metadata)
- NULLs replaced with empty string before hashing
- Column order matches Bronze schema order

---

## 7. Gold Layer

### 7.1 Star Schema

| Table | Type | Grain | Key |
|-------|------|-------|-----|
| `dim_{{dimension1}}` | Dimension | One row per {{entity}} | `{{entity}}_code` |
| `fact_{{fact1}}` | Fact | One row per {{event}} | Composite |

### 7.2 Dimension Tables
<!-- Detail each dimension: columns, SCD type, load strategy -->

### 7.3 Fact Tables
<!-- Detail each fact: measures, grain, partitioning -->

### 7.4 Write Strategies

| Table | Strategy | Why |
|-------|----------|-----|
| Dimensions | MERGE (upsert) | Preserves historical records, maintains FK integrity |
| Facts | Append / Overwrite partition | {{reason}} |

---

## 8. Semantic Model

### 8.1 Relationships

| From | To | Cardinality | Active |
|------|-----|------------|--------|
| `fact_{{f1}}.{{key}}` | `dim_{{d1}}.{{key}}` | M:1 | Yes |

### 8.2 Key Measures

| Measure | DAX | Notes |
|---------|-----|-------|
| {{measure_name}} | `{{DAX_expression}}` | {{filter context notes}} |

### 8.3 Row-Level Security
<!-- RLS roles and filter expressions -->

---

## 9. Pipeline Design

### 9.1 Orchestration Flow
```
Trigger (scheduled) -> Bronze Load -> Silver Transform -> Gold Build -> Semantic Refresh
```

### 9.2 Error Handling
- Each stage validates row counts before proceeding
- Failed stages do not propagate to downstream
- Alert via {{email/Teams/Slack}} on failure

---

## 10. Effort Estimate

| Phase | Task | Hours |
|-------|------|-------|
| 1. Setup | Environment, Git, permissions | {{N}} |
| 2. Bronze | Ingestion notebooks, testing | {{N}} |
| 3. Silver | Transformation, data quality | {{N}} |
| 4. Gold | Star schema, measures | {{N}} |
| 5. Semantic | Model, RLS, DAX | {{N}} |
| 6. Pipeline | Orchestration, monitoring | {{N}} |
| 7. Testing | E2E validation, UAT | {{N}} |
| 8. Documentation | Runbook, handoff | {{N}} |
| **Total** | | **{{TOTAL}}** |

---

## 11. Risks & Mitigations

| Risk | Impact | Probability | Mitigation |
|------|--------|------------|-----------|
| {{risk}} | High/Medium/Low | High/Medium/Low | {{mitigation}} |

---

## 12. Open Questions

| # | Question | Impact | Status |
|---|----------|--------|--------|
| 1 | {{question}} | {{what changes if answered differently}} | Open/Resolved |
