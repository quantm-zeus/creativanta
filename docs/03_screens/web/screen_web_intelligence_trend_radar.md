# Screen: Web — Trend Radar

> **Screen ID**: W038
> **Module**: M02 — Trend Radar
> **Route**: `/intelligence/trends`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §10/§11, A1 Schema (trends, trend_snapshots, watchlists, watchlist_items), B4 Connectors, B5 RBAC §2.3

---

## 1. Purpose & Context

The Trend Radar is the intelligence engine's primary discovery interface — a real-time "content weather map" showing what's trending across connected platforms (TikTok, YouTube, Shopee, Google Trends, Instagram). The screen combines AI-powered scoring, multi-axis filtering, sparkline visualizations, and one-click conversion to actionable content ideas. Every trend card carries source provenance badges so creators know exactly how trustworthy the signal is.

### User Story
> As a creator watching multiple platforms, I want to discover what's trending in my niche right now — with confidence scores so I know which signals are strong — and instantly convert promising trends into content ideas before the window closes.

### Business Goals
- Accelerate content-market fit (trend → content in minutes, not days)
- Drive AI Studio adoption via "Remix video" action (trend → AI video → publish)
- Increase platform engagement time (daily trend scanning habit loop)
- Differentiate from competitors with source provenance transparency
- Drive subscription retention (trends are a Pro+ feature)

### When This Screen Is Used
- **Morning scan**: Creator checks "what's hot today" before planning content
- **Content drought**: Looking for inspiration and data-backed ideas
- **Niche monitoring**: Filtering by category to track specific verticals
- **Competitive response**: Spotting trends competitors are riding
- **Campaign planning**: Finding trends to tie seasonal campaigns to

### Entry Points
- Sidebar: "🔥 Xu hướng" under Intelligence section
- Home Dashboard ([W001]): AI Pulse widget "Xem →" links
- Morning Brief ([W003]): "🔥 3 xu hướng mới hôm nay" → filtered to today
- Copilot: "Xu hướng mới trên TikTok" → navigate here with platform filter
- Notification: "🔥 New high-score trend detected" → deep link
- Direct URL: `/intelligence/trends` or `/intelligence/trends?platform=tiktok&period=7d`

### Exit Points
- Click trend card → `/intelligence/trends/[id]` (Trend Detail W010)
- "💡 Tạo ý tưởng" → `/ideas/new?from_trend_id=[id]` (Idea pre-filled)
- "🔄 Remix video" → `/studio/remix?url=[trend_video_url]` (AI Studio)
- "📌 Lưu watchlist" → inline save (stays on page)
- "📊 Cơ hội" → `/intelligence/opportunities` (Opportunity Board)

---

## 2. Preconditions / Postconditions

### Preconditions
- User authenticated with valid session
- User has `trend:read` permission
- At least one platform connector is active (trends require platform data)
- Workspace has Trend Radar feature enabled (Pro+ tier)

### Postconditions
- View event logged for analytics
- Watchlist additions persisted to `watchlist_items` table
- Idea creation from trend links `ideas.from_trend_id` for attribution
- Filter state persisted in URL params (shareable, bookmarkable)
- View mode (Grid/List) persisted in `localStorage`

---

## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell + Filter bar + 3-column card grid |
| Tablet (768-1279px) | App Shell (collapsed) + Filter bar + 2-column card grid |
| Mobile (≤767px) | Redirect to Mobile Trend List (M014) |

