# Screen: Admin — Dispute Resolution

> **Screen ID**: A019
> **Module**: Admin — Commerce Operations
> **Route**: `/admin/commerce/disputes`
> **Platform**: Admin Web (SvelteKit) — VPN-only access
> **Upstream**: S26, Pack 06 §Commerce, B5 §3 Admin Roles

---
## 1. Purpose & Context

Review and resolve commerce disputes between workspaces and platforms. Includes evidence review, refund approval, SLA tracking, and escalation management. Disputes originate from order issues (product quality, non-delivery, wrong item), refund disagreements, or payment discrepancies.

### User Goals
- Quickly triage and prioritize disputes by severity and SLA
- Review evidence from both parties (user-submitted + platform data)
- Make fair resolution decisions (approve refund, reject, escalate)
- Track resolution metrics and SLA compliance

### Entry Points
- Admin Nav: Commerce → "⚖️ Disputes"
- Admin Dashboard (A001): alert "3 disputes pending"
- Notification: "New dispute filed" or "SLA breach imminent"
- Support Queue (A026): "Escalate to disputes" action

### Exit Points
- Click user/workspace → A003 User Detail or A005 Workspace Detail
- Click order → Order detail view (admin context)
- "Contact user" → Admin communication channel

---
## 2. Preconditions / Postconditions

### Preconditions
- Admin user authenticated with VPN + MFA
- User holds role: Super Admin, Operations Admin, or Finance Admin (per B5 §3.2 `admin:refund:issue`)

### Postconditions
- Resolution decision logged in `admin_audit_log` with reason + evidence reviewed
- Refund (if approved) triggers billing credit or payment reversal
- User notified of resolution via email + in-app notification
- Dispute resolution metrics updated for SLA tracking

---
## 3. Screen Layout

### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ ← Commerce   ⚖️ Disputes                 Pending: 3 · Overdue: 1  │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Summary Bar ─────────────────────────────────────────────────┐   │
│ │ ⏳ 3 pending · ⚠️ 1 SLA breach · ✅ 47 resolved (30d)        │   │
│ │ Avg resolution: 18h · Target: 24h · Compliance: 94%           │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ [Status: All ▾] [Platform ▾] [Priority ▾] [Type ▾] [🔍 Search]    │
│                                                                      │
│ ┌─ Dispute Row ──────────────────────────────────────────────────┐  │
│ │ #D-456 · [🔴 Critical] · Order #12345                          │  │
│ │ 💰 850,000 VND · ws_abc (User: Quân) vs TikTok Shop           │  │
│ │ Type: Product quality · Filed: 3d ago · SLA: ⚠️ 4h remaining  │  │
│ │ Evidence: 3 photos (user) + order data (platform)               │  │
│ │ [👁 Review] [✅ Approve Refund] [❌ Reject] [📧 Contact User]  │  │
│ │ [⬆ Escalate] [📝 Internal Note]                                │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Dispute Row ──────────────────────────────────────────────────┐  │
│ │ #D-457 · [🟡 High] · Order #12890                              │  │
│ │ 💰 1,200,000 VND · ws_xyz (User: Linh) vs Shopee              │  │
│ │ Type: Non-delivery · Filed: 1d ago · SLA: ✅ 20h remaining     │  │
│ │ Evidence: Tracking shows delivered, user claims not received     │  │
│ │ [👁 Review] [✅ Approve] [❌ Reject] [📧 Contact User]         │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ Pagination: [← Trước] Page 1/2 [Tiếp →]                           │
│                                                                      │
│ ┌─ Resolved (collapsed) ────────────────────────────────────────┐   │
│ │ 📁 Resolved Disputes (47 in 30d) [Expand ▾]                   │   │
│ └────────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
DisputeResolutionPage
├── AdminShell
├── PageHeader
│   ├── BackLink ("← Commerce")
│   ├── PageTitle ("⚖️ Disputes")
│   └── PendingCountBadge (count + overdue count)
├── SummaryBar
│   ├── PendingCount
│   ├── SLABreachCount
│   ├── ResolvedCount (30d)
│   ├── AvgResolutionTime
│   ├── TargetTime
│   └── ComplianceRate (percentage)
├── FilterBar
│   ├── StatusFilter (All, Pending, In Review, Escalated, Resolved, Rejected)
│   ├── PlatformFilter (TikTok, Shopee, Lazada, etc.)
│   ├── PriorityFilter (Critical, High, Normal, Low)
│   ├── TypeFilter (Product Quality, Non-delivery, Wrong Item, Payment, Other)
│   └── SearchInput (dispute ID, order ID, workspace name)
├── DisputeList
│   └── DisputeRow[]
│       ├── DisputeID
│       ├── PriorityBadge (🔴 Critical / 🟡 High / 🔵 Normal / ⚪ Low)
│       ├── OrderReference
│       ├── AmountDisplay (formatted VND)
│       ├── PartiesDisplay (workspace vs platform)
│       ├── TypeBadge
│       ├── FiledDateRelative
│       ├── SLATimer (countdown with color coding)
│       ├── EvidenceSummary (count of attachments)
│       └── ActionBar
│           ├── ReviewButton (primary)
│           ├── ApproveButton (success)
│           ├── RejectButton (destructive)
│           ├── ContactButton
│           ├── EscalateButton
│           └── NoteButton
├── Pagination
├── ResolvedSection (collapsible)
│   └── ResolvedDisputeRow[] (compact, read-only)
└── ReviewDrawer (side panel — opens on "Review")
    ├── DisputeHeader (full details)
    ├── EvidenceGallery (photos, screenshots, documents)
    ├── OrderDataSection (from platform API — official source)
    ├── ShippingTimeline (tracking events)
    ├── UserStatementSection
    ├── InternalNotesThread
    ├── ResolutionForm
    │   ├── DecisionRadio (Approve Refund / Partial Refund / Reject / Escalate)
    │   ├── RefundAmountInput (for partial)
    │   ├── ReasonTextarea (required)
    │   ├── InternalNoteTextarea (optional)
    │   └── SubmitButton (requires OTP for refund approval)
    └── AuditTrail (history of actions on this dispute)
