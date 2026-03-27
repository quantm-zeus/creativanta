# Screen Specs 12 — Admin Site (S26)

> **Upstream**: Product Freeze §Admin, Pack 07 (Admin), A1 Schema (admin tables), A3 API (admin RPCs)
> **Screens**: 36 admin screens (VPN-only, separate JWT/RBAC)
> **Access**: Admin role only, physically isolated from user-facing sites

---

## Admin Site Overview

The Admin Site is a separate application accessible only via VPN/internal network. It uses the same design system tokens but a distinct admin theme (darker, higher information density).

### Admin Navigation
```
┌─ Admin Sidebar ───────────────────────┐
│ 🛡️ Creativanta Admin                  │
│                                        │
│ 📊 Dashboard                          │
│ 👥 Users                              │
│ 🏢 Workspaces                         │
│ 💳 Subscriptions                      │
│ 🔗 Connectors                         │
│ 📤 Content Moderation                 │
│ 🤖 AI Operations                      │
│ 📦 Commerce                           │
│ 🔧 System Health                      │
│ 📈 Analytics                          │
│ 🆘 Support                            │
│ ⚙️ Config                             │
│ 📋 Audit Log                          │
└────────────────────────────────────────┘
```

---

## A1. Admin Dashboard

**Route**: `/admin`
**Purpose**: System-wide KPIs — active users, revenue, system health, alerts.

### Layout
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ 📊 Admin Dashboard                               [Period: 24h ▾]│
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ KPI Row ───────────────────────────────────────────────────┐ │
│ │ 👥 Active Users│ 🏢 Workspaces│ 💰 MRR      │ ⚙️ System   │ │
│ │ 1,234 (+5%)   │ 456 (+8%)    │ 125M VND    │ 🟢 Healthy  │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Charts Row ────────────────────────────────────────────────┐ │
│ │ [User signups (7d)]  │ [Revenue curve (30d)]                │ │
│ │ [API latency (24h)]  │ [Error rate (24h)]                   │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Active Alerts ─────────────────────────────────────────────┐ │
│ │ 🔴 3 failed connector syncs across 12 workspaces           │ │
│ │ 🟡 AI provider latency spike (Gemini: 2.1s avg, +150%)     │ │
│ │ 🟡 5 abuse reports pending review                           │ │
│ │ [→ View all alerts]                                          │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Recent Activity ──────────────────────────────────────────┐  │
│ │ 10:05 User #1234 upgraded to Pro                           │  │
│ │ 10:02 Workspace #456 exceeded rate limit                   │  │
│ │ 09:58 Support ticket #789 escalated                        │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### Data Sources
| Section | API | Cache |
|---|---|---|
| KPI Row | `AdminAnalyticsService/GetDashboardKPIs` | `admin:kpis` (5m TTL) |
| Charts | ClickHouse aggregations | — |
| Alerts | `AdminAlertService/ListActive` | — |
| Activity | `AuditLogService/List(limit=10)` | — |

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Change period | Period dropdown | Refetch KPIs + charts | Data refreshes |
| View alert detail | Click alert row | — | → `/admin/system` or relevant screen |
| View all alerts | "View all alerts" | — | → `/admin/system` with alert filter |
| Click activity | Click activity row | — | → relevant admin detail screen |
| Export KPIs | ⋮ → Export | `AdminAnalyticsService/ExportKPIs` | CSV download |

### States
- **Loading**: KPI skeleton row + 4 chart placeholders + activity shimmer
- **Error**: "Dashboard không tải được. [Thử lại]"
- **Degraded**: Yellow banner "Một số metrics đang delay" with stale indicator

---

## A2-A3. User Management

### A2. User List (`/admin/users`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ 👥 Users                                        Total: 1,234     │
├──────────────────────────────────────────────────────────────────┤
│ [🔍 Search by name/email]  [Plan: All ▾] [Status: All ▾]       │
│ [Sort: Created ▾] [Export CSV]                                   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ☐ │ ID    │ Name        │ Email           │ Plan │ Status   │ Created│
│ ☐ │ #1234 │ Nguyễn Quân │ quan@email.com  │ Pro  │ 🟢Active │ 15/1   │
│ ☐ │ #1235 │ Trần Minh   │ minh@email.com  │ Free │ 🟢Active │ 20/2   │
│ ☐ │ #1236 │ [Flagged]   │ spam@fake.com   │ Free │ 🔴Suspended│ 3/3  │
│                                                                  │
│ Bulk: [Suspend selected] [Export selected] [Send notification]   │
│ Per-row ⋮: [View] [Edit] [Suspend] [Delete] [Impersonate]       │
│                                                                  │
│ ◀ Page 1 of 62 ▶                                                │
└──────────────────────────────────────────────────────────────────┘
```

### A2 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Search | Type in search | `AdminUserService/List(query)` | Table filters |
| Filter | Dropdown change | `AdminUserService/List(filters)` | Table updates |
| View detail | Click row or "View" | — | → `/admin/users/[id]` |
| Suspend | ⋮ → Suspend → confirm | `AdminUserService/Suspend(id)` | Status → Suspended |
| Delete | ⋮ → Delete → confirm+OTP | `AdminUserService/Delete(id)` | Row removed, audit logged |
| Impersonate | ⋮ → Impersonate → OTP | `AdminUserService/Impersonate(id)` | New tab as user, audit logged |
| Bulk suspend | Select rows → Suspend | `AdminUserService/BulkSuspend(ids)` | Multi-update |
| Export CSV | "Export CSV" | `AdminUserService/Export` | File download |

### A3. User Detail (`/admin/users/[id]`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ ← Users   👤 Nguyễn Quân (#1234)     [🟢 Active] [⋮ Actions]    │
├──────────────────────────────────────────────────────────────────┤
│ Tabs: [Profile] [Workspaces] [Activity] [Tickets] [Billing]     │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ── Profile Tab ──                                                │
│ ┌─ Info Card ────────────────────────────────────────────────┐   │
│ │ [Avatar]  Nguyễn Quân                                      │   │
│ │ Email: quan@email.com (verified ✅)                         │   │
│ │ Phone: +84 912 xxx xxx                                      │   │
│ │ Joined: 15/01/2026 · Last login: 2h ago                    │   │
│ │ Plan: Pro · Credits: 320/500                                │   │
│ │ Locale: vi · Timezone: Asia/Ho_Chi_Minh                     │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                  │
│ ┌─ Linked Workspaces ────────────────────────────────────────┐   │
│ │ ws_abc123 · "Creativanta Studio" · Owner · Pro plan        │   │
│ │ ws_def456 · "Side Project" · Admin · Free plan              │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                  │
│ ┌─ Login History (last 10) ──────────────────────────────────┐   │
│ │ 27/3 10:05 · Chrome/Mac · IP 203.x.x.x · 🟢 Success      │   │
│ │ 27/3 08:30 · Mobile/iOS  · IP 14.x.x.x  · 🟢 Success      │   │
│ │ 26/3 22:15 · Chrome/Mac · IP 203.x.x.x · 🔴 Failed (pwd) │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                  │
│ ┌─ Admin Actions ────────────────────────────────────────────┐   │
│ │ [🔄 Reset password] [🚪 Force logout] [⏸ Suspend]          │   │
│ │ [🚫 Ban] [🗑 Delete account] [👤 Impersonate]               │   │
│ │ ⚠️ Destructive actions require OTP verification            │   │
│ └────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────┘
```

