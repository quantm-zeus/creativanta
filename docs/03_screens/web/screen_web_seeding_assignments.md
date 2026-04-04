# Screen: Web — Seeding Creator Assignment

> **Screen ID**: W112
> **Module**: M18 — Seeding / Sample CRM
> **Route**: `/seeding/assignments`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 08 §Seeding, A1 Schema (seeding_assignments, sample_shipments, seeding_campaigns), B5 RBAC §2.7

---
## 1. Purpose & Context

Assign products to external creators (KOLs) and track their deliverables through the seeding pipeline: **Assigned → Shipped → Received → Creating → Published**. This is the operational CRM for managing product seeding relationships.

### User Goals
- Assign specific products to selected creators for a seeding campaign
- Track shipment status for each assignment
- Monitor whether creators have produced and published content
- Follow up on overdue creators who haven't published

### Business Goals
- Systematic tracking of seeding investments (products + shipping costs)
- Ensure ROI accountability by tracking content delivery
- Build creator relationship database for future campaigns
- Identify reliable vs unreliable creators based on delivery rate

### Entry Points
- Seeding Campaigns (W098): "👥 Creators" button on campaign
- Sidebar: Seeding → "👥 Assignments"
- Notification: "Creator @skincare_qn published content for your seeding campaign"

### Exit Points
- Click creator → creator profile/contact
- Click product → Product Detail (W061)
- Click published content → Content detail
- "+ Assign sản phẩm" → Assignment modal

---
## 2. Preconditions / Postconditions

### Preconditions
- Active seeding campaign exists
- Products available for seeding
- Creator contacts available

### Postconditions
- New assignments create records + optional notification to creator
- Shipped status triggers logistics tracking
- Published status feeds into campaign ROI calculation

---
## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Seeding   👥 Creator Assignment             [+ Assign sản phẩm]  │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Pipeline Summary ────────────────────────────────────────────┐   │
│ │ ⚪ Assigned: 2 · 📦 Shipped: 3 · 📥 Received: 2             │   │
│ │ 🎬 Creating: 1 · 🟢 Published: 5 · 🔴 Overdue: 1           │   │
│ │ Completion rate: 62% (5/8 published)                          │   │
│ │ [⚪]──[📦]──[📥]──[🎬]──[🟢]                                │   │
│ │   2     3     2     1     5    ← pipeline funnel              │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Filter: [Campaign ▾] [Status ▾]  Sort: [Deadline ▾]                │
│                                                                      │
│ ┌─ Assignment Table ────────────────────────────────────────────┐   │
│ │ Creator       │ Product     │ Status        │ Deadline │ Actions│  │
│ │ ──────────────┼─────────────┼───────────────┼──────────┼───────│  │
│ │ @skincare_qn  │ Serum VitC  │ 🟢 Published  │ ✅ Done  │ [📊] │  │
│ │ · 50K followers · Content: "Review Serum VitC" · 24K views     │  │
│ │ ─────────────────────────────────────────────────────────────── │  │
│ │ @cooking_tips │ Gia vị      │ 🎬 Creating   │ 05/04   │ [💬] │  │
│ │ · 35K followers · Confirmed received on 20/3                   │  │
│ │ ─────────────────────────────────────────────────────────────── │  │
│ │ @beauty_vn    │ Kem CN      │ 📥 Received   │ 10/04   │ [💬] │  │
│ │ · Tracking: VNPost · Delivered 22/3                             │  │
│ │ ─────────────────────────────────────────────────────────────── │  │
│ │ @tech_review  │ USB-C cable │ ⚪ Assigned    │ 15/04   │ [📦] │  │
│ │ · Not yet shipped · Assigned 25/3                               │  │
│ │ ─────────────────────────────────────────────────────────────── │  │
│ │ @lifestyle_hc │ Mask set    │ 🔴 Overdue    │ ⏰ 5d ago│ [⚠️] │  │
│ │ · ⚠️ No content published · Last contact: 10d ago              │  │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Legend: ⚪ Assigned · 📦 Shipped · 📥 Received · 🎬 Creating ·    │
│         🟢 Published · 🔴 Overdue                                   │
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
SeedingAssignmentPage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Seeding")
│   ├── PageTitle ("👥 Creator Assignment")
│   └── AssignButton ("+ Assign sản phẩm", primary CTA)
├── PipelineSummary
│   ├── StatusCounts (per stage)
│   ├── CompletionRate
│   ├── OverdueCount (red highlight if > 0)
│   └── PipelineFunnel (visual flow diagram)
├── FilterSortBar
│   ├── CampaignFilter
│   ├── StatusFilter
│   └── SortSelector (Deadline, Creator name, Status)
├── AssignmentTable
│   └── AssignmentRow[]
│       ├── CreatorInfo
│       │   ├── Avatar + Handle
│       │   ├── FollowerCount
│       │   └── Platform
│       ├── ProductInfo (name + thumbnail)
│       ├── StatusBadge (color-coded per pipeline stage)
│       ├── Deadline (date or "Done" or "Overdue")
│       ├── ContextLine (tracking, received date, content link, etc.)
│       └── ActionButton (context-dependent)
│           ├── 📦 Ship (for Assigned → open shipping modal)
│           ├── 💬 Message (for in-progress → contact creator)
│           ├── 📊 View content (for Published)
│           └── ⚠️ Follow up (for Overdue → send reminder)
├── StatusLegend
└── AssignModal (opens on "+ Assign")
    ├── CampaignSelector
    ├── CreatorPicker (search by handle, name, or email)
    ├── ProductPicker (from campaign products)
    ├── ShippingAddressInput (or pre-filled from creator profile)
    ├── DeadlineInput (content delivery deadline)
    ├── NotesInput (optional brief for creator)
    ├── NotifyCreatorToggle (send notification email)
    └── AssignButton
