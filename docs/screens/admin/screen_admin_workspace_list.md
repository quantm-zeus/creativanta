# Screen: Admin — Workspace List

> **Screen ID**: A004
> **Module**: Admin — Workspace Management (S26)
> **Route**: `/admin/workspaces`
> **Platform**: Admin Web (SvelteKit) — VPN-only access
> **Upstream**: Product Freeze §4, A1 Schema (workspaces, subscriptions, users), B5 RBAC §3 (Admin 8-role)

---
## 1. Purpose & Context

The Workspace List is the master registry of all Creativanta workspaces. Admin operators use this screen to monitor workspace health, investigate issues, manage subscriptions, and take administrative actions (suspend, credit adjustment, plan override). This is the primary workspace management surface for Operations, Finance, and Super Admin roles.

### User Goals
- Search and find specific workspaces by name, owner email, or workspace ID
- Assess workspace health (plan status, activity, MRR contribution)
- Take administrative actions (suspend, upgrade, grant credits, investigate)
- Monitor growth metrics (new sign-ups, churn, trial conversions)

### Business Goals
- Enable efficient workspace management at scale
- Track MRR and churn metrics for business health
- Support customer success through workspace-level visibility
- Enable rapid response to abuse reports or billing issues

### When This Screen Is Used
- Daily: Customer success team reviewing new sign-ups and trial workspaces
- On-demand: Investigating support tickets linked to specific workspaces
- Weekly: Business review of MRR, churn, and growth metrics
- On-alert: Responding to abuse reports or suspicious activity flags

### Entry Points
- Admin sidebar: "🏢 Workspaces"
- Admin Dashboard (A001): click workspace count KPI
- User Detail (A003): "View workspace" link
- Support Ticket (A026): linked workspace
- Search: admin command bar → workspace search

### Exit Points
- Click row → Workspace Detail (A005)
- Click owner email → User Detail (A003)
- Click subscription → Subscription Overview (A021)

---
## 2. Preconditions / Postconditions

### Preconditions
- Admin user is on VPN (IP allowlist verified)
- Admin MFA verified
- Admin has role with workspace read access (Super Admin, Operations Admin, Finance Admin, Support Admin — per B5 §3.2)

### Postconditions
- Page view logged in `admin_audit_log`
- Any action taken (suspend, credit adjust, etc.) logged with admin ID, IP, timestamp, affected workspace

---
## 3. Screen Layout

### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ 🏢 Workspaces (1,234)            [🔍 Search...         ] [📤 Export]│
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Growth Stats Bar ───────────────────────────────────────────────┐ │
│ │ Total: 1,234 │ Active: 1,100 │ Trial: 89 │ Suspended: 12       │ │
│ │ Churned: 45  │ MRR Total: 450M VND │ ARPU: 82K VND            │ │
│ │ This week: +23 new · 5 churned · 8 trial→paid · Net: +18       │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ Filters: [Plan ▾] [Status ▾] [Region ▾] [Created ▾] [Sort: MRR ▾] │
│                                                                      │
│ ┌─ Workspace Table ────────────────────────────────────────────────┐ │
│ │ ☐ │ Name             │ Owner        │ Plan │ Members│ MRR  │ St ││
│ │───│──────────────────│──────────────│──────│────────│──────│────││
│ │ ☐ │ Creativanta Stud │ quanng@gm..  │ 🟢Pro│ 3      │ 299K │ 🟢││
│ │   │ ID: ws_abc       │              │      │        │      │    ││
│ │───│──────────────────│──────────────│──────│────────│──────│────││
│ │ ☐ │ Beauty Hub       │ linh@ex..    │ 🟣Ent│ 8      │ 999K │ 🟢││
│ │   │ ID: ws_def       │ Last: 2h ago │      │        │      │    ││
│ │───│──────────────────│──────────────│──────│────────│──────│────││
│ │ ☐ │ Side Project     │ minh@ex..    │ ⚪Fre│ 1      │ 0    │ 🟢││
│ │   │ ID: ws_ghi       │ Last: 5d ago │      │ ⚠ low  │      │    ││
│ │───│──────────────────│──────────────│──────│────────│──────│────││
│ │ ☐ │ Demo Co          │ demo@ex..    │ 🟡Tri│ 1      │ 0    │ 🟡││
│ │   │ ID: ws_jkl       │ Trial: 5d    │      │        │      │ exp││
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ Per-row actions: [📧 Email owner] [⏸ Suspend] [💰 Credits]         │
│                  [📋 Copy ID] [⬆ Upgrade] [🗑 Delete]              │
│                                                                      │
│ Bulk actions (when selected): [⏸ Bulk Suspend] [📧 Bulk Email]     │
│                                                                      │
│ Pagination: ← 1 2 3 ... 62 → │ Showing 1-20 of 1,234 │ [20▾/page]│
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
AdminWorkspaceListPage
├── AdminShell
│   ├── AdminTopBar
│   └── AdminNav
├── PageHeader
│   ├── PageTitle ("🏢 Workspaces" + total count badge)
│   ├── SearchInput (full-text search: name, owner email, workspace ID)
│   └── ExportButton ("📤 Export CSV")
├── GrowthStatsBar
│   ├── StatCard[] (Total, Active, Trial, Suspended, Churned)
│   ├── MRRTotal (formatted VND)
│   ├── ARPUValue (computed MRR/active)
│   └── WeeklyDelta
│       ├── NewCount (+23)
│       ├── ChurnedCount (5)
│       ├── ConvertedCount (8 trial→paid)
│       └── NetChange (+18)
├── FilterBar
│   ├── PlanFilter (Free, Starter, Pro, Business, Enterprise, Trial)
│   ├── StatusFilter (Active, Suspended, Trial, Churned, Deleted)
│   ├── RegionFilter (Vietnam, SEA, Global)
│   ├── CreatedDateFilter (date range picker)
│   └── SortSelector (MRR desc, Created desc, Members desc, Last active)
├── WorkspaceTable
│   ├── SelectAllCheckbox
│   ├── ColumnHeaders (sortable)
│   └── WorkspaceRow[]
│       ├── RowCheckbox
│       ├── WorkspaceName (bold, clickable → A005)
│       ├── WorkspaceID (monospace, small, copyable)
│       ├── OwnerEmail (clickable → A003)
│       ├── LastActivity (relative time)
│       ├── PlanBadge (colored: 🟢Pro, 🟣Enterprise, 🟡Trial, ⚪Free)
│       ├── MemberCount (with warning if 0 active)
│       ├── MRRValue (VND formatted)
│       ├── StatusBadge (🟢Active, 🟡Trial expiring, 🔴Suspended, ⚫Churned)
│       └── RowActionMenu (hover reveal)
│           ├── EmailOwner ("📧")
│           ├── SuspendToggle ("⏸" / "▶")
│           ├── AdjustCredits ("💰")
│           ├── CopyID ("📋")
│           ├── UpgradePlan ("⬆")
│           └── DeleteWorkspace ("🗑", Owner+Super Admin only)
├── BulkActionBar (appears when ≥1 row selected)
│   ├── SelectedCount
│   ├── BulkSuspendButton
│   ├── BulkEmailButton
│   └── ClearSelectionButton
└── PaginationControls
    ├── PageButtons (1, 2, 3, ... N)
    ├── PageSizeSelector (20, 50, 100)
    └── ResultCountLabel ("Showing 1-20 of 1,234")
