# Screen: Admin — Usage Analytics

> **Screen ID**: A22
> **Module**: Admin — Analytics
> **Route**: `/admin/analytics/usage`
> **Platform**: Admin Web (SvelteKit) — VPN-only
> **Upstream**: A1 Schema (usage_metrics), B5 RBAC §3

---

## 1. Purpose & Context
Platform-wide usage analytics — DAU/MAU, feature adoption, API call volumes, AI credit consumption, and storage usage patterns.
### Entry Points - Admin Dashboard: "Usage" card
### Exit Points - Drill into workspace → Workspace Detail (A05)

---

## 2. Screen Layout
### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ 📊 Usage Analytics                         [Period: 30d ▾] [📥]   │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Key Metrics ──────────────────────────────────────────────────┐  │
│ │ DAU: 456 (↑12%) · MAU: 1,100 · Stickiness: 41%              │  │
│ │ API calls: 1.2M/day · AI credits consumed: 45K/day           │  │
│ │ Storage used: 2.3 TB / 10 TB · Avg session: 12m              │  │
│ └────────────────────────────────────────────────────────────────┘  │
│ ┌─ DAU Trend (30d area chart) ──────────────────────────────────┐  │
│ │ [Users over time — with event annotations]                     │  │
│ └────────────────────────────────────────────────────────────────┘  │
│ ┌─ Feature Adoption ────────────────────────────────────────────┐  │
│ │ Feature         │ Users  │ Sessions │ Adoption │ Trend       │  │
│ │ Publishing      │ 890    │ 4.5K     │ 81%      │ ↑5%         │  │
│ │ AI Studio       │ 678    │ 2.3K     │ 62%      │ ↑12%        │  │
│ │ Commerce        │ 456    │ 3.1K     │ 41%      │ ↑2%         │  │
│ │ Workflow        │ 234    │ 1.2K     │ 21%      │ ↑8%         │  │
│ │ Creator Pro     │ 123    │ 890      │ 11%      │ ↑15%        │  │
│ └────────────────────────────────────────────────────────────────┘  │
│ ┌─ Top Consumers (by resource) ─────────────────────────────────┐  │
│ │ 1. ws_abc (12K API/day, 500 AI cr/day, 45GB storage)         │  │
│ │ 2. ws_def (8K API/day, 300 AI cr/day, 23GB storage)          │  │
│ └────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```
## 7. States
| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Shimmer |
| LOADED | Data ready | Charts + tables |
| RESOURCE_HIGH | Storage > 80% | Warning: "⚠️ Storage at 80%!" |
| ERROR | API failed | Error with retry |

---

## 2. Preconditions / Postconditions
### Preconditions
- Admin user with appropriate S26 role
- VPN connection active
### Postconditions
- All actions logged in audit trail
- State changes reflected in real-time

---

## 4. Component Hierarchy
```
UsageAnalyticsPage
├── AdminShell (shared)
├── PageHeader (Title + Breadcrumb + Actions)
├── ContentArea
│   ├── SummaryCards
│   ├── PrimaryContent
│   │   └── [Items per wireframe]
│   └── SecondaryContent
└── PageFooter
```

---

## 5. Data Binding & Display Format
| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Primary data | Backend table | `Service/Get` | Formatted display | 15m TTL |
| List items | Backend query | `Service/List(page)` | Card/row list | Based on criticality |
| Summary stats | Aggregation | `Service/GetStats` | Count/percentage | 5m TTL |
| User-facing text | i18n keys | — | Vietnamese | Static |


---
## 19. Related Screens
| Screen | Relationship |
|---|---|
| [A23] Business Analytics | Revenue metrics |
| [A05] Workspace Detail | Per-workspace drill-down |
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
| Primary data | 200-500ms | Content populates progressively |
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
