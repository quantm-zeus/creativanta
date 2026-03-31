# Screen: Web — Settings: Referral Center

> **Screen ID**: W129
> **Module**: M26 — Settings (Growth)
> **Route**: `/settings/referral`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 10, A1 Schema (referrals, referral_rewards), B5 RBAC §2.9

---

## 1. Purpose & Context

Referral program dashboard — personal referral link with multi-channel sharing, conversion tracking with funnel metrics, credit rewards, and tier progression.

### User Goals
- Share referral link easily (copy, social, messaging)
- Track how many clicks → signups → paid conversions
- Earn credit rewards and see tier progression
- View referral history with individual status

### Entry Points
- Sidebar: Settings → "🎁 Giới thiệu"
- In-app prompt: "Giới thiệu bạn bè, nhận credits"

### Exit Points
- Self-contained settings page

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Settings   🎁 Giới thiệu bạn bè                                 │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Your Referral Link ─────────────────────────────────────────┐    │
│ │ creativanta.vn/r/QUANNG2026                                   │    │
│ │ [📋 Copy] [Zalo] [📘 Facebook] [📧 Email] [📱 SMS]          │    │
│ │ QR Code: [🖼 QR image] — "Scan để đăng ký"                   │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Conversion Funnel ──────────────────────────────────────────┐    │
│ │ 👆 Clicks: 45 → 📝 Signups: 12 (27%) → 💳 Paid: 3 (25%)   │    │
│ │ 🪙 Credits earned: 150 · Pending: 50 (2 upgrading...)        │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Reward Tiers ───────────────────────────────────────────────┐    │
│ │ 🥉 Bronze (1-5 refs) → 50 cr/referral                       │    │
│ │ 🥈 Silver (6-15 refs) → 75 cr/referral + badge   ◄ Current  │    │
│ │    You: 12 referrals · 3 more to Gold                         │    │
│ │ 🥇 Gold (16-30 refs) → 100 cr/referral + 1 month free       │    │
│ │ 💎 Diamond (31+) → 150 cr/referral + lifetime 20% discount  │    │
│ │ [███████████████████████████████░░░░░░░░] 12/15 to Gold      │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Referral History ───────────────────────────────────────────┐    │
│ │ 👤 Nguyễn A · Pro plan · +75 cr ✅ · 5d ago                  │    │
│ │ 👤 Trần B · Pro plan · +75 cr ✅ · 8d ago                    │    │
│ │ 👤 Lê C · Free → ⏳ Pending upgrade · 12d ago                │    │
│ │ 👤 Phạm D · Free → ⏳ Pending (signed up 15d ago)            │    │
│ └────────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Stats shimmer |
| LOADED | Data received | Full referral dashboard |
| NO_REFERRALS | No referrals yet | "Chưa giới thiệu ai. Chia sẻ link để nhận credits! [📋 Copy link]" |
| NEAR_TIER_UP | 1-2 referrals from next tier | Highlight: "🎯 Chỉ còn {n} referral nữa để đạt {tier}!" |
| ERROR | API failed | Error with retry |

---

## 8. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached referral data | Retry online |
| Link copy fail | Clipboard API blocked | Toast: "Không copy được. [Select → Copy thủ công]" | Manual copy |
| QR render fail | Canvas error | Fallback: text link + "QR không hiển thị được" | Manual share |
| Share API fail | Navigator.share unsupported | Fallback: copy link only | Copy |
| History load fail | API error | "Không tải được lịch sử. [Thử lại]" | Retry |

---

## 9. Accessibility

| Element | Requirement |
|---|---|
| Referral link | `aria-label="Referral link: creativanta.vn/r/QUANNG2026"`, selectable |
| Share buttons | `aria-label="Share via {platform}"` each |
| QR code | `role="img"`, `aria-label="QR code for referral link"` |
| Funnel stats | `role="status"`, `aria-label="45 clicks, 12 signups (27%), 3 paid (25%)"` |
| Tier progress | `role="progressbar"`, `aria-valuenow="12"`, `aria-valuemax="15"`, `aria-label="12 of 15 to Gold tier"` |

---

## 10. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Link + funnel skeletons |
| Referral link | 100-200ms | Link + share buttons populate |
| Funnel stats | 200-400ms | Numbers animate in |
| Tier progress | 300-500ms | Progress bar animates |
| History | 400-700ms | Rows stagger |
| QR code | 500-800ms | QR renders |

---

## 11. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `referral.viewed` | Page load | `total_referrals`, `current_tier`, `credits_earned` |
| `referral.link_copied` | "📋 Copy" | — |
| `referral.shared_social` | Share button click | `platform` (Zalo/Facebook/Email/SMS) |
| `referral.qr_viewed` | QR code displayed | — |
| `referral.tier_viewed` | Tier section scroll into view | `current_tier`, `next_tier_remaining` |
| `referral.history_scrolled` | Scroll past 5 history items | `visible_count` |
| `referral.referral_converted` | Referral upgrades to paid | `referral_id`, `plan`, `credits_earned` |
| `referral.near_tier_up_seen` | Near-tier-up highlight displayed | `remaining` |

---

## 12. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/settings/referral/+page.svelte`
- **Server load**: `+page.server.ts` → `ReferralService/GetDashboard(user_id)` → returns `{ link, funnel, tier, history }`
- **Link**: Generated server-side, unique per user, stored in `referrals.code`
- **Share**: `navigator.share()` with fallback to platform-specific URLs (Zalo: `zalo://...`, FB: `https://facebook.com/sharer/...`)
- **QR code**: Client-side `qrcode` library, rendered to canvas
- **Tier progress**: Computed from `referral_count` vs tier thresholds (static config)
- **History**: Cursor-paginated, 10 per load, with lazy "Load more"
- **Rewards**: Background job checks referral conversions daily, credits auto-added

---

## 13. Localization Notes

- Link: "Liên kết giới thiệu của bạn"
- Share: "📋 Sao chép", "Chia sẻ qua [Zalo/Facebook/Email/SMS]"
- Funnel: "👆 Clicks", "📝 Đăng ký", "💳 Trả phí"
- Tiers: "🥉 Đồng", "🥈 Bạc", "🥇 Vàng", "💎 Kim cương"
- Rewards: "50 cr/giới thiệu", "+1 tháng miễn phí"
- Tone: Motivational, gamified

---

## 14. Design Tokens

| Token | Usage |
|---|---|
| `--color-tier-bronze` | 🥉 Bronze tier |
| `--color-tier-silver` | 🥈 Silver tier |
| `--color-tier-gold` | 🥇 Gold tier |
| `--color-tier-diamond` | 💎 Diamond tier |
| `--color-accent` | Share CTA |
| `--color-success` | Converted referral, credits earned |
| `--color-warning` | Pending status |
| `--color-surface-elevated` | Section cards |
| `--font-metric` | Funnel numbers (tabular-nums) |

---

## 15. Related Screens

| Screen | Relationship |
|---|---|
| [W093] Billing | Subscription info |
| [M061] Mobile Referral | Mobile equivalent |

---

## 16. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (link copy, QR render), funnel/tier a11y, 8 analytics, SvelteKit impl (share API, QR gen), localization, 9 design tokens (tier-specific). | System |
| 2026-03-28 | 1.0 | Initial specification | System |
