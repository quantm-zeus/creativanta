# Shared: Navigation Patterns

> **Screen ID**: S002
> **Module**: Shared — UI Patterns
> **Platform**: All (Web + Mobile)

---

## 1. Purpose & Context

Standardized navigation structures for Web sidebar, mobile bottom nav, and admin sidebar.

---

## 2. Web Sidebar

```
┌─ Sidebar (240px, collapsible to 56px) ────┐
│ [Logo] Creativanta        [◀ Collapse]     │
│ ──────────────────────────                  │
│ [🏠] Dashboard                              │
│ [📈] Intelligence                           │
│   ├ Trend Radar                             │
│   ├ Competitors                             │
│   └ Opportunities                           │
│ [💡] Ideas                                  │
│ [📝] Scripts                                │
│ [🎬] AI Studio                              │
│ [📅] Calendar                               │
│ [💬] Inbox              [badge: 5]         │
│ [📦] Commerce                              │
│ [💰] Finance                               │
│ [📊] Analytics                              │
│ [⚡] Workflows                              │
│ [🎮] Level                                  │
│ ──────────────────────────                  │
│ [⚙️] Settings                              │
│ [❓] Help                                   │
│ [👤] Profile                                │
└─────────────────────────────────────────────┘
```

## 3. Mobile Bottom Nav (5 tabs)

```
[🏠 Home] [💡 Ideas] [🎬 Studio] [💬 Inbox] [📊 More]
```

- More (📊) opens a drawer with remaining nav items
- Active tab: filled icon + label
- Inactive: outlined icon only
- Badge on Inbox for unread count

## 4. Admin Sidebar

```
┌─ Admin Sidebar (dark theme) ──────────────┐
│ [🛡] ADMIN                                │
│ [📊] Dashboard                             │
│ [👥] Users                                 │
│ [🏢] Workspaces                            │
│ [💳] Subscriptions                         │
│ [📋] Moderation                            │
│ [🤖] AI Operations                         │
│ [📦] Commerce                              │
│ [🔧] System                                │
│ [📈] Analytics                              │
│ [🎧] Support                               │
│ [📜] Audit Log                              │
│ [🚩] Feature Flags                          │
└─────────────────────────────────────────────┘
```

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-28 | 1.0 | Initial specification |

---

## 2. Preconditions / Postconditions
### Preconditions
- User authenticated with valid session
- Required module permissions granted
### Postconditions
- User actions persisted to backend
- Analytics events dispatched

---

## 4. Component Hierarchy
```
NavigationPatternsPage
├── AppShell (shared)
├── PageHeader (Breadcrumb + Title + Actions)
├── ContentArea
│   ├── PrimarySection
│   │   └── [Items per wireframe]
│   └── SecondarySection
└── AppFooter
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
