---
layer: business
canonical: true
source: creativanta_pricing_credits_growth_contract_v_3_1.md
last_updated: 2026-10-30
---

# Pricing & Credits

> Conflict rule: nếu mâu thuẫn với PRD §30, PRD wins.

---

## 1. Tier Table

### 1.1 Tier Positioning

> **CANONICAL DECISION (2026-04-07)**: recurring subscription prices are now defined as launch-default catalog values. Finance may override runtime pricing via the admin pricing config, but implementation MUST treat the tables below as the default source-of-truth until an audited config override exists.
>
> **Currency rule**:
> - Catalog pricing uses fixed pricebooks by currency; it is **NOT** derived from spot FX at checkout time.
> - Launch pricebooks are defined for `USD` and `VND`.
> - Invoices and checkout display the workspace billing currency pricebook.
> - `Enterprise` remains contract/custom, not self-serve.

| Tier | Target | Positioning | USD Monthly | USD Annual | VND Monthly | VND Annual |
|---|---|---|---|---|---|---|
| **Free** | Explorer / evaluator | Try before buy, limited scope | $0 | $0 | ₫0 | ₫0 |
| **Starter** | Solo creator / small seller | Essential tools, affordable | $20 | $200 | ₫499,000 | ₫4,990,000 |
| **Pro** | Active creator / seller | Full feature set, higher limits | $60 | $600 | ₫1,499,000 | ₫14,990,000 |
| **Business** | Agency / MCN / brand | Multi-creator, collaboration, advanced analytics | $200 | $2,000 | ₫4,999,000 | ₫49,990,000 |
| **Enterprise** | Large organization | Custom, SLA, dedicated support | Custom | Custom | Custom | Custom |

Implementation notes:
- Annual billing follows the canonical `2 months free` rule (10 × monthly price).
- `Starter`, `Pro`, and `Business` are intentionally aligned to the nearest bundled credit-pack value for launch economics: 500 credits ≈ Starter, 2,000 ≈ Pro, 10,000 ≈ Business.
- Paywall, billing settings, and admin pricing tools MUST read catalog values from config/API, not hardcode them in UI.

### 1.2 Full Feature Gating Matrix

| Feature | Free | Starter | Pro | Business | Enterprise |
|---|---|---|---|---|---|
| **AI Credits/month** | 50 | 500 | 2,000 | 10,000 | Custom |
| **Connected accounts** | 2 | 5 | 15 | 50 | Unlimited |
| **Workspace members** | 1 | 2 | 5 | 20 | Custom |
| **Operator modes** | 1 | 2 | All | All | All |
| **AI video generation** | 3/mo | 30/mo | 150/mo | 500/mo | Custom |
| **AI video editing (upload)** | 2/mo | 20/mo | 100/mo | 300/mo | Custom |
| **Publish jobs/month** | 10 | 100 | 500 | 2,000 | Unlimited |
| **Trend monitoring** | Basic | Standard | Advanced | Full | Custom |
| **Live sessions/month** | 0 | 5 | 30 | Unlimited | Unlimited |
| **Commerce (products)** | 5 | 50 | 500 | 5,000 | Unlimited |
| **Workflow automations** | 3 | 20 | 100 | 500 | Unlimited |
| **Agent runs/month** | 0 | 10 | 50 | 200 | Custom |
| **Report exports** | 0 | 5 | Unlimited | Unlimited | Unlimited |
| **API access** | No | Read only | Read/Write | Full | Custom |
| **API keys** | 0 | 3 | 10 | 25 | Custom |
| **API webhook subscriptions** | 0 | 5 | 20 | 100 | Custom |
| **API requests / month** | 0 | 10,000 | 100,000 | 1,000,000 | Custom |
| **Affiliate link tracking** | 10 | 100 | 500 | 5,000 | Unlimited |
| **Storage** | 1 GB | 10 GB | 50 GB | 200 GB | Custom |
| **Priority support** | No | Email | Chat | Dedicated | Dedicated + SLA |
| **Custom branding** | No | No | Yes | Yes | Yes |
| **Approval workflows** | No | Basic | Advanced | Advanced | Custom |
| **Team roles/RBAC** | No | Basic | Full | Full | Custom |
| **Character slots** | 1 | 2 | 5 | 15 | Unlimited |
| **Digital Twin characters** | No | No | 1 | 5 | Unlimited |
| **Voice clone** | No | No | 1 voice | 5 voices | Unlimited |
| **Referral rewards** | Yes | Yes | Yes | Yes | Yes |

### 1.3 Production Mode Limits

