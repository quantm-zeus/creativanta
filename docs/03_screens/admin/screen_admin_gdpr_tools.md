# Screen: Admin — GDPR & Compliance Tools

> **Screen ID**: A029
> **Module**: Admin — Compliance & Data Protection
> **Route**: `/admin/compliance/gdpr`
> **Platform**: Admin Web (SvelteKit) — VPN-only access
> **Upstream**: S26 §12.2, PRD §32G (Legal/Compliance), B5 RBAC §3

---

## 1. Purpose & Context

The GDPR & Compliance Tools screen provides workflows for processing data subject requests (access, erasure, portability), managing consent records, and handling data breach notifications. This screen ensures Creativanta meets PDPA (Vietnam) and GDPR (EU) compliance requirements.

### User Goals
- Process data subject rights requests (access, erasure, portability)
- View and audit consent records per user
- Manage data processing activities log (Article 30)
- Initiate breach notification workflow if needed

### Business Goals
- Meet PDPA compliance (primary — Vietnam market)
- Achieve GDPR readiness for EU expansion
- Maintain consent records for 5 years (PRD §32G.2)
- Comply with 72-hour breach notification requirement

### Entry Points
- Admin Navigation: "📋 Audit" → "GDPR Tools"
- Admin Dashboard alerts: compliance-related alerts
- Admin search: "GDPR", "data request"

### Exit Points
- Click user → A003 User Detail
- Click audit trail → A010 Audit Log
- External: email notification to data subject

---

## 2. Preconditions / Postconditions

### Preconditions
- Admin authenticated via VPN + MFA
- Role: Super Admin or Auditor (full access), Operations Admin (view DSR queue only)

### Postconditions
- All actions logged in `admin_audit_log` with immutable audit trail
- Data subject notified via email upon request completion
- Compliance records updated

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ 🏢 Creativanta Admin  [GDPR & Compliance]     [Auditor] 👤 admin@  │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ [📋 Data Requests] [📝 Consent Dashboard] [🔒 Breach] [📊 DPA Log] │
│                                                                      │
│ ─── Tab: Data Subject Requests ──────────────────────────────────── │
│                                                                      │
│ ┌─ Stats Bar ──────────────────────────────────────────────────┐    │
│ │ Open: 3 | In Progress: 2 | Completed (30d): 15 | Avg: 4.2d  │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Request Queue ──────────────────────────────────────────────┐    │
│ │ [Type ▾] [Status ▾] [🔍 Search by email/ID...]               │    │
│ │ ┌──────────────────────────────────────────────────────────┐  │    │
│ │ │ DSR-001 | Right to Access | usr_abc@email.com            │  │    │
│ │ │ Submitted: 2026-03-25 | SLA: 28d remaining               │  │    │
│ │ │ Status: ⏳ In Progress — data export generating            │  │    │
│ │ │ [View] [Process] [Respond]                                 │  │    │
│ │ │──────────────────────────────────────────────────────────│  │    │
│ │ │ DSR-002 | Right to Erasure | usr_def@email.com            │  │    │
│ │ │ Submitted: 2026-03-26 | SLA: 29d remaining               │  │    │
│ │ │ Status: 🔴 Pending — requires Super Admin approval        │  │    │
│ │ │ [View] [Approve Deletion] [Reject with Reason]             │  │    │
│ │ └──────────────────────────────────────────────────────────┘  │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ─── Tab: Consent Dashboard ──────────────────────────────────────── │
│ (Search by user → view all consent records: marketing, analytics,   │
│  AI processing, each with timestamp, version, consent_given flag)   │
│                                                                      │
│ ─── Tab: Breach Notification ────────────────────────────────────── │
│ (Breach report form: what data, how many affected, timeline,        │
│  notification template, 72hr countdown, regulatory body contact)    │
│                                                                      │
│ ─── Tab: Data Processing Activities ─────────────────────────────── │
│ (Article 30 log: all data processing activities, purposes,          │
│  retention periods, data categories, recipients, safeguards)        │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
GDPRToolsPage
├── AdminShell (shared)
├── TabNavigation
│   ├── Tab: "Data Requests" (default)
│   ├── Tab: "Consent Dashboard"
│   ├── Tab: "Breach Notification"
│   └── Tab: "DPA Log"
├── DataRequestsTab
│   ├── StatsBar
│   │   ├── OpenCount
│   │   ├── InProgressCount
│   │   ├── CompletedCount (30d)
│   │   └── AvgCompletionDays
│   ├── FilterBar
│   │   ├── TypeFilter (access, erasure, portability, rectification, objection)
│   │   ├── StatusFilter (pending, in_progress, completed, rejected)
│   │   └── SearchInput (email, user ID, request ID)
│   └── RequestQueue
│       └── RequestRow[]
│           ├── RequestID
│           ├── TypeBadge
│           ├── UserEmail
│           ├── SubmissionDate
│           ├── SLACountdown (30 days GDPR / PDPA compliance)
│           ├── StatusBadge
│           └── ActionButtons (View, Process, Respond, Approve/Reject)
├── ConsentDashboardTab
│   ├── UserSearchBar
│   └── ConsentRecordTable
│       └── ConsentRow[]
│           ├── ConsentType (marketing, analytics, ai_processing, data_sharing)
│           ├── ConsentGiven (boolean)
│           ├── Timestamp
│           ├── Version (ToS/PP version at time of consent)
│           └── Source (signup, settings change, re-consent prompt)
├── BreachNotificationTab
│   ├── ActiveBreachBanner (if any)
│   ├── BreachReportForm
│   │   ├── DataAffected
│   │   ├── UsersAffected (count)
│   │   ├── DiscoveryTimestamp
│   │   ├── NotificationTimeline (72hr countdown)
│   │   ├── SeverityAssessment
│   │   └── RegulatoryContacts
│   └── BreachHistory
└── DPALogTab
    └── ProcessingActivityTable
        └── ActivityRow[]
            ├── ActivityName
            ├── Purpose
            ├── DataCategories
            ├── RetentionPeriod
            ├── Recipients
            └── Safeguards
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Request queue | `data_subject_requests` | `AdminComplianceService/ListRequests(filters)` | Paginated list | 2m TTL |
| Stats | Aggregated from requests | `AdminComplianceService/GetStats` | Counts + avg days | 5m TTL |
| Consent records | `user_consents` per user | `AdminComplianceService/GetUserConsents(userId)` | Table rows | No cache (always fresh) |
| DPA log | `data_processing_activities` | `AdminComplianceService/GetDPALog` | Full list | 30m TTL |
| Breach history | `breach_notifications` | `AdminComplianceService/GetBreaches` | Timeline | No cache |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | View request | Click "View" | `AdminComplianceService/GetRequest(id)` | — | Open request detail panel | Auditor+, Ops Admin |
| 2 | Process data export | Click "Process" on access request | `AdminComplianceService/GenerateExport(userId)` | Export job created | Toast "Export generating..." + progress | Super Admin only |
| 3 | Approve deletion | Click "Approve Deletion" | `AdminComplianceService/ApproveDeletion(requestId)` | User data queued for deletion + OTP required | Confirmation modal + OTP + toast "Deletion approved" | Super Admin only |
| 4 | Reject with reason | Click "Reject with Reason" | `AdminComplianceService/RejectRequest(id, reason)` | Request marked rejected | Reason input + toast "Request rejected" + email to user | Super Admin, Auditor |
| 5 | Search consent | Enter user email | `AdminComplianceService/GetUserConsents(email)` | — | Consent records displayed | Auditor+, Super Admin |
| 6 | Initiate breach report | Click "Report Breach" | `AdminComplianceService/CreateBreach(data)` | Breach record created + 72hr timer starts | Form → confirmation → toast "Breach reported" | Super Admin only |
| 7 | Export DPA log | Click "Export" | `AdminComplianceService/ExportDPA` | — | Download PDF/CSV | Super Admin, Auditor |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial page load | Skeleton shimmer |
| LOADED | Data ready | Full tabs rendered |
| EMPTY | No data requests | "No active data subject requests" |
| BREACH_ACTIVE | Breach in progress | Red banner: "⚠️ Active breach notification — [X hours remaining]" |
| ERROR | API failure | Error with retry |

