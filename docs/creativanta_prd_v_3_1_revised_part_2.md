# Creativanta — PRD Master v3.1 (Revised, Freeze-Ready) — Part 2/2

> Tài liệu này nối tiếp trực tiếp từ **Part 1/2**. Không có phần nào bị cắt scope. Phần này tiếp tục từ **M13** và đi tới hết PRD.

---

## 23. Detailed Module Requirements — Phần 2

### 23.13 M13 — Product Hub / Inventory / Order Truth
**Mục tiêu**: tạo canonical commerce layer cho product, inventory, orders.

**Primary Objects**: Product, SKU, Variant SKU, Inventory Location, Stock Movement, Order, Refund, Return.

**Functions**:
- product master
- SKU registry
- inventory locations
- stock movement ledger
- reserved stock
- order ingestion
- order lifecycle
- refund/return lifecycle
- fulfillment mapping
- inventory alerts
- product-to-content mapping

**Acceptance Criteria**:
- mọi offer phải map tới product hoặc product-less digital offer rõ ràng
- mọi order phải có source class và lifecycle state
- inventory truth không được tách silo khỏi stock movement logic

**Mobile Execution Requirement**:
- quick stock check, order status, alert action

### 23.14 M14 — Monetization OS
**Mục tiêu**: quản lý các lớp monetization của creator commerce trong cùng hệ.

**Primary Objects**: Offer, Campaign, Coupon, Affiliate Link, Membership Plan, Conversion Event.

**Functions**:
- offer strategy
- pricing logic
- coupon management
- link management
- monetization experiments
- sponsorship monetization coordination
- conversion signal linking

**Acceptance Criteria**:
- mọi monetization object phải map được về operating ledger scope khi có doanh thu/chi phí phát sinh
- monetization surfaces không được đứng riêng khỏi proof/profit system

**Mobile Execution Requirement**:
- quick coupon/link access, offer tweaks, conversion follow-up

### 23.15 M15 — Creator Store / Offers / Membership
**Mục tiêu**: vận hành storefront, offer stack, memberships và digital/community commerce.

**Primary Objects**: Store Page, Offer, Bundle, Membership Plan, Product, Price Rule.

**Functions**:
- storefront pages
- offers/bundles
- memberships
- digital products
- upsell/cross-sell structures
- price rules
- store performance linking

**Acceptance Criteria**:
- offer lifecycle rõ ràng
- product-less offers phải khai báo rõ loại offer
- store performance nối được về proof/profit layer

**Mobile Execution Requirement**:
- inspect store, quick offer edits, quick share links

### 23.16 M16 — In-Product Affiliate Network
**Mục tiêu**: quản lý affiliate objects, links, creator attribution và related proof.

**Primary Objects**: Affiliate Link, Campaign, Commission, Affiliate Statement, Coupon, Creator Assignment.

**Functions**:
- link generation
- coupon assignment
- creator assignment
- attribution views
- affiliate statement import/reconciliation
- partner performance proof

**Acceptance Criteria**:
- attributed performance phải có source class và confidence
- affiliate payouts/commissions nối được về ledger
- ambiguous attribution phải hiện là inferred hoặc unreconciled

**Mobile Execution Requirement**:
- quick share, inspect attributed results, follow-up

### 23.17 M17 — Live Commerce War Room
**Mục tiêu**: điều phối live commerce như operating surface thời gian thực.

**Primary Objects**: Live Session, Live Segment, Cue Card, Highlight, Thread, Offer.

**Functions**:
- live plan
- run-of-show
- cue cards
- offer pinning
- comment triage
- highlight marking
- post-live summary
- live performance linking

**Acceptance Criteria**:
- live events phải để lại timeline usable
- highlight và cue phải link được về live session
- post-live proof/performance view mở được

**Mobile Execution Requirement**:
- live monitoring, cue, highlight, urgent reply

### 23.18 M18 — Seeding / Sample CRM
**Mục tiêu**: quản lý sample outreach, creator assignment, shipment và follow-up.

**Primary Objects**: Sample Request, Sample Shipment, Creator Assignment, Person/Entity, Follow-up Task.

**Functions**:
- creator roster
- seeding lists
- sample requests
- shipment tracking
- follow-up states
- outcome logging
- performance linkage

**Acceptance Criteria**:
- sample request và shipment có lifecycle state rõ
- seeding outcomes link được về campaign/performance khi có dữ liệu
- missing proof không được biến thành definitive outcome claim

**Mobile Execution Requirement**:
- request triage, shipment check, follow-up update

### 23.19 M19 — Operating Ledger / Profit Graph / Proof Center
**Mục tiêu**: đưa user từ revenue nhìn sang profit truth có proof.

**Primary Objects**: Profit Snapshot, Margin Snapshot, Cost Item, Settlement, Reconciliation Record, Evidence Object, Proof Bundle.

**Functions**:
- gross/net/profit dashboards
- cost coverage
- reconciliation queues
- evidence drilldown
- proof bundles
- profit anomaly detection
- by platform/creator/product/offer/campaign/post/live breakdowns

**Acceptance Criteria**:
- money cards phải có source class, confidence, last refresh, drilldown
- estimate không được trộn vào Official truth mà không nhãn
- unreconciled bucket riêng phải hiện rõ

**Mobile Execution Requirement**:
- inspect anomalies, proof drawer, assign follow-up

### 23.20 M20 — Workflow Studio
**Mục tiêu**: cho user/operator thiết kế workflow operating loops có kiểm soát.

**Primary Objects**: Workflow, Trigger Event, Action Log, Approval Request, Diagnostics Record.

**Functions**:
- visual workflow builder
- triggers/conditions/actions
- approvals
- fallbacks
- retries / dead-letter handling
- diagnostics
- test run / dry run

**Acceptance Criteria**:
- business-critical side effects có audit trail
- workflow failures có user-facing explanation
- capability-aware execution bắt buộc

**Mobile Execution Requirement**:
- inspect run status, approvals, urgent intervention

### 23.21 M21 — Workflow Marketplace / Recipe Economy / Agent Center
**Mục tiêu**: biến best practices thành reusable operating units.

**Primary Objects**: Recipe Template, Workflow, Agent Run, Audit Event.

**Functions**:
- recipe library
- install/clone recipes
- template parameterization
- agent plans
- run history
- usage insights

**Acceptance Criteria**:
- installed recipe phải map được về canonical workflow/agent objects
- recipe/agent không được phá auditability
- dependencies và required capabilities phải được giải thích rõ

**Mobile Execution Requirement**:
- run recipe, inspect result, approve next step

### 23.22 M22 — Capability Matrix & Policy Center
**Mục tiêu**: giải thích rõ “làm được gì, không làm được gì, vì sao”.

**Primary Objects**: Capability Snapshot, Policy Note, Fallback Path, Diagnostics Record.

**Functions**:
- platform capability matrix
- policy notes
- fallback guidance
- execution ownership notes
- diagnostics entry points

**Acceptance Criteria**:
- mọi degraded/unsupported action mở được explanation
- policy notes và fallback paths truy được từ action context
- capability state không bị giấu khỏi user

**Mobile Execution Requirement**:
- inspect policy note, follow fallback quickly

### 23.23 M23 — Reporting / Admin / Billing / Diagnostics
**Mục tiêu**: cung cấp lớp vận hành, support, billing, reporting để sản phẩm full-scope usable.

