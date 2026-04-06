# Screen: Web — Partnership Manager

> **Screen ID**: W091
> **Module**: S16 — Creator Pro Tools
> **Route**: `/creator-pro/partnerships`
> **Platform**: Web (SvelteKit)
> **Upstream**: S16 Creator Pro Spec, A1 Schema (`brand_deals`), A3 API (`BrandDealService/ListPartnerships`, `BrandDealService/UpdateDeliverable`, `BrandDealService/UpdatePayment`, `ProofService/UploadEvidence`)

---

## 1. Purpose & Context

The Partnership Manager tracks active brand collaborations — deliverables, deadlines, payments, proof of performance. This is the operational center for Brand Collaboration operator mode users managing sponsor relationships.

### User Goals
- Track all active partnerships and their deliverable status
- Never miss a deliverable deadline
- Monitor payment status and expected payout dates
- Access performance proof for completed deliverables

### Business Goals
- Ensure deliverable fulfillment maintains brand relationship quality
- Track partnership revenue as part of profit calculation
- Build portfolio of completed partnerships for Media Kit

### When This Screen Is Used
- Brand Collaboration mode operators checking daily tasks
- Reviewing upcoming deliverable deadlines
- After completing a deliverable, updating status
- Checking payment status for completed partnerships

### Entry Points
- Sidebar: Creator Pro → "🤝 Partnerships"
- Creator Pro Dashboard (W088): "Active Partnerships" card
- Notification: "Deliverable due in 3 days" → deep link to partnership
- Brand Deals (W095): "View partnership" from accepted deal

### Exit Points
- Click deliverable → proof tracking or content link
- Click "📊 Stats" → analytics for partnership content
- Click "💬 Contact brand" → open thread in Inbox (W046)
- Click "→ Deliverables" → expand deliverable checklist
- Back → Creator Pro Dashboard

---

## 2. Preconditions / Postconditions

### Preconditions
- User has `brand_deal:read` permission (Owner, Admin, Manager, Editor)
- At least one brand deal exists in "accepted" or "active" state
- Creator Pro feature available for user's subscription tier

