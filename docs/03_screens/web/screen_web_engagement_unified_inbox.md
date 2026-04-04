# Screen: Web — Unified Inbox

> **Screen ID**: W046
> **Module**: M12 — Unified Inbox & Engagement
> **Route**: `/inbox`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §20, A1 Schema (threads, messages, entities, intents, suggested_replies, follow_up_tasks), B5 RBAC §2.7

---
## 1. Purpose & Context

The Unified Inbox aggregates comments, DMs, and mentions from all connected platforms (TikTok, Instagram, YouTube, Shopee, Facebook) into a single split-pane interface. AI-powered intent detection classifies each message (purchase inquiry, praise, criticism, complaint, question, spam), auto-generates context-aware suggested replies leveraging product catalog and brand voice, and enables rapid triage for high-volume creators.

### User Goals
- View all messages from every platform in one inbox (no tab-switching between platform apps)
- Quickly identify high-priority / purchase-intent messages for revenue conversion
- Reply faster using AI-suggested replies tailored to brand voice
- Triage efficiently using swipe, keyboard shortcuts, and bulk actions
- Track customer relationships through entity profiles and purchase history

### Business Goals
- Reduce average response time (target: <15 min for purchase inquiries)
- Increase reply rate through AI assistance (target: >80% reply rate)
- Convert purchase-intent messages to actual sales
- Build customer relationship database (entities → CRM)
- Justify platform value by replacing 5+ separate platform inboxes

### When This Screen Is Used
- **Continuous**: High-frequency check throughout the day (most visited web screen after dashboard)
- **Real-time**: During and after content publishing (engagement spike)
- **Triage**: Morning bulk-process of overnight messages
- **Customer support**: Handling complaints and purchase questions
- **Sales**: Converting purchase-intent messages

### Entry Points
- Sidebar: "💬 Inbox" (badge shows unread count, pulsing if >50)
- Home Dashboard (W001): Unread KPI widget tap
- Notification: comment/DM notification click
- URL: `/inbox` or `/inbox?thread=[id]` (deep link to specific thread)
- Mobile: via deep link or universal link from push notification
- Global search: search result → thread

### Exit Points
- Click entity profile → `/contacts/[entity_id]` (Contact Detail)
- Click entity orders → `/orders?entity=[entity_id]`
- Create follow-up → Task created inline (no navigation)
- Triage mode → `/inbox/triage` (rapid processing UI)
- Close thread → stays in inbox with status change

---
## 2. Preconditions / Postconditions

### Preconditions
- User has `thread:read` permission (Editor+ roles)
- At least one platform connected with messaging/comment access
- Thread sync running (SSE connection active or polling as fallback)

### Postconditions
- Thread view → marked as read (optimistic update)
- Reply sent → platform API call → thread status updated
- Follow-up created → task added to workspace task list
- Entity tagged → entity profile updated
- Session engagement metrics logged

