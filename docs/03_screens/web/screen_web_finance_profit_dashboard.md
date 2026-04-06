# Screen: Web — Profit Dashboard

> **Screen ID**: W081
> **Module**: M19 — Operating Ledger / Profit Graph / Proof
> **Route**: `/finance`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §25-27, A1 Schema (`profit_snapshots`, `cost_items`, `settlements`, `proof_bundles`, `reconciliation_state`), B5 RBAC §2.7

---
## 1. Purpose & Context

The Profit Dashboard is the financial cockpit of Creativanta — showing real net profit (revenue minus all costs), revenue breakdown by platform/product, cost tracking by category, reconciliation status per platform, and proof audit trail. Every financial number is traceable to its source via Proof Bundles. This is the "Trust Layer" that transforms raw commerce data into verified, auditable financial intelligence.

### User Goals
- See actual profit at a glance (revenue - costs = net profit)
- Understand which platforms and products generate the most revenue
- Track all costs (platform fees, commissions, AI credits, marketing, products)
- Verify data accuracy through reconciliation status and proof bundles
- Export financial reports for tax filing and business analysis

### Business Goals
- Differentiate Creativanta through transparent financial proof (vs competitors who show only revenue)
- Enable creators to run profitable businesses with real cost visibility
- Support tax compliance through auditable financial records
- Build trust through reconciliation status (every number has a source)

### When This Screen Is Used
- Daily: Quick profit check after orders process
- Monthly: End-of-month financial review and export
- Quarterly: Business performance review, tax preparation
- On-demand: Investigating revenue discrepancies or cost anomalies

### Entry Points
- Sidebar: "💰 Tài chính" under Finance section
- Home Dashboard: Revenue/Profit KPI widget click
- AI Copilot: "Lợi nhuận tháng này bao nhiêu?" → navigates here
- Notification: "📊 Báo cáo tài chính tháng 3 đã sẵn sàng"

### Exit Points
- Click revenue metric → Revenue Detail (W071)
- Click cost category → Cost Manager (W072)
- Click proof badge → Proof Bundle (W075)
- Click reconciliation → Reconciliation Detail (W074)
- Click settlement → Settlement Import (W073)
- "📤 Export" → PDF/CSV download

---
## 2. Preconditions / Postconditions

### Preconditions
- User has `profit:read` permission (Owner, Admin, Manager only — financial data is sensitive)
- At least one revenue source connected or manual revenue entry exists
- Financial data aggregation pipeline has run (ClickHouse materialized views)

### Postconditions
- Page view logged for analytics
- Export action logged in workspace audit trail
- Settlement file uploads create new reconciliation records

