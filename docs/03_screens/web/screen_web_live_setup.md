# Screen: Web — Live Session Setup

> **Screen ID**: W108
> **Module**: M17 — Live Commerce War Room
> **Route**: `/live/[id]/setup`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 05, PRD §23.17, A1 Schema (live_sessions, live_products, live_cue_cards, live_offers), B5 RBAC §2.7

---

## 1. Purpose & Context

Prepare everything for a live session — product lineup with drag-reorder, cue cards with timing, special offers configuration, and pre-live equipment checklist. This is the "Prepare" step: **Plan → Setup → War Room → Post-Live**.

### User Goals
- Organize product presentation order with talking points
- Create timed cue cards as a teleprompter guide
- Configure flash sales and special offers for the session
- Complete a pre-live checklist to ensure readiness

### Business Goals
- Reduce prep time with structured setup flow
- Ensure product lineup is optimized (best sellers first)
- Pre-configure offers to reduce War Room workload
- Track readiness score before going live

### Entry Points
- Live Planner (W107): "📋 Chuẩn bị" on upcoming session
- Notification: "Session starts in 1 hour — check setup"

### Exit Points
- "✅ Bắt đầu live →" → War Room (W109)
- "← Live" → Live Planner (W107)

---

## 2. Preconditions / Postconditions

### Preconditions
- Live session exists in "planned" status
- At least one product selected for the session

