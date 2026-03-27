# Creativanta — v3.1 Product Freeze / Build Contract — Part 1/2

> Tài liệu này nối tiếp trực tiếp từ **PRD Master v3.1 (Revised, Freeze-Ready)**.
> Vai trò của tài liệu này là **khóa hợp đồng sản phẩm ở cấp build**, để mọi team đi vào detail design và implementation mà không tự đổi nghĩa sản phẩm.
>
> **Đây không phải PRD thuần** và **chưa phải detail design thuần**.
>
> Đây là tài liệu chốt các lớp sau:
> - canonical contracts
> - field-level product contracts
> - state machine contracts
> - read/write ownership
> - score registry rules
> - traceability từ module tới object, state, event, diagnostics, acceptance
> - UX contract cho web, mobile, beginner flows, degraded states
> - out-of-interpretation rules cho downstream teams

---

## 1. Document Status

- Tên tài liệu: **Creativanta v3.1 Product Freeze / Build Contract**
- Phiên bản: **v3.1**
- Loại tài liệu: **build contract / product freeze**
- Upstream authority: **PRD Master v3.1 (Revised, Freeze-Ready)**
- Downstream targets:
  - detail design
  - system design
  - schema design
  - API contracts
  - UX screen specs
  - workflow engine spec
  - agent framework spec
  - QA acceptance packs
- Rule: downstream documents **được chi tiết hóa**, **không được tự đổi nghĩa** so với tài liệu này

---

## 2. Purpose of This Document

Tài liệu này tồn tại để chốt 8 thứ trước khi sang detail design:

1. **Scope cuối cùng** của từng module và cross-module behavior
2. **Canonical naming** và taxonomy mà mọi team phải dùng giống nhau
3. **Object contracts** ở mức đủ chặt để không bỏ sót logic quan trọng
4. **State machines** và các transition boundaries
5. **Score / confidence / proof / capability** rules
6. **Read / write ownership** để không có nhiều source of truth cho cùng một field
7. **UX contract** cho beginner, non-tech, power-user và degraded states
8. **Acceptance traceability** để QA, FE, BE, AI và data không test theo 5 cách khác nhau

---

## 3. Authority Stack and Precedence Rules

### 3.1 Document Precedence
Thứ tự quyền lực tài liệu như sau:
1. **PRD Master v3.1**
2. **Product Freeze / Build Contract v3.1**
3. **Detail Design Packs**
4. **Implementation Notes / Tickets / RFCs**

### 3.2 Conflict Rule
Nếu downstream spec mâu thuẫn với tài liệu này:
- tài liệu này thắng
- downstream spec phải sửa lại
- không được “giải thích mềm” để né canonical contract

### 3.3 Scope Rule
- không module nào bị cắt khỏi canonical product
- không domain nào được biến thành placeholder mơ hồ
- không được dùng bundle, platform limitation hoặc execution convenience để cắt domain scope

### 3.4 Naming Rule
- module IDs `M01–M23` là canonical
- object names canonical phải giữ nguyên English naming ở tầng system/product
- user-facing label có thể bản địa hóa, nhưng canonical system naming không đổi

---

## 4. What Is Frozen Here

Phần này freeze các lớp mà PRD đã chốt nghĩa nhưng chưa đi đủ sâu:

- canonical module map và module contracts
- object-level product contracts
- cross-module contracts
- field class requirements cho object trọng yếu
- read/write ownership
- state machine families
- score registry framework
- diagnostics hierarchy
- trust and explainability surfaces
- onboarding / empty / broken / repair state contracts
- workflow / recipe / agent runtime contracts
- mobile execution requirements cho từng nhóm task

---

## 5. What Still Moves to Detail Design

Những phần sau không được đổi nghĩa, nhưng sẽ đi chi tiết hơn ở detail design:
- DB schema và storage strategy
- API endpoints / GraphQL / BFF payloads
- exact event payloads
- queue / retry / cron / dead-letter design
- sequence diagrams
- screen-by-screen wireframes
- component-level UI specs
- RBAC matrix ở cấp permission key
- connector-specific error maps
- implementation-specific caching / indexing / search strategy

### 5.1 API Versioning Strategy
- API phải support versioning (URL-based: `/v1/`, `/v2/`)
- Breaking changes bắt buộc tạo version mới
- Non-breaking additions cho phép trong version hiện tại
- Minimum 6-month deprecation window cho old versions
- API changelog bắt buộc duy trì
- Client SDK versioning phải align với API versions

---

## 6. Canonical Module Map

Creativanta gồm đúng **23 modules**, map cố định như sau:

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

Không được đổi thứ tự, đổi số lượng hoặc đổi canonical naming ở downstream specs.

---

## 7. Canonical Operator Modes

6 operator modes canonical:
- Creator Mode
- Seller Mode
- Affiliate Operator Mode
- Live Operator Mode
- Agency / MCN Mode
- Brand Collaboration Mode

### 7.1 Mode Lock Rules
Mọi downstream UX specs bắt buộc map đủ cả 6 mode này.

### 7.2 Mode Derivation Rules
Mode thay đổi:
- home priorities
- navigation emphasis
- quick actions
- recipe recommendations
- notification prioritization
- daily brief composition
- object emphasis

Mode **không** được làm thay đổi canonical domain model.

### 7.3 Brand Collaboration Mode Freeze Rule
Brand Collaboration Mode là mode canonical. Không được bỏ khỏi:
- navigation spec
- home variants
- recipe recommendations
- reporting filters
- proof and payout flows

---

