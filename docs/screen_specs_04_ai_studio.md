# Screen Specs 04 — AI Studio (M07)

> **Upstream**: Pack 01 §4.4, Pack 04 (AI/Media), Product Freeze §15, A1 Schema (assets, asset_briefs, characters, generation_queue), D1 AI Provider Guide
> **Screens**: 10 web + 3 mobile screens

---

## 24. AI Studio Home

**Route**: `/studio`
**Purpose**: Hub for all AI video/image production modes. Grid of mode cards + recent projects + credit status.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🎬 AI Studio                              Credits: 🪙 320/500    │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Production Modes (4-column grid) ──────────────────────────┐ │
│ │ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌────────┐ │ │
│ │ │ ✂️ Quick Edit│ │ 🎬 Clip     │ │ 🔀 Multi-   │ │ 🔄 AI  │ │ │
│ │ │             │ │    Factory  │ │    Merge    │ │  Remix │ │ │
│ │ │ Chỉnh sửa  │ │ Tạo clips   │ │ Gộp media   │ │ Remix  │ │ │
│ │ │ video nhanh │ │ từ video    │ │ thành video │ │ video  │ │ │
│ │ │ ~25 credits │ │ dài         │ │ mới         │ │ trend  │ │ │
│ │ │             │ │ ~15 cr/clip │ │ ~20 credits │ │ ~35 cr │ │ │
│ │ │ [Mở →]     │ │ [Mở →]     │ │ [Mở →]     │ │ [Mở →]│ │ │
│ │ └─────────────┘ └─────────────┘ └─────────────┘ └────────┘ │ │
│ │                                                              │ │
│ │ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌────────┐ │ │
│ │ │ 🛍️ Product  │ │ 🖼️ Image to │ │ 🎨 Thumbnail│ │ 🔗 Link│ │ │
│ │ │  Showcase   │ │    Video    │ │    Studio   │ │ to Video│ │ │
│ │ │ Video SP    │ │ Ảnh→video  │ │ Thumbnail   │ │ URL→   │ │ │
│ │ │ ~15 credits │ │ ~10 credits │ │ ~5 credits  │ │ video  │ │ │
│ │ │ [Mở →]     │ │ [Mở →]     │ │ [Mở →]     │ │ ~20 cr │ │ │
│ │ └─────────────┘ └─────────────┘ └─────────────┘ └────────┘ │ │
│ │                                                              │ │
│ │ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐            │ │
│ │ │ 🌐 Translate│ │ 🎵 Sound    │ │ 🤖 Video    │            │ │
│ │ │    Studio   │ │    Studio   │ │    Agent    │            │ │
│ │ │ Dịch video  │ │ Âm thanh    │ │ Text→Video │            │ │
│ │ │ ~20 credits │ │ ~8 credits  │ │ ~30 credits │            │ │
│ │ │ [Mở →]     │ │ [Mở →]     │ │ [Mở →]     │            │ │
│ │ └─────────────┘ └─────────────┘ └─────────────┘            │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Recent Projects (carousel) ────────────────────────────────┐ │
│ │ [Thumb1] "5 tips" │ [Thumb2] "Serum review" │ [Thumb3] ...  │ │
│ │ Quick Edit · 2h   │ Clip Factory · 1d       │               │ │
│ │ [Resume →]        │ [Resume →]              │               │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Queue Status ──────────────────────────────────────────────┐ │
│ │ 📋 2 videos đang xử lý · Ước tính: 5 phút                  │ │
│ │ [Xem queue →]                                                │ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

### Mode Card Behavior
- **Hover** (web): Card elevates slightly + preview animation plays
- **Locked** (tier restriction): Overlay "🔒 Nâng cấp lên Pro" + dimmed
- **Click locked**: Upsell modal with feature comparison
- **Click unlocked**: Navigate to respective mode screen

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Open mode | Click mode card | — | → `/studio/{mode}` |
| Resume project | Click recent | — | → respective mode with project loaded |
| View queue | "Xem queue" | — | → `/studio/queue` |
| Upgrade tier | Click locked mode | — | Modal: tier comparison + upgrade CTA |

### States
- **Loading**: 11 card skeletons + queue skeleton
- **No credits**: Banner "Credits hết. [Nạp thêm →]" — modes still browsable
- **Queue full**: Badge on modes showing estimated wait time

---

## 29. Quick Edit Mode

**Route**: `/studio/quick-edit`
**Purpose**: Text-based video editing — edit the transcript to edit the video. AI auto-cut, captions, hooks, music.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Studio   ✂️ Quick Edit                       [Credits: ~25]    │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Upload / Select ──────────────────────────────────────────┐  │
│ │ [📎 Upload video] or [📂 Choose from library ▾]            │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Editing Canvas (two panels) ──────────────────────────────┐  │
│ │                                                              │  │
│ │ ┌─ Transcript Panel (40%) ──┐  ┌─ Video Preview (60%) ──┐ │  │
│ │ │ 00:00 "Xin chào các bạn" │  │ [Video Player]          │ │  │
│ │ │ 00:03 ~~"ừm"~~ (filler)  │  │                         │ │  │
│ │ │ 00:04 "Hôm nay mình sẽ"  │  │ AI-detected:            │ │  │
│ │ │ 00:06 ~~(pause 2s)~~     │  │ • 5 filler words        │ │  │
│ │ │ 00:08 "chia sẻ 5 tips"   │  │ • 2 dead pauses         │ │  │
│ │ │ ...                       │  │ • Suggested hook: ✔     │ │  │
│ │ │                           │  │                         │ │  │
│ │ │ Click word = select       │  │ [Player controls]       │ │  │
│ │ │ Strikethrough = cut       │  │ [Split: Before | After] │ │  │
│ │ │ Highlight = AI-suggested  │  │                         │ │  │
│ │ │ [🗑 Delete] [⟲ Undo]     │  │                         │ │  │
│ │ └───────────────────────────┘  └─────────────────────────┘ │  │
│ │                                                              │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Edit Plan (checklist) ────────────────────────────────────┐  │
│ │ ☑ Remove 5 filler words           (saves 8s)              │  │
│ │ ☑ Cut 2 dead pauses               (saves 4s)              │  │
│ │ ☑ Auto-captions (bounce style ▾)                           │  │
│ │ ☐ Add hook (Question type ▾)       (+3 credits)            │  │
│ │ ☐ Beat-sync music                  (+5 credits)            │  │
│ │ ☐ AI B-roll injection              (+10 credits)           │  │
│ │ ☐ Platform preset: [TikTok ▾]      (+3 credits)            │  │
│ │ ☐ Audio enhancement (noise remove) (+3 credits)            │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Estimated credits: [25 ▾] (updates real-time)                    │
│ [▶ Preview — free] [🚀 Apply edits — 25 credits]                │
└──────────────────────────────────────────────────────────────────┘
```

### Data Sources
| Source | API | Cache |
|---|---|---|
| Transcript | `AIService/Transcribe` (Whisper) | Session |
| Filler detection | `AIService/AnalyzeTranscript` | Session |
| Hook library | `ContentService/GetHookTemplates` | 24h |
| Music library | `AssetService/ListMusic` | 24h |

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Upload video | Drag-drop / click | Upload to R2 | Video loads, transcript generates |
| Delete word/segment | Click strikethrough on transcript | — (client) | Word crossed out, preview updates |
| Undo edit | ⟲ button or ⌘Z | — (client) | Last edit reverted |
| Toggle edit option | Click checkbox | — (client) | Credit estimate updates |
| Preview | ▶ Preview | Client-side simulation | Split player: before/after |
| Apply edits | 🚀 Apply | `AssetService/Generate(type=quick_edit)` | → Queue with progress |
| Export | After completion | `AssetService/Export` | Platform format selection |

### States
- **Loading**: Shimmer on transcript + player skeleton
- **Analyzing**: Progress bar "Đang phân tích transcript..." (typical 30-60s)
- **Ready**: Transcript loaded, AI suggestions highlighted
- **Processing**: Queue item with progress stages
- **Preview**: Split player (before/after, synced playback)
- **Empty**: No video uploaded — "Upload video để bắt đầu chỉnh sửa"

---

## 30. Clip Factory Mode

**Route**: `/studio/clip-factory`
**Purpose**: Upload a long video → AI detects and extracts best clips → rate by virality score → batch export.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Studio   🎬 Clip Factory                    [Source: 12:34]    │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Source Video ─────────────────────────────────────────────┐  │
│ │ [Video preview — scrub timeline]                            │  │
│ │ ████████████████████░░░░░░░░░░░░░ 12:34                    │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Detected Clips (8)           Sort: [Virality ▾] [Duration ▾]    │
│ ☑ Select all (3 selected)    [Batch: Add Captions ▾]             │
│                                                                  │
│ ┌─ Clip Card ────────────────────────────────────────────────┐  │
│ │ ┌───────┐ Clip 1 — 0:45-1:12 (27s)            ⭐ 87/100  │  │
│ │ │ Thumb │ Hook: Question | Pacing: Fast                    │  │
│ │ │       │ "Bạn có biết rằng 90%..."                        │  │
│ │ │       │ Virality breakdown: [📊 See details]             │  │
│ │ └───────┘                                                  │  │
│ │ [☑ Select] [▶ Preview] [✏ Edit in Quick Edit] [📊 Score]  │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Clip Card ────────────────────────────────────────────────┐  │
│ │ ┌───────┐ Clip 2 — 3:21-3:55 (34s)            ⭐ 72/100  │  │
│ │ │ Thumb │ Hook: Statement | Pacing: Medium                 │  │
│ │ │       │ "Mẹo thứ hai là..."                              │  │
│ │ └───────┘                                                  │  │
│ │ [☐ Select] [▶ Preview] [✏ Edit] [📊 Score]                │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Virality Score Detail (popover on 📊) ──                     │
│ ┌──────────────────────────────────────────┐                     │
│ │ Hook strength:     ████████░░ 80         │                     │
│ │ Pacing quality:    █████████░ 90         │                     │
│ │ Visual engagement: ████████░░ 85         │                     │
│ │ Topic relevance:   ███████░░░ 70         │                     │
│ │ Trending match:    █████████████ 95      │                     │
│ └──────────────────────────────────────────┘                     │
│                                                                  │
│ [Export 3 selected → TikTok + Reels + Shorts — ~45 credits]     │
└──────────────────────────────────────────────────────────────────┘
```

