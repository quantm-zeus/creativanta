# Creativanta — Legal / Compliance / Consent / Liability Contract v3.1

## 0. Traceability Header

- **Upstream sections used**: PRD §28 (Security/Privacy/Reliability), §30 (Packaging/Pricing), §37 (Architecture Decisions), Product Freeze §46A.
- **Canonical objects touched**: Workspace, Connected Account, User Account, Billing Event, Consent Record, Policy Note, Audit Event, Data Export Request.
- **New objects introduced**: Consent Record, Legal Document Version, Platform Policy Snapshot, Liability Disclaimer Record, Data Export Request, Content License Record.
- **Acceptance scenarios inherited**: data privacy, user consent, platform policy change handling, liability limitation, service availability, content IP ownership, data portability, EU AI Act compliance.
- **Cross-ref**: S26 (Internal Admin) §12 — GDPR compliance tools (data subject requests, deletion workflow, breach notification) vận hành từ admin site.

---

## 1. Mục tiêu

Pack này khóa toàn bộ khung pháp lý, consent management, liability protection và compliance cho Creativanta — bảo vệ cả platform lẫn user khỏi rủi ro pháp lý khi:
- Nền tảng bên thứ ba (TikTok, Shopee, YouTube...) thay đổi API/policy
- Tính năng bị degraded hoặc ngừng hoạt động
- AI generation tạo nội dung có rủi ro
- Dữ liệu tài chính hiển thị không chính xác
- User vi phạm chính sách nền tảng bên thứ ba

---

## 2. Terms of Service (ToS) Contract

### 2.1 ToS Structure bắt buộc

| Section | Nội dung |
|---|---|
| **Definitions** | Định nghĩa rõ: Workspace, User, Operator, Connected Account, AI Generated Content, Third-Party Platform |
| **Service Description** | Mô tả rõ Creativanta là tool hỗ trợ, KHÔNG phải đại diện (agent) của user trên nền tảng bên thứ ba |
| **Account Terms** | Đăng ký, xác thực, trách nhiệm bảo mật tài khoản |
| **Acceptable Use** | Hành vi được phép và bị cấm |
| **Intellectual Property** | Quyền sở hữu nội dung: user giữ IP, Creativanta được license để xử lý |
| **AI Content Disclaimer** | AI output là gợi ý, user chịu trách nhiệm cuối cùng |
| **Third-Party Integration** | Creativanta không chịu trách nhiệm cho thay đổi API/policy của nền tảng bên thứ ba |
| **Service Level** | "As-is" service, không guarantee uptime 100% |
| **Limitation of Liability** | Cap liability, exclude indirect/consequential damages |
| **Termination** | Điều kiện chấm dứt dịch vụ, data retention |
| **Dispute Resolution** | Luật áp dụng, cơ chế giải quyết tranh chấp |
| **Changes to Terms** | Quy trình thông báo thay đổi ToS |

### 2.2 Critical Liability Clauses

#### 2.2.1 Third-Party Platform Dependency Disclaimer
```
Creativanta sử dụng API và dịch vụ của các nền tảng bên thứ ba (bao gồm 
nhưng không giới hạn: TikTok, YouTube, Instagram, Shopee, Lazada, Facebook).

Creativanta KHÔNG đảm bảo rằng:
- Các tính năng phụ thuộc vào nền tảng bên thứ ba sẽ luôn khả dụng
- Thay đổi chính sách/API của nền tảng bên thứ ba sẽ không ảnh hưởng đến 
  chức năng của Creativanta
- Dữ liệu từ nền tảng bên thứ ba sẽ luôn chính xác và kịp thời

Khi nền tảng bên thứ ba thay đổi chính sách hoặc API, Creativanta sẽ:
1. Thông báo cho user trong vòng 48 giờ
2. Cung cấp workaround hoặc manual fallback khi có thể
3. Cập nhật tính năng trong thời gian hợp lý
4. KHÔNG hoàn tiền cho dịch vụ bị ảnh hưởng bởi thay đổi từ bên thứ ba
```