---
## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell (240px sidebar) + Split pane: Thread List (380px fixed) + Thread Detail (fill) |
| Tablet (768-1279px) | App Shell (64px sidebar) + Full-width Thread List. Click → push Thread Detail full-screen. |
| Mobile (≤767px) | Redirect to M004 Mobile Inbox |

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 💬 Inbox                           Unread: 23        [⚡ Triage]    │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Filter Bar ────────────────────────────────────────────────────┐ │
│ │ [Tất cả ▾] [Platform ▾] [Priority ▾] [Intent ▾] [🔍 Search]   │ │
│ │ [☑ Chỉ chưa đọc] [Assigned to: Me ▾]                           │ │
│ └────────────────────────────────────────────────────────────────┘ │
│                                                                      │
├─ Thread List (380px) ──────┬─ Thread Detail (fill remaining) ───────┤
│                             │                                         │
│ ┌─ Thread ────────────────┐│ ┌─ Entity Header ─────────────────────┐│
│ │ 🔵 [😊] Nguyễn Văn A   ││ │ [🖼 Avatar] Nguyễn Văn A            ││
│ │ 🎵 TikTok · Comment    ││ │ @nguyenvana · 🎵 TikTok              ││
│ │ "Sản phẩm này mua      ││ │ Followers: 12K · Purchases: 3        ││
│ │  ở đâu vậy ạ?"         ││ │ Customer value: ★★★★☆ · LTV: 1.8M   ││
│ │ 🟢 Purchase · ⭐ High  ││ │ [👤 Profile] [📦 Orders (3)]        ││
│ │ ⏱ 15 phút trước        ││ │ [🏷 Tags: VIP, skincare-buyer]      ││
│ └─────────────────────────┘│ └─────────────────────────────────────┘│
│                             │                                         │
│ ┌─ Thread ────────────────┐│ ┌─ Original Post Context ─────────────┐│
│ │ 🔵 [😄] Lê Hoa         ││ │ 📝 "5 tips nấu ăn nhanh" · 24K 👁  ││
│ │ 📸 IG · Comment         ││ │ On: 🎵 TikTok · Posted: 25/3       ││
│ │ "Quá đẹp luôn! 😍"     ││ │ Engagement: 3.2K ❤️ · 145 💬       ││
│ │ 🔵 Praise               ││ └─────────────────────────────────────┘│
│ │ ⏱ 2 giờ trước           ││                                         │
│ └─────────────────────────┘│ ┌─ Conversation ─────────────────────┐ │
│                             │ │                                     │ │
│ ┌─ Thread (read) ─────────┐│ │ 💬 Nguyễn Văn A · 15 phút trước:  │ │
│ │ ⚪ [😐] @competitor_fan ││ │ "Sản phẩm này mua ở đâu vậy ạ?"  │ │
│ │ 🎵 TikTok · Comment    ││ │                                     │ │
│ │ "Video dở quá..."       ││ │ 🤖 AI Intent: 🟢 Purchase inquiry │ │
│ │ 🟠 Criticism · ✓ Replied││ │ Confidence: 94% · Products matched:│ │
│ │ ⏱ 5 giờ trước          ││ │ [Serum VitC], [Kem chống nắng]    │ │
│ └─────────────────────────┘│ │                                     │ │
│                             │ │ ┌─ AI Suggested Reply ────────────┐│ │
│ ┌─ Thread ────────────────┐│ │ │ "Cảm ơn bạn quan tâm! 😊       ││ │
│ │ 🔵 [🛍] Trần C         ││ │ │  Bạn có thể mua Serum VitaminC ││ │
│ │ 🛍 Shopee · Chat       ││ │ │  tại: shopee.vn/creativanta/... ││ │
│ │ "Bao giờ hàng về ạ?"   ││ │ │  Đang giảm 20% hôm nay! 🎉"   ││ │
│ │ 🟢 Purchase · ⭐ High  ││ │ └────────────────────────────────┘│ │
│ │ ⏱ 30 phút trước         ││ │ [✅ Gửi gợi ý] [✏️ Sửa & gửi] │ │
│ └─────────────────────────┘│ │ [🔄 Gợi ý khác] [👎 Không phù  │ │
│                             │ │                    hợp]            │ │
│ ... virtual scroll ...      │ │                                     │ │
│                             │ │ ────── hoặc tự viết ──────         │ │
│                             │ │ ┌─────────────────────────── ┐     │ │
│                             │ │ │ Nhập tin nhắn...    [📎][💬]│    │ │
│                             │ │ └────────────────────────────┘     │ │
│                             │ └─────────────────────────────────────┘│
│                             │                                         │
│                             │ ┌─ Thread Actions ───────────────────┐ │
│                             │ │ [✅ Resolve] [📌 Follow-up task]   │ │
│                             │ │ [🏷 Tag] [👤 Assign to...] [🔇 Mute]│ │
│                             │ │ [🚫 Mark spam] [⏰ Snooze]        │ │
│                             │ └─────────────────────────────────────┘│
└─────────────────────────────┴─────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
UnifiedInboxPage
├── AppShell (shared)
├── PageHeader
│   ├── Title ("💬 Inbox") + UnreadBadge (pulsing if >50)
│   └── TriageModeButton ("⚡ Triage" → /inbox/triage)
├── FilterBar
│   ├── StatusFilter (All / Unread / Replied / Resolved / Muted)
│   ├── PlatformFilter (multi-select: TikTok, IG, YouTube, Shopee, Facebook)
│   ├── PriorityFilter (All / High / Medium / Low)
│   ├── IntentFilter (multi-select: Purchase, Praise, Criticism, Complaint, Question, Spam)
│   ├── AssignmentFilter (All / Assigned to me / Unassigned)
│   ├── SearchInput (search by keyword / buyer name / order ID)
│   └── UnreadOnlyToggle
├── SplitPane (resizable divider)
│   ├── ThreadListPanel (380px, resizable)
│   │   └── ThreadList (virtual scroll — infinite scroll)
│   │       └── ThreadListItem[] (selectable, keyboard navigable)
│   │           ├── UnreadDot (🔵 unread / ⚪ read)
│   │           ├── EntityAvatar (with emoji overlay for sentiment)
│   │           ├── EntityName + Handle
│   │           ├── PlatformBadge (icon + message type: Comment/DM/Mention)
│   │           ├── MessagePreview (1-2 lines, truncated)
│   │           ├── IntentChip (color-coded by intent class)
│   │           ├── PriorityBadge (⭐ High, visible only for high-priority)
│   │           ├── AssignedBadge (avatar of assignee, if assigned)
│   │           └── RelativeTime ("15 phút trước")
│   └── ThreadDetailPanel (fills remaining width)
│       ├── EntityHeader (rich customer profile)
│       │   ├── Avatar + Name + Handle
│       │   ├── PlatformBadge
│       │   ├── CustomerMetrics (followers, total purchases, LTV)
│       │   ├── CustomerValueRating (★★★★☆)
│       │   ├── Tags (VIP, skincare-buyer, etc.)
│       │   └── QuickLinks (Profile, Orders, Previous threads)
│       ├── OriginalPostContext (collapsible)
│       │   ├── PostTitle
│       │   ├── PostPlatform + PostDate
│       │   └── PostEngagementMetrics (views, likes, comments)
│       ├── ConversationView (scrollable)
│       │   ├── MessageBubble[] (chronological, grouped by day)
│       │   │   ├── SenderInfo (avatar, name)
│       │   │   ├── MessageContent (text, with links auto-highlighted)
│       │   │   ├── Timestamp
│       │   │   └── DeliveryStatus (sent/delivered/read — for DMs)
│       │   ├── AIIntentBadge
│       │   │   ├── IntentClass + Color
│       │   │   ├── ConfidenceScore ("94%")
│       │   │   └── MatchedProducts (if purchase intent — linked products)
│       │   └── SuggestedReplyCard
│       │       ├── AIReplyText (pre-generated, context-aware)
│       │       ├── SendSuggestionButton ("✅ Gửi gợi ý")
│       │       ├── EditAndSendButton ("✏️ Sửa & gửi" → inline edit mode)
│       │       ├── RegenerateButton ("🔄 Gợi ý khác")
│       │       └── NotRelevantButton ("👎 Không phù hợp" → feedback)
│       ├── ManualReplyInput
│       │   ├── TextInput (auto-resize, placeholder: "Nhập tin nhắn...")
│       │   ├── AttachButton ("📎" → file picker)
│       │   ├── EmojiButton
│       │   ├── TemplateButton (saved reply templates)
│       │   └── SendButton ("💬")
│       └── ThreadActionsBar
│           ├── ResolveButton ("✅ Resolve")
│           ├── CreateFollowUpButton ("📌 Follow-up task")
│           ├── TagButton ("🏷 Tag" → tag picker)
│           ├── AssignButton ("👤 Assign" → member picker)
│           ├── MuteButton ("🔇 Mute")
│           ├── SpamButton ("🚫 Mark spam")
│           └── SnoozeButton ("⏰ Snooze" → duration picker)
```

---
## 5. Displayed Data

| Element | Source | API | Display Format | Cache |
|---|---|---|---|---|
| Thread list | `threads + latest messages` | `ThreadService/List(filters, cursor)` | Thread list items, 20 per page | Real-time SSE |
| Entity info | `entities` join | Included in thread | Avatar, name, handle, metrics | 10m |
| Customer value | `entities.customer_value` | same | ★★★★☆ (1-5 stars) | 10m |
| LTV | `entities.lifetime_value` | same | "1.8M VND" (compact) | 10m |
| Purchase count | `COUNT(orders WHERE buyer=entity)` | same | "3 purchases" | 10m |
| Intent | `intents.intent_class` | Pre-computed on message arrival | Color chip (see Intent Color Map) | — |
| Confidence | `intents.confidence` | same | "94%" | — |
| Matched products | `intents.matched_product_ids` | Join | Product names linked | — |
| Suggested reply | AI-generated | `CopilotService/Query(mode=reply, thread_context)` | Card with text | Per-thread |
| Original post | `content.title` + metrics | Join | Title + view count | 10m |
| Unread count | `COUNT(threads WHERE unread)` | `ThreadService/GetUnreadCount()` | Badge number | Real-time |
| Messages | `messages ORDER BY created_at` | `ThreadService/GetMessages(thread_id)` | Bubbles | Per-thread |

### Intent Color Map
| Intent | Color | Icon | Priority Weight |
|---|---|---|---|
| Purchase inquiry | 🟢 Green | 🛒 | **Highest** — revenue opportunity |
| Complaint | 🔴 Red | ⚠️ | **High** — reputation risk |
| Question | ⚪ Gray | ❓ | Medium |
| Criticism | 🟠 Orange | 👎 | Medium — monitor |
| Praise | 🔵 Blue | 👍 | Low — reply optional |
| Spam | ⚫ Black | 🚫 | Lowest — auto-filter |

---
## 6. User Actions

| # | Action | Trigger | Type | API Call | System Response | Permission |
|---|---|---|---|---|---|---|
| 1 | Select thread | Click thread in list | Select | `ThreadService/MarkRead(id)` | Detail panel loads. Thread marked read (optimistic). | `thread:read` |
| 2 | Send AI reply | "✅ Gửi gợi ý" | Primary CTA | `ConnectorService/ReplyComment(thread_id, text)` | Reply posted to platform. Toast "✅ Đã gửi." Thread status → Replied. | `thread:reply` |
| 3 | Edit & send | "✏️ Sửa & gửi" | Edit + Send | (inline edit → then ConnectorService) | AI text becomes editable. User modifies → send. | `thread:reply` |
| 4 | Regenerate reply | "🔄 Gợi ý khác" | AI | `CopilotService/Query(mode=reply, regenerate=true)` | New suggestion replaces current one (typing animation). | `copilot:use_help` |
| 5 | Mark not relevant | "👎 Không phù hợp" | Feedback | `CopilotService/Feedback(negative)` | Card hides. Manual reply input highlighted. Feedback logged for AI improvement. | `thread:reply` |
| 6 | Send manual reply | Type + "💬" send | Reply | `ConnectorService/ReplyComment(thread_id, text)` | Reply posted. Thread status → Replied. | `thread:reply` |
| 7 | Attach file | "📎" → file picker | Attach | File upload → included in reply | File preview appears in reply input. | `thread:reply` |
| 8 | Use template | Template button → picker | Insert | — | Template text inserted into reply input. | `thread:reply` |
| 9 | Resolve thread | "✅ Resolve" | Status | `ThreadService/Update(id, status=resolved)` | Thread moves to resolved. Fades in list if filtered to unread. | `thread:triage` |
| 10 | Create follow-up | "📌 Follow-up task" | Create | `FollowUpTaskService/Create(thread_id, entity_id)` | Dialog for task description → Task created. Toast "📌 Task tạo xong." | `thread:triage` |
| 11 | Tag thread | "🏷 Tag" → picker | Update | `ThreadService/AddTag(id, tag)` | Tag chip appears on thread item. | `thread:triage` |
| 12 | Assign thread | "👤 Assign" → member picker | Assign | `ThreadService/Update(id, assigned_to)` | Assignment badge shows on thread. | `thread:triage` |
| 13 | Mute thread | "🔇 Mute" | Status | `ThreadService/Update(id, muted=true)` | Thread hidden from default list (visible with "Muted" filter). | `thread:triage` |
| 14 | Mark spam | "🚫 Mark spam" | Status | `ThreadService/Update(id, is_spam=true)` | Thread hidden. Feedback sent to AI for future auto-classification. | `thread:triage` |
| 15 | Snooze thread | "⏰ Snooze" → duration | Schedule | `ThreadService/Snooze(id, wake_at)` | Thread hidden until wake_at. Reappears as unread. | `thread:triage` |
| 16 | Filter | Change any filter | Filter | `ThreadService/List(filters)` | Thread list updates. Active filter badge shown. | `thread:read` |
| 17 | Search | Type in search (debounced) | Search | Meilisearch query | Thread list filters by keyword. | `thread:read` |
| 18 | Enter triage mode | "⚡ Triage" | Navigate | — | → `/inbox/triage` (rapid processing UI) | `thread:triage` |
| 19 | View entity profile | "👤 Profile" | Navigate | — | → `/contacts/[entity_id]` | `thread:read` |
| 20 | View entity orders | "📦 Orders" | Navigate | — | → `/orders?entity=[entity_id]` | `order:read` |
| 21 | Keyboard nav | ↑↓ arrows | Select | — | Navigate thread list. J/K also work (Vim-style). | `thread:read` |
| 22 | Keyboard reply | R key | Focus | — | Focus jumps to reply input. | `thread:reply` |

---
## 7. Validation Rules

### Reply Text
| Check | Rule | Error |
|---|---|---|
| Required | Must not be empty | "Nội dung trả lời không được trống" |
| TikTok comment max | 150 characters | "Quá dài cho TikTok comment (max 150). [Tự cắt →]" |
| Instagram comment max | 2200 characters | "Quá dài cho Instagram comment" |
| YouTube comment max | 10000 characters | — |
| Shopee chat max | 5000 characters | — |
| Attachment size | Max 10MB per file | "File quá lớn (tối đa 10MB)" |
| Attachment type | Images, PDF only for DMs | "Định dạng không hỗ trợ" |

---
## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial page load | Thread list skeleton + empty detail panel | Wait |
| LOADED | Data ready | Split-pane with thread list and detail (first thread auto-selected) | Interact |
| THREAD_SELECTED | Thread clicked | Detail panel populated with conversation + AI reply | Reply/manage |
| NO_THREADS | Zero threads total | "💬 Hộp thư trống 🎉 Đăng bài để nhận tương tác!" + CTA "📤 Đăng bài" | Create content |
| NO_MATCH_FILTER | Filters active but 0 results | "Không có thread phù hợp bộ lọc. [Xóa bộ lọc]" | Clear filters |
| AI_GENERATING | AI generating suggested reply | Reply card shows typing animation ("🤖 Đang soạn gợi ý...") | Wait |
| SENDING_REPLY | Reply being sent | Send button shows spinner. Input disabled. | Wait |
| REPLY_FAILED | Reply failed to send | Error toast "Không gửi được. [Thử lại]". Reply text preserved. | Retry |
| PLATFORM_DEGRADED | Platform API limited | Banner per platform: "🟡 TikTok: Chỉ đọc (API limit). DM trả lời không khả dụng." | Read-only |
| BULK_SELECT | Multiple threads selected | Bulk action bar appears at top | Bulk actions |
| ERROR | API failed | "❌ Không tải được inbox. [Thử lại]" | Retry |

---
## 9. Permissions & Role-based Behavior

| Action | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View inbox | ✅ | ✅ | ✅ | ✅ | ✅ (assigned) | ❌ | ❌ |
| View all threads | ✅ | ✅ | ✅ | ✅ | ❌ (own assigned only) | ❌ | ❌ |
| Reply | ✅ | ✅ | ✅ | ✅ | ⚠️ assigned only | ❌ | ❌ |
| AI suggested reply | ✅ | ✅ | ✅ | ✅ | ⚠️ assigned + credit | ❌ | ❌ |
| Resolve thread | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Assign thread | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Mute / Spam | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Triage mode | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Create follow-up | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| View entity profile | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

### Visibility Rules
- **Editor**: Sees all threads, can reply, but cannot manage (resolve/assign/mute). Thread action bar shows only reply.
- **Contributor**: Sees only threads assigned to them. Sidebar badge shows own assigned unread count only.
- **Viewer/External**: No access. No sidebar item.

---
## 10. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| New threads | SSE `/events/inbox` | Real-time — thread slides in at top |
| Thread status change | SSE | Real-time — badge/status updates inline |
| New messages in active thread | SSE `/events/inbox/thread/{id}` | Real-time — appended to conversation |
| Unread count | SSE | Real-time — sidebar badge + page badge |
| AI reply ready | SSE | After pre-computation — card appears with typing animation |

### Real-time UX
- **New thread**: Slides in from top with highlight pulse (gold → transparent, 3s). Unread dot 🔵 shows.
- **New message in active thread**: Message bubble appends with slide-up animation. Auto-scroll to bottom.
- **Reply sent confirmation**: Message appears in conversation as "You" bubble. Green checkmark animation.
- **Team member resolves**: Thread status changes in real-time. If filtered to unread, thread fades out.

---
## 11. Edge Cases

| Edge Case | Handling |
|---|---|
| 1000+ unread threads | Virtual scroll. Badge caps at "99+". "⚡ Triage mode" suggested prominently. |
| AI confidence < 50% | Intent badge shows "❓ Uncertain". No auto-generated reply. Manual reply input highlighted. |
| Platform token expired | Banner: "🔴 TikTok ngắt kết nối. Tin nhắn không cập nhật. [Kết nối lại →]" |
| Reply char limit exceeded | Inline warning appears. Auto-truncation offered: "[Tự cắt →]" |
| Same entity across platforms | Entity merged. Header shows: "Also on: Instagram, Shopee". All threads grouped. |
| Thread in language ≠ Vietnamese | AI detects language. Reply generated in same language. Option to translate. |
| Media-only message (image/sticker) | Show "[🖼 Hình ảnh]" preview. AI reply acknowledges: "Cảm ơn bạn đã chia sẻ 😊" |
| Deleted comment (platform-side) | Thread shows: "💨 Comment đã bị xóa trên nền tảng" with strikethrough. |
| Very long conversation (50+ messages) | Lazy-load older messages. Show "Tải thêm tin nhắn cũ ↑" |
| Reply failed → platform API down | Show error inline. Queue reply for retry. "⏳ Đã lưu — sẽ tự gửi khi nền tảng khôi phục." |

---
## 12. Keyboard Shortcuts

| Shortcut | Action |
|---|---|
| `J` / `↓` | Next thread |
| `K` / `↑` | Previous thread |
| `R` | Focus reply input |
| `Enter` (in list) | Select thread / open detail |
| `E` | Resolve thread |
| `A` | Assign thread |
| `T` | Tag thread |
| `M` | Mute thread |
| `S` | Snooze thread |
| `Shift+Enter` | Send reply (when focused) |
| `/` | Focus search |
| `Escape` | Clear selection / close modal |

---
## 13. Accessibility

| Element | Requirement |
|---|---|
| Thread list | `role="listbox"`, `aria-label="Danh sách hội thoại"`, arrow key navigation |
| Thread item | `role="option"`, `aria-selected`, `aria-label="Thread từ {name}, {intent}, {time_ago}"` |
| Reply input | `role="textbox"`, `aria-label="Nhập trả lời"`, Shift+Enter to send |
| Intent badges | Color + icon + text label (not color-only) |
| AI reply card | `role="region"`, `aria-label="AI gợi ý trả lời"` |
| Error banner | `role="alert"`, `aria-live="assertive"` |
| Keyboard | Full keyboard navigation (see shortcuts above) |
| Focus management | Auto-focus first unread thread. After reply send → focus back to thread list. |
| Screen reader | All icons with `aria-label` or `sr-only` text |

---
## 14. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `inbox.viewed` | Page load | `unread_count`, `filter_active`, `platform_filter` |
| `inbox.thread.selected` | Thread click | `thread_id`, `intent`, `priority`, `platform` |
| `inbox.reply.ai_sent` | AI reply sent directly | `thread_id`, `intent`, `reply_length`, `time_to_reply_ms` |
| `inbox.reply.ai_edited` | AI reply edited & sent | `thread_id`, `edit_distance`, `time_to_reply_ms` |
| `inbox.reply.manual` | Manual reply sent | `thread_id`, `reply_length`, `time_to_reply_ms` |
| `inbox.reply.regenerated` | AI regenerated | `thread_id`, `regenerate_count` |
| `inbox.reply.rejected` | "Not relevant" clicked | `thread_id`, `intent` |
| `inbox.thread.resolved` | Thread resolved | `thread_id`, `reply_count`, `total_time_open` |
| `inbox.thread.assigned` | Thread assigned | `thread_id`, `assignee_id` |
| `inbox.thread.snoozed` | Thread snoozed | `thread_id`, `snooze_duration` |
| `inbox.filter.changed` | Filter applied | `filter_type`, `filter_value` |
| `inbox.triage.entered` | Triage mode entered | `unread_count` |
| `inbox.reply.failed` | Reply failed | `thread_id`, `error_type` |

---
## 15. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 1.5s (thread list rendered) |
| TTI | < 2.0s |
| Thread list virtual scroll | 60fps for 10,000+ threads |
| Thread selection → detail load | < 300ms |
| AI reply generation | < 3s (streamed) |
| Reply send → confirmation | < 2s |
| Search | < 300ms (Meilisearch) |
| Real-time new thread render | < 500ms from SSE event |

---
## 16. Technical Implementation Notes

### SvelteKit Specifics
- **Route**: `src/routes/(app)/inbox/+page.svelte`
- **Layout**: Split-pane with resizable divider (`svelte-split-pane`)
- **Server load**: `+page.server.ts` → initial thread list (20 items, unread first)
- **SSE**: Client-side `onMount` → `EventSource('/events/inbox')` for real-time
- **Thread detail**: Client-side fetch on selection (not server load)
- **Virtual scroll**: `svelte-virtual-list` for thread list

### Data Flow
```
SSE events (new thread / status change / new message)
  → Svelte store update → UI reactively updates
  → Unread counter badge (sidebar, page, tab title)

