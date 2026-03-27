# Creativanta — Detail Design Pack 02 — Backend Domain / Canonical Schema Contract v3.1

## 0. Traceability Header

- **Upstream sections used**: Product Freeze sections 10–17, 21–29, 39–46.
- **Canonical objects touched**: toàn bộ Tier A core objects cùng Tier B/Tier C có business side effects, đặc biệt Workspace, Connected Account, Publish Job, Queue Item, Approval Request, Offer/Coupon/Affiliate/Store objects, Refund, Reconciliation Record, Live Session, Recipe Template, Evidence Object, Diagnostics Record, Capability Snapshot.
- **State machines touched**: Publish Job, Queue Item, Approval Request, Publish Item, Offer/Campaign/Store/Monetization Support, Order/Refund/Settlement/Reconciliation/Cost, Workflow Run, Agent Run, Recipe Template, Live Session, Sample Request, Sample Shipment.
- **Read / write ownership respected**: backend enforce single primary owner, contributing modules qua commands/events, append-only records immutable, family contracts không tạo shadow truth.
- **Acceptance scenarios inherited**: owner enforcement, append-only truth integrity, publish truth linkage, refund/order linkage, monetization support consistency, proof/profit lineage, workspace isolation.
- **Cross-ref**: S26 (Internal Admin) §2/§4/§5 — Internal Admin RBAC (separate from workspace RBAC), user/workspace management console, destructive action gate vận hành từ admin site.

## 1. Mục tiêu

Pack này khóa cách backend và data model triển khai canonical graph để:
- giữ đúng write ownership
- không tạo shadow truth
- hỗ trợ cross-module linking, auditability và proofability

## 2. Domain Partitioning

### 2.1 Bounded Contexts
- Identity & Workspace
- Intelligence
- Decision & Creation
- Continuity & Media
- Publish & Capability
- Engagement
- Commerce
- Finance & Proof
- Workflow & Agent Runtime
- Reporting / Billing / Admin
- Internal Admin & Operations (S26)

### 2.2 Canonical Rule
Bounded context không được tạo silo. Context là ownership boundary, không phải business-island boundary.

## 3. Canonical Ownership Topology

### 3.1 Aggregate Roots
- Workspace
- Connected Account
- Trend
- Opportunity
- Idea
- Script
- Asset Brief
- Asset
- Publish Job
- Publish Item
- Thread
- Product
- Offer
- Campaign
- Order
- Refund
- Settlement
- Cost Item
- Profit Snapshot
- Proof Bundle
- Workflow
- Workflow Run
- Agent Run
- Diagnostics Record
- Character
- Fraud Case (S26)
- Incident (S26)
- Post-Mortem (S26)

### 3.2 Canonical Append-Only Records
- Publish Log
- Evidence Object
- Billing Event
- Metering Record
- audit/event records defined by runtime contracts

### 3.3 Canonical Supporting Entities / Snapshots
- Capability Snapshot
- Queue Item
- Approval Request
- Channel Post
- Coupon
- Affiliate Link
- Membership Plan
- Store Page
- Reconciliation Record
- Sample Request
- Sample Shipment
- Live Session
- Live Segment
- Creator Assignment
- Recipe Template
- Commission
- Creator Payout
- Affiliate Statement
- Invoice
- Margin Snapshot
- Click Event
- Lead
- Conversion Event
- Return
- Experiment

### 3.4 New Domain Objects (Pack 07/08)

#### Billing / Pricing Context (owner: Billing service)
- Subscription Plan
- Subscription Record
- Feature Gate
- AI Credit Balance
- AI Credit Transaction
- Billing Event (append-only)
- Metering Record (append-only)

#### Growth / Referral Context (owner: Growth service)
- Referral Code
- Referral Record
- Reward Ledger Entry

#### Legal / Compliance Context (owner: Compliance service)
- Consent Record (append-only)
- Legal Document Version
- Platform Policy Snapshot
- Compliance Scan Result (append-only)

#### Affiliate Health Context (owner: Affiliate service)
- Link Health Record

#### Profit OS Context (owner: Profit service) — PRD §33
- Profit Calculation Record
- Platform Fee Schedule
- COGS Entry
- Content Attribution Record (content → revenue linkage)

#### Copilot Context (owner: Agent Runtime service) — PRD §34
- Copilot Session
- Copilot Action Log (append-only)

