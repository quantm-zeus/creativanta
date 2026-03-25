# Creativanta — Supplementary Spec S26 — Internal Admin & Operations Site v3.1

## 0. Traceability Header

- **Upstream**: PRD §29 (Beginner-friendly), Product Freeze §46A.4 (RBAC), Pack 02 §14 (Security), Pack 06 §10 (Admin Override), S25 (Enterprise & Internal Ops), S19 (Customer Support)
- **Pack dependencies**: Pack 02 (Backend/Schema), Pack 06 (Commerce/Finance), Pack 08 (Pricing/Credits)
- **New objects introduced**: Internal Admin User, Internal Role, Internal Permission, Internal Audit Log, System Alert, Moderation Case, Impersonation Session, Feature Flag Override, System Announcement, Fraud Case, Incident, Post-Mortem, Webhook Subscription Monitor, API Key Admin Record.
- **Scope**: Bắt buộc trước launch — hệ thống production không thể vận hành mà không có admin site riêng biệt.

---

## 1. Tổng Quan & Nguyên Tắc Kiến Trúc

### 1.1 Tại Sao Cần Admin Site Riêng

Admin site là **ứng dụng hoàn toàn tách biệt** khỏi Creativanta main app:

| Aspect | Main App (creativanta.app) | Admin Site (admin.creativanta.app) |
|---|---|---|
| **Đối tượng** | End users (creators, sellers) | Internal operators (Creativanta team) |
| **Access** | Public internet | Internal-only (VPN / IP whitelist / Zero-Trust) |
| **Auth** | Clerk (email/social login) | Separate auth với MFA bắt buộc |
| **RBAC** | 7 workspace roles (Owner→External) | Internal role hierarchy (Super Admin→Read-only) |
| **Database** | Shared PostgreSQL (different schema/views) | Read/write qua internal API layer |
| **Deployment** | Public CDN | Private deployment, không indexed |

### 1.2 Nguyên Tắc Core

1. **Zero-Trust**: Admin site KHÔNG truy cập được từ public internet. Yêu cầu VPN/Cloudflare Access + MFA.
2. **Principle of Least Privilege**: Mỗi internal admin chỉ thấy/làm được đúng chức năng được cấp.
3. **Full Auditability**: Mọi action trên admin site tạo audit log (actor, target, old_value, new_value, timestamp, IP).
4. **Read-first, Write-gated**: Đa số actions là read/view. Write actions yêu cầu confirmation + reason.
5. **Non-destructive**: Không có nút "Delete forever" trên admin site. Tất cả là soft-delete + archive.
6. **Impersonation with Guardrails**: Có thể view-as-user nhưng KHÔNG được mutate data khi impersonating.

---

## 2. Internal Admin RBAC

### 2.1 Internal Role Hierarchy

> **QUAN TRỌNG**: Đây là hệ thống role TÁCH BIỆT hoàn toàn khỏi workspace roles (Owner/Admin/Manager/...).

| Role | Level | Scope | Description |
|---|---|---|---|
| **Super Admin** | L0 | Global | Quyền tuyệt đối. Quản lý hệ thống, cấp/thu hồi quyền cho tất cả admin. Chỉ Founder/CTO nắm. Max 2-3 người. |
| **Operations Admin** | L1 | Global | Quản lý user, workspace, billing, support. Không được modify system config hoặc feature flags. |
| **Finance Admin** | L1 | Finance domain | Revenue, billing, refunds, payouts, cost tracking. Không thấy user PII ngoài billing scope. |
| **Content Admin** | L1 | Content domain | Moderation, DMCA, AUP enforcement, recipe marketplace review. |
| **Support Admin** | L1 | Support domain | Ticket management, user communication, impersonation (view-only). |
| **Technical Admin** | L1 | Technical domain | System health, infra monitoring, feature flags, deployment, incident management. |
| **Analyst** | L2 | Read-only | Dashboard access, reports, analytics. KHÔNG có write permission. |
| **Auditor** | L2 | Audit-only | Audit logs, compliance reports, security events. KHÔNG modify data. |

### 2.2 Super Admin Exclusive Controls

Chỉ Super Admin mới có thể:
- Tạo/xóa/modify Internal Admin accounts
- Assign/revoke roles cho Internal Admins
- Override feature flags globally
- Access raw database queries (read-only SQL console)
- Modify system-wide configuration (pricing tiers, credit rates, etc.)
- Trigger manual billing runs / credit adjustments hàng loạt
- View/export complete audit logs
- Activate/deactivate "Emergency mode" (system-wide freeze)
- Access impersonation với write capability (cần OTP mỗi lần)

### 2.3 Permission Matrix

| Permission | Super Admin | Ops Admin | Finance Admin | Content Admin | Support Admin | Tech Admin | Analyst | Auditor |
|---|---|---|---|---|---|---|---|---|
| **User Management** | ✅ Full | ✅ Full | ❌ | ❌ | ✅ View + Notes | ❌ | ✅ View | ❌ |
| **Workspace Management** | ✅ Full | ✅ Full | ✅ Billing only | ❌ | ✅ View | ❌ | ✅ View | ❌ |
| **Billing / Revenue** | ✅ Full | ✅ View | ✅ Full | ❌ | ✅ View | ❌ | ✅ View | ✅ View |
| **Refund / Credit Adj** | ✅ Full | ✅ Request | ✅ Approve | ❌ | ✅ Request | ❌ | ❌ | ✅ View |
| **Content Moderation** | ✅ Full | ❌ | ❌ | ✅ Full | ❌ | ❌ | ❌ | ❌ |
| **Support Tickets** | ✅ Full | ✅ View | ❌ | ❌ | ✅ Full | ❌ | ❌ | ❌ |
| **System Config** | ✅ Full | ❌ | ❌ | ❌ | ❌ | ✅ Full | ❌ | ❌ |
| **Feature Flags** | ✅ Full | ❌ | ❌ | ❌ | ❌ | ✅ Full | ❌ | ❌ |
| **Infra Health** | ✅ Full | ✅ View | ❌ | ❌ | ❌ | ✅ Full | ✅ View | ❌ |
| **Audit Logs** | ✅ Full | ✅ Own actions | ✅ Finance logs | ✅ Content logs | ✅ Support logs | ✅ Tech logs | ❌ | ✅ Full |
| **Impersonation** | ✅ R/W (OTP) | ✅ Read-only | ❌ | ❌ | ✅ Read-only | ❌ | ❌ | ❌ |
| **Admin Management** | ✅ Full | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Fraud & Abuse** | ✅ Full | ✅ Full | ✅ Financial fraud | ❌ | ❌ | ❌ | ✅ View | ✅ View |
| **Job Queues / DLQ** | ✅ Full | ❌ | ❌ | ❌ | ❌ | ✅ Full | ✅ View | ❌ |
| **Webhooks & Connectors** | ✅ Full | ❌ | ❌ | ❌ | ❌ | ✅ Full | ✅ View | ❌ |
| **API Key Management** | ✅ Full | ✅ Suspend/Revoke | ❌ | ❌ | ❌ | ✅ Full | ❌ | ❌ |
| **Incident Management** | ✅ Full | ✅ View | ❌ | ❌ | ❌ | ✅ Full | ✅ View | ❌ |

