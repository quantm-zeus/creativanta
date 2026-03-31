# Screen: Web — Sponsor Inquiries

> **Screen ID**: W090
> **Module**: S16 — Creator Pro Tools
> **Route**: `/creator-pro/inquiries`
> **Platform**: Web (SvelteKit)
> **Upstream**: S16 Creator Pro Spec, A1 Schema (sponsor_inquiries, brand_deals), B5 RBAC §2.7

---
## 1. Purpose & Context

Manage incoming sponsor and brand collaboration inquiries with a status pipeline: **New → Negotiating → Accepted → Declined**. Inquiries come from brands contacting the creator through various channels — the system aggregates them into a single inbox-like view.

### User Goals
- View all incoming brand inquiries in one pipeline
- Evaluate deals quickly with budget, deliverable, and timeline information
- Accept, negotiate, or decline with structured responses
- Track conversion rate from inquiry to active partnership

### Business Goals
- Centralize brand deal intake for professional management
- Reduce missed opportunities by surfacing new inquiries
- Track inquiry-to-deal conversion rate for pricing optimization
- Accepted inquiries feed into Partnership Manager (W091)

### Entry Points
- Sidebar: Creator Pro → "📨 Inquiries"
- Creator Pro Dashboard (W088): "3 new inquiries" notification card
- Notification: "New sponsor inquiry from Brand ABC"
- Email: Brand inquiry forwarded to Creativanta

### Exit Points
- "✅ Accept" → creates brand deal → Partnership Manager (W091)
- "💬 Negotiate" → opens communication thread
- "👁 View brief" → full brief drawer
- "← Creator Pro" → Creator Pro Dashboard

---
## 2. Preconditions / Postconditions

### Preconditions
- User has `brand_deal:read` permission
- Creator Pro feature available for subscription tier

### Postconditions
- Accepted inquiries create `brand_deal` record with status "accepted"
- Declined inquiries are archived with decline reason
- Negotiation responses are logged in communication thread

---
## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Creator Pro  📨 Sponsor Inquiries               Pending: 3       │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Summary Bar ─────────────────────────────────────────────────┐   │
│ │ 📨 3 new · 💬 2 negotiating · ✅ 5 accepted · ❌ 1 declined │   │
│ │ Conversion rate (30d): 45% · Avg deal value: 4.2M VND       │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Tabs: [📨 New (3)] [💬 Negotiating (2)] [✅ Accepted (5)] [❌ Declined (1)]│
│                                                                      │
│ ┌─ Inquiry Card ─────────────────────────────────────────────────┐  │
│ │ 📨 Brand ABC — "Summer skincare campaign"      [📨 New]       │  │
│ │ Received: 2 ngày trước · Response SLA: ⏰ 22h remaining      │  │
│ │                                                                  │  │
│ │ 💰 Budget: 5,000,000 VND                                       │  │
│ │ 📋 Deliverables: 3 TikTok videos (60s) + 2 IG stories         │  │
│ │ 📅 Timeline: April 1 – April 30                                │  │
│ │ 📧 Contact: marketing@brandabc.com                              │  │
│ │ 🏢 Brand: Beauty Corp (verified)                                │  │
│ │                                                                  │  │
│ │ Rate comparison: Your rate card → 7M for same scope (↓2M gap)  │  │
│ │                                                                  │  │
│ │ [👁 View Full Brief] [✅ Accept Deal] [💬 Negotiate]          │  │
│ │ [❌ Decline] [⭐ Flag as Priority]                              │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Inquiry Card ─────────────────────────────────────────────────┐  │
│ │ 📨 Brand XYZ — "Product launch collab"         [📨 New]       │  │
│ │ 💰 Budget: 3,000,000 VND · 📋 2 YT shorts + 1 blog           │  │
│ │ 📅 March 25 – April 10 · ⏰ Response: 46h remaining          │  │
│ │ [👁 Brief] [✅ Accept] [💬 Negotiate] [❌ Decline]            │  │
│ └────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
SponsorInquiriesPage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Creator Pro")
│   ├── PageTitle ("📨 Sponsor Inquiries")
│   └── PendingBadge (count)
├── SummaryBar
│   ├── StatusCounts (new, negotiating, accepted, declined)
│   ├── ConversionRate
│   └── AvgDealValue
├── StatusTabs (New, Negotiating, Accepted, Declined)
├── InquiryList
│   └── InquiryCard[]
│       ├── CardHeader
│       │   ├── BrandLogo (avatar or initial)
│       │   ├── BrandName
│       │   ├── CampaignTitle
│       │   ├── StatusBadge
│       │   └── PriorityFlag (if flagged ⭐)
│       ├── TimingRow
│       │   ├── ReceivedDate (relative)
│       │   └── ResponseSLA (countdown timer, color-coded)
│       ├── DealDetails
│       │   ├── Budget (formatted VND)
│       │   ├── Deliverables (summary list)
│       │   ├── Timeline (date range)
│       │   ├── ContactEmail
│       │   └── BrandVerifiedBadge (if verified)
│       ├── RateComparison (optional — compares offered budget vs rate card)
│       │   ├── YourRate
│       │   ├── OfferedRate
│       │   └── GapIndicator (↑ above / ↓ below your rate)
│       └── ActionBar
│           ├── ViewBriefButton ("👁 View Full Brief" → drawer)
│           ├── AcceptButton ("✅ Accept Deal")
│           ├── NegotiateButton ("💬 Negotiate")
│           ├── DeclineButton ("❌ Decline")
│           └── FlagButton ("⭐ Priority")
├── BriefDrawer (opens on "View Full Brief")
│   ├── BrandSection (logo, name, industry, verified status, website)
│   ├── CampaignBrief
│   │   ├── Objective
│   │   ├── Target audience
│   │   ├── Key messages
│   │   ├── Content guidelines
│   │   └── Deliverables (detailed list)
│   ├── CommercialTerms
│   │   ├── Budget
│   │   ├── Payment terms (upfront, milestone, completion)
│   │   ├── Exclusivity clause
│   │   └── Usage rights
│   ├── RateCardComparison (side-by-side)
│   └── RespondSection
│       ├── AcceptButton
│       ├── NegotiateButton (opens message composer)
│       └── DeclineButton (with reason dropdown)
└── DeclineModal
    ├── ReasonSelector (Too low budget, Schedule conflict, Not my niche, Other)
    ├── OptionalMessage
    ├── SuggestCounter toggle (suggest alternative terms)
    └── SubmitButton