#### Achievement Context (owner: Growth service) — PRD §37.3
- Achievement Definition
- User Achievement Record
- Weekly Challenge Definition
- Challenge Progress Record

#### Platform Health Context (owner: Connector service) — PRD §37.4
- Platform Health Score
- Platform Health Check Log (append-only)

#### Content Repurpose Context (owner: AI Pipeline service) — PRD §36
- Repurpose Job
- Repurpose Output (linked to Asset)

#### Character Builder Context (owner: AI/Media service) — PRD M08 / Pack 04 §12B
- Character (user-facing entity: digital_twin | ai_generated | stock)
- Character links to: Character Pack, Voice Pack, Brand Pack (continuity refs)
- Voice Clone Record (provider reference for cloned voice)
- Character Consent Record (digital twin identity verification)
- **Schema**: See Pack 04 §12B.2 for full Character object schema
- **Tier gating**: character_slots feature gate (Free:1 → Enterprise:unlimited)

#### Video Production Context (owner: AI Pipeline service) — PRD M07 / Pack 04 §9 / ADR-011

**Remix Blueprint** (AI Remix Studio output):
- RemixBlueprint: aggregate root (schema defined in Pack 04 §9.5.7)
- Links to: Workspace, Asset (reference), Asset (output), Character, Brand Pack
- States: analyzing → analyzed → generating → generated → failed

**Clip Collection** (Clip Factory output):
- ClipCollection: group of clips from a single source video
- Links to: source Asset, workspace, Repurpose Job
- Contains: ordered list of Clip references + per-clip ViralityScore

**Virality Score** (computed, attached to clips and remixes):
- ViralityScore: embedded value object (not standalone aggregate)
- Fields: total (0-100), engagement_pattern, hook_strength, pacing_score, audio_quality, content_relevance, explanation
- Source: computed from video analysis + Trend Engine data (M02/M03)
- See ADR-011 §11.5 for Rust struct

**Creative DNA Blueprint** (analysis output):
- CreativeDnaBlueprint: JSON value object embedded in RemixBlueprint
- Contains: scene_count, hook_type, content_structure, pacing_profile, visual_style, audio_profile, transition_map

**Video Edit Job** (production mode job):
- VideoEditJob: processing job for all production modes
- Fields: workspace_id, mode (quick_edit | clip_factory | multi_merge | remix | product_showcase | image_to_video | link_to_video | translation | video_agent), input_assets, output_assets, status, credits_used, provider_route
- Links to: source Assets, output Asset(s), RemixBlueprint (if remix), ClipCollection (if clip_factory)

**Product Showcase Job** (product → video, Pack 04 §9.6):
- ProductShowcaseJob: extends VideoEditJob pattern
- Fields: workspace_id, product_id (nullable, FK → Product), style (enum: spin_360 | tabletop | flip_reveal | virtual_tryon | lifestyle | unboxing | before_after | review_style), customization (background, duration, music, voice, text, cta, aspect_ratio, pacing, color_grade), batch_id (nullable), status, credits_used
- Links to: Product (optional), Asset (output), Character (if Review Style), Brand Pack

**Link-to-Video Job** (URL → video ad, Pack 04 §9.9):
- LinkToVideoJob: extends VideoEditJob pattern
- Fields: workspace_id, source_url, platform_detected (shopee | lazada | tiktok_shop | amazon | shopify | generic), scraped_data (json: name, price, images, description, reviews), script_template (problem_solution | listicle | testimonial | flash_sale | comparison), status, credits_used
- Links to: Asset (output), Character (voice)

**Translation Job** (video → N languages, Pack 04 §9.10):
- TranslationJob: processing job for dubbing/localization
- Fields: workspace_id, source_asset_id, target_languages (string[]), lip_sync_enabled (bool), per_language_status (json map), credits_used
- Links to: source Asset, output Assets (one per language)

**Style Pack** (learned editing style, Pack 04 §9.12):
- StylePack: Continuity OS entity (parallel to Brand Pack / Character Pack)
- Fields: workspace_id, name, source_asset_id (video analyzed), extracted_style (json: caption, color_grade, transitions, pacing, text_overlay, audio_mix), is_active (bool)
- Links to: Workspace, source Asset
- Owner: Continuity OS service (M08)

