---
name: pptx-builder
description: PowerPoint presentation builder using pptxgenjs for the Fabric Datalake project. Use this skill when creating, modifying, or fixing .pptx presentations via JavaScript/Node.js generation scripts. Trigger on any PPTX work that uses pptxgenjs, Ocean Gradient palette, or when building slides programmatically. Also use the anthropic-skills:pptx skill for direct PPTX manipulation.
---

# PPTX Builder — pptxgenjs Presentation Specialist

## Ocean Gradient Palette
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

## Image Embedding (prevents PPTX corruption)

```javascript
const fs = require("fs");
const path = require("path");

function addInfographic(pres, filename, notes) {
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
  slide.background = { color: "1E2761" };
  slide.addImage({
    data: b64, x: 0, y: 0, w: 10, h: 5.625,
    sizing: { type: "contain", w: 10, h: 5.625 }
  });
  slide.addNotes(notes || "AI-generated infographic: " + filename);
}
```

## Presentation Rules

### Content Rules
- **Never reference Plan B in Plan A** presentations (and vice versa)
- **Show 338h total** — never split into 250h DE + 30h AE
- **Copilot readiness is ALWAYS in scope** regardless of F64 availability
- **Neutral file delivery language**: "Files arrive in the Landing Zone" not "customer/Paycom delivers"
- **Never cite user notes** as sources
- **"Accept risk" is never an option** for PII — defense-in-depth is default

### Structure Rules
- **Logical layer-by-layer story**: Context → Challenge → Solution (layer by layer) → Analytics → Operations → Delivery
- **Add agenda slide** after title
- **Every slide must have speaker notes**
- **Infographics go AFTER their content slide**, not at the end
- **Don't duplicate information** — if a content slide has it, the infographic reinforces the concept visually

### Readability Rules
- If text is too small, split into multiple slides
- Don't force/deform images — create at proper resolution
- Tables must be legible at presentation distance
- Max 6-8 items per slide

### Architecture Accuracy
- Plan A Gold: 7 dims + 4 facts (constellation schema)
- Plan B Gold: 4 dims + 3 facts (simplified star)
- SFTP Pipeline is IN SCOPE for Plan A (Stage 0)
- Security: 5 layers (Landing → Bronze → Silver → Gold → Semantic Model)

## CDW Template (python-pptx) — CRITICAL RULES

When building with python-pptx using the CDW PowerPoint Template:

**Dimensions:** 13.33" x 7.50" (NOT 10x5.625)

**Title layout (index 0):** NEVER override font colors on placeholders. Just set `shape.text = "..."` and let the template style it. Overriding `p.font.color.rgb` breaks rendering.

**Agenda layout (index 3):** UNRELIABLE placeholder rendering. Use BLANK layout (index 26) with manual numbered boxes + `stitle(s, "Agenda")` instead.

**Closing layout (index 29):** Works reliably. Same rule — set text only, no font overrides.

**Reference implementation:** `docs/presentations/build_data_analysis_v4.py` — the WORKING pattern for CDW template slides.

## File Conventions
- Generator scripts: `docs/presentations/generate_plan_a_final.js`
- Infographic version: `docs/presentations/generate_plan_a_infographics.js`
- Output: `docs/presentations/plan_a_architecture.pptx` or `plan_a_with_infographics.pptx`
- Run with: `node docs/presentations/generate_plan_a_final.js`
