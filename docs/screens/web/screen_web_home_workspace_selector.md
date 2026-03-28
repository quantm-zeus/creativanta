# Screen: Web — Workspace Selector

> **Screen ID**: W02
> **Module**: M01 — Home & Decision
> **Route**: `/workspaces`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §8, A1 Schema (workspaces, workspace_members)

---

## 1. Purpose & Context

The Workspace Selector is the first screen after Clerk authentication. Users with multiple workspaces choose which to enter. Users with a single workspace are auto-redirected to Home Dashboard (`/`). Also accessible anytime via the workspace dropdown in the sidebar.

### User Story
> As a user with multiple workspaces (e.g., personal brand + agency clients), I want to easily switch between them so I can manage each independently.

### Entry Points
- After login (if >1 workspace)
- Sidebar: Workspace dropdown → "Đổi workspace"
- Direct URL: `/workspaces`

### Exit Points
- Click workspace card → `/` (Home Dashboard of selected workspace)
- Click "Tạo workspace mới" → Workspace creation flow

---

## 2. Layout Structure

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | Centered container (800px max-width), grid of workspace cards |
| Tablet (768-1279px) | Centered container (600px max-width), 2-column grid |
| Mobile (≤767px) | Full-width, single column stack |

### ASCII Wireframe
```
┌──────────────────────────────────────────────────────────────────────┐
│                                                                      │
│         🏢 Chọn Workspace                    [+ Tạo mới]            │
│                                                                      │
│         ┌─ Workspace Card ──────────────────────────────────┐       │
│         │ [🟢] Thương hiệu cá nhân — Quân                   │       │
│         │ Plan: Pro · 3 thành viên · 5 platforms connected   │       │
│         │ Last active: 2 giờ trước                           │       │
│         │ Role: Owner                                         │       │
│         │ [→ Mở]                                             │       │
│         └────────────────────────────────────────────────────┘       │
│                                                                      │
│         ┌─ Workspace Card ──────────────────────────────────┐       │
│         │ [🟢] Agency Client: ABC Corp                       │       │
│         │ Plan: Team · 8 thành viên · 3 platforms            │       │
│         │ Last active: 1 ngày trước                          │       │
│         │ Role: Manager                                       │       │
│         │ [→ Mở]                                             │       │
│         └────────────────────────────────────────────────────┘       │
│                                                                      │
│         ┌─ Workspace Card (invited) ────────────────────────┐       │
│         │ [🔵] Team Hoa: Skincare Brand                      │       │
│         │ Plan: Starter · Invited · Role: Editor             │       │
│         │ [✅ Accept invite] [❌ Decline]                    │       │
│         └────────────────────────────────────────────────────┘       │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
WorkspaceSelectorPage
├── PageHeader
│   ├── Title ("Chọn Workspace")
│   └── CreateButton ("+ Tạo mới")
├── WorkspaceGrid
│   └── WorkspaceCard[]
│       ├── StatusIndicator (🟢 active / 🟡 suspended / 🔴 deactivated)
│       ├── WorkspaceName
│       ├── PlanBadge
│       ├── MemberCount
│       ├── PlatformCount
│       ├── LastActiveTime
│       ├── RoleBadge
│       └── ActionButton ("→ Mở" or Accept/Decline for invites)
└── CreateWorkspaceModal (trigger: "Tạo mới")
    ├── NameInput
    ├── IndustrySelector
    ├── PlanSelector
    └── ConfirmButton
```

---

## 4. Data Binding & Display Format

| UI Element | Data Source | API | Display Format |
|---|---|---|---|
| Workspace name | `workspaces.name` | `WorkspaceService/ListMy` | Text |
| Plan | `workspaces.plan_type` | same | Badge: "Starter" / "Pro" / "Team" / "Enterprise" |
| Member count | `COUNT(workspace_members)` | same | "{n} thành viên" |
| Platform count | `COUNT(connectors WHERE active)` | same | "{n} platforms connected" |
| Last active | `workspaces.last_activity_at` | same | Relative time ("2 giờ trước") |
| Role | `workspace_members.role` | same | Role badge |
| Status | `workspaces.status` | same | Color indicator |

