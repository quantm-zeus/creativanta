# Screen Specs 06 — Engagement & Inbox (M09)

> **Upstream**: Pack 01 §4, Product Freeze §20, A1 Schema (threads, messages, entities, follow_up_tasks, intents, suggested_replies)
> **Screens**: 6 web + 3 mobile screens
> **Screen Numbers**: §49-§54 (per screen_index.md canonical numbering)

---

## 49. Unified Inbox

**Route**: `/inbox`
**Purpose**: Unified inbox aggregating comments, DMs, mentions from all connected platforms. AI-powered intent detection and triage.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 💬 Inbox                                    Unread: 23           │
├──────────────────────────────────────────────────────────────────┤
│ Filter: [Tất cả ▾] [Platform ▾] [Priority ▾] [Intent ▾]        │
│ [☑ Unread only]                                                  │
├─ Thread List (40%) ──────┬─ Thread Detail (60%) ─────────────────┤
│                          │                                        │
│ ┌─ Thread ─────────────┐│ ┌─ Entity Header ──────────────────┐  │
│ │ 🔵 Nguyễn Văn A      ││ │ [Avatar] Nguyễn Văn A            │  │
│ │ 🎵 TikTok · Comment  ││ │ @nguyenvana · TikTok             │  │
│ │ "Sản phẩm này mua    ││ │ Follower: 12K · Mua 3 lần trước │  │
│ │  ở đâu vậy ạ?"       ││ │ Customer value: ★★★★☆             │  │
│ │ 🟢 Purchase intent   ││ │ [👤 Profile] [📦 Orders]          │  │
│ │ ⏱ 15 phút trước      ││ └─────────────────────────────────┘  │
│ │ [⭐ Priority: High]   ││                                        │
│ └──────────────────────┘│ ┌─ Conversation ───────────────────┐  │
│                          │ │ 📝 Post: "5 tips nấu ăn nhanh"  │  │
│ ┌─ Thread ─────────────┐│ │ ─────────────────────────────────│  │
│ │ ⚪ Lê Hoa            ││ │ 💬 Nguyễn Văn A (15m ago):       │  │
│ │ 📸 IG · Comment      ││ │ "Sản phẩm này mua ở đâu ạ?"    │  │
│ │ "Quá đẹp luôn! 😍"  ││ │                                  │  │
│ │ 🔵 Praise            ││ │ 🤖 AI Intent: Purchase inquiry   │  │
│ │ ⏱ 2 giờ trước        ││ │ 🤖 Suggested reply:              │  │
│ │ [Priority: Normal]    ││ │ "Cảm ơn bạn! Bạn có thể mua    │  │
│ └──────────────────────┘│ │  tại link: [shopee.vn/...]       │  │
│                          │ │  Đang giảm giá 20% hôm nay!"    │  │
│ ┌─ Thread ─────────────┐│ │ [✅ Gửi gợi ý] [✏️ Sửa & gửi]  │  │
│ │ ⚪ @competitor_fan    ││ │ ─────────────────────────────────│  │
│ │ 🎵 TikTok · Comment  ││ │ hoặc tự viết:                    │  │
│ │ "Video dở quá..."    ││ │ [Type your reply...         💬]  │  │
│ │ 🟠 Criticism          ││ └─────────────────────────────────┘  │
│ │ ⏱ 5 giờ trước         ││                                       │
│ └──────────────────────┘│ ┌─ Actions Bar ────────────────────┐  │
│                          │ │ [✅ Resolve] [📌 Follow-up task] │  │
│ [Tải thêm ↓]            │ │ [🏷 Tag] [👤 Assign] [🔇 Mute] │  │
│                          │ └─────────────────────────────────┘  │
└──────────────────────────┴────────────────────────────────────────┘
```

### Components Detail

#### 49.1 Thread List Item
| Field | Source | Display |
|---|---|---|
| Entity avatar | `entities.avatar_url` | Circular avatar |
| Entity name | `entities.display_name` | Bold text |
| Platform | `threads.platform` | Platform icon |
| Type | `threads.thread_type` | Comment / DM / Mention |
| Last message preview | `messages[last].body` | Truncated to 50 chars |
| AI Intent | `intents.intent_class` | Color-coded chip: 🟢 Purchase, 🔵 Praise, 🟠 Criticism, 🔴 Complaint, ⚪ Question |
| Priority | `threads.priority` | Star rating / badge |
| Time | `threads.last_activity_at` | Relative time |
| Unread | `threads.unread` | 🔵 dot |

#### 49.2 AI Intent & Suggested Reply
- Intent detected via `CopilotService/ClassifyIntent`
- Suggested reply generated via `CopilotService/Query(mode=reply_suggestion)`
- "✅ Gửi gợi ý" → sends the AI reply via platform API
- "✏️ Sửa & gửi" → loads suggestion into reply editor for manual editing
- Reply is sent via `ConnectorService/ReplyComment` or `SendDM`

#### 49.3 Entity Context Panel
- Shows entity's purchase history, past interactions, follower count
- Customer value score (computed from order history)
- Quick links to entity profile and order history

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Send AI reply | "✅ Gửi gợi ý" | `ConnectorService/ReplyComment` | Reply posted, thread status → Replied |
| Edit & send | "✏️ Sửa & gửi" | `ConnectorService/ReplyComment` | Reply posted |
| Manual reply | Type + send | `ConnectorService/ReplyComment` | Reply posted |
| Resolve thread | "✅ Resolve" | `ThreadService/Update(status=resolved)` | Thread moves to resolved |
| Create follow-up | "📌 Follow-up task" | `FollowUpTaskService/Create` | Task created, linked |
| Assign | "👤 Assign" → member dropdown | `ThreadService/Update(assigned_to)` | Badge updates |
| Mute | "🔇 Mute" | `ThreadService/Update(muted=true)` | Thread hidden |
| Tag | "🏷 Tag" → tag input | `ThreadService/AddTag` | Tag chip added |
| Filter | Change filter | Refetch | List updates |
| Search | Search within inbox | Meilisearch: threads | List filters |

### States
- **Loading**: Thread list skeleton + detail empty state
- **Empty**: "Hộp thư trống 🎉 Chưa có tin nhắn mới. Đăng bài để bắt đầu tương tác!"
- **Empty (with filters)**: "Không có thread nào khớp bộ lọc. [Xóa bộ lọc]"
- **Platform degraded**: Banner "TikTok DM: Chỉ đọc (API không hỗ trợ gửi). Trả lời thủ công trên app."
- **Thread selected (no conversation)**: "Chọn một thread để xem..." placeholder

---

## 50. Thread Detail

**Route**: `/inbox/[id]` (when opened full-page on mobile or clicked from deep link)
**Purpose**: Full thread view with complete conversation history, entity profile, and actions.

Same layout as the right panel of Unified Inbox (§49) but full-screen for mobile.

### Mobile Specific
- Full-screen conversation
- Swipe left on thread in list → reveal actions (Resolve, Assign, Mute)
- Reply input fixed at bottom
- AI suggestion appears as dismissable card above reply input
- Long press on message → Copy, Reply, Create task

---

## 51. Contact List

**Route**: `/contacts`
**Purpose**: CRM-like contact list — all entities (customers, followers, partners) across platforms.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 👤 Contacts              [+ Thêm] [🔍 Search] [Filter ▾]       │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Contact Row ───────────────────────────────────────────────┐ │
│ │ [Avatar] Nguyễn Văn A    @nguyenvana                        │ │
│ │ 🎵 TikTok · 📸 Instagram · Follower: 12K                   │ │
│ │ Type: Customer · Value: ★★★★☆ · Orders: 3                  │ │
│ │ Last interaction: Comment 2h ago                             │ │
│ │ Tags: [VIP] [Food lover]                                    │ │
│ │                                              [→ Chi tiết]   │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ... more contacts ...                                            │
│ [Tải thêm ↓]                                                    │
└──────────────────────────────────────────────────────────────────┘
```