| Mode | Free | Starter | Pro | Business |
|---|---|---|---|---|
| Quick Edit /mo | 2 | 20 | 100 | 300 |
| Clip Factory /mo | 0 | 5 | 30 | 100 |
| Multi-Merge /mo | 1 | 10 | 50 | 200 |
| AI Remix /mo | 0 | 3 | 20 | 50 |
| Product Showcase /mo | 0 | 10 | 50 | 200 |
| Image-to-Video /mo | 3 | 20 | 100 | 300 |
| Link-to-Video /mo | 0 | 5 | 30 | 100 |
| Translation /mo | 0 | 3 | 15 | 50 |
| AI Video Agent /mo | 0 | 5 | 30 | 100 |
| A/B Test variants /mo | 0 | 5 | 20 | 80 |
| Max upload size | 100MB | 500MB | 2GB | 5GB |
| Max duration (upload) | 3min | 10min | 30min | 60min |

### 1.4 Free Tier Specifics
- 50 AI credits per month
- 2 connected accounts, 1 operator mode
- Limited Daily Brief
- Creativanta watermark on eligible AI-generated exports; omit promotional watermark on platform delivery routes that prohibit it (including TikTok Direct Post). This provider-policy exception does not grant other paid features.
- Shareable scorecards

---

## 2. Credit System

### 2.1 How Credits Work
- AI Credit = đơn vị tính dùng chung cho mọi AI operation (1 credit ≠ 1 token — abstraction layer)
- Mỗi tier có monthly allocation
- Credit cost hiển thị **TRƯỚC** khi user confirm action
- Hệ thống sử dụng **Credit Reservation (Escrow) Flow** để tránh mất credit khi AI operation fail

### 2.2 Credit Reset & Rollover

| Tier | Reset Cycle | Rollover |
|---|---|---|
| Free | Monthly | Không rollover |
| Starter | Monthly | Không rollover |
| Pro | Monthly | Rollover tối đa 20% unused sang tháng sau |
| Business | Monthly | Rollover tối đa 20% unused sang tháng sau |
| Enterprise | Monthly | Custom rollover policy |

> **CANONICAL CLARIFICATION — Purchased Credit Packs vs Subscription Credits**:
> - **Subscription credits** (monthly allocation) follow the rollover rules above — unused credits expire or roll over per tier policy.
> - **Purchased credit packs** (one-time buy) **NEVER expire** and are **NOT subject to rollover limits**. They remain in the workspace balance indefinitely until consumed.
> - **Consumption order**: Subscription credits are consumed before purchased pack credits (earliest expiry first); expiring promotional grants are consumed before subscription lots. This ensures purchased credits serve as a reserve buffer.
> - **Display**: Workspace credit balance MUST use the complete CreditBalance projection in API behavior contracts: all source lots, total remaining, reserved and spendable available. Subscription plus purchased alone omits promotional/overage lots and held amounts.

### 2.3 Credit Reservation

All AI execution follows [Credit accounting](../04_contracts/credit_accounting_contract.md), the sole owner of reserve/commit/release, 30-minute initial lease, in-flight reconciliation, concurrency, expiry and late-result semantics. Credit cache is never financial authority.

---

## 3. Cost-Based Credit Quotes

The operation tables below classify billable operations; no historical credit range is a fixed price or maximum. A quote is computed before consent from a verified, versioned provider rate card. No model ID or provider-price example enables a live route automatically.

### 3.0 Quote algorithm and margin floor

1. Estimate a **bounded worst-case provider cost** in USD for the complete pipeline: input/output tokens, video seconds × samples × resolution/audio rate, TTS characters, music, lip-sync, rendering, paid retries/fallbacks and non-provider variable processing cost. Adapters MUST declare measured units and maximum attempts. Unbounded or stale/unavailable rates block live quotation.
2. Engineering default `usd_per_credit_floor = 0.015000` is the conservative net USD revenue per credit after the cheapest annual/bulk pricebook and payment fees. `gross_margin_floor = 0.5000`. Price/config changes MUST recompute the floor; promotions below it require an explicitly funded marketing budget or a new quote catalog. Free/included actions charge zero to users but have internal budgets/rate limits.
3. `quoted_credits = ceil(cost_ceiling_usd / (usd_per_credit_floor × (1 − gross_margin_floor)))`. Persist quote inputs, provider plan and rate version. Quote validity: five minutes. All wire amounts are decimal strings.
4. Example fixture, not a live rate promise: cost ceiling $0.600000 → 80 credits; at $0.015000 net/credit, revenue $1.200000 and 50% margin. Expensive models, longer clips or paid retry budgets increase the quote.
5. Actual customer charge uses the same catalog version and measured units, capped at confirmed credits. Additional paid attempts beyond the plan require a new quote and consent. Platform absorbs estimation errors; alert and suspend a systematically loss-making route.
6. Rate cards require provider/model/currency/units, audio/resolution/sample conditions, source URL, verified_at and valid_until (at most seven days after verification). Routes start disabled; deployment verifies availability, entitlement and measured metering before enabling.

