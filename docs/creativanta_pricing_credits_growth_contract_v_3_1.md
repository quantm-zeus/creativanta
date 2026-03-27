# Creativanta — Pricing / AI Credit / Referral / Growth Engine Contract v3.1

## 0. Traceability Header

- **Upstream sections used**: PRD §30 (Packaging/Pricing), Product Freeze §9 (Billing/Metering), §33 (Runtime Contract), Pack 06 §9 (Billing/Metering).
- **Cross-ref**: S26 (Internal Admin) §6 — Billing & Revenue Console (payment management, dunning, refund, AI cost control) vận hành từ admin site.
- **Canonical objects touched**: Workspace, Billing Event, Metering Record, User Account, Subscription Plan, AI Credit Balance, Referral Record, Reward Ledger.
- **New objects introduced**: Subscription Plan, AI Credit Balance, AI Credit Transaction, Feature Gate, Usage Quota, Referral Code, Referral Record, Reward Ledger Entry, Loyalty Tier, Promotional Credit.
- **Read / write ownership respected**: billing/metering/subscription chỉ đọc canonical objects; không tạo shadow truth.

---

## 1. Mục tiêu

Pack này khóa:
- Subscription tiers & feature gating
- AI credit system & budget control
- Referral / growth engine
- Pricing strategy & anti-abuse
- Revenue protection & margin safety

---

## 2. Subscription Tier Contract

### 2.1 Tier Structure

| Tier | Target | Positioning |
|---|---|---|
| **Free** | Explorer / evaluator | Try before buy, limited scope |
| **Starter** | Solo creator / small seller | Essential tools, affordable |
| **Pro** | Active creator / seller | Full feature set, higher limits |
| **Business** | Agency / MCN / brand | Multi-creator, collaboration, advanced analytics |
| **Enterprise** | Large organization | Custom, SLA, dedicated support |

### 2.2 Feature Gating Matrix

| Feature | Free | Starter | Pro | Business | Enterprise |
|---|---|---|---|---|---|
| **Connected accounts** | 2 | 5 | 15 | 50 | Unlimited |
| **Workspace members** | 1 | 2 | 5 | 20 | Custom |
| **Operator modes** | 1 | 2 | All | All | All |
| **AI credits/month** | 50 | 500 | 2,000 | 10,000 | Custom |
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
| **Referral rewards** | Yes | Yes | Yes | Yes | Yes |
| **Priority support** | No | Email | Chat | Dedicated | Dedicated + SLA |
| **Custom branding** | No | No | Yes | Yes | Yes |
| **Approval workflows** | No | Basic | Advanced | Advanced | Custom |
| **Team roles/RBAC** | No | Basic | Full | Full | Custom |
| **Character slots** | 1 | 2 | 5 | 15 | Unlimited |
| **Digital Twin characters** | No | No | 1 | 5 | Unlimited |
| **Voice clone** | No | No | 1 voice | 5 voices | Unlimited |

### 2.3 Feature Gate Object
```
- gate_id
- feature_key (e.g., "ai_video_generation", "live_session", "api_write")
- tier_requirements: Map<Tier, Boolean | Limit>
- enforcement_type: "hard_block" | "soft_limit" | "degraded"
- over_limit_behavior: "block" | "warn_then_block" | "charge_overage" | "queue"
- upsell_message_key (localized)
```

### 2.4 Feature Gating UX Rules
- Khi user chạm limit → hiển thị inline upsell card, KHÔNG redirect ra landing page
- Free users thấy được Pro features (preview mode) nhưng không thể use
- Over-limit warning hiển thị khi đạt 80% quota
- Hard block hiển thị: tính năng locked + reason + upgrade CTA + credit purchase CTA
- No dark patterns: upgrade flow phải clear, reversible, có cancel anytime

---

## 3. AI Credit System Contract

### 3.1 What is an AI Credit?
AI Credit là đơn vị tính dùng chung cho mọi AI operation. 1 credit ≠ 1 token. Credit là abstraction layer giúp user dễ hiểu.

### 3.2 Credit Conversion Table

