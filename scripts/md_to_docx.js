/**
 * md_to_docx.js — Convert markdown files to professional .docx
 * Handles: headings, tables, bullet lists, code blocks, bold/italic, images
 * Usage: node scripts/md_to_docx.js <input.md> <output.docx> [--images-dir <dir>]
 */
const fs = require("fs");
const path = require("path");
const {
  Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell,
  ImageRun, HeadingLevel, AlignmentType, BorderStyle, WidthType,
  ShadingType, LevelFormat, PageBreak, Header, Footer, PageNumber
} = require("docx");

const args = process.argv.slice(2);
const inputFile = args[0];
const outputFile = args[1];
const imagesDir = args.indexOf("--images-dir") >= 0 ? args[args.indexOf("--images-dir") + 1] : null;

if (!inputFile || !outputFile) {
  console.log("Usage: node md_to_docx.js <input.md> <output.docx> [--images-dir <dir>]");
  process.exit(1);
}

const md = fs.readFileSync(inputFile, "utf-8");
const lines = md.split("\n");

// Track which mermaid block we're on for image replacement
let mermaidBlockIndex = 0;
const border = { style: BorderStyle.SINGLE, size: 1, color: "CCCCCC" };
const borders = { top: border, bottom: border, left: border, right: border };
const cellMargins = { top: 60, bottom: 60, left: 100, right: 100 };

// Parse inline formatting (bold, italic, code, links)
function parseInline(text) {
  const runs = [];
  // Simple regex-based parsing for **bold**, *italic*, `code`, [text](url)
  let remaining = text;

  while (remaining.length > 0) {
    // Bold: **text**
    let m = remaining.match(/^(.*?)\*\*(.+?)\*\*(.*)/s);
    if (m) {
      if (m[1]) runs.push(new TextRun({ text: m[1], font: "Calibri", size: 22 }));
      runs.push(new TextRun({ text: m[2], bold: true, font: "Calibri", size: 22 }));
      remaining = m[3];
      continue;
    }
    // Inline code: `text`
    m = remaining.match(/^(.*?)`(.+?)`(.*)/s);
    if (m) {
      if (m[1]) runs.push(new TextRun({ text: m[1], font: "Calibri", size: 22 }));
      runs.push(new TextRun({ text: m[2], font: "Consolas", size: 20, color: "CC0000" }));
      remaining = m[3];
      continue;
    }
    // No more formatting — add remainder
    runs.push(new TextRun({ text: remaining, font: "Calibri", size: 22 }));
    break;
  }
  return runs.length > 0 ? runs : [new TextRun({ text: text, font: "Calibri", size: 22 })];
}

// Parse markdown table into rows of cells
function parseTable(tableLines) {
  const rows = [];
  for (const line of tableLines) {
    if (line.match(/^\|[\s-:|]+\|$/)) continue; // Skip separator row
    const cells = line.split("|").filter((_, i, a) => i > 0 && i < a.length - 1).map(c => c.trim());
    if (cells.length > 0) rows.push(cells);
  }
  return rows;
}

// Build docx table
function buildTable(tableRows) {
  if (tableRows.length === 0) return null;
  const numCols = tableRows[0].length;
  const colWidth = Math.floor(9360 / numCols);

  return new Table({
    width: { size: 9360, type: WidthType.DXA },
    columnWidths: Array(numCols).fill(colWidth),
    rows: tableRows.map((row, ri) =>
      new TableRow({
        children: row.map(cell =>
          new TableCell({
            borders,
            width: { size: colWidth, type: WidthType.DXA },
            margins: cellMargins,
            shading: ri === 0 ? { fill: "CC0000", type: ShadingType.CLEAR } :
                     ri % 2 === 0 ? { fill: "F4F4F4", type: ShadingType.CLEAR } : undefined,
            children: [new Paragraph({
              children: ri === 0
                ? [new TextRun({ text: cell, bold: true, color: "FFFFFF", font: "Calibri", size: 20 })]
                : parseInline(cell).map(r => { r.root[1].size = 20; return r; })
            })]
          })
        )
      })
    )
  });
}

