# Screen: Mobile — Thread Detail

> **Screen ID**: M008
> **Module**: M13 — Engagement & CRM
> **Route**: `/inbox/[threadId]` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 01 §4, Product Freeze §21-23, A1 Schema (threads, messages, contacts, engagement_events), B5 RBAC §2.7

---

## 1. Purpose & Context

Single conversation thread on mobile — the full message history with a contact, enriched with AI reply suggestions, contact context bar (VIP status, LTV, purchase intent, sentiment), quick actions, and inline order/product references. Optimized for thumb-zone reply and rapid customer engagement.

### User Goals
- Read full conversation history with chronological context
- Reply quickly using AI suggestions or manual typing
- Understand contact context (VIP, recent orders, sentiment) before replying
- Execute quick actions (send product link, create order, tag contact)

### Business Goals
- Reduce average response time (target: <2 hours for VIP contacts)
- Increase AI suggestion adoption rate (target: 40%+ replies use AI)
- Improve customer satisfaction through contextual, informed replies
- Enable commerce actions directly from conversation (create order from chat)

### When This Screen Is Used
- **Push notification**: "💬 New message from @skincare_queen" → opens thread
- **Inbox browse**: Tap thread row in Inbox (M007) to view full conversation
- **Contact follow-up**: From Contact Detail (M049) → "View conversation"
- **Order inquiry**: Customer asks about order → thread has order context

### Entry Points
- Inbox (M007): Tap thread row
- Push notification: Tap message notification → deep links to thread
- Contact Detail (M049): "💬 Xem hội thoại" action
- Order Detail: "💬 Message buyer" action

### Exit Points
- "← Inbox" → Back to inbox list
- "👤 Profile" → Contact Detail (M049)
- Product/order links in messages → respective detail screens
- "📦 Create order" → Order creation from chat context

---

## 2. Preconditions / Postconditions

### Preconditions
- User has `engagement:read` permission
- Thread exists and user has access (own workspace)
- Platform with valid token for sending replies