### Virality Score Badge Colors
| Range | Color | Label |
|---|---|---|
| ≥80 | 🟢 Green | Excellent |
| 50-79 | 🟡 Yellow | Good potential |
| <50 | 🔴 Red | Low predicted |

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Upload source | File upload | Upload to R2 | Analysis begins |
| Analyze video | Auto after upload | `AIService/AnalyzeClips` | Clip cards appear (30-90s) |
| Sort clips | Sort dropdown | — (client) | Cards reorder |
| Select clip | Toggle checkbox | — (client) | Selection count updates |
| Preview clip | ▶ Preview | — (client) | In-page player seeks to clip |
| Edit clip | ✏ Edit | — | → `/studio/quick-edit?source_clip=[id]` |
| View score | 📊 Score | — (client) | Popover with 5-dimension breakdown |
| Batch captions | "Add Captions" | — (queued) | Captions added to all selected |
| Export | Export button | `AssetService/BatchExport` | Multi-platform export → Queue |

---

## 31. Multi-Merge Mode

**Route**: `/studio/multi-merge`
**Purpose**: Combine multiple media (videos + images) into one polished video with AI transitions, voice-over, and music.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Studio   🔀 Multi-Merge                    [Media: 5/20 max]  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Media Drop Zone ──────────────────────────────────────────┐  │
│ │ [Drop media here ↓] or [📎 Upload] or [📂 From library]   │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Timeline Editor ──────────────────────────────────────────┐  │
│ │ ┌────┐ → ┌────┐ → ┌────┐ → ┌────┐ → ┌────┐              │  │
│ │ │ V1 │   │ I1 │   │ V2 │   │ I2 │   │ V3 │              │  │
│ │ │30s │   │ 3s │   │15s │   │ 3s │   │20s │              │  │
│ │ │ ✂️ │   │ ✂️ │   │ ✂️ │   │ ✂️ │   │ ✂️ │              │  │
│ │ └────┘   └────┘   └────┘   └────┘   └────┘              │  │
│ │ [drag to reorder]  Transitions: → indicates transition type│  │
│ │ Click → between items to edit transition: [Fade|Cut|Zoom] │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Settings ─────────────────────────────────────────────────┐  │
│ │ Duration target: [60s ▾]   Auto-adjust timing: [ON ▾]     │  │
│ │ Transitions: [Auto AI ▾]                                   │  │
│ │ Voice-over: [🎭 Character: Mila ▾] [🎤 Record own]        │  │
│ │ Music: [🎵 Auto-select ▾] [📎 Upload] [🎵 Generate AI]    │  │
│ │ Aspect ratio: [9:16 ●] [16:9 ○] [1:1 ○]                  │  │
│ │ Pacing: [Fast ○] [Medium ●] [Slow ○]                      │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ [▶ Preview — free] [Credits: ~20] [🚀 Create video]             │
└──────────────────────────────────────────────────────────────────┘
```

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Add media | Upload/drop | Upload to R2 | Thumbnail appears on timeline |
| Reorder | Drag-drop on timeline | — (client) | Timeline reorders |
| Remove media | Click ✂️ on item | — (client) | Item removed, timeline updates |
| Edit transition | Click → between | — (client) | Transition picker dropdown |
| Record voice-over | 🎤 Record | Browser MediaRecorder | Audio captured, added to timeline |
| AI voice-over | Select character | `AIService/GenerateVoice` | Voice generated for script |
| Auto-select music | "Auto-select" | `AIService/SuggestMusic` | Music track assigned |
| Generate AI music | 🎵 Generate AI | `AIService/GenerateMusic` | Custom music → timeline |
| Preview | ▶ Preview | Client-side composite | Preview modal |
| Create | 🚀 Create | `AssetService/Generate(type=merge)` | → Queue |

---

## 32. AI Remix Studio

**Route**: `/studio/remix`
**Purpose**: 3-phase pipeline to analyze a reference video's "Creative DNA" and generate an original remix.

### Layout — Phase 1 (Input)
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Studio   🔄 AI Remix Studio                                    │
├──────────────────────────────────────────────────────────────────┤
│ Step: [● Input] → [○ DNA Report] → [○ Polish]                  │
│                                                                  │
│ ┌─ Reference ────────────────────────────────────────────────┐  │
│ │ [📎 Upload video] or [🔗 Paste URL]                        │  │
│ │ URL: [https://tiktok.com/...                          ]    │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Remix Settings ───────────────────────────────────────────┐  │
│ │ Fidelity: ○ Match 1:1  ● Adapt  ○ Loose                   │  │
│ │ Topic/niche: [Skincare, beauty tips                    ]   │  │
│ │ Character: [🎭 Mila (default) ▾]                           │  │
│ │ Brand Pack: [My Brand ▾]                                   │  │
│ │ Platforms: [☑ TikTok] [☑ Reels] [☐ YouTube]               │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ [🔍 Analyze — ~8 credits]                                       │
└──────────────────────────────────────────────────────────────────┘
```

