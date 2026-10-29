# Screen: Admin — Error Analytics

> **Screen ID**: A025
> **Module**: Admin — Analytics
> **Route**: `/admin/analytics/errors`
> **Platform**: Admin Web (SvelteKit) — VPN-only
> **Upstream**: A1 Schema (error_logs, error_metrics), B5 RBAC §3

---

## 1. Purpose & Context
Admin error analytics — error frequency charts, top errors, affected workspaces, error type breakdown, and resolution tracking. Helps operations team prioritize bug fixes.
### Entry Points - Admin Dashboard: "Errors" widget / System Health → "Error analysis"
### Exit Points - Click error → error detail with stack trace / Click workspace → Workspace Detail (A05)

---

## 2. Screen Layout
### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ ⚠️ Error Analytics                         [Period: 7d ▾] [🔄]    │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Summary ──────────────────────────────────────────────────────┐  │
│ │ Total: 1,234 (↓15% vs last week) · Unique: 45                │  │
│ │ P0: 2 · P1: 8 · P2: 35 · Resolution rate: 78%               │  │
│ └────────────────────────────────────────────────────────────────┘  │
│ ┌─ Error Trend (7d line chart) ──────────────────────────────────┐ │
│ │ [Daily error count with breakdown by severity]                  │ │
│ │ Spike: Mar 25 (Shopee API change)                               │ │
│ └────────────────────────────────────────────────────────────────┘  │
│ ┌─ Top Errors ──────────────────────────────────────────────────┐  │
│ │ Error                    │ Count │ Users │ Last  │ Status     │  │
│ │ TikTok OAuth timeout     │ 234   │ 45    │ 5m    │ 🟡 Open  │  │
│ │ Shopee rate limit        │ 189   │ 23    │ 12m   │ 🔵 Fix   │  │
│ │ AI provider 503          │ 67    │ 12    │ 1h    │ 🟡 Open  │  │
│ │ [Click → stack trace + affected workspaces]                    │  │
│ └────────────────────────────────────────────────────────────────┘  │
│ ┌─ By Type ─────────────────────────────────────────────────────┐  │
│ │ [API: 45%] [Auth: 20%] [Sync: 18%] [AI: 12%] [Other: 5%]  │  │
│ └────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```
## 3. States
| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Shimmer |
| LOADED | Errors available | Charts + table |
| NO_ERRORS | Clean period | "✅ No errors in period" |
| SPIKE_DETECTED | Error spike > 3× avg | Red banner: "🔴 Error spike detected!" |
| ERROR | API failed | Error with retry |

## 4. Permission Matrix
Admin: `admin:analytics:read` role required. Read-only for Analyst/Auditor roles (per RBAC §3.2).

---

## 5. Preconditions / Postconditions
### Preconditions
- Admin user with appropriate S26 role
- VPN connection active
### Postconditions
- All actions logged in audit trail
- State changes reflected in real-time

---

## 6. Component Hierarchy
```
ErrorAnalyticsPage
├── AdminShell (shared)
├── PageHeader (Title + Breadcrumb + Actions)
├── ContentArea
│   ├── SummaryCards
│   ├── PrimaryContent
│   │   └── Screen-specific regions defined by the ASCII wireframe and interaction states
│   └── SecondaryContent
└── PageFooter
```

---

## 7. Data Binding & Display Format
| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Primary data | Parent screen state or canonical contract object(s) | Resolve via owning feature doc + API/schema contracts | Exact DTO fields from canonical contracts | Per endpoint policy |
| List items | Parent screen list/query contract(s) | Resolve via API endpoint map before implementation | Card or row layout per wireframe | Per endpoint policy |
| Summary stats | Parent screen aggregates/projections | Resolve via feature rules + API contracts | Count / KPI / chip formatting per screen | Short-lived cache only if contract allows |
| User-facing text | i18n keys | — | Vietnamese | Static |


---
## 8. Related Screens
| Screen | Relationship |
|---|---|
| [A006] System Health | System overview |
| [A010] Audit Log | Operation log |
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
