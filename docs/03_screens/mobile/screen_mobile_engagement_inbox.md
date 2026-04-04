# Screen: Mobile — Unified Inbox

> **Screen ID**: M019
> **Module**: M12 — Unified Inbox & Engagement
> **Route**: `/inbox` (bottom tab: 💬)
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 01 §4, Product Freeze §20, A1 Schema (threads, messages, entities, intents, suggested_replies), B5 RBAC §2.7

---
## 1. Purpose & Context

Mobile Unified Inbox — the highest-frequency mobile screen after the home dashboard. Optimized for rapid triage with swipe gestures, AI-suggested replies, and one-thumb operation. Threads are sorted by AI-computed priority with intent badges for instant classification. Designed for the "reply while commuting" usage pattern.

### User Goals
- Quickly scan and triage all messages from all platforms on mobile
- Reply to high-priority messages (purchase inquiries, complaints) within minutes
- Use AI-suggested replies for speed — edit and send in one thumb gesture
- Stay responsive without needing the desktop app

### Business Goals
- Enable sub-15-minute response time on purchase inquiries (mobile is the fastest path)
- Maintain >80% reply rate through AI assistance
- Drive mobile engagement stickiness (inbox notifications → app opens → time-in-app)
- Reduce missed messages (push notifications + badge count)

### When This Screen Is Used
- **Push notification tap**: Most common entry — notification → specific thread
- **Periodic check**: Multiple times per day between activities
- **During commute**: Quick triage and AI-assisted replies
- **After publishing**: Engagement spike → reply to new comments
- **Morning ritual**: Bulk-process overnight messages

### Entry Points
- Bottom nav: 💬 tab (badge shows unread count)
- Push notification: tap → opens specific thread (deep link)
- Home Dashboard (M001): Unread KPI tap → inbox
- iOS/Android system badge → app opens → inbox tab
- Universal link: `creativanta.vn/inbox/[thread_id]`

### Exit Points
- Thread detail → reply sent → auto-back to list
- Entity profile → `/contacts/[id]` (push navigation)
- Entity orders → `/orders?entity=[id]` (push navigation)
- Triage mode → rapid processing UI

---
## 2. Preconditions / Postconditions

### Preconditions
- User has `thread:read` permission
- At least one platform connected with messaging/comment access
- Push notification permissions granted (for real-time delivery)

### Postconditions
- Thread view → marked as read
- Reply sent → platform API call → thread status updated
- Follow-up created → task added to task list
- Badge count updated (both in-app and system badge)
- Offline replies queued for send when online

---
## 3. Screen Layout

