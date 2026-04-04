# Screen: Web — Image-to-Video Mode

> **Screen ID**: W035
> **Module**: M07 — AI Studio
> **Route**: `/studio/image-to-video`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 04, PRD §22, A1 Schema (assets, ai_jobs), B5 RBAC §2.7

---

## 1. Purpose & Context

Transform static images into animated videos. AI adds motion (pan, zoom, parallax, morphing), transitions between images, and optional music/voice-over. Ideal for converting product photos, carousel posts, or artwork into video content.

### User Story
> As a creator, I want to turn my Instagram carousel photos into a short video with smooth animations.

### User Goals
- Upload multiple images and create a video slideshow with AI motion
- Choose motion style per image (Ken Burns, parallax, etc.)
- Add music and voice-over
- Preview before spending credits

### Entry Points
- AI Studio Launcher (W030): "🖼️ Image to Video" mode
- Content Editor: "Convert images to video"
- Asset Library: select images → "Create video"

### Exit Points
- Generated → Asset Library / Content Editor
- "Queue" → AI Queue status

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Studio   🖼️ Image to Video                     Credits: ~10-25   │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Image Upload ────────────────────────────────────────────────┐   │
│ │ [📸 Drop images or click to upload] (2-20 images)             │   │
│ │                                                                │   │
│ │ [🖼 Img1] [🖼 Img2] [🖼 Img3] [🖼 Img4] [🖼 Img5] [+ Add]  │   │
│ │ ← drag to reorder →                                           │   │
│ │                                                                │   │
│ │ Per-image settings (click to expand):                          │   │
│ │ Img1: Duration [3s ▾] · Motion [Ken Burns ▾] · Focal [Auto]  │   │
│ │ Img2: Duration [3s ▾] · Motion [Parallax ▾] · Focal [Center] │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Motion Style (global default) ──────────────────────────────┐   │
│ │ [🔍 Ken Burns] [🌊 Parallax] [📐 3D Rotate] [🔄 Morph]     │   │
│ │ [🎬 Cinematic] [🔀 Random mix]                               │   │
│ │ Transition: [Fade ▾ | Cut | Slide | Zoom | Dissolve]        │   │
│ │ Transition duration: [0.5s ▾]                                  │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Audio ───────────────────────────────────────────────────────┐   │
│ │ Background music:                                              │   │
│ │ [🎵 Auto-match mood ▾] [📎 Upload own] [🎵 Generate AI (+5cr)]│  │
│ │ Volume: [━━━━━━━━○━━━] 70%                                    │   │
│ │                                                                │   │
│ │ Voice-over:                                                    │   │
│ │ [None ▾] [🎭 AI character ▾] [🎤 Record own]                 │   │
│ │ AI character: [Vietnamese Female — Natural ▾]                  │   │
│ │ Script: [Text input for voice-over script...]                 │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Output settings:                                                     │
│ Aspect: [● 9:16 (TikTok/Reels)] [○ 16:9 (YouTube)] [○ 1:1 (IG)]  │
│ Quality: [○ Draft 5cr] [● Standard 10cr] [○ Premium 25cr]          │
│ Duration: Auto (based on images × per-image duration)               │
│                                                                      │
│ [▶ Preview — free] [🚀 Generate — {credits} credits]               │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Motion Styles

| Style | Description | Best For |
|---|---|---|
| 🔍 Ken Burns | Slow pan + zoom on focal point | Portraits, landscapes |
| 🌊 Parallax | Depth-based layer motion | Product photos |
| 📐 3D Rotate | Subtle 3D tilt effect | Flat-lay, artwork |
| 🔄 Morph | Image-to-image AI transition | Sequential content |
| 🎬 Cinematic | Dramatic zoom + color grade | Brand content |
| 🔀 Random | AI picks best per image | Quick, varied |

---

## 5. States

| State | Condition | Visual |
|---|---|---|
| EMPTY | No images uploaded | Drop zone: "📸 Kéo thả hình ảnh vào đây (2-20 hình)" |
| IMAGES_LOADED | Images uploaded | Image strip with drag reorder |
| PREVIEWING | Free preview playing | Preview player with scrub bar |
| GENERATING | Credits spent, processing | "🚀 Đang tạo video... {step_progress}" with cancel |
| GENERATED | Video ready | Player with download + use buttons |
| INSUFFICIENT_CREDITS | Not enough credits | "⚠️ Thiếu {n} credits. [💳 Mua thêm]" |
| ERROR | Generation failed | Error with retry (credits refunded) |

---
---

## 6. Component Hierarchy

```
ImageToVideoPage
├── AppShell (shared)
├── PageHeader (BackButton, Title, CreditBalance)
├── ImageUploadSection
│   ├── DropZone (2-20 images)
│   ├── ImageStrip (draggable, with per-image settings)
│   └── AddMoreButton
├── MotionStyleSelector (global default)
│   ├── StyleGrid (Ken Burns, Parallax, 3D, Morph, Cinematic, Random)
│   ├── TransitionSelector
│   └── TransitionDurationInput
├── AudioSection
│   ├── MusicSelector (Auto/Upload/Generate)
│   ├── VolumeSlider
│   └── VoiceOverControl (None/AI/Record)
├── OutputSettings
│   ├── AspectRatioSelector
│   ├── QualityTierSelector (Draft/Standard/Premium)
│   └── DurationDisplay (auto-calculated)
└── ActionBar (Preview — free, Generate — credits)
```

