---
name: Edge TTS Narration
description: Free Microsoft Edge TTS for professional narration audio (presentations, videos). Use instead of Replicate MiniMax.
version: 1.0.0
author: omaperoha
---

# Edge TTS Narration

Microsoft's Edge TTS is **free**, **fast**, and produces **natural-sounding voices** suitable for professional presentations and videos. Use this instead of paid TTS services like Replicate minimax.

## When to Use
- Presentation narration
- Demo video voiceovers
- Any AI-generated speech for customer deliverables
- When speaker lost their voice and needs TTS replacement

## Install
```bash
pip install edge-tts
```

## Recommended Voices (US English)

### Female (Professional)
- `en-US-AvaNeural` — **Newest, most natural**, confident consulting voice
- `en-US-EmmaNeural` — Warm, engaging
- `en-US-AriaNeural` — Confident narrator

### Male (Professional)
- `en-US-AndrewNeural` — Steady, authoritative (USED in final Fabric demo video)
- `en-US-BrianNeural` — Warm narrator
- `en-US-ChristopherNeural` — Deep, news-anchor style
- `en-US-GuyNeural` — Classic, most common

## Basic Pattern
```python
import edge_tts
import asyncio

async def generate(text, voice='en-US-AvaNeural', rate='-5%', out_path='output.mp3'):
    comm = edge_tts.Communicate(text, voice, rate=rate)
    await comm.save(out_path)

# Rate options: '-50%' (slower) to '+50%' (faster)
# '-5%' is good for clarity in consulting presentations
asyncio.run(generate("Hello world.", out_path='hello.mp3'))
```

## Per-Section Narration Pattern (CRITICAL)

**DO NOT** try to surgically edit a monolithic narration track. Generate each section as a separate audio file, then assemble with exact timing. This eliminates ALL alignment issues.

```python
SECTIONS = [
    ('01_intro', 'Opening narration text...'),
    ('02_architecture', 'Architecture section text...'),
    ('03_bronze', 'Bronze layer text...'),
    # etc.
]

async def generate_all():
    for name, text in SECTIONS:
        comm = edge_tts.Communicate(text, 'en-US-AndrewNeural', rate='-5%')
        await comm.save(f'sections/{name}.mp3')
        # Measure duration for video assembly
        from moviepy import AudioFileClip
        a = AudioFileClip(f'sections/{name}.mp3')
        print(f'{name}: {a.duration:.1f}s')
        a.close()
```

## Voice Selection Tips
- **Never ask user which voice** until you've generated samples they can listen to
- Generate 3-4 voice candidates with the SAME TEXT for direct comparison
- Save samples as `voice_test_<name>.mp3` in the repo so user can compare on any PC
- **Proven combination for consulting presentations:** `en-US-AvaNeural` for slide narration + `en-US-AndrewNeural` for demo/walkthrough video sections

## Finding Clean Audio Cut Points (RMS Energy Scan)
When you must cut a monolithic audio file at a specific second, find a natural pause — never cut mid-word:

```python
import numpy as np
from moviepy import AudioFileClip

narr = AudioFileClip('narration.mp3')

# Scan around the target time in 0.5s steps — find the quietest window
for t_start in np.arange(46, 55, 0.5):
    chunk = narr.subclipped(t_start, t_start + 0.5)
    frames = np.array([chunk.get_frame(t / 20) for t in range(10)])
    rms = np.sqrt(np.mean(frames ** 2))
    label = "QUIET (safe cut)" if rms < 0.02 else ("low" if rms < 0.04 else "LOUD — skip")
    print(f"  t={t_start:.1f}s  rms={rms:.4f}  {label}")
```

Cut at the lowest RMS point. Lesson: user reported "clipping 'deliverables'" — the word wasn't finished. RMS scan prevents this.

## Gotchas
- Edge TTS requires internet connection (not fully offline)
- Some voices (Multilingual variants) may sound different from English-only counterparts
- Use `rate='-5%'` for consulting/professional tone. Default (0%) sounds slightly rushed.

## Why Not Replicate MiniMax?
- Replicate costs money (even small amounts add up during iteration)
- Rate-limited: 6 requests/min under $5 credit, 12s delay required between calls
- Bitrate restricted to `{32000, 64000, 128000, 256000}` only
- Edge TTS has equal or better voice quality for English

## Files to Reference
- `scripts/generate_tts_and_copilot.js` (Fabric-Datalake) — shows Replicate pattern (for comparison)
- `scripts/build_demo_video_v8.py` (Fabric-Datalake) — shows Edge TTS per-section pattern
- `build_exec_ai_enablement.py` (commit e022410) — original Edge TTS usage
