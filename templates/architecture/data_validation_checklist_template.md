# Data Validation Checklist — Silver Layer Transformations

> **Purpose:** Use this checklist when the first production data samples arrive. For each column, inspect actual values to determine the correct Silver-layer transformation.
>
> **How to use:** Open each source file with actual data. For each column below, check the items listed and record findings. This directly informs the Bronze-to-Silver notebook configuration.
>
> **Automation:** Use the data profiling notebook (`templates/notebooks/data-profiling/`) to automate most of these checks. This checklist serves as the human-readable reference.

---

## File {{N}}: {{File Name}} ({{Format}}, ~{{N}} columns)

### {{Column Group Name}} (Columns {{range}})

| Column | Target Type | What to Check | Why It Matters |
|--------|------------|---------------|----------------|
| `{{column_name}}` | {{TARGET_TYPE}} | {{what_to_inspect}} | {{business_impact}} |

<!-- Copy this pattern for each column group -->

### Common Column Checks

For **every column**, verify:

- [ ] **Null convention:** What represents "no value"? NULL, empty string, "N/A", "0", "-", "None"?
- [ ] **Data type:** Does the actual data match the expected type? Any mixed types?
- [ ] **Leading/trailing whitespace:** Trim needed?
- [ ] **Encoding:** Special characters rendering correctly?

### Type-Specific Checks

**Strings:**
- [ ] Max length — will it fit the target column?
- [ ] Case consistency — mixed case or all upper/lower?
- [ ] Free text vs enumerated values?

**Dates:**
- [ ] Format: `MM/DD/YYYY`, `YYYY-MM-DD`, `M/D/YY`, other?
- [ ] Consistent format across all rows?
- [ ] Any future dates (data quality issue)?
- [ ] What represents "no date"? NULL, blank, "N/A", "12/31/9999"?

**Numbers:**
- [ ] Currency symbols (`$`) or commas (`,`) present?
- [ ] Decimal precision needed?
- [ ] Can be negative?
- [ ] Blank vs "0" — different meaning?

**Booleans:**
- [ ] Values: "Yes"/"No", "Y"/"N", "1"/"0", TRUE/FALSE, blank?
- [ ] What does blank mean — FALSE or unknown?

**IDs / Keys:**
- [ ] Consistent format across files? (e.g., leading zeros)
- [ ] Fixed length or variable?
- [ ] Alphanumeric or purely numeric?

---

## Cross-File Validation

### Join Key Consistency

| Key | File 1 Column | File 2 Column | File 3 Column | Format Match? |
|-----|--------------|--------------|--------------|:------------:|
| {{key_name}} | `{{col}}` | `{{col}}` | `{{col}}` | Yes / No |

### Cross-File Checks

- [ ] **Orphan detection:** Are there IDs in File N not present in File 1?
- [ ] **Format normalization:** Do join keys need padding, trimming, or case normalization?
- [ ] **Manual entries:** Are there records in one file that appear to be manually added (not from the source system)?

---

## Null Convention Decision Matrix

For each column with non-trivial null patterns, decide:

| Column | Source Values Found | Silver Decision | Reason |
|--------|-------------------|-----------------|--------|
| `{{col}}` | NULL, "", "N/A" | Map all to NULL | {{reason}} |
| `{{col}}` | "0", blank | Keep "0" as 0, blank as NULL | "0" means enrolled at zero cost |

---

## Duplicate Column Disambiguation

If source files have duplicate column headers:

| Original Header | Occurrences | Positional Mapping |
|----------------|:-----------:|-------------------|
| `{{header}}` | {{N}} | Col {{X}} -> `{{header}}_group1`, Col {{Y}} -> `{{header}}_group2` |

---

## PII Inventory

| Column | PII Category | Protection Required |
|--------|-------------|-------------------|
| `{{col}}` | High (SSN, salary) | Column encryption + OLS + audit |
| `{{col}}` | Medium (name, email) | OLS masking + RLS |
| `{{col}}` | Low (department) | RLS by role |
