# Screen: Mobile — Referral Center

> **Screen ID**: M062
> **Module**: M23 — Settings / Growth
> **Route**: `/m/settings/referral`
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 08 §Growth/Referral, A1 Schema (referrals, referral_tiers, credit_transactions), B5 RBAC §2.9

---

## 1. Purpose & Context

Mobile referral dashboard — share personalized referral link, track conversion funnel (clicks → signups → paid conversions), earn credits, and progress through referral tiers. Optimized for social sharing on mobile.

### User Story
> As a user, I want to share my referral link via Zalo/Facebook and track how many friends signed up so I can earn credits and unlock higher rewards.

### Business Goal
- Organic growth through user referrals (target: 20% of new signups from referral)
- Credit incentive drives engagement and retention
- Tier system rewards power referrers progressively
- Mobile-first sharing for Vietnam market (Zalo, Facebook, direct message)

### When to Use
- Sharing Creativanta with peers
- Checking referral stats and earnings
- Tracking tier progression toward higher rewards
- Claiming pending credits

### Entry Points
- Settings → "🎁 Giới thiệu bạn bè"
- In-app prompt: "Giới thiệu bạn bè, nhận 75 credits!" banner
- Dashboard card: "Referral: 12/15 to Gold" → this screen
- Push notification: "🎉 Bạn bè vừa nâng cấp! +75 credits"

### Exit Points
- Share link → system share sheet → other app
- Copy link → toast confirmation
- Check credit balance → navigate to billing
- Back → Settings

---

## 2. Preconditions / Postconditions

### Preconditions
- User is authenticated
- User has a referral code generated (auto-generated on account creation)

### Postconditions
- Link shared via selected channel
- Referral conversions tracked automatically
- Credits awarded when referred user completes qualifying action (signup → paid)
- Tier progression updated

---

