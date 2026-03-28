# Screen: Web — Finance: Profit Dashboard

> **Screen ID**: W081
> **Module**: M19 — Operating Ledger
> **Route**: `/finance`
> **Platform**: Web (SvelteKit)
> **Upstream**: PRD §25, A1 Schema (financial_snapshots, revenue_entries, cost_entries), S009 Trust Badge, B5 RBAC §2.8

---

## 1. Purpose & Context

Main finance dashboard — net profit overview with trust annotations, revenue vs cost trend, margin health tracking, and quick links to detailed breakdowns. The command center for financial health.

### User Goals
- See net profit at a glance with period comparison
- Understand revenue vs cost trends visually
- Know which revenue sources and cost categories dominate
- Get AI insight on margin changes and optimization opportunities

### Business Goals
- Centralize financial visibility
- Surface margin health proactively
- Enable data-driven cost optimization
- Provide trust-annotated financial summary

### Entry Points
- Sidebar: "💰 Finance"
- Home Dashboard: "Finance" summary card

### Exit Points
- "→ Revenue Detail" → Revenue Breakdown (W082)
- "→ Cost Detail" → Cost Tracker (W083)
- "📊 Reports" → Financial Reports (W087)
- "📥 Export" → CSV/PDF download

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 💰 Finance Dashboard            [Period: T3 2026 ▾] [📥 Export]    │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ KPI Row ─────────────────────────────────────────────────────┐   │
│ │ 💰 Net Profit  │ 📈 Revenue    │ 📉 Costs      │ 📊 Margin   │  │
│ │ 26.7M VND     │ 45.2M VND    │ 18.5M VND    │ 59.1%        │   │
│ │ ↑12% vs T2    │ ↑18% vs T2   │ ↑8% vs T2    │ ↑2.3pp       │   │
│ │ [🟢 Official] │ [🟡 Mixed]   │ [🟢 Official] │              │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Revenue vs Cost Trend ───────────────────────────────────────┐   │
│ │ [━━ Revenue (green)]  [━━ Costs (red)]  [━━ Net (blue)]      │   │
│ │ [Dual-axis area chart over 30 days]                           │   │
│ │ Notable: Revenue spike on 15/3 (TikTok Shop flash sale)      │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Revenue Sources ───────────────┐ ┌─ Cost Breakdown ──────────┐  │
│ │ 📊 Revenue by source            │ │ 📊 Cost by category       │  │
│ │ 🛍 Products: 28.5M (63%)       │ │ 📦 Shipping: 5.1M (28%) │  │
│ │   Source: [🟢 Official]         │ │ 💳 Platform: 4.8M (26%)  │  │
│ │ 🤝 Affiliate: 8.2M (18%)      │ │ 🤖 AI Credits: 3.2M (17%)│  │
│ │   Source: [🟢 Official]         │ │ 📦 COGS: 3.5M (19%)     │  │
│ │ 📺 Platform rev: 5.5M (12%)   │ │ 💰 Subs: 699K (4%)       │  │
│ │   Source: [🟡 Imported]         │ │ 📋 Other: 1.2M (6%)     │  │
│ │ 🤝 Sponsors: 3.0M (7%)        │ │                            │  │
│ │   Source: [🟡 Imported]         │ │ [→ Cost Detail →]         │  │
│ │ [→ Revenue Detail →]            │ │                            │  │
│ └──────────────────────────────────┘ └────────────────────────────┘  │
│                                                                      │
│ ┌─ Trust Summary ───────────────────────────────────────────────┐   │
│ │ 🔰 Data trust: 82% Official · 12% Imported · 6% Estimated   │   │
│ │ [████████████████████████████████████░░░░░░░] 82%             │   │
│ │ ⚠️ Estimated revenue: 2.7M VND chưa reconcile                │   │
│ │ [→ Reconciliation Center]                                      │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ AI Insight ──────────────────────────────────────────────────┐   │
│ │ 💡 "Margin cải thiện +2.3pp nhờ giảm shipping cost 15% từ    │   │
│ │    bulk deal mới. Đề xuất: tăng affiliate marketing — ROI cao │   │
│ │    nhất (ROAS 12×) nhưng chỉ chiếm 18% revenue."             │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Quick links: [📊 Reports] [🔄 Reconciliation] [📈 Settlements]    │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
ProfitDashboardPage
├── AppShell (shared)
├── PageHeader
│   ├── PageTitle ("💰 Finance Dashboard")
│   ├── PeriodSelector (month/quarter/year)
│   └── ExportButton
├── KPIRow
│   ├── NetProfitCard (amount, % change, source badge)
│   ├── RevenueCard (amount, % change, source badge)
│   ├── CostsCard (amount, % change, source badge)
│   └── MarginCard (%, pp change)
├── RevenueCostTrendChart
│   ├── DualAxisAreaChart (30d)
│   ├── Legend
│   └── NotableAnnotation (spikes, events)
├── SourcesCostsRow
│   ├── RevenueSourcesCard
│   │   └── SourceRow[] (name, amount, %, source badge)
│   │   └── RevDetailLink
│   └── CostBreakdownCard
│       └── CostRow[] (name, amount, %)
│       └── CostDetailLink
├── TrustSummary
│   ├── TrustPercentages (Official, Imported, Estimated)
│   ├── TrustCoverageBar
│   ├── UnreconciledWarning
│   └── ReconciliationLink
├── AIInsightCard
│   └── InsightText (generated by CopilotService/FinanceInsight)
└── QuickLinks (Reports, Reconciliation, Settlements)
```

---

## 5. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching aggregated data | KPI shimmer + chart skeleton |
| LOADED | Full data | Complete dashboard |
| NO_DATA | No financial data for period | "Chưa có dữ liệu tài chính cho kỳ này." |
| LOW_TRUST | < 70% Official data | Warning: "⚠️ Chỉ {pct}% dữ liệu đã xác minh. Chạy reconciliation." |
| MARGIN_DECLINING | Margin decreased > 5pp | Red alert: "📉 Margin giảm {pp}pp — xem chi tiết cost." |
| ERROR | API/aggregation failed | Error with retry |

---

## 6. Permissions

| Feature | Owner | Admin | Manager+ |
|---|---|---|---|
| View dashboard | ✅ | ✅ | ❌ |
| View trust data | ✅ | ✅ | ❌ |
| Export | ✅ | ✅ | ❌ |
| View AI insight | ✅ | ✅ | ❌ |

---
## 7. Edge Cases

| Edge Case | Handling |
|---|---|
| Negative profit (costs > revenue) | Net Profit card red: "🔴 -5.2M VND". Alert: "Chi phí vượt doanh thu!" |
| Low trust (<70% Official) | Warning: "⚠️ Chỉ {pct}% dữ liệu xác minh. Chạy reconciliation trước khi báo cáo." |
| No platform connectors | CTA: "Kết nối TikTok Shop / Shopee để xem tài chính. [Kết nối →]" |
| Single revenue source | Source comparison hidden, single-source layout |
| Very large numbers (>1B VND) | Format: "1.2B VND" instead of full number |

---

## 8. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached dashboard | Auto-retry online |
| Aggregation fail | ClickHouse timeout | "Dữ liệu đang tính toán. [Thử lại]" | Retry with shorter period |
| Chart render fail | SVG error | Fallback table with same data | Retry |
| AI insight fail | CopilotService error | "💡 Phân tích chưa khả dụng" | Retry |
| Export fail | PDF generation error | Toast: "Không xuất được. [Thử lại]" | Retry |

---

## 9. Accessibility

| Element | Requirement |
|---|---|
| KPI cards | `role="status"`, `aria-label="Lợi nhuận ròng: {value}đ, tăng {delta}%"` |
| Revenue/Cost trend chart | `role="img"`, `aria-label="Biểu đồ xu hướng doanh thu vs chi phí"` + data table fallback |
| Trust coverage bar | `role="progressbar"`, `aria-valuenow`, `aria-label="Độ tin cậy: {pct}%"` |
| Source class badges | `aria-label="Nguồn: {class_name}"`, not color-only |
| Revenue/Cost source lists | `role="list"`, each item `aria-label="{source}: {amount}đ, {pct}%"` |

---

## 10. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | KPI shimmer + chart placeholder |
| KPI cards | 200-500ms | Counters animate from 0 → value |
| Trend chart | 400-800ms | Lines draw left→right |
| Source breakdown | 500-1000ms | Rows stagger in |
| Trust bar | 600-1000ms | Bar fills with animation |
| AI insight | 1-2s | Text fades in |

---

## 11. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `finance_dashboard.viewed` | Page load | `period`, `net_profit`, `margin`, `trust_pct` |
| `finance_dashboard.period_changed` | Period selector | `from_period`, `to_period` |
| `finance_dashboard.revenue_clicked` | Revenue detail link | `revenue_total` |
| `finance_dashboard.cost_clicked` | Cost detail link | `cost_total` |
| `finance_dashboard.reconciliation_clicked` | Reconciliation link | `trust_pct` |
| `finance_dashboard.exported` | Export | `format` |
| `finance_dashboard.ai_insight_viewed` | AI card visible | — |
| `finance_dashboard.trust_warning_shown` | Low trust warning | `trust_pct` |

---

## 12. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/finance/+page.svelte`
- **Server load**: `+page.server.ts` → `FinanceService/GetProfitSummary(period)` aggregated from ClickHouse
- **Charts**: `layerchart` — dual-axis area chart for revenue vs cost
- **KPI animation**: Svelte `tweened` stores for counter animation
- **Trust badges**: S009 component (`<TrustBadge source={sourceClass} />`)
- **No localStorage**: Financial data never cached client-side (privacy)
- **Export**: PDF via `pdf-lib`, CSV via server-side `FinanceService/ExportReport`