## 8. Canonical Taxonomy Freeze

### 8.1 Source Class Taxonomy
User-facing source classes canonical:
- Official
- Imported
- Inferred
- Estimated
- Unreconciled

#### Mapping Rules
- `Direct`, `Direct Connected`, `Official Direct`, `Connected Official` nếu có ở downstream implementation chỉ là internal alias
- UI canonical badge vẫn phải map về 1 trong 5 lớp trên

### 8.2 Confidence Bands
Canonical confidence bands:
- High
- Medium-High
- Medium
- Low-Medium
- Low

### 8.3 Verification Status
- Verified
- Re-verify
- Pending

### 8.4 Capability States
- Native
- Read-only
- Manual
- Degraded *(added per §46A.6 — partial functionality due to platform/policy change)*
- Unsupported

### 8.5 Reconciliation States
- fully_reconciled
- partially_reconciled
- awaiting_evidence
- imported_only
- inferred_pending_confirmation
- conflict_detected
- manually_overridden

### 8.6 Required User-Facing Trust Surfaces
Mọi surface quan trọng phải có tối thiểu:
- source badge
- confidence badge khi áp dụng
- freshness/last sync
- explanation entry point
- evidence / proof / diagnostics drilldown khi áp dụng

---

## 9. Canonical Navigation and Surface Contract

### 9.1 Surface Types
App có 5 loại surface chuẩn:
- decision surface
- object workspace
- execution surface
- trust / diagnostics surface
- admin / support surface

### 9.2 Navigation Rule
- primary navigation phải tổ chức theo work, object hoặc loop
- không được buộc user mới “học toàn bộ architecture” trước khi làm việc
- global search / command bar là accelerator, không phải cổng duy nhất

### 9.3 Beginner Rule
Người non-tech phải có thể bắt đầu từ:
- Daily Brief
- guided recipes
- suggested actions
- task inbox
- onboarding checklist

---

## 10. Canonical Object Registry

Object registry này định nghĩa các object canonical bắt buộc phải được thể hiện trong cùng One Graph. Registry được chia tier để khóa mức độ contract hóa, **không** để cắt phạm vi tính năng.

### 10.1 Tier A — Core First-Class Objects
Đây là các object downstream bắt buộc phải có standalone contract rõ trong Product Freeze và downstream detail design:
- Workspace
- Connected Account
- Signal
- Trend
- Opportunity
- Idea
- Script
- Asset Brief
- Asset
- Publish Job
- Publish Item
- Publish Log
- Capability Snapshot
- Person / Entity
- Thread
- Message / Comment / DM / Inquiry
- Follow-up Task
- Product
- Offer
- Campaign
- Order
- Refund
- Settlement
- Cost Item
- Profit Snapshot
- Evidence Object
- Proof Bundle
- Workflow
- Workflow Run
- Agent Run
- Diagnostics Record

### 10.2 Tier B — Operational / Support First-Class Objects
Đây là các object first-class có family contract hoặc standalone contract tùy domain, nhưng vẫn bắt buộc có canonical id, owner, lifecycle/relationship rule rõ:
- Hook
- Angle
- Shot List
- Scene
- Clip
- Variant
- Packaging Checklist
- Experiment
- Character Pack
- Brand Pack
- Voice Pack
- Queue Item
- Approval Request
- Channel Post
- Coupon
- Affiliate Link
- Membership Plan
- Store Page
- Reconciliation Record
- Live Session
- Cue Card
- Highlight
- Sample Request
- Sample Shipment
- Recipe Template
- Billing Event
- Metering Record

### 10.3 Tier C — Canonical Supporting / Derived Records
Đây là các supporting objects, policy records, derived records và support entities đã được freeze ở PRD. Chúng không được bỏ qua, nhưng có thể được contract hóa theo family contract thay vì mỗi object một section riêng, miễn là owner, relationship, truth class và auditability vẫn rõ:
- Brand Profile
- Creator Profile
- Seller Profile
- Team Member
- Role
- Permission Set
- Connected Provider
- Region Profile
- Currency Profile
- Search Intent Cluster
- Keyword Cluster
- Competitor Entity
- Product Opportunity
- Watchlist
- Alert
- Benchmark Snapshot
- Confidence Record
- Decision Card
- Expected Impact Model
- Expected Effort Model
- Decision Outcome
- Objection Pattern
- Scene Memory
- Lookbook
- Approved Reference
- Prompt Lineage Record
- Continuity Rule
- Continuity Violation
- Sponsor Inquiry
- Intent
- Suggested Reply
- SKU
- Variant SKU
- Inventory Location
- Stock Movement
- Bundle
- Price Rule
- Promotion Rule
- Click Event
- Lead
- Conversion Event
- Return
- Commission
- Creator Payout
- Affiliate Statement
- Invoice
- Margin Snapshot
- Live Segment
- Creator Assignment
- Trigger Event
- Action Log
- Source Class Record
- Confidence Reason
- Policy Note
- Fallback Path
- Audit Event

### 10.4 Object Class Rule
Không được tạo “shadow object” ở downstream để né canonical object. Nếu cần projection hoặc read model, phải ghi rõ đó là:
- projection
- denormalized read model
- cache view
- derived summary

Tier semantics bắt buộc:
- Tier A: phải có standalone freeze contract + downstream schema/event/UX coverage.
- Tier B: phải có freeze contract ở mức object hoặc family + state/relationship/UX/runtime coverage phù hợp.
- Tier C: phải được coverage bằng family contracts, schema, events, proof/audit rules; không được coi là “ngoài scope”.