### A3 Actions
| Action | Trigger | API | Permission | Result |
|---|---|---|---|---|
| Reset password | Button → confirm | `AdminUserService/ResetPassword` | SuperAdmin | Email sent to user |
| Force logout | Button → confirm | `AdminUserService/ForceLogout` | Admin | All sessions terminated |
| Suspend | Button → reason modal | `AdminUserService/Suspend` | Admin | Status → Suspended |
| Ban | Button → reason + OTP | `AdminUserService/Ban` | SuperAdmin | Permanent + audit |
| Delete | Button → type name + OTP | `AdminUserService/Delete` | SuperAdmin | GDPR delete queued |
| Impersonate | Button → OTP | `AdminUserService/Impersonate` | SuperAdmin | Opens user session |
| Grant credits | Billing tab → amount | `AdminCreditService/Grant` | Admin | Credits added |

### A3 States
- **Loading**: Profile card skeleton + tab content shimmer
- **Not found**: "User không tồn tại. [← Quay lại]"
- **Suspended user**: Red banner "Tài khoản đã bị suspend bởi {admin} lúc {time}. Lý do: {reason}"

---

## A4-A5. Workspace Management

### A4. Workspace List (`/admin/workspaces`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ 🏢 Workspaces                                   Total: 456       │
├──────────────────────────────────────────────────────────────────┤
│ [🔍 Search]  [Plan ▾] [Status ▾] [Mode ▾] [Created ▾]          │
├──────────────────────────────────────────────────────────────────┤
│ ID       │ Name              │ Owner       │ Plan │ Members│ Status │
│ ws_abc   │ Creativanta Studio│ Nguyễn Quân │ Pro  │ 5      │ 🟢     │
│ ws_def   │ Side Project      │ Trần Minh   │ Free │ 1      │ 🟢     │
│ ws_ghi   │ [Frozen]          │ Lê Hoa      │ Pro  │ 3      │ 🔵Frozen│
│                                                                  │
│ Per-row ⋮: [View] [Freeze] [Force downgrade] [Delete] [Export]  │
│ ◀ Page 1 of 23 ▶                                                │
└──────────────────────────────────────────────────────────────────┘
```

### A4 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Search | Search input | `AdminWorkspaceService/List(query)` | Filtered |
| View | Click row | — | → `/admin/workspaces/[id]` |
| Freeze | ⋮ → Freeze → confirm | `AdminWorkspaceService/Freeze` | Status = Frozen |
| Delete | ⋮ → Delete → OTP | `AdminWorkspaceService/Delete` | GDPR queue |

### A5. Workspace Detail (`/admin/workspaces/[id]`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ ← Workspaces   🏢 Creativanta Studio         [🟢 Active] [⋮]    │
├──────────────────────────────────────────────────────────────────┤
│ Tabs: [Overview] [Members] [Usage] [Billing] [Content] [Danger] │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ── Overview Tab ──                                               │
│ ┌─ Info ──────────────────────────────────────────────────────┐  │
│ │ ID: ws_abc123 · Owner: Nguyễn Quân · Plan: Pro             │  │
│ │ Mode: Creator · Created: 15/1/2026 · Members: 5/10         │  │
│ │ Region: Asia/Ho_Chi_Minh · Locale: vi                      │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Usage Metrics ─────────────────────────────────────────────┐  │
│ │ API calls (30d): 45,230 │ Storage: 2.3GB/10GB              │  │
│ │ AI credits: 320/500     │ Connectors: 3 active              │  │
│ │ Posts published: 42      │ Revenue (30d): 45.2M VND          │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Connected Accounts ────────────────────────────────────────┐  │
│ │ 🟢 TikTok @creator123 · 🟢 Shopee Shop · 🔴 IG (expired)  │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Danger Tab ──                                                 │
│ [⏸ Freeze workspace] [⬇ Force downgrade] [🗑 Delete] [📦 Export]│
│ ⚠️ All actions require OTP + are audit-logged                   │
└──────────────────────────────────────────────────────────────────┘
```

### A5 Actions
| Action | Trigger | API | Permission | Result |
|---|---|---|---|---|
| Freeze | Danger → Freeze → OTP | `AdminWorkspaceService/Freeze` | SuperAdmin | All operations paused |
| Unfreeze | Danger → Unfreeze | `AdminWorkspaceService/Unfreeze` | SuperAdmin | Restored |
| Force downgrade | Danger → Downgrade → OTP | `AdminWorkspaceService/ForcePlanChange` | SuperAdmin | Plan changed |
| Delete | Danger → Delete → type name + OTP | `AdminWorkspaceService/Delete` | SuperAdmin | GDPR delete queued |
| Data export | Export button | `AdminWorkspaceService/ExportData` | Admin | Zipped data download |

---

## A6-A7. Subscription Management