#### 2.2.2 AI Content Liability Shield
```
Nội dung được tạo bởi AI (bao gồm video, script, hình ảnh, text) là GỢI Ý.
User có trách nhiệm:
- Kiểm tra nội dung trước khi xuất bản
- Đảm bảo nội dung tuân thủ chính sách của nền tảng đích
- Đảm bảo nội dung không vi phạm bản quyền bên thứ ba
- Đảm bảo nội dung tuân thủ luật pháp địa phương

Creativanta KHÔNG chịu trách nhiệm cho:
- Nội dung AI bị nền tảng gỡ hoặc phạt
- Vi phạm bản quyền do AI reference materials
- Tổn thất doanh thu do nội dung AI không phù hợp
```

#### 2.2.3 Financial Data Disclaimer
```
Dữ liệu tài chính (doanh thu, lợi nhuận, chi phí) được hiển thị dựa trên:
- Source class taxonomy (Official / Imported / Inferred / Estimated / Unreconciled)
- Confidence bands tương ứng

Creativanta KHÔNG phải là dịch vụ kế toán hoặc tư vấn tài chính.
Số liệu hiển thị KHÔNG thay thế sổ sách kế toán chính thức.
User không nên dựa vào số liệu "Estimated" hoặc "Unreconciled" để ra 
quyết định tài chính quan trọng.
```

#### 2.2.4 Service Availability Clause
```
Creativanta cung cấp dịch vụ trên cơ sở "as available".
Target uptime: 99.5% (không phải guarantee).
Planned maintenance: thông báo trước 24 giờ.
Unplanned outage: best-effort recovery, thông báo qua status page.

Trong trường hợp ngừng dịch vụ:
- Dưới 4 giờ liên tục: không có bồi thường
- 4-24 giờ liên tục: credit tương đương 1 ngày subscription
- Trên 24 giờ liên tục: credit tương đương 3 ngày subscription
- Trên 72 giờ liên tục: credit tương đương 1 tháng subscription

Credit chỉ áp dụng cho paid plans và không quy đổi thành tiền mặt.
```

### 2.3 ToS Change Management
- Thay đổi nhỏ (typo, clarification): thông báo in-app, hiệu lực ngay
- Thay đổi trung bình (scope adjustment): thông báo email + in-app, 15 ngày trước hiệu lực
- Thay đổi lớn (liability, pricing, data use): thông báo email + in-app + banner, 30 ngày trước hiệu lực
- User tiếp tục sử dụng sau thời gian thông báo = đồng ý với ToS mới
- User có quyền chấm dứt trước khi ToS mới có hiệu lực

---

## 3. Privacy Policy Contract

### 3.1 Data Collection Categories

| Category | Data | Legal Basis |
|---|---|---|
| Account data | Email, name, password hash, workspace info | Contract performance |
| Connected account data | OAuth tokens, platform handles, scopes | Legitimate interest + consent |
| Content data | Scripts, assets, ideas, publish items | Contract performance |
| Commerce data | Orders, revenue, costs, settlements | Contract performance |
| Usage data | Features used, pages visited, session duration | Legitimate interest |
| Device data | Browser, OS, IP, device type | Legitimate interest |
| AI interaction data | Prompts, generation requests, feedback | Contract performance + consent |
| Communication data | Support tickets, feedback | Contract performance |

### 3.2 Data Processing Rules
- Data chỉ xử lý cho purposes đã khai báo
- Third-party data processors phải có DPA (Data Processing Agreement)
- AI training: user data KHÔNG được dùng để train AI models chung mà không có explicit consent
- Cross-workspace data isolation bắt buộc
- Data retention: active data giữ suốt subscription, deleted data purge sau 30 ngày, backup purge sau 90 ngày

### 3.3 Data Subject Rights
- Right to access: export data trong 30 ngày
- Right to rectification: sửa data qua workspace settings
- Right to erasure: yêu cầu xóa data, xử lý trong 30 ngày
- Right to portability: export JSON/CSV
- Right to object: opt-out marketing, analytics
- Right to restrict processing: tạm dừng xử lý data

### 3.4 International Data Transfer
- Data storage primary: Southeast Asia region (Singapore/Vietnam)
- Cross-border transfer: Standard Contractual Clauses (SCCs) khi cần
- PDPA (Vietnam), PDPA (Thailand), PDP (Indonesia) compliance
- GDPR compliance cho EU users nếu có

---

## 4. Cookie & Tracking Consent Contract

