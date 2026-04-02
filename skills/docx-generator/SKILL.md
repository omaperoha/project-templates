---
name: docx-generator
description: Markdown to DOCX converter with professional formatting. Use this skill when generating Word documents from markdown files. Handles headings, tables, code blocks, Mermaid diagram images, bullet lists, and inline formatting. Trigger on any mention of "docx", "Word document", ".docx", or when the user needs professional document output.
---

# DOCX Generator — Markdown to Word Converter

## Usage
```bash
node scripts/md_to_docx.js <input.md> <output.docx> [--images-dir <dir>]
```

## What It Does
- Converts markdown to professional .docx with docx-js
- Handles: H1-H4 headings, tables (with alternating row shading), bullet/numbered lists, bold/italic/code inline, blockquotes, horizontal rules, code blocks
- Replaces Mermaid code blocks with rendered PNG images from `--images-dir`
- CDW Confidential header, page numbers in footer
- Calibri font, US Letter size, 1" margins
- H1 in CDW Red (#CC0000), H2-H4 in dark grey

## Mermaid Diagram Rendering
For Mermaid diagrams in markdown:
1. Extract .mmd files: parse ```mermaid blocks
2. Render to PNG: use `mermaid-py` package (Python) — `md.Mermaid(graph).to_png(path)` with 5-10s delay between calls to avoid API throttling
3. Embed in docx: `--images-dir` parameter tells the converter where to find rendered PNGs
4. Naming: `diagram_1.png`, `diagram_2.png`, etc. (sequential, matching mermaid block order)

## Dual Format Delivery Rule
ALWAYS generate both .md (for GitHub/technical review) and .docx (for non-technical stakeholders). Regenerate .docx after ANY markdown update — do not let them drift out of sync.

## Dependencies
- Node.js with `docx` package: `npm install docx`
- Python `mermaid-py` for diagram rendering: `py -m pip install mermaid-py`