---

## 11. Field-Level Product Contracts — Global Rules

### 11.1 Field Class Categories
Mỗi object Tier A khi vào detail design phải phân loại field thành:
- **identity fields**
- **relationship fields**
- **state fields**
- **truth / trust fields**
- **execution fields**
- **commercial / money fields**
- **audit / provenance fields**
- **UX helper fields**

### 11.2 Mandatory Cross-Cutting Field Classes
Mọi object Tier A phải có cách biểu diễn cho:
- identity
- current state
- provenance/source context khi áp dụng
- timestamps tối thiểu cho lifecycle
- relationship refs tối thiểu
- auditability hooks khi object có business side effects

### 11.3 Rule for Optionality
Field optional chỉ được phép khi:
- platform limitation thật sự tồn tại
- object subtype khác nhau
- data chưa available tại thời điểm tạo

Nếu optional vì thiếu data:
- phải có trạng thái hoặc explanation path tương ứng

---

## 12. Object Contracts — Identity, Decision and Creation Layer

### 12.1 Workspace
Bắt buộc có:
- workspace_id
- workspace_type
- display name
- primary region/currency profile refs
- default operator mode
- owner/admin refs
- active module/capability summary
- status

Primary write owner:
- M23 identity/admin layer

Contributing modules:
- M22 chỉ được ghi capability overlays hoặc access-related projections qua contract

Read owners:
- mọi module

#### Freeze Rules
- Workspace là hard tenant boundary
- currency/region mặc định phải được reference rõ, không hardcode rải rác ở UI/logic

### 12.2 Connected Account
Bắt buộc có:
- connected_account_id
- workspace_ref
- connected_provider_ref
- account handle/external id
- granted scopes summary
- connection status
- last_successful_sync_at
- last_failed_sync_at nếu có
- diagnostics ref nếu có
- capability summary ref

Primary write owner:
- M22 connector/capability boundary

Read owners:
- M01, M11, M12, M17, M20, M22, M23

#### Freeze Rules
- Connected Account không được collapse vào ad-hoc settings blob
- connection status, capability visibility và diagnostics path phải đọc được từ canonical graph

### 12.3 Signal
Bắt buộc có:
- signal_id
- signal_type
- source_system / source_provider
- collected_at
- normalized summary
- raw reference or raw payload ref
- related trend refs nếu có
- freshness context
- confidence context nếu có infer/aggregation

Primary write owner:
- ingestion pipeline / intelligence system

Read owners:
- M01, M02, M03, M04, M23

#### Signal Lifecycle States
- detected
- processed
- merged (vào trend cluster)
- expired
- discarded

Signal không có complex state machine nhưng lifecycle states này bắt buộc để tracking freshness và deduplication.

### 12.4 Trend
Bắt buộc có:
- trend_id
- trend cluster or title
- source signals[]
- summary
- why_now
- expected content/commercial relevance
- source class mix
- confidence band
- freshness

Primary write owner:
- M02

Primary read owners:
- M01, M02, M03, M04, M05, M10, M14, M23

### 12.5 Opportunity
Bắt buộc có:
- opportunity_id
- linked trend/signal refs
- opportunity type
- summary
- why it matters
- expected impact
- expected effort
- priority state
- suggested next step
- owner nếu assigned

Primary write owner:
- M04

Read owners:
- M01, M04, M05, M06, M14, M17, M20

#### Freeze Rules
- Opportunity phải map được về source lineage
- Opportunity không được render chỉ như score card tách khỏi object graph

### 12.6 Idea
Bắt buộc có:
- idea_id
- source opportunity/trend refs
- angle/hook refs nếu có
- creator/seller intent
- audience intent
- status
- suggested script direction
- expected publish surface nếu có

Primary write owner:
- M05

Read owners:
- M01, M05, M06, M07, M09, M10

#### Freeze Rules
- Idea không được tồn tại như note rời nếu đã đi vào production flow

### 12.7 Script
Bắt buộc có:
- script_id
- idea_ref
- publish target profile(s)
- asset brief ref
- script body structure
- current lifecycle state
- approval state
- continuity refs nếu có
- offer/product hooks nếu có

Primary write owner:
- M06

Read owners:
- M05, M06, M07, M08, M09, M10, M11, M17

#### Freeze Rules
- Script bắt buộc nối được Idea + Asset Brief + Publish Targets
- lifecycle state và approval state là hai machine tách biệt

### 12.8 Asset Brief
Bắt buộc có:
- asset_brief_id
- source script_ref
- output type
- required scenes/shots
- continuity requirements
- brand/voice requirements
- target publish surfaces
- asset production status

Primary write owner:
- M06

Read owners:
- M06, M07, M08, M09, M10

### 12.9 Asset
Bắt buộc có:
- asset_id
- asset_type
- canonical source script_ref
- asset_brief_ref nếu có
- source generation mode
- source provider
- lineage refs
- continuity refs[] nếu có
- quality state
- approval state
- derivative refs[] nếu có

Primary write owner:
- M07

Contributing modules:
- M09 chỉ được tạo derivative/clip/variant qua contract, không takeover canonical asset ownership

Read owners:
- M06, M07, M08, M09, M10, M11, M17

#### Freeze Rules
- Asset lineage là bắt buộc khi asset do AI / external provider tạo ra
- Asset approval state và generation state là hai state machine khác nhau

### 12.10 Creation Support Records
Family contract này áp dụng cho: Hook, Angle, Shot List, Scene, Clip, Variant, Objection Pattern.