### Postconditions
- Product order saved to `live_products.display_order`
- Cue cards available in War Room as teleprompter
- Offers pre-configured and ready to activate during live

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Live   ⚙️ Setup: "Spring Sale"           [✅ Bắt đầu live →]   │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Readiness Score ─────────────────────────────────────────────┐   │
│ │ ✅ 4/5 steps complete · Score: 80%                            │   │
│ │ [████████████████░░░░] Ready to go (missing: speed test)     │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Tabs: [📦 Sản phẩm (8)] [📋 Cue Cards (12)] [🎁 Offers (3)] [✅ Checklist]│
│                                                                      │
│ ── 📦 Sản phẩm Tab (Drag-reorder) ──                                │
│ ┌─ Product Lineup ──────────────────────────────────────────────┐   │
│ │ ≡ 1. Serum Vitamin C · 299K → 249K 🔥 · Stock: 245          │   │
│ │   Talking points: • Thành phần chính · • So sánh đối thủ     │   │
│ │   Planned duration: ~10 min · Target orders: 30              │   │
│ │ ≡ 2. Kem chống nắng · 199K · Stock: 180                      │   │
│ │   Talking points: • SPF50+ · • Texture                        │   │
│ │   Planned duration: ~8 min · Target orders: 20               │   │
│ │ ≡ 3. Toner AHA · 149K · Stock: 320                            │   │
│ │ [+ Thêm sản phẩm từ catalog]                                  │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ── 📋 Cue Cards Tab ──                                               │
│ ┌─ Cue Card Timeline ──────────────────────────────────────────┐    │
│ │ ⏱ 0:00 │ "Chào mừng các bạn! Hôm nay sẽ có 8 sản phẩm"     │    │
│ │ ⏱ 0:05 │ "Serum VitC — điểm nổi bật, before/after demo"     │    │
│ │ ⏱ 0:15 │ "🔥 Flash sale: giảm 50K trong 5 phút!"            │    │
│ │ ⏱ 0:20 │ "Kem chống nắng — SPF test live, so sánh"          │    │
│ │ ⏱ 0:28 │ "Q&A time — trả lời câu hỏi từ chat"              │    │
│ │ [+ Thêm cue card] [🤖 AI generate cue cards — 5 credits]    │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ── 🎁 Offers Tab ──                                                  │
│ ┌─ Session Offers ──────────────────────────────────────────────┐   │
│ │ 🔥 Flash Sale #1: Serum -50K (0:15-0:20) · Auto-activate    │   │
│ │ 🎁 Bundle: Serum + Kem CN = 398K (save 50K) · Manual pin     │   │
│ │ 🎟 Coupon: LIVE10 -10% all · Show in chat                     │   │
│ │ [+ Thêm offer]                                                 │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ── ✅ Checklist Tab ──                                               │
│ ┌─ Pre-Live Checklist ──────────────────────────────────────────┐   │
│ │ ☑ Camera đã sẵn sàng (webcam/phone)                           │   │
│ │ ☑ Microphone kết nối và test âm lượng                         │   │
│ │ ☐ Internet speed test (≥ 10Mbps upload)                       │   │
│ │ ☑ Sản phẩm bày trưng bên cạnh                                │   │
│ │ ☑ Ánh sáng tốt, không ngược sáng                              │   │
│ │ ☑ Background sạch, gọn gàng                                   │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ [💾 Lưu setup]                              [✅ Bắt đầu live →]    │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
LiveSetupPage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Live")
│   ├── PageTitle ("⚙️ Setup: {session_name}")
│   └── StartLiveButton ("✅ Bắt đầu live →", primary CTA)
├── ReadinessScore
│   ├── StepsComplete (N/total)
│   ├── ScorePercentage + ProgressBar
│   └── MissingItems (if any)
├── SetupTabs
│   ├── ProductsTab
│   │   └── DraggableProductList
│   │       └── ProductItem[] (drag handle ≡)
│   │           ├── Position (auto-numbered)
│   │           ├── ProductName + Price (original + sale price if flash)
│   │           ├── StockLevel
│   │           ├── TalkingPoints[] (editable bullet list)
│   │           ├── PlannedDuration (minutes)
│   │           ├── TargetOrders
│   │           └── RemoveButton
│   │       └── AddProductButton
│   ├── CueCardsTab
│   │   └── CueCardTimeline
│   │       └── CueCard[]
│   │           ├── Timestamp (editable)
│   │           ├── Content (rich text, editable)
│   │           ├── DragHandle (reorder)
│   │           ├── EditButton + DeleteButton
│   │       └── AddCueCardButton + AIGenerateButton
│   ├── OffersTab
│   │   └── OfferList
│   │       └── OfferItem[]
│   │           ├── OfferType (Flash Sale / Bundle / Coupon)
│   │           ├── OfferDetails
│   │           ├── ActivationSchedule (time or manual)
│   │           └── EditButton + RemoveButton
│   │       └── AddOfferButton
│   └── ChecklistTab
│       └── ChecklistItem[] (toggleable)
│           ├── Checkbox
│           ├── ItemDescription
│           └── StatusIcon
├── SaveButton
└── StartLiveButton (fixed at bottom)
```

---

## 5. User Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Reorder products | Drag & drop | `LiveCommerceService/UpdateRunOfShow` | Position updated | `live:manage` |
| 2 | Add product | "+ Thêm" → catalog picker | `LiveCommerceService/HighlightProduct` | Product added to lineup | `live:manage` |
| 3 | Edit talking points | Click text | — (inline edit) | Auto-save | `live:manage` |
| 4 | Add cue card | "+ Thêm cue card" | — | New empty cue card at end | `live:manage` |
| 5 | AI generate cue cards | "🤖 AI generate" | `AIService/GenerateLiveCueCards` | Cue cards populated from product info | `live:manage` |
| 6 | Add offer | "+ Thêm offer" → modal | `LiveCommerceService/HighlightProduct` | Offer configured | `live:manage` |
| 7 | Toggle checklist | Click checkbox | Client-side | Item checked/unchecked, readiness updates | `live:manage` |
| 8 | Start live | "✅ Bắt đầu" → confirm | `LiveCommerceService/StartSession` | Session → "live", redirect to War Room | `live:manage` |
| 9 | Save | "💾 Lưu" | `LiveCommerceService/CreateSession` | All changes persisted, toast | `live:manage` |

---

## 6. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Tab skeletons |
| LOADED | Setup data ready | Editable tabs with readiness score |
| READY | All checklist items done | Green readiness: "✅ 100% ready!" Start button fully enabled |
| NOT_READY | Missing checklist items | Orange: "⚠️ {count} items chưa hoàn thành" Start button still enabled but with warning |
| NO_PRODUCTS | No products selected | "Thêm ít nhất 1 sản phẩm để bắt đầu live. [+ Thêm từ catalog]" Start button disabled |
| SESSION_STARTED | Session already started | Redirect to War Room automatically |
| ERROR | API failed | Error with retry |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached setup data | Retry online |
| Save fail | API error on save | Toast: "Không lưu được setup. [Thử lại]" | Retry |
| AI cue card fail | AI credit insufficient or error | Toast: "Không tạo được cue cards. [Thử lại]" | Retry/top-up |
| Start session fail | Platform API error | Alert: "Không bắt đầu được live. Kiểm tra {platform}." | Re-check |
| Product not found | Catalog item deleted | Inline: "⚫ Sản phẩm đã bị xóa. [Thay thế]" | Remove/replace |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| Setup tabs | `role="tablist"`, `aria-selected`, tab counts in labels |
| Product list | `role="list"`, drag items `aria-roledescription="sortable"` |
| Cue card timeline | `role="list"`, `aria-label="Cue cards timeline"` |
| Readiness progress | `role="progressbar"`, `aria-valuenow`, `aria-label="Setup readiness: {pct}%"` |
| Checklist items | `role="checkbox"`, `aria-checked` |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Readiness skeleton + tab skeletons |
| Readiness score | 100-300ms | Score + progress bar |
| Products tab | 300-600ms | Product items populate |
| Cue cards | 300-600ms | Timeline items appear |
| Offers | 200-400ms | Offer items load |
| AI generation | 3-8s | "🤖 Đang tạo cue cards..." progress bar |

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `live.setup_viewed` | Page load | `session_id`, `readiness_pct`, `product_count` |
| `live.product_reordered` | Drag completed | `session_id`, `product_id` |
| `live.product_added` | "+ Thêm" confirmed | `session_id`, `product_id` |
| `live.cue_card_created` | "+ Thêm cue card" | `session_id`, `method` (manual/AI) |
| `live.ai_cue_cards_generated` | "🤖 AI generate" | `session_id`, `card_count`, `credits_used` |
| `live.offer_configured` | Offer added/edited | `session_id`, `offer_type` |
| `live.checklist_toggled` | Checkbox click | `session_id`, `item`, `checked` |
| `live.session_started` | "✅ Bắt đầu" confirmed | `session_id`, `readiness_pct`, `product_count` |

---

## 11. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/live/[id]/setup/+page.svelte`
- **Server load**: `+page.server.ts` → `LiveService/GetSession(id)` + products, cue cards, offers, checklist
- **Drag-drop**: `@dnd-kit/sortable` for products and cue cards
- **AI cue cards**: `AIService/GenerateLiveCueCards(session_id, products)` → 5 credits → cards populate
- **Talking points**: Inline editable text, auto-save on blur
- **Checklist**: Client-side state → persisted on "💾 Lưu"
- **Start session**: `LiveService/StartSession(id)` → status → "live" → redirect to War Room
- **Readiness**: Computed from checklist + product count + cue card count