### 2.4 Internal Admin Authentication

- **MFA bắt buộc** cho tất cả internal admins (TOTP authenticator app, không SMS)
- **Session timeout**: 30 phút inactive → auto-logout
- **IP whitelist**: chỉ access từ VPN hoặc Cloudflare Access tunnel
- **Login anomaly**: new device/IP → email verification + alert Super Admin
- **Max concurrent sessions**: 1 per admin (login mới kills session cũ)
- **Password policy**: min 16 chars, complexity + rotation mỗi 90 ngày
- **Emergency access**: Super Admin có recovery key (offline, printed, in safe)

---

## 3. Admin Dashboard — Command Center

### 3.1 Dashboard Layout

Dashboard chính chia làm 4 vùng:

```
┌─────────────────────────────────────────────────────────┐
│  [Logo] CREATIVANTA OPS CENTER        [User] [Search]   │
├──────────┬──────────────────────────────────────────────┤
│          │  📊 LIVE METRICS BAR                         │
│          │  Users: 12,450 | MRR: $45.2K | Active: 1,203│
│  SIDE    │──────────────────────────────────────────────│
│  NAV     │                                              │
│          │  [Customizable Widget Grid]                  │
│  ▸ Home  │                                              │
│  ▸ Users │  ┌──────────┐ ┌──────────┐ ┌──────────┐    │
│  ▸ Work  │  │ Revenue  │ │  AI Cost │ │  Alerts  │    │
│  ▸ Bill  │  │  Chart   │ │  Chart   │ │  Panel   │    │
│  ▸ AI    │  └──────────┘ └──────────┘ └──────────┘    │
│  ▸ Cont  │  ┌──────────┐ ┌──────────┐ ┌──────────┐    │
│  ▸ Supp  │  │ Sign-ups │ │  Churn   │ │  System  │    │
│  ▸ Infra │  │  Trend   │ │  Risk    │ │  Health  │    │
│  ▸ Logs  │  └──────────┘ └──────────┘ └──────────┘    │
│  ▸ Conf  │                                              │
└──────────┴──────────────────────────────────────────────┘
```

### 3.2 Live Metrics Bar (Always Visible)

| Metric | Source | Refresh |
|---|---|---|
| Total registered users | PostgreSQL | 5 min |
| DAU / MAU | PostHog / analytics | 1 min |
| Active workspaces (last 24h) | Session tracking | 5 min |
| MRR / ARR | Billing system | Hourly |
| AI credits consumed today | Credit ledger | Real-time |
| AI cost today (USD) | Provider cost tracker | Real-time |
| Open support tickets | Ticket system | Real-time |
| Active alerts | Alert system | Real-time |
| System health score | Composite (0-100) | 30s |

### 3.3 Alert Center (Critical — Always Accessible)

| Alert Type | Trigger | Severity | Auto-Action |
|---|---|---|---|
| **Revenue anomaly** | MRR drops > 5% vs previous week | 🔴 Critical | Email Super Admin + Finance Admin |
| **Churn spike** | Daily cancellations > 2× average | 🔴 Critical | Notify Ops Admin |
| **AI cost overrun** | Daily AI cost > 120% budget | 🟡 Warning | Notify Finance + Tech Admin |
| **Mass credit abuse** | Workspace burns > 10× daily average | 🔴 Critical | Auto-throttle + notify Ops |
| **System health < 90** | Composite health score drop | 🔴 Critical | Notify Tech Admin + PagerDuty |
| **Failed payments surge** | > 10% payment failures in 1 hour | 🟡 Warning | Notify Finance Admin |
| **Security event** | Brute force, suspicious login, data export | 🔴 Critical | Auto-block + notify Super Admin |
| **Platform API degraded** | TikTok/FB/Shopee API errors > 30% | 🟡 Warning | Show degraded badge + notify Tech |
| **Storage approaching limit** | System storage > 80% capacity | 🟡 Warning | Notify Tech Admin |
| **AUP violation detected** | AI moderation flags content | 🟡 Warning | Create moderation case + notify Content Admin |

---

## 4. User Management Console

### 4.1 User Explorer

**Search & Filter:**
- Search by: email, name, user ID, workspace name, phone
- Filter by: plan tier, registration date, last active, country, operator mode, status (active/suspended/churned)
- Sort by: registration date, last activity, revenue generated, AI credits used, workspace count

**User Profile View:**

```
┌─────────────────────────────────────────────────────────┐
│  👤 User: Nguyễn Văn A                                  │
│  ID: usr_abc123 | Email: a@example.com                  │
│  Registered: 2026-01-15 | Last active: 2h ago           │
│  Status: ✅ Active | Plan: Pro | Mode: Creator           │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  [Account] [Workspaces] [Billing] [AI Usage] [Support]  │
│  [Activity] [Connected Accounts] [Security] [Notes]     │
│                                                         │
│  📊 Quick Stats:                                        │
│  - Workspaces: 2 (1 owner, 1 member)                   │
│  - Total revenue tracked: 45.2M VND                     │
│  - AI credits used this month: 234 / 500                │
│  - Support tickets: 3 (2 resolved, 1 open)              │
│  - Connected accounts: TikTok, Facebook, Shopee          │
│  - Content published: 156 posts                          │
│  - Account age: 71 days                                  │
│                                                         │
│  ⚡ Quick Actions:                                       │
│  [Impersonate (View)] [Send Email] [Add Note]           │
│  [Adjust Credits] [Change Plan] [Suspend] [Reset Pass]  │
└─────────────────────────────────────────────────────────┘
```