Commercial subscription and credit-pack prices elsewhere in this document remain unchanged. Catalog defaults are engineering policy, not evidence of customer willingness to pay or measured profitability.


### 3.1 Core AI Operations

| AI Operation | Credits | Notes |
|---|---|---|
| Text generation (script, idea, copy) | Cost-based quote | Depends on length |
| AI image generation (standard) | Cost-based quote | Flux 2 / SDXL |
| AI image generation (HD) | Cost-based quote | GPT Image HD / Flux 2 Max |
| AI video generation (short <60s, standard) | Cost-based quote | Veo Fast / Kling Std / Runway Turbo |
| AI video generation (short <60s, premium) | Cost-based quote | Veo Quality / Kling Pro |
| AI video generation (long 1-3min) | Cost-based quote | Kling 3.0 extended |
| AI video editing (user upload) | Cost-based quote | Depends on duration/edits |
| AI video style transfer | Cost-based quote | Apply style to uploaded video |
| AI lip-sync (post-production) | Cost-based quote | SyncLabs / Wav2Lip per clip |
| AI video dubbing (1 language) | Cost-based quote | TTS + lip-sync + final mix per minute |
| AI music generation | Cost-based quote | Depends on duration |
| AI voice generation (standard) | Cost-based quote | Google Cloud TTS / OpenAI TTS |
| AI voice generation (premium) | Cost-based quote | ElevenLabs (expressive, Vietnamese) |
| AI translation | Cost-based quote | Per piece |
| AI content compliance scan | Cost-based quote | Per content item |
| AI trend analysis (deep) | Cost-based quote | Per analysis |
| AI script rewrite/optimize | Cost-based quote | Per script |
| AI thumbnail generation | Cost-based quote | Per thumbnail |
| AI caption/subtitle | Cost-based quote | Per video (Whisper + Gemini) |
| AI engagement reply suggestion | Cost-based quote | Per thread |
| AI simulation run | Cost-based quote | Per scenario |
| AI agent execution | Cost-based quote | Depends on complexity |

### 3.2 Character & Voice

| Operation | Credits | Notes |
|---|---|---|
| Character creation (AI Generated) | Cost-based quote | Per character |
| Character creation (Digital Twin) | Cost-based quote | Processing-intensive, one-time |
| Voice clone setup | Cost-based quote | One-time per voice |
| Character preview (15s test) | Cost-based quote | Quick validation |

### 3.3 Extended Production Features

| Operation | Credits | Notes |
|---|---|---|
| Product Showcase video (per style) | Cost-based quote | 360° cheapest, Virtual Try-On most expensive |
| Image-to-Video | Cost-based quote | Per image, depends on duration |
| Link-to-Video (URL → video ad) | Cost-based quote | Scraper + script + visual + voice |
| AI Translation (video dubbing) | Cost-based quote | Per language, depends on duration |
| AI Music (custom BGM) | Cost-based quote | Per track (30s-3min) |
| Speech-to-Song | Cost-based quote | Transform voice-over to singing |
| AI Sound Effects | Cost-based quote | Contextual SFX generation |
| Style extraction (to Style Pack) | Cost-based quote | Per style analysis + save |
| AI Video Agent (1-click pipeline) | Cost-based quote | Full pipeline orchestration |
| A/B variant generation | Cost-based quote | Per variant |
| Performance Coach analysis | 0 — included, budgeted internally | Included in plan |

### 3.4 Copilot

| Copilot Action | Credits | Availability |
|---|---|---|
| Analytics query (read-only) | 0 — included, budgeted internally | All tiers |
| Help / guidance | 0 — included, budgeted internally | All tiers |
| Content generation (script, caption) | Cost-based quote | Starter+ |
| Workflow creation | Cost-based quote | Pro+ |
| Multi-step action execution | Cost-based quote | Pro+ |
| Voice input | 0 — included, budgeted internally | All tiers |

> User chọn model cụ thể → credit cost có thể khác. System hiển thị estimated credits trước generate.

---

## 4. Add-on Modules

