# Screen: Web — Analytics Detail Report

> **Screen ID**: W110
> **Module**: M17 — Analytics
> **Route**: `/analytics/[platform]`
> **Platform**: Web (SvelteKit)
> **Upstream**: Product Freeze §26, A1 Schema (analytics_snapshots, engagement_snapshots, published_posts), B5 RBAC §2.17

---

## 1. Purpose & Context

The Analytics Detail Report provides deep per-platform analytics with engagement trends, audience demographics, content performance ranking, best posting times, and AI-generated strategic recommendations. This is the drill-down from the Analytics Overview — where a creator goes to understand one specific platform's performance in depth and extract actionable insights for content strategy.

### User Story
> As a creator with 45K TikTok followers, I want to see which content types drive the most engagement, when my audience is most active, and what demographic shifts are happening — so I can optimize my content strategy for that specific platform.

### Business Goals
- Enable data-driven content strategy (reduce guessing, increase hit rate)
- Drive content creation by surfacing what works (top-performing content patterns)
- Increase platform-specific optimization (best times, formats, lengths)
- Support AI insight adoption (automated recommendations)
- Enable period comparison for measuring strategy effectiveness

### When This Screen Is Used
- **Weekly analytics review**: Deep-dive into each platform's performance
- **Content strategy planning**: Understanding what types of content perform best
- **Audience analysis**: Understanding demographic shifts and growth patterns
- **Performance debugging**: Why did engagement drop this week?
- **Reporting**: Exporting data for team/brand partner reports

### Entry Points
- Analytics Overview ([W109]): Click on platform card → this detail page
- Morning Brief ([W003]): "📊 Analytics" CTA → platform-specific
- Channel Posts ([W044]): "📊 Analytics" on individual post → post analytics
- Sidebar: Analytics → Platform sub-menu
- Direct URL: `/analytics/tiktok` or `/analytics/instagram` etc.

### Exit Points
- "← Analytics" → `/analytics` (Overview)
- Click post in ranking → `/analytics/posts/[post_id]` (Post Analytics Detail W075)
- "📤 Export" → Download CSV/PDF
- "📅 Compare" → Same page with comparison mode
- "Full AI Analysis →" → `/analytics/ai-insights` (AI Insights Hub)
- "Show all posts →" → `/publish/posts?platform=tiktok&sort=views` (Channel Posts filtered)

---

## 2. Preconditions / Postconditions

### Preconditions
- User authenticated with valid session
- User has `analytics:read` permission
- Platform connector configured and active for requested platform
- At least 7 days of analytics data synced (otherwise: insufficient data state)

### Postconditions
- Page view logged for analytics
- Export generates downloadable file (CSV or PDF)
- AI insights marked as "viewed" (for recommendation freshness)
- Period selection persisted to `localStorage`

---

## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell + Single-column scrollable dashboard (max-width: 1024px) |
| Tablet (768-1279px) | App Shell (collapsed sidebar) + Full-width dashboard |
| Mobile (≤767px) | Redirect to Mobile Analytics (M011) |

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Analytics   📊 TikTok Analytics     [Period: 30 ngày ▾] [Compare]│
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Platform KPIs ────────────────────────────────────────────────┐  │
│ │ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────┐│  │
│ │ │ 👥        │ │ 👁        │ │ 💬        │ │ 📈        │ │ 🔗  ││  │
│ │ │ Followers │ │ Views    │ │ Engage   │ │ Profile  │ │ Link ││  │
│ │ │ 45.2K     │ │ 890K     │ │ 8.2%     │ │ 12.4K    │ │ 3.2K ││  │
│ │ │ +2.1K ↑   │ │ +12% ↑  │ │ +0.3% ↑  │ │ +18% ↑   │ │ -5% ↓││  │
│ │ └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────┘│  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Growth Chart ─────────────────────────────────────────────────┐  │
│ │ Tabs: [👥 Followers] [👁 Views] [💬 Engagement] [📈 Profile] │  │
│ │                                                                 │  │
│ │   45K ┤                                          ╱──           │  │
│ │   44K ┤                              ╱──────────╱              │  │
│ │   43K ┤              ╱──────────────╱                          │  │
│ │   42K ┤ ────────────╱                                          │  │
│ │       └─────┬─────┬─────┬─────┬─────┬─────┬─────              │  │
│ │           Week1  Week2  Week3  Week4                            │  │
│ │                                                                 │  │
│ │   [Comparison line: previous period — dashed grey]              │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Top Performing Content ───────────────────────────────────────┐  │
│ │ Sort: [Views ▾] · Period: 30 ngày                               │  │
│ │                                                                 │  │
│ │ # │ [Thumb] │ Title                │ Views   │ ER    │ Comments│  │
│ │ ──┼─────────┼──────────────────────┼─────────┼───────┼─────────│  │
│ │ 1 │ [🎬]   │ 5 tips skincare      │ 120K    │ 12.0% │ 450     │  │
│ │ 2 │ [🎬]   │ Serum review         │ 85K     │ 9.5%  │ 280     │  │
│ │ 3 │ [🎬]   │ Morning routine      │ 62K     │ 8.1%  │ 190     │  │
│ │ 4 │ [🎬]   │ Budget meal prep     │ 45K     │ 7.3%  │ 120     │  │
│ │ 5 │ [🎬]   │ Study vlog           │ 38K     │ 6.2%  │ 95      │  │
│ │                                                                 │  │
│ │ [Show all posts →]                                              │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Content Type Performance ─────────────────────────────────────┐  │
│ │ ┌──────────────────────────────┐                               │  │
│ │ │ Horizontal bar chart:        │                               │  │
│ │ │ Skincare tips  ████████ 12% ER                               │  │
│ │ │ Cooking          ██████ 8.2% ER                              │  │
│ │ │ Product review    ████ 6.5% ER                               │  │
│ │ │ Vlogs              ██ 3.2% ER                                │  │
│ │ │ Study               █ 2.1% ER                                │  │
│ │ └──────────────────────────────┘                               │  │
│ │ 🤖 "Skincare tips thể loại tốt nhất — 3× hơn vlogs"          │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Best Posting Times ───────────────────────────────────────────┐  │
│ │ ┌───────────────────────────────────────┐                      │  │
│ │ │ Heatmap: Day of week × Hour of day   │                      │  │
│ │ │                                       │                      │  │
│ │ │     06  09  12  15  18  21  24       │                      │  │
│ │ │ Mon  ·   ·   ·   ·   ██  ██  ·      │                      │  │
│ │ │ Tue  ·   ·   ·   ·   ██  ███ ·      │                      │  │
│ │ │ Wed  ·   ·   ██  ·   ·   ██  ·      │                      │  │
│ │ │ Thu  ·   ·   ·   ·   ███ ██  ·      │  ███ = Hot           │  │
│ │ │ Fri  ·   ·   ·   ·   ██  ██  ·      │  ██  = Warm          │  │
│ │ │ Sat  ·   ·   ·   ██  ·   ·   ·      │  ·   = Cold          │  │
│ │ │ Sun  ·   ██  ·   ██  ·   ·   ·      │                      │  │
│ │ └───────────────────────────────────────┘                      │  │
│ │ 🤖 "Thứ 5 & 6 lúc 18:00-21:00 là thời gian tốt nhất"        │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Audience Demographics ────────────────────────────────────────┐  │
│ │ ┌─ Age ────────────┐  ┌─ Gender ──────┐  ┌─ Top Cities ─────┐│  │
│ │ │ 18-24: ████ 45%  │  │ ♀ 68% ████   │  │ 1. HCM    35%    ││  │
│ │ │ 25-34: ███ 32%   │  │ ♂ 30% ██     │  │ 2. HN     22%    ││  │
│ │ │ 35-44: █ 15%     │  │ Other 2% ·   │  │ 3. DN     8%     ││  │
│ │ │ 45+:   · 8%      │  │              │  │ 4. CT     5%     ││  │
│ │ └──────────────────┘  └──────────────┘  │ 5. HP     4%     ││  │
│ │                                          └──────────────────┘│  │
│ │ 🤖 "18-24 tăng 5% so với tháng trước — content hút Gen Z"    │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ AI Insights & Recommendations ────────────────────────────────┐  │
│ │ 🤖 AI Analysis (updated 2 giờ trước)                          │  │
│ │                                                                 │  │
│ │ 1. 💡 "Skincare tips perform 3× better than vlogs — shift     │  │
│ │    content mix toward tutorial format."                         │  │
│ │    [Tạo script skincare →]                                     │  │
│ │                                                                 │  │
│ │ 2. ⏰ "Best posting window: 19:00-21:00 Thu & Fri — schedule   │  │
│ │    high-effort content for these slots."                        │  │
│ │    [Open calendar →]                                            │  │
│ │                                                                 │  │
│ │ 3. 📈 "Hook retention 15% above avg — keep opening format.    │  │
│ │    First 3s critical."                                          │  │
│ │                                                                 │  │
│ │ 4. 👥 "Gen Z audience growing (+5%). Consider trending audio   │  │
│ │    and shorter clips (< 30s)."                                  │  │
│ │    [View trending audio →]                                      │  │
│ │                                                                 │  │
│ │ [📊 Xem phân tích AI đầy đủ →]                                │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ [📤 Export CSV] [📄 Export PDF]  [📅 So sánh giai đoạn]           │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
AnalyticsDetailPage
├── AppShell (shared)
│   ├── Sidebar
│   └── TopBar
├── PageHeader
│   ├── BackLink ("← Analytics")
│   ├── PlatformIcon + Title ("📊 TikTok Analytics")
│   ├── PeriodSelector (dropdown: 7d / 30d / 90d / Custom)
│   └── CompareButton ("📅 Compare" → comparison mode)
├── PlatformKPIs
│   └── KPICard[] (5 cards in horizontal row)
│       ├── Icon (👥/👁/💬/📈/🔗)
│       ├── Label ("Followers" / "Views" / etc.)
│       ├── Value ("45.2K")
│       ├── DeltaValue ("+2.1K ↑" with trend arrow)
│       └── DeltaColor (green for positive, red for negative)
├── GrowthChart
│   ├── MetricTabs (Followers / Views / Engagement / Profile visits)
│   ├── LineChart (current period: solid, previous period: dashed grey)
│   ├── TimeAxisLabels (Week1, Week2... or daily)
│   └── TooltipOnHover (exact values for date point)
├── TopContentSection
│   ├── SectionHeader ("Top Performing Content")
│   ├── SortSelector (Views / ER / Comments / Shares)
│   └── ContentRankTable
│       └── ContentRow[]
│           ├── RankNumber (#1, #2...)
│           ├── Thumbnail (48×48)
│           ├── PostTitle (truncated)
│           ├── Views (compact number)
│           ├── EngagementRate ("12.0%")
│           ├── Comments (count)
│           └── ClickTarget → Post Analytics Detail
│   └── ShowAllLink ("Show all posts →")
├── ContentTypePerformance
│   ├── SectionHeader
│   ├── HorizontalBarChart (content type vs avg ER)
│   └── AIInsight ("Skincare tips thể loại tốt nhất")
├── BestPostingTimes
│   ├── SectionHeader
│   ├── Heatmap (7-day × 24-hour, color intensity = engagement)
│   └── AIInsight ("Thứ 5 & 6 lúc 18:00-21:00 tốt nhất")
├── AudienceDemographics
│   ├── SectionHeader
│   ├── AgeDistribution (horizontal bar chart)
│   ├── GenderSplit (pie chart or donut)
│   ├── TopCities (ranked list with percentages)
│   └── AIInsight ("18-24 tăng 5% — content hút Gen Z")
├── AIInsightsSection
│   ├── SectionHeader ("🤖 AI Insights & Recommendations")
│   ├── LastUpdated ("Updated 2 giờ trước")
│   └── InsightCard[]
│       ├── InsightIcon (💡/⏰/📈/👥)
│       ├── InsightText (AI-generated recommendation)
│       └── CTAButton (optional — actionable next step)
├── ExportActions
│   ├── ExportCSVButton ("📤 Export CSV")
│   ├── ExportPDFButton ("📄 Export PDF")
│   └── ComparePeriodsButton ("📅 So sánh giai đoạn")
└── ComparisonOverlay (when Compare mode active)
    ├── DateRangePicker (Period A vs Period B)
    ├── SideBySideKPIs
    └── DeltaHighlights
```

---

## 5. Displayed Data / Data Binding

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Followers count | Platform API → `analytics_snapshots.followers` | `AnalyticsService/GetPlatformKPIs(platform, period)` | Compact: "45.2K" | 1h TTL |
| Views total | `analytics_snapshots.views` aggregated | Same | Compact: "890K" | 1h TTL |
| Engagement rate | Computed: (likes+comments+shares)/views×100 | Same | "8.2%" | 1h TTL |
| Profile visits | Platform API → `analytics_snapshots.profile_visits` | Same | Compact: "12.4K" | 1h TTL |
| Link clicks | Platform API → `analytics_snapshots.link_clicks` | Same | Compact: "3.2K" | 1h TTL |
| KPI deltas | Computed vs previous period | Same | "+2.1K ↑" / "-5% ↓" with color | 1h TTL |
| Growth chart | `analytics_snapshots` daily series | `AnalyticsService/GetGrowthSeries(platform, metric, period)` | Line chart with data points | 1h TTL |
| Top content | `published_posts` joined with `engagement_snapshots` | `AnalyticsService/GetTopContent(platform, period, sort, limit=5)` | Ranked table | 1h TTL |
| Content type performance | AI-categorized posts → aggregated ER by category | `AnalyticsService/GetContentTypeBreakdown(platform, period)` | Horizontal bar chart | 6h TTL |
| Best posting times | `engagement_snapshots` grouped by day×hour | `AnalyticsService/GetBestPostingTimes(platform)` | Heatmap | 24h TTL |
| Age demographics | Platform API → `analytics_snapshots.demographics_age` | `AnalyticsService/GetDemographics(platform)` | Horizontal bar chart | 24h TTL |
| Gender demographics | Platform API → `analytics_snapshots.demographics_gender` | Same | Pie chart | 24h TTL |
| Top cities | Platform API → `analytics_snapshots.demographics_cities` | Same | Ranked list | 24h TTL |
| AI insights | AI-generated from analytics data | `CopilotService/AnalyzeAnalytics(platform, period)` | Recommendation cards | 6h TTL |

---

## 6. User Actions

| # | Action | Trigger | API Call | System Response | Permission |
|---|---|---|---|---|---|
| 1 | Change period | Period dropdown | Refetch all sections with new period | Dashboard updates with loading transition | `analytics:read` |
| 2 | View post detail | Click post in ranking | — | Navigate → `/analytics/posts/[post_id]` | `analytics:read` |
| 3 | Show all posts | Click "Show all posts →" | — | Navigate → `/publish/posts?platform={platform}&sort=views` | `publish:read` |
| 4 | Switch growth metric | Click metric tab on chart | Client-side (chart re-renders) | Chart switches data series | `analytics:read` |
| 5 | Sort top content | Change sort dropdown | Refetch or client-side re-sort | Table re-ordered | `analytics:read` |
| 6 | Export CSV | "📤 Export CSV" | `AnalyticsService/ExportCSV(platform, period)` | CSV file downloads | `analytics:export` |
| 7 | Export PDF | "📄 Export PDF" | `AnalyticsService/ExportPDF(platform, period)` | PDF file downloads | `analytics:export` |
| 8 | Compare periods | "📅 Compare" → date picker | Refetch with comparison period | Side-by-side or overlay mode | `analytics:read` |
| 9 | Act on AI insight | Click CTA on AI insight card | — | Navigate to relevant screen | Varies |
| 10 | View full AI analysis | "Xem phân tích AI đầy đủ →" | — | Navigate → `/analytics/ai-insights` | `analytics:read` |

---

## 7. States / State Machine

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial page load | KPI card skeletons + chart shimmer + table skeletons |
| LOADED | All data available | Full dashboard with charts, tables, insights |
| INSUFFICIENT_DATA | < 7 days of data for platform | "Cần ít nhất 7 ngày dữ liệu. Quay lại sau {n} ngày." |
| AI_GENERATING | AI insights being refreshed | AI section shows: "🤖 Đang phân tích..." with shimmer |
| COMPARISON_MODE | Compare periods active | Dual KPIs, overlay chart, delta highlights |
| EXPORTING | Export in progress | Button shows spinner: "Đang xuất..." |
| PLATFORM_DISCONNECTED | Platform connector not active | Banner: "⚠ {platform} bị ngắt kết nối. Dữ liệu có thể không cập nhật. [Kết nối lại →]" |
| ERROR | API failed | "Không tải được analytics. [Thử lại]" |

---

## 8. Validation Rules

N/A — Read-only screen. Period selector has predefined options.

---

## 9. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View platform analytics | ✅ | ✅ | ✅ | ✅ | ✅ (own posts only) | ✅ | ❌ |
| View demographics | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| View AI insights | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Export CSV/PDF | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Compare periods | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |
| Act on AI insight CTAs | ✅ | ✅ | ✅ | ✅ | Per-action | ❌ | ❌ |

---

## 10. Navigation Map

```
Analytics Detail (/analytics/[platform])
├── → /analytics/posts/[post_id]                    (Click post → detail)
├── → /publish/posts?platform={platform}             (Show all posts)
├── → /analytics/ai-insights                         (Full AI analysis)
├── → /scripts/new                                   (AI insight CTA: create script)
├── → /publish/calendar                              (AI insight CTA: open calendar)
├── → /intelligence/trends/[id]                      (AI insight CTA: trending audio)
└── ← /analytics                                     (Back to overview)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Platform data unavailable | Platform API rate limited or down | Banner: "⚠ Dữ liệu {platform} tạm thời không khả dụng. Hiển thị dữ liệu cache." | Show cached data (up to 24h old) with staleness indicator |
| Demographics unavailable | Platform doesn't expose demographics (e.g., new TikTok accounts < 100 followers) | Section shows: "👥 Cần ≥ 100 followers để xem demographics." | Wait for account growth |
| AI insights generation fails | Copilot service error | AI section: "🤖 Không phân tích được. [Thử lại]" | Retry button |
| Export fails | Large dataset timeout | Toast: "Export thất bại. Thử giảm khoảng thời gian." | Select shorter period |
| Chart rendering error | Data format unexpected | Chart area: "Không hiển thị được biểu đồ. [Thử lại]" | Retry or show fallback table |
| Connector disconnected | OAuth token expired | Banner: "⚠ Kết nối {platform} hết hạn. Dữ liệu cũ nhất: {date}. [Kết nối lại →]" | Reconnect OAuth |
| No data for period | Zero posts in selected period | Per-section empty: "Không có dữ liệu cho giai đoạn này. [Thử 90 ngày]" | Select different period |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| KPI cards | `role="region"`, `aria-label="Followers: 45,200, increased by 2,100"` |
| Charts | `role="img"`, `aria-label` with data summary: "Follower growth chart showing increase from 42,100 to 45,200 over 30 days" |
| Chart tooltips | `aria-live="polite"` — announced on hover |
| Content rank table | `role="table"` with proper `th` headers |
| Heatmap | `aria-label="Best posting times heatmap. Thursday and Friday 18:00-21:00 are optimal."` |
| AI insights | `role="article"`, `aria-label="AI recommendation: {insight_text}"` |
| Export buttons | `aria-label="Export analytics data as CSV for TikTok, 30 day period"` |
| Period selector | `aria-label="Select analytics period"`, associated label |
| Color contrast | All text meets WCAG 2.1 AA (4.5:1 ratio). Data visualizations use patterns in addition to color. |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Shell render | 0ms | App Shell renders (SSR). Platform header visible. |
| KPI cards | 100-400ms | KPI numbers animate from 0 to value (counter animation). Delta arrows blink in. |
| Growth chart | 300-800ms | Chart line draws left-to-right with path animation (1s) |
| Top content table | 400-800ms | Rows appear with staggered slide-in (50ms per row) |
| Content type chart | 500-1000ms | Bars grow horizontally with animation |
| Heatmap | 600-1200ms | Cells fade in with intensity animation |
| Demographics | 700-1200ms | Charts animate in (pie rotates, bars grow) |
| AI insights | 1-3s | Cards slide in. Text may appear word-by-word if streaming. |

---

## 14. Performance Requirements

| Metric | Target | Measurement |
|---|---|---|
| LCP | < 2.5s | KPI cards (most important above-fold) |
| FID | < 100ms | First click on period selector or tab |
| CLS | < 0.1 | Acceptable CLS due to progressive chart loading |
| TTI | < 3.0s | All interactive elements (selectors, tabs, links) |
| Chart render | < 500ms per chart | Each chart SVG renders within 500ms after data |
| Export generation | < 10s for 90-day CSV | Server-side export + download |

---

## 15. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| KPI numbers | Polling | Every 1 hour (platform API sync) |
| AI insights refresh | Manual or cache expiry | Every 6 hours (or on user request) |

### Why Not Real-time
Analytics data is inherently delayed (platform APIs sync every 15-60 min). Real-time updates would create false precision. Instead, show "Last sync: {time}" indicator.

---

## 16. Localization Notes

- Primary language: Vietnamese
- Metric numbers: Compact format (45.2K, 890K) — uses dot for decimal, K/M suffix
- Percentages: "8,2%" (Vietnamese comma decimal) in body text; "8.2%" in charts (international)
- Dates: DD/MM/YYYY format
- Period labels: "7 ngày", "30 ngày", "90 ngày", "Tùy chỉnh"
- City names: Vietnamese (HCM, HN, ĐN, CT, HP)
- AI insights: Vietnamese text with English technical terms ("hook retention", "engagement rate")
- Tone: Data-driven, analytical — not emotional

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `analytics_detail.viewed` | Page load | `platform`, `period`, `source` |
| `analytics_detail.period.changed` | Period selector changed | `old_period`, `new_period` |
| `analytics_detail.chart.tab.changed` | Growth chart tab switched | `metric` (followers/views/engagement/profile) |
| `analytics_detail.content.rank.clicked` | Click post in ranking | `post_id`, `rank`, `views`, `er` |
| `analytics_detail.content.sort.changed` | Sort changed in top content | `sort_by` |
| `analytics_detail.export.csv` | Export CSV clicked | `platform`, `period`, `row_count` |
| `analytics_detail.export.pdf` | Export PDF clicked | `platform`, `period` |
| `analytics_detail.compare.opened` | Compare mode activated | `period_a`, `period_b` |
| `analytics_detail.ai_insight.viewed` | AI insight scrolled into view | `insight_index`, `insight_type` |
| `analytics_detail.ai_insight.cta.clicked` | CTA on AI insight clicked | `insight_type`, `cta_target` |
| `analytics_detail.show_all_posts` | "Show all posts" clicked | `platform`, `sort_by` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | Period selector active, chart accent line, export buttons |
| `--color-success` | Positive deltas (↑), growth indicators |
| `--color-danger` | Negative deltas (↓), decline indicators |
| `--color-surface-primary` | Page background |
| `--color-surface-elevated` | Section cards, KPI cards |
| `--color-text-primary` | Section headers, KPI values |
| `--color-text-secondary` | Labels, axis labels, timestamps |
| `--color-chart-primary` | Main chart line (current period) |
| `--color-chart-comparison` | Comparison chart line (previous period, dashed) |
| `--color-heatmap-hot` | Heatmap high-engagement cells |
| `--color-heatmap-warm` | Heatmap medium-engagement cells |
| `--color-heatmap-cold` | Heatmap low-engagement cells |
| `--color-surface-ai` | AI insights section background tint |
| `--font-metric` | KPI numbers, chart values (tabular-nums, monospace) |
| `--radius-card` | Section card radius (12px) |
| `--shadow-card` | Section card shadow |

---

## 19. Technical Implementation Notes

### SvelteKit Specifics
- **Route**: `src/routes/(app)/analytics/[platform]/+page.svelte`
- **Server load**: `+page.server.ts` → fetch KPIs + growth series + top content
- **Params**: `[platform]` = "tiktok" | "instagram" | "youtube" | "twitter" | "facebook"
- **URL params**: `?period=30d&sort=views&compare=7d`

### Data Fetching Strategy
```
+page.server.ts:
  const platform = params.platform
  const period = url.searchParams.get('period') || '30d'
  
  const [kpis, growthSeries, topContent] = await Promise.all([
    analyticsService.getPlatformKPIs(workspaceId, platform, period),
    analyticsService.getGrowthSeries(workspaceId, platform, 'followers', period),
    analyticsService.getTopContent(workspaceId, platform, period, 'views', 5)
  ])
  
  // Loaded client-side (async, lower priority):
  // - demographics (24h cache, expensive platform API)
  // - AI insights (6h cache, Copilot call)
  // - best posting times (24h cache)
  // - content type breakdown (6h cache)
```

### Chart Library
- **SVG-based** charts (lightweight, SSR-friendly)
- Library: `layerchart` (SvelteKit-native) or custom D3 + Svelte
- Animations: Svelte `tweened` stores for value transitions

### Export
- CSV: Server-side generation → stream download (`Content-Disposition: attachment`)
- PDF: Server-side rendering via Puppeteer/wkhtmltopdf → download link
- Both queued as background jobs for large datasets (>1000 posts)

---

## 20. Related Screens

| Screen | Relationship |
|---|---|
| [W109] Analytics Overview | Parent: all-platform summary |
| [W075] Post Analytics Detail | Child: individual post deep-dive |
| [W044] Channel Posts | Sibling: content list with metrics |
| [W046] Schedule Calendar | Related: AI best time → calendar integration |
| [M011] Mobile Analytics | Mobile equivalent |

---

## 21. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Full Tier A rewrite**: Upgraded from 177-line Tier C with generic boilerplate to 480+ line full spec. Added: complete dashboard component hierarchy, 5 KPI cards with delta tracking, growth chart with metric tabs and comparison mode, top content ranking table with sorting, content type performance bar chart, best posting times heatmap, audience demographics (age/gender/cities), AI insights with CTAs, CSV/PDF export, period comparison mode, 11 analytics events, chart library recommendation. Removed all generic boilerplate. | System |
| 2026-03-28 | 1.0 | Initial specification (Tier C) | System |
