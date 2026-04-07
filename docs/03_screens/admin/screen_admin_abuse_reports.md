# Screen: Admin — Abuse Reports & Trust Safety

> **Screen ID**: A017
> **Module**: S26 — Internal Admin & Operations (Trust & Safety)
> **Route**: `/admin/abuse`
> **Platform**: Admin Web (SvelteKit) — VPN-only access
> **Upstream**: S26 §3.2 Content Moderation, A1 Schema (`moderation_cases`), A3 API endpoint map §18.4 (`AdminAbuseService/*`), B5 RBAC §3.2 (`admin:moderation:manage`)

---

## 1. Purpose & Context

Centralized abuse report review and action queue. Handles content violations (spam, scam, misinformation, harassment), user complaints, and AI-flagged content. Features auto-classification with confidence scores, evidence collection, escalation paths, and bulk moderation actions.

### User Story
> As a Trust & Safety admin, I want to review reported content with AI-assisted classification so I can take appropriate action quickly and consistently.

### Business Goal
- Maintain platform integrity and user trust
- Respond to abuse within SLA (<24h for high priority, <72h for medium)
- Reduce false positives in AI moderation through human review
- Legal compliance (takedown requests, law enforcement cooperation)

### When to Use
- Reviewing new abuse reports
- Actioning AI-flagged content surfaced by automated checks
- Processing escalated reports from moderation queue
- Investigating repeat offenders
- Handling legal/DMCA takedown requests

### Entry Points
- Admin sidebar → "🚩 Trust & Safety" → "Abuse Reports"
- Dashboard alert: "🔴 12 abuse reports pending"
- Email escalation: "New high-priority report" → deep link
- Moderation queue → "Escalate to Abuse" → this screen

### Exit Points
- Action taken → report resolved
- Escalate → Legal team (external flow)
- View user detail → `/admin/users/[id]`

---

## 2. Preconditions / Postconditions

### Preconditions
- Admin user with `admin:moderation:manage` permission
- Effective roles: Super Admin or Content Admin
- VPN connection active
- Abuse reports exist in queue

### Postconditions
- Abuse-report projection updated from canonical moderation state
- Underlying `moderation_cases` record actioned, dismissed, or escalated
- Content/user action applied if warranted
- Internal audit log recorded
- Reporter notification can be scheduled by the owning admin service

---

## 3. Layout Structure

### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ 🚩 Abuse Reports                    [SLA: 🟢 On track] [Export]    │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│ ┌─ Summary Dashboard ────────────────────────────────────────────┐  │
│ │ ⏳ Pending: 12  │  🔴 P0: 2   │  🟡 P1: 5  │  🟢 P2: 5     │  │
│ │ ✅ Today: 8     │  Avg res: 4h │  Repeat: 3  │  AI-flagged: 7 │  │
│ │                                                                 │  │
│ │ SLA compliance: [████████████████████████░░░░] 87% on-time      │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ Tabs: [⏳ Pending (12)] [🔍 Under Review (3)] [✅ Resolved] [📋 All]│
│ Filter: [Type ▾] [Priority ▾] [AI confidence ▾] [Date ▾]           │
│                                                                       │
│ ┌─ Report Card — P0 (Critical) ──────────────────────────────────┐  │
│ │ 🔴 #789 · Scam · Priority: P0                     ⏱ 30m ago  │  │
│ │                                                                 │  │
│ │ Reporter: @user123 · Against: ws_abc (seller account)           │  │
│ │                                                                 │  │
│ │ Content: "Buy followers cheap!! DM for prices"                  │  │
│ │ Evidence: [📸 Screenshot 1] [📸 Screenshot 2] [🔗 URL]        │  │
│ │                                                                 │  │
│ │ AI Classification:                                              │  │
│ │ ████████████████████████████████████░ 95% Scam confidence       │  │
│ │ Flags: follower_selling, price_solicitation, DM_redirect        │  │
│ │                                                                 │  │
│ │ Repeat offender: ⚠️ Yes (2 prior violations)                  │  │
│ │                                                                 │  │
│ │ ┌─ Quick Actions ───────────────────────────────────────────┐   │  │
│ │ │ [🗑 Remove Content] [⚠️ Warn User] [⏸ Suspend 7d]       │   │  │
│ │ │ [🚫 Permanent Ban] [📧 Escalate Legal] [❌ Dismiss]     │   │  │
│ │ └───────────────────────────────────────────────────────────┘   │  │
│ │                                                                 │  │
│ │ [🔍 Full Review →]                                             │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Report Card — P1 ─────────────────────────────────────────────┐  │
│ │ 🟡 #788 · Spam · Priority: P1                     ⏱ 2h ago   │  │
│ │ Reporter: @beauty_fan · Against: ws_def                         │  │
│ │ AI: ████████████████████░░░░░░░░░░ 78% Spam                    │  │
│ │ [🗑 Remove] [⚠️ Warn] [❌ Dismiss] [🔍 Review]               │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Bulk Actions ──────────────────────────────────────────────────┐  │
│ │ [☑ 3 selected] [🗑 Bulk Remove] [❌ Bulk Dismiss]             │  │
│ └─────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
AbuseReportsPage
├── AdminShell (shared)
├── PageHeader
│   ├── Title ("🚩 Abuse Reports")
│   ├── SLAStatusBadge (🟢/🟡/🔴)
│   └── ExportButton
├── SummaryDashboard
│   ├── PendingCount
│   ├── PriorityBreakdown (P0/P1/P2 count)
│   ├── ResolvedTodayCount
│   ├── AvgResolutionTime
│   ├── RepeatOffenderCount
│   ├── AIFlaggedCount
│   └── SLAComplianceBar
├── TabBar
│   ├── PendingTab (count badge)
│   ├── UnderReviewTab (count badge)
│   ├── ResolvedTab
│   └── AllTab
├── FilterBar
│   ├── TypeFilter (Spam/Scam/Harassment/Violation/DMCA/Other)
│   ├── PriorityFilter (P0/P1/P2)
│   ├── AIConfidenceFilter (>90%/>70%/>50%/All)
│   └── DateRangeFilter
├── ReportList (scrollable)
│   └── AbuseReportCard[]
│       ├── PriorityBadge (🔴/🟡/🟢)
│       ├── ReportID + Type + TimeAgo
│       ├── ReporterInfo
│       ├── AccusedInfo (workspace/user with link)
│       ├── ContentPreview (truncated, expandable)
│       ├── EvidenceAttachments (thumbnails, clickable)
│       ├── AIClassification
│       │   ├── ConfidenceBar (0-100%, color-coded)
│       │   └── FlagsList (tag chips)
│       ├── RepeatOffenderWarning (conditional)
│       ├── QuickActionButtons
│       │   ├── RemoveContentButton
│       │   ├── WarnUserButton
│       │   ├── SuspendButton (dropdown: 7d/30d/permanent)
│       │   ├── BanButton (requires confirmation)
│       │   ├── EscalateButton
│       │   └── DismissButton
│       └── FullReviewLink
├── BulkActions (when items selected)
│   ├── SelectedCount
│   ├── BulkRemoveButton
│   └── BulkDismissButton
├── FullReviewDrawer (opened by "Full Review")
│   ├── ReportTimeline (all events: report → classification → actions)
│   ├── FullContent (uncensored for review)
│   ├── AllEvidence (full-size view)
│   ├── UserHistory (prior violations, account age, activity)
│   ├── SimilarReports (other reports against same user)
│   ├── ActionForm
│   │   ├── ActionSelector
│   │   ├── InternalNote (for audit trail)
│   │   └── NotifyReporterCheckbox
│   └── SubmitActionButton
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Summary stats | `moderation_cases` abuse-report projection | `AdminAbuseService/GetStats` | Count cards + SLA bar | 1m TTL (real-time-ish) |
| Report list | `moderation_cases` abuse-report projection | `AdminAbuseService/ListReports(tab, filters)` | Card list sorted by priority + time | No cache |
| AI classification | `moderation_cases.evidence` projection | included | Confidence bar + flag chips | No cache |
| Evidence | `moderation_cases.evidence` | `AdminAbuseService/GetEvidence(id)` | Thumbnail gallery | No cache |
| User history | `moderation_cases` + audit projection | `AdminAbuseService/GetUserHistory(user_id)` | Timeline in drawer | No cache |
| SLA compliance | Computed from resolution times | `AdminAbuseService/GetSLACompliance` | Percentage + bar | 5m TTL |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Remove content | Click "🗑 Remove" | `AdminAbuseService/RemoveContent(report_id)` | Content hidden + report resolved | Toast "Content removed" + card moves to Resolved | `admin:moderation:manage` |
| 2 | Warn user | Click "⚠️ Warn" | `AdminAbuseService/WarnUser(report_id)` | Warning issued + report resolved | Toast "Warning sent" + card resolved | `admin:moderation:manage` |
| 3 | Suspend user | Click "⏸ Suspend" → pick duration | `AdminAbuseService/SuspendUser(report_id, days)` | User suspended + content removed | Confirmation → "User suspended {n} days" | `admin:moderation:manage` |
| 4 | Permanent ban | Click "🚫 Ban" → confirm | `AdminAbuseService/BanUser(report_id)` | User banned, content removed, workspace frozen | Double confirm ("Type BAN to confirm") → "User banned" | `admin:moderation:manage` |
| 5 | Escalate to legal | Click "📧 Escalate" | `AdminAbuseService/Escalate(report_id, note)` | Report escalated, legal team notified | Toast "Escalated to legal team" | `admin:moderation:manage` |
| 6 | Dismiss report | Click "❌ Dismiss" | `AdminAbuseService/Dismiss(report_id, reason)` | Report dismissed, no action | Reason required → "Report dismissed" | `admin:moderation:manage` |
| 7 | Bulk remove | Select multiple → "🗑 Bulk Remove" | `AdminAbuseService/BulkAction(ids, 'remove')` | Multiple reports actioned | Progress → "Removed {n} items" | `admin:moderation:manage` |
| 8 | Open full review | Click "🔍 Full Review" | `AdminAbuseService/GetFullReport(id)` | — | Open FullReviewDrawer | `admin:moderation:manage` |
| 9 | Submit full review action | Submit action form in drawer | `AdminAbuseService/ActionReport(id, action, note)` | Report actioned with detailed audit | Drawer closes + card updates | `admin:moderation:manage` |
| 10 | View accused user | Click user link | — | — | Navigate to `/admin/users/[id]` | Any admin |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching reports | Shimmer summary + skeleton cards |
| LOADED | Reports available | Summary + cards sorted by priority |
| EMPTY | No pending reports | "✅ No pending abuse reports. Queue clean!" |
| HIGH_VOLUME | >20 pending or P0 >0 | Red banner: "🔴 High-priority reports pending! Action P0 first." |
| SLA_AT_RISK | SLA compliance <80% | Yellow banner: "⚠️ SLA at risk. Current: {n}% on-time." |
| REVIEWING | Full review drawer open | Drawer visible with detailed report |
| ACTIONING | Processing action | Button spinner |
| ERROR | API failure | Toast with retry |