### Layout — Phase 2 (Creative DNA Report)
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Studio   🔄 Creative DNA Analysis                              │
├──────────────────────────────────────────────────────────────────┤
│ Step: [✓ Input] → [● DNA Report] → [○ Polish]                  │
│                                                                  │
│ ┌─ Creative DNA ─────────────────────────────────────────────┐  │
│ │ Duration: 28s | Scenes: 6 | Hook: Question                 │  │
│ │                                                              │  │
│ │ 📊 Structure:                                                │  │
│ │ [Hook 3s][Problem 5s][Tip1 6s][Tip2 6s][CTA 5s][Outro 3s]  │  │
│ │ (clickable segments — reorder/edit possible)                 │  │
│ │                                                              │  │
│ │ 🎵 Audio: Pop, BPM 120, Voice 70% / Music 30%               │  │
│ │ 🎨 Visual: Bright palette, fast cuts, text overlays          │  │
│ │ 📈 Pacing: Fast → Medium → Fast                              │  │
│ │ 🎭 Character: Detected — Woman, 25-30, casual tone          │  │
│ │ 📝 Script tone: Conversational, 2nd person pronoun           │  │
│ │                                                              │  │
│ │ [✏ Edit blueprint] [🔄 Generate Remix — ~35 credits]        │  │
│ └────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### Layout — Phase 3 (Polish)
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Studio   🔄 Polish & Export                                     │
├──────────────────────────────────────────────────────────────────┤
│ Step: [✓ Input] → [✓ DNA Report] → [● Polish]                  │
│                                                                  │
│ ┌─ Side-by-Side Player ──────────────────────────────────────┐  │
│ │ [Original Video ▶]       │       [Remix Video ▶]           │  │
│ │ Synced playback          │       Synced playback           │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Quality Checks ──────────────────────────────────────────┐  │
│ │ ✅ Originality: 85% (safe — threshold: ≥70%)              │  │
│ │ ⭐ Virality Score: 78/100                                  │  │
│ │ ✅ Compliance: pass (no copyright issues)                  │  │
│ │ ✅ Script similarity: 22% (safe — threshold: <30%)        │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Per-Scene Editor ─────────────────────────────────────────┐  │
│ │ Scene: [1 ▾] Hook — 3s                                     │  │
│ │ [✏ Edit script] [🎨 Edit visual] [🔄 Regenerate — 15 cr]  │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ [📤 Export to platforms] [📅 Schedule publish] [💾 Save draft]  │
└──────────────────────────────────────────────────────────────────┘
```

### AI Remix Legal Safeguards (visible on UI)
- Originality score always displayed
- "No footage reuse" badge
- Script similarity percentage
- Abuse prevention: max 20 remixes/day shown in header
- Fidelity level shown throughout flow

---

## 33-37. Extended Mode Screens
(Product Showcase, Image-to-Video, Thumbnail Studio, Link-to-Video, Translation Studio remain as already specified above.)

## 38. Sound Studio

**Route**: `/studio/sound`
**Purpose**: AI music generation, beat-drop sync, speech-to-song, and SFX for videos.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Studio   🎵 Sound Studio                     [Credits: ~8]     │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Tabs: [🎵 Music Gen] [🥁 Beat Sync] [🎤 Speech→Song] [🔊 SFX] │
│                                                                  │
│ ── Music Generation Tab ──                                       │
│ ┌─ Input ────────────────────────────────────────────────────┐  │
│ │ Video: [📎 Upload or select from library ▾]                │  │
│ │ Style: [Pop ▾] [Lo-fi ▾] [Epic ▾] [Custom prompt]        │  │
│ │ Mood: [Energetic ○] [Calm ●] [Happy ○] [Dramatic ○]      │  │
│ │ Duration: [30s ▾] — auto-match video if uploaded           │  │
│ │ BPM: [Auto ▾] or [120 ▾]                                  │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Waveform Editor ──────────────────────────────────────────┐  │
│ │ [Video waveform ═══════════════════════════]                │  │
│ │ [Music waveform ───────────────────────────] (after gen)   │  │
│ │ [SFX layer     ·   ·       ·    ·         ] (optional)    │  │
│ │ Volume: Voice [█████████░] 80%                             │  │
│ │         Music [██████░░░░] 60%                             │  │
│ │         SFX   [████░░░░░░] 40%                             │  │
│ │ [AI Auto-duck: ON ▾] — music dips during speech            │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Beat Sync Tab ──                                              │
│ AI detects beats in music → auto-cuts video on beats             │
│                                                                  │
│ ── Speech→Song Tab ──                                            │
│ Upload voice-over → transform to singing                         │
│ Style: [Pop] [R&B] [Auto] — 8-20 credits                        │
│                                                                  │
│ ── SFX Tab ──                                                    │
│ Video scene analysis → contextual sound effects                  │
│ [Whoosh] [Impact] [Transition] [Ambient] — 3-8 credits           │
│                                                                  │
│ [▶ Preview — free] [🚀 Apply — 8 credits]                       │
└──────────────────────────────────────────────────────────────────┘
```

---

## 39. AI Style Learning

**Route**: `/studio/style-learning`
**Purpose**: Extract editing style from reference videos → create reusable Style Pack for Continuity OS.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Studio   🎨 Style Learning                   [Credits: ~15]    │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Input ────────────────────────────────────────────────────┐  │
│ │ Reference video(s): [📎 Upload] (1-5 videos for analysis) │  │
│ │ Uploaded: [Video1 ×] [Video2 ×] [+ Add more]              │  │
│ │ [🔍 Analyze style — 15 credits]                            │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── After analysis ──                                             │
│ ┌─ Extracted Style Elements ─────────────────────────────────┐  │
│ │ 🎨 Color palette: [████ Warm tones, high contrast]         │  │
│ │ ✂️ Cut pacing: Fast (avg 1.8s/cut)                         │  │
│ │ 📝 Text style: Bold sans-serif, bottom-center              │  │
│ │ 🎵 Music style: Upbeat pop, BPM 110-130                   │  │
│ │ 🎬 Transitions: Jump cuts, occasional zoom                │  │
│ │ 📊 Hook pattern: Text overlay question, 2-3s              │  │
│ │ 🎭 Visual mood: Bright, lifestyle, product closeups       │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Save as Style Pack ───────────────────────────────────────┐  │
│ │ Pack name: [My Skincare Style                         ]    │  │
│ │ [💾 Save to Continuity OS] [▶ Apply to next video]         │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ My Style Packs ───────────────────────────────────────────┐  │
│ │ 🎨 "My Skincare Style" — Created 2d ago    [Edit] [Apply] │  │
│ │ 🎨 "Tech Review Style" — Created 1w ago    [Edit] [Apply] │  │
│ └────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

---

## 40. AI Video Agent

