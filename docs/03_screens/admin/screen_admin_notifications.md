# Screen: Admin — Notification Broadcast

> **Screen ID**: A027
> **Module**: S26 — Internal Admin & Operations
> **Route**: `/admin/notifications`
> **Platform**: Admin Web (SvelteKit) — VPN-only access
> **Upstream**: Pack 08 §Comms, S26 §Broadcasts, A1 Schema (broadcasts, broadcast_targets, notification_events), B5 RBAC §3

---

## 1. Purpose & Context

Platform-wide notification broadcast system for internal admins to send announcements, maintenance alerts, feature updates, and targeted communications. Supports multi-channel delivery (in-app, email, push), audience targeting by plan/region/workspace, scheduling, and delivery analytics.

### User Story
> As an admin, I want to broadcast notifications to specific user segments across multiple channels so I can communicate platform changes effectively.

### Business Goal
- Centralized communication management for platform operations
- Targeted messaging to reduce noise for irrelevant users
- Delivery tracking and read-rate analytics for communication effectiveness
- Scheduled maintenance communication for user trust

### When to Use
- Announcing new features or platform updates
- Scheduled maintenance windows
- Security alerts requiring immediate attention
- Plan-specific feature announcements
- Regional compliance or legal updates

### Entry Points
- Admin sidebar → "📢 Notifications"
- System Health → "Send maintenance alert" quick action
- Incident Management → "Notify affected users" action

### Exit Points
- Send/Schedule → confirmation + stay on page
- View broadcast detail → drill down to delivery stats
- Navigate to other admin pages

---

## 2. Preconditions / Postconditions

### Preconditions
- Admin user authenticated via internal auth
- VPN connection active
- Role: `comms_admin`, `ops_admin`, or `super_admin`

### Postconditions
- Broadcast record created in `broadcasts` table
- Notification jobs queued for each target channel
- Delivery tracking records initialized
- Audit event: `admin.broadcast.sent` / `admin.broadcast.scheduled`

---

## 3. Layout Structure

### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ 📢 Notification Broadcast                    [📋 Templates] [+ New]│
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│ Tabs: [📝 Compose] [📊 History] [📋 Scheduled (2)]                  │
│                                                                       │
│ ┌─ Compose Panel ─────────────────────────────────────────────────┐  │
│ │ ── Type ──                                                       │  │
│ │ [🔔 Announcement] [🔧 Maintenance] [🚀 Feature] [⚠️ Security] │  │
│ │                                                                 │  │
│ │ ── Audience ──                                                   │  │
│ │ ○ All users (~1,234)                                            │  │
│ │ ● By plan: [☑ Pro] [☑ Business] [☐ Free] [☐ Starter]          │  │
│ │ ○ By region: [Vietnam ▾]                                        │  │
│ │ ○ Specific workspaces: [Search + add workspace IDs]             │  │
│ │ 📊 Reach estimate: ~150 workspaces · ~180 users                │  │
│ │                                                                 │  │
│ │ ── Channel ──                                                    │  │
│ │ [☑ In-app banner] [☑ Email] [☐ Push notification]              │  │
│ │ [☐ SMS (emergency only)]                                        │  │
│ │                                                                 │  │
│ │ ── Content ──                                                    │  │
│ │ Title: [Security update — mandatory password reset               │  │
│ │         required for all Pro accounts                     ]     │  │
│ │                                                                 │  │
│ │ Body (Markdown):                                                │  │
│ │ ┌──────────────────────────────────────────────────────────┐   │  │
│ │ │ ## Important Security Update                             │   │  │
│ │ │                                                          │   │  │
│ │ │ We detected suspicious activity and are requiring...     │   │  │
│ │ │ [Rich markdown editor with preview toggle]               │   │  │
│ │ └──────────────────────────────────────────────────────────┘   │  │
│ │                                                                 │  │
│ │ CTA Button (optional):                                          │  │
│ │ Label: [Reset Password Now    ] → URL: [/settings/security    ]│  │
│ │                                                                 │  │
│ │ ── Schedule ──                                                   │  │
│ │ ○ Send immediately                                              │  │
│ │ ● Schedule: [2026-03-29] [09:00] [UTC+7 ▾]                    │  │
│ │ ○ Recurring: [Weekly ▾] until [2026-06-29]                      │  │
│ │                                                                 │  │
│ │ ── Preview ──                                                    │  │
│ │ [👁 Preview in-app] [📱 Preview email] [📤 Send test to me]    │  │
│ │                                                                 │  │
│ │ [████████████ 📤 Schedule Broadcast ████████████████]           │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Broadcast History ─────────────────────────────────────────────┐  │
│ │ Date     │ Title              │ Target │ Delivered│ Read  │ CTR │  │
│ │──────────│────────────────────│────────│──────────│───────│─────│  │
│ │ 25/03    │ Live Commerce v2   │ All    │ 1,100   │ 45%  │ 12% │  │
│ │ 20/03    │ Maintenance 03/21  │ All    │ 1,234   │ 62%  │ —   │  │
│ │ 15/03    │ Pro analytics      │ Pro    │ 150     │ 78%  │ 34% │  │
│ │ [← 1 2 3 ... →]                                                │  │
│ └─────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
NotificationBroadcastPage
├── AdminShell (shared)
├── PageHeader
│   ├── Title ("📢 Notification Broadcast")
│   ├── TemplatesButton
│   └── NewBroadcastButton
├── TabBar
│   ├── ComposeTab
│   ├── HistoryTab
│   └── ScheduledTab (badge with count)
├── ComposePanel (visible on Compose tab)
│   ├── TypeSelector (chips: Announcement/Maintenance/Feature/Security)
│   ├── AudienceSection
│   │   ├── AllUsersRadio
│   │   ├── ByPlanSelector (checkboxes per plan tier)
│   │   ├── ByRegionSelector (dropdown)
│   │   ├── SpecificWorkspacesInput (search + tags)
│   │   └── ReachEstimate (computed, updates live)
│   ├── ChannelSelector
│   │   ├── InAppCheckbox (default: checked)
│   │   ├── EmailCheckbox (default: checked)
│   │   ├── PushCheckbox
│   │   └── SMSCheckbox (requires super_admin + confirmation)
│   ├── ContentSection
│   │   ├── TitleInput (max 120 chars)
│   │   ├── BodyEditor (Markdown with preview toggle)
│   │   └── CTAButtonConfig (optional)
│   │       ├── LabelInput
│   │       └── URLInput
│   ├── ScheduleSection
│   │   ├── ImmediateRadio
│   │   ├── ScheduledRadio (date + time + timezone)
│   │   └── RecurringRadio (frequency + end date)
│   ├── PreviewSection
│   │   ├── PreviewInAppButton
│   │   ├── PreviewEmailButton
│   │   └── SendTestButton (sends to current admin)
│   └── SubmitButton ("📤 Send / Schedule Broadcast")
├── HistoryPanel (visible on History tab)
│   ├── HistoryTable
│   │   ├── TableHeader (sortable: date, title, target, delivered, read rate, CTR)
│   │   └── BroadcastRow[]
│   │       ├── DateCell
│   │       ├── TitleCell (clickable → detail)
│   │       ├── TargetBadge
│   │       ├── DeliveredCount
│   │       ├── ReadRate (percentage with bar)
│   │       ├── CTRCell (if CTA present)
│   │       └── ActionsMenu (view, duplicate, delete)
│   └── Pagination
├── ScheduledPanel (visible on Scheduled tab)
│   └── ScheduledBroadcastCard[]
│       ├── ScheduledDateTime
│       ├── BroadcastSummary
│       ├── EditButton
│       ├── CancelButton
│       └── SendNowButton
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Reach estimate | Computed from audience filter | `AdminBroadcastService/EstimateReach(filters)` | "{n} workspaces · {m} users" | No cache |
| History table | `broadcasts` | `AdminBroadcastService/ListHistory(page, sort)` | Table with pagination | No cache |
| Read rate | `notification_events` aggregation | same | Percentage with color bar | 5m TTL |
| CTR | `notification_events WHERE clicked` / delivered | same | Percentage | 5m TTL |
| Scheduled broadcasts | `broadcasts WHERE status=scheduled` | `AdminBroadcastService/ListScheduled` | Card list | No cache |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Select broadcast type | Click type chip | — (local) | — | Title template pre-fills, channel defaults adjust | `comms_admin` |
| 2 | Configure audience | Change audience filters | `AdminBroadcastService/EstimateReach` | — | Reach estimate updates live | `comms_admin` |
| 3 | Preview in-app | Click "👁 Preview" | — (local) | — | Modal showing in-app notification rendering | `comms_admin` |
| 4 | Preview email | Click "📱 Preview" | `AdminBroadcastService/PreviewEmail(content)` | — | Modal showing email rendering | `comms_admin` |
| 5 | Send test | Click "📤 Send test" | `AdminBroadcastService/SendTest(admin_id)` | Test notification to current admin | Toast "Test sent. Check your notifications." | `comms_admin` |
| 6 | Send immediately | Click "Send" (immediate mode) | `AdminBroadcastService/Send(payload)` | Broadcast record + job queue | Confirmation dialog → Progress: "Sending to {n}..." → "✅ Sent" | `comms_admin` |
| 7 | Schedule broadcast | Click "Schedule" (scheduled mode) | `AdminBroadcastService/Schedule(payload)` | Broadcast record (status=scheduled) | Toast "Scheduled for {datetime}" | `comms_admin` |
| 8 | View broadcast detail | Click row in history | — | — | Navigate to broadcast detail or open drawer | `comms_admin` |
| 9 | Duplicate broadcast | Click "Duplicate" in row menu | — | — | Compose tab pre-fills with broadcast content | `comms_admin` |
| 10 | Cancel scheduled | Click "Cancel" on scheduled card | `AdminBroadcastService/Cancel(id)` | `broadcasts.status = cancelled` | Card removed, toast "Cancelled" | `comms_admin` |
| 11 | Send scheduled now | Click "Send Now" | `AdminBroadcastService/SendNow(id)` | Updates schedule, sends immediately | Confirmation → send progress | `comms_admin` |
| 12 | Use template | Click template from Templates panel | — | — | Compose pre-fills from template | `comms_admin` |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching history/scheduled | Shimmer table |
| LOADED | Data ready, compose fresh | Compose form + history table |
| COMPOSING | Admin typing content | Form with live reach estimate |
| PREVIEWING | Preview modal open | Modal with rendered notification |
| SENDING | Broadcast sending in progress | Progress bar: "📤 Sending to {n}/{total}..." |
| SENT | Broadcast completed | Success toast, compose resets, history updates |
| SEND_FAILED | Partial or full failure | Error: "Failed to deliver to {n} users. [Retry failed] [View details]" |
| SCHEDULED | Broadcast scheduled | Success toast, moves to Scheduled tab |
| VALIDATION_ERROR | Missing required fields | Red highlights on title/body/audience |

