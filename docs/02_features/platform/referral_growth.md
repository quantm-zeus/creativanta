---
layer: features
module: referral
canonical: true
domain: platform
status: READY
last_updated: 2026-04-02
upstream: PRD v3.1 §37.2, Pricing/Credits Pack §6–7
---

# Referral & Growth Engine

> **Upstream**: PRD §37.2, Pricing/Credits/Growth Contract §6–7
> **DB tables**: `referral_records` (§18.6), `ai_credit_transactions` (transaction_type = 'referral_bonus' | 'promotional')
> **Screens**: 3 (referral center, rewards dashboard, referral leaderboard)

---

## 1. Purpose

Referral & Growth Engine drives organic acquisition through a **double-sided refer-and-earn program**, tiered referral rewards, and growth triggers embedded throughout the product. Every successful referral earns credits for both referrer and referred — with escalating multipliers at higher referral tiers.

### Scope

**Covers**: Referral code generation/sharing, double-sided reward distribution, referral tiers (Bronze→Platinum) with multipliers and recurring commissions, anti-fraud detection, growth triggers (viral loop, seasonal promotions), freemium conversion optimization, community & education programs.

**Does NOT cover (Non-goals for this module)**:
- Gamification achievements/streaks/challenges (owned by `gamification.md`)
- AI credit system and billing (owned by `pricing_and_credits.md`)
- Marketing campaigns or paid acquisition (external)
- Social features / community forums (not in v1)

### Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Referrer | Any workspace member | Share referral code, track earnings, view tier progress |
| Referred User | New user | Sign up via referral link, receive bonus credits |
| System | System | Validate referrals, detect fraud, distribute rewards, tier calculation |
| Admin (Internal) | FinanceAdmin | Review flagged referrals, adjust rewards, suspend fraud cases |

## 2. Business Rules

| Rule | Description |
|------|-------------|
| RULE-REF-001 | Each workspace has exactly one referral code (auto-generated, short, shareable) |
| RULE-REF-002 | Rewards are **double-sided**: both referrer and referred user receive credits |
| RULE-REF-003 | Referral tiers escalate: Bronze (1-5 referrals, 1x), Silver (6-20, 1.5x), Gold (21-50, 2x + 10% recurring), Platinum (51+, 2.5x + 15% recurring) |
| RULE-REF-004 | Minimum qualification: referred user must maintain paid subscription ≥ 30 days before referral is "qualified" |
| RULE-REF-005 | Referral credits are credited as `transaction_type = 'referral_bonus'` in AI Credit Transaction |
| RULE-REF-006 | Recurring commissions (Gold/Platinum) are calculated per billing cycle of the referred user |
| RULE-REF-007 | Self-referral, churn-and-return, and IP-range abuse detected → fraud_flagged → manual review |
| RULE-REF-008 | Fraud penalty: forfeiture of all pending rewards + suspension of referral program access |

## 3. Key Flows

### 3.1 Referral Code Sharing
1. User navigates to Settings → Referral Program
2. System displays unique referral code + shareable link
3. Share buttons: WhatsApp, Telegram, Facebook, Twitter, copy link
4. Referral dashboard shows: total referrals, earnings, tier progress

### 3.2 Referral Conversion Flow
1. New user signs up using referral link/code
2. System creates `referral_record` (status: `pending`)
3. Both users receive signup bonus credits immediately (20 each)
4. If referred user upgrades to paid plan:
   - System validates (no fraud signals)
   - Upgrade reward distributed (e.g., Starter: referrer 100, referred 50)
5. After 30-day qualification period → status moves to `qualified` → `rewarded`
6. If referred user completes 1st month: referrer gets additional 50 credits

### 3.3 Tier Advancement
1. System recalculates referrer tier after each qualified referral
2. Tier upgrade triggers notification + new multiplier applied to future rewards
3. Gold/Platinum: recurring commission starts from next billing cycle of referred users

### 3.4 Growth Triggers (In-Product Prompts)

| Trigger Point | Action | Incentive |
|---|---|---|
| First publish success | Prompt share referral | 20 bonus credits |
| First profit proof | Prompt share case study | 50 bonus credits |
| 1,000 followers reached | Achievement badge + share | 30 bonus credits |
| Team member invitation | Invite team members | 10 credits per join |
| Recipe submission | Submit to marketplace | 50 credits if approved |
| Feature request upvote | Community engagement | 5 credits |

## 4. Reward Structure

### 4.1 Double-Sided Rewards

| Action | Referrer Gets | Referred Gets |
|---|---|---|
| Sign up (free) | 20 bonus credits | 20 bonus credits |
| Upgrade to Starter | 100 bonus credits | 50 bonus credits |
| Upgrade to Pro | 300 bonus credits | 100 bonus credits |
| Upgrade to Business | 1,000 bonus credits | 300 bonus credits |
| Referred completes 1st month | 50 bonus credits | — |

### 4.2 Referral Tiers

| Tier | Successful Referrals | Multiplier | Extra Benefits |
|---|---|---|---|
| **Bronze** | 1–5 | 1x (base rewards) | — |
| **Silver** | 6–20 | 1.5x rewards | — |
| **Gold** | 21–50 | 2x rewards | + 10% recurring commission on referred users' subscriptions |
| **Platinum** | 51+ | 2.5x rewards | + 15% recurring commission on referred users' subscriptions |

## 5. State Machine — Referral Record