**Route**: `/studio/agent`
**Purpose**: 1-click full pipeline — describe what you want → AI handles entire production from script to ready-to-publish.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Studio   🤖 Video Agent                      [Credits: ~50]    │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Prompt Input ─────────────────────────────────────────────┐  │
│ │ Mô tả video bạn muốn:                                     │  │
│ │ [Review serum Vitamin C 30ml, phong cách                ]  │  │
│ │ [trẻ trung năng động, target TikTok 18-25 tuổi         ]  │  │
│ │ [                                                        ]  │  │
│ │                                                              │  │
│ │ Quick suggestions:                                           │  │
│ │ [📝 Product review] [🎯 Tutorial] [📊 Top 5 listicle]    │  │
│ │ [😂 Funny reaction] [📖 Storytelling] [🔥 Trend response] │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Options ──────────────────────────────────────────────────┐  │
│ │ Character: [Mila ▾]  Brand Pack: [My Brand ▾]             │  │
│ │ Product (optional): [Serum Vitamin C ▾]                    │  │
│ │ Duration: [30s ▾]  Platform: [☑ TikTok] [☐ YouTube]      │  │
│ │ Style Pack (optional): [My Skincare Style ▾]              │  │
│ │ Quality: [● Standard ~30cr] [○ Premium ~60cr]              │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ [🚀 Generate Video — ~50 credits]                                │
│                                                                  │
│ ── After generation ──                                           │
│ ┌─ Pipeline Progress ────────────────────────────────────────┐  │
│ │ ✅ Script generated (3s)                                   │  │
│ │ ✅ Scenes planned (2s)                                     │  │
│ │ ████████░░ Generating visuals... (Scene 3/5)              │  │
│ │ ○ Voice-over                                               │  │
│ │ ○ Music & SFX                                              │  │
│ │ ○ Assembly & export                                        │  │
│ │                                                              │  │
│ │ Estimated time: ~3 minutes                                  │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── After completion ──                                           │
│ [Video preview player]                                           │
│ [📤 Publish] [✏ Edit in Quick Edit] [🔄 Regenerate] [📥 DL]   │
└──────────────────────────────────────────────────────────────────┘
```

---

## 41. A/B Testing Engine

**Route**: `/studio/ab-test`
**Purpose**: Generate N video variants (different hooks, CTAs, thumbnails, music) → publish all → auto-pick winner.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Studio   🧪 A/B Testing Engine                                 │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Source ───────────────────────────────────────────────────┐  │
│ │ Base video: [Select from library ▾]                        │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Variant Dimensions ───────────────────────────────────────┐  │
│ │ ☑ Hook variation (AI generates 3 hook styles)              │  │
│ │ ☑ Thumbnail variation (3 variants)                         │  │
│ │ ☐ CTA variation (text + placement)                         │  │
│ │ ☐ Music variation (different energy levels)                │  │
│ │ Total variants: 3 · Credits: ~15                           │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Test Settings ────────────────────────────────────────────┐  │
│ │ Winner criteria: [Engagement rate ▾]                       │  │
│ │ Test duration: [24h ▾]                                     │  │
│ │ Auto-winner: [☑ ON — keep winner, option to hide loser]   │  │
│ │ Platform: [TikTok ▾]                                       │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ [🧪 Generate variants — 15 credits] [📤 Publish all]            │
│                                                                  │
│ ── Active Tests ──                                               │
│ ┌─ Test Result Card ─────────────────────────────────────────┐  │
│ │ 🧪 "Serum review" — Hook test · 18h remaining             │  │
│ │ Variant A: 2.4K views · 8.2% eng  🏆 Leading              │  │
│ │ Variant B: 1.8K views · 6.1% eng                           │  │
│ │ Variant C: 2.1K views · 5.4% eng                           │  │
│ │ [📊 Full analytics] [⏹ End early]                         │  │
│ └────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

---

## Mobile Mode Screens

### M52. Mobile Quick Edit

**Route**: `/studio/quick-edit` (mobile)
**Purpose**: Mobile-optimized video editing with transcript-based editing and touch interactions.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Quick Edit                               [Credits: ~25] [⋮]   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Video Player (full width, 16:9) ──────────────────────────┐  │
│ │ [Video preview with playhead]                               │  │
│ │ [Before ◀ ▶ After] toggle overlay                           │  │
│ │ ▶ 00:35 / 02:15                                            │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Tabs: [📝 Transcript] [✂️ Edit Plan] [⚙️ Settings]              │
│                                                                  │
│ ── Transcript Tab ──                                             │
│ ┌─ Transcript (scrollable) ──────────────────────────────────┐  │
│ │ [00:00] "Xin chào các bạn, hôm nay mình sẽ..."           │  │
│ │ [00:05] "review sản phẩm serum vitamin C này"   [🟡 uh]   │  │
│ │ [00:12] "Đầu tiên mình thấy là texture rất..."            │  │
│ │ [00:18] "nhẹ và thấm nhanh vào da" [🔴 long pause]        │  │
│ │                                                              │  │
│ │ Swipe word left = strike-through (delete)                   │  │
│ │ Tap word = select/deselect                                  │  │
│ │ Long press = context menu (delete/restore/split)            │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Edit Plan Tab ──                                              │
│ ┌─ AI Suggestions ───────────────────────────────────────────┐  │
│ │ ☑ Remove filler words (3 found)                            │  │
│ │ ☑ Remove long pauses (2 found)                             │  │
│ │ ☐ Speed up slow segments                                   │  │
│ │ ☐ Add captions                                             │  │
│ │ ☐ Auto background music                                    │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ [▶ Preview — free] [🚀 Apply edits — 25 credits]                │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M52 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Upload video | Entry → camera roll picker | `FileService/Upload` | Video uploaded, transcript generated |
| Delete word | Swipe left on word | — (client) | Word struck through |
| Restore word | Tap struck word | — (client) | Word restored |
| Toggle suggestion | Tap checkbox | — (client) | Edit plan updated |
| Preview | "Preview" | Client-side mock | Before/after comparison |
| Apply edits | "Apply" | `AssetService/Generate(type=quick_edit)` | → Generation queue |

---

### M53. Mobile Clip Factory

**Route**: `/studio/clip-factory` (mobile)
**Purpose**: Generate viral clips from long videos using swipe-based selection.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Clip Factory                            [Credits: ~15/clip]    │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ── Step 1: Upload ──                                             │
│ ┌─ Upload Area ──────────────────────────────────────────────┐  │
│ │ [📹 Chọn video dài để tạo clips]                          │  │
│ │ Video: review_full.mp4 · 15:30 · 450 MB                   │  │
│ │ [🤖 Analyzing... ████████░░ 80%]                           │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Step 2: Swipe to Select ──                                    │
│ ┌─ Clip Card Stack (Tinder-style) ───────────────────────────┐  │
│ │ ┌──────────────────────────────────────────────────────┐   │  │
│ │ │ [Video preview 9:16]                                  │   │  │
│ │ │ ▶ Clip 3 of 8 · 00:45 - 01:12 (27s)                 │   │  │
│ │ │                                                        │   │  │
│ │ │ 🔥 Virality: 87/100                                   │   │  │
│ │ │ "Review serum — before/after reveal"                   │   │  │
│ │ │                                                        │   │  │
│ │ │ ← SKIP                               SELECT →         │   │  │
│ │ └──────────────────────────────────────────────────────┘   │  │
│ │                                                              │  │
│ │ Swipe RIGHT = Select · Swipe LEFT = Skip                    │  │
│ │ Swipe UP = Preview full clip                                │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Selected: 3 clips · [📋 Review selected]                        │
│                                                                  │
│ ── After Review (bottom sheet) ──                                │
│ [🚀 Generate 3 clips — 45 credits]                              │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M53 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Upload video | Tap upload area | Camera roll picker | Video uploaded + analysis starts |
| Swipe right | Swipe clip right | — (client) | Clip selected, card flies right |
| Swipe left | Swipe clip left | — (client) | Clip skipped, card flies left |
| Swipe up | Swipe clip up | — (client) | Full-screen clip preview |
| Review | "Review selected" | — | Bottom sheet: selected clips list |
| Generate | "Generate" | `AssetService/Generate(type=clip_factory)` | → Generation queue |
| Pull-to-refresh | After analysis | `AssetService/AnalyzeVideo` | Re-analyze for more clips |

---

### M54. Mobile Multi-Merge

**Route**: `/studio/multi-merge` (mobile)
**Purpose**: Combine multiple media files into one video with mobile-optimized timeline.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Multi-Merge                              [Credits: ~20] [⋮]   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Timeline (horizontal scroll) ─────────────────────────────┐  │
│ │ [🎬 Clip1 15s] [🖼 Img2 5s] [🎬 Clip3 20s] [+ Thêm]     │  │
│ │ ← drag handles to reorder →                                │  │
│ │ Total: 40s                                                  │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Preview (full width) ─────────────────────────────────────┐  │
│ │ [Video preview of composed timeline]                        │  │
│ │ ▶ 00:12 / 00:40     [◀] [▶] [▶▶]                          │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Settings (expandable sections) ──                             │
│ ┌─ Âm thanh ──────────────────────────────── [▾ Expand] ─────┐  │
│ │ Voice: [Original ▾]     Music: [🎵 Chọn nhạc ▾]           │  │
│ │ Voice vol: [────●────] Music vol: [──●──────]              │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Chuyển cảnh ──────────────────────────── [▾ Expand] ──────┐  │
│ │ [Cut] [Fade] [Slide] [Zoom] [Glitch]                       │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Aspect: [9:16] [16:9] [1:1]                                     │
│                                                                  │
│ [▶ Preview] [🚀 Generate — 20 credits]                          │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M54 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Add media | "+ Thêm" | Camera roll / file picker | Media added to timeline |
| Reorder | Drag clip handle | — (client) | Timeline order updated |
| Remove clip | Swipe up on timeline item | — (client) | Clip removed |
| Set transition | Tap transition style | — (client) | Transition applied between clips |
| Adjust volume | Drag sliders | — (client) | Audio mix updated |
| Generate | "Generate" | `AssetService/Generate(type=multi_merge)` | → Generation queue |

---

### M55. Mobile AI Remix

**Route**: `/studio/remix` (mobile)
**Purpose**: Remix trends by matching your content to viral formats with phase-based workflow.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← AI Remix                                 [Credits: ~35] [⋮]   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Phase Progress ───────────────────────────────────────────┐  │
│ │ [● Phase 1] ── [○ Phase 2] ── [○ Phase 3]                 │  │
│ │  Input         Creative DNA    Preview                      │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Phase 1: Input ── (swipe to next)                             │
│ ┌─ Reference Video ──────────────────────────────────────────┐  │
│ │ [📋 Paste URL or 📹 Upload reference video]                │  │
│ │ [Preview thumbnail of reference video]                      │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Your Assets ──────────────────────────────────────────────┐  │
│ │ [📹 Upload your footage] or [📁 From library]              │  │
│ │ [Asset1 ×] [Asset2 ×] [+ Add]                             │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Adaptation: [Strict copy ──●── Creative freedom]                 │
│                                                                  │
│ [→ Analyze & Continue — 5 credits]                               │
│                                                                  │
│ ── Phase 2: Creative DNA (accordion) ──                          │
│ ┌─ Pacing ──────────────────────────────── [▾] ──────────────┐  │
│ │ Cut frequency: Fast (2.1s avg) · Rhythm: Energetic         │  │
│ │ [Keep ●] [Modify ○]                                        │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Visual Style ───────────────────────── [▾] ──────────────┐   │
│ │ Color grading: Warm · Transitions: Zoom cuts              │   │
│ │ [Keep ●] [Modify ○]                                       │   │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Audio ──────────────────────────────── [▾] ───────────────┐  │
│ │ Music: "trending beat" · Voice: overlay narration          │  │
│ │ [Keep ●] [Modify ○]                                       │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ [→ Generate Remix — 30 credits]                                  │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M55 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Paste URL | Paste in URL field | `AssetService/FetchReference` | Reference video loaded |
| Upload assets | Tap upload / library | Camera roll / `FileService/List` | Assets added |
| Analyze | "Analyze" | `AssetService/AnalyzeCreativeDNA` | Phase 2 populated (5 cr) |
| Toggle DNA element | Keep/Modify toggle | — (client) | Remix parameters updated |
| Generate | "Generate" | `AssetService/Generate(type=remix)` | → Generation queue (30 cr) |
| Swipe phases | Swipe left/right | — (client) | Navigate between phases |

---

### M56. Mobile Sound Studio

**Route**: `/studio/sound` (mobile)
**Purpose**: Generate and manage audio tracks (music, sound effects, voiceover) on mobile.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Sound Studio                              [Credits: ~10] [⋮]  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Tabs: [🎵 Music] [🥁 Beat] [🎤 Song] [🔊 SFX]                  │
│                                                                  │
│ ── Music Tab ──                                                  │
│ ┌─ Prompt ───────────────────────────────────────────────────┐  │
│ │ [Mô tả nhạc bạn muốn...                              ]    │  │
│ │ Ex: "upbeat lo-fi for cooking video, 30 seconds"           │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Quick Presets (horizontal scroll) ────────────────────────┐  │
│ │ [Lo-fi] [Energetic] [Chill] [Dramatic] [Corporate]        │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Duration: [15s] [30s] [●60s] [Custom]                           │
│ Mood: [Happy ▾]  Tempo: [Medium ▾]                              │
│                                                                  │
│ [🎵 Generate Music — 10 credits]                                │
│                                                                  │
│ ── Generated Tracks ──                                           │
│ ┌─ Track Card ───────────────────────────────────────────────┐  │
│ │ 🎵 Track 1 · 00:30 · Lo-fi chill                          │  │
│ │ [Simplified waveform ▁▂▃▅▆▇▆▅▃▂▁▃▅▇▆▃▂]                 │  │
│ │ [▶ Play] [📥 Download] [📋 Use in project]                │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Track Card ───────────────────────────────────────────────┐  │
│ │ 🎵 Track 2 · 00:30 · Upbeat pop                           │  │
│ │ [Simplified waveform ▂▅▇▇▅▂▁▃▇▇▅▃▁▂▅▇]                  │  │
│ │ [▶ Play] [📥 Download] [📋 Use in project]                │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ [🔄 Generate thêm — 10 credits]                                 │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M56 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Generate | "Generate" + prompt | `AssetService/Generate(type=sound)` | Tracks generated (2 variants) |
| Select preset | Tap preset chip | — (client) | Prompt auto-filled |
| Play track | "▶ Play" | — (client) | Audio plays with waveform animation |
| Download | "Download" | — | File saved to device |
| Use in project | "Use in project" | — | → Asset selector in other Studio modes |

---

### M57. Mobile Style Learning

**Route**: `/studio/style-learning` (mobile)
**Purpose**: Upload reference content to teach AI your visual/editing style.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Style Learning                                        [⋮]     │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Upload Section ───────────────────────────────────────────┐  │
│ │ 📹 Upload 3-5 video mẫu để AI học phong cách của bạn      │  │
│ │                                                              │  │
│ │ ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐    │  │
│ │ │ [📹]     │  │ [📹]     │  │ [📹]     │  │ [+ Add]  │    │  │
│ │ │ review   │  │ tutorial │  │ haul     │  │          │    │  │
│ │ │ .mp4     │  │ .mp4     │  │ .mp4     │  │          │    │  │
│ │ │ 2:30     │  │ 5:15     │  │ 3:45     │  │          │    │  │
│ │ │ [✕]      │  │ [✕]      │  │ [✕]      │  │          │    │  │
│ │ └──────────┘  └──────────┘  └──────────┘  └──────────┘    │  │
│ │                                                              │  │
│ │ [🤖 Analyze Style — 20 credits]                             │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Extracted Style Elements ──                                   │
│ ┌─ Element Card ─────────────────────────────────────────────┐  │
│ │ 🎨 Color Grading: Warm tones, high saturation              │  │
│ │ Confidence: 92% · [✏️ Adjust]                              │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Element Card ─────────────────────────────────────────────┐  │
│ │ ✂️ Editing: Fast cuts (avg 2.1s), zoom transitions          │  │
│ │ Confidence: 87% · [✏️ Adjust]                              │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Element Card ─────────────────────────────────────────────┐  │
│ │ 🎵 Audio: Background lo-fi, voice-over narration            │  │
│ │ Confidence: 78% · [✏️ Adjust]                              │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Style name: [My Creator Style          ]                        │
│ [💾 Save Style]                                                   │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M57 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Upload videos | Tap "+" or video slots | Camera roll picker | Videos uploaded |
| Remove video | Tap "✕" on video | — (client) | Video removed |
| Analyze | "Analyze Style" | `AssetService/AnalyzeStyle` | Style elements extracted (20 cr) |
| Adjust element | "Adjust" | — | Bottom sheet with parameter sliders |
| Save style | "Save Style" | `StyleService/Save` | Style available in all Studio modes |

---

### M58. Mobile Video Agent

**Route**: `/studio/agent` (mobile)
**Purpose**: AI-powered end-to-end video generation from a text prompt with pipeline monitoring.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Video Agent                              [Credits: ~50+] [⋮]  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Prompt Input ─────────────────────────────────────────────┐  │
│ │ Mô tả video bạn muốn tạo:                                 │  │
│ │ ┌──────────────────────────────────────────────────────┐   │  │
│ │ │ "Tạo video review serum Vitamin C, 60s, phong cách  │   │  │
│ │ │  tự nhiên, có before/after, nhạc lo-fi, sub tiếng   │   │  │
│ │ │  Việt, kết thúc bằng CTA mua hàng"                  │   │  │
│ │ └──────────────────────────────────────────────────────┘   │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Options (expandable) ──                                       │
│ ┌─ Tùy chọn nâng cao ──────────────── [▾ Expand] ───────────┐  │
│ │ Duration: [30s] [●60s] [90s]                               │  │
│ │ Aspect: [●9:16] [16:9] [1:1]                              │  │
│ │ Character: [None ▾] (from library)                         │  │
│ │ Brand assets: [☐ Include logo] [☐ Include products]        │  │
│ │ Voice: [AI Voice ▾]  · Language: [Tiếng Việt ▾]           │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ [🤖 Generate Video — ~50 credits]                                │
│                                                                  │
│ ── Pipeline Progress (after submit) ──                           │
│ ┌─ Vertical Stepper ────────────────────────────────────────┐   │
│ │ ✅ 1. Script generation          — Done (15s)              │   │
│ │ ✅ 2. Scene planning             — Done (8s)               │   │
│ │ 🔄 3. Asset generation           — In progress...          │   │
│ │    [████████░░░░░░░░] 55%                                  │   │
│ │ ⬜ 4. Video composition          — Waiting                 │   │
│ │ ⬜ 5. Audio mixing               — Waiting                 │   │
│ │ ⬜ 6. Final render               — Waiting                 │   │
│ │                                                            │   │
│ │ Est. remaining: ~3 min                                     │   │
│ │ [🔔 Thông báo khi xong]                                   │   │
│ └────────────────────────────────────────────────────────────┘   │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M58 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Submit prompt | "Generate Video" | `AssetService/Generate(type=video_agent)` | Pipeline starts |
| Expand options | "▾ Expand" | — (client) | Options section expands |
| Select character | Character dropdown | `CharacterService/List` | Character selected |
| Notify on complete | "Thông báo khi xong" | — | Push notification scheduled |
| Cancel | "⋮" → Cancel → confirm | `AssetService/Cancel` | Pipeline stopped, partial credits refunded |
| View result | Pipeline completes | — | Full-screen video player with share options |

#### M58 States
- **Input**: Prompt field + options
- **Processing**: Vertical stepper with live progress
- **Complete**: Full-screen preview + "📤 Share" + "📥 Download" + "📝 Edit in Quick Edit"
- **Failed**: Error message + "🔄 Retry" + "💬 Get help"
- **Background**: Push notification "Video đã sẵn sàng! 🎬" when app is closed


### 33. Product Showcase

**Route**: `/studio/showcase`
**Purpose**: Create product showcase videos from photos. 8 styles available.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Studio   🛍️ Product Showcase                  [Credits: ~15]   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Step 1: Chọn sản phẩm ────────────────────────────────────┐ │
│ │ [🔍 Search products...                               ]     │ │
│ │                                                              │ │
│ │ ┌─ Product Card ────┐ ┌─ Product Card ────┐                │ │
│ │ │ [📸] Serum VitC   │ │ [📸] Kem chống    │                │ │
│ │ │ 299,000đ          │ │ nắng · 199,000đ   │                │ │
│ │ │ [● Chọn]          │ │ [○ Chọn]          │                │ │
│ │ └────────────────────┘ └────────────────────┘                │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Step 2: Chọn style ───────────────────────────────────────┐ │
│ │ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐   │ │
│ │ │ 360° │ │Table │ │Flip &│ │Virtual│ │Life- │ │Unbox │   │ │
│ │ │ Spin │ │ Demo │ │Reveal│ │TryOn  │ │style │ │ ing  │   │ │
│ │ │ [●]  │ │ [○]  │ │ [○]  │ │ [○]   │ │ [○]  │ │ [○]  │   │ │
│ │ └──────┘ └──────┘ └──────┘ └──────┘ └──────┘ └──────┘   │ │
│ │ (hover on style → animated preview)                        │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Step 3: Customize ────────────────────────────────────────┐ │
│ │ Background: [White ▾] Duration: [15s ▾] Music: [Auto ▾]   │ │
│ │ Voice-over: [None ▾]  Text: [Product name + price ▾]       │ │
│ │ Aspect: [9:16] [16:9] [1:1]                               │ │
│ │ CTA: [Mua ngay ▾]    Pacing: [Medium ▾]                   │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Product Photos ────────────────────────────────────────────┐ │
│ │ [📸 Drop photos] or [📎 Upload] or [Import from product]   │ │
│ │ [Img1 ×] [Img2 ×] [Img3 ×] [+ Add more]                  │ │
│ │ 🤖 Auto background removal: [ON ▾]                        │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ [▶ Preview — free] [🚀 Generate — 15 credits]                   │
└──────────────────────────────────────────────────────────────────┘
```

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Search products | Type in search | Meilisearch: products index | Product cards appear |
| Select product | Click product card | — (client) | Card highlighted, photos loaded |
| Select style | Click style card | — (client) | Animated preview plays |
| Upload photos | Drag-drop / click upload | Upload to R2 | Thumbnails appear |
| Remove photo | Click × on photo | — (client) | Photo removed |
| Auto bg removal | Toggle ON | `AIService/RemoveBackground` | Photo updates (transparent bg) |
| Preview | "▶ Preview" | Client-side mock | Preview modal |
| Generate | "🚀 Generate" | `AssetService/Generate(type=showcase)` | → queue, redirect to `/studio/queue` |