### ASCII Wireframe (Grid View)
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 🔥 Xu hướng (128)        [📊 Cơ hội] [View: ▦ Grid | ☰ List]     │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Quick Summary Bar ──────────────────────────────────────────────┐│
│ │ 🔥 128 trends · 🆕 12 mới hôm nay · ⚡ Top: "AI cooking" (92) ││
│ │ Platforms: 🎵 TikTok (54) · 📺 YouTube (32) · 📸 IG (28) · ... ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Filter Bar ──────────────────────────────────────────────────────┐│
│ │ Nền tảng: [Tất cả ▾] Thời gian: [7 ngày ▾] Lĩnh vực: [Tất cả ▾]││
│ │ Min score: [▾ Tất cả] Nguồn: [▾ Tất cả] Watchlist: [▾]       ││
│ │ Sort: [Score cao nhất ▾]                          🔍 Tìm kiếm   ││
│ │ Active: [🎵 TikTok ✕] [Score ≥ 70 ✕]             [Xóa tất cả] ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Trend Card ─────────────┐ ┌─ Trend Card ─────────────┐ ┌─ ... ─┐│
│ │ 🔥 "AI cooking assistant" │ │ 🔥 "Minimalist skincare  │ │       ││
│ │                   ⭐ 92  │ │  for acne"        ⭐ 78  │ │       ││
│ │                           │ │                           │ │       ││
│ │ 🎵 TikTok · +340% (7d)  │ │ 📸 IG · +180% (3d)      │ │       ││
│ │ 1.2M total views          │ │ 450K reach                │ │       ││
│ │ Lĩnh vực: Food & Cooking│ │ Lĩnh vực: Beauty         │ │       ││
│ │                           │ │                           │ │       ││
│ │ [📈 Sparkline: 7d chart] │ │ [📈 Sparkline: 7d chart] │ │       ││
│ │                           │ │                           │ │       ││
│ │ Source: 🟢 Official       │ │ Source: 🟢 Official       │ │       ││
│ │ Confidence: 🟢 High      │ │ Confidence: 🟡 Medium     │ │       ││
│ │ Freshness: 2h ago        │ │ Freshness: 5h ago         │ │       ││
│ │                           │ │                           │ │       ││
│ │ 🆕 NEW                   │ │                           │ │       ││
│ │                           │ │                           │ │       ││
│ │ [💡 Ý tưởng] [🔄 Remix] │ │ [💡 Ý tưởng] [🔄 Remix] │ │       ││
│ │ [📌 Watchlist] [→ Detail]│ │ [📌 Watchlist] [→ Detail]│ │       ││
│ └───────────────────────────┘ └───────────────────────────┘ └───────┘│
│                                                                      │
│ ┌─ Trend Card ─────────────┐ ┌─ Trend Card ─────────────┐          │
│ │ 🔥 "Vitamin C routine"   │ │ 🔥 "Budget meal prep"    │          │
│ │                   ⭐ 71  │ │                   ⭐ 45  │          │
│ │ ...                       │ │ ...                       │          │
│ └───────────────────────────┘ └───────────────────────────┘          │
│                                                                      │
│ [Tải thêm ↓] (cursor-based, 18 per page)                           │
│                                                                      │
│ 🤖 AI: "3 xu hướng mới trong lĩnh vực Food tuần này. Score trung   │
│        bình cao hơn 15% so với tuần trước."                         │
└──────────────────────────────────────────────────────────────────────┘
```

### ASCII Wireframe (List View)
```
┌─ Trend Table ────────────────────────────────────────────────────────┐
│ Title              │ Score │ Platform │ Growth │ Volume   │ Category │ Actions     │
│ ───────────────────┼───────┼──────────┼────────┼──────────┼──────────┼─────────────│
│ AI cooking assist. │ ⭐ 92 │ 🎵 TT   │ +340%  │ 1.2M    │ Food     │ 💡 🔄 📌 → │
│ Minimalist skin.   │ ⭐ 78 │ 📸 IG   │ +180%  │ 450K    │ Beauty   │ 💡 🔄 📌 → │
│ Vitamin C routine  │ ⭐ 71 │ 📺 YT   │ +120%  │ 890K    │ Beauty   │ 💡 🔄 📌 → │
│ Budget meal prep   │ ⭐ 45 │ 🎵 TT   │ +50%   │ 123K    │ Food     │ 💡 🔄 📌 → │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
TrendRadarPage
├── AppShell (shared)
│   ├── Sidebar
│   └── TopBar
├── PageHeader
│   ├── Title ("🔥 Xu hướng" + count badge "(128)")
│   ├── OpportunityLink ("📊 Cơ hội" → /intelligence/opportunities)
│   └── ViewToggle (▦ Grid | ☰ List)
├── QuickSummaryBar
│   ├── TotalTrends ("🔥 128 trends")
│   ├── NewTodayCount ("🆕 12 mới hôm nay")
│   ├── TopTrend ("⚡ Top: 'AI cooking' (92)")
│   └── PlatformBreakdown ("🎵 TikTok (54) · 📺 YouTube (32)...")
├── FilterBar
│   ├── PlatformFilter (multi-select: TikTok, YouTube, IG, Shopee, Google Trends)
│   ├── PeriodFilter (dropdown: 24h / 3d / 7d / 14d / 30d / 90d)
│   ├── CategoryFilter (multi-select: Food, Beauty, Tech, Lifestyle, etc.)
│   ├── MinScoreFilter (dropdown: Tất cả / ≥90 / ≥70 / ≥50 / <50)
│   ├── SourceFilter (dropdown: Official / Imported / Estimated)
│   ├── WatchlistFilter (dropdown: filter by specific watchlist)
│   ├── SortSelector (Score cao nhất / Mới nhất / Growth cao nhất / Volume cao nhất)
│   ├── SearchInput ("🔍 Tìm kiếm" — full-text with 300ms debounce)
│   └── ActiveFilterChips (removable: "[🎵 TikTok ✕]")
├── TrendGrid (when Grid view active — 3 columns on desktop)
│   └── TrendCard[]
│       ├── TrendTitle ("🔥 AI cooking assistant" — max 2 lines)
│       ├── StrengthScoreBadge
│       │   ├── ScoreNumber ("92")
│       │   └── ScoreColor (🟢 ≥80 / 🟡 50-79 / 🔴 <50)
│       ├── PlatformInfo
│       │   ├── PlatformIcon (🎵/📺/📸/🛍/📊)
│       │   └── PlatformName
│       ├── GrowthIndicator ("+340% (7d)" with ↑ arrow)
│       ├── VolumeMetric ("1.2M total views")
│       ├── CategoryChip ("Food & Cooking")
│       ├── SparklineChart (7-day inline SVG, 80×24px, animate draw)
│       ├── TrustBadges
│       │   ├── SourceBadge ("🟢 Official" / "🔵 Imported" / "🟡 Estimated")
│       │   ├── ConfidenceBadge ("🟢 High" / "🟡 Medium" / "🔴 Low")
│       │   └── FreshnessBadge ("2h ago" — relative time since last sync)
│       ├── NewBadge (conditional — "🆕 NEW" for trends < 24h old)
│       ├── WatchlistIndicator (📌 filled if in any watchlist)
│       └── ActionBar
│           ├── CreateIdeaButton ("💡 Ý tưởng")
│           ├── RemixButton ("🔄 Remix")
│           ├── SaveWatchlistButton ("📌 Watchlist" → dropdown: select watchlist)
│           └── ViewDetailLink ("→")
├── TrendTable (when List view active)
│   ├── TableHeader (sortable: Title, Score, Platform, Growth, Volume, Category)
│   └── TrendRow[]
│       ├── Title (clickable → detail)
│       ├── ScoreBadge
│       ├── PlatformIcon
│       ├── GrowthPercentage
│       ├── VolumeCompact
│       ├── CategoryChip
│       └── InlineActions (💡 🔄 📌 →)
├── LoadMore (cursor-based, 18 per page, infinite scroll)
├── AIInsightBar
│   └── InsightText ("🤖 AI: 3 xu hướng mới trong lĩnh vực Food tuần này...")
├── WatchlistDropdown (inline popover when clicking 📌)
│   ├── WatchlistOption[] (existing watchlists)
│   ├── Divider
│   └── CreateWatchlistButton ("+ Tạo watchlist mới")
└── EmptyState (when no trends match)
    ├── Illustration
    ├── Message ("Chưa có xu hướng — kết nối nền tảng để bắt đầu khám phá")
    └── ConnectCTA ("Kết nối ngay" → /settings/connectors)
