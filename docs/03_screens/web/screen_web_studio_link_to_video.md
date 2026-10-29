# Screen: Web — Link-to-Video Mode

> **Screen ID**: W036
> **Module**: M07 — AI Studio
> **Route**: `/studio/link-to-video`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 04, A1 Schema (assets)

---

## 1. Purpose & Context

Paste a URL (article, product page, blog post) → AI scrapes content → generates a video summary with visuals, voice-over, and text overlays. Great for repurposing written content into video.

### User Story
> As a creator, I want to turn blog posts and articles into short video summaries for social media.

---

## 2-5. Layout & Actions

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Studio   🔗 Link to Video                       Credits: ~20     │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ URL Input ────────────────────────────────────────────────────┐  │
│ │ [🔗 Paste URL: https://blog.example.com/skincare-tips      ]  │  │
│ │ [🔍 Analyze content]                                           │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ── After analysis ──                                                 │
│ ┌─ Extracted Content ────────────────────────────────────────────┐  │
│ │ Title: "5 mẹo skincare đơn giản"                               │  │
│ │ Key points (editable):                                          │  │
│ │ 1. [Rửa mặt bằng nước ấm, không nước nóng              ]     │  │
│ │ 2. [Thoa serum trước kem dưỡng                           ]     │  │
│ │ 3. [Chống nắng mỗi ngày, kể cả khi ở nhà               ]     │  │
│ │ 4. [Tẩy da chết 2 lần/tuần                               ]     │  │
│ │ 5. [Uống đủ nước                                          ]     │  │
│ │ [+ Add point] [🤖 AI rephrase]                                │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Video Settings ───────────────────────────────────────────────┐  │
│ │ Duration: [60s ▾]   Platform: [☑ TikTok] [☐ YouTube]         │  │
│ │ Visual style: [Animated text ▾] [Stock footage ▾]             │  │
│ │ Voice-over: [🎭 Mila ▾]   Music: [🎵 Auto ▾]                │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ [▶ Preview — free] [🚀 Generate — 20 credits]                      │
└──────────────────────────────────────────────────────────────────────┘
```

### Actions
| # | Action | Credits | Result |
|---|---|---|---|
| 1 | Analyze URL | 0 | Content extracted |
| 2 | Edit key points | 0 | Script updated |
| 3 | AI rephrase | ~2 cr | Points rewritten |
| 4 | Generate | ~20 cr | → Queue |

---

## 4. Component Hierarchy
```
LinkToVideoPage
├── AppShell (shared)
├── PageHeader (BackButton, Title, CreditBalance)
├── URLInputSection
│   ├── URLInput (paste/type)
│   └── AnalyzeButton
├── ExtractedContentSection (after analysis)
│   ├── TitleDisplay (readonly)
│   ├── KeyPointsList (editable, draggable)
│   │   ├── KeyPointInput[] (inline edit)
│   │   ├── AddPointButton
│   │   └── AIRephraseButton
│   └── EditorActions
├── VideoSettingsForm
│   ├── DurationSelector
│   ├── PlatformCheckboxes
│   ├── VisualStyleSelector
│   ├── VoiceOverSelector (character)
│   └── MusicSelector
└── ActionBar (Preview — free, Generate — credits)
```

---

## 5. States

| State | Condition | Visual |
|---|---|---|
| EMPTY | No URL entered | URL input + placeholder: "Dán link bài viết, blog, hoặc trang sản phẩm" |
| ANALYZING | URL submitted | Spinner: "🔍 Đang phân tích nội dung..." |
| EXTRACTED | Content ready | Key points list + settings form |
| GENERATING | Job submitted | SSE progress: "Đang tạo video... 35%" |
| COMPLETE | Video ready | "✅ Video đã sẵn sàng!" → Queue link |

---

## 6. Edge Cases

| Edge Case | Handling |
|---|---|
| Paywalled / login-required URL | Toast: "Không truy cập được. Trang yêu cầu đăng nhập." + manual input option |
| URL returns no text content | Warning: "Không tìm thấy nội dung text. [Nhập thủ công]" |
| Very long article (5000+ words) | AI summarizes to 5-7 key points, collapsible "Xem thêm" |
| Invalid URL format | Inline error: "URL không hợp lệ. Kiểm tra lại." |
| Insufficient credits | CTA disabled: "Cần thêm {n} credits. [Mua credits]" |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" | Auto-retry online |
| Scrape failed | URL unreachable | Toast: "Không truy cập được URL. [Thử lại] [Nhập thủ công]" | Manual input |
| Scrape timeout | Slow response (>15s) | Toast: "Trang phản hồi chậm. [Thử lại]" | Retry |
| AI rephrase failed | Service error | Toast: "Không viết lại được. [Thử lại]" | Retry |
| Generation failed | Queue error | Banner: "Lỗi tạo video. Credits không bị trừ. [Thử lại]" | Retry (refund) |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| URL input | `aria-label="Dán URL bài viết"`, `type="url"` |
| Key points list | `role="list"`, items with `role="listitem"` + drag handle `aria-label` |
| AI rephrase | `aria-label="AI viết lại nội dung"` |
| Settings panel | `role="region"`, `aria-label="Cài đặt video"` |
| Credit display | `aria-live="polite"` |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | URL input zone |
| URL analysis | 3-8s | Spinner + progress text |
| Key points | 1-2s after analysis | Points appear with stagger |
| AI rephrase | 2-3s | Shimmer on text, then replace |
| Generation | 30s-3min | SSE progress bar |

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `link_to_video.opened` | Page load | `source` |
| `link_to_video.url_analyzed` | Analysis complete | `url_domain`, `key_points_count` |
| `link_to_video.points_edited` | Manual edit | `edit_count`, `added`, `removed` |
| `link_to_video.ai_rephrased` | AI rephrase | `credits_used` |
| `link_to_video.started` | Generate | `platform`, `duration`, `credits` |
| `link_to_video.generated` | Done | `total_time` |<!-- AUDIT-FIX 2026-04-19: .completed → .generated to match canonical domain_event_catalog.md line 401 -->

---

## 11. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/studio/link-to-video/+page.svelte`
- **Scraping**: Server-side via `AIService/ScrapeURL(url)` → headless browser
- **Key points**: `AIService/ExtractKeyPoints(content)` → JSON array
- **AI rephrase**: `AIService/Rephrase(points, style)` → ~2 credits
- **Generate**: `AssetService/Generate(type=link_to_video)` → SSE
- **Drag reorder**: Client-side sortable (dnd-kit)

---

## 12. Localization Notes

- Placeholder: "Dán link bài viết, blog, hoặc trang sản phẩm"
- Analysis: "Đang phân tích nội dung..."
- Points: "Điểm chính", "Thêm điểm", "AI viết lại"
- Settings: "Thời lượng", "Nền tảng", "Phong cách hình ảnh", "Giọng đọc", "Nhạc nền"
- Progress: "Đang tạo video... 35% · Còn ~2 phút"

---

## 13. Design Tokens

| Token | Usage |
|---|---|
| `--color-studio-link` | Link-to-video mode accent |
| `--color-url-valid` | Valid URL indicator (green) |
| `--color-url-invalid` | Invalid URL indicator (red) |
| `--color-keypoint-bg` | Key point card background |
| `--color-progress-active` | Progress bar fill |
| `--color-credit-warning` | Low credit warning |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Cards |

---

## 14. Related Screens

| Screen | Relationship |
|---|---|
| [W021] Studio Launcher | Parent |
| [W030] Studio Queue | Job tracking |
| [W029] Asset Library | Output storage |

---

## 15. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: Added proper hierarchy, 5 states, 5 edge cases (paywalled content), 5 errors, accessibility for content extraction, SSE progress, 6 analytics, SvelteKit impl, 8 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