### ASCII Wireframe — Thread List
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ 💬 Inbox (23 chưa đọc)           [⚡ Triage] [🔍 Search]           │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Quick Filter Chips (horizontal scroll) ─────────────────────────┐│
│ │ [✱ Tất cả (23)] [🛒 Mua (8)] [💬 Chat (6)] [👍 Khen (5)]      ││
│ │ [⚠️ Phàn nàn (2)] [❓ Hỏi (2)] [🚫 Spam (0)]                    ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Thread Row ──────────────────────────────────────────────────────┐│
│ │ 🔵 [😊] Nguyễn Văn A            🎵 TikTok    15 phút ←         ││
│ │       "Sản phẩm này mua ở đâu vậy ạ?"                            ││
│ │       🟢 Purchase · ⭐ High priority                               ││
│ │                                        ← swipe: ✅ Reply | 📌 → ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Thread Row ──────────────────────────────────────────────────────┐│
│ │ 🔵 [😄] Lê Hoa                  📸 Instagram  2 giờ ←           ││
│ │       "Quá đẹp luôn! 😍"                                         ││
│ │       🔵 Praise                                                    ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Thread Row (read) ──────────────────────────────────────────────┐│
│ │ ⚪ [😐] @competitor_fan          🎵 TikTok    5 giờ ←            ││
│ │       "Video dở quá..."                                            ││
│ │       🟠 Criticism · ✓ Replied                                     ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Thread Row ──────────────────────────────────────────────────────┐│
│ │ 🔵 [🛍] Trần Văn C              🛍 Shopee    30 phút ←          ││
│ │       "Bao giờ hàng về ạ?"                                         ││
│ │       🟢 Purchase · ⭐ High                                        ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ... pull up for more ...                                              │
│                                                                      │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬•23] [📊]                                        │
└──────────────────────────────────────────────────────────────────────┘
```

### ASCII Wireframe — Thread Detail (push navigation)
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Inbox        Nguyễn Văn A        🎵 TikTok     [⋮ Actions]      │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Entity Quick Info ───────────────────────────────────────────────┐│
│ │ [🖼 Avatar] Nguyễn Văn A · @nguyenvana                            ││
│ │ Followers: 12K · Mua 3 lần · ★★★★☆                               ││
│ │ [👤 Profile] [📦 Orders (3)] [🏷 Tags: VIP]                      ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Original Post ───────────────────────────────────────────────────┐│
│ │ 📝 "5 tips nấu ăn nhanh" · 24K 👁 · 🎵 TikTok                  ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Conversation ────────────────────────────────────────────────────┐│
│ │                                                                    ││
│ │ 💬 Nguyễn Văn A · 15 phút trước:                                 ││
│ │ "Sản phẩm này mua ở đâu vậy ạ?"                                  ││
│ │                                                                    ││
│ │ 🤖 AI: 🟢 Purchase inquiry (94%)                                 ││
│ │ Products: [Serum VitC], [Kem chống nắng]                          ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ AI Suggested Reply ─────────────────────────────────────────────┐│
│ │ "Cảm ơn bạn quan tâm! 😊                                         ││
│ │  Bạn có thể mua Serum Vitamin C tại:                              ││
│ │  shopee.vn/creativanta/serum-vitc                                  ││
│ │  Đang giảm 20% hôm nay nha! 🎉"                                  ││
│ │                                                                    ││
│ │ [✅ Gửi] [✏️ Sửa & gửi] [🔄 Khác]                               ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Quick Actions (horizontal scroll) ──────────────────────────────┐│
│ │ [✅ Resolve] [📌 Follow-up] [👤 Profile] [📦 Orders] [🏷 Tag]  ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Reply Input ─────────────────────────────────────────────────────┐│
│ │ [Nhập tin nhắn...                                    ] [💬 Gửi]  ││
│ └──────────────────────────────────────────────────────────────────┘│
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
MobileInboxPage
├── AppBar
│   ├── Title ("💬 Inbox") + UnreadBadge
│   ├── TriageModeButton ("⚡")
│   └── SearchButton ("🔍" → expands search bar)
├── QuickFilterChips (horizontal scroll)
│   └── IntentFilterChip[] (All, Purchase, Chat, Praise, Complaint, Question, Spam)
│       ├── IntentIcon
│       ├── Label
│       └── Count (unread count per intent)
├── ThreadList (pull-to-refresh, infinite scroll)
│   └── ThreadRow[] (swipeable — Dismissible widget)
│       ├── UnreadDot (🔵 unread / ⚪ read)
│       ├── SentimentEmoji (😊/😄/😐/😡/🛍 — overlay on avatar)
│       ├── EntityAvatar
│       ├── EntityName
│       ├── PlatformBadge (🎵/📸/📺/🛍)
│       ├── MessagePreview (1 line, truncated)
│       ├── IntentBadge (color chip: 🟢🔴🟠🔵⚪🚫)
│       ├── PriorityBadge (⭐ if high)
│       ├── RepliedCheckmark (✓ if replied)
│       ├── RelativeTime
│       ├── SwipeLeftAction → QuickReplyDrawer
│       └── SwipeRightAction → FollowUpAction
├── ThreadDetailPage (pushed navigation)
│   ├── AppBar (← back, entity name, platform, "⋮" actions menu)
│   ├── EntityQuickInfo (avatar, name, metrics, quick links)
│   ├── OriginalPostContext (collapsible)
│   ├── ConversationView (scrollable)
│   │   ├── MessageBubble[] (with timestamps, grouped by day)
│   │   └── AIIntentBadge (intent + confidence + matched products)
│   ├── SuggestedReplyCard
│   │   ├── AIReplyText
│   │   ├── SendButton ("✅ Gửi")
│   │   ├── EditAndSendButton ("✏️ Sửa & gửi")
│   │   └── RegenerateButton ("🔄 Khác")
│   ├── QuickActionsScroller (horizontal chips)
│   └── ReplyInput
│       ├── TextField (auto-resize)
│       └── SendButton ("💬")
└── BottomNavBar (💬 tab shows badge)
```