> **Ref**: S26 (Internal Admin & Operations Site) — spec đầy đủ cho **Internal Admin Site** (admin.creativanta.app), tách biệt hoàn toàn khỏi workspace-level admin trong main app.

**Primary Objects**: Report, Billing Event, Metering Record, Diagnostics Record, Audit Event, Admin Override Action, Internal Admin User, Internal Role, Internal Permission, Internal Audit Log, System Alert, Moderation Case, Fraud Case, Incident, Post-Mortem, Webhook Subscription Monitor, API Key Admin Record.

**Functions**:
- reporting
- workspace admin (in-app, cho workspace Owner/Admin)
- connector admin
- provider admin
- billing admin
- diagnostics console
- support tools
- policy center updates
- metering/billing logs
- **internal admin site** (S26): Super Admin RBAC, user/workspace management, billing console, AI cost tracking, content moderation, support management, system health monitoring, feature flags, audit/compliance, **fraud & abuse detection, job queue monitor, webhook & connector health, API key management, incident management**

**Acceptance Criteria**:
- admin/support không phá canonical truth
- override tools phải có reason và audit trail
- diagnostics hierarchy usable cho non-technical user trước khi đến engineering logs
- internal admin site hoàn toàn tách biệt khỏi main app (separate auth, VPN access, internal RBAC)

**Mobile Execution Requirement**:
- inspect critical diagnostics, approve urgent admin actions, view reports summary

---

## 24. State Machine Requirement

Các object sau **bắt buộc** phải có standardized state machines trong downstream specs:
- Opportunity
- Script
- Asset
- Publish Job
- Publish Item
- Thread
- Offer
- Order
- Refund
- Reconciliation Record
- Workflow Run
- Agent Run
- Sample Request
- Sample Shipment
- Live Session

PRD khóa rule này ở cấp sản phẩm; state transition table chi tiết sẽ nằm ở Product Freeze và Detail Design.

---

## 25. Cross-Module Contract Rules

Các contract sau là bất khả vi phạm:
- Trend/Signal phải đi tiếp được sang Opportunity hoặc Idea.
- Opportunity phải đi tiếp được sang Idea, Script, Campaign hoặc Live Plan.
- Script phải đi tiếp được sang Asset Brief và Publish.
- Asset phải đi tiếp được sang Packaging và Publish.
- Publish phải để lại logs và quay về Engagement / Commerce / Proof.
- Thread phải đi tiếp được sang reply, task, idea, offer, seeding hoặc campaign action.
- Offer/Campaign phải nối về Order / Settlement / Cost / Profit.
- Proof/Profit phải mở ngược ra Evidence và source context.
- Workflow/Agent phải dùng canonical objects, không tạo parallel state ngoài graph.

---

## 26. Reporting and Explainability Rules

Mọi surface quan trọng phải trả lời được:
- điều gì đang xảy ra
- vì sao hệ thống nói vậy
- dữ liệu đến từ đâu
- chỗ nào còn thiếu hoặc chưa chắc
- việc tiếp theo nên làm là gì

Giải thích phải ưu tiên plain language trước, technical detail sau.

---

## 27. Beginner UX và Progressive Disclosure Rules

Để người non-tech dùng được, sản phẩm phải:
- không bắt user “học module” trước khi làm việc
- ưu tiên flow theo task/loop hơn taxonomy nội bộ
- dùng CTA cụ thể thay vì abstract score-only views
- có empty states, partial setup states, broken states và repair states rõ ràng
- giải thích trust/capability bằng ngôn ngữ dễ hiểu
- cho phép user bắt đầu bằng recipe, object hoặc suggested action, không ép vào command-heavy UX

---

## 28. Security, Privacy, Reliability và Operational Integrity

### 28.1 Reliability
- graceful degradation
- connector retries
- workflow retries / dead-letter
- resilient mobile sync
- diagnostics-first failure handling

### 28.2 Security
- encryption at rest / in transit
- RBAC
- audit logs
- secret isolation
- BYOK isolation

### 28.3 Privacy
- workspace separation
- delete/export flows
- retention policies
- least privilege

### 28.4 Data Integrity
- immutable audit events cho state changes quan trọng
- idempotent ingestion nơi phù hợp
- reconciliation jobs
- conflict resolution rules

### 28.5 Operational Integrity
- UI không được tự tính money logic khác finance/proof layer
- manual override phải có reason và audit trail
- business-critical agent/workflow actions phải lưu side effects đầy đủ

---

## 29. Admin, Support và Diagnostics Philosophy

Sản phẩm full-scope nhưng phải support-friendly nhờ:
- standardized state machines
- self-serve diagnostics
- repair wizards
- explanation-first UX
- admin override tools có kiểm soát

Diagnostics hierarchy phải gồm:
- user-facing explanation
- operator diagnostics
- engineering trace log
- audit event stream

---

## 30. Packaging, Pricing và Monetization

### 30.1 Pricing Principle
Một kiến trúc chung, **tier-based capacity model**. Tier mở capacity (credits, accounts, seats) và feature gates. Operator modes thay đổi UX emphasis, **không cắt domain scope**. Add-ons bổ sung capability chuyên sâu.

### 30.2 Subscription Tiers (Canonical — Chi tiết tại Pack 08)

| Tier | AI Credits | Connected Accounts | Operator Modes | Seats |
|---|---|---|---|---|
| **Free** | 50/mo | 2 | 1 | 1 |
| **Starter** | 500/mo | 5 | 2 | 2 |
| **Pro** | 2,000/mo | 15 | all | 5 |
| **Business** | 10,000/mo | 50 | all + multi-creator | 20 |
| **Enterprise** | custom | custom | custom | custom |

### 30.3 Add-on Modules
- Commerce Intelligence Add-on (advanced fit graph, competitor deep dive)
- Continuity Pro Add-on (unlimited packs, advanced drift detection)
- Advanced Profit / Reconciliation Add-on (multi-source reconciliation, advanced cost attribution)
- Workflow / Agent Pro Add-on (unlimited workflows, priority agent execution)
- Extra AI Credit Packs (pay-as-you-go top-ups)

### 30.4 Feature Gating Rule
- Tier gates checked TRƯỚC role/permission gates
- Over-limit: inline upsell card, KHÔNG force redirect
- Hard block cho Free/Starter khi hết credits, soft warning cho Pro/Business
- Operator mode availability follows tier allocation, không tạo separate pricing per mode

### 30.5 Monetization Surfaces
- subscriptions (monthly/annual)
- add-ons (always available as upsell)
- usage-based AI credit top-ups
- template/recipe marketplace commission
- setup/onboarding services

### 30.6 Free Tier Surfaces
- 50 AI credits per month
- 2 connected accounts
- 1 operator mode
- limited Daily Brief
- Creativanta watermark on AI-generated exports
- shareable scorecards

---

## 31. KPIs và Success Metrics

### 31.1 North Star
**Qualified profit influenced per active workspace**

### 31.2 Supporting Metrics
- qualified revenue influenced per active workspace
- closed-loop completion rate
- multi-module operating rate
- proof-covered revenue rate
- profit confidence coverage
- continuity pass rate
- workflow-assisted action rate

### 31.3 Reliability Metrics
- connector health
- workflow failure rate
- publish fallback rate
- stale sync rate
- unreconciled revenue rate
- diagnostics resolution rate

---

## 32. Performance & Core Web Vitals Contract

