# Screen: Mobile — Approval Queue

> **Screen ID**: M051
> **Module**: M20 — Workflow Studio
> **Route**: `/m/approvals`
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 01 §10 (Mobile Execution), Pack 03 §Workflow/Agent, A1 Schema (approval_requests, publish_items, scripts, assets), B5 RBAC §2.7

---

## 1. Purpose & Context

Mobile-optimized approval queue for reviewing and acting on pending approvals — scripts, AI-generated content, publish items, workflow actions, and asset reviews. Designed for fast **swipe-to-approve** interaction on the go, making mobile a real execution surface for managers and team leads.

### User Story
> As a manager on mobile, I want to quickly review and approve/reject pending items using swipe gestures so my team isn't blocked waiting for my review.

### Business Goal
- Reduce approval bottleneck (target: <2h average approval time)
- Enable on-the-go management (commute, between meetings)
- Prevent missed scheduled publishes due to late approvals
- Support Agency/MCN Mode multi-workspace approval workflows

### When to Use
- Push notification: "📋 5 items cần duyệt"
- Schedule urgency: "⚠️ Video scheduled in 4h needs approval"
- Workflow blocked: "Workflow paused — waiting for your approval"
- Regular queue check

### Entry Points
- Push notification → deep link to specific item or queue
- Tasks tab → "📋 Approvals" segment
- Dashboard alert → "pending approvals" → this screen
- Bottom nav badge indicator

### Exit Points
- All items approved → Empty state
- Tap item → Preview detail
- Back → Tasks tab

---

## 2. Preconditions / Postconditions

### Preconditions
- User has `publish:approve` permission
- User is assigned as approver for pending items
- Pending approval items exist

### Postconditions
- Approved items proceed to next state (publish queue, asset finalization, etc.)
- Rejected items return to creator with feedback
- Audit trail: `approval.approved` / `approval.rejected` logged
- Notification sent to item creator

---

## 3. Layout Structure

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Phê duyệt                          [Filter ▾] [Batch ✅ All]     │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│ ┌─ Queue Summary Card ────────────────────────────────────────────┐  │
│ │ ⏳ Chờ duyệt: 5    ⚡ Gấp: 1    ⏱ TB chờ: 2h 15m              │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ Segments: [Tất cả (5)] [📝 Script (2)] [📤 Publish (2)] [🤖 AI (1)]│
│                                                                       │
│ ┌─ Approval Card (URGENT) ────────────────────────────────────────┐  │
│ │ ⚠️ GẤP · Lên lịch trong 4h                                     │  │
│ │                                                                 │  │
│ │ 📝 Script: "Morning skincare routine"                           │  │
│ │ 🤖 AI generated · 🎵 TikTok · ⏱ 60s                           │  │
│ │ 👤 Requested by: Mai · 2h ago                                   │  │
│ │                                                                 │  │
│ │ Preview: "Chào mọi người! Hôm nay mình sẽ chia sẻ..."        │  │
│ │                                                                 │  │
│ │ ← ❌ Reject      [👁 Xem]      ✅ Approve →                    │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Approval Card ─────────────────────────────────────────────────┐  │
│ │ 📤 Publish: "Top 5 serum" → TikTok + Reels                     │  │
│ │ Scheduled: 20:00 · Media: 🎬 Video (45s) + 📝 Caption          │  │
│ │ 👤 Requested by: An · 5h ago                                    │  │
│ │                                                                 │  │
│ │ ← ❌ Reject      [👁 Xem]      ✅ Approve →                    │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Approval Card ─────────────────────────────────────────────────┐  │
│ │ 💬 AI Reply: @skincare_queen — purchase inquiry                 │  │
│ │ 🤖 AI draft · Confidence: 92% · Platform: TikTok               │  │
│ │ Preview: "Cảm ơn bạn đã quan tâm! Sản phẩm này..."           │  │
│ │ 👤 Auto-generated · 30m ago                                     │  │
│ │                                                                 │  │
│ │ ← ❌ Reject      [👁 Xem]      ✅ Approve →                    │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ │ ... 2 more items                                                    │
│                                                                       │
│ Pull-to-refresh ↻                                                    │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [📋] [➕] [💬] [👤]                                            │
└──────────────────────────────────────────────────────────────────────┘
```

### Swipe Action Detail
```
← Swipe Left (Reject):
┌──────────────────────────────────────────────────────────────────────┐
│ ████████████████████████████████ ❌ Từ chối ████████████████████████ │
│ [Card slides left, red background revealed]                          │
│ → Opens rejection reason bottom sheet                                │
└──────────────────────────────────────────────────────────────────────┘

