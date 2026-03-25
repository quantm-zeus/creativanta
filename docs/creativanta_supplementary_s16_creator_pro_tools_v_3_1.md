# Creativanta — Supplementary Spec S16 — Creator Pro Tools & Monetization v3.1

## 0. Traceability Header

- **Upstream**: PRD §37.1 (Content ROI), §38 (P2 Brand Collaboration), Product Freeze §30 (Operator Modes)
- **Canonical objects touched**: User Profile, Asset, Publish Item, Revenue Record, Brand Deal, Media Kit, Rate Card
- **Pack dependencies**: Pack 01 (FE UX), Pack 02 (Schema), Pack 06 (Commerce/Finance)
- **Scope**: v1 core creator tools. Brand deal CRM pipeline và contract templates là P2.

---

## 1. Mục tiêu

Cung cấp công cụ chuyên nghiệp giúp creator monetize hiệu quả hơn, tối ưu thu nhập, và chuyên nghiệp hóa hình ảnh khi làm việc với brands.

---

## 2. Link-in-Bio Builder

### 2.1 Chức năng
- Tạo landing page cá nhân với links quan trọng
- Custom URL: `creativanta.link/{username}`
- Drag-drop reorder links
- Link types: URL, product, video, social profile, download, email

### 2.2 Design Contract
- Template styles: ≥ 5 built-in themes
- Custom colors, fonts, avatar, background image
- Brand kit integration (nếu user có)
- Mobile-responsive, load time ≤ 1s
- Analytics: views, clicks, CTR per link

### 2.3 Schema

```
LinkInBioPage:
  id: UUID
  workspace_id: FK → Workspace
  slug: string (unique)
  title: string
  bio: text (≤ 300 chars)
  avatar_url: string
  theme: enum(minimal, bold, gradient, dark, custom)
  custom_css: json (nullable)
  links: LinkItem[]
  analytics_enabled: boolean
  created_at, updated_at: timestamp

LinkItem:
  id: UUID
  page_id: FK → LinkInBioPage
  type: enum(url, product, video, social, download, email)
  label: string
  url: string
  icon: string (nullable)
  thumbnail_url: string (nullable)
  position: integer
  clicks: integer (counter)
  is_active: boolean
```

### 2.4 Domain Protection & Anti-Abuse

> **Context**: Shared domain `creativanta.link` có rủi ro bị platform blacklist nếu spammer lạm dụng.

**Anti-abuse rules:**
- Link destination content pre-check: khi user thêm link mới, system scan URL đích cho malware/phishing/adult content (Google Safe Browsing API)
- Links vi phạm AUP (Legal §10): flagged → warning → remove nếu không sửa trong 48h
- Mass link creation throttle: max 20 links/ngày/workspace (chống spam bot)
- Report link: bất kỳ ai truy cập `creativanta.link` page có thể report link vi phạm

**Custom domain (Pro+ tiers):**
- Pro/Business/Enterprise: hỗ trợ custom domain (VD: `links.brand.com`)
- Custom domain setup: CNAME record → verification → SSL auto-provision
- Lợi ích: isolated domain reputation, branding chuyên nghiệp, không bị ảnh hưởng bởi shared domain blacklist
- Free/Starter: chỉ dùng `creativanta.link/{username}`

**Shared domain reputation monitoring:**
- Monitor `creativanta.link` reputation score trên Google Safe Browsing, VirusTotal, platform blocklists
- Alert ops nếu domain bị flag trên bất kỳ blocklist nào
- Emergency: suspend tất cả Link-in-Bio pages vi phạm AUP nếu shared domain bị threatened

---

## 3. Media Kit Auto-Generator

### 3.1 Chức năng
- Tự động tạo media kit (PDF/web page) từ workspace data
- Pull real-time metrics từ connected platforms
- Shareable link hoặc download PDF
- Update tự động khi metrics thay đổi

### 3.2 Media Kit Content

| Section | Data Source | Auto-populated |
|---|---|---|
| Creator overview | User profile | ✅ |
| Platform stats | Connected accounts API | ✅ |
| Audience demographics | Platform analytics | ✅ |
| Top performing content | Publish log + analytics | ✅ |
| Rate card | User-defined (AI suggested) | Partial |
| Past collaborations | Brand deals (P2) | Manual input (v1) |
| Contact information | User profile | ✅ |

### 3.3 Design
- ≥ 3 professional templates
- Brand kit auto-applied (colors, fonts, logo)
- Custom sections (add/remove/reorder)
- AI credit cost: 3–5 credits per generation

---

## 4. Rate Card Builder

### 4.1 Chức năng
- Tạo bảng giá dịch vụ cho brand collaborations
- AI gợi ý pricing dựa trên metrics và industry benchmarks

### 4.2 Rate Card Items

| Service Type | AI Pricing Basis |
|---|---|
| Sponsored post (static) | Followers × engagement rate × niche multiplier |
| Sponsored video (short) | Views avg × completion rate × niche |
| Sponsored video (long) | Views avg × watch time × niche |
| Story/Reel mention | Followers × story view rate |
| Product review | Followers × trust score × conversion reference |
| Live shoutout | Live avg viewers × engagement |
| Bundle deal | Sum of items × discount % |

### 4.3 Schema

```
RateCard:
  id: UUID
  workspace_id: FK → Workspace
  currency: enum(VND, USD, ...)
  items: RateCardItem[]
  ai_suggested_at: timestamp (nullable)
  custom_note: text

RateCardItem:
  id: UUID
  rate_card_id: FK → RateCard
  service_type: string
  price_min: decimal
  price_max: decimal
  ai_suggested_price: decimal (nullable)
  description: text
  delivery_time: string
```