---
## 5. Displayed Data

| Element | Source | API | Display Format | Cache |
|---|---|---|---|---|
| Thread list | `threads + latest message` | `ThreadService/ListMobile(filters, cursor)` | Thread rows, 20 per page | Real-time SSE/push |
| Entity info | `entities` join | In thread | Name, handle, avatar, metrics | 10m |
| Customer value | `entities.customer_value` | same | ★★★★☆ | 10m |
| Purchase count | `COUNT(orders WHERE buyer=entity)` | same | "Mua 3 lần" | 10m |
| Intent | `intents.intent_class` | Pre-computed | Color chip (same map as web) | — |
| Confidence | `intents.confidence` | same | "94%" | — |
| Matched products | `intents.matched_product_ids` | Join | Product names | — |
| AI reply | `CopilotService/Query(mode=reply)` | On-demand | Card text | Per-thread |
| Original post | `content.title + metrics` | Join | Title + views | 10m |
| Unread count | `COUNT(threads WHERE unread)` | Real-time | Badge number | Real-time |

---
## 6. User Actions

| # | Action | Trigger | Type | API Call | System Response | Permission |
|---|---|---|---|---|---|---|
| 1 | Open thread | Tap thread row | Navigate | `ThreadService/MarkRead(id)` | Push detail page. Mark read. Badge decrements. | `thread:read` |
| 2 | Swipe quick reply | Swipe left on row | Drawer | Pre-filled AI reply bottom sheet | AI reply shown. One-tap send. Haptic medium. | `thread:reply` |
| 3 | Swipe follow-up | Swipe right on row | Action | `FollowUpTaskService/Create(thread_id)` | Task created. Haptic success. Toast "📌 Task tạo." | `thread:triage` |
| 4 | Send AI reply | "✅ Gửi" in detail | Primary CTA | `ConnectorService/Reply(thread, text)` | Reply posted. Toast "✅ Đã gửi." Pop back optional. | `thread:reply` |
| 5 | Edit & send | "✏️ Sửa & gửi" | Edit → Send | (edit inline → send) | Text becomes editable. User modifies → tap send. | `thread:reply` |
| 6 | Regenerate AI | "🔄 Khác" | AI | `CopilotService/Query(regenerate)` | New suggestion replaces. Typing animation. | `copilot:use_help` |
| 7 | Manual reply | Type + "💬" send | Reply | `ConnectorService/Reply(thread, text)` | Reply sent. Bubble appears in conversation. | `thread:reply` |
| 8 | Filter by intent | Tap filter chip | Filter | `ThreadService/ListMobile(intent=...)` | List updates. Badge per filter. | `thread:read` |
| 9 | Pull refresh | Pull-down | Refresh | Refetch thread list | List updates. Haptic light. | `thread:read` |
| 10 | Search | Tap 🔍 → type | Search | Meilisearch query | Results in list. | `thread:read` |
| 11 | Resolve thread | Detail → ⋮ → "✅ Resolve" | Status | `ThreadService/Update(resolved)` | Pop back. Thread shows ✓ in list. | `thread:triage` |
| 12 | View profile | "👤 Profile" in detail | Navigate | — | Push → Contact Detail | `thread:read` |
| 13 | View orders | "📦 Orders" in detail | Navigate | — | Push → Order list filtered | `order:read` |
| 14 | Tag thread | "🏷 Tag" in detail | Update | `ThreadService/AddTag` | Tag chip added. | `thread:triage` |

---
## 7. Validation Rules

### Reply
| Check | Rule | Error |
|---|---|---|
| Required | Not empty | "Nhập nội dung trả lời" |
| TikTok comment | Max 150 chars | "Quá dài (max 150). Sẽ tự cắt." |
| Instagram comment | Max 2200 chars | "Quá dài (max 2200)" |
| Shopee chat | Max 5000 chars | — |

