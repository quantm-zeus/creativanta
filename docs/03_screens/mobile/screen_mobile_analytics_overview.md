# Screen: Mobile — Analytics Overview

> **Screen ID**: M036
> **Module**: M17 — Analytics & Reporting
> **Route**: `/analytics` (bottom tab: 📊)
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 01 §4, Product Freeze §28-29, A1 Schema (ClickHouse: content_performance, engagement_metrics, follower_snapshots, revenue_daily), B5 RBAC §2.7

---
## 1. Purpose & Context

Mobile Analytics is the quick-check performance dashboard — designed for the "check my stats while waiting for coffee" usage pattern. Shows key metrics in a glanceable 2×2 grid, platform breakdown, top performing content, and AI-generated insights. Optimized for vertical scroll-feed UX with animated counters and interactive sparklines.

### User Goals
- Quickly see today's/week's/month's performance numbers
- Understand which platform is performing best right now
- Discover top-performing content for replication
- Get AI-powered insights on patterns and optimization opportunities
- Share performance snapshots with team or sponsors

### Business Goals
- Drive daily app opens through addictive analytics checking (target: 3+ sessions/day)
- Enable data-driven content strategy through accessible insights
- Support creator monetization conversations with shareable metrics
- Inform AI recommendations with performance feedback loops

### When This Screen Is Used
- Multiple times daily: Quick stat check (morning, post-publish, evening)
- Weekly: Performance review and content planning
- On notification: "📊 Weekly report ready", "🔥 Your post went viral!"
- Before meetings: Quick reference for brand deal / sponsor conversations

### Entry Points
- Bottom nav: 📊 Analytics tab (primary access)
- Home Dashboard (M001): Tap any KPI card
- Push notification: "📊 Báo cáo tuần đã sẵn sàng" → deep link
- AI Copilot (M060): "Cho tôi xem stats" → navigates here
- Share deeplink from web: webapp → "Open in app" → analytics

### Exit Points
- Tap platform row → Platform Detail (M012)
- Tap content → Content Analytics (M013)
- Tap AI insight → expanded insight with action prompts
- "📤 Share" → system share sheet with screenshot
- Tap revenue → Mobile Profit Summary (M034)

---
## 2. Preconditions / Postconditions

### Preconditions
- User has `report:read` permission (Editor+ roles)
- At least one platform connected (otherwise NO_DATA state)
- Analytics materialized views are up-to-date (max 2h lag from ClickHouse)

### Postconditions
- Page view logged for engagement analytics
- Period changes persisted in local storage (remembered on next visit)
- AI insight viewed → tracked for recommendation engine learning

