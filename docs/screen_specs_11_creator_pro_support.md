# Screen Specs 11 — Creator Pro & Support (M16)

> **Upstream**: Product Freeze §28-29, A1 Schema (creator_profiles, sponsor_inquiries, creator_assignments, brand_profiles)
> **Screens**: 11 web + 5 mobile screens
> **Screen Numbers**: §104-§114 (per screen_index.md canonical numbering)

---

## 104. Creator Pro Dashboard

**Route**: `/creator-pro`
**Purpose**: Creator-specific dashboard — media kit, brand partnerships, sponsorship tracking, creator analytics.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🌟 Creator Pro                                                   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ KPI Row ───────────────────────────────────────────────────┐ │
│ │ 📊 Avg Engagement │ 👥 Total Reach │ 💰 Sponsor Rev  │ ⭐  │ │
│ │ 6.2%              │ 1.2M (30d)     │ 8.5M VND        │4.8  │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ Tabs: [Overview] [Media Kit] [Partnerships] [Inquiries]         │
│                                                                  │
│ ── Overview ──                                                   │
│ ┌─ Active Partnerships ──────────────────────────────────────┐ │
│ │ 🤝 Brand ABC · Campaign "Summer Launch" · [🟢 Active]      │ │
│ │    3/5 deliverables completed · Due: 30/3                   │ │
│ │    [→ View deliverables]                                     │ │
│ │                                                              │ │
│ │ 🤝 Brand XYZ · Sponsorship · [🟡 Negotiating]              │ │
│ │    Offer: 5M VND for 3 videos · [→ View inquiry]            │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Upcoming Deliverables ─────────────────────────────────────┐ │
│ │ ☐ Brand ABC — Video review (due 28/3)    [✏️ Start]        │ │
│ │ ☐ Brand ABC — Story mention (due 30/3)    [✏️ Start]        │ │
│ │ ✅ Brand ABC — Reel (completed 25/3)      [📊 Stats]        │ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

---

## 105. Media Kit Editor

**Route**: `/creator-pro/media-kit`
**Purpose**: Build and share a professional media kit — stats, audience demographics, portfolio, pricing.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Creator Pro   📋 Media Kit Editor          [👁 Preview] [📤]  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Header ────────────────────────────────────────────────────┐ │
│ │ [Photo] [Name] [Tagline]                                    │ │
│ │ "Content creator chuyên về ẩm thực & lifestyle"            │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Statistics (auto-synced) ──────────────────────────────────┐ │
│ │ TikTok: 50K followers · 6.2% eng · 1.2M reach/mo          │ │
│ │ Instagram: 25K followers · 4.1% eng · 450K reach/mo        │ │
│ │ YouTube: 12K subscribers · 5.8% eng                         │ │
│ │ [🔄 Refresh stats] [Last updated: 1d ago]                   │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Audience Demographics ─────────────────────────────────────┐ │
│ │ Age: 18-24 (45%) · 25-34 (35%) · 35-44 (15%) · 45+ (5%)   │ │
│ │ Gender: Female 62% · Male 38%                                │ │
│ │ Top cities: HCMC (30%), Hanoi (25%), Da Nang (10%)          │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Best Content (portfolio) ──────────────────────────────────┐ │
│ │ [Drag-sortable grid of top posts/videos]                    │ │
│ │ [Thumb1] 24K views · [Thumb2] 18K · [Thumb3] 15K           │ │
│ │ [+ Add content]                                              │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Pricing (editable) ───────────────────────────────────────┐ │
│ │ TikTok video (60s): [2,000,000 VND]                         │ │
│ │ Instagram Reel: [1,500,000 VND]                              │ │
│ │ YouTube video: [5,000,000 VND]                               │ │
│ │ Story mention: [500,000 VND]                                 │ │
│ │ Bundle (3 videos): [5,000,000 VND]                           │ │
│ │ [+ Add pricing item]                                         │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Share ─────────────────────────────────────────────────────┐ │
│ │ Public link: https://creativanta.vn/k/nguyenquan             │ │
│ │ [📋 Copy link] [📧 Email to brand] [📥 Download PDF]        │ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

---

## 106. Sponsor Inquiries