**Performance Report** (AI coach output, Pack 04 §9.14):
- PerformanceReport: generated analysis document
- Fields: workspace_id, period (daily | weekly | monthly), publish_items_analyzed (FK[]), metrics (json: views, engagement, best_content, worst_content, growth), suggestions (json array), generated_at
- Links to: Workspace, PublishItem(s)

**AB Test Experiment** (video variant testing, Pack 04 §9.15):
- ABTestExperiment: extends Experiment entity (M10)
- Fields: workspace_id, source_video_id, variants (json array: variant_type, asset_id, publish_item_id), metrics_snapshot (json per variant), winner_id (nullable), status (running | completed | cancelled), started_at, completed_at
- Links to: source Asset, variant Assets, PublishItem(s)

**Creator Progress** (gamification state, Pack 04 §9.16):
- CreatorProgress: per-workspace gamification state
- Fields: workspace_id, level (1-50), total_xp, current_streak_days, longest_streak, achievements_unlocked (string[]), active_quests (json), seasonal_challenge_progress (json)
- Links to: Workspace, Achievement Definition(s), User Achievement Record(s)
- Owner: Growth service

### 3.5 Registry Rule
Không phải mọi canonical object đều là aggregate root, nhưng mọi canonical first-class/support/supporting object đều phải có owner, persistence strategy và graph relationship rõ.

## 4. Field Group Contract

Mọi aggregate phải nhóm field thành:
- identity
- lifecycle
- relationships
- trust/provenance
- execution
- money
- audit
- metadata

## 5. Persistence Strategy

### 5.1 Canonical Stores
- canonical entity store
- event/audit store
- read model/projection store
- search/index store
- file/blob pointer store

### 5.2 Rule
Projection không được là source of truth. Mọi write business-critical phải quay về aggregate owner.

## 6. Relationship Strategy

### 6.1 Relationship Types
- strong canonical ref
- weak external ref
- derived relation
- projection-only relation

### 6.2 Rules
- critical business flows phải dùng canonical refs
- external ids không thay thế canonical ids
- many-to-many relations phải có direction ownership rõ

## 7. Invariants

### 7.1 Global Invariants
- Trend phải truy ngược được về source lineage
- Opportunity phải có source refs
- Script phải có Idea + Asset Brief + Publish Targets
- Publish truth phải có Publish Item + Publish Log
- Thread phải có owner / intent / status / next action
- Offer phải product-backed hoặc product-less declared
- Money truth phải có source class
- Workflow/agent mutations phải có audit trail

### 7.2 Money Invariants
- Official và Estimated không merge im lặng
- unreconciled không render như finalized truth
- cost items thiếu proof phải mang confidence caveat

## 8. Validation Layers

### 8.1 Validation Levels
- input validation
- business invariant validation
- state transition validation
- permission validation
- capability validation
- audit requirement validation

### 8.2 Rule
State transition business-critical không được pass nếu thiếu audit context, approval hoặc capability requirement tương ứng.

## 9. Entity Contract Notes

### 9.1 Opportunity
- canonical owner: Decision context
- projections: Home cards, score views, assignment boards
- emitted events: OpportunityCreated, OpportunityPrioritized, OpportunityAssigned, OpportunityConverted

### 9.2 Script
- canonical owner: Creation context
- tách lifecycle_state và approval_state
- emitted events: ScriptDrafted, ScriptSubmittedForApproval, ScriptApproved, ScriptReadyForProduction

### 9.3 Asset
- canonical owner: Media context
- tách generation_state và approval_state
- lineage bắt buộc nếu asset do provider/external generation tạo ra

### 9.4 Publish Job
- canonical owner: Publish runtime context
- là execution-attempt group object cho đúng một Publish Item
- không thay thế publish truth; Publish Log vẫn là append-only execution evidence

### 9.5 Publish Item
- canonical owner: Publish context
- capability snapshot ref bắt buộc
- publish log là execution evidence record tách riêng

### 9.6 Publish Log
- canonical owner: Publish runtime boundary
- immutable sau khi append
- phải link ngược được tới publish job, publish item và capability snapshot

### 9.7 Thread
- canonical owner: Engagement context
- next_action là field bắt buộc, không phải UI helper field tạm thời

### 9.8 Refund
- canonical owner: Commerce/Finance boundary
- phải link tới order(s), amount/currency, reason và refund lifecycle state
- order refunded states chỉ là derived/linked lifecycle, không thay Refund object

