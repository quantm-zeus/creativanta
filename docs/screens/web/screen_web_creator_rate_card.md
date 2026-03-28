# Screen: Web — Rate Card Builder

> **Screen ID**: W093
> **Module**: S16 — Creator Pro Tools
> **Route**: `/creator-pro/rate-card`
> **Platform**: Web (SvelteKit)
> **Upstream**: S16 Creator Pro Spec, A1 Schema (rate_card_items, creator_profiles), B5 RBAC §2.7

---

## 1. Purpose & Context

Build a professional pricing table for brand collaborations — editable service pricing with AI-suggested rates based on engagement metrics, niche, and market benchmarks. The rate card feeds into the Media Kit (W089) and Sponsor Inquiries (W090) for automated budget comparison.

### User Goals
- Set min/max pricing for each content type I offer
- Get AI-powered rate suggestions based on my actual metrics
- Share my rate card publicly via Media Kit or as a standalone PDF
- Keep rates updated as my audience grows

### Business Goals
- Enable data-driven pricing instead of guesswork
- Auto-compare incoming inquiry budgets against rate card
- Track rate card views and engagement (from media kit page)
- Support multi-currency for international collaborations

### Entry Points
- Sidebar: Creator Pro → "💰 Rate Card"
- Media Kit Editor (W089): "Edit pricing" section link
- Sponsor Inquiries (W090): "View your rate card" from comparison widget
- Copilot: "Giá TikTok video của tôi bao nhiêu?"

### Exit Points
- "Embed in Media Kit" → Media Kit Editor (W089)
- "📤 Share" → Share options (link, PDF)
- "← Creator Pro" → Dashboard

---

## 2. Preconditions / Postconditions

### Preconditions
- Creator Pro subscription active
- At least one social platform connected (for AI suggestions)

### Postconditions
- Saved rate card updates media kit pricing section automatically
- AI credit consumed when "AI Suggest" is used (3 credits per suggestion round)
- PDF export generates shareable document

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Creator Pro   💰 Bảng giá dịch vụ     [📤 Share] [📥 PDF]       │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Settings Bar ────────────────────────────────────────────────┐   │
│ │ Currency: [VND ▾]  Language: [Tiếng Việt ▾]                   │   │
│ │ [🤖 AI Suggest All — 3 credits] [💎 Last updated: 2d ago]    │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Rate Card Table ─────────────────────────────────────────────┐   │
│ │ Dịch vụ            │ Giá min     │ Giá max     │ AI suggest  │   │
│ │ ─────────────────── ──────────── ──────────── ──────────── │      │
│ │ TikTok video (60s) │ [2,000,000] │ [3,000,000] │ 2,500,000  │   │
│ │   ├ Turnaround: 5 ngày · Includes: 1 revision                │   │
│ │   └ Notes: "Price includes scripting + filming + editing"      │   │
│ │ Instagram Reel     │ [1,500,000] │ [2,000,000] │ 1,800,000  │   │
│ │ YouTube video (10m)│ [5,000,000] │ [8,000,000] │ 6,200,000  │   │
│ │ Story mention      │ [  300,000] │ [  500,000] │   400,000  │   │
│ │ Bundle (3 videos)  │ [5,000,000] │ [7,000,000] │ 6,000,000  │   │
│ │                                                                │   │
│ │ [+ Thêm dịch vụ]                                              │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ AI Pricing Intelligence ─────────────────────────────────────┐   │
│ │ 📊 Based on:                                                   │   │
│ │ • 50K followers × 6.2% engagement × skincare niche            │   │
│ │ • Market: similar creators charge 1.5-3M/video                 │   │
│ │ • Your engagement is 40% above niche average                   │   │
│ │ 💡 Recommendation: "Engagement cao hơn average — giá có thể  │   │
│ │    đặt ở top 30% thị trường (~2.8M/video)"                   │   │
│ │                                                                │   │
│ │ Comparable creators:                                           │   │
│ │ @creator_a: 45K followers, 2.0M/video                         │   │
│ │ @creator_b: 60K followers, 3.5M/video                         │   │
│ │ @creator_c: 55K followers, 2.8M/video                         │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Additional Terms (optional) ─────────────────────────────────┐   │
│ │ Payment terms: [50% upfront, 50% on delivery ▾]               │   │
│ │ Revision policy: [1 revision included ▾]                       │   │
│ │ Exclusivity: [None ▾]                                          │   │
│ │ Usage rights: [6 months ▾]                                     │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ [Lưu] [Embed in Media Kit →] [📥 Export PDF] [📤 Share link]       │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
RateCardBuilderPage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Creator Pro")
│   ├── PageTitle ("💰 Bảng giá dịch vụ")
│   ├── ShareButton
│   └── ExportPDFButton
├── SettingsBar
│   ├── CurrencySelector (VND, USD, EUR)
│   ├── LanguageSelector (for PDF export)
│   ├── AISuggestAllButton (with credit cost)
│   └── LastUpdatedTimestamp
├── RateCardTable
│   └── RateCardItem[] (drag-sortable)
│       ├── ServiceNameInput (editable)
│       ├── MinPriceInput (editable, formatted currency)
│       ├── MaxPriceInput (editable)
│       ├── AISuggestValue (read-only, badge)
│       ├── ExpandedDetails (collapsible)
│       │   ├── TurnaroundInput (days)
│       │   ├── RevisionsInput (count)
│       │   └── NotesInput (free text)
│       ├── DragHandle (for reordering)
│       └── DeleteButton (with confirm)
├── AddServiceButton
├── AIPricingIntelligenceCard
│   ├── BasisSection (followers, engagement, niche)
│   ├── MarketComparison
│   ├── Recommendation
│   └── ComparableCreators[] (anonymized or public)
├── AdditionalTermsSection
│   ├── PaymentTermsSelector
│   ├── RevisionPolicySelector
│   ├── ExclusivitySelector
│   └── UsageRightsSelector
└── ActionBar
    ├── SaveButton (primary)
    ├── EmbedInMediaKitButton
    ├── ExportPDFButton
    └── ShareLinkButton