---
## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell + full dashboard with side-by-side charts |
| Tablet (768-1279px) | App Shell (collapsed) + stacked charts |
| Mobile (≤767px) | Redirect to M034 Mobile Profit Summary |

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 💰 Tài chính                    [Period: Tháng 3/2026 ▾] [📤 Export]│
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Profit Summary Bar (full width) ────────────────────────────────┐│
│ │ ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐     ││
│ │ │ 📈 Revenue      │ │ 📉 Costs        │ │ 💰 Net Profit   │     ││
│ │ │ 45.2M VND       │ │ 12.8M VND       │ │ 32.4M VND       │     ││
│ │ │ ↑+15% vs Feb    │ │ ↑+8% vs Feb     │ │ ↑+18% vs Feb    │     ││
│ │ │ Source: 🟢 5/5  │ │ Source: 🟡 3/5  │ │ Margin: 71.7%   │     ││
│ │ │ [📊 Detail →]   │ │ [📊 Detail →]   │ │ ↑+2.1pp vs Feb  │     ││
│ │ └─────────────────┘ └─────────────────┘ │ [📋 Proof →]     │     ││
│ │                                          └─────────────────┘      ││
│ │ ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐     ││
│ │ │ 🔄 ROI          │ │ 📦 Orders       │ │ 💳 Avg Order    │     ││
│ │ │ 253%            │ │ 428             │ │ 105,600đ        │     ││
│ │ │ ↑+12% vs Feb    │ │ ↑+22% vs Feb   │ │ ↓-3% vs Feb     │     ││
│ │ └─────────────────┘ └─────────────────┘ └─────────────────┘     ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Revenue by Platform ────────────┐ ┌─ Revenue by Product ─────────┐│
│ │ [Donut Chart]                    │ │ [Horizontal Bar Chart]         ││
│ │                                  │ │                                ││
│ │ 🎵 TikTok Shop  25.1M (55.5%)  │ │ Serum VitC    12.5M ████████ ││
│ │   ├ Ecom: 20.5M                 │ │ Sunscreen     8.2M  █████    ││
│ │   └ Live: 4.6M                  │ │ Toner AHA/BHA 5.1M  ███      ││
│ │ 🛍 Shopee       12.3M (27.2%)  │ │ Set 3 món     4.8M  ███      ││
│ │ 📸 Instagram     5.2M (11.5%)  │ │ Mask pack     3.2M  ██       ││
│ │ 🎖 Membership    2.6M (5.8%)   │ │ Others       11.4M  ████████ ││
│ │                                  │ │                                ││
│ │ Click segment for drill-down     │ │ Click product for detail       ││
│ └──────────────────────────────────┘ └────────────────────────────────┘│
│                                                                      │
│ ┌─ Cost Breakdown Table ───────────────────────────────────────────┐ │
│ │ Category         │ Amount  │ % Rev  │ Trend  │ Proof Status      │ │
│ │──────────────────│─────────│────────│────────│───────────────────│ │
│ │ Platform fees    │ 4.5M    │ 10.0%  │ →      │ 🟢 Verified      │ │
│ │ Platform commis. │ 3.6M    │  8.0%  │ →      │ 🟢 Verified      │ │
│ │ AI credits used  │ 2.1M    │  4.6%  │ ↑+15%  │ 🟢 Auto-tracked  │ │
│ │ Product COGS     │ 1.8M    │  4.0%  │ →      │ 🟡 Manual entry  │ │
│ │ Marketing spend  │ 0.5M    │  1.1%  │ ↓-20%  │ 🟡 Manual entry  │ │
│ │ Other costs      │ 0.3M    │  0.7%  │ →      │ 🟡 Manual entry  │ │
│ │ Total costs      │ 12.8M   │ 28.3%  │        │                   │ │
│ │──────────────────│─────────│────────│────────│───────────────────│ │
│ │ [+ Thêm chi phí mới] [📊 Chi tiết chi phí →]                    │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Reconciliation Status ──────────────────────────────────────────┐ │
│ │ Platform       │ Expected  │ Settled   │ Delta      │ Status     │ │
│ │────────────────│───────────│───────────│────────────│────────────│ │
│ │ 🎵 TikTok Shop│ 25.1M    │ 25.0M     │ -100K (fee)│ 🟢 Matched│ │
│ │ 🛍 Shopee     │ 12.3M    │ 12.3M     │ 0          │ 🟢 Matched│ │
│ │ 📸 Instagram  │ 5.2M     │ —         │ —          │ 🟡 Pending│ │
│ │ 📺 YouTube    │ 0.8M     │ —         │ —          │ 🟡 Pending│ │
│ │ 🎖 Membership │ 2.6M     │ 2.6M      │ 0          │ 🟢 Matched│ │
│ │──────────────────────────────────────────────────────────────────│ │
│ │ [📋 Upload settlement file] [📊 Chi tiết reconciliation →]     │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Monthly Trend (6 months) ───────────────────────────────────────┐ │
│ │ [Multi-line chart: Revenue (blue) / Costs (red) / Net (green)]  │ │
│ │                                                                    │ │
│ │ Oct    Nov    Dec    Jan    Feb    Mar                             │ │
│ │ 30M    32M    38M    35M    39M    45M  — Revenue                │ │
│ │ 10M    10M    12M    11M    12M    13M  — Costs                  │ │
│ │ 20M    22M    26M    24M    27M    32M  — Net profit             │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Tax Summary (collapsible) ──────────────────────────────────────┐ │
│ │ Estimated taxable income (Q1/2026): 96.8M VND                    │ │
│ │ Estimated PIT (assumed 5%): 4.84M VND                            │ │
│ │ [📤 Export for tax filing →]                                     │ │
│ └──────────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
ProfitDashboardPage
├── AppShell (shared)
├── PageHeader
│   ├── PageTitle ("💰 Tài chính")
│   ├── PeriodSelector (month/quarter/year/custom — date range picker)
│   └── ExportButton ("📤 Export" — dropdown: PDF, CSV, Excel)
├── ProfitSummaryBar
│   ├── PrimaryMetricCard[] (Revenue, Costs, Net Profit — large)
│   │   ├── MetricLabel
│   │   ├── MetricValue (animated counter, VND formatted)
│   │   ├── TrendIndicator (↑↓→ with percentage vs previous period)
│   │   ├── SourceCompleteness ("🟢 5/5" — how many data sources confirmed)
│   │   └── DetailLink (→ Revenue Detail or Cost Detail)
│   └── SecondaryMetricCard[] (ROI, Orders, Avg Order Value — small)
│       ├── MetricLabel
│       ├── MetricValue
│       └── TrendIndicator
├── ChartsRow (side-by-side on desktop, stacked on tablet)
│   ├── RevenueByPlatformDonut
│   │   ├── DonutChart (interactive — click segment for drill-down)
│   │   └── Legend
│   │       └── PlatformLegendItem[] (icon, name, amount, percentage)
│   │           └── SubBreakdown (optional — e.g., TikTok: Ecom vs Live)
│   └── RevenueByProductBar
│       ├── HorizontalBarChart (clickable bars)
│       └── ProductLabel[] (name, amount, bar)
├── CostBreakdownTable
│   ├── TableHeader (Category, Amount, % of Revenue, Trend, Proof Status)
│   ├── CostRow[]
│   │   ├── CategoryName (icon + name)
│   │   ├── Amount (VND formatted)
│   │   ├── PercentOfRevenue
│   │   ├── TrendArrow (vs previous period — ↑/↓/→ with %)
│   │   └── ProofBadge (S009 trust badge — 🟢 Verified / 🟡 Manual / 🔴 Missing)
│   ├── TotalRow (bold summary)
│   ├── AddCostButton ("+ Thêm chi phí mới")
│   └── CostDetailLink ("📊 Chi tiết chi phí →")
├── ReconciliationStatusTable
│   ├── TableHeader (Platform, Expected, Settled, Delta, Status)
│   ├── PlatformRow[]
│   │   ├── PlatformIcon + Name
│   │   ├── ExpectedRevenue
│   │   ├── SettledAmount (from settlement file)
│   │   ├── Delta (difference — ideally 0 or explainable fee)
│   │   └── ReconciliationBadge (🟢 Matched / 🟡 Pending / 🔴 Mismatch / ⚫ No data)
│   ├── UploadSettlementButton ("📋 Upload")
│   └── ReconciliationDetailLink
├── MonthlyTrendChart
│   ├── MultiLineChart (revenue blue, costs red, net profit green)
│   ├── XAxisLabels (months)
│   ├── Tooltip (hover for exact values)
│   └── LegendBar
└── TaxSummarySection (collapsible)
    ├── TaxableIncome (quarterly/annual estimate)
    ├── EstimatedTax (configurable rate)
    └── ExportForTaxButton