### 4.1 Cookie Categories

| Category | Purpose | Consent Required |
|---|---|---|
| **Strictly Necessary** | Authentication, security, load balancing | NO (essential) |
| **Functional** | Language preference, theme, saved views | NO (legitimate interest) |
| **Analytics** | Usage tracking, performance monitoring | YES |
| **Marketing** | Conversion tracking, retargeting | YES |

### 4.2 Consent Banner Requirements
- Hiển thị ngay lần đầu truy cập
- Phải có nút "Accept All", "Reject All", và "Customize"
- "Customize" phải chi tiết từng cookie category
- Consent lưu 12 tháng, sau đó hỏi lại
- Consent record lưu với timestamp, IP, user agent, choices
- Withdraw consent phải dễ dàng như grant consent

### 4.3 Tracking Transparency
- User phải biết analytics nào đang active
- No tracking trước consent (trừ strictly necessary)
- Cookie policy page phải liệt kê tất cả cookies, purpose, duration, provider

### 4.4 Third-Party Tracking
- Facebook Pixel, Google Analytics, TikTok Pixel: chỉ load sau consent
- Connected platform tracking: separate consent category
- Affiliate tracking cookies: disclose duration và purpose

---

## 5. Platform Policy Compliance Engine

### 5.1 Mục tiêu
Creativanta phải giúp user KHÔNG vi phạm chính sách các nền tảng bên thứ ba.

### 5.2 Platform Policy Snapshot Object
```
- policy_snapshot_id
- platform (TikTok, YouTube, Shopee, Instagram, Facebook, Lazada...)
- policy_version
- policy_areas[] (content, commerce, music, hashtag, AI, live, disclosure)
- key_rules_summary
- last_updated
- change_diff_from_previous (nếu có)
- source_url
- impact_assessment (none / low / medium / high / critical)
```

### 5.3 Policy Change Monitoring
- Scheduled crawl policy pages mỗi 24 giờ
- Manual review bổ sung khi có tin tức về platform changes
- Change detection → tạo Policy Change Alert
- Impact assessment tự động → notification tới affected workspaces

### 5.4 Content Policy Pre-Check (M10)

#### 5.4.1 Pre-Publish Compliance Scan
Trước khi publish, hệ thống phải check:

| Check | Platform | Action |
|---|---|---|
| Music copyright | TikTok, YouTube, Instagram | Warn if unlicensed music detected |
| Hashtag limit | TikTok (max 5 from Aug 2025) | Block if > limit |
| Commercial disclosure | All | Warn if #ad/#sponsored missing for branded content |
| Banned keywords | Shopee (competitor names), TikTok | Flag and suggest alternatives |
| AI content label | TikTok, YouTube | Remind to label AI-generated content |
| Image/video dimensions | All | Auto-check format compatibility |
| Duration limits | TikTok (60s music cap) | Warn if music exceeds platform limit |
| Product claim check | Shopee, TikTok Shop | Flag potentially misleading claims |
| Age/region restrictions | All | Flag content that may be restricted |
| Nudity/violence check | All | AI scan + flag + block |

#### 5.4.2 Pre-Check Results
- pass: safe to publish
- pass_with_warnings: publishable with acknowledged warnings
- review_required: manual review needed
- blocked: cannot publish, must fix

#### 5.4.3 Post-Publish Monitoring
- Track if published content gets flagged/removed by platform
- Log platform penalties (strikes, reduced reach, demonetization)
- Suggest corrective actions
- Feed back into content policy training

### 5.5 Live Stream Compliance (M17)
- TikTok Live: creator accountable for ALL content during live (including third-party tools)
- Music restriction check: only official library allowed for live (from Jul 2025)
- Real-time moderation warning: flag potentially violating comments/content
- Post-live compliance summary

---

## 6. AI Usage Consent & Transparency

### 6.1 AI Disclosure Requirements
- User phải được thông báo khi nội dung được AI generate/edit
- AI-generated labels bắt buộc trước khi publish lên platforms yêu cầu
- Lineage record phải track: human input → AI processing → human review → final output

### 6.2 AI Data Usage Consent
- Explicit opt-in cho: sử dụng user content để improve AI models
- Default: OFF (user data KHÔNG dùng để train)
- Separate consent cho: anonymized usage analytics
- User có thể withdraw AI training consent bất cứ lúc nào