## 3. Layout Structure

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Giới thiệu bạn bè                                                │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│ ┌─ Your Referral Link ───────────────────────────────────────────┐  │
│ │ 🔗 creativanta.vn/r/QUANNG2026                                 │  │
│ │                                                                 │  │
│ │ [📋 Copy]  [📱 Zalo]  [📘 Facebook]  [📤 Chia sẻ khác]       │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Reward Banner ─────────────────────────────────────────────────┐  │
│ │ 🎁 Mỗi bạn bè đăng ký + nâng cấp: BẠN nhận 75cr, HỌ nhận   │  │
│ │    50cr miễn phí!                                               │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Conversion Funnel ────────────────────────────────────────────┐  │
│ │ 👆 Clicks     │ 📝 Signups    │ 💳 Paid        │               │  │
│ │    45          │    12 (27%)   │    3 (25%)      │               │  │
│ │    ████████████│ ████████░░░░░│ ██░░░░░░░░░░░░░│               │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Credits Summary ──────────────────────────────────────────────┐  │
│ │ 💰 Tổng kiếm được: 225 credits                                │  │
│ │ ✅ Đã nhận: 150 credits                                        │  │
│ │ ⏳ Chờ xử lý: 75 credits (1 bạn chưa nâng cấp)               │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Tier Progress ────────────────────────────────────────────────┐  │
│ │ 🥈 Silver                                                      │  │
│ │ [████████████████████████░░░░░░] 12/15 to Gold (80%)           │  │
│ │                                                                 │  │
│ │ Hiện tại: 75cr mỗi referral                                   │  │
│ │ Gold (15 ref): 100cr + 1 tháng miễn phí 🎉                     │  │
│ │ Platinum (30 ref): 150cr + 3 tháng miễn phí 🏆                │  │
│ │                                                                 │  │
│ │ 🎯 Chỉ còn 3 referral nữa để lên Gold!                       │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Referral History ─────────────────────────────────────────────┐  │
│ │ ── Đã nâng cấp ──                                              │  │
│ │ 👤 Nguyễn A · Pro plan · +75cr ✅ · 5 ngày trước               │  │
│ │ 👤 Lê C · Pro plan · +75cr ✅ · 15 ngày trước                  │  │
│ │ 👤 Phạm D · Business · +75cr ✅ · 1 tháng trước               │  │
│ │                                                                 │  │
│ │ ── Chờ nâng cấp ──                                              │  │
│ │ 👤 Trần B · Free plan · ⏳ · 12 ngày trước                    │  │
│ │   "Đã đăng ký, chưa nâng cấp. [Nhắc nhở]"                    │  │
│ │                                                                 │  │
│ │ ── Click chưa đăng ký ──                                        │  │
│ │ 32 clicks chưa chuyển đổi                                      │  │
│ │                                                                 │  │
│ │ [→ Xem tất cả]                                                 │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [📋] [➕] [💬] [👤]                                            │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
ReferralScreen
├── AppBar
│   ├── BackButton
│   └── Title ("Giới thiệu bạn bè")
├── ScrollableContent
│   ├── ReferralLinkCard
│   │   ├── LinkDisplay (monospace, selectable)
│   │   └── ShareButtonRow
│   │       ├── CopyButton ("📋 Copy")
│   │       ├── ZaloShareButton ("📱 Zalo")
│   │       ├── FacebookShareButton ("📘 Facebook")
│   │       └── SystemShareButton ("📤 Chia sẻ khác")
│   ├── RewardBanner
│   │   ├── RewardDescription
│   │   └── ReferrerReward + RefereeReward
│   ├── ConversionFunnelCard
│   │   ├── ClicksMetric (count + full bar)
│   │   ├── SignupsMetric (count + percentage + bar)
│   │   └── PaidMetric (count + percentage + bar)
│   ├── CreditsSummaryCard
│   │   ├── TotalEarned
│   │   ├── Received (with ✅)
│   │   └── Pending (with ⏳ + explanation)
│   ├── TierProgressCard
│   │   ├── CurrentTierBadge (🥉/🥈/🥇/🏆)
│   │   ├── ProgressBar (to next tier)
│   │   ├── CurrentReward
│   │   ├── NextTierReward (highlighted)
│   │   ├── FutureTiersList
│   │   └── MotivationMessage ("🎯 Chỉ còn {n} nữa!")
│   └── ReferralHistorySection
│       ├── PaidGroup ("Đã nâng cấp")
│       │   └── ReferralRow[] (avatar + name + plan + reward + date)
│       ├── PendingGroup ("Chờ nâng cấp")
│       │   └── ReferralRow[] (with "Nhắc nhở" button)
│       ├── ClicksSummary ("32 clicks chưa chuyển đổi")
│       └── ViewAllLink
├── BottomNavBar (shared)
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Referral link | `users.referral_code` | `ReferralService/GetMyReferralCode` | "creativanta.vn/r/{CODE}" | Session |
| Clicks | `referral_events WHERE type=click` count | `ReferralService/GetReferralStats` | Integer | 15m TTL |
| Signups | `referrals WHERE status=signed_up` count | same | "12 (27%)" | 15m TTL |
| Paid | `referrals WHERE status=converted` count | same | "3 (25%)" | 15m TTL |
| Credits earned | `credit_transactions WHERE source=referral` sum | same | "225 credits" | 15m TTL |
| Current tier | `users.referral_tier` | same | Badge icon + label | Session |
| Tier progress | Computed from referral count / tier threshold | same | Progress bar + "{n}/{max}" | Session |
| History | `referrals` list | `ReferralService/ListReferrals(page)` | Grouped card list | 15m TTL |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Copy referral link | Tap "📋 Copy" | — (clipboard) | — | Toast "✅ Đã copy link!", haptic | Any |
| 2 | Share via Zalo | Tap "📱 Zalo" | Zalo SDK share | — | Zalo share dialog opens | Any |
| 3 | Share via Facebook | Tap "📘 Facebook" | Facebook SDK share | — | FB share dialog opens | Any |
| 4 | Share via system | Tap "📤 Chia sẻ khác" | System share sheet | — | System share sheet opens | Any |
| 5 | Remind friend | Tap "Nhắc nhở" on pending referral | `ReferralService/SendReminder(referral_id)` | Reminder notification sent | Toast "Đã gửi nhắc nhở cho {name}" | Any |
| 6 | View all referrals | Tap "→ Xem tất cả" | — | — | Navigate to full referral history | Any |
| 7 | Pull to refresh | Pull down gesture | `ReferralService/GetReferralStats` | — | All sections refresh | Any |
| 8 | Check credit balance | Tap credits section | — | — | Navigate to billing/credits | Any |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching stats | Shimmer link card + skeleton sections |
| LOADED | Data available | Full dashboard |
| EMPTY | No referrals yet | Link card + reward banner + "Chia sẻ link để nhận credits!" + illustration |
| NEAR_TIER | 1-3 referrals to next tier | Highlighted motivation message + tier card glows |
| TIER_UP | Just reached new tier | 🎉 Celebration animation: "Chúc mừng! Bạn đã lên {tier_name}!" |
| CREDITS_PENDING | Has unclaimed/pending credits | ⏳ badge on credits section |
| ERROR | API failure | Toast with retry |

