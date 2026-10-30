# Screen: Mobile — Copilot Chat

> **Screen ID**: M060
> **Module**: copilot — see canonical feature owner in screen_task_map.csv
> **Route**: `/copilot` (mobile app)
> **Platform**: Mobile (Flutter)
> **Upstream**: Product Freeze §34 (Copilot Tiers), A1 Schema (copilot_sessions §19.12 — messages as JSONB), B5 RBAC §2.14

---
## 1. Purpose & Context

The Mobile Copilot is a context-aware AI assistant accessible from any screen via a floating action button. It answers questions about the user's workspace data (analytics, trends, orders, content performance), generates content ideas and scripts, executes quick actions (create idea, check orders, schedule publish), and provides contextual guidance based on the screen the user was on when they opened it.

### User Goals
- Get instant answers about their workspace metrics and performance
- Generate content ideas and scripts via conversational AI
- Execute quick actions without navigating to the full module screen
- Learn how to use Creativanta features through conversational help

### Business Goals
- Reduce time-to-action by enabling in-context AI assistance
- Increase feature discovery through AI-guided suggestions
- Drive AI credit consumption (monetizable)
- Differentiate from competitors through deep workspace-aware AI

### When This Screen Is Used
- When user needs quick answers: "How many orders today?", "What's trending?"
- When user wants AI-generated content ideas or scripts
- When user is stuck and needs help with a feature
- When user wants to execute actions hands-free (e.g., while commuting)

### Entry Points
- Floating "🤖" button (visible on all screens except splash/auth)
- Bottom nav: "🤖" (if in bottom nav configuration)
- Push notification: "AI insight ready" → opens copilot with context
- Home Dashboard: Quick Action "🤖 Hỏi AI Copilot"

### Exit Points
- Close/dismiss → returns to previous screen
- CTA links in AI responses → navigate to respective module screen
- "📝 Tạo script →" → Script Editor with AI-generated content
- "💡 Xem ý tưởng →" → Idea Board filtered by AI suggestion

---
## 2. Preconditions / Postconditions

### Preconditions
- User is authenticated and has active workspace
- User has `copilot:use_help` permission (minimum) — all roles except External
- AI credit balance > 0 for generative queries (analytics queries are free)

### Postconditions
- Copilot session logged in `copilot_sessions` table
- Each message pair (user + AI) logged in `copilot_sessions.messages` JSONB array
- AI credit consumed per generative response (creative/analytics/action tiers per §34)
- Any action executed via copilot is audited same as manual action

