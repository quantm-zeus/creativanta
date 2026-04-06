# Screen: Admin — Support Queue

> **Screen ID**: A026
> **Module**: S26 — Support Operations
> **Route**: `/admin/support`
> **Platform**: Web (SvelteKit) — VPN-only
> **Upstream**: A1 Schema (`support_tickets`, `support_ticket_messages`, `kb_articles`), A3 API (`SupportService/GetMyTickets`, `SupportService/GetTicket`, `SupportService/ListMessages`, `SupportService/Assign`, `SupportService/Escalate`, `SupportService/Reply`, `SupportService/Close`, `KBService/Search`), B5 RBAC §3

---

## 1. Purpose & Context

Admin support queue — manages user support tickets with priority-based SLA tracking. Shows ticket list, assignment, response times, and escalation status.

### User Story
> As a support agent, I want to see all support tickets sorted by priority with SLA timers so I can handle critical issues first.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ 🎫 Support Queue (23 open)      [Filter ▾] [Assigned to ▾]        │
├──────────────────────────────────────────────────────────────────────┤
│ SLA: 🔴 5 breaching · 🟡 8 at risk · 🟢 10 on track                │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Ticket (critical) ────────────────────────────────────────────┐  │
│ │ #T-1234 [🔴 Critical] "Cannot publish to TikTok"              │  │
│ │ User: quanm@gmail.com · Plan: Pro · Created: 30m ago           │  │
│ │ SLA: ⏰ 30m remaining (target: 1h) · Assigned: None            │  │
│ │ [→ Open] [👤 Assign to me] [⬆ Escalate]                       │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Ticket (high) ────────────────────────────────────────────────┐  │
│ │ #T-1235 [🟡 High] "AI credit not deducted correctly"          │  │
│ │ User: lehoaa@gmail.com · Plan: Starter · Created: 2h ago       │  │
│ │ SLA: ⏰ 2h remaining (target: 4h) · Assigned: Agent Minh      │  │
│ │ [→ Open] [💬 Reply]                                            │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ [Tải thêm ↓]                                                        │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
AdminSupportQueuePage
├── AdminShell
├── PageHeader (Title + OpenCount, Filters)
├── SLASummaryBar (breaching, at risk, on track)
└── TicketList
    └── TicketRow[]
        ├── TicketNumber
        ├── PriorityBadge (Critical/High/Normal/Low)
        ├── Subject
        ├── UserInfo (email, plan)
        ├── CreatedTime
        ├── SLATimer (countdown with color)
        ├── AssigneeInfo
        └── ActionButtons (Open, Assign, Escalate, Reply)
```

---

## 4-5. Data & Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Open ticket | "→ Open" | — | → `/admin/support/[id]` | `admin:support:manage` |
| 2 | Assign to me | "👤 Assign to me" | `SupportService/Assign(id, me)` | Assigned | `admin:support:manage` |
| 3 | Escalate | "⬆ Escalate" | `SupportService/Escalate(id)` | Priority raised, notification | `admin:support:manage` |
| 4 | Reply | "💬 Reply" | — | → `/admin/support/[id]#reply` | `admin:support:manage` |
| 5 | Close | In detail → "Close" | `SupportService/Close(id, resolution)` | Ticket closed | `admin:support:manage` |

---

## 6-20. Standard Sections

### SLA Rules
| Priority | Target | Escalation |
|---|---|---|
| Critical | 1h response | Auto-escalate at 45m |
| High | 4h response | Auto-escalate at 3h |
| Normal | 24h response | Auto-escalate at 20h |
| Low | 72h response | No auto-escalation |

### States
| State | Visual |
|---|---|
| LOADING | Row skeletons |
| LOADED | Priority-sorted ticket list |
| EMPTY | "Không có ticket nào! 🎉" |

### Technical Notes
- Route: `src/routes/admin/support/+page.svelte`
- SLA timer: real-time countdown
- Auto-sort: critical first, then by SLA urgency
- Notifications: push to admin when SLA at risk
- Related-article suggestions come from `kb_articles` for repeated issue clusters

### Related Screens
| Screen | Relationship |
|---|---|
| [A034] Knowledge Base Editor | Create/refresh article from repeated issue clusters |
| [A001] Admin Dashboard | Summary shown |

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-04-06 | 2.0 | Rebound queue screen to canonical support + KB contracts, removed generic data-binding placeholders and self-referential related-screen note. |
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

## 5. Data Binding & Display Format
| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Ticket queue | `support_tickets` | `SupportService/GetMyTickets` (admin-scoped filter) | Priority-sorted ticket rows | No cache |
| Ticket detail preview | `support_tickets` | `SupportService/GetTicket` | Drawer summary with SLA | No cache |
| Conversation preview | `support_ticket_messages` | `SupportService/ListMessages` | Latest reply snippet | No cache |
| SLA summary | `support_tickets` aggregation | same queue response | Breaching / at-risk counters | 30s TTL |
| KB suggestions | `kb_articles` | `KBService/Search` | Related article chips | 5m TTL |

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
