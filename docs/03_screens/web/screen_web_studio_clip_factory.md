# Screen: Web — Clip Factory

> **Screen ID**: W023
> **Module**: M07 — AI Studio
> **Route**: `/studio/clip-factory`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4.4, Pack 04, Product Freeze §15, A1 Schema (assets, generation_queue)

---

## 1. Purpose & Context

Upload a long video → AI detects and extracts best clips → rate by virality score → batch export. Designed for repurposing YouTube/podcast content into short-form TikTok/Reels clips.

### User Story
> As a creator, I want to upload my long YouTube video and have AI find the most viral moments automatically.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Studio   🎬 Clip Factory                      [Source: 12:34]    │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Source Video ─────────────────────────────────────────────────┐  │
│ │ [Video preview — scrub timeline]                                │  │
│ │ ████████████████████░░░░░░░░░░░░░ 12:34                        │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ Detected Clips (8)              Sort: [Virality ▾] [Duration ▾]     │
│ ☑ Select all (3 selected)       [Batch: Add Captions ▾]             │
│                                                                      │
│ ┌─ Clip Card ────────────────────────────────────────────────────┐  │
│ │ ┌───────┐ Clip 1 — 0:45-1:12 (27s)                ⭐ 87/100  │  │
│ │ │ Thumb │ Hook: Question | Pacing: Fast                         │  │
│ │ │       │ "Bạn có biết rằng 90%..."                             │  │
│ │ │       │ Virality breakdown: [📊 See details]                  │  │
│ │ └───────┘                                                       │  │
│ │ [☑ Select] [▶ Preview] [✏ Edit in Quick Edit] [📊 Score]       │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ [Export 3 selected → TikTok + Reels + Shorts — ~45 credits]         │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
ClipFactoryPage
├── AppShell (shared)
├── PageHeader (← Studio, title, source duration)
├── SourceVideoSection
│   ├── VideoPlayer (scrubable timeline)
│   └── TimelineBar (with clip markers)
├── ClipControls
│   ├── ClipCount
│   ├── SortDropdown (Virality / Duration)
│   ├── SelectAllCheckbox
│   └── BatchActionDropdown (Add Captions, Platform preset)
├── ClipList
│   └── ClipCard[]
│       ├── Thumbnail
│       ├── ClipInfo (number, time range, duration)
│       ├── ViralityBadge (🟢/🟡/🔴 score)
│       ├── HookType + PacingLabel
│       ├── ScriptSnippet
│       ├── ScoreDetailPopover
│       │   └── ScoreBar[] (hook, pacing, visual, topic, trending)
│       ├── SelectCheckbox
│       ├── PreviewButton
│       ├── EditInQuickEditButton
│       └── ScoreButton
└── ExportBar
    ├── PlatformSelectors
    ├── CreditEstimate
    └── ExportButton