```

---
## 5. Pipeline Status Flow

```
⚪ Assigned → 📦 Shipped → 📥 Received → 🎬 Creating → 🟢 Published
                                                              ↑
                                                        (content link
                                                         attached)
                ↓ (if > deadline + 7 days without publish)
            🔴 Overdue → (Manual follow-up)
```

Status transitions:
1. **Assigned → Shipped**: User enters tracking number + carrier
2. **Shipped → Received**: Creator confirms receipt (or auto-detect if carrier provides delivery confirmation)
3. **Received → Creating**: Automatic after received (time-based)
4. **Creating → Published**: Creator publishes content and links it OR system auto-detects content mentioning product
5. **Any → Overdue**: System marks overdue if deadline + 7 days passed without "Published" status

---
## 6. User Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Assign product | "+ Assign" → modal | `SeedingService/CreateAssignment` | New row in Assigned status | `sample:manage` |
| 2 | Mark shipped | "📦 Ship" → tracking modal | `SeedingService/MarkShipped(tracking_number)` | Status → Shipped, creator notified | `sample:manage` |
| 3 | Confirm received | Manual or auto | `SeedingService/MarkReceived` | Status → Received | `sample:manage` |
| 4 | Link content | "📊 View" → link content | `SeedingService/LinkContent(content_id)` | Status → Published, content attributed | `sample:manage` |
| 5 | Send reminder | "⚠️ Follow up" | `SeedingService/SendReminder` | Email/notification sent to creator | `sample:manage` |
| 6 | Message creator | "💬" | — | Open messaging/email | `sample:manage` |
| 7 | Remove assignment | ⋮ → "Remove" → confirm | `SeedingService/RemoveAssignment` | Assignment deleted | `sample:manage` |

---
## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Pipeline shimmer + table skeleton |
| LOADED | Data received | Pipeline summary + assignment table |
| EMPTY | No assignments | "Chưa có assignment nào. Bắt đầu bằng cách gán sản phẩm cho creator. [+ Assign sản phẩm]" |
| HAS_OVERDUE | One or more overdue | Red warning: "⚠️ {count} creators quá hạn chưa publish. [Gửi nhắc nhở →]" |
| ALL_PUBLISHED | All assignments published | Green celebration: "🎉 Tất cả creators đã publish content!" |
| ERROR | API failed | Error with retry |

---
## 8. Permissions

| Feature | Owner | Admin | Manager | Editor+ |
|---|---|---|---|---|
| View assignments | ✅ | ✅ | ✅ | ❌ |
| Create assignment | ✅ | ✅ | ✅ | ❌ |
| Mark shipped | ✅ | ✅ | ✅ | ❌ |
| Send reminders | ✅ | ✅ | ✅ | ❌ |
| Remove assignment | ✅ | ✅ | ❌ | ❌ |

---

## 9. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached assignments | Retry online |
| Assign fail | API error on create | Toast: "Không gán được sản phẩm. [Thử lại]" | Retry |
| Ship fail | Tracking API error | Toast: "Không cập nhật được tracking. [Thử lại]" | Retry |
| Reminder fail | Email send error | Toast: "Gửi nhắc nhở thất bại. [Thử lại]" | Retry |
| Creator not found | Invalid handle | Inline: "Không tìm thấy creator. Kiểm tra lại handle." | Re-search |

---

## 10. Accessibility

| Element | Requirement |
|---|---|
| Pipeline summary | `role="status"`, `aria-label="Pipeline: {assigned} assigned, {shipped} shipped, {published} published"` |
| Assignment table | `role="table"`, `aria-label="Creator assignments"` |
| Status badge | `aria-label="{status} — {creator} — {product}"` |
| Action buttons | `aria-label="{action} for {creator}"` (e.g., "Ship for @skincare_qn") |
| Overdue indicator | `role="alert"`, `aria-label="{count} creators overdue"` |

---

## 11. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Pipeline shimmer + table skeleton |
| Pipeline counts | 100-300ms | Counts populate |
| Assignment rows | 300-600ms | Rows stagger in |
| Creator metadata | 500-800ms | Follower counts, platform badges load |

---

## 12. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `seeding.assignments_viewed` | Page load | `total_count`, `overdue_count`, `completion_rate` |
| `seeding.assigned` | "+ Assign" confirmed | `creator`, `product`, `campaign_id` |
| `seeding.shipped` | "📦 Ship" confirmed | `assignment_id`, `tracking_number`, `carrier` |
| `seeding.received_confirmed` | "📥 Received" | `assignment_id`, `days_in_transit` |
| `seeding.content_linked` | Content linked | `assignment_id`, `content_url` |
| `seeding.reminder_sent` | "⚠️ Follow up" | `assignment_id`, `days_overdue` |
| `seeding.removed` | "Remove" confirmed | `assignment_id` |
| `seeding.filter_applied` | Filter changed | `filter_type`, `value` |

---

## 13. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/seeding/assignments/+page.svelte`
- **Server load**: `+page.server.ts` → `SeedingService/ListAssignments(workspace_id, campaign_id?)` + `GetPipelineStats`
- **Pipeline summary**: Computed server-side from assignment statuses
- **Status transitions**: `SeedingService/UpdateStatus(id, new_status, metadata)` — optimistic UI
- **Tracking**: `ShipmentService/AddTracking(assignment_id, tracking_number, carrier)` — carrier API integration
- **Reminders**: `NotificationService/SendReminder(creator_id, template)` — throttled 1/day
- **Bulk actions**: Multi-select → bulk ship, bulk remind