```

---

## 5. Displayed Data / Data Binding

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Trend title | `trends.title` | `TrendService/List(filters, page)` | Bold text, max 2 lines | 10m TTL |
| Strength score | `trends.strength_score` | Same | Number + color badge (🟢/🟡/🔴) | 10m |
| Platform | `trends.source_platform` | Same | Platform icon (SVG) + name | 10m |
| Growth % | Computed: `(current - prev) / prev × 100` | Same | "+340%" with ↑/↓ arrow, colored | 10m |
| Volume | `trends.volume_metric` | Same | Compact: "1.2M views" / "450K reach" | 10m |
| Category | `trends.category` | Same | Chip badge | 10m |
| Sparkline | `trend_snapshots` 7-day aggregation | `TrendService/GetSparklines(ids[])` | Inline SVG line (80×24px) | 30m |
| Source class | `trends.source_class` | Same | Badge: "🟢 Official" / "🔵 Imported" / "🟡 Estimated" | 10m |
| Confidence | `trends.confidence_level` | Same | Badge: "🟢 High" / "🟡 Medium" / "🔴 Low" | 10m |
| Freshness | `trends.synced_at` | Same | Relative: "2h ago", "5m ago" | — (computed) |
| Is new | `trends.first_seen_at > 24h ago` | Same | "🆕 NEW" badge | 10m |
| In watchlist | `watchlist_items WHERE trend_id` | Same (join) | 📌 filled/unfilled | 5m |
| Total count | COUNT aggregate | `TrendService/GetStats(filters)` | "(128)" in header | 10m |
| New today | COUNT where first_seen_at = today | Same | "12 mới hôm nay" | 10m |
| Top trend | MAX(strength_score) | Same | "⚡ Top: '{title}' ({score})" | 10m |
| Platform breakdown | GROUP BY platform | Same | "🎵 TikTok (54) · 📺 YouTube (32)..." | 10m |
| AI insight | `CopilotService/TrendInsight(filters)` | Lazy loaded | Markdown text | 1h |

### Score Color Mapping
| Range | Color | Token | Label |
|---|---|---|---|
| ≥ 80 | Green | `--color-score-high` | Strong signal |
| 50-79 | Amber | `--color-score-medium` | Moderate signal |
| < 50 | Red | `--color-score-low` | Weak signal |

---

## 6. User Actions

| # | Action | Trigger | API Call | System Response | Permission |
|---|---|---|---|---|---|
| 1 | Create idea from trend | "💡 Ý tưởng" | `IdeaService/Create({ from_trend_id, title, platform })` | New idea created. Toast "✅ Ý tưởng đã tạo!" Navigate → `/ideas/[new_id]` | `idea:create` |
| 2 | Remix video | "🔄 Remix" | — | Navigate → `/studio/remix?url={trend_video_url}` | `asset:generate` + credits |
| 3 | Save to watchlist | "📌 Watchlist" → dropdown → select watchlist | `WatchlistService/AddItem(trend_id, watchlist_id)` | Pin icon fills. Toast "📌 Đã lưu vào '{watchlist_name}'" | `trend:watchlist:manage` |
| 4 | Remove from watchlist | Click filled 📌 | `WatchlistService/RemoveItem(trend_id, watchlist_id)` | Pin unfills. Toast "Đã xóa khỏi watchlist" | `trend:watchlist:manage` |
| 5 | Create new watchlist | "📌" dropdown → "+ Tạo watchlist mới" | `WatchlistService/Create(name)` + `AddItem` | Watchlist created, trend added | `trend:watchlist:manage` |
| 6 | View detail | Click card body or "→" | — | Navigate → `/intelligence/trends/[id]` | `trend:read` |
| 7 | Filter by platform | Change platform dropdown | Refetch with `platform=tiktok` | Grid updates. URL params updated. Active chip shown. | `trend:read` |
| 8 | Filter by period | Change period dropdown | Refetch with `period=7d` | Grid + sparklines update | `trend:read` |
| 9 | Filter by category | Change category dropdown | Refetch with `category=food` | Grid updates | `trend:read` |
| 10 | Filter by min score | Change score dropdown | Refetch with `score_min=70` | Grid updates | `trend:read` |
| 11 | Sort | Change sort dropdown | Refetch with `sort=score_desc` | Grid reorders | `trend:read` |
| 12 | Search | Type in search (300ms debounce) | `TrendService/Search(query)` or Meilisearch | Cards filter to matching | `trend:read` |
| 13 | Clear filters | "Xóa tất cả" | Refetch without filters | Full list shown, chips cleared | `trend:read` |
| 14 | Toggle view | Grid ↔ List | — (client-side) | Layout switches. Saved to localStorage. | `trend:read` |
| 15 | Load more | Scroll or "Tải thêm ↓" | `TrendService/List(cursor)` | More cards append with staggered fade | `trend:read` |

---

## 7. States / State Machine

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial page load | Summary bar shimmer + 6 card skeletons in grid layout |
| LOADED | Data received | Cards rendered with data, sparklines animate drawing left→right |
| EMPTY | No trends + no connectors | "Chưa có xu hướng — kết nối nền tảng để bắt đầu khám phá 🔥" + CTA "Kết nối ngay" |
| EMPTY_FILTERED | Filters match nothing | "Không có xu hướng phù hợp với bộ lọc. [Xóa bộ lọc]" |
| EMPTY_CONNECTOR | Connectors exist but no trends yet | "Đang thu thập xu hướng. Dữ liệu sẽ xuất hiện trong vài phút..." |
| SEARCHING | Search in progress | Search spinner. Non-matching cards dimmed. |
| DEGRADED | Some platform data is stale (>6h) | Yellow banner: "⚠️ Dữ liệu {platform} cũ {time}. [Kiểm tra kết nối]" + available data shown |
| ERROR | API failed | "Không thể tải xu hướng. [Thử lại]" |
| TIER_BLOCKED | Workspace on Free tier (no Trend access) | Upsell: "🔥 Trend Radar là tính năng Pro+. [Nâng cấp →]" with blurred preview |

---

## 8. Validation Rules

N/A — Read-only display with filter inputs (no form submission). Watchlist name (if creating new) requires 2-50 chars.

---

## 9. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View trends | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ (read-only) | ❌ |
| Filter/sort | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Create idea from trend | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Remix video from trend | ✅ | ✅ | ✅ | ✅ | ⚠️ credit-limited | ❌ | ❌ |
| Save to watchlist | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Create watchlist | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| View AI insights | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |

---

## 10. Navigation Map

```
Trend Radar (/intelligence/trends)
├── → /intelligence/trends/[id]            (Click card → Trend Detail)
├── → /ideas/new?from_trend_id=[id]        (💡 Tạo ý tưởng → Idea Board)
├── → /studio/remix?url=[url]              (🔄 Remix video → AI Studio)
├── → /intelligence/opportunities          (📊 Cơ hội → Opportunity Board)
├── → /intelligence/watchlist              (Filter by watchlist → Watchlist Manager)
├── → /settings/connectors                 (Empty state "Kết nối ngay")
└── ← Sidebar navigation                   (Intelligence section)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network error | No internet / server down | Full page error: "Không thể tải xu hướng. [Thử lại]" | Retry button |
| Partial platform fail | One platform API fails | Degraded banner: "⚠️ Dữ liệu {platform} cũ {time}. [Kiểm tra kết nối]" + show available data | Link to connector settings |
| Rate limited | 429 response | Toast: "Quá nhiều yêu cầu. Tự động thử lại sau 30 giây." | Auto-retry after 30s |
| Idea creation fails | IdeaService error | Toast: "Không tạo được ý tưởng. [Thử lại]" | Retry (trend data still available) |
| Watchlist add fails | Network error | Toast: "Không lưu được. [Thử lại]" | Retry |
| Search fails | Meilisearch unavailable | Fallback to API search. Toast: "Tìm kiếm nâng cao tạm thời không khả dụng." | Client-side filter |
| Sparkline load fails | ClickHouse timeout | Show placeholder dash in sparkline area | Retry on viewport entry |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Trend cards | `role="article"`, `aria-label="Xu hướng: {title}, điểm {score}, nền tảng {platform}, tăng {growth}%"` |
| Score badge | Color + number (not color alone). `aria-label="Strength score: {score} out of 100, {level}"` |
| Growth indicator | `aria-label="Growth: positive {n} percent over {period}"` |
| Sparkline | `aria-hidden="true"` (decorative — score and growth provide data textually) |
| Filter dropdowns | `aria-label="Lọc theo {filter_type}"`, `aria-expanded` |
| Search input | `role="searchbox"`, `aria-label="Tìm kiếm xu hướng"` |
| Source/confidence badges | `aria-label="Data source: Official"`, `aria-label="Confidence: High"` |
| Watchlist button | `aria-label="Lưu vào watchlist"` / `aria-pressed="true"` (when saved) |
| View toggle | `role="radiogroup"`, `aria-label="View mode"` |
| Load more | `aria-label="Tải thêm xu hướng"` |
| Keyboard | Tab: card → card. Enter: open detail. `Shift+Tab`: reverse. `/`: focus search. |
| Color contrast | WCAG 2.1 AA (4.5:1) for all text |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Shell render | 0ms | App Shell (SSR). Page header + filter bar visible. |
| Summary bar | 100-300ms | Stats populate with counter animation |
| Card skeletons | 0-100ms | 6 card skeletons with shimmer |
| Cards populate | 300-800ms | Cards fade in with staggered animation (50ms per card) |
| Sparklines | 500-1200ms | Sparklines animate drawing left→right (200ms per chart) |
| AI insight | 800-2000ms | AI text fades in at bottom (lazy — low priority) |