Bắt buộc có:
- canonical id theo subtype
- parent ref (idea/script/asset)
- subtype/classification
- ordering/index nếu object có sequence
- current status hoặc usage status nếu áp dụng
- provenance / generation mode khi object được AI/runtime sinh ra

Primary write owner:
- M05 với Hook/Angle/Objection Pattern
- M06 với Shot List/Scene
- M07 hoặc M09 với Clip/Variant theo asset derivation contract

Read owners:
- M05, M06, M07, M09, M10, M11

---

## 13. Object Contracts — Continuity, Packaging, Publish

### 13.1 Character Pack / Brand Pack / Voice Pack
Mỗi continuity pack phải có:
- pack_id
- pack_type
- owner workspace / brand / creator scope
- approved references[]
- rules summary
- allowed use scope
- current version
- status

Primary write owner:
- M08

Read owners:
- M06, M07, M08, M09, M10

#### Continuity Pack State Machine
- draft
- active
- deprecated
- retired

Allowed transitions:
- draft → active
- active → deprecated / retired
- deprecated → retired / active (re-activate)
- retired là terminal

### 13.2 Continuity Support Records
Family contract này áp dụng cho: Scene Memory, Lookbook, Approved Reference, Prompt Lineage Record, Continuity Rule, Continuity Violation.

Bắt buộc có:
- canonical id theo subtype
- parent pack/ref hoặc asset/script ref
- rule/reference summary
- provenance/source mode
- status/severity nếu áp dụng
- related asset/script refs
- version/timestamp context

Primary write owner:
- M08

Contributing modules:
- M07 và M09 chỉ được append lineage/violation evidence qua contract

Read owners:
- M06, M07, M08, M09, M10, M23

### 13.3 Packaging Checklist
Bắt buộc có:
- checklist_id
- linked script/asset/publish item refs
- readiness checks
- missing items
- warnings
- hard blockers
- override records nếu có
- overall readiness state

Primary write owner:
- M10

Read owners:
- M10, M11, M23

### 13.4 Experiment
Bắt buộc có:
- experiment_id
- experiment_type
- compared objects[]
- success metric definition
- current state
- result summary nếu có
- evidence/proof link khi result được dùng để support claim

Primary write owner:
- M10

Read owners:
- M01, M10, M11, M19, M23

### 13.5 Publish Job
Bắt buộc có:
- publish_job_id
- publish_item_ref
- execution_group_type
- target account/platform scope
- dispatch strategy
- current lifecycle state
- attempt counters
- current queue/worker ref nếu có
- approval request ref nếu có
- last execution summary nếu có

Primary write owner:
- M11 runtime / execution system

Read owners:
- M01, M11, M17, M19, M22, M23

#### Freeze Rules
- Publish Job là canonical execution-attempt group object cho đúng một Publish Item
- Publish Job state không thay thế publish truth; publish truth vẫn là Publish Item + Publish Log

### 13.6 Queue Item / Approval Request
Family contract này áp dụng cho Queue Item và Approval Request.

Bắt buộc có:
- canonical id theo subtype
- parent publish/workflow/commercial action ref
- requested action summary
- current state
- requested_by / acting context
- approver/owner/assignee context
- queue priority/position hoặc approval expiry tùy subtype
- diagnostics/refusal reason nếu có

Primary write owner:
- M11 cho publish queue/approval objects
- M20 cho workflow/agent approval queue objects phát sinh từ runtime

Read owners:
- M01, M10, M11, M20, M21, M23

#### Freeze Rules
- Queue Item và Approval Request phải là inspectable objects, không được ẩn toàn bộ trong internal queue system
- approval outcome phải link ngược được tới affected object(s) và audit trail

### 13.7 Publish Item
Bắt buộc có:
- publish_item_id
- asset_ref
- target platform
- target account
- target format
- publish mode
- schedule_at nếu có
- capability_snapshot_ref
- status
- diagnostics state
- linked offer / campaign refs nếu có

Primary write owner:
- M11

Read owners:
- M01, M10, M11, M12, M17, M19, M22, M23

#### Freeze Rules
- Publish Item là canonical record cho publish intent và publish state
- Publish truth không complete nếu thiếu Publish Log success hoặc imported proof equivalent

### 13.8 Publish Log
Bắt buộc có:
- publish_log_id
- publish_job_ref
- publish_item_ref
- attempted_at
- completed_at hoặc failed_at
- actor / acting mode
- execution path
- capability_snapshot_ref
- result status
- diagnostics ref nếu fail/degrade
- evidence ref hoặc imported proof ref nếu publish thành công

Primary write owner:
- M11 runtime / execution system

Read owners:
- M11, M19, M22, M23

#### Freeze Rules
- Publish truth = Publish Item + Publish Log
- Publish Log là immutable execution evidence record, chỉ append/annotate, không overwrite historical execution truth

### 13.9 Capability Snapshot
Bắt buộc có:
- capability_snapshot_id
- platform / provider context
- action context
- capability state
- policy notes refs[] nếu có
- fallback path ref nếu có
- captured_at

Primary write owner:
- M22

Read owners:
- M11, M20, M21, M22, M23

### 13.10 Channel Post
Bắt buộc có:
- channel_post_id
- publish_item_ref hoặc imported external post ref
- connected account ref
- external permalink/post id
- post status snapshot
- engagement summary snapshot khi áp dụng
- imported_at hoặc synced_at

Primary write owner:
- M11 post-sync boundary