### A6. Subscription Overview (`/admin/subscriptions`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ 💳 Subscriptions                                [Period: 30d ▾]   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ KPI Row ───────────────────────────────────────────────────┐  │
│ │ MRR: 125M VND │ Churn: 3.2% │ ARPU: 285K │ Active: 456    │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Plan Distribution ────────────────────────────────────────┐   │
│ │ [Pie chart: Free 60% · Starter 25% · Pro 12% · Enterprise 3%]│
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Revenue Chart (monthly) ──────────────────────────────────┐   │
│ │ [Bar chart: MRR trend 12 months, stacked by plan tier]     │   │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Churn & Movement ─────────────────────────────────────────┐   │
│ │ Upgrades: 23 (+15%) │ Downgrades: 8 │ Cancellations: 12    │   │
│ │ [View upgrade paths →] [View churn reasons →]               │   │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### A7. Manual Subscription Override (`/admin/subscriptions/override`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ ← Subscriptions   ⚙️ Manual Override                             │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Workspace: [🔍 Search workspace...                           ]   │
│                                                                  │
│ ┌─ Selected: ws_abc123 "Creativanta Studio" ──────────────────┐  │
│ │ Current: Pro · Credits: 320/500 · Expires: 15/4/2026       │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Action: [● Change plan] [○ Grant credits] [○ Extend trial]      │
│                                                                  │
│ ┌─ Change Plan ──────────────────────────────────────────────┐   │
│ │ New plan: [Enterprise ▾]                                    │   │
│ │ Reason: [Partnership deal with Brand X               ]     │   │
│ │ Duration: [Custom ▾] Until: [31/12/2026]                    │   │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ⚠️ Requires OTP verification                                    │
│ [Apply override] [Cancel]                                        │
└──────────────────────────────────────────────────────────────────┘
```

### A7 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Change plan | Select plan → Apply → OTP | `AdminSubscriptionService/Override` | Plan changed + audit |
| Grant credits | Amount → Apply → OTP | `AdminCreditService/Grant` | Credits added + audit |
| Extend trial | Date → Apply → OTP | `AdminSubscriptionService/ExtendTrial` | Trial extended + audit |

---

## A8-A9. Connector Administration

### A8. Global Connector Status (`/admin/connectors`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ 🔗 Connector Status                             [Auto-refresh 30s]│
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Platform Health Cards ─────────────────────────────────────┐  │
│ │ 🟢 TikTok API    │ 🟡 Shopee API    │ 🟢 Instagram API    │  │
│ │ Latency: 120ms   │ Latency: 890ms   │ Latency: 200ms      │  │
│ │ Error: 0.1%      │ Error: 2.3% ⚠️   │ Error: 0.3%         │  │
│ │ Rate: 45%        │ Rate: 78% ⚠️     │ Rate: 30%           │  │
│ │ [Debug →]        │ [Debug →]         │ [Debug →]           │  │
│ ├──────────────────┼──────────────────┼─────────────────────┤  │
│ │ 🟢 YouTube API   │ 🔴 Lazada API    │ 🟢 Facebook API     │  │
│ │ Latency: 150ms   │ Latency: timeout │ Latency: 180ms      │  │
│ │ Error: 0.2%      │ Error: 100% 🔴   │ Error: 0.1%         │  │
│ │ Rate: 20%        │ Affected: 12 ws  │ Rate: 25%           │  │
│ │ [Debug →]        │ [Debug →]         │ [Debug →]           │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Affected Workspaces (when errors) ─────────────────────────┐  │
│ │ Lazada outage: 12 workspaces affected                       │  │
│ │ ws_abc · ws_def · ws_ghi · ... [View all →]                 │  │
│ │ [📧 Notify affected users] [📋 Create incident]              │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### A9. Connector Debug (`/admin/connectors/[platform]/debug`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ ← Connectors   🔧 TikTok Debug                                   │
├──────────────────────────────────────────────────────────────────┤
│ Tabs: [API Logs] [Token Status] [Manual Sync] [Rate Limits]     │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ── API Logs Tab ──                                               │
│ ┌─ Log Stream (real-time) ────────────────────────────────────┐  │
│ │ 10:05:23 GET /products 200 125ms ws_abc                     │  │
│ │ 10:05:21 POST /orders 429 0ms ws_def [RATE LIMITED]         │  │
│ │ 10:05:18 GET /videos 200 890ms ws_ghi                       │  │
│ │ Filter: [Workspace ▾] [Status ▾] [Endpoint ▾]              │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Manual Sync Tab ──                                            │
│ Workspace: [🔍 ws_abc123]                                        │
│ Sync type: [☑ Products] [☑ Orders] [☐ Videos] [☐ Comments]     │
│ [🔄 Trigger sync now]                                            │
│                                                                  │
│ ── Rate Limits Tab ──                                            │
│ ┌─────────────────────────────────────────────────────────────┐  │
│ │ Current: 4,500/10,000 (45%) · Resets in: 45 min            │  │
│ │ [Progress bar ████████░░░░░░░░░░░░ 45%]                     │  │
│ │ [⚠️ Reset rate limit counter] (requires SuperAdmin)         │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### A8-A9 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| View debug | Click "Debug →" | — | → `/admin/connectors/[platform]/debug` |
| Notify users | "Notify affected" | `AdminNotificationService/BulkNotify` | Email sent |
| Manual sync | Select + Trigger | `AdminConnectorService/TriggerSync` | Sync queued |
| Reset rate | Button → OTP | `AdminConnectorService/ResetRateLimit` | Counter reset |
| Create incident | "Create incident" | `AdminIncidentService/Create` | Incident logged |

---

## A10-A12. Content Moderation

### A10. Moderation Queue (`/admin/moderation`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ 📤 Content Moderation                    Pending: 5              │
├──────────────────────────────────────────────────────────────────┤
│ Filter: [All ▾] [Auto-flagged ▾] [Reported ▾] [Priority ▾]    │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Flagged Content ───────────────────────────────────────────┐ │
│ │ 🚩 Script: "Weight loss miracle pills" — Workspace #123    │ │
│ │ Flag: Auto-detected health claim · Severity: High           │ │
│ │ AI Confidence: 92% · Rule: Health claims without evidence   │ │
│ │ [👁 Review] [✅ Approve] [⚠️ Warn user] [🚫 Remove + Ban] │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Reported Content ──────────────────────────────────────────┐ │
│ │ 🚩 Video: "Fake review" — Reported by 3 users              │ │
│ │ Flag: User report · Reasons: Misleading, Spam               │ │
│ │ [👁 Review] [✅ Dismiss] [⚠️ Warn] [🚫 Remove]            │ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

### A10 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Review | "👁 Review" | — | Drawer: full content preview + context |
| Approve | "✅ Approve" | `AdminModerationService/Approve` | Item removed from queue |
| Warn user | "⚠️ Warn" → reason | `AdminModerationService/Warn` | Warning sent + logged |
| Remove + Ban | "🚫 Remove" → confirm | `AdminModerationService/RemoveAndBan` | Content deleted + user banned |
| Dismiss report | "✅ Dismiss" | `AdminModerationService/Dismiss` | Report closed |

### A10 States
- **Loading**: Card skeletons
- **Empty**: "🎉 Không có nội dung cần kiểm duyệt"
- **High volume**: Red banner "15+ items pending — consider batch review mode"

### A11. Moderation Rules (`/admin/moderation/rules`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ ← Moderation   📋 Rules Engine                  [+ Add rule]     │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Rule Card ─────────────────────────────────────────────────┐  │
│ │ 🚩 Health Claims Detection                    [🟢 Active]   │  │
│ │ Type: AI Classifier · Threshold: 85%                        │  │
│ │ Keywords: "giảm cân", "trị mụn", "thần dược"               │  │
│ │ Action: Auto-flag for review · Severity: High               │  │
│ │ Triggered: 23 times (30d) · False positive: 8%              │  │
│ │ [✏️ Edit] [🧪 Test] [⏸ Disable]                           │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Rule Card ─────────────────────────────────────────────────┐  │
│ │ 🚩 Spam Detection                              [🟢 Active]  │  │
│ │ Type: Keyword + Frequency · Threshold: 3 posts/min          │  │
│ │ Action: Auto-suspend · Severity: Critical                   │  │
│ │ Triggered: 5 times (30d) · False positive: 2%               │  │
│ │ [✏️ Edit] [🧪 Test] [⏸ Disable]                           │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### A11 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Add rule | "+ Add rule" | — | Modal: rule configuration form |
| Edit rule | "✏️ Edit" | — | Modal pre-filled |
| Test rule | "🧪 Test" → paste content | `AdminModerationService/TestRule` | Shows match/no-match result |
| Toggle | "⏸ Disable" | `AdminModerationService/UpdateRule` | Status toggled |

### A12. Abuse Reports (`/admin/moderation/reports`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ ← Moderation   🚨 Abuse Reports                 Pending: 5      │
├──────────────────────────────────────────────────────────────────┤
│ ┌─ Stats Bar ─────────────────────────────────────────────────┐  │
│ │ Total: 45 │ Resolved: 38 │ Rate: 84% │ Avg time: 4h       │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Report Row ────────────────────────────────────────────────┐  │
│ │ #789 · Reported by: user_456 · Against: user_123           │  │
│ │ Type: Misleading content · Evidence: [3 screenshots]        │  │
│ │ Status: [🟡 Pending] · Filed: 2d ago                        │  │
│ │ [👁 Review] [✅ Resolve] [🚫 Action against user]           │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

---

## A13-A15. AI Operations

### A13. AI Provider Dashboard (`/admin/ai`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ 🤖 AI Operations                                [Auto-refresh 60s]│
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Provider Health ──────────────────────────────────────────┐   │
│ │ Provider   │ Status │ Latency │ Error % │ Cost (30d)       │   │
│ │ Gemini 2.5 │ 🟢     │ 1.2s    │ 0.3%    │ 2.5M VND        │   │
│ │ OpenAI 4o  │ 🟢     │ 1.8s    │ 0.5%    │ 1.2M VND (fall) │   │
│ │ Replicate  │ 🟡     │ 3.2s    │ 2.1%    │ 4.8M VND        │   │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Global Credit Usage (24h) ────────────────────────────────┐   │
│ │ Consumed: 12,345 cr │ Revenue: 8.2M VND │ Cost: 3.1M VND  │   │
│ │ [Bar chart: usage by generation mode over 7d]               │   │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Queue Status ──────────────────────────────────────────────┐  │
│ │ Pending: 23 │ Processing: 8 │ Avg wait: 45s │ Failed: 2    │  │
│ │ [View queue →]                                               │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### A13 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| View provider detail | Click row | — | Expandable: latency chart, error logs |
| Pause provider | ⋮ → Pause → confirm | `AdminAIService/ToggleProvider` | Traffic rerouted to fallback |
| View queue | "View queue →" | — | → `/admin/system/jobs?type=ai` |

### A14. AI Credit Manager (`/admin/ai/credits`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ ← AI Ops   💰 Credit Manager                                     │
├──────────────────────────────────────────────────────────────────┤
│ [🔍 Search workspace]  [Plan ▾] [Balance: Low first ▾]          │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Workspace      │ Plan │ Balance │ Used (30d) │ Limit  │ Actions │
│ Creativanta    │ Pro  │ 320     │ 180        │ 500    │ [Grant] │
│ Side Project   │ Free │ 5       │ 45         │ 50     │ [Grant] │
│ Agency Studio  │ Ent  │ 2,100   │ 900        │ 5000   │ [Grant] │
│                                                                  │
│ ── Grant Credits Modal ──                                        │
│ ┌──────────────────────────────────────────────────────────────┐ │
│ │ Workspace: Creativanta Studio                                │ │
│ │ Amount: [   100   ] credits                                  │ │
│ │ Reason: [Compensation for downtime 27/3          ]           │ │
│ │ [Grant] [Cancel]                                              │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ── Transaction Log ──                                            │
│ 27/3 10:05 │ ws_abc │ +100 │ Grant (Admin: quan) │ Compensation │
│ 27/3 09:30 │ ws_abc │ -15  │ Video gen (Clip Factory)           │
└──────────────────────────────────────────────────────────────────┘
```