---

## 14. Performance Requirements

| Metric | Target | Measurement |
|---|---|---|
| LCP | < 2.0s | First trend card with score and platform visible |
| FID | < 100ms | Click on filter or action button |
| CLS | < 0.05 | No shift when sparklines load (fixed placeholder dimensions) |
| TTI | < 2.5s | All actions interactive |
| Sparkline rendering | < 100ms per chart | SVG — not canvas. No chart library overhead. |
| Filter change | < 500ms | Server response + DOM update |
| Search response | < 200ms | Meilisearch instant results |
| Items per page | 18 | Cursor-based for efficient pagination |

---

## 15. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| New trends detected | SSE `/events/trends` | Real-time — new card slides into grid with "🆕 NEW" badge + green glow (3s) |
| Score changes | SSE `/events/trends` | Real-time — score badge transitions (number morphs) |
| Platform sync | SSE `/events/sync` | After sync: new trends appear, stale data refreshes |
| Summary stats | Derived from SSE events | Real-time on new trend: total count / today count increments |

### Real-time UX
- **New trend appears**: Card slides in at the appropriate position (sorted). Brief green border glow. "🆕 NEW" badge.
- **Score update**: Score number morphs from old → new with color transition if range changed.
- **Team activity**: If team member saves to watchlist, 📌 fills silently (no notification).

