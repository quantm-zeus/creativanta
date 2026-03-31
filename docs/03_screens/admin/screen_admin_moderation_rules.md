# Screen: Admin — Moderation Rules

> **Screen ID**: A10
> **Module**: Admin — Trust & Safety
> **Route**: `/admin/moderation/rules`
> **Platform**: Admin Web (SvelteKit) — VPN-only
> **Upstream**: A1 Schema (moderation_rules), B5 RBAC §3

---

## 1. Purpose & Context
Configure content moderation rules — keyword lists, AI detection thresholds, auto-actions on violations, and escalation policies.
### Entry Points - Moderation (A09): "⚙️ Rules" button
### Exit Points - Self-contained

---

## 2. Screen Layout
### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ ⚙️ Moderation Rules                              [+ New rule]      │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Rule Card ───────────────────────────────────────────────────┐   │
│ │ #1 "No follower sales" · [🟢 Active]                          │   │
│ │ Type: Keyword + AI · Keywords: "buy followers", "get fans"    │   │
│ │ AI threshold: 85% · Auto-action: Flag for review              │   │
│ │ Triggered: 45 times (30d) · False positive rate: 3%           │   │
│ │ [✏ Edit] [⏸ Disable]                                         │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Rule Card ───────────────────────────────────────────────────┐   │
│ │ #2 "Adult content" · [🟢 Active]                               │   │
│ │ Type: AI image classification · Threshold: 90%                │   │
│ │ Auto-action: Auto-remove + warn user                          │   │
│ │ Triggered: 12 times (30d) · FP rate: 1%                      │   │
│ │ [✏ Edit] [⏸ Disable]                                         │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Rule Card ───────────────────────────────────────────────────┐   │
│ │ #3 "Scam/fraud patterns" · [🟢 Active]                       │   │
│ │ Type: AI behavior analysis · Threshold: 80%                   │   │
│ │ Auto-action: Auto-suspend + notify admin                      │   │
│ │ Triggered: 5 times (30d) · FP rate: 5%                       │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Escalation Policy ──────────────────────────────────────────┐    │
│ │ 1st violation: Warn · 2nd: Temp suspend (24h) · 3rd: Ban    │    │
│ │ [✏ Edit policy]                                               │    │
│ └────────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────┘
```
## 7. States
| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Shimmer |
| LOADED | Rules listed | Rule cards + policy |
| EDITING | Rule form open | Modal editor |
| HIGH_FP | FP rate > 10% | "⚠️ High false positive rate — review rule" |
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
ModerationRulesPage
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
| [A09] Moderation Queue | Uses these rules |
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
