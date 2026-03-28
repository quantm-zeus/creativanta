# Screen: Admin — Dashboard

> **Screen ID**: A001
> **Module**: Admin — System Operations
> **Route**: `/admin`
> **Platform**: Admin Web (SvelteKit) — VPN-only access
> **Upstream**: Pack 01 §4, Product Freeze §33, S26, B5 RBAC (§3 Admin Roles)

---
## 1. Purpose & Context

The Admin Dashboard is the operations command center for Creativanta internal staff. It shows real-time system health, active user metrics, revenue KPIs, support queue, and operational alerts. This is a completely isolated system from the main workspace application — separate auth, separate codebase, VPN-only access.

### User Goals
- Monitor platform health and detect issues proactively
- Review business KPIs (users, revenue, churn)
- Triage support queue and escalations
- Identify AI cost anomalies and capacity issues

### Business Goals  
- Ensure platform uptime meets 99.5% SLA (PRD §32G.5)
- Maintain operational visibility across all subsystems
- Enable rapid incident response through real-time alerting
- Track business metrics for growth decisions

### When This Screen Is Used
- Daily: Operations team morning check
- Continuous: System monitoring during business hours
- On-call: Incident detection and response
- Weekly: Business review and reporting

### Entry Points
- Admin auth → `/admin` (VPN required)
- Direct URL (VPN only): `admin.creativanta.vn`
- Internal Slack alert → deep link to admin dashboard

### Exit Points
- Click nav item → respective admin section
- Click "Audit log" → A010
- Click "Support queue" → A026
- Click system health detail → A006
- Click user metric → A023 Usage Analytics

---
## 2. Preconditions / Postconditions

### Preconditions
- User is on VPN (IP allowlist check)
- Admin MFA verified (separate from Clerk — internal admin auth)
- User holds one of 8 admin roles (B5 §3)

### Postconditions
- Admin session logged in `admin_audit_log`
- Dashboard viewed event tracked for admin activity monitoring

---
## 3. Screen Layout

### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ 🏢 Creativanta Admin         [Super Admin] 👤 admin@creativanta.vn │
├──────────────────────────────────────────────────────────────────────┤
│ Admin Nav: [📊 Dashboard] [👥 Users] [💰 Billing] [🎫 Support]    │
│            [🛡 Moderation] [⚙ System] [📢 Announce] [🤖 AI]       │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ System Health (full width) ──────────────────────────────────┐   │
│ │ API: 🟢 99.9% (p99: 120ms) · DB: 🟢 OK (conn: 45/100)       │   │
│ │ Queue: 🟡 1,234 pending (5m avg) · Workers: 🟢 12/12 active  │   │
│ │ AI APIs: 🟡 OpenAI rate-limited (80%) · Anthropic: 🟢 OK     │   │
│ │ CDN: 🟢 OK · Storage: 🟢 62% used                             │   │
│ │ [→ System Health Detail]                                       │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Business KPIs (3×2 grid) ────────────────────────────────────┐   │
│ │ Workspaces │ MAU     │ DAU    │ MRR      │ Churn  │ ARPU     │   │
│ │ 1,234      │ 5,678   │ 1,234  │ 450M     │ 2.1%   │ 82K     │   │
│ │ +12% ↑     │ +8% ↑   │ +5% ↑  │ +15% ↑   │ ↓0.3%  │ +7% ↑  │   │
│ │ Period: [This Month ▾]                                         │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Operational Alerts ──────────────────────────────────────────┐   │
│ │ 🔴 3 abuse reports pending review (SLA: 4h remaining)         │   │
│ │ 🔴 2 support tickets breaching SLA (critical, 1h remaining)   │   │
│ │ 🟡 AI OpenAI rate limit at 80% capacity                       │   │
│ │ 🟡 Queue backlog growing: +500 in 1h (investigate)            │   │
│ │ 🟢 Scheduled maintenance: Saturday 02:00-04:00 UTC+7          │   │
│ │ [→ All alerts]                                                 │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Recent Activity ──────────────┐ ┌─ Support Queue ─────────────┐ │
│ │ 14:32 👤 "quanm" logged in     │ │ ⏳ 23 open tickets           │ │
│ │ 14:28 💳 ws "ABC" → Pro plan   │ │ 🔴 5 critical (SLA: 1h)    │ │
│ │ 14:25 📤 publish TikTok #1234  │ │ 🟡 8 high (SLA: 4h)        │ │
│ │ 14:20 🤖 AI spike: 200 req/min │ │ 🟢 10 normal (SLA: 24h)    │ │
│ │ 14:15 🚨 Abuse report #789     │ │ ⌀ Avg response: 2h 15m     │ │
│ │ [→ Full audit log]             │ │ [→ Support queue]            │ │
│ └────────────────────────────────┘ └──────────────────────────────┘ │
│                                                                      │
│ ┌─ AI Operations ────────────────┐ ┌─ Revenue (Today) ───────────┐ │
│ │ Today's AI calls: 45,234       │ │ 💰 Subscriptions: 12.5M VND │ │
│ │ AI spend: $42.50 / $100 budget │ │ 💎 Credit purchases: 3.2M   │ │
│ │ Credit consumption: 8,456      │ │ 📊 New trials: 23            │ │
│ │ Most used: Text gen (62%)      │ │ 💸 Refunds: 450K             │ │
│ │ [→ AI Operations]              │ │ [→ Revenue dashboard]        │ │
│ └────────────────────────────────┘ └──────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
AdminDashboardPage
├── AdminShell
│   ├── AdminTopBar
│   │   ├── AdminLogo ("🏢 Creativanta Admin")
│   │   ├── AdminRoleBadge (role name)
│   │   └── AdminUserMenu (email, logout, switch role if multi-role)
│   └── AdminNav (horizontal tabs)
│       └── NavItem[] (Dashboard, Users, Billing, Support, Moderation, System, Announce, AI)
├── SystemHealthBar (full width)
│   └── HealthIndicator[]
│       ├── ServiceName
│       ├── StatusDot (🟢/🟡/🔴)
│       ├── MetricSnippet (latency, connections, usage %)
│       └── DetailLink
├── KPIGrid (3×2)
│   └── KPICard[]
│       ├── MetricValue (animated counter)
│       ├── MetricLabel
│       ├── TrendDelta (↑/↓ + percentage + color)
│       └── Sparkline (30-day mini chart)
│   └── PeriodSelector (This Month / Last Month / This Quarter)
├── AlertPanel
│   └── AdminAlert[]
│       ├── SeverityIcon (🔴/🟡/🟢)
│       ├── AlertMessage
│       ├── SLACountdown (if applicable)
│       └── ActionLink
├── SplitRow
│   ├── RecentActivityFeed
│   │   └── ActivityItem[]
│   │       ├── Timestamp
│   │       ├── ActivityIcon
│   │       ├── Description
│   │       └── Link (optional)
│   └── SupportQueueSummary
│       ├── TotalOpen
│       ├── SeverityBreakdown (critical/high/normal)
│       ├── AvgResponseTime
│       └── ViewAllLink
├── SecondSplitRow
│   ├── AIOperationsSummary
│   │   ├── TodayCalls
│   │   ├── SpendBar (current / budget)
│   │   ├── CreditConsumption
│   │   ├── TopModelUsage
│   │   └── DetailLink
│   └── RevenueSummary
│       ├── SubscriptionRevenue
│       ├── CreditPurchases
│       ├── NewTrials
│       ├── Refunds
│       └── DetailLink
```

---
## 5. Displayed Data

| Element | Source | API | Format |
|---|---|---|---|
| System health | Internal monitoring (Prometheus/Grafana) | `AdminService/GetSystemHealth` | Status dots + metrics |
| Workspaces | `workspaces` count | `AdminService/GetDashboard` | Integer + trend % |
| MAU | `user_sessions` distinct 30d | same | Integer + trend % |
| DAU | `user_sessions` distinct today | same | Integer + trend % |
| MRR | `subscriptions` active recurring | same | VND compact "450M" |
| Churn | Computed monthly | same | Percentage "2.1%" |
| ARPU | MRR / active subscribers | same | VND compact "82K" |
| Activity feed | `admin_audit_log` last 50 | `AdminService/GetRecentActivity` | Timestamped list |
| Support tickets | `support_tickets WHERE status=open` | `AdminService/GetSupportSummary` | Count by severity |
| AI operations | `ai_usage_logs` today | `AdminService/GetAIOps` | Call count + spend |
| Revenue | `billing_events` today | `AdminService/GetRevenueSummary` | VND amounts |
| Alerts | Admin-level alerts + SLA breaches | `AdminAlertService/GetActive` | Priority-sorted |

---
## 6. User Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Navigate to section | Click nav item | — | → respective admin page | Role-dependent |
| 2 | View system health detail | "→ System Health Detail" | — | → A006 | `admin:system_health` |
| 3 | View audit log | "→ Full audit log" | — | → A010 | `admin:audit_log:read` |
| 4 | View support queue | "→ Support queue" | — | → A026 | `admin:support:manage` |
| 5 | View AI operations | "→ AI Operations" | — | → A011 | `admin:ai_ops` |
| 6 | View revenue | "→ Revenue dashboard" | — | → A022 | `admin:analytics:read` |
| 7 | Dismiss alert | Click ✕ on alert | `AdminAlertService/Dismiss` | Alert hidden, action logged | Any admin role |
| 8 | Change KPI period | Period selector | `AdminService/GetDashboard(period)` | KPIs update | `admin:analytics:read` |
| 9 | View all alerts | "→ All alerts" | — | Expand alert panel or navigate | Any admin role |

---
## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial page load | KPI skeletons + health bar loading indicators |
| LOADED | All data received | Full admin dashboard rendered |
| PARTIAL_DEGRADED | Some APIs fail | Working widgets + error card for failed ones |
| SYSTEM_DEGRADED | System health shows 🔴 items | Red prominent banner: "Cảnh báo hệ thống" + pulsing health bar |
| MAINTENANCE | Maintenance mode active | Full-page banner: "Hệ thống đang bảo trì. Dự kiến hoàn thành: {time}" |
| ERROR | All APIs fail | "Không tải được Admin Dashboard. [Thử lại]" |

---
## 8. Permission Matrix (Admin RBAC — 8 Roles per B5 §3)

> **IMPORTANT**: Admin RBAC is completely isolated from workspace RBAC. These are the 8 admin roles defined in B5 §3.1.

| Feature | Super Admin | Operations | Finance | Content | Support | Tech | Analyst | Auditor |
|---|---|---|---|---|---|---|---|---|
| View dashboard | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| System health bar | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| Business KPIs | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ | ✅ |
| Revenue metrics | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ | ✅ |
| Operational alerts | ✅ | ✅ | ✅ (finance) | ✅ (content) | ✅ (support) | ✅ (system) | ❌ | ❌ |
| Activity feed | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ | ❌ | ✅ |
| Support queue summary | ✅ | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ |
| AI operations | ✅ | ❌ | ✅ (cost) | ❌ | ❌ | ✅ (capacity) | ✅ (usage) | ❌ |
| Navigate to sections | ✅ All | ✅ All | ✅ Finance | ✅ Content | ✅ Support | ✅ System | ✅ Analytics | ✅ Audit |

### Dashboard Personalization by Role
- **Super Admin / Operations**: Sees all widgets
- **Finance Admin**: Sees KPIs, Revenue, AI cost (no system health, no activity feed)
- **Content Admin**: Sees Alerts (content-related), Moderation metrics
- **Support Admin**: Sees Support Queue, Activity feed (support-scoped), Alerts (support-related)
- **Tech Admin**: Sees System Health, Queue metrics, Activity feed, AI capacity
- **Analyst**: Sees KPIs, Revenue, AI usage stats only
- **Auditor**: Sees KPIs, Activity feed, Audit-related alerts only

---
## 9. Admin-Specific Security

| Feature | Detail |
|---|---|
| Access control | VPN (IP allowlist) + Admin auth (NOT Clerk) + MFA required |
| Session | 4hr idle timeout. 24hr max session. |
| No workspace context | Admin sees ALL workspaces (platform-level view) |
| Audit | All admin actions logged with IP, timestamp, user, action |
| IP allowlist | Only Creativanta office IPs + approved VPN endpoints |
| Impersonation | Only Super Admin + Operations Admin (read-only mode for Support Admin) |

---
## 10. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| System health | WebSocket | Real-time (5s heartbeat) |
| Support queue count | SSE | Real-time |
| Activity feed | SSE | Real-time |
| KPIs | Polling | Every 30 seconds |
| Alerts | WebSocket | Real-time |
| AI operations | Polling | Every 60 seconds |
| Revenue | Polling | Every 5 minutes |

---
## 11. Technical Implementation Notes

- Route: `src/routes/admin/+page.svelte` (separate route group from main app)
- Auth: Separate admin auth middleware, NOT Clerk. Custom JWT with admin roles.
- Shell: Admin Shell is completely separate from App Shell — no shared components
- SSR: Full SSR for layout, client-side hydration for real-time data
- Data refresh: configurable per widget (30s default, 5s for system health)
- Audit logging: Every page view and action logged to `admin_audit_log`

---
## 12. Edge Cases

| Edge Case | Handling |
|---|---|
| VPN disconnects during session | Show "VPN kết nối bị gián đoạn. Kiểm tra VPN và tải lại trang." |
| Admin has multiple roles | Dashboard shows union of all permitted widgets |
| System in maintenance mode | Override dashboard with maintenance status page + estimated completion |
| First admin login of day | Show "Daily operations briefing" modal with overnight summary |
| MFA token expires | Redirect to MFA re-verification (no silent refresh for admin) |

---
## 13. Navigation Map

```
Admin Dashboard (/admin)
├── → /admin/users                    (User Management)
├── → /admin/billing                  (Billing Overview)
├── → /admin/support                  (Support Queue)
├── → /admin/moderation               (Content Moderation)
├── → /admin/system                   (System Health Detail)
├── → /admin/announce                 (Notification Broadcast)
├── → /admin/ai                       (AI Operations)
├── → /admin/audit                    (Audit Log)
├── → /admin/revenue                  (Revenue Dashboard)
```

---
## 14. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| VPN disconnected | Network/VPN down | Full-page: "VPN kết nối bị gián đoạn. Kiểm tra VPN và tải lại trang." | Reconnect VPN + refresh |
| Auth expired | Session timeout (4hr idle / 24hr max) | Redirect to admin MFA re-verification | Re-authenticate |
| API error (single widget) | Server 5xx on one endpoint | Widget shows inline error card "Không tải được [widget]. [Thử lại]" | Per-widget retry |
| API error (all) | Server down | Full-page: "Admin Dashboard không khả dụng. [Thử lại] [Liên hệ Engineering]" | Retry or contact on-call |
| Permission denied | 403 on role-gated widget | Widget hidden (not shown, not error) | Contact Super Admin for role change |
| Rate limited | 429 from monitoring endpoints | Toast: "Too many requests. Auto-retry in 30s." | Auto-retry with backoff |

---
## 15. Validation Rules

N/A — Admin Dashboard is a read-only monitoring screen. No form inputs.

---
## 16. Accessibility

| Element | Requirement |
|---|---|
| KPI cards | `role="status"`, `aria-label` with metric name + value (e.g., "Monthly Recurring Revenue: 450 million VND") |
| System health bar | `role="status"`, `aria-live="polite"` for real-time updates |
| Alert panel | `role="alert"`, `aria-live="assertive"` for critical alerts |
| Activity feed | `role="log"`, `aria-live="polite"` for new entries |
| Navigation | Full keyboard navigation with visible focus indicators |
| Color coding | Service status uses 🟢/🟡/🔴 dots WITH text labels (not color-only) |
| Contrast | All text meets WCAG 2.1 AA (4.5:1 ratio) |
| Focus management | Tab order: Health bar → KPIs → Alerts → Activity → Support → AI Ops → Revenue |

---
## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `admin.dashboard.viewed` | Page load | `admin_id`, `admin_role`, `session_type` |
| `admin.alert.clicked` | Click alert action | `alert_type`, `severity`, `sla_remaining` |
| `admin.alert.dismissed` | Dismiss alert | `alert_type`, `alert_id` |
| `admin.kpi.period_changed` | Change period selector | `period`, `previous_period` |
| `admin.nav.clicked` | Click nav item | `destination`, `admin_role` |
| `admin.widget.retry` | Retry failed widget | `widget_name`, `error_type` |

> All admin events are logged to `admin_audit_log` (immutable, 7-year retention).

---
## 18. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Shell render | 0ms | Admin shell renders immediately (SSR). Admin nav + topbar visible. |
| Skeleton phase | 0-300ms | All widget areas show shimmer skeletons matching final layout |
| System health bar | 100-500ms | Health indicators populate first (highest priority) |
| KPIs + Alerts | 200-800ms | KPI counters animate from 0 to value. Alerts slide in. |
| Activity feed + Support | 300-1000ms | Lists populate with staggered animation |
| AI Ops + Revenue | 400-1200ms | Lower priority widgets load last |
| Real-time connection | 500-2000ms | WebSocket/SSE channels established for live updates |

---
## 19. Performance Requirements

| Metric | Target | Measurement |
|---|---|---|
| LCP | < 2.0s | System Health bar or first KPI card |
| FID | < 100ms | First click on any nav/alert |
| CLS | < 0.05 | No layout shift after skeleton → content |
| TTI | < 2.5s | All widgets interactive |
| WebSocket latency | < 100ms | System health real-time updates |
| API batch load | ≤ 6 parallel calls | Dashboard data split by widget priority |

---
## 20. Localization Notes

- Admin interface: **English only** (internal tool)
- User-generated content displayed as-is (may contain Vietnamese)
- Dates: ISO 8601 format (`2026-03-28T14:32:00Z`)
- Currency: USD for AI costs, VND for revenue with Intl.NumberFormat
- Numbers: US formatting (comma for thousands: 12,450)
- Timestamps: relative ("2h ago") for activity feed, absolute for audit

---
## 21. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-admin-accent` | Primary actions, active nav, CTA buttons |
| `--color-admin-success` | 🟢 Healthy status, positive changes |
| `--color-admin-warning` | 🟡 Degraded status, approaching limits |
| `--color-admin-danger` | 🔴 Critical status, SLA breach, errors |
| `--color-admin-surface` | Card backgrounds, widget containers |
| `--color-admin-surface-elevated` | Alert panel, system health bar |
| `--color-admin-text-primary` | Main text |
| `--color-admin-text-secondary` | Labels, timestamps, descriptions |
| `--font-admin-metric` | KPI numbers (tabular-nums, monospace) |
| `--spacing-admin-grid-gap` | Grid gap between widgets (20px) |
| `--radius-admin-card` | Admin card radius (8px — more subdued than user app) |

---
## 22. Related Screens

| Screen | Relationship |
|---|---|
| [A002] User List | User management |
| [A006] System Health | Deep system diagnostics |
| [A010] Audit Log | Full audit trail |
| [A011] AI Operations | AI monitoring detail |
| [A022] Revenue Dashboard | Revenue detail |
| [A026] Support Queue | Support ticket management |

---
## 20. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 2.0 | **Major revision**: Fixed RBAC from 4 ad-hoc roles to canonical 8 admin roles per B5 §3. Added role-based dashboard personalization method. Added system health detail, AI operations summary, revenue summary widgets. Added security details, real-time update specs, edge cases, navigation map. | System |
| 2026-03-27 | 1.0 | Initial specification | System |