### A14 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Grant credits | [Grant] → modal → confirm | `AdminCreditService/Grant` | Credits added + audit |
| Revoke credits | ⋮ → Revoke → reason | `AdminCreditService/Revoke` | Credits deducted + audit |
| Export log | Export button | `AdminCreditService/ExportLog` | CSV download |

### A15. AI Model Configuration (`/admin/ai/config`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ ← AI Ops   ⚙️ Model Config                                       │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Task: Text Generation ─────────────────────────────────────┐  │
│ │ Primary: [Gemini 2.5 Flash ▾]  Fallback: [OpenAI 4o-mini ▾]│  │
│ │ Temperature: [0.7] · Max tokens: [4096] · Top-p: [0.9]     │  │
│ │ Rate limit: Free [10/h] Starter [50/h] Pro [200/h] Ent [∞] │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Task: Image Generation ────────────────────────────────────┐  │
│ │ Primary: [Replicate FLUX ▾]    Fallback: [DALL-E 3 ▾]      │  │
│ │ Default size: [1024x1024] · Quality: [HD]                   │  │
│ │ Rate limit: Free [5/h] Starter [20/h] Pro [100/h] Ent [∞]  │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Task: Video Generation ────────────────────────────────────┐  │
│ │ Primary: [Replicate Wan ▾]     Fallback: [None]             │  │
│ │ Max duration: [60s] · Resolution: [1080p]                   │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ [💾 Save changes] [↩ Revert]                                     │
│ ⚠️ Changes take effect within 1 minute (cache TTL)              │
└──────────────────────────────────────────────────────────────────┘
```

### A15 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Change model | Dropdown | — | Local state until save |
| Save config | "Save changes" → OTP | `AdminAIService/UpdateConfig` | Applied + audit |
| Revert | "Revert" | — | Reload from server |

---

## A16-A18. Commerce Admin

### A16. Global Commerce Stats (`/admin/commerce`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ 📦 Commerce Overview                           [Period: 30d ▾]   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ KPIs ──────────────────────────────────────────────────────┐  │
│ │ GMV: 1.2B VND │ Orders: 3,456 │ Refund: 2.1% │ AOV: 350K  │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Per-Platform ──────────────────────────────────────────────┐  │
│ │ TikTok Shop │ GMV: 800M │ Orders: 2,100 │ Refund: 1.8%    │  │
│ │ Shopee      │ GMV: 300M │ Orders: 1,200 │ Refund: 2.5%    │  │
│ │ Website     │ GMV: 100M │ Orders: 156   │ Refund: 3.1%    │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Top Workspaces ────────────────────────────────────────────┐  │
│ │ 1. ws_abc "Beauty Hub" · 450M VND · 1,200 orders           │  │
│ │ 2. ws_def "Tech Shop"  · 300M VND · 800 orders             │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### A17. Platform Fee Config (`/admin/commerce/fees`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ ← Commerce   💵 Fee Configuration                                 │
├──────────────────────────────────────────────────────────────────┤
│ Platform: [TikTok Shop ▾]                                        │
│                                                                  │
│ ┌─ Fee Table ─────────────────────────────────────────────────┐  │
│ │ Category        │ Commission │ Payment fee │ Shipping       │  │
│ │ Fashion         │ 5.0%       │ 1.5%        │ Platform calc  │  │
│ │ Beauty          │ 4.5%       │ 1.5%        │ Platform calc  │  │
│ │ Electronics     │ 3.0%       │ 1.5%        │ Seller pays    │  │
│ │ [✏️ Edit row]                                                │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Last updated: 15/3/2026 by Admin:quan                            │
│ [💾 Save] [📥 Import CSV] [📤 Export]                            │
└──────────────────────────────────────────────────────────────────┘
```