```

---

## 4-5. Data & Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Upload source | File upload | Upload to R2 | Analysis begins | `asset:generate` |
| 2 | Analyze video | Auto after upload | `AIService/AnalyzeClips` | Cards appear (30-90s) | `asset:generate` |
| 3 | Select clip | Toggle checkbox | — (client) | Selection count updates | `asset:generate` |
| 4 | Preview clip | ▶ Preview | — (client) | Player seeks to clip | `asset:generate` |
| 5 | Edit clip | ✏ Edit | — | → `/studio/quick-edit?clip=[id]` | `asset:generate` |
| 6 | View score | 📊 Score | — (client) | Popover with 5-dimension breakdown | `asset:generate` |
| 7 | Batch export | Export button | `AssetService/BatchExport` | Multi-platform → Queue | `asset:generate` |

### Virality Score Breakdown
| Dimension | Weight | Meaning |
|---|---|---|
| Hook strength | 25% | Quality of opening hook |
| Pacing quality | 20% | Cut rhythm and flow |
| Visual engagement | 20% | Visual variety and quality |
| Topic relevance | 15% | Match to creator niche |
| Trending match | 20% | Similarity to trending formats |

---

## 6. Edge Cases

| Edge Case | Handling |
|---|---|
| Video too long (> 30 min) | Warning: "Video dài — phân tích mất 3-5 phút. [Tiếp tục?]" |
| No viral clips detected | "Không tìm thấy clip tiềm năng. [Thử video khác] [Cắt thủ công]" |
| Video has no speech | Info: "Không phát hiện lời nói. Score dựa trên hình ảnh." |
| Batch export > 50 credits | Confirm: "Export {n} clips tốn {credits} credits. [Tiếp tục?]" |
| Clip overlaps with another | Auto-adjust boundaries: "Đã điều chỉnh để tránh trùng lặp" |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" | Auto-retry online |
| Upload failed | File too large | Toast: "Không upload. Tối đa 2GB. [Thử lại]" | Retry |
| Analysis failed | AI error | Toast: "Phân tích thất bại. Credits hoàn trả. [Thử lại]" | Retry |
| Export failed | Queue error | Toast: "Không export clip {n}. [Thử lại]" | Retry individual |
| Score unavailable | ML error | Info: "Score không khả dụng. Clips vẫn hiển thị." | Hide score column |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| Clip list | `role="list"`, clip cards `role="listitem"` |
| Clip card | `aria-label="Clip {n}: {time_range}, {duration}s, virality {score}/100"` |
| Score badge | `aria-label="Điểm viral: {score} — {level}"` (not color-only) |
| Score detail popover | `role="dialog"`, `aria-label="Chi tiết điểm viral"` |
| Select checkbox | Standard checkbox with `aria-label="Chọn clip {n}"` |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Upload zone |
| Video upload | 5-30s | Progress bar (large files) |
| Analysis | 30-90s | "Đang phân tích..." with time estimate |
| Clip cards | 200ms after analysis | Cards stagger in by virality |
| Export | 10-30s per clip | Queue progress per clip |

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `clip_factory.opened` | Page load | `source` |
| `clip_factory.uploaded` | Upload complete | `video_duration`, `file_size` |
| `clip_factory.analyzed` | Analysis complete | `clips_found`, `analysis_time` |
| `clip_factory.clip_previewed` | Preview click | `clip_id`, `virality_score` |
| `clip_factory.clip_edited` | Edit in Quick Edit | `clip_id` |
| `clip_factory.exported` | Batch export | `clip_count`, `platforms`, `credits` |
| `clip_factory.score_viewed` | Score detail opened | `clip_id`, `score` |

---

## 11. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/studio/clip-factory/+page.svelte`
- **Upload**: Chunked upload to R2 (up to 2GB)
- **Analysis**: `AIService/AnalyzeClips(asset_id)` → Whisper transcription + scene detection
- **Virality ML**: Server-side model scoring 5 dimensions
- **Preview**: Client-side video seek to clip boundaries
- **Edit**: Navigate to `/studio/quick-edit?clip=[id]`
- **Export**: `AssetService/BatchExport(clip_ids, platforms)` → Queue

---

## 12. Localization Notes

- Status: "Đang phân tích...", "Sẵn sàng", "Đang export"
- Virality: "⭐ 87/100 — Tiềm năng cao", "⭐ 55/100 — Trung bình"
- Hook types: "Câu hỏi", "Mở bài shock", "Thống kê", "Cá nhân"
- Pacing: "Nhanh", "Trung bình", "Chậm"
- Export: "Export {n} clips đã chọn → {platforms}"

---

## 13. Design Tokens

| Token | Usage |
|---|---|
| `--color-studio-clip` | Clip factory mode accent |
| `--color-virality-high` | Score > 70 (green) |
| `--color-virality-medium` | Score 40-70 (amber) |
| `--color-virality-low` | Score < 40 (red) |
| `--color-clip-selected` | Selected clip border |
| `--color-clip-marker` | Timeline clip markers |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Cards |

---

## 14. Related Screens

| Screen | Relationship |
|---|---|
| [W021] Studio Launcher | Parent |
| [W022] Quick Edit | Edit individual clip |
| [M015] Mobile Clip Factory | Mobile equivalent |

---

## 15. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: 5 edge cases (long video, no clips), 5 errors, clip card accessibility, 7 analytics, SvelteKit impl (Whisper, scene detection), 8 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
