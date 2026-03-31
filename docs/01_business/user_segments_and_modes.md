---
layer: business
canonical: true
source: creativanta_prd_v_3_1_revised_part_1.md (§8, §20)
last_updated: 2026-03-30
---

# User Segments & Operator Modes

---

## 1. 7 User Segments

### Solo Creator
- **Mô tả**: Cá nhân tự tạo content, publish, bán offer, gắn affiliate, theo dõi revenue/profit
- **Primary Objects**: Idea, Script, Asset, Publish Item, Thread, Offer
- **Use case**: Một người làm tất cả — từ nghĩ idea đến đếm lời

### Affiliate Creator / KOC / KOL
- **Mô tả**: Nghiên cứu trend, chọn sản phẩm, tạo content, gắn link/coupon, tối ưu conversion
- **Primary Objects**: Opportunity, Product, Offer, Affiliate Link, Campaign, Profit Snapshot
- **Use case**: Kiếm tiền từ commission bằng cách quảng bá sản phẩm của người khác

### Seller / Seller Team
- **Mô tả**: Quản lý sản phẩm, tồn kho, offers, live, inbox, doanh thu, lợi nhuận
- **Primary Objects**: Product, SKU, Offer, Order, Thread, Profit Snapshot
- **Use case**: Vận hành cửa hàng trên nhiều nền tảng, theo dõi profit thật

### Live Commerce Team
- **Mô tả**: Quản lý live plan, pin offer, cue, comment, highlight, post-live follow-up
- **Primary Objects**: Live Session, Cue Card, Thread, Offer, Highlight
- **Use case**: Chạy live bán hàng như một phòng chiến, cần tốc độ và coordination

### Agency / MCN / Team Ops
- **Mô tả**: Quản lý nhiều workspace, creator, client, approvals, performance proof, templates
- **Primary Objects**: Workspace, Approval Request, Script, Asset, Report, Workflow
- **Use case**: Điều phối đội ngũ creator, đảm bảo chất lượng và delivery

### Community / Digital Product Creator
- **Mô tả**: Bán membership, digital product, bundle, lead magnet, sponsor inventory
- **Primary Objects**: Membership Plan, Bundle, Offer, Store Page, Campaign
- **Use case**: Xây community và monetize bằng sản phẩm số

### Sponsor / Brand Collaboration Operator
- **Mô tả**: Quản lý sponsor deal, deliverable, proof, invoice, payout, performance evidence
- **Primary Objects**: Sponsor Inquiry, Campaign, Publish Item, Proof Bundle, Invoice, Creator Payout
- **Use case**: Làm việc với brands, cần proof rõ ràng cho deliverables

---

## 2. 6 Operator Modes

App phải hỗ trợ 6 mode chính. Mỗi mode thay đổi **UX emphasis**, không cắt domain scope.

### Creator Mode
- **DB enum**: `creator`
- **Dashboard priorities**: ideas, scripts, assets, publish, comments, earnings snapshot
- **Primary Objects**: Idea, Script, Asset, Publish Item, Thread, Offer
- **Mobile-critical loops**: review script, approve asset, quick publish, quick reply

### Seller Mode
- **DB enum**: `seller`
- **Dashboard priorities**: products, offers, inventory, inbox, profit, anomalies
- **Primary Objects**: Product, SKU, Offer, Order, Thread, Profit Snapshot
- **Mobile-critical loops**: quick offer edit, thread triage, stock alert action, profit anomaly follow-up

### Affiliate Operator Mode
- **DB enum**: `affiliate_operator`
- **Dashboard priorities**: opportunities, products, packaging, links/coupons, attributed revenue/profit
- **Primary Objects**: Opportunity, Product, Offer, Affiliate Link, Campaign, Profit Snapshot
- **Mobile-critical loops**: quick idea capture, coupon/link share, reply-to-conversion flows

### Live Operator Mode
- **DB enum**: `live_operator`
- **Dashboard priorities**: live war room, cue, offer pinning, comment triage, highlights, post-live summary
- **Primary Objects**: Live Session, Cue Card, Thread, Offer, Highlight
- **Mobile-critical loops**: live monitoring, quick cue, highlight mark, urgent reply

### Agency / MCN Mode
- **DB enum**: `agency_mcn`
- **Dashboard priorities**: workspace switching, approvals, creator scorecards, reports, templates
- **Primary Objects**: Workspace, Approval Request, Script, Asset, Report, Workflow
- **Mobile-critical loops**: approvals, urgent diagnostics, summary review

### Brand Collaboration Mode
- **DB enum**: `brand_collaboration`
- **Dashboard priorities**: sponsor inquiries, deliverables, campaign proof, invoice/payout tracking, performance evidence
- **Primary Objects**: Sponsor Inquiry, Campaign, Publish Item, Proof Bundle, Invoice, Creator Payout
- **Mobile-critical loops**: approve deliverable, inspect proof, status update, sponsor follow-up

---

## 3. Operator Mode Contract

Mỗi mode **bắt buộc** phải định nghĩa rõ 8 fields sau:

| Field | Mô tả |
|---|---|
| **Dashboard priorities** | Nội dung và thứ tự ưu tiên trên home surface |
| **Default navigation emphasis** | Menu items nào nổi bật nhất |
| **Daily Brief logic** | Card selection priorities cho Daily Brief |
| **Terminology emphasis** | Thuật ngữ ưu tiên hiển thị (vd: "orders" vs "content") |
| **Recommended recipes** | Workflow/recipe mặc định gợi ý cho mode |
| **Alert priorities** | Loại alert nào urgent nhất cho mode |
| **Primary objects** | Objects nào user tương tác nhiều nhất |
| **Mobile-critical loops** | Actions nào phải nhanh trên mobile |

> Nếu thiếu bất kỳ field nào, mode chưa đầy đủ.

---

## 4. Tier Capacity Table

| Dimension | Free | Starter | Pro | Business | Enterprise |
|---|---|---|---|---|---|
| **AI Credits/month** | 50 | 500 | 2,000 | 10,000 | Custom |
| **Connected Accounts** | 2 | 5 | 15 | 50 | Unlimited |
| **Workspace Members** | 1 | 2 | 5 | 20 | Custom |
| **Operator Modes** | 1 | 2 | All | All | All |

> Chi tiết đầy đủ: [pricing_and_credits.md](./pricing_and_credits.md)

---

## 5. Mobile-First Rules

### One Product, Two Real Execution Surfaces
Web và mobile đều là execution surfaces thật — không có chuyện mobile chỉ để xem.

### Mobile Must Support
- Review scripts
- Approve assets
- Quick publish flows theo capability
- Reply flows
- Live monitoring và highlight management
- Offer quick edits
- Task triage
- Inspect profit anomalies và assign follow-up

### UX Principles (Web + Mobile)
- **Workflow over dashboard** — dẫn user theo task flow, không chỉ hiện số
- **Object-first navigation** — navigate theo object thật, không chỉ menu taxonomy
- **Trust by visibility** — mọi số liệu phải show source + confidence
- **Fast operator ergonomics** — power-user flow phải nhanh
- **Progressive disclosure** — non-tech user không bị overwhelm