### A18. Dispute Resolution (`/admin/commerce/disputes`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ ← Commerce   ⚖️ Disputes                        Pending: 3      │
├──────────────────────────────────────────────────────────────────┤
│ [Status: All ▾] [Platform ▾] [Priority ▾]                       │
│                                                                  │
│ ┌─ Dispute Row ───────────────────────────────────────────────┐  │
│ │ #D-456 · Order #12345 · 850K VND · ws_abc vs TikTok Shop   │  │
│ │ Type: Product quality · Filed: 3d ago · SLA: 24h left ⚠️   │  │
│ │ [👁 Review] [✅ Approve refund] [❌ Reject] [📧 Contact]   │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### A16-A18 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Edit fee | Edit row → save | `AdminCommerceService/UpdateFees` | Fee updated + audit |
| Import CSV | "Import CSV" | `AdminCommerceService/ImportFees` | Bulk update |
| Review dispute | "Review" | — | Drawer: full order + evidence |
| Approve refund | "Approve" → OTP | `AdminCommerceService/ResolveDispute` | Refund processed |
| Reject dispute | "Reject" → reason | `AdminCommerceService/ResolveDispute` | Dispute closed |

---

## A19-A21. System Health

### A19. Infrastructure Dashboard (`/admin/system`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ 🔧 System Health                                [Auto-refresh 15s]│
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Service Status ────────────────────────────────────────────┐  │
│ │ Service      │ Status │ CPU  │ RAM  │ Disk │ Latency       │  │
│ │ PostgreSQL   │ 🟢     │ 35%  │ 4.2G │ 45%  │ p95: 12ms    │  │
│ │ Dragonfly    │ 🟢     │ 10%  │ 1.8G │ —    │ p95: 0.5ms   │  │
│ │ Meilisearch  │ 🟢     │ 15%  │ 2.1G │ 30%  │ p95: 8ms     │  │
│ │ ClickHouse   │ 🟡     │ 65%  │ 6.0G │ 70%  │ p95: 120ms   │  │
│ │ Activepieces │ 🟢     │ 20%  │ 1.2G │ 15%  │ p95: 45ms    │  │
│ │ Rust API     │ 🟢     │ 25%  │ 800M │ —    │ p95: 15ms    │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Request Rate (1h) ─────────────────────────────────────────┐  │
│ │ [Line chart: requests/sec + error rate overlay]              │  │
│ │ Current: 450 req/s · Errors: 0.2% · p99 latency: 250ms    │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Active Alerts ─────────────────────────────────────────────┐  │
│ │ 🟡 ClickHouse CPU 65% — consider query optimization         │  │
│ │ [View details] [Acknowledge] [Snooze 1h]                     │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### A20. Background Job Monitor (`/admin/system/jobs`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ ← System   📋 Background Jobs                                    │
├──────────────────────────────────────────────────────────────────┤
│ [Type: All ▾] [Status: All ▾] [Queue: All ▾]                    │
│                                                                  │
│ ┌─ Queue Overview ────────────────────────────────────────────┐  │
│ │ ai_generation │ Pending: 23 │ Active: 8 │ Failed: 2         │  │
│ │ connector_sync│ Pending: 5  │ Active: 3 │ Failed: 0         │  │
│ │ export        │ Pending: 1  │ Active: 1 │ Failed: 0         │  │
│ │ email         │ Pending: 12 │ Active: 4 │ Failed: 1         │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Failed Jobs ───────────────────────────────────────────────┐  │
│ │ ai_gen:45678 · "Clip Factory" · ws_abc · Failed 3x         │  │
│ │ Error: "Provider timeout after 60s"                         │  │
│ │ [🔄 Retry] [🗑 Delete] [👁 View payload]                    │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Dead Letter Queue ─────────────────────────────────────────┐  │
│ │ 3 items · Last added: 2h ago                                 │  │
│ │ [👁 View all] [🗑 Purge all]                                 │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### A21. Feature Flags (`/admin/system/flags`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ ← System   🚩 Feature Flags                     [+ Create flag]  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Flag Name          │ Status │ Rollout │ Scope    │ Updated       │
│ ai_video_agent     │ 🟡 50% │ 50%     │ Pro+     │ 2d ago        │
│ live_commerce_v2   │ 🟢 On  │ 100%    │ All      │ 7d ago        │
│ new_checkout_flow  │ 🔴 Off │ 0%      │ —        │ 14d ago       │
│ seeding_campaign   │ 🟡 25% │ 25%     │ Ent only │ 1d ago        │
│                                                                  │
│ Per-row: [Toggle] [Edit rollout %] [Edit scope] [Delete]         │
└──────────────────────────────────────────────────────────────────┘
```

### A19-A21 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Acknowledge alert | "Acknowledge" | `AdminAlertService/Ack` | Alert marked seen |
| Retry job | "Retry" | `AdminJobService/Retry` | Job re-queued |
| Delete job | "Delete" → confirm | `AdminJobService/Delete` | Job removed |
| Purge DLQ | "Purge" → OTP | `AdminJobService/PurgeDLQ` | DLQ cleared |
| Toggle flag | Toggle | `AdminFlagService/Toggle` | Immediate effect |
| Edit rollout | Edit % → save | `AdminFlagService/Update` | Gradual rollout |

### A19 States
- **Loading**: Service table skeleton + chart placeholder
- **Degraded service**: Row turns yellow/red with blinking indicator
- **All healthy**: Green banner "Tất cả dịch vụ hoạt động bình thường"

---

## A22-A24. Admin Analytics

### A22. Business Analytics (`/admin/analytics`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ 📈 Business Analytics                          [Period: 30d ▾]   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Cohort Analysis ──────────────────────────────────────────┐   │
│ │ [Heatmap: signup week vs milestone reached]                 │   │
│ │ Week 1: Signup → 65%    connect account                     │   │
│ │ Week 2: Connect → 40%   first publish                       │   │
│ │ Week 3: Publish → 25%   first revenue                       │   │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Funnel ───────────────────────────────────────────────────┐   │
│ │ Signup: 100% → Onboarding: 85% → Connect: 65% →            │   │
│ │ Create: 45% → Publish: 30% → Revenue: 15%                  │   │
│ │ [Funnel bar chart with drop-off percentages]                │   │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Feature Usage Heatmap ────────────────────────────────────┐   │
│ │ [Grid: features × plan tiers, colored by usage frequency]   │   │
│ │ AI Studio: ████ Pro, ██ Free · Inbox: ███ Pro, ███ Free    │   │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### A23. Usage Analytics (`/admin/analytics/usage`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ ← Analytics   📊 Usage                          [Period: 7d ▾]   │
├──────────────────────────────────────────────────────────────────┤
│ Tabs: [API Calls] [Search] [Cache] [Storage]                     │
│                                                                  │
│ ── API Calls Tab ──                                              │
│ ┌─ Top Endpoints ─────────────────────────────────────────────┐  │
│ │ 1. GET /content/list        │ 45,000/d │ p95: 25ms         │  │
│ │ 2. POST /ai/generate        │ 12,000/d │ p95: 2.1s         │  │
│ │ 3. GET /inbox/messages       │ 8,500/d  │ p95: 15ms         │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Cache Tab ──                                                  │
│ ┌─ Dragonfly ─────────────────────────────────────────────────┐  │
│ │ Hit rate: 94.2% │ Keys: 125K │ Memory: 1.8GB/4GB          │  │
│ │ [Line chart: hit rate over 7d]                               │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### A24. Error Analytics (`/admin/analytics/errors`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ ← Analytics   🚨 Errors                         [Period: 24h ▾]  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Error Summary ─────────────────────────────────────────────┐  │
│ │ Total: 234 │ Unique: 12 │ Users affected: 45               │  │
│ │ [Line chart: error count per hour]                           │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Grouped Errors ────────────────────────────────────────────┐  │
│ │ 1. ConnectorSyncError (TikTok) │ 120 occ │ 30 users │ ↑25% │  │
│ │    Last: "Rate limit exceeded" — stack trace preview        │  │
│ │    [👁 View full] [🔕 Mute] [📋 Create ticket]              │  │
│ │                                                              │  │
│ │ 2. AIGenerationTimeout         │ 45 occ  │ 12 users │ new  │  │
│ │    Last: "Replicate timeout 60s" — stack trace preview      │  │
│ │    [👁 View full] [🔕 Mute] [📋 Create ticket]              │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### A22-A24 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Change period | Period dropdown | Refetch analytics | Charts update |
| Export report | ⋮ → Export | `AdminAnalyticsService/Export` | CSV/PDF download |
| Create ticket from error | "Create ticket" | `AdminSupportService/CreateFromError` | Ticket prefilled |
| Mute error | "Mute" | `AdminErrorService/Mute` | Error hidden from view |

---

## A25-A27. Support Admin

### A25. Ticket Dashboard (`/admin/support`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ 🆘 Support                                     Open: 23          │
├──────────────────────────────────────────────────────────────────┤
│ [Status: All ▾] [Priority ▾] [Assigned: All ▾] [SLA ▾]         │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ SLA Overview ──────────────────────────────────────────────┐  │
│ │ Within SLA: 89% │ Breached: 3 │ Avg response: 2.5h         │  │
│ │ Avg resolution: 18h │ CSAT: 4.2/5                           │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Ticket Row ────────────────────────────────────────────────┐  │
│ │ #T-789 · "Không thể kết nối TikTok" · user:1234            │  │
│ │ Priority: 🔴 High · Status: Open · SLA: 4h left ⚠️         │  │
│ │ Plan: Pro · Created: 3h ago · Assigned: Admin:minh          │  │
│ │ [👁 View] [✏️ Assign] [⬆ Escalate] [✅ Resolve]            │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Ticket Row ────────────────────────────────────────────────┐  │
│ │ #T-790 · "Lỗi thanh toán" · user:5678                       │  │
│ │ Priority: 🟡 Medium · Status: Waiting · SLA: OK             │  │
│ │ Plan: Free · Created: 1d ago · Assigned: Unassigned          │  │
│ │ [👁 View] [✏️ Assign] [✅ Resolve]                          │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### A26. Ticket Detail (`/admin/support/[id]`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ ← Support   #T-789 "Không thể kết nối TikTok"    [🔴 High] [⋮] │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ User Context ──────────────────────────────────────────────┐  │
│ │ 👤 Nguyễn Quân · Pro · ws_abc123 · 42 total tickets         │  │
│ │ Last login: 2h ago · Connected: TikTok, Shopee              │  │
│ │ [👤 View user] [🏢 View workspace]                          │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Conversation ──────────────────────────────────────────────┐  │
│ │ [User 10:05] "Tôi không thể kết nối TikTok, báo lỗi 401"  │  │
│ │ [Attachment: screenshot.png]                                 │  │
│ │                                                              │  │
│ │ [Admin:minh 10:30] "Tôi đang kiểm tra phía server..."      │  │
│ │ [Internal note 🔒] "Token expired, checking OAuth flow"     │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Reply ─────────────────────────────────────────────────────┐  │
│ │ [Rich text editor]                                           │  │
│ │ [☐ Internal note] [📎 Attach] [🤖 AI suggest reply]         │  │
│ │ [Send reply]                                                 │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Actions: [✏️ Reassign] [⬆ Escalate] [✅ Resolve] [🚫 Close]    │
└──────────────────────────────────────────────────────────────────┘
```