### Postconditions
- Deliverable status updates are synced to brand deal record
- Completed deliverables auto-add to Media Kit portfolio
- Payment status changes trigger notification to workspace owner

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Creator Pro   🤝 Active Partnerships              [+ Thêm deal]  │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Summary ─────────────────────────────────────────────────────┐   │
│ │ 📊 3 active · 💰 15M VND total value · ⏰ 2 deadlines this week│  │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Filter: [Status ▾] [Sort: Deadline soonest ▾]                       │
│                                                                      │
│ ┌─ Partnership Card ─────────────────────────────────────────────┐  │
│ │ 🤝 Brand ABC — "Summer Skincare Campaign"     [🟢 Active]     │  │
│ │ Value: 5,000,000 VND · Period: Apr 1 – Apr 30                  │  │
│ │                                                                  │  │
│ │ Deliverables: 3/5 completed                [████████░░░░ 60%]  │  │
│ │ ☑ TikTok video 60s          ✅ Completed 25/3  [📊 12K views] │  │
│ │ ☑ Instagram Reel             ✅ Completed 27/3  [📊 5K views]  │  │
│ │ ☐ IG Story mention ×2       ⏰ Due 30/3       [Mark done]     │  │
│ │ ☐ YouTube Short 30s         ⏰ Due 5/4        [Mark done]     │  │
│ │ ☐ Blog review post          📅 Due 15/4                        │  │
│ │                                                                  │  │
│ │ 💳 Payment: [🟡 Pending] · Expected: 15/4/2026                │  │
│ │ Proof Bundle: 2/3 proofs submitted [→ Add proof]                │  │
│ │                                                                  │  │
│ │ [→ All Deliverables] [📊 Performance Stats] [💬 Contact Brand] │  │
│ │ [📎 Upload Proof] [📄 Contract] [📤 Export Report]             │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Partnership Card ─────────────────────────────────────────────┐  │
│ │ 🤝 Brand XYZ — "Spring Collection"           [🟡 In Progress] │  │
│ │ Value: 3,000,000 VND · Period: Mar 15 – Apr 15                 │  │
│ │ Deliverables: 1/3 completed                                     │  │
│ │ ...                                                              │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Completed Section (collapsed) ────────────────────────────────┐  │
│ │ 📁 Completed Partnerships (5) [Expand ▾]                       │  │
│ └────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
PartnershipManagerPage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Creator Pro")
│   ├── PageTitle ("🤝 Active Partnerships")
│   └── AddDealButton (primary CTA: "+ Thêm deal")
├── SummaryBar
│   ├── ActiveCount ("3 active")
│   ├── TotalValue ("15M VND")
│   └── UpcomingDeadlines ("2 deadlines this week")
├── FilterBar
│   ├── StatusFilter (Active, In Progress, Payment Pending, Completed)
│   └── SortSelector (Deadline soonest, Value highest, Recent)
├── PartnershipCardList
│   └── PartnershipCard[]
│       ├── CardHeader
│       │   ├── BrandLogo (avatar)
│       │   ├── BrandName
│       │   ├── CampaignTitle
│       │   └── StatusBadge (🟢 Active / 🟡 In Progress / 🔵 Payment Pending / ⚪ Completed)
│       ├── MetaRow
│       │   ├── ValueDisplay (formatted VND)
│       │   └── PeriodDisplay (date range)
│       ├── DeliverableSection
│       │   ├── ProgressBar (X/Y completed)
│       │   └── DeliverableItem[]
│       │       ├── Checkbox (completed/pending)
│       │       ├── DeliverableTitle
│       │       ├── PlatformIcon
│       │       ├── DueDateBadge (with urgency color)
│       │       ├── PerformanceSnippet (views/engagement if completed)
│       │       └── MarkDoneButton (conditional)
│       ├── PaymentSection
│       │   ├── PaymentStatusBadge (🟢 Paid / 🟡 Pending / 🔴 Overdue)
│       │   ├── ExpectedDate
│       │   └── ProofBundleStatus
│       └── ActionBar
│           ├── ViewDeliverablesButton
│           ├── StatsButton
│           ├── ContactBrandButton
│           ├── UploadProofButton
│           ├── ContractButton
│           └── ExportButton
├── CompletedSection (collapsible)
│   └── CompletedPartnershipCard[] (compact format)
```

---

## 5. Displayed Data

| Field | Source | Format | Fallback |
|---|---|---|---|
| Brand name | `brand_deals.brand_name` | String | "Unnamed Brand" |
| Campaign title | `BrandDealService/ListPartnerships` response title field | String, max 60 chars | "Untitled Partnership" |
| Value | `brand_deals.value` | VND format: "5.000.000đ" or "5M" | "Chưa xác định" |
| Period | `BrandDealService/ListPartnerships` response period projection | "1/4 – 30/4/2026" | "—" |
| Deliverable title | `BrandDealService/ListPartnerships` response `deliverables[]` projection | String | — |
| Deliverable platform | `BrandDealService/ListPartnerships` response `deliverables[]` projection | Platform icon | — |
| Due date | `BrandDealService/ListPartnerships` response `deliverables[]` projection | Relative or absolute date | "Chưa đặt deadline" |
| Deliverable status | `BrandDealService/ListPartnerships` response `deliverables[]` projection | Checkbox + status text | "pending" |
| Payment status | `BrandDealService/ListPartnerships` response payment projection | Badge | "pending" |
| Expected payment date | `BrandDealService/ListPartnerships` response payment projection | "15/4/2026" | "—" |
| Performance | `content_performance` linked | Views + engagement | "Chưa có dữ liệu" |

---

## 6. User Actions

| # | Action | Trigger | Type | API Call | System Response | Navigation |
|---|---|---|---|---|---|---|
| 1 | Add new deal | "+ Thêm deal" | Primary CTA | — | Open Create Deal modal | — (modal) |
| 2 | Mark deliverable done | "Mark done" button | Inline | `BrandDealService/UpdateDeliverable(status=completed)` | Checkbox fills, progress bar updates, toast "Đã hoàn thành deliverable" | — |
| 3 | View performance | "📊 Stats" | Secondary | — | Open analytics side panel | — (panel) |
| 4 | Contact brand | "💬 Contact Brand" | Secondary | — | Open thread in Inbox | → W046 |
| 5 | Upload proof | "📎 Upload Proof" | Inline | `ProofService/UploadEvidence` | File picker → upload → attach to proof bundle | — |
| 6 | View contract | "📄 Contract" | Inline | — | Open contract PDF/viewer | — (modal) |
| 7 | Export report | "📤 Export" | Inline | `ReportService/ExportPartnershipReport` | Download PDF report | — |
| 8 | Edit partnership | Click card header | Navigation | — | Open partnership detail drawer | — (drawer) |
| 9 | Toggle completed section | "Expand ▾" | Toggle | — | Expand/collapse completed partnerships | — |

---

## 7. Validation Rules

### Create Deal Modal
| Field | Rule | Error Message |
|---|---|---|
| Brand name | Required, 2-100 chars | "Vui lòng nhập tên thương hiệu" |
| Campaign title | Required, 2-200 chars | "Vui lòng nhập tên chiến dịch" |
| Value | Required, positive number | "Giá trị phải lớn hơn 0" |
| Start date | Required, today or future | "Ngày bắt đầu phải từ hôm nay trở đi" |
| End date | Required, after start date | "Ngày kết thúc phải sau ngày bắt đầu" |
| At least 1 deliverable | Required | "Cần ít nhất 1 deliverable" |

### Mark Done Validation
- Cannot mark done without at least one proof artifact (screenshot, link, or file)
- Auto-prompts for proof upload if marking done without proof

---

## 8. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Card shimmer skeletons (2-3 cards) |
| LOADED | Data received | Partnership cards with full data |
| EMPTY | No partnerships exist | Empty state: "Chưa có partnership nào. Khi bạn nhận deal từ brand, chúng sẽ hiển thị ở đây. [+ Thêm deal thủ công]" |
| ERROR | API failed | Error banner: "Không tải được partnerships. [Thử lại]" |
| DEADLINE_WARNING | Deliverable due within 48h | Card shows pulsing ⏰ icon on overdue/near-due items |
| PAYMENT_OVERDUE | Payment past expected date | Payment badge turns 🔴 with "Quá hạn thanh toán" |

---

## 9. Permissions & Role-based Behavior

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer |
|---|---|---|---|---|---|---|
| View partnerships | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Create partnership | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Mark deliverable done | ✅ | ✅ | ✅ | ✅ (own) | ❌ | ❌ |
| Upload proof | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Edit partnership | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Delete partnership | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| View payment details | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Export report | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

---

## 10. Edge Cases

| Edge Case | Handling |
|---|---|
| All deliverables completed | Card shows "✅ Tất cả deliverables hoàn thành" + payment status becomes primary focus |
| Partnership period expired with pending deliverables | 🔴 "Quá hạn" badge. Overdue items highlighted red. |
| Payment received | Update payment status → "✅ Đã thanh toán" + amount confirmed badge |
| Brand contact not in CRM | "💬 Contact" creates new thread + adds brand as contact |
| No connected platform for deliverable | Deliverable shows "⚫ Nền tảng chưa kết nối" warning |

---

## 11. Tier Gating

- Free: Cannot use Creator Pro → redirect to upsell
- Starter: 3 active partnerships max
- Pro: 20 active partnerships max
- Business: Unlimited

---

## 12. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached partnership data | Retry online |
| Deliverable mark fail | API error on mark done | Toast: "Không cập nhật được. [Thử lại]" + checkbox reverts | Retry |
| Proof upload fail | File too large or API error | Toast: "Upload thất bại. Tối đa 50MB." | Re-upload |
| Export report fail | PDF generation error | Toast: "Không tạo được báo cáo. [Thử lại]" | Retry |
| Platform not connected | Deliverable has unconnected platform | Inline: "⚫ Nền tảng chưa kết nối. [→ Kết nối]" | Navigate |

---

## 13. Accessibility

| Element | Requirement |
|---|---|
| Partnership cards | `role="article"`, `aria-label="{brand} — {campaign}, {status}"` |
| Deliverable progress | `role="progressbar"`, `aria-valuenow`, `aria-valuemax`, `aria-label="{done} of {total} deliverables"` |
| Deliverable checklist | `role="list"`, checkbox items with `aria-label="{deliverable}: {status}"` |
| Payment badge | `aria-label="Payment: {status}"` |
| Completed section | `aria-expanded`, `aria-controls` on toggle |

---

## 14. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Summary bar + card skeletons |
| Summary stats | 100-300ms | Counts + value populate |
| Partnership cards | 300-600ms | Cards stagger with progress bars |
| Deliverables | 400-700ms | Checklists populate per card |
| Performance stats | 500-800ms | Async per completed deliverable |

---

## 15. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `partnerships.viewed` | Page load | `active_count`, `total_value`, `upcoming_deadlines` |
| `partnerships.deal_created` | "+ Thêm deal" confirmed | `brand`, `value`, `deliverable_count` |
| `partnerships.deliverable_completed` | "Mark done" | `partnership_id`, `deliverable_type`, `days_remaining` |
| `partnerships.proof_uploaded` | "📎 Upload Proof" | `partnership_id`, `file_type`, `file_size` |
| `partnerships.stats_viewed` | "📊 Performance Stats" | `partnership_id` |
| `partnerships.brand_contacted` | "💬 Contact Brand" | `partnership_id` |
| `partnerships.report_exported` | "📤 Export Report" | `partnership_id` |
| `partnerships.payment_updated` | Payment status change | `partnership_id`, `new_status`, `amount` |

---

## 16. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/creator-pro/partnerships/+page.svelte`
- **Server load**: `+page.server.ts` → `BrandDealService/ListPartnerships(workspace_id, status)` + `BrandDealService/GetSummary`
- **Deliverables**: `BrandDealService/UpdateDeliverable(id, status)` → optimistic UI, reverts on error
- **Proof upload**: `ProofService/UploadEvidence(partnership_id, file)` → S3 presigned URL
- **Performance**: Lazy-loaded per completed deliverable from `ContentPerformanceService/GetStats(content_id)`
- **Export**: Server generates PDF via `ReportService/ExportPartnershipReport(id)` → download
- **Completed section**: Lazy-loaded on expand, cursor-paginated
- **Contact brand**: Creates thread in Unified Inbox (W046) with brand as participant