---

### 34. Image-to-Video

**Route**: `/studio/img2vid`
**Purpose**: Convert static images into motion videos using AI. 6 motion styles.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Studio   🖼️ Image to Video                    [Credits: ~10]   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Upload ────────────────────────────────────────────────────┐ │
│ │ [Drop image here or click to upload]                        │ │
│ │ [Uploaded image preview — large]                            │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Motion Style ──────────────────────────────────────────────┐ │
│ │ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐   │ │
│ │ │Zoom  │ │Pan   │ │Kenburn│ │Parall│ │3D    │ │Custom│   │ │
│ │ │ In   │ │      │ │      │ │ ax   │ │ Tilt │ │Prompt│   │ │
│ │ │(anim)│ │(anim)│ │(anim)│ │(anim)│ │(anim)│ │      │   │ │
│ │ │ [●]  │ │ [○]  │ │ [○]  │ │ [○]  │ │ [○]  │ │ [○]  │   │ │
│ │ └──────┘ └──────┘ └──────┘ └──────┘ └──────┘ └──────┘   │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ Duration: [5s ▾]  Aspect: [9:16] [16:9] [1:1]                   │
│ Music: [None ▾]   Custom prompt: [optional text field    ]       │
│                                                                  │
│ [▶ Preview — free] [🚀 Generate — 10 credits]                   │
└──────────────────────────────────────────────────────────────────┘
```

---

### 35. Thumbnail Studio

**Route**: `/studio/thumbnails`
**Purpose**: Generate and A/B test thumbnails for YouTube/social content.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Studio   🎨 Thumbnail Studio                  [Credits: ~5]    │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Input ─────────────────────────────────────────────────────┐ │
│ │ Cho nội dung: [Select script/publish item ▾]                │ │
│ │ Tiêu đề video: [5 tips nấu ăn nhanh cho bận rộn       ]    │ │
│ │ Style:         [Minimal ▾] [Bold Text ▾] [Photo + Text ▾]  │ │
│ │ Face included: [☑ Có mặt] [📎 Upload face photo]           │ │
│ │ Number of variants: [3 ▾]                                   │ │
│ │                                                              │ │
│ │ [🤖 Generate thumbnails — 5 credits]                        │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Generated Variants ───────────────────────────────────────┐ │
│ │ ┌──────────┐  ┌──────────┐  ┌──────────┐                   │ │
│ │ │ Variant A│  │ Variant B│  │ Variant C│                   │ │
│ │ │ [Image]  │  │ [Image]  │  │ [Image]  │                   │ │
│ │ │ [●]      │  │ [○]      │  │ [○]      │                   │ │
│ │ │ [📥 DL]  │  │ [📥 DL]  │  │ [📥 DL]  │                   │ │
│ │ └──────────┘  └──────────┘  └──────────┘                   │ │
│ │                                                              │ │
│ │ [🧪 A/B Test — sẽ track CTR trên YouTube]                   │ │
│ │ [Chọn variant A → sử dụng] [🔄 Generate thêm — 5 cr]       │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Template Browser ─────────────────────────────────────────┐ │
│ │ Browse từ thư viện template → nhanh hơn AI generate        │ │
│ │ [Template grid with categories]                             │ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

---

### 36. Link-to-Video

**Route**: `/studio/link2vid`
**Purpose**: Paste any URL → AI crawls content → generates a video about it.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Studio   🔗 Link to Video                     [Credits: ~20]   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ URL: [https://shopee.vn/product/12345                      ]     │
│ [🔍 Crawl & Analyze]                                             │
│                                                                  │
│ ── After crawl: ──                                               │
│                                                                  │
│ ┌─ Crawled Data ──────────────────────────────────────────────┐ │
│ │ 🛍️ Detected: Product page (Shopee)                          │ │
│ │ Title: Serum Vitamin C 30ml                                 │ │
│ │ Price: 299,000đ · Rating: 4.8⭐ · Sales: 1,234             │ │
│ │ [📸 4 images extracted]                                     │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ Script template: [● Problem-Solution] [○ Listicle]               │
│                  [○ Testimonial] [○ Flash Sale] [○ Comparison]   │
│ Duration: [30s ▾]  Character: [Mila ▾]  Voice: [Vietnamese ▾]   │
│ Platform: [☑ TikTok] [☑ Instagram] [☐ YouTube]                  │
│                                                                  │
│ [🚀 Generate Video — 20 credits]                                 │
└──────────────────────────────────────────────────────────────────┘
```