> **Boundary clarification (Audit v5 — M4)**: M11 owns Channel Post canonical write. M22 provides the connector/sync mechanism (API calls to platform). Data flows: Platform API → M22 connector → M11 post-sync boundary → Channel Post creation. M11 is the write owner; M22 is the data transport. This prevents M22 from becoming a shadow truth source.

Read owners:
- M01, M11, M12, M17, M19, M23

---

## 14. Object Contracts — Engagement and Commercial Intent

### 14.1 Person / Entity
Bắt buộc có:
- entity_id
- entity_type
- display name / handle(s)
- platform refs
- linked workspace relationship nếu có
- relationship state nếu có

Primary write owner:
- M12

Contributing modules:
- M18 chỉ được append seeding/sample relationship overlays và related refs qua contract

Read owners:
- M12, M15, M16, M17, M18, M23

### 14.2 Thread
Bắt buộc có:
- thread_id
- thread_type
- entity/person ref nếu có
- owner
- intent
- priority
- status
- next action
- related object refs[]
- SLA/follow-up state nếu áp dụng
- last activity timestamp

Primary write owner:
- M12

Read owners:
- M01, M12, M15, M17, M18, M20, M23

#### Freeze Rules
- `owner`, `intent`, `status`, `next action` là non-negotiable
- Thread phải mở ngược ra messages/comments/DM/inquiry items
- Thread phải đi tiếp được sang follow-up task hoặc business action khi cần

### 14.3 Message / Comment / DM / Inquiry
Bắt buộc có:
- message_id
- parent thread ref
- subtype
- source platform context
- body/content ref
- created_at
- author direction
- moderation / visibility state nếu có
- intent overlay nếu áp dụng

Primary write owner:
- M12 ingestion/runtime

### 14.4 Follow-up Task
Bắt buộc có:
- task_id
- source thread ref hoặc source object ref
- assigned owner
- task type
- due/follow-up timing
- status
- outcome summary nếu có

Primary write owner:
- M12

Contributing modules:
- M18 và M20 chỉ được tạo/update task qua command contract hoặc runtime handoff contract

### 14.5 Engagement Support Records
Family contract này áp dụng cho: Sponsor Inquiry, Intent, Suggested Reply.

Bắt buộc có:
- canonical id theo subtype
- parent thread/message/entity ref
- classification/type
- confidence/provenance nếu là inferred/recommended record
- resolution/usage status nếu áp dụng
- related business object refs khi có

Primary write owner:
- M12

Read owners:
- M01, M12, M15, M17, M18, M20, M23

---

## 15. Object Contracts — Commerce, Orders, Ledger, Proof

### 15.1 Product
Bắt buộc có:
- product_id
- product_type
- title
- catalog status
- pricing baseline nếu có
- inventory applicability
- offer linkage rules
- current availability state

Primary write owner:
- M13

Read owners:
- M03, M05, M10, M13, M14, M15, M16, M17, M19

### 15.2 Catalog Support Records
Family contract này áp dụng cho: SKU, Variant SKU, Inventory Location, Stock Movement.

Bắt buộc có:
- canonical id theo subtype
- parent product ref hoặc inventory scope ref
- availability/quantity/location facts theo subtype
- source class / source system ref
- effective timestamp
- reconciliation or import status nếu áp dụng

Primary write owner:
- M13

Read owners:
- M13, M14, M15, M17, M19, M23

### 15.3 Offer
Bắt buộc có:
- offer_id
- offer_type
- product_ref hoặc product-less declaration
- pricing/value logic
- CTA logic
- channel availability
- lifecycle state
- campaign refs nếu có

Primary write owner:
- M14

Contributing modules:
- M15 chỉ được map/store/surface offer qua store contract, không thay canonical offer ownership

Read owners:
- M01, M10, M11, M12, M14, M15, M16, M17, M19

#### Freeze Rules
- Offer không được tồn tại ở trạng thái ambiguous giữa product-backed và product-less
- User-facing price/value logic phải đọc được từ canonical offer contract, không hardcode ở UI

### 15.4 Monetization Support Objects
Family contract này áp dụng cho: Coupon, Affiliate Link, Membership Plan, Store Page, Bundle, Price Rule, Promotion Rule.

Bắt buộc có:
- canonical id theo subtype
- related product/offer/campaign/store refs theo subtype
- commercial logic summary (discount/commission/entitlement/layout/rule)
- lifecycle state
- effective dates hoặc availability window nếu áp dụng
- auditability for commercial changes

Primary write owner:
- M14 cho Coupon, Affiliate Link, Bundle, Price Rule, Promotion Rule
- M15 cho Membership Plan và Store Page

Read owners:
- M01, M11, M14, M15, M16, M17, M19, M23

### 15.5 Campaign
Bắt buộc có:
- campaign_id
- campaign_type
- related products/offers
- related creators/entities
- related posts/live sessions nếu có
- objective
- state

Primary write owner:
- M14

Contributing modules:
- M16 và M18 chỉ được attach affiliate/seeding relationships qua contract

Read owners:
- M01, M14, M16, M18, M19, M23

### 15.6 Order
Bắt buộc có:
- order_id
- source class
- source system reference
- lifecycle state
- amount / currency
- related product/offer/campaign/post/live refs khi có
- evidence / proof linkage khi dùng trong claim
- reconciliation state nếu áp dụng

Primary write owner:
- M13

Read owners:
- M13, M14, M15, M16, M17, M19, M23

#### Freeze Rules
- Money surfaces không được tự tạo order-like read model rồi dùng như truth thay cho Order contract

### 15.7 Refund / Return
Family contract này áp dụng cho Refund và Return.