---

## 13. Localization Notes

- Currency: VND — "45.200.000đ", large: "45.2M VND", >1B: "1.2B VND"
- Period: "T3 2026" (tháng), "Q1 2026" (quý), "2026" (năm)
- Trust: "🟢 Chính thức", "🟡 Nhập", "🔵 Suy luận", "⚪ Ước tính"
- Margin: "59.1%", delta: "+2.3pp"
- Tone: Data-driven, formal (finance context)

---

## 14. Design Tokens

| Token | Usage |
|---|---|
| `--color-revenue` | Revenue metric, chart line (blue) |
| `--color-costs` | Cost metric, chart line (red) |
| `--color-profit` | Net profit metric (green) |
| `--color-trust-official` | 🟢 Official badge |
| `--color-trust-imported` | 🟡 Imported badge |
| `--color-trust-estimated` | ⚪ Estimated badge |
| `--color-margin-healthy` | Margin ≥50% (green) |
| `--color-margin-warning` | Margin 30-50% (amber) |
| `--color-margin-danger` | Margin <30% (red) |
| `--color-surface-elevated` | Cards |

---

## 15. Related Screens

| Screen | Relationship |
|---|---|
| [W082] Revenue Breakdown | Revenue drill-down |
| [W083] Cost Tracker | Cost drill-down |
| [W084] Reconciliation | Trust verification |
| [W085] Proof Browser | Evidence chain |
| [W086] Settlements | Payment tracking |
| [W087] Financial Reports | Report generation |
| [M034] Mobile Finance | Mobile equivalent |

---

## 16. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 edge cases (negative profit, low trust), 5 errors, KPI/chart a11y, 8 analytics, SvelteKit impl, 10 design tokens (trust/margin). | System |
| 2026-03-28 | 1.0 | Initial specification | System |