→ Swipe Right (Approve):
┌──────────────────────────────────────────────────────────────────────┐
│ ████████████████████████████████ ✅ Phê duyệt ██████████████████████│
│ [Card slides right, green background revealed]                       │
│ → Immediate approval with haptic feedback                            │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
ApprovalQueueScreen
├── AppBar
│   ├── BackButton
│   ├── Title ("Phê duyệt")
│   ├── FilterButton (dropdown: by type, by urgency, by requester)
│   └── BatchApproveButton ("Batch ✅ All")
├── QueueSummaryCard
│   ├── PendingCount
│   ├── UrgentCount (orange if >0)
│   └── AverageWaitTime
├── SegmentBar (scrollable chips)
│   ├── AllSegment (count)
│   ├── ScriptSegment (count)
│   ├── PublishSegment (count)
│   ├── AIReplySegment (count)
│   ├── AssetSegment (count)
│   └── WorkflowSegment (count)
├── ApprovalList (scrollable, pull-to-refresh)
│   └── SwipeableApprovalCard[]
│       ├── UrgencyBanner (conditional — orange for urgent items)
│       ├── ItemTypeIcon + ItemTitle
│       ├── MetaRow
│       │   ├── GenerationBadge (🤖 AI / 👤 Human)
│       │   ├── PlatformBadge
│       │   ├── DurationOrSize
│       │   └── ConfidenceBadge (for AI items)
│       ├── RequesterInfo (avatar + name + time ago)
│       ├── PreviewText (truncated, 2 lines max)
│       ├── SwipeActions
│       │   ├── LeftAction (❌ Reject — red)
│       │   └── RightAction (✅ Approve — green)
│       └── CenterTapAction (👁 Xem — opens detail)
├── EmptyState (conditional)
│   ├── Illustration (celebration)
│   ├── Message ("🎉 Tất cả đã duyệt! Nghỉ ngơi thôi.")
│   └── RefreshHint
├── RejectionBottomSheet (conditional — opens on swipe-left)
│   ├── Title ("Lý do từ chối")
│   ├── QuickReasonChips
│   │   ├── "Nội dung chưa phù hợp"
│   │   ├── "Cần chỉnh sửa thêm"
│   │   ├── "Sai thông tin sản phẩm"
│   │   ├── "Không đúng brand voice"
│   │   └── "Khác"
│   ├── CustomReasonInput (optional text)
│   ├── RejectButton
│   └── CancelButton
└── BottomNavBar (shared, badge on 📋 tab)
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Queue count | `approval_requests WHERE status=pending` | `ApprovalService/GetQueueStats` | Integer | Real-time SSE |
| Urgent count | Items with schedule <6h | same | Integer + orange badge | Real-time |
| Average wait | Computed from `created_at` | same | "2h 15m" relative | 5m TTL |
| Card title | `approval_requests.title` | `ApprovalService/ListPending(filters)` | String | No cache |
| Generation type | `approval_requests.generation_mode` | same | 🤖 / 👤 badge | No cache |
| AI confidence | `approval_requests.confidence` | same | "92%" with color | No cache |
| Requester | `approval_requests.requested_by` → `users` | same | Avatar + name | Session |
| Preview text | `approval_requests.preview_text` | same | 2-line truncated | No cache |
| Time ago | `approval_requests.created_at` | same | Relative time | Client-computed |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Approve item | Swipe right (+haptic) | `ApprovalService/Approve(id)` | `status = approved` | Card slides off + ✅ toast + count decreases | `publish:approve` |
| 2 | Reject item | Swipe left → select reason → confirm | `ApprovalService/Reject(id, reason)` | `status = rejected` | Card slides off + ❌ toast + count decreases | `publish:approve` |
| 3 | Preview item | Tap card center (👁 Xem) | — | — | Navigate to item detail preview | `publish:approve` |
| 4 | Batch approve all | Tap "Batch ✅ All" → confirm | `ApprovalService/BatchApprove(ids[])` | All `status = approved` | Confirmation dialog → all cards cleared → 🎉 Empty state | `publish:approve` |
| 5 | Filter by type | Tap segment chip | `ApprovalService/ListPending(type_filter)` | — | List filters | `publish:approve` |
| 6 | Filter advanced | Tap Filter button | — | — | Filter bottom sheet (by urgency, requester, date) | `publish:approve` |
| 7 | Pull to refresh | Pull down gesture | `ApprovalService/ListPending` | — | List refreshes + summary updates | `publish:approve` |
| 8 | Undo approve | Tap "Hoàn tác" in toast (3s window) | `ApprovalService/UndoApprove(id)` | `status = pending` | Card reappears at original position | `publish:approve` |
| 9 | Undo reject | Tap "Hoàn tác" in toast (3s window) | `ApprovalService/UndoReject(id)` | `status = pending` | Card reappears | `publish:approve` |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching queue | Card shimmer (3 skeleton cards) |
| LOADED | Items pending | Queue summary + approval cards |
| EMPTY | No pending items | 🎉 Celebration illustration + "Tất cả đã duyệt! Nghỉ ngơi thôi." |
| URGENT | Items near schedule deadline | Orange urgency banner on affected cards + summary badge |
| FILTERED_EMPTY | Filter active, 0 matches | "Không có mục nào phù hợp bộ lọc. [Xóa bộ lọc]" |
| APPROVING | Processing approval | Card animates off-screen + brief spinner |
| BATCH_APPROVING | Processing batch approval | Progress: "Đang duyệt {n}/{total}..." |
| ERROR | API failure | Toast: "Không thể {action}. [Thử lại]" |
| OFFLINE | No network | Banner: "Đang offline. Phê duyệt sẽ được gửi khi có mạng." + queue locally |