Bắt buộc có:
- canonical id theo subtype
- related order ref(s)
- amount/currency hoặc quantity/return scope theo subtype
- reason
- current lifecycle state
- source class / source system ref
- settlement/reconciliation linkage nếu có

Primary write owner:
- M13 cho operational refund/return truth

Contributing modules:
- M19 chỉ được import/annotate finance proof hoặc reconciliation overlays qua contract

Read owners:
- M13, M19, M23

### 15.8 Settlement
Bắt buộc có:
- settlement_id
- related order(s) hoặc batch scope
- gross/net components
- fees/deductions
- source class
- reconciliation state
- effective date(s)

Primary write owner:
- M19 ingestion/finance layer

Read owners:
- M19, M23

### 15.9 Cost Item
Bắt buộc có:
- cost_item_id
- cost_type
- amount / currency
- related scope
- source class
- evidence/proof link nếu có
- confidence reason nếu chưa đủ proof
- reconciliation state nếu áp dụng

Primary write owner:
- M19

Read owners:
- M01, M14, M19, M23

### 15.10 Reconciliation / Payout Support Records
Family contract này áp dụng cho: Reconciliation Record, Click Event, Lead, Conversion Event, Commission, Creator Payout, Affiliate Statement, Invoice, Margin Snapshot.

Bắt buộc có:
- canonical id theo subtype
- related commercial/financial object refs
- source class / provenance
- current lifecycle or calculation status
- effective period / timestamp
- mismatch/proof/audit context nếu áp dụng

Primary write owner:
- M19

Read owners:
- M14, M16, M17, M19, M23

### 15.11 Profit Snapshot
Bắt buộc có:
- snapshot_id
- scope type
- scope ref
- snapshot period
- revenue components
- cost components
- margin/profit outputs
- source mix summary
- confidence summary
- freshness

Primary write owner:
- M19 derived truth layer

Read owners:
- M01, M14, M19, M23

### 15.12 Evidence Object
Bắt buộc có:
- evidence_id
- evidence_type
- source provenance
- immutable content ref/hash nếu áp dụng
- collected_at
- verification status
- related object refs[]

Primary write owner:
- M19 proof layer

Contributing modules:
- M11, M23 và ingestion systems chỉ được append/submit evidence capture qua contract

Read owners:
- M19, M23 và mọi module mở proof drawer

### 15.13 Proof Bundle
Bắt buộc có:
- proof_bundle_id
- claim scope
- claim summary
- supporting evidence refs[]
- source class context
- confidence context
- coverage summary
- unresolved gaps

Primary write owner:
- M19 proof layer

Read owners:
- M01, M14, M16, M17, M19, M23

#### Freeze Rules
- `Evidence Object` là bằng chứng đơn lẻ
- `Proof Bundle` là tập bằng chứng hỗ trợ cho một claim
- `Confidence Reason` là lớp giải thích mức tin cậy, không phải vật thay thế Proof Bundle

---

## 16. Object Contracts — Workflow, Agent, Diagnostics, Admin

### 16.1 Workflow
Bắt buộc có:
- workflow_id
- workflow type
- trigger definition
- action chain definition
- approval requirements nếu có
- status
- version
- owner scope

Primary write owner:
- M20

Read owners:
- M20, M21, M23

### 16.2 Workflow Run
Bắt buộc có:
- workflow_run_id
- workflow_ref
- trigger event context
- started_at
- current node/action
- current state
- result summary
- affected objects[]
- diagnostics ref nếu có
- audit ref nếu có

Primary write owner:
- M20 runtime

Read owners:
- M20, M21, M23

### 16.3 Agent Run
Bắt buộc có:
- agent_run_id
- recipe/workflow/context refs
- plan summary
- execution scope
- approval state nếu có
- current state
- side effects summary
- handoff target nếu có
- diagnostics ref nếu có
- audit ref nếu có

Primary write owner:
- M21 runtime

Read owners:
- M20, M21, M23

### 16.4 Operations Support Objects
Family contract này áp dụng cho: Live Session, Live Segment, Cue Card, Highlight, Sample Request, Sample Shipment, Creator Assignment, Recipe Template.

Bắt buộc có:
- canonical id theo subtype
- parent scope ref (campaign/live/session/entity/workflow)
- current lifecycle state hoặc usage state
- owner/assignee if applicable
- timing window / effective period nếu áp dụng
- related product/offer/thread refs khi có
- auditability for business-critical transitions

Primary write owner:
- M17 cho Live Session, Live Segment, Cue Card, Highlight
- M18 cho Sample Request, Sample Shipment, Creator Assignment
- M21 cho Recipe Template

Read owners:
- M11, M12, M14, M17, M18, M20, M21, M23

### 16.5 Runtime Support Records
Family contract này áp dụng cho: Trigger Event, Action Log.

Bắt buộc có:
- canonical id theo subtype
- runtime/workflow/agent ref
- action or trigger summary
- emitted_at/executed_at
- affected object refs
- outcome summary
- diagnostics/audit refs nếu có

Primary write owner:
- M20 runtime

Contributing modules:
- M21 runtime có thể append agent-side runtime records theo shared runtime contract

Read owners:
- M20, M21, M23

### 16.6 Diagnostics Record
Bắt buộc có:
- diagnostics_id
- scope type / scope ref
- error or degraded type
- severity
- user-facing explanation
- operator explanation
- likely causes
- suggested actions / repair path
- detected_at
- current status

Primary write owner:
- M23 diagnostics/admin layer

