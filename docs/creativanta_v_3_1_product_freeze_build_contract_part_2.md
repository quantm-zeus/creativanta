# Creativanta — v3.1 Product Freeze / Build Contract — Part 2/2

> Tài liệu này nối tiếp trực tiếp từ **Part 1/2**. Không có phần nào bị cắt scope.

---

## 20. Module Contracts — M13 to M23

### 20.1 M13 — Product Hub / Inventory / Order Truth
**Primary mission**: tạo commerce truth layer cho catalog, inventory, orders.

**Primary writes**:
- Product
- SKU / inventory projections
- Order truth ingestion
- Refund / Return lifecycle

**Must support**:
- product master
- inventory location and stock movement truth
- order lifecycle truth
- refund/return truth
- product-to-content / product-to-offer mapping

**Contract**:
- product-backed vs product-less offers phải tách bạch
- inventory truth không được tách khỏi stock movement logic
- order state không được đồng nghĩa với settlement state

### 20.2 M14 — Monetization OS
**Primary mission**: vận hành monetization strategy trong cùng graph.

**Primary writes**:
- monetization strategy objects
- offer/campaign orchestration metadata
- conversion intent mappings

**Must support**:
- pricing logic
- offer strategy
- coupon / link logic
- sponsorship monetization orchestration
- conversion signal linking

**Contract**:
- monetization surfaces không được đứng riêng ngoài proof / profit layer
- strategy output phải map được tới canonical offer/campaign objects

### 20.3 M15 — Creator Store / Offers / Membership
**Primary mission**: vận hành storefront và commercial surfaces.

**Primary writes**:
- Store Page
- Offer lifecycle aspects
- Membership plan surfaces
- Bundle structures

**Must support**:
- storefront pages
- memberships
- digital products
- bundle logic
- upsell/cross-sell structures
- price rule exposure

**Contract**:
- store performance phải nối được về M19
- product-less offer phải được khai báo rõ subtype, không mơ hồ

### 20.4 M16 — In-Product Affiliate Network
**Primary mission**: chuẩn hóa affiliate operations, attribution, statements, proof.

**Primary writes**:
- Affiliate Link
- creator assignment overlays
- affiliate campaign metadata
- statement import / reconciliation layer

**Must support**:
- link/coupon assignment
- partner performance views
- commission handling
- affiliate statement reconciliation
- proof-backed partner reporting

**Contract**:
- ambiguous attribution phải hiển thị inferred hoặc unreconciled
- partner payout logic không được trình bày như finalized truth nếu chưa reconcile

### 20.5 M17 — Live Commerce War Room
**Primary mission**: điều phối live commerce execution surface.

**Primary writes**:
- Live Session
- Cue Card
- Highlight
- live-linked conversation/action overlays

**Must support**:
- run-of-show
- live cueing
- offer pinning logic
- thread triage in live context
- highlight marking
- post-live summary and follow-up

**Contract**:
- live timeline phải usable
- highlights là first-class derivatives của live context, không chỉ UI markers
- post-live result view phải mở được proof path khi user dùng để support claim

### 20.6 M18 — Seeding / Sample CRM
**Primary mission**: quản lý sample, creator outreach, shipment, follow-up, outcomes.

**Primary writes**:
- Sample Request
- Sample Shipment
- Creator Assignment
- follow-up tasks

**Must support**:
- creator roster / sample workflows
- shipment tracking
- status/follow-up model
- outcome logging
- performance linkage where available

**Contract**:
- sample request lifecycle tách khỏi shipment lifecycle
- missing proof không được biến thành outcome certainty

### 20.7 M19 — Operating Ledger / Profit Graph / Proof Center
**Primary mission**: canonical truth layer cho revenue, cost, margin, profit, proof.

**Primary writes**:
- Settlement ingestion
- Cost Item truth
- Profit Snapshot derivation
- Reconciliation Record
- Evidence Object / Proof Bundle assembly

**Must support**:
- gross/net/profit views
- by-scope drilldowns
- anomaly detection
- proof drawer
- reconciliation queues
- source class / confidence visibility

**Contract**:
- Official và Estimated không được trộn mà không nhãn
- unreconciled values phải tách bucket riêng
- mọi claim ở surface này phải mở được evidence/proof path

### 20.8 M20 — Workflow Studio
**Primary mission**: thiết kế workflow operating loops có kiểm soát.