---
## 3. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ 📊 Analytics                          [Period: 30 ngày ▾] [📤 Share]│
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Key Metrics (2×2 Grid) ────────────────────────────────────────┐ │
│ │ ┌─────────────────────┐  ┌─────────────────────┐               │ │
│ │ │ 👁 Lượt xem         │  │ ❤️ Tương tác        │               │ │
│ │ │ 1.2M                │  │ 7.8%                 │               │ │
│ │ │ ↑+15% vs kỳ trước  │  │ ↑+0.5pp vs kỳ trước │               │ │
│ │ │ [sparkline ──/\──] │  │ [sparkline ──/──]   │               │ │
│ │ └─────────────────────┘  └─────────────────────┘               │ │
│ │ ┌─────────────────────┐  ┌─────────────────────┐               │ │
│ │ │ 👤 Followers        │  │ 💰 Doanh thu         │               │ │
│ │ │ 125K                │  │ 45.2M VND            │               │ │
│ │ │ ↑+2.3K (+1.9%)     │  │ ↑+12% vs kỳ trước   │               │ │
│ │ │ [sparkline ──/──]  │  │ [sparkline ──/\──]  │               │ │
│ │ └─────────────────────┘  └─────────────────────┘               │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Views Trend Chart (expandable) ─────────────────────────────────┐│
│ │ [Area chart: Daily views over period, tappable data points]      ││
│ │ ___/\___/\____/\\\___/\___/\_______/\\\\\___/\___               ││
│ │                   ↑ peak: 85K (Thứ 3, TikTok viral)             ││
│ │ Tap point for breakdown · Pinch to zoom                          ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Platform Breakdown ─────────────────────────────────────────────┐│
│ │ 🎵 TikTok    850K views  8.2% eng  ↑+15%  🟢                   ││
│ │              20 posts · Best: Thu 19:00                           ││
│ │ 📸 Instagram 280K views  5.1% eng  ↑+8%   🟢                    ││
│ │              15 posts · Best: Sun 10:00                           ││
│ │ 📺 YouTube   70K views   15.0% eng ↑+3%   🟡                    ││
│ │              4 videos · Best: Sat 14:00                           ││
│ │ [→ Xem chi tiết →]                                               ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Top Content (30d) ──────────────────────────────────────────────┐│
│ │ 🏆 Ranking by engagement rate × views                            ││
│ │                                                                    ││
│ │ 1. [🎬 thumb] "5 tips nấu ăn"      🎵 TikTok                   ││
│ │    24K views · 12.5% eng · ↑trending                              ││
│ │                                                                    ││
│ │ 2. [📸 thumb] "Serum review tháng 3" 📸 IG                      ││
│ │    8.5K views · 8.2% eng                                           ││
│ │                                                                    ││
│ │ 3. [📺 thumb] "Haul tháng 3"        📺 YouTube                   ││
│ │    3.2K views · 15.1% eng                                          ││
│ │                                                                    ││
│ │ [→ Xem tất cả content →]                                          ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ AI Insights ────────────────────────────────────────────────────┐│
│ │ 🤖 Phân tích tự động                                             ││
│ │                                                                    ││
│ │ 💡 "Nội dung skincare outperform food 2x trong 30 ngày qua."    ││
│ │ 📊 "Đăng lúc 19:00 mang lại 1.5x lượt xem hơn đăng sáng."    ││
│ │ 🔥 "Tháng này engagement rate tăng 0.5pp — nhờ video viral."   ││
│ │                                                                    ││
│ │ [🤖 Xem chi tiết phân tích →]                                    ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Weekly Summary Card ────────────────────────────────────────────┐│
│ │ 📋 Tuần 12 (18-24/03/2026)                                       ││
│ │ Posts: 12 · Views: 350K · Followers: +800 · Revenue: 11.2M      ││
│ │ Best day: Thursday (85K views) · Worst: Monday (28K views)       ││
│ │ [📤 Share tuần này] [📊 So sánh vs tuần trước]                    ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊•]                                          │
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
MobileAnalyticsPage
├── AppBar
│   ├── PageTitle ("📊 Analytics")
│   ├── PeriodSelector (dropdown: Today, 7d, 30d, 90d, YTD, Custom)
│   └── ShareButton ("📤" → capture + share)
├── ScrollableContent (pull-to-refresh)
│   ├── MetricsGrid (2×2 layout)
│   │   └── MetricCard[] (4 cards)
│   │       ├── MetricIcon (👁/❤️/👤/💰)
│   │       ├── MetricLabel ("Lượt xem", "Tương tác", "Followers", "Doanh thu")
│   │       ├── MetricValue (animated counter — number + unit)
│   │       ├── TrendIndicator (↑↓→, percentage/absolute, color-coded)
│   │       ├── Sparkline (30-day mini chart, tappable to expand)
│   │       └── TapAction (expand to breakdown bottom sheet)
│   ├── TrendChart (expandable area chart)
│   │   ├── AreaChart (interactive — tap data points)
│   │   ├── PeakAnnotation (highlight peak with label)
│   │   ├── PinchToZoom (gesture support)
│   │   └── DataPointTooltip (on tap — date + value + platform breakdown)
│   ├── PlatformBreakdownSection
│   │   └── PlatformRow[] (tappable → platform detail)
│   │       ├── PlatformIcon (🎵/📸/📺)
│   │       ├── PlatformName
│   │       ├── ViewCount
│   │       ├── EngagementRate
│   │       ├── GrowthTrend (↑/↓, color-coded)
│   │       ├── PostCount ("20 posts")
│   │       └── BestTimeSlot ("Best: Thu 19:00")
│   ├── TopContentSection
│   │   ├── RankingLabel ("🏆 by engagement × views")
│   │   └── ContentRow[] (top 3, tappable → content detail)
│   │       ├── Rank (1-3, medal emoji)
│   │       ├── Thumbnail
│   │       ├── Title
│   │       ├── PlatformBadge
│   │       ├── ViewCount
│   │       ├── EngagementRate
│   │       └── TrendingBadge (optional — "↑trending")
│   ├── AIInsightsCard
│   │   ├── SectionHeader ("🤖 Phân tích tự động")
│   │   ├── InsightItem[] (bullet points with icons)
│   │   │   ├── InsightIcon (💡/📊/🔥/⚠️)
│   │   │   └── InsightText
│   │   └── DetailLink ("🤖 Xem chi tiết →" → Copilot with analytics context)
│   └── WeeklySummaryCard
│       ├── WeekLabel ("Tuần 12")
│       ├── QuickStats (posts, views, followers, revenue)
│       ├── BestWorstDay
│       ├── ShareButton
│       └── CompareButton (vs previous week)
└── BottomNavBar
```

---
## 5. Displayed Data

| Element | Source | API | Display Format | Cache |
|---|---|---|---|---|
| Views total | `SUM(content_performance.views)` | `AnalyticsService/GetOverview(period)` | "1.2M" (abbreviated) | 10m |
| Engagement rate | `SUM(engagements)/SUM(views)×100` | same | "7.8%" | 10m |
| Follower count | Latest `follower_snapshots` | same | "125K" (abbreviated) | 10m |
| Follower growth | Delta from period start | same | "+2.3K (+1.9%)" | 10m |
| Revenue | `SUM(revenue_daily)` | same | "45.2M VND" | 15m |
| Trend vs previous | Same metrics for previous period | same | "↑+15%" (green/red) | 10m |
| Sparklines | Daily aggregates for period | same, in overview response | Mini chart array | 10m |
| Platform breakdown | Grouped by platform | `AnalyticsService/GetPlatformBreakdown(period)` | Platform rows | 10m |
| Best time slot | Peak engagement window per platform | Included in breakdown | "Thu 19:00" | 30m |
| Top content | Top 3 by `engagement_rate × views` | `AnalyticsService/GetTopContent(period, limit=3)` | Content cards | 10m |
| AI insights | `CopilotService/AnalyticsInsights(period)` | Pre-computed daily | Bullet points | 1h |
| Weekly summary | Aggregated for current/previous week | `AnalyticsService/GetWeeklySummary()` | Card | 1h |

---
## 6. User Actions

| # | Action | Trigger | Type | API Call | System Response | Permission |
|---|---|---|---|---|---|---|
| 1 | Change period | Period dropdown | Filter | Refetch with new period | All sections animate to new data | `report:read` |
| 2 | Expand metric | Tap metric card | Expand | — | Bottom sheet: daily breakdown by platform | `report:read` |
| 3 | Tap chart point | Tap on trend chart | Detail | — | Tooltip: date, value, platform breakdown for that day | `report:read` |
| 4 | Pinch zoom chart | Pinch gesture on chart | Zoom | — | Chart zooms into date range | `report:read` |
| 5 | View platform detail | Tap platform row | Navigate | — | Push → M012 Platform Detail | `report:read` |
| 6 | View content detail | Tap content row | Navigate | — | Push → Content Analytics | `report:read` |
| 7 | View AI insights | Tap "🤖 Xem chi tiết →" | Navigate | — | Push → Copilot with analytics context injected | `report:read` |
| 8 | Share report | "📤 Share" | Share | — | Capture dashboard screenshot → system share sheet | `report:read` |
| 9 | Share weekly | "📤 Share tuần này" in weekly card | Share | — | Formatted weekly summary → share sheet | `report:read` |
| 10 | Compare weeks | "📊 So sánh vs tuần trước" | Expand | — | Side-by-side comparison bottom sheet | `report:read` |
| 11 | Pull refresh | Pull-down gesture | Refresh | Refetch all | Data updates with haptic light | `report:read` |

---
## 7. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial page load | Metric card + chart skeletons (shimmer) | Wait |
| LOADED | All data received | Full dashboard with animated counters (numbers count up) | Normal interactions |
| NO_DATA | No platforms connected | Illustration + "📊 Chưa có dữ liệu. Đăng bài trên các nền tảng để xem analytics! [Kết nối nền tảng →]" | Connect platforms |
| PARTIAL_STALE | Some data is stale (>2h old) | Banner: "⚠️ Dữ liệu TikTok cũ 6h — đang cập nhật..." | Wait or refresh |
| REFRESHING | Pull-to-refresh in progress | Refresh indicator at top | Wait |
| PERIOD_CHANGING | Period selector changed | Metrics shimmer briefly → animate to new values | Wait |
| ERROR | API failed | "Không tải được analytics. [Thử lại]" with retry button | Retry |
| OFFLINE | No network | Banner: "📡 Ngoại tuyến — hiển thị dữ liệu cached" with cached data shown | Read cached |

---
## 8. Permissions & Role-based Behavior

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View analytics | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| View revenue | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Share report | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| AI insights | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

### Visibility Rules
- **Editor**: Revenue metric card hidden. Shows 3 metrics (2×1.5 grid) instead of 2×2.
- **Contributor/Viewer/External**: Analytics tab hidden from bottom nav. No access.

---
## 9. Mobile-specific UX

### Gestures & Haptics
- **Pull-to-refresh**: Standard refresh indicator with haptic light on trigger
- **Tap metric card**: Expand to breakdown bottom sheet. Haptic light.
- **Tap chart data point**: Tooltip appears. Haptic light.
- **Pinch zoom chart**: Zoom into date range. Standard gesture.
- **Long press content row**: Quick share that content's metrics. Haptic light.
- **Swap between metrics**: Horizontal swipe on metric grid for additional metrics (if enabled)

### Animated Counters
- Numbers count up from 0 to final value on page load (600ms duration)
- Use `AnimatedCount` widget with easing curve
- Respect `prefers-reduced-motion` — show final number immediately

### Dark Mode
- Full dark mode support
- Charts use semi-transparent colors on dark backgrounds
- Sparklines: thin lines with contrasting colors

### Offline Behavior
- Last fetched data cached (all metrics + chart data + top content)
- AI insights cached for 24h
- Period changes disabled offline (show currently cached period only)
- "📤 Share" works offline (captures cached view)

---
## 10. Edge Cases

| Edge Case | Handling |
|---|---|
| 0 views for period | Show "0" with "—" for trend. "Đăng bài để bắt đầu tracking!" |
| Engagement > 100% (viral share count) | Cap display at 99.9% with "🔥 Viral" badge |
| Platform disconnected mid-period | Show available data with note: "⚠️ TikTok disconnected on Mar 15" |
| Revenue metric with no commerce | Hide revenue card entirely. Show 3-metric grid instead. |
| Very high numbers (>1B views) | Display as "1.2B" with full number in tooltip |
| AI insights service unavailable | Show cached insights or "🤖 AI insights đang cập nhật..." placeholder |
| First week (< 7 days data) | Show available data, trend shows "N/A" instead of percentage |
| Negative growth | Red text: "↓-15%" with down arrow |

---
## 11. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `analytics.overview.viewed` | Page opens | `period`, `platform_count`, `total_views` |
| `analytics.period.changed` | Period dropdown | `old_period`, `new_period` |
| `analytics.metric.tapped` | Tap metric card | `metric_type` (views/engagement/followers/revenue) |
| `analytics.chart.interacted` | Tap data point | `date`, `value`, `interaction_type` (tap/pinch) |
| `analytics.platform.tapped` | Tap platform row | `platform` |
| `analytics.content.tapped` | Tap content row | `content_id`, `rank`, `platform` |
| `analytics.insight.viewed` | View AI insight detail | `insight_count` |
| `analytics.shared` | Share button | `share_type` (full/weekly), `period` |
| `analytics.pulled_refresh` | Pull to refresh | — |

---
## 12. Performance Requirements

| Metric | Target |
|---|---|
| Cold open to interactive | < 1.5s (metrics visible) |
| Animated counters | Complete within 600ms |
| Chart render | < 500ms |
| Pull-to-refresh | < 2s |
| Period change | < 1s |
| Share screenshot | < 1s |
| Scroll performance | 60fps |
| Offline cache load | < 300ms |

---
## 13. Flutter Implementation Notes

### Widget Structure
- **Route**: `/analytics` → `AnalyticsOverviewPage`
- **State management**: Riverpod `analyticsOverviewProvider(period)` + `topContentProvider(period)`
- **Charts**: `fl_chart` package (high-performance, customizable)
- **Animated numbers**: Custom `AnimatedCount` widget with `Tween<num>`
- **Pull-to-refresh**: `RefreshIndicator` widget
- **Period persistence**: `SharedPreferences` for last selected period

### Data Fetching Strategy
```
onInit:
  period = sharedPrefs.get('analytics_period') ?? '30d'
  Promise.all([
    analyticsService.getOverview(period),      // metrics + sparklines
    analyticsService.getPlatformBreakdown(period), // platform rows
    analyticsService.getTopContent(period, 3), // top 3 content
    copilotService.getAnalyticsInsights(period), // AI insights
    analyticsService.getWeeklySummary(),        // weekly card
  ])