Contributing modules:
- M07, M11, M20, M22 runtime systems chỉ được emit diagnostics facts/events qua contract

Read owners:
- M01, M07, M11, M20, M22, M23

### 16.7 Billing Event / Metering Record
Bắt buộc có:
- billing_event_id hoặc metering_record_id
- workspace scope
- feature scope
- usage measure
- pricing context
- event time
- reconciliation state nếu áp dụng

Primary write owner:
- M23

### 16.8 Trust / Policy Support Records
Family contract này áp dụng cho: Source Class Record, Confidence Reason, Policy Note, Fallback Path, Audit Event.

Bắt buộc có:
- canonical id theo subtype
- parent object ref hoặc parent action ref
- explanation/policy/audit summary
- source/provenance context khi áp dụng
- effective time/version context
- actor/system context khi áp dụng

Primary write owner:
- M19 cho Confidence Reason gắn profit/proof
- M22 cho Policy Note và Fallback Path
- M23 cho Audit Event và shared source-class governance records

Read owners:
- mọi module cần trust/proof/diagnostics explanation

---

## 17. Read / Write Ownership Matrix — Rules

### 17.1 General Rule
Mỗi object canonical phải có **single primary write owner** ở cấp product contract.

### 17.2 Shared Read Rule
Nhiều module có thể đọc cùng object, nhưng không được tự ý ghi đè state thuộc module owner.

### 17.3 Projection Rule
Nếu module cần view riêng:
- dùng projection/read model
- không mutate canonical write contract một cách không traceable

### 17.4 User Edit Rule
User edit trực tiếp chỉ được phép ở những field classes mà module owner cho phép.

### 17.5 Automation Rule
Workflow/agent có thể mutate object chỉ khi:
- action được policy cho phép
- audit trail được lưu
- state transition hợp lệ
- capability state không cấm action đó

---

## 18. Module Contracts — M01 to M12

### 18.1 M01 — Home / Daily Decision Engine
**Primary mission**: đưa user tới hành động có impact cao nhất hôm nay.

**Primary reads**:
- Opportunity
- Thread
- Profit Snapshot
- Diagnostics Record
- Approval Request
- Publish Item summaries

**Must support**:
- top actions
- top risks
- top profitable actions
- pending approvals
- urgent conversation work
- trust warnings
- drilldown to real objects

**Must not become**:
- vanity dashboard
- dead-end KPI page

**Key acceptance**:
- mọi card có CTA chính
- card mở ra object hoặc flow thật
- mode-aware composition hoạt động
- beginner copy phải dễ hiểu

### 18.2 M02 — Trend Fusion Radar
**Write owner**: Trend and signal normalization.

**Must support**:
- ingest
- classify
- score velocity/freshness/saturation
- watchlists
- alerts
- convert to Opportunity / Idea / Product Opportunity

**Trust contract**:
- trend score giải thích được
- freshness luôn hiển thị
- inferred trend clusters phải gắn nhãn inferred/confidence

### 18.3 M03 — Research & Competitor Intelligence
**Must support**:
- competitor registry
- benchmark snapshots
- offer/pricing comparison
- format/content pattern analysis
- white-space mapping

**Trust contract**:
- market inference không được hiển thị như accounting truth
- benchmark date range và source provenance phải truy được

### 18.4 M04 — Opportunity Board
**Must support**:
- priority and ranking
- owner assignment
- effort/impact view
- status progression
- conversion to downstream work

**Contract**:
- owner là bắt buộc
- priority reason là bắt buộc
- downstream conversion không được tạo orphan work

### 18.5 M05 — Idea Engine
**Must support**:
- idea generation from trend/product/comments/objections
- hook / angle / format suggestions
- dedupe / clustering
- conversion to Script or execution plan

**Contract**:
- mọi idea phải có source lineage
- idea score không được vô nghĩa / opaque

### 18.6 M06 — Script Lab
**Must support**:
- templates
- drafting
- approvals
- disclosure blocks
- CTA blocks
- asset brief creation
- publish target mapping

**Contract**:
- script incomplete nếu không map được publish intent
- script approval state tách biệt generation state

### 18.7 M07 — AI Video Studio
**Must support**:
- multi-provider routing (Veo 3.1, Kling 3.0, Runway Gen-4; Flux 2, GPT Image; ElevenLabs, SyncLabs)
- Smart Pipeline Router (Native Audio / Audio-First / Post-Prod Lip-Sync / Voice-Over)
- model selector UX (user chọn model hoặc "Tự động")
- job lifecycle, cost tracking, retries / diagnostics, versioning, lineage, BYOK support
- lip-sync orchestration (SyncLabs / Wav2Lip)
- post-production mix (rust-ffmpeg: audio ducking, normalize, subtitles)
- **4 Core Production Modes + 11 Extended Features**:
  - **Quick Edit** (1→1): text-based editing, animated captions, active speaker detection, beat-sync, AI B-roll gen, Smart Hook Library (50+ hooks), copyright-safe audio, platform presets
  - **Clip Factory** (1→N): scene detection + Whisper ASR + LLM highlight detection → Virality Score (0-100 using Trend Engine M02/M03 data) → batch export
  - **Multi-Merge** (N→1): drag-reorder, AI transitions, voice-over (Character Pack), background music, target duration
  - **AI Remix Studio** (ref→new): 3-phase pipeline (Analyze Creative DNA 8-layer → Remix script+visual+voice → Polish compliance+virality). Fidelity levels: Match 1:1 / Adapt / Loose
