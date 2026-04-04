# Screen: Web — Analytics Overview

> **Screen ID**: W075
> **Module**: M17 — Analytics & Reporting
> **Route**: `/analytics`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §28-29, A1 Schema (ClickHouse: content_performance, audience_demographics)

---

## 1. Purpose & Context

The Analytics Overview is the reporting hub — aggregated metrics across all platforms with drill-down capability. Shows content performance, audience growth, engagement trends, and top-performing content with AI-powered insights.

### User Story
> As a creator, I want to understand my overall performance across all platforms with clear trends and actionable insights.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 📊 Analytics                    [Period: 30 ngày ▾] [Platform ▾]   │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Key Metrics Bar ──────────────────────────────────────────────┐  │
│ │  Total Views     Engagement    Followers     Revenue            │  │
│ │  1.2M (+15%)    7.8% (+0.5)  125K (+2.3K)  45.2M (+12%)      │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ Tabs: [📊 Overview] [🎬 Content] [👥 Audience] [💰 Revenue]       │
│                                                                      │
│ ── Overview Tab ──                                                   │
│ ┌─ Performance Trend (Line Chart) ───────────────────────────────┐  │
│ │ [Views / Engagement / Followers — 30 days with platform split] │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Top Content (30d) ────────────┐  ┌─ AI Insights ─────────────┐ │
│ │ 1. "5 tips nấu ăn" 🎵 TikTok │  │ 🤖 "Content về skincare  │ │
│ │    24K views · 12% eng         │  │  đang outperform food.   │ │
│ │ 2. "Serum review" 📸 IG       │  │  Đề xuất: tăng tỷ lệ    │ │
│ │    8.5K reach · 8% eng         │  │  skincare lên 60%."      │ │
│ │ 3. "Haul tháng 3" 📺 YT      │  │                           │ │
│ │    3.2K views · 15% eng        │  │ "Posting vào 19:00-21:00│ │
│ │ [→ Xem thêm]                  │  │  cho views cao nhất."    │ │
│ └────────────────────────────────┘  └───────────────────────────┘ │
│                                                                      │
│ ┌─ Platform Comparison ──────────────────────────────────────────┐  │
│ │ Platform  │ Views    │ Eng%  │ Followers │ Posts │ Growth      │  │
│ │ TikTok   │ 850K    │ 8.2% │ 125K      │ 45   │ +15% 🟢    │  │
│ │ Instagram│ 280K    │ 5.1% │ 45K       │ 30   │ +8% 🟢     │  │
│ │ YouTube  │ 70K     │ 15%  │ 12K       │ 8    │ +3% 🟡     │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Best Posting Times (Heatmap) ─────────────────────────────────┐  │
│ │ [7×24 heatmap: day of week × hour → engagement density]       │  │
│ └────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
AnalyticsOverviewPage
├── AppShell (shared)
├── PageHeader
│   ├── Title
│   ├── PeriodSelector (7d/30d/90d/year/custom)
│   └── PlatformFilter (all/specific)
├── KeyMetricsBar
│   └── MetricCard[] (Views, Engagement, Followers, Revenue)
│       ├── Value (animated)
│       ├── TrendIndicator
│       └── SparklineMini
├── TabContainer
│   ├── OverviewTab
│   │   ├── PerformanceTrendChart (multi-line, toggleable metrics)
│   │   ├── TopContentList (top 10 performing content)
│   │   │   └── ContentRow[] (thumbnail, title, platform, metrics)
│   │   ├── AIInsightsCard
│   │   │   ├── InsightList (markdown bullets)
│   │   │   └── RegenerateButton
│   │   ├── PlatformComparisonTable
│   │   │   └── PlatformRow[] (all metrics per platform)
│   │   └── BestPostingHeatmap
│   │       ├── Heatmap (7×24 grid)
│   │       └── Legend
│   ├── ContentTab (→ content-specific analytics)
│   ├── AudienceTab (→ audience demographics)
│   └── RevenueTab (→ revenue analytics)
```

---

## 4-5. Data & Actions

| UI Element | Source | API |
|---|---|---|
| Total views | `ClickHouse: SUM(views)` | `AnalyticsService/GetOverview(period, platform)` |
| Engagement | `ClickHouse: AVG(engagement_rate)` | same |
| Followers | `connector_snapshots.followers` (latest) | same |
| Revenue | `revenue_entries SUM` | same |
| Trend data | `ClickHouse: daily aggregation` | `AnalyticsService/GetTimeSeries(metric, period)` |
| Top content | `content_performance ORDER BY views DESC LIMIT 10` | same |
| AI insights | `CopilotService/Query(mode=analytics_insight)` | On-demand |
| Heatmap | `content_performance GROUP BY day_of_week, hour` | same |

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Change period | Period selector | Refetch | All data updates | `report:read` |
| 2 | Filter platform | Platform dropdown | Refetch | Filtered view | `report:read` |
| 3 | View content detail | Click content in top list | — | → `/analytics/content/[id]` | `report:read` |
| 4 | Switch tab | Click tab | — | Tab content loads | `report:read` |
| 5 | Regenerate insights | Refresh on AI card | `CopilotService/Query` | New insights | `copilot:use_analytics` |
| 6 | Export | ⋮ → "Export PDF" | Client-side | Report PDF | `report:read` |

---

## 6. Edge Cases

| Edge Case | Handling |
|---|---|
| No platform connectors | Full-screen CTA: "Kết nối nền tảng để xem analytics. [Kết nối ngay →]" |
| Only 1 platform connected | Platform comparison section hidden, single-platform layout |
| Revenue tab + no finance:read | Tab hidden entirely (not disabled) |
| Stale data (>6h since sync) | Yellow banner: "⚠️ Dữ liệu cũ {time}. [Kiểm tra kết nối]" |
| No posts in selected period | "Không có bài đăng trong giai đoạn này. [Thử 90 ngày]" |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached dashboard | Auto-retry online |
| ClickHouse timeout | Query > 10s | Banner: "Dữ liệu đang tải chậm. [Thử lại]" | Retry with shorter period |
| Chart render fail | SVG error | Chart area: "Không hiển thị được. [Thử lại]" + fallback table | Retry |
| AI insight fail | CopilotService error | Card: "🤖 Phân tích không khả dụng. [Thử lại]" | Retry |
| Export fail | PDF/CSV generation error | Toast: "Không xuất được. [Thử lại]" | Retry |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| KPI metric cards | `role="region"`, `aria-label="Tổng lượt xem: {value}, tăng {delta}%"` |
| Performance trend chart | `role="img"`, `aria-label="Biểu đồ xu hướng {metric} qua {period}"` + data table fallback |
| Heatmap | `aria-label="Biểu đồ nhiệt: thời gian đăng tốt nhất. {summary}"` |
| Platform comparison table | `role="table"`, sortable columns with `aria-sort` |
| Tab container | `role="tablist"`, tabs as `role="tab"` with `aria-selected` |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Page header + KPI card skeletons |
| KPI cards | 100-400ms | Numbers animate from 0 → value (counter animation) |
| Trend chart | 300-800ms | Line draws left→right (1s animation) |
| Top content | 400-800ms | Rows stagger in (50ms per row) |
| Heatmap | 600-1200ms | Cells fade in with intensity |
| AI insights | 1-3s | Text fades in (lazy, low priority) |

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `analytics_overview.viewed` | Page load | `period`, `platform_filter`, `source` |
| `analytics_overview.period_changed` | Period selector | `from_period`, `to_period` |
| `analytics_overview.platform_filtered` | Platform dropdown | `platform` |
| `analytics_overview.tab_changed` | Tab click | `tab_name` |
| `analytics_overview.content_clicked` | Top content row | `content_id`, `rank` |
| `analytics_overview.ai_regenerated` | AI refresh | — |
| `analytics_overview.exported` | Export | `format` (CSV/PDF) |
| `analytics_overview.heatmap_interacted` | Heatmap hover | `day`, `hour`, `engagement_level` |

---

## 11. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/analytics/+page.svelte`
- **Server load**: `+page.server.ts` → `AnalyticsService/GetOverview(period, platform)` via ClickHouse
- **Charts**: `layerchart` (SvelteKit-native) for trend chart + heatmap
- **KPI animation**: Svelte `tweened` stores for counter animation
- **URL params**: `?period=30d&platform=all` — shareable, bookmarkable
- **AI insights**: `CopilotService/Query(mode=analytics_insight)` — lazy loaded
- **Export**: Client-side PDF via `pdf-lib` (charts rendered as SVG)
- **Data pipeline**: All queries hit ClickHouse (not Postgres) — pre-aggregated