### 6.3 AI Output Warranty Disclaimer
- AI output không có warranty về accuracy, originality, hoặc platform compliance
- User phải review trước khi publish

### 6.5 AI Remix Studio — Legal Framework

> **Ref**: Pack 04 §9.5 (AI Remix Contract), ADR-011

#### 6.5.1 Fair Use / Structure Learning
- AI Remix **chỉ học cấu trúc** (hook type, pacing, scene structure) từ reference video — KHÔNG copy footage, audio, hoặc script
- Legal basis: learning structure/format is not copying copyrightable expression (format/structure không được copyright protection trong hầu hết jurisdiction)
- Creativanta **không lưu trữ** reference video footage — chỉ lưu analysis data (JSON metadata)
- Reference video chỉ dùng trong session hiện tại cho analysis, không archive

#### 6.5.2 Originality Requirements
| Safeguard | Threshold | Enforcement |
|---|---|---|
| **Script similarity** | Output < 30% similarity vs reference | Automated check, block if exceeded |
| **Transcript copy** | 0% direct copy allowed | LLM + text comparison |
| **Footage reuse** | 0% — KHÔNG lấy bất kỳ frame nào | Architecture enforced (only metadata passed) |
| **Audio reuse** | 0% — always gen new voice/music | Architecture enforced |
| **Overall originality** | Block if > 70% total similarity | Multi-factor similarity scoring |

#### 6.5.3 User Responsibility Declaration
Khi user bắt đầu AI Remix, hệ thống hiển thị disclaimer:
```
Bằng cách sử dụng AI Remix, bạn xác nhận:
1. Video bạn sử dụng làm tham chiếu KHÔNG vi phạm quyền sở hữu trí tuệ
   của bạn khi được phân tích cấu trúc
2. Bạn chịu trách nhiệm đảm bảo output content phù hợp với
   chính sách platform bạn publish lên
3. AI chỉ học CẤU TRÚC (format, pacing, hook type) — KHÔNG copy nội dung
4. Output được tạo hoàn toàn mới bằng AI generation
```
User phải accept (checkbox + confirm) trước khi bắt đầu Phase 1.

#### 6.5.4 Platform-Specific Derivative Content Policies
| Platform | Policy | Creativanta Compliance |
|---|---|---|
| **TikTok** | Cho phép "duet" và "trend participation". Cấm "freebooting" (repost nguyên video). | ✅ Remix tạo content mới, không repost |
| **YouTube** | Fair use doctrine. "Transformative" content được bảo vệ. | ✅ Remix output là transformative (new script, new visuals) |
| **Instagram Reels** | Cho phép inspired content. Cấm exact copy. | ✅ No footage/audio reuse |
| **General** | Nếu reference owner DMCA claim → Creativanta comply ngay | DMCA compliance process (§7 existing) |

#### 6.5.5 Anti-Abuse Controls
- Max 20 remixes/day/workspace (rate limiter)
- Flag mass-cloning patterns (>50 remixes/week from unique sources → review)
- Block remixing content flagged as "children/minor" detection
- Block remixing content đã bị DMCA claim trong hệ thống
- Audit trail: mọi remix action logged với reference source + output + similarity scores

#### 6.5.6 AI Content Disclosure cho Remixed Video
- User option: auto-label "AI-assisted content" trên output video
- Mandatory labeling cho platforms yêu cầu (YouTube, EU jurisdictions)
- C2PA metadata embedded nếu applicable (EU AI Act Art.50)
- AI-generated financial insights không thay thế professional financial advice
- AI-assisted content editing không guarantee platform approval

### 6.6 Extended Features Legal Framework (Pack 04 §9.6-9.16)

#### 6.6.1 Product Showcase Studio
- **Virtual Try-On ethics**: AI model body proportions must be realistic (no unrealistic body standards)
- **Product representation**: generated video must not misrepresent product (size, color, features phải gần đúng thực tế)
- **Price accuracy**: nếu price tag auto-filled từ Product Hub, phải match current price (no stale data)
- **Third-party imagery**: user upload ảnh SP → Creativanta không claim ownership, user responsible cho product photography rights