**Primary writes**:
- Workflow
- workflow templates
- runtime run metadata

**Must support**:
- visual flow
- trigger-condition-action
- approvals
- fallbacks
- retries / dead-letter handling
- dry run / test run

**Contract**:
- business-critical side effects phải có auditability
- workflow failure phải có repair path
- workflow execution phải capability-aware

### 20.9 M21 — Workflow Marketplace / Recipe Economy / Agent Center
**Primary mission**: biến best practice thành reusable operating units và controlled agent execution.

**Primary writes**:
- Recipe Template
- agent plan metadata
- Agent Run metadata

**Must support**:
- install/clone recipes
- parameterized templates
- run recipes
- plan/execute agents
- inspect usage and outcomes

**Contract**:
- recipe/agent không được tạo shadow state ngoài canonical graph
- dependencies và required capabilities phải khai báo rõ trước install/run

### 20.10 M22 — Capability Matrix & Policy Center
**Primary mission**: trung thực hóa capability, policy, fallback, degraded execution.

**Primary writes**:
- Capability Snapshot
- Policy Note
- Fallback Path
- diagnostics enrichment

**Must support**:
- platform capability matrix
- policy notes
- execution ownership notes
- fallback guidance
- diagnostics entry points

**Contract**:
- action limitations không được giấu ở deep settings hoặc fine print
- degraded execution phải luôn có explanation path

### 20.11 M23 — Reporting / Admin / Billing / Diagnostics
**Primary mission**: support, reporting, billing, metering, admin, diagnostics as first-class operating layers.

**Primary writes**:
- Report definitions / outputs
- Billing Event
- Metering Record
- admin override actions
- diagnostics consoles / support metadata

**Must support**:
- support-friendly diagnostics hierarchy
- billing visibility
- usage metering
- controlled overrides
- report surfaces by workspace / creator / product / offer / campaign / live / financial scopes

**Contract**:
- admin override phải có reason + audit trail
- reporting không được tự tạo truth khác M19/M13/M11 canonical layers

---

## 21. State Machine Family Contracts

### 21.1 General Rule
Mọi state machine bắt buộc phải có:
- explicit states
- allowed transitions
- invalid transition handling
- state timestamps
- actor attribution for state change
- audit event emission for business-critical transitions

### 21.2 Separation Rule
Không được trộn nhiều loại state khác nhau vào một field duy nhất. Ít nhất phải tách giữa:
- lifecycle state
- approval state
- diagnostics state
- reconciliation state
- visibility/publication state khi cần

---

## 22. State Machine — Opportunity

### 22.1 Lifecycle States
- draft
- open
- prioritized
- assigned
- in_progress
- converted
- parked
- closed_won
- closed_lost

### 22.2 Allowed Transition Intent
- draft → open
- open → prioritized / parked / closed_lost
- prioritized → assigned / parked
- assigned → in_progress / parked
- in_progress → converted / closed_won / closed_lost / parked
- parked → open / prioritized / closed_lost
- converted là terminal from opportunity execution standpoint

### 22.3 Rules
- `converted` chỉ hợp lệ khi downstream object ref đã tồn tại
- `closed_won` không đồng nghĩa đã có profit proof

---

## 23. State Machine — Idea / Script / Asset Brief / Asset

### 23.1 Idea States
- draft
- candidate
- selected
- converted
- archived

### 23.1.1 Idea Allowed Transition Intent
- draft → candidate / archived
- candidate → selected / archived
- selected → converted / archived
- archived → draft (re-open)
- converted là terminal from idea execution standpoint; downstream object ref bắt buộc tồn tại

### 23.2 Script Lifecycle States
- draft
- in_review
- approved
- revision_required
- ready_for_production
- archived

### 23.3 Script Approval States
- not_submitted
- pending_approval
- approved
- rejected

### 23.4 Asset Brief States
- draft
- ready
- locked
- superseded

### 23.5 Asset Generation States
- queued
- generating
- generated
- failed
- cancelled

### 23.6 Asset Quality / Approval States
- draft
- review_required
- approved
- rejected
- promoted_canonical

### 23.7 Rules
- script lifecycle và approval là 2 machines riêng
- asset generation và asset approval là 2 machines riêng
- `ready_for_production` script yêu cầu asset brief ref hợp lệ
- `promoted_canonical` asset phải để lại continuity lineage event nếu liên quan M08