---
## 3. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ 🤖 Copilot                      [Context: Home]  [🗑 Clear] [✕]   │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ System Message ──────────────────────────────────────────────┐   │
│ │ 🤖 Chào Quân! Tôi có thể giúp bạn:                          │   │
│ │ · Tìm xu hướng phù hợp                                       │   │
│ │ · Tạo ý tưởng/script nội dung                                │   │
│ │ · Phân tích hiệu suất kênh                                   │   │
│ │ · Kiểm tra đơn hàng & doanh thu                              │   │
│ │ · Giải thích bất kỳ tính năng nào                            │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Quick Action Chips (horizontal scroll) ───────────────────────┐  │
│ │ [💡 Ý tưởng] [📝 Script] [📊 Analytics] [🛍 Đơn hàng]      │  │
│ │ [🔥 Xu hướng] [❓ Hướng dẫn]                                 │  │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ── Conversation ──                                                   │
│                                                                      │
│ 🧑 Cho tôi 3 ý tưởng video skincare cho TikTok                    │
│     14:32                                                            │
│                                                                      │
│ ┌─ AI Response (streaming) ─────────────────────────────────────┐   │
│ │ 🤖 Dựa trên xu hướng đang hot và profile kênh của bạn:      │   │
│ │                                                                │   │
│ │ 1. 💡 "Morning routine 3 bước cho da dầu"                    │   │
│ │    🎵 TikTok · 45-60s · ER dự kiến: 7.2%                    │   │
│ │    Lý do: "morning routine" +340% views tuần này              │   │
│ │    [📝 Tạo script →] [💾 Lưu ý tưởng]                       │   │
│ │                                                                │   │
│ │ 2. 💡 "So sánh 3 serum HA dưới 200K"                         │   │
│ │    🎵 TikTok · 60-90s · ER dự kiến: 5.5%                    │   │
│ │    Lý do: "budget skincare" trending cao                      │   │
│ │    [📝 Tạo script →] [💾 Lưu ý tưởng]                       │   │
│ │                                                                │   │
│ │ 3. 💡 "Q&A: 5 myths skincare phổ biến"                       │   │
│ │    🎵 TikTok · 30-45s · ER dự kiến: 6.2%                    │   │
│ │    Lý do: Q&A format có save rate cao                         │   │
│ │    [📝 Tạo script →] [💾 Lưu ý tưởng]                       │   │
│ │                                                                │   │
│ │ 💰 Chi phí: 2 credits · Còn lại: 10/100                      │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ 14:32                                                                │
│                                                                      │
│ ┌─ Input Bar ──────────────────────────────────────────────────────┐ │
│ │ [📸] [🎤] [Nhập tin nhắn...                            ] [📤] │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                           │
└──────────────────────────────────────────────────────────────────────┘
```

### Presentation Mode
- **Full screen overlay**: Copilot opens as a full-screen page (not bottom sheet) on mobile
- **Safe area**: Respects notch + home indicator
- **Background blur**: Previous screen visible behind with blur overlay (glassmorphism)

---
## 4. Component Hierarchy

```
MobileCopilotPage
├── AppBar
│   ├── CopilotIcon ("🤖")
│   ├── Title ("Copilot")
│   ├── ContextBadge (shows which screen user came from)
│   ├── ClearChatButton ("🗑")
│   └── CloseButton ("✕")
├── ChatBody (ScrollableList, reversed for chat-style)
│   ├── SystemWelcomeMessage
│   │   ├── GreetingText (time-based + user name)
│   │   └── CapabilityList (bulleted)
│   ├── QuickActionChips (horizontal scroll, disappears after first message)
│   │   └── ActionChip[] (icon + label)
│   └── MessageList[]
│       ├── UserMessage
│       │   ├── MessageText
│       │   ├── AttachedImage (if photo input)
│       │   └── Timestamp
│       └── AIResponse
│           ├── ResponseContent (Markdown-rendered)
│           │   ├── TextBlock
│           │   ├── IdeaSuggestionCard[] (if content generation)
│           │   │   ├── IdeaTitle
│           │   │   ├── PlatformBadge
│           │   │   ├── DurationEstimate
│           │   │   ├── ERPrediction
│           │   │   ├── ReasoningNote
│           │   │   └── ActionButtons (Tạo script, Lưu ý tưởng)
│           │   ├── AnalyticsCard (if analytics query)
│           │   │   ├── MetricGrid
│           │   │   ├── MiniChart
│           │   │   └── InsightText
│           │   └── ActionConfirmation (if action executed)
│           │       ├── ActionDescription
│           │       ├── ResultStatus
│           │       └── UndoButton (if applicable)
│           ├── CreditCostBadge ("2 credits · Còn lại: 10/100")
│           ├── StreamingIndicator (typing dots while generating)
│           ├── Timestamp
│           └── FeedbackButtons (👍 👎, appears after completion)
├── InputBar (pinned to bottom, above keyboard)
│   ├── PhotoButton ("📸" → camera/gallery picker)
│   ├── VoiceButton ("🎤" → speech-to-text)
│   ├── TextInput (multiline, auto-expand up to 4 lines)
│   └── SendButton ("📤", disabled when empty or THINKING)
└── CreditWarningBanner (conditional — shows when credits < 5)
    ├── WarningText ("⚠️ Còn 3 credits. Nạp thêm?")
    └── TopUpButton ("Nạp thêm →")