### 4.2 User Actions (Write Operations)

| Action | Required Role | Confirmation | Audit |
|---|---|---|---|
| View user profile | Support+  | None | View logged |
| Add internal note | Support+ | None | Yes |
| Send system email | Ops Admin+ | Preview confirmation | Yes |
| Adjust AI credits | Finance Admin+ (request) → Super Admin (approve > 100 credits) | Reason required | Yes |
| Change plan/tier | Finance Admin+ | Reason + confirmation | Yes |
| Issue refund | Finance Admin+ | Amount + reason + approval if > $50 | Yes |
| Suspend account | Ops Admin+ | Reason + duration required | Yes + user email |
| Unsuspend account | Ops Admin+ | Confirmation | Yes + user email |
| Reset password | Support Admin+ | Confirmation | Yes + user email |
| Force disconnect OAuth | Ops Admin+ | Reason required | Yes |
| Delete account (GDPR) | Super Admin only | OTP + double confirmation | Yes + compliance log |
| Impersonate (view-only) | Support Admin+ | Logged + time-limited (30 min) | Full session recorded |
| Impersonate (write) | Super Admin only | OTP each time | Full session recorded |

### 4.3 Impersonation Protocol

> **Impersonation = View app as user** — dùng để debug, support, verify.

**Rules:**
- Impersonation session tối đa 30 phút (auto-expire)
- User KHÔNG được thông báo (tránh confusion) nhưng audit log ghi đầy đủ
- Read-only impersonation: Support Admin+. Chỉ xem screens, KHÔNG click buttons có side effects.
- Write impersonation: Super Admin only + OTP mỗi lần. Extremely rare — chỉ dùng cho critical bug fix.
- Impersonation với billing/payment scope: BLOCKED (even Super Admin phải dùng Finance Admin tools)
- Banner hiển thị: `🔴 IMPERSONATING: user@email.com | [End Session]` — luôn visible cho admin
- Mọi page view, click, và action trong impersonation session logged vào audit trail

---

## 5. Workspace Management Console

### 5.1 Workspace Explorer

**View per workspace:**
- Workspace info: name, ID, created date, owner, plan, member count
- Subscription status: active, trial, grace period, suspended, churned
- Usage metrics: storage used vs limit, AI credits used vs quota, connected accounts
- Financial summary: MRR contribution, total revenue tracked, outstanding invoices
- Health indicators: connector status, last activity, compliance status

### 5.2 Workspace Health Score (0-100)

| Factor | Weight | Healthy | Warning | Critical |
|---|---|---|---|---|
| Active usage (last 7d) | 20% | Daily activity | 1-3 days gap | > 7 days inactive |
| Payment status | 25% | Current | Retry pending | Failed / Grace period |
| Connected accounts health | 15% | All healthy | 1+ degraded | All disconnected |
| AI credit utilization | 10% | 10-80% used | > 90% used | Exhausted |
| Storage utilization | 10% | < 70% | 70-90% | > 90% |
| Support ticket open | 10% | 0 open | 1-2 open | 3+ open or escalated |
| Content activity | 10% | Regular publishing | Declining | No publish in 14d |

### 5.3 Churn Risk Detection

| Signal | Weight | Detection Method |
|---|---|---|
| Login frequency declining | 25% | Compare last 7d vs previous 7d |
| Content creation stopped | 20% | No new scripts/videos in 14d |
| Connected accounts disconnecting | 15% | OAuth disconnect events |
| Support tickets unresolved | 10% | Open tickets > 7d |
| Plan downgrade intent | 15% | Visited pricing page, cancel page |
| Payment method about to expire | 15% | Card expiry within 30 days |

- **Score**: 0-100 (0 = likely to churn, 100 = highly engaged)
- **Action threshold**: Score < 40 → flag for Ops Admin review → trigger retention campaign
- **Auto-actions**: Score < 20 → auto-send "We miss you" email → assign to Support for outreach

---

## 6. Billing & Revenue Console

### 6.1 Revenue Dashboard

| Metric | Period | Visualization |
|---|---|---|
| MRR / ARR | Real-time | Line chart (30d trend) |
| New MRR | Monthly | Bar chart (new subscriptions) |
| Expansion MRR | Monthly | Bar chart (upgrades) |
| Contraction MRR | Monthly | Bar chart (downgrades) |
| Churn MRR | Monthly | Bar chart (cancellations) |
| Net MRR Movement | Monthly | Waterfall chart |
| ARPU | Monthly | Line chart |
| LTV | Computed | Per cohort |
| CAC | If marketing data available | Per channel |
| LTV:CAC ratio | Computed | Target > 3:1 |

### 6.2 Payment Management

| Action | Tool |
|---|---|
| View all invoices | Filter by status (paid, pending, failed, refunded) |
| Retry failed payment | Manual retry button + reason |
| Issue refund | Amount, reason, type (full/partial/credit) |
| Apply promotional credit | Credit amount + reason + expiry |
| Override plan/tier | Change plan + effective date + reason |
| Extend trial | Duration + reason |
| Pause subscription | Duration + resume date |
| Void invoice | Reason required |
| Generate statement | Per workspace, date range, format (PDF/CSV) |

### 6.3 Dunning Management

| Stage | Day | Action | Admin Visibility |
|---|---|---|---|
| Payment failed | D0 | Auto-retry #1 + email | Orange badge |
| Retry #2 | D3 | Auto-retry + push notification | Orange badge |
| Retry #3 | D7 | Auto-retry + email with urgency | Yellow badge |
| Retry #4 | D10 | Email: "Update payment to avoid service interruption" | Red badge |
| Grace period start | D14 | Read-only mode + in-app banner | Red badge + alert |
| Final notice | D21 | "Last chance" email | Red badge + escalation |
| Auto-downgrade | D30 | Downgrade to Free + data archived (not deleted) | Churned label |

Admin can: skip stages, extend grace period, manually resolve, add notes per case.

### 6.4 AI Cost Control Panel