```

---
## 5. Displayed Data

| Column | Source | API | Display Format | Sortable |
|---|---|---|---|---|
| Workspace Name | `workspaces.display_name` | `AdminService/ListWorkspaces` | Bold text, max 30 chars | Yes |
| Workspace ID | `workspaces.workspace_id` | same | Monospace `ws_abc...` | No |
| Owner | `users.email` (via owner_id join) | same | Truncated email | Yes |
| Last Activity | `workspace_sessions.last_active_at` | same | Relative time ("2h ago") | Yes |
| Plan | `subscriptions.plan_type` | same | Colored badge | Yes |
| Members | `COUNT(workspace_members)` | same | Integer (⚠ if 0 active) | Yes |
| MRR | `subscriptions.monthly_amount` | same | VND formatted | Yes (default desc) |
| Status | `workspaces.status` | same | Status badge | Yes |
| Trial remaining | Computed (trial_end - now) | same | "5d left" (if trial) | Yes |

### Growth Stats Data
| Stat | Source | API | Refresh |
|---|---|---|---|
| Total count | `COUNT(workspaces)` | `AdminService/GetWorkspaceStats` | 60s polling |
| Active count | `WHERE status='active'` | same | 60s |
| Trial count | `WHERE plan='trial'` | same | 60s |
| Suspended | `WHERE status='suspended'` | same | 60s |
| Churned | `WHERE status='churned'` | same | 60s |
| MRR Total | `SUM(subscriptions.monthly_amount)` | same | 5m |
| ARPU | `MRR / active_count` | computed | 5m |
| Weekly delta | 7-day window aggregation | same | 5m |

---
## 6. User Actions

| # | Action | Trigger | Type | API Call | System Response | Permission |
|---|---|---|---|---|---|---|
| 1 | Search | Type in search input (debounce 300ms) | Filter | `AdminService/ListWorkspaces(query)` | Table refreshes with results | `admin:workspace:read` (all admin roles except Content) |
| 2 | Filter | Change any filter dropdown | Filter | Refetch with filters | Table refreshes | Same |
| 3 | Sort | Click column header | Sort | Refetch with sort | Table re-sorts | Same |
| 4 | View workspace | Click row name | Navigate | — | → A005 Workspace Detail | Same |
| 5 | View owner | Click owner email | Navigate | — | → A003 User Detail | `admin:user:read` |
| 6 | Suspend workspace | "⏸ Suspend" → confirm reason | Destructive | `AdminService/SuspendWorkspace(id, reason)` | Confirmation dialog → status → 🔴 → toast "Workspace đã bị tạm ngưng" | `admin:user:suspend` (Super, Ops) |
| 7 | Unsuspend | "▶ Unsuspend" → confirm | Action | `AdminService/UnsuspendWorkspace(id)` | Status → 🟢 → toast | `admin:user:suspend` |
| 8 | Adjust credits | "💰 Credits" → modal | Action | `AdminService/AdjustCredits(ws_id, amount, reason)` | Modal: amount + reason → toast "Đã điều chỉnh {amount} credits" | `admin:credits:adjust` (Super, Ops, Finance) |
| 9 | Upgrade plan | "⬆ Upgrade" → plan picker | Action | `AdminService/OverridePlan(ws_id, plan, reason)` | Modal: plan + reason + duration → toast | `admin:plan:override` (Super, Ops, Finance) |
| 10 | Email owner | "📧" → compose in mail client | Action | `mailto:{owner_email}` | Opens mail client | Any admin role |
| 11 | Copy workspace ID | "📋" | Action | — (clipboard) | Toast: "ID đã copy" | Any |
| 12 | Delete workspace | "🗑" → triple confirm | Destructive | `AdminService/DeleteWorkspace(id, reason)` | Triple confirmation (type workspace name) → permanently deleted | `admin:user:delete` (Super Admin ONLY) |
| 13 | Export | "📤 Export" | Bulk | `AdminService/ExportWorkspaces(filters)` | CSV download with current filters applied | `admin:report:export` |
| 14 | Bulk suspend | Select rows → "⏸ Bulk Suspend" | Destructive | `AdminService/BulkSuspend(ids[], reason)` | Confirmation → all suspended | `admin:user:suspend` |
| 15 | Change page | Click page number | Paginate | Refetch with offset | Table updates | Any |

---
## 7. Validation Rules

### Suspend Action
| Field | Rule | Error |
|---|---|---|
| Reason | Required, min 10 chars | "Vui lòng nhập lý do (tối thiểu 10 ký tự)" |

### Credit Adjustment
| Field | Rule | Error |
|---|---|---|
| Amount | Required, integer, -10000 to +10000 | "Số lượng credit không hợp lệ" |
| Reason | Required, min 10 chars | "Vui lòng nhập lý do" |

### Plan Override
| Field | Rule | Error |
|---|---|---|
| Plan | Required, must be valid plan | "Chọn gói subscription" |
| Duration | Required (permanent / until date) | "Chọn thời hạn" |
| Reason | Required, min 10 chars | "Vui lòng nhập lý do" |

### Delete Workspace
| Field | Rule | Error |
|---|---|---|
| Workspace name confirmation | Must exactly match workspace display name | "Tên workspace không khớp" |
| Reason | Required, min 20 chars | "Vui lòng nhập lý do chi tiết" |
| Second confirmation | Must type "DELETE" | "Nhập 'DELETE' để xác nhận" |

---
## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial page load | Stats bar shimmer + table skeleton rows | Wait |
| LOADED | Data received | Full stats + populated table | Interact normally |
| EMPTY | No workspaces (impossible in prod but handled) | "Chưa có workspace nào." | — |
| EMPTY_FILTERED | Filters active, no matches | "Không tìm thấy workspace phù hợp với bộ lọc. [Xóa bộ lọc]" | Clear filters |
| EMPTY_SEARCH | Search query, no results | "Không tìm thấy workspace '{query}'." | Modify search |
| ERROR | API failed | "Không tải được danh sách workspace. [Thử lại]" | Retry |
| ACTION_PENDING | Admin action in progress | Row shows spinner, action button disabled | Wait |
| ACTION_SUCCESS | Admin action completed | Toast success + row updated | Continue |
| ACTION_ERROR | Admin action failed | Toast error: "Thao tác thất bại: {reason}. [Thử lại]" | Retry |

---
## 9. Permissions & Role-based Behavior (Admin 8-Role per B5 §3)

| Feature | Super | Ops | Finance | Content | Support | Tech | Analyst | Auditor |
|---|---|---|---|---|---|---|---|---|
| View workspace list | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ | ✅ | ✅ |
| View MRR/ARPU | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ | ✅ |
| Search/filter | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ | ✅ | ✅ |
| Suspend/unsuspend | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Adjust credits | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Override plan | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Delete workspace | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Export | ✅ | ✅ | ✅ | ❌ | ❌ | ✅ | ✅ | ✅ |
| Bulk actions | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |

### Visibility Rules
- **Support Admin**: Can view workspace list + details (for support context) but no financial columns (MRR hidden). No action buttons except "📧 Email".
- **Analyst/Auditor**: Read-only. See all data including MRR for reporting. No action buttons.
- **Content Admin**: No access to workspace list. Redirect to "Access denied."
- **Tech Admin**: Can view for system debugging. No financial actions.

---
## 10. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Growth stats | Polling | Every 60 seconds |
| Table data | Manual refresh / on filter change | On-demand |
| Workspace status changes | SSE | Real-time (if another admin suspends a workspace while you're viewing) |

---
## 11. Technical Implementation Notes

- **Route**: `src/routes/admin/workspaces/+page.svelte`
- **Server load**: `+page.server.ts` → validate admin auth + VPN → fetch first page + stats
- **Search**: Server-side PostgreSQL full-text search (workspace name + owner email + workspace ID)
- **Pagination**: Server-side offset/limit (not cursor — admin needs page numbers)
- **Export**: Server generates CSV with current filter params, streams to browser download
- **Audit**: Every page view and action logged to `admin_audit_log` table with IP and admin user

---
## 12. Edge Cases

| Edge Case | Handling |
|---|---|
| Workspace with null owner | Show "⚠️ No owner" — likely a system workspace or orphaned |
| Trial workspace expired today | Show "🔴 Trial expired" badge, auto-status check on load |
| Workspace with >100 members | Show member count normally, no special treatment |
| Admin suspends workspace they're currently viewing | Status updates in real-time |
| Export with >10,000 results | Background job → email admin when CSV ready |
| Delete workspace with active subscriptions | Block deletion: "Workspace có subscription active. Hủy subscription trước." |
| Workspace in deletion queue | Show "🔴 Pending Delete (3d grace period)" — can be restored |

---
## 13. Navigation Map

```
Admin Workspace List (/admin/workspaces)
├── → /admin/workspaces/[id] (click row → Workspace Detail)
├── → /admin/users/[id] (click owner email → User Detail)
├── → /admin/subscriptions (via plan badge click)
├── → /admin (breadcrumb → Admin Dashboard)
```

---
## 14. Accessibility

| Element | Requirement |
|---|---|
| Table | `role="table"`, `aria-label="Danh sách workspace"` |
| Sortable headers | `aria-sort="ascending/descending/none"` |
| Row selection | `aria-checked` on checkboxes |
| Status badges | `aria-label` with full status text ("Trạng thái: đang hoạt động") |
| Action buttons | `aria-label` with workspace context ("Tạm ngưng workspace: Beauty Hub") |
| Pagination | `role="navigation"`, `aria-label="Phân trang"`, current page `aria-current="page"` |
| Search | `role="searchbox"`, `aria-label="Tìm kiếm workspace"` |


---
## 19. Related Screens

| Screen | Relationship |
|---|---|
| [A001] Admin Dashboard | Parent (linked via workspace count KPI) |
| [A003] User Detail | Owner lookup |
| [A005] Workspace Detail | Drill-down |
| [A021] Subscriptions | Plan management |
| [A010] Audit Log | Action audit trail |
| [A026] Support Queue | Support ticket context |
---
## Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached data | Pull-to-refresh when online |
| API error | Server 5xx | Toast: "Không tải được dữ liệu. [Thử lại]" | Retry |
| Not found | 404 | "Không tìm thấy" → navigate back | Back |
| Permission denied | 403 | "Không có quyền truy cập" | Contact admin |

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
