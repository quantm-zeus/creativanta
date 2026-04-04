# Screen: Web — Benchmark View

> **Screen ID**: W041
> **Module**: M03 — Competitive Intelligence
> **Route**: `/intelligence/benchmarks`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §11, A1 Schema (benchmarks, competitor_snapshots)

---

## 1. Purpose & Context

The Benchmark View provides side-by-side comparison of the user's metrics vs tracked competitors. Shows where the user leads or lags across key metrics (followers, engagement, posting frequency, content performance, growth rate).

### User Story
> As a creator, I want to compare my performance against competitors to understand my competitive position and identify areas for improvement.

### Entry Points
- Sidebar: "📊 Benchmark" under Intelligence
- Competitor Registry: "📊 Benchmark" button
- Direct URL: `/intelligence/benchmarks`

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 📊 Benchmark              [Competitors ▾] [Period: 30d ▾]          │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Overall Score Card ───────────────────────────────────────────┐  │
│ │ Bạn đứng #2 trong 5 đối thủ được theo dõi                      │  │
│ │ 🏆 @skincare_queen (#1) — Bạn (#2) — @beauty_guru (#3)       │  │
│ │ Overall Score: 78/100 · ↑+5 so với tháng trước                 │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Metrics Comparison Table ─────────────────────────────────────┐  │
│ │          │ Bạn       │ skincare_queen │ beauty_guru  │ Avg     │  │
│ │──────────┼───────────┼────────────────┼──────────────┼─────────│  │
│ │ Follow   │ 125K      │ 245K 🏆       │ 180K         │ 183K    │  │
│ │ Growth   │ +8% 🟢   │ +12% 🏆       │ +5%          │ +8.3%   │  │
│ │ Eng rate │ 8.2% 🏆  │ 9.5%          │ 5.2%         │ 7.6%    │  │
│ │ Avg view │ 45K       │ 120K 🏆       │ 85K          │ 83K     │  │
│ │ Posts/wk │ 12 🏆     │ 14            │ 8            │ 11.3    │  │
│ │ Revenue* │ Hidden     │ N/A           │ N/A          │ N/A     │  │
│ └────────────────────────────────────────────────────────────────┘  │
│ * Revenue is private and not compared                                │
│                                                                      │
│ ┌─ Radar Chart ──────────────────────────────────────────────────┐  │
│ │                     Followers                                    │  │
│ │                        ●                                         │  │
│ │     Content Quality  ╱ ╲  Growth                                │  │
│ │              ●──────●──────●                                    │  │
│ │     Engagement ╲     ╱  Posting Frequency                       │  │
│ │                  ●──●                                            │  │
│ │              Consistency                                         │  │
│ │ [🔵 Bạn] [🔴 skincare_queen] [🟡 beauty_guru]                 │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ AI Insight ───────────────────────────────────────────────────┐  │
│ │ 🤖 "Bạn dẫn đầu về tương tác nhưng yếu về lượt xem.          │  │
│ │ Đề xuất: Tăng tần suất đăng bài hoặc thử nội dung viral.     │  │
│ │ Đối thủ @skincare_queen đang giảm dần — cơ hội vượt mặt."    │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Trend Comparison (Line Chart) ────────────────────────────────┐  │
│ │ [Engagement Rate over time - 30 days]                           │  │
│ │ ── You ── skincare_queen ── beauty_guru                        │  │
│ └────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
BenchmarkPage
├── AppShell (shared)
├── PageHeader
│   ├── Title
│   ├── CompetitorSelector (multi-select, max 5)
│   └── PeriodSelector (7d/30d/90d)
├── OverallScoreCard
│   ├── RankPosition
│   ├── RankAvatars (podium-style)
│   └── ScoreWithTrend
├── MetricsComparisonTable
│   ├── TableHeader (You + competitors + avg)
│   └── MetricRow[]
│       ├── MetricName
│       ├── ValueCell[] (per entity)
│       ├── LeaderBadge (🏆)
│       └── TrendIndicator (🟢 above avg, 🔴 below)
├── RadarChart
│   ├── ChartCanvas (5-6 axes)
│   ├── DataOverlay[] (one per entity)
│   └── Legend
├── AIInsightCard
│   ├── InsightText (markdown)
│   └── RegenerateButton
└── TrendComparisonChart
    ├── LineChart (multi-series)
    ├── MetricSelector (engagement/followers/views)
    └── Legend
```

---

## 4-5. Data Binding & Actions

| UI Element | Data Source | API |
|---|---|---|
| Your metrics | `ClickHouse: content_performance` | `AnalyticsService/GetBenchmarkData` |
| Competitor metrics | `competitor_snapshots` latest | `BenchmarkService/Compare(competitor_ids, period)` |
| Radar chart | Normalized scores (0-100 per axis) | same |
| AI Insight | `CopilotService/Query(mode=benchmark_analysis)` | On-demand |
| Trend chart | Time-series data | `BenchmarkService/GetTimeSeries(metric, period)` |

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Select competitors | Dropdown | Refetch | Table + charts update | `competitor:manage` |
| 2 | Change period | Period selector | Refetch | All data refreshes | `competitor:manage` |
| 3 | Change trend metric | Metric selector on trend chart | Refetch | Chart updates | `competitor:manage` |
| 4 | Regenerate AI insight | Refresh on AI card | `CopilotService/Query` | New analysis | `copilot:use_analytics` |
| 5 | Export report | ⋮ → "Export PDF" | Client-side | PDF download | `report:read` |

---

## 6. Edge Cases

| Edge Case | Handling |
|---|---|
| No competitors tracked | Full-screen CTA: "Thêm đối thủ để bắt đầu benchmark → [Quản lý đối thủ →]" |
| Only 1 competitor | Table shows 2 columns (Bạn + 1): "Thêm đối thủ để so sánh tốt hơn" |
| Competitor data stale (> 24h) | Yellow badge on column: "⚠️ Dữ liệu cũ {time}" |
| All competitors removed mid-session | Redirect to empty state with CTA |
| Revenue metric curiosity | Row shows "—" with tooltip: "Thu nhập không được so sánh (riêng tư)" |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached table | Auto-retry online |
| Benchmark API fail | Server 5xx | Toast: "Không tải được benchmark. [Thử lại]" | Retry |
| Competitor data unavailable | Scraper fail | Column shows "N/A" with tooltip | Auto-retry next sync |
| AI insight fail | CopilotService error | Card shows: "Phân tích không khả dụng. [Thử lại]" | Retry |
| Export PDF fail | Client-side error | Toast: "Không xuất được PDF. [Thử lại]" | Retry |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| Comparison table | `role="table"`, `aria-label="Bảng so sánh benchmark"` |
| Metric row | `aria-label="{metric}: Bạn {value}, {competitor} {value}"` |
| Leader badge 🏆 | `aria-label="Dẫn đầu"` (not icon-only) |
| Radar chart | `aria-label="Biểu đồ radar so sánh {n} đối thủ"`, with data table fallback |
| Trend chart | `aria-label="Biểu đồ xu hướng {metric} qua {period}"` |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Page header + filter controls |
| Table data | 300-800ms | Table skeleton → populated rows |
| Radar chart | 500-1000ms | SVG draws with animation (500ms) |
| Trend chart | 800-1500ms | Line chart animates after radar |
| AI insight | 1-3s | Typewriter text in card |

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `benchmark.viewed` | Page load | `competitor_count`, `period`, `source` |
| `benchmark.competitor_changed` | Dropdown change | `selected_ids`, `count` |
| `benchmark.period_changed` | Period selector | `from_period`, `to_period` |
| `benchmark.trend_metric_changed` | Chart metric switch | `metric` |
| `benchmark.ai_regenerated` | Refresh AI | — |
| `benchmark.exported` | Export PDF | `competitor_count`, `period` |
| `benchmark.competitor_clicked` | Click competitor name | `competitor_id` |

---

## 11. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/intelligence/benchmarks/+page.svelte`
- **Server load**: `+page.server.ts` → `BenchmarkService/Compare(competitor_ids, period)`
- **Radar chart**: Custom SVG component (`RadarChart.svelte`) — no chart library
- **Comparison table**: Sticky first column + header for horizontal scroll
- **Trend chart**: `layerchart` (SvelteKit-compatible)
- **Export**: Client-side PDF via `pdf-lib` (captures table + charts as SVG)
- **AI insight**: `CopilotService/Query(mode=benchmark_analysis)` → streamed

---

## 12. Localization Notes

- Rankings: "Bạn đứng #2 trong 5 đối thủ"
- Metrics: "Lượt theo dõi", "Tăng trưởng", "Tỷ lệ tương tác", "Lượt xem TB", "Bài/tuần"
- Comparison: "Dẫn đầu", "Trên TB", "Dưới TB"
- Period: "7 ngày", "30 ngày", "90 ngày"
- Revenue: "Thu nhập" (never compared — always "—")

---

## 13. Design Tokens

| Token | Usage |
|---|---|
| `--color-benchmark-leader` | 🏆 leader badge + best value highlight |
| `--color-benchmark-above` | Above average (green) |
| `--color-benchmark-below` | Below average (red) |
| `--color-benchmark-you` | Your data series in radar/chart (blue) |
| `--color-benchmark-competitor-1` | First competitor overlay (red) |
| `--color-benchmark-competitor-2` | Second competitor overlay (amber) |
| `--color-benchmark-avg` | Average line/column (gray) |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Cards |

---

## 14. Related Screens

| Screen | Relationship |
|---|---|
| [W040] Competitor Registry | Manage which competitors to benchmark |
| [W039] Trend Detail | Trend data feeds benchmark context |
| [W075] Analytics Overview | User's own detailed analytics |

---

## 15. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 edge cases (no competitors, stale data), 5 errors, radar chart a11y, 7 analytics, SvelteKit impl (layerchart, pdf-lib), 9 design tokens. | System |
| 2026-03-27 | 1.0 | Initial specification | System |