| View | Content |
|---|---|
| **System-wide AI cost** | Total cost today/week/month vs budget. Per-provider breakdown (Gemini, Claude, GPT, HeyGen). |
| **Per-workspace cost** | Top 50 workspaces by AI cost. Flag anomalies (> 3× average). |
| **Per-operation cost** | Cost breakdown by operation type (text gen, video gen, image gen, analysis). |
| **Margin analysis** | AI cost vs credit revenue per tier. Alert if margin < 30%. |
| **Provider health** | Circuit breaker status, latency p50/p95/p99, error rate per provider. |
| **Rate card management** | Edit credit costs per operation type (e.g., "Quick Edit = 5 credits"). |

**Admin Actions:**
- Adjust credit-to-cost ratio per operation type
- Set daily/weekly AI spend caps per-workspace tier
- Override provider routing (e.g., "force all video gen to Gemini for 24h")
- View real-time provider spend waterfall
- Block specific workspace from AI operations (abuse case)

---

## 7. Content Moderation Console

### 7.1 Moderation Queue

Content flagged by:
- AI auto-moderation (OpenAI Moderation API, Gemini Safety)
- User reports (from Link-in-Bio, marketplace, etc.)
- Automated AUP scans
- Platform policy violation detection (S14)

**Moderation Case Object:**
```
ModerationCase:
  id: UUID
  case_type: enum(content_report, aup_violation, dmca, spam, abuse, fraud)
  status: enum(pending, in_review, action_taken, dismissed, escalated)
  severity: enum(low, medium, high, critical)
  reported_object_type: string (e.g., "link_in_bio", "recipe", "profile")
  reported_object_id: UUID
  workspace_id: FK → Workspace
  reported_by: enum(ai_auto, user_report, admin_manual, system_scan)
  assigned_to: FK → Internal Admin (nullable)
  evidence: json (screenshots, URLs, content snapshot)
  resolution: text (nullable)
  resolution_action: enum(no_action, warning_sent, content_removed, account_suspended, account_banned)
  created_at, updated_at, resolved_at: timestamp
```

### 7.2 Moderation Actions

| Action | Effect | Notification |
|---|---|---|
| Dismiss | Close case, no action | None |
| Warning | Flag on user account (1st strike) | Email: "Your content was flagged..." |
| Remove content | Soft-delete content + archive | Email: "Content removed due to..." |
| Suspend workspace | 7/14/30 day suspension | Email + in-app banner |
| Ban workspace | Permanent suspension | Email + data export option (30 days) |
| Escalate to Legal | Forward to legal team | Internal notification |

### 7.3 AUP Enforcement Matrix

| Violation | 1st Offense | 2nd Offense | 3rd Offense |
|---|---|---|---|
| Spam / mass low-quality | Warning | 7-day suspend + content removal | Permanent ban |
| Copyright (DMCA) | Content removal (48h) | Content removal + warning | 30-day suspend |
| Phishing / malware | Immediate removal + warning | 30-day suspend | Permanent ban |
| Adult content | Content removal + warning | 7-day suspend | Permanent ban |
| Fraud / financial scam | Immediate suspend (investigation) | Permanent ban | — |
| Hate speech / violence | Content removal + warning | 30-day suspend | Permanent ban |
| Platform API abuse | Throttle + warning | 7-day suspend | Permanent ban |

---

## 8. Support Management Console

### 8.1 Ticket Dashboard

Extends S19 (Customer Support) with admin-side interface:

| View | Content |
|---|---|
| **Queue** | All open tickets sorted by priority × SLA remaining time |
| **My tickets** | Tickets assigned to current admin |
| **Unassigned** | Tickets not yet picked up → auto-assign based on load |
| **SLA breaching** | Tickets exceeding response/resolution SLA → red highlight |
| **Trends** | Top issue categories this week, average resolution time, CSAT score |

### 8.2 Ticket View

```
┌───────────────────────────────────────────────────────┐
│  Ticket #TK-4523 | Priority: High | SLA: 2h remaining │
│  User: user@email.com | Plan: Pro | Mode: Seller       │
├───────────────────────────────────────────────────────┤
│                                                       │
│  Subject: "Video không publish được lên TikTok"        │
│                                                       │
│  📎 Auto-captured: browser, OS, route, last 5 errors  │
│  👤 Workspace: Cool Fashion | Connected: TikTok ✅     │
│                                                       │
│  [Conversation Thread]                                 │
│  - User: "Tôi thử publish nhưng bị lỗi..."            │
│  - AI Bot: "Bạn hãy thử reconnect TikTok account..."  │
│  - User: "Vẫn không được"                              │
│  - [ESCALATED TO HUMAN]                                │
│                                                       │
│  ⚡ Quick Actions:                                     │
│  [Reply] [Impersonate (View)] [Check Diagnostics]     │
│  [Assign] [Escalate] [Link to Bug] [Close]            │
│                                                       │
│  📋 Internal Notes: (only visible to admin team)       │
│  [Add Note]                                            │
└───────────────────────────────────────────────────────┘
```

### 8.3 Support Analytics

| Metric | Target | Visualization |
|---|---|---|
| First response time | Per SLA tier | Distribution chart |
| Resolution time | Per SLA tier | Distribution chart |
| CSAT score | > 4.0 / 5.0 | Trend line |
| Ticket volume | — | Daily/weekly bar chart |
| Top categories | — | Pie chart |
| AI resolution rate | > 60% | Percentage |
| Escalation rate | < 30% | Percentage |
| Reopened tickets | < 5% | Percentage |

---

## 9. System Health & Infrastructure Console

### 9.1 System Health Dashboard

Extends S25.6 (Internal Health Dashboard):

| Panel | Metrics | Alert Threshold |
|---|---|---|
| **Web App** | Response time, error rate, uptime | Error > 1% or p99 > 3s |
| **API** | Request volume, latency p50/p95/p99, error rate | Error > 0.5% or p99 > 1s |
| **Database** | Connection pool, query latency, replication lag | Connections > 80% or lag > 5s |
| **Cache (Dragonfly)** | Hit rate, memory usage, eviction rate | Hit < 90% or memory > 80% |
| **Search (Meilisearch)** | Indexing lag, query latency, index size | Lag > 30s or latency > 200ms |
| **Queue (Dragonfly Streams)** | Depth, processing rate, dead-letter count | Depth > 10K or DLQ > 100 |
| **AI Providers** | Latency, error rate, circuit breaker status | Per-provider threshold |
| **Storage (R2)** | Usage, bandwidth, error rate | Usage > 80% capacity |
| **CDN (Cloudflare)** | Cache hit ratio, bandwidth, threat count | Hit < 85% or threats spike |
| **Platform Connectors** | TikTok/FB/Shopee API health, webhook delivery | Error > 10% per platform |

