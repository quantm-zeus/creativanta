# Screen: Admin — Feature Flag Manager

> **Screen ID**: A06
> **Module**: Admin — Config
> **Route**: `/admin/feature-flags`
> **Platform**: Web (SvelteKit) — VPN-only
> **Upstream**: Product Freeze §36, A1 Schema (feature_flags)

---

## 1. Purpose & Context

Manage feature flags — enable/disable features per user segment, rollout percentage, and A/B testing. Critical for safe deployments.

---

## 2-5. Layout & Actions

### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ 🚩 Feature Flags                          [+ Create Flag]          │
├──────────────────────────────────────────────────────────────────────┤
│ Search: [🔍 flag name...]  Filter: [All ▾] [Enabled ▾]            │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Flag Row ─────────────────────────────────────────────────────┐  │
│ │ 🟢 ai_studio_translation   "Translation Studio feature"       │  │
│ │ Rollout: 100% · Segment: All users                             │  │
│ │ Created: 15/3 · Last changed: 20/3                             │  │
│ │ [✏ Edit] [Toggle: ON/OFF]                                      │  │
│ └────────────────────────────────────────────────────────────────┘  │
│ ┌─ Flag Row ─────────────────────────────────────────────────────┐  │
│ │ 🟡 live_commerce_v2   "New live selling UI"                    │  │
│ │ Rollout: 25% · Segment: Pro plan users                         │  │
│ │ Created: 28/3 · Last changed: Today                            │  │
│ │ [✏ Edit] [Toggle: ON/OFF]                                      │  │
│ └────────────────────────────────────────────────────────────────┘  │
│ ┌─ Flag Row ─────────────────────────────────────────────────────┐  │
│ │ 🔴 deprecated_api_v1   "Legacy API v1 access"                 │  │
│ │ Rollout: 5% · Segment: Legacy users · Kill date: 01/05        │  │
│ │ [✏ Edit] [Toggle: ON/OFF] [🗑 Archive]                        │  │
│ └────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

### Create/Edit Flag Modal
```
┌─ Feature Flag ──────────────────────────────────────────────────────┐
│ Flag key: [ai_studio_translation      ]                              │
│ Description: [Translation Studio feature]                            │
│ Status: [● Enabled] [○ Disabled]                                    │
│ Rollout: [100 %] (slider: 0-100%)                                   │
│ Segment: [○ All] [● Plan-based] [○ User list]                      │
│ Plan filter: [☑ Pro] [☑ Business] [☐ Free]                         │
│ Kill date: [📅 01/05/2026] (auto-disable)                           │
│ [Cancel]                                              [Save ✓]      │
└──────────────────────────────────────────────────────────────────────┘
```

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Create | Form | `FeatureFlagService/Create` | New flag | `admin:config` |
| 2 | Toggle | Switch | `FeatureFlagService/Toggle` | Flag on/off | `admin:config` |
| 3 | Edit rollout | Slider | `FeatureFlagService/Update` | Rollout % changed | `admin:config` |
| 4 | Archive | "🗑" | `FeatureFlagService/Archive` | Flag archived | `admin:config` |

### Technical Notes
- Route: `src/routes/(admin)/feature-flags/+page.svelte`
- Flags: cached in Dragonfly, checked per request
- All changes logged to Audit Log

### Related Screens: [A01] Admin Dashboard, [A11] Audit Log

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
FeatureFlagManagerPage
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
