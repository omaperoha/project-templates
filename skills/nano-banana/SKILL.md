---
name: nano-banana
description: Replicate API specialist for generating infographics using Nano Banana 2 (google/nano-banana-2, Gemini 3.1 Flash image model). Use this skill whenever you need to generate AI images, infographics, or visual assets via the Replicate API. Trigger on any mention of "infographic", "Nano Banana", "Replicate API", "generate image", or when creating visual content for presentations.
version: 1.0.0
author: omaperoha
---

# Nano Banana 2 — Replicate API Image Generation Specialist

## API Details
- **Model**: google/nano-banana-2 (Gemini 3.1 Flash image generation)
- **Endpoint**: `https://api.replicate.com/v1/models/google/nano-banana-2/predictions`
- **Auth**: `Authorization: Bearer $REPLICATE_API_TOKEN`

## CRITICAL: API is ASYNC

The `Prefer: wait` header does NOT work reliably. You MUST use async polling:

1. POST to create prediction → get prediction ID
2. Poll GET `/v1/predictions/{id}` every 5 seconds
3. Wait for `status: "succeeded"` → download from `output` array
4. ~35 seconds per image typical

### Node.js Polling Script (PROVEN PATTERN)

```javascript
const https = require("https"), fs = require("fs");
const TOKEN = process.env.REPLICATE_API_TOKEN;

function req(opts, body) {
  return new Promise((resolve, reject) => {
    const r = https.request(opts, res => {
      let d = ""; res.on("data", c => d += c);
      res.on("end", () => resolve({ status: res.statusCode, body: d }));
    });
    r.on("error", reject);
    r.setTimeout(30000, () => { r.destroy(); reject(new Error("timeout")); });
    if (body) r.write(body);
    r.end();
  });
}

function download(url, filepath) {
  return new Promise((resolve, reject) => {
    https.get(url, res => {
      if (res.statusCode >= 300 && res.statusCode < 400 && res.headers.location)
        return download(res.headers.location, filepath).then(resolve).catch(reject);
      const w = fs.createWriteStream(filepath);
      res.pipe(w);
      w.on("finish", () => { w.close(); resolve(); });
    }).on("error", reject);
  });
}

async function generate(prompt, outputPath) {
  const body = JSON.stringify({
    input: { prompt, resolution: "1K", aspect_ratio: "16:9", output_format: "jpg" }
  });
  const r = await req({
    hostname: "api.replicate.com",
    path: "/v1/models/google/nano-banana-2/predictions",
    method: "POST",
    headers: { "Authorization": "Bearer " + TOKEN, "Content-Type": "application/json" }
  }, body);
  const pred = JSON.parse(r.body);
  if (!pred.id) throw new Error("No prediction ID: " + r.body);

  for (let i = 0; i < 40; i++) {
    await new Promise(r => setTimeout(r, 5000));
    const r2 = await req({
      hostname: "api.replicate.com",
      path: "/v1/predictions/" + pred.id,
      method: "GET",
      headers: { "Authorization": "Bearer " + TOKEN }
    });
    const s = JSON.parse(r2.body);
    if (s.status === "succeeded") {
      const url = Array.isArray(s.output) ? s.output[0] : s.output;
      await download(url, outputPath);
      console.log("OK: " + outputPath + " (" + fs.statSync(outputPath).size + " bytes)");
      return;
    }
    if (s.status === "failed") throw new Error("Generation failed: " + s.error);
    process.stdout.write(".");
  }
  throw new Error("Timeout after 200 seconds");
}
```

## Output Format
- Always save as `.jpg` (NOT .png) — Replicate returns JPEG regardless
- For PPTX embedding: use base64 with correct MIME type detection

## Rate Limits
- Wait 11 seconds between requests on low-credit accounts
- "Service unavailable due to high demand" (E003) = retry after 30-60 seconds

## Prompt Engineering for Technical Infographics

### Style Prefix (always include)
```
Professional technical infographic, dark navy background (#1E2761), teal accents (#0891B2), white text, clean modern design. No people, no photographs.
```