```

---
## 5. Displayed Data

| Element | Source | API | Display Format | Cache |
|---|---|---|---|---|
| User name | `users.display_name` | Pre-loaded (session) | First name | Session |
| Context screen | Navigation state | Client-side | Badge label | — |
| Chat history | `copilot_sessions.messages` (JSONB) | `CopilotService/GetHistory` | Paginated messages (last 50) | 5m |
| AI credits | `ai_credit_transactions` balance projection | `CreditService/GetBalance` | "10/100" | Real-time |
| Credit cost per response | AI response metadata | Included in response | "2 credits" | — |
| Trend data (in responses) | `trends` | AI context injection | Formatted inline | — |
| Order data (in responses) | `orders` aggregation | AI context injection | Formatted inline | — |
| Analytics data (in responses) | `ClickHouse` | AI context injection | Formatted inline | — |

---
## 6. User Actions

| # | Action | Trigger | Type | API Call | System Response | Navigation | Permission |
|---|---|---|---|---|---|---|---|
| 1 | Send text message | Tap "📤" or keyboard submit | Primary | `CopilotService/SendMessage(session_id, text, context)` | Streaming AI response appears | — | `copilot:use_help` |
| 2 | Send photo | "📸" → select/capture → send | Primary | `CopilotService/SendMessage(session_id, text, image_url)` | AI analyzes image + responds | — | `copilot:use_creative` |
| 3 | Voice input | "🎤" → speak → auto-transcribe | Primary | Speech-to-text (on-device) → send as text | Transcribed text appears in input, user confirms | — | `copilot:use_help` |
| 4 | Tap quick action chip | Tap chip (e.g., "💡 Ý tưởng") | Quick | Sends predefined prompt | AI responds with relevant suggestions | — | Varies by chip |
| 5 | Create script from suggestion | "📝 Tạo script →" in AI response | CTA | `ScriptService/Create(from_idea)` | Toast "Script đã tạo" | → Script Editor | `script:create` |
| 6 | Save idea from suggestion | "💾 Lưu ý tưởng" in AI response | CTA | `IdeaService/Create(from_copilot)` | Toast "Ý tưởng đã lưu" | — | `idea:create` |
| 7 | Clear chat | "🗑 Clear" | Destructive | `CopilotService/ClearSession(session_id)` | Confirmation dialog → chat cleared, new session | — | Any |
| 8 | Provide feedback | "👍" or "👎" on AI response | Feedback | `CopilotService/Feedback(message_id, rating)` | Button highlights, "Cảm ơn!" toast | — | Any |
| 9 | Top up credits | "Nạp thêm →" in warning banner | Navigation | — | — | → Mobile Billing (M061) | `credits:top_up` |
| 10 | Close copilot | "✕" or back gesture | Navigation | — | Return to previous screen | ← Previous | Any |

---
## 7. Validation Rules

### Text Input
| Field | Rule | Error |
|---|---|---|
| Message text | Min 1 char, max 2000 chars | "Tin nhắn quá dài (tối đa 2000 ký tự)" |
| Photo | Max 10MB, JPG/PNG/WebP | "File quá lớn hoặc định dạng không hỗ trợ" |
| Voice | Max 60 seconds recording | Auto-stop at 60s with "Đã ghi tối đa 60 giây" |

### Credit Validation
| Condition | Behavior |
|---|---|
| Credits = 0 | Show "Đã hết credits. [Nạp thêm]" — input disabled for generative queries, help queries still work |
| Credits < 5 | Show warning banner at bottom |
| Query type exceeds allowed tier | "Tính năng này yêu cầu quyền `copilot:use_analytics`. Liên hệ admin." |

---
## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| IDLE | Ready for input, no conversation | Welcome message + quick action chips visible | Type or tap chip |
| CONVERSATION | Active chat, waiting for user | Chat messages visible, input enabled | Continue conversation |
| THINKING | AI processing user message | Typing indicator with animated dots below last user message. Input disabled. | Wait (cancel button appears after 5s) |
| STREAMING | AI response being streamed | Text appears word-by-word with cursor. Input disabled. | Watch response stream in |
| ERROR_MESSAGE | Single AI response failed | "❌ Không thể xử lý yêu cầu. [Thử lại]" inline | Tap "Thử lại" |
| ERROR_NETWORK | Network disconnected | Banner: "📡 Mất kết nối. Kiểm tra mạng." | Reconnect → auto-retry |
| NO_CREDITS | Credit balance = 0 | Banner: "💳 Đã hết AI credits. Chỉ có thể hỏi trợ giúp. [Nạp thêm]" | Top up or ask help-only questions |
| RATE_LIMITED | Too many requests | "⏳ Vui lòng chờ 30 giây trước khi gửi tiếp." | Wait 30s |

---
## 9. Permissions & Role-based Behavior

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| Open copilot | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Help queries (features, how-to) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Creative queries (ideas, scripts) | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Analytics queries (metrics, insights) | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Action queries (create, schedule) | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Video production queries | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| View credit balance | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Top up credits | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Voice input | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Photo input | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |

### Visibility Rules
- **Viewer**: Quick action chips for "Ý tưởng" and "Script" are hidden. Only "📊 Analytics" (view-only) and "❓ Hướng dẫn" visible.
- **Contributor**: Analytics chip hidden. Creative + Help chips visible.
- **Editor+**: All chips visible.
- If user tries query outside their permission, AI responds: "Bạn cần quyền `{permission}` để thực hiện thao tác này. Liên hệ Admin workspace."

---
## 10. Navigation Map

```
Mobile Copilot (/copilot)
├── ← Back to previous screen (close overlay)
├── → /scripts/new (via "Tạo script" CTA)
├── → /ideas (via "Lưu ý tưởng" CTA)
├── → /intelligence/trends/[id] (via trend link in AI response)
├── → /orders (via order info CTA in AI response)
├── → /analytics (via analytics CTA in AI response)
├── → /settings/billing (via "Nạp thêm" credit warning)
└── → Any screen referenced in AI response CTAs
```

---
## 11. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| AI streaming response | WebSocket (streaming tokens) | Real-time |
| Credit balance | SSE `/events/credits` | Real-time (updates after each response) |
| Session state | Client-side | Immediate |

---
## 12. Edge Cases

| Edge Case | Handling |
|---|---|
| User sends while AI is still streaming | Queue message, send after stream completes |
| Very long AI response (>500 words) | Response rendered progressively, "Xem thêm" collapse for responses >300 words |
| User opens copilot from multiple contexts rapidly | Use latest context, abandon previous if no messages sent |
| Network loss mid-stream | Show partial response + "📡 Mất kết nối. Phản hồi không đầy đủ. [Thử lại]" |
| Session has >100 messages | Paginate: load last 50, "⬆ Tải tin nhắn cũ" button at top |
| AI returns no actionable response | Show "Tôi chưa hiểu rõ. Bạn có thể diễn đạt lại không?" + suggest rephrasing |
| Photo too large | Client-side resize to max 1024px before upload |
| Credits expire during conversation | Show inline notice: "💳 Credits đã hết sau câu trả lời này. [Nạp thêm]" |
| Copilot response references deleted item | Show "⚠️ Mục này đã bị xóa" with strikethrough link |

---
## 13. Accessibility

| Element | Requirement |
|---|---|
| Chat messages | `semantics: label` for each message (role + content summary) |
| Streaming text | Announce "AI đang trả lời..." when streaming starts |
| Input field | `semantics: textField, hint: "Nhập tin nhắn cho AI"` |
| Action buttons in responses | Each has clear `semantics: button, label` |
| Quick action chips | `semantics: button` with descriptive labels |
| Credit warning | `semantics: liveRegion` to announce when it appears |
| Close button | `semantics: button, label: "Đóng Copilot"` |
| Voice input | Visual waveform indicator + "Đang nghe..." text for non-haptic indication |

---
## 14. Mobile-specific UX

### Gestures & Haptics
- **Swipe down from top**: Close copilot (returns to previous screen)
- **Long press on AI response**: Copy text to clipboard (haptic light)
- **Haptic feedback**: Light on send, medium on action CTA tap, success pattern on "Script đã tạo"

### Keyboard Behavior
- Input bar sticks above keyboard when keyboard opens
- Auto-scroll chat to bottom when keyboard appears
- Dismiss keyboard on scroll up

### Platform Conventions
- **iOS**: Large title "Copilot" in app bar, swipe-from-edge to close
- **Android**: Material 3 styling, back button closes

### Dark Mode
- Full dark mode support
- AI response cards: `surface-container` background in dark
- Streaming cursor: `primary` color in both modes

### Offline Behavior
- Show banner: "📡 Ngoại tuyến — Copilot cần kết nối internet"
- Previous chat history still visible (cached)
- Input disabled until reconnection

---
## 15. Performance Requirements

| Metric | Target |
|---|---|
| Open to interactive | < 500ms (overlay opens immediately) |
| First token latency | < 2s (from send to first AI token) |
| Streaming throughput | ≥ 20 tokens/second displayed |
| Scroll performance | 60fps minimum |
| Memory footprint | < 30MB for copilot screen |
| Photo upload | < 3s for 5MB image |
| Voice transcription | < 1.5s for 10s recording |

---
## 16. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `copilot.opened` | Copilot screen opens | `source_screen`, `workspace_id`, `role` |
| `copilot.message_sent` | User sends message | `message_type` (text/photo/voice), `char_count`, `has_attachment` |
| `copilot.response_received` | AI response completes | `response_type` (creative/analytics/help/action), `token_count`, `credits_used`, `latency_ms` |
| `copilot.quick_action_tapped` | Quick action chip tap | `action_type` |
| `copilot.cta_clicked` | CTA in AI response clicked | `cta_type` (create_script/save_idea/view_trend/etc), `response_id` |
| `copilot.feedback` | 👍/👎 tapped | `rating`, `message_id` |
| `copilot.cleared` | Chat cleared | `message_count` (how many messages were in session) |
| `copilot.closed` | Copilot closed | `session_duration`, `messages_sent`, `credits_used_total` |
| `copilot.credit_warning_shown` | Credit warning banner appears | `remaining_credits` |
| `copilot.error` | Any error state | `error_type`, `error_message` |

---
## 17. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-surface-primary` | Chat background |
| `--color-surface-container` | AI response card background |
| `--color-surface-elevated` | User message bubble |
| `--color-primary` | Send button, streaming cursor, CTA buttons |
| `--color-on-primary` | Send icon color |
| `--color-text-primary` | Message text |
| `--color-text-secondary` | Timestamps, credit cost text |
| `--color-warning` | Credit warning banner |
| `--color-error` | Error messages |
| `--spacing-message-gap` | Gap between messages (12px) |
| `--spacing-card-padding` | AI response card padding (16px) |
| `--radius-message` | Message bubble radius (16px) |
| `--radius-chip` | Quick action chip radius (20px) |
| `--font-message` | Message text (14sp, regular) |
| `--font-timestamp` | Timestamp text (11sp, regular, secondary color) |

