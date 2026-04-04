# Screen: Admin — Content Moderation Queue

> **Screen ID**: A015
> **Module**: Admin — Trust & Safety
> **Route**: `/admin/moderation`
> **Platform**: Admin Web (SvelteKit) — VPN-only
> **Upstream**: A1 Schema (moderation_queue), B5 RBAC §3

---

## 1. Purpose & Context
Content moderation queue — review AI-flagged or user-reported content. Approve/remove/warn with evidence and audit trail.
### Entry Points - Admin sidebar: "🛡 Moderation" / Dashboard: "Flagged" badge
### Exit Points - Action → logged in audit

---

## 2. Screen Layout
### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ 🛡 Content Moderation                      [Filter ▾] [Sort ▾]    │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Summary ──────────────────────────────────────────────────────┐  │
│ │ Pending: 8 · AI-flagged: 5 · User-reported: 3                │  │
│ │ Resolved today: 15 · Avg resolution: 3h                      │  │
│ └────────────────────────────────────────────────────────────────┘  │
│ ┌─ Moderation Item ─────────────────────────────────────────────┐  │
│ │ 🛡 Content: TikTok script "Buy followers..."                  │  │
│ │ Workspace: ws_abc · User: @spammer                           │  │
│ │ Flagged by: 🤖 AI (confidence: 92% spam)                    │  │
│ │ Content preview: "Get 10K followers for just 50K VND!..."    │  │
│ │ Rule violated: #3 — No follower sales                        │  │
│ │ Previous violations: 2 (warned 2×)                            │  │
│ │ [✅ Approve] [🗑 Remove] [⚠️ Warn] [⏸ Suspend user]       │  │
│ └────────────────────────────────────────────────────────────────┘  │
│ ┌─ Moderation Item ─────────────────────────────────────────────┐  │
│ │ 🛡 Content: Product listing "Fake brand..."                  │  │
│ │ Flagged by: 👤 User report                                    │  │
│ │ [✅ Approve] [🗑 Remove] [⚠️ Warn]                          │  │
│ └────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```
## 7. States
| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Shimmer |
| LOADED | Queue ready | Summary + items |
| EMPTY | Nothing pending | "✅ Queue clear!" |
| HIGH_VOLUME | > 20 pending | "🔴 High volume — prioritize P0" |
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
ContentModerationQueuePage
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
| [A016] Moderation Rules | Rule configuration |
| [A017] Abuse Reports | User reports |
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
