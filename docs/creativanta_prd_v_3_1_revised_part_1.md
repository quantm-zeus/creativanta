# Creativanta — PRD Master v3.1 (Revised, Freeze-Ready) — Part 1/2

> Bản này sửa trực tiếp từ PRD v3 theo hướng **khóa nghĩa, vá lỗi logic, làm đều contract, tăng độ chặt cross-module**, **không cắt bớt tính năng** và **không phase hóa scope domain**.

---

## 1. Document Status

- Tên tài liệu: **Creativanta PRD Master v3.1 — Revised, Freeze-Ready**
- Mục đích: làm bản PRD gốc đã được làm chặt để từ đây đi tiếp sang **v3.1 Product Freeze / Build Contract** và **Detail Design**
- Tính chất: **full-scope product contract ở cấp sản phẩm**, không phải implementation detail-level spec
- Nguyên tắc chỉnh sửa:
  - không cắt tính năng
  - không đổi thesis sản phẩm
  - không biến PRD thành DB/API spec
  - chỉ sửa để giảm ambiguity, khóa taxonomy, khóa link logic, làm đều contract

---

## 2. Product Definition

### 2.1 Sản phẩm được định nghĩa bởi 10 lớp cốt lõi

1. Trend & Intelligence Layer
2. Opportunity & Decision Layer
3. Idea / Script / Packaging Layer
4. AI Production & Continuity Layer
5. Publish & Distribution Layer
6. Engagement & Commerce Intent Layer
7. Store / Offer / Affiliate / Live / Seeding Operations Layer
8. Revenue / Cost / Profit / Proof Layer
9. Workflow / Recipe / Agentic Operations Layer
10. Capability-Aware / Policy-Safe Execution Layer

### 2.2 Định nghĩa “full product”

Creativanta là **full product từ ngày đầu ở cấp domain**, không phải ở cấp native parity tuyệt đối trên mọi platform.

Điều này có nghĩa:
- mọi domain chính phải hiện diện đầy đủ ở cấp UX, object model, schema contract, reporting, trust model và fallback
- cùng một domain phải được dùng xuyên web và mobile như execution surface thật
- execution có thể khác nhau tùy capability thực tế của platform, nhưng **domain không được biến mất khỏi sản phẩm**
- bundle thương mại chỉ mở capability, execution scope hoặc operational limits; **bundle không được dùng để cắt canonical domain model**
- downstream documents không được hợp thức hóa việc giảm scope domain bằng wording mơ hồ, placeholder hoặc “phase sau tính tiếp”

### 2.3 Điều làm sản phẩm khác biệt

Creativanta không cạnh tranh chỉ bằng số lượng module. Sản phẩm cạnh tranh bằng 7 lợi thế cấu trúc:
- **One Graph**: một graph xuyên suốt từ trend đến profit
- **Proof Graph**: mọi claim quan trọng đều gắn với evidence
- **Operating Ledger**: không dừng ở revenue, đi tới cost, margin, profit
- **Continuity OS**: AI content có character/brand/voice/scene continuity
- **Capability Trust Layer**: sản phẩm trung thực với giới hạn thật của từng platform
- **Recipe-first & Agentic Operations**: biến hệ thống thành action system, không chỉ dashboard
- **SEA-native Social Commerce Fit**: thiết kế phù hợp logic vận hành creator commerce của khu vực

---

## 3. Vision, Mission, Product Thesis

### 3.1 Vision
Trở thành hệ điều hành tiêu chuẩn cho creator commerce đa nền tảng trên web và mobile.

### 3.2 Mission
Giúp creator và operator biến signal thành profit một cách có hệ thống, có proof, có trust, có thể vận hành hằng ngày trong một sản phẩm thống nhất.

### 3.3 Product Thesis
Người dùng không thiếu tool. Người dùng thiếu một **operating truth system**.

### 3.4 Positioning Statement
**Creativanta là một Proofed Trend-to-Profit Operating System cho creator commerce, nơi trend, content, engagement, offer, live, affiliate, store, revenue, cost, profit, workflow và policy được nối lại thành một hệ thống thống nhất.**

---

## 4. Problem Statement

Người dùng creator commerce hiện phải vận hành qua nhiều tool rời rạc:
- tool nghiên cứu trend
- tool viết script và tạo content
- tool publish
- tool inbox / comment / DM
- tool live / seeding / affiliate / store
- tool order / finance / reporting
- tool workflow / automation

Vấn đề không chỉ là “nhiều tool”. Vấn đề là:
- object không liên kết với nhau
- money không có proof rõ ràng
- AI output thiếu continuity
- capability và policy bị che giấu
- revenue bị nhìn tách rời khỏi cost và profit
- work không được tổ chức thành closed loop có thể lặp lại

---

## 5. Goals

Creativanta phải giúp user:
- nhìn thấy việc quan trọng nhất hôm nay thay vì chìm trong dashboard
- chuyển signal thành decision, idea, script, asset, publish, engagement, commerce, profit trong cùng một hệ thống
- biết con số nào đáng tin tới đâu, dựa trên nguồn nào, còn thiếu gì
- vận hành AI content với continuity thật, không chỉ generate rời rạc
- biến công việc lặp lại thành workflow, recipe hoặc agent plan có audit trail
- dùng được cả trên web và mobile như execution surface thật

---

## 6. Non-Goals

1. Không xây social network riêng.
2. Không hứa native parity tuyệt đối cho mọi platform.
3. Không lấy scraping trái chính sách làm lõi.
4. Không hỗ trợ spam automation, mass abuse hoặc vi phạm policy.
5. Không thay thế mọi native console trong mọi use case đặc thù.
6. Không mặc định đóng vai merchant of record hoặc escrow cho toàn bộ use case.
7. Không train foundation model riêng trong launch definition.

---

## 7. Product Principles

1. **Domain-complete, execution-honest**
2. **One Graph, Many Surfaces**
3. **Proof before persuasion**
4. **Profit over vanity**
5. **Workflow-first**
6. **Continuity-first AI production**
7. **Native coexistence, not blind replacement**
8. **Capability-aware, not capability-hidden**
9. **Confidence-visible by default**
10. **Agentic, but auditable**
11. **SEA-native operating assumptions**

Các nguyên tắc trên là **normative product rules**, không phải guideline mềm.