---
## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial page load | Shimmer thread list. Bottom nav shows cached badge. | Wait |
| LOADED | Data ready, threads present | Full list with badges and intent chips. | Interact |
| EMPTY | No threads at all | "💬 Hộp thư trống 🎉 Đăng bài để nhận tương tác!" + CTA "📤 Đăng bài" | Create content |
| FILTERED_EMPTY | Filter active, 0 results | "Không có tin nhắn {intent}. [Xem tất cả →]" | Clear filter |
| REFRESHING | Pull-to-refresh | Refresh indicator at top. Existing list visible. | Wait |
| DETAIL_LOADING | Thread detail opening | Detail skeleton. App bar shows entity name. | Wait |
| AI_GENERATING | AI generating reply | Reply card shows "🤖 Đang soạn..." typing dots. | Wait |
| SENDING | Reply being sent | Send button shows spinner. Input disabled. | Wait |
| SEND_FAILED | Reply failed | Error toast "❌ Không gửi được. [Thử lại]". Text preserved. | Retry |
| OFFLINE | No network | List shows cached threads. Banner: "📡 Ngoại tuyến — trả lời sẽ gửi khi có mạng" | Compose offline reply |
| ERROR | API failed | "Không tải được inbox. [Kéo xuống để thử lại]" | Pull refresh |

---
## 9. Permissions & Role-based Behavior

| Action | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View inbox | ✅ | ✅ | ✅ | ✅ | ✅ (assigned) | ❌ | ❌ |
| Reply | ✅ | ✅ | ✅ | ✅ | ⚠️ assigned | ❌ | ❌ |
| AI reply | ✅ | ✅ | ✅ | ✅ | ⚠️ credit | ❌ | ❌ |
| Resolve | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Assign/Tag | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Triage mode | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Swipe follow-up | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| View entity | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

### Visibility Rules
- **Contributor**: Bottom nav shows 💬 badge with own-assigned count only. Sees only threads assigned to them.
- **Viewer/External**: 💬 tab hidden from bottom nav.

---
## 10. Mobile-specific UX

### Gestures & Haptics
| Gesture | Target | Haptic | Result |
|---|---|---|---|
| Tap thread | Thread row | Light | Push → thread detail |
| Swipe left | Thread row | Medium (at threshold) | Quick reply bottom sheet |
| Swipe right | Thread row | Medium | Create follow-up task |
| Pull down | Thread list | Light | Refresh |
| Long press thread | Thread row | Heavy | Context menu (Resolve, Tag, Mute, Spam) |
| Tap AI send | "✅ Gửi" button | Success vibration | Reply sent |

### Quick Reply Bottom Sheet (swipe left)
```
┌─────────────────────────────────────────┐
│ Trả lời nhanh — Nguyễn Văn A           │
│                                         │
│ 🤖 AI gợi ý:                           │
│ "Cảm ơn bạn quan tâm! 😊               │
│  Mua tại shopee.vn/creativanta/serum    │
│  Giảm 20% hôm nay! 🎉"                │
│                                         │
│ [✅ Gửi ngay] [✏️ Sửa] [🔄 Khác]     │
│                                         │
│ hoặc:                                   │
│ [Nhập tin nhắn...             ] [💬]    │
└─────────────────────────────────────────┘
```

### Push Notification Behavior
- **Platform message → server → FCM/APNs → device notification**
- Notification shows: entity name, platform icon, message preview
- Tap notification → app opens → specific thread detail (deep link)
- Inline reply action on notification (iOS/Android): reply without opening app
- Badge count updates on both notification and app icon

### Offline Behavior
- **Available offline**: Cached thread list, entity info, previous conversations
- **Not cached**: AI suggestions (require API), new threads (require SSE/push)
- **Offline reply**: User can compose reply → queued → auto-sent when online
- Visual: Banner "📡 Ngoại tuyến — trả lời sẽ gửi khi có mạng"

---
## 11. Edge Cases

| Edge Case | Handling |
|---|---|
| 100+ unread threads | Badge shows "99+". Triage mode suggested if >50 unread. |
| AI confidence < 50% | No auto-generated reply. Manual reply input highlighted. Intent shows "❓ Uncertain". |
| Platform token expired | Thread list shows stale data. Banner: "🔴 TikTok ngắt — cập nhật bị gián đoạn [→]" |
| Same entity on 2+ platforms | Entity unified. Thread shows primary platform. Profile shows all platforms. |
| Reply char limit exceeded | Counter turns red. Toast: "Quá dài. Tự cắt khi gửi." Auto-truncation applies. |
| Media-only message | Show "[🖼 Hình ảnh]" in preview. Detail shows image inline. |
| Deleted comment | "💨 Đã xóa trên nền tảng" with strikethrough. No reply possible. |
| Push notification while in inbox | Thread highlights with bounce animation. Badge increments. |
| Swipe on read thread | Same behavior as unread. Quick reply still available. |

