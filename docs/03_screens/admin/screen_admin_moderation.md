# Screen: Admin — Content Moderation Queue

> **Screen ID**: A015
> **Module**: S26 — Internal Admin & Operations (Trust & Safety)
> **Route**: `/admin/moderation`
> **Platform**: Admin Web (SvelteKit) — VPN-only
> **Upstream**: S26 §3.2 Content Moderation, A1 Schema (`moderation_cases`), A3 API endpoint map §6 (`ModerationService/*`), B5 RBAC §3.2 (`admin:moderation:manage`)

---

## 1. Purpose & Context

Primary queue for reviewing `moderation_cases` created by automated checks, user reports, or manual admin escalation. This screen is the first-stop operational surface for deciding whether a reported object is safe, should be warned, should be removed, or must be escalated.

### Entry Points
- Admin sidebar: "🛡 Moderation"
- Admin dashboard alert: flagged content count
- Deep link from abuse reports (A017) for cases that remain in the moderation queue

### Exit Points
- Case resolved or dismissed
- Case escalated to deeper abuse/legal handling (A017)

---

## 2. Preconditions / Postconditions

### Preconditions
- Admin user has `admin:moderation:manage` permission
- Effective roles: Super Admin or Content Admin
- VPN + admin MFA session active

### Postconditions
- `moderation_cases.status` updated to `in_review`, `action_taken`, `dismissed`, or `escalated`
- `moderation_cases.resolution` and `resolution_action` populated when actioned
- Internal audit log recorded for every write action
- If the case is resolved, downstream `moderation.case_resolved` event can be emitted by the owner service

---

## 3. Screen Layout

### ASCII Wireframe
```text
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ 🛡 Content Moderation                     [Severity ▾] [Source ▾]   │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Summary ──────────────────────────────────────────────────────┐  │
│ │ Pending: 8 · In review: 3 · Escalated: 1 · Resolved today: 15 │  │
│ │ AI-auto: 5 · User-report: 3 · Critical: 2                     │  │
│ └────────────────────────────────────────────────────────────────┘  │
│ ┌─ Moderation Case Card ─────────────────────────────────────────┐  │
│ │ CASE-789 · spam · critical                        30m ago      │  │
│ │ Object: script / 0190... · Workspace: ws_abc                   │  │
│ │ Source: ai_auto · Assignee: Lan Tran                           │  │
│ │ Evidence preview: "Buy followers..."                           │  │
│ │ [✅ Clear] [⚠️ Warn] [🗑 Remove] [⏸ Suspend] [↗ Escalate]     │  │
│ └─────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```text
ContentModerationQueuePage
├── AdminShell
├── PageHeader
├── SummaryCards
├── FilterBar
│   ├── StatusFilter
│   ├── SeverityFilter
│   └── ReportedByFilter
├── ModerationCaseList
│   └── ModerationCaseCard[]
│       ├── CaseHeader
│       ├── ObjectSummary
│       ├── EvidencePreview
│       ├── AssigneeInfo
│       └── ActionBar
└── EmptyState / ErrorState
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Summary stats | `moderation_cases` grouped by `status`, `severity`, `reported_by` | `ModerationService/ListCases` | KPI chips / counts | No cache |
| Queue list | `moderation_cases` | `ModerationService/ListCases` | Case cards sorted by severity then `created_at DESC` | No cache |
| Case identity | `case_id`, `case_type`, `severity`, `status` | included | Code + severity badge + status badge | No cache |
| Object context | `reported_object_type`, `reported_object_id`, `workspace_id` | included | Object label + workspace reference | No cache |
| Source + assignee | `reported_by`, `assigned_to` | included | Source chip + admin name | No cache |
| Evidence preview | `moderation_cases.evidence` JSONB | included | Short text / thumbnail / structured evidence preview | No cache |
| Resolution history | `resolution`, `resolution_action`, `resolved_at` | included when present | Inline secondary text | No cache |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Filter queue | Change filter chips | `ModerationService/ListCases` | — | Queue refreshes | `admin:moderation:manage` |
| 2 | Clear / approve | Click "✅ Clear" | `ModerationService/ActOnCase` | Marks case dismissed / no violation | Toast + case leaves pending queue | `admin:moderation:manage` |
| 3 | Warn user | Click "⚠️ Warn" | `ModerationService/ActOnCase` | `resolution_action = warning_sent` | Toast + case moves to actioned | `admin:moderation:manage` |
| 4 | Remove content | Click "🗑 Remove" | `ModerationService/ActOnCase` | `resolution_action = content_removed` | Toast + case moves to actioned | `admin:moderation:manage` |
| 5 | Suspend user | Click "⏸ Suspend" | `ModerationService/ActOnCase` | `resolution_action = account_suspended` | Confirmation + toast + case moves to actioned | `admin:moderation:manage` |
| 6 | Escalate | Click "↗ Escalate" | `ModerationService/ActOnCase` | `status = escalated` | Badge updates to escalated | `admin:moderation:manage` |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching cases | Shimmer cards + summary placeholders |
| LOADED | Cases available | Summary + queue cards |
| EMPTY | No pending cases | "✅ Queue clear." |
| HIGH_VOLUME | Pending critical/high cases exceed threshold | Red alert banner |
| ERROR | API failure | Error panel + retry |

---

## 8. Permission Matrix (Admin RBAC — 8 Roles per B5 §3)

| Feature | Super Admin | Operations | Finance | Content | Support | Tech | Analyst | Auditor |
|---|---|---|---|---|---|---|---|---|
| View moderation queue | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Take moderation action | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Escalate case | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |

---

## 9. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" | Retry when online |
| API error | Server 5xx | Toast: "Không tải được queue moderation. [Thử lại]" | Retry |
| Permission denied | Missing admin role | Access denied screen | Contact Super Admin |
| Action conflict | Case already resolved elsewhere | Toast: "Case đã được xử lý bởi admin khác." | Refresh queue |

---

## 10. Localization Notes

- Primary operator language: Vietnamese
- Severity/status chips may remain short English enums if they match canonical admin states
- Relative time: "30 phút trước", "2 giờ trước"

---

## Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-04-07 | 2.0 | Rebuilt from canonical `moderation_cases`, `ModerationService`, and admin RBAC. Removed template placeholders and non-canonical upstream tables. | GPT-5.4 |
| 2026-03-28 | 1.0 | Initial specification | System |
