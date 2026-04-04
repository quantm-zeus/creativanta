# Screen: Web — Thread Detail

> **Screen ID**: W047
> **Module**: M12 — Unified Inbox & Engagement
> **Route**: `/inbox/[id]`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §20, A1 Schema (threads, messages, intents, suggested_replies)

---

## 1. Purpose & Context

Full-page thread view — an alternative to the split-pane inbox for deep-link access and focused conversations. Shows the complete message history with AI intent classification and suggested replies.

### User Story
> As a creator, I want to view a full conversation thread from a notification or deep link with all context visible.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Inbox    Thread with Nguyễn Văn A    🎵 TikTok                   │
├──────────────────────────────────┬───────────────────────────────────┤
│ Conversation (65%)               │ Context Panel (35%)               │
│                                  │                                    │
│ ┌─ Original Post ────────────┐  │ ┌─ Entity Info ──────────────────┐│
│ │ 📝 "5 tips nấu ăn nhanh"  │  │ │ [Avatar] Nguyễn Văn A          ││
│ │ 24K views · 12% eng        │  │ │ 🎵 TikTok · 12K followers     ││
│ └────────────────────────────┘  │ │ Value: ★★★★☆ · Buyer          ││
│                                  │ │ [👤 Full profile]               ││
│ 💬 Nguyễn Văn A (15m ago):     │ └──────────────────────────────┘ │
│ "Sản phẩm này mua ở đâu?"      │                                    │
│ 🤖 Intent: 🟢 Purchase (94%)   │ ┌─ Thread Actions ───────────────┐│
│                                  │ │ Status: [🟡 Open ▾]            ││
│ 🤖 Suggested Reply:             │ │ Assigned: [Quân ▾]             ││
│ ┌─ Reply Card ───────────────┐  │ │ Priority: [⭐ High ▾]         ││
│ │ "Cảm ơn bạn! 😊            │  │ │ Tags: [purchase] [+ Add]      ││
│ │  Mua tại shopee.vn/...     │  │ │                                ││
│ │  Giảm 20% hôm nay!"       │  │ │ [✅ Resolve]                   ││
│ │ [✅ Gửi] [✏️ Sửa] [🔄]    │  │ │ [📌 Follow-up task]           ││
│ └────────────────────────────┘  │ │ [🔇 Mute]                     ││
│                                  │ └──────────────────────────────┘ │
│ Your reply (if sent):            │                                    │
│ ← "Cảm ơn bạn! Link ở bio"    │ ┌─ Related Threads ──────────────┐│
│    ✅ Sent · 10m ago             │ │ 💬 Same person · 2d ago        ││
│                                  │ │ 💬 Similar intent · 1h ago     ││
│ [Reply input...           ] [→] │ └──────────────────────────────┘ │
└──────────────────────────────────┴───────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
ThreadDetailPage
├── AppShell (shared)
├── PageHeader (BackButton, Entity name, Platform)
├── SplitView
│   ├── ConversationPanel (65%)
│   │   ├── OriginalPostCard (content title, metrics)
│   │   ├── MessageList
│   │   │   └── MessageBubble[] (entity + creator)
│   │   │       ├── SenderInfo
│   │   │       ├── MessageText
│   │   │       ├── Timestamp
│   │   │       └── IntentBadge (on entity messages)
│   │   ├── SuggestedReplyCard
│   │   │   ├── ReplyText
│   │   │   ├── SendButton, EditButton, RegenerateButton
│   │   └── ReplyInput
│   └── ContextPanel (35%)
│       ├── EntityInfoCard
│       ├── ThreadActionsCard (status, assigned, priority, tags)
│       ├── ResolveButton
│       ├── FollowUpButton
│       └── RelatedThreadsCard
```

---

## 4-5. Data & Actions

Same data model as [W49] Unified Inbox but focused on single thread. Actions include resolve, assign, tag, follow-up, reply (manual and AI-assisted).

---

## 6. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Split-view skeleton |
| LOADED | Thread data received | Conversation + context panel |
| NOT_FOUND | Thread deleted/invalid | "Thread không tồn tại. [← Inbox]" |
| RESOLVED | Thread resolved | Green banner: "✅ Đã giải quyết bởi {name}" + read-only |
| REPLYING | Sending reply | Send button spinner |

---

## 7. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| New messages | SSE `/events/inbox/[thread_id]` | Real-time |
| Status changes | SSE | Real-time |
| AI suggested reply | Generated on new message | Auto-update card |

### Real-time UX
- New message: bubble slides in at bottom with subtle pop animation
- AI reply: regenerates automatically when new entity message arrives
- Resolution by other user: banner slides in, reply input disables

---

## 8. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến — tin nhắn mới sẽ không xuất hiện" | Auto-retry online |
| Reply failed | Platform API error | Toast: "Không gửi được. [Thử lại]" + message stays in input | Retry |
| Thread not found | Deleted | Error page: "Thread không tồn tại" | Navigate to inbox |
| AI reply failed | AI service error | Empty card: "🤖 Không tạo được gợi ý. [🔄 Thử lại]" | Regenerate |
| Resolve failed | Server error | Toast: "Không đánh dấu đã giải quyết. [Thử lại]" | Retry |

---

## 9. Accessibility

| Element | Requirement |
|---|---|
| Message bubbles | `role="listitem"`, `aria-label="{sender}: {text}, {time}"` |
| Message list | `role="list"`, `aria-label="Hội thoại với {entity_name}"` |
| Intent badges | `aria-label="AI intent: {type} ({confidence}%)"` |
| Reply input | `aria-label="Nhập tin nhắn trả lời"` |
| Context panel | `role="complementary"`, `aria-label="Thông tin thread"` |
| Status dropdown | `aria-expanded`, `aria-haspopup="listbox"` |

---

## 10. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Split-view skeleton |
| Original post | 200ms | Post card populates |
| Messages | 300-500ms | Bubbles populate with stagger |
| AI reply | 400-600ms | Reply card generates/loads |
| Context panel | 500ms | Entity info + actions load |

---

## 11. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `thread.viewed` | Page load | `thread_id`, `platform`, `message_count`, `intent` |
| `thread.replied` | Send reply | `thread_id`, `reply_type` ('manual'/'ai'/'edited_ai') |
| `thread.resolved` | Resolve clicked | `thread_id`, `time_to_resolve` |
| `thread.assigned` | Assign changed | `thread_id`, `assignee` |
| `thread.followup_created` | Follow-up created | `thread_id` |
| `thread.muted` | Mute clicked | `thread_id` |
| `thread.contact_viewed` | Click "Full profile" | `thread_id`, `entity_id` |

---

## 12. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/inbox/[id]/+page.svelte`
- **Server load**: `+page.server.ts` → fetch thread + messages + entity + AI reply
- **SSE**: `/events/inbox/[thread_id]` for real-time new messages
- **Deep-linkable**: Notifications link here directly with full context
- **Reply**: `ConnectorService/Reply(thread_id, text)` → platform API
- **AI reply**: `AIService/SuggestReply(thread_id)` → pre-generated or on-demand