---

### 37. Translation Studio

**Route**: `/studio/translate`
**Purpose**: Translate videos to other languages with optional lip-sync.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Studio   🌐 Translation Studio                [Credits: ~20]   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Source video: [📎 Upload hoặc chọn từ thư viện ▾]                │
│                                                                  │
│ ┌─ Video Preview ─────────────────────────────────────────────┐ │
│ │ [Video player with transcript overlay]                      │ │
│ │ Detected language: Vietnamese                                │ │
│ │ Duration: 45s · Words detected: 156                          │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ Target languages:                                                │
│ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐                   │
│ │ 🇺🇸   │ │ 🇯🇵   │ │ 🇰🇷   │ │ 🇹🇭   │ │ 🇮🇩   │                   │
│ │ EN   │ │ JA   │ │ KO   │ │ TH   │ │ ID   │                   │
│ │ [☑]  │ │ [☐]  │ │ [☐]  │ │ [☐]  │ │ [☐]  │                   │
│ └──────┘ └──────┘ └──────┘ └──────┘ └──────┘                   │
│                                                                  │
│ Lip-sync: [☑ Có] (thêm 5 cr/ngôn ngữ)                           │
│ Voice: [Clone from original ▾]                                    │
│ Subtitles: [☑ Burned-in] [☑ SRT file]                            │
│                                                                  │
│ Credits: 20 base + 5 lip-sync × 1 lang = 25 total               │
│ [🚀 Translate — 25 credits]                                      │
└──────────────────────────────────────────────────────────────────┘
```

---

## 42. Generation Queue

**Route**: `/studio/queue`
**Purpose**: Monitor all running and completed AI generation jobs.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Studio   📋 Hàng chờ xử lý                                    │
├──────────────────────────────────────────────────────────────────┤
│ Tabs: [Đang xử lý (2)] [Hoàn thành (15)] [Lỗi (1)]            │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Queue Item ────────────────────────────────────────────────┐ │
│ │ 🎬 Product Showcase — "Serum Vitamin C"                     │ │
│ │ ████████████░░░░░░░░ 65% · Stage: Rendering scenes          │ │
│ │ Started: 3 min ago · Est. remaining: 2 min                  │ │
│ │ Credits: 15 (deducted) · Provider: Veo 3.1                 │ │
│ │ [⏸ Pause] [❌ Cancel]                                       │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Queue Item ────────────────────────────────────────────────┐ │
│ │ 🎨 Thumbnail Gen — "5 tips nấu ăn" (3 variants)            │ │
│ │ ████████████████████ 100% ✅                                │ │
│ │ Completed: 1 min ago · Credits: 5                           │ │
│ │ [👁 Xem kết quả] [📥 Download]                              │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ── Lỗi tab: ──                                                   │
│ ┌─ Queue Item (Error) ────────────────────────────────────────┐ │
│ │ 🔗 Link-to-Video — shopee.vn/product/...                    │ │
│ │ ❌ Error: Provider timeout (Veo 3.1)                        │ │
│ │ Credits: 20 (refunded ✅)                                   │ │
│ │ [🔄 Retry] [📋 Copy error log] [🗑 Dismiss]                │ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

### Queue Item Status States
| State | Visual | Progress |
|---|---|---|
| Queued | "Đang chờ..." | No progress bar |
| Processing | "Đang xử lý" + stage name | Animated progress bar |
| Completed | "✅ Hoàn thành" | Full green bar |
| Error | "❌ Lỗi" + error message | Red bar |
| Cancelled | "Đã hủy" | Grey bar |

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Cancel job | "❌ Cancel" → confirm | `AssetService/CancelGeneration` | Status → Cancelled, credits refunded |
| Retry failed | "🔄 Retry" | `AssetService/RetryGeneration` | New queue entry |
| View result | "👁 Xem" on completed | — | → preview modal or asset detail |
| Download | "📥 Download" | Direct R2 URL | File downloads |
| Dismiss error | "🗑 Dismiss" | `AssetService/DismissError` | Item hidden |

### Real-time Updates
- WebSocket subscription to queue updates
- Progress bar animates in real-time
- Stage name updates as job progresses
- Toast notification when job completes (even if on other page)

---

## 25-26. Character Builder & Library

### 25. Character Builder

**Route**: `/studio/characters/new` or `/studio/characters/[id]/edit`

Detailed in Screen Specs 03 §27 (Continuity Packs). Character builder is accessed from both AI Studio and Continuity screens.

### 26. Character Library

**Route**: `/studio/characters`

Grid view of all characters. Click → edit. Use default star indicator. Integrates with all generation modes.

---

## Mobile Screens

### M21. Mobile AI Studio Home

**Route**: `/studio` (mobile)
**Purpose**: Browse AI production modes in a vertical grid with quick access to queue.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ 🎬 AI Studio                    [🪙 Credits: 320] [Queue (2)]   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ── Recent Projects (horizontal carousel) ──                      │
│ ┌──────────┐  ┌──────────┐  ┌──────────┐                        │
│ │ [🖼 thumb]│  │ [🖼 thumb]│  │ [🖼 thumb]│                        │
│ │ "Serum    │  │ "Skincare│  │ "Unbox   │                        │
│ │  review"  │  │  routine"│  │  haul"   │                        │
│ │ Draft     │  │ Done ✅  │  │ Queue 🔄 │                        │
│ └──────────┘  └──────────┘  └──────────┘                        │
│                                                                  │
│ ── Production Modes (2-column grid) ──                           │
│ ┌──────────────┐  ┌──────────────┐                               │
│ │ ✂️ Quick Edit │  │ 🎬 Clip      │                               │
│ │ ~25 credits  │  │ Factory      │                               │
│ │              │  │ ~15/clip     │                               │
│ ├──────────────┤  ├──────────────┤                               │
│ │ 🔀 Multi-    │  │ 🔥 AI Remix  │                               │
│ │ Merge ~20   │  │ ~35 credits  │                               │
│ ├──────────────┤  ├──────────────┤                               │
│ │ 🎵 Sound    │  │ 🧠 Style     │                               │
│ │ Studio ~10  │  │ Learning ~20 │                               │
│ ├──────────────┤  ├──────────────┤                               │
│ │ 🤖 Video    │  │ 🛍 Showcase   │                               │
│ │ Agent ~50+  │  │ ~15 credits  │                               │
│ ├──────────────┤  ├──────────────┤                               │
│ │ 🖼 Img2Vid  │  │ 🎨 Thumbnail │                               │
│ │ ~10 credits │  │ ~5 credits   │                               │
│ ├──────────────┤  ├──────────────┤                               │
│ │ 🔗 Link2Vid │  │ 🔒 [Pro]     │                               │
│ │ ~20 credits │  │ Upgrade →    │                               │
│ └──────────────┘  └──────────────┘                               │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M21 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Open mode | Tap mode card | — | → Mode's mobile screen (M52-M58, etc.) |
| View queue | "Queue" badge | — | → M22 Generation Queue |
| Resume project | Tap recent project | — | → Project's current state |
| Locked mode | Tap locked card | — | Upsell bottom sheet |

---

### M22. Mobile Generation Queue

**Route**: `/studio/queue` (mobile)
**Purpose**: Monitor all generation jobs with real-time progress and retry options.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Generation Queue                                               │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Filter: [All] [Running 2] [Completed 8] [Failed 1]              │
│                                                                  │
│ ┌─ Queue Item ───────────────────────────────────────────────┐  │
│ │ 🔄 Quick Edit — "Serum review"                             │  │
│ │ [████████████░░░░] 75% · Step 3/4 · Est. 2 min             │  │
│ │ [⏸ Pause]                                                  │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Queue Item ───────────────────────────────────────────────┐  │
│ │ 🔄 Clip Factory — 3 clips generating                       │  │
│ │ [██████░░░░░░░░░░] 40% · Clip 2/3 · Est. 5 min            │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Queue Item ───────────────────────────────────────────────┐  │
│ │ ✅ Thumbnail — "5 tips skincare"           · 30 min ago    │  │
│ │ 3 variants generated · 5 credits used                      │  │
│ │ [👁 View] [📥 Download]                                    │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Queue Item ───────────────────────────────────────────────┐  │
│ │ 🔴 Video Agent — "Product demo"           · 1h ago         │  │
│ │ Error: "GPU timeout" · 50 credits refunded                 │  │
│ │ ← Swipe L: [🔄 Retry] · Swipe R: [🗑 Dismiss]            │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Pull-to-refresh                                                  │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M22 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| View result | "View" on completed | — | Full-screen preview |
| Download | "Download" | — | File saved to device |
| Retry | Swipe left on failed | `AssetService/Retry` | New run queued |
| Dismiss | Swipe right on failed | `AssetService/Dismiss` | Item removed |
| Pull-to-refresh | Pull down | `AssetService/ListQueue` | Queue refreshed |

---

### M23. Mobile Character Library

**Route**: `/studio/characters` (mobile)
**Purpose**: Browse and manage AI characters for video generation.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Character Library                                [+ Tạo mới]  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Character Card ───────────────────────────────────────────┐  │
│ │ [Avatar] "Quân — Beauty Reviewer"                          │  │
│ │ Voice: Warm, natural · Style: Friendly                      │  │
│ │ Used in: 12 videos · Last used: 2h ago                     │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Character Card ───────────────────────────────────────────┐  │
│ │ [Avatar] "Minh — Tech Expert"                               │  │
│ │ Voice: Professional · Style: Informative                    │  │
│ │ Used in: 5 videos · Last used: 5d ago                      │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Character Card ───────────────────────────────────────────┐  │
│ │ [Avatar] "AI Narrator"                                      │  │
│ │ Voice: Neutral, clear · Style: Versatile                    │  │
│ │ System default · Used in: 3 videos                         │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Long press → [📋 Duplicate] [🗑 Delete]                         │
│                                                                  │
│                                              [+ Tạo character] ⊕│
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M23 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| View/Edit | Tap card | — | Bottom sheet: edit form (name, voice, avatar) |
| Create | FAB "+" | — | → Creation bottom sheet |
| Duplicate | Long press → Duplicate | `CharacterService/Duplicate` | New character created |
| Delete | Long press → Delete → confirm | `CharacterService/Delete` | Character removed |

