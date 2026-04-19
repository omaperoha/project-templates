---
name: MP4 Video Assembly
description: Build professional narrated videos as standalone MP4 files. Skip PowerPoint — assemble slides + audio + embedded video directly with moviepy.
version: 1.0.0
author: omaperoha
---

# MP4 Video Assembly

Build a complete narrated presentation video as a **standalone MP4 file** that plays anywhere. Bypass PowerPoint's unreliable audio auto-play by assembling everything directly with moviepy.

## When to Use
- Customer needs a video deliverable (not a live presentation)
- Speaker lost voice — presentation must be pre-recorded
- PowerPoint audio auto-play keeps failing (even with COM automation)
- Need consistent playback across all devices

## Why NOT PowerPoint's "Export as Video"?
PowerPoint's audio auto-play is unreliable across versions. Even with:
- `AnimationSettings.PlaySettings.PlayOnEntry = True`
- `TimeLine.MainSequence.AddEffect(shape, 1, 0, 1)` (msoAnimTriggerWithPrevious)
- Correct timing configuration

...PowerPoint STILL requires clicks to trigger audio. Tested and confirmed as a dead-end.

## Winning Pattern (3 Steps)

### Step 1: Export Slides as PNG via PowerPoint COM
```python
import win32com.client

ppt = win32com.client.Dispatch('PowerPoint.Application')
ppt.Visible = True
pres = ppt.Presentations.Open(PPTX_PATH)

for i in range(1, pres.Slides.Count + 1):
    pres.Slides(i).Export(f'slide_{i:02d}.png', 'PNG', 1920, 1080)
# Ignore errors on pres.Close() — slides are saved
```

### Step 2: Build Segments with moviepy
Each slide = ImageClip with its audio. Demo video on slide 6 = VideoFileClip.

```python
from moviepy import (ImageClip, AudioFileClip, VideoFileClip,
                     concatenate_videoclips)

FPS = 24
SIZE = (1920, 1080)
XFADE = 0.6  # crossfade between slides (seconds)

segments = []

for slide_num in range(1, 10):
    slide_png = f'slide_images/slide_{slide_num:02d}.png'

    if slide_num == 6:  # Special: slide with embedded video
        intro_audio = AudioFileClip('slide_06_intro.mp3')
        closing_audio = AudioFileClip('slide_06_closing.mp3')
        demo_video = VideoFileClip('demo_video.mp4')

        # Three clips: slide with intro -> video -> slide with closing
        intro_clip = (ImageClip(slide_png)
                      .with_duration(intro_audio.duration + 1.0)
                      .resized(SIZE).with_fps(FPS)
                      .with_audio(intro_audio))

        demo_clip = demo_video.resized(SIZE)  # has its own audio

        closing_clip = (ImageClip(slide_png)
                        .with_duration(closing_audio.duration + 1.5)
                        .resized(SIZE).with_fps(FPS)
                        .with_audio(closing_audio))

        segments.extend([intro_clip, demo_clip, closing_clip])
    else:  # Normal slide: image + audio
        audio = AudioFileClip(f'slide_{slide_num:02d}_mixed.wav')
        clip = (ImageClip(slide_png)
                .with_duration(audio.duration + 1.0)  # small buffer
                .resized(SIZE).with_fps(FPS)
                .with_audio(audio))
        segments.append(clip)
```

### Step 3: Concatenate with Crossfade
```python
# padding=-XFADE creates overlap regions that blend = crossfade transitions
final = concatenate_videoclips(segments, method='compose', padding=-XFADE)

final.write_videofile(
    'final_video.mp4',
    fps=FPS,
    codec='libx264',
    audio_codec='aac',
    bitrate='5000k',
    audio_bitrate='192k',
    preset='medium',
    threads=4,
)
```

## Audio Mixing (Voice + Background Music)

### Option A — moviepy only (simpler, no extra dependency)
Mix voice + background music entirely within moviepy using volume multipliers:

```python
from moviepy import AudioFileClip, CompositeAudioClip

MUSIC_VOL = 0.15  # 15% = music audible but clearly subordinate to voice

narr = AudioFileClip('slide_01_narration.mp3')
music_raw = AudioFileClip('background_music.mp3')

# Loop music to match narration length
music = music_raw.with_effects([
    afx.AudioLoop(duration=narr.duration)
]).with_volume_scaled(MUSIC_VOL)

mixed = CompositeAudioClip([narr, music])
# Attach to clip: clip = clip.with_audio(mixed)
```

**Tuning guide**: `0.10` (barely audible) → `0.15` (standard, proven) → `0.20` (noticeable). Start at `0.15`.

### Option B — pydub (more control, dB units)
Use `pydub` to overlay background music UNDER the narration at low volume:

```python
from pydub import AudioSegment

MUSIC = AudioSegment.from_mp3('background_music.mp3')
MUSIC_DB = -20  # Music 20dB quieter than voice (voice prominent)

narr = AudioSegment.from_mp3('slide_01_narration.mp3')

# Loop music if shorter than narration
music = MUSIC
while len(music) < len(narr):
    music = music + MUSIC

mixed = narr.overlay(music[:len(narr)] + MUSIC_DB)
mixed.export('slide_01_mixed.wav', format='wav')
```

**Critical**: `MUSIC_DB = -14` is TOO LOUD for consulting narration. Use `-20` minimum. User feedback: "Is it too difficult to raise a little the voice over the background music?"

**When to prefer pydub**: when you need precise dB control, multi-track mixing, or are already using pydub for other audio work. Otherwise Option A (moviepy only) is simpler.

## Crossfade Transition Variants

| padding value | effect |
|--------------|--------|
| `0` | Hard cut (no transition) |
| `-0.3` | Quick crossfade (subtle) |
| `-0.6` | **Standard** crossfade (professional) |
| `-1.0` | Slow dramatic crossfade |

moviepy requires `method='compose'` for padding to work.

## Dependencies
```bash
pip install moviepy pydub pywin32
winget install ffmpeg   # Required by moviepy/pydub
# Windows: ffmpeg ends up at C:\Users\<user>\AppData\Local\Microsoft\WinGet\Links
# Add to PATH: export PATH="$PATH:/c/Users/<user>/AppData/Local/Microsoft/WinGet/Links"
```

## Slide Image Quality
- Export at 1920x1080 for Full HD video
- PowerPoint's native PNG export handles transparency, gradients correctly
- Native export > screenshot tools (better quality, preserves fonts)

## Sizing Match
- Video canvas: 1920x1080 (Full HD)
- Slide images: 1920x1080 (same — no scaling needed)
- Demo video: Use `.resized(SIZE)` if demo video has different dimensions
- Aspect ratio MUST match or moviepy will letterbox/pillarbox

## Performance Notes
- 9.4 min video at 1080p @ 24fps = ~13,500 frames
- Render time: ~15-20 minutes on typical laptop
- Output size: ~60 MB at `bitrate='5000k'` (reasonable for sharing)
- Use `bitrate='8000k'` for higher quality (~95 MB)

## Reference Implementation
- `scripts/build_demo_video_v8.py` (Fabric-Datalake) — demo video assembly
- `docs/presentations/AI_360_Enablement_Narrated_Video.mp4` — final 9.4-min output (59 MB)
- Total session time to build: ~2 hours including all iterations

## The Lesson
When PowerPoint's audio features don't work, **stop fighting it**. Export slides as images and assemble the video directly with moviepy. The output is a single MP4 that plays anywhere — no PowerPoint playback needed.
