# Screen: Web — Derivative Manager

> **Screen ID**: W018
> **Module**: M09 — Asset Derivative Manager
> **Route**: `/derivatives`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01, PRD §23.9, A1 Schema (content_items, derivatives, asset_variants), B5 RBAC §2.7

---

## 1. Purpose & Context

Manage content derivatives — repurposed/remixed versions of original content for different platforms. Tree structure groups derivatives under their source content, showing platform-specific adaptations (aspect ratios, durations, formats) and their publish status.

### User Goals
- See all derivatives organized by source content (tree view)
- Create new derivatives from existing content (resize, re-edit, AI remix)
- Track publish status per derivative across platforms
- Compare performance of derivatives vs source content

### Business Goals
- Maximize content ROI by repurposing across platforms
- Track content reuse ratio (derivatives/source)
- Ensure consistent messaging across platform-specific variants
- Reduce content production time with AI-powered derivation

### Entry Points
- Sidebar: Content → "📦 Derivatives"
- Content detail: "📦 Create derivative" button
- AI Studio: "Save as derivative" after AI edit
- Copilot: "Tạo IG Reel từ video TikTok"

### Exit Points
- "✏️ Edit" → platform-specific editor
- "📤 Publish" → Publish Composer (W041)
- "📊 Stats" → Content Analytics (W075)
- Click source → Source content detail

---

## 2. Preconditions / Postconditions

### Preconditions
- User has `idea:read` permission
- At least one published or draft content exists

### Postconditions
- New derivatives link to source content via `derivatives.source_content_id`
- Published derivatives tracked independently for analytics

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 📦 Derivatives                    [Filter: Source ▾] [View: 🌳/📋]  │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Summary Bar ─────────────────────────────────────────────────┐   │
│ │ 📊 12 sources · 34 derivatives · Reuse ratio: 2.8x           │   │
│ │ Published: 28 · Draft: 4 · Processing: 2                     │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Source Group: "5 tips nấu ăn" ───────────────────────────────┐   │
│ │ 📹 Original: TikTok video (60s) · Published 3d ago           │   │
│ │ 👁 24.3K views · 💬 6.8% eng · [📊 Source stats]             │   │
│ │                                                                  │   │
│ │ Derivatives (4):                                                 │   │
│ │ ├── 📹 YouTube Shorts (60s, 9:16)                              │   │
│ │ │   [🟢 Published] · 👁 8.2K views · [📊] [✏️]            │   │
│ │ ├── 📹 Instagram Reel (30s, 9:16)                              │   │
│ │ │   [📋 Draft] · AI-trimmed · [✏️ Edit] [📤 Publish]       │   │
│ │ ├── 📸 Thumbnail set (3 variants, 16:9)                        │   │
│ │ │   [✅ Generated] · Used for YT + Blog                      │   │
│ │ └── 📝 Blog post (AI-written from transcript)                   │   │
│ │     [📋 Draft] · 1,200 words · [✏️ Edit] [📤 Publish]      │   │
│ │                                                                  │   │
│ │ [+ Tạo derivative] [🤖 AI suggest derivatives]                │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Source Group: "Review combo skincare" ────────────────────────┐  │
│ │ 📹 Original: Instagram Reel (45s) · Published 5d ago          │  │
│ │ Derivatives (2): TikTok duet (Published) · Blog (Draft)       │  │
│ │ [+ Tạo derivative]                                              │  │
│ └────────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
DerivativeManagerPage
├── AppShell (shared)
├── PageHeader
│   ├── PageTitle ("📦 Derivatives")
│   ├── SourceFilter
│   └── ViewToggle (Tree 🌳 / List 📋)
├── SummaryBar
│   ├── SourceCount
│   ├── DerivativeCount
│   ├── ReuseRatio (derivatives / sources)
│   └── StatusCounts (Published, Draft, Processing)
├── SourceGroupList
│   └── SourceGroup[]
│       ├── SourceHeader
│       │   ├── ContentThumbnail
│       │   ├── ContentTitle + Type + Duration
│       │   ├── PublishDate + PlatformBadge
│       │   ├── PerformanceSnippet (views, engagement)
│       │   └── SourceStatsButton
│       ├── DerivativeTree
│       │   └── DerivativeItem[]
│       │       ├── TypeIcon (📹/📸/📝)
│       │       ├── PlatformName + Format (duration, aspect ratio)
│       │       ├── StatusBadge (Published / Draft / Processing / Generated)
│       │       ├── PerformanceSnippet (if published)
│       │       └── ActionBar (Edit / Publish / Stats)
│       ├── CreateDerivativeButton ("+ Tạo derivative")
│       └── AISuggestButton ("🤖 AI suggest")
└── CreateDerivativeModal
    ├── SourcePreview
    ├── DerivativeTypeSelector
    │   ├── PlatformResize (TikTok→IG, YT Shorts, etc.)
    │   ├── FormatTransform (Video→Blog, Video→Thumbnails)
    │   └── AIRemix (AI re-edit with different angle)
    ├── PlatformSelector (target platform)
    ├── DurationInput (for video derivatives)
    └── CreateButton ("🤖 Generate" or "✏️ Create manually")
