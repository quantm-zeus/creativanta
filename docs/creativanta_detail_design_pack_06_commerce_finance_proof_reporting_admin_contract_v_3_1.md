# Creativanta — Detail Design Pack 06 — Commerce / Finance / Proof / Reporting / Admin Contract v3.1

## 0. Traceability Header

- **Upstream sections used**: Product Freeze sections 10–17, 20, 26–27, 30–46.
- **Canonical objects touched**: Product, SKU, Offer, Coupon, Affiliate Link, Membership Plan, Store Page, Campaign, Order, Refund, Return, Settlement, Cost Item, Reconciliation Record, Commission, Creator Payout, Affiliate Statement, Invoice, Margin Snapshot, Profit Snapshot, Evidence Object, Proof Bundle, Billing Event, Metering Record.
- **State machines touched**: Offer/Campaign/Store/Monetization Support, Order/Refund/Settlement/Reconciliation/Cost.
- **Read / write ownership respected**: finance/proof/reporting chỉ đọc hoặc derive từ canonical commerce/finance owners; không tạo shadow truth.
- **Acceptance scenarios inherited**: product-backed/product-less offer logic, monetization support lifecycle, refund/reconciliation proofability, profit truth, billing/metering consistency, admin override audit.

## 1. Mục tiêu

Pack này khóa các lớp truth nhạy cảm nhất:
- commerce objects
- order / settlement / cost / profit
- reconciliation
- evidence / proof bundle
- reporting projections
- billing / metering
- admin overrides

## 2. Commerce Contract

### 2.1 Product
Product phải là canonical catalog object cho:
- product-backed offers
- inventory applicability
- product-to-content mapping
- product-to-campaign mapping

### 2.2 Catalog Support Objects
Family contract này áp dụng cho: SKU, Variant SKU, Inventory Location, Stock Movement.

Bắt buộc có:
- canonical id theo subtype
- parent product/inventory scope ref
- quantity/location/variant facts theo subtype
- source system provenance
- effective timestamp
- reconciliation/import status nếu áp dụng

### 2.3 Offer
Offer phải tách rõ:
- product-backed offer
- product-less digital/community/membership offer

Offer contract bắt buộc có:
- pricing/value logic
- CTA logic
- channel availability
- lifecycle state

### 2.4 Monetization Support Objects
Family contract này áp dụng cho: Coupon, Affiliate Link, Membership Plan, Store Page, Bundle, Price Rule, Promotion Rule.

Bắt buộc có:
- canonical id theo subtype
- related product/offer/campaign/store refs
- commercial logic summary
- lifecycle state
- effective window nếu áp dụng
- auditability for price/commission/entitlement changes

### 2.5 Campaign
Campaign là coordination object cho:
- offer push
- affiliate coordination
- seeding effort
- sponsor/deliverable scope if applicable

## 3. Order / Refund / Settlement Contract

### 3.1 Order
Order là canonical transactional truth object cho order lifecycle, không thay cho settlement truth.

Order bắt buộc có:
- source class
- source system ref
- lifecycle state
- amount/currency
- related product/offer/campaign/post/live refs nếu có
- reconciliation state khi áp dụng

### 3.2 Refund / Return
Refund là money reversal truth object; Return là support object cho logistics/quantity reversal khi platform/source tách riêng.

Bắt buộc có:
- canonical id theo subtype
- related order ref(s)
- amount/currency hoặc quantity scope
- reason
- lifecycle state
- source class / source system ref
- settlement/reconciliation linkage nếu có

### 3.3 Settlement
Settlement là money realization / payout-context object, tách riêng khỏi Order.

Settlement bắt buộc có:
- gross/net components
- fees/deductions
- source class
- reconciliation state
- effective date/batch scope

## 4. Cost Contract

### 4.1 Cost Item Types
- ads spend
- AI generation cost
- tool/service cost
- shipping / fulfillment
- affiliate commission
- creator payout
- seeding / sample cost
- manual allocated cost

### 4.2 Payout / Statement Support Objects
Family contract này áp dụng cho: Commission, Creator Payout, Affiliate Statement, Invoice, Margin Snapshot, Click Event, Lead, Conversion Event.

Bắt buộc có:
- canonical id theo subtype
- related order/offer/campaign/live/product scope refs
- source class / provenance
- lifecycle/calculation status
- effective period
- proof/audit context nếu áp dụng

### 4.3 Rules
- mọi cost item phải có source class
- estimated cost không được render như official cost truth
- cost thiếu proof phải có confidence caveat
- payout/statement support objects không được làm mờ source-of-truth owner của order/refund/settlement

## 5. Profit Contract

