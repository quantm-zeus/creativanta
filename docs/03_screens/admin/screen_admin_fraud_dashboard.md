# Screen: Admin — Fraud Dashboard

> **Screen ID**: A028
> **Module**: Admin — Fraud & Abuse Detection
> **Route**: `/admin/fraud`
> **Platform**: Admin Web (SvelteKit) — VPN-only access
> **Upstream**: S26 §14, B5 RBAC §3 Admin Roles, PRD §32G

---

## 1. Purpose & Context

The Fraud Dashboard is the central hub for detecting, investigating, and resolving fraud and abuse patterns across the Creativanta platform. It surfaces automated fraud signals, provides device/identity intelligence, and enables case-based investigation workflows.

### User Goals
- Identify active fraud patterns (trial abuse, multi-account, credit gaming, referral abuse)
- Investigate linked accounts and suspicious behaviors
- Take enforcement actions (warning, suspend, ban, revoke credits)
- Track fraud case resolution and financial impact

### Business Goals
- Minimize platform revenue loss from fraud (target: <0.5% of total credits)
- Protect shared domain reputation (creativanta.link)
- Maintain referral program integrity
- Comply with payment processor fraud prevention requirements

### When This Screen Is Used
- Daily: Review automated fraud alerts
- On-demand: Investigate specific fraud cases
- Weekly: Review fraud metrics and trends

### Entry Points
- Admin Dashboard (A001) → Alerts panel → Fraud alerts
- Admin Navigation: "🔍 Fraud & Abuse"
- Admin search: fraud case ID / user email

### Exit Points
- Click user → A003 User Detail
- Click workspace → A005 Workspace Detail
- Click "Create moderation case" → A015 Moderation Queue
- Click "View audit trail" → A010 Audit Log

---

## 2. Preconditions / Postconditions

### Preconditions
- Admin authenticated via VPN + MFA
- Role: Super Admin, Operations Admin, Finance Admin (financial fraud only), Analyst (view only), Auditor (view only)

