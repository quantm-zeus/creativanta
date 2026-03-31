# Screen: Web — Live War Room

> **Screen ID**: W87
> **Module**: M20 — Live Commerce
> **Route**: `/live/[id]/war-room`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 05, A1 Schema (live_sessions, cue_cards, highlights)

---

## 1. Purpose & Context

Full-screen live selling command center — product queue, AI chat triage, real-time stats, and quick actions (flash sale, highlight, coupon). No sidebar — maximum screen real estate.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ Full Screen ────────────────────────────────────────────────────────┐
│ 🔴 LIVE · "Spring Sale" · 00:45:23 · 👁 1,234 viewers              │
├── Product Queue (25%) ──┬── Chat Triage (50%) ──┬── Stats (25%) ────┤
│ Now: Serum VitC          │ [Live chat stream]     │ 📊 Live Stats    │
│ ├ Price: 299K → 249K 🔥  │ AI-highlighted:        │ Orders: 45       │
│ ├ Stock: 45 remaining    │ purchase intents in    │ Revenue: 12.5M    │
│ ├ Orders this session: 12│ green background       │ Viewers peak: 1.8K│
│ └ [📋 Cue Card]          │                        │ Engagement: 12%   │
│                           │ [Quick reply...]       │                   │
│ Next: Kem chống nắng     │                        │ 🔔 Alerts         │
│ After: Combo set          │                        │ ⚠️ Stock < 10     │
│                           │                        │ 💡 Show offer NOW │
│ ┌─ Quick Actions ────┐  │                        │                   │
│ │ [🔥 Flash Sale NOW] │  │                        │                   │
│ │ [📌 Highlight]      │  │                        │                   │
│ │ [🏷 Show coupon]   │  │                        │                   │
│ │ [📸 Pin product]   │  │                        │                   │
│ └─────────────────────┘  │                        │                   │
├───────────────────────────┴────────────────────────┴───────────────────┤
│ [End Session] [📊 Post-Live Summary]                                  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3-5. Component & Actions

```
LiveWarRoomPage
├── FullScreenLayout (no app shell sidebar)
├── StatusBar (live indicator, title, duration, viewers)
├── ThreeColumnLayout
│   ├── ProductQueue (left, 25%)
│   │   ├── CurrentProduct (name, price, stock, orders, cue card)
│   │   ├── NextUpList
│   │   └── QuickActions (flash sale, highlight, coupon, pin)
│   ├── ChatTriage (center, 50%)
│   │   ├── ChatStream (AI-highlighted purchase intents)
│   │   └── QuickReplyInput
│   └── StatsPanel (right, 25%)
│       ├── LiveMetrics (orders, revenue, viewers, engagement)
│       └── AlertList (stock warnings, AI suggestions)
└── BottomBar (End Session, Post-Live)
```

| # | Action | Trigger | API | Result |
|---|---|---|---|---|
| 1 | Next product | "▼ Next product" | `LiveService/NextProduct` | Queue advances |
| 2 | Flash sale | "🔥 Flash Sale" → confirm | `LiveService/TriggerFlashSale` | Price drops |
| 3 | Highlight | "📌 Highlight" | `LiveService/CreateHighlight` | Moment bookmarked |
| 4 | Show coupon | "🏷 Show coupon" | `LiveService/ShowCoupon` | Code displayed |
| 5 | Quick reply | Type + enter | `LiveService/Reply` | Reply posted |
| 6 | End session | "End" → confirm | `LiveService/EndSession` | → Post-Live |

### Technical Notes
- Route: `src/routes/(app)/live/[id]/war-room/+page.svelte`
- Chat: WebSocket real-time with AI intent classification
- Stats: SSE real-time updates

### Related Screens: [W85] Planner, [W88] Post-Live, [M36] Mobile War Room

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-28 | 1.0 | Initial specification |

---

## 6. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| WebSocket disconnect | Network interruption | Banner: "⚠️ Mất kết nối chat. Đang kết nối lại..." + auto-reconnect | Auto-reconnect 3s |
| Stats SSE disconnect | SSE connection dropped | Stats show stale with "⚠️ Cập nhật lần cuối: {time}" | Auto-reconnect |
| Flash sale fail | API error on trigger | Toast: "Không kích hoạt được Flash Sale. [Thử lại]" | Retry |
| End session fail | API error | Toast: "Không kết thúc được phiên. [Thử lại]" | Retry |
| Platform disconnect | Live platform drops | Alert: "🔴 {platform} ngắt kết nối! Kiểm tra lại." | Reconnect |