### 9.9 Profit Snapshot
- canonical owner: Finance/Proof derived layer
- là derived truth object, không phải raw transaction object

### 9.10 Evidence Object
- canonical owner: Proof layer
- immutable evidence ref/hash, provenance và verification status là mandatory
- append-only contributors có thể submit capture requests, nhưng canonicalization và verification thuộc proof layer

### 9.11 Capability Snapshot
- canonical owner: Capability context
- là snapshot canonical cho action/platform/time cụ thể, không phải UI helper object

### 9.12 Canonical Support Families
- identity/profile supports (Brand Profile, Creator Profile, Seller Profile, Team Member, Role, Permission Set, Connected Provider, Region Profile, Currency Profile) phải link chặt về workspace boundary và access model
- intelligence supports (Search Intent Cluster, Keyword Cluster, Competitor Entity, Product Opportunity, Watchlist, Alert, Benchmark Snapshot, Confidence Record) phải giữ provenance, freshness và confidence lineage
- monetization/catalog supports (SKU, Variant SKU, Inventory Location, Stock Movement, Bundle, Price Rule, Promotion Rule, Coupon, Affiliate Link, Membership Plan, Store Page) phải tách product facts, commercial rules và presentation layout
- finance supports (Click Event, Lead, Conversion Event, Return, Commission, Creator Payout, Affiliate Statement, Invoice, Margin Snapshot) phải link ngược được về order/offer/campaign/live scope hoặc proof path
- operations/runtime supports (Live Segment, Creator Assignment, Trigger Event, Action Log, Audit Event) phải lưu actor/context/correlation và không được mutate Tier A truth fields trực tiếp

## 10. Write Ownership Enforcement

Backend phải enforce:
- chỉ aggregate owner service được mutate canonical lifecycle/state fields
- cross-context updates qua commands/events rõ ràng
- không cho UI hoặc ad-hoc jobs mutate canonical objects trực tiếp ngoài contract

## 11. Projection Strategy

### 11.1 Required Projections
- Home action cards
- Daily Brief summary
- Trend watchlist views
- Opportunity board summary
- Script review queue
- Publish queue view
- Inbox triage view
- Live War Room timeline
- Profit anomaly board
- Diagnostics overview
- Admin metering views

### 11.2 Projection Rule
Projection phải carry đủ:
- canonical object id
- freshness
- trust summary
- quick actions availability

## 12. Audit & Provenance

### 12.1 Audit Events Required For
- state changes business-critical
- publish execution
- price/offer changes
- workflow side effects
- admin overrides
- reconciliation overrides

### 12.2 Provenance Required For
- inferred/estimated outputs
- imported financial data
- generated media assets
- benchmark/research snapshots

## 13. Deletion / Archival Strategy

### 13.1 Rules
- soft delete hoặc archive cho business-critical objects
- proof/audit-linked objects không được hard delete im lặng
- archive state phải giữ được graph integrity

## 14. Multi-Tenant / Workspace Isolation & Security

### 14.1 Core Isolation Rules
- Workspace là hard security boundary
- Shared templates/recipes không được lộ tenant data
- Audit trail luôn lưu workspace scope

### 14.2 Data Isolation (OWASP-aligned)
- `workspace_id` bắt buộc trong mọi resource queries, cache keys, storage paths
- Row-Level Security (RLS) hoặc equivalent enforcement tại database layer
- Cross-tenant data access prevention: validate tenant ownership trước mọi object access (IDOR prevention)
- tenant_id không được trust từ client input; phải derive từ authenticated session

### 14.3 Cache & Session Isolation
- Cache keys phải include workspace_id
- Session scoping per workspace per user
- Shared entity cache (e.g., recipe templates) phải strip tenant-specific data

### 14.4 File / Blob Storage Isolation
- File paths phải include workspace_id prefix
- Pre-signed URLs phải verify workspace ownership
- CDN caching rules phải respect workspace boundary
- **Temporary file auto-cleanup**: draft uploads, failed AI render outputs, và processing intermediates tự động xóa sau 14 ngày nếu không được pinned/published/archived
- **Cleanup warning**: 7 ngày trước cleanup, hiển thị badge trên file: "⚠️ Sẽ bị xóa trong [N] ngày. [Giữ lại]."
- **AI generation temp files**: output mà user discard/cancel → xóa ngay lập tức (không chờ 14 ngày)
- **Storage usage dashboard**: hiển thị breakdown: published assets / drafts / temp files / total, kèm progress bar vs tier limit