onPeriodChange(newPeriod):
  sharedPrefs.set('analytics_period', newPeriod)
  // Refetch all data with new period
```

### Share Implementation
```dart
onShare():
  final screenshot = await screenshotController.capture()
  final tempPath = '${tempDir}/analytics_${period}.png'
  await File(tempPath).writeAsBytes(screenshot)
  Share.shareXFiles([XFile(tempPath)], text: 'Analytics report for $period')
```

---
## 14. Navigation Map

```
Mobile Analytics (/analytics)
├── → /analytics/platform/[id] (tap platform row → Platform Detail)
├── → /analytics/content/[id] (tap content row → Content Analytics)
├── → /copilot (tap AI insights detail → Copilot with analytics context)
├── → /finance (tap revenue card → Mobile Profit Summary)
├── → /settings/platforms (via "Kết nối nền tảng →" in NO_DATA state)
```

---
## 15. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network error | No connectivity | Banner: "📡 Ngoại tuyến — hiển thị dữ liệu cached" | Pull-to-refresh when online |
| API error (5xx) | Server failure | Toast: "Không tải được analytics. [Thử lại]" | Retry button |
| Partial stale data | ClickHouse lag > 2h | Banner: "⚠️ Dữ liệu [Platform] cũ {n}h — đang cập nhật..." | Auto-refresh on completion |
| Platform disconnected | Token expired mid-fetch | Platform row shows "⚠️ Ngắt kết nối. [Kết nối lại →]" | Re-auth flow |
| AI insights unavailable | Copilot timeout | Card shows "🤖 AI insights đang cập nhật..." with cached insights | Auto-retry |
| Share failed | System share error | Toast: "Không chia sẻ được. Thử lại." | Retry |

---
## 16. Accessibility

| Element | Requirement |
|---|---|
| Metric cards | `Semantics(label: "Lượt xem: 1 triệu 2 trăm nghìn, tăng 15 phần trăm so với kỳ trước")` |
| Sparklines | `Semantics(label: "Biểu đồ xu hướng lượt xem 30 ngày, đang tăng")` |
| Trend chart | Tappable data points with `Semantics(value:)` for each point |
| Platform rows | `Semantics(label: "TikTok, 850 nghìn lượt xem, tương tác 8 phẩy 2 phần trăm, tăng 15 phần trăm")` |
| Content ranking | `Semantics(label: "Hạng 1: 5 tips nấu ăn, TikTok, 24 nghìn lượt xem")` |
| Period selector | Accessible dropdown with clear labels |
| Color charts | Not color-only — include values as text labels |
| Animated counters | `prefers-reduced-motion` → show final number immediately without animation |

---
## 17. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | App bar + period selector visible |
| Metric skeletons | 0-200ms | 4 metric card shimmer |
| Metrics populate | 200-600ms | Animated counters (numbers count up 600ms) |
| Trend chart | 300-800ms | Chart skeleton → area chart draws left-to-right |
| Platform rows | 400-800ms | Skeleton → platform data populates staggered |
| Top content | 500-1000ms | Content cards fade in |
| AI insights | 1-3s | "🤖 Đang phân tích..." → insights populate |

---
## 18. Real-time Updates

| Data | Channel | Frequency |
|---|---|---|
| Views/engagement | Polling | Every 10 minutes |
| Revenue | Polling | Every 15 minutes |
| Follower count | Polling | Every 30 minutes |
| AI insights | Background refresh | Daily generated, cached 24h |
| Weekly summary | Background | Updated weekly |

---
## 19. Localization Notes

- Primary language: Vietnamese
- Numbers abbreviated: "1.2M", "45.2K", "125K"
- Full format in tooltips/breakdowns: "1.200.000"
- Currency: VND (no decimals, dot separator: "45.200.000₫")
- Percentages: "7.8%", trend: "↑+15%", "↓-3%"
- Percentage points: "+0.5pp"
- Date: DD/MM/YYYY
- Period labels: "7 ngày", "30 ngày", "90 ngày", "Năm nay", "Tuỳ chỉnh"
- Day names: "Thứ 2" through "Chủ nhật"

---
## 20. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | Active tab, period selector highlight, trend chart accent |
| `--color-success` | Positive growth (↑), good engagement |
| `--color-danger` | Negative growth (↓), declining metrics |
| `--color-warning` | Stale data banner |
| `--color-surface-elevated` | Metric cards, platform rows, content cards |
| `--font-metric` | Large metric numbers (tabular-nums) |
| `--color-chart-tiktok` | TikTok-specific chart color |
| `--color-chart-instagram` | Instagram-specific chart color |
| `--color-chart-youtube` | YouTube-specific chart color |

---
## 21. Related Screens

| Screen | Relationship |
|---|---|
| [W075] Web Analytics Overview | Web equivalent (full table + advanced charts) |
| [W076] Analytics Detail | Platform-specific analytics drill-down (web) |
| [M037] Post Analytics | Content-specific metrics |
| [M041] Mobile Finance Summary | Revenue deep-dive |
| [M060] Mobile Copilot | AI insights context |
| [M001] Mobile Home Dashboard | KPI cards link here |

---
## 22. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 3.0 | **Structure fix**: Removed duplicate template sections (§6/§8/§9/§11/§12/§13/§15/§16/§18). Added detailed Error Handling (6 scenarios), comprehensive Accessibility with semantic labels, progressive Loading timeline, Real-time update strategy, expanded Localization with number formatting rules, Design Tokens with per-platform chart colors. Renumbered to 22-point structure. | System |
| 2026-03-28 | 2.0 | Full Tier A rewrite. Added interactive trend chart, platform breakdown, weekly summary, AI insights, 11 actions, 8 states, mobile UX, Flutter implementation. | System |
| 2026-03-27 | 1.0 | Initial specification | System |

