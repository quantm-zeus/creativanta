# Screen: Admin — Global Commerce Stats

> **Screen ID**: A018
> **Module**: S26 — Internal Admin & Operations
> **Route**: `/admin/commerce`
> **Platform**: Admin Web (SvelteKit, VPN-only)
> **Upstream**: S26 commerce oversight, A1 Schema (`orders`, `platform_fee_schedules`, `workspaces`) + commerce analytics projections, B5 RBAC §3 (8 Admin roles)

---

## 1. Purpose & Context

Platform-wide commerce overview — cross-workspace GMV, order volume, refund rates, platform fee health, and top-performing workspace rankings. This is the Admin's bird's-eye view of all commerce activity across the Creativanta platform.

### User Goals (Admin)
- Monitor platform-wide GMV and order trends
- Identify workspaces with unusually high refund rates
- Track commerce fee collection and revenue share
- Spot anomalies (fraud, unusual spikes, platform issues)

### Business Goals
- Revenue tracking for platform operations (commerce fees collected)
- Risk monitoring (high refund rates signal potential fraud or quality issues)
- Capacity planning (order volume trends)
- Strategic insights (which platforms are growing for Creativanta users)

### Entry Points
- Admin Dashboard (A001): "📦 Commerce" card
- Admin Sidebar: "📦 Commerce Overview"

### Exit Points
- Click workspace → Admin Workspace Detail
- Click fee config → Fee Configuration (A019)
- Click disputes → Dispute Management (A020)

---

## 2. Preconditions / Postconditions

### Preconditions
- VPN connection active
- Admin user with `admin:commerce:read` permission (Super Admin, Operations Admin, Finance Admin)