### Postconditions
- Thread marked as read (`threads.read_at` updated)
- Reply sent → `messages` record created, platform API called
- AI suggestion used → logged for AI quality tracking
- Contact last_engagement_at updated

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Inbox   @skincare_queen · 🎵 TikTok           [👤] [📱 Call]    │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Contact Context Bar (collapsible) ─────────────────────────────┐ │
│ │ ⭐ VIP · 5 orders · LTV: 1.2M · Last order: 3 ngày trước      │ │
│ │ Intent: [🛒 Purchase] · Sentiment: [😊 Positive]               │ │
│ │ Tags: [repeat-buyer] [skincare] · 📦 Ongoing order: #ORD-1234  │ │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ── Messages ──                                                       │
│ 🧑 @skincare_queen · 2 giờ trước                                   │
│ "Chị ơi, serum HA còn hàng không?"                                  │
│                                                                      │
│          📤 You · 1 giờ trước                                       │
│          "Dạ chào bạn! Serum HA hiện còn hàng ạ."                  │
│          [Sent ✓]                                                    │
│                                                                      │
│ 🧑 @skincare_queen · 30 phút trước                                 │
│ "Giao bao lâu vậy ạ?"                                               │
│                                                                      │
│ ┌─ AI Draft Reply (auto-generated) ───────────────────────────────┐ │
│ │ 🤖 AI gợi ý:                                                    │ │
│ │ "Giao nhanh nội thành 4 giờ, ngoại thành 1-2 ngày ạ.           │ │
│ │  Bạn ở khu vực nào để em kiểm tra nhé?"                         │ │
│ │ Confidence: 92% · Based on: shipping_policy + location data      │ │
│ │ [📤 Gửi] [✏ Sửa trước khi gửi] [🗑 Bỏ qua]                   │ │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Quick Suggestions (horizontal scroll) ─────────────────────────┐ │
│ │ 💡 "Cảm ơn bạn" · 💡 "Giao 1-2 ngày" · 💡 "Link sản phẩm"   │ │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Input Bar ──────────────────────────────────────────────────────┐│
│ │ [📸] [📎] [Nhập tin nhắn...                          ] [📤]     ││
│ └──────────────────────────────────────────────────────────────────┘│
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                          │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
ThreadDetailPage
├── AppBar
│   ├── BackButton ("← Inbox")
│   ├── ContactAvatar (small, 32dp)
│   ├── ContactName ("@skincare_queen")
│   ├── PlatformBadge ("🎵 TikTok")
│   ├── ProfileButton ("👤" → Contact Detail M049)
│   └── CallButton ("📱" → phone dialer, conditional)
├── ContactContextBar (collapsible — tap to expand/collapse)
│   ├── VIPBadge ("⭐ VIP")
│   ├── OrderSummary ("5 orders · LTV: 1.2M")
│   ├── LastOrder ("Last order: 3d ago")
│   ├── IntentBadge ("🛒 Purchase" — AI-detected)
│   ├── SentimentBadge ("😊 Positive" — AI-analyzed)
│   ├── TagChips ([repeat-buyer] [skincare])
│   └── OngoingOrderLink ("📦 #ORD-1234" — tappable)
├── MessageList (ScrollableList, reversed for chat)
│   ├── DateSeparator ("Hôm nay", "Hôm qua")
│   └── MessageBubble[]
│       ├── IncomingMessage (left-aligned)
│       │   ├── SenderAvatar (small)
│       │   ├── SenderName
│       │   ├── MessageText (selectable)
│       │   ├── MediaAttachment (if image/video)
│       │   ├── ProductReference (if product mentioned — linked card)
│       │   └── Timestamp
│       └── OutgoingMessage (right-aligned)
│           ├── MessageText
│           ├── Timestamp
│           └── StatusIndicator (Sending/Sent ✓/Delivered ✓✓/Read ✓✓/Failed ❌)
├── AIDraftReply (conditional — auto-generated, dismissible)
│   ├── AIIcon ("🤖 AI gợi ý:")
│   ├── DraftText (editable)
│   ├── ConfidenceBadge ("92%")
│   ├── SourceNote ("Based on: shipping_policy")
│   ├── SendButton ("📤 Gửi")
│   ├── EditButton ("✏ Sửa trước khi gửi")
│   └── DiscardButton ("🗑 Bỏ qua")
├── QuickSuggestions (horizontal scroll, above input)
│   └── SuggestionChip[] (tappable → fills input)
├── InputBar (pinned to bottom, above keyboard)
│   ├── PhotoButton ("📸" → camera/gallery)
│   ├── AttachButton ("📎" → file/product link)
│   ├── TextInput (auto-expand up to 4 lines)
│   └── SendButton ("📤")
└── BottomNavBar
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Messages | `messages WHERE thread_id={id} ORDER BY created_at ASC` | `ThreadService/GetMessages(threadId, cursor)` | Chat bubbles, paginated (last 50) | 2m |
| Contact info | `contacts` join | Included in thread response | Context bar fields | 5m |
| AI draft | AI auto-reply model | `CopilotService/GenerateReply(threadId, context)` | Draft bubble with edit actions | — |
| Quick suggestions | AI suggestion model | Included in draft response | Horizontal chip list (max 5) | — |
| Platform icon | `threads.platform` | Included | Platform emoji | Static |
| Intent classification | AI analysis of last message | Included in thread | Badge: "🛒 Purchase" / "❓ Question" / "⚠️ Complaint" | 5m |
| Sentiment | AI sentiment analysis | Included in thread | Badge: "😊 Positive" / "😐 Neutral" / "😞 Negative" | 5m |
| Message status | `messages.status` | WebSocket updates | ✓/✓✓/❌ | Real-time |
| Order reference | `orders` join by contact | Included | "📦 #ORD-1234" link | 5m |

---

## 6. Actions Table

