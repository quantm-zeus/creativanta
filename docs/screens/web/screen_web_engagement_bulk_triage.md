# Screen: Web — Bulk Triage

> **Screen ID**: W54
> **Module**: M09 — Engagement
> **Route**: `/inbox/triage`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §20, A1 Schema (threads, messages, intents)

---

## 1. Purpose & Context

Bulk Triage is a rapid processing mode for clearing inbox backlog. Threads are presented one-at-a-time (Tinder-like card swipe UX), with pre-generated AI replies. Users can quickly approve replies, modify, assign, or skip.

### User Story
> As a creator with 50+ unread messages, I want a fast triage mode where I can process each message in 5-10 seconds.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ⚡ Triage Mode          Progress: 12/47 processed    [✕ Exit]      │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Thread Card (center, 700px max) ─────────────────────────────┐  │
│ │                                                                  │  │
│ │ 🎵 TikTok · Comment on "5 tips nấu ăn"                        │  │
│ │ [😊] Nguyễn Văn A · 12K followers · ★★★★☆                    │  │
│ │                                                                  │  │
│ │ 💬 "Sản phẩm này mua ở đâu vậy ạ?"                            │  │
│ │ 🤖 Intent: 🟢 Purchase inquiry (94%)                           │  │
│ │                                                                  │  │
│ │ ┌─ AI Suggested Reply ──────────────────────────────────────┐  │  │
│ │ │ "Cảm ơn bạn! 😊 Mua tại shopee.vn/creativanta/serum      │  │  │
│ │ │  Đang giảm 20% hôm nay! 🎉"                              │  │  │
│ │ └──────────────────────────────────────────────────────────┘  │  │
│ │                                                                  │  │
│ │ ← Swipe left: Skip       Swipe right: Send reply →             │  │
│ │                                                                  │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Quick Actions (bottom) ───────────────────────────────────────┐  │
│ │ [⏭ Skip] [✏️ Edit reply] [✅ Send AI reply] [👤 Assign]      │  │
│ │                    [📌 Follow-up] [🔇 Mute]                    │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ████████████████████████████░░░░░░░░░░░░░░░░ 25%                    │
│ Speed: ~8s/thread · Est. remaining: ~4 min                           │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
BulkTriagePage
├── AppShell (shared)
├── TriageHeader
│   ├── Title
│   ├── ProgressCounter ("12/47")
│   └── ExitButton
├── CardStack (swipeable center)
│   └── TriageCard (current thread)
│       ├── PlatformBadge + PostContext
│       ├── EntityInfo (avatar, name, followers, value)
│       ├── MessageText
│       ├── IntentBadge
│       ├── AIReplyCard
│       │   ├── ReplyText
│       │   └── SwipeHint
│       └── SwipeOverlay (Skip ← | → Send)
├── QuickActionsBar
│   ├── SkipButton
│   ├── EditReplyButton (opens inline editor)
│   ├── SendButton
│   ├── AssignButton
│   ├── FollowUpButton
│   └── MuteButton
├── ProgressBar
└── SpeedIndicator (avg seconds per thread)
```

---

## 4-5. Data & Actions

| # | Action | Trigger | API | Result |
|---|---|---|---|---|
| 1 | Send AI reply | Swipe right or "✅ Send" | `ConnectorService/Reply` | Card exits right, next card |
| 2 | Skip | Swipe left or "⏭ Skip" | `ThreadService/MarkRead` | Card exits left, next card |
| 3 | Edit & send | "✏️ Edit" → edit → send | Edit then reply API | Card exits, next card |
| 4 | Assign | "👤 Assign" → picker → confirm | `ThreadService/Assign` | Assigned, next card |
| 5 | Follow-up | "📌 Follow-up" | `FollowUpTaskService/Create` | Task created, next card |
| 6 | Mute | "🔇 Mute" | `ThreadService/Mute` | Muted, next card |
| 7 | Exit | "✕ Exit" | — | → `/inbox` | 

---

## 6. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching batch | Card skeleton + progress bar |
| TRIAGING | Active triage | Card stack with swipe gestures |
| COMPLETE | All threads processed | "🎉 Tất cả đã xử lý! Sent: {n}, Skipped: {n}, Assigned: {n}. [← Inbox]" + stats |
| REPLY_SENDING | Sending reply | Card shows spinner overlay |
| ERROR | Reply failed | "Không gửi được. [Thử lại]" → card stays |

---

## 7. Edge Cases

| Edge Case | Handling |
|---|---|
| 0 unread threads | Redirect to inbox: "Không có tin nhắn cần xử lý 🎉" |
| AI reply confidence < 50% | Warning badge: "⚠️ AI không chắc chắn" + "Edit" highlighted |
| Thread has multiple messages | Show latest + "2 messages trước" expandable |
| Platform rate-limited | Toast: "Bị giới hạn bởi {platform}. Chờ {n} giây" + auto-wait |
| Reply character limit exceeded | AI auto-trims; warning if user edit exceeds |

---

## 8. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến — tạm dừng triage" | Resume online |
| Reply failed | Platform API error | Card stays: "Không gửi được. [Thử lại] [Bỏ qua]" | Retry or skip |
| AI reply unavailable | AI service down | Empty reply card: "🤖 Không có gợi ý. [Viết tay]" | Manual compose |
| Rate limit | Platform throttle | Auto-pause: "⏳ Chờ {n}s..." + countdown | Auto-resume |
| Assign failed | Server error | Toast: "Không giao nhiệm vụ được. [Thử lại]" | Retry |

---

## 9. Accessibility

| Element | Requirement |
|---|---|
| Card stack | `role="region"`, `aria-label="Thread {n} trên {total}"` |
| Swipe actions | Keyboard: Left=skip, Right=send, E=edit, A=assign |
| Progress bar | `role="progressbar"`, `aria-valuenow={processed}`, `aria-valuemax={total}` |
| Intent badge | `aria-label="AI intent: {type} ({confidence}%)"` |
| Quick action buttons | Descriptive `aria-label`: "Gửi AI reply", "Bỏ qua", etc. |
| Speed indicator | `aria-label="Tốc độ: {n}s/thread, còn {m} phút"` |

---

## 10. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Progress bar + card skeleton |
| First batch (3 threads) | 300-500ms | First card slides in |
| AI replies | 200-400ms per card | Reply text populates |
| Pre-fetch next | Background | Next 3 cards loaded silently |
| Card transition | 300ms | Swipe exit + next card slide-in |

---

## 11. Performance Requirements

| Metric | Target |
|---|---|
| First card visible | < 1s |
| Card transition | < 300ms (60fps swipe) |
| Reply send | < 2s |
| Pre-fetch | Background, < 500ms each |
| Target processing speed | < 10s/thread |

---

## 12. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `triage.started` | Enter triage mode | `total_threads` |
| `triage.reply_sent` | Send AI reply | `thread_id`, `intent`, `confidence`, `time_spent` |
| `triage.reply_edited` | Edit + send | `thread_id`, `edit_length_delta` |
| `triage.skipped` | Skip thread | `thread_id`, `time_spent` |
| `triage.assigned` | Assign thread | `thread_id`, `assignee` |
| `triage.followup_created` | Create follow-up | `thread_id` |
| `triage.muted` | Mute thread | `thread_id` |
| `triage.completed` | All processed | `total_processed`, `sent`, `skipped`, `avg_time` |

---

## 13. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/inbox/triage/+page.svelte`
- **Server load**: `+page.server.ts` → fetch first 3 threads with AI replies
- **Swipe**: CSS transforms + pointer events (touch + mouse)
- **Pre-fetch**: After current card action, load next 3 in background
- **Keyboard**: Global event listeners: ArrowLeft, ArrowRight, E, A, F, M
- **AI replies**: Pre-generated in batch via `AIService/BatchSuggestReplies`
- **Exit**: Ctrl+Escape or "✕ Exit" → navigate to `/inbox`