### 32.1 Core Web Vitals Targets

| Metric | Web Target | Mobile Target | Measurement |
|---|---|---|---|
| **LCP** (Largest Contentful Paint) | ≤ 2.5s | ≤ 2.0s | P75 across all key pages |
| **INP** (Interaction to Next Paint) | ≤ 200ms | ≤ 200ms | P75 across all interactions |
| **CLS** (Cumulative Layout Shift) | ≤ 0.1 | ≤ 0.1 | Session-based |
| **FCP** (First Contentful Paint) | ≤ 1.8s | ≤ 1.5s | P75 |
| **TTFB** (Time to First Byte) | ≤ 800ms | ≤ 600ms | P75 |

### 32.2 Rendering Strategy per Surface Type

| Surface Type | Rendering | Rationale |
|---|---|---|
| Home / Daily Brief | SSR + streaming | Fast LCP, personalized data |
| Object list pages | SSR + client hydration | SEO + fast first paint |
| Object detail pages | SSR shell + client fetch | Fast navigation, dynamic data |
| Live War Room (M17) | CSR + WebSocket | Real-time priority |
| Inbox (M12) | CSR + WebSocket | Real-time priority |
| Workflow builder (M20) | CSR | Heavy interactive canvas |
| AI Studio (M07) | CSR + progressive | Media-heavy |
| Reports / Dashboards | SSR + lazy charts | Data-heavy, LCP-sensitive |
| Admin / Settings | CSR | Low traffic, high interactivity |

### 32.3 Bundle Size Budget

| Bundle | Max Size (gzip) |
|---|---|
| Initial JS bundle | ≤ 150 KB |
| Per-route chunk | ≤ 80 KB |
| Shared component library | ≤ 60 KB |
| Total first-load transfer | ≤ 400 KB |

Code-splitting bắt buộc theo route và module boundary.

### 32.4 API Response Time SLAs

| API Type | P50 | P95 | P99 |
|---|---|---|---|
| Read / list queries | ≤ 100ms | ≤ 300ms | ≤ 500ms |
| Write / mutation | ≤ 200ms | ≤ 500ms | ≤ 1s |
| Search / full-text | ≤ 200ms | ≤ 500ms | ≤ 1s |
| Report generation | ≤ 2s | ≤ 5s | ≤ 10s |
| AI generation request submission | ≤ 300ms | ≤ 1s | ≤ 2s |
| Publish execution dispatch | ≤ 500ms | ≤ 1s | ≤ 2s |

### 32.5 Caching Strategy

| Layer | Strategy | TTL |
|---|---|---|
| Static assets | CDN edge cache, immutable hash | ≥ 1 year |
| API responses (read) | Stale-while-revalidate | 30s – 5min |
| User session data | Client memory + IndexedDB | Session |
| Object list projections | Server-side in-memory + invalidation | Event-driven |
| Search index | Near-real-time sync | ≤ 5s delay |
| Image / media thumbnails | CDN + responsive sizing | ≥ 1 year |

### 32.6 Mobile-Specific Performance

- **Offline-first**: critical read data cached locally (IndexedDB / SQLite)
- **Optimistic updates**: mutations show immediately, sync in background
- **Connection-aware loading**: degrade gracefully on slow/2G networks
- **Image strategy**: responsive images, WebP/AVIF with fallback, lazy loading
- **Prefetch**: next likely navigation targets preloaded on interaction
- **App size**: initial download ≤ 30 MB (native) hoặc ≤ 3 MB (PWA shell)

### 32.7 Loading State Contract

| State | Visual Treatment |
|---|---|
| Initial page load | Skeleton screen matching layout |
| Data fetching | Shimmer placeholder, not spinner |
| Background refresh | Subtle indicator (dot / badge), no blocking |
| Stale data | Stale banner with "last updated X ago" |
| Slow connection | Progress bar + estimated time |
| AI/media job progress | Multi-step progress with current stage name |
| Offline | Offline banner + cached data indicator |

### 32.8 List & Data Performance

- List virtualization bắt buộc khi > 50 items
- Infinite scroll hoặc paginated load theo context (inbox = infinite, reports = paginated)
- Filters, sort, search phải persisted across navigation
- Saved views phải persisted per user per workspace
- Debounced search input (≥ 300ms debounce)

### 32.9 Performance Monitoring Contract

Sản phẩm bắt buộc monitor:
- Core Web Vitals (real user metrics)
- API latency percentiles
- Error rates per surface
- Bundle size per release
- Mobile crash rate
- Stale data incident rate

---

## 32A. Search & Command Hub Contract

### 32A.1 Mục tiêu
Global Search / Command Hub là accelerator chính cho power users và entry path nhanh cho mọi user.

### 32A.2 Search Capabilities

| Capability | Requirement |
|---|---|
| Full-text search | Across all canonical objects Tier A + B |
| Fuzzy matching | Typo-tolerant, phonetic matching for Vietnamese |
| Faceted search | Filter by object type, module, status, owner, date |
| Recent searches | Persist per user, ≤ 20 items |
| Search suggestions | Auto-complete as-you-type, ≤ 200ms |
| Deep linking | Click result → navigate to object detail |
| Contextual search | Search scoped to current module when triggered in-context |

### 32A.3 Command Hub
Command bar phải support:
- object search
- quick actions (create idea, publish, approve)
- navigation shortcuts
- operator mode switch
- recipe trigger
- keyboard shortcut hint display

### 32A.4 Performance
- Search suggestion response: ≤ 200ms
- Full search result: ≤ 500ms
- Command execution: ≤ 300ms

### 32A.5 Mobile Search
- Pull-down search hoặc dedicated search tab
- Voice search support khi platform hỗ trợ
- Recent results accessible offline

---

## 32B. Real-time & Sync Contract

### 32B.1 Real-time Surfaces

| Surface | Protocol | Requirement |
|---|---|---|
| Live War Room (M17) | WebSocket | ≤ 500ms latency |
| Unified Inbox (M12) | WebSocket / SSE | ≤ 2s message arrival |
| Publish Job progress (M11) | WebSocket / SSE | Status update ≤ 3s |
| Workflow Run status (M20) | WebSocket / SSE | Status update ≤ 3s |
| Connector health (M22) | Polling / SSE | ≤ 30s refresh |
| Notifications / Alerts | WebSocket / Push | ≤ 5s delivery |
| AI generation progress (M07) | Polling / SSE | ≤ 5s progress update |
| Approval queue (M20/M21) | WebSocket | ≤ 5s new item arrival |
| Profit anomaly alerts (M19) | SSE / Polling | ≤ 1min detection → notification |

### 32B.2 Sync Strategy

| Data Type | Sync Model |
|---|---|
| Critical operational data | Real-time push (WebSocket/SSE) |
| Object list projections | Event-driven invalidation + refetch |
| Report data | Scheduled refresh + manual refresh CTA |
| File/media assets | Upload → CDN → reference update |
| Mobile offline data | Background sync on reconnect |

### 32B.3 Conflict Resolution
- Last-write-wins cho non-critical fields
- Merge UI cho concurrent edits trên critical fields (script body, workflow definition)
- Optimistic lock với version check cho financial/proof mutations

### 32B.4 Reconnection Contract
- Auto-reconnect WebSocket với exponential backoff
- Hiển thị connection status indicator
- Queue offline mutations, replay on reconnect
- Notify user nếu data có thể stale do disconnection

