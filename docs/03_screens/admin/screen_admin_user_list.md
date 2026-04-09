# Screen: Admin — User Management

> **Screen ID**: A002
> **Module**: Admin — User Management
> **Route**: `/admin/users`
> **Platform**: Web (SvelteKit) — VPN-only
> **Upstream**: Admin Spec, A1 Schema (users, workspaces, subscriptions)

---

## 1. Purpose & Context

Admin User Management — list, search, and manage all platform users and their workspaces. Supports account actions (suspend, verify, reset), workspace inspection, and subscription management.

### User Story
> As a Creativanta admin, I want to search for users, view their workspace details, and take administrative actions when needed.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ 👥 Quản lý người dùng (5,678 users)     [🔍 Search] [+ Invite]    │
├──────────────────────────────────────────────────────────────────────┤
│ Filter: [Plan ▾] [Status ▾] [Registered ▾] [Sort ▾]               │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ User Row ──────────────────────────────────────────────────────┐ │
│ │ [😊] Quân Nguyễn          quanm@gmail.com     [🟢 Active]     │ │
│ │ Plan: Pro · Workspaces: 2 · Registered: 15/01/2026             │ │
│ │ AI Credits used: 450/1000 · Storage: 2.3GB/10GB                │ │
│ │ Last login: 2h ago · MRR contribution: 499K VND                │ │
│ │ [→ Detail] [📧 Email] [⚠️ Suspend] [🔑 Reset pwd]            │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ User Row ──────────────────────────────────────────────────────┐ │
│ │ [😐] Test User            test@test.com       [🔴 Suspended]   │ │
│ │ Plan: Free · Workspaces: 1 · Registered: 20/03/2026            │ │
│ │ Reason: Abuse · Suspended: 25/03/2026 by Admin                 │ │
│ │ [→ Detail] [🟢 Reactivate]                                     │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ Showing 1-20 of 5,678    [← Prev] [1] [2] [3] ... [284] [Next →] │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
AdminUserListPage
├── AdminShell
├── PageHeader (Title + Count, Search, InviteButton)
├── FilterBar (Plan, Status, Date range, Sort)
└── UserList
    └── UserRow[]
        ├── Avatar + UserName
        ├── Email
        ├── StatusBadge
        ├── PlanBadge
        ├── WorkspaceCount
        ├── UsageMetrics (credits, storage)
        ├── LastLogin
        ├── MRRContribution (if paid)
        ├── SuspensionReason (if suspended)
        └── ActionButtons
            ├── DetailLink
            ├── EmailButton
            ├── SuspendButton / ReactivateButton
            └── ResetPasswordButton
```

---

## 4-5. Data & Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | View detail | "→ Detail" | — | → `/admin/users/[id]` | `admin:user:read` |
| 2 | Search | Search input | Meilisearch | Results filter | `admin:user:read` |
| 3 | Suspend | "⚠️ Suspend" → reason → confirm | `AdminUserService/Suspend(id, reason)` | Status → Suspended | `admin:user:suspend` |
| 4 | Reactivate | "🟢 Reactivate" | `AdminUserService/Reactivate(id)` | Status → Active | `admin:user:suspend` |
| 5 | Reset password | "🔑 Reset" → confirm | `AdminUserService/ResetPassword(id)` | Email sent | `admin:user:suspend` |
| 6 | Send email | "📧 Email" → compose modal | `AdminEmailService/Send(to, subject, body)` | Email sent | `admin:user:read` |
| 7 | Invite | "+ Invite" → email input | `AdminUserService/Invite(email)` | Invitation sent | `admin:user:read` |

---

## 6-20. Standard Sections

### Admin Role Requirements
- Only `admin:user:read` + `admin:user:suspend` permissions (Super Admin, Operations Admin roles)
- All actions logged to admin audit

### States
| State | Visual |
|---|---|
| LOADING | Row skeletons |
| LOADED | User list with pagination |
| EMPTY_SEARCH | "Không tìm thấy user" |

### Technical Notes
- Route: `src/routes/admin/users/+page.svelte`
- Pagination: server-side, 20 per page
- Search: Meilisearch `users` index

### Related Screens
| Screen | Relationship |
|---|---|
| [A003] User Detail | Individual user view |
| [A001] Admin Dashboard | Parent |

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

## 5. Data Binding & Display Format
| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Primary data | Parent screen state or canonical contract object(s) | Resolve via owning feature doc + API/schema contracts | Exact DTO fields from canonical contracts | Per endpoint policy |
| List items | Parent screen list/query contract(s) | Resolve via API endpoint map before implementation | Card or row layout per wireframe | Per endpoint policy |
| Summary stats | Parent screen aggregates/projections | Resolve via feature rules + API contracts | Count / KPI / chip formatting per screen | Short-lived cache only if contract allows |
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