#### 6.6.2 Link-to-Video Generator
- **Product claim accuracy**: AI-generated script KHÔNG được exaggerate product claims beyond source data
- **Review fairness**: khi compile reviews, phải include balanced sentiment (không chỉ chọn 5-star)
- **Platform scraping**: comply với từng marketplace's ToS cho data scraping (cache only, no bulk)
- **Price verification**: scraped price phải ghi rõ "giá tại thời điểm tạo video" disclaimer

#### 6.6.3 AI Translation Studio
- **Cultural sensitivity**: LLM translation phải avoid culturally offensive translations, slang review
- **Accuracy disclaimer**: "Bản dịch AI — khuyên user review trước khi publish" warning
- **Voice cloning for dubbing**: user consent required nếu dubbing voice giống ai đó (applies existing Character consent flow)
- **Content liability**: user vẫn chịu trách nhiệm nội dung sau khi dịch (liability không transfer sang Creativanta)

#### 6.6.4 AI Performance Coach
- **Data accuracy**: metrics phải từ REAL platform API, không estimate/hallucinate
- **No guaranteed results**: disclaimer "AI coaching suggestions are based on data patterns, results not guaranteed"
- **Competitor data**: chỉ dùng anonymized, aggregated benchmarks (không expose cụ thể ai)

#### 6.6.5 Gamification System
- **No gambling mechanics**: XP/credits reward KHÔNG dựa trên chance/luck (deterministic only)
- **Streak pressure**: streak notifications có hard cap (max 2 reminders/day), user opt-out available
- **Minor protection**: nếu user < 18 tuổi, gamification pressure giảm (fewer notifications)

### 6.4 EU AI Act Compliance Detail (Article 50 — Effective Aug 2026)

#### 6.4.1 AI Content Labeling Requirements
- **Visible indicator**: "AI-assisted" badge on all AI-generated/edited content within Creativanta UI
- **Machine-readable metadata**: C2PA standard tagging embedded in exported images/videos
- **Label format**: dual-layer — visible label for humans + metadata for machines
- **Exemption**: content with substantial human editorial review may skip visible label (human oversight must be documented)

#### 6.4.2 Risk Classification cho Creativanta AI Features

| AI Feature | Risk Tier | Requirements |
|---|---|---|
| Script generation | Minimal | Transparency disclosure |
| AI video editing | Minimal | Content labeling |
| Product description AI | Minimal | Transparency disclosure |
| Trend prediction | Minimal | Source data disclosure |
| Compliance scan | Limited | Accuracy monitoring |
| Financial insights AI | Limited | "Not financial advice" disclaimer, human review flag |
| Inbox auto-reply | Limited | User notification that AI is responding |

#### 6.4.3 AI System Documentation
- AI model provider documentation: version, capabilities, known limitations
- Data processing documentation: what user data flows to AI providers
- Output quality monitoring: monthly accuracy sampling
- Incident logging: AI content flagged/removed by platforms

#### 6.4.4 AI Literacy
- In-app tooltips explaining AI capabilities and limitations
- Onboarding flow includes "How Creativanta uses AI" section
- Clear distinction between AI-generated content and human-created content

---

## 6A. Content Ownership & AI IP Contract

### 6A.1 User Content Ownership
- **User-created content** (scripts, ideas, strategies): 100% user-owned IP
- Creativanta receives a **limited license** to process, display, and store content within the platform
- License terminates upon account deletion
- User retains all commercial rights to content created on Creativanta

### 6A.2 AI-Generated Content Ownership
- **AI-generated content** (scripts, video edits, descriptions): user is the beneficial owner for commercial purposes
- Creativanta does NOT claim copyright on AI-generated outputs
- Under US Copyright Office guidance: purely AI-generated content may not qualify for copyright protection
- User assumes responsibility for any IP claims arising from AI-generated content
- Hybrid content (human + AI co-creation) may qualify for partial copyright — user documenting human creative input

### 6A.3 Content Usage Rights
- User may use ALL content created within Creativanta for commercial purposes without additional licensing fees
- Creativanta may use anonymized, aggregated insights from content patterns (NOT content itself) to improve AI models — only with explicit consent
- User's uploaded assets (brand logos, product photos, video footage): remain user IP, Creativanta does NOT gain redistribution rights