---

## 32C. Notification & Alert Contract

### 32C.1 Notification Channels

| Channel | Use Case |
|---|---|
| In-app notification center | Tất cả notifications |
| Push notification (mobile) | Urgent + high priority |
| Push notification (web/desktop) | Urgent nếu user opt-in |
| Email digest | Daily/weekly summary, non-urgent |
| In-context banner | Real-time warnings trong current view |

### 32C.2 Notification Priority Model

| Priority | Behavior | Example |
|---|---|---|
| **Urgent** | Push + in-app + badge + sound | Connector revoked, live emergency, payment failure |
| **High** | Push + in-app + badge | Approval waiting, profit anomaly, thread SLA breach |
| **Normal** | In-app + badge | Script approved, publish completed, new trend alert |
| **Low** | In-app only, batched | Weekly summary, recipe suggestion, benchmark update |

### 32C.3 Notification Grouping
- Group by object type + time window
- Collapse similar notifications (e.g., "5 new comments on Post X")
- Expandable groups

### 32C.4 Notification Preferences
- Per operator mode default configuration
- User override per notification type
- Do Not Disturb / quiet hours support
- Per workspace notification settings

### 32C.5 Push Notification Content Contract
Mọi push notification phải có:
- title (≤ 60 chars)
- body (≤ 120 chars, action-oriented)
- deep link to relevant object/action
- action buttons khi platform hỗ trợ (approve/reject, reply, open)

### 32C.6 Operator Mode Alert Priorities

| Mode | Top Alert Types |
|---|---|
| Creator | Script/asset approval, publish result, trending opportunity |
| Seller | Order anomaly, stock alert, profit warning, inbox SLA |
| Affiliate | Link performance, commission update, conversion spike |
| Live Operator | Live session start, urgent cue, comment surge |
| Agency/MCN | Approval waiting, diagnostic issue, report ready |
| Brand Collaboration | Deliverable due, proof request, invoice action |

---

## 32D. Daily Brief Intelligence Contract

### 32D.1 Mục tiêu
Daily Brief là surface đầu ngày quan trọng nhất. Phải chuyển được user từ "không biết làm gì" sang "biết làm gì ngay" trong ≤ 30 giây.

### 32D.2 Selection Algorithm
Daily Brief cards được chọn dựa trên:
1. **Impact score**: estimated revenue/profit impact
2. **Urgency score**: time sensitivity (SLA, expiry, anomaly recency)
3. **Effort score**: inverse — ưu tiên quick wins
4. **Operator mode weight**: mode-specific priorities
5. **Unresolved item age**: items chờ lâu được boost priority

### 32D.3 Composition Rules
- Luôn hiển thị ≤ 7 cards
- Ít nhất 1 opportunity/growth card
- Ít nhất 1 risk/anomaly card nếu tồn tại
- Ít nhất 1 pending action card nếu tồn tại
- Remaining slots fill bằng impact × urgency ranking

### 32D.4 Personalization
- Rule-based cho v1 (operator mode + workspace data)
- ML-based cho v2+ (learning từ user action patterns)
- Explicit feedback: dismiss / snooze / "not relevant" phải ảnh hưởng tới future ranking

### 32D.5 Refresh & Freshness
- Daily Brief refresh mỗi 15 phút hoặc khi user mở app
- Real-time injection cho urgent items (connector break, payment failure)
- Stale indicator nếu data > 30 phút tuổi

### 32D.6 Mobile Daily Brief
- Notification-style summary mỗi sáng (nếu user opt-in)
- Swipeable card stack trên mobile
- Mỗi card ≤ 2 taps tới action

---

## 32E. Export & Sharing Contract

### 32E.1 Exportable Objects

| Object / Surface | Export Formats |
|---|---|
| Proof Bundle | PDF report, JSON data |
| Profit Snapshot / Report | PDF, CSV, Excel |
| Script | Markdown, PDF, Google Docs |
| Campaign scorecard | PDF, shareable link |
| Workspace performance | PDF, CSV, Excel |
| Affiliate statement | CSV, PDF |
| Live session summary | PDF |
| Diagnostics report | PDF, JSON |

### 32E.2 Sharing Model

| Share Type | Mechanism |
|---|---|
| Team share | Object-level permission + workspace RBAC |
| Client share | Read-only shareable link with expiry |
| Public scorecard | Public URL (opt-in, data-limited) |
| Export download | Secure download with audit trail |
| API export | Authenticated API endpoint |

### 32E.3 Shareable Link Contract
- Expiry control (1 day, 7 days, 30 days, custom)
- Password protection optional
- View tracking (who viewed, when)
- Revoke anytime
- Branding customizable (workspace logo, colors)

### 32E.4 Export Performance
- Small exports (< 1000 rows): synchronous, ≤ 3s
- Large exports: async job with progress notification
- PDF generation: ≤ 10s for standard reports

---

## 32F. Internationalization & Localization Contract

### 32F.1 Language Support
- Primary: Vietnamese (vi-VN), English (en-US)
- Secondary (planned): Thai (th-TH), Indonesian (id-ID), Filipino (fil-PH)
- All UI strings externalized, no hardcoded text

### 32F.2 Content Rules
- Canonical system naming (module IDs, object types, field names) luôn giữ English
- User-facing labels, tooltips, error messages, help text → localized
- User-generated content → display as-is, no auto-translate
- Score names, capability states, source classes → localized display label, canonical key giữ English

### 32F.3 Format Localization

| Element | Localized By |
|---|---|
| Currency | Workspace region profile (VND, USD, THB, IDR, PHP) |
| Date/time | Workspace region profile + user preference |
| Number format | Locale-aware (decimal sep, thousands sep) |
| Phone number | International format |
| Address | Region-specific format |

### 32F.4 RTL Support
- RTL layout readiness for future Arabic/Hebrew markets
- CSS logical properties preferred (margin-inline, padding-block)

### 32F.5 Translation Management
- Translation files per locale, JSON/YAML format
- String keys namespaced by module
- Pluralization support bắt buộc
- Context comments for translators attached to each key

### 32F.6 SEA-Specific Requirements
- Vietnamese diacritics search support
- Currency display: VND uses dot separator (1.000.000đ), không dùng decimal
- Date format mặc định: DD/MM/YYYY cho vi-VN region
- SMS/Zalo notification support cho Vietnamese market

---

## 32F-bis. Offline & Connectivity Contract

### 32F-bis.1 Offline Data Availability (Mobile)

| Data Type | Available Offline | Sync Strategy |
|---|---|---|
| Daily Brief (cached) | ✅ | Background refresh every 30 min |
| Task queue | ✅ | Bi-directional sync on reconnect |
| Draft scripts/content | ✅ | Local-first, sync on reconnect |
| Publish queue status | ✅ (read) | Server-authoritative on reconnect |
| Inbox threads (cached) | ✅ (read) | Full sync on reconnect |
| Real-time notifications | ❌ | Push notification fallback |
| AI generation | ❌ | Requires connectivity |
| Analytics / dashboards | ✅ (cached) | Refresh on reconnect |
| Settings / preferences | ✅ | Local-first |

### 32F-bis.2 Conflict Resolution
- **Server-wins** cho: publish states, order states, financial data, capability states
- **Client-wins** cho: draft edits, task status changes, preferences
- **Merge** cho: thread triage (combine actions), workflow pause/resume
- Conflict detected → inline indicator + manual resolve option khi cần
- Last-write-wins cho single-field edits; structural changes require explicit merge