```

---
## 5. Displayed Data

| Element | Source | API | Display Format | Cache |
|---|---|---|---|---|
| Revenue total | `profit_snapshots.gross_revenue WHERE scope_type='period'` | `ProfitService/GetSummary(period)` | VND formatted ("45.2M VND") | 15m |
| Costs total | `profit_snapshots.(platform_fees + shipping_costs + affiliate_commissions + refund_deductions + cogs + ads_spend + ai_credit_costs + other_costs)` | same | VND formatted | 15m |
| Net profit | Revenue - Costs | Computed client-side | VND formatted | — |
| Margin | Net Profit / Revenue × 100 | Computed | Percentage ("71.7%") | — |
| ROI | Net Profit / Costs × 100 | Computed | Percentage ("253%") | — |
| Revenue by platform | `profit_snapshots WHERE scope_type='platform'` | `ProfitService/GetRevenueByPlatform(period)` | Donut chart + legend | 15m |
| Revenue by product | `profit_snapshots WHERE scope_type='product'` | `ProfitService/GetRevenueByProduct(period)` | Bar chart | 15m |
| Cost breakdown | `cost_items GROUP BY cost_type` | `ProfitService/GetCostBreakdown(period)` | Table rows | 15m |
| Proof status | `proof_bundles.status` per cost category | Included in cost data | Trust badge (S009) | 15m |
| Reconciliation | `settlements.reconciliation_state` + `reconciliation_records` | `ReconciliationService/GetStatus(period)` | Status table | 15m |
| Monthly trend | 6-month aggregation | `ProfitService/GetTrend(6_months)` | Multi-line chart | 30m |
| Orders count | `COUNT(orders) WHERE period` | Included in summary | Integer | 15m |
| Avg order value | Revenue / Orders | Computed | VND formatted | — |
| Source completeness | Count of platforms with verified data | Computed | "5/5 🟢" | 15m |
| Tax estimate | Net profit × configured tax rate | Computed | VND formatted | — |

---
## 6. User Actions

| # | Action | Trigger | Type | API Call | System Response | Navigation | Permission |
|---|---|---|---|---|---|---|---|
| 1 | Change period | Period selector dropdown | Filter | Refetch all data | Dashboard updates with animation | — | `profit:read` |
| 2 | Export PDF | "📤 Export" → "PDF" | Export | `ProfitService/ExportReport(period, 'pdf')` | PDF download | — | `profit:read` |
| 3 | Export CSV | "📤 Export" → "CSV" | Export | `ProfitService/ExportReport(period, 'csv')` | CSV download | — | `profit:read` |
| 4 | View revenue detail | Click revenue card "Detail →" | Navigate | — | — | → `/finance/revenue` | `profit:read` |
| 5 | View revenue segment | Click donut segment | Navigate | — | — | → `/finance/revenue?platform=[id]` | `profit:read` |
| 6 | View product detail | Click bar in product chart | Navigate | — | — | → `/products/[id]` | `profit:read` |
| 7 | View cost detail | Click cost category row | Navigate | — | — | → `/finance/costs?category=[cat]` | `profit:read` |
| 8 | Add new cost | "+ Thêm chi phí mới" | Create | — | Modal: cost entry form | — | `reconciliation:manage` |
| 9 | View proof bundle | Click proof badge | Navigate | — | — | → `/finance/proof/[id]` | `proof_bundle:read` |
| 10 | Upload settlement | "📋 Upload settlement file" | Upload | `SettlementService/Upload(file)` | Upload modal → processing → reconciliation | — | `reconciliation:manage` |
| 11 | View reconciliation | "Chi tiết reconciliation →" | Navigate | — | — | → `/finance/reconciliation` | `reconciliation:manage` |
| 12 | Export for tax | "📤 Export for tax →" | Export | `ProfitService/ExportTaxReport(quarter)` | Formatted tax export download | — | `profit:read` |
| 13 | Toggle tax section | Click tax section header | Toggle | — | Section expands/collapses | — | `profit:read` |

---
## 7. Validation Rules

### Add Cost Entry (Modal)
| Field | Rule | Error |
|---|---|---|
| Category | Required, select from predefined list | "Chọn danh mục chi phí" |
| Amount | Required, > 0, max 10B VND | "Số tiền phải lớn hơn 0" |
| Date | Required, within selected period | "Ngày phải trong khoảng thời gian đã chọn" |
| Description | Required for "Other" category, min 5 chars | "Mô tả chi phí cho danh mục 'Khác'" |
| Proof document | Optional but encouraged (receipt/invoice upload) | Warning: "Nên đính kèm chứng từ để verified proof" |

### Settlement Upload
| Field | Rule | Error |
|---|---|---|
| File | Required, CSV/XLS/PDF, max 10MB | "File phải là CSV, XLS hoặc PDF, tối đa 10MB" |
| Platform | Required | "Chọn nền tảng cho settlement file" |
| Period | Required | "Chọn kỳ thanh toán" |

---
## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial page load | Summary cards shimmer + chart placeholders | Wait |
| LOADED | All data received | Full dashboard with animated counters | Interact normally |
| NO_REVENUE | No revenue entries for period | Illustration + "Chưa có dữ liệu doanh thu trong kỳ này. Kết nối nền tảng thương mại hoặc thêm doanh thu thủ công. [Kết nối →]" | Connect platform |
| PARTIAL_DATA | Some platforms have data, others pending | Dashboard shows available data + yellow banners for missing: "⚠️ Dữ liệu Instagram chưa cập nhật (cũ 6h)" | Wait or refresh |
| RECONCILIATION_MISMATCH | Settlement doesn't match expected | Red alert on affected platform: "🔴 Shopee: Chênh lệch 500K VND. [Kiểm tra →]" | Investigate |
| UPLOADING | Settlement file being processed | Upload progress bar + "Đang xử lý settlement file..." | Wait |
| EXPORT_GENERATING | Report being generated | Export button shows spinner | Wait |
| ERROR | API failed | "Không tải được dữ liệu tài chính. [Thử lại]" | Retry |

---
## 9. Permissions & Role-based Behavior

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View profit dashboard | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| View revenue/costs | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| View proof bundles | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Add cost entries | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Upload settlement | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| View reconciliation | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Export reports | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Tax summary | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |

### Visibility Rules
- **Manager**: Full read access to all financial data. Cannot add costs or upload settlements. Tax section hidden.
- **Editor/Contributor/Viewer/External**: Finance sidebar item completely hidden. Direct URL redirect to permission denied.
- Financial data is never cached in localStorage or service workers (privacy requirement).

---
## 10. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Revenue entries | Polling | Every 15 minutes (financial data lag from platforms) |
| Cost entries | On-demand | Refetch on period change or cost add |
| Reconciliation status | Polling | Every 15 minutes |
| Settlement processing | SSE | Real-time (during upload processing) |
| Monthly trend | Static | Computed daily at midnight |

### Data Freshness Policy
| Source | Freshness Guarantee |
|---|---|
| TikTok Shop | T+2 hours (API sync) |
| Shopee | T+6 hours (API sync) |
| Membership | Real-time (internal) |
| Manual costs | Immediate |
| Settlement files | After processing (1-5 minutes) |

---
## 11. Edge Cases

| Edge Case | Handling |
|---|---|
| Revenue = 0 for period | Show "Chưa có doanh thu" — margin "N/A", ROI "N/A" |
| Costs > Revenue (negative profit) | Show in red: "🔴 -5.2M VND". Alert: "⚠️ Chi phí vượt doanh thu trong kỳ này." |
| Platform not connected | Show platform in reconciliation as "⚫ Chưa kết nối. [Kết nối →]" |
| Settlement amount mismatch > 5% | Auto-flag as "🔴 Conflict detected". "Chênh lệch lớn hơn 5% — cần kiểm tra." |
| Currency conversion needed | Show in VND with note: "Converted from USD at rate {rate} on {date}" |
| Very large numbers (>1B VND) | Format as "1.2B VND" instead of "1,200,000,000đ" |
| Historical period (>12 months ago) | Data available (read-only). "Dữ liệu lịch sử — không thể chỉnh sửa." |
| Multiple workspaces | Finance data is per-workspace. No cross-workspace aggregation. |
| Proof document expired | Cost row shows "🟠 Proof expired — re-upload required" |

---
## 12. Accessibility

| Element | Requirement |
|---|---|
| Summary cards | `role="status"`, `aria-label` includes metric name, value, and trend |
| Charts | Alt text descriptions + data table fallback for screen readers |
| Donut chart | `aria-label="Revenue by platform: TikTok 55.5%, Shopee 27.2%..."` |
| Cost table | Standard table ARIA with sortable columns |
| Reconciliation badges | `aria-label` with full status ("TikTok Shop: reconciled, matched settlement S-042") |
| Export button | `aria-label="Export financial report"` |
| Period selector | `aria-label="Select reporting period"` |
| Animated counters | Respect `prefers-reduced-motion` — show final number immediately |

---
## 13. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 2.0s (summary bar is LCP — complex data aggregation) |
| CLS | < 0.05 (chart containers have fixed heights) |
| TTI | < 3.0s |
| Chart render | < 500ms (progressive: summary → donut → bar → line) |
| Export generation | PDF < 5s, CSV < 2s |
| Data refresh | < 3s for full dashboard |

---
## 14. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `finance.dashboard.viewed` | Page load | `period`, `revenue_total`, `net_profit`, `margin` |
| `finance.period.changed` | Period selector | `old_period`, `new_period` |
| `finance.chart.interacted` | Click donut/bar segment | `chart_type`, `segment`, `value` |
| `finance.cost.added` | New cost entry saved | `category`, `amount` |
| `finance.settlement.uploaded` | Settlement file uploaded | `platform`, `period`, `file_size` |
| `finance.proof.viewed` | Proof badge clicked | `cost_category`, `proof_status` |
| `finance.exported` | Report exported | `format` (pdf/csv), `period` |
| `finance.reconciliation.viewed` | View reconciliation detail | `unmatched_count` |
| `finance.tax.exported` | Tax export clicked | `quarter`, `estimated_amount` |

---
## 15. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-revenue` (blue-500) | Revenue metric, chart line |
| `--color-costs` (red-400) | Cost metric, chart line |
| `--color-profit` (green-500) | Net profit metric, chart line |
| `--color-proof-verified` (green-500) | 🟢 Verified badge |
| `--color-proof-manual` (yellow-500) | 🟡 Manual badge |
| `--color-proof-missing` (red-500) | 🔴 Missing badge |
| `--font-metric-lg` | Summary card values (32px, bold) |
| `--font-metric-sm` | Secondary metrics (24px, medium) |
| `--spacing-card-gap` | Gap between summary cards (16px) |

