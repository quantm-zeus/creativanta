# Screen: Web — Revenue Per Content

> **Screen ID**: W094
> **Module**: S16 — Creator Pro Tools (Revenue Analytics)
> **Route**: `/creator-pro/revenue`
> **Platform**: Web (SvelteKit)
> **Upstream**: S16 Creator Pro Spec, PRD §33 Profit OS Attribution, A1 Schema (orders, order_attribution, content_items, ai_usage), B5 RBAC §2.7

---

## 1. Purpose & Context

Revenue attribution per content piece — track ROI of every video/post by connecting content creation costs to revenue generated through that content. Shows RPM (Revenue Per Mille) trends, production cost analysis, and AI-generated optimization insights.

### User Goals
- See which content generates the most revenue and highest ROI
- Understand RPM trends over time and per platform
- Identify content types and topics that drive best revenue
- Track production cost efficiency (AI credits, time invested)

### Business Goals
- Enable data-driven content strategy with revenue attribution
- Help creators focus on high-ROI content types
- Track content-to-revenue pipeline efficiency
- Support content auditing with cost/revenue transparency

### Entry Points
- Sidebar: Creator Pro → "💰 Revenue per Content"
- Creator Pro Dashboard (W088): revenue attribution card
- Copilot: "RPM của tôi tháng này bao nhiêu?"
- Content list: "View revenue" on individual content item

### Exit Points
- Click content card → Content detail page
- "📊 Full breakdown" → Detailed revenue attribution drawer
- "← Creator Pro" → Dashboard

---

## 2. Preconditions / Postconditions

### Preconditions
- Creator Pro subscription active (Pro or Business tier)
- Published content with attributed revenue data (at least one order linked)

### Postconditions
- No data mutations (analytics view only)

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Creator Pro   💰 Revenue per Content     [Period: 30d ▾]         │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Summary KPIs ────────────────────────────────────────────────┐   │
│ │ 💰 Total: 45.2M VND  │ 📊 Avg RPM: 18,500đ  │ 🏆 Top ROI: 342%│ │
│ │ 🎬 23 pieces published │ ↑22% revenue vs prev period          │   │
│ │ 💡 Revenue/piece: 1.96M avg │ Best day: Thứ 5 (~3.5M/piece)  │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ RPM Trend Chart ─────────────────────────────────────────────┐   │
│ │ [Line chart: RPM over time, per-platform color coded]          │   │
│ │ 🎵 TikTok RPM: 21,500đ (solid blue)                           │   │
│ │ 📸 Instagram RPM: 15,200đ (solid pink)                         │   │
│ │ ▶️ YouTube RPM: 12,800đ (solid red)                            │   │
│ │ --- Average RPM: 18,500đ (dashed gray)                         │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Sort: [Revenue ▾] [ROI ▾] [RPM ▾] [Views ▾]                       │
│ Filter: [Platform ▾] [Content type ▾]                               │
│                                                                      │
│ ┌─ Content Revenue Card ────────────────────────────────────────┐   │
│ │ 🥇 🎬 "5 tips nấu ăn" · 🎵 TikTok · 25/3                    │   │
│ │                                                                  │   │
│ │ 📊 Performance:                                                 │   │
│ │ 👁 24,300 views · 🛒 12 orders · 💰 3,580,000 VND             │   │
│ │ Conversion rate: 0.049% · AOV: 298K                             │   │
│ │                                                                  │   │
│ │ 💸 Production cost:                                              │   │
│ │ AI credits: 25 (≈62,500đ) · Time: ~3h · Total: ~112,500đ      │   │
│ │                                                                  │   │
│ │ 📈 Metrics:                                                      │   │
│ │ ROI: 3,082% · RPM: 18,500đ · Rev/hour: ~1,193K                │   │
│ │ Source: [🟡 Inferred attribution]                               │   │
│ │                                                                  │   │
│ │ [📊 Full breakdown] [→ Source content] [📥 Export]             │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Content Revenue Card ────────────────────────────────────────┐   │
│ │ 🥈 🎬 "Review combo skincare" · 📸 IG · 23/3                  │   │
│ │ 👁 18,500 views · 🛒 8 orders · 💰 2,240,000 VND              │   │
│ │ ROI: 1,845% · RPM: 12,100đ                                     │   │
│ │ [📊 Breakdown] [→ Content]                                     │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ── AI Insights ──────────────────────────────────────────────────     │
│ ┌─ Revenue Optimization Hints ──────────────────────────────────┐   │
│ │ 💡 "Video dạy cooking RPM cao nhất (21K) — tăng tần suất"    │   │
│ │ 💡 "TikTok có RPM cao hơn IG 40% — ưu tiên publish TikTok"  │   │
│ │ 💡 "Video dài 60-90s có ROI tốt nhất — tối ưu duration"      │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Pagination: [← Trước] Page 1/3 [Tiếp →]                           │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
RevenuePerContentPage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Creator Pro")
│   ├── PageTitle ("💰 Revenue per Content")
│   └── PeriodSelector
├── SummaryKPIs
│   ├── TotalRevenue
│   ├── AvgRPM (Revenue Per Mille views)
│   ├── TopROI
│   ├── ContentCount
│   ├── PeriodComparison
│   ├── RevenuePerPiece (average)
│   └── BestPublishDay
├── RPMTrendChart
│   ├── PlatformLines[] (color-coded per platform)
│   ├── AverageLine (dashed)
│   └── Legend
├── FilterSortBar
│   ├── SortSelector (Revenue, ROI, RPM, Views)
│   └── PlatformFilter + ContentTypeFilter
├── ContentRevenueList
│   └── ContentRevenueCard[]
│       ├── RankBadge (🥇🥈🥉 for top 3)
│       ├── ContentThumbnail + Title + Platform + Date
│       ├── PerformanceSection
│       │   ├── Views
│       │   ├── Orders
│       │   ├── Revenue (VND)
│       │   ├── ConversionRate
│       │   └── AOV
│       ├── ProductionCostSection
│       │   ├── AICreditsCost
│       │   ├── TimeInvested
│       │   └── TotalCost
│       ├── MetricsSection
│       │   ├── ROI (percentage)
│       │   ├── RPM (VND per 1K views)
│       │   └── RevenuePerHour
│       ├── SourceBadge (S009 — attribution source class)
│       └── ActionBar
│           ├── FullBreakdownButton (→ drawer)
│           ├── SourceContentButton (→ content detail)
│           └── ExportButton
├── AIInsightsSection
│   └── InsightCard[] (AI-generated optimization hints)
├── Pagination
└── BreakdownDrawer (on "Full breakdown")
    ├── OrderList (all orders attributed to this content)
    ├── AttributionPath (how order was linked to content)
    ├── PlatformBreakdown (if cross-platform content)
    └── TimelineChart (revenue over time for this piece)
