# Presentation Generation Template

Generate professional PowerPoint presentations programmatically using [pptxgenjs](https://github.com/gitbrent/PptxGenJS).

## Setup

```bash
npm install pptxgenjs
```

## Usage

1. Copy `generate_presentation.js` to your project
2. Edit the `CONFIG` section at the top with your project details
3. Run: `node generate_presentation.js`
4. Output: `output/presentation.pptx`

## Color Palette

The template includes a configurable color palette. Default is "Ocean Gradient":

```javascript
const COLORS = {
  navy: "1E2761",      // Dark backgrounds
  deepBlue: "065A82",  // Section headers
  teal: "1C7293",      // Accents
  accent: "0891B2",    // Highlights, CTAs
  gold: "F59E0B",      // Warnings, attention
  white: "FFFFFF",     // Text on dark
  lightGray: "F3F4F6", // Light backgrounds
  medGray: "9CA3AF",   // Subtle elements
  darkText: "1F2937",  // Text on light
};
```

## Critical Gotchas (learned the hard way)

1. **Never use `#` in hex colors** — pptxgenjs expects `"0891B2"` not `"#0891B2"`
2. **Never reuse option objects** — pptxgenjs mutates them. Always create fresh objects:
   ```javascript
   // BAD — options get mutated between calls
   const opts = { fill: { color: "0891B2" } };
   slide.addShape(pres.shapes.RECTANGLE, opts);
   slide.addShape(pres.shapes.RECTANGLE, opts); // corrupted!

   // GOOD — fresh object each time
   slide.addShape(pres.shapes.RECTANGLE, { fill: { color: "0891B2" } });
   slide.addShape(pres.shapes.RECTANGLE, { fill: { color: "0891B2" } });
   ```
3. **Never use negative width on LINE shapes** — corrupts the entire PPTX file
   ```javascript
   // BAD — corrupts file
   slide.addShape(pres.shapes.LINE, { x: 5, y: 2, w: -2.5, h: 0 });

   // GOOD — swap start point instead
   slide.addShape(pres.shapes.LINE, { x: 2.5, y: 2, w: 2.5, h: 0 });
   ```
4. **Use a `makeShadow()` factory** — avoids shadow object mutation:
   ```javascript
   const makeShadow = () => ({
     type: "outer", blur: 4, offset: 2, color: "000000", opacity: 0.25,
   });
   slide.addShape(pres.shapes.RECTANGLE, { shadow: makeShadow() });
   ```
5. **Speaker notes** — use `slide.addNotes("text")` for presenter notes

## AI Infographic Integration

To add AI-generated infographic slides (e.g., via Replicate API):

```javascript
const infographics = [
  { file: "path/to/image.png", notes: "Speaker notes for this slide" },
];

infographics.forEach((img) => {
  const slide = pres.addSlide();
  slide.background = { color: COLORS.navy };
  slide.addImage({
    path: img.file,
    x: 0, y: 0, w: 10, h: 5.625,
    sizing: { type: "contain", w: 10, h: 5.625 },
  });
  slide.addNotes(img.notes);
});
```

### Recommended AI Image Models (Replicate API)

| Model | Quality | Speed | Best For |
|-------|---------|-------|----------|
| `google/nano-banana-2` | Production | 30-70s | Technical diagrams with text (use `resolution: "1K"`) |
| `google/nano-banana` | Good | 10-20s | Fast prototyping |
| `black-forest-labs/flux-1.1-pro` | Aesthetic | 15-30s | Non-text visuals only (garbles text) |

## Slide Reordering

pptxgenjs creates slides sequentially. To interleave (e.g., content + infographic pairs), use python-pptx after generation:

```python
from pptx import Presentation
prs = Presentation("output.pptx")
sldIdLst = prs.part._element.find('{http://schemas.openxmlformats.org/presentationml/2006/main}sldIdLst')
entries = list(sldIdLst)
new_order = [0, 17, 1, 18, 2, 19, ...]  # interleaved indices
reordered = [entries[i] for i in new_order]
for e in entries:
    sldIdLst.remove(e)
for e in reordered:
    sldIdLst.append(e)
prs.save("output_reordered.pptx")
```

## PPTX to Image Conversion (Windows)

Use PowerPoint COM automation (no LibreOffice needed):

```powershell
$ppt = New-Object -ComObject PowerPoint.Application
$ppt.Visible = $true
$doc = $ppt.Presentations.Open("$pwd\output.pptx")
$doc.SaveAs("$pwd\slides", 17)  # 17 = ppSaveAsJPG
$doc.Close()
$ppt.Quit()
```