### A27. Knowledge Base Editor (`/admin/support/kb`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ ← Support   📚 Knowledge Base                   [+ New article]  │
├──────────────────────────────────────────────────────────────────┤
│ Tabs: [Articles] [Categories] [Search Analytics]                 │
│                                                                  │
│ ── Articles Tab ──                                               │
│ [🔍 Search]  [Category ▾] [Status ▾]                            │
│                                                                  │
│ Title                       │ Category  │ Views │ Helpful │ Status │
│ Kết nối TikTok Shop         │ Connector │ 1,234 │ 89%     │ ✅     │
│ Cách sử dụng AI Studio      │ AI        │ 890   │ 92%     │ ✅     │
│ Thanh toán và hóa đơn        │ Billing   │ 456   │ 75%     │ ✏️Draft│
│                                                                  │
│ ── Search Analytics Tab ──                                       │
│ ┌─ Top Failed Searches ──────────────────────────────────────┐   │
│ │ "refund" — 45 searches, 0 results → [Create article →]     │   │
│ │ "API key" — 23 searches, 0 results → [Create article →]    │   │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### A25-A27 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Assign ticket | "Assign" → select admin | `AdminSupportService/Assign` | Ticket assigned |
| Escalate | "Escalate" → reason | `AdminSupportService/Escalate` | Priority bumped |
| Reply | "Send reply" | `AdminSupportService/Reply` | Message sent to user |
| Internal note | Check "Internal" → send | `AdminSupportService/Note` | Note visible to admins only |
| AI suggest | "AI suggest" | `CopilotService/SuggestReply` | Pre-filled reply |
| Resolve | "Resolve" → resolution | `AdminSupportService/Resolve` | CSAT survey sent |
| Create article | "New article" | — | → WYSIWYG editor |
| Publish article | Editor → Publish | `AdminKBService/Publish` | Article live |