| Add-on | What It Unlocks | Eligible Tiers | USD Monthly | USD Annual | VND Monthly | VND Annual |
|---|---|---|---|---|---|---|
| **Commerce Intelligence** | Advanced fit graph, competitor deep dive | Starter+ | $39 | $390 | ₫999,000 | ₫9,990,000 |
| **Continuity Pro** | Unlimited packs, advanced drift detection | Starter+ | $29 | $290 | ₫749,000 | ₫7,490,000 |
| **Advanced Profit / Reconciliation** | Multi-source reconciliation, advanced cost attribution | Starter+ | $79 | $790 | ₫1,999,000 | ₫19,990,000 |
| **Workflow / Agent Pro** | Unlimited workflows, priority agent execution | Starter+ | $59 | $590 | ₫1,499,000 | ₫14,990,000 |
| **Extra AI Credit Packs** | Pay-as-you-go top-ups | Starter+ | See §5.7 | One-time | See §5.7 | One-time |

Add-on billing rules:
- Module add-ons inherit the workspace billing interval (`monthly` or `yearly`).
- Add-on purchase mid-cycle is prorated immediately on the current billing cycle.
- Add-on removal takes effect at the next billing boundary, not immediately.
- Extra AI Credit Packs remain one-time purchases and do **not** inherit the subscription interval.

---

## 5. Billing Rules

### 5.1 Billing Cycle
- Monthly billing (default) hoặc Annual (discount: 2 months free)
- Billing date = signup date

### 5.2 Plan Changes
- **Upgrade**: immediate, prorated charge
- **Downgrade**: takes effect next billing cycle
- Downgrade validation: check current usage vs new limits → warn → 7-day adjustment period

### 5.3 Trial
- 14-day free trial of Pro tier (no credit card required)
- Trial → auto-convert to Free if not upgraded
- 1 trial per email/payment method

### 5.4 Cancellation
- Cancel anytime, access until end of billing cycle
- Day 0–30 after expiry: read-only mode (view/export/delete, no create/generate/publish)
- Day 30–90: soft delete (`deleted_at` set, data inaccessible, reactivation via support)
- Day 90+: permanent hard delete of all workspace data
- Full data export available at any point before hard delete (GDPR Article 20)
- See `business_rules.md` BIZ-010, BIZ-014 for detailed lifecycle

### 5.5 Payment Methods
- Credit/debit card (Stripe)
- Bank transfer (Enterprise/Vietnam)
- Local: Momo, ZaloPay, VNPay (Vietnam)
- PayPal (international)

### 5.6 Failed Payment & Dunning
```
Day 0:  Payment fails → retry immediately
Day 1:  2nd retry → in-app banner
Day 3:  3rd retry → email
Day 5:  4th retry → email + in-app + push
Day 7:  GRACE PERIOD starts → read-only mode
Day 10: 5th retry → final email
Day 14: Grace ends → downgrade to Free tier
```

Grace period (Day 7–14): user can view/export data + update payment, but NOT create/generate/publish.

> **Note**: Dunning results in **downgrade to Free tier** (not data deletion). The workspace persists on Free tier with all data preserved. Data deletion only occurs per the cancellation lifecycle (BIZ-010/014: read-only Day 0-30, soft delete Day 30-90, hard delete Day 90+). If a user cancels after dunning downgrade, the cancellation timeline starts from the cancellation date.

### 5.7 Credit Purchase Options

| Pack | Credits | Price (USD) | Price (VND) | Per Credit |
|---|---|---|---|---|
| Small | 100 | $5 | ₫129,000 | $0.050 |
| Medium | 500 | $20 | ₫499,000 | $0.040 |
| Large | 2,000 | $60 | ₫1,499,000 | $0.030 |
| Mega | 10,000 | $200 | ₫4,999,000 | $0.020 |

- Purchased credits never expire; inactive/read-only access prevents spending but does not confiscate the lot. Reactivation and legally required erasure follow the credit accounting and retention contracts.
- Available cho mọi paid tier

### 5.8 Anti-Abuse
- Rate limit: max 100 AI requests/hour/workspace
- Per-action: max 10 video generations/hour
- Anomaly detection: >3x daily average → alert + temporary throttle
- No credit reselling, no automated credit farming

---

## 6. Feature Gating Summary

> Chi tiết gate logic, priority rules, và enforcement types: [business_rules.md § Feature Gating Rules](./business_rules.md#3-feature-gating-rules)

**Quick reference:**
- Tier gates checked **TRƯỚC** role/permission gates
- Over-limit → inline upsell card, **KHÔNG** force redirect
- Hard block: Free/Starter khi hết credits
- Soft warning: Pro (80%), Business (80%)
- Operator mode availability follows tier — **không pricing riêng per mode**

> Clarification: "auto-buy" for Pro refers to optional auto-refill of purchased credit packs after the workspace enables auto-refill. It does NOT grant Business-style invoice overage billing beyond the subscription allocation.