---

## 8. Validation Rules

| Field | Rule | Error Message |
|---|---|---|
| Reminder | Max 1 per 7 days per referral | "Đã gửi nhắc nhở gần đây. Thử lại sau {n} ngày." |
| Share | Link must be valid | — (auto-generated, always valid) |

---

## 9. Permission Matrix

This is a personal screen — all authenticated users can access their own referral data. No role-based restrictions.

| Action | Any authenticated user |
|---|---|
| View own referral stats | ✅ |
| Share referral link | ✅ |
| Remind pending referral | ✅ |

---

## 10. Navigation Map

```
Referral (/m/settings/referral)
├── → Zalo (share intent)
├── → Facebook (share intent)
├── → System share sheet
├── → /m/settings/billing           (via credits section)
├── → /m/settings/referral/history  (via "Xem tất cả")
└── ← /m/settings                  (via back)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Stats load failed | API error | Toast "Không tải được thống kê" | Pull-to-refresh |
| Share failed | Share SDK error | Toast "Không thể chia sẻ. Thử copy link." | Copy link instead |
| Reminder failed | API error | Toast "Gửi nhắc nhở thất bại" | Retry |
| Reminder limit | Too frequent | Toast "Đã nhắc nhở gần đây. Thử lại sau." | Wait 7 days |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Referral link | `Semantics(label: "Link giới thiệu: creativanta.vn/r/...")`, long-pressable |
| Share buttons | Minimum 48x48 tap targets, clear labels |
| Progress bar | `Semantics(value: 12, max: 15, label: "Tiến trình lên Gold")` |
| Tier badges | Text label (not icon alone) |
| Funnel bars | Percentage announced |
| Celebration animation | `Semantics(liveRegion: true)` |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | App bar + shimmer sections |
| Stats load | 200-500ms | Sections populate (stagger) |
| Share action | Instant | System dialog opens |
| Tier-up celebration | 2s animation | Confetti + badge animation |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| Screen render | <1.5s |
| Stats load | <500ms |
| Share intent | <200ms |
| Funnel rendering | <300ms |

---

## 15. Real-time Updates

| Data | Channel | Frequency |
|---|---|---|
| New referral signup | Push notification | Real-time |
| Credit awarded | Push notification | Real-time |
| Tier advancement | Push notification + local notification | Real-time |

---

## 16. Localization Notes

- Vietnamese primary
- Credits: "credits" / "cr" (universal)
- Referral code: alphanumeric (locale-independent)
- Numbers: dot separator (1.234)
- Tier names: keep English (Bronze/Silver/Gold/Platinum — universally understood)

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `referral.viewed` | Screen load | `current_tier`, `referral_count`, `credits_total` |
| `referral.link_copied` | Copy | — |
| `referral.shared` | Share via platform | `platform` (zalo/facebook/other) |
| `referral.reminder_sent` | Send reminder | `referral_id`, `days_since_signup` |
| `referral.tier_achieved` | New tier unlocked | `new_tier`, `referral_count` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | Share buttons, CTA |
| `--color-success` | Converted referrals, earned credits |
| `--color-warning` | Pending credits |
| `--color-tier-bronze` | Bronze tier badge |
| `--color-tier-silver` | Silver tier badge |
| `--color-tier-gold` | Gold tier badge + motivation glow |
| `--color-tier-platinum` | Platinum tier badge |
| `--gradient-celebration` | Tier-up celebration background |

---

## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W126] Web Referral Program | Web equivalent (more detailed stats) |
| [M061] Billing | Credit balance display |
| [M057] Settings | Parent screen |
| [S011] Upsell Banner | Referral mention in upsell context |

---

## 20. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 3.0 | Full 20-point upgrade from 63-line Tier C. Added conversion funnel visualization, credits summary with pending detail, tier progression with 4 tiers, reward descriptions, reminder system, share via Zalo/Facebook SDK, referral history grouped by status, celebration animation for tier-up, 7 states. Fixed Screen ID (M061b→M058), module (M26→M23). | System |