---

## A28-A30. Configuration

### A28. Notification Templates (`/admin/config/notifications`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ ← Config   📧 Notification Templates             Total: 39       │
├──────────────────────────────────────────────────────────────────┤
│ [Type: All ▾] [Channel: All ▾]                                   │
│                                                                  │
│ Template                  │ Channels       │ Status │ Last edited │
│ welcome_email              │ 📧 Email       │ ✅     │ 7d ago      │
│ order_confirmation         │ 📧+📱 Push     │ ✅     │ 14d ago     │
│ ai_generation_complete     │ 📱 Push + 🔔   │ ✅     │ 3d ago      │
│ credit_low_warning         │ 📧+📱+🔔       │ ✏️Draft│ 1d ago      │
│                                                                  │
│ Per-row: [✏️ Edit] [👁 Preview] [🧪 Test send] [⏸ Disable]     │
└──────────────────────────────────────────────────────────────────┘
```

### A29. Onboarding Config (`/admin/config/onboarding`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ ← Config   🎯 Onboarding Steps                                   │
├──────────────────────────────────────────────────────────────────┤
│ Mode: [Creator ▾]                                                │
│                                                                  │
│ ┌─ Step List (drag to reorder) ──────────────────────────────┐   │
│ │ ⠿ Step 1: Welcome + mode selection      [✅ Active] [✏️]  │   │
│ │ ⠿ Step 2: Connect accounts              [✅ Active] [✏️]  │   │
│ │ ⠿ Step 3: Import products (seller only) [✅ Active] [✏️]  │   │
│ │ ⠿ Step 4: Create first idea             [✅ Active] [✏️]  │   │
│ │ ⠿ Step 5: Explore AI Studio             [✅ Active] [✏️]  │   │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Conversion Tracking ──────────────────────────────────────┐   │
│ │ Step 1→2: 95% │ Step 2→3: 72% │ Step 3→4: 58% │ All: 45% │   │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ [+ Add step] [💾 Save order]                                     │
└──────────────────────────────────────────────────────────────────┘
```

### A30. Recipe Template Manager (`/admin/config/recipes`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ ← Config   📋 Workflow Recipes                   [+ Create]      │
├──────────────────────────────────────────────────────────────────┤
│ [Category ▾] [Status ▾]                                          │
│                                                                  │
│ ┌─ Recipe Card ───────────────────────────────────────────────┐  │
│ │ 📋 "Auto-respond to comments"              [🟢 Published]   │  │
│ │ Category: Engagement · Used by: 234 workspaces              │  │
│ │ Trigger: New comment → AI classify → Auto-reply             │  │
│ │ [✏️ Edit] [📊 Usage stats] [⏸ Unpublish]                   │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Recipe Card ───────────────────────────────────────────────┐  │
│ │ 📋 "Daily trend digest"                     [✏️ Draft]      │  │
│ │ Category: Intelligence · Used by: 0                         │  │
│ │ Trigger: Daily 8AM → Fetch trends → Generate brief          │  │
│ │ [✏️ Edit] [🚀 Publish] [🗑 Delete]                         │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### A28-A30 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Edit template | "Edit" | — | → Rich template editor with variables |
| Preview | "Preview" | `AdminNotificationService/Preview` | Rendered preview all channels |
| Test send | "Test send" → target | `AdminNotificationService/TestSend` | Test notification sent |
| Reorder steps | Drag & drop | `AdminOnboardingService/UpdateOrder` | Order saved |
| Edit step | "Edit" | — | Modal: copy, image, skip rule |
| Publish recipe | "Publish" | `AdminRecipeService/Publish` | Available to all users |

---

## A31-A33. Audit & Compliance