| AI Operation | Credits Consumed | Notes |
|---|---|---|
| **Text generation** (script, idea, copy) | 1–5 | Depends on length |
| **AI image generation** (standard) | 3–8 | Flux 2 / SDXL |
| **AI image generation** (HD) | 8–15 | GPT Image HD / Flux 2 Max |
| **AI video generation** (short <60s, standard) | 15–25 | Veo Fast / Kling Std / Runway Turbo |
| **AI video generation** (short <60s, premium) | 30–50 | Veo Quality / Kling Pro |
| **AI video generation** (long 1-3min) | 50–150 | Kling 3.0 extended (up to 2min) |
| **AI video editing** (user upload) | 15–40 | Depends on duration and edits |
| **AI video style transfer** | 20–60 | Apply trending style to uploaded video |
| **AI lip-sync** (post-production) | 5–15 | SyncLabs / Wav2Lip per clip |
| **AI video dubbing** (1 language) | 10–30 | TTS + lip-sync + final mix per minute |
| **AI music generation** | 10–30 | Depends on duration (Suno / MusicFX) |
| **AI voice generation** (standard) | 3–8 | Google Cloud TTS / OpenAI TTS |
| **AI voice generation** (premium) | 5–15 | ElevenLabs (expressive, Vietnamese) |
| **AI translation** | 2–5 | Per piece |
| **AI content compliance scan** | 1–3 | Per content item |
| **AI trend analysis** (deep) | 3–10 | Per analysis |
| **AI script rewrite/optimize** | 2–5 | Per script |
| **AI thumbnail generation** | 3–8 | Per thumbnail (Flux 2 / GPT Image) |
| **AI caption/subtitle** | 2–5 | Per video (Whisper + Gemini) |
| **AI engagement reply suggestion** | 1 | Per thread |
| **AI simulation run** | 5–15 | Per scenario |
| **AI agent execution** | 10–50 | Depends on complexity |
| **Character creation (AI Generated)** | 5–10 | Per character |
| **Character creation (Digital Twin)** | 15–30 | Processing-intensive, one-time |
| **Voice clone setup** | 10–20 | One-time per voice (ElevenLabs) |
| **Character preview (15s test)** | 2–3 | Quick validation |
| **Product Showcase video** (per style) | 8–40 | 360° Spin cheapest, Virtual Try-On/Review Style most expensive |
| **Image-to-Video** | 5–15 | Per ảnh, depends on duration (3-15s) |
| **Link-to-Video** (URL → video ad) | 20–45 | Includes scraper + script + visual gen + voice |
| **AI Translation** (video dubbing) | 15–40 | Per language version, depends on video duration |
| **AI Music generation** (custom BGM) | 5–15 | Per track (30s-3min), Stable Audio / MusicGen |
| **Speech-to-Song** | 8–20 | Transform voice-over to singing |
| **AI Sound Effects** (per video) | 3–8 | Contextual SFX generation |
| **Style extraction** (to Style Pack) | 10–20 | Per style analysis + save |
| **AI Video Agent** (1-click pipeline) | 30–80 | Full pipeline orchestration, depends on complexity |
| **A/B variant generation** | 5–15 | Per variant (hook, CTA, thumbnail, music) |
| **Performance Coach analysis** | 0 | Included in plan (uses existing analytics) |

> **Model choice**: User chọn model cụ thể (Veo/Kling/Runway) → credit cost có thể khác nhau. System hiển thị estimated credits trước khi generate.
> **Pipeline strategy**: Native audio (1 call) tiết kiệm hơn Post-production lip-sync (3 calls). System tự tối ưu nếu user chọn "Tự động".

### 3.3 AI Credit Balance Object
```
- credit_balance_id
- workspace_id
- plan_credits_monthly: number
- plan_credits_used_this_cycle: number
- bonus_credits: number (từ referrals, promotions)
- purchased_credits: number (mua thêm)
- total_available: computed
- cycle_reset_date
- last_updated
```

### 3.4 AI Credit Transaction Object
```
- transaction_id
- workspace_id
- credit_amount: number (positive = add, negative = consume)
- transaction_type: "plan_allocation" | "consumption" | "purchase" | "referral_bonus" | "promotional" | "refund" | "admin_adjustment" | "reservation" | "reservation_release" | "reservation_confirm"
- reservation_status: "pending" | "confirmed" | "released" (nullable — chỉ dùng cho reservation transactions)
- source_action: ref to AI operation that consumed credits
- model_used: AI provider/model identifier
- input_tokens: number (internal tracking)
- output_tokens: number (internal tracking)
- actual_cost_usd: number (internal, platform cost)
- created_at
- description
```

### 3.4A Credit Reservation (Escrow) Flow

> **Context**: Tránh trường hợp user bị trừ credits nhưng AI operation fail (provider timeout, network error). Reservation flow tạo 1 transaction thay vì 2 (deduct → refund).

**Flow:**
```
1. User confirm AI action → System tạo reservation transaction (status: pending)
   - Credit balance giảm đi estimated_cost (reserved)
   - UI: "⏳ Đang xử lý... [N] credits đã được giữ."
   
2a. SUCCESS → Reservation confirmed (status: confirmed)
   - credit_amount adjusted to actual cost (có thể < estimated)
   - Nếu actual < estimated → auto-release phần dư
   - Chỉ 1 transaction record cuối cùng

2b. FAILURE → Reservation released (status: released)
   - Credits trả lại balance ngay lập tức
   - UI: "❌ Không thể hoàn thành. [N] credits đã được hoàn lại."
   - Log lý do fail (provider error, timeout, content policy)

2c. TIMEOUT → Auto-release sau 15 phút nếu không có response
   - Treat as failure, release credits
   - Alert user + log vào Diagnostics
```

**Rules:**
- Reservation TTL: 15 phút (max time for any AI operation). Expired = auto-release.
- Mỗi workspace chỉ có tối đa 5 concurrent reservations (prevent credit lock-up)
- Reservation pending credits vẫn tính vào "used" cho quota check
- Reservation history auditable (linked to source_action)

### 3.5 Budget Control Rules

#### 3.5.1 Tier Limits
- Mỗi tier có monthly credit allocation
- Credits reset mỗi billing cycle (không rollover cho Free/Starter)
- Pro/Business cho phép rollover tối đa 20% unused credits sang tháng sau
- Enterprise custom rollover policy