### 32F-bis.3 Connectivity Loss UX
- **Detection**: online/offline status via navigator.onLine + heartbeat ping
- **Banner**: persistent top banner "You're offline — changes will sync when reconnected"
- **Queue**: offline actions queued locally, replayed on reconnect
- **Retry**: auto-retry queued actions with exponential backoff (max 3 retries)
- **Stale data indicator**: show "Last updated X min ago" when data might be outdated

### 32F-bis.4 Network-Aware Behavior
- WiFi: full real-time features, prefetch, background sync
- Cellular: reduced prefetch, lazy-load images, defer non-critical sync
- Metered: no auto-play video, reduced image quality, no background sync
- Offline: read-only cached data + local draft editing

## 32G. Legal / Compliance / Consent Contract

### 32G.1 Mandatory Legal Documents
Creativanta bắt buộc có và duy trì:
- Terms of Service (ToS)
- Privacy Policy
- Cookie Policy
- Acceptable Use Policy (AUP)
- DMCA / Copyright Policy
- AI Content Disclaimer
- Data Processing Agreement (DPA)

### 32G.2 Consent Management
- Cookie consent banner: first visit, Accept All / Reject All / Customize
- ToS acceptance: click-wrap bắt buộc trước khi sử dụng
- Privacy policy acknowledgment: cùng thời điểm ToS
- AI data usage consent: explicit opt-in, default OFF
- Connected account permission disclosure: trước mỗi lần connect
- Consent records lưu trữ 5 năm

### 32G.3 Third-Party Liability Protection
Creativanta sử dụng API bên thứ ba (TikTok, YouTube, Shopee, Instagram...). Platform KHÔNG đảm bảo tính khả dụng liên tục của tính năng phụ thuộc bên thứ ba. Khi API/policy thay đổi:
1. Capability state → Degraded/Unsupported
2. User notification trong 48h
3. Manual fallback path nếu có
4. KHÔNG hoàn tiền cho services bị ảnh hưởng bởi third-party changes

### 32G.4 AI Content Liability Shield
- AI output là GỢI Ý, user chịu trách nhiệm cuối cùng
- Không warranty về accuracy, originality, platform compliance
- Financial insights từ AI không thay thế professional advice

### 32G.5 Service Level Agreement
- Target uptime: 99.5% monthly
- Service credits cho outage > 4 giờ
- Credit cap: 30% monthly subscription
- Credit không quy đổi thành tiền mặt

### 32G.6 Regulatory Compliance
- PDPA (Vietnam): primary
- GDPR readiness cho EU expansion
- EU AI Act (Aug 2026)
- DMCA: takedown 48h, 3-strike policy

> **Chi tiết**: `creativanta_legal_compliance_consent_contract_v_3_1.md`

---

## 32H. AI Credit System & Budget Control

### 32H.1 AI Credit Unit
- AI Credit = abstraction layer cho mọi AI operation
- Mỗi tier có monthly credit allocation, reset mỗi billing cycle

### 32H.2 Credit Pricing
| Operation | Credits |
|---|---|
| Text generation | 1–5 |
| Image generation | 5–15 |
| Video generation (short) | 20–50 |
| Video generation (long) | 50–150 |
| Video editing — Quick Edit (user upload) | 15–40 |
| Video editing — Clip Factory (1→N, 10 clips) | 60–120 |
| Video editing — Multi-Merge (N→1) | 15–35 |
| Video editing — AI Remix Studio | 30–55 |
| Analysis / scan | 1–10 |
| Agent execution | 10–50 |

> **Note**: Đây là summary ranges. Quick Edit tổng 15-40 nhưng per-capability từ 3-30 credits (xem chi tiết Pack 08 §4.2). Credit estimator UX hiển thị chi tiết per-option trước khi user confirm.

### 32H.3 Budget Safety
- Hard block cho Free/Starter, soft warning cho Pro/Business
- Rate limit: max 100 AI requests/hour/workspace
- Anomaly detection: > 3x daily average → alert + throttle
- Credit cost hiển thị TRƯỚC khi confirm
- No credit reselling / farming

### 32H.4 Internal Cost Control
- Track actual_cost_usd per operation (internal)
- Alert if margin < 30%
- Model routing: cost-effective first, premium fallback
- Semantic caching cho similar prompts

> **Chi tiết**: `creativanta_pricing_credits_growth_contract_v_3_1.md`

---

## 32I. Platform Policy Compliance Engine

### 32I.1 Pre-Publish Compliance Scan
Trước mỗi publish, scan cho:
- Music copyright | Hashtag limits (TikTok max 5) | Missing #ad/#sponsored
- Banned keywords (Shopee competitor names) | AI content label requirements
- Dimension/duration compatibility | Misleading product claims
- Nudity/violence detection

### 32I.2 Scan Results
- `pass` / `pass_with_warnings` / `review_required` / `blocked`

### 32I.3 Policy Monitoring
- Crawl policy pages mỗi 24h → change detection → impact assessment → notify

### 32I.4 Post-Publish Monitoring
- Track flagged/removed content → log penalties → improve pre-publish scan

### 32I.5 AI Video Editing + Compliance
- User upload video → chọn mode (Quick Edit / Clip Factory / Multi-Merge / AI Remix) → AI process → compliance scan → export/publish
- Quick Edit, Clip Factory, Multi-Merge: compliance violations phải block export, không chỉ warn
- AI Remix: thêm originality check (script similarity < 30% vs reference), không dùng footage/audio gốc
- Virality Score (Clip Factory + Remix) sử dụng data từ Trend Engine (M02/M03)
- Trend-Aware Editing: trending hooks, caption styles, music sync từ Trend Engine

> **Chi tiết**: `creativanta_legal_compliance_consent_contract_v_3_1.md` §5

---

## 32J. Growth & Referral Engine

### 32J.1 Referral Program
- Double-sided rewards: referrer + referred đều nhận bonus credits
- Tier system: Bronze → Silver → Gold → Platinum
- Gold/Platinum: recurring commission 10–15%
- Anti-fraud: self-referral detection, min 30-day qualified period

### 32J.2 Viral Loop
User tạo content → Creativanta watermark (Free) → viewer hỏi tool → referral → new user → repeat

### 32J.3 Subscription Tiers
- Free: 50 credits, 2 accounts, 1 mode
- Starter: 500 credits, 5 accounts, 2 modes
- Pro: 2,000 credits, 15 accounts, all modes
- Business: 10,000 credits, 50 accounts, multi-creator
- Enterprise: custom

### 32J.4 Feature Gating
- Tier gates checked TRƯỚC role gates
- Inline upsell card khi hit limit, KHÔNG force redirect
- No dark patterns

### 32J.5 Affiliate Link Health Monitor
- HTTP check 6h / product availability 12h / price change 12h
- Link expiry alert 7 ngày trước
- Revenue impact assessment → sort by impact

> **Chi tiết**: `creativanta_pricing_credits_growth_contract_v_3_1.md`

---

## 33. Launch Readiness Definition

Creativanta chỉ sẵn sàng khi đạt đủ 7 mức completeness:

### 33.1 Domain Completeness
Tất cả domain chính usable trên web và mobile.

### 33.2 Truth Completeness
Evidence, source class, confidence, reconciliation hoạt động ở các luồng trọng yếu.