---
## 12. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| New threads | Push notification + SSE fallback | Real-time |
| Thread status | SSE | Real-time |
| New messages in thread | SSE per-thread | Real-time (when in detail view) |
| Unread count | Push + SSE | Real-time (badge updates) |

### Real-time UX
- **New thread**: Slides in at top with highlight pulse. Bottom nav badge ++.
- **New message in active thread**: Bubble appends. Auto-scroll. Haptic light.
- **Reply confirmation**: "You" bubble appears with green ✓.

---
## 13. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `inbox.mobile.viewed` | Tab opened / Page load | `unread_count`, `filter`, `source` (tab/push/kpi) |
| `inbox.mobile.thread.opened` | Thread tapped | `thread_id`, `intent`, `priority`, `time_since_message` |
| `inbox.mobile.reply.ai_sent` | AI reply sent | `thread_id`, `reply_length`, `time_to_reply_ms` |
| `inbox.mobile.reply.ai_edited` | AI edited & sent | `thread_id`, `edit_distance` |
| `inbox.mobile.reply.manual` | Manual reply | `thread_id`, `reply_length` |
| `inbox.mobile.swipe.reply` | Swipe quick reply | `thread_id`, `intent` |
| `inbox.mobile.swipe.followup` | Swipe follow-up | `thread_id` |
| `inbox.mobile.filter.used` | Filter chip tapped | `filter_intent` |
| `inbox.mobile.notification.opened` | Push notification → thread | `thread_id`, `notification_delay_ms` |

---
## 14. Performance Requirements

| Metric | Target |
|---|---|
| Cold open to interactive | < 2s |
| Thread list scroll | 60fps (virtual scroll) |
| Thread detail load | < 500ms |
| AI reply generation | < 3s (streamed) |
| Reply send → confirmation | < 2s |
| Push notification → display | < 1s |
| Swipe gesture recognition | < 100ms |

---
## 15. Flutter Implementation Notes

### Widget Structure
- **Route**: `/inbox` → `InboxPage extends ConsumerStatefulWidget`
- **State**: Riverpod `inboxProvider` (thread list + filters + unread count)
- **Thread list**: `ListView.builder` with `Dismissible` for swipe gestures
- **Thread detail**: Push navigation `Navigator.push → ThreadDetailPage`
- **Quick reply**: `showModalBottomSheet` with AI pre-fill
- **Pull-to-refresh**: `RefreshIndicator`
- **Push nav from notification**: `firebase_messaging` → `NavigationService.pushThread(id)`

### Notification Setup
```dart
// FCM token registration
FirebaseMessaging.onMessage.listen((message) {
  // In-app: update thread list + badge
  ref.invalidate(inboxProvider);
  showLocalNotification(message);
});

FirebaseMessaging.onMessageOpenedApp.listen((message) {
  // Deep link to thread
  final threadId = message.data['thread_id'];
  NavigationService.pushThread(threadId);
});
```

### Offline Reply Queue
```dart
Future<void> sendReply(String threadId, String text) async {
  try {
    await connectorService.reply(threadId, text);
  } on NetworkException {
    await offlineQueue.add(PendingReply(threadId, text));
    showToast('📡 Đã lưu — sẽ gửi khi có mạng');
  }
}

// OnConnectivity restored:
connectivityStream.listen((status) {
  if (status == ConnectivityResult.wifi || status == ConnectivityResult.mobile) {
    offlineQueue.processAll();
  }
});
```

---
## 16. Navigation Map

```
Mobile Inbox (/inbox — bottom tab 💬)
├── → /inbox/thread/[id] (tap thread → detail)
├── → /inbox/triage (⚡ rapid processing)
├── → /contacts/[entity_id] (entity profile)
├── → /orders?entity=[entity_id] (entity orders)
```