```

---

## 5. User Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Edit prices | Change min/max input | Auto-save debounced 2s | Updated in DB | `rate_card:manage` |
| 2 | AI suggest all | "🤖 AI Suggest" | `AIService/SuggestRates` | AI values appear, 3 credits consumed | `rate_card:manage` |
| 3 | Add service | "+ Thêm dịch vụ" | — | New empty row appears | `rate_card:manage` |
| 4 | Remove service | Delete button → confirm | `RateCardService/DeleteItem` | Row removed | `rate_card:manage` |
| 5 | Reorder | Drag and drop | `RateCardService/Reorder` | Position updated | `rate_card:manage` |
| 6 | Save | "Lưu" | `RateCardService/Save` | Toast "Đã lưu bảng giá" | `rate_card:manage` |
| 7 | Export PDF | "📥 PDF" | Client-side PDF gen | PDF download | `rate_card:manage` |
| 8 | Share link | "📤 Share" | — | Copy public link / email composer | `rate_card:manage` |
| 9 | Embed in media kit | "Embed →" | — | → Media Kit Editor with pricing section | `rate_card:manage` |
| 10 | Change currency | Currency dropdown | — (client-side) | All amounts recalculated to selected currency | `rate_card:manage` |

---

## 6. Validation Rules

| Field | Rule | Error |
|---|---|---|
| Service name | Required, 3-100 chars | "Tên dịch vụ phải từ 3-100 ký tự" |
| Min price | Required, > 0 | "Giá tối thiểu phải lớn hơn 0" |
| Max price | Required, ≥ min price | "Giá tối đa phải ≥ giá tối thiểu" |
| Turnaround | Optional, 1-90 days | "Thời gian từ 1-90 ngày" |
| Revisions | Optional, 0-10 | "Số lần sửa từ 0-10" |
| At least 1 item | Required to save | "Bảng giá cần ít nhất 1 dịch vụ" |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Table skeleton |
| LOADED | Data received | Editable rate card table |
| EMPTY | No rate card items | "Chưa có bảng giá. Thêm dịch vụ đầu tiên để bắt đầu. [+ Thêm dịch vụ]" |
| AI_PROCESSING | AI suggest running | "🤖 Đang phân tích thị trường..." spinner on AI section |
| SAVING | Save in progress | Save button spinner |
| SAVED | Just saved | Toast "✅ Đã lưu bảng giá" |
| NO_PLATFORM | No social platform connected | "Kết nối TikTok hoặc Instagram để AI gợi ý giá dựa trên metrics. [→ Kết nối]" |
| ERROR | API failed | Error with retry |

---

## 8. Tier Gating

| Tier | Access |
|---|---|
| Free | ❌ No access |
| Starter | View only, cannot edit |
| Pro | Full access, AI suggest (10/month) |
| Business | Full access, unlimited AI suggest |

---

## 9. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| AI suggest fail | AI credit insufficient or API error | Toast: "Không đủ credits hoặc AI lỗi. [Thử lại]" | Top-up or retry |
| Save fail | API error on save | Toast: "Không lưu được bảng giá. [Thử lại]" | Retry |
| PDF export fail | Generation error | Toast: "Không tạo được PDF." | Retry |
| Currency convert fail | Exchange rate API error | Fallback: show VND only, note "Tỷ giá chưa cập nhật" | Retry |
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached rate data | Retry online |

---

## 10. Accessibility

| Element | Requirement |
|---|---|
| Rate card table | `role="table"`, editable cells with `aria-label="Giá {min/max} cho {service}"` |
| Drag handles | `aria-roledescription="sortable"`, `aria-label="Drag to reorder {service}"` |
| AI suggest values | `role="status"`, `aria-label="AI suggested: {amount}"` |
| Currency selector | `role="listbox"`, `aria-label="Currency selection"` |
| AI Intelligence card | `role="complementary"`, `aria-label="AI pricing intelligence"` |

---

## 11. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Table skeleton + settings bar |
| Rate data | 200-400ms | Table rows populate |
| AI intelligence | 500-2000ms | Intelligence card fades in |
| AI suggest all | 3-8s | Spinner on AI section, values update progressively |
| PDF generation | 2-5s | "Đang tạo PDF..." loading bar |

---

## 12. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `rate_card.viewed` | Page load | `item_count`, `currency` |
| `rate_card.item_added` | "+ Thêm dịch vụ" | `service_name` |
| `rate_card.price_updated` | Price input changed | `service`, `old_price`, `new_price`, `field` (min/max) |
| `rate_card.ai_suggested` | "🤖 AI Suggest All" | `credits_used`, `items_suggested` |
| `rate_card.reordered` | Drag completed | `item_id`, `old_pos`, `new_pos` |
| `rate_card.exported_pdf` | "📥 PDF" | `format`, `language` |
| `rate_card.shared` | "📤 Share" | `method` (link/email) |
| `rate_card.saved` | "Lưu" | `item_count` |

---

## 13. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/creator-pro/rate-card/+page.svelte`
- **Server load**: `+page.server.ts` → `RateCardService/GetRateCard(user_id)` + `AIService/GetPricingIntelligence`
- **Auto-save**: Debounced 2s after price input blur → `RateCardService/Save`
- **AI suggest**: `AIService/SuggestRates(platform_stats, niche)` → 3 credits → values populate inline
- **Drag-sort**: `@dnd-kit/sortable` for service reorder
- **Multi-currency**: Client-side conversion using cached exchange rates from `ExchangeRateService/GetRates`
- **PDF**: Server-side Puppeteer rendering of rate card template → download
- **Intelligence card**: Cached 24h, refreshes on manual "Refresh" or after AI suggest

