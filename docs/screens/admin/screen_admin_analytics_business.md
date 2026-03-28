# Screen: Admin — Business Analytics Dashboard

> **Screen ID**: A017
> **Module**: S26 — Internal Admin & Operations
> **Route**: `/admin/analytics/business`
> **Platform**: Admin Web (SvelteKit) — VPN-only access
> **Upstream**: S26 §Analytics, A1 Schema (subscription_events, workspace_events, onboarding_events, payment_events), B5 RBAC §3

---

## 1. Purpose & Context

Executive-level business analytics dashboard showing key SaaS metrics — MRR, ARR, churn, LTV, CAC, plan distribution, conversion funnels, and cohort retention analysis. Core dashboard for platform business decisions.

### User Story
> As a platform operator, I want to see MRR trends, churn rates, and user conversion funnels so I can make data-driven pricing and growth decisions.

### Business Goal
- Real-time visibility into platform financial health
- Early churn detection with actionable alerts
- Conversion funnel optimization data
- Cohort analysis for product-market fit validation

### When to Use
- Daily business check (MRR movement)
- Monthly board preparation
- Pricing strategy decisions
- Growth experiment evaluation
- Investor reporting data source

### Entry Points
- Admin sidebar → "📊 Analytics" → "Business"
- Admin Dashboard → "Revenue" widget click
- Executive report → "View details" link

### Exit Points
- Drill into plan detail → Plan Analytics page
- Drill into cohort → Cohort Detail
- Export CSV/PDF → download

---

## 2. Preconditions / Postconditions

### Preconditions
- Admin with `analytics_admin` or `super_admin` role
- VPN connection active
- Sufficient historical data (>30 days) for trend charts

### Postconditions
- Dashboard rendered with current metrics
- All data point-in-time consistent (snapshot)
- Export preserves filters and date range

---

## 3. Layout Structure

### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ 💰 Business Analytics          [Period: 30d ▾] [Compare ▾] [📥 CSV]│
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│ ┌─ Key Metrics Row ──────────────────────────────────────────────┐  │
│ │ MRR          │ ARR          │ Churn Rate    │ Active Workspaces│  │
│ │ 125.2M VND   │ 1.50B VND   │ 2.1%          │ 1,090            │  │
│ │ ↑ 8.2% MoM   │ ↑ 12% YoY   │ ✅ <3% target │ ↑ 45 net new    │  │
│ ├──────────────┼─────────────┼───────────────┼──────────────────┤  │
│ │ ARPU         │ LTV          │ CAC           │ LTV/CAC          │  │
│ │ 113K VND     │ 2.7M VND    │ 450K VND      │ 6.0× ✅          │  │
│ │ ↑ 3%         │ ↑ 5%         │ ↓ 8% ✅       │ Target: >3×      │  │
│ └──────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ MRR Trend (12 months) ────────────────────────────────────────┐  │
│ │ [Stacked bar chart]                                              │  │
│ │ ■ New MRR  ■ Expansion  ■ Contraction  ■ Churn                 │  │
│ │                                                                 │  │
│ │  █ █ █ █ █ █ █ █ █ █ █ █                                       │  │
│ │  ▁ ▂ ▃ ▄ ▅ ▆ ▇ ▇ ▇ █ █ █  — Net MRR line                    │  │
│ │  M4 M5 M6 M7 M8 M9 M10 M11 M12 M1 M2 M3                     │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Plan Distribution ────────────────┐ ┌─ Revenue Mix ───────────┐  │
│ │ [Donut chart]                       │ │ [Pie chart]              │  │
│ │                                     │ │                          │  │
│ │ Free:      600 (55%) ████████████  │ │ Subscriptions: 86% ████│  │
│ │ Starter:   300 (27%) ██████        │ │ Credits: 6% █           │  │
│ │ Pro:       150 (14%) ███           │ │ Fees: 5%                │  │
│ │ Business:   30 (3%)  █             │ │ Other: 3%               │  │
│ │ Enterprise: 10 (1%)               │ │                          │  │
│ │                                     │ │ Total: 145.7M VND/mo   │  │
│ └─────────────────────────────────────┘ └──────────────────────────┘  │
│                                                                       │
│ ┌─ Conversion Funnel ────────────────────────────────────────────┐  │
│ │                                                                 │  │
│ │ Signup → Onboarding → Connected → Content → Upgrade → Month 2 │  │
│ │ 100%      85%          62%         45%       34%       72%      │  │
│ │ █████     ████████     ██████      ████      ███       ████████│  │
│ │                                                                 │  │
│ │ Biggest drop-off: Connected → Content (17pp) [Investigate →]   │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Cohort Retention Heatmap ─────────────────────────────────────┐  │
│ │      │ M1  │ M2  │ M3  │ M4  │ M5  │ M6  │                    │  │
│ │ Oct  │100% │ 75% │ 68% │ 62% │ 58% │ 55% │                    │  │
│ │ Nov  │100% │ 78% │ 71% │ 65% │ 60% │     │                    │  │
│ │ Dec  │100% │ 80% │ 73% │ 67% │     │     │                    │  │
│ │ Jan  │100% │ 82% │ 75% │     │     │     │                    │  │
│ │ Feb  │100% │ 84% │     │     │     │     │                    │  │
│ │ Mar  │100% │     │     │     │     │     │                    │  │
│ │                                                                 │  │
│ │ Trend: Retention improving ↑3pp per cohort ✅                   │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Quick Insights (AI-generated) ────────────────────────────────┐  │
│ │ 💡 "Pro→Business upgrade rate increased 15% after...")         │  │
│ │ ⚠️ "Free→Starter conversion dropped 5pp in Feb cohort"        │  │
│ │ ✅ "Churn rate at 6-month low. Key driver: Copilot feature."  │  │
│ └─────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
BusinessAnalyticsPage
├── AdminShell (shared)
├── PageHeader
│   ├── Title ("💰 Business Analytics")
│   ├── PeriodSelector (7d/30d/90d/12mo/custom)
│   ├── CompareToggle (vs. previous period)
│   └── ExportButton (CSV/PDF)
├── KeyMetricsRow (8 metric cards in 2 rows)
│   ├── MRRCard (value + MoM change + sparkline)
│   ├── ARRCard (value + YoY change)
│   ├── ChurnRateCard (value + target comparison)
│   ├── ActiveWorkspacesCard (value + net new)
│   ├── ARPUCard (value + change)
│   ├── LTVCard (value + change)
│   ├── CACCard (value + change, ↓ is good)
│   └── LTVCACRatioCard (value + target)
├── MRRTrendChart (stacked bar + line)
│   ├── ChartCanvas
│   ├── Legend (New/Expansion/Contraction/Churn)
│   ├── NetMRRLine
│   └── PeriodLabels
├── DistributionRow (side-by-side charts)
│   ├── PlanDistributionChart (donut)
│   │   ├── DonutChart
│   │   └── PlanLegend (plan name + count + percentage)
│   └── RevenueMixChart (pie)
│       ├── PieChart
│       └── SourceLegend (subscriptions/credits/fees/other)
├── ConversionFunnelChart
│   ├── FunnelBars (decreasing width)
│   ├── StepLabels + Percentages
│   └── DropOffInsight (biggest drop highlighted)
├── CohortRetentionHeatmap
│   ├── HeatmapGrid (color-coded cells)
│   ├── CohortLabels (rows)
│   ├── MonthLabels (columns)
│   └── TrendInsight
├── QuickInsightsPanel (AI-generated)
│   └── InsightItem[] (icon + text)
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| MRR | `subscription_events` aggregation | `AdminAnalyticsService/GetBusinessMetrics(period)` | VND millions (125.2M) + MoM % | 15m TTL |
| Churn rate | `churn_events / active_at_start` | same | Percentage (2.1%) + target indicator | 15m TTL |
| ARPU | `total_revenue / active_workspaces` | same | VND thousands (113K) | 15m TTL |
| LTV | `ARPU × avg_lifetime_months` | same | VND millions (2.7M) | 15m TTL |
| CAC | `marketing_spend / new_customers` | same | VND thousands (450K) | 15m TTL |
| MRR trend | `mrr_snapshots` (12 months) | `AdminAnalyticsService/GetMRRTrend(12mo)` | Stacked bar chart | 1h TTL |
| Plan distribution | `workspaces` by plan | same | Donut chart + counts | 15m TTL |
| Funnel | `onboarding_events` pipeline | `AdminAnalyticsService/GetConversionFunnel` | Funnel bars + percentages | 1h TTL |
| Cohort heatmap | `cohort_retention` matrix | `AdminAnalyticsService/GetCohortRetention(6mo)` | Color-coded heatmap | 1h TTL |
| Quick insights | AI-generated from metrics | `AdminAnalyticsService/GetInsights` | Text items | 1h TTL |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Change period | Select period dropdown | `AdminAnalyticsService/GetBusinessMetrics(period)` | — | All metrics + charts reload | `analytics_admin` |
| 2 | Toggle comparison | Click "Compare" | `AdminAnalyticsService/GetComparison(period, prev_period)` | — | Delta values shown alongside current | `analytics_admin` |
| 3 | Export CSV | Click "📥 CSV" | `AdminAnalyticsService/Export(format=csv, period)` | — | CSV download | `analytics_admin` |
| 4 | Export PDF | Click PDF option | `AdminAnalyticsService/Export(format=pdf)` | — | PDF download | `analytics_admin` |
| 5 | Drill into plan | Click plan in distribution chart | — | — | Navigate to Plan Detail page | `analytics_admin` |
| 6 | Drill into cohort | Click cohort row | — | — | Navigate to Cohort Detail page | `analytics_admin` |
| 7 | Investigate drop-off | Click "Investigate →" on funnel | — | — | Navigate to funnel detail with step analysis | `analytics_admin` |
| 8 | Hover chart element | Mouse hover on chart | — | — | Tooltip with exact values | Any |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching metrics | Shimmer cards + skeleton charts |
| LOADED | Data ready | Full dashboard with charts |
| COMPARING | Compare mode active | Delta values (green/red arrows) beside each metric |
| CHURN_HIGH | Churn > 5% | Red alert: "🔴 Churn rate elevated! {n}% (target <3%)" |
| MRR_DECLINING | MRR ↓ > 5% MoM | Red alert: "📉 MRR declining {n}%! Review pricing." |
| LTV_CAC_LOW | LTV/CAC < 3× | Yellow warning: "⚠️ LTV/CAC ratio below 3×. CAC needs reduction." |
| NO_DATA | Insufficient history (<30d) | "Insufficient data for trends. Available after 30 days." |
| ERROR | API failure | Error state with retry |

