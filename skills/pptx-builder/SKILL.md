---
name: pptx-builder
description: PowerPoint presentation builder using pptxgenjs or python-pptx. Use this skill when creating, modifying, or fixing .pptx presentations via JavaScript/Node.js or Python generation scripts. Trigger on any PPTX work that builds slides programmatically. Also use the anthropic-skills:pptx skill for direct PPTX manipulation.
version: 1.0.0
author: omaperoha
---

# PPTX Builder — Programmatic Presentation Specialist

## Default Palette (Ocean Gradient)
A proven palette for data/analytics presentations. Override in your project's CLAUDE.md if the customer has a branded template.

```javascript
const C = {
  navy: "1E2761",      // Primary background
  deepBlue: "065A82",  // Dimension boxes
  teal: "1C7293",      // Fact boxes, accents
  midnight: "21295C",
  white: "FFFFFF",
  offWhite: "F4F6F8",  // Light slide backgrounds
  lightGray: "E2E8F0",
  medGray: "94A3B8",
  darkGray: "334155",
  text: "1E293B",
  accent: "0891B2",    // Primary accent (teal)
  green: "059669",
  orange: "D97706",
  red: "DC2626",
  gold: "F59E0B",
};
```

## pptxgenjs Rules (CRITICAL — violations cause corruption)

1. **No `#` prefix in hex colors** — use `"1E2761"` not `"#1E2761"`
2. **makeShadow() must be a factory function** (returns new object each call), NOT a shared object
3. **Use RECTANGLE** — `pres.shapes.RECTANGLE`, never `ROUNDED_RECTANGLE` (not supported)
4. **No negative shadow offset values**
5. **No opacity in hex strings** — opacity goes as separate property in shadow config
6. **`fs` require at top of file** when embedding images
7. **Default slide size**: 10" × 5.625" — override with `pres.layout = 'LAYOUT_WIDE'` if needed

## Image Embedding (prevents PPTX corruption)

```javascript
const fs = require("fs");
const path = require("path");

function addInfographic(pres, filename, notes, bgColor) {
  const filepath = path.join(__dirname, filename);
  if (!fs.existsSync(filepath)) {
    console.log("  SKIP (missing): " + filename);
    return;
  }
  const buf = fs.readFileSync(filepath);
  const isJpeg = buf[0] === 0xFF && buf[1] === 0xD8;
  const mime = isJpeg ? "image/jpeg" : "image/png";
  const b64 = mime + ";base64," + buf.toString("base64");
  const slide = pres.addSlide();
  slide.background = { color: bgColor || "1E2761" };
  slide.addImage({
    data: b64, x: 0, y: 0, w: 10, h: 5.625,
    sizing: { type: "contain", w: 10, h: 5.625 }
  });
  slide.addNotes(notes || "AI-generated infographic: " + filename);
}
```

## Universal Presentation Rules

### Content Rules
- **Every slide must have speaker notes**
- **Infographics go AFTER their content slide**, not batched at the end
- **"Accept risk" is never an option** for PII — defense-in-depth is default
- **Never cite internal session notes** as sources in customer-facing slides

### Structure Rules
- **Logical story**: Context → Challenge → Solution → Analytics/Value → Operations → Delivery
- **Add agenda slide** after title
- **Don't duplicate information** — infographic reinforces the content slide, not repeats it

### Readability Rules
- If text is too small, split into multiple slides
- Don't force/deform images — create at proper resolution
- Tables must be legible at presentation distance
- Max 6–8 items per slide

## Customer-Branded Template (python-pptx)

When using a customer's PowerPoint template (.pptx), check dimensions FIRST:

```python
from pptx import Presentation
from pptx.util import Inches
prs = Presentation("template.pptx")
print(prs.slide_width / 914400, prs.slide_height / 914400)  # inches
```

**Critical rules for branded templates:**
- **NEVER override font colors on layout placeholders** — just set `shape.text = "..."` and let the template style apply
- **Agenda layouts are often unreliable** — use BLANK layout with manual boxes instead
- **Save as a NEW file** (v2) if the original may be open in PowerPoint
- Record the template's layout indices before using: `for i, l in enumerate(prs.slide_layouts): print(i, l.name)`

## File Conventions
- Generator scripts live near output: `docs/presentations/generate_<name>.js`
- Python builders: `scripts/build_<name>.py`
- Run JS: `node docs/presentations/generate_<name>.js`
- Run Python: `py scripts/build_<name>.py`