**Route**: `/creator-pro/inquiries`
**Purpose**: Manage incoming sponsor/brand inquiries with status tracking.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 📨 Sponsor Inquiries                         Pending: 3         │
├──────────────────────────────────────────────────────────────────┤
│ Tabs: [New (3)] [Negotiating (2)] [Accepted (5)] [Declined (1)]│
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Inquiry ───────────────────────────────────────────────────┐ │
│ │ 📨 Brand ABC — "Summer skincare campaign"                   │ │
│ │ Budget: 5M VND · Type: 3 TikTok videos + 2 IG stories     │ │
│ │ Timeline: April 1-30 · Received: 2d ago                     │ │
│ │ Contact: marketing@brandabc.com                              │ │
│ │ [👁 View brief] [✅ Accept] [💬 Negotiate] [❌ Decline]     │ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Accept | "✅ Accept" | `SponsorInquiryService/Update(accepted)` | → Create campaign from inquiry |
| Negotiate | "💬 Negotiate" | — | → Email draft / in-app messaging |
| Decline | "❌ Decline" → reason | `SponsorInquiryService/Update(declined)` | Archived |
| View brief | "👁 View brief" | — | Drawer with full brief |

---

## 107. Partnership Manager

**Route**: `/creator-pro/partnerships`
**Purpose**: Active partnerships — deliverables, deadlines, payments.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🤝 Active Partnerships                                            │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Partnership Card ───────────────────────────────────────┐ │
│ │ 🤝 Brand ABC — "Summer Skincare"          [🟢 Active]       │ │
│ │ Value: 5,000,000 VND · Period: April 1-30                  │ │
│ │ Deliverables: 3/5 completed                                │ │
│ │ ☑ TikTok video 60s (completed 25/3)                        │ │
│ │ ☑ Instagram Reel (completed 27/3)                           │ │
│ │ ☑ Product unboxing (completed 28/3)                         │ │
│ │ ☐ IG Story mention ×2 (due 30/3)                            │ │
│ │ Payment: [🟡 Pending] · Expected: 15/4                       │ │
│ │ [→ Deliverables] [📊 Stats] [💬 Contact brand]              │ │
│ └──────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

---

## 108. Link-in-Bio Builder