### 14.5 Rate Limiting
- Per-workspace rate limits cho API calls
- Per-workspace rate limits cho AI operations (xem Pack 08 §3)
- Per-user rate limits within workspace
- Rate limit response: HTTP 429 + Retry-After header

### 14.6 Tenant Onboarding / Offboarding
- Provisioning: workspace setup with default Feature Gates, Subscription Plan, consent records
- Offboarding: full data export → grace period (30 days) → hard delete including blobs, events, projections, search indexes
- Third-party connected account cleanup during offboarding
- **Connected Account dependency check khi remove user**: khi xóa user từ workspace, system phải check và alert admin nếu user đó là OAuth token provider cho bất kỳ Connected Account nào. Block removal nếu có accounts đang active phụ thuộc vào token của user đó — yêu cầu transfer/re-authorize trước.
- **Transfer flow**: Admin phải chọn 1 trong 2: (a) Yêu cầu member khác re-authorize Connected Account, hoặc (b) Acknowledge rằng account sẽ chuyển sang "disconnected" state sau khi remove user.

### 14.7 Destructive Action Gate (Malicious Insider Protection)

> **Context**: Ngăn chặn hành vi phá hoại nội bộ (Admin/Manager muốn gây thiệt hại) bằng confirmation layer bổ sung.

**Destructive actions yêu cầu Owner confirmation hoặc OTP verification:**

| Action | Threshold | Required Confirmation |
|---|---|---|
| Bulk disconnect Connected Accounts | ≥ 3 accounts | Owner OTP |
| Bulk delete content/assets | ≥ 10 items | Owner OTP |
| Change product price to ≤ 0 | Any | Owner approval |
| Delete/archive workflow automations | ≥ 5 workflows | Owner OTP |
| Remove team members | ≥ 3 members | Owner OTP |
| Export toàn bộ workspace data | Any | Owner OTP |
| Modify billing/subscription | Any plan change | Owner only (non-delegatable) |

**Rules:**
- OTP gửi qua email/SMS của **Owner** (không phải của actor thực hiện action)
- Destructive action log: mọi action vượt threshold đều logged với actor, timestamp, justification (bắt buộc), và approval ref
- Cool-down: sau khi bulk destructive action, 15-phút cool-down trước khi cho phép action tương tự tiếp theo
- **Emergency freeze**: Owner có thể kích hoạt "Workspace Freeze" từ bất kỳ đâu (web/mobile) — chặn toàn bộ write operations trừ Owner actions
- Freeze alert: mọi workspace members nhận notification khi freeze được kích hoạt

## 15. Authentication & Identity Contract

### 15.1 Authentication Methods
- Email + Password (primary)
- OAuth 2.0 Social Login (Google, Facebook, Apple, TikTok)
- Magic Link (passwordless option)
- SSO / SAML 2.0 (Enterprise tier only)

### 15.2 Session Management
- JWT-based access tokens (short-lived, 15 min)
- Refresh tokens (long-lived, 7 days, rotatable)
- Secure HTTP-only cookies for web, secure storage for mobile
- Support multiple active sessions per user
- Session revocation on password change or security event

### 15.3 Security Rules
- Password policy: min 8 chars, complexity requirements
- MFA / 2FA: TOTP (authenticator app) for all tiers, SMS for Pro+
- Brute force protection: rate limit login attempts (5 per min per IP)
- Account lockout after 10 failed attempts → email unlock
- Login anomaly detection (new device, new location) → email alert

### 15.4 API Authentication
- Bearer token (JWT) for SPA/mobile
- API keys for external integrations (per workspace)
- OAuth2 client credentials for server-to-server
- Webhook signature verification (HMAC-SHA256)

## 16. API Response & Error Contract

### 16.1 Standard Response Envelope
```
{
  "data": { ... },
  "meta": { "page", "total", "cursor" },
  "errors": [ { "code", "message", "field", "details" } ],
  "trace_id": "..."
}
```

### 16.2 Error Code Taxonomy
- 400: validation error (missing field, invalid format)
- 401: authentication required
- 403: forbidden (insufficient permission or feature gate)
- 404: resource not found
- 409: conflict (state transition violation, duplicate)
- 422: unprocessable (business rule violation)
- 429: rate limited (Retry-After header)
- 500: internal server error
- 503: service unavailable (maintenance)