```

---

## 5. Key Metrics

| Metric | Formula | Description |
|---|---|---|
| RPM | (Revenue / Views) × 1,000 | Revenue per 1,000 views |
| ROI | ((Revenue - Cost) / Cost) × 100 | Return on content investment |
| Conversion Rate | (Orders / Views) × 100 | % of viewers who ordered |
| AOV | Revenue / Orders | Average order value |
| Revenue/Hour | Revenue / Time Invested | Hourly revenue of content creation |

---

## 6. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | KPI shimmer + card skeletons |
| LOADED | Data received | Full revenue attribution dashboard |
| EMPTY | No attributed revenue | "Chưa có doanh thu được gán cho content. Doanh thu sẽ tự động gán khi có đơn hàng qua link/attribution." |
| NO_CONTENT | No published content | "Chưa publish content nào. [→ Tạo content đầu tiên]" |
| INSUFFICIENT_DATA | < 7 days of data | "RPM trend cần ít nhất 7 ngày dữ liệu." |
| ERROR | API failed | Error with retry |

---

## 7. Permissions & Tier Gating

| Feature | Free | Starter | Pro | Business |
|---|---|---|---|---|
| View revenue summary | ❌ | ✅ (top 5) | ✅ (all) | ✅ (all) |
| RPM trends | ❌ | ❌ | ✅ | ✅ |
| Production cost tracking | ❌ | ❌ | ✅ | ✅ |
| AI insights | ❌ | ❌ | ✅ (3/month) | ✅ (unlimited) |
| Export | ❌ | ❌ | ✅ | ✅ |

---
## 8. Edge Cases

| Edge Case | Handling |
|---|---|
| Attribution gap (no link tracking) | Card note: "⚠️ Attribution là ước tính — chỉ tính qua order_attribution" |
| Zero-view content with revenue | Edge case: direct sales. Show "🛒 Bán trực tiếp — không qua view" |
| Free tier accessing this page | Full-page gate: "💎 Revenue per Content cần Creator Pro. [Nâng cấp →]" |
| Single content piece | RPM trend hides (need >7d data), summary shows single item |
| AI insights quota exhausted (Starter) | "Bạn đã dùng 3/3 insights tháng này. [Nâng cấp Pro →]" |

---

## 9. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached data | Auto-retry online |
| Attribution calc fail | ClickHouse error | "Không tính được attribution. [Thử lại]" | Retry |
| RPM chart fail | SVG error | Fallback table | Retry |
| AI insights fail | CopilotService error | "💡 Insights chưa khả dụng" | Retry |
| Export fail | CSV generation error | Toast: "Không xuất được." | Retry |

---

## 10. Accessibility

| Element | Requirement |
|---|---|
| KPI cards | `role="status"`, `aria-label="Tổng doanh thu: {value}đ, RPM trung bình: {value}đ"` |
| RPM trend chart | `role="img"`, `aria-label="Biểu đồ xu hướng RPM theo nền tảng"` + data table fallback |
| Content cards | `role="article"`, `aria-label="{title}: {revenue}đ, ROI {roi}%"` |
| Rank badges | `aria-label="Hạng {rank}"` |
| AI insights | `role="alert"`, actionable CTA with `aria-label` |

---

## 11. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | KPI shimmer + card skeletons |
| KPI summary | 200-400ms | Counters animate |
| RPM chart | 400-800ms | Lines draw left→right |
| Content cards | 500-1000ms | Cards stagger in |
| AI insights | 1-2s | Cards fade in |
| Breakdown drawer | 0ms | Instant overlay |

---

## 12. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `creator_revenue.viewed` | Page load | `period`, `total_revenue`, `avg_rpm`, `content_count` |
| `creator_revenue.period_changed` | Period selector | `from_period`, `to_period` |
| `creator_revenue.sorted` | Sort selector | `sort_by`, `direction` |
| `creator_revenue.filtered` | Filter | `platform`, `content_type` |
| `creator_revenue.breakdown_opened` | "Full breakdown" | `content_id`, `revenue` |
| `creator_revenue.content_clicked` | "→ Source content" | `content_id` |
| `creator_revenue.insight_viewed` | AI insight visible | `insight_type` |
| `creator_revenue.exported` | Export | `format` |

---

## 13. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/creator-pro/revenue/+page.svelte`
- **Server load**: `+page.server.ts` → `ContentRevenueService/GetAttribution(period)` from ClickHouse
- **Tier gating**: Server-side check `subscription.tier >= 'starter'`; redirect to upgrade page if not
- **RPM chart**: `layerchart` multi-line with platform color codes
- **Content cards**: Paginated list, sorted by revenue (server-side)
- **AI insights**: `CopilotService/GetContentOptimization(period)` — lazy loaded, quota-checked
- **Breakdown drawer**: Lazy-loaded `AttributionDetail` with order list
- **Attribution**: `order_attribution` table → ClickHouse JOIN for revenue calculation