---

## 16. Localization Notes

- Primary language: Vietnamese
- Trend titles: Original language (many English titles from international trends) — no auto-translate
- Category names: Vietnamese ("Ẩm thực", "Làm đẹp", "Công nghệ", "Lối sống")
- Numbers: Vietnamese format ("1.200.000 lượt xem") but compact ("1.2M") preferred
- Percentages: "+340%" (universal)
- Dates: Relative ("2 giờ trước", "5 phút trước")
- Source class: English ("Official", "Imported", "Estimated") — industry standard
- Tone: Discovery-oriented, exciting — "🔥 Xu hướng mới!" "Khám phá cơ hội!"

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `trends.viewed` | Page load | `total_count`, `platform_filter`, `period`, `category_filter`, `view_mode`, `source` |
| `trends.card.clicked` | Click trend card | `trend_id`, `score`, `platform`, `position`, `is_new` |
| `trends.idea.created` | "💡 Ý tưởng" clicked | `trend_id`, `score`, `platform`, `category` |
| `trends.remix.started` | "🔄 Remix" clicked | `trend_id`, `score`, `platform` |
| `trends.watchlist.saved` | "📌" clicked to save | `trend_id`, `watchlist_id`, `watchlist_name` |
| `trends.watchlist.removed` | "📌" clicked to unsave | `trend_id`, `watchlist_id` |
| `trends.filter.applied` | Filter change | `filter_type`, `filter_value`, `result_count` |
| `trends.search.used` | Search query submitted | `query_length`, `result_count` |
| `trends.view.toggled` | Grid ↔ List switch | `from_view`, `to_view` |
| `trends.sort.changed` | Sort order changed | `sort_field`, `sort_direction` |
| `trends.load_more` | More items loaded | `page_number`, `items_loaded` |
| `trends.ai_insight.viewed` | AI insight scrolled into view | `insight_type`, `category` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | CTA buttons, "📊 Cơ hội" link |
| `--color-score-high` | Score ≥ 80 badge (green) |
| `--color-score-medium` | Score 50-79 badge (amber) |
| `--color-score-low` | Score < 50 badge (red) |
| `--color-growth-positive` | "+340%" growth text (green) |
| `--color-growth-negative` | "-15%" (rare but possible) text (red) |
| `--color-source-official` | S009 "🟢 Official" badge |
| `--color-source-imported` | S009 "🔵 Imported" badge |
| `--color-source-estimated` | S009 "🟡 Estimated" badge |
| `--color-confidence-high` | "🟢 High" confidence badge |
| `--color-confidence-medium` | "🟡 Medium" confidence badge |
| `--color-confidence-low` | "🔴 Low" confidence badge |
| `--color-platform-tiktok` | TikTok brand accent |
| `--color-platform-youtube` | YouTube brand red |
| `--color-platform-instagram` | Instagram gradient accent |
| `--color-surface-primary` | Page background |
| `--color-surface-elevated` | Trend cards, filter bar, summary bar |
| `--color-text-primary` | Trend titles |
| `--color-text-secondary` | Volume, freshness, category |
| `--color-border` | Card borders |
| `--color-sparkline` | Sparkline stroke color (matches score color) |
| `--shadow-card` | Card elevation |
| `--radius-card` | Card border-radius (12px) |