---

## 8. Core User Segments và Operator Modes

### 8.1 User Segments

#### Solo Creator
- tạo content, publish, bán offer, gắn affiliate, theo dõi revenue/profit

#### Affiliate Creator / KOC / KOL
- nghiên cứu trend, chọn sản phẩm, tạo content, gắn link/coupon, tối ưu conversion

#### Seller / Seller Team
- quản lý sản phẩm, tồn kho, offers, live, inbox, doanh thu, lợi nhuận

#### Live Commerce Team
- quản lý live plan, pin offer, cue, comment, highlight, post-live follow-up

#### Agency / MCN / Team Ops
- quản lý nhiều workspace, creator, client, approvals, performance proof, templates

#### Community / Digital Product Creator
- bán membership, digital product, bundle, lead magnet, sponsor inventory

#### Sponsor / Brand Collaboration Operator
- quản lý sponsor deal, deliverable, proof, invoice, payout, performance evidence

### 8.2 Operator Modes

App phải hỗ trợ 6 mode chính:
- **Creator Mode**
- **Seller Mode**
- **Affiliate Operator Mode**
- **Live Operator Mode**
- **Agency / MCN Mode**
- **Brand Collaboration Mode**

> **Naming reconciliation (Audit v5 — M3)**: The display names above map to these DB canonical enum values in `workspaces.active_operator_mode`:
> | Display Name | DB Enum Value |
> |---|---|
> | Creator Mode | `creator` |
> | Seller Mode | `seller` |
> | Affiliate Operator Mode | `affiliate_operator` |
> | Live Operator Mode | `live_operator` |
> | Agency / MCN Mode | `agency_mcn` |
> | Brand Collaboration Mode | `brand_collaboration` |

### 8.3 Operator Mode Contract

Mỗi mode bắt buộc phải định nghĩa rõ:
- dashboard priorities
- default navigation emphasis
- Daily Brief logic
- terminology emphasis
- recommended recipes
- alert priorities
- primary objects
- mobile-critical loops

### 8.4 Canonical Mode Matrix

#### Creator Mode
- ưu tiên: ideas, scripts, assets, publish, comments, earnings snapshot
- primary objects: Idea, Script, Asset, Publish Item, Thread, Offer
- mobile-critical loops: review script, approve asset, quick publish, quick reply

#### Seller Mode
- ưu tiên: products, offers, inventory, inbox, profit, anomalies
- primary objects: Product, SKU, Offer, Order, Thread, Profit Snapshot
- mobile-critical loops: quick offer edit, thread triage, stock alert action, profit anomaly follow-up

#### Affiliate Operator Mode
- ưu tiên: opportunities, products, packaging, links/coupons, attributed revenue/profit
- primary objects: Opportunity, Product, Offer, Affiliate Link, Campaign, Profit Snapshot
- mobile-critical loops: quick idea capture, coupon/link share, reply-to-conversion flows

#### Live Operator Mode
- ưu tiên: live war room, cue, offer pinning, comment triage, highlights, post-live summary
- primary objects: Live Session, Cue Card, Thread, Offer, Highlight
- mobile-critical loops: live monitoring, quick cue, highlight mark, urgent reply

#### Agency / MCN Mode
- ưu tiên: workspace switching, approvals, creator scorecards, reports, templates
- primary objects: Workspace, Approval Request, Script, Asset, Report, Workflow
- mobile-critical loops: approvals, urgent diagnostics, summary review

#### Brand Collaboration Mode
- ưu tiên: sponsor inquiries, deliverables, campaign proof, invoice/payout tracking, performance evidence
- primary objects: Sponsor Inquiry, Campaign, Publish Item, Proof Bundle, Invoice, Creator Payout
- mobile-critical loops: approve deliverable, inspect proof, status update, sponsor follow-up

---

## 9. Jobs To Be Done

1. Khi bắt đầu ngày làm việc, tôi muốn biết ngay 3–5 việc quan trọng nhất cần làm để tăng growth, revenue hoặc profit.
2. Khi thấy một trend hoặc cơ hội sản phẩm, tôi muốn chuyển nó thành idea usable ngay.
3. Khi có idea, tôi muốn có script, shot list, CTA, packaging guidance và continuity guardrails.
4. Khi tạo content bằng AI, tôi muốn nhân vật/brand/voice nhất quán giữa nhiều video.
5. Khi publish, tôi muốn biết platform nào support gì, action nào chạy được native, action nào phải fallback.
6. Khi có comment hoặc inquiry, tôi muốn app hiểu intent và đề xuất action tiếp theo.
7. Khi có order, payout, refund hoặc chi phí, tôi muốn thấy nó trong cùng một ledger để biết lời thật.
8. Khi làm live, seeding hoặc affiliate, tôi muốn biết performance thật và proof của kết quả.
9. Khi một insight có confidence thấp, tôi muốn app nói rõ tại sao.
10. Khi công việc lặp đi lặp lại, tôi muốn biến nó thành workflow hoặc recipe.
11. Khi hỏi app một câu vận hành, tôi muốn được agent trả lời dựa trên graph thật chứ không chỉ “nói hay”.

---

## 10. Unified Operating Loop

Mọi module của Creativanta phải map được vào ít nhất một bước trong vòng lặp này:
1. **Signal**
2. **Opportunity**
3. **Decision**
4. **Idea**
5. **Script**
6. **Asset**
7. **Packaging**
8. **Publish**
9. **Engagement**
10. **Commerce**
11. **Order / Settlement / Cost**
12. **Profit / Proof**
13. **Learn / Optimize**
14. **Automate**

Không module nào được tồn tại như island surface không nối được vào loop này.

---

## 11. Product Architecture Overview

Creativanta gồm **23 module / surface chính**:

- **M01** Home / Daily Decision Engine
- **M02** Trend Fusion Radar
- **M03** Research & Competitor Intelligence
- **M04** Opportunity Board
- **M05** Idea Engine
- **M06** Script Lab
- **M07** AI Video Studio
- **M08** Continuity OS
- **M09** Asset Derivative Manager / Repurpose Hub
- **M10** Packaging QA / Upload Copilot / Experiment Lab
- **M11** Publish Hub
- **M12** Unified Inbox & Engagement Center
- **M13** Product Hub / Inventory / Order Truth
- **M14** Monetization OS
- **M15** Creator Store / Offers / Membership
- **M16** In-Product Affiliate Network
- **M17** Live Commerce War Room
- **M18** Seeding / Sample CRM
- **M19** Operating Ledger / Profit Graph / Proof Center
- **M20** Workflow Studio
- **M21** Workflow Marketplace / Recipe Economy / Agent Center
- **M22** Capability Matrix & Policy Center
- **M23** Reporting / Admin / Billing / Diagnostics

Mã module trên là canonical naming cho downstream documents.

---

## 12. Canonical Object Model — One Graph

### 12.1 Core Rule
Không module nào được tạo data silo. Mọi data quan trọng phải được thể hiện dưới dạng canonical objects trong cùng một graph.

### 12.2 Object Families

#### Identity & Workspace
- Workspace
- Brand Profile
- Creator Profile
- Seller Profile
- Team Member
- Role
- Permission Set
- Connected Account
- Connected Provider
- Region Profile
- Currency Profile

#### Intelligence Objects
- Signal
- Trend
- Search Intent Cluster
- Keyword Cluster
- Competitor Entity
- Product Opportunity
- Watchlist
- Alert
- Benchmark Snapshot
- Confidence Record

#### Decision Objects
- Opportunity
- Decision Card
- Expected Impact Model
- Expected Effort Model
- Decision Outcome

#### Creation Objects
- Idea
- Hook
- Angle
- Objection Pattern
- Script
- Scene
- Shot List
- Asset Brief
- Asset
- Clip
- Variant
- Packaging Checklist
- Experiment

#### Continuity Objects
- **Character** (user-facing entity: digital twin, AI generated, stock)
- Character Pack
- Brand Pack
- Voice Pack
- Scene Memory
- Lookbook
- Approved Reference
- Prompt Lineage Record
- Continuity Rule
- Continuity Violation

#### Production Objects
- Remix Blueprint
- Creative DNA Blueprint
- Clip Collection
- Virality Score
- Video Edit Job
- Repurpose Job
- Product Showcase Job
- Link-to-Video Job
- Translation Job
- Style Pack
- Performance Report
- AB Test Experiment
- Creator Progress

#### Distribution Objects
- Publish Item
- Channel Post
- Publish Job
- Queue Item
- Approval Request
- Publish Log
- Capability Snapshot

#### Engagement Objects
- Person / Entity
- Thread
- Message
- Comment
- DM
- Inquiry
- Sponsor Inquiry
- Sample Request
- Intent
- Suggested Reply
- Follow-up Task

#### Commerce Objects
- Product
- SKU
- Variant SKU
- Inventory Location
- Stock Movement
- Offer
- Bundle
- Membership Plan
- Coupon
- Affiliate Link
- Campaign
- Store Page
- Price Rule
- Promotion Rule

#### Financial Objects
- Click Event
- Lead
- Conversion Event
- Order
- Refund
- Return
- Settlement
- Commission
- Creator Payout
- Affiliate Statement
- Invoice
- Cost Item
- Margin Snapshot
- Profit Snapshot
- Reconciliation Record

#### Operations Objects
- Live Session
- Live Segment
- Cue Card
- Highlight
- Sample Shipment
- Creator Assignment
- Workflow
- Workflow Run
- Trigger Event
- Action Log
- Recipe Template
- Agent Run

#### Trust & Proof Objects
- Evidence Object
- Source Class Record
- Confidence Reason
- Proof Bundle
- Policy Note
- Fallback Path
- Audit Event
- Diagnostics Record

### 12.3 Mandatory Relationship Rules
- Mỗi Trend có thể dẫn tới nhiều Opportunities, Ideas, Scripts, Campaigns và Products.
- Mỗi Opportunity phải map được về ít nhất một source object.
- Mỗi Script phải link được tới Idea và Asset Brief.
- Mỗi Script phải link được tới ít nhất một publish target hoặc publish target profile.
- Mỗi Asset có thể link tới Character Pack, Brand Pack, Voice Pack và Prompt Lineage.
- Mỗi Publish Item phải có Capability Snapshot tại thời điểm execution.
- Mỗi Publish Item khi đi vào execution phải sinh Publish Log.
- Mỗi Thread phải map được sang ít nhất một Intent.
- Mỗi Thread phải có owner, status và next action.
- Mỗi Offer phải map về Product, hoặc phải được đánh dấu rõ là product-less digital/community offer.
- Mỗi Order / Settlement / Payout khi đủ dữ liệu phải link được tới Product / Offer / Campaign / Post / Live Session.
- Mỗi Cost Item phải map được ít nhất tới Workspace hoặc object cụ thể.
- Mỗi Revenue / Profit insight phải link được tới Evidence Object, Proof Bundle hoặc Confidence Reason.
- Mỗi Workflow Run và Agent Run phải để lại Action Log và Audit Event.

---

## 13. Critical Object Minimum Contracts

Đây là lớp minimum contract ở cấp PRD cho các object dễ bị downstream hiểu lệch. Đây **không phải DB schema**, nhưng là product contract bắt buộc.

### 13.1 Opportunity
Bắt buộc có:
- title / summary
- source object refs
- priority / owner / status
- expected impact / expected effort
- confidence hoặc priority reason

### 13.2 Idea
Bắt buộc có:
- source refs
- hook / angle / audience / goal
- state
- link tới opportunity hoặc source objects khi có

### 13.3 Script
Bắt buộc có:
- idea link
- format type
- CTA blocks
- disclosure blocks nếu cần
- status / approval state
- asset brief link
- publish targets hoặc publish target profile refs

### 13.4 Asset Brief
Bắt buộc có:
- script link
- target format / duration / platform intent
- continuity refs nếu có
- production instructions

### 13.5 Asset
Bắt buộc có:
- asset type
- source provider / generation mode
- lineage refs
- continuity pack refs nếu có
- quality / approval status

### 13.6 Publish Item
Bắt buộc có:
- asset link
- target platform / target account / target format
- capability snapshot ref
- publish mode
- schedule time nếu có
- publish state / diagnostics state