### 16.3 Pagination
- Cursor-based pagination (default for lists)
- Response includes: `cursor`, `has_more`, `total_count`
- Sort: `sort_by` + `sort_order` (asc/desc)
- Filter: field-specific query params

### 16.4 Error Code → User Message Mapping

> **Cross-ref**: Pack 01 §9C (Error UX & Copy/Tone Contract). This table bridges backend error codes to user-facing error categories.

| HTTP Code | Backend `error.code` | FE Error Category (Pack 01 §9C) | User-Facing Template |
|---|---|---|---|
| 400 | `validation.missing_field` | Validation | "Vui lòng điền {field_label}." |
| 400 | `validation.invalid_format` | Validation | "{field_label} chưa đúng định dạng. {hint}." |
| 401 | `auth.token_expired` | Permission / Auth | "Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại." |
| 401 | `auth.invalid_credentials` | Permission / Auth | "Email hoặc mật khẩu chưa đúng." |
| 403 | `permission.insufficient` | Permission / Auth | "Bạn cần quyền {permission} để thực hiện. Liên hệ admin workspace." |
| 403 | `feature.tier_restricted` | Capability / Platform | "Tính năng này cần gói {required_tier}. [Nâng cấp]" |
| 403 | `credits.insufficient` | Financial / Proof | "Không đủ credits ({needed} credits). [Mua thêm]" |
| 404 | `resource.not_found` | Validation | "{object_type} không tồn tại hoặc đã bị xóa." |
| 409 | `state.transition_invalid` | Workflow / Agent | "Không thể {action} vì {object} đang ở trạng thái {current_state}." |
| 409 | `conflict.duplicate` | Validation | "{object_type} đã tồn tại. Kiểm tra lại hoặc chọn tên khác." |
| 422 | `business.rule_violation` | Workflow / Agent | "{explanation}. {suggested_fix}." |
| 422 | `capability.unsupported` | Capability / Platform | "{platform} chưa hỗ trợ {action}. {fallback_suggestion}." |
| 429 | `rate.limited` | Network / Connection | "Quá nhiều yêu cầu. Vui lòng thử lại sau {retry_after}s." |
| 500 | `server.internal_error` | AI Generation *(or generic)* | "Có lỗi hệ thống. Vui lòng thử lại. Nếu lỗi tiếp tục, liên hệ hỗ trợ." |
| 503 | `service.maintenance` | Network / Connection | "Hệ thống đang bảo trì. Dự kiến hoàn tất lúc {estimated_end}." |

**Rules:**
- Backend MUST populate `error.code` (snake_case) + `error.message` (human-readable Vietnamese) + `error.field` (if applicable)
- FE MUST use `error.code` to select the appropriate error template and category (Pack 01 §9C.3)
- FE MUST NOT expose `error.code` values directly to users — translate to action-oriented Vietnamese messages
- `error.details` may contain structured data for FE to interpolate into templates (e.g., `{field_label}`, `{required_tier}`)
- All 500 errors logged with `trace_id` for debugging; trace_id shown to user as "Mã lỗi: {trace_id}" for support reference

## 17. Commerce Edge Cases Contract

### 17.1 Inventory Overselling Prevention
- Reserved stock: deduct available on order creation, confirm on fulfillment
- Race condition protection: optimistic locking on stock quantity
- Cross-platform sync lag buffer: configurable safety margin per product
- Alert on available < safety threshold

### 17.2 Chargeback Handling
- Chargeback ingestion: import từ payment provider
- Auto-link chargeback → order → product → offer
- Chargeback state machine: opened → evidence_submitted → won | lost
- Financial impact: auto-adjust revenue/profit snapshot
- Repeat chargeback → customer risk flag

### 17.3 Refund Fraud Detection
- Monitor refund frequency per customer: flag if > 3 refunds in 30 days
- Photo/video evidence requirement for damage claims (configurable)
- Tiered refund processing: instant (low-risk) vs manual review (high-risk)
- Refund amount cap per order
- Blacklist management for serial refund abusers

### 17.4 Partial Refund & Order Cancellation
- Partial refund: line-item level granularity
- Order cancellation: distinct from refund (before fulfillment)
- Cancelled orders: không tính vào revenue truth