---

## 12. Localization Notes

- Tabs: "📦 Sản phẩm", "📋 Cue Cards", "🎁 Offers", "✅ Checklist"
- Readiness: "{n}/{total} bước hoàn thành · Điểm: {pct}%"
- Products: "Điểm nổi bật:", "Thời lượng dự kiến:", "Mục tiêu đơn:"
- Checklist: "Camera sẵn sàng", "Microphone test", "Internet speed test"
- Tone: Preparatory, checklist-focused

---

## 13. Design Tokens

| Token | Usage |
|---|---|
| `--color-readiness-ready` | ✅ 100% ready (green) |
| `--color-readiness-partial` | ⚠️ Partial ready (orange) |
| `--color-live-active` | Start live CTA |
| `--color-accent` | Tab highlights, add buttons |
| `--color-ai` | AI generate button |
| `--color-surface-elevated` | Tab content panels |
| `--font-metric` | Prices, stock numbers (tabular-nums) |
| `--color-border` | Product/cue card separators |

---

## 14. Related Screens

| Screen | Relationship |
|---|---|
| [W107] Live Planner | Session list |
| [W109] Live War Room | Next step after setup |
| [W060] Product List | Product catalog |
| [M055] Mobile Live War Room | Mobile equivalent |

---

## 15. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (AI cue cards, start fail), tab/drag a11y, 8 analytics, SvelteKit impl (drag-drop, AI gen, readiness), localization, 8 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