### 13.7 Publish Log
Bắt buộc có:
- publish item ref
- attempted_at / completed_at hoặc failed_at
- capability snapshot ref tại thời điểm execution
- actor / acting mode
- result status
- diagnostics ref nếu fail/degrade
- evidence link nếu publish thành công hoặc imported proof tương đương

### 13.8 Thread
Bắt buộc có:
- person/entity ref nếu có
- thread type
- owner
- intent
- priority
- status
- next action
- related object refs
- SLA/follow-up state nếu áp dụng

### 13.9 Offer
Bắt buộc có:
- offer type
- pricing / value / CTA logic
- mapped product hoặc product-less declaration
- channel availability
- lifecycle state

### 13.10 Order
Bắt buộc có:
- source class
- lifecycle state
- amount / currency
- linked product/offer/campaign/post/live refs khi có
- evidence/proof linkage nếu dùng để support performance claims

### 13.11 Settlement
Bắt buộc có:
- related order(s) hoặc payout batch
- gross/net components
- fees / deductions
- source class
- reconciliation state

### 13.12 Cost Item
Bắt buộc có:
- cost type
- amount / currency
- related scope
- source class
- evidence hoặc confidence reason nếu chưa đủ proof

### 13.13 Evidence Object
Bắt buộc có:
- evidence type
- payload reference hoặc immutable content hash
- source provenance
- collected_at
- linked object refs
- verification status

### 13.14 Proof Bundle
Bắt buộc có:
- claim scope
- claim statement hoặc claim summary
- supporting evidence refs[]
- linked source class / confidence context
- coverage summary
- unresolved gaps nếu có

### 13.15 Workflow Run / Agent Run
Bắt buộc có:
- workflow/agent ref
- trigger source
- actor / acting mode
- state
- action logs
- side-effect summary
- audit trail

---

## 14. Native Tool Coexistence Strategy

### 14.1 Mục tiêu
Creativanta là operating layer nằm trên và xuyên qua native tools.

### 14.2 Execution Ownership Model
Mỗi action/domain phải được phân loại thành một trong các nhóm:
- **Native-owned**
- **OS-owned**
- **Shared truth**
- **Imported truth**
- **Execution handoff**

### 14.3 Product Rule
User luôn phải thấy:
- action có tồn tại không
- ai sở hữu execution
- source of truth đang ở đâu
- capability hiện tại là gì
- fallback path là gì
- policy note nào liên quan

---

## 15. Canonical Trust, Source, Confidence và Capability Taxonomy

Phần này được **freeze ngay trong PRD**, không để downstream tự đặt thêm taxonomy song song.

### 15.1 Source Class Taxonomy
User-facing canonical source classes chỉ gồm:
- **Official**: dữ liệu đến từ connected native/platform/system-of-record truth hoặc normalized direct truth do hệ thống xác định là authoritative
- **Imported**: dữ liệu import từ file, external system, manual import hoặc imported source chưa phải connected authoritative truth
- **Inferred**: dữ liệu suy ra từ evidence gián tiếp, attribution logic hoặc graph reasoning
- **Estimated**: dữ liệu mô hình hóa, dự báo, simulation hoặc estimate-based calculation
- **Unreconciled**: dữ liệu đang pending match, conflict hoặc chưa đủ coverage để xem là clean truth

Quy tắc:
- không được dùng song song các nhãn user-facing khác như “Direct”, “Direct Connected”, “Official Direct” nếu không map về 1 trong 5 lớp trên
- downstream implementation có thể dùng sub-class nội bộ, nhưng UI badge canonical phải map về 5 lớp này

### 15.2 Confidence Bands
Canonical confidence bands:
- High
- Medium-High
- Medium
- Low-Medium
- Low

Mọi confidence surface phải giải thích:
- vì sao score đang ở mức này
- yếu tố nào đang kéo xuống
- cần làm gì để tăng confidence

### 15.3 Verification Status
Canonical verification states:
- Verified
- Re-verify
- Pending

### 15.4 Capability States
Canonical capability states:
- Native
- Read-only
- Manual
- Unsupported

### 15.5 Reconciliation States
Canonical reconciliation states:
- fully_reconciled
- partially_reconciled
- awaiting_evidence
- imported_only
- inferred_pending_confirmation
- conflict_detected
- manually_overridden

### 15.6 Degraded Execution Rules
Nếu action không chạy native:
- action vẫn phải hiển thị
- UI phải giải thích trạng thái degraded
- fallback phải hiện nếu có
- policy note phải mở được
- tác động tới workflow phải được nói rõ

### 15.7 UI Requirements
Mỗi KPI quan trọng phải có:
- source badge
- confidence badge
- last sync/refresh badge
- “why this number” panel
- drilldown tới evidence, proof bundle hoặc reconciliation detail

---

## 16. Operating Ledger, Profit Graph và Reconciliation Model

### 16.1 Mục tiêu
Biến hệ thống từ revenue dashboard thành profit operating system.

### 16.2 Ledger Scope
Operating Ledger phải ghi nhận:
- gross revenue
- net revenue
- platform fees
- affiliate commission
- creator payout
- ads spend
- AI generation cost
- service/tool cost
- shipping/fulfillment cost
- refunds/returns
- other assigned cost
- margin
- profit

### 16.3 Ledger Requirements
- mọi money-related object phải có source class
- mọi money-related object phải có evidence, proof bundle hoặc confidence reason
- cost classes có thể incomplete nhưng phải làm rõ impact on confidence
- user phải drill down từ dashboard tới transaction/evidence level
- UI không được trộn estimated với Official truth mà không gắn nhãn rõ
- unreconciled values không được hiển thị như finalized truth

### 16.4 Reconciliation System
Hệ thống phải hỗ trợ:
- revenue reconciliation
- payout reconciliation
- order reconciliation
- cost reconciliation
- affiliate statement reconciliation
- refund reconciliation

### 16.5 Profit Formula
Profit = gross revenue - fees - commission - payouts - refund impact - ads spend - AI cost - service cost - shipping/fulfillment cost - other allocated cost

### 16.6 Profit Confidence
Profit Confidence phải phản ánh:
- số lớp cost đã hiện diện
- mức độ sạch của revenue mapping
- quality của reconciliation
- freshness của dữ liệu
- conflict presence