#### 3.5.2 Overage Protection
- **Free**: Hard block khi hết credits. Không cho phép overage.
- **Starter**: Hard block. Có thể mua credit packs bổ sung.
- **Pro**: Soft warning at 90% → hard block at 100%. Có thể mua credit packs hoặc enable auto-buy.
- **Business**: Soft warning at 80% → email alert at 100% → allow 10% overage buffer → hard block at 110%.
- **Enterprise**: Custom budget alerts, no hard block, invoiced monthly.

#### 3.5.3 Anti-Abuse Rules
- Rate limit: max 100 AI requests / hour / workspace (adjustable per tier)
- Per-action rate limit: max 10 video generations / hour
- Anomaly detection: nếu workspace tiêu > 3x daily average → alert + temporary throttle
- No credit reselling: credits tied to workspace, không transferable
- No automated credit farming: detect scripted/bot usage → suspend
- Repeated zero-value generations: nếu user cancel/discard > 50% AI outputs liên tục → throttle

#### 3.5.4 Cost Transparency
- User dashboard hiện rõ: credits used / remaining / next reset date
- Per-operation credit cost hiển thị TRƯỚC khi user confirm action
- Monthly usage breakdown by operation type
- Cost trend chart (tuần/tháng)

### 3.6 Credit Purchase Options

| Pack | Credits | Price (USD) | Per Credit |
|---|---|---|---|
| Small | 100 | $5 | $0.050 |
| Medium | 500 | $20 | $0.040 |
| Large | 2,000 | $60 | $0.030 |
| Mega | 10,000 | $200 | $0.020 |

- Purchased credits không expire (valid suốt thời gian subscription active)
- Enterprise volume pricing negotiable
- Credit purchase available cho mọi paid tier

### 3.7 Internal Cost Management

#### 3.7.1 AI Cost Tracking (Internal)
- Mỗi AI operation track actual_cost_usd (chi phí gọi provider)
- Monthly P&L dashboard (internal): credit revenue vs actual AI costs
- Margin alert: nếu margin < 30% trên bất kỳ operation type → review pricing

#### 3.7.2 Model Routing Optimization
- Route requests tới cost-effective model trước, fallback tới premium model
- Caching: semantic cache cho similar prompts → reduce API calls
- Batch processing: group small requests khi có thể
- Provider diversification: không phụ thuộc 1 AI provider

---

## 4. AI Video Editing Contract (User Upload)

### 4.1 Mục tiêu
User upload video tự quay → AI tự động chỉnh sửa → output video chất lượng, hợp trending, tự nhiên.
Hệ thống cung cấp 4 core production modes: Quick Edit, Clip Factory, Multi-Merge, AI Remix Studio + 11 extended features (Pack 04 §9.6-9.16): Product Showcase Studio, Image-to-Video, Thumbnail Studio, Link-to-Video, Translation Studio, Sound Studio, Style Learning, Video Agent, Performance Coach, A/B Testing Engine, Creator Gamification.

### 4.2 AI Editing Capabilities (Quick Edit — Base)

| Capability | Description | Credit Cost |
|---|---|---|
| **Auto-cut** | AI tự cắt video: remove pauses, filler words, bad takes | 5–10 |
| **Trending style transfer** | Apply trending visual style (color grading, transitions, text overlays) | 15–30 |
| **Auto-captions** | Generate + style captions theo trending format | 3–5 |
| **Hook generation** | AI thêm hook mở đầu (text overlay, sound effect, pattern interrupt) | 5–10 |
| **Background music** | Auto-select + sync royalty-free music matching mood | 3–8 |
| **Pace optimization** | Adjust speed/cuts to match platform best practices | 5–10 |
| **Format adaptation** | Chuyển 16:9 → 9:16, crop thông minh theo subject | 3–5 |
| **B-roll injection** | AI thêm stock/AI b-roll tại chỗ phù hợp | 10–20 |
| **Audio enhancement** | Noise removal, volume normalization, voice clarity | 3–5 |
| **Color correction** | Auto color grade theo aesthetic phù hợp | 3–5 |
| **Product highlight** | Auto-detect product trong video, thêm price/CTA overlay | 5–10 |
| **Thumbnail extraction** | AI chọn + enhance best frame làm thumbnail | 3–5 |

### 4.2B AI Editing Capabilities (Quick Edit — Enhanced)

| Capability | Description | Credit Cost |
|---|---|---|
| **Text-based editing** | Edit transcript = edit video (xóa text = xóa segment) | 5–10 |
| **Animated captions** | Trending styles: karaoke, bounce, highlight | 3–5 |
| **Active speaker detection** | Auto-reframe theo người đang nói (multi-speaker video) | 5–10 |
| **Beat-sync music** | Cắt video beats khớp nhạc tự động | 5–10 |
| **AI B-roll generation** | Gen AI b-roll contextual (Flux 2/Veo) thay stock | 10–20 |
| **Platform presets** | Tối ưu pace riêng: TikTok (fast cuts), YouTube (slower), Reels (medium) | 3–5 |
| **Smart Hook Library** | 50+ mẫu hook proven viral, AI auto-match nội dung | 5–10 |
| **Copyright-safe audio** | Auto-scan copyright + gợi ý royalty-free alternatives | 3–5 |

### 4.3 Clip Factory Credits (1→N)