---

## 17. Localization Notes

- Status: "🟢 Đang hoạt động", "🟡 Đang thực hiện", "🔵 Chờ thanh toán", "⚪ Hoàn thành"
- Deliverables: "đã hoàn thành", "còn {n} ngày", "⚠️ quá hạn"
- Payment: "💰 Chờ thanh toán", "✅ Đã thanh toán", "🔴 Quá hạn"
- Values: VND "5.000.000đ" or "5M VND"
- Tone: Professional, task-oriented

---

## 18. Design Tokens

| Token | Usage |
|---|---|
| `--color-partnership-active` | 🟢 Active status |
| `--color-partnership-progress` | 🟡 In Progress |
| `--color-partnership-payment` | 🔵 Payment Pending |
| `--color-success` | ✅ Completed, paid |
| `--color-danger` | 🔴 Overdue payment/deliverable |
| `--color-warning` | ⏰ Deadline approaching |
| `--color-accent` | Add deal CTA |
| `--color-surface-elevated` | Partnership cards |
| `--font-metric` | Values, dates (tabular-nums) |

---

## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W088] Creator Pro Dashboard | Parent screen |
| [W089] Media Kit Editor | Completed partnerships feed into portfolio |
| [W090] Sponsor Inquiries | Accepted inquiries become partnerships |
| [W046] Unified Inbox | Brand contact communication |
| [M046] Mobile Brand Deals | Mobile equivalent |

---

## 20. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (deliverable mark, proof upload), card/progress a11y, 8 analytics, SvelteKit impl (proof upload, export), localization, 9 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