| From | To | Trigger | Condition |
|------|----|---------|-----------| 
| — | pending | Referred user signs up | Referral code/link used |
| pending | qualified | 30-day qualification met | Referred user maintained paid subscription ≥ 30 days |
| pending | expired | Referred user doesn't upgrade | Free user for 30+ days or cancels within 30 days |
| pending | fraud_flagged | Fraud signals detected | See anti-fraud rules |
| qualified | rewarded | Rewards distributed | Credits deposited to both parties |
| fraud_flagged | qualified | Manual review clears | Admin marks as legitimate |
| fraud_flagged | forfeited | Fraud confirmed | All pending rewards cancelled, referral program suspended |

## 5.1 Anti-Fraud Rules

| Signal | Detection Method | Action |
|---|---|---|
| Self-referral | Same IP, device fingerprint, payment method | Auto-flag |
| Churn-and-return | Signup → cancel → re-signup via referral | Auto-flag |
| IP range clustering | >10 referrals from same IP range | Auto-flag + throttle |
| Payment method reuse | Same card used across referrer and referred | Auto-flag |
| High-value manual review | Any referral >$100 in value | Manual review required |
| Scripted signups | Bot behavior patterns, CAPTCHA fails | Immediate block |

## 5.2 Edge Cases

### EC-REF-001: Referred user upgrades then downgrades within 30 days
- Condition: User upgrades to Pro (triggers reward), then downgrades to Free at day 15
- Expected behavior: Referral remains in `pending` state. 30-day qualification NOT met. Upgrade reward is NOT clawed back (already distributed), but the referral does NOT count toward tier advancement. Referrer notified: "Referral [user] is no longer on a paid plan."

### EC-REF-002: Platinum referrer's referred user churns
- Condition: Platinum referrer receives 15% recurring commission. Referred user cancels after 6 months.
- Expected behavior: Recurring commission stops from the next billing cycle. No clawback on previously paid commissions. Referrer's tier calculation still counts this as a successful referral (they earned 30-day qualification).

### EC-REF-003: Concurrent referral code use
- Condition: Two different referral codes used during signup (one in URL, one manually entered)
- Expected behavior: System uses the **referral code in the URL** (priority). If only manual entry, that code is used. If conflict, first one applied wins. Second referrer is NOT credited.

## 6. Seasonal & Campaign Promotions

- **Promotional credits**: time-limited bonus credits (tracked as `transaction_type = 'promotional'`)
- **Flash sales**: credit packs at discount for limited time
- **Holiday campaigns**: limited-time tier upgrades (e.g., "Try Pro free for 1 week")
- **Partnership promotions**: co-branded offers with external partners
- All promotions tracked via `ai_credit_transactions` table with `transaction_type = 'promotional'` and metadata containing `campaign_id` and `expires_at`

## 7. Freemium Conversion Optimization

- Track conversion funnel: signup → activation → engagement → monetization
- Identify conversion barriers (which feature gates are hit most)
- A/B test upsell messaging
- Progressive feature revelation: unlock features as user engagement grows
- Well-timed upgrade prompts (after experiencing value, NOT on first login)
- Free users see Pro features (preview mode) but cannot use — inline upsell card, NOT redirect

## 8. Community & Education

- **Creator Academy**: official learning resources (free for all tiers)
- **Template Gallery**: community-contributed templates and recipes
- **Case Studies**: success stories (with user consent)
- **Community Forum / Discord**: user community
- **Weekly Tips / Newsletter**: opt-in content

## 9. API Surface

> ✅ **RESOLVED: API-M-002b** (2026-04-02) — `ReferralService` now fully defined in `api_endpoint_map.md` §2.8.11 with 5 RPCs: GetMyReferralCode, GetReferralStats, ListReferrals, ClaimReward, ValidateCode. `PromotionalService` defined at §2.8.12.

| Service | Key RPCs |
|---------|----------|
| `ReferralService` | GetCode, GetDashboard, ListReferrals, GetTierProgress, ClaimReward |
| `PromotionalService` | ListActiveCampaigns, RedeemPromo, GetPromoStatus |

## 10. Acceptance Criteria

```gherkin
Feature: Referral Program
  Scenario: Successful referral with upgrade
    Given user A has a referral code
    When user B signs up via user A's referral link
    Then both users receive 20 bonus credits
    When user B upgrades to Pro plan
    Then user A receives 300 credits (or multiplied by tier)
    And user B receives 100 credits
    And referral record status is "pending" (awaiting 30-day qualification)

  Scenario: Anti-fraud — self-referral detection
    Given user A creates a new account using their own referral code
    When the system detects same IP and device fingerprint
    Then referral status is set to "fraud_flagged"
    And no credits are distributed until manual review

  Scenario: Tier advancement
    Given a referrer with 20 qualified referrals (Silver tier)
    When their 21st referral is qualified
    Then tier advances to Gold
    And future rewards apply 2x multiplier
    And recurring commission (10%) begins for all referred paid users

  Scenario: Growth trigger — first publish
    Given a user who just published their first content
    When the publish succeeds
    Then system shows prompt: "Share Creativanta and earn credits!"
    And prompt includes referral link + share buttons
```

## 11. Cross-references

- **DB**: `04_contracts/database_schema.md` §18.6 (referral_records) + §13.2 (ai_credit_transactions for referral_bonus)
- **API**: `04_contracts/api_endpoint_map.md` §2.8 (Admin/Billing M23 — referral RPCs within ~15 RPCs)
- **Events**: `04_contracts/domain_event_catalog.md` (referral.qualified, referral.rewarded, referral.fraud_detected)
- **Credits**: `01_business/pricing_and_credits.md` §2 (transaction_type = 'referral_bonus')
- **Admin**: `02_features/platform/internal_admin.md` (fraud case review)
- **Gamification**: `02_features/platform/gamification.md` (growth triggers overlap)