---

## 5. Actions Table

| # | Action | Trigger | API Call | UI Result | Permission |
|---|---|---|---|---|---|
| 1 | Open workspace | Click card or "→ Mở" | `WorkspaceService/SetCurrent(id)` | Navigate → `/` with workspace context | Any member |
| 2 | Create workspace | Click "Tạo mới" → fill form | `WorkspaceService/Create` | New card appears + auto-redirect | Any authenticated |
| 3 | Accept invite | Click "✅ Accept" on invited workspace | `WorkspaceService/AcceptInvite` | Card updates to normal state | Invited user |
| 4 | Decline invite | Click "❌ Decline" → confirm | `WorkspaceService/DeclineInvite` | Card removed | Invited user |

---

## 6. State Machine

| State | Visual | Trigger |
|---|---|---|
| LOADING | Skeleton cards (3 placeholders) | Page load |
| LOADED | All workspace cards rendered | API response |
| EMPTY | "Chưa có workspace. Tạo workspace đầu tiên!" + Create CTA | No workspaces found |
| SINGLE | Auto-redirect to `/` | Only 1 workspace |
| ERROR | "Không thể tải danh sách workspace" + retry | API error |

---

## 7. Validation Rules

### Create Workspace Form
| Field | Rule | Error Message |
|---|---|---|
| Name | Required, 3-50 chars, unique per user | "Tên workspace phải từ 3-50 ký tự" |
| Industry | Required (select) | "Hãy chọn ngành nghề" |

---

## 8. Permission Matrix

| Action | Any Authenticated | Member | Owner |
|---|---|---|---|
| View workspace list | ✅ (own workspaces only) | — | — |
| Create workspace | ✅ | — | — |
| Open workspace | — | ✅ | ✅ |
| Accept/decline invite | ✅ (when invited) | — | — |

---

## 9. Navigation Map

```
Workspace Selector (/workspaces)
├── → / (Home Dashboard)                    (via Open workspace)
├── → /workspaces/create                     (via Create workspace)
└── ← /auth/login                           (back to login)
```

---

## 10. Error Handling

| Error | UI Response | Recovery |
|---|---|---|
| Create fails (409 conflict) | Toast "Tên workspace đã tồn tại" | Edit name |
| Accept invite fails | Toast "Lời mời đã hết hạn" + card hidden | — |
| Network error | Full page error + retry | Retry button |

---

## 11-20. Standard Sections

### Accessibility
- Cards are `role="button"` with `aria-label="Mở workspace [name]"`
- Keyboard: Tab between cards, Enter to open

### Loading Behavior
- SSR renders page shell
- Client fetches workspace list (< 500ms typical)
- Auto-redirect if single workspace (no flash)

### Performance
- LCP < 1.0s (simple page)
- No heavy assets

### Localization
- All text in Vietnamese
- Date: relative time format

### Design Tokens
- `--color-surface-card` for card backgrounds
- `--color-accent` for plan badges
- `--radius-card` for card corners

### Technical Notes
- Route: `src/routes/(auth)/workspaces/+page.svelte`
- Server load: `+page.server.ts` → `WorkspaceService/ListMy`
- Redirect logic in `handle` hook if single workspace

### Related Screens
| Screen | Relationship |
|---|---|
| [W01] Home Dashboard | Target after workspace selection |
| Auth/Login | Entry point |

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-27 | 1.0 | Initial specification |

---

## 2. Preconditions / Postconditions
### Preconditions
- User authenticated with valid session
- Required module permissions granted
### Postconditions
- User actions persisted to backend
- Analytics events dispatched

---

## 15. Real-time Updates
| Data | Channel | Frequency |
|---|---|---|
| Critical data | SSE or polling | Based on data criticality |
| Non-critical | On-demand refresh | User-triggered |

---

## 17. Analytics / Tracking Events
| Event | Trigger | Properties |
|---|---|---|
| `workspace_selector.viewed` | Screen load | `source` |
| `workspace_selector.action` | Primary user action | `action_type`, relevant IDs |
| `workspace_selector.error` | Error occurred | `error_type`, `error_code` |