### 6A.4 Content After Account Deletion
- Content already published on third-party platforms: platform-specific rules apply, Creativanta has no control
- Content stored on Creativanta: deleted per data portability contract (§14A)
- Shared recipes/templates: anonymized or removed within 30 days

### 6A.5 UGC & Shared Content License
- Recipes/templates shared publicly: CC-BY-SA 4.0 unless creator specifies otherwise
- Marketplace content (sold templates): commercial license terms defined per listing
- Creativanta receives display and distribution rights for marketplace listings only

---

## 7. Third-Party Integration Liability Contract

### 7.1 Connected Account Risk Disclosure
Khi user connect account, phải hiển thị:
- Quyền truy cập (scopes) mà Creativanta yêu cầu
- Dữ liệu nào sẽ được đọc/ghi
- Rủi ro khi platform thay đổi API
- Cách disconnect và xóa data

### 7.2 Platform API Change Handling
```
Khi platform API thay đổi:
1. Capability state chuyển sang "Degraded" hoặc "Unsupported"
2. User nhận notification với:
   - Tính năng nào bị ảnh hưởng
   - Workaround có sẵn không
   - Timeline dự kiến để fix
   - Manual fallback path
3. Feature flag tắt tính năng bị ảnh hưởng
4. KHÔNG promise timeline cố định cho restoration
5. Status page cập nhật

Creativanta KHÔNG hoàn tiền cho dịch vụ bị ảnh hưởng bởi 
thay đổi API/policy từ bên thứ ba, vì đây nằm ngoài tầm kiểm soát.
```

### 7.3 Data Sync Accuracy Disclaimer
- Dữ liệu từ platforms có thể bị delay, incomplete, hoặc temporarily inaccurate
- Source class và confidence badges luôn visible để user nhận biết
- Reconciliation tools giúp user verify data nhưng không thay thế platform's dashboard
- Creativanta không chịu trách nhiệm cho quyết định kinh doanh dựa trên dữ liệu sync bị lỗi

---

## 8. DMCA / Copyright Compliance

### 8.1 DMCA Notice Procedure
- Designated DMCA agent contact thông tin
- Takedown request process: submit form → review → action trong 48 giờ
- Counter-notice process cho user bị accused
- Repeat infringer policy: 3 strikes → account suspension

### 8.2 AI-Generated Content Copyright
- AI output không được Creativanta claim copyright
- User chịu trách nhiệm đảm bảo AI output không infringe
- Reference materials dùng cho AI generation phải có proper licensing
- Continuity Packs chỉ sử dụng approved references

---

## 9. Age Restriction & Parental Controls

### 9.1 Minimum Age
- Minimum age to use Creativanta: 18 tuổi (hoặc legal age of majority)
- Accounts dưới 18 bị cấm
- Age verification qua self-declaration + payment verification

### 9.2 Content Age-Gating
- Content analysis có thể flag age-sensitive content
- User tự chịu trách nhiệm về tính phù hợp của content với audience

---

## 10. Acceptable Use Policy (AUP)

### 10.1 Prohibited Uses
- Spam / mass publish vi phạm platform guidelines
- Fraud / scam nội dung
- Manipulation of metrics (fake engagement, fake reviews)
- Illegal product promotion
- Harassment / hate speech
- Pornographic content
- Content quảng cáo thuốc lá, ma túy, vũ khí (trừ khi platform allows)
- Sử dụng AI để tạo deepfakes lừa đảo
- Abuse AI credits (automated farming, reselling)

### 10.2 Enforcement
- First violation: warning + content removal
- Second violation: temporary feature restriction (24-72h)
- Third violation: account suspension (7-30 days)
- Severe violation (fraud, illegal content): immediate termination
- Appeal process available trong 30 ngày

---

## 11. Dispute Resolution & SLA

### 11.1 Dispute Resolution Path
1. In-app support ticket
2. Email escalation to support lead
3. Mediation (nếu cần)
4. Arbitration (binding, theo luật địa phương)
5. Court (chỉ khi arbitration không áp dụng)

### 11.2 SLA cho Paid Plans

