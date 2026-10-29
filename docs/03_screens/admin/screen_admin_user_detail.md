# Screen: Admin — User Detail

> **Screen ID**: A003
> **Module**: Admin — User Management (S26)
> **Route**: `/admin/users/[id]`
> **Platform**: Admin Web (SvelteKit) — VPN-only access
> **Upstream**: Product Freeze §27, A1 Schema (users, user_sessions, workspaces, `ai_credit_transactions`, content), B5 RBAC §3 (Admin 8-role)

---
## 1. Purpose & Context

The User Detail screen is the comprehensive profile investigation surface for admin operators. It displays full account information, workspace memberships, activity timeline, credit usage, content statistics, risk scoring, and admin actions (suspend, impersonate, grant credits, delete). This is the primary screen used by Operations and Support admins when investigating user issues or support tickets.

### User Goals
- Investigate user account for support ticket resolution
- Assess user risk level (abuse, fraud, suspicious activity)
- Take administrative actions (suspend, credit adjustment, plan override)
- Impersonate user to reproduce reported issues (OTP-secured)

### Business Goals
- Enable rapid support ticket resolution (target: < 15min per ticket)
- Detect and act on abuse/fraud through risk scoring
- Support customer success through proactive engagement
- Maintain audit trail for all admin actions on user accounts

### When This Screen Is Used
- Support ticket investigation: User reports issue → admin looks up user
- Abuse/fraud investigation: Flagged user → review activity + risk score
- Customer success: Proactive outreach to high-value or at-risk users
- Audit/compliance: Reviewing user data access history

### Entry Points
- User List (A002): click user row
- Workspace Detail (A005): click owner/member email
- Support Queue (A026): "View user" link on ticket
- Admin search: command bar → user search by email/ID

### Exit Points
- Workspace links → Workspace Detail (A005)
- "← Users" → User List (A002)
- Audit log links → Audit Log (A010)

---
## 2. Preconditions / Postconditions

### Preconditions
- Admin on VPN with MFA verified
- Admin has user read access (Super, Ops, Support, Finance, Tech, Analyst, Auditor — per B5 §3.2)
- User ID exists in system

### Postconditions
- Page view logged in `admin_audit_log` (who viewed which user)
- Any admin action logged with admin ID, IP, timestamp, reason, affected user
- Impersonate sessions logged with start time, duration, and all actions taken

---
## 3. Screen Layout

### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ ← Users   👤 Nguyễn Quân                     [⋮ Actions ▾]        │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Profile Header ────────────────────────────────────────────────┐ │
│ │ [Avatar 64px]  Nguyễn Quân                                      │ │
│ │                quanng@email.com · Phone: 090.xxx.xxxx            │ │
│ │                                                                  │ │
│ │ Status: 🟢 Active   Plan: Pro   Since: Jan 2026 (3 months)     │ │
│ │ Last login: 2h ago · Method: Google OAuth · IP: 103.xxx.xxx     │ │
│ │ Device: iPhone 15 Pro / Chrome macOS Sequoia                     │ │
│ │ Locale: vi-VN · Timezone: Asia/Ho_Chi_Minh                      │ │
│ │ Risk score: 2/10 (Low ✅) · Abuse reports: 0                   │ │
│ │ User ID: user_abc123                      [📋 Copy ID]          │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ Tabs: [📊 Overview] [🏢 Workspaces (2)] [📜 Activity] [💰 Credits]│
│       [📝 Content] [🔐 Security] [📋 Tickets]                     │
│                                                                      │
│ ═══ Tab: Overview ═══                                                │
│ ┌─ Quick Stats ────────────────────────────────────────────────────┐ │
│ │ Workspaces: 2 │ Content: 156 │ Revenue: 28.5M │ Credits: 1,200 │ │
│ │ AI queries: 342 (30d) │ Logins: 45 (30d) │ Avg session: 23min  │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Account Health ─────────────────────────────────────────────────┐ │
│ │ ✅ Email verified : 2026-01-15                                   │ │
│ │ ✅ MFA enabled    : TOTP                                         │ │
│ │ ✅ Payment method : Credit card ending 4242                     │ │
│ │ ⚠️ No recovery email set                                        │ │
│ │ Risk factors: None detected                                      │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ═══ Tab: Workspaces ═══                                              │
│ ┌─ Workspace Card ─────────────────────────────────────────────────┐ │
│ │ 🏢 Creativanta Studio · Role: Owner · Plan: Pro · MRR: 299K   │ │
│ │ Members: 3 · Status: 🟢 Active · Created: Jan 2026            │ │
│ │ [→ View workspace] [📧 Email members]                           │ │
│ ├──────────────────────────────────────────────────────────────────┤ │
│ │ 🏢 Side Project · Role: Editor · Plan: Free · MRR: 0          │ │
│ │ Members: 5 · Status: 🟢 Active · Joined: Feb 2026            │ │
│ │ [→ View workspace]                                               │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ═══ Tab: Activity (timeline) ═══                                     │
│ ┌─ Activity Timeline ──────────────────────────────────────────────┐ │
│ │ Filter: [All ▾] [Date range ▾]                                   │ │
│ │                                                                    │ │
│ │ 🟢 2h ago  · Login · Chrome macOS · 103.xxx.xxx                 │ │
│ │ 📤 3h ago  · Published TikTok video "5 tips nấu ăn"            │ │
│ │ ✏️ 5h ago  · Created script "Skincare morning routine"          │ │
│ │ 🤖 6h ago  · AI query: "Tạo ý tưởng skincare" · 2 credits     │ │
│ │ 💰 1d ago  · Order #12345 received · 350K VND                  │ │
│ │ 🟢 1d ago  · Login · iPhone 15 Pro · 103.xxx.xxx               │ │
│ │ ...                                                                │ │
│ │ Pagination: ← 1 2 3 ... 15 →                                    │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ═══ Tab: Credits ═══                                                 │
│ ┌─ Credit Summary ─────────────────────────────────────────────────┐ │
│ │ Balance: 320 · Used (30d): 180 · Granted: 0 · Purchased: 500  │ │
│ │ Total lifetime: 1,200 used · $0.24 avg cost/credit              │ │
│ │ [💰 Grant credits] [🔄 View full history]                      │ │
│ │                                                                    │ │
│ │ ── Transaction History ──                                         │ │
│ │ 6h ago   · AI query          · -2   · Balance: 320              │ │
│ │ 1d ago   · AI video gen     · -5   · Balance: 322              │ │
│ │ 3d ago   · Monthly grant     · +100 · Balance: 327              │ │
│ │ 5d ago   · Purchase (100 cr) · +100·  Balance: 227              │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ═══ Tab: Security ═══                                                │
│ ┌─ Login History ──────────────────────────────────────────────────┐ │
│ │ IP: 103.xxx.xxx · Chrome macOS · 2h ago · 🟢 Normal           │ │
│ │ IP: 103.xxx.xxx · Safari iPhone · 1d ago · 🟢 Normal          │ │
│ │ IP: 192.xxx.xxx · Firefox Windows · 7d ago · 🟡 New device    │ │
│ ├──────────────────────────────────────────────────────────────────┤ │
│ │ Suspicious activity: None detected                               │ │
│ │ Active sessions: 2 (Chrome macOS, Safari iPhone)                │ │
│ │ [🔒 Force logout all] [🔑 Reset password]                      │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ═══ Admin Actions Panel (sticky bottom) ═══                          │
│ ┌──────────────────────────────────────────────────────────────────┐ │
│ │ [📧 Email user]   [💰 Grant credits]  [⬆ Override plan]       │ │
│ │ [⏸ Suspend user]  [👤 Impersonate]    [🗑 Delete account]     │ │
│ └──────────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
AdminUserDetailPage
├── AdminShell
├── PageHeader
│   ├── BackLink ("← Users")
│   ├── UserName (heading)
│   └── ActionsDropdown (⋮ Actions ▾)
├── ProfileHeader
│   ├── Avatar (64px, with online indicator)
│   ├── UserName + Email + Phone (partial masked)
│   ├── StatusBadge (🟢 Active / 🔴 Suspended / ⚫ Deleted)
│   ├── PlanBadge
│   ├── AccountAge ("Since Jan 2026")
│   ├── LastLoginInfo (time, method, IP, device)
│   ├── LocaleInfo (language + timezone)
│   ├── RiskScore (0-10 scale with color: Green ≤3, Yellow 4-6, Red ≥7)
│   ├── AbuseReportCount
│   └── UserIDCopy (monospace + copy button)
├── TabView
│   ├── OverviewTab
│   │   ├── QuickStats (6 metric cards)
│   │   └── AccountHealth (checklist: email verified, MFA, payment, recovery)
│   ├── WorkspacesTab
│   │   └── WorkspaceCard[]
│   │       ├── WorkspaceName (clickable → A005)
│   │       ├── UserRole (in this workspace)
│   │       ├── PlanBadge + MRR
│   │       ├── MemberCount + Status
│   │       └── ActionLinks (view, email members)
│   ├── ActivityTab
│   │   ├── FilterBar (activity type + date range)
│   │   └── ActivityTimeline
│   │       └── ActivityItem[]
│   │           ├── ActivityIcon (login/content/commerce/AI/admin)
│   │           ├── Timestamp
│   │           ├── Description
│   │           ├── Metadata (IP, device, amounts, etc.)
│   │           └── LinkToEntity (optional — click to view content/order)
│   ├── CreditsTab
│   │   ├── CreditSummary (balance, used, granted, purchased, lifetime)
│   │   ├── GrantCreditsButton
│   │   └── TransactionHistory
│   │       └── TransactionRow[] (time, type, delta, balance)
│   ├── ContentTab (summary of user's content across workspaces)
│   │   ├── ContentStats (ideas, scripts, assets, published)
│   │   └── RecentContentList (last 10 content items)
│   ├── SecurityTab
│   │   ├── LoginHistory (IP, device, location, anomaly flag)
│   │   ├── ActiveSessions
│   │   ├── SuspiciousActivityFlag
│   │   └── SecurityActions (force logout, reset password)
│   └── TicketsTab
│       └── RelatedTickets (support tickets involving this user)
│           └── TicketRow[] (ID, subject, status, date)
└── AdminActionsPanel (sticky bottom bar)
    ├── EmailButton ("📧")
    ├── GrantCreditsButton ("💰")
    ├── OverridePlanButton ("⬆")
    ├── SuspendButton ("⏸") / UnsuspendButton ("▶")
    ├── ImpersonateButton ("👤", OTP-secured)
    └── DeleteButton ("🗑", Super Admin only)
```

---
## 5. Displayed Data

| Section | Source | API | Cache |
|---|---|---|---|
| Profile | `users` table | `AdminService/GetUser(id)` | 5m |
| Workspaces | `workspace_members` + `workspaces` | `AdminService/GetUserWorkspaces(id)` | 5m |
| Activity | `user_activity_log` | `AdminService/GetUserActivity(id, filters)` | 2m |
| Credits | `ai_credit_transactions` + balance projection | `AdminService/GetUserCredits(id)` | 2m |
| Content | `ideas` + `scripts` + `assets` + `publish_items` | `AdminService/GetUserContentStats(id)` | 5m |
| Security | `user_sessions` + `login_history` | `AdminService/GetUserSecurity(id)` | 2m |
| Tickets | `support_tickets WHERE user_id` | `AdminService/GetRelatedTickets(id)` | 5m |
| Risk score | Computed: login patterns + abuse reports + content flags | Included in profile | 5m |

---
## 6. User Actions

| # | Action | Trigger | Type | API Call | System Response | Permission |
|---|---|---|---|---|---|---|
| 1 | View workspace | Click workspace name | Navigate | — | → A005 Workspace Detail | `admin:workspace:read` |
| 2 | Email user | "📧 Email user" | Action | `mailto:{user.email}` | Opens mail client | Any admin |
| 3 | Grant credits | "💰 Grant" → modal | Action | `AdminService/GrantCredits(user_id, amount, reason)` | Modal: amount + reason → toast "Đã cấp {amount} credits" | `admin:credits:adjust` (Super, Finance) |
| 4 | Override plan | "⬆ Override plan" → modal | Action | `AdminService/OverridePlan(user_id, plan, duration, reason)` | Modal → toast "Plan đã override" | `admin:plan:override` |
| 5 | Suspend user | "⏸ Suspend" → confirm | Destructive | `AdminService/SuspendUser(id, reason)` | Confirmation + reason → status 🔴 → user logged out | `admin:user:suspend` |
| 6 | Unsuspend | "▶ Unsuspend" → confirm | Action | `AdminService/UnsuspendUser(id, reason)` | Status 🟢 → toast | `admin:user:suspend` |
| 7 | Impersonate | "👤 Impersonate" → OTP → session | Sensitive | `AdminService/Impersonate(user_id, otp)` | OTP modal → new browser tab opens as user (read-only by default) → red banner "IMPERSONATING" | `admin:impersonate` (Super + Ops only) |
| 8 | Delete account | "🗑 Delete" → triple confirm | Destructive | `AdminService/DeleteUser(id, reason)` | Type email + "DELETE" + reason → permanently deleted | `admin:user:delete` (Super Admin ONLY) |
| 9 | Force logout | Security tab: "🔒 Force logout all" | Action | `AdminService/ForceLogout(user_id)` | All sessions terminated | `admin:user:suspend` |
| 10 | Reset password | Security tab: "🔑 Reset password" | Action | `AdminService/ResetPassword(user_id)` | Password reset email sent to user | `admin:user:suspend` |
| 11 | Copy user ID | "📋 Copy" | Action | — (clipboard) | Toast: "User ID đã copy" | Any |
| 12 | Filter activity | Change filter in Activity tab | Filter | Refetch | Timeline updates | `admin:user:read` |

---
## 7. Validation Rules

### Grant Credits
| Field | Rule | Error |
|---|---|---|
| Amount | Required, integer, 1-10000 | "Số credits phải từ 1 đến 10,000" |
| Reason | Required, min 10 chars | "Vui lòng nhập lý do cấp credits" |

### Suspend User
| Field | Rule | Error |
|---|---|---|
| Reason | Required, min 10 chars | "Vui lòng nhập lý do tạm ngưng" |

### Delete Account
| Field | Rule | Error |
|---|---|---|
| Email confirmation | Must exactly match user's email | "Email không khớp" |
| "DELETE" confirmation | Must type "DELETE" | "Nhập 'DELETE' để xác nhận" |
| Reason | Required, min 20 chars | "Vui lòng nhập lý do chi tiết" |

### Impersonate
| Field | Rule | Error |
|---|---|---|
| OTP | Required, 6-digit TOTP | "OTP không hợp lệ" |
| Valid within | 30-second window | "OTP đã hết hạn. Thử lại." |

---
## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Fetching user profile | Profile shimmer + tab skeletons | Wait |
| LOADED | Data received | Full profile + tabs | Interact normally |
| USER_NOT_FOUND | Invalid user ID | "Người dùng không tồn tại. [← Danh sách]" | Go back |
| SUSPENDED | User is suspended | Red banner: "⏸ Tạm ngưng bởi {admin_name} — {reason} — {date}" | Unsuspend or review |
| HIGH_RISK | Risk score ≥ 7 | Red "🔴 High Risk" badge + "Xem chi tiết rủi ro" link | Investigate security tab |
| DELETED | User is deleted (viewing archive) | Grey overlay: "🗑 Tài khoản đã xóa — {date}" — all actions disabled | Read-only review |
| IMPERSONATING | Admin is impersonating this user | "👤 Đang impersonate trong tab khác" indicator | End session |
| ACTION_PENDING | Admin action processing | Relevant button shows spinner | Wait |
| ERROR | API failed | "Không tải được thông tin người dùng. [Thử lại]" | Retry |

---
## 9. Permissions & Role-based Behavior (Admin 8-Role per B5 §3)

| Feature | Super | Ops | Finance | Content | Support | Tech | Analyst | Auditor |
|---|---|---|---|---|---|---|---|---|
| View user profile | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ | ✅ | ✅ |
| View financial data | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ | ✅ |
| View security/sessions | ✅ | ✅ | ❌ | ❌ | ✅ | ✅ | ❌ | ✅ |
| Grant credits | ✅ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Override plan | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Suspend/unsuspend | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Impersonate | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Force logout | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Reset password | ✅ | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ |
| Delete account | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |

### Visibility Rules
- **Support Admin**: Can view profile, activity, and security for troubleshooting. Financial tabs (credits, revenue) are hidden. Action bar shows only "📧 Email" and "🔑 Reset password".
- **Analyst/Auditor**: Full read access (including financials) but no action buttons visible.
- **Tech Admin**: Can view profile + security for debugging. No financial or user management actions.
- **Content Admin**: No access → redirect to admin dashboard.

---
## 10. Edge Cases

| Edge Case | Handling |
|---|---|
| User with no workspaces | Workspaces tab shows count (0), "User has no workspaces" message |
| User with 50+ workspaces | Paginate workspace list, show total count |
| Impersonation of suspended user | Block: "Cannot impersonate suspended user. Unsuspend first." |
| Deleting user with active subscriptions | Block: "User has active subscriptions in {count} workspaces. Cancel subscriptions first." |
| Activity log > 10,000 entries | Date range required (max 90 days at a time). Paginated. |
| User created via API (no OAuth provider) | Show "Method: Email/Password" in login info |
| User with same email in different case | System treats as same (case-insensitive). Show canonical form. |
| Risk score changes while viewing | Auto-refresh risk score every 5m. Badge updates in-place. |

---
## 11. Technical Implementation Notes

- **Route**: `src/routes/admin/users/[id]/+page.svelte`
- **Server load**: `+page.server.ts` → validate admin auth + VPN → fetch user profile
- **Tab data**: Lazy-loaded per tab (only fetch when tab becomes active)
- **Impersonation**: Creates new auth session with `impersonated_by` field. All actions tagged as impersonation in audit log.
- **Risk score**: Computed server-side from: login anomaly detection, content flags, abuse reports, payment chargebacks

---
## 12. Accessibility

| Element | Requirement |
|---|---|
| Profile header | `role="banner"`, status announced via `aria-label` |
| Tab navigation | `role="tablist"` with `aria-selected`, keyboard navigable |
| Risk score | `aria-label="Risk score: 2 out of 10, low risk"` |
| Action buttons | `aria-label` with user context ("Suspend user: Nguyễn Quân") |
| Activity timeline | `role="feed"`, `aria-label="Activity timeline"` |
| Copy button | `aria-label="Copy user ID to clipboard"` |

---
## 13. Data Binding & Display Format
*(Refer to screen-specific data binding in section above)*


---
## 14. Related Screens

| Screen | Relationship |
|---|---|
| [A002] User List | Parent list |
| [A005] Workspace Detail | Workspace drill-down |
| [A010] Audit Log | Admin action trail |
| [A021] Subscriptions | Plan management |
| [A026] Support Queue | Related tickets |
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