Reply flow:
  User sends → optimistic UI (message appears instantly)
  → ConnectorService/ReplyComment → platform API
  → on success: confirm checkmark
  → on failure: error indicator + retry
```

### AI Reply Pre-computation
- Purchase-intent threads: AI reply pre-computed on message arrival (server-side)
- Other intents: AI reply computed on demand (when thread selected)
- Context includes: entity purchase history, product catalog, brand voice guide

---
## 17. Navigation Map

```
Unified Inbox (/inbox)
├── → /inbox?thread=[id] (deep link to specific thread)
├── → /inbox/triage (rapid triage mode)
├── → /inbox/tasks (follow-up task list)
├── → /contacts/[entity_id] (entity profile)
├── → /orders?entity=[entity_id] (entity orders)
```

---
## 5. Data Binding & Display Format
*(Refer to screen-specific data binding in section above)*


---
## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W047] Thread Detail | Full-page thread view (deep link) |
| [W048] Contact List | Entity management / CRM |
| [W050] Bulk Triage | Rapid processing mode |
| [M019] Mobile Inbox | Mobile equivalent |
| [W001] Home Dashboard | Unread count widget |
---
## Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached data | Pull-to-refresh when online |
| API error | Server 5xx | Toast: "Không tải được dữ liệu. [Thử lại]" | Retry |
| Not found | 404 | "Không tìm thấy" → navigate back | Back |
| Permission denied | 403 | "Không có quyền truy cập" | Contact admin |

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
