# Screen: Web — Trend Detail

> **Screen ID**: W10
> **Module**: M02 — Trend Radar
> **Route**: `/intelligence/trends/[id]`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §10/§11, A1 Schema (trends, trend_snapshots, watchlists)

---

## 1. Purpose & Context

Deep-dive into a single trend — showing its trajectory over time, related content, top-performing examples, audience overlap scores, and one-click conversion to ideas/scripts. This is the "intelligence brief" for a trend.

### User Story
> As a creator who found an interesting trend, I want to see its full data — growth curve, related hashtags, top creator examples, and audience fit — so I can decide if it's worth pursuing.

### Entry Points
- Trend Radar: click trend card
- Home Dashboard: AI Pulse trend link
- Watchlist: trend item click
- Direct URL: `/intelligence/trends/[id]`

### Exit Points
- "💡 Tạo ý tưởng" → `/ideas/new?trend_id=[id]`
- "📝 Viết script" → `/scripts/new?trend_id=[id]`
- "🔄 Remix video" → `/studio/remix?url=[top_video_url]`
- Related trend → `/intelligence/trends/[related_id]`
- "← Quay lại" → `/intelligence/trends`

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Xu hướng   "AI cooking assistant"          ⭐ 92/100  [⋮]       │
├──────────────────────────────────┬───────────────────────────────────┤
│ Main (65%)                       │ Side Panel (35%)                   │
│                                  │                                    │
│ ┌─ Trend Chart ──────────────┐  │ ┌─ Quick Info ──────────────────┐│
│ │ [Line chart: score over    │  │ │ Platform: 🎵 TikTok            ││
│ │  30 days, with volume bars]│  │ │ Category: Food & Cooking       ││
│ │ [Toggle: 7d | 14d | 30d]  │  │ │ First seen: 15/03/2026        ││
│ │                            │  │ │ Growth: +340% (7d)            ││
│ └────────────────────────────┘  │ │ Volume: 1.2M total views      ││
│                                  │ │ Hashtags: #ai_cooking          ││
│ Tabs: [Overview] [Examples] [Audience] [Related]│ │ #airecipes #foodtech ││
│                                  │ │ Source: 🟢 Official            ││
│ ── Overview Tab ──               │ │ Confidence: High              ││
│ ┌─ AI Analysis ──────────────┐  │ └──────────────────────────────┘ │
│ │ 🤖 Phân tích AI:            │  │                                    │
│ │ "Xu hướng AI cooking đang   │  │ ┌─ Actions ─────────────────────┐│
│ │  tăng mạnh trên TikTok.     │  │ │ [💡 Tạo ý tưởng]              ││
│ │  Nội dung mẹo nấu ăn nhanh │  │ │ [📝 Viết script]             ││
│ │  với AI sẽ phù hợp với      │  │ │ [🔄 Remix top video]          ││
│ │  đối tượng 18-35 tuổi.      │  │ │ [📌 Thêm watchlist]           ││
│ │  Đề xuất: tạo 'AI recipe   │  │ │ [📤 Chia sẻ cho team]        ││
│ │  challenge' series."        │  │ └────────────────────────────────┘│
│ └────────────────────────────┘  │                                    │
│                                  │ ┌─ Audience Fit ───────────────┐ │
│ ┌─ Key Metrics Grid ────────┐  │ │ Match score: 78% 🟢           │ │
│ │ Posts  │ Avg Views │ Eng   │  │ │ Your audience: 18-25, F, VN  │ │
│ │ 12,300 │ 45K      │ 8.2%  │  │ │ Trend audience: 18-35, F     │ │
│ │ ↑15%   │ ↑23%     │ ↑2pp  │  │ │ Overlap: High                │ │
│ └────────────────────────────┘  │ └───────────────────────────────┘ │
│                                  │                                    │
│ ── Examples Tab ──               │ ┌─ Your Related Content ───────┐ │
│ ┌─ Top Performing Videos ────┐  │ │ 🎬 "AI cooking tips" (draft) │ │
│ │ ┌─ Video Card ────────────┐│  │ │ 💡 "Recipe idea" (idea)      │ │
│ │ │ [🎬 Thumb] @creator1    ││  │ └───────────────────────────────┘ │
│ │ │ 2.3M views · 12% eng    ││  │                                    │
│ │ │ [📥 Save ref] [🔄 Remix]││  │                                    │
│ │ └──────────────────────────┘│  │                                    │
│ │ ... more video cards ...    │  │                                    │
│ └────────────────────────────┘  │                                    │
└──────────────────────────────────┴───────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
TrendDetailPage
├── AppShell (shared)
├── PageHeader
│   ├── BackButton
│   ├── TrendTitle
│   ├── StrengthScoreBadge
│   └── MoreMenu (share, export, report)
├── MainPanel (65%)
│   ├── TrendChart
│   │   ├── LineChart (score over time)
│   │   ├── BarOverlay (volume per day)
│   │   └── PeriodToggle (7d/14d/30d)
│   ├── TabContainer
│   │   ├── OverviewTab
│   │   │   ├── AIAnalysisCard
│   │   │   │   ├── AnalysisText (markdown rendered)
│   │   │   │   └── RegenerateButton
│   │   │   └── KeyMetricsGrid
│   │   │       └── MetricCard[] (post count, avg views, engagement)
│   │   ├── ExamplesTab
│   │   │   └── VideoCardGrid
│   │   │       └── VideoCard[]
│   │   │           ├── Thumbnail
│   │   │           ├── CreatorName
│   │   │           ├── ViewCount
│   │   │           ├── EngagementRate
│   │   │           ├── SaveRefButton
│   │   │           └── RemixButton
│   │   ├── AudienceTab
│   │   │   ├── DemographicChart (age, gender, geography)
│   │   │   └── OverlapAnalysis
│   │   └── RelatedTab
│   │       └── RelatedTrendCard[]
│   │           ├── TrendTitle + Score
│   │           └── CorrelationBadge
└── SidePanel (35%)
    ├── QuickInfoCard
    │   ├── PlatformBadge, Category, FirstSeen
    │   ├── GrowthIndicator, Volume
    │   ├── HashtagChips
    │   ├── SourceBadge, ConfidenceBadge
    ├── ActionsCard
    │   └── ActionButton[] (idea, script, remix, watchlist, share)
    ├── AudienceFitCard
    │   ├── MatchScore (percentage circle)
    │   ├── YourAudienceDesc
    │   ├── TrendAudienceDesc
    │   └── OverlapBadge
    └── RelatedContentCard
        └── ContentLink[] (existing ideas/scripts related to this trend)