---
## 16. Technical Implementation Notes

### SvelteKit Specifics
- **Route**: `src/routes/(app)/finance/+page.svelte`
- **Server load**: `+page.server.ts` → fetch summary + breakdown data
- **Charts**: `layerchart` library (SvelteKit-optimized, SSR-friendly)
- **Export PDF**: Client-side `pdf-lib` with chart screenshots via `html2canvas`
- **Export CSV**: Server-side generation via `ProfitService/GetSummary`
- **Financial data**: Read-only from external platforms. Manual entries only for costs.
- **Privacy**: No `localStorage` caching of financial data. Data cleared on logout.

### Data Freshness
```
+page.server.ts:
  Promise.all([
    financeService.getProfitSummary(period),
    financeService.getRevenueByPlatform(period),
    financeService.getRevenueByProduct(period),
    financeService.getCostBreakdown(period),
    reconciliationService.getStatus(period),
    financeService.getTrend('6months'),
  ])
  // All responses include `last_updated_at` for freshness indication
```

### Proof System
Every financial number has a `source_class` (S009) from the canonical taxonomy:
- **Official**: Directly from platform API (auto-verified)
- **Imported**: From settlement file upload (reconciled)
- **Manual**: User-entered cost (requires proof document upload for verification)
- **Inferred**: Calculated from partial data (lower confidence)