### 33.3 Execution Completeness
Capability matrix, fallback, diagnostics, logs, workflow trust layer sẵn sàng.

### 33.4 Commercial Completeness
Bundles, billing, metering, offers, ledger, key monetization surfaces usable.

### 33.5 Operational Completeness
Admin, support, diagnostics, policy center, connector health, agent/workflow logs usable.

### 33.6 Legal & Compliance Completeness (NEW)
- ToS, Privacy Policy, Cookie Policy, AUP deployed
- Consent management system active
- Platform policy compliance engine active
- DMCA process operational
- Age verification gate active

### 33.7 Pricing & Business Completeness (NEW)
- Subscription tiers live with feature gating
- AI credit system operational with budget controls
- Payment processing active
- Referral program active
- Billing/metering accurate

---

## 34. Key Risks và Mitigations

### 34.1 Platform policy changes
- capability registry
- feature flags
- policy notes
- fallback paths

### 34.2 Product complexity overwhelm
- operator modes
- recipe-first UX
- Daily Decision Engine
- smart defaults
- progressive disclosure
- repair-first onboarding

### 34.3 Low trust in metrics
- Evidence Graph
- Confidence System
- Reconciliation Queue
- Proof Bundles
- visible source class taxonomy

### 34.4 AI output inconsistency
- Continuity OS
- approved references
- drift flags
- lineage tracking

### 34.5 Too many moving parts operationally
- admin tooling
- diagnostics-first design
- workflow logs
- agent audit trails

---

## 35. What Is Frozen in This PRD

Các nội dung sau được xem là đã freeze ở cấp PRD:
- full-scope domain definition
- 23-module canonical map và module IDs M01–M23
- core user segments và 6 operator modes
- canonical object families
- critical object minimum contracts
- source class taxonomy
- confidence bands
- verification status taxonomy
- capability state taxonomy
- reconciliation state taxonomy
- mobile là execution surface thật
- beginner UX là product requirement, không phải nice-to-have
- state-machine requirement cho critical objects
- cross-module contract rules

---

## 36. What Moves to Product Freeze / Build Contract

Các nội dung sau **không còn được đổi nghĩa**, nhưng sẽ được chi tiết hóa ở v3.1 Product Freeze:
- field-level object contracts
- state transition tables
- score registry
- read/write ownership matrix
- workflow node taxonomy chi tiết
- simulation assumption model chi tiết
- acceptance traceability matrix
- screen-by-screen UX contract

---

## 37. Architecture Decisions Locked for Downstream Documents

Downstream documents phải bám theo các quyết định sau:
1. canonical object schema follows One Graph
2. Publish truth = Publish Item + Publish Log
3. Proof truth = Evidence Objects + Proof Bundles + Source Class + Confidence Context
4. money surfaces dùng canonical source class taxonomy
5. UI không được tự tính profit truth ngoài finance/proof context
6. bundle không được cắt domain scope
7. workflow/agent phải auditable và capability-aware
8. mobile không được view-only
9. Brand Collaboration Mode là mode canonical, không được bỏ quên ở UX specs
10. beginner usability là launch requirement
11. legal/compliance/consent là launch requirement
12. AI credit budget control là launch requirement
13. platform policy compliance engine là launch requirement

---

## 38. Final Product Definition

Creativanta là một full-scope web + mobile operating system cho creator commerce, được định nghĩa bởi các điều kiện sau:

1. Mọi domain cốt lõi của creator commerce đều hiện diện trong cùng một sản phẩm.
2. Mọi object cốt lõi đều nằm trong cùng một graph.
3. Mọi money-related insight đều có source class, confidence và proof path.
4. Mọi AI production đều có continuity và lineage.
5. Mọi action đều capability-aware và policy-safe.
6. Mọi workflow lặp lại đều có thể biến thành recipe, workflow hoặc agent plan.
7. Mọi user đều có thể làm việc theo operator mode phù hợp.
8. Mọi quyết định quan trọng đều có evidence, simulation hoặc explanation đủ rõ.
9. Mọi layer monetization đều nối được về operating ledger và profit truth.
10. Web và mobile đều là execution surfaces thật.
11. Người non-tech vẫn có thể vận hành được hệ thống nhờ guided UX, progressive disclosure và repair-first support.
12. Mọi hoạt động đều tuân thủ pháp lý, có consent management, ToS, privacy policy, và platform compliance engine.
13. AI operations đều budget-controlled, metered, và transparent về cost.
14. Growth engine (referral, viral loop, gamification) tích hợp sẵn trong sản phẩm.
15. User upload video tự quay có thể được AI chỉnh sửa thành sản phẩm chuyên nghiệp.
16. Profit OS cho user thấy lợi nhuận thật (không chỉ GMV) — duyệt mỗi ngày.
17. AI Copilot cho phép non-tech user ra lệnh bằng ngôn ngữ tự nhiên.
18. Content Repurpose biến 1 video → 50+ content pieces tự động.

Nếu thiếu một trong các điều kiện này, sản phẩm chưa phải là Creativanta đúng nghĩa.

---

## 33. Profit OS — Real Profit Tracking Engine

### 33.1 Mục tiêu
Giải quyết gap GMV vs actual profit (15-40% chênh lệch). User phải thấy **lợi nhuận thật** — không chỉ revenue.

### 33.2 Profit OS Dashboard

| Metric | Source | Tính toán |
|---|---|---|
| GMV (Gross) | Platform API | Tổng giá trị đơn hàng |
| Platform fees | Platform API | Commission + transaction + service fees |
| Shipping costs | Platform API + user input | Actual shipping deductions |
| Affiliate commissions | Platform API | Creator/affiliate payouts |
| Refund deductions | Platform API | Including platform-retained charges |
| COGS | User input (1 lần per product) | Cost of goods sold |
| Ad spend | Ads API integration | TikTok Ads, Shopee Ads |
| AI credit costs | Internal | Creativanta AI usage cost |
| **Net Profit** | Computed | GMV - ALL deductions |

### 33.3 Profit Granularity
- **Per product**: profit margin per SKU
- **Per platform**: compare TikTok vs Shopee vs others
- **Per content piece**: "Video X generated ₫2.3M profit"
- **Per time period**: daily / weekly / monthly P&L
- **Per campaign**: ROI per marketing campaign

### 33.4 Profit Alerts
- Product margin drops below threshold (configurable, default 15%) → alert
- Platform fee change detected → recalculate + alert
- Revenue trending down vs last period → early warning
- "Sản phẩm X đang lỗ 5% sau khi trừ phí mới" → suggest actions

### 33.5 Fee Database
- Maintain up-to-date fee schedules cho TikTok Shop, Shopee, Lazada
- Auto-update when platform announces fee changes
- Per-category fee rates (electronics vs fashion vs beauty)
- Regional fee variations (Vietnam, Thailand, Philippines)

### 33.6 Mapping
- Module: M09 (Profit Surface), M16 (Commerce), M22 (Reporting)
- Objects: extended from Pack 06 (Commerce/Finance)
- Backend: Profit Calculation Service → reads Order, Settlement, Billing Event objects

---

## 34. Creativanta Copilot — AI Conversational Assistant

### 34.1 Mục tiêu
Biến Creativanta thành "ChatGPT for creator business" — non-tech user ra lệnh bằng tiếng Việt tự nhiên.

### 34.2 Copilot Modes