---

## 24. State Machine — Publish / Queue / Approval

### 24.1 Publish Job Lifecycle States
- created
- queued
- dispatched
- executing
- partially_succeeded
- succeeded
- failed
- cancelled
- requires_manual_fallback

### 24.2 Queue Item States
- pending
- scheduled
- blocked
- ready
- claimed
- completed
- expired
- removed

### 24.3 Publish Item Lifecycle States
- draft
- queued
- scheduled
- ready_to_execute
- executing
- published
- partially_published
- failed
- cancelled
- requires_manual_fallback

### 24.4 Publish Diagnostics States
- healthy
- warning
- degraded
- blocked

### 24.5 Approval Request States
- not_required
- pending_approval
- approved
- rejected
- expired
- cancelled

### 24.6 Rules
- `published` chỉ hợp lệ khi có Publish Log success hoặc imported proof equivalent
- Publish Job state và Publish Item state là hai machines khác nhau; job không thay item truth
- Queue Item phải inspectable được ở UI/runtime để repair, retry và audit
- `requires_manual_fallback` không được coi là terminal success

---

## 25. State Machine — Thread / Follow-up Task

### 25.1 Thread Lifecycle States
- new
- triaged
- active
- waiting_on_user
- waiting_on_team
- converted_to_task
- resolved
- archived

### 25.2 Thread Priority States
- urgent
- high
- normal
- low

### 25.3 Follow-up Task States
- open
- in_progress
- blocked
- completed
- cancelled

### 25.4 Rules
- thread luôn phải có `next action` trừ khi ở `resolved` hoặc `archived`
- `converted_to_task` không đóng thread tự động nếu conversation còn active

---

## 26. State Machine — Offer / Campaign / Store / Monetization Support

### 26.1 Offer Lifecycle States
- draft
- review_required
- active
- paused
- expired
- retired

### 26.2 Campaign States
- planned
- ready
- live
- paused
- completed
- cancelled

### 26.3 Coupon States
- draft
- active
- paused
- expired
- retired

### 26.4 Affiliate Link States
- draft
- active
- paused
- revoked
- expired

### 26.5 Membership Plan States
- draft
- active
- hidden
- paused
- retired

### 26.6 Store Page States
- draft
- published
- hidden
- retired

### 26.7 Rules
- `active` offer yêu cầu pricing/value contract hoàn chỉnh
- campaign completion không mặc định bằng success; reporting/proof phải xác định riêng
- coupon, affiliate link, membership plan và store page phải có audit trail cho mọi commercial state changes

---

## 27. State Machine — Order / Refund / Settlement / Reconciliation / Cost

### 27.1 Order Lifecycle States
- created
- confirmed
- fulfilled
- completed
- refunded
- partially_refunded
- returned
- cancelled

### 27.2 Refund States
- requested
- approved
- rejected
- processing
- completed
- failed
- cancelled

### 27.3 Return Support States
- initiated
- approved
- shipped_back
- received
- inspected
- closed
- rejected

### 27.4 Settlement States
- imported
- pending_reconciliation
- reconciled
- partially_reconciled
- disputed

### 27.5 Cost Item States
- recorded
- pending_evidence
- reconciled
- estimated
- superseded

### 27.6 Reconciliation Record States
- open
- awaiting_evidence
- matching
- partially_reconciled
- fully_reconciled
- conflict_detected
- manually_overridden
- closed

### 27.7 Rules
- settlement state không thay thế order/refund state
- refund và return có thể cùng tồn tại nhưng không được collapse thành một state field mơ hồ
- cost item `estimated` không được render như official cost truth
- manual override bắt buộc có reason + audit event

---

## 28. State Machine — Workflow Run / Agent Run / Recipe Template

### 28.1 Workflow Run States
- queued
- running
- waiting_approval
- waiting_external_condition
- succeeded
- partially_succeeded
- failed
- cancelled
- requires_manual_intervention

### 28.2 Agent Run States
- planning
- awaiting_approval
- executing
- waiting_context
- completed
- partially_completed
- failed
- handed_off
- cancelled

### 28.3 Recipe Template States
- draft
- review_required
- published
- deprecated
- retired