---
## 17. Related Screens

| Screen | Relationship |
|---|---|
| [W082] Revenue Detail | Revenue drill-down |
| [W083] Cost Detail | Cost management |
| [W084] Reconciliation | Settlement matching |
| [W085] Proof Browser | Evidence audit trail |
| [W086] Settlements | Payment tracking |
| [W087] Financial Reports | Report generation |
| [M041] Mobile Finance Summary | Mobile equivalent |
| [S009] Trust Badge | Source class taxonomy |

---

## 18. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" — no cached financial data (privacy) | Retry online |
| Aggregation fail | ClickHouse timeout | "Dữ liệu đang tính toán. [Thử lại]" | Retry |
| Settlement upload fail | File parse error | Toast: "File không hợp lệ. Kiểm tra format." | Fix & re-upload |
| Export fail | PDF generation error | Toast: "Không xuất được. [Thử lại]" | Retry |
| Platform data stale | Sync delay >6h | Per-platform banner: "⚠️ Dữ liệu {platform} cũ {time_ago}" | Wait or reconnect |

---

## 19. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Summary bar shimmer + chart placeholders |
| Summary KPIs | 200-500ms | Counters animate from 0 → value |
| Revenue donut | 400-800ms | Donut segments animate (clockwise) |
| Product bars | 500-800ms | Bars grow horizontally |
| Cost table | 600-1000ms | Rows stagger in |
| Reconciliation | 700-1000ms | Status badges populate |
| Monthly trend | 800-1200ms | Multi-line chart draws |
| Tax summary | On expand | Instant |

---

## 20. Localization Notes

- Currency: VND — "45.200.000đ", large: "45.2M VND", >1B: "1.2B VND"
- Period: "Tháng 3/2026", "Q1 2026", "Năm 2025"
- Trust: "🟢 Xác minh", "🟡 Thủ công", "🔴 Thiếu", "⚫ Chưa kết nối"
- Reconciliation: "Khớp", "Chưa xác nhận", "Không khớp"
- Tax: "Thu nhập chịu thuế", "TNCN ước tính"
- Tone: Formal, data-driven (finance context)

---

## 21. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.1 | **Tier A cleanup**: Replaced generic Error/Loading/Localization boilerplate with screen-specific content. Already had edge cases, a11y, analytics, tokens, impl. | System |
| 2026-03-28 | 2.0 | Full specification | System |