---

## 8. Validation Rules

| Field | Rule | Error Message |
|---|---|---|
| Dismiss reason | Required, min 10 chars | "Provide reason for dismissal (min 10 characters)" |
| Ban confirmation | Must type "BAN" | "Type BAN to confirm permanent ban" |
| Internal note | Optional but recommended for audits | Warning: "Adding a note improves audit trail quality" |
| Suspend duration | 1-365 days | "Suspension duration: 1-365 days" |

---

## 9. Permission Matrix

| Action | Super Admin | Operations | Finance | Content | Support | Tech | Analyst | Auditor |
|---|---|---|---|---|---|---|---|---|
| View reports | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Remove content | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Warn user | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Suspend user | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Permanent ban | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Escalate | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Dismiss | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Bulk actions | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |

---

## 10. Navigation Map

```
Abuse Reports (/admin/abuse)
├── → /admin/users/[id]            (via accused user link)
├── → FullReviewDrawer              (via "Full Review")
├── → /admin/moderation             (related queue)
├── → /admin/abuse/[id]             (direct report link)
└── ← /admin                       (via breadcrumb)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Action failed | API error | Toast: "Action failed. Report preserved." | Retry action |
| Ban failed | User already banned | Toast: "User already banned." | Refresh |
| Evidence load failed | Storage error | Placeholder: "Evidence unavailable" | Retry load |
| Bulk partial failure | Some actions failed | "Actioned {n}/{total}. {k} failed. [Retry failed]" | Retry failed |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Report cards | Full label: "Scam report #789, priority P0, 30 minutes ago, AI confidence 95%" |
| Action buttons | `aria-label` with context, destructive actions use `aria-describedby` with warning |
| Confidence bar | `aria-valuenow`, text percentage (not color alone) |
| Evidence images | `alt` text with report context |
| Priority badges | Text label (not color alone) |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Page load | <1s | Admin Shell + shimmer |
| Reports fetch | 200-500ms | Progressive: summary → cards |
| Full review | 300-500ms | Drawer slides in + content loads |
| Action execution | 500ms-2s | Button spinner |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| Page load | <2s |
| Report list (50 items) | <500ms |
| Action response | <2s |
| Evidence load | <3s per image |

---

## 15. Real-time Updates

| Data | Channel | Frequency |
|---|---|---|
| New reports | SSE `/admin/events/abuse` | Real-time |
| Report count | SSE (same channel) | Real-time (badge update) |
| SLA countdown | Client timer | 1m |

---

## 16. Localization Notes

- Admin interface: English only
- User content in reports: displayed as-is (may contain Vietnamese)
- SLA times: "4h", "24h", "72h" format

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `admin.abuse.viewed` | Page load | `pending_count`, `p0_count` |
| `admin.abuse.actioned` | Action taken | `report_id`, `action_type`, `time_to_action`, `ai_confidence` |
| `admin.abuse.dismissed` | Report dismissed | `report_id`, `reason` |
| `admin.abuse.escalated` | Escalated | `report_id`, `escalation_target` |
| `admin.abuse.bulk_action` | Bulk action | `action_type`, `count` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-admin-danger` | P0 badge, ban button |
| `--color-admin-warning` | P1 badge, suspend button |
| `--color-admin-success` | Resolved badge, clean queue |
| `--color-admin-neutral` | P2 badge |

---

## 19. Related Screens

| Screen | Relationship |
|---|---|
| [A015] Content Moderation | Sibling — content moderation |
| [A003] User Detail | Drill-down — accused user |
| [A001] Admin Dashboard | Summary metrics |

---

## 20. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 3.0 | Full 20-point upgrade from 62-line Tier C. Added SLA tracking with compliance bar, full review drawer with timeline/evidence/history, AI classification with multi-flag detection, repeat offender detection, escalation flow, bulk actions, permanent ban with double confirmation, 8 states including SLA risk. Fixed Screen ID (A25→A019), module (Admin→S26). | System |