---

## 8. Validation Rules

| Field | Rule | Error Message |
|---|---|---|
| Rejection reason | Required (quick chip or custom text) | "Vui lòng chọn hoặc nhập lý do từ chối" |
| Custom reason text | Max 500 characters | "Lý do tối đa 500 ký tự" |
| Batch approve | Confirmation required | "Phê duyệt tất cả {n} mục? Hành động này không thể hoàn tác sau 3 giây." |

---

## 9. Permission Matrix

| Action | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View approval queue | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Approve items | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Reject items | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Batch approve | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| View item detail | ✅ | ✅ | ✅ | ✅ (own items only) | ❌ | ❌ | ❌ |

> **Agency/MCN Mode**: Managers see approvals from all assigned creators/sub-workspaces.

---

## 10. Navigation Map

```
Approval Queue (/m/approvals)
├── → /m/scripts/[id]/preview    (via script approval tap)
├── → /m/publish/[id]/preview    (via publish approval tap)
├── → /m/threads/[id]            (via AI reply approval tap)
├── → /m/assets/[id]/preview     (via asset approval tap)
├── → RejectionBottomSheet       (via swipe left)
├── → BatchConfirmDialog         (via Batch ✅ All)
└── ← /m/tasks                   (via back — Tasks tab)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network error | No connectivity | Banner "Đang offline" + local queue | Auto-sync on reconnect |
| Approval API fail | Server error | Toast "Không thể phê duyệt. Thử lại." + card returns to position | Manual retry (re-swipe) |
| Item already processed | Concurrent approval by another admin | Toast "Mục này đã được duyệt bởi {name}" + card removed | No action needed |
| Batch partial failure | Some items fail in batch | "Đã duyệt {n}/{total}. {k} mục lỗi. [Xem chi tiết]" | Retry failed items |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Swipe actions | Tap fallback buttons visible for reduced-motion users |
| Urgency banner | `Semantics(liveRegion: true)`, not color-only |
| Cards | Each card has full label: "Script: Morning skincare, cần duyệt, đợi 2 giờ" |
| Batch action | Confirmation dialog with explicit counts |
| Haptic | Medium haptic on approve, light on reject |
| Reduced motion | Disable swipe animations, use tap buttons instead |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | App bar + shimmer cards (3 skeletons) |
| Data fetch | 200-500ms | Summary card populates → cards animate in (stagger 50ms) |
| Swipe action | 200ms | Card slides off-screen + count updates |
| Pull-to-refresh | 300ms-1s | Pull indicator → refresh → list updates |
| Undo toast | 3s visible | Toast appears with "Hoàn tác" button, auto-dismisses |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| Screen render | <1.5s |
| Swipe response | <100ms (haptic + visual) |
| Approval API | <500ms |
| Batch approval | <2s for 10 items |
| List scroll | 60fps |

---

## 15. Real-time Updates

| Data | Channel | Frequency |
|---|---|---|
| New approvals | Push notification + SSE | Real-time |
| Queue count | SSE `/events/approvals` | Real-time (for badge update) |
| Item already approved | SSE | Real-time (concurrent handling) |

---

## 16. Localization Notes

- Vietnamese primary
- Time: relative ("2h trước", "30 phút trước")
- Rejection reason chips: Vietnamese labels
- Haptic patterns: platform-native (iOS + Android)

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `approval.queue.viewed` | Screen load | `pending_count`, `urgent_count`, `avg_wait_time` |
| `approval.approved` | Swipe approve | `item_type`, `item_id`, `wait_time_seconds` |
| `approval.rejected` | Swipe reject + reason | `item_type`, `item_id`, `reason`, `wait_time_seconds` |
| `approval.batch_approved` | Batch approve | `count` |
| `approval.undone` | Undo tap | `item_type`, `original_action` |
| `approval.previewed` | Tap preview | `item_type`, `item_id` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-success` | Approve swipe background, approved badge |
| `--color-danger` | Reject swipe background, rejected badge |
| `--color-warning` | Urgent banner |
| `--color-surface-primary` | Card background |
| `--color-surface-elevated` | Summary card |
| `--radius-card` | Card radius (12px) |

---

## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W104] Web Approval Queue | Web equivalent (table view) |
| [M052] Mobile Task Queue | Sibling — task management |
| [M050] Mobile Workflow Monitor | Parent — workflow context |
| [W016] Script Editor | Detail — opens from script approval preview |

---

## 20. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 3.0 | Full 20-point upgrade from 65-line Tier C. Added detailed swipe interaction wireframe, rejection reason bottom sheet with quick chips, batch approval with progress, undo support (3s window), offline queue, concurrent edit handling, full component hierarchy, 9 actions with API calls, 9 states, Agency/MCN Mode note, comprehensive analytics. Fixed Screen ID (M059→M051). | System |
| 2026-03-28 | 2.0 | Expanded from sparse | System |
| 2026-03-28 | 1.0 | Initial specification | System |