| Operation | Credits | Notes |
|---|---|---|
| **Analyze + detect clips** | 10–15 | Scene detection + ASR + LLM analysis |
| **Virality Score per clip** | Included | Tính trong analyze cost |
| **Process per clip** (caption + format + music) | 5–10 per clip | Varies by enhancements selected |
| **Batch export** (all selected clips) | 3–5 | Multi-format + multi-platform |
| **Typical total** (10 clips) | **60–120** | Analyze + 10 clips + export |

### 4.4 Multi-Merge Credits (N→1)

| Operation | Credits | Notes |
|---|---|---|
| **Assembly + transitions** | 5–10 | Based on number of inputs |
| **Voice-over** (if AI voice) | 5–15 | Based on duration, uses TTS provider |
| **Background music** | 3–8 | Auto-select or library |
| **Render + export** | 3–5 | Final output processing |
| **Typical total** | **15–35** | |

### 4.5 AI Remix Studio Credits

| Operation | Credits | Notes |
|---|---|---|
| **Phase 1 — Analyze** (Creative DNA extraction) | 5–10 | ASR + Video Intelligence + LLM analysis |
| **Phase 2 — Remix** (gen new video) | 25–50 | Script rewrite + visual gen + voice gen + assembly |
| **Regenerate** (nếu chưa hài lòng) | 15–30 | Partial re-gen, không full pipeline |
| **Platform export** (multi-platform) | 3–5 | Auto-resize + optimize per platform |
| **Typical total** | **30–55** | Rẻ hơn + nhanh hơn gen from scratch (40-80 credits) |

### 4.6 Tier Limits cho Production Modes

| Mode | Free | Starter | Pro | Business |
|---|---|---|---|---|
| **Quick Edit** per month | 2 | 20 | 100 | 300 |
| **Clip Factory** per month | 0 | 5 | 30 | 100 |
| **Multi-Merge** per month | 1 | 10 | 50 | 200 |
| **AI Remix** per month | 0 | 3 | 20 | 50 |
| **Product Showcase** per month | 0 | 10 | 50 | 200 |
| **Image-to-Video** per month | 3 | 20 | 100 | 300 |
| **Link-to-Video** per month | 0 | 5 | 30 | 100 |
| **Translation** per month | 0 | 3 | 15 | 50 |
| **AI Video Agent** per month | 0 | 5 | 30 | 100 |
| **A/B Test variants** per month | 0 | 5 | 20 | 80 |
| **Max upload size** | 100MB | 500MB | 2GB | 5GB |
| **Max duration (upload)** | 3min | 10min | 30min | 60min |
| **Remix per day** | N/A | 3 | 10 | 20 |

> **Daily vs Monthly Limit Interaction (Audit v5 — M9 clarified)**:
> - Daily limits = **burst protection** (prevent mass-clone abuse spikes, e.g., 20 remixes/day).
> - Monthly limits = **total allocation** per billing cycle.
> - **Daily limit × 30 >> Monthly limit is intentional**. This is an anti-abuse pattern, not a bug.
> - Example: Pro tier = max 10 remixes/day AND max 20 remixes/month → user CAN do 10/day but monthly quota exhausted after 2 days. This is correct — it prevents someone from consuming their entire monthly allocation in a single abuse burst while allowing normal daily usage within reason.
> - Credit system enforces: `current_daily_count < daily_limit AND current_monthly_count < monthly_limit`. Both must pass.
> - Tier upgrade immediately updates both daily and monthly limits.

### 4.7 AI Editing Workflow
1. User upload video (max file size per tier: Free 100MB, Starter 500MB, Pro 2GB, Business 5GB)
2. User chọn mode: Quick Edit / Clip Factory / Multi-Merge / AI Remix / Product Showcase / Image-to-Video / Link-to-Video / Translation / Video Agent
3. AI analyze: detect scenes, faces, products, speech, mood, pacing
4. AI suggest editing plan: danh sách edits + preview + estimated credits
5. User review + approve/customize editing plan
6. AI execute editing
7. User review output → accept / request adjustments (1 free revision per edit)
8. Export final video

### 4.8 Content Compliance Integration
- AI editing workflow phải include pre-publish compliance scan
- Scan video cho: music copyright, content policy violations, platform-specific issues
- Compliance results hiển thị TRƯỚC khi user export/publish
- Blocked content: video có high-risk violations không cho publish, phải fix trước
- AI Remix: thêm originality check (script similarity < 30% vs reference)

### 4.9 Upload & Processing Rules
- Supported formats: MP4, MOV, AVI, MKV, WebM
- Max duration per tier: Free 3min, Starter 10min, Pro 30min, Business 60min
- Processing queue: Free → low priority, Paid → normal/high priority
- Processing time SLA: ≤ 5 phút cho video < 3 phút, ≤ 15 phút cho video < 10 phút
- Failed processing → refund credits automatically

---

## 5. Affiliate Link Health Monitor Contract

### 5.1 Mục tiêu
Tự động phát hiện affiliate links chết, hết hạn, sản phẩm hết hàng → tránh mất doanh thu.

### 5.2 Link Health Check Types

| Check Type | Frequency | Action on Failure |
|---|---|---|
| **HTTP status check** | Every 6 hours | Flag dead link + notify |
| **Product availability** | Every 12 hours | Flag out-of-stock + suggest alternative |
| **Price change detection** | Every 12 hours | Notify if price changed significantly |
| **Commission rate change** | Daily | Alert if commission decreased |
| **Link expiry** | Daily | Alert 7 days before expiry |
| **Redirect chain check** | Weekly | Flag excessive redirects (>3) |
| **Platform account status** | Daily | Check if affiliate account still active |