| Metric | Target | Measurement |
|---|---|---|
| Platform uptime | 99.5% | Monthly, excluding planned maintenance |
| Support response (urgent) | ≤ 4 hours | Business hours |
| Support response (normal) | ≤ 24 hours | Business hours |
| Bug fix (critical) | ≤ 48 hours | From confirmed report |
| Bug fix (normal) | ≤ 7 days | From confirmed report |
| Data export | ≤ 72 hours | From request |
| Account deletion | ≤ 30 days | From request |

### 11.3 Service Credit Policy
- SLA breach → service credits automatically calculated
- Credits áp dụng cho billing cycle tiếp theo
- Credits không vượt quá 30% monthly subscription fee
- Credits KHÔNG quy đổi thành tiền mặt

---

## 12. Regulatory Compliance Matrix

### 12.1 Current Requirements

| Regulation | Region | Status | Key Requirements |
|---|---|---|---|
| PDPA | Vietnam | Must comply | Data protection, consent, cross-border |
| PDPA | Thailand | Planned | Similar to Vietnam PDPA |
| PDP | Indonesia | Planned | Local data storage requirements |
| GDPR | EU | If serving EU users | Full data rights, DPO, DPIA |
| EU AI Act | EU | Aug 2026 deadline | AI content labeling (Art.50), risk classification, transparency (xem §6.4) |
| CCPA/CPRA | California | If serving CA users | Data rights, opt-out sale |
| EU Accessibility Act | EU | Jun 2025 | WCAG 2.1 AA compliance for digital services |
| Digital Services Act (DSA) | EU | Active | Transparency, dispute resolution for platforms |

### 12.2 Platform-Specific Compliance

| Platform | Key 2025-2026 Rules | Creativanta Response |
|---|---|---|
| TikTok | Commercial content disclosure, AI content labeling, hashtag limits, live accountability, music restrictions | Pre-publish checks, AI label reminders, hashtag counter, live compliance monitor |
| Shopee | Off-platform transaction ban, video community guidelines, competitor keyword ban | Content scanner for banned keywords, transaction flow compliance |
| YouTube | Copyright claims, community guidelines, AI content labeling | Music check, content policy scan, C2PA metadata embedding |
| Instagram | Branded content tool, Meta policies | Disclosure reminders, format checks |
| Facebook | Community standards, shop policies | Content compliance scan |

---

## 13. Audit Trail cho Legal Compliance

### 13.1 Records cần lưu giữ
- Consent records: 5 năm sau khi consent expires hoặc withdrawn
- ToS acceptance records: suốt thời gian account active + 3 năm
- DMCA requests: 5 năm
- AUP violations: 3 năm
- Payment/billing records: 7 năm (or per local tax law)
- Data deletion requests: records of requests giữ 5 năm (không giữ deleted data)

### 13.2 Audit Access
- Internal compliance team: full access
- Legal counsel: upon request
- User: own records via data export
- Regulators: upon lawful request

---

## 14. FE/UX Requirements cho Legal/Compliance

### 14.1 Consent Surfaces
- Cookie consent banner (first visit)
- ToS acceptance (account creation, major ToS changes)
- Privacy policy acknowledgment (account creation)
- AI data usage consent toggle (Settings)
- Connected account permission disclosure (connect flow)

### 14.2 Policy Compliance Surfaces
- Pre-publish compliance scan results
- Platform policy change alerts (Home / Notification Center)
- Content violation history
- Live compliance warnings (M17)

### 14.3 Legal Document Center
- Always-accessible legal documents (footer link)
- Version history of all legal documents
- User's consent history (Settings)
- Data export/deletion request portal (Settings)

---

## 14A. Data Portability & Account Lifecycle Contract

### 14A.1 Data Export
- **Export format**: machine-readable JSON (primary) + CSV (tabular data)
- **Export scope**:
  - Account profile & settings
  - Content (scripts, ideas, asset metadata, publish history)
  - Commerce data (products, orders, revenue, costs)
  - Analytics & performance data
  - Workflow & recipe definitions
  - AI generation history
  - Consent & legal records (own records only)
- **Excluded from export**: system-internal data (indexes, caches, projections)
- **Export delivery**: download link via email, valid 72 hours
- **SLA**: export ready within 72 hours of request (per §11.2)