---

## 52. Contact Detail

**Route**: `/contacts/[id]`
**Purpose**: Full entity profile — cross-platform identity, purchase history, interaction history, tags.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Contacts   Nguyễn Văn A                          [✏️] [⋮]    │
├──────────────────────────────────┬───────────────────────────────┤
│ Profile (65%)                    │ Side Panel (35%)               │
│                                  │                                │
│ ┌─ Header ───────────────────┐  │ ┌─ Quick Info ───────────────┐│
│ │ [Large Avatar]              │  │ │ Type: Customer              ││
│ │ Nguyễn Văn A               │  │ │ Value: ★★★★☆               ││
│ │ @nguyenvana                │  │ │ Total spent: 2.4M VND      ││
│ │ 🎵 TikTok (12K) · 📸 IG   │  │ │ Orders: 3 · Last: 5d ago  ││
│ │ Tags: [VIP] [Food lover]   │  │ │ Satisfaction: 😊 Good       ││
│ └────────────────────────────┘  │ └─────────────────────────────┘│
│                                  │                                │
│ Tabs: [Overview] [Orders] [Threads] [Activity]                   │
│                                  │ ┌─ Actions ─────────────────┐ │
│ ── Overview Tab ──               │ │ [💬 Send message]          │ │
│ ┌─ Cross-Platform IDs ──────┐  │ │ [🎁 Send offer]            │ │
│ │ TikTok: @nguyenvana (linked)│ │ │ [🏷 Add tag]              │ │
│ │ Instagram: @nguyen.a (linked)│ │ │ [📝 Add note]             │ │
│ │ Shopee: buyer_123 (linked)  │ │ └─────────────────────────────┘│
│ └────────────────────────────┘  │                                │
│                                  │ ┌─ Notes ───────────────────┐ │
│ ── Orders Tab ──                 │ │ "VIP customer, always buys││
│ ┌─ Order List ───────────────┐  │ │  skincare products. Very   ││
│ │ #1234 · 299K · Delivered   │  │ │  responsive to discounts." ││
│ │ #1089 · 599K · Delivered   │  │ └─────────────────────────────┘│
│ │ #985 · 199K · Delivered    │  │                                │
│ └────────────────────────────┘  │                                │
└──────────────────────────────────┴───────────────────────────────┘
```

---

## 53. Follow-up Tasks

**Route**: `/inbox/tasks`
**Purpose**: Task list created from threads — reminders to follow up, send offers, check back.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 📋 Follow-up Tasks                          [+ Tạo task mới]    │
├──────────────────────────────────────────────────────────────────┤
│ Tabs: [Chưa xong (8)] [Hoàn thành (15)] [Quá hạn (2)]         │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Task ──────────────────────────────────────────────────────┐ │
│ │ ☐ Gửi link sản phẩm cho Nguyễn Văn A                       │ │
│ │   📎 Thread: "Sản phẩm mua ở đâu?" · Hạn: Hôm nay 18:00  │ │
│ │   👤 Assigned: Quân · Priority: 🔴 Urgent                   │ │
│ │   [✅ Hoàn thành] [💬 Mở thread] [✏️ Sửa]                  │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Task ──────────────────────────────────────────────────────┐ │
│ │ ☐ Follow-up khách Lê Hoa sau 3 ngày mua hàng               │ │
│ │   📎 Order: #1234 · Hạn: 30/3                              │ │
│ │   👤 Assigned: Quân · Priority: 🟡 Normal                   │ │
│ │   [✅ Hoàn thành] [📦 Xem order] [✏️ Sửa]                  │ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

---

## 54. Bulk Triage

**Route**: `/inbox/triage`
**Purpose**: Rapid triage mode — quickly process many threads with keyboard shortcuts.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ⚡ Triage Mode                    Còn 23 thread · Speed: 4 avg  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Current Thread (centered, max-width) ──────────────────────┐ │
│ │                                                              │ │
│ │ [Avatar] Nguyễn Văn A · 🎵 TikTok                          │ │
│ │ "Sản phẩm này mua ở đâu vậy ạ?"                            │ │
│ │ On post: "5 tips nấu ăn nhanh"                              │ │
│ │                                                              │ │
│ │ 🤖 Intent: Purchase · Priority suggestion: High             │ │
│ │ 🤖 Suggested reply: "Cảm ơn bạn! Link mua sản phẩm..."    │ │
│ │                                                              │ │
│ │    [1: ✅ Send AI reply]  [2: ✏️ Edit reply]                │ │
│ │    [3: ⏭ Skip]           [4: 📌 Create task]               │ │
│ │    [5: 🔇 Mute]          [6: 👤 Assign]                    │ │
│ │                                                              │ │
│ │    Keyboard: 1-6 for actions, ← → to navigate               │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ Progress: ████████████░░░░░░░░░░ 12/23 processed                │
└──────────────────────────────────────────────────────────────────┘
```