| # | Action | Trigger | Type | API Call | System Response | Permission |
|---|---|---|---|---|---|---|
| 1 | Send reply | Tap "📤" with text | Primary | `ThreadService/Reply(threadId, text, platform)` | Message appears as outgoing. Status: "Sending..." → "✓ Sent". Haptic success. | `engagement:reply` |
| 2 | Send AI draft | "📤 Gửi" on AI draft | Primary | `ThreadService/Reply(threadId, ai_draft_text)` | Draft becomes sent message. AI usage logged. | `engagement:reply` |
| 3 | Edit AI draft | "✏ Sửa" on AI draft | Edit | — | Draft text copies to input bar for editing. Draft dismissed. | `engagement:reply` |
| 4 | Discard AI draft | "🗑 Bỏ qua" | Dismiss | `CopilotService/DismissReply(threadId)` | Draft fades out. Not shown again for this thread round. | Any |
| 5 | Use quick suggestion | Tap suggestion chip | Fill | — | Suggestion text fills input bar (editable before sending) | `engagement:reply` |
| 6 | Send photo | "📸" → select/capture → send | Attach | Upload → `ThreadService/Reply(threadId, text, media_url)` | Photo appears in chat. Upload progress shown. | `engagement:reply` |
| 7 | Attach product link | "📎" → product picker | Attach | `ThreadService/Reply(threadId, product_link)` | Product card appears in chat | `engagement:reply` |
| 8 | View contact profile | Tap "👤" | Navigate | — | Push → Contact Detail (M049) | `contact:read` |
| 9 | Call contact | Tap "📱 Call" | External | Launch phone dialer | Opens phone app | `contact:read` |
| 10 | View order | Tap "📦 #ORD-1234" in context bar | Navigate | — | Push → Order Detail | `order:read` |
| 11 | Scroll to older messages | Scroll up past loaded messages | Paginate | `ThreadService/GetMessages(cursor=prev)` | Older messages load above | `engagement:read` |
| 12 | Copy message text | Long press message → "📋 Copy" | Clipboard | Client-side | Toast "Đã sao chép" + haptic light | Any |

---

## 7. Validation Rules

### Reply Input
| Field | Rule | Error |
|---|---|---|
| Message text | Min 1 char, max per platform (TikTok: 2000, IG: 1000) | "Tin nhắn quá dài cho {platform} (tối đa {limit} ký tự)" |
| Photo | Max 10MB, JPG/PNG/WebP | "File quá lớn hoặc định dạng không hỗ trợ" |
| Product link | Valid product_id from workspace | Auto-validated from picker |

---

## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Fetching thread | Message shimmer + context bar shimmer | Wait |
| LOADED | Messages visible, no AI draft | Messages + input bar | Reply manually |
| LOADED_WITH_DRAFT | AI draft available | Messages + AI draft bubble above input | Review/send/edit/discard draft |
| SENDING | Reply in progress | Send button spinner + message "Sending..." | Wait |
| SENT | Reply delivered | Message shows "✓ Sent" | Continue conversation |
| SEND_FAILED | Platform API rejected | Message shows "❌ Gửi thất bại. [Thử lại]" | Retry |
| AI_GENERATING | AI creating draft | "🤖 Đang soạn gợi ý..." typing indicator | Wait or type manually |
| EMPTY_THREAD | Thread exists, no messages | "Nhắn tin đầu tiên cho @{name}" + input bar | Send first message |
| OFFLINE | No network | Cached messages visible. Input disabled. Banner: "📡 Ngoại tuyến" | View cached |
| ERROR | Thread not found | "❌ Không tải được hội thoại. [Thử lại]" | Retry or go back |

---

## 9. Permissions & Role-based Behavior

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View thread | ✅ | ✅ | ✅ | ✅ | ✅ (assigned) | ❌ | ❌ |
| Send reply | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Use AI draft | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| View contact context | ✅ | ✅ | ✅ | ✅ | ✅ (assigned) | ❌ | ❌ |
| Send product link | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Call contact | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| View order reference | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

### Visibility Rules
- **Contributor**: Input bar hidden. Read-only thread view for assigned threads.
- **Editor**: Can reply but cannot call or view full order details.

---

## 10. Mobile-specific UX

### Gestures & Haptics
| Gesture | Target | Haptic | Result |
|---|---|---|---|
| Tap send | SendButton | Success vibration | Send message |
| Long press message | MessageBubble | Heavy | Context menu: Copy, Forward, Delete |
| Long press AI draft | AIDraftReply | Light | Copy draft text |
| Swipe down from context bar | ContactContextBar | — | Collapse context bar |
| Pull up on collapsed bar | ContactContextBar | — | Expand context bar |