---

## 14. Localization Notes

- Progress: "12/47 đã xử lý"
- Speed: "~8 giây/thread · Còn ~4 phút"
- Intent: "🟢 Mua hàng (94%)", "🔵 Khen ngợi (87%)", "🟡 Hỏi đáp (72%)"
- Actions: "Gửi", "Bỏ qua", "Sửa reply", "Giao nhiệm vụ", "Theo dõi", "Tắt tiếng"
- Completion: "🎉 Tất cả đã xử lý!"

---

## 15. Design Tokens

| Token | Usage |
|---|---|
| `--color-swipe-send` | Swipe right overlay (🟢 green) |
| `--color-swipe-skip` | Swipe left overlay (🔴 red) |
| `--color-triage-card` | Card background (elevated white) |
| `--color-triage-progress` | Progress bar fill (accent) |
| `--color-intent-purchase` | 🟢 Purchase intent |
| `--color-intent-praise` | 🔵 Praise intent |
| `--color-intent-question` | 🟡 Question intent |
| `--color-accent` | Primary CTAs |
| `--color-ai-reply` | AI reply card background |

---

## 16. Related Screens

| Screen | Relationship |
|---|---|
| [W049] Unified Inbox | Parent — triage mode access |
| [W050] Thread Detail | Full thread view |
| [W053] Follow-up Tasks | Tasks from triage |
| [M007] Mobile Inbox | Mobile triage (limited) |

---

## 17. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: Added 5 states, 5 edge cases (rate limit, AI confidence), 5 error scenarios, swipe accessibility with keyboard shortcuts, SvelteKit impl (pre-fetch, batch AI replies, keyboard), 8 analytics, 5 perf KPIs, triage-specific localization, 9 design tokens with swipe colors. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