---

## 8. Validation Rules

| Field | Rule | Error Message |
|---|---|---|
| Type | Required | "Select broadcast type" |
| Audience | At least 1 target | "Select target audience" |
| Channel | At least 1 channel | "Select at least one delivery channel" |
| Title | Required, 5-120 chars | "Title is required (5-120 characters)" |
| Body | Required, 10-5000 chars | "Body is required (10-5000 characters)" |
| CTA URL | Valid URL if CTA label set | "Enter a valid URL for CTA button" |
| Schedule date | Must be > now + 15min | "Schedule must be at least 15 minutes in the future" |
| SMS channel | Requires super_admin confirmation | "SMS requires super_admin approval" |

### Business Validation
- Maintenance alerts auto-select "All users" + "In-app + Email"
- Security alerts require all channels enabled
- Max 3 broadcasts per day (soft limit, super_admin bypass)

---

## 9. Permission Matrix

| Action | Super Admin | Ops Admin | Comms Admin | Support Admin | Read Only |
|---|---|---|---|---|---|
| View history | ✅ | ✅ | ✅ | ✅ | ✅ |
| Compose & send | ✅ | ✅ | ✅ | ❌ | ❌ |
| Send SMS | ✅ | ❌ | ❌ | ❌ | ❌ |
| Delete broadcast | ✅ | ❌ | ❌ | ❌ | ❌ |
| Manage templates | ✅ | ✅ | ✅ | ❌ | ❌ |
| Cancel scheduled | ✅ | ✅ | ✅ | ❌ | ❌ |