---

## 14. Localization Notes

- Services: "Dịch vụ", "Giá tối thiểu", "Giá tối đa", "AI gợi ý"
- Terms: "Điều khoản thanh toán", "Chính sách sửa đổi", "Độc quyền", "Quyền sử dụng"
- AI: "Dựa trên: {followers} followers × {engagement}% tương tác"
- Currency: VND "2.000.000đ", USD "$200"
- Tone: Professional, data-confident

---

## 15. Design Tokens

| Token | Usage |
|---|---|
| `--color-accent` | Save CTA, share |
| `--color-ai` | AI suggest badge, intelligence card border |
| `--color-success` | Saved confirmation |
| `--color-text-secondary` | AI suggestions, notes |
| `--color-surface-elevated` | Table cards, intelligence card |
| `--color-border` | Table row separators |
| `--font-metric` | Prices (tabular-nums) |
| `--radius-card` | Card corners |

---

## 16. Related Screens

| Screen | Relationship |
|---|---|
| [W089] Media Kit Editor | Rate card embeds into media kit |
| [W090] Sponsor Inquiries | Rate comparison against incoming offers |
| [W088] Creator Pro Dashboard | Parent |
| [M049] Mobile Rate Card | Mobile equivalent |

---

## 17. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (AI suggest, PDF), table/drag a11y, 8 analytics, SvelteKit impl (AI suggest, multi-currency, PDF), localization, 8 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