### 9.2 Feature Flag Management

| Control | Detail |
|---|---|
| List all flags | Name, status (on/off), target (global/tier/workspace/user), created by |
| Toggle flag | On/off + rollout percentage (0-100%) |
| Target flag | By tier (Free/Starter/Pro), by workspace ID, by user ID |
| History | Who toggled what, when, with what rollout % |
| Dependencies | Which flags depend on which |
| Emergency kill switch | One-click disable feature for all users |

### 9.3 Deployment & Release Management

| View | Content |
|---|---|
| Current version | Git SHA, deploy time, deployer |
| Canary status | Traffic %, error delta vs stable, metrics comparison |
| Rollback button | One-click rollback to previous version |
| Release notes | Auto-generated from Git commits |
| Deployment history | Last 30 deploys with metrics before/after |

---

## 10. Analytics & Reporting Console

### 10.1 Business Metrics

| Report | Content | Frequency |
|---|---|---|
| **Executive Summary** | MRR, ARR, user growth, churn, ARPU, LTV | Daily digest |
| **Cohort Analysis** | Retention by signup month, revenue by cohort | Weekly |
| **Funnel Analysis** | Signup → Onboarding → First publish → Paid conversion | Daily |
| **Feature Adoption** | % users using each module (M01-M23) | Weekly |
| **Mode Distribution** | % users per operator mode (Creator/Seller/etc.) | Daily |
| **Geographic** | Users by country/region | Weekly |
| **Platform Distribution** | Connected accounts by platform (TikTok/FB/Shopee) | Weekly |

### 10.2 Operational Reports

| Report | Content | Audience |
|---|---|---|
| **AI Cost Report** | Per-provider, per-operation, per-tier cost breakdown | Finance Admin |
| **Storage Report** | Per-workspace storage usage, growth trend, cleanup effectiveness | Tech Admin |
| **Credit Utilization** | Usage vs allocation per tier, over-usage patterns | Finance Admin |
| **Connector Health** | Platform API stability, failure rates, degradation history | Tech Admin |
| **Support Report** | Ticket volume, resolution times, CSAT, top issues | Ops Admin |
| **Moderation Report** | Cases handled, AUP violations, strike distribution | Content Admin |
| **Security Report** | Login anomalies, brute force attempts, suspicious activities | Super Admin |
| **Compliance Report** | GDPR requests processed, data deletions, consent records | Auditor |

### 10.3 Custom Report Builder

- Drag-and-drop report builder cho Analyst role
- Data sources: users, workspaces, billing, AI usage, support, content
- Export: PDF, CSV, Excel
- Scheduled reports: daily/weekly/monthly email delivery đến team
- Template library: pre-built reports cho common use cases

---

## 11. System Configuration Console

### 11.1 Global Configuration (Super Admin Only)

| Config Area | Controls |
|---|---|
| **Pricing** | Tier pricing (VND/USD), credit allocation per tier, overage rates |
| **AI Credit Rates** | Credits per operation type (text gen, video gen, image gen, analysis) |
| **Rate Limits** | Global rate limits, per-tier rate limits, per-platform rate limits |
| **Storage Limits** | Per-tier storage quotas, temp file TTL, cleanup schedule |
| **SLA Configuration** | Support response times per tier, escalation timeouts |
| **AUP Rules** | Violation categories, strike thresholds, auto-action rules |
| **Email Templates** | System emails (welcome, billing, suspension, etc.) |
| **Platform Connector Config** | API keys per platform, rate limit settings, webhook URLs |
| **Maintenance Mode** | Toggle maintenance mode (read-only for all users + banner) |

### 11.2 System Announcements

| Field | Detail |
|---|---|
| Title | Short announcement title |
| Body | Rich text content |
| Type | info / warning / success / critical |
| Target | All users / specific tier / specific mode / specific workspace |
| Display | Banner / Modal / Notification |
| Schedule | Immediate / scheduled date |
| Expiry | Auto-dismiss after date |
| Dismissable | Yes / No |

---

## 12. Audit & Compliance Console

### 12.1 Audit Log Explorer

**Internal Admin Audit Log:**
```
InternalAuditLog:
  id: UUID
  actor_admin_id: FK → Internal Admin
  actor_role: string
  action: string (e.g., "user.suspend", "billing.refund", "config.update")
  target_type: string (e.g., "user", "workspace", "config")
  target_id: string
  old_value: json (nullable)
  new_value: json (nullable)
  reason: text (required for write actions)
  ip_address: string
  user_agent: string
  timestamp: timestamp
  session_type: enum(normal, impersonation)
```

- **Retention**: Audit logs retained for 7 years (compliance requirement)
- **Immutable**: Append-only, không thể edit hoặc delete
- **Search**: Full-text search by actor, action, target, date range
- **Export**: CSV/JSON for compliance audits

### 12.2 GDPR Compliance Tools

| Tool | Function |
|---|---|
| **Data Subject Request** | Process "Right to Access" requests — export all user data |
| **Data Deletion Request** | Process "Right to Erasure" — full data deletion workflow |
| **Consent Dashboard** | View consent records per user (marketing, analytics, AI processing) |
| **Data Processing Log** | Record of all data processing activities (GDPR Article 30) |
| **Breach Notification** | Template + workflow for 72-hour breach notification |

### 12.3 Security Events

| Event Type | Detection | Response |
|---|---|---|
| Brute force login | > 10 failed attempts in 5 min | Auto-block IP + alert |
| Unusual data export | Large data download | Alert Ops + confirm with user |
| API key abuse | Abnormal request patterns | Alert Tech + throttle |
| Cross-tenant attempt | IDOR detection (should never happen) | Alert Super Admin + auto-block + incident |
| Admin privilege escalation | Unauthorized admin action attempt | Alert Super Admin + session kill |

---

## 13. Communication & Outreach Console

### 13.1 System Email Management