### 28.4 Rules
- workflow/agent states phải gắn side-effect summary
- `partially_succeeded` và `partially_completed` yêu cầu unresolved actions summary
- `handed_off` bắt buộc có human owner tiếp theo
- recipe template state không được dùng để override runtime states của workflow/agent runs

---

## 29. State Machine — Live / Seeding

### 29.1 Live Session States
- planned
- ready
- live
- paused
- ended
- post_live_processing
- closed

### 29.2 Sample Request States
- requested
- approved
- declined
- fulfilled
- cancelled

### 29.3 Sample Shipment States
- preparing
- shipped
- delivered
- lost
- returned
- closed

### 29.4 Rules
- sample request và shipment phải tách state machine
- live ended chưa đồng nghĩa post-live reporting hoàn tất
- live segment/highlight là support records, không được thay thế live session state machine

---

## 30. Score Registry Freeze

### 30.1 Goal
Mọi score trong hệ thống phải giải thích được, không được là magic number.

### 30.2 Score Classes
- intelligence scores
- decision scores
- packaging/readiness scores
- fit scores
- financial/profit confidence scores
- operational health scores

### 30.3 Canonical Score Registry Entries
Tối thiểu freeze các score sau:
- Trend Strength
- Trend Freshness
- Trend Saturation
- Opportunity Priority
- Expected Impact
- Expected Effort
- Idea Score
- Packaging Score
- Readiness Score
- Fit Score (subtypes allowed)
- Profit Confidence
- Proof Strength
- Connector Health
- Workflow Reliability

### 30.4 Score Contract Template
Mỗi score phải có:
- score name
- score purpose
- input families
- output range/class
- missing input behavior
- freshness/update cadence
- confidence/explanation rules
- “what improves this score” explanation path

### 30.5 User-Facing Rule
User-facing score phải trả lời được:
- score này đo cái gì
- dựa vào dữ liệu gì
- còn thiếu gì
- làm gì để cải thiện

---

## 31. Fit Graph Contract

### 31.1 Canonical Fit Types
- Product × Creator Fit
- Product × Format Fit
- Product × Offer Fit
- Creator × Offer Fit
- Hook × Offer Fit
- Trend × Niche Fit
- Comment Intent × Offer Fit
- Live Segment × Conversion Fit
- Content Type × Margin Fit

### 31.2 Fit Output Rules
Fit output phải gồm:
- recommended action
- fit basis summary
- evidence/history backing nếu có
- confidence band
- missing data warnings khi áp dụng

### 31.3 Fit Governance Rule
Fit score không được hiển thị như deterministic truth nếu chỉ dựa trên sparse data hoặc heuristic nhẹ.

---

## 32. Simulation Contract

### 32.1 Simulation Families
- content output scenarios
- offer/pricing scenarios
- channel mix scenarios
- creator allocation scenarios
- live structure scenarios
- cost/margin sensitivity scenarios

### 32.2 Simulation Run Contract
Mỗi simulation run phải có:
- simulation_run_id
- simulation_type
- input scope
- assumptions
- scenario variants
- output summaries
- confidence / caveat summary
- saved status nếu user lưu

### 32.3 Critical Rules
- simulation output không được đồng nhất với Official truth
- assumptions phải luôn nhìn thấy được
- saved scenario có thể link với relevant canonical objects nhưng không mutate truth objects nếu user chưa commit

---

## 33. Workflow / Recipe / Agent Runtime Contract

### 33.1 Runtime Boundaries
Workflow và agent chỉ được phép:
- đọc canonical objects
- mutate through allowed actions
- ghi action logs
- emit diagnostics and audit events

### 33.2 Forbidden Behavior
- không được tạo parallel state outside canonical graph
- không được side-effect business-critical action mà thiếu audit trail
- không được giả vờ Native nếu action thực tế là Manual hoặc Unsupported

### 33.3 Approval Boundaries
Approval bắt buộc cho các nhóm action sau khi được policy đánh dấu:
- publish to external surface
- commercial changes có impact trực tiếp tới pricing/offer availability
- ledger-impacting overrides
- payout/commission affecting actions
- destructive content/archive/retire actions

### 33.4 Handoff Rules
Nếu workflow/agent không tự hoàn tất được:
- tạo diagnostics + explanation
- assign owner tiếp theo
- preserve context cho human handoff

---

## 34. Diagnostics Hierarchy Freeze

