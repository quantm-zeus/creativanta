---
layer: business
canonical: true
source: creativanta_pricing_credits_growth_contract_v_3_1.md
last_updated: 2026-03-30
---

# Pricing & Credits

> Conflict rule: nếu mâu thuẫn với PRD §30, PRD wins.

---

## 1. Tier Table

### 1.1 Tier Positioning

| Tier | Target | Positioning |
|---|---|---|
| **Free** | Explorer / evaluator | Try before buy, limited scope |
| **Starter** | Solo creator / small seller | Essential tools, affordable |
| **Pro** | Active creator / seller | Full feature set, higher limits |
| **Business** | Agency / MCN / brand | Multi-creator, collaboration, advanced analytics |
| **Enterprise** | Large organization | Custom, SLA, dedicated support |

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
- Creativanta watermark on AI-generated exports
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
> - **Consumption order**: Subscription credits are consumed **first** (FIFO within billing cycle), then purchased pack credits. This ensures purchased credits serve as a reserve buffer.
> - **Display**: Workspace credit balance MUST show breakdown: `{subscription_remaining} + {purchased_remaining} = {total_available}`.

### 2.3 Credit Reservation (Escrow) Flow
1. User confirm AI action → System tạo reservation (status: pending) → balance giảm
2. **SUCCESS**: reservation confirmed, adjusted to actual cost (có thể < estimated)
3. **FAILURE**: credits trả lại balance ngay lập tức
4. **TIMEOUT**: auto-release sau 15 phút

Rules:
- Reservation TTL: 15 phút
- Max 5 concurrent reservations per workspace
- Reservation pending credits vẫn tính vào "used" cho quota check

---

## 3. Credit Cost Table

### 3.1 Core AI Operations

| AI Operation | Credits | Notes |
|---|---|---|
| Text generation (script, idea, copy) | 1–5 | Depends on length |
| AI image generation (standard) | 3–8 | Flux 2 / SDXL |
| AI image generation (HD) | 8–15 | GPT Image HD / Flux 2 Max |
| AI video generation (short <60s, standard) | 15–25 | Veo Fast / Kling Std / Runway Turbo |
| AI video generation (short <60s, premium) | 30–50 | Veo Quality / Kling Pro |
| AI video generation (long 1-3min) | 50–150 | Kling 3.0 extended |
| AI video editing (user upload) | 15–40 | Depends on duration/edits |
| AI video style transfer | 20–60 | Apply style to uploaded video |
| AI lip-sync (post-production) | 5–15 | SyncLabs / Wav2Lip per clip |
| AI video dubbing (1 language) | 10–30 | TTS + lip-sync + final mix per minute |
| AI music generation | 10–30 | Depends on duration |
| AI voice generation (standard) | 3–8 | Google Cloud TTS / OpenAI TTS |
| AI voice generation (premium) | 5–15 | ElevenLabs (expressive, Vietnamese) |
| AI translation | 2–5 | Per piece |
| AI content compliance scan | 1–3 | Per content item |
| AI trend analysis (deep) | 3–10 | Per analysis |
| AI script rewrite/optimize | 2–5 | Per script |
| AI thumbnail generation | 3–8 | Per thumbnail |
| AI caption/subtitle | 2–5 | Per video (Whisper + Gemini) |
| AI engagement reply suggestion | 1 | Per thread |
| AI simulation run | 5–15 | Per scenario |
| AI agent execution | 10–50 | Depends on complexity |

### 3.2 Character & Voice

| Operation | Credits | Notes |
|---|---|---|
| Character creation (AI Generated) | 5–10 | Per character |
| Character creation (Digital Twin) | 15–30 | Processing-intensive, one-time |
| Voice clone setup | 10–20 | One-time per voice |
| Character preview (15s test) | 2–3 | Quick validation |

### 3.3 Extended Production Features

| Operation | Credits | Notes |
|---|---|---|
| Product Showcase video (per style) | 8–40 | 360° cheapest, Virtual Try-On most expensive |
| Image-to-Video | 5–15 | Per image, depends on duration |
| Link-to-Video (URL → video ad) | 20–45 | Scraper + script + visual + voice |
| AI Translation (video dubbing) | 15–40 | Per language, depends on duration |
| AI Music (custom BGM) | 5–15 | Per track (30s-3min) |
| Speech-to-Song | 8–20 | Transform voice-over to singing |
| AI Sound Effects | 3–8 | Contextual SFX generation |
| Style extraction (to Style Pack) | 10–20 | Per style analysis + save |
| AI Video Agent (1-click pipeline) | 30–80 | Full pipeline orchestration |
| A/B variant generation | 5–15 | Per variant |
| Performance Coach analysis | 0 | Included in plan |

### 3.4 Copilot

| Copilot Action | Credits | Availability |
|---|---|---|
| Analytics query (read-only) | 0 | All tiers |
| Help / guidance | 0 | All tiers |
| Content generation (script, caption) | 1–5 | Starter+ |
| Workflow creation | 2–10 | Pro+ |
| Multi-step action execution | 3–15 | Pro+ |
| Voice input | 0 | All tiers |

> User chọn model cụ thể → credit cost có thể khác. System hiển thị estimated credits trước generate.

---

## 4. Add-on Modules

| Add-on | What It Unlocks |
|---|---|
| **Commerce Intelligence** | Advanced fit graph, competitor deep dive |
| **Continuity Pro** | Unlimited packs, advanced drift detection |
| **Advanced Profit / Reconciliation** | Multi-source reconciliation, advanced cost attribution |
| **Workflow / Agent Pro** | Unlimited workflows, priority agent execution |
| **Extra AI Credit Packs** | Pay-as-you-go top-ups |

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
- Data retained 30 days, permanently deleted 90 days after subscription end

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
Day 14: Grace ends → downgrade to Free
Day 44: Data deletion warning
Day 60: Data permanently deleted
```

Grace period (Day 7–14): user can view/export data + update payment, but NOT create/generate/publish.

### 5.7 Credit Purchase Options

| Pack | Credits | Price (USD) | Per Credit |
|---|---|---|---|
| Small | 100 | $5 | $0.050 |
| Medium | 500 | $20 | $0.040 |
| Large | 2,000 | $60 | $0.030 |
| Mega | 10,000 | $200 | $0.020 |

- Purchased credits không expire (valid suốt subscription active)
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
- Soft warning: Pro (90%), Business (80%)
- Operator mode availability follows tier — **không pricing riêng per mode**