### 16.7 Proof Rule
Mọi claim dạng “post này tạo doanh thu”, “offer này lời”, “creator này mang về profit”, “live này hiệu quả” phải mở được proof path gồm:
- Evidence Objects liên quan
- Proof Bundle nếu claim ở mức tổng hợp
- Source Class context
- Confidence explanation
- unresolved gaps nếu còn

---

## 17. Fit Graph và Decision Intelligence

### 17.1 Mục tiêu
Không chỉ phân tích “cái gì hot”, mà phân tích “cái gì phù hợp nhất để ra profit”.

### 17.2 Fit Graph Types
- Product × Creator Fit
- Product × Format Fit
- Product × Offer Fit
- Creator × Offer Fit
- Hook × Offer Fit
- Trend × Niche Fit
- Comment Intent × Offer Fit
- Live Segment × Conversion Fit
- Content Type × Margin Fit

### 17.3 Fit Outputs
- recommended creator for product
- recommended offer for thread/comment cluster
- recommended format for product push
- recommended live segment structure
- recommended hook based on objection cluster
- recommended profit-maximizing action

### 17.4 Requirements
- fit score phải chỉ rõ input và confidence
- fit score phải map ngược về evidence/performance history khi có
- fit score không được hiện như ground truth nếu dữ liệu còn yếu

---

## 18. Decision Engine và Home Surface

### 18.1 Mục tiêu
Home không phải chỉ là dashboard. Home phải là **daily decision engine**.

### 18.2 Must Show
- Top Opportunities Today
- Top Risks Today
- Top Profitable Actions
- Pending Approvals
- Urgent Threads
- Profit Anomalies
- Connector / Capability Issues

### 18.3 Interaction Rules
- mỗi card có 1 hành động chính rõ ràng
- có why drawer hoặc diagnostics drawer
- có dismiss / snooze / assign khi phù hợp
- card phải dẫn user vào object thật, không dẫn tới dead-end dashboard

### 18.4 Non-Tech Usability Rule
Home phải dùng ngôn ngữ hành động, không đẩy user mới vào abstraction quá sớm.

---

## 19. Simulation và Decision Support

### 19.1 Mục tiêu
Cho phép user mô phỏng quyết định trước khi commit tài nguyên thật.

### 19.2 Supported Simulation Families
- content output scenarios
- offer / pricing scenarios
- channel mix scenarios
- creator allocation scenarios
- live structure scenarios
- cost / margin sensitivity scenarios

### 19.3 Product Rules
- simulation là decision support, không phải truth
- mọi assumption phải nhìn thấy được
- mọi output phải phân biệt với Official truth
- simulation output phải có confidence/explanation phù hợp
- saved scenario phải link được tới object scope liên quan nếu user lưu

---

## 20. Web + Mobile Experience Contract

### 20.1 One Product, Two Real Execution Surfaces
Web và mobile đều là execution surfaces thật, không có chuyện mobile chỉ để xem.

### 20.2 Mobile Must Support
- review scripts
- approve assets
- quick publish flows theo capability
- reply flows
- live monitoring và highlight management
- offer quick edits
- task triage
- inspect profit anomalies và assign follow-up

### 20.3 UX Principles
- workflow over dashboard
- object-first navigation
- trust by visibility
- fast operator ergonomics
- progressive disclosure cho user non-tech

### 20.4 Beginner / Non-Tech Experience Contract
Sản phẩm phải có:
- onboarding wizard
- recipe-first entry paths
- plain-language explanations
- empty state, partial setup state, broken state rõ ràng
- repair wizards cho connectors/capabilities/truth gaps
- first closed-loop guidance

### 20.5 Accessibility & Usability
- keyboard shortcuts trên web
- readable contrast
- large touch targets trên mobile
- state colors không phải nguồn thông tin duy nhất
- dense mode cho power-users nhưng không làm hại beginner UX

---

## 21. Workflow, Recipe và Agentic Operations

### 21.1 Mục tiêu
Biến operating loops lặp lại thành execution systems có kiểm soát.

### 21.2 Core Building Blocks
- triggers
- conditions
- actions
- approvals
- fallback nodes
- diagnostics nodes
- human handoff nodes
- agent planning / execution nodes

### 21.3 Product Rules
- workflow/agent không được side-effect business-critical mà không có audit trail
- approval boundaries phải rõ
- manual override phải có reason
- workflow phải capability-aware
- workflow failure phải có repair path, không được im lặng

### 21.4 Default Recipe Requirement
Launch definition phải có đủ recipe cho:
- trend to idea
- idea to script
- script to publish
- comment to commerce action
- profit anomaly follow-up
- live follow-up
- affiliate push
- sponsor deliverable proofing

---

## 22. Capability Matrix, Policy Center và Diagnostics Trust Layer

### 22.1 Mục tiêu
Làm rõ giới hạn thực của từng connector, platform, capability và policy condition.

### 22.2 Must Support
- capability registry
- per-platform capability notes
- policy notes
- fallback paths
- connector health
- diagnostics hierarchy
- repair guidance

### 22.3 Product Rule
Không được che capability limitations chỉ để tạo cảm giác “đủ tính năng”. Trust quan trọng hơn illusion.

---

## 23. Detailed Module Requirements — Phần 1

> Tất cả module dưới đây phải tuân cùng một template contract: **Mục tiêu / Primary Objects / Functions / Acceptance Criteria / Mobile Execution Requirement**.

### 23.1 M01 — Home / Daily Decision Engine
**Mục tiêu**: là bề mặt vận hành đầu ngày, nơi user biết việc tiếp theo có impact nhất.

**Primary Objects**: Decision Card, Opportunity, Thread, Approval Request, Profit Snapshot, Diagnostics Record.

**Functions**:
- top opportunities today
- top risks today
- top profitable actions
- pending approvals
- urgent threads
- profit anomalies
- connector/capability issues
- assign/snooze/dismiss
- why drawer / diagnostics drawer

**Acceptance Criteria**:
- mỗi card có primary action rõ ràng
- card map được về object thật
- home phản ánh operator mode
- home không được là dashboard chết chỉ để xem số

**Mobile Execution Requirement**:
- action cards phải thao tác được trên mobile với CTA rõ ràng

### 23.2 M02 — Trend Fusion Radar
**Mục tiêu**: gom và chuẩn hóa các tín hiệu trend để phục vụ decision.