### Behavior
- One thread at a time, full-focus
- Keyboard shortcuts for all actions (1-6)
- After action → auto-advance to next thread
- Speed tracking (avg seconds per thread)
- Progress bar shows remaining
- Exit triage → back to inbox with all changes applied

---

## Mobile Screens

### M4. Mobile Unified Inbox

**Route**: `/inbox` (mobile)
**Purpose**: Full-screen threaded inbox with swipe actions and AI-assisted replies.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ 💬 Inbox (23)                                [🔍] [Filter ▾]    │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Filter: [All] [Unread] [🟢 Purchase] [❓ Question] [⭐ Priority] │
│                                                                  │
│ ┌─ Thread ───────────────────────────────────────────────────┐  │
│ │ 🔵 [Ava] Nguyễn Văn A · TikTok           · 15 min ago    │  │
│ │ "Sản phẩm này mua ở đâu vậy ạ?"                           │  │
│ │ 🟢 Purchase intent · ⭐ High priority                     │  │
│ │ ← Swipe R: [🤖 AI Reply] · Swipe L: [✅ Resolve]         │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Thread ───────────────────────────────────────────────────┐  │
│ │ 🔵 [Ava] Trần B · YouTube                 · 1h ago        │  │
│ │ "Video rất hay! Làm thêm review..."                        │  │
│ │ 💬 Compliment · Normal priority                            │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Thread ───────────────────────────────────────────────────┐  │
│ │ ⚪ [Ava] Lê C · Instagram                  · 3h ago        │  │
│ │ "Có ship COD không ạ?"                                     │  │
│ │ 🟢 Purchase intent · Normal priority                       │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Pull-to-refresh · Infinite scroll                                │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M4 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Open thread | Tap | — | → M5 Thread Detail |
| AI reply | Swipe right | `InboxService/GenerateReply` | Reply sent via AI |
| Resolve | Swipe left | `InboxService/Resolve` | Thread marked resolved |
| Filter | Tap chip | — | List filtered |
| Pull-to-refresh | Pull down | `InboxService/ListThreads` | Threads refreshed |