---

## 8. Permission Matrix (Admin RBAC — 8 Roles per B5 §3)

| Feature | Super Admin | Operations | Finance | Content | Support | Tech | Analyst | Auditor |
|---|---|---|---|---|---|---|---|---|
| View data requests | ✅ | ✅ (view) | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| Process export | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Approve deletion | ✅ (OTP) | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| View consent dashboard | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| Report breach | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| View DPA log | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| Export compliance data | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |

---

## 9. Navigation Map

```
GDPR Tools (/admin/compliance/gdpr)
├── → /admin/users/[id]               (View user of a request)
├── → /admin/audit                    (Audit trail for actions)
└── ← /admin                          (Back to dashboard)
```

---

## 10. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| VPN disconnected | Network/VPN down | Full-page VPN error | Reconnect |
| Export generation failed | Processing error | Toast "Export failed" + retry | Retry export |
| Deletion approval failed | OTP invalid | "OTP không hợp lệ" | Re-enter OTP |

---

## 11. Accessibility

| Element | Requirement |
|---|---|
| Tabs | `role="tablist"`, `aria-selected` on active tab |
| Request queue | `role="list"`, keyboard navigable |
| SLA countdown | `aria-label` with days remaining |
| Breach banner | `role="alert"`, `aria-live="assertive"` |

---

## 12. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Shell + tabs | 0ms | Immediate |
| Active tab content | 200-500ms | Shimmer → content |

---

## 13. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 2.0s |
| Request queue render | < 500ms |
| Export generation | < 5 minutes (background job) |

---

## 14. Localization Notes

- Admin interface: English only
- User data displayed as-is (may contain Vietnamese)
- Dates: ISO 8601 format
- SLA countdown: "X days remaining"

---

## 15. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-admin-accent` | Active tab, CTA buttons |
| `--color-admin-danger` | Breach banner, deletion warnings |
| `--color-admin-warning` | SLA approaching deadline |
| `--color-admin-surface` | Card backgrounds |

---

## 16. Related Screens

| Screen | Relationship |
|---|---|
| [A001] Admin Dashboard | Parent |
| [A003] User Detail | View user of a data request |
| [A010] Audit Log | Compliance action audit trail |
| [A028] Fraud Dashboard | Security-related compliance |

---

## 17. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 1.0 | Initial specification — aligned to S26 §12, PRD §32G, PDPA/GDPR requirements | System |