```

---

## 4. Data Binding & Display Format

| UI Element | Data Source | API | Display Format |
|---|---|---|---|
| Title | `trends.title` | `TrendService/Get(id)` | H1 text |
| Score | `trends.strength_score` | same | Badge "⭐ 92/100" |
| Chart data | `trend_snapshots` | `TrendService/GetTimeSeries(id, period)` | Line + bar chart |
| AI Analysis | `CopilotService/Query(mode=trend_analysis)` | On-demand | Markdown text |
| Top videos | Platform API (scraped) | `TrendService/GetExamples(id, limit=10)` | Video card grid |
| Audience demographics | `trends.audience_data` (JSON) | same | Donut charts |
| Audience fit | Computed: `cos_similarity(user_audience, trend_audience)` | `TrendService/GetAudienceFit(id)` | Percentage + badge |
| Related trends | `trends WHERE embedding SIMILAR` | `TrendService/ListRelated(id)` | Card list |
| Hashtags | `trends.hashtags` (array) | `TrendService/Get(id)` | Chip list |

---

## 5. Actions Table

| # | Action | Trigger | API Call | UI Result | Permission |
|---|---|---|---|---|---|
| 1 | Create idea | "💡 Tạo ý tưởng" | `IdeaService/Create(from_trend_id)` | Navigate → `/ideas/[new_id]` | `idea:create` |
| 2 | Write script | "📝 Viết script" | — | Navigate → `/scripts/new?trend_id=[id]` | `script:create` |
| 3 | Remix top video | "🔄 Remix" on video card | — | Navigate → `/studio/remix?url=...` | `asset:generate` |
| 4 | Save to watchlist | "📌 Thêm watchlist" | `WatchlistService/AddItem` | Toast + pin fills | `trend:watchlist:manage` |
| 5 | Share with team | "📤 Chia sẻ" | `NotificationService/Send(team)` | Toast "Đã chia sẻ" | Any |
| 6 | Save reference video | "📥 Save ref" on video | `ReferenceService/Save(url)` | Toast "Đã lưu" | `idea:create` |
| 7 | Change chart period | Toggle 7d/14d/30d | `TrendService/GetTimeSeries(id, period)` | Chart re-renders | `trend:read` |
| 8 | Regenerate analysis | Refresh icon on AI card | `CopilotService/Query` | Analysis text updates | `copilot:use_deep` |
| 9 | Navigate related | Click related trend | — | Navigate → `/intelligence/trends/[related_id]` | `trend:read` |
| 10 | Back to list | "← Xu hướng" | — | Navigate → `/intelligence/trends` | `trend:read` |

---

## 6. State Machine

| State | Visual |
|---|---|
| LOADING | Chart skeleton + side panel skeleton |
| LOADED | Full data rendered, chart animates in |
| AI_GENERATING | AI analysis card shows typewriter animation |
| ERROR | "Không tải được xu hướng này. [Thử lại]" |
| NOT_FOUND | "Xu hướng không tồn tại hoặc đã bị xóa" |

---

## 7. Validation Rules

N/A — Read-only display.

---

## 8. Permission Matrix

| Element | Owner | Admin | Manager | Editor | Contributor | Viewer |
|---|---|---|---|---|---|---|
| View trend detail | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Create idea | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Remix video | ✅ | ✅ | ✅ | ✅ | ⚠️ credit check | ❌ |
| Watchlist | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Regenerate AI | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

---

## 9. Edge Cases

| Edge Case | Handling |
|---|---|
| Trend deleted / expired | Full-page: "Xu hướng không tồn tại hoặc đã bị xóa. [← Quay lại]" |
| Chart data gap (missing days) | Interpolated line with dashed segment + tooltip: "Không có dữ liệu" |
| No top videos for this trend | Examples tab: "Chưa có video mẫu. Dữ liệu sẽ được cập nhật." |
| Audience data unavailable | Audience tab: "Dữ liệu khán giả chưa sẵn sàng." (pending scrape) |
| Related trends empty | Related tab: "Không có xu hướng liên quan" |

---

## 10. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached detail | Auto-retry online |
| Trend not found | 404 | Full-page: "Xu hướng không tồn tại. [← Quay lại]" | Back to radar |
| AI analysis fail | CopilotService error | Card: "Phân tích AI không khả dụng. [Thử lại]" | Retry |
| Chart data fail | ClickHouse timeout | Chart placeholder: "Không tải được biểu đồ. [Thử lại]" | Retry |
| Remix unavailable | No credits | Toast: "Cần credits để remix. [Mua thêm]" | Buy credits |

---

## 11. Accessibility

| Element | Requirement |
|---|---|
| Split view | Main `role="main"`, side `role="complementary"` |
| Trend chart | `aria-label="Biểu đồ xu hướng {title} qua {period}"` + data table fallback |
| Tab list | `role="tablist"`, tabs as `role="tab"` with `aria-selected` |
| Tab panels | `role="tabpanel"`, `aria-labelledby="{tab_id}"` |
| Audience match | `aria-label="Phù hợp khán giả: {score}%"` (not color-only) |

---

## 12. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Split-view skeleton |
| Chart | 300-800ms | Line animates drawing left→right |
| AI analysis | 800-2000ms | Typewriter text effect (streamed) |
| Examples tab | 500ms (lazy) | Video cards stagger in |
| Side panel | 200-400ms | Quick info + audience fit populate |

---

## 13. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `trend_detail.viewed` | Page load | `trend_id`, `score`, `platform`, `source` |
| `trend_detail.period_changed` | Period toggle | `from_period`, `to_period` |
| `trend_detail.tab_changed` | Tab click | `tab_name` |
| `trend_detail.idea_created` | "💡 Tạo ý tưởng" | `trend_id`, `score` |
| `trend_detail.remixed` | "🔄 Remix" | `trend_id`, `video_url` |
| `trend_detail.watchlisted` | "📌 Thêm watchlist" | `trend_id`, `watchlist_id` |
| `trend_detail.shared` | "📤 Chia sẻ" | `trend_id` |
| `trend_detail.ai_regenerated` | AI analysis refresh | `trend_id` |

---

## 14. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/intelligence/trends/[id]/+page.svelte`
- **Server load**: `+page.server.ts` → `TrendService/Get(id)` + `TrendService/GetTimeSeries(id, '30d')`
- **Chart**: `layerchart` (SvelteKit-native) — line + bar combo
- **AI analysis**: `CopilotService/Query(mode=trend_analysis, trend_id)` → streamed response
- **Tabs**: Lazy-loaded — Examples/Audience/Related fetch on tab activation
- **SSE**: `/events/trends/[id]` for real-time score updates
- **Video cards**: Thumbnails from `TrendService/GetExamples(id, limit=10)` — lazy-load

