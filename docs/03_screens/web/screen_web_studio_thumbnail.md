# Screen: Web — Thumbnail Studio

> **Screen ID**: W026
> **Module**: M07 — AI Studio
> **Route**: `/studio/thumbnail`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 04, A1 Schema (assets)

---

## 1. Purpose & Context

AI thumbnail generation optimized for click-through rate. Generate multiple variants from video frames or custom prompts, with text overlay options and A/B variant suggestions.

### User Story
> As a creator, I want eye-catching thumbnails that maximize click-through rates without spending time on Photoshop.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Studio   🎨 Thumbnail Studio                    Credits: ~5      │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Source ───────────────────────────────────────────────────────┐  │
│ │ [📎 Upload image] [📂 From video frame ▾] [✍ AI Generate]    │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Template Style ───────────────────────────────────────────────┐  │
│ │ [🔥 Emotion] [🎬 YouTube] [📊 Split] [😱 Clickbait] [📸 Clean]│ │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Generated Variants (3-column grid) ───────────────────────────┐ │
│ │ ┌────────────┐  ┌────────────┐  ┌────────────┐                │ │
│ │ │ Variant 1  │  │ Variant 2  │  │ Variant 3  │                │ │
│ │ │ CTR: 🟢    │  │ CTR: 🟡    │  │ CTR: 🔴    │                │ │
│ │ │ [✏ Edit]   │  │ [✏ Edit]   │  │ [✏ Edit]   │                │ │
│ │ │ [✅ Select] │  │ [○ Select] │  │ [○ Select] │                │ │
│ │ └────────────┘  └────────────┘  └────────────┘                │ │
│ │ [🔄 Regenerate more]                                           │ │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Text Overlay Editor ──────────────────────────────────────────┐  │
│ │ Text: [5 SAI LẦM SKINCARE                                 ]   │  │
│ │ Font: [Bold Sans ▾]  Size: [48px ▾]  Color: [#FFF ▾]         │  │
│ │ Position: [Top ○] [Center ●] [Bottom ○]                       │  │
│ │ Outline: [☑ Black 2px]   Shadow: [☑ On]                      │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ [📥 Download 1080p] [📤 Use for video] [🔄 Generate more — 5 cr]  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3-5. Component & Actions

```
ThumbnailStudioPage
├── AppShell
├── SourceSelector (upload / video frame / AI generate)
├── StyleGrid (5 template styles)
├── VariantGrid (3-column)
│   └── ThumbnailVariant[] (with CTR prediction + edit + select)
├── TextOverlayEditor
│   ├── TextInput, FontSelector, SizeSelector
│   ├── ColorPicker, PositionSelector
│   └── OutlineToggle, ShadowToggle
├── RegenerateButton
└── ActionBar (Download, Use, Generate more)
```

| # | Action | Trigger | API | Credits | Result |
|---|---|---|---|---|---|
| 1 | Generate | Select source + style → auto | `AIService/GenerateThumbnails` | ~5 cr | 3 variants appear |
| 2 | Edit text | Text overlay editor | — (client) | 0 | Real-time preview |
| 3 | Select variant | "✅ Select" | — (client) | 0 | Variant selected |
| 4 | Download | "📥 Download" | Direct | 0 | 1080p PNG |
| 5 | Regenerate | "🔄 Generate more" | Same API | ~5 cr | 3 new variants |

---

## 6. CTR Prediction Model

AI predicts click-through rate based on:

| Factor | Weight | Description |
|---|---|---|
| Face expression | 30% | Emotion intensity, eye contact |
| Text contrast | 25% | Readability, font size ratio |
| Color vibrancy | 20% | Saturation, color harmony |
| Composition | 15% | Rule of thirds, focal point |
| Trending match | 10% | Similarity to high-CTR thumbnails |

Score display: 🟢 > 70% (high), 🟡 40-70% (medium), 🔴 < 40% (low)

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| EMPTY | No source selected | Source selector: "Chọn ảnh, frame video, hoặc AI tạo" |
| GENERATING | Processing | Spinner: "🎨 Đang tạo thumbnail..." (3-5s) |
| VARIANTS_READY | 3 variants generated | 3-column grid with CTR scores |
| EDITING | Text overlay active | Canvas editor with real-time preview |
| SELECTED | Variant chosen | Selected variant highlighted, actions enabled |

---

## 8. Edge Cases

| Edge Case | Handling |
|---|---|
| Source image < 500px | Warning: "Ảnh gốc quá nhỏ. Kết quả có thể bị mờ." |
| All variants low CTR | Suggestion: "Thử style khác hoặc thêm khuôn mặt vào ảnh" |
| Text overlay too long | Auto-resize font: max 3 lines, minimum 24px |
| No face detected | Info: "Không phát hiện khuôn mặt. Thumbnail vẫn tạo được." |
| Insufficient credits | CTA disabled: "Cần thêm {n} credits. [Mua credits]" |

---

## 9. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" | Auto-retry online |
| Generation failed | AI error | Toast: "Không tạo thumbnail. Credits hoàn trả. [Thử lại]" | Retry |
| Upload failed | File error | Toast: "Không upload được ảnh. [Thử lại]" | Retry |
| Download failed | Export error | Toast: "Không tải xuống được. [Thử lại]" | Retry |
| Video frame extract failed | Video error | Toast: "Không trích xuất frame. [Chọn ảnh khác]" | Alternative |

---

## 10. Accessibility

| Element | Requirement |
|---|---|
| Variant grid | `role="radiogroup"`, `aria-label="Chọn thumbnail variant"` |
| Variant cards | `role="radio"`, `aria-checked`, `aria-label="Variant {n}, CTR: {score}%"` |
| CTR badge | `aria-label="Dự đoán click: {score}% — {level}"` (not color-only) |
| Text overlay editor | `aria-label="Chỉnh sửa text trên thumbnail"` |
| Style grid | `role="radiogroup"`, `aria-label="Chọn phong cách"` |

---

## 11. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Source selector + style grid |
| Image upload | 1-2s | Progress bar |
| Thumbnail generation | 3-5s | Spinner in variant area |
| Text overlay | Realtime | Canvas updates instantly |
| Download | 1-2s | Progress indicator |

---

## 12. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `thumbnail.opened` | Page load | `source` |
| `thumbnail.source_selected` | Source chosen | `source_type` (upload/frame/ai) |
| `thumbnail.generated` | Generation complete | `style`, `credits_used` |
| `thumbnail.text_edited` | Text overlay changed | `text_length`, `font`, `position` |
| `thumbnail.selected` | Variant chosen | `variant_id`, `ctr_score` |
| `thumbnail.downloaded` | Download | `resolution` |
| `thumbnail.regenerated` | Regenerate | `style`, `credits_used` |

---

## 13. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/studio/thumbnail/+page.svelte`
- **Generation**: `AIService/GenerateThumbnails(source, style)` → 3 variants
- **Text overlay**: `<canvas>` API for real-time preview + rendering
- **CTR model**: Runs on generation response (server-side ML)
- **Download**: Client-side canvas → PNG blob → download
- **Video frames**: `AssetService/ExtractFrames(asset_id, count=10)` → frame picker

---

## 14. Localization Notes

- Styles: "🔥 Cảm xúc", "🎬 YouTube", "📊 Chia đôi", "😱 Clickbait", "📸 Tối giản"
- CTR: "Dự đoán click cao 🟢", "Trung bình 🟡", "Thấp 🔴"
- Text: "Chữ", "Font", "Kích thước", "Màu", "Vị trí", "Viền", "Bóng"
- Actions: "Tải xuống 1080p", "Sử dụng cho video", "Tạo thêm"

---

## 15. Design Tokens

| Token | Usage |
|---|---|
| `--color-studio-thumbnail` | Thumbnail mode accent |
| `--color-ctr-high` | CTR > 70% (green) |
| `--color-ctr-medium` | CTR 40-70% (amber) |
| `--color-ctr-low` | CTR < 40% (red) |
| `--color-variant-selected` | Selected variant border |
| `--color-text-overlay-bg` | Text editor panel bg |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Cards |

---

## 16. Related Screens

| Screen | Relationship |
|---|---|
| [W021] Studio Launcher | Parent |
| [W027] A/B Testing | Thumbnail variants for testing |
| [W029] Asset Library | Output |

---

## 17. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: CTR prediction model, 5 states, 5 edge cases, 5 errors, canvas accessibility, 7 analytics, SvelteKit impl, 8 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
