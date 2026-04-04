# Screen: Web — Style Learning

> **Screen ID**: W032
> **Module**: M07 — AI Studio
> **Route**: `/studio/style-learning`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 04, A1 Schema (style_packs)

---

## 1. Purpose & Context

Extract editing style from reference videos → create reusable Style Pack for Continuity OS. Analyzes color palette, cut pacing, text style, music preferences, transitions, hook patterns, and visual mood.

### User Story
> As a creator building a consistent brand, I want to extract my editing style from existing videos and save it as a reusable template.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Studio   🎨 Style Learning                      Credits: ~15     │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Input ────────────────────────────────────────────────────────┐  │
│ │ Reference videos (1-5): [📎 Upload]                            │  │
│ │ [Video1 ×] [Video2 ×] [+ Add more]                            │  │
│ │ [🔍 Analyze style — 15 credits]                                │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ── After analysis ──                                                 │
│ ┌─ Extracted Style Elements ─────────────────────────────────────┐  │
│ │ 🎨 Color palette: [████ Warm tones, high contrast]             │  │
│ │ ✂️ Cut pacing: Fast (avg 1.8s/cut)                              │  │
│ │ 📝 Text style: Bold sans-serif, bottom-center                  │  │
│ │ 🎵 Music style: Upbeat pop, BPM 110-130                       │  │
│ │ 🎬 Transitions: Jump cuts, occasional zoom                     │  │
│ │ 📊 Hook pattern: Text overlay question, 2-3s                   │  │
│ │ 🎭 Visual mood: Bright, lifestyle, product closeups            │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Save as Style Pack ───────────────────────────────────────────┐  │
│ │ Pack name: [My Skincare Style                             ]    │  │
│ │ [💾 Save to Continuity OS] [▶ Apply to next video]             │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ My Style Packs ───────────────────────────────────────────────┐  │
│ │ 🎨 "My Skincare Style" — Created 2d ago      [Edit] [Apply]   │  │
│ │ 🎨 "Tech Review Style" — Created 1w ago      [Edit] [Apply]   │  │
│ └────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3-5. Component & Actions

```
StyleLearningPage
├── AppShell
├── UploadSection (1-5 reference videos)
├── AnalyzeButton
├── ExtractedStyleCard (7 style elements)
├── SaveSection (name input + save/apply buttons)
└── MyStylePacksList
    └── StylePackRow[] (name, date, edit/apply actions)
```

| # | Action | Trigger | API | Result |
|---|---|---|---|---|
| 1 | Upload references | File upload | Upload to R2 | Videos listed |
| 2 | Analyze | "🔍 Analyze" | `AIService/AnalyzeStyle` (15 cr) | Style elements shown |
| 3 | Save pack | "💾 Save" | `StylePackService/Create` | Pack saved |
| 4 | Apply pack | "▶ Apply" | — | → Studio mode with pack pre-selected |
| 5 | Edit pack | "Edit" | → `/studio/style-learning/[id]` | Edit mode |

---

## 6. States

| State | Condition | Visual |
|---|---|---|
| EMPTY | No videos uploaded | Upload zone: "Tải lên 1-5 video tham chiếu" |
| UPLOADING | Files uploading | Progress bar per video |
| ANALYZING | Analysis in progress | Spinner: "🔍 Đang phân tích phong cách..." (15-30s) |
| RESULTS | Style extracted | 7 style element cards + save section |
| SAVED | Pack saved | "✅ Style Pack đã lưu!" + My Packs list |

---

## 7. Edge Cases

| Edge Case | Handling |
|---|---|
| Only 1 video uploaded | Warning: "Nên tải 3+ video để kết quả chính xác hơn" |
| Videos have inconsistent styles | Show: "⚠️ Phong cách không đồng nhất. Kết quả là trung bình." |
| Video too short (< 10s) | Toast: "Video quá ngắn. Tối thiểu 10 giây." |
| Style pack name duplicate | Inline error: "Tên đã tồn tại. Chọn tên khác." |
| Max 10 packs (plan limit) | Modal: "Đạt giới hạn. [Xóa pack cũ] [Nâng cấp]" |

---

## 8. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" | Auto-retry online |
| Upload failed | File error | Toast: "Không upload được video. [Thử lại]" | Retry |
| Analysis failed | AI error | Toast: "Phân tích thất bại. Credits không trừ. [Thử lại]" | Retry |
| Save failed | Server error | Toast: "Không lưu pack. [Thử lại]" | Retry |
| Pack load failed | Server error | Toast: "Không tải danh sách pack. [Thử lại]" | Retry |

---

## 9. Accessibility

| Element | Requirement |
|---|---|
| Style elements list | `role="list"`, elements `role="listitem"` |
| Color palette | `aria-label="Bảng màu: {description}"` (not color-only) |
| Upload zone | `aria-label="Tải lên video tham chiếu"`, keyboard accessible |
| Style packs list | `role="list"`, pack rows with `aria-label="{name}, tạo {date}"` |
| Analyze button | `aria-label="Phân tích phong cách — 15 credits"` |

---

## 10. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Upload zone + My Packs skeleton |
| Video upload | 2-5s per video | Progress bar per file |
| Style analysis | 15-30s | Spinner with progress text |
| Style elements | 200ms after analysis | Cards stagger in |
| My Packs list | 200-400ms | Pack rows populate |

---

## 11. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `style_learning.opened` | Page load | `source`, `existing_packs_count` |
| `style_learning.videos_uploaded` | Upload complete | `video_count`, `total_duration` |
| `style_learning.analyzed` | Analysis complete | `credits_used`, `video_count` |
| `style_learning.pack_saved` | Save clicked | `pack_name`, `element_count` |
| `style_learning.pack_applied` | Apply clicked | `pack_id`, `target_mode` |
| `style_learning.pack_deleted` | Delete confirmed | `pack_id` |

---

## 12. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/studio/style-learning/+page.svelte`
- **Edit route**: `src/routes/(app)/studio/style-learning/[id]/+page.svelte`
- **Server load**: `+page.server.ts` → fetch user's style packs
- **Upload**: Chunked to R2 (video files)
- **Analysis**: `AIService/AnalyzeStyle(asset_ids)` → JSON style config
- **Storage**: Style packs → `StylePackService/Create|Update|Delete`
- **Integration**: Other modes reference pack via `style_pack_id` query param

---

## 13. Localization Notes

- Elements: "Bảng màu", "Nhịp cắt", "Kiểu chữ", "Phong cách nhạc", "Chuyển cảnh", "Mẫu hook", "Mood hình ảnh"
- Pacing: "Nhanh (1.8s/cắt)", "Trung bình (3s/cắt)", "Chậm (5s/cắt)"
- Actions: "Phân tích phong cách", "Lưu vào Continuity OS", "Áp dụng cho video tiếp"
- Pack status: "Đang sử dụng", "Chưa sử dụng"

---

## 14. Design Tokens

| Token | Usage |
|---|---|
| `--color-studio-style` | Style learning mode accent |
| `--color-palette-swatch` | Color palette display bg |
| `--color-element-card` | Style element card bg |
| `--color-pack-active` | Active/used pack indicator |
| `--color-pack-inactive` | Unused pack indicator |
| `--color-credit-warning` | Low credit warning |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Cards, panels |

---

## 15. Related Screens

| Screen | Relationship |
|---|---|
| [W021] Studio Launcher | Parent |
| [W025] AI Remix | Uses style packs |
| [W031] Video Agent | Uses style packs |

---

## 16. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: 5 states, 5 edge cases (inconsistent styles), 5 errors, style element accessibility, 6 analytics, SvelteKit impl, 8 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