---
## 17. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network error | No connectivity during list fetch | Banner: "📡 Ngoại tuyến — hiển thị tin nhắn cached" + disable send | Auto-retry on reconnect |
| Reply send failed | Platform API error (rate limit, token expired) | Toast: "❌ Không gửi được. [Thử lại]" + text preserved in input | Retry button |
| AI generation failed | Copilot service timeout | "🤖 AI không tạo được gợi ý. Nhập thủ công." Manual input highlighted | Manual compose |
| Token expired | 401 from platform | Red dot on platform badge + banner: "🔴 [Platform] ngắt — [Kết nối lại]" | Re-auth flow |
| Thread not found | Deep link to deleted thread | Toast: "Tin nhắn không tìm thấy" + navigate to inbox list | Show inbox list |
| Thread too old | Platform API doesn't allow reply to old comments | Toast: "Không thể trả lời — bài đăng quá cũ" | Inform user |

---
## 18. Accessibility

| Element | Requirement |
|---|---|
| Thread rows | `Semantics(label: "Nguyễn Văn A, TikTok, Sản phẩm này mua ở đâu, 15 phút trước, chưa đọc, ưu tiên cao")` |
| Intent badges | `Semantics(label: "Phân loại: Ý định mua hàng, độ tin cậy 94 phần trăm")` |
| Swipe gestures | Swipe actions ALSO available via long-press context menu for accessibility |
| Reply input | `Semantics(textField: true, hint: "Nhập tin nhắn trả lời")` |
| Unread badge | `Semantics(label: "23 tin nhắn chưa đọc")` |
| Send button | `Semantics(button: true, label: "Gửi tin nhắn")`, minimum 48×48dp |
| Filter chips | `Semantics(selected:)` on active filter |
| Status changes | `Semantics(liveRegion: true)` for new messages arrived |

---
## 19. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | App bar + shimmer thread list |
| Thread list load | 200-500ms | Threads populate with staggered fade-in |
| Thread detail push | 100-300ms | Slide transition → entity info + conversation skeleton |
| AI reply generation | 1-3s | "🤖 Đang soạn..." with animated dots |
| Reply send | 500ms-2s | Send button spinner → your bubble appears with ✓ |
| Pull-to-refresh | <2s | Refresh indicator → new threads slide in from top |

---
## 20. Localization Notes

- Primary language: Vietnamese
- Message preview: Truncated to 60 chars
- Platform names: Keep original (TikTok, Instagram, Shopee)
- Reply char limits: Platform-specific (TikTok 150, IG 2200, Shopee 5000)
- Relative time: "15 phút trước", "2 giờ trước", "Hôm qua"
- Customer value: Vietnamese stars (★★★★☆)
- Tone: Professional yet warm

---
## 21. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | Primary CTA (Send), active filter chip |
| `--color-success` | Purchase intent badge (🟢), sent confirmation |
| `--color-warning` | Complaint intent badge (🟠), follow-up indicator |
| `--color-danger` | Critical priority badge (🔴), send failed |
| `--color-surface-elevated` | Thread cards, AI suggestion card, entity info card |
| `--color-text-primary` | Entity names, message text |
| `--color-text-secondary` | Timestamps, platform labels |
| `--color-unread` | Unread dot (🔵) |

---
## 22. Related Screens

| Screen | Relationship |
|---|---|
| [W046] Web Unified Inbox | Web equivalent (split-pane, keyboard shortcuts) |
| [M020] Mobile Thread Detail | Full thread view (alternative route) |
| [M052] Mobile Task Queue | Task list from inbox follow-ups |
| [M001] Mobile Home Dashboard | Unread KPI + 💬 bottom tab |

---
## 23. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 3.0 | **Structure fix**: Removed duplicate template sections (§5/§6/§11/§12/§13/§16/§18). Added detailed Error Handling (6 scenarios), expanded Accessibility with semantic labels, specific Loading Behavior timeline, comprehensive Design Tokens. Renumbered to 23-section structure. | System |
| 2026-03-28 | 2.0 | **Major revision**: Full Tier A rewrite. Added entity quick info, quick reply bottom sheet, swipe gestures, push notification behavior, offline reply queue, 14 actions, 11 states. | System |
| 2026-03-27 | 1.0 | Initial specification | System |