### 5.3 Link Health Object
```
- link_health_id
- affiliate_link_ref
- last_checked_at
- http_status
- product_status: "available" | "out_of_stock" | "discontinued" | "price_changed" | "unknown"
- commission_status: "active" | "changed" | "suspended" | "unknown"
- link_status: "healthy" | "warning" | "broken" | "expired"
- expiry_date (nếu có)
- suggested_action
- alert_sent: boolean
```

### 5.4 FE/UX cho Link Health
- Affiliate Link list có status badge (healthy/warning/broken)
- Dashboard widget: "X links need attention"
- Click-to-fix: suggest replacement links, update expired links
- Bulk health check action
- Notification cho high-priority broken links (high revenue impact)

### 5.5 Revenue Impact Assessment
- Mỗi broken link phải estimate revenue impact dựa trên historical performance
- Sort broken links by revenue impact (fix high-impact first)
- Monthly "lost revenue" report from broken/expired links

---

## 6. Referral & Growth Engine Contract

### 6.1 Referral Program Structure

#### 6.1.1 Double-Sided Rewards
| Action | Referrer Gets | Referred Gets |
|---|---|---|
| Sign up (free) | 20 bonus credits | 20 bonus credits |
| Upgrade to Starter | 100 bonus credits | 50 bonus credits |
| Upgrade to Pro | 300 bonus credits | 100 bonus credits |
| Upgrade to Business | 1,000 bonus credits | 300 bonus credits |
| Referred completes 1st month | 50 bonus credits | — |

#### 6.1.2 Referral Tiers
| Tier | Successful Referrals | Bonus |
|---|---|---|
| **Bronze** | 1–5 | Base rewards |
| **Silver** | 6–20 | 1.5x rewards |
| **Gold** | 21–50 | 2x rewards + 10% recurring commission |
| **Platinum** | 51+ | 2.5x rewards + 15% recurring commission |

### 6.2 Referral Code Object
```
- referral_code_id
- referral_code: string (short, shareable)
- owner_workspace_id
- owner_user_id
- created_at
- total_referrals: number
- successful_conversions: number
- total_credits_earned: number
- total_commission_earned: number (for Gold/Platinum)
- current_tier: bronze | silver | gold | platinum
- status: active | suspended | expired
```

### 6.3 Referral Record Object
```
- referral_record_id
- referral_code_ref
- referred_workspace_id
- referred_user_id
- signup_date
- conversion_event: "signup" | "starter" | "pro" | "business" | "enterprise"
- referrer_reward_credits
- referred_reward_credits
- commission_percent (for recurring)
- commission_amount_this_cycle
- status: "pending" | "qualified" | "rewarded" | "expired" | "fraud_flagged"
```

### 6.4 Referral Anti-Fraud Rules
- Self-referral detection (same IP, device fingerprint, payment method)
- Churn-and-return detection (signup → cancel → re-signup via referral)
- Minimum qualified period: referred user phải maintain paid subscription ≥ 30 days
- Suspicious pattern detection: > 10 referrals from same IP range
- Manual review for referrals > $100 in value
- Fraud penalty: forfeiture of all pending rewards + suspension

### 6.5 Referral UX
- Referral code trong Settings > Referral Program
- Share buttons: WhatsApp, Telegram, Facebook, Twitter, copy link
- Referral dashboard: total referrals, earnings, tier progress
- Leaderboard (optional, gamification)
- In-app prompts: post-successful-action ("Share and earn credits!")

---

## 7. Growth & Marketing Engine

### 7.1 Viral Loop Design

```
User creates content → content has Creativanta watermark (Free tier) → 
viewer asks "how?" → user shares referral → new user → repeat
```

### 7.2 Growth Triggers

| Trigger Point | Action | Incentive |
|---|---|---|
| First publish success | Prompt share referral | 20 bonus credits |
| First profit proof | Prompt share case study | 50 bonus credits |
| Reach 1,000 followers (any platform) | Achievement badge + share | 30 bonus credits |
| Team invitation | Invite team members | 10 credits per member joined |
| Recipe submission | Submit recipe to marketplace | 50 credits if approved |
| Feature request upvote | Community engagement | 5 credits |

### 7.3 Seasonal / Campaign Promotions
- Promotional credits: time-limited bonus credits
- Flash sales: credit packs at discount
- Holiday campaigns: limited-time tier upgrades
- Partnership promotions: co-branded offers
- All promotions tracked via Promotional Credit type in ledger

### 7.4 Freemium Conversion Optimization
- Track conversion funnel: signup → activation → engagement → monetization
- Identify conversion barriers (feature gates most hit)
- A/B test upsell messaging
- Progressive feature revelation: unlock features as user engagement grows
- Well-timed upgrade prompts (after experiencing value, NOT on first login)

### 7.5 Community & Education
- Creator Academy: official learning resources (free for all tiers)
- Template gallery: community-contributed templates
- Case studies: success stories (with user consent)
- Community forum / Discord
- Weekly tips / newsletter (opt-in)

### 7.6 Achievement & Gamification Engine (PRD §37.3)