**Primary Objects**: Signal, Trend, Watchlist, Alert, Confidence Record.

**Functions**:
- signal ingestion
- trend normalization
- velocity/freshness/saturation scoring
- watchlists
- alerts
- save to opportunity / idea / product opportunity

**Acceptance Criteria**:
- trend save works
- trend → opportunity works
- confidence visible
- watchlist alerts hoạt động

**Mobile Execution Requirement**:
- save trend, watch, dismiss, convert nhanh

### 23.3 M03 — Research & Competitor Intelligence
**Mục tiêu**: biến market/competitor research thành operating intelligence, không chỉ notes.

**Primary Objects**: Competitor Entity, Benchmark Snapshot, Trend, Product Opportunity.

**Functions**:
- competitor mapping
- benchmark snapshots
- pricing/offer comparison
- format/content pattern analysis
- white-space detection
- research note linking

**Acceptance Criteria**:
- inferred insights phải gắn nhãn inferred
- insight phải có confidence/explanation
- không conflates market intelligence với accounting truth

**Mobile Execution Requirement**:
- save benchmark, share snapshot, create opportunity

### 23.4 M04 — Opportunity Board
**Mục tiêu**: biến signal thành prioritized decision surface.

**Primary Objects**: Opportunity, Expected Impact Model, Expected Effort Model, Decision Outcome.

**Functions**:
- opportunity registry
- score/rank opportunities
- impact vs effort matrix
- urgency tags
- assign owner
- convert to idea/script/campaign/live plan
- expected profit estimation
- decision status tracking

**Acceptance Criteria**:
- opportunity phải map về trend/signal source
- opportunity phải có owner và status
- opportunity phải có priority reason hoặc confidence context

**Mobile Execution Requirement**:
- assign, prioritize, convert nhanh

### 23.5 M05 — Idea Engine
**Mục tiêu**: biến signals, comments, products và objections thành ideas usable.

**Primary Objects**: Idea, Hook, Angle, Objection Pattern.

**Functions**:
- idea from trend
- idea from product
- idea from comment cluster
- objection-led ideation
- offer-led ideation
- hook bank
- angle suggestions
- format suggestions
- dedupe/clustering
- idea scoring

**Acceptance Criteria**:
- mỗi idea link được về source refs
- idea có state rõ ràng
- idea có thể đi tiếp sang script hoặc campaign/live plan

**Mobile Execution Requirement**:
- quick capture, save, convert to script

### 23.6 M06 — Script Lab
**Mục tiêu**: tạo ra script usable, có continuity và có thể đi vào asset production ngay.

**Primary Objects**: Script, Scene, Shot List, Asset Brief.

**Functions**:
- script drafting
- format templates
- shot list
- CTA blocks
- duration targets
- channel rewrites
- disclosure insertion
- script compare
- approval flow
- script-to-asset brief

**Acceptance Criteria**:
- mỗi script có status
- links tới idea, asset brief, publish targets hoặc publish target profile refs
- approval state rõ ràng

**Mobile Execution Requirement**:
- review, comment, approve script trên mobile

### 23.7 M07 — AI Video Studio
**Mục tiêu**: điều phối AI production toàn diện — từ generate, edit, remix đến repurpose — thay vì chỉ generate hộ.

**Primary Objects**: Asset, Asset Brief, Prompt Lineage Record, Diagnostics Record, Remix Blueprint, Clip Collection, Virality Score.

**Functions — Core Generation**:
- **multi-provider routing** (Veo 3.1, Kling 3.0, Runway Gen-4 cho video; Flux 2, GPT Image cho ảnh)
- **Smart Pipeline Router** — tự chọn: Native Audio / Audio-First / Post-Prod Lip-Sync / Voice-Over
- **model selector UX** — user có thể chọn model hoặc "Tự động" (smart routing)
- provider routing + failover + circuit breaker
- prompt templates
- asset generation jobs
- image/video/voice/subtitle orchestration
- **lip-sync orchestration** (SyncLabs / Wav2Lip cho post-production sync)
- **post-production mix** (rust-ffmpeg: audio ducking, normalize, subtitles)
- cost estimation (hiển thị estimated credits trước generate)
- job diagnostics, asset versioning, approve/promote asset, BYOK support

**Functions — 4 Core Production Modes + 11 Extended Features**:

- **🎨 Quick Edit** (1→1): User upload 1 video → AI tự edit → 1 video tốt hơn
  - text-based editing (edit transcript = edit video), animated captions (karaoke/bounce/highlight trending styles)
  - active speaker detection (auto-reframe theo người đang nói), beat-sync music (cắt video khớp nhạc)
  - AI B-roll generation (Flux 2/Veo gen contextual b-roll thay stock), platform presets (TikTok/YouTube/Reels pace)
  - Smart Hook Library (50+ mẫu hook proven viral: question, shock, story, POV, listicle, contrast)
  - copyright-safe audio system (auto-scan + gợi ý royalty-free alternatives)

- **✂️ Clip Factory** (1→N): Upload video dài (3-60min) → AI cắt → 5-20 clips ngắn viral
  - AI highlight detection (scene analysis + speech importance scoring)
  - **Virality Score** (0-100) per clip: engagement pattern (30%) + hook strength (25%) + pacing (20%) + audio (15%) + trend relevance (10%, from M02/M03 Trend Engine)
  - batch operations (add captions, music, style to all clips), bulk export + schedule
  - clip review board (sort by virality/duration/chronological, select + bulk action)

- **🔀 Multi-Merge** (N→1): User upload nhiều videos/ảnh → AI ghép thành 1 video hoàn chỉnh
  - drag-reorder media, AI auto-transitions, voice-over options (AI voice/upload/record)
  - background music (AI auto-select/library/upload, copyright check), target duration control
  - aspect ratio selection (9:16, 16:9, 1:1), timeline preview + adjust