---

## 15. Localization Notes

- Score: "⭐ 92/100", "Mức độ mạnh"
- Growth: "+340% (7 ngày)"
- Chart periods: "7 ngày", "14 ngày", "30 ngày"
- Tabs: "Tổng quan", "Video mẫu", "Khán giả", "Liên quan"
- Audience: "Phù hợp: 78%", "Khán giả của bạn", "Khán giả xu hướng"

---

## 16. Design Tokens

| Token | Usage |
|---|---|
| `--color-score-high` | Score ≥ 80 badge (green) |
| `--color-score-medium` | Score 50-79 (amber) |
| `--color-score-low` | Score < 50 (red) |
| `--color-trend-line` | Main trend line stroke |
| `--color-trend-volume` | Volume bar fill |
| `--color-audience-match-high` | Match ≥ 70% (green) |
| `--color-audience-match-low` | Match < 50% (red) |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Cards |

---

## 17. Related Screens

| Screen | Relationship |
|---|---|
| [W009] Trend Radar | Parent list |
| [W011] Watchlist Manager | Save target |
| [W017] Idea Board | Target after idea creation |
| [M015] Mobile Trend Detail | Mobile equivalent |

---

## 18. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 edge cases (deleted trend, data gap), 5 errors, chart/tab a11y, 8 analytics, SvelteKit impl (layerchart, streamed AI), 9 design tokens. | System |
| 2026-03-27 | 1.0 | Initial specification | System |