```

---
## 5. Displayed Data

| Field | Source | Format |
|---|---|---|
| Brand name | `sponsor_inquiries.brand_name` | String |
| Campaign title | `sponsor_inquiries.campaign_title` | String |
| Budget | `sponsor_inquiries.budget_amount` | VND "5,000,000đ" |
| Deliverables | `sponsor_inquiries.deliverables[]` | Formatted list |
| Timeline | `sponsor_inquiries.start_date` + `end_date` | "April 1 – April 30" |
| Contact | `sponsor_inquiries.contact_email` | Email |
| Status | `sponsor_inquiries.status` | Badge |
| Received | `sponsor_inquiries.created_at` | Relative: "2 ngày trước" |
| SLA | Computed: created_at + 48h - now | Countdown |
| Rate comparison | Compare budget vs `rate_card.calculate(deliverables)` | Gap: "↓2M" |
| Conversion rate | Accepted / total (30d) × 100 | "45%" |

---
## 6. User Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | View brief | "👁 View Full Brief" | — | BriefDrawer opens | `brand_deal:read` |
| 2 | Accept | "✅ Accept" → confirm | `SponsorInquiryService/Accept` | Creates brand_deal → toast "Deal đã được chấp nhận. [→ Partnership Manager]" | `brand_deal:manage` |
| 3 | Negotiate | "💬 Negotiate" | — | Opens message composer with template | `brand_deal:manage` |
| 4 | Decline | "❌ Decline" → DeclineModal | `SponsorInquiryService/Decline(reason)` | Status → Declined, optional counter-suggestion sent | `brand_deal:manage` |
| 5 | Flag priority | "⭐ Priority" toggle | `SponsorInquiryService/Flag` | Star icon, card sorted to top | `brand_deal:read` |
| 6 | Switch tab | Tab click | — (client filter) | List filters by status | `brand_deal:read` |

---
## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Summary shimmer + card skeletons |
| LOADED | Data received | Inquiry cards with pipeline tabs |
| EMPTY | No inquiries | "📨 Chưa có lời mời hợp tác nào. Khi brand liên hệ, các yêu cầu sẽ hiển thị ở đây. [→ Cập nhật Media Kit để thu hút brand]" |
| SLA_WARNING | Inquiry close to SLA (< 12h) | Orange pulsing timer |
| SLA_BREACH | Inquiry past SLA | Red timer: "Quá hạn phản hồi. Trả lời ngay!" |
| ERROR | API failed | Error with retry |

---
## 8. Permissions

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer |
|---|---|---|---|---|---|---|
| View inquiries | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Accept deal | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Negotiate | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Decline | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| View budget details | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Flag priority | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |

---
## 9. Rate Card Integration

When a creator has a Rate Card (W093) configured, each inquiry shows:
- **Your rate** for the same scope of deliverables (auto-calculated)
- **Offered budget** from the brand
- **Gap**: positive (above your rate) or negative (below your rate)
- **Suggestion**: If below, system suggests negotiate with counter-offer

This helps creators make informed accept/negotiate/decline decisions.

---
## 10. Tier Gating

- Free: No access to Creator Pro → redirect to upsell
- Starter: View only, cannot accept/negotiate
- Pro: Full access, up to 10 active inquiries
- Business: Unlimited, priority placement in inquiry routing

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached inquiry data | Retry online |
| Accept fail | API error on accept | Toast: "Không chấp nhận được. [Thử lại]" | Retry |
| Decline fail | API error on decline | Toast: "Không từ chối được. [Thử lại]" | Retry |
| SLA breach | Inquiry past 48h without response | Red alert: "⚠️ Quá hạn phản hồi!" + notification | Respond immediately |
| Rate card unavailable | No rate card configured | Inline: "Chưa có Rate Card. [→ Tạo Rate Card]" | Navigate |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Status tabs | `role="tablist"`, each tab `role="tab"`, `aria-selected` |
| Inquiry cards | `role="article"`, `aria-label="{brand} — {campaign}, {status}, SLA: {time}"` |
| SLA countdown | `role="timer"`, `aria-label="Response time remaining: {hours} hours"` |
| Brief drawer | `role="dialog"`, focus trap, `aria-label="Full brief: {brand}"` |
| Decline modal | `role="alertdialog"`, focus trap |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Summary bar + card skeletons |
| Summary stats | 100-300ms | Counts + conversion rate |
| Inquiry cards | 300-600ms | Cards stagger by tab status |
| Rate comparison | 500-800ms | Async per card |
| Brief drawer | 200-400ms | Content loads on open |

---

## 14. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `inquiries.viewed` | Page load | `new_count`, `conversion_rate`, `avg_deal_value` |
| `inquiries.tab_switched` | Tab change | `tab` (new/negotiating/accepted/declined) |
| `inquiries.brief_viewed` | "👁 View Full Brief" | `inquiry_id`, `brand`, `budget` |
| `inquiries.accepted` | "✅ Accept" confirmed | `inquiry_id`, `budget`, `rate_card_gap` |
| `inquiries.negotiated` | "💬 Negotiate" sent | `inquiry_id`, `counter_amount` |
| `inquiries.declined` | "❌ Decline" confirmed | `inquiry_id`, `reason` |
| `inquiries.flagged` | "⭐ Priority" toggled | `inquiry_id`, `flagged` |
| `inquiries.sla_breached` | SLA timer expired | `inquiry_id`, `hours_overdue` |

---

## 15. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/creator-pro/inquiries/+page.svelte`
- **Server load**: `+page.server.ts` → `SponsorInquiryService/ListInquiries(workspace_id)` + `SponsorInquiryService/GetStats`
- **Tabs**: Client-side filter by `status` field; all data loaded once
- **SLA**: Computed client-side from `created_at + 48h - now()`, updates every second
- **Accept flow**: `SponsorInquiryService/Accept(id)` → creates `brand_deal` → redirect to Partnership Manager
- **Decline**: `SponsorInquiryService/Decline(id, reason, counter?)` → optionally sends counter terms
- **Brief drawer**: Lazy-loads full brief content on open
- **Rate comparison**: `RateCardService/CompareScope(deliverables)` async per card