#### 7.6.1 Achievement Definition Object
```
- achievement_id
- key: string (e.g. "debut_creator", "rising_star")
- display_name: localized
- description: localized
- trigger_type: "event" | "threshold" | "streak" | "compound"
- trigger_condition: JSON (flexible condition definition)
- reward_credits: number
- badge_asset_url: string
- category: "content" | "revenue" | "engagement" | "growth" | "learning"
- is_active: boolean
- sort_order: number
```

#### 7.6.2 User Achievement Record Object
```
- user_achievement_id
- user_id
- workspace_id
- achievement_ref
- unlocked_at: datetime
- reward_credited: boolean
- reward_transaction_ref (→ AI Credit Transaction)
- shared_on_social: boolean
```

#### 7.6.3 Weekly Challenge Object
```
- challenge_id
- title: localized
- description: localized
- start_date
- end_date
- challenge_type: "publish_count" | "revenue_target" | "engagement_target" | "streak"
- target_value: number
- reward_credits: number
- is_active: boolean
```

#### 7.6.4 Challenge Progress Object
```
- progress_id
- challenge_ref
- workspace_id
- current_value: number
- target_value: number
- completed: boolean
- completed_at: datetime (nullable)
- reward_credited: boolean
```

#### 7.6.5 Rules
- Achievement rewards credited as "promotional" type in AI Credit Transaction
- Achievements are per-workspace (team achievements shared)
- Weekly challenges rotate every Monday 00:00 UTC+7
- Max 3 active challenges per week
- Challenge completion notification + celebration animation
- Duplicate achievement attempts → no double credit
- Achievement audit trail: immutable, linked to triggering event

### 7.7 Copilot Credit Integration (PRD §34.4)

| Copilot Action | Credit Cost | Tier Availability |
|---|---|---|
| Analytics query (read-only) | 0 (included) | All tiers |
| Help / guidance | 0 (included) | All tiers |
| Content generation (script, caption) | 1-5 | Starter+ |
| Workflow creation | 2-10 | Pro+ |
| Multi-step action execution | 3-15 | Pro+ |
| Voice input | 0 (included) | All tiers |

- Copilot sessions tracked but NOT counted as AI credits for analytics/help queries
- Generation actions follow standard AI Credit Transaction flow
- Credit cost shown in Copilot UI BEFORE action confirmation
- Daily Copilot query limit: Free 20, Starter 100, Pro unlimited, Business unlimited

---

## 8. Permission & RBAC Contract

> **Canonical Source**: Product Freeze §46A.4 / Pack 02 §S07. This section aligns to the frozen 7-role hierarchy.

### 8.1 Role Hierarchy (Aligned to Freeze §46A.4)

| Role | Scope | Key Permissions |
|---|---|---|
| **Owner** | Workspace | Full access, billing, danger zone, workspace deletion |
| **Admin** | Workspace | All features except billing management + workspace deletion |
| **Manager** | Workspace | Team oversight, finance/revenue access, inbox moderation, commerce management, approve content |
| **Editor** | Workspace | Create/edit/publish content, workflows, view analytics, commerce (operational) |
| **Contributor** | Workspace | Create/edit content drafts only — cannot publish, approve, or access finance |
| **Viewer** | Workspace | Read-only access to all non-sensitive data |
| **External Collaborator** | Limited | Brand/agency external collaborator, scoped per invitation, limited to assigned content |

> **Reconciliation Note**: Previous version used Finance as a separate role. Per Freeze §46A.4, Finance permissions are merged into **Manager** (operational oversight role covering finance visibility, inbox moderation, commerce management, and content approval). **Contributor** is added as a step below Editor for team members who can draft but not publish. See Pack 02 §S07 for full permission matrix.

### 8.2 Permission Groups

| Permission Group | Granularity |
|---|---|
| Content management | Create, edit, delete, publish, archive |
| Commerce management | Products, offers, orders, refunds |
| Financial access | Revenue, costs, profit, reconciliation |
| Team management | Invite, remove, change roles |
| Integration management | Connect/disconnect accounts |
| Workflow management | Create, edit, run, approve workflows |
| AI usage | Generate, edit, consume credits |
| Billing management | View invoices, change plan, buy credits |
| Report access | View, export, share reports |
| Admin actions | Overrides, data repair, diagnostics |

### 8.3 Feature Gate × Role Matrix
- Feature gates (tier-based) checked BEFORE permission gates (role-based)
- If tier blocks feature → role doesn't matter
- If tier allows feature → role determines access level

### 8.4 Invitation & Onboarding
- Owner invites via email → invited user gets role assignment
- External collaborators get time-limited access tokens
- Guest access (view-only) via shareable links (Pro+ tiers)
- SSO support for Business/Enterprise tiers

---

## 9. Billing & Subscription Management

### 9.1 Billing Cycle
- Monthly billing (default)
- Annual billing (discount: 2 months free)
- Billing date = signup date

### 9.2 Plan Changes
- Upgrade: immediate, prorated charge for remaining cycle
- Downgrade: takes effect at next billing cycle
- Downgrade validation: check if current usage exceeds new tier limits → warn user → allow data/feature adjustment period

### 9.3 Trial Period
- 14-day free trial of Pro tier (no credit card required)
- Trial → auto-convert to Free tier if not upgraded
- No trial abuse: 1 trial per email/payment method