---

## 19. Technical Implementation Notes

### SvelteKit Specifics
- **Route**: `src/routes/(app)/intelligence/trends/+page.svelte`
- **Server load**: `+page.server.ts` → `TrendService/List` with SSR
- **URL params**: `?platform=tiktok&period=7d&category=food&score_min=70&sort=score_desc&q=cooking`

### Data Fetching Strategy
```
+page.server.ts:
  const [trends, stats] = await Promise.all([
    trendService.list({
      platform: url.searchParams.get('platform'),
      period: url.searchParams.get('period') || '7d',
      category: url.searchParams.get('category'),
      scoreMin: url.searchParams.get('score_min'),
      sort: url.searchParams.get('sort') || 'score_desc',
      q: url.searchParams.get('q'),
      limit: 18
    }),
    trendService.getStats(filters)
  ])

  // Sparklines: batch fetch for visible trend IDs
  const sparklines = await trendService.getSparklines(trends.map(t => t.id))
```

### Sparkline Component
```svelte
<!-- SparklineChart.svelte — lightweight SVG, no chart library -->
<svg viewBox="0 0 80 24" class="sparkline" aria-hidden="true">
  <polyline
    fill="none"
    stroke={scoreColor}
    stroke-width="1.5"
    points={dataPoints.map((v, i) => `${i * (80/6)},${24 - (v/max * 24)}`).join(' ')}
  />
</svg>
```