```

---

## 5. Derivative Types

| Type | Source → Target | Method | AI Credits |
|---|---|---|---|
| Platform resize | Video → different aspect ratio | Auto-crop + reframe | 5 |
| Trim/cut | Long video → short clip | AI-selected best segment | 8 |
| Transcript → Blog | Video → blog post | AI transcription + formatting | 10 |
| Thumbnail extraction | Video → image(s) | AI selects best frames | 3 |
| Audio extract | Video → podcast clip | Audio separation | 2 |
| AI Remix | Video → new angle/style | Full AI re-edit | 25 |
| Manual | Any → any | User creates manually | 0 |

---

## 6. User Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Create derivative | "+ Tạo" → modal | `DerivativeService/Create` | Processing → derivative generated | `idea:create` |
| 2 | AI suggest | "🤖 AI suggest" | `AIService/SuggestDerivatives(source_id)` | List of recommended derivatives | `idea:create` |
| 3 | Edit | "✏️" | — | → platform-specific editor | `script:edit` |
| 4 | Publish | "📤" | — | → Publish Composer (W041) | `publish:execute` |
| 5 | View stats | "📊" | — | → Content Analytics (W075) | `report:read` |
| 6 | Delete | ⋮ → "Delete" → confirm | `DerivativeService/Delete` | Derivative removed (source unaffected) | `script:delete` |
| 7 | Toggle view | Tree/List toggle | Client-side | View switches | Any |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Source group skeletons |
| LOADED | Data received | Tree view with derivatives |
| EMPTY | No content or derivatives | "Chưa có derivatives. Tạo content gốc trước, sau đó repurpose cho các nền tảng khác. [→ Tạo content]" |
| PROCESSING | Derivative being generated | Progress bar on item: "🤖 Đang tạo IG Reel... 65%" |
| GENERATION_FAILED | AI generation failed | Error on item with retry |
| ERROR | API failed | Error with retry |

---

## 8. Permissions

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer |
|---|---|---|---|---|---|---|
| View derivatives | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Create derivatives | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Edit derivatives | ✅ | ✅ | ✅ | ✅ | Own only | ❌ |
| Publish | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Delete | ✅ | ✅ | ✅ | Own only | ❌ | ❌ |

---

## 9. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/derivatives/+page.svelte`
- **Server load**: `+page.server.ts` → fetch source groups with derivatives
- **SSR**: Server renders first 10 source groups (collapsed)
- **SSE**: `/events/derivatives` for processing progress and status changes
- **AI generation**: `DerivativeService/Create(source_id, type)` → SSE progress events
- **View mode**: localStorage ('derivative_view_mode') — tree 🌳 or list 📋

### Data Fetching Strategy
```
+page.server.ts:
  derivativeService.listGrouped({ sort, filter, page, limit: 10 })

Client-side:
  onCreate(source_id, type) → derivativeService.create(source_id, type)
  onAISuggest(source_id) → aiService.suggestDerivatives(source_id)
  onDelete(derivative_id) → derivativeService.delete(derivative_id)
```

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `derivatives.viewed` | Page load | `source_count`, `derivative_count`, `reuse_ratio` |
| `derivatives.created` | Create derivative | `source_id`, `type`, `method` ('ai'/'manual'), `ai_credits` |
| `derivatives.ai_suggested` | AI suggest clicked | `source_id`, `suggestions_count` |
| `derivatives.published` | Publish derivative | `derivative_id`, `platform` |
| `derivatives.deleted` | Delete confirmed | `derivative_id`, `type` |
| `derivatives.stats_viewed` | View stats | `derivative_id` |
| `derivatives.generation_completed` | AI generation done | `derivative_id`, `type`, `duration` |