### 17.5 Currency & Tax
- Multi-currency support: store amounts in original currency + base currency equivalent
- Exchange rate: snapshot at transaction time
- Tax: tax_amount field per order line (platform-agnostic)
- Tax reporting export: configurable per jurisdiction

## 18. Data Import & Migration Strategy

### 18.1 Supported Import Sources
- Shopee Seller Center (products, orders, settlements)
- TikTok Shop (products, orders, affiliate data)
- Manual CSV/Excel upload (products, orders, costs)
- API-based bulk import (for integrations)

### 18.2 Import Process
1. Upload / connect source
2. Field mapping (auto-suggest + manual override)
3. Validation preview (errors, warnings, duplicates)
4. Deduplication check (product name + SKU + platform)
5. Confirmation → background import job
6. Import result report (success, failed, skipped rows)

### 18.3 Import Rules
- Imported data gets source_class = `Imported`
- External IDs preserved as external_ref, canonical ID auto-generated
- Imported data không auto-reconcile; must go through reconciliation queue
- Import jobs idempotent (re-import same file = update, not duplicate)

### 18.4 Migration From Competing Tools
- Provide export format spec for common tools
- Offer guided migration wizard (Pack 01 UX)
- Migration data: products, orders, revenue history, content metadata

## 19. Handoff sang Schema Design

Schema design tiếp theo phải tạo:
- tables/collections per aggregate root
- storage/models cho canonical append-only records
- storage/models cho canonical supporting entities / snapshots / support families
- storage/models cho new domain objects (§3.4)
- relationship tables
- event tables/topics và audit stores
- projection stores
- file/blob pointer models
- retention rules
- indexing/search design
- tenant isolation design (§14)
- authentication/session stores (§15)

## 20. Acceptance Scenario Inventory

Backend/schema bắt buộc cover tối thiểu các scenario sau:
- single primary owner được enforce cho Tier A/Tier B objects, contributors chỉ qua commands/events
- Publish Job, Queue Item, Approval Request, Publish Item, Publish Log link đúng và không tạo shadow truth
- commercial support objects (Coupon, Affiliate Link, Membership Plan, Store Page, Bundle, Price Rule) link được vào offer/campaign/store flows
- Refund/Return/Settlement/Reconciliation/Proof lineage truy ngược được tới order/commercial scope
- workspace isolation giữ nguyên qua projections, events, file/blob pointers và search indexes
- support families giữ provenance, freshness, auditability và không bị projection thay canonical storage
- new domain objects (subscription, credits, consent, referral, link health) link đúng về canonical graph
- authentication, session, API key objects isolated per workspace
- import jobs idempotent, source_class correct, dedup enforced
- overselling prevention, chargeback linkage, refund fraud flags operational
- temporary file auto-cleanup xóa draft/failed renders sau 14 ngày, warning hiển thị 7 ngày trước
- connected account dependency check chặn remove user nếu user đó là token provider cho active accounts
- destructive action gate yêu cầu Owner OTP cho bulk disconnect/delete/price-change vượt threshold
- emergency workspace freeze chặn toàn bộ write operations trừ Owner actions

---

## S07. RBAC Full Permission Matrix (Supplementary)

> **Ref**: Design Index canonical rule #19, Pack 02 §14, **Product Freeze §46A.4 (CANONICAL)**

### S07.1 Pre-Built Roles (7) — Aligned to Product Freeze §46A.4

| Role | Scope | Description |
|---|---|---|
| **Owner** | Workspace | Full access, billing, danger zone, workspace deletion |
| **Admin** | Workspace | All features except billing management + workspace deletion |
| **Manager** | Workspace | Team oversight, finance/revenue access, inbox moderation, commerce management, approve content |
| **Editor** | Workspace | Create/edit/publish content, workflows, view analytics, commerce (operational) |
| **Contributor** | Workspace | Create/edit content drafts only — cannot publish, approve, or access finance |
| **Viewer** | Workspace | Read-only access to all non-sensitive data |
| **External Collaborator** | Limited | Brand/agency external collaborator, scoped per invitation, limited to assigned content |

> **Reconciliation Note**: Previous version used Finance/Moderator as separate roles. Per Freeze §46A.4, these are merged into **Manager** (operational oversight role covering finance visibility, inbox moderation, commerce management, and content approval). **Contributor** is added as a step below Editor for team members who can draft but not publish.

### S07.2 Permission Matrix