### 14A.2 Account Deletion (Right to Be Forgotten)
- **Trigger**: user request via Settings → "Delete Account"
- **Grace period**: 14 days (user can cancel deletion during this period)
- **Deletion timeline**: complete within 30 days of grace period end (total 44 days)
- **Scope of deletion**:
  - Personal data: permanently deleted
  - Content data: permanently deleted
  - AI generation history: permanently deleted
  - Connected account tokens: revoked and deleted
  - File/blob storage: permanently purged
- **Retained (legally required)**:
  - Financial records: retained 7 years per tax law (anonymized)
  - Consent records: retained 5 years (anonymized)
  - Audit trail: retained 3 years (anonymized)
  - DMCA/AUP records: retained 5 years
- **Third-party cleanup**: notify connected platforms of token revocation within 24 hours
- **Published content**: content already published on third-party platforms is NOT under Creativanta's control

### 14A.3 Account Suspension vs Deletion
- Suspension: temporary, data preserved, access blocked
- Deletion: permanent, data destroyed per retention rules
- Suspended accounts auto-delete after 365 days of inactivity without reinstatement

### 14A.4 Workspace Transfer
- Workspace ownership can be transferred to another user (Settings → Team → Transfer)
- Transfer requires both parties' explicit confirmation
- Transfer preserves all workspace data

---

## 14B. Accessibility Compliance (WCAG 2.1 AA)

### 14B.1 Target
- WCAG 2.1 Level **AA** compliance across all user-facing surfaces
- EU Accessibility Act (Jun 2025) compliance

### 14B.2 Requirements
- Color contrast ratio: ≥ 4.5:1 for normal text, ≥ 3:1 for large text
- Keyboard navigation: all interactive elements operable via keyboard
- Screen reader support: proper ARIA labels, roles, and landmarks
- Focus management: visible focus indicators, logical tab order
- Touch targets: minimum 44×44px on mobile
- Text scaling: UI functional at 200% zoom
- Motion: respect prefers-reduced-motion
- Alternative text: all images and icons
- Form labels: all inputs have visible, associated labels
- Error identification: errors clearly identified by text (not color alone)

### 14B.3 Testing Strategy
- Automated: axe-core or Lighthouse a11y audit in CI/CD
- Manual: keyboard-only testing per release
- Screen reader: VoiceOver (iOS/Mac) + NVDA (Windows) testing quarterly

---

## 15. Online Dispute Resolution (ODR)

### 15.1 Internal Dispute Resolution
1. In-app complaint form (max 48h first response)
2. Support lead review (max 5 business days resolution)
3. Escalation to management (max 10 business days)

### 15.2 External Resolution
- Mediation: neutral third-party mediator (user's choice of provider)
- Arbitration: binding arbitration per governing law
- Court: only when arbitration unavailable by law

### 15.3 EU P2B Compliance (if applicable)
- Transparent ranking parameters for marketplace
- Accessible complaint-handling mechanism
- External mediator listed for business users

---

## 16. Acceptance Scenario Inventory

Legal/Compliance bắt buộc cover tối thiểu các scenario sau:
- User account creation requires ToS accept + Privacy Policy accept + age confirmation
- Cookie banner appears on first visit, consent choices persisted, re-asked after 12 months
- Platform API change triggers: capability degradation → user notification → policy note → manual fallback
- Pre-publish scan catches hashtag violations, missing disclosures, copyright risk → blocks or warns before publish
- AI-generated content clearly labeled throughout pipeline: generation → review → publish
- AI content exported with C2PA metadata and visible "AI-assisted" indicator
- User data export completed within 72 hours of request in JSON + CSV formats
- Account deletion: 14-day grace period → completion within 30 days → retained records anonymized
- ToS major change: 30-day notice → user re-consent or terminate
- DMCA takedown processed within 48 hours
- AUP violation enforcement follows graduated penalty system
- Connected account disconnect removes stored tokens and cached data within 24 hours
- Financial data always shows source class, confidence, and disclaimer when applicable
- Content ownership: user retains IP for user-created content; AI-generated content beneficial ownership to user
- WCAG 2.1 AA automated audit passes with ≥ 95% score
- Data import from Shopee/TikTok follows source_class = Imported rules
- Account suspension vs deletion clearly distinguished in UX
- Dispute resolution path accessible within 2 clicks from any page