### 9.4 Cancellation & Refund
- Cancel anytime, access maintained until end of billing cycle
- No refund for partial months (annual plans: prorated refund for unused months if cancel within 30 days)
- Data retained 30 days after subscription end
- Data permanently deleted 90 days after subscription end (with advance notice)

### 9.5 Payment Methods
- Credit/debit card (Stripe)
- Bank transfer (for Enterprise/Vietnam market)
- Local payment methods: Momo, ZaloPay, VNPay (Vietnam)
- PayPal (international)

### 9.6 Dunning & Failed Payment Recovery

#### 9.6.1 Dunning Flow (Automated)
```
Day 0: Payment fails → retry immediately with same method
Day 1: 2nd retry → in-app banner "Payment failed, please update"
Day 3: 3rd retry → email "Action required: payment failed"
Day 5: 4th retry → email + in-app + push "Your account will be restricted"
Day 7: Enter GRACE PERIOD → read-only mode, warning banner displayed
Day 10: 5th retry → final email "Last chance to update payment"
Day 14: GRACE PERIOD ENDS → downgrade to Free tier, data retained 30 days
Day 44: Data deletion warning sent
Day 60: Data permanently deleted (except legally required records)
```

#### 9.6.2 Grace Period Rules
- Duration: 7 days (Day 7 → Day 14 of dunning cycle)
- During grace: workspace enters read-only mode
- Read-only = user can view data, export data, update payment method
- Read-only ≠ content creation, AI generation, publish, commerce operations
- Grace period visible: countdown banner on all pages
- User updates payment during grace → immediate full access restoration

#### 9.6.3 Pre-Dunning (Preventive)
- Card expiry alert: 30 days before card expiry → email + in-app notification
- Account Updater integration (if available via Stripe) → auto-update expired cards
- Backup payment method: user can set fallback payment method
- Pre-charge validation: validate card before billing cycle start

### 9.7 Subscription Lifecycle State Machine

```
States:
- trialing → active (upgrade) | free (trial expired, no upgrade)
- active → past_due (payment failed) | cancelled (user-initiated) | paused (user request, Business+)
- past_due → active (payment recovered) | grace_period (day 7)
- grace_period → active (payment recovered) | downgraded_free (grace expired)
- downgraded_free → active (re-upgrade)
- cancelled → active (re-subscribe before cycle end)
- paused → active (resume, max 90 days pause)
```

### 9.8 Plan Migration Rules
- Upgrade mid-cycle: prorated charge, immediate access
- Downgrade mid-cycle: takes effect next cycle, 7-day feature adjustment window
- Feature adjustment window: user has 7 days to reduce usage within new tier limits
- Auto-archival: if usage exceeds new tier limits after adjustment window → oldest excess items archived (not deleted)
- Re-upgrade: restore archived items automatically

---

## 9A. OAuth Token Security Contract

### 9A.1 Token Storage
- Connected account OAuth tokens: encrypted at rest (AES-256)
- Storage: dedicated secrets store (AWS Secrets Manager / Vault equivalent)
- Tokens NEVER stored in application database in plaintext
- Tokens NEVER logged, included in error reports, or exposed in API responses

### 9A.2 Token Lifecycle
- Access tokens: short-lived, auto-refreshed via refresh token
- Refresh tokens: encrypted, rotated on each use
- Token revocation: on user disconnect, password change, or security event
- Stale token detection: if refresh fails 3x → mark Connected Account as "disconnected" → notify user

### 9A.3 Scope Management
- Request minimum necessary scopes per platform
- Document all scopes requested per platform in UX (Pack 07 §7.1)
- Scope changes: re-consent required if new scopes needed
- Regular scope audit: quarterly review of scope usage

### 9A.4 PKCE (Proof Key for Code Exchange)
- Mandatory for all OAuth flows from public clients (SPA, mobile)
- Authorization code interception prevention

---

## 9B. Disaster Recovery & Backup Contract

### 9B.1 Recovery Objectives

| Data Category | RPO (max data loss) | RTO (max downtime) |
|---|---|---|
| Financial data (orders, settlements, billing) | 0 (synchronous replication) | ≤ 1 hour |
| User content (scripts, assets, publish history) | ≤ 1 hour | ≤ 4 hours |
| Analytics / projections | ≤ 4 hours | ≤ 8 hours |
| Audit / consent records | 0 (synchronous replication) | ≤ 1 hour |
| AI generation history | ≤ 4 hours | ≤ 8 hours |

### 9B.2 Backup Strategy
- Database: continuous backups with point-in-time recovery
- File/blob storage: cross-region replication (primary: Singapore, secondary: Vietnam/Japan)
- Backup verification: automated restore testing weekly
- Immutable backups: ransomware-resistant, write-once storage
- Backup retention: daily snapshots 30 days, weekly snapshots 90 days, monthly snapshots 1 year

### 9B.3 Failover Architecture
- Primary region: Singapore (ap-southeast-1)
- Failover region: configured per deployment
- Failover type: Active-Passive (warm standby)
- DNS failover: health check + automatic rerouting
- Database failover: read replicas in secondary region, promotable in emergency
- CDN: multi-region by default

### 9B.4 Incident Response
- Severity levels: P0 (data loss risk) → P1 (core service down) → P2 (degraded) → P3 (minor)
- On-call rotation: 24/7 for P0/P1
- Communication: status page update within 15 minutes of P0/P1
- Post-mortem: mandatory for P0/P1, published within 5 business days