---

## 16. Localization Notes

- Tabs: "📨 Mới", "💬 Đang thương lượng", "✅ Đã chấp nhận", "❌ Đã từ chối"
- SLA: "⏰ Còn 22 giờ để phản hồi"
- Budget: VND "5.000.000đ"
- Rate gap: "↓2M dưới rate card" / "↑1M trên rate card"
- Conversion: "Tỷ lệ chuyển đổi: 45%"
- Tone: Professional, opportunity-focused

---

## 17. Design Tokens

| Token | Usage |
|---|---|
| `--color-inquiry-new` | 📨 New badge |
| `--color-inquiry-negotiating` | 💬 Negotiating badge |
| `--color-success` | ✅ Accepted |
| `--color-danger` | ❌ Declined, SLA breach |
| `--color-warning` | SLA warning (<12h) |
| `--color-accent` | Accept CTA |
| `--color-surface-elevated` | Inquiry cards, brief drawer |
| `--color-rate-above` | Rate card above (green) |
| `--color-rate-below` | Rate card below (orange/red) |

---

## 18. Related Screens

| Screen | Relationship |
|---|---|
| [W088] Creator Pro Dashboard | Parent screen |
| [W089] Media Kit Editor | Attract more inquiries |
| [W091] Partnership Manager | Accepted inquiries become partnerships |
| [W093] Rate Card | Rate comparison data source |
| [M046] Mobile Brand Deals | Mobile equivalent |

---

## 19. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (accept fail, SLA breach), card/drawer a11y, 8 analytics, SvelteKit impl, localization, 9 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