---

## 12. Localization Notes

- Metrics: "Tổng lượt xem", "Tỷ lệ tương tác", "Người theo dõi", "Doanh thu"
- Period: "7 ngày", "30 ngày", "90 ngày", "Năm", "Tùy chỉnh"
- Growth: "+15%", "↑2.3K"
- Heatmap legend: "Nóng", "Ấm", "Lạnh"
- AI: Vietnamese with English technical terms

---

## 13. Design Tokens

| Token | Usage |
|---|---|
| `--color-chart-primary` | Main chart line |
| `--color-chart-comparison` | Previous period dashed line |
| `--color-heatmap-hot` | High-engagement cells |
| `--color-heatmap-warm` | Medium-engagement cells |
| `--color-heatmap-cold` | Low-engagement cells |
| `--color-delta-positive` | ↑ green growth |
| `--color-delta-negative` | ↓ red decline |
| `--color-surface-ai` | AI insights card bg |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Section cards |

---

## 14. Related Screens

| Screen | Relationship |
|---|---|
| [W076] Analytics Detail | Per-platform drill-down |
| [W078] Post Detail Analytics | Per-post deep-dive |
| [W077] Performance Metrics | AI coaching |
| [W079] Gamification | Engagement mechanics |
| [M035] Mobile Analytics | Mobile equivalent |

---

## 15. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 edge cases (no connectors, stale data), 5 errors (ClickHouse, chart), chart/heatmap a11y, 8 analytics, SvelteKit impl (ClickHouse, layerchart), 10 design tokens. | System |
| 2026-03-27 | 1.0 | Initial specification | System |