| Feature Domain | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| **Workspace settings** | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Billing & subscription** | ✅ | ❌ | ✅ (view) | ❌ | ❌ | ❌ | ❌ |
| **Team management** | ✅ | ✅ | ✅ (invite/assign) | ❌ | ❌ | ❌ | ❌ |
| **Content create/edit** | ✅ | ✅ | ✅ | ✅ | ✅ (draft only) | ❌ | ✅ (assigned) |
| **Content delete** | ✅ | ✅ | ✅ | ✅ (own) | ❌ | ❌ | ❌ |
| **Publish** | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| **Approve publish** | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **View analytics** | ✅ | ✅ | ✅ | ✅ | ✅ (own content) | ✅ | ✅ (scoped) |
| **Revenue/Profit data** | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Commerce (orders)** | ✅ | ✅ | ✅ | ✅ (operational) | ❌ | ✅ (view) | ❌ |
| **Inbox/Threads** | ✅ | ✅ | ✅ | ✅ | ✅ (view) | ✅ (view) | ❌ |
| **Workflow create/edit** | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| **Workflow execute** | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| **AI Copilot** | ✅ | ✅ | ✅ | ✅ | ✅ (creative only) | ✅ (help only) | ❌ |
| **Connected accounts** | ✅ | ✅ | ✅ (view) | ❌ | ❌ | ❌ | ❌ |
| **Export data** | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **API keys** | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Danger zone** (delete workspace) | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |

### S07.3 Role Hierarchy & Inheritance
```
Owner (all permissions)
  └── Admin (Owner minus billing + danger zone)
        └── Manager (Admin minus workspace settings + API keys)
              └── Editor (Manager minus finance + approve + export + team mgmt)
                    └── Contributor (Editor minus publish + delete + workflows)
                          └── Viewer (read-only)
External Collaborator (isolated, invitation-scoped, no inheritance)
```

### S07.4 Agency Multi-Creator Workflows
- Agency Owner can manage multiple client workspaces
- Each client workspace has independent RBAC
- Agency dashboard: cross-workspace reporting (revenue, content, tasks)
- Permission: Agency team member invited per workspace with role assignment
- Billing: Agency plan covers all client workspaces under one subscription

---

## S20. Security Roadmap & AI Governance (Supplementary)

> **Ref**: Pack 02 §14-16, Legal §10 (AI Ethics), Tech Stack ADR Layer 8

### S20.1 Account Security Enhancements

| Feature | Spec |
|---|---|
| **Account freeze / panic button** | User can instantly freeze account → all sessions revoked, API keys disabled, login blocked. Unfreeze via email verification + MFA |
| **Suspicious login alert** | Email alert for login from new device/location/IP |
| **Active sessions management** | View + revoke active sessions from Settings |
| **Login history** | Last 30 days, IP + device + location + timestamp |

### S20.2 Security Certifications Roadmap

| Certification | Target Timeline | Priority |
|---|---|---|
| SOC 2 Type I | Post-launch +12 months | HIGH (enterprise blocker) |
| SOC 2 Type II | Post-launch +18 months | HIGH |
| ISO 27001 | Post-launch +24 months | MEDIUM |
| PCI DSS (via Stripe) | Launch (delegated) | N/A (Stripe handled) |
| GDPR certification | Launch | HIGH (EU users) |

### S20.3 Penetration Testing Schedule
- External pen test: annually by certified firm
- Internal security audit: quarterly
- Automated vulnerability scanning: weekly (Dependabot + Trivy)
- Bug bounty program: P2 (post-SOC2)

### S20.4 AI Governance Framework

| Principle | Implementation |
|---|---|
| **AI decision logging** | Every AI call logged: input (hashed), output, provider, model, latency, cost, workspace_id |
| **AI bias monitoring** | Monthly review of AI output quality per language/region. Flagged if VN output quality < EN |
| **Human-in-the-loop** | AI never auto-publishes. AI never auto-pays. AI never auto-deletes. Always human approval required |
| **AI confidence display** | Show confidence % on AI suggestions (high/medium/low). User can dismiss low-confidence |
| **AI cost transparency** | Credit cost shown BEFORE execution. Running total in sidebar. Daily/weekly summary |
| **Opt-out AI training** | User data NEVER used for model training. Explicit in ToS. Technical: no data shared with providers for training |
| **Right to explanation** | User can click "Tại sao AI gợi ý này?" → see input factors and reasoning |