| Email Type | Trigger | Customizable |
|---|---|---|
| Welcome email | User signup | Template editable |
| Trial expiry reminder | 3 days before trial ends | Template + timing |
| Payment failure | Payment attempt fails | Template editable |
| Plan change confirmation | Upgrade/downgrade | Template editable |
| Suspension notice | Account suspended | Template editable |
| Feature announcement | New feature launch | Full custom |
| Retention outreach | Churn risk score < 40 | Full custom |

### 13.2 Bulk Communication

- Target by: tier, mode, activity level, country, registration cohort
- Preview: show estimated audience count before send
- A/B testing: split audience for subject line / content testing
- Schedule: immediate or scheduled
- Rate limit: max 10,000 emails/hour (prevent spam flag)
- Unsubscribe: automatic unsubscribe link + respect preferences

---

## 14. Fraud & Abuse Detection Console

### 14.1 Fraud Detection Dashboard

| Signal | Detection | Auto-Action |
|---|---|---|
| **Trial abuse** | Same device/IP creates multiple Free accounts | Auto-flag + block trial for device fingerprint |
| **Multi-account fraud** | Same credit card across multiple workspaces claiming separate free tiers | Alert Finance Admin + merge suggestion |
| **Chargeback pattern** | User disputes > 2 payments in 90 days | Auto-suspend + escalate to Finance Admin |
| **Credit gaming** | Create workspace → use all free credits → abandon → create new workspace | Device fingerprint block + alert Ops |
| **Referral abuse** | Self-referral loop or bot referrals detected | Freeze referral rewards + alert Ops |
| **Scraping / Data harvesting** | Abnormal API call patterns, mass data download | Rate limit → temp block → alert Tech Admin |
| **Marketplace fraud** | Fake recipe reviews, stolen recipe content | AI scan + Content Admin review |

### 14.2 Device & Identity Intelligence

| Data Point | Purpose |
|---|---|
| Device fingerprint | Detect multi-account abuse across same device |
| IP geolocation + history | Detect suspicious location changes, VPN abuse |
| Browser/app fingerprint | Link accounts silently using same browser profile |
| Credit card BIN + last 4 | Cross-reference payment methods across accounts |
| Email pattern analysis | Detect disposable email domains, plus-addressing abuse |
| Behavioral biometrics | Abnormal click patterns, bot-like interactions |

### 14.3 Fraud Case Management

```
FraudCase:
  id: UUID
  fraud_type: enum(trial_abuse, multi_account, chargeback, credit_gaming, referral_abuse, scraping, marketplace_fraud)
  severity: enum(low, medium, high, critical)
  status: enum(detected, investigating, confirmed, false_positive, resolved)
  implicated_users: UUID[] (array of user IDs)
  evidence: json (device fingerprints, IP logs, payment data, behavioral data)
  financial_impact: decimal (estimated or actual loss)
  assigned_to: FK → Internal Admin
  resolution: text
  resolution_action: enum(no_action, warning, credit_revoked, account_suspended, account_banned, legal_referral)
  created_at, resolved_at: timestamp
```

**Admin Actions:**
- View linked accounts (multi-account map visualization)
- Merge duplicate accounts (with user consent)
- Revoke fraudulently obtained credits/rewards
- Block device fingerprint from creating new accounts
- Generate fraud impact report per period

---

## 15. Job Queue & Background Task Monitor

### 15.1 Queue Dashboard

Real-time visibility vào tất cả async workers & queues:

| Queue | Metrics | Alert |
|---|---|---|
| **Publish Queue** | Depth, processing rate, avg wait time, oldest job age | Depth > 5K or oldest > 30 min |
| **AI Processing Queue** | Depth, GPU utilization, avg processing time, failures | Depth > 1K or failure > 5% |
| **Email Queue** | Depth, send rate, bounce rate, complaint rate | Bounce > 2% or complaint > 0.1% |
| **Webhook Outbound** | Depth, delivery rate, retry count, DLQ count | DLQ > 50 or delivery < 95% |
| **Media Processing** | Active jobs, avg duration, ffmpeg errors | Errors > 3% or avg > 5 min |
| **Scheduled Tasks** | Next run times, last run status, skipped count | Any "failed" or "skipped > 3" |
| **Platform Sync** | Per-platform sync queue, lag, error rate | Lag > 10 min per platform |

### 15.2 Dead-Letter Queue (DLQ) Management

| Action | Detail |
|---|---|
| View DLQ messages | Message payload, error reason, original queue, retry count |
| Retry single message | Re-enqueue with backoff |
| Retry batch | Re-enqueue all matching messages (filter by error type) |
| Purge | Delete messages from DLQ (with reason + audit) |
| Export | Export DLQ messages for debugging (JSON) |

### 15.3 Scheduled Task Viewer

| Control | Detail |
|---|---|
| List all cron jobs | Name, schedule (cron expression), last run, next run, status |
| Trigger manual run | Force-execute a scheduled task immediately |
| Pause/resume | Temporarily disable a scheduled task |
| View execution history | Last 100 runs: duration, status, output summary, errors |
| Set alerting | Configure alerts per task (failure, duration threshold, skip) |

### 15.4 Workflow/Saga State Inspector

- View all active workflow runs (Workflow Studio M20)
- Per-run detail: current step, history, pending compensations
- Force-complete or force-cancel stuck workflows (Tech Admin+, with reason)
- View saga compensation history (which steps were rolled back)
- Alert on stuck workflows (no progress > configured threshold)

---

## 16. Webhook & Connector Health Console

### 16.1 Outbound Webhook Monitor (S24 Public API)

| View | Content |
|---|---|
| **Active subscriptions** | List all webhook consumers, endpoint URLs, event types subscribed |
| **Delivery dashboard** | Success rate, avg latency, failure rate per consumer |
| **Retry queue** | Failed deliveries pending retry, retry count, next attempt |
| **DLQ** | Permanently failed deliveries (max retries exceeded) |
| **Payload inspector** | View sent payload, response status, response headers (for debugging) |

**Admin Actions:**
- Disable a webhook subscription (abuse or causing load)
- Manually retry failed delivery
- View consumer health score (reliability %)
- Set per-consumer rate limit override
- Export delivery logs per consumer

### 16.2 Inbound Webhook Monitor (Platform → Creativanta)