### 34.1 Layers
Diagnostics hierarchy gồm 4 lớp:
1. user-facing explanation
2. operator diagnostics
3. engineering trace reference
4. audit event stream

### 34.2 User-Facing Diagnostics Requirements
Mọi lỗi/degraded state quan trọng phải trả lời được:
- cái gì đang lỗi
- ảnh hưởng gì
- vì sao có thể xảy ra
- user nên làm gì tiếp theo

### 34.3 Operator Diagnostics Requirements
Operator phải thấy được:
- scope affected
- likely causes
- last successful state
- repair path
- manual fallback option nếu có

### 34.4 Engineering Trace Requirements
Detail design sẽ định nghĩa trace IDs/log structure, nhưng build contract chốt rằng:
- engineering trace phải link được từ diagnostics record
- user không bị ép xem engineering logs để hiểu lỗi cơ bản

---

## 35. Beginner UX / Non-Tech Contract

### 35.1 Core Principle
Người non-tech phải dùng được sản phẩm mà không cần hiểu architecture nội bộ trước.

### 35.2 Required UX Layers
Sản phẩm bắt buộc có:
- onboarding wizard
- connector/setup checklist
- recipe-first starting paths
- beginner copy mode trên critical surfaces
- empty state with next step
- partial setup state
- broken state
- repair wizard
- first closed-loop guidance

### 35.3 Language Rule
Trên critical surfaces, UX phải ưu tiên:
- action language
- plain explanation
- “why” and “what next” clarity

Không được chỉ đưa raw score / raw status mà không giải thích.

### 35.4 Anti-Overwhelm Rules
Không được:
- đẩy user mới vào quá nhiều module cùng lúc
- lộ quá nhiều low-level controls ngay entry flow
- dùng command-heavy UX như primary entry path cho beginner

---

## 36. Empty, Partial, Broken, Repair State Contract

### 36.1 Empty State
Mọi empty state phải có:
- giải thích object / module này dùng để làm gì
- bước đầu tiên để bắt đầu
- đường vào nhanh bằng recipe hoặc setup

### 36.2 Partial Setup State
Khi object/domain có dữ liệu chưa đủ:
- phải chỉ rõ thiếu cái gì
- tác động tới score/truth/capability là gì
- step tiếp theo để nâng cấp trạng thái

### 36.3 Broken State
Khi connector/capability/runtime fail:
- phải có clear broken indicator
- phải có repair CTA
- không được im lặng fail rồi để user đoán

### 36.4 Repair Wizard
Repair wizard phải có:
- issue summary
- what changed / why broken nếu biết
- recommended fix path
- permission/scope requirements nếu cần reconnect
- post-repair verification

---

## 37. Web / Mobile Execution Contract

### 37.1 Rule
Web và mobile đều là execution surfaces thật, không có mobile view-only.

### 37.2 Mobile Mandatory Task Families
Mobile bắt buộc support ít nhất:
- review / approve script
- review / approve asset
- quick publish / retry / inspect diagnostics
- thread triage / quick reply / assign / next action
- live monitoring / cue / highlight actions
- offer quick edit / link share / coupon access
- profit anomaly inspect / follow-up assign
- workflow/agent run inspect / approval/handoff

### 37.3 Mobile UX Constraints
- thumb-friendly actions
- fast task-oriented entry points
- minimized deep branching for urgent flows

---

## 38. Cross-Module Contract Matrix

### 38.1 Signal → Opportunity / Idea
- M02/M03 must feed M04 or M05 without orphaning source lineage

### 38.2 Opportunity → Idea / Script / Campaign / Live Plan
- M04 conversion must preserve source refs and rationale

### 38.3 Idea → Script
- M05 to M06 must preserve hook/angle/audience/goal context

### 38.4 Script → Asset Brief → Asset
- M06 to M07/M08/M09 must preserve continuity and publish intent

### 38.5 Asset → Packaging → Publish
- M07/M09 to M10/M11 must preserve readiness signals and target context

### 38.6 Publish → Engagement / Commerce / Proof
- M11 outputs must feed M12, M17, M19 through canonical refs and logs

### 38.7 Thread → Task / Idea / Commerce / CRM
- M12 must convert threads into actionable downstream work without losing conversation context

### 38.8 Offer / Campaign → Order / Settlement / Profit
- M14/M15/M16 outputs must map into M13/M19 truth layers