### A31. Audit Log (`/admin/audit`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ 📋 Audit Log                     [Date ▾] [Actor ▾] [Action ▾] │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ 10:05:23 [Admin:quan] USER_IMPERSONATE user:1234                │
│ 10:02:15 [System]     RATE_LIMIT_EXCEEDED workspace:456         │
│ 09:58:45 [Admin:minh] MANUAL_CREDIT_GRANT workspace:789 +100cr │
│ 09:55:01 [System]     SUBSCRIPTION_UPGRADE user:1235 free→pro  │
│ 09:50:30 [Admin:quan] CONTENT_MODERATION_REMOVE content:5678   │
│                                                                  │
│ [Export CSV] [Export JSON]                                        │
└──────────────────────────────────────────────────────────────────┘
```

### A31 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Filter | Dropdowns | `AuditLogService/List(filters)` | Log filtered |
| View detail | Click row | — | Drawer: full event payload |
| Export | "Export CSV/JSON" | `AuditLogService/Export` | File download |
| Navigate to entity | Click entity link | — | → relevant admin screen |

### A32. GDPR Tools (`/admin/compliance/gdpr`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ ← Compliance   🔒 GDPR Tools                                     │
├──────────────────────────────────────────────────────────────────┤
│ Tabs: [Data Export] [Data Deletion] [Consent] [Retention]        │
│                                                                  │
│ ── Data Export Tab ──                                             │
│ ┌─ Pending Requests ──────────────────────────────────────────┐  │
│ │ #GDPR-45 · user:1234 · Requested 2d ago · SLA: 28d left    │  │
│ │ Status: Processing (45%) · [📦 Force complete] [👁 View]    │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Data Deletion Tab ──                                          │
│ ┌─ Pending Deletions ─────────────────────────────────────────┐  │
│ │ #DEL-23 · user:5678 · Requested 5d ago · Grace: 25d left   │  │
│ │ Scope: All data + content · [⏸ Pause] [✅ Execute now]     │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Retention Tab ──                                              │
│ ┌─ Policy Status ─────────────────────────────────────────────┐  │
│ │ Logs: 90d ✅ · Sessions: 30d ✅ · Content: indefinite ✅    │  │
│ │ Deleted users: 14d post-deletion cleanup ✅                  │  │
│ │ Last cleanup: 2d ago · Next: in 5d                          │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### A33. Security Dashboard (`/admin/compliance/security`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ ← Compliance   🛡️ Security                                       │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Failed Logins (24h) ──────────────────────────────────────┐   │
│ │ Total: 45 │ Unique IPs: 12 │ Brute force detected: 2       │   │
│ │ [Bar chart: failed logins per hour]                         │   │
│ │ Top IP: 203.x.x.x (15 attempts) [🚫 Block IP]             │   │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Suspicious Activity ──────────────────────────────────────┐   │
│ │ ⚠️ user:9012 — 500 API calls in 1 min (normal: 50)         │   │
│ │ ⚠️ user:3456 — Login from 3 countries in 1 hour             │   │
│ │ [👁 Investigate] [⏸ Suspend user] [✅ False positive]       │   │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ API Key Anomalies ────────────────────────────────────────┐   │
│ │ ws_abc: API key used from unusual IP range                   │   │
│ │ [🔄 Rotate key] [👁 View usage]                             │   │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Admin Mutual Oversight ───────────────────────────────────┐   │
│ │ Admin:quan — 5 impersonations today · 2 suspensions         │   │
│ │ Admin:minh — 12 ticket resolutions · 0 escalations          │   │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### A31-A33 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Force export | "Force complete" → OTP | `AdminGDPRService/ForceExport` | Export accelerated |
| Execute deletion | "Execute now" → OTP | `AdminGDPRService/ExecuteDelete` | Deletion started |
| Block IP | "Block IP" → confirm | `AdminSecurityService/BlockIP` | IP blacklisted |
| Rotate API key | "Rotate key" → confirm | `AdminSecurityService/RotateKey` | Old key revoked |
| Investigate | "Investigate" | — | Drawer: full activity timeline |

---

## A34-A36. Additional Admin Screens

### A34. Email Campaign Manager (`/admin/emails`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ 📧 Email Campaigns                              [+ New campaign]  │
├──────────────────────────────────────────────────────────────────┤
│ Tabs: [Campaigns] [Transactional logs] [Templates]               │
│                                                                  │
│ ── Campaigns Tab ──                                              │
│ ┌─ Campaign Row ──────────────────────────────────────────────┐  │
│ │ 📧 "March Feature Update"                    [✅ Sent]       │  │
│ │ Audience: Pro users (456) · Sent: 25/3 · Open: 45%         │  │
│ │ Click: 12% · Bounce: 1.2% · Unsub: 0.3%                    │  │
│ │ [📊 Report] [📋 Duplicate]                                  │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Transactional Tab ──                                          │
│ [🔍 Search by email] [Status ▾] [Template ▾]                    │
│ 27/3 10:05 │ quan@email.com │ order_confirmation │ ✅ Delivered  │
│ 27/3 10:02 │ minh@email.com │ welcome_email      │ 🔴 Bounced   │
└──────────────────────────────────────────────────────────────────┘
```

### A35. File Storage Manager (`/admin/storage`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ 📁 File Storage                                                   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ R2 Overview ──────────────────────────────────────────────┐   │
│ │ Total: 245 GB / 1 TB │ Files: 125,000 │ Orphaned: 1,234    │   │
│ │ [Pie chart: storage by type — video 60%, image 25%, doc 15%]│   │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Per-Workspace Usage ──────────────────────────────────────┐   │
│ │ Workspace      │ Used    │ Limit  │ Files │ Largest file   │   │
│ │ ws_abc         │ 15.3 GB │ 50 GB  │ 3,456 │ 1.2 GB (video)│   │
│ │ ws_def         │ 2.1 GB  │ 10 GB  │ 890   │ 450 MB        │   │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Cleanup Actions ──────────────────────────────────────────┐   │
│ │ Orphaned files: 1,234 (8.5 GB) — files not linked to any   │   │
│ │ content. [👁 Preview list] [🗑 Clean up orphans]             │   │
│ │ Last cleanup: 14d ago                                       │   │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### A36. Admin Settings (`/admin/settings`)
```
┌─ Admin Shell ────────────────────────────────────────────────────┐
│ ⚙️ Admin Settings                                                 │
├──────────────────────────────────────────────────────────────────┤
│ Tabs: [Admin Users] [Roles] [System Defaults] [Maintenance]     │
│                                                                  │
│ ── Admin Users Tab ──                                            │
│ ┌─ Admin List ────────────────────────────────────────────────┐  │
│ │ Name        │ Role       │ MFA     │ Last login │ Actions   │  │
│ │ Admin Quân  │ SuperAdmin │ ✅ TOTP │ 2h ago     │ [✏️] [🗑]│  │
│ │ Admin Minh  │ Admin      │ ✅ TOTP │ 1d ago     │ [✏️] [🗑]│  │
│ │ [+ Add admin user]                                          │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Roles Tab ──                                                  │
│ ┌─ Permission Matrix ────────────────────────────────────────┐   │
│ │ Permission       │ SuperAdmin │ Admin │ Support │ Viewer   │   │
│ │ User management  │ ✅ Full    │ ✅    │ 👁 Read │ 👁 Read  │   │
│ │ Impersonate      │ ✅         │ ❌    │ ❌      │ ❌       │   │
│ │ Billing override │ ✅         │ ⚠️ OTP│ ❌      │ ❌       │   │
│ │ System config    │ ✅         │ ❌    │ ❌      │ ❌       │   │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Maintenance Tab ──                                            │
│ [🔴 Enable maintenance mode] — Shows "Đang bảo trì" to users   │
│ Scheduled: [Date picker] [Duration] [Message]                    │
│ [💾 Save settings]                                                │
└──────────────────────────────────────────────────────────────────┘
```

### A34-A36 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Create campaign | "New campaign" | — | → Campaign editor wizard |
| View report | "Report" | — | Drawer: full email metrics |
| Clean orphans | "Clean up" → OTP | `AdminStorageService/CleanOrphans` | Files deleted + size freed |
| Add admin | "Add admin" → form | `AdminSettingsService/CreateAdmin` | Admin user created |
| Toggle maintenance | Toggle → confirm | `AdminSettingsService/SetMaintenance` | Banner shown to all users |
| Edit role | Click cell | `AdminSettingsService/UpdateRole` | Permission changed |