| Platform | Metrics |
|---|---|
| TikTok | Webhook delivery rate, signature verification failures, processing lag |
| Facebook/Instagram | Graph API webhook health, challenge verification, rate limit remaining |
| Shopee/Lazada | Order webhook delivery, product sync status, error rate |
| Stripe | Payment event delivery, signature verification, processing lag |

**Admin Actions:**
- View failed inbound webhooks (unprocessed events)
- Re-trigger processing for missed events
- View platform rate limit dashboard (remaining quota per platform)
- Toggle platform integration on/off (emergency isolation)

### 16.3 Connected Account Health Matrix

```
┌────────────────────────────────────────────────────────────────┐
│  Platform Health Matrix (Real-time)                            │
├──────────┬──────────┬──────────┬──────────┬──────────────────┤
│ Platform │ Status   │ Error %  │ Rate Lim │ Affected Users   │
├──────────┬──────────┬──────────┬──────────┬──────────────────┤
│ TikTok   │ 🟢 OK    │ 0.3%     │ 72%      │ 0                │
│ Facebook │ 🟡 Slow  │ 2.1%     │ 89%      │ 12               │
│ Shopee   │ 🟢 OK    │ 0.1%     │ 45%      │ 0                │
│ Stripe   │ 🟢 OK    │ 0.0%     │ 15%      │ 0                │
│ YouTube  │ 🔴 Down  │ 45%      │ 100%     │ 342              │
└──────────┴──────────┴──────────┴──────────┴──────────────────┘
```

---

## 17. Public API Key Management

### 17.1 API Key Lifecycle (Extends S24)

| State | Description |
|---|---|
| **Active** | Key is live, currently used for API access |
| **Suspended** | Key temporarily disabled (abuse investigation or user request) |
| **Revoked** | Key permanently disabled, cannot be re-activated |
| **Expired** | Key past expiry date (if set), auto-disabled |

### 17.2 Admin Controls

| Action | Required Role | Detail |
|---|---|---|
| View all API keys | Tech Admin+ | List all issued keys: workspace, scopes, created, last used, request count |
| View key usage analytics | Tech Admin+ | Requests/day, error rate, endpoints hit, rate limit hits |
| Suspend key | Ops Admin+ | Immediately disable key + reason + notify workspace owner |
| Revoke key | Ops Admin+ | Permanently disable + reason + notify workspace owner |
| Override rate limit | Tech Admin+ | Increase/decrease rate limit for specific key (temporary) |
| View abuse patterns | Tech Admin+ | Keys with highest error rates, rate limit violations, suspicious patterns |

### 17.3 API Key Abuse Detection

| Signal | Threshold | Action |
|---|---|---|
| Rate limit hits > 100/hour | Per-key monitoring | Alert Tech Admin |
| 4xx error rate > 50% | Sustained over 1 hour | Alert Tech Admin + auto-suspend key |
| Unusual endpoint access | Accessing admin-only or internal endpoints | Alert Super Admin + immediate suspend |
| Data exfiltration pattern | Mass GET requests across many resources | Alert Super Admin + throttle |

---

## 18. Incident Management Console

### 18.1 Incident Dashboard

| View | Content |
|---|---|
| **Active incidents** | Currently impacting incidents with severity, affected services, ETA |
| **Incident history** | Last 90 days, searchable by service, severity, root cause |
| **Status page control** | Manage public status page (S19 integration) |

### 18.2 Incident Lifecycle

```
Detected → Acknowledged → Investigating → Identified → Monitoring → Resolved → Post-mortem
```

| Phase | Actions |
|---|---|
| **Detected** | Auto-detected from alerts or manually created |
| **Acknowledged** | Tech Admin claims incident, sets severity (Sev1-Sev4) |
| **Investigating** | Update status, assign team members, link related alerts |
| **Identified** | Root cause identified, document fix plan, update ETA |
| **Monitoring** | Fix deployed, monitoring for recurrence |
| **Resolved** | Incident closed, resolution documented |
| **Post-mortem** | Requires post-mortem document within 48h for Sev1-Sev2 |

### 18.3 Status Page Management

| Control | Detail |
|---|---|
| Service status | Set per-service status: Operational / Degraded Performance / Partial Outage / Major Outage |
| Public updates | Post incident updates visible on public status page (status.creativanta.app) |
| Scheduled maintenance | Announce planned maintenance windows |
| Subscriber notifications | Email subscribers about status changes |
| Uptime tracking | Rolling 90-day uptime percentage per service |

### 18.4 Post-Mortem Template

```
Post-Mortem:
  incident_id: UUID
  title: string
  severity: enum(sev1, sev2, sev3, sev4)
  duration: interval (start → resolved)
  impact: text (users affected, revenue impact, data impact)
  timeline: json (array of timestamped events)
  root_cause: text
  contributing_factors: text[]
  action_items: json (array of {action, owner, deadline, status})
  lessons_learned: text
  created_by: FK → Internal Admin
  approved_by: FK → Super Admin (required for Sev1-2)
  created_at: timestamp
```

---

## 19. FE/UX Contract

### 19.1 Design Principles

- **Information density**: Admin cần thấy nhiều data — denser layout so với main app
- **Dark mode default**: Reduce eye strain cho long sessions
- **Keyboard shortcuts**: Power users cần navigate nhanh (Cmd+K search, keyboard nav)
- **Responsive**: Desktop-first nhưng phải usable trên tablet
- **Loading states**: Skeleton loaders cho mọi data panel
- **Error handling**: Admin sees detailed error info (stack traces cho Tech Admin, friendly messages cho others)

### 19.2 Navigation Structure