// Main conversion
const children = [];
let inCodeBlock = false;
let inMermaidBlock = false;
let codeBlockLines = [];
let tableLines = [];
let inTable = false;
let inBlockquote = false;

for (let i = 0; i < lines.length; i++) {
  const line = lines[i];

  // Mermaid code block
  if (line.trim() === "```mermaid") {
    inMermaidBlock = true;
    codeBlockLines = [];
    continue;
  }

  // Regular code block
  if (line.trim().startsWith("```") && !inMermaidBlock && !inCodeBlock) {
    inCodeBlock = true;
    codeBlockLines = [];
    continue;
  }

  // End of code block
  if (line.trim() === "```" && (inCodeBlock || inMermaidBlock)) {
    if (inMermaidBlock) {
      mermaidBlockIndex++;
      // Try to embed the rendered image
      const imgPath = imagesDir ? path.join(imagesDir, `diagram_${mermaidBlockIndex}.png`) : null;
      if (imgPath && fs.existsSync(imgPath)) {
        const imgData = fs.readFileSync(imgPath);
        children.push(new Paragraph({
          alignment: AlignmentType.CENTER,
          spacing: { before: 200, after: 200 },
          children: [new ImageRun({
            type: "png",
            data: imgData,
            transformation: { width: 620, height: 400 },
            altText: { title: `Diagram ${mermaidBlockIndex}`, description: `Architecture diagram ${mermaidBlockIndex}`, name: `diagram_${mermaidBlockIndex}` }
          })]
        }));
      } else {
        // Fallback: show as code
        children.push(new Paragraph({
          shading: { fill: "F0F0F0", type: ShadingType.CLEAR },
          children: [new TextRun({ text: `[Mermaid Diagram ${mermaidBlockIndex} — render in VS Code with Mermaid Preview extension]`, font: "Consolas", size: 18, italics: true, color: "888888" })]
        }));
      }
    } else {
      // Regular code block
      for (const cl of codeBlockLines) {
        children.push(new Paragraph({
          shading: { fill: "F5F5F5", type: ShadingType.CLEAR },
          spacing: { before: 0, after: 0 },
          children: [new TextRun({ text: cl || " ", font: "Consolas", size: 18 })]
        }));
      }
    }
    inCodeBlock = false;
    inMermaidBlock = false;
    codeBlockLines = [];
    continue;
  }

  if (inCodeBlock || inMermaidBlock) {
    codeBlockLines.push(line);
    continue;
  }

  // Table detection
  if (line.trim().startsWith("|")) {
    tableLines.push(line);
    inTable = true;
    continue;
  } else if (inTable) {
    const tbl = buildTable(parseTable(tableLines));
    if (tbl) children.push(tbl);
    children.push(new Paragraph({ spacing: { after: 100 }, children: [] }));
    tableLines = [];
    inTable = false;
  }

  // Headings
  const h1 = line.match(/^# (.+)/);
  const h2 = line.match(/^## (.+)/);
  const h3 = line.match(/^### (.+)/);
  const h4 = line.match(/^#### (.+)/);

  if (h1) {
    children.push(new Paragraph({ heading: HeadingLevel.HEADING_1, spacing: { before: 360, after: 200 }, children: parseInline(h1[1]) }));
    continue;
  }
  if (h2) {
    children.push(new Paragraph({ heading: HeadingLevel.HEADING_2, spacing: { before: 300, after: 160 }, children: parseInline(h2[1]) }));
    continue;
  }
  if (h3) {
    children.push(new Paragraph({ heading: HeadingLevel.HEADING_3, spacing: { before: 240, after: 120 }, children: parseInline(h3[1]) }));
    continue;
  }
  if (h4) {
    children.push(new Paragraph({ heading: HeadingLevel.HEADING_4, spacing: { before: 200, after: 100 }, children: parseInline(h4[1]) }));
    continue;
  }

  // Horizontal rule
  if (line.trim() === "---") {
    children.push(new Paragraph({
      border: { bottom: { style: BorderStyle.SINGLE, size: 6, color: "CCCCCC", space: 1 } },
      spacing: { before: 100, after: 100 },
      children: []
    }));
    continue;
  }

  // Blockquote
  if (line.startsWith("> ")) {
    children.push(new Paragraph({
      indent: { left: 400 },
      border: { left: { style: BorderStyle.SINGLE, size: 12, color: "CC0000", space: 4 } },
      children: parseInline(line.substring(2))
    }));
    continue;
  }

  // Bullet list
  if (line.match(/^[\s]*[-*] /)) {
    const indent = line.match(/^(\s*)/)[1].length;
    const text = line.replace(/^[\s]*[-*] /, "");
    children.push(new Paragraph({
      indent: { left: 360 + indent * 180, hanging: 180 },
      children: [new TextRun({ text: "• ", font: "Calibri", size: 22 }), ...parseInline(text)]
    }));
    continue;
  }

  // Numbered list
  if (line.match(/^\d+\. /)) {
    const text = line.replace(/^\d+\. /, "");
    const num = line.match(/^(\d+)\./)[1];
    children.push(new Paragraph({
      indent: { left: 360, hanging: 180 },
      children: [new TextRun({ text: `${num}. `, bold: true, font: "Calibri", size: 22 }), ...parseInline(text)]
    }));
    continue;
  }

  // Empty line
  if (line.trim() === "") {
    children.push(new Paragraph({ spacing: { after: 60 }, children: [] }));
    continue;
  }

  // Regular paragraph
  children.push(new Paragraph({ spacing: { after: 80 }, children: parseInline(line) }));
}

// Flush remaining table
if (inTable && tableLines.length > 0) {
  const tbl = buildTable(parseTable(tableLines));
  if (tbl) children.push(tbl);
}

// Build document
const doc = new Document({
  styles: {
    default: { document: { run: { font: "Calibri", size: 22 } } },
    paragraphStyles: [
      { id: "Heading1", name: "Heading 1", basedOn: "Normal", next: "Normal", quickFormat: true,
        run: { size: 36, bold: true, font: "Calibri", color: "CC0000" },
        paragraph: { spacing: { before: 360, after: 200 }, outlineLevel: 0 } },
      { id: "Heading2", name: "Heading 2", basedOn: "Normal", next: "Normal", quickFormat: true,
        run: { size: 30, bold: true, font: "Calibri", color: "333333" },
        paragraph: { spacing: { before: 300, after: 160 }, outlineLevel: 1 } },
      { id: "Heading3", name: "Heading 3", basedOn: "Normal", next: "Normal", quickFormat: true,
        run: { size: 26, bold: true, font: "Calibri", color: "54565B" },
        paragraph: { spacing: { before: 240, after: 120 }, outlineLevel: 2 } },
      { id: "Heading4", name: "Heading 4", basedOn: "Normal", next: "Normal", quickFormat: true,
        run: { size: 24, bold: true, font: "Calibri", color: "54565B" },
        paragraph: { spacing: { before: 200, after: 100 }, outlineLevel: 3 } },
    ]
  },
  sections: [{
    properties: {
      page: {
        size: { width: 12240, height: 15840 },
        margin: { top: 1440, right: 1440, bottom: 1440, left: 1440 }
      }
    },
    headers: {
      default: new Header({ children: [new Paragraph({
        alignment: AlignmentType.RIGHT,
        children: [new TextRun({ text: "CDW Confidential", font: "Calibri", size: 16, color: "999999", italics: true })]
      })] })
    },
    footers: {
      default: new Footer({ children: [new Paragraph({
        alignment: AlignmentType.CENTER,
        children: [new TextRun({ text: "Page ", font: "Calibri", size: 16, color: "999999" }), new TextRun({ children: [PageNumber.CURRENT], font: "Calibri", size: 16, color: "999999" })]
      })] })
    },
    children
  }]
});

Packer.toBuffer(doc).then(buffer => {
  fs.writeFileSync(outputFile, buffer);
  console.log(`Created: ${outputFile} (${(buffer.length / 1024).toFixed(0)} KB, ${children.length} elements)`);
});