---

## 14. Localization Notes

- Pipeline: "⚪ Đã gán", "📦 Đã gửi", "📥 Đã nhận", "🎬 Đang tạo", "🟢 Đã publish", "🔴 Quá hạn"
- Actions: "Gán sản phẩm", "Đánh dấu đã gửi", "Gửi nhắc nhở"
- Metrics: "Tỷ lệ hoàn thành: {pct}%", "{count} creators quá hạn"
- Tone: Operational, CRM-focused

---

## 15. Design Tokens

| Token | Usage |
|---|---|
| `--color-seeding-assigned` | ⚪ Assigned badge |
| `--color-seeding-shipped` | 📦 Shipped badge |
| `--color-seeding-received` | 📥 Received badge |
| `--color-seeding-published` | 🟢 Published badge |
| `--color-danger` | 🔴 Overdue badge, warning |
| `--color-accent` | Assign CTA |
| `--color-surface-elevated` | Assignment cards |
| `--font-metric` | Completion rate (tabular-nums) |

---

## 16. Related Screens

| Screen | Relationship |
|---|---|
| [W113] Seeding Campaigns | Parent campaign view |
| [W111] Sample Requests | Sample shipment management |
| [W061] Product Detail | Product being seeded |
| [M056] Mobile Seeding | Mobile equivalent |

---

## 17. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (assign, tracking), pipeline/table a11y, 8 analytics, SvelteKit impl (pipeline, bulk), localization, 8 design tokens (seeding-specific). | System |
| 2026-03-28 | 1.0 | Initial specification | System |