```

---
## 5. Displayed Data

| Field | Source | Format |
|---|---|---|
| Dispute ID | `disputes.id` | "#D-456" |
| Priority | `disputes.priority` | Badge with color |
| Order ID | `disputes.order_id` → `orders.id` | "#12345" |
| Amount | `disputes.amount` | VND: "850.000đ" |
| Workspace | `disputes.workspace_id` → `workspaces.name` | "ws_abc" |
| User | `disputes.user_id` → `users.display_name` | "Quân" |
| Platform | `disputes.platform` | Platform icon + name |
| Type | `disputes.type` | Type badge |
| Filed date | `disputes.created_at` | Relative: "3 ngày trước" |
| SLA remaining | Computed: `created_at + sla_hours - now` | Countdown: "4h remaining" |
| Evidence | `dispute_evidence[]` | Count + thumbnails |
| Resolution | `disputes.resolution` | Status + reason |

---
## 6. User Actions

| # | Action | Trigger | Type | API Call | System Response | Permission |
|---|---|---|---|---|---|---|
| 1 | Review dispute | "👁 Review" | Primary | — | Open ReviewDrawer with full evidence | Super, Ops, Finance |
| 2 | Approve full refund | "✅ Approve" → OTP confirmation | Destructive (financial) | `AdminCommerceService/ResolveDispute(decision=approve_full)` | OTP modal → confirmation → refund issued → user notified | Super, Ops, Finance |
| 3 | Approve partial refund | "Partial Refund" in drawer → amount → OTP | Destructive | `AdminCommerceService/ResolveDispute(decision=approve_partial, amount)` | Same as above with partial amount | Super, Ops, Finance |
| 4 | Reject dispute | "❌ Reject" → reason required | Decision | `AdminCommerceService/ResolveDispute(decision=reject, reason)` | Confirmation dialog → dispute closed → user notified | Super, Ops, Finance |
| 5 | Contact user | "📧 Contact" | Communication | — | Open admin-to-user communication channel | Super, Ops, Support |
| 6 | Escalate | "⬆ Escalate" | Workflow | `AdminCommerceService/EscalateDispute(reason)` | Priority elevated, assigned to senior admin | Super, Ops |
| 7 | Add internal note | "📝 Note" | Inline | `AdminCommerceService/AddNote` | Note added to dispute thread (internal only) | Super, Ops, Finance |
| 8 | Filter disputes | Change filter | Filter | Refetch with params | List updates | All admin with access |
| 9 | Search | Type in search | Debounced | Refetch with query | List filters | All admin with access |

---
## 7. Validation Rules

### Refund Approval
| Rule | Error Message |
|---|---|
| OTP verification required | "Vui lòng xác nhận OTP để phê duyệt hoàn tiền" |
| Reason text required (min 20 chars) | "Vui lòng nhập lý do phê duyệt (tối thiểu 20 ký tự)" |
| Partial refund amount > 0 and ≤ dispute amount | "Số tiền hoàn phải từ 1đ đến {dispute_amount}" |
| Cannot approve own escalated dispute | "Không thể tự phê duyệt dispute do bạn escalate" |

### Rejection
| Rule | Error Message |
|---|---|
| Reason required (min 20 chars) | "Vui lòng nhập lý do từ chối (tối thiểu 20 ký tự)" |
| Must review evidence first | "Vui lòng xem xét bằng chứng trước khi từ chối" |

---
## 8. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Table skeleton rows |
| LOADED | Data received | Dispute list with sorting/filtering |
| EMPTY | No disputes in filter | "Không có dispute nào" (filtered: "Không tìm thấy với bộ lọc này") |
| REVIEWING | Review drawer open | Side panel with evidence and resolution form |
| PROCESSING | Refund/resolution being processed | Action buttons disabled, spinner on active button |
| SLA_BREACH | ≥1 dispute past SLA | Red pulsing banner: "⚠️ {count} disputes đã vượt SLA!" |
| ERROR | API failure | Error banner |

---
## 9. Permission Matrix (Admin RBAC)

| Feature | Super | Ops | Finance | Content | Support | Tech | Analyst | Auditor |
|---|---|---|---|---|---|---|---|---|
| View disputes | ✅ | ✅ | ✅ | ❌ | ⚠️ | ❌ | ❌ | ✅ |
| Review evidence | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ |
| Approve refund | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Reject dispute | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Escalate | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Contact user | ✅ | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ |
| Add note | ✅ | ✅ | ✅ | ❌ | ⚠️ | ❌ | ❌ | ❌ |

> ⚠️ Support Admin: sees dispute list in read-only mode, can add notes about user communication, cannot take resolution actions. Auditor: read-only access for compliance checks.

---
## 10. SLA Configuration

| Priority | Target Resolution | Escalation After |
|---|---|---|
| Critical | 4 hours | 2 hours |
| High | 24 hours | 12 hours |
| Normal | 72 hours | 48 hours |
| Low | 7 days | 5 days |

- SLA clock starts when dispute is filed
- Clock pauses when "waiting for user response"
- Auto-escalation notification sent when 50% SLA consumed
- SLA breach → admin alert + manager notification

---
## 11. Audit Requirements

- **Every action logged**: who, what, when, IP address, reason
- **Evidence access logged**: who viewed what evidence, when
- **Resolution logged**: decision, reason, amount (if refund), OTP verification timestamp
- **Retention**: Dispute records and audit trail kept for 5 years (legal compliance)

---
## 12. Data Binding & Display Format
*(Refer to screen-specific data binding in section above)*


---
## 13. Related Screens

| Screen | Relationship |
|---|---|
| [A001] Admin Dashboard | Dispute alerts shown |
| [A018] Commerce Overview | Commerce operations parent |
| [A003] User Detail | User context for dispute |
| [A005] Workspace Detail | Workspace context |
| [A010] Audit Log | Dispute actions appear in audit log |
| [A026] Support Queue | Disputes can originate from support tickets |
---
## Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached data | Pull-to-refresh when online |
| API error | Server 5xx | Toast: "Không tải được dữ liệu. [Thử lại]" | Retry |
| Not found | 404 | "Không tìm thấy" → navigate back | Back |
| Permission denied | 403 | "Không có quyền truy cập" | Contact admin |

---
## Accessibility

| Element | Requirement |
|---|---|
| Interactive elements | Minimum 48×48dp tap targets |
| Icons with meaning | `Semantics(label:)` descriptive text |
| Status indicators | Color not sole indicator; text/icon also present |
| Dynamic content | `Semantics(liveRegion: true)` for updates |
| Contrast | 4.5:1 minimum ratio |

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