### 38.9 Workflow / Agent → Canonical Objects
- M20/M21 may orchestrate but cannot replace canonical business objects

---

## 39. Acceptance Traceability Matrix — Required Structure

### 39.1 Every Module Must Map To
- primary canonical objects
- key read models / projections
- state machines touched
- events emitted / consumed
- diagnostics keys
- trust surfaces
- acceptance scenarios

### 39.2 Acceptance Scenario Categories
Mỗi module tối thiểu phải có scenario thuộc các nhóm:
- happy path
- degraded path
- missing data path
- broken connector/capability path nếu có
- audit/proof path nếu có business-critical side effects
- mobile path nếu module có mobile execution requirement

### 39.3 Examples of Mandatory Cross-Cut Acceptance
- publish success with log and proof path
- publish degraded requiring manual fallback
- thread triage with next action assignment
- opportunity conversion preserving lineage
- order/settlement/profit drilldown preserving source class and confidence
- workflow side effect with audit trail
- repair flow after connector break

---

## 40. Reporting Contract

### 40.1 Reporting Principle
Reporting là projection và explanation layer, không phải canonical truth owner.

### 40.2 Report Must Declare
- report scope
- source object classes
- source class mix
- freshness
- confidence caveats nếu áp dụng

### 40.3 Forbidden Pattern
Không report nào được:
- silently mix Official với Estimated
- suppress unresolved gaps khi claim performance/profit
- invent alternate business logic ngoài canonical owners

---

## 41. Admin / Override Contract

### 41.1 Override Rule
Override chỉ hợp lệ khi có:
- allowed policy scope
- acting user identity
- reason
- audit event
- impacted objects list

### 41.2 Override Types Requiring Strong Audit
- reconciliation overrides
- payout / commission affecting overrides
- publish state corrections
- destructive archive/retire actions
- workflow/agent force-complete or force-cancel

---

## 42. Data Freshness and Sync Contract

### 42.1 Freshness Rule
Mọi KPI / object summary quan trọng phải có freshness context.

### 42.2 Stale Data Rule
Nếu dữ liệu stale:
- phải hiển thị stale indicator
- score/truth surfaces bị ảnh hưởng phải phản ánh caveat tương ứng

### 42.3 Sync Failure Rule
Nếu sync fail:
- diagnostics record phải được mở
- user phải biết dữ liệu nào có thể outdated
- repair path phải khả dụng

---

## 43. Security / Privacy / Access Contract

### 43.1 Product-Level Freeze
Build contract khóa các yêu cầu sau:
- workspace separation
- RBAC required for write actions
- auditability for business-critical actions
- least privilege connector model
- deletion/export pathways phải tồn tại

### 43.2 Downstream Detail Design Responsibility
Detail design sẽ quy định permission keys cụ thể, nhưng không được hạ thấp các nguyên tắc trên.

---

## 44. Out-of-Interpretation Rules

Các điểm sau downstream teams **không được tự diễn giải khác**:

1. Sản phẩm có **23 modules**, không phải 22.
2. Có đúng **6 operator modes**, gồm cả Brand Collaboration Mode.
3. Source class canonical chỉ gồm `Official / Imported / Inferred / Estimated / Unreconciled`.
4. Publish truth = `Publish Item + Publish Log`.
5. `Thread` bắt buộc có `owner / intent / status / next action`.
6. `Script` bắt buộc nối `Idea + Asset Brief + Publish Targets`.
7. `Evidence Object`, `Proof Bundle`, `Confidence Reason` là 3 lớp khác nhau.
8. Mobile là execution surface thật.
9. Beginner / non-tech usability là launch requirement.
10. Workflow / agent không được tạo shadow truth outside canonical graph.
11. Reporting không được thay canonical truth owners.
12. Bundle không được dùng để cắt canonical domain.

---

## 45. Handoff to Detail Design

Detail design packs bắt buộc tách theo ít nhất các domain sau:
- FE UX / screen contracts
- backend domain & object schema contracts
- event backbone / workflow runtime contracts
- AI/media provider orchestration contracts
- connector and capability contracts
- finance / reconciliation / proof contracts
- reporting / billing / metering / admin contracts

Mỗi detail design pack phải mở đầu bằng:
- upstream sections from Product Freeze used
- canonical objects touched
- state machines touched
- read/write ownership respected
- acceptance scenarios inherited

