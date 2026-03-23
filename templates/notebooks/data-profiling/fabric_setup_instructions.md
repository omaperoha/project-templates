# Running the Data Profiling Notebook in Microsoft Fabric

> **Purpose:** Step-by-step guide to run the data profiling notebook in your Fabric workspace.

---

## Prerequisites

- Microsoft Fabric workspace with **PBI Premium** or **Fabric capacity** (P or F SKU)
- Capacity must be **running** (not paused)
- Your source files ready to upload (CSV, XLSX, or Parquet)

---

## Step 1: Create a Lakehouse

1. Go to [app.fabric.microsoft.com](https://app.fabric.microsoft.com)
2. In the left navigation, select your workspace
3. Click **+ New item** -> **Lakehouse**
4. Name it `data_profiling_lakehouse` -> Click **Create**
5. You should see the Lakehouse explorer with **Tables** and **Files** sections

---

## Step 2: Upload Source Files

1. In the Lakehouse explorer, click **Files** in the left panel
2. Click **New subfolder** -> name it `raw`
3. Open the `raw` folder -> click **Upload** -> **Upload files**
4. Select your source files. Wait for upload to complete.
5. Verify all files appear under `Files/raw/`

> **Important:** File names are **case-sensitive**. Note the exact names for the configuration step.

---

## Step 3: Create the Notebook

1. From the Lakehouse explorer, click **Open notebook** -> **New notebook** in the top toolbar
   - This automatically attaches the Lakehouse to the notebook
2. Alternatively: go to your workspace -> **+ New item** -> **Notebook**, then attach the Lakehouse:
   - Click **Lakehouses** in the left panel -> **Add** -> select your Lakehouse

---

## Step 4: Set Up the Notebook Cells

The notebook code is in `nb_data_profiling_template.py`. Copy each section into separate cells. Look for the `# %%` markers — each one is a new cell.

### Creating cells:

1. Click in the first cell
2. Paste the code for **Cell 1** (`%pip install openpyxl`)
3. Hover below the cell -> click **+ Code** to add the next cell
4. Paste the next section
5. Repeat for all sections

> **Tip:** To add a Markdown cell, click **+ Code** then change the cell type dropdown from "Code" to "Markdown".

---

## Step 5: Configure File Names

In the **Configuration** cell, update the file names and join keys to match your data:

```python
CONFIG = {
    "file1_name": "Your_File_1.csv",       # <- Change to match
    "file2_name": "Your_File_2.csv",       # <- Change to match
    "file3_name": "Your_File_3.xlsx",      # <- Change to match
    "join_key_file1": "Employee_Code",     # <- Your cross-file join key
    "join_key_file2": "Employee_Code",
    "join_key_file3": "EE_Code",
    ...
}
```

Match the **exact** file names (case-sensitive) as shown in the Lakehouse Files explorer.

---

## Step 6: Run the Notebook

### Option A: Run All (recommended)
- Click **Run all** in the notebook toolbar
- The first Spark operation takes **30-60 seconds** to start — this is normal
- Total run time: approximately **2-5 minutes** for small datasets (<10K rows)

### Option B: Run Cell by Cell
- Click the **Play** button on each cell, starting from Cell 1
- Run cells **in order** (top to bottom)
- Do not skip cells — later cells depend on earlier ones

### What to expect:
- **Cell 1** (`%pip install`): ~15 seconds
- **Cell 2** (Config): Instant, prints file check results
- **Cell 3** (Helpers): ~30-60s on first run (Spark session startup)
- **Cells 4-6** (Load files): A few seconds each, prints row/column counts
- **Cells 7-10** (Profiling): 10-30s each, prints findings
- **Cell 11** (Cross-file): ~10s, prints overlap analysis
- **Cell 12** (Null map): Renders HTML table inline
- **Cell 13** (Summary): Renders full HTML report
- **Cell 14** (Delta save): ~5s, confirms table writes
- **Cell 15** (Export): ~2s, writes portable CSV/JSON files

---

## Step 7: Download Results

1. In the Lakehouse explorer, expand **Files** -> **output**
2. Download **all files**:

| File | Purpose | Who needs it |
|------|---------|-------------|
| `profiling_bundle.json` | **Complete profiling data** | **Claude Code** (Silver layer design) |
| `profiling_findings.csv` | All findings with severity | You + team |
| `null_convention_map.csv` | Per-column null patterns | Developer (Silver config) |
| `profiling_results.csv` | Full per-column details | Developer (reference) |
| `file_headers.json` | Column names for mapping | Developer (column mapping) |
| `profiling_report.html` | Visual HTML report | Stakeholders |

---

## Step 8: Bring Results Back for Silver Layer Design

1. **Create a results folder** in your project repo:
   ```
   docs/profiling_results/
   ```

2. **Copy the downloaded files** into that folder

3. **Start a Claude Code session** and say:
   > "Read the profiling results in `docs/profiling_results/profiling_bundle.json` and design the Silver layer transformations."

4. Claude Code will read all findings and generate the exact PySpark transformations for your Silver layer notebook.

> **Note:** The `profiling_bundle.json` contains NO real data — only metadata (column names, types, null counts, patterns). Safe to store in the repo.

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "No Lakehouse attached" error | Click **Lakehouses** in left panel -> Add -> select your Lakehouse |
| File not found | Check file name case. Upload to `Files/raw/` (not `Tables/`) |
| `%pip install` fails | Ask your Fabric admin to add the library to a Fabric Environment |
| Spark session timeout | Click **Run all** instead of cell-by-cell |
| Garbled characters in names | The notebook auto-detects CP1252 encoding. If still garbled, manually set encoding in CONFIG |
| "Capacity is not active" | Ensure your Fabric/Premium capacity is running (not paused) |
| Cell output truncated | Scroll down in the cell output area |