### Postconditions
- No data mutations (read-only analytics dashboard)

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ 📦 Commerce Overview                           [Period: 30d ▾]     │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ KPI Row ─────────────────────────────────────────────────────┐   │
│ │ 💰 GMV: 1.2B VND │ 📦 Orders: 3,456│ 🔄 Refund: 2.1%      │   │
│ │ ↑15% vs prev     │ ↑8% vs prev    │ ↓0.3% 🟢               │   │
│ │ 💳 AOV: 350K VND │ 🏢 Active: 45  │ 💵 Fees: 84M VND      │   │
│ │ ↑5% vs prev      │ workspaces     │ ↑12% vs prev            │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ GMV Trend Chart ─────────────────────────────────────────────┐   │
│ │ [Area chart: daily GMV over period with platform segments]     │   │
│ │ [TikTok ████▒▒] [Shopee ████▒] [Website █▒] [Other ▒]       │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Per-Platform Breakdown ──────────────────────────────────────┐   │
│ │ Platform    │ GMV     │ Orders │ AOV  │ Refund │ Active WS   │   │
│ │ TikTok Shop │ 800M    │ 2,100  │ 381K │ 1.8%  │ 32          │   │
│ │ Shopee      │ 300M    │ 1,200  │ 250K │ 2.5%  │ 28          │   │
│ │ Website     │ 100M    │ 156    │ 641K │ 3.1%  │ 12          │   │
│ │ ─────────── ──────── ──────── ────── ─────── ──────────     │   │
│ │ TOTAL       │ 1.2B    │ 3,456  │ 350K │ 2.1%  │ 45          │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Top Workspaces (by GMV) ─────────────────────────────────────┐   │
│ │ # │ Workspace    │ Plan │ GMV    │ Orders │ Refund │ Health  │   │
│ │ 1 │ Beauty Hub   │ Pro  │ 450M   │ 1,200  │ 1.2%  │ 🟢     │   │
│ │ 2 │ Tech Shop    │ Biz  │ 300M   │ 800    │ 1.5%  │ 🟢     │   │
│ │ 3 │ Fashion Co   │ Pro  │ 200M   │ 600    │ 4.5%  │ 🟡 ⚠️  │   │
│ │ 4 │ Food Studio  │ Free │ 150M   │ 500    │ 0.8%  │ 🟢     │   │
│ │ 5 │ Skin Lab     │ Pro  │ 100M   │ 356    │ 8.2%  │ 🔴 ⚠️  │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Alerts ──────────────────────────────────────────────────────┐   │
│ │ 🔴 Workspace "Skin Lab" refund rate 8.2% (> 5% threshold)    │   │
│ │    [→ Investigate] [→ Contact owner]                           │   │
│ │ 🟡 GMV growth ↑40% on TikTok Shop (unusually high)           │   │
│ │    [→ Verify activity]                                         │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ [📥 Export Commerce Report]                                          │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
AdminCommerceOverviewPage
├── AdminShell (shared)
├── PageHeader
│   ├── PageTitle ("📦 Commerce Overview")
│   └── PeriodSelector
├── KPIRow
│   ├── GMV (animated counter + trend)
│   ├── OrderCount + trend
│   ├── RefundRate + health indicator (🟢/🟡/🔴)
│   ├── AOV + trend
│   ├── ActiveWorkspaces
│   └── PlatformFeesCollected + trend
├── GMVTrendChart
│   ├── AreaChart (daily, segmented by platform)
│   └── PlatformLegend
├── PlatformBreakdownTable
│   ├── SortableColumns
│   └── PlatformRow[] + TotalRow
├── TopWorkspacesTable
│   ├── SortableColumns (GMV, Orders, Refund, Health)
│   └── WorkspaceRow[]
│       ├── Rank
│       ├── WorkspaceName (linked → admin workspace detail)
│       ├── Plan
│       ├── GMV, Orders, RefundRate
│       └── HealthBadge (🟢/🟡/🔴 based on refund rate thresholds)
├── AlertsSection
│   └── AlertCard[]
│       ├── SeverityIcon (🔴/🟡)
│       ├── AlertDescription
│       └── ActionLinks
└── ExportButton
```

---

## 5. User Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Change period | Period selector | Refetch | All data updates | `admin:commerce:read` |
| 2 | Sort tables | Column header click | Client-side | Table re-sorts | `admin:commerce:read` |
| 3 | Investigate workspace | Click workspace / "Investigate" | — | → Admin Workspace Detail | `admin:workspace:read` |
| 4 | Contact owner | "Contact owner" | — | → Admin messaging | `admin:support:manage` |
| 5 | Export report | "📥 Export" | Server-side PDF | Commerce report download | `admin:commerce:read` |

---

## 6. Health Scoring

| Refund Rate | Health | Action |
|---|---|---|
| < 2% | 🟢 Healthy | No action |
| 2-5% | 🟡 Watch | Monitor, review trends |
| 5-10% | 🟡 ⚠️ Warning | Alert admin, suggest investigation |
| > 10% | 🔴 ⚠️ Critical | Auto-flag for review, restrict payouts |

---

## 7. Permissions (Admin RBAC — 8 roles)

| Feature | Super Admin | Operations Admin | Finance Admin | Analyst | Others |
|---|---|---|---|---|---|
| View commerce overview | ✅ | ✅ | ✅ | ✅ | ❌ |
| View workspace GMV | ✅ | ✅ | ✅ | ❌ | ❌ |
| View fee details | ✅ | ❌ | ✅ | ❌ | ❌ |
| Export reports | ✅ | ✅ | ✅ | ✅ | ❌ |
| Contact workspace owners | ✅ | ✅ | ❌ | ❌ | ❌ |

---

## 8. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | KPI shimmer + chart skeleton |
| LOADED | Data received | Full commerce dashboard |
| EMPTY | No commerce activity | "No commerce transactions in this period." |
| ALERTS_ACTIVE | Health alerts present | Alert section visible with action links |
| ERROR | API failed | Error with retry |

---
## 9. Data Binding & Display Format
| UI Element | Data Source | API / Projection | Display Format | Cache |
|---|---|---|---|---|
| KPI row | Commerce overview projection derived from `orders` + fee schedules | Admin commerce overview projection | GMV / orders / refund / AOV / active workspaces / fees | 5m TTL |
| GMV trend | Daily commerce metrics projection | Admin commerce trend projection | Area chart by platform | 15m TTL |
| Platform breakdown | Platform commerce aggregation | Admin commerce breakdown projection | Table rows with totals | 15m TTL |
| Top workspaces | Workspace-ranked commerce projection | Admin commerce ranking projection | Ranked table | 5m TTL |
| Alerts | Diagnostics / threshold evaluation projection | Admin commerce alerts projection | Alert cards with severity | 1m TTL |


---
## 10. Related Screens

| Screen | Relationship |
|---|---|
| [A001] Admin Dashboard | Parent |
| [A020] Fee Management | Commerce fee settings |
| [A019] Commerce Disputes | Commerce disputes |
| [A005] Workspace Detail | Per-workspace detail |
---
## Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached data | Pull-to-refresh when online |
| API error | Server 5xx | Toast: "Không tải được dữ liệu. [Thử lại]" | Retry |
| Not found | 404 | "Không tìm thấy" → navigate back | Back |
| Permission denied | 403 | "Không có quyền truy cập" | Contact admin |

---
## Accessibility

| Element | Requirement |
|---|---|
| Interactive elements | Minimum 48×48dp tap targets |
| Icons with meaning | `Semantics(label:)` descriptive text |
| Status indicators | Color not sole indicator; text/icon also present |
| Dynamic content | `Semantics(liveRegion: true)` for updates |
| Contrast | 4.5:1 minimum ratio |

---
## Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | App bar + shimmer placeholders |
| Commerce overview data | 200-500ms | Content populates progressively |
| User action | <1s | Inline spinner → result feedback |

---
## Localization Notes

- Primary language: Vietnamese
- Currency: VND (no decimals, dot separator: "1.200.000đ")
- Date: DD/MM/YYYY
- Numbers: dot separator (1.234)
- Relative time: "2 giờ trước", "1 ngày trước"
- Tone: Friendly, action-oriented

---
## Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | Primary actions, CTAs |
| `--color-success` | Positive states, confirmations |
| `--color-warning` | Warning indicators |
| `--color-danger` | Error states, destructive actions |
| `--color-surface-elevated` | Cards, elevated surfaces |

---
## Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | Patch | Removed duplicate template sections. Replaced with screen-specific Error Handling, Accessibility, Loading, Localization, Design Tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