---

## 10. Navigation Map

```
Notifications (/admin/notifications)
├── → Broadcast Detail (via history row click)
├── → Templates Panel (via Templates button)
├── → Preview Modal (via Preview buttons)
├── → Scheduled tab (via tab switch)
└── ← /admin (via breadcrumb)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Partial delivery failure | Some channels failed | "Delivered to {n}/{total}. Email failed for {k} users. [Retry email]" | Retry per channel |
| Rate limit | >3 broadcasts/day | Warning: "Daily limit reached. Override requires super_admin." | super_admin override |
| Template load failed | API error | Toast "Cannot load templates" | Retry |
| Large audience | >5000 users | Info: "Large broadcast. Processing may take 5-10 minutes." | No action needed |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Type chips | `role="radiogroup"` with `aria-label` |
| Audience checkboxes | Grouped with `fieldset` + `legend` |
| Markdown editor | `aria-label="Broadcast body"`, keyboard-accessible toolbar |
| History table | Proper `<th>` scoping, sortable columns announced |
| Preview modal | Focus trap, Escape to close |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Page load | <1s | Admin shell + compose form instant (static) |
| History fetch | 200-500ms | Shimmer table rows |
| Reach estimate | <300ms (debounced) | Inline spinner on estimate |
| Send broadcast | 1-30s | Progress bar with count |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| Page load | <2s |
| Reach estimate | <500ms |
| Send (100 users) | <5s |
| Send (1000 users) | <30s (async with progress) |

---

## 15. Real-time Updates

| Data | Channel | Frequency |
|---|---|---|
| Send progress | SSE `/admin/events/broadcast/{id}` | Real-time (per-user delivery) |
| Read rate | Polling | 5m (history table) |

---

## 16. Localization Notes

- Admin interface: English only
- Broadcast content: Vietnamese or English (admin chooses)
- Dates: ISO format in admin UI
- Email rendering: supports Vietnamese characters

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `admin.broadcast.composed` | Start composing | `type` |
| `admin.broadcast.previewed` | Preview clicked | `channel` |
| `admin.broadcast.sent` | Broadcast sent | `type`, `audience_size`, `channels[]` |
| `admin.broadcast.scheduled` | Broadcast scheduled | `type`, `scheduled_at` |
| `admin.broadcast.cancelled` | Scheduled cancelled | `broadcast_id` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-admin-accent` | Send button, active type chip |
| `--color-admin-success` | Delivered badge, high read rate |
| `--color-admin-warning` | Scheduled badge |
| `--color-admin-danger` | Failed delivery |

---

## 19. Related Screens

| Screen | Relationship |
|---|---|
| [A001] Admin Dashboard | Home — overview |
| [A006] System Health | Source — maintenance alerts |
| [A031] Incident Manager | Source — incident notifications |

---

## 20. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 3.0 | Full 20-point upgrade from 59-line Tier C. Added compose panel with audience targeting, channel selection, markdown editor, CTA config, scheduling, recurring broadcasts, preview, send-test, delivery progress, history with CTR analytics, scheduled broadcast management, templates. Fixed Screen ID (A26→A020), module (Admin→S26). | System |