### Keyboard Behavior
- Input bar sticks above keyboard
- Auto-scroll to latest message when keyboard opens
- Dismiss keyboard on scroll up
- "📤 Send" key on keyboard (platform-specific)

### Push Notification → Deep Link
- Notification tap → opens this thread at latest message
- Thread marked as read immediately
- If app was killed → cold launch → navigate to thread

### Offline Behavior
- **Available offline**: Cached message history, contact context
- **Not available**: Send reply, AI draft, new messages
- Offline replies queued locally → sent when back online

---

## 11. Edge Cases

| Edge Case | Handling |
|---|---|
| 500+ messages in thread | Paginated: show last 50, "⬆ Tải tin nhắn cũ" at top |
| AI draft confidence < 50% | Show with "⚠️ Độ chính xác thấp — nên kiểm tra trước khi gửi" warning |
| Platform token expired | Banner: "🔴 {Platform} ngắt kết nối. Không thể gửi tin nhắn. [Kết nối lại →]" |
| Contact deleted/blocked | Banner: "⚠️ Contact đã bị xóa/chặn trên {platform}" + input disabled |
| Very long incoming message | Message bubble with "Xem thêm" collapse at 500 chars |
| Multiple media in one message | Horizontal scroll gallery in message bubble |
| Reply fails after 3 retries | Show "❌ Gửi thất bại sau 3 lần thử. Kiểm tra kết nối hoặc liên hệ hỗ trợ." |

---

## 12. Real-time Updates

| Data | Channel | Frequency |
|---|---|---|
| New incoming messages | WebSocket `ws://threads/{id}/messages` | Real-time |
| Message delivery status | WebSocket | Real-time (sent → delivered → read) |
| AI draft generation | SSE stream | Real-time (streaming text) |
| Contact context changes | SSE | When contact data updates |

### Real-time UX
- **New message**: Bubble slides in from bottom. Haptic light. Sound if app foregrounded.
- **Read receipt**: Double check appears on sent message.
- **AI draft**: Text streams word-by-word in draft bubble.

---

## 13. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `thread.viewed` | Thread opened | `thread_id`, `platform`, `contact_id`, `is_vip`, `source` |
| `thread.replied` | Reply sent | `thread_id`, `reply_type` (manual/ai_full/ai_edited), `char_count` |
| `thread.ai_draft_sent` | AI draft sent as-is | `thread_id`, `confidence`, `response_time` |
| `thread.ai_draft_edited` | AI draft edited then sent | `thread_id`, `edit_percentage` |
| `thread.ai_draft_discarded` | AI draft dismissed | `thread_id`, `reason` |
| `thread.suggestion_used` | Quick suggestion tapped | `thread_id`, `suggestion_index` |
| `thread.contact_viewed` | "👤" profile tapped | `thread_id`, `contact_id` |
| `thread.media_sent` | Photo/product sent | `thread_id`, `media_type` |
| `thread.send_failed` | Reply failed | `thread_id`, `error_type` |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| Thread load to interactive | <1s |
| Message send → status "Sent" | <3s |
| AI draft generation | <5s first token, <10s complete |
| AI suggestions load | <2s |
| Scroll performance | 60fps |
| Photo upload | <3s for 5MB |

---

## 15. Flutter Implementation Notes

### Widget Structure
- **Route**: `/inbox/:threadId` → `ThreadDetailPage extends ConsumerStatefulWidget`
- **State**: Riverpod `threadMessagesProvider(threadId)` + `aiDraftProvider(threadId)`
- **Message list**: `ListView.builder(reverse: true)` for bottom-anchored chat
- **WebSocket**: `web_socket_channel` for real-time messages
- **AI streaming**: SSE via `eventsource` package

### Data Fetching
```
onInit:
  threadService.getThread(threadId)         // thread + contact context
  threadService.getMessages(threadId, last: 50)  // paginated messages
  copilotService.generateReply(threadId)    // AI draft (background)
  
  wsConnect('threads/$threadId/messages', onMessage: addMessage)

onReply(text):
  // Optimistic add
  addLocalMessage(text, status: 'sending')
  threadService.reply(threadId, text)
    .then(() => updateStatus('sent'))
    .onError(() => updateStatus('failed'))
```