---

## 8. Validation Rules

N/A — This is a read-only analytics dashboard. No user input required.

---

## 9. Permission Matrix

| Action | Super Admin | Ops Admin | Analytics Admin | Support Admin | Read Only |
|---|---|---|---|---|---|
| View dashboard | ✅ | ✅ | ✅ | ❌ | ✅ |
| Export data | ✅ | ❌ | ✅ | ❌ | ❌ |
| View financial details | ✅ | ❌ | ✅ | ❌ | ❌ |
| Drill into cohorts | ✅ | ✅ | ✅ | ❌ | ✅ |

---

## 10. Navigation Map

```
Business Analytics (/admin/analytics/business)
├── → /admin/analytics/plans/[plan]     (via plan drill-down)
├── → /admin/analytics/cohorts/[month]  (via cohort drill-down)
├── → /admin/analytics/funnel/[step]    (via funnel investigate)
├── → /admin/revenue                    (related finance view)
└── ← /admin/analytics                 (via breadcrumb)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Metrics fetch failed | API error | Per-section error with retry | Manual retry |
| Chart render failed | Data parsing error | "Chart unavailable. Raw data: [View table]" | Fallback table |
| Export failed | Generation error | Toast "Export failed. Try again." | Retry |
| Partial data | Some metrics missing | Affected cards show "N/A" | Auto-retry |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Metric cards | `role="status"`, announced with label + value + change |
| Charts | Alternative data table view for screen readers |
| Heatmap | Color + value in each cell (not color alone) |
| Funnel | Sequential reading order, percentages announced |
| Tooltips | Keyboard-accessible (focus shows tooltip) |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Page load | <1s | Admin Shell + shimmer cards |
| Metrics load | 500ms-1s | Cards populate → charts render progressively |
| Chart animation | 500ms | Bars/lines animate in |
| Period change | 300-500ms | Charts fade-transition to new data |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| Page load | <3s |
| Charts render | <1s per chart |
| Period switch | <500ms |
| Export generation | <5s for CSV, <10s for PDF |

---

## 15. Real-time Updates

| Data | Channel | Frequency |
|---|---|---|
| MRR | Polling | 15m |
| Active workspace count | Polling | 15m |
| All other metrics | On-demand (period change) | Manual |

---

## 16. Localization Notes

- Admin interface: English only
- Currency: VND with Vietnamese abbreviations (M = triệu, B = tỷ)
- Percentages: standard format ("2.1%")
- Dates: ISO format

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `admin.business_analytics.viewed` | Page load | `period`, `admin_role` |
| `admin.business_analytics.period_changed` | Period switch | `old_period`, `new_period` |
| `admin.business_analytics.exported` | Export clicked | `format`, `period` |
| `admin.business_analytics.drilled_down` | Drill into detail | `drill_type` (plan/cohort/funnel) |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-admin-success` | Positive changes, met targets |
| `--color-admin-danger` | Negative changes, missed targets |
| `--color-chart-1` through `--color-chart-6` | Chart series colors |
| `--color-heatmap-high` | High retention cells |
| `--color-heatmap-low` | Low retention cells |

---

## 19. Related Screens

| Screen | Relationship |
|---|---|
| [A015] Platform Revenue | Financial detail |
| [A018] Usage Analytics | Usage-focused view |
| [A001] Admin Dashboard | Summary hub |
| [A005] Subscription Management | Subscription operations |

---

## 20. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 3.0 | Full 20-point upgrade from 61-line Tier C. Added 8 KPI metric cards (MRR/ARR/Churn/ARPU/LTV/CAC/LTV:CAC/Active), MRR trend with new/expansion/contraction/churn breakdown, revenue mix pie chart, conversion funnel with drop-off insight, cohort retention heatmap with trend analysis, AI-generated quick insights panel, comparison mode, export CSV/PDF, 8 states with business-specific alerts. Fixed Screen ID (A23→A017), module (Admin→S26). | System |