### Postconditions
- Fraud cases created/updated logged in `admin_audit_log`
- Enforcement actions (suspend/ban/credit revoke) applied to target users
- Financial impact calculated and tracked

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ 🏢 Creativanta Admin  [Fraud & Abuse]  [Super Admin] 👤 admin@...  │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Fraud Signals (full width) ─────────────────────────────────┐    │
│ │ 🔴 Trial Abuse: 5 detected ─ 🔴 Multi-Account: 3 ─ 🟡 Ref: 2│   │
│ │ 🟡 Credit Gaming: 1 ─ 🟡 Scraping: 1 ─ Period: [30d ▾]      │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Active Cases ───────────────────────────────────────────────┐    │
│ │ [All ▾] [Severity ▾] [Type ▾] [Status ▾] [🔍 Search...]     │    │
│ │ ┌──────────────────────────────────────────────────────────┐  │    │
│ │ │ 🔴 FC-1234 | Trial Abuse | Critical                      │  │    │
│ │ │ usr_abc, usr_def — same device fingerprint                │  │    │
│ │ │ Created: 2h ago | Impact: $12.50 credits | [Investigate]  │  │    │
│ │ │──────────────────────────────────────────────────────────│  │    │
│ │ │ 🔴 FC-1235 | Multi-Account | High                        │  │    │
│ │ │ Same CC across 3 workspaces — 2,450 credits consumed     │  │    │
│ │ │ Created: 1d ago | Impact: $45.00 | [Investigate]          │  │    │
│ │ │──────────────────────────────────────────────────────────│  │    │
│ │ │ 🟡 FC-1236 | Referral Abuse | Medium                     │  │    │
│ │ │ Self-referral loop — 5 accounts from same IP              │  │    │
│ │ │ Created: 3d ago | Impact: $25.00 credits | [Investigate]  │  │    │
│ │ └──────────────────────────────────────────────────────────┘  │    │
│ │ Showing 1-10 of 23 | [← Prev] [Next →]                       │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Fraud Metrics (30d) ──────────┐ ┌─ Device Intelligence ──────┐  │
│ │ Total cases: 45                 │ │ Blocked fingerprints: 12    │  │
│ │ Resolved: 38 | Open: 7          │ │ Flagged IPs: 23             │  │
│ │ False positive: 6 (13%)         │ │ Disposable emails: 8        │  │
│ │ Est. prevented loss: $1,234     │ │ Linked account groups: 15   │  │
│ │ Credits revoked: 4,560          │ │ [→ Full Intelligence]       │  │
│ │ Accounts suspended: 8           │ │                              │  │
│ │ [→ Fraud Report]                │ │                              │  │
│ └─────────────────────────────────┘ └──────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
FraudDashboardPage
├── AdminShell (shared)
├── FraudSignalBar (full width)
│   └── SignalIndicator[] (type, count, severity dot)
│       └── PeriodSelector (7d / 30d / 90d)
├── ActiveCasePanel
│   ├── FilterBar
│   │   ├── StatusFilter (all, detected, investigating, confirmed, false_positive, resolved)
│   │   ├── SeverityFilter (low, medium, high, critical)
│   │   ├── TypeFilter (trial_abuse, multi_account, chargeback, credit_gaming, referral_abuse, scraping, marketplace_fraud)
│   │   └── SearchInput (case ID, user email, workspace name)
│   ├── CaseList
│   │   └── CaseRow[]
│   │       ├── SeverityIcon
│   │       ├── CaseID + FraudType badge
│   │       ├── ImplicatedUsers (linked user IDs)
│   │       ├── Description (auto-generated from detection signals)
│   │       ├── Timestamps (created, last updated)
│   │       ├── FinancialImpact (estimated loss)
│   │       └── ActionButton ("Investigate" → opens case detail)
│   └── Pagination
├── MetricsGrid (2 columns)
│   ├── FraudMetricsCard
│   │   ├── TotalCases
│   │   ├── ResolvedVsOpen
│   │   ├── FalsePositiveRate
│   │   ├── PreventedLoss
│   │   ├── CreditsRevoked
│   │   └── AccountsSuspended
│   └── DeviceIntelligenceCard
│       ├── BlockedFingerprints
│       ├── FlaggedIPs
│       ├── DisposableEmails
│       └── LinkedAccountGroups
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Fraud signals | `fraud_cases` aggregation by type | `AdminFraudService/GetSignals(period)` | Count per type + severity dot | 5m TTL |
| Case list | `fraud_cases` with filters | `AdminFraudService/ListCases(filters, page)` | Paginated case rows | 2m TTL |
| Fraud metrics | Aggregated from resolved cases | `AdminFraudService/GetMetrics(period)` | Counts + percentages + USD | 15m TTL |
| Device intelligence | `device_fingerprints`, `blocked_ips` | `AdminFraudService/GetDeviceIntel` | Counts | 15m TTL |
| Financial impact | Computed from revoked credits + prevented fraud | `AdminFraudService/GetImpact(period)` | USD amount | 15m TTL |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Filter cases | Filter controls | `AdminFraudService/ListCases(filters)` | — | Case list updates | Any fraud-viewing role |
| 2 | Search cases | Search input | `AdminFraudService/SearchCases(query)` | — | Case list updates | Any fraud-viewing role |
| 3 | Open case detail | Click "Investigate" | — | — | Navigate → `/admin/fraud/[id]` | Super Admin, Ops Admin, Finance Admin |
| 4 | Create manual case | Click "Create Case" | `AdminFraudService/CreateCase(data)` | New fraud case created | Toast "Case created" + navigate to detail | Super Admin, Ops Admin |
| 5 | Bulk action | Select cases + action | `AdminFraudService/BulkAction(ids, action)` | Cases updated | Toast "X cases updated" | Super Admin only |
| 6 | Export report | Click "Fraud Report" | `AdminFraudService/ExportReport(period)` | — | Download CSV/PDF | Super Admin, Ops Admin, Analyst |
| 7 | Change period | Period selector | `AdminFraudService/GetSignals(period)` | — | Signals + metrics update | Any fraud-viewing role |
| 8 | View linked accounts | Click link group | — | — | Open linked-accounts visualization | Super Admin, Ops Admin |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial page load | Skeleton shimmer for signal bar + case list |
| LOADED | All data received | Full dashboard rendered |
| EMPTY | No fraud cases detected | "Không có trường hợp gian lận nào trong khoảng thời gian này. 🎉" |
| ERROR | API failure | Error message with retry button |
| FILTERED_EMPTY | Filters applied, no results | "Không tìm thấy kết quả phù hợp. [Xóa bộ lọc]" |