```
Home (Dashboard)
├── Users
│   ├── User Explorer
│   ├── User Segments
│   └── Churn Risk List
├── Workspaces
│   ├── Workspace Explorer
│   ├── Health Scores
│   └── Usage Analytics
├── Billing
│   ├── Revenue Dashboard
│   ├── Payment Management
│   ├── Dunning Queue
│   ├── Refund Requests
│   └── Credit Adjustments
├── AI Operations
│   ├── Cost Dashboard
│   ├── Provider Health
│   ├── Usage by Workspace
│   ├── Rate Card Management
│   └── Anomaly Alerts
├── Content
│   ├── Moderation Queue
│   ├── AUP Cases
│   ├── DMCA Cases
│   ├── Marketplace Reviews
│   └── Link-in-Bio Reports
├── Support
│   ├── Ticket Queue
│   ├── My Tickets
│   ├── SLA Dashboard
│   └── Knowledge Base Editor
├── Infrastructure
│   ├── System Health
│   ├── Feature Flags
│   ├── Deployments
│   ├── Incidents                ← NEW
│   └── Status Page Control      ← NEW
├── Jobs & Queues                ← NEW
│   ├── Queue Dashboard
│   ├── Dead-Letter Queue
│   ├── Scheduled Tasks
│   └── Workflow Inspector
├── Webhooks & Connectors        ← NEW
│   ├── Outbound Webhook Monitor
│   ├── Inbound Webhook Monitor
│   ├── Connected Account Health
│   └── API Key Management       ← NEW
├── Fraud & Abuse                ← NEW
│   ├── Fraud Dashboard
│   ├── Device Intelligence
│   ├── Fraud Cases
│   └── Abuse Patterns
├── Communication
│   ├── System Emails
│   ├── Bulk Outreach
│   └── Announcements
├── Analytics
│   ├── Business Metrics
│   ├── Operational Reports
│   └── Custom Reports
├── Configuration
│   ├── Pricing & Credits
│   ├── Rate Limits
│   ├── Email Templates
│   ├── Announcements
│   └── Connector Config
├── Team
│   ├── Admin Users (Super Admin only)
│   ├── Roles & Permissions
│   └── Activity Log
└── Audit
    ├── Audit Log Explorer
    ├── Compliance (GDPR)
    └── Security Events
```

---

## 20. Tech Stack & Deployment

### 20.1 Technology

| Layer | Choice | Rationale |
|---|---|---|
| **Frontend** | SvelteKit 2 (separate app) | Consistent with main app stack, SSR for security |
| **API** | Shared Rust Axum backend | Thêm admin-scoped endpoints + middleware |
| **Auth** | Separate auth system (NOT Clerk) | Internal users khác end users. Self-hosted auth hoặc Keycloak. |
| **Database** | Same PostgreSQL, admin-specific views/schemas | Cost effective, nhưng isolated access |
| **Hosting** | Same Contabo VPS, separate Docker container | Behind VPN/Cloudflare Access tunnel |
| **Monitoring** | Prometheus + Grafana dashboards embedded | Real-time metrics |

### 20.2 Security Architecture

```
Internet → Cloudflare Access (Zero-Trust) → VPN Tunnel → Admin App
                    │
              MFA Required
              IP Whitelist
              Session 30min timeout
                    │
              Admin API Layer (separate middleware)
                    │
              ┌─────┴─────┐
              │ Read APIs  │ ← Most admin actions
              │ Write APIs │ ← Gated by role + audit log
              └────────────┘
                    │
              PostgreSQL (RLS + admin-scoped policies)
```

### 20.3 Deployment Rules

- Admin site deploys independently from main app
- Admin API endpoints live on separate route prefix (`/internal/admin/v1/`)
- Admin routes registered in same Axum app nhưng behind `InternalAdminAuthMiddleware`
- Rate limiting stricter cho admin writes (max 50 write operations/min)
- All admin API responses stripped of internal implementation details

---

## 21. Implementation Priority

| Phase | Modules | When |
|---|---|---|
| **Phase 0** (Pre-launch) | Auth + RBAC, User Explorer, Basic Dashboard, Audit Logs | Week 1-2 |
| **Phase 1** (Launch) | Billing Console, Support Console, System Health, Incident Management | Week 3-4 |
| **Phase 2** (Post-launch) | AI Cost Dashboard, Moderation Queue, Job Queue Monitor, Webhook Console | Week 5-6 |
| **Phase 3** (Growth) | Fraud Detection, Custom Reports, Bulk Communication, API Key Management, Advanced Analytics | Week 7-8 |

---

## 22. Acceptance Scenarios

- Super Admin creates Ops Admin account → Ops Admin can manage users but NOT config → verified
- Ops Admin tries to access System Config → denied → audit logged
- Support Admin impersonates user → sees user's dashboard (read-only) → session auto-expires in 30 min
- Super Admin impersonates user with write → OTP required → action performed → full audit trail
- Finance Admin issues $30 refund → auto-approved → processed → audit logged
- Finance Admin issues $100 refund → requires Super Admin approval → approved → processed → audit logged
- Revenue anomaly detected (MRR drop 7%) → alert created → Super Admin + Finance Admin notified → investigation initiated
- Workspace burns 10× daily AI credits → auto-throttle → Ops Admin notified → investigates → either release or suspend
- User reports Link-in-Bio page (phishing) → moderation case created → Content Admin reviews → content removed → user warned
- Payment fails 3× → dunning flow visible in admin → Finance Admin extends grace period → user updates card → resolved
- Churn risk score drops to 25 → flagged in dashboard → Ops Admin assigns retention outreach → email sent
- Tech Admin toggles feature flag to 10% rollout → monitors metrics → expands to 100% → all tracked in audit
- System health drops to 85 → alert fired → Tech Admin checks → identifies DB connection issue → resolves
- GDPR deletion request submitted → Super Admin processes → all user data exported then deleted → compliance log created
- Admin session inactive 31 min → auto-logged out → must re-authenticate with MFA
- Suspicious login from new IP → session blocked → Super Admin alerted → verifies admin identity → unblocks
- Trial abuse detected: same device creates 3rd free account → auto-blocked → Ops Admin reviews → confirms fraud → device fingerprint banned
- Publish queue depth exceeds 5K → alert fired → Tech Admin checks → identifies bottleneck → scales worker → queue drains
- Outbound webhook delivery drops to 85% for a consumer → alert → Tech Admin investigates → consumer endpoint down → disables subscription → notifies consumer
- YouTube API goes down → inbound webhook monitor shows 45% errors → auto-isolates YouTube connector → status page updated → incident created → resolved when API recovers
- Public API key shows 60% error rate → auto-suspended → workspace owner notified → Tech Admin investigates → key re-enabled after fix
- Sev1 incident created → Tech Admin acknowledges → status page updated to "Major Outage" → fix deployed → monitoring → resolved → post-mortem created within 48h
- Dead-letter queue accumulates 200 failed publish jobs → alert → Tech Admin views errors → identifies API change → fixes adapter → retries batch → all succeed