**Route**: `/creator-pro/link-in-bio`
**Purpose**: Create and manage a personal landing page at `creativanta.link/{username}` with analytics.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Creator Pro   🔗 Link-in-Bio          [👁 Preview] [📤 Share] │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Live Preview (40%) ─────┐  ┌─ Editor (60%) ─────────────────┐│
│ │ [Phone frame mockup]      │  │                                 ││
│ │ ┌──────────────────┐      │  │ ┌─ Profile ──────────────────┐ ││
│ │ │ [Avatar]         │      │  │ │ Avatar: [📎 Upload]        │ ││
│ │ │ Nguyễn Quân      │      │  │ │ Name: [Nguyễn Quân     ]  │ ││
│ │ │ Content creator  │      │  │ │ Bio: [Content creator     │ ││
│ │ │ ẩm thực & beauty │      │  │ │  chuyên ẩm thực & beauty] │ ││
│ │ │                  │      │  │ └────────────────────────────┘ ││
│ │ │ [🎬 YouTube]     │      │  │                                 ││
│ │ │ [🛍 TikTok Shop] │      │  │ ┌─ Links (drag to reorder) ─┐ ││
│ │ │ [📸 Instagram]   │      │  │ │ ☰ 🎬 YouTube channel      │ ││
│ │ │ [💬 Liên hệ]     │      │  │ │   URL: [youtube.com/...] │ ││
│ │ │                  │      │  │ │   Type: [URL ▾] [🟢 On]  │ ││
│ │ └──────────────────┘      │  │ │   Clicks: 342             │ ││
│ │                            │  │ │                            │ ││
│ │ Updates in real-time      │  │ │ ☰ 🛍 TikTok Shop          │ ││
│ └────────────────────────────┘  │ │   URL: [tiktok.com/...]  │ ││
│                                  │ │   Type: [Product ▾]      │ ││
│                                  │ │                            │ ││
│                                  │ │ [+ Thêm link mới]         │ ││
│                                  │ └────────────────────────────┘ ││
│                                  │                                 ││
│                                  │ ┌─ Theme ──────────────────┐   ││
│                                  │ │ [Minimal] [Bold] [Gradient│   ││
│                                  │ │ [Dark] [Custom]           │   ││
│                                  │ │ Colors: [Primary ██]     │   ││
│                                  │ │         [Background ██]  │   ││
│                                  │ └────────────────────────────┘ ││
│                                  │                                 ││
│                                  │ ┌─ Custom Domain (Pro+) ───┐   ││
│                                  │ │ URL: creativanta.link/... │   ││
│                                  │ │ [Setup custom domain →]  │   ││
│                                  │ └────────────────────────────┘ ││
│                                  └──────────────────────────────── ┘│
│                                                                  │
│ ┌─ Analytics (bottom section) ────────────────────────────────┐  │
│ │ Total views: 1,234 (7d) · Total clicks: 342 · CTR: 27.7%  │  │
│ │ Top link: YouTube (45% clicks) · Devices: 📱 78% · 💻 22%  │  │
│ │ [📊 View full analytics]                                    │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ [Lưu] [📤 Copy link] [📧 Send to brand]                        │
└──────────────────────────────────────────────────────────────────┘
```

### Link Types
| Type | Icon | Behavior |
|---|---|---|
| URL | 🔗 | External link with Safe Browsing check |
| Product | 🛍 | Opens product page, shows price |
| Video | 🎬 | Embedded video preview |
| Social | 📱 | Platform icon, follows link |
| Download | 📥 | Direct download |
| Email | 📧 | Opens mailto: |

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Add link | "+ Thêm link" | — (client) | New link row appears |
| Reorder links | Drag ☰ handle | `LinkInBioService/Reorder` | Links reorder |
| Delete link | Swipe left / ✕ | `LinkInBioService/DeleteLink` | Link removed |
| Toggle link | ON/OFF toggle | `LinkInBioService/ToggleLink` | Link hidden/shown |
| Change theme | Click theme card | `LinkInBioService/UpdateTheme` | Preview updates |
| Preview | 👁 Preview | — | New tab: `creativanta.link/{slug}` |
| Share | 📤 Share | — | Share sheet / copy URL |
| Setup domain | "Setup custom" | → | Modal: CNAME instructions |
| Save | "Lưu" | `LinkInBioService/Save` | Toast: "Đã lưu" |

### States
- **Empty**: No links — "Thêm link đầu tiên để chia sẻ với audience"
- **Tier-gated**: Free (max 3 links) — inline upsell when adding 4th
- **URL safety blocked**: Red warning — "Link này bị phát hiện không an toàn"

---

## 109. Rate Card Builder

**Route**: `/creator-pro/rate-card`
**Purpose**: Build pricing table for brand collaborations with AI-suggested rates.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Creator Pro   💰 Bảng giá dịch vụ        [📤 Share] [📥 PDF] │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Currency: [VND ▾]                [🤖 AI Suggest — 3 credits]    │
│                                                                  │
│ ┌─ Rate Card Items (editable table) ─────────────────────────┐  │
│ │ Dịch vụ              │ Giá min    │ Giá max    │ AI suggest │  │
│ │─────────────────────────────────────────────────────────── │  │
│ │ TikTok video (60s)   │ 2,000,000  │ 3,000,000  │ 2,500,000 │  │
│ │ Instagram Reel       │ 1,500,000  │ 2,000,000  │ 1,800,000 │  │
│ │ YouTube video (10m)  │ 5,000,000  │ 8,000,000  │ 6,200,000 │  │
│ │ Story mention        │   300,000  │   500,000  │   400,000 │  │
│ │ Product review       │ 3,000,000  │ 5,000,000  │ 3,800,000 │  │
│ │ Live shoutout        │ 1,000,000  │ 2,000,000  │ 1,500,000 │  │
│ │ Bundle (3 videos)    │ 5,000,000  │ 7,000,000  │ 6,000,000 │  │
│ │ [+ Thêm dịch vụ]                                           │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ AI Pricing Basis (shown after AI suggest) ────────────────┐  │
│ │ Based on:                                                    │  │
│ │ • 50K followers × 6.2% engagement × skincare niche (1.2x)  │  │
│ │ • Market benchmark: similar creators charge 1.5-3M/video   │  │
│ │ 💡 "Bạn có engagement cao hơn average — giá có thể cao hơn" │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Custom Note ──────────────────────────────────────────────┐  │
│ │ [Ghi chú thêm cho brands: delivery time, revisions, etc.] │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ [Lưu] [Embed in Media Kit] [📥 Export PDF]                      │
└──────────────────────────────────────────────────────────────────┘
```

---

## 110. Revenue Per Content

**Route**: `/creator-pro/revenue`
**Purpose**: Revenue attribution per content piece — track ROI of every video/post.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Creator Pro   💰 Revenue per Content    [Period: 30d ▾]       │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Summary KPIs ─────────────────────────────────────────────┐  │
│ │ Total Rev    │ Avg RPM    │ Top ROI     │ Content count    │  │
│ │ 45.2M VND   │ 18,500đ   │ 342%        │ 23 pieces        │  │
│ │ ↑22% vs prev │ ↑8%       │ "5 tips..."  │ 18 video + 5 post│  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ RPM Trend Chart ──────────────────────────────────────────┐  │
│ │ [Line chart: RPM over time, per-platform color coded]      │  │
│ │ [━ TikTok] [━ YouTube] [━ Instagram] [━ Shopee]            │  │
│ │ ⚠ RPM dropped 25% on TikTok (last 7d)                     │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Sort: [Revenue ▾] [ROI ▾] [RPM ▾] [Views ▾]                    │
│                                                                  │
│ ┌─ Content Revenue Card ─────────────────────────────────────┐  │
│ │ 🎬 "5 tips nấu ăn nhanh"   │ TikTok · 25/3              │  │
│ │ 👁 24.3K views · ❤ 890 eng  │ Mode: Quick Edit            │  │
│ │ 🔗 342 link clicks          │ UTM: tracked ✅             │  │
│ │ 📦 12 orders attributed     │ Revenue: 3.58M VND          │  │
│ │ 💸 Production cost: 25 cr (≈$0.75)                        │  │
│ │ 📊 ROI: 342% · RPM: 18,500đ                              │  │
│ │ Derivatives: 3 clips → +1.2M additional revenue            │  │
│ │ [📊 Full breakdown] [Source content → original video]      │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Content Revenue Card ─────────────────────────────────────┐  │
│ │ 🎬 "Review serum VitC"     │ YouTube · 23/3              │  │
│ │ 👁 12.1K views · ❤ 234 eng │ Mode: Clip Factory            │  │
│ │ 📦 5 orders attributed     │ Revenue: 1.49M VND           │  │
│ │ 📊 ROI: 198% · RPM: 12,300đ                              │  │
│ │ [📊 Full breakdown]                                        │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Change period | Period dropdown | `RevenueService/GetPerContent` | Data refreshes |
| Sort | Column click | — (client) | Cards reorder |
| Full breakdown | "📊 Full breakdown" | — | Drawer: UTM→clicks→orders→revenue funnel |
| View source | "Source content" link | — | → `/publish/[id]` |
| Export report | Top-right ⋮ → Export | `ReportService/ExportRevenue` | CSV/PDF download |

---

## 111. Brand Deal Manager

**Route**: `/creator-pro/deals`
**Purpose**: Basic brand deal tracking (v1) — manual entry with status pipeline.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Creator Pro   🤝 Brand Deals          [+ Thêm deal] [Filter]  │
├──────────────────────────────────────────────────────────────────┤
│ Pipeline:                                                        │
│ [Negotiating(2)] → [Agreed(1)] → [In-progress(1)] →             │
│ [Delivered(3)] → [Paid(5)] → [Completed(8)]                     │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Deal Card ────────────────────────────────────────────────┐  │
│ │ 🤝 Brand ABC — "Summer skincare campaign"                  │  │
│ │ Type: Sponsored post · Value: 5,000,000 VND                │  │
│ │ Status: [🟡 In-progress] · Deadline: 30/3/2026            │  │
│ │ Deliverables:                                               │  │
│ │ ☑ TikTok video 60s (completed 25/3)                        │  │
│ │ ☐ Instagram Reel (due 28/3)                                │  │
│ │ ☐ 2x Story mentions (due 30/3)                             │  │
│ │ Contact: marketing@brandabc.com                             │  │
│ │ [→ Detail] [💬 Contact] [📊 Stats]                        │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Deal Card ────────────────────────────────────────────────┐  │
│ │ 🤝 Brand XYZ — "Product launch"                            │  │
│ │ Type: Product review · Value: 3,000,000 VND + product      │  │
│ │ Status: [🟢 Paid] · Completed: 20/3/2026                  │  │
│ │ Revenue recorded ✅ · Proof bundle linked ✅               │  │
│ │ [→ Detail] [📊 Stats]                                     │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Calendar integration ──                                       │
│ Deal deadlines appear on Content Calendar (screen §45)           │
└──────────────────────────────────────────────────────────────────┘
```

### Deal Status State Machine
```
negotiating → agreed → in_progress → delivered → paid → completed
    │                       │              │
    └→ cancelled            └→ cancelled   └→ disputed
```

---

## 112. Tax Report Export

**Route**: `/creator-pro/tax-export`
**Purpose**: Export income reports for tax filing — monthly/quarterly/yearly.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Creator Pro   📊 Báo cáo thuế                                 │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Period Selection ─────────────────────────────────────────┐  │
│ │ Loại: [● Tháng] [○ Quý] [○ Năm]                           │  │
│ │ Kỳ:   [Tháng 3/2026 ▾]                                    │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Income Summary ───────────────────────────────────────────┐  │
│ │ Nguồn                    │ Thu nhập       │ Tỷ trọng      │  │
│ │─────────────────────────────────────────────────────────── │  │
│ │ Affiliate (TikTok Shop)  │ 15,200,000     │ 33.6%         │  │
│ │ Affiliate (Shopee)       │ 8,400,000      │ 18.6%         │  │
│ │ Brand sponsorship        │ 12,000,000     │ 26.5%         │  │
│ │ Product sales            │ 6,800,000      │ 15.0%         │  │
│ │ Membership               │ 2,850,000      │ 6.3%          │  │
│ │─────────────────────────────────────────────────────────── │  │
│ │ Tổng thu nhập brutto     │ 45,250,000     │ 100%          │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Expense Summary ──────────────────────────────────────────┐  │
│ │ AI Credits consumed      │ -380,000                         │  │
│ │ Subscription (Pro plan)  │ -699,000                         │  │
│ │ Credit purchases         │ -250,000                         │  │
│ │ Tổng chi phí             │ -1,329,000                       │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Net Income ───────────────────────────────────────────────┐  │
│ │ Thu nhập ròng trước thuế: 43,921,000 VND                   │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Format: [PDF ●] [Excel ○] [CSV ○]                               │
│ [📥 Export] [📧 Gửi qua email]                                  │
└──────────────────────────────────────────────────────────────────┘
```

### States
- **No data**: "Chưa có dữ liệu thu nhập trong kỳ này"
- **Partial data**: Warning banner "⚠ Một số nền tảng chưa sync — báo cáo có thể chưa đầy đủ"
- **Processing**: "Đang tạo báo cáo..." with skeleton

---

## 113. Support Center

**Route**: `/support`
**Purpose**: Help center + support ticket system.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🆘 Trung tâm hỗ trợ                                            │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Search ────────────────────────────────────────────────────┐ │
│ │ [🔍 Tìm kiếm hướng dẫn, FAQ...]                            │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Quick Help Categories ─────────────────────────────────────┐ │
│ │ 🚀 Getting Started │ 🔗 Connections │ 📤 Publishing         │ │
│ │ 💰 Billing         │ 🤖 AI Studio   │ 📊 Analytics          │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ My Tickets ────────────────────────────────────────────────┐ │
│ │ [🟢 Open] "Shopee sync vẫn chậm" — 2d ago                 │ │
│ │ [✅ Resolved] "Không đăng được lên TikTok" — 5d ago        │ │
│ │ [+ Tạo ticket mới]                                          │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Popular Articles ──────────────────────────────────────────┐ │
│ │ 📝 Cách kết nối TikTok Shop                                │ │
│ │ 📝 Hướng dẫn tạo video AI đầu tiên                        │ │
│ │ 📝 Cách đọc báo cáo lợi nhuận                             │ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

---

## 114. Help Article Viewer

**Route**: `/support/articles/[slug]`
**Purpose**: Render individual help article with related articles, contextual navigation, feedback, and search.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Trung tâm hỗ trợ   📖 Cách kết nối TikTok Shop               │
├──────────────────────────┬───────────────────────────────────────┤
│ Sidebar (25%)            │ Article Content (75%)                  │
│                          │                                        │
│ ┌─ In This Article ───┐ │ ┌─ Breadcrumb ──────────────────────┐ │
│ │ ▸ Yêu cầu trước     │ │ │ Hỗ trợ > Connectors > TikTok     │ │
│ │ ▸ Bước 1: Tạo shop  │ │ └──────────────────────────────────┘ │
│ │ ▸ Bước 2: Kết nối   │ │                                      │
│ │ ▸ Bước 3: Xác thực  │ │ # Cách kết nối TikTok Shop          │
│ │ ▸ Xử lý lỗi thường │ │ ✏️ Cập nhật: 25/3/2026 · ⏱ 5 phút  │
│ │   gặp                │ │                                      │
│ └─────────────────────┘ │ ## Yêu cầu trước khi bắt đầu        │
│                          │ ✅ Tài khoản TikTok Business          │
│ ┌─ Related Articles ──┐ │ ✅ Shop đã đăng ký trên TikTok Shop  │
│ │ 📝 Fix lỗi 401      │ │                                      │
│ │ 📝 Sync đơn hàng    │ │ ## Bước 1: Tạo shop trên TikTok     │
│ │ 📝 API rate limits  │ │ [Screenshot: TikTok Shop setup]      │
│ └─────────────────────┘ │ 1. Vào TikTok Seller Center...       │
│                          │ 2. Chọn "Register as seller"...      │
│                          │                                      │
│                          │ > 💡 **Tip**: Nếu đã có shop, bỏ    │
│                          │ > qua bước này.                      │
│                          │                                      │
│                          │ ## Bước 2: Kết nối trong Creativanta │
│                          │ [Screenshot: Connection page]         │
│                          │ 1. Vào Settings > Connections...      │
│                          │ 2. Click "Kết nối TikTok Shop"...    │
│                          │                                      │
│                          │ ## Xử lý lỗi thường gặp              │
│                          │ | Lỗi | Nguyên nhân | Cách xử lý |  │
│                          │ | 401 | Token hết hạn | Re-auth |   │
│                          │ | 429 | Rate limit | Chờ 15 phút |  │
│                          │                                      │
│                          │ ┌─ Feedback ──────────────────────┐  │
│                          │ │ Bài viết này có hữu ích không?  │  │
│                          │ │ [👍 Có] [👎 Không]              │  │
│                          │ │ 89% thấy hữu ích (234 phản hồi)│  │
│                          │ └──────────────────────────────────┘  │
│                          │                                      │
│                          │ [📤 Chia sẻ bài viết] [📧 Gửi email]│
│                          │ [Vẫn cần giúp đỡ? → Tạo ticket]     │
└──────────────────────────┴───────────────────────────────────────┘
```

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Navigate TOC | Click sidebar heading | — (anchor scroll) | Smooth scroll to section |
| Rate article | 👍/👎 | `KBService/RateArticle` | Feedback saved, thank you message |
| View related | Click related article | — | → `/support/articles/[slug]` |
| Share | "Chia sẻ" | — | Share sheet / copy URL |
| Create ticket | "Tạo ticket" | — | → `/support/new?context=[slug]` |
| Search | Top-bar search | `KBService/Search` | → Search results overlay |

### States
- **Loading**: Article skeleton with heading + paragraph shimmer
- **Not found**: "Bài viết không tồn tại hoặc đã bị xóa. [← Quay lại hỗ trợ]"
- **Outdated**: Yellow banner "Bài viết này có thể đã cũ. Cập nhật lần cuối: {date}"


## Mobile Screens

### M40. Mobile Creator Pro
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Creator Pro                                    🔔 👤           │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ KPI Summary (horizontal scroll) ─────────────────────────┐   │
│ │ [💰 Revenue    ] [📦 Active Deals] [⭐ Rating        ]    │   │
│ │ [25.6M ▲12%   ] [5 deals        ] [4.8/5.0          ]    │   │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Active Partnerships ──────────────────────────────────────┐   │
│ │ ┌── Deal Card ──────────────────────────────────────────┐  │   │
│ │ │ [Brand logo] Brand ABC               [🟢 In Progress] │  │   │
│ │ │ 📦 3/5 deliverables done · Due: 30/3                  │  │   │
│ │ │ 💰 5.5M VND · [Progress bar ████░░ 60%]               │  │   │
│ │ └──────────────────────────────────────────────────────────┘│   │
│ │                                                              │   │
│ │ ┌── Deal Card ──────────────────────────────────────────┐  │   │
│ │ │ [Brand logo] Beauty XYZ              [🟡 Deliverable]  │  │   │
│ │ │ 📦 1/3 deliverables done · Due: 5/4                   │  │   │
│ │ │ 💰 3.2M VND · [Progress bar ██░░░░ 33%]               │  │   │
│ │ └──────────────────────────────────────────────────────────┘│   │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Deliverable Checklist ────────────────────────────────────┐   │
│ │ ☑ Video review (uploaded 25/3)                              │   │
│ │ ☑ Story mention (posted 26/3)                               │   │
│ │ ⬜ Carousel post (due 30/3)                                 │   │
│ │ [Submit deliverable →]                                      │   │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
├─ Bottom Nav ─────────────────────────────────────────────────────┤
│ [🏠 Home] [💡 Ideas] [🎬 Studio] [💬 Inbox] [📊 More]         │
└──────────────────────────────────────────────────────────────────┘
```

#### M40 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| View deal | Tap card | — | → Deal detail with full brief |
| Submit deliverable | "Submit" | `BrandDealService/SubmitDeliverable` | Deliverable sent for review |
| Pull-to-refresh | Pull down | Refetch all | Data refreshed |

### M41. Mobile Support
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Hỗ trợ                                                        │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Search ────────────────────────────────────────────────────┐  │
│ │ [🔍 Tìm bài hướng dẫn hoặc hỏi AI...]                     │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Category Grid (2 columns) ────────────────────────────────┐  │
│ │ ┌──────────────┐  ┌──────────────┐                          │  │
│ │ │ 🔌 Connector │  │ 🤖 AI Studio │                          │  │
│ │ │  5 articles  │  │  8 articles  │                          │  │
│ │ └──────────────┘  └──────────────┘                          │  │
│ │ ┌──────────────┐  ┌──────────────┐                          │  │
│ │ │ 📦 Commerce  │  │ 💰 Billing   │                          │  │
│ │ │  12 articles │  │  6 articles  │                          │  │
│ │ └──────────────┘  └──────────────┘                          │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ My Tickets ───────────────────────────────────────────────┐   │
│ │ #T-789 · "Kết nối TikTok" · 🟡 Đang xử lý · 3h ago        │   │
│ │ #T-785 · "Lỗi thanh toán"  · ✅ Đã giải quyết · 2d ago    │   │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ [+ Tạo ticket mới]                                               │
│ [💬 Chat trực tiếp]                                              │
└──────────────────────────────────────────────────────────────────┘
```

#### M41 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Search KB | Type in search | `KBService/Search` | Article results |
| View category | Tap | — | → Article list |
| Create ticket | "Tạo ticket" | — | → `/support/new` |
| View ticket | Tap ticket | — | → Ticket detail |
| Chat support | "Chat" | `SupportService/OpenChat` | Live chat overlay |

### M49. Mobile Link-in-Bio
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Link in Bio                        [👁 Preview] [📤 Share]    │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Profile Header ───────────────────────────────────────────┐  │
│ │ [Avatar] · [Display name] · [Bio text]                      │  │
│ │ [✏️ Edit profile]                                           │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Link List (drag to reorder) ──────────────────────────────┐  │
│ │ ⠿ 🛍️ Shopee Store              [🟢] [✏️] [👁 23 clicks]  │  │
│ │ ⠿ 🎬 Latest Video               [🟢] [✏️] [👁 45 clicks]  │  │
│ │ ⠿ 📧 Contact Me                 [🟢] [✏️] [👁 12 clicks]  │  │
│ │ ⠿ 🎁 Discount Code              [🔴] [✏️] [👁 0 clicks]   │  │
│ │ [+ Add link]                                                 │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Theme (horizontal scroll) ────────────────────────────────┐  │
│ │ [Dark ●] [Light ○] [Gradient ○] [Neon ○] [Custom ○]        │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Analytics Summary ────────────────────────────────────────┐  │
│ │ Total clicks: 80 (7d) · Unique visitors: 45 · CTR: 12%    │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### M50. Mobile Brand Deals
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Brand Deals                                                    │
├──────────────────────────────────────────────────────────────────┤
│ ┌─ Pipeline Chips (horizontal scroll) ──────────────────────┐   │
│ │ [All 8] [Proposed 2] [Active 3] [Delivered 2] [Paid 1]    │   │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Deal Card ─────────────────────────────────────────────────┐  │
│ │ [Brand logo] Brand ABC                    [🟢 Active]       │  │
│ │ Campaign: "Summer Launch" · 5.5M VND                        │  │
│ │ 📦 3/5 deliverables · Due: 30/3                             │  │
│ │ [📋 Checklist] [📧 Contact brand]                           │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Deal Card ─────────────────────────────────────────────────┐  │
│ │ [Brand logo] Beauty XYZ                   [🟡 Proposed]     │  │
│ │ Campaign: "Holiday Bundle" · 3.2M VND                       │  │
│ │ Deadline to accept: 2d left                                 │  │
│ │ [✅ Accept] [❌ Decline] [📧 Negotiate]                     │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Swipe right → "Contact brand"                                    │
│ Pull-to-refresh                                                  │
└──────────────────────────────────────────────────────────────────┘
```

#### M50 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Filter pipeline | Tap chip | — | List filtered |
| View deal | Tap card | — | → Deal detail |
| Accept deal | "Accept" | `BrandDealService/Accept` | Status → Active |
| Contact brand | Swipe right or button | — | → Composer |
| Set reminder | Long press → "Remind me" | `ReminderService/Create` | Push notification scheduled |

### M51. Mobile Media Kit Preview
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Media Kit                              [📤 Share] [✏️ Edit]   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Preview Card (scrollable) ────────────────────────────────┐  │
│ │ [Avatar + Name + Bio]                                       │  │
│ │                                                              │  │
│ │ 📊 Audience Stats                                           │  │
│ │ TikTok: 125K followers · Instagram: 45K · YouTube: 12K     │  │
│ │                                                              │  │
│ │ 📈 Engagement                                               │  │
│ │ Avg views: 50K · Avg likes: 5K · ER: 4.5%                 │  │
│ │                                                              │  │
│ │ 👤 Demographics                                              │  │
│ │ [Pie chart: Age] [Pie chart: Gender] [Map: Location]        │  │
│ │                                                              │  │
│ │ 🏆 Past Collaborations                                      │  │
│ │ Brand ABC · Brand XYZ · Brand 123                           │  │
│ │                                                              │  │
│ │ 📋 Rate Card                                                │  │
│ │ Video review: 3-5M · Story: 500K · Carousel: 2M            │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Share Options ─────────────────────────────────────────────┐  │
│ │ [📱 WhatsApp] [💬 Zalo] [📧 Email] [📋 Copy link]          │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ 🔄 Last synced: 2h ago · [Sync now]                              │
└──────────────────────────────────────────────────────────────────┘
```

#### M51 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Share | Share buttons | `ShareService/Share` | Link shared |
| Copy link | "Copy link" | — | Clipboard + toast |
| Edit | "Edit" | — | → Web editor (deep link) |
| Sync | "Sync now" | `MediaKitService/Sync` | Stats refreshed |