- **🔄 AI Remix Studio** (ref video → new video): Upload/paste URL video → AI phân tích Creative DNA → tạo video mới nội dung tương tự
  - **Phase 1 — Analyze**: 8-layer analysis (scene detection, script extraction via ASR, hook pattern, pacing/rhythm, visual style, audio profile, engagement structure, transition map)
  - **Phase 2 — Remix**: Creative DNA Blueprint + user's Brand Pack + Character Pack + topic → AI script rewrite (LLM) + visual gen + voice gen + music match + assembly with pacing match
  - **Phase 3 — Polish**: side-by-side preview (original vs remix), edit per-scene, compliance scan, predicted virality score, platform-specific export
  - remix fidelity levels: "Match 1:1" / "Adapt" / "Loose inspiration"
  - legal safeguards: originality score (block if >70% transcript similarity), no footage reuse, script similarity <30%, abuse detection (max 20 remixes/day)
  - integration: Trend Engine (M02/M03) gợi ý trending videos → "Remix this" button

**Functions — Trend-Aware Editing** (lợi thế riêng, đối thủ KHÔNG có):
- trending hook injection (Trend Engine detect hook nào đang viral → AI gen hook phù hợp nội dung)
- trending caption style (auto-detect + apply style trending)
- trending music sync (cross-ref trending sounds → suggest royalty-free tương tự)
- CTA placement intelligence (phân tích retention curve → đặt CTA trước drop-off point)

- **📸 AI Product Showcase Studio** (photos → product video): upload 1-10 ảnh sản phẩm → AI remove background → generate video showcase
  - 8 styles: 360° Spin, Tabletop Demo, Flip & Reveal, Virtual Try-On (AI model mặc lên), Lifestyle Context, Unboxing Simulation, Before/After, Review Style (AI avatar review sản phẩm)
  - tùy chọn: background, duration (15-60s), music, voice-over, text overlay, CTA, aspect ratio, pacing, color grade
  - integration Product Hub (M13): auto-fill product data, auto-suggest style phù hợp category
  - batch mode: upload 20 SP → gen 20 videos → bulk export
  - Virtual Try-On: AI model mặc/đeo/cầm SP, sử dụng Kolors/Flux + Veo animation

- **🎥 Image-to-Video Converter** (ảnh tĩnh → video động): upload ảnh → AI biến thành video chuyển động
  - styles: Cinematic Pan, Product Rotate, Parallax 3D, Subtle Movement (tóc bay, nước chảy), Zoom In, Custom Prompt
  - duration: 3-15s, loop-friendly option, auto music sync
  - provider: Veo 3.1 / Kling 3.0 image-to-video API

- **🎨 AI Thumbnail Studio**: upgrade từ basic frame → full thumbnail production
  - auto-extract best frame + enhance, generate from prompt, 50+ template styles
  - A/B thumbnail testing (tạo 2-3 → auto-pick winner dựa trên CTR)
  - brand consistency: Brand Pack fonts/colors/logo auto-apply

- **🔗 Link-to-Video Generator** (product URL → video ad): paste link Shopee/Lazada/TikTok Shop/Amazon → AI crawl product data → auto-gen video ad
  - auto-extract: tên, giá, ảnh, mô tả, reviews
  - 5 script templates: Problem-Solution, Listicle Review, Testimonial, Flash Sale, Comparison
  - integration: Product Showcase style (§9.6) + Character voice + trending format

- **🌍 AI Translation & Localization Studio**: video gốc → N phiên bản đa ngôn ngữ
  - pipeline: Whisper ASR → LLM translate → ElevenLabs voice clone → SyncLabs lip-sync
  - languages (v1): VN ↔ EN, TH, ID, PH, JP, KR, ZH, ES
  - integration: Trend Engine ("hot ở Thailand → dịch video sang Thai?") + Publish Hub auto-schedule

- **🎵 AI Sound Studio** (extends S13.1): full audio production
  - AI music generator (mood → copyright-free BGM), beat-drop sync, speech-to-song
  - AI sound effects (describe scene → contextual SFX), multi-lang voice clone
  - podcast → short clips conversion

- **🎭 AI Style Learning & Transfer**: learn editing style từ video → save as Style Pack
  - extract: caption style, color grade, transition timing, pacing, text overlay, audio mix
  - Style Pack integration với Continuity OS (M08) — giống Brand/Character Pack
  - future: Style Pack Marketplace (community share/sell)

- **🤖 AI Video Agent** (1-click pipeline): user mô tả ý tưởng 1 câu → Agent orchestrate full pipeline → video ready to publish
  - auto: script gen → visual gen → voice-over → music → captions → thumbnail → Virality Score
  - context aware: Brand Pack + Character + Trend data + past performance

- **📊 AI Performance Coach** (UNIQUE — không đối thủ nào có): post-publish analysis + coaching
  - 24h analysis: hook effectiveness, retention rate, engagement comparison
  - weekly report card: best/worst content, format analysis, improvement suggestions
  - proactive coaching: format recommendations, trending sound suggestions, competitor benchmarks

- **🧪 Video A/B Testing Engine**: tạo N variations (hook, CTA, thumbnail, music) → publish → auto-pick winner
  - AI generate variations, spread schedule, monitor 24-72h, report winner + insight, auto-scale

- **🏆 Creator Gamification System**: Creator Level (1-50), XP per action, daily streak, weekly quests, achievements, Creator Score, seasonal challenges, referral quests
  - streak rewards: 7-day = +50 credits, 30-day = +200 credits
  - achievements: shareable → organic growth
  - link: Pack 02 Achievement Context objects

**Acceptance Criteria**:
- required logs gồm provider, model, cost, latency, status, diagnostics, lineage
- asset versions truy được nguồn gốc (provider + model + prompt)
- generation failure có explanation usable + auto-fallback to secondary provider
- user chọn được model cụ thể hoặc "Tự động" → system hiện estimated credit cost
- lip-sync output khớp audio (QA drift check vs canonical character)
- post-production mix output normalize -14 LUFS, aspect ratio correct
- Clip Factory virality score phải sử dụng data từ Trend Engine (M02/M03), không chỉ pattern chung
- AI Remix output phải pass originality check (<30% script similarity vs reference)
- AI Remix KHÔNG sử dụng bất kỳ footage/audio gốc nào — chỉ dùng analysis data
- Quick Edit text-based editing phải sync transcript ↔ video timeline real-time
- Multi-Merge output phải pass compliance scan trước export
- Product Showcase: background removal clean, product recognizable, Virtual Try-On proportions natural
- Link-to-Video: product data extraction accurate (price, reviews), script relevant to product
- Translation: lip-sync quality check, cultural nuance in translation
- Performance Coach: analysis based on REAL platform data, no hallucinated stats
- Gamification: XP calculation event-driven, streak tracking persist across sessions