### 5.1 Profit Snapshot
Profit Snapshot là derived truth object cho một scope (workspace, creator, offer, campaign, live, product, content).

### 5.2 Required Fields
- scope type/ref
- period
- revenue components
- cost components
- margin/profit outputs
- source mix summary
- confidence summary
- freshness

### 5.3 Rule
Profit UI không được tính ad-hoc trên FE ngoài canonical finance/proof layer.

## 6. Reconciliation Contract

### 6.1 Reconciliation Record
Bắt buộc có:
- scope
- related objects
- mismatch summary
- unresolved items
- current state
- suggested next actions
- override info if any

### 6.2 States
- open
- awaiting_evidence
- matching
- partially_reconciled
- fully_reconciled
- conflict_detected
- manually_overridden
- closed

### 6.3 Rule
Manual override bắt buộc có reason + audit trail + actor identity.

## 7. Evidence & Proof Contract

### 7.1 Evidence Object
Evidence Object là bằng chứng đơn lẻ.

Required:
- evidence type
- immutable ref/hash if applicable
- source provenance
- verification status
- related object refs
- collected_at

### 7.2 Proof Bundle
Proof Bundle là tập evidence hỗ trợ cho một claim.

Required:
- claim scope
- claim summary
- supporting evidence refs
- source class context
- confidence context
- coverage summary
- unresolved gaps

### 7.3 Confidence Reason
Confidence Reason là lớp giải thích vì sao confidence đang ở mức hiện tại, không thay cho evidence/proof bundle.

## 8. Reporting Contract

### 8.1 Reporting Principle
Reporting là projection/explanation layer, không phải truth owner.

### 8.2 Required Report Families
- executive / workspace summary
- creator performance
- trend/opportunity conversion
- publish performance
- commerce / revenue / profit
- affiliate / live / seeding outcomes
- diagnostics / connector health
- billing / usage

### 8.3 Mandatory Metadata
Mọi report phải khai báo:
- scope
- data freshness
- source mix
- confidence caveat if applicable
- unresolved gaps if material

## 9. Billing / Metering Contract

### 9.1 Billing Event
Billing events phải support:
- subscriptions
- add-ons
- usage-based charges
- credits / adjustments
- refunds if applicable

### 9.2 Metering Records
Metering phải track:
- feature scope
- usage quantity
- time window
- workspace scope
- pricing context

### 9.3 Rule
Billing/metering reporting không được mâu thuẫn với monetization/bundle contract ở PRD/Product Freeze.

## 10. Admin Override Contract

> **Ref**: S26 (Internal Admin & Operations Site) cho full admin console spec, RBAC, và audit framework.

### 10.1 Allowed Override Areas
- reconciliation override
- publish state correction
- workflow/agent force-cancel or force-complete
- billing adjustments
- controlled data repair

### 10.2 Required Fields
- actor
- permission scope
- reason
- affected objects
- old/new summary
- timestamp
- audit ref

### 10.3 Rule
Override là exceptional path, không phải operational shortcut mặc định.

## 11. FE/UX Notes

Các surface finance/proof phải support:
- source badges
- confidence badges
- freshness
- proof drawer
- unresolved gaps block
- drilldown to object/evidence/reconciliation
- direct navigation tới coupon / affiliate link / membership plan / store page / refund / payout support objects khi chúng ảnh hưởng tới claim hoặc profit view

## 12. Handoff

Detail design tiếp theo phải chốt:
- financial schemas
- reconciliation jobs
- proof assembly logic
- report definitions
- billing ledger design
- metering aggregation logic
- admin permission matrix


## 13. Acceptance Scenario Inventory

Commerce/finance/proof pack bắt buộc cover tối thiểu các scenario sau:
- product-backed và product-less offer paths cùng sống trong một canonical commerce graph
- coupon/affiliate link/membership/store/bundle/price-rule changes đều có lifecycle + audit + downstream reporting consistency
- order/refund/return/settlement/reconciliation/proof linkage truy ngược được tới source objects và unresolved gaps
- click/lead/conversion/commission/payout/statement/invoice/margin records không thay source-of-truth owner nhưng vẫn join được vào profit/proof views
- reporting và billing/metering không mâu thuẫn với finance/proof truth
- admin overrides luôn để lại audit trail và repair context

---

## S22. Recipe Marketplace Governance (Supplementary)

> **Ref**: PRD M21 (Recipe Marketplace), Tech Stack ADR (Activepieces)
> **Scope**: Marketplace governance for workflow recipes/templates ONLY.
> Community forum, tipping/donations, fan membership tiers → explicitly out of v1 scope.

### S22.1 Submission Review Process