---

## 5. Revenue Per Content Tracker

### 5.1 Chức năng (extends PRD §37.1 Content ROI)
- Dashboard hiển thị revenue attribution per content piece
- UTM auto-tagging khi publish qua Creativanta
- Correlation: content → clicks → orders → revenue → profit
- **Video Production Mode tracking**: attribute revenue to source content AND derivatives (clips, remixes)

### 5.2 Metrics Per Content

| Metric | Source | Calculation |
|---|---|---|
| Views | Platform API | Direct |
| Engagement | Platform API | Likes + comments + shares + saves |
| Link clicks | UTM tracking | Creativanta tracked |
| Orders attributed | Affiliate/UTM correlation | Order count with matching UTM |
| Revenue attributed | Order values | Sum of order values |
| Cost to produce | AI credits + estimated time | System tracked |
| **Production mode** | M07 metadata | Quick Edit / Clip Factory / Multi-Merge / AI Remix |
| **Source content ROI** | Derivative tracking | Revenue from all clips/remixes → attributed to source |
| **ROI %** | Computed | (Revenue - Cost) / Cost × 100% |
| **RPM** | Computed | Revenue / (Views / 1000) |

### 5.3 RPM Tracking
- RPM (Revenue Per Mille) tính per platform, per content type
- Trend chart: RPM over time (weekly/monthly)
- Benchmark: so sánh RPM với average (anonymized, nếu có data)
- Alert: RPM drop > 20% so với previous period → notification

---

## 6. Brand Deal Management (v1 Scope — Simplified)

### 6.1 v1 Scope (Simplified Pipeline)
- Basic brand deal log (manual entry)
- Fields: brand name, deal type, value, status, deadline, deliverables
- Status: negotiating → agreed → in-progress → delivered → paid → completed
- Calendar integration: deadlines hiển thị trên content calendar

### 6.2 Schema

```
BrandDeal:
  id: UUID
  workspace_id: FK → Workspace
  brand_name: string
  contact_email: string (nullable)
  deal_type: enum(sponsored_post, product_review, ambassador, affiliate, custom)
  value: decimal
  currency: string
  status: enum(negotiating, agreed, in_progress, delivered, paid, completed, cancelled)
  deadline: date
  deliverables: text
  notes: text
  created_at, updated_at: timestamp
```

### 6.3 P2 Scope (Deferred)
- Brand deal CRM pipeline (kanban board)
- Contract template library
- Brand deal valuation AI
- Auto-invoice generation for brand deals
- Brand collaboration marketplace

---

## 7. Tax Report Export

### 7.1 Chức năng
- Export báo cáo thu nhập cho mục đích kê khai thuế
- Periods: monthly, quarterly, yearly
- Formats: PDF, Excel (XLSX), CSV

### 7.2 Report Content
- Total revenue per platform
- Total revenue per source (affiliate, sponsorship, product sales)
- AI credit expenses
- Subscription expenses
- Net income before tax
- Transaction detail list

---

## 8. FE/UX Contract

### 8.1 Navigation
- Creator Pro Tools gom trong section "Monetization" trên sidebar
- Sub-items: Link-in-Bio, Media Kit, Rate Card, Brand Deals, Revenue, Tax Export

### 8.2 Mode Availability
- Creator Mode: full access
- Seller Mode: Revenue + Tax Export only
- Agency Mode: per-creator views
- Affiliate Mode: Revenue + Rate Card
- Brand Collab Mode: full access
- Beginner Mode: guided unlock (progressive disclosure)

### 8.3 Tier Gating

| Feature | Free | Starter | Pro | Business |
|---|---|---|---|---|
| Link-in-Bio | ✅ (3 links) | ✅ (10 links) | ✅ (unlimited) | ✅ |
| Link-in-Bio Custom Domain | ❌ | ❌ | ✅ | ✅ |
| Media Kit | ❌ | ✅ (1 template) | ✅ (all templates) | ✅ + custom |
| Rate Card AI | ❌ | ❌ | ✅ | ✅ |
| Revenue per Content | ✅ (basic) | ✅ | ✅ (with RPM) | ✅ |
| Brand Deals | ❌ | ✅ (5 deals) | ✅ (unlimited) | ✅ |
| Tax Export | ❌ | ✅ | ✅ | ✅ |

---

## 9. Acceptance Scenarios

- Creator tạo Link-in-Bio page → share link → analytics hiển thị views/clicks
- Creator generate Media Kit → download PDF → metrics auto-populated
- Creator dùng Rate Card AI → pricing gợi ý dựa trên metrics thực
- Creator log brand deal → track deliverables → mark completed → revenue recorded
- Creator view Revenue per Content → thấy top ROI content → AI suggest "tạo thêm dạng này"
- Creator export Tax Report → file Excel/PDF correct tổng thu nhập
- Creator thêm link trong Link-in-Bio → system scan URL đích → phishing detected → warning hiển thị → user chọn remove hoặc override
- Spammer lạm dụng Link-in-Bio → AUP violation detected → warning → không sửa trong 48h → link bị remove
- Pro user setup custom domain → CNAME verified → SSL provisioned → Link-in-Bio page live trên custom domain
- Shared domain reputation drop → ops alerted → AUP violators suspended → reputation recovers