**Mobile Execution Requirement**:
- xem progress, approve asset, retry/handoff
- chọn model (simplified picker), xem estimated credits
- Quick Edit: review AI suggestions, approve edit plan
- Clip Factory: review clips (swipe cards), select + bulk export
- AI Remix: input URL, review Creative DNA report, approve remix
- Product Showcase: upload photos (camera), select style, preview video
- Image-to-Video: upload photo, select motion style, preview
- Link-to-Video: paste URL, review generated video
- Performance Coach: daily/weekly push notifications with insights
- Gamification: streak counter on home screen, achievement notifications

### 23.8 M08 — Continuity OS
**Mục tiêu**: giải quyết pain thiếu nhất quán trong AI content + cung cấp Character Builder để user tạo và quản lý nhân vật AI.

**Primary Objects**: Character, Character Pack, Brand Pack, Voice Pack, Scene Memory, Lookbook, Approved Reference, Continuity Violation.

**Functions**:
- **character builder** (tạo/quản lý nhân vật AI — digital twin, AI generated, stock avatar)
- **character default selection** (chọn nhân vật mặc định cho video generation)
- **voice clone** (clone giọng nói gắn liền với character)
- continuity packs
- approved references
- prompt lineage
- continuity QA
- continuity-safe regeneration
- drift flags
- promote canonical asset

**Acceptance Criteria**:
- user tạo được character qua 4-step wizard (type → profile → preview → save)
- character tự động tạo Character Pack canonical (continuity integration)
- user chọn character tại bước script hoặc generation
- default character auto-selected khi mở video generation flow
- digital twin phải pass consent verification trước khi sử dụng
- output drift phải được cảnh báo (so với canonical character visual/voice)
- continuity history truy được xuyên assets
- character slots gating per tier (Free: 1, Starter: 2, Pro: 5, Business: 15)

**Mobile Execution Requirement**:
- tạo character (stock/AI generated), chọn character khi generate
- chọn pack, review drift, approve canonical reference

### 23.9 M09 — Asset Derivative Manager / Repurpose Hub
**Mục tiêu**: quản lý lifecycle của asset derivatives (clips, variants, repurposed outputs) sau khi được tạo bởi M07 production modes — đảm bảo traceability, organize, và route vào packaging/publish.

> **Quan hệ M07 ↔ M09**: M07 (AI Video Studio) là **production engine** tạo ra derivatives (Clip Factory cắt clips, Multi-Merge ghép video, Quick Edit chỉnh video). M09 là **derivative hub** quản lý output lifecycle: organize, tag, link lineage, prepare cho packaging/publish. Không overlap sản xuất.

**Primary Objects**: Clip, Variant, Derivative Asset, Clip Collection, Repurpose Job.

**Functions**:
- derivative library (browse, search, filter tất cả clips/variants/remixes)
- clip/variant organizing (folders, tags, collections)
- lineage inspector (source → derivative → publish trail)
- batch operations (tag, archive, delete, queue publish cho nhiều derivatives)
- live highlight management (organize highlights từ M17)
- repurpose recommendations (AI gợi ý từ source asset: "Cắt thành 3 clips nữa?")
- derivative performance tracking (xem clip nào perform tốt nhất)
- ratio/CTA/subtitle variant management

**Acceptance Criteria**:
- mọi derivative phải link về source asset (lineage mandatory)
- variant purpose và target channel phải rõ
- clip/derivative đi tiếp được sang M10 (packaging) / M11 (publish) liền mạch
- performance attribution: clip performance feed ngược về source asset analytics
- batch operations phải support ≥100 items cùng lúc

**Mobile Execution Requirement**:
- review clip list (swipe cards), approve, queue publish
- quick share derivative, quick tag/organize

### 23.10 M10 — Packaging QA / Upload Copilot / Experiment Lab
**Mục tiêu**: biến content thành content sẵn sàng ra thị trường và tối ưu chuyển đổi.

**Primary Objects**: Packaging Checklist, Experiment, Publish Item, Offer, Coupon.

**Functions**:
- hook score
- title score
- caption score
- CTA check
- disclosure check
- coupon/link check
- packaging score
- readiness checklist
- A/B variant compare
- upload presets
- experiment design

**Acceptance Criteria**:
- mọi publish attempt có packaging QA panel
- mọi error/readiness gap có suggested fix hoặc override
- override phải có reason nếu bypass trust-critical checks

**Mobile Execution Requirement**:
- quick readiness check, quick fix, quick queue

### 23.11 M11 — Publish Hub
**Mục tiêu**: điều phối publish đa nền tảng với capability clarity.

**Primary Objects**: Publish Item, Publish Job, Publish Log, Queue Item, Capability Snapshot, Approval Request.

**Functions**:
- content calendar
- queue
- direct publish
- draft publish
- export package
- manual fallback
- approvals
- batch publish
- diagnostics
- retry/requeue
- post-publish sync

**Acceptance Criteria**:
- mỗi publish action hiển thị capability status theo platform
- publish logs lưu capability snapshot, diagnostics, evidence link
- publish state không được đánh dấu published nếu thiếu publish log success hoặc imported proof tương đương

**Mobile Execution Requirement**:
- quick publish, approve, retry, inspect diagnostics

### 23.12 M12 — Unified Inbox & Engagement Center
**Mục tiêu**: gom interaction thành operating inbox có semantic model nhất quán.

**Primary Objects**: Person/Entity, Thread, Message, Comment, DM, Inquiry, Intent, Suggested Reply, Follow-up Task.

**Functions**:
- unified threads
- intent classification
- AI summaries
- suggested replies
- suggested commerce actions
- moderation where supported
- assignment
- SLA/follow-up states
- comment-to-content
- comment-to-commerce
- sponsor inquiry routing
- sample request routing

**Acceptance Criteria**:
- thread luôn có owner, intent, status, next action
- thread có thể sinh content/commercial/CRM tasks
- thread phải mở được related objects

**Mobile Execution Requirement**:
- swipe triage, quick reply, assign, set next action

> **Tiếp tục ở Part 2/2 từ M13 đến hết tài liệu.**