### Known Limitations
| Capability | Accuracy | Notes |
|-----------|----------|-------|
| Short labels (1-3 words) | 70-85% | dim_employee renders correctly |
| Long text (sentences) | 30-40% | Becomes illegible or fabricated |
| Exact numbers | 40-60% | "7" often correct, "338h" less reliable |
| Code/column names | 50-70% | Short names OK, long names get truncated |

### Hallucination Prevention
- Describe VISUAL LAYOUT (boxes, arrows, grids) not paragraphs
- Use short labels (dim_employee not silver_employee_period_totals)
- Specify exact counts ("exactly 7 blue boxes in a row")
- Include "No people, no photographs" always
- Say what NOT to include if needed
- ONE concept per infographic

### Division of Labor
- **Infographics convey STRUCTURE** (flow, relationships, layers)
- **Slides carry EXACT DETAILS** (column names, numbers, formulas)
- Accept that infographics will be approximate — they are visual aids, not reference diagrams

## CRITICAL: Save ALL Assets for Iteration

**Always save the following for EVERY generated image:**

1. **Prompt** — The exact text sent to Nano Banana 2
2. **Seed** — Extract from `prediction.logs` field (contains "seed:NNNNN"). Parse with regex: `s.logs.match(/seed:(\d+)/)[1]`. THIS WAS MISSED IN PREVIOUS SESSIONS — seeds were not captured, preventing iteration on successful images.
3. **Output image** — The downloaded .jpg file
4. **Prediction ID** — The Replicate prediction ID for reference

Save these in a manifest file alongside the images (e.g., `infographic_manifest.json`):

```json
{
  "images": [
    {
      "filename": "na2_arch.jpg",
      "prediction_id": "abc123...",
      "seed": 12345,
      "prompt": "Professional technical infographic...",
      "generated_at": "2026-03-25T10:00:00Z",
      "resolution": "1K",
      "aspect_ratio": "16:9"
    }
  ]
}
```

**Why:** This allows iterating over the SAME image (refining the prompt or using the same seed for consistency) instead of recreating from scratch every time, which always produces a different result.

**To reproduce an image with the same seed**, include `"seed": <saved_seed>` in the API input:
```json
{
  "input": {
    "prompt": "...",
    "resolution": "1K",
    "aspect_ratio": "16:9",
    "output_format": "jpg",
    "seed": 12345
  }
}
```

**To iterate on an image:** Use the same seed + modify the prompt. This produces a variation of the original rather than a completely different image.

## Project-Specific Image Naming
- Plan A images: `na2_*.jpg` prefix
- Plan B images: `nb2_*.jpg` prefix (legacy, mostly .png)
- Never reuse Plan B images for Plan A — generate unique ones

## CRITICAL: Windows Path Handling

**NEVER use `/h/` Unix-style paths in Node.js on Windows.** Node.js resolves these incorrectly, prepending the current drive letter and creating invalid paths like `H:\h\Users\...`.

**Working pattern:** Use `__dirname` (the script's own directory) for output paths:
```javascript
const OUT_DIR = __dirname;
const outPath = path.join(OUT_DIR, "na2_my_image.jpg");
```

**Failing pattern:** Hardcoded Unix paths in Node.js:
```javascript
// WRONG — creates H:\h\Users\... on Windows
const out = "/h/Users/Nosotros/Documents/GIT/Fabric-Datalake/docs/presentations/na2_image.jpg";
```

**Also working:** Windows-style escaped paths (less portable):
```javascript
const OUTDIR = 'H:\\Users\\Nosotros\\Documents\\GIT\\Fabric-Datalake\\docs\\presentations';
```

**Best practice:** Always use the proven `generate_infographics.js` script pattern from `docs/presentations/` — it uses `__dirname` and has been tested. Copy and modify the IMAGES array, don't rewrite the boilerplate.

## CDW Color Palette for Infographic Prompts

When generating infographics for CDW-branded presentations, use these colors in prompts instead of Ocean Gradient:
- **CDW Red:** CC0000 (primary accent)
- **Dark Grey:** 54565B (body text)
- **Teal:** 1C7293 (secondary accent)
- **White background** (not dark navy — CDW slides use light backgrounds)
- Always include: "Modern flat corporate design. No people no photographs."