---

## 7. Accessibility

| Element | Requirement |
|---|---|
| Status bar | `role="status"`, `aria-live="polite"`, `aria-label="Live: {title}, {duration}, {viewers} viewers"` |
| Product queue | `role="list"`, `aria-label="Product queue"` |
| Chat stream | `role="log"`, `aria-live="polite"`, AI-highlighted with `role="mark"` |
| Quick actions | `role="toolbar"`, each button with `aria-label` |
| Stats panel | `role="status"`, each metric with `aria-label="{metric}: {value}"` |
| Alerts | `role="alert"`, `aria-live="assertive"` |

---

## 8. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Full-screen 3-column skeleton |
| Session data | 200-400ms | Product queue + session info |
| Chat WebSocket | 300-500ms | Chat stream starts |
| Stats SSE | 300-500ms | Real-time stats begin |
| Cue cards | 200-400ms | Current product cue card loads |

---

## 9. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `live.war_room_entered` | Page load | `session_id`, `viewer_count` |
| `live.product_advanced` | "▼ Next product" | `session_id`, `old_product`, `new_product` |
| `live.flash_sale_triggered` | "🔥 Flash Sale" confirmed | `session_id`, `product_id`, `discount` |
| `live.highlight_created` | "📌 Highlight" | `session_id`, `timestamp` |
| `live.coupon_shown` | "🏷 Show coupon" | `session_id`, `coupon_code` |
| `live.chat_replied` | Quick reply sent | `session_id`, `reply_type` |
| `live.session_ended` | "End Session" confirmed | `session_id`, `duration`, `total_orders`, `revenue` |
| `live.stock_alert` | Stock <10 | `session_id`, `product_id`, `remaining` |

---

## 10. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/live/[id]/war-room/+page.svelte`
- **Full-screen**: No AppShell sidebar — uses `data-sveltekit-prefetch` for fast load
- **Chat**: WebSocket connection to `wss://live.api/chat/{session_id}` with AI intent classification
- **Stats**: SSE from `LiveService/StreamStats(session_id)` → updates every 2s
- **Quick actions**: `LiveService/TriggerFlashSale`, `CreateHighlight`, `ShowCoupon` — all optimistic UI
- **Product queue**: `LiveService/NextProduct(session_id)` → auto-advances cue card
- **End session**: `LiveService/EndSession(session_id)` → redirect to Post-Live Summary
- **Alerts**: Real-time stock monitoring, AI chat suggestions pushed via SSE

---

## 11. Localization Notes

- Status: "ĐANG LIVE", "Thời lượng:", "Người xem:"
- Products: "Đang bán:", "Tiếp theo:", "Tồn kho:", "Đơn phiên này:"
- Quick actions: "Giảm giá chớp nhoáng", "Đánh dấu điểm nhấn", "Hiển thị mã giảm giá"
- Chat: "Trả lời nhanh...", "Ý định mua hàng"
- Tone: Urgent, action-driven (live selling energy)

---

## 12. Design Tokens

| Token | Usage |
|---|---|
| `--color-live-active` | 🔴 Live pulsing dot |
| `--color-flash-sale` | 🔥 Flash sale button + overlay |
| `--color-chat-intent` | Purchase intent highlight |
| `--color-stock-warning` | ⚠️ Low stock alert |
| `--color-live-stats-bg` | Stats panel background |
| `--color-success` | Order count, revenue positive |
| `--color-danger` | End session, stock critical |
| `--color-surface-dark` | Full-screen dark background |
| `--font-metric` | Stats numbers (tabular-nums) |

---

## 13. Related Screens

| Screen | Relationship |
|---|---|
| [W107] Live Planner | Session list |
| [W108] Live Setup | Previous step (preparation) |
| [W110] Post-Live Summary | Post-session analytics |
| [M055] Mobile Live War Room | Mobile equivalent |

---

## 14. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (WebSocket, flash sale), 3-column/chat a11y, 8 analytics, SvelteKit impl (WebSocket, SSE, full-screen), localization, 9 design tokens (live-specific). | System |
| 2026-03-28 | 1.0 | Initial specification | System |