| Mode | Trigger | Capabilities |
|---|---|---|
| 💡 Creative | "Gợi ý ý tưởng...", "Tạo video cho..." | Brainstorm, trend analysis, content generation |
| 📊 Analytics | "Bán gì chạy nhất?", "So sánh..." | Query data, generate reports, visualize |
| ⚡ Action | "Lên lịch đăng...", "Tạo workflow..." | Execute tasks, trigger workflows, manage queue |
| 🎬 Video Production | "Remix video này", "Cắt clip", "Ghép video", "Tạo showcase", "Biến ảnh thành video" | Route to production modes + extended features (M07) |
| 🆘 Help | "Hướng dẫn...", "Cách làm..." | Step-by-step guides, contextual help |

### 34.2B Video Production Commands (M07 integration)
| Câu lệnh tự nhiên | Action | Mode |
|---|---|---|
| "Remix video này" / "Tạo video tương tự" | Open AI Remix Studio + auto-fill URL | AI Remix |
| "Cắt clip từ video này" / "Tách video" | Open Clip Factory | Clip Factory |
| "Ghép các video lại" / "Merge video" | Open Multi-Merge | Multi-Merge |
| "Chỉnh sửa video" / "Edit video" | Open Quick Edit | Quick Edit |
| "Virality score bao nhiêu?" / "Video nào viral nhất?" | Show Virality Score | Analytics |
| "Cắt clip từ video X rồi đăng TikTok" | Clip Factory → auto-publish | Action chain |
| "Video trending nào nên remix?" | Trend Engine → filter → suggest | Creative + Remix |
| "Tạo video showcase sản phẩm này" | Open Product Showcase Studio | Product Showcase |
| "Biến ảnh này thành video" | Open Image-to-Video | Image-to-Video |
| "Tạo thumbnail cho video" | Open Thumbnail Studio | Thumbnail |
| "Tạo video từ link Shopee này" | Open Link-to-Video | Link-to-Video |
| "Dịch video sang tiếng Anh" | Open Translation Studio | Translation |
| "Streak bao nhiêu rồi?" / "Level tôi là gì?" | Show gamification stats | Analytics |
| "Phân tích video vừa đăng" | Open Performance Coach | Performance Coach |

### 34.3 Copilot Entry Points
- Floating chat button (bottom-right, all screens)
- Command bar (Cmd/Ctrl+K)
- Voice input (mobile)
- Morning Brief → "Hỏi Copilot" buttons inline

### 34.4 AI Credit Usage
- Simple queries (analytics, help): 0 credits (included in plan)
- Content generation (scripts, captions): 1-5 credits
- Complex actions (workflow creation, multi-step): 2-10 credits
- Credit cost shown BEFORE execution

### 34.5 Context Awareness
- Copilot understands: current screen, recent actions, workspace data
- Language: Vietnamese primary, English secondary, auto-detect
- Personality: friendly, concise, action-oriented
- Safety: no hallucinated data (only query real workspace data)

### 34.6 Mapping
- Module: M21 (Agent Center), Cross-cutting
- Objects: Copilot sessions logged for improvement (anonymized)
- Backend: Agent Runtime (Pack 03) + LLM orchestration

---

## 35. Morning Brief — Enhanced Daily Intelligence

### 35.1 Mục tiêu
Thay thế notification flooding bằng 1 bản tin sáng cá nhân hóa → user mở app mỗi sáng.

### 35.2 Morning Brief Structure

```
📋 CREATIVANTA MORNING BRIEF — [Ngày/Tháng/Năm]

🔥 Highlights (overnight performance):
├─ Top performing content + metrics
├─ Unusual activity alerts (viral, spike, drop)
└─ New follower milestones

💰 Money Summary:
├─ Yesterday revenue (gross + net profit)
├─ Broken/expiring affiliate links
└─ Outstanding orders / returns

📋 Today's Actions:
├─ Scheduled publishes
├─ Pending approvals  
├─ Inbox threads needing response (priority sorted)
└─ AI credits remaining

🔮 AI Suggestions:
├─ Trending topics relevant to niche
├─ Optimal posting times for today
├─ Content ideas based on performance patterns
└─ Competitor activity highlights
```

### 35.3 Delivery Channels
- Push notification (mobile, 7:00 AM local time, configurable)
- In-app card (Dashboard home screen)
- Email digest (optional, daily/weekly toggle)
- Each section → deep link to relevant screen

### 35.4 Personalization Rules
- Brief content adapts to operator mode (Creator sees content metrics, Seller sees orders)
- Sections auto-hide if no relevant data (no empty sections)
- AI suggestions improve over time based on user engagement patterns
- Users can snooze, customize sections, change delivery time

### 35.5 Mapping
- Module: M01 (Daily Brief) — enhancement of existing spec
- Data aggregated from: M08 (Publish), M16 (Commerce), M03 (Trend), M09 (Profit)

---

## 36. Content Repurpose Engine — "1 Video → 50+ Content Pieces"

### 36.1 Mục tiêu
Giải quyết creator burnout (78% affected). 1 effort → 10x output. Auto-repurpose long-form → multi-format, multi-platform.

### 36.2 Repurpose Pipeline

```
INPUT: 1 long-form video (livestream, tutorial, review, interview)
│
├─ 📱 Auto-Clips (5-10 clips)
│   ├─ AI detect viral moments (hooks, punchlines, key points)
│   ├─ Virality score per clip (0-100)
│   ├─ Auto-reframe 16:9 → 9:16 (smart crop on speaker/subject)
│   └─ Credit cost: 10-30 per batch
│
├─ 📝 Text Posts (5-8 posts)
│   ├─ Platform-adapted: Facebook (long), Twitter/Threads (short), LinkedIn (professional)
│   ├─ Hashtag suggestions per platform
│   └─ Credit cost: 2-5 per batch
│
├─ 🖼️ Thumbnails (2-3 per clip)
│   ├─ AI extract best frames + enhance
│   ├─ A/B variants with different text overlays
│   └─ Credit cost: 3-5 per batch
│
├─ 📊 Carousel (1-2 sets)
│   ├─ Extract key points → visual slides
│   ├─ Auto-design with brand colors/fonts
│   └─ Credit cost: 3-8 per set
│
├─ ✍️ Blog Post (1)
│   ├─ Transcribe → structure with headings
│   ├─ SEO-optimized (keyword suggestions)
│   └─ Credit cost: 3-5
│
├─ 🎵 Audio Clip (1-3)
│   ├─ Extract audio → podcast-ready
│   ├─ Noise removal + normalization
│   └─ Credit cost: 2-3
│
├─ 📋 Captions (per clip)
│   ├─ Trending-style animated captions
│   ├─ Multi-language (vi, en)
│   └─ Credit cost: 2-3 per clip
│
└─ 📅 Auto-Schedule
    ├─ Distribute across week (optimal times per platform)
    ├─ Spacing rules: no self-competition
    └─ One-click approve → auto-publish
```

### 36.3 Input Requirements
- Max video length per tier: Free 5min, Starter 30min, Pro 60min, Business 120min
- Supported formats: MP4, MOV, AVI, WebM, MKV
- Upload or paste URL (YouTube, TikTok, drive)

### 36.4 Output Review
- All outputs generated as drafts → user reviews → approve/edit/discard
- Batch approve option for quick workflow
- AI confidence score per output (low confidence → flag for manual review)