---

## 11. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 1.5s (first source group) |
| TTI | < 2.0s |
| AI generation | Progress updates every 5s via SSE |
| Tree expand | < 300ms |
| Search response | < 300ms |
| Create modal open | < 200ms |

---

## 12. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến — hiển thị dữ liệu cached" | Auto-retry online |
| API error (5xx) | Server failure | Error banner: "Không tải được derivatives. [Thử lại]" | Retry button |
| Generation failed | AI error | Item error: "🤖 Tạo thất bại. [Thử lại] [Tạo thủ công]" | Retry or manual |
| Insufficient credits | Not enough AI credits | Modal: "Không đủ credit AI. Cần {n} credit. [Mua thêm →]" | Purchase credits |
| Source deleted | Source content removed | "(Nội dung gốc đã xóa)" — derivatives remain functional | — |
| Export limit | Too many derivatives | Toast: "Giới hạn {limit} derivatives/nguồn. [Nâng cấp →]" | Upgrade plan |
| Concurrent generation | Same source being processed | Toast: "Đang tạo derivative khác. Vui lòng chờ." | Wait |

---

## 13. Accessibility

| Element | Requirement |
|---|---|
| Source groups | `role="group"`, `aria-label="Nguồn: {title}, {n} derivatives"` |
| Tree view | `role="tree"`, `role="treeitem"` for each derivative |
| Status badges | Color + icon + text (never color-only) |
| Processing items | `aria-live="polite"`, `aria-label="Đang tạo {type}... {percent}%"` |
| Expand/collapse | `aria-expanded` on group header |
| View toggle | `aria-label="Chuyển kiểu xem: cây / danh sách"` |

---

## 14. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | App Shell + summary bar shimmer + group skeletons |
| Summary stats | 200ms | Counters animate in |
| Source groups | 300-500ms | Groups populate with stagger |
| Derivative items | 400-600ms | Tree items expand with slide-down |
| Processing items | Real-time | Progress bar animation |

---

## 15. Localization Notes

- Primary language: Vietnamese
- Reuse ratio: "Tỷ lệ tái sử dụng: 2.8x"
- Types: "Thu nhỏ" (Resize), "Cắt ghép" (Trim), "Bản sao" (Transcript→Blog), "AI Remix"
- Processing: "🤖 Đang tạo IG Reel... 65%"
- Credits: "Cần 8 credit AI"
- Status: "Đã xuất bản", "Nháp", "Đang xử lý", "Đã tạo"
- Relative time: "3 ngày trước"

---

## 16. Design Tokens

| Token | Usage |
|---|---|
| `--color-derivative-published` | Published status (🟢 green) |
| `--color-derivative-draft` | Draft status (📋 amber) |
| `--color-derivative-processing` | Processing status (🤖 blue, pulsing) |
| `--color-derivative-generated` | Generated status (✅ teal) |
| `--color-derivative-failed` | Failed generation (🔴 red) |
| `--color-accent` | Primary CTAs (Create, AI Suggest) |
| `--color-surface-elevated` | Source group cards |
| `--color-tree-connector` | Tree branch lines |

---

## 17. Related Screens

| Screen | Relationship |
|---|---|
| [W019] Content Continuity | Brand consistency for derivatives |
| [W052] Publish Composer | Publish derivatives |
| [W075] Analytics Overview | Performance comparison |
| [W021] Studio Launcher | AI-powered derivative creation |
| [W022] Quick Edit | Edit video derivatives |
| [S011] Upsell Banner | Credit/tier limit upsell |

---

## 18. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: Fixed section numbering. Added SvelteKit implementation (SSE processing, AI generation), 7 analytics events, 6 performance KPIs, 7 error scenarios (credits, concurrent), accessibility for tree view, 5-stage loading, derivative-specific localization, 8 design tokens incl. tree connector color. Removed generic boilerplate. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