---

### M5. Mobile Thread Detail

**Route**: `/inbox/[threadId]` (mobile)
**Purpose**: Full-screen conversation with AI reply suggestions.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Inbox   [Ava] Nguyễn Văn A · TikTok     [👤 Profile] [⋮]    │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Entity Info Bar ──────────────────────────────────────────┐  │
│ │ 12K followers · Mua 3 lần · Customer ★★★★☆               │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Conversation (scrollable) ────────────────────────────────┐  │
│ │ [👤 A] "Sản phẩm này mua ở đâu vậy ạ?"    · 15 min ago  │  │
│ │                                                              │  │
│ │ [🤖 AI Suggested reply]                                     │  │
│ │ ┌───────────────────────────────────────────────────────┐   │  │
│ │ │ "Chào bạn! Sản phẩm có tại shop Shopee của mình:     │   │  │
│ │ │  [link]. Free ship cho đơn từ 200K ạ!"                │   │  │
│ │ │ [📤 Send] [✏️ Edit] [🔄 Regen]                       │   │  │
│ │ └───────────────────────────────────────────────────────┘   │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Reply Input ──────────────────────────────────────────────┐  │
│ │ [Type reply...                            ] [📎] [📤 Send]│  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

#### M5 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Send AI reply | "Send" on suggestion | `InboxService/SendReply` | Reply sent, haptic |
| Edit AI reply | "Edit" | — | Text editable inline |
| Regenerate | "Regen" | `InboxService/GenerateReply` | New suggestion |
| Manual reply | Type + send | `InboxService/SendReply` | Reply sent |
| View profile | "Profile" | — | → Entity detail bottom sheet |

---

### M29. Mobile Follow-up Tasks

**Route**: `/inbox/tasks` (mobile)
**Purpose**: Manage follow-up tasks with completion tracking and thread linking.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Follow-up Tasks                           [Filter ▾] [Sort ▾] │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Tabs: [⏰ Pending (5)] [✅ Done (12)] [🔴 Overdue (2)]          │
│                                                                  │
│ ┌─ Task (overdue) ───────────────────────────────────────────┐  │
│ │ 🔴 Reply to Nguyễn A about Shopee link                     │  │
│ │ From: TikTok comment · Due: 2h ago                         │  │
│ │ ← Swipe R: [✅ Done]                                      │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Task ─────────────────────────────────────────────────────┐  │
│ │ ⏰ Follow up with Trần B about collaboration              │  │
│ │ From: YouTube DM · Due: in 3h                              │  │
│ │ ← Swipe R: [✅ Done]                                      │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Task ─────────────────────────────────────────────────────┐  │
│ │ 🔴 Process refund for order #12345                         │  │
│ │ From: Email · Due: 1d ago                                  │  │
│ │ ← Swipe R: [✅ Done]                                      │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Pull-to-refresh                                                  │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M29 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Complete | Swipe right | `TaskService/Complete` | Task marked done |
| View linked | Tap task | — | → M5 thread or order detail |
| Filter | Tap tab | — | List filtered by status |
| Pull-to-refresh | Pull down | `TaskService/List` | Tasks refreshed |