---

## 8. Permission Matrix (Admin RBAC — 8 Roles per B5 §3)

| Feature | Super Admin | Operations | Finance | Content | Support | Tech | Analyst | Auditor |
|---|---|---|---|---|---|---|---|---|
| View dashboard | ✅ | ✅ | ✅ (financial) | ❌ | ❌ | ❌ | ✅ (read) | ✅ (read) |
| View case detail | ✅ | ✅ | ✅ (financial) | ❌ | ❌ | ❌ | ✅ (read) | ✅ (read) |
| Create case | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Take action (warn/suspend/ban) | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Revoke credits | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Block device fingerprint | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Export reports | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ | ✅ |
| View device intelligence | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |

---

## 9. Navigation Map

```
Fraud Dashboard (/admin/fraud)
├── → /admin/fraud/[id]               (Case detail — investigate)
├── → /admin/users/[id]               (View implicated user)
├── → /admin/workspaces/[id]          (View implicated workspace)
├── → /admin/moderation               (Create moderation case)
├── → /admin/audit                    (View audit trail)
└── ← /admin                          (Back to admin dashboard)
```

---

## 10. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| VPN disconnected | Network/VPN down | Full-page VPN error | Reconnect VPN + refresh |
| Auth expired | Session timeout | Redirect to admin MFA | Re-authenticate |
| API error | Server 5xx | Widget error card with retry | Per-widget retry |
| Permission denied | Insufficient role | Page shows "Insufficient permissions" | Contact Super Admin |

---

## 11. Accessibility

| Element | Requirement |
|---|---|
| Case list | `role="list"`, keyboard navigable rows |
| Severity indicators | Color + icon + text label (not color-only) |
| Signal bar | `role="status"`, `aria-live="polite"` |
| Action buttons | Clear `aria-label` describing the action |
| Focus management | Tab order: Signals → Filters → Case list → Metrics |

---

## 12. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Shell render | 0ms | Admin shell + page title |
| Signal bar | 100-500ms | Signal indicators populate |
| Case list | 200-800ms | Case rows appear with stagger animation |
| Metrics | 300-1000ms | Metric cards populate |

---

## 13. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 2.0s |
| Case list render | < 500ms for 50 cases |
| Search response | < 300ms |

---

## 14. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| New fraud signals | SSE | Real-time |
| Case status changes | SSE | Real-time |
| Metrics | Polling | Every 5 minutes |

---

## 15. Localization Notes

- Admin interface: English only
- Monetary values: USD
- Dates: ISO 8601
- Numbers: US formatting

---

## 16. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `admin.fraud.dashboard_viewed` | Page load | `admin_id`, `admin_role`, `period` |
| `admin.fraud.case_opened` | Click investigate | `case_id`, `fraud_type`, `severity` |
| `admin.fraud.case_created` | Manual case creation | `fraud_type`, `implicated_users_count` |
| `admin.fraud.action_taken` | Enforcement action | `case_id`, `action_type`, `impact_usd` |

---

## 17. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-admin-accent` | Primary actions |
| `--color-admin-danger` | Critical severity, fraud indicators |
| `--color-admin-warning` | Medium severity |
| `--color-admin-surface` | Card backgrounds |

---

## 18. Related Screens

| Screen | Relationship |
|---|---|
| [A001] Admin Dashboard | Parent — fraud alerts originate here |
| [A003] User Detail | View implicated user details |
| [A005] Workspace Detail | View implicated workspace |
| [A010] Audit Log | Audit trail for fraud actions |
| [A015] Content Moderation | Cross-reference moderation cases |

---

## 19. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 1.0 | Initial specification — aligned to S26 §14 fraud detection system | System |