### 36.5 Mapping
- Module: M06 (Script Lab), M07 (AI Video), M08 (Publish)
- Objects: Repurpose Job → linked to source Asset + generated Assets
- Backend: AI pipeline (Pack 04) → Publish queue (Pack 05)

---

## 37. P1 Strategic Features (Post-Launch Enhancement)

### 37.1 Content ROI Tracker

Per content piece:
- Views / engagement / reach (from platform APIs)
- Link clicks tracked (UTM auto-tagged by Creativanta)
- Orders attributed (via affiliate link + UTM correlation)
- Revenue generated → Cost to produce (AI credits + estimated time)
- **ROI % = (Revenue - Cost) / Cost × 100%**
- AI recommendation: "Tạo thêm content dạng này → predicted ROI: X%"
- Leaderboard: Top 10 highest-ROI content per month

Module: M22 (Reporting), M09 (Profit Surface)

### 37.2 Smart Scheduling Engine

- Analyze audience activity patterns per platform (from API data)
- Historical post performance by time slot
- Competitor posting pattern analysis
- Trend momentum detection (hot trend → suggest immediate post)
- Output: recommended posting calendar with AI-optimized times
- A/B mode: same content at different times → learn optimal slots
- Accuracy improvement: ML model trained on user-specific data over time

Module: M08 (Publish), M03 (Trend Discovery)

### 37.3 Creator Achievement System

Milestone badges + bonus credits:

| Achievement | Trigger | Reward |
|---|---|---|
| Debut Creator | First publish | 20 credits |
| Rising Star | 10K total views | 50 credits |
| Money Maker | First ₫1M revenue | 100 credits |
| Consistent Creator | 30-day publish streak | 200 credits |
| Viral Hit | 10x average views on single content | 150 credits |
| Pro Creator | First brand deal completed | 100 credits |
| Quick Learner | Complete onboarding | 30 credits |
| Ambassador | Refer 5 friends | 500 credits |
| Community Builder | Submit approved recipe | 50 credits |
| Profit Master | Maintain >30% margin for 30 days | 200 credits |

- Progress bars visible in profile
- Shareable badges (social media cards)
- Weekly challenges: "Đăng 5 video tuần này → bonus 100 credits"
- Achievement credits stack with referral credits

Module: M23 (User Engagement), M15 (Growth)

### 37.4 Platform Health Score

Per connected platform:

| Metric | Source | Target |
|---|---|---|
| Response rate | Inbox API | >90% |
| Shipping time | Order API | <3 days |
| Return rate | Order API | <5% |
| Review rating | Platform API | >4.5★ |
| Content frequency | Publish log | Platform-specific |
| Violation count | Platform API | 0 |
| Probation status | Platform API | Clear |

- Overall score: 0-100 (weighted composite)
- AI suggestions for improving low scores
- Alert when approaching penalty thresholds
- Historical trend chart

Module: M05 (Connector/Capability), M22 (Reporting)

### 37.5 Contextual Learning System

Instead of separate academy:
- Micro-tips embedded in workflow (1-sentence actionable advice)
- Quick how-to videos (30 seconds, in-context)
- Case study cards: "Creator X tăng revenue 300% bằng cách..."
- Milestone-triggered tips (first video → hook advice, first sale → pricing tips)
- Re-engagement tips after inactivity (7 days → "Trend mới tuần này")
- Quiz challenges: "Test kiến thức → earn credits"

Module: M01 (Daily Brief), Pack 01 (FE UX)

---

## 38. P2 Strategic Features (Roadmap — Phase 2)

Following features explicitly planned for post-launch (NOT in v1 scope, but architecturally prepared):

| Feature | Description | Prep Needed in v1 |
|---|---|---|
| **Deep Link Attribution** | UTM builder + click → conversion → revenue tracking per link | UTM param support in publish flow |
| **Content A/B Testing** | Auto-create variants → publish → auto-pick winner | A/B flag in Publish Item schema |
| **Brand Collaboration Marketplace** | Connect brands ↔ creators, proposal, contract, payment | External role in RBAC, campaign object |
| **Industry Benchmarks** | Anonymous aggregated metrics → "You're in top 20%" | Analytics event anonymization pipeline |
| **Team Workspace Templates** | Pre-built configs for Solo, MCN, Agency, Seller Team | Template seed data + onboarding flow |
| **AI Content Calendar Fill** | Visual calendar → AI suggest content for empty slots → 1-click generate | Content calendar UI + AI suggestion API |

These features MUST NOT be removed from roadmap. Backend schema should include placeholder fields where noted.

---

## 39. Product Identity (Updated)

Creativanta là một hệ thống hoàn chỉnh chỉ khi:

1. Quản trị và kinh doanh content cho creator/seller trên ≥ 3 nền tảng cùng lúc.
2. Dữ liệu có nguồn gốc rõ ràng (source class) và được reconcile chính xác.
3. Quy trình publish → đo lường → tối ưu chạy liên tục, không gián đoạn.
4. Dữ liệu content, commerce, profit, trend liên thông — không silo.
5. Mọi insight đều dẫn đến action, mọi action đều có audit trail.
6. Tổ chức/team nhiều người có thể cộng tác an toàn.
7. Sự cố nền tảng được phát hiện, thông báo, phân loại — không im lặng.
8. AI hỗ trợ liên tục: tạo nội dung, cắt video, gợi ý hành động, quản lý inbox — không phải nice-to-have.
9. Xu hướng và ý tưởng content mới luôn sẵn sàng — không cần rời hệ thống để research.
10. Commerce từ storefront → checkout → delivery → profit/loss → reconciliation chạy trên cùng graph.
11. Người non-tech vẫn có thể vận hành được hệ thống nhờ guided UX, progressive disclosure và repair-first support.
12. Mọi hoạt động đều tuân thủ pháp lý, có consent management, ToS, privacy policy, và platform compliance engine.
13. AI operations đều budget-controlled, metered, và transparent về cost.
14. Growth engine (referral, viral loop, gamification) tích hợp sẵn trong sản phẩm.
15. User upload video tự quay có thể được AI chỉnh sửa thành sản phẩm chuyên nghiệp.
16. **Profit OS cho user thấy lợi nhuận thật (không chỉ GMV) — sự khác biệt cốt lõi.**
17. **AI Copilot cho phép mọi user ra lệnh bằng ngôn ngữ tự nhiên — không cần biết navigate UI.**
18. **Content Repurpose biến 1 video → 50+ content pieces tự động — giải quyết burnout.**

Nếu thiếu một trong các điều kiện này, sản phẩm chưa phải là Creativanta đúng nghĩa.

---

## 40. Final Note

Đây là bản PRD Master v3.1 dùng làm nền tảng cho các tài liệu tiếp theo:
- Product Freeze / Build Contract
- System Design
- Data Schema
- Object Model
- Connector Specification
- Capability Registry
- Workflow Engine Spec
- Agent Framework Spec
- Commerce / Offer / Order / Inventory Schema
- Revenue / Cost / Profit / Reconciliation Spec
- Continuity OS Spec
- UX flows and screen maps
- Pricing and packaging model
- Admin / support architecture

Nguyên tắc downstream:
- được chi tiết hóa, không được tự đổi nghĩa
- được implementation hóa, không được cắt domain
- được tối ưu UX, không được làm đứt One Graph / Proof / Profit / Capability / Continuity contract