- **Trend-Aware Editing**: trending hook injection, caption style, music sync từ Trend Engine
- Character Builder integration (select character khi generate)
- video analysis stack: Google Video Intelligence, Whisper ASR, ACRCloud, Librosa, mediapipe

- **Extended Production Features** (Pack 04 §9.6-9.16):
  - **AI Product Showcase Studio** (8 styles: 360° Spin, Tabletop Demo, Flip & Reveal, Virtual Try-On, Lifestyle, Unboxing, Before/After, Review Style + batch mode + Product Hub integration)
  - **Image-to-Video Converter** (6 motion styles, 3-15s, Veo/Kling image-to-video API)
  - **AI Thumbnail Studio** (generate + A/B test + brand consistency)
  - **Link-to-Video Generator** (URL → video ad, Shopee/Lazada/TikTok Shop/Amazon, 5 script templates)
  - **AI Translation & Localization Studio** (Whisper → LLM translate → voice clone → lip-sync, 8 languages v1)
  - **AI Sound Studio** (AI music gen + beat-drop sync + speech-to-song + AI SFX)
  - **AI Style Learning** (extract editing style → Style Pack → Continuity OS, future marketplace)
  - **AI Video Agent** (1-click: prompt → full pipeline → ready-to-publish)
  - **AI Performance Coach** (post-publish analysis + weekly report + coaching)
  - **Video A/B Testing Engine** (N variations → spread publish → auto-winner)
  - **Creator Gamification System** (Level 1-50, XP, streaks, quests, achievements, seasonal challenges)

**Contract**:
- generation failure phải có diagnostics usable
- cost visibility bắt buộc cho business-critical usage
- auto-fallback to secondary provider khi primary fails
- Clip Factory virality score phải dùng REAL data từ Trend Engine (M02/M03)
- AI Remix output phải pass originality check (<30% script similarity vs reference)
- AI Remix KHÔNG sử dụng footage/audio gốc — chỉ analysis data
- Quick Edit text-based editing phải sync transcript ↔ video timeline real-time
- Multi-Merge output phải pass compliance scan trước export
- lip-sync output phải qua QA drift check vs canonical character
- legal safeguards: originality score, no footage reuse, script similarity <30%, abuse detection (max 20 remixes/day)
- Product Showcase: background removal clean, product recognizable, Virtual Try-On proportions natural, batch partial failure handling
- Link-to-Video: product data extraction accurate, script contextually appropriate
- Translation: lip-sync quality check, cultural nuance in translation
- Performance Coach: analysis based on REAL platform data, no hallucinated stats
- Gamification: XP event-driven, streak persist across sessions, credits reward auditable

### 18.8 M08 — Continuity OS
**Must support**:
- continuity packs
- approved references
- prompt lineage
- drift detection
- continuity-safe regeneration
- **Character Builder** (3 types: digital twin, AI generated, stock)
- character ↔ continuity integration (auto-create Character Pack)
- character selection UX (default character, video generation picker)
- voice clone integration (ElevenLabs)
- Digital Twin consent flow (EU AI Act compliant)
- character slots gating per tier (Free: 1, Starter: 2, Pro: 5, Business: 15)

**Contract**:
- continuity violation phải mở được explanation path
- canonical approved reference phải versioned
- Character Pack auto-created khi Character saved
- character type Digital Twin phải có explicit consent record

### 18.9 M09 — Asset Derivative Manager / Repurpose Hub
**Must support**:
- derivative library (browse, search, filter clips/variants/remixes)
- clip/variant organizing (folders, tags, collections)
- lineage inspector (source → derivative → publish)
- batch operations (tag, archive, delete, queue publish)
- live highlight management (organize highlights từ M17)
- repurpose recommendations (AI gợi ý)
- derivative performance tracking
- ratio/CTA/subtitle variant management

> **M07 ↔ M09 boundary**: M07 = production engine (Quick Edit, Clip Factory, Multi-Merge, Remix). M09 = output lifecycle manager (organize, tag, track, route derivatives vào packaging/publish). Không overlap.

**Contract**:
- every derivative asset links back to source asset (lineage mandatory)
- every clip/variant has target intent và target channel
- batch operations phải support ≥100 items cùng lúc
- clip performance feed ngược về source asset analytics

### 18.10 M10 — Packaging QA / Upload Copilot / Experiment Lab
**Must support**:
- readiness checks
- hook/title/caption/CTA/disclosure checks
- experiment setup
- override with reason

**Contract**:
- blockers vs warnings phải tách bạch
- hard trust-critical checks không được bị bypass im lặng

### 18.11 M11 — Publish Hub
**Must support**:
- queue/schedule
- direct publish where native
- export/manual fallback
- approvals
- retries
- post-publish sync
- logs and diagnostics

**Contract**:
- action hiển thị capability state trước khi execute
- publish success phải có log/evidence path
- manual fallback vẫn phải giữ publish intent trong graph

### 18.12 M12 — Unified Inbox & Engagement Center
**Must support**:
- unified thread model
- intent classification
- assignment
- suggested replies
- suggested business action
- sponsor inquiry handling
- sample request routing
- SLA/follow-up states

**Contract**:
- owner / intent / status / next action là mandatory
- thread phải có link tới related business objects khi có
- moderation/capability limitations phải hiển thị rõ

---

## 19. Transition to Part 2

**Part 2/2** tiếp tục với:
- module contracts M13–M23
- state machine family contracts
- score registry freeze
- UX contract chi tiết
- diagnostics hierarchy
- acceptance traceability matrix
- detail design handoff rules

**Không có phần nào bị cắt scope.**