---

## 46. Definition of Build Readiness

Một module/domain chỉ được coi là **build-ready** khi đã có đủ:
- canonical object contracts
- state machine mapping
- read/write ownership
- trust / diagnostics rules
- beginner + degraded UX rules
- acceptance scenario inventory
- mobile/web execution classification
- legal/compliance requirements (consent, ToS, privacy)
- feature gating / tier enforcement rules
- authentication & authorization rules
- accessibility target (WCAG 2.1 AA minimum)

Nếu thiếu một trong các lớp trên, module chưa được xem là ready để xuống ticket implementation.

---

## 46A. New Domain Freeze (Pack 07 / Pack 08)

### 46A.1 Subscription Tier Freeze
Các tier canonical đã frozen:
- **Free** (50 credits, 2 accounts, 1 mode, 1 seat)
- **Starter** (500 credits, 5 accounts, 2 modes, 2 seats)
- **Pro** (2,000 credits, 15 accounts, all modes, 5 seats)
- **Business** (10,000 credits, 50 accounts, all modes + multi-creator, 20 seats)
- **Enterprise** (custom everything)

Downstream không được tạo tier mới hoặc thay đổi credit allocations mà không quay lên PRD/Freeze.

### 46A.2 AI Credit System Freeze
- AI Credit là canonical unit of value cho mọi AI operation
- Credit pricing per operation category: frozen (Pack 08 §3)
- Budget safety rules: frozen (hard block Free/Starter, soft warning Pro/Business)
- Internal cost tracking: bắt buộc (actual_cost_usd per operation)

### 46A.3 Consent & Legal Freeze
- ToS acceptance: click-wrap, bắt buộc trước khi sử dụng
- Cookie consent: 3-choice banner (Accept All / Reject All / Customize)
- AI data usage consent: explicit opt-in, default OFF
- Consent records retention: 5 năm minimum
- Third-party liability disclaimers: bắt buộc cho mọi connected platform

### 46A.4 RBAC Role Hierarchy Freeze
7 canonical roles (xem Pack 08 §8):
1. Owner
2. Admin
3. Manager
4. Editor
5. Contributor
6. Viewer
7. External Collaborator

Downstream không được thêm role mới mà không quay lên Freeze.

### 46A.5 Referral & Growth Engine Freeze
- Double-sided rewards: canonical
- Referral tier system: Bronze → Silver → Gold → Platinum
- Anti-fraud rules: canonical (self-referral detection, min 30-day qualified period)
- Viral watermark (Free tier): canonical

### 46A.6 Capability State Taxonomy Update
Canonical capability states (UPDATED):
- Native
- Read-only
- Manual
- **Degraded** (NEW — partial functionality due to platform/policy change)
- Unsupported

"Degraded" được thêm vào canonical taxonomy và áp dụng retroactive cho mọi downstream documents.

### 46A.7 Platform Policy Compliance Engine Freeze
- Pre-publish compliance scan: bắt buộc cho mọi publish action
- Scan results: pass / pass_with_warnings / review_required / blocked
- Policy monitoring: crawl platform policy pages mỗi 24h
- Post-publish monitoring: track flagged/removed content

### 46A.8 Strategic Features Freeze (PRD §33-§38)

#### Profit OS (§33) — FROZEN
- Net profit calculation PHẢI trừ: platform fees, shipping, affiliate commissions, refund charges, COGS, ad spend
- Profit granularity levels: per product, per platform, per content, per period, per campaign
- Profit alerts: margin threshold, fee change detection, revenue trend
- Platform fee database: auto-updated, per-category, per-region

#### Copilot (§34) — FROZEN
- 4 modes: Creative, Analytics, Action, Help
- Entry points: floating chat, command bar (Cmd+K), voice (mobile), Morning Brief inline
- Credit rules: analytics/help = 0 credits; generation = standard credit cost; cost shown BEFORE action
- Daily query limits: Free 20, Starter 100, Pro unlimited, Business unlimited
- Language: Vietnamese primary, English secondary, auto-detect

#### Morning Brief (§35) — FROZEN
- Structure: Highlights + Money Summary + Today's Actions + AI Suggestions
- Delivery: push (7AM default), in-app card, email (optional)
- Personalization: adapts to operator mode, auto-hide empty sections