| Step | SLA | Handler |
|---|---|---|
| Creator submits recipe | — | Self-serve |
| Automated scan | ≤ 1h | System (malware, policy, quality) |
| Manual review | ≤ 3 business days | Marketplace team |
| Publish / reject + feedback | — | System notification |

### S22.2 Revenue Share

| Party | Share | Notes |
|---|---|---|
| **Recipe creator** | 70% | Net after payment processing fees |
| **Creativanta** | 30% | Platform fee |
| Payment processing | ~3% (deducted from gross) | Stripe/VNPay fees |

- Minimum payout: 100.000 VND / $5 USD
- Payout schedule: monthly (net-30)
- Revenue tracked in creator's Profit OS

### S22.3 Rating & Review System

| Feature | Spec |
|---|---|
| Rating | 1-5 stars (required on review) |
| Written review | Optional text (≤ 500 chars) |
| Verified purchaser badge | Only users who installed can review |
| Creator response | Recipe creator can reply to reviews |
| Abuse prevention | Rate limit: 1 review per recipe per user. AI spam detection |
| Display | Average rating + review count on recipe card |

### S22.4 DMCA & Takedown

| Step | SLA |
|---|---|
| DMCA notice received | Acknowledge within 24h |
| Content takedown | Within 48h of valid notice |
| Counter-notice window | 14 days for creator to respond |
| Repeat infringer | 3 strikes → permanent marketplace ban |

### S22.5 Version Update & Refund Policy

| Policy | Detail |
|---|---|
| Version updates | Creator publishes update → existing users get notification → auto-update or manual |
| Breaking changes | Must be flagged in update notes → user can pin to previous version |
| Refund window | 7 days after purchase, if recipe not executed successfully |
| Auto-refund trigger | Recipe fails on first run due to recipe bug (not user config) |

---

## S25. Enterprise & Internal Ops (Supplementary)

> **Ref**: Pack 02 §14 (SSO), Pack 03 §11C.4 (Feature Flags), ADR Layer 9-10, **S26 (Internal Admin & Operations Site — full admin console, moderation, support management, AI cost tracking)**

### S25.1 White-Label (Enterprise Tier)

| Feature | Spec |
|---|---|
| Custom domain | `app.{client-domain}.com` → CNAME to Creativanta |
| Custom branding | Logo, colors, favicon replaceable per workspace |
| Email templates | Branded transactional emails with custom sender domain |
| Limitations | Core UI structure unchanged. Chromeless mode available (hide Creativanta branding) |

### S25.2 Enterprise Billing

| Feature | Spec |
|---|---|
| Purchase Orders | Manual PO upload → invoice generation → net-30 payment |
| Consolidated billing | Multiple workspaces under one invoice |
| Custom pricing | Negotiated rates for Enterprise tier |
| Dedicated account manager | Assigned TAM for Enterprise accounts |

### S25.3 Canary Deployment Strategy

```
Code merge → CI Green → Canary (5% traffic)
                           │
                    15 min observe (error rate, latency, p99)
                           │
                    ✅ Metrics OK → Expand to 25%
                           │
                    30 min observe
                           │
                    ✅ Metrics OK → Expand to 100% (full rollout)
                           │
                    ❌ Metrics Bad → Auto-rollback → Alert on-call
```

### S25.4 SLOs (Service Level Objectives)

| Service | SLO Target | Measurement |
|---|---|---|
| Web app availability | 99.9% | Uptime monitor (BetterUptime) |
| API availability | 99.95% | Health check endpoint |
| Payment processing | 99.99% | Stripe SLA + internal checks |
| Database | 99.95% | Neon/RDS monitoring |
| AI services | 99.5% | Multi-provider fallback |
| CDN/assets | 99.99% | Cloudflare SLA |

### S25.5 Cost Per Workspace Tracking

| Metric | Tracking Method |
|---|---|
| AI API cost | Per-workspace cost tracker (ADR §ADR-009) |
| Storage cost | R2 usage per workspace (tagged uploads) |
| Database cost | Estimated pro-rata by row count + query volume |
| Compute cost | Estimated pro-rata by API request volume |
| Total cost per user | Aggregated monthly → profitability per workspace |

### S25.6 Internal Health Dashboard

| Panel | Data Source | Refresh |
|---|---|---|
| Active users (DAU/MAU) | PostHog | Real-time |
| API latency p50/p95/p99 | Prometheus | 10s |
| Error rate | Sentry | Real-time |
| Database connections | PG stats | 30s |
| AI provider health | Circuit breaker status | 10s |
| Queue depth | Redis Streams | 10s |
| Revenue (MRR/ARR) | Stripe | Hourly |
| Churn rate | Computed | Daily |