### Real-time Setup
```
onMount(() => {
  const eventSource = new EventSource('/api/events/trends')
  eventSource.addEventListener('new_trend', (e) => {
    const trend = JSON.parse(e.data)
    trends = insertSorted(trends, trend, currentSort)
    stats.total += 1
    if (isToday(trend.first_seen_at)) stats.new_today += 1
  })
  eventSource.addEventListener('score_update', (e) => {
    const { trend_id, new_score } = JSON.parse(e.data)
    trends = trends.map(t => t.id === trend_id ? { ...t, strength_score: new_score } : t)
  })
})
```

---

## 20. Related Screens

| Screen | Relationship |
|---|---|
| [W039] Trend Detail | Full trend analysis + related content |
| [W042] Watchlist | Manage watchlists |
| [W043] Opportunity Board | Opportunity scoring from trends |
| [W012] Idea Board | Ideas created from trends land here |
| [W001] Home Dashboard | AI Pulse links to trending topics |
| [W009] Morning Brief | Daily trend summary |
| [M017] Mobile Trend List | Mobile equivalent |
| [S009] Trust Badge | Source/confidence badges |

---

## 21. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Full Tier A rewrite**: Upgraded from 309-line Tier B with generic boilerplate to 540+ line full spec. Added: quick summary bar with platform breakdown, detailed filter bar with active chips, watchlist inline dropdown, AI insight bar, score/source/confidence color mapping, sparkline SVG component spec, real-time SSE for new trends/score updates, TIER_BLOCKED state for free users, 12 analytics events, per-platform brand color tokens, list view table layout, search with Meilisearch fallback. Removed all generic boilerplate. Standardized Screen ID from W09 to W038. | System |
| 2026-03-27 | 1.0 | Initial specification (Tier B) | System |