---

## 7. Edge Cases

| Edge Case | Handling |
|---|---|
| Only 1 image | Warning: "Thêm ít nhất 1 ảnh nữa để tạo video" |
| > 20 images | Upload disabled: "Tối đa 20 ảnh. [Xóa bớt để thêm]" |
| Mixed resolutions | Auto upscale low-res, warning: "Một số ảnh sẽ được phóng to" |
| Morph style with dissimilar images | Warning: "Ảnh khác nhau nhiều — morph có thể không tự nhiên" |
| Insufficient credits | CTA shows tier options: "Draft 5cr / Standard 10cr / Premium 25cr" |

---

## 8. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" | Auto-retry online |
| Image upload failed | File error | Toast: "Không upload {filename}. [Thử lại]" | Retry |
| Generation failed | AI error | Banner: "Lỗi tạo video. Credits hoàn trả. [Thử lại]" | Retry |
| AI music gen failed | Service error | Toast: "Không tạo nhạc. [Upload nhạc riêng]" | Fallback |
| Preview failed | Client error | Toast: "Không tạo preview. [Thử lại]" | Retry |

---

## 9. Accessibility

| Element | Requirement |
|---|---|
| Image strip | `role="listbox"`, images as `role="option"`, drag with keyboard arrows |
| Motion style grid | `role="radiogroup"`, styles as `role="radio"` with `aria-checked` |
| Per-image settings | Expandable: `aria-expanded`, `aria-controls` for settings panel |
| Quality tier selector | `role="radiogroup"`, `aria-label="Chọn chất lượng"` |
| Volume slider | `role="slider"`, `aria-label="Âm lượng nhạc nền: {n}%"` |

---

## 10. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Drop zone + style grid |
| Image upload | 1-3s per image | Progress bar per file |
| Preview | 3-10s | Spinner in preview modal |
| Generation | 30s-3min | SSE progress: "Đang tạo video..." with step detail |
| AI music | 10-20s (if selected) | Progress in music slot |

---

## 11. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `image_to_video.opened` | Page load | `source` |
| `image_to_video.images_uploaded` | Upload complete | `image_count` |
| `image_to_video.motion_selected` | Style chosen | `motion_style` |
| `image_to_video.previewed` | Preview clicked | `image_count`, `motion_style` |
| `image_to_video.started` | Generate clicked | `image_count`, `quality`, `credits`, `aspect` |
| `image_to_video.completed` | SSE complete | `duration`, `total_time` |
| `image_to_video.failed` | Error | `error_type` |

---

## 12. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/studio/image-to-video/+page.svelte`
- **Upload**: Chunked to R2, auto resize for quality tier
- **Motion**: Per-image or global default, sent as JSON config
- **Preview**: Client-side animation preview (CSS transforms approx)
- **Generate**: `AssetService/Generate(type=image_to_video, config)` → SSE
- **Music**: `AIService/GenerateMusic(mood=auto_match)` → +5 credits
- **Quality tiers**: Draft (720p, fast), Standard (1080p), Premium (4K, color grade)

---

## 13. Localization Notes

- Motions: "🔍 Ken Burns", "🌊 Parallax", "📐 Xoay 3D", "🔄 Biến hình", "🎬 Cinematic", "🔀 Ngẫu nhiên"
- Transitions: "Fade", "Cut", "Slide", "Zoom", "Dissolve"
- Quality: "Bản nháp (5 cr)", "Chuẩn (10 cr)", "Cao cấp (25 cr)"
- Aspect: "9:16 (TikTok/Reels)", "16:9 (YouTube)", "1:1 (Instagram)"
- Progress: "Đang tạo video... 45% · Bước: Tạo hình ảnh chuyển động"

---

## 14. Design Tokens

| Token | Usage |
|---|---|
| `--color-studio-i2v` | Image-to-video mode accent |
| `--color-motion-ken-burns` | Ken Burns style card |
| `--color-motion-parallax` | Parallax style card |
| `--color-motion-selected` | Selected motion border |
| `--color-quality-draft` | Draft tier indicator |
| `--color-quality-standard` | Standard tier indicator |
| `--color-quality-premium` | Premium tier indicator (gold) |
| `--color-surface-elevated` | Cards |

---

## 15. Related Screens

| Screen | Relationship |
|---|---|
| [W021] Studio Launcher | Parent |
| [W026] Thumbnail Generator | Image source |
| [W028] Sound Manager | Music generation |
| [W030] Studio Queue | Job tracking |

---

## 16. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: Proper component hierarchy, 5 edge cases, 5 errors, image drag accessibility, 7 analytics, SvelteKit impl (motion styles, quality tiers), 8 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