#### Content Repurpose Engine (§36) — FROZEN
- Pipeline: Auto-Clips + Text Posts + Thumbnails + Carousel + Blog + Audio + Captions + Auto-Schedule
- All outputs = drafts (user must approve before publish)
- Max video length per tier: Free 5min, Starter 30min, Pro 60min, Business 120min

#### Achievement System (§37.3) — FROZEN
- Rewards credited as "promotional" in AI Credit Transaction
- Maximum 3 active weekly challenges
- Per-workspace achievements, not per-user
- No duplicate credit on re-trigger

#### Extended Production Features (Pack 04 §9.6-9.16) — FROZEN
- AI Product Showcase Studio: 8 styles, batch mode, Product Hub integration
- Image-to-Video Converter: 6 motion styles, Veo/Kling API
- AI Thumbnail Studio: generate + A/B test + brand consistency
- Link-to-Video Generator: Shopee/Lazada/TikTok Shop/Amazon URL scraper + script gen
- AI Translation & Localization Studio: 8 languages v1, voice clone + lip-sync
- AI Sound Studio: music gen + beat-drop sync + speech-to-song + SFX
- AI Style Learning: Style Pack → Continuity OS (M08), future marketplace
- AI Video Agent: 1-click full pipeline orchestration
- AI Performance Coach: post-publish analysis + weekly coaching (0 credits)
- Video A/B Testing Engine: N variations → auto-winner
- Creator Gamification System: Level 1-50, XP, streaks, quests, achievements
- All extended features subject to tier limits as defined in Pricing Contract §4.6

#### P2 Roadmap Preservation (§38) — FROZEN
- 6 P2 features MUST NOT be removed from roadmap
- v1 schema MUST include preparation fields as specified
- P2 scope expansion requires formal Product Freeze update

---

## 47. Final Freeze Statement

Tài liệu này khóa Creativanta ở cấp **Build Contract** như sau:

- full scope đã được giữ nguyên
- mọi module đã được map về canonical objects
- mọi object trọng yếu đã có product contract đủ chặt
- state machines trọng yếu đã được chốt family và transition boundaries
- score/proof/capability/confidence đã có taxonomy và governance rõ ràng
- beginner UX và repair UX đã được đưa lên thành product requirement
- mobile execution đã được chốt là real execution surface
- workflow/agent đã bị ràng buộc bởi auditability, capability-awareness và canonical graph rules
- **pricing tiers, AI credit system, consent management đã frozen** (NEW)
- **RBAC role hierarchy đã frozen** (NEW)
- **referral/growth engine đã frozen** (NEW)
- **"Degraded" capability state đã thêm vào canonical taxonomy** (NEW)
- **platform policy compliance engine đã frozen** (NEW)
- **Profit OS (real profit tracking) đã frozen** (STRATEGIC)
- **Copilot (AI conversational assistant) đã frozen** (STRATEGIC)
- **Content Repurpose Engine đã frozen** (STRATEGIC)
- **Achievement & Gamification System đã frozen** (STRATEGIC)
- **Morning Brief (daily intelligence) đã frozen** (STRATEGIC)
- **P2 roadmap items preservation đã frozen** (STRATEGIC)
- **Extended Production Features (Product Showcase, Image-to-Video, Thumbnail, Link-to-Video, Translation, Sound Studio, Style Learning, Video Agent, Performance Coach, A/B Testing, Gamification) đã frozen** (STRATEGIC)

Từ thời điểm này trở đi:
- **PRD** không còn là nơi thêm ambiguity mới
- **Product Freeze** không còn là nơi tranh luận product meaning
- **Detail Design** chỉ được phép implementation hóa và chi tiết hóa

Nếu detail design hoặc implementation phá một trong các freeze rules trên, đó là lỗi lệch contract, không phải “một cách hiểu hợp lệ khác”.

---

## 48. Final Note

Bộ tài liệu chuẩn từ đây sẽ là:
1. **PRD Master v3.1 (Revised, Freeze-Ready)**
2. **Product Freeze / Build Contract v3.1**
3. **Detail Design Packs**

Thứ tự làm tiếp nên là:
- detail design theo domain
- acceptance packs theo module
- system design / schema / events
- UX screen specs
- implementation breakdown

Tài liệu này là cầu nối chính thức giữa product meaning và implementation reality.