---
## 18. Flutter Implementation Notes

### Widget Structure
- **Route**: Full-screen modal route (not page route) — preserves back stack
- **State management**: Riverpod `copilotSessionProvider` + `copilotMessagesProvider`
- **Chat scroll**: `ListView.builder(reverse: true)` for bottom-anchored chat
- **Streaming**: WebSocket connection via `web_socket_channel` package
- **Voice**: `speech_to_text` package (on-device, privacy-first)
- **Photo**: `image_picker` package → client-side resize → upload to CDN → send URL

### Data Fetching
```
onInit:
  copilotService.getOrCreateSession(workspace_id, context_screen)
  → session_id + cached messages

onSend(text):
  copilotService.sendMessage(session_id, text, context) → Stream<Token>
  → update UI per token
  → on complete: update credit balance
```

### Context Injection
The copilot sends the current screen context with each message so AI can provide relevant answers:
```dart
CopilotContext(
  currentScreen: 'home_dashboard',
  visibleData: {
    'revenue_today': '2.4M VND',
    'pending_orders': 3,
  },
  userRole: 'owner',
  operatorModes: ['creator', 'seller'],
)
```

---
## 19. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến — Copilot cần kết nối internet" + input disabled | Auto-retry on reconnect |
| AI generation failed | Backend/model error | Inline: "❌ Không thể xử lý yêu cầu. [Thử lại]" | Retry button |
| Streaming interrupted | Network loss mid-stream | Partial response shown + "📡 Mất kết nối. Phản hồi không đầy đủ. [Thử lại]" | Retry |
| Credit exhausted | Balance = 0 | Banner: "💳 Đã hết AI credits. Chỉ có thể hỏi trợ giúp. [Nạp thêm]" | Buy credits |
| Rate limited | Too many requests | Inline: "⏳ Vui lòng chờ 30 giây trước khi gửi tiếp." with countdown | Wait 30s |
| Permission denied | Action outside user role | AI responds: "Bạn cần quyền `{permission}` để thực hiện thao tác này." | Contact admin |
| Photo upload failed | File too large or bad format | Toast: "File quá lớn hoặc định dạng không hỗ trợ" | Re-select photo |