---

## 14. Localization Notes

- Currency: VND — "3.580.000đ", RPM: "18.500đ"
- ROI: "3.082%", conversion: "0.049%"
- Revenue per hour: "~1.193K/giờ"
- Rank: "🥇", "🥈", "🥉"
- Source: "🟡 Attribution ước tính", "🟢 Tracking chính thức"
- Tone: Data-driven, coaching

---

## 15. Design Tokens

| Token | Usage |
|---|---|
| `--color-rpm-tiktok` | TikTok RPM line (blue) |
| `--color-rpm-instagram` | Instagram RPM line (pink) |
| `--color-rpm-youtube` | YouTube RPM line (red) |
| `--color-rpm-average` | Average RPM line (gray dashed) |
| `--color-roi-high` | ROI >500% (green) |
| `--color-roi-medium` | ROI 100-500% (amber) |
| `--color-roi-low` | ROI <100% (red) |
| `--color-rank-gold` | 🥇 (gold) |
| `--color-surface-elevated` | Cards |

---

## 16. Related Screens

| Screen | Relationship |
|---|---|
| [W088] Creator Pro Dashboard | Parent |
| [W082] Revenue Detail | Overall revenue data |
| [W060] Product List | Products driving revenue |
| [M048] Mobile Revenue per Content | Mobile equivalent |

---

## 17. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 edge cases (attribution gap, tier gate), 5 errors, card/chart a11y, 8 analytics, SvelteKit impl (ClickHouse attribution, tier gating), localization, 9 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