---

## 13. Localization Notes

- Status: "🟢 Mở", "🟡 Đang xử lý", "✅ Đã giải quyết", "🔇 Đã tắt"
- Intent: "🟢 Mua hàng", "🔵 Khen ngợi", "🟡 Hỏi đáp", "🔴 Khiếu nại"
- Actions: "Gửi", "Sửa reply", "Giao nhiệm vụ", "Đánh dấu giải quyết"
- Reply placeholder: "Nhập tin nhắn..."
- Relative time: "15 phút trước", "2 giờ trước"

---

## 14. Design Tokens

| Token | Usage |
|---|---|
| `--color-thread-open` | Open status (🟢 green) |
| `--color-thread-pending` | Pending status (🟡 amber) |
| `--color-thread-resolved` | Resolved banner (✅ green bg) |
| `--color-thread-muted` | Muted status (gray) |
| `--color-bubble-entity` | Entity message bubbles |
| `--color-bubble-creator` | Creator reply bubbles |
| `--color-accent` | Primary CTAs (Send) |
| `--color-ai-reply` | AI reply card background |

---

## 15. Related Screens

| Screen | Relationship |
|---|---|
| [W046] Unified Inbox | Parent (alternative split-pane view) |
| [W049] Contact Detail | Entity profile |
| [W051] Follow-up Tasks | Task from thread |
| [M020] Mobile Thread Detail | Mobile equivalent |

---

## 16. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: Added 5 states, real-time SSE with UX behaviors, 5 error scenarios, accessibility for conversation, SvelteKit impl (SSE, deep-link), 7 analytics, 5-stage loading, thread-specific localization, 8 design tokens with status/bubble colors. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
