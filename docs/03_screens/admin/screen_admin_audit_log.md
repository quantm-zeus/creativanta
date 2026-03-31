# Screen: Admin — Audit Log

> **Screen ID**: A11
> **Module**: Admin — Security
> **Route**: `/admin/audit-log`
> **Platform**: Web (SvelteKit) — VPN-only
> **Upstream**: Admin Spec

---

## 1. Purpose & Context

Immutable audit trail of all administrative and critical user actions. Searchable, filterable, with export for compliance. Essential for security auditing and incident investigation.

### User Story
> As a security admin, I want to track all administrative actions and sensitive operations for compliance.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ 📜 Audit Log                    [🔍 Search] [Date range ▾]        │
├──────────────────────────────────────────────────────────────────────┤
│ Filter: [Actor ▾] [Action type ▾] [Severity ▾] [Entity ▾]        │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Log Entry ────────────────────────────────────────────────────┐  │
│ │ [14:23:45] 🔴 CRITICAL · admin@creativanta.com                │  │
│ │ Action: user.suspend · Target: test@test.com                   │  │
│ │ Reason: "Abuse detected" · IP: 103.xxx.xxx.xxx                │  │
│ │ [→ Details]                                                     │  │
│ └────────────────────────────────────────────────────────────────┘  │
│ ┌─ Log Entry ────────────────────────────────────────────────────┐  │
│ │ [14:20:12] 🟡 WARNING · system                                │  │
│ │ Action: ai.fallback_triggered · Provider: ElevenLabs → Google │  │
│ │ [→ Details]                                                     │  │
│ └────────────────────────────────────────────────────────────────┘  │
│ ┌─ Log Entry ────────────────────────────────────────────────────┐  │
│ │ [14:15:30] 🟢 INFO · quanm@gmail.com                          │  │
│ │ Action: workspace.settings_updated · Entity: workspace_123    │  │
│ │ [→ Details]                                                     │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ Showing 1-50 of 12,345    [← Prev] [Next →]                        │
│ [📊 Export CSV] [📄 Export PDF]                                     │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3-5. Component & Actions

```
AuditLogPage
├── AdminShell
├── PageHeader (title, search, date range)
├── FilterBar (actor, action type, severity, entity)
├── LogList
│   └── LogEntry[] (timestamp, severity badge, actor, action, target, IP)
├── Pagination
└── ExportActions (CSV, PDF)
```

| # | Action | Trigger | Result | Permission |
|---|---|---|---|---|
| 1 | Search | Search input | Full-text search across logs | `admin:audit` |
| 2 | Filter | Dropdown selections | List filters | `admin:audit` |
| 3 | View details | "→ Details" | Expanded view with full payload | `admin:audit` |
| 4 | Export | Export buttons | CSV/PDF download | `admin:audit` |

### Severity Levels
| Level | Icon | Examples |
|---|---|---|
| CRITICAL | 🔴 | User suspension, data deletion, permission change |
| WARNING | 🟡 | Failed login, rate limit hit, provider fallback |
| INFO | 🟢 | Settings update, normal admin action |

### Technical Notes
- Route: `src/routes/admin/audit-log/+page.svelte`
- Immutable: write-once, no delete capability
- Retention: 365 days minimum
- Search: Meilisearch `audit_logs` index

### Related Screens: [A01] Admin Dashboard, [A05] System Health

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-28 | 1.0 | Initial specification |

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
AuditLogPage
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