---
## 20. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Copilot open | <500ms | Overlay slides up. Welcome message immediate. |
| Session load | 200-500ms | Previous chat history loads (last 50 messages) |
| AI first token | <2s | Typing indicator ("🤖 Đang suy nghĩ...") |
| AI streaming | 1-10s | Text appears word-by-word with blinking cursor |
| Photo upload | 1-3s | Upload progress indicator on photo |
| Voice transcription | <1.5s | Waveform animation → transcribed text appears |

---
## 21. Localization Notes

- Primary language: Vietnamese
- AI greeting: Time-based ("Chào buổi sáng!", "Chào buổi chiều!")
- Credit display: "10/100 credits"
- Timestamps: Relative ("14:32", "2 phút trước")
- AI capability list: Vietnamese bullet points
- Quick action chips: Vietnamese labels
- Error messages: Vietnamese, friendly tone
- Tone of AI: Conversational Vietnamese, using "bạn" (informal you)

---
## 22. Related Screens

| Screen | Relationship |
|---|---|
| [W008] Web Copilot Dialog | Web equivalent |
| [M001] Mobile Home Dashboard | Primary entry point via quick action |
| [M011] Mobile Script Editor | Destination from "Tạo script" CTA |
| [M008] Mobile Idea Board | Destination from "Lưu ý tưởng" CTA |
| [M061] Mobile Billing | Destination from credit top-up |
| [S008] Command Palette | Web equivalent of quick actions |

---
## 23. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 4.0 | **Structure fix**: Removed duplicate template sections (§6/§11/§13/§16). Added detailed Error Handling (7 scenarios), progressive Loading timeline, expanded Localization with AI tone rules. Renumbered to 23-section structure. | System |
| 2026-03-28 | 3.0 | Full Tier A rewrite. Added component hierarchy, 10 actions, 8 states, RBAC matrix, real-time, 12 edge cases, accessibility, mobile UX, performance, analytics, design tokens, Flutter implementation. | System |
| 2026-03-28 | 2.0 | Expanded from 55-line sparse. Added quick action chips, voice/photo input. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