---

## 16. Navigation Map

```
Thread Detail (/inbox/[threadId])
├── ← /inbox (back button → M007 Inbox)
├── → /contacts/[contactId] (tap 👤 → M049 Contact Detail)
├── → /orders/[orderId] (tap 📦 order link → Order Detail)
├── → /products/[productId] (tap product reference in message)
├── → tel:[phone] (tap 📱 Call → phone dialer)
└── → /settings/platforms (tap "Kết nối lại" if token expired)
```

---

## 17. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached messages. Input disabled. | Auto-retry on reconnect |
| Reply failed | Platform API error | Message: "❌ Gửi thất bại. [Thử lại]" on message bubble | Tap "Thử lại" |
| Token expired | Platform OAuth invalid | Banner: "🔴 {Platform} ngắt. Không thể gửi. [Kết nối lại →]" | Re-auth flow |
| AI draft failed | Copilot timeout | "🤖 Không tạo được gợi ý. [Thử lại]" or skip | Retry or type manually |
| Thread not found | Deleted or no access | "❌ Hội thoại không tồn tại." → navigate back | Go back |
| Media upload failed | File too large or format | Toast: "Upload thất bại. [Thử lại]" | Retry |

---

## 18. Accessibility

| Element | Requirement |
|---|---|
| Incoming messages | `Semantics(label: "@skincare_queen nói: Chị ơi serum HA còn hàng không, 2 giờ trước")` |
| Outgoing messages | `Semantics(label: "Bạn đã gửi: Dạ chào bạn, 1 giờ trước, đã gửi")` |
| AI draft | `Semantics(label: "AI gợi ý: {text}, độ chính xác 92 phần trăm")` |
| Send button | `Semantics(button: true, label: "Gửi tin nhắn")`, min 48×48dp |
| Contact context bar | `Semantics(label: "Khách VIP, 5 đơn hàng, giá trị 1.2 triệu")` |
| Quick suggestions | `Semantics(button: true, label: "Gợi ý: Cảm ơn bạn")` |

---

## 19. Localization Notes

- Primary language: Vietnamese
- Message timestamps: Relative ("2 giờ trước", "30 phút trước")
- AI labels: "🤖 AI gợi ý:", "Độ chính xác: 92%"
- Status indicators: "Đang gửi...", "Đã gửi ✓", "Đã nhận ✓✓", "Đã xem ✓✓", "Gửi thất bại ❌"
- Context bar: Vietnamese ("đơn hàng", "ngày trước")
- LTV: "1.2M VND" format
- Tone: Natural conversational Vietnamese

---

## 20. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-incoming-bubble` | Incoming message background (light grey/surface-container) |
| `--color-outgoing-bubble` | Outgoing message background (primary-light) |
| `--color-ai-draft` | AI draft background (soft blue/info-light) |
| `--color-accent` | Send button, AI suggestion chips |
| `--color-success` | Sent status (✓✓), positive sentiment |
| `--color-danger` | Failed status (❌), negative sentiment |
| `--color-vip` | VIP badge (gold/amber) |
| `--color-text-primary` | Message text |
| `--color-text-secondary` | Timestamps, context bar text |

---

## 21. Related Screens

| Screen | Relationship |
|---|---|
| [W051] Web Thread Detail | Web equivalent (side panel in inbox) |
| [M007] Mobile Inbox | Parent (thread list) |
| [M049] Mobile Contact Detail | Contact context (via 👤 tap) |
| [M008] Mobile Thread Detail | Self |

---

## 22. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 2.0 | **Full Tier A rewrite** from 244-line Tier C. Added complete 22-section structure: expanded wireframe with AI draft reply bubble and quick suggestions, full component hierarchy (40+ widgets), specific data binding (9 fields with AI intent/sentiment), 12 user actions, reply validation, 10 states, full RBAC matrix, mobile UX with gestures/keyboard/push deep-link/offline, 7 edge cases, real-time WebSocket/SSE, 9 tracking events, performance targets, Flutter implementation, error handling (6 scenarios), accessibility with message semantics, localization, design tokens with chat-specific colors. Replaced ALL template placeholders. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
