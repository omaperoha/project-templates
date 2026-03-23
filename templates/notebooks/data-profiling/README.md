# Data Profiling Notebook Template

A PySpark data profiling notebook designed to run in Microsoft Fabric. Profiles raw source files and produces a portable JSON bundle for downstream transformation design.

## What It Does

- **38 automated checks** across encoding, headers, types, nulls, PII, cross-file joins
- **Portable output** — `profiling_bundle.json` can be shared with Claude Code or any tool for automated Silver layer design
- **HTML report** — color-coded, self-contained report for stakeholders
- **Delta table exports** — results persisted in Lakehouse for querying

## Checks Performed

| Category | Checks |
|----------|--------|
| File Structure | BOM detection, header shift (metadata rows), encoding detection (UTF-8/CP1252) |
| Column Headers | Duplicate detection, disambiguation with positional suffixes |
| Data Types | Inferred type per column (string, integer, decimal, date, boolean) |
| Null Patterns | Null/blank/NA percentages, null convention detection, Silver recommendation |
| PII Detection | SSN patterns, email patterns, phone numbers, ZIP codes |
| Date Formats | Format detection (MM/DD/YYYY, YYYY-MM-DD, etc.), consistency check |
| Numeric Issues | Currency symbols, commas, negative values, non-numeric in numeric columns |
| Cross-File | Join key matching, format consistency, orphan detection |
| Excel-Specific | Hidden sheet detection, formula wrappers, sheet enumeration |
| Data Quality | Leading zeros, whitespace padding, duplicate rows, rehire detection |

## How to Customize

### 1. Configure your files

In the Configuration cell, update `CONFIG`:

```python
CONFIG = {
    "file1_name": "your_file_1.csv",
    "file2_name": "your_file_2.csv",
    "file3_name": "your_file_3.xlsx",
    "join_key_file1": "Employee_Code",    # Column name for cross-file join
    "join_key_file2": "Employee_Code",
    "join_key_file3": "EE_Code",
    "pii_columns": ["Name", "SSN", "Email", "Phone", "Address"],
    "output_folder": "/lakehouse/default/Files/output",
}
```

### 2. Add or remove files

The template supports 2-5 source files. To add File 4:
- Duplicate the "Load File 3" cell
- Duplicate the "Profile File 3" cell
- Add File 4 to the cross-file validation cell

### 3. Add custom checks

In the helpers cell, add functions to `CUSTOM_CHECKS`:

```python
def check_custom_rule(pdf, col_name):
    """Your custom validation logic"""
    values = pdf[col_name].dropna()
    if some_condition:
        FINDINGS.append({
            "severity": "WARNING",
            "section": "Custom",
            "column": col_name,
            "message": "Description of the issue",
            "details": "What to do about it"
        })
```

## Files

| File | Purpose |
|------|---------|
| `nb_data_profiling_template.py` | The notebook — copy cells into Fabric |
| `generate_test_data_template.py` | Generates synthetic test data with planted issues |
| `test_profiling_template.py` | Local test runner (validates all checks work) |
| `fabric_setup_instructions.md` | Step-by-step Fabric execution guide |

## Output Files

After running, download from `Files/output/` in the Lakehouse:

| File | Purpose |
|------|---------|
| `profiling_bundle.json` | Complete results — share with Claude Code for Silver design |
| `profiling_findings.csv` | All findings with severity |
| `null_convention_map.csv` | Per-column null patterns with Silver recommendations |
| `profiling_results.csv` | Full per-column profiling details |
| `file_headers.json` | Original and renamed column names |
| `profiling_report.html` | Visual HTML report for stakeholders |

## Workflow

```
1. Upload source files to Lakehouse Files/raw/
2. Create notebook, paste cells from template
3. Update CONFIG with your file names and join keys
4. Run All
5. Download profiling_bundle.json
6. Place in your project repo: docs/profiling_results/
7. Tell Claude Code: "Read profiling_bundle.json and design Silver transforms"
```