## 10. FE/UX Requirements

### 10.1 Pricing Page
- Clear tier comparison table
- AI credit allocation highlight
- "Most popular" badge on recommended tier
- Annual vs monthly toggle with savings display
- FAQ section
- Custom Enterprise CTA

### 10.2 Usage Dashboard
- Credit balance widget (prominent)
- Usage breakdown by operation type (this cycle)
- Usage trend chart (last 30 days)
- Quota progress bars for key limits
- Upgrade CTA when approaching limits
- Credit purchase CTA

### 10.3 Referral Center
- Referral code + share buttons
- Referral dashboard (referrals, earnings, tier)
- Leaderboard (optional)
- Rewards history

### 10.4 Billing Settings
- Current plan info
- Payment method management
- Invoice history + download
- Plan change interface
- Cancel subscription flow

### 10.5 Permission Management
- Team members list with roles
- Role assignment interface
- Invitation management
- Active sessions / connected devices
- Access audit log

---

## 11. Acceptance Scenario Inventory

Pricing/Credit/Growth pack bắt buộc cover tối thiểu các scenario sau:
- Free user hits credit limit → sees clear upsell card with credit count, not generic "upgrade" → can buy credits or upgrade tier
- Pro user approaches 80% quota → warning notification → at 100% can buy more or wait for reset
- AI video generation shows credit cost preview BEFORE user confirms → **reserves credits (status: pending)** → confirms reservation on successful completion → **releases credits immediately** if fails/times out
- Credit reservation: concurrent reservations per workspace capped at 5 → 6th request shows: "Đang có nhiều tác vụ AI chạy. Vui lòng chờ hoàn thành." → auto-releases after 15 min TTL
- User uploads video → AI generates editing plan with credit estimate → user approves → credits reserved → AI edits → user reviews → accepts (reservation confirmed) or requests 1 free revision
- Pre-publish compliance scan flags TikTok hashtag violation → blocks publish → user fixes → re-scan passes → publish proceeds
- Affiliate link health monitor detects broken link → notification with revenue impact → user clicks → sees suggested fix
- Referral code shared → new user signs up → both get credits → referred user upgrades → referrer gets tier upgrade credits
- Referral anti-fraud: same IP signup detected → referral flagged → manual review → fraud confirmed → rewards forfeited
- Business tier user invites team member as Editor → Editor can create/publish but cannot access financial data
- Annual plan user cancels → prorated refund for unused months → access continues until current period ends
- Downgrade from Pro to Starter → system warns about features/data that exceed new limits → 7-day adjustment period
- Credit purchase → credits available immediately → no expiry → show in balance
- Internal AI cost tracking shows margin drop below 30% → alert to operations team → pricing review triggered
- Platform (TikTok) changes API → capability degrades → user sees degraded badge on affected features → notification explains impact and workaround → no refund (covered by ToS)
- Payment fails → dunning flow starts: 5 retries over 14 days → grace period (read-only) → auto-downgrade to Free if unresolved
- Card expiry in 30 days → pre-dunning email + in-app notification → user updates card → no disruption
- Grace period: user can view data, export data, update payment, but NOT create/generate/publish
- Grace period recovery: user updates payment during grace → immediate full access restoration
- Trial expires without upgrade → auto-convert to Free tier → no data loss → upsell prompt
- Trial abuse: same email tries 2nd trial → blocked → suggestion to upgrade
- OAuth token refresh fails 3x → Connected Account → "disconnected" state → user notification → reconnect flow
- OAuth tokens encrypted at rest, never logged, never in API responses
- DR: database restore tested weekly → verified within RPO/RTO targets
- P0 incident → status page update within 15 minutes → post-mortem within 5 days
- Subscription pause (Business+) → max 90 days → auto-resume → notification 7 days before resume
- Copilot: user asks "bán gì chạy nhất?" → Copilot queries analytics data → shows answer with chart → 0 credits consumed
- Copilot: user asks "tạo script cho sản phẩm A" → Copilot shows credit cost → user confirms → script generated → credits deducted
- Copilot: Free user hits 20 daily query limit → clear message + upgrade CTA
- Achievement: user publishes first content → "Debut Creator" badge unlocked → 20 credits added as "promotional" → celebration animation
- Achievement: user completes weekly challenge → credits awarded → challenge refreshes next Monday
- Achievement: duplicate trigger (e.g. first publish again) → no double credit → no notification
- Profit OS: user views dashboard → sees GMV - platform fees - shipping - COGS - ad spend = net profit → per product breakdown
- Profit OS: platform fee increase detected → alert: "TikTok commission tăng từ 6% lên 8% cho Beauty → ảnh hưởng margin sản phẩm X, Y"
- Content Repurpose: user uploads 10min video → system generates clips + text posts + thumbnails as DRAFTS → user reviews → batch approve → auto-scheduled
- Content Repurpose: Free user tries 30min video → blocked (max 5min for Free) → upgrade CTA
- Morning Brief: user receives push at 7AM → opens → sees money summary + trending topics + pending actions → deep links to each section
- Platform Health: shop response rate drops to 88% → alert: "Cần trả lời 3 tin nhắn để tăng lên >90%"


