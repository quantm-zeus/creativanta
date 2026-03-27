# Screen Specs 10 — Settings, Diagnostics & Connected Accounts (M23)

> **Upstream**: Product Freeze §33-34, A1 Schema (connected_accounts, capability_snapshots, diagnostics_records, workspaces), B4 Connector Specs
> **Screens**: 12 web + 5 mobile screens
> **Screen Numbers**: §92-§103 (per screen_index.md canonical numbering)

---

## 92. Connected Accounts

**Route**: `/settings/connections`
**Purpose**: Manage all platform connections — social (TikTok, IG, YouTube, FB) + commerce (Shopee, Lazada, TikTok Shop). Shows capability status per platform.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🔗 Kết nối                                    [+ Kết nối mới]   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Connected Account ─────────────────────────────────────────┐ │
│ │ 🎵 TikTok · @creativanta_studio                             │ │
│ │ Status: 🟢 Connected · Token valid · Last sync: 10m ago     │ │
│ │                                                              │ │
│ │ Capabilities:                                                │ │
│ │ ├ Publish video:      🟢 Native                             │ │
│ │ ├ Read comments:      🟢 Native                             │ │
│ │ ├ Reply comments:     🟢 Native                             │ │
│ │ ├ Read analytics:     🟢 Native                             │ │
│ │ ├ Read DMs:           🟡 Read-only                          │ │
│ │ ├ Send DMs:           🔴 Unsupported (API limitation)       │ │
│ │ ├ Live streaming:     🟢 Native                             │ │
│ │                                                              │ │
│ │ Rate Limits: 145/600 requests used today                    │ │
│ │ Data synced: 1,234 posts · 45K comments · 89 orders         │ │
│ │                                                              │ │
│ │ [🔄 Force sync] [⚙️ Settings] [🔌 Disconnect]              │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Connected Account ─────────────────────────────────────────┐ │
│ │ 🛍 Shopee · shop_creativanta                                │ │
│ │ Status: 🟡 Degraded · Sync delay (2h) · Last sync: 2h ago  │ │
│ │                                                              │ │
│ │ ⚠️ "Đồng bộ đơn hàng bị chậm. Đang thử lại tự động."      │ │
│ │ [🔧 Kiểm tra] [🔄 Force sync]                              │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Available to Connect ──────────────────────────────────────┐ │
│ │ 📸 Instagram           [Kết nối →]                          │ │
│ │ ▶️ YouTube              [Kết nối →]                          │ │
│ │ 📘 Facebook            [Kết nối →]                          │ │
│ │ 🛒 Lazada              [Kết nối →]                          │ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

### Connect Flow
1. Click "Kết nối" → OAuth popup opens for platform
2. User authorizes → popup closes → account appears as "Connecting..."
3. Initial sync starts → progress indicator shows sync status
4. Sync complete → capability snapshot created → full row displayed

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Connect new | Click "Kết nối" | OAuth flow → `ConnectorService/Connect` | New account row |
| Force sync | "🔄 Force sync" | `ConnectorService/ForceSync` | Sync starts, Toast "Syncing..." |
| Disconnect | "🔌 Disconnect" → confirm | `ConnectorService/Disconnect` | Account removed, warning about data loss |
| View settings | "⚙️ Settings" | — | → `/settings/connections/[id]` |
| Repair | "🔧 Kiểm tra" | — | → Repair wizard drawer |

---

## 93. Connected Account Detail

**Route**: `/settings/connections/[id]`
**Purpose**: Deep settings for a connected account — sync schedules, data retention, specific API toggles.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Connections   🎵 TikTok @creativanta_studio            [⋮]     │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Tabs: [Sync Settings] [Capabilities] [Token] [History]           │
│                                                                  │
│ ── Sync Settings Tab ──                                           │
│ ┌─ Sync Frequency ─────────────────────────────────────────┐ │
│ │ Posts:      [● 15 min] [○ 30 min] [○ 1h] [○ Manual]        │ │
│ │ Comments:   [● 15 min] [○ 30 min] [○ 1h]                    │ │
│ │ Orders:     [● 5 min] [○ 15 min] [○ 30 min]                 │ │
│ │ Analytics:  [○ 1h] [● 6h] [○ Daily]                          │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Data Retention ─────────────────────────────────────────┐ │
│ │ Keep historical data: [● 90 days] [○ 180 days] [○ Forever]  │ │
│ │ Delete after disconnect: [☑ Delete all synced data]           │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ── Token Tab ──                                                │
│ ┌─ API Token Status ─────────────────────────────────────────┐ │
│ │ Status: ✅ Valid · Expires: 15/04/2026                         │ │
│ │ Scopes: publish, read_comments, analytics, live              │ │
│ │ [🔄 Renew token] [📝 Re-authorize scopes]                     │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ── History Tab ──                                                │
│ ┌─ Sync History ──────────────────────────────────────────┐ │
│ │ 27/3 15:30 · Posts sync · ✅ 12 updated · 1.2s              │ │
│ │ 27/3 15:15 · Comments sync · ✅ 45 new · 2.8s              │ │
│ │ 27/3 15:00 · Orders sync · ✅ 3 new · 0.8s                 │ │
│ │ 27/3 14:00 · Analytics · ✅ Aggregated · 5.2s              │ │
│ └──────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

---

## 94. Diagnostics Center

**Route**: `/settings/diagnostics`
**Purpose**: System health overview — all active issues, warnings, and degraded services.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🔧 Diagnostics Center                  Overall: 🟡 Degraded     │
├──────────────────────────────────────────────────────────────────┤
│ Quick stats: 🔴 2 Critical · 🟡 3 Warnings · 🟢 12 Healthy   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Issue: Critical ──────────────────────────────────────────┐  │
│ │ 🔴 Shopee Order Sync Failed                                │  │
│ │ Affected: Order data · Since: 2h ago · Impact: Revenue     │  │
│ │ tracking incomplete                                         │  │
│ │ Root cause: API rate limit exceeded                         │  │
│ │ [🔧 Repair] [📋 Details] [📧 Notify team]                  │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Issue: Warning ───────────────────────────────────────────┐  │
│ │ 🟡 AI Credit Usage High                                    │  │
│ │ Remaining: 120/500 (24%) · Usage rate: 15/day avg          │  │
│ │ Estimated depletion: 8 days                                 │  │
│ │ [💳 Top up] [📊 Usage detail]                               │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Health Grid ──────────────────────────────────────────────┐  │
│ │ Service        │ Status   │ Last Check │ Latency            │  │
│ │ TikTok API     │ 🟢 OK   │ 1m ago     │ 120ms              │  │
│ │ Shopee API     │ 🔴 Error│ 2h ago     │ timeout            │  │
│ │ AI Provider    │ 🟢 OK   │ 30s ago    │ 450ms              │  │
│ │ Database       │ 🟢 OK   │ 10s ago    │ 3ms                │  │
│ │ Search (Meili) │ 🟢 OK   │ 15s ago    │ 8ms                │  │
│ │ Cache (Dragon) │ 🟢 OK   │ 10s ago    │ 1ms                │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### Repair Wizard (Drawer)
```
┌─ Drawer: Repair ──────────────────────────────────────────────┐
│ Step 1 of 4: Issue Summary                                     │
│ ───────────────────────────────────────────                    │
│ Shopee order sync đã dừng từ 2h trước do vượt rate limit.     │
│ Dữ liệu đơn hàng từ 14:00 chưa được đồng bộ.               │
│                                                                │
│ [Tiếp tục →]                                                   │
├────────────────────────────────────────────────────────────────┤
│ Step 2 of 4: Why It Happened                                   │
│ ───────────────────────────────────────────                    │
│ Shopee API giới hạn 200 requests/15 phút. Workspace bạn       │
│ đã dùng 198/200 do sync 3 shop phụ cùng lúc.                 │
│                                                                │
│ [Tiếp tục →]                                                   │
├────────────────────────────────────────────────────────────────┤
│ Step 3 of 4: Recommended Fix                                   │
│ ───────────────────────────────────────────                    │
│ ○ Chờ reset (10 phút nữa) — Recommended                      │
│ ○ Giảm sync frequency cho shop phụ                            │
│ ○ Retry ngay (có thể fail)                                    │
│                                                                │
│ [Áp dụng →]                                                    │
├────────────────────────────────────────────────────────────────┤
│ Step 4 of 4: Verify Repair                                     │
│ ───────────────────────────────────────────                    │
│ ⏳ Đang kiểm tra kết nối...                                   │
│ ✅ Kết nối OK · Sync resumed · 12 orders synced               │
│                                                                │
│ [✅ Hoàn thành]                                                │
└────────────────────────────────────────────────────────────────┘
```

---

## 95. Diagnostics Detail

**Route**: `/settings/diagnostics/[id]`
**Purpose**: Full diagnostics record detail — root cause, timeline, resolution steps.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Diagnostics   🔴 Shopee Order Sync Failed         [🔧 Repair] │
├──────────────────────────────────┬───────────────────────────────┤
│ Main (65%)                       │ Side Panel (35%)               │
│                                  │                                │
│ ┌─ Issue Summary ─────────────┐  │ ┌─ Impact Assessment ───────┐│
│ │ Severity: 🔴 Critical        │  │ │ Affected: Order data      ││
│ │ Since: 27/3 14:00 (2h ago) │  │ │ Revenue gap: ~1.2M VND   ││
│ │ Service: Shopee Connector  │  │ │ Users impacted: 1         ││
│ │ Auto-retry: 3/3 exhausted │  │ │ Data freshness: 2h stale  ││
│ └────────────────────────────┘  │ └─────────────────────────────┘│
│                                  │                                │
│ ┌─ Root Cause Analysis ─────┐  │ ┌─ Previous Occurrences ───┐│
│ │ 🤖 AI Analysis:              │  │ │ 25/3 - Same issue (auto) ││
│ │ Shopee API rate limit 200  │  │ │ 18/3 - Token expired      ││
│ │ requests/15min exceeded.  │  │ │ Total occurrences: 3      ││
│ │ 3 shops syncing at same   │  │ └─────────────────────────────┘│
│ │ time caused burst.        │  │                                │
│ └────────────────────────────┘  │ ┌─ Actions ────────────────┐│
│                                  │ │ [🔧 Start repair wizard]  ││
│ ┌─ Event Timeline ───────────┐  │ │ [🔔 Set alert rule]       ││
│ │ 14:00 Rate limit reached  │  │ │ [📝 Add note]             ││
│ │ 14:01 Auto-retry 1/3     │  │ │ [✅ Mark resolved]        ││
│ │ 14:05 Auto-retry 2/3     │  │ └─────────────────────────────┘│
│ │ 14:10 Auto-retry 3/3 FAIL│  │                                │
│ │ 14:11 Critical alert sent │  │                                │
│ └────────────────────────────┘  │                                │
└──────────────────────────────────┴───────────────────────────────┘
```

---

## 96. Subscription & Billing

**Route**: `/settings/billing`
**Purpose**: Current plan, usage, upgrade/downgrade, payment history.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 💳 Gói đăng ký & Thanh toán                                     │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Current Plan ──────────────────────────────────────────────┐ │
│ │ Gói hiện tại: [⭐ Pro]                                      │ │
│ │ 499,000đ/tháng · Gia hạn: 15/04/2026                       │ │
│ │ AI Credits: 500/month · Members: 5 · Connectors: Unlimited │ │
│ │ [📈 Nâng cấp Business] [📉 Hạ cấp] [❌ Hủy đăng ký]       │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Usage This Period ─────────────────────────────────────────┐ │
│ │ AI Credits: ████████░░░░ 320/500 (64%)                      │ │
│ │ Storage:    ██░░░░░░░░░ 2.1/10 GB (21%)                    │ │
│ │ Members:    ██████░░░░ 3/5 (60%)                            │ │
│ │ API Calls:  ████████████████████ 8,500/10,000 (85%) ⚠️     │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Plan Comparison ──────────────────────────────────────────┐  │
│ │ [Free]    [Starter]   [⭐ Pro]    [Business]               │  │
│ │ 0đ       199K/m      499K/m     999K/m                     │  │
│ │ Feature comparison table...                                 │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Payment History ──────────────────────────────────────────┐  │
│ │ 15/3/2026 · Pro · 499,000đ · ✅ Paid · [📥 Invoice]       │  │
│ │ 15/2/2026 · Pro · 499,000đ · ✅ Paid · [📥 Invoice]       │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

---

## 97. Analytics Overview

**Route**: `/analytics`
**Purpose**: Cross-platform analytics dashboard — content performance, audience growth, engagement trends.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 📊 Analytics                      [Platform ▾] [Period: 30d ▾]  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ KPI Row ───────────────────────────────────────────────────┐ │
│ │ 👁 Total reach  │ ❤ Engagement │ 👥 Followers  │ 📤 Posts   │ │
│ │ 1.2M ↑24%      │ 6.2% ↑0.8%  │ 52K ↑12%     │ 24         │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ Tabs: [Overview] [Content] [Audience] [Comparison]              │
│                                                                  │
│ ── Overview Tab ──                                               │
│ ┌─ Reach Chart (area, over time) ────────────────────────────┐ │
│ │ Broken down by platform colors                              │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Top Posts ─────────────────────────────────────────────────┐ │
│ │ Ranked by engagement, showing thumbnail + metrics           │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ── Content Tab ──                                                │
│ Per-post metrics table: title, platform, views, likes, comments │
│ Click → post analytics detail                                   │
│                                                                  │
│ ── Audience Tab ──                                               │
│ Demographics, geographic distribution, active hours             │
│                                                                  │
│ ── Comparison Tab ──                                             │
│ Period-over-period comparison, platform comparison              │
└──────────────────────────────────────────────────────────────────┘
```

---

## 98-99. Gamification & Performance Coach

### 98. Gamification Dashboard (`/gamification`)

**Purpose**: Engage creators with game mechanics — levels, streaks, achievements, quests.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🎮 Level & Achievements                                           │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Creator Level ──────────────────────────────────────────┐ │
│ │ ⭐ Level 12 — "Content Pro"                                   │ │
│ │ XP: 2,840 / 3,200 ██████████████░░░ 88%                      │ │
│ │ Next: Level 13 "Influencer" — 360 XP to go                  │ │
│ │ 🔥 Streak: 14 ngày liên tục · Best: 21 ngày                   │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Active Quests ──────────────────────────────────────────┐ │
│ │ 🎯 "Publish 3 videos this week" ─ 2/3 done ─ +50 XP       │ │
│ │ 🎯 "Reply to 10 comments" ─ 7/10 done ─ +30 XP              │ │
│ │ 🎯 "First live session" ─ ☐ Not started ─ +100 XP            │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Achievement Grid ─────────────────────────────────────────┐ │
│ │ [🌟 First Post] [🔥 7-Day Streak] [🎬 10 Videos]           │ │
│ │ [💰 First Sale]  [🤖 AI Master]    [🎤 First Live]           │ │
│ │ [⬜ Locked]     [⬜ Locked]       [⬜ Locked]                 │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                                  │
│ [Leaderboard →]   [Weekly Report Card →]                         │
└──────────────────────────────────────────────────────────────────┘
```

### 99. Performance Coach (`/performance`)

**Purpose**: AI-powered performance coaching with post-publish insights and strategy recommendations.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🏆 Performance Coach                                              │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Weekly Report Card ───────────────────────────────────────┐ │
│ │ Week 13 — Mar 24-30, 2026                                   │ │
│ │ Overall Grade: B+ (↑ from B last week)                       │ │
│ │ Consistency: ⭐⭐⭐⭐☆ · Quality: ⭐⭐⭐⭐⭐ · Growth: ⭐⭐⭐☆☆    │ │
│ │ Posts: 5 (↑ vs 3 last week) · Avg engagement: 6.2%          │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Post-Publish Insights ────────────────────────────────────┐ │
│ │ 🎬 "5 tips nấu ăn" — ⭐ Top performer this week              │ │
│ │ ✅ What worked: Hook trong 3s đầu, trending sound             │ │
│ │ 💡 Improve: Thêm CTA rõ ràng hơn ở cuối video               │ │
│ │ ┌───────────────────────────────────────────────────────┐     │ │
│ │ │ 🎬 "Review serum" — Below average engagement             │     │ │
│ │ │ ❌ What didn't work: Quá dài (2 min), no hook          │     │ │
│ │ │ 💡 Improve: Giảm xuống 45-60s, thêm hook 3s            │     │ │
│ │ └───────────────────────────────────────────────────────┘     │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ AI Strategy Recommendations ───────────────────────────────┐ │
│ │ 💡 "Tăng tần suất posting từ 3 lên 5/tuần — engagement     │ │
│ │    tăng 24% với nhịp này"                                   │ │
│ │ 💡 "Đăng vào 19:00-21:00 — reach cao hơn 35% so với 10:00" │ │
│ │ 💡 "Thử format 'list tips' — top 3 videos của bạn đều   │ │
│ │    dùng format này"                                           │ │
│ └──────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

---

## Mobile Screens

### M38. Mobile Connected Accounts

**Route**: `/settings/connections` (mobile)
**Purpose**: View and manage all platform connections with quick sync and status overview.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Tài khoản liên kết                          [+ Kết nối mới]   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Connected (3) ────────────────────────────────────────────┐   │
│ │ ┌─ Platform Card ───────────────────────────────────────┐  │   │
│ │ │ [TikTok icon] TikTok Shop              [🟢 Connected] │  │   │
│ │ │ @quancreator · Last sync: 5 min ago                    │  │   │
│ │ │ Posts: 45 · Orders: 123 · Revenue: 25.6M              │  │   │
│ │ │ ← Swipe: [🔄 Sync now] [⚙️ Settings] [🔌 Disconnect]│  │   │
│ │ └───────────────────────────────────────────────────────┘  │   │
│ │                                                            │   │
│ │ ┌─ Platform Card ───────────────────────────────────────┐  │   │
│ │ │ [Shopee icon] Shopee                   [🟢 Connected] │  │   │
│ │ │ Creativanta Shop · Last sync: 15 min ago               │  │   │
│ │ │ Products: 34 · Orders: 89 · Revenue: 12.1M            │  │   │
│ │ │ ← Swipe: [🔄 Sync now] [⚙️ Settings] [🔌 Disconnect]│  │   │
│ │ └───────────────────────────────────────────────────────┘  │   │
│ │                                                            │   │
│ │ ┌─ Platform Card ───────────────────────────────────────┐  │   │
│ │ │ [YouTube icon] YouTube                 [🟡 Token exp.] │  │   │
│ │ │ Quan's Channel · ⚠️ Token hết hạn trong 3 ngày        │  │   │
│ │ │ Videos: 12 · Subs: 1.2K                                │  │   │
│ │ │ [🔄 Gia hạn token]                                    │  │   │
│ │ └───────────────────────────────────────────────────────┘  │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                  │
│ ┌─ Available to Connect ─────────────────────────────────────┐   │
│ │ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐       │   │
│ │ │ Instagram│ │ Facebook │ │ Lazada   │ │ Zalo OA  │       │   │
│ │ │ [+ Kết  ]│ │ [+ Kết  ]│ │ [+ Kết  ]│ │ [+ Kết  ]│       │   │
│ │ └──────────┘ └──────────┘ └──────────┘ └──────────┘       │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                  │
│ Pull-to-refresh to sync all                                      │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M38 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Force sync | Swipe left → "Sync" | `ConnectorService/ForceSync` | Sync starts, spinner on card |
| View settings | Tap card or swipe "Settings" | — | → Connected Account Detail |
| Disconnect | Swipe → "Disconnect" → confirm | `ConnectorService/Disconnect` | Card moves to "Available" |
| Connect new | Tap "+" on available platform | — | → OAuth flow in browser |
| Renew token | "Gia hạn" on warning card | — | → Re-auth OAuth flow |
| Pull-to-refresh | Pull down | `ConnectorService/SyncAll` | All cards refresh |

#### M38 States
- **Loading**: Skeleton cards with shimmer
- **Empty**: "Chưa kết nối nền tảng nào" + "Bắt đầu kết nối" CTA
- **Sync in progress**: Spinner overlay on card + "Đang đồng bộ..."
- **Error**: Red badge on card + "Lỗi kết nối — tap để sửa"

---

### M39. Mobile Diagnostics

**Route**: `/settings/diagnostics` (mobile)
**Purpose**: View system health status, issues, and repair actions on mobile.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Chẩn đoán hệ thống                  Health: [🟢 96%]          │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Health Score Card ────────────────────────────────────────┐   │
│ │ ┌──────────────────────────────────────────────────────┐   │   │
│ │ │ [Circular progress: 96%]                              │   │   │
│ │ │ 🟢 Sức khỏe hệ thống: Tốt                            │   │   │
│ │ │ Last check: 10 min ago · [🔄 Kiểm tra lại]           │   │   │
│ │ └──────────────────────────────────────────────────────┘   │   │
│ │                                                            │   │
│ │ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐                      │   │
│ │ │Sync  │ │API   │ │Data  │ │Queue │                      │   │
│ │ │🟢 OK │ │🟢 OK │ │🟡 Warn│ │🟢 OK │                      │   │
│ │ └──────┘ └──────┘ └──────┘ └──────┘                      │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                  │
│ ┌─ Issues (2) ───────────────────────────────────────────────┐   │
│ │ ┌─ Issue Card ──────────────────────────────────────────┐  │   │
│ │ │ 🟡 Data staleness — TikTok analytics                  │  │   │
│ │ │ Analytics data chưa cập nhật 6 giờ                    │  │   │
│ │ │ Tác động: Số liệu có thể không chính xác             │  │   │
│ │ │ [🔧 Sửa tự động] [👁 Chi tiết]                       │  │   │
│ │ └───────────────────────────────────────────────────────┘  │   │
│ │                                                            │   │
│ │ ┌─ Issue Card ──────────────────────────────────────────┐  │   │
│ │ │ 🟢 Resolved — Shopee sync error                       │  │   │
│ │ │ Đã tự động sửa: Token refreshed                       │  │   │
│ │ │ Resolved 2h ago                                        │  │   │
│ │ └───────────────────────────────────────────────────────┘  │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                  │
│ ┌─ Recent Health History ────────────────────────────────────┐   │
│ │ [Mini line chart: health score over 7 days]                │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                  │
│ Pull-to-refresh for new health check                             │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M39 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Re-check | "Kiểm tra lại" | `DiagnosticsService/RunCheck` | Health score recalculated |
| Auto-repair | "Sửa tự động" | `DiagnosticsService/AutoRepair` | Repair wizard (bottom sheet) |
| View detail | "Chi tiết" / tap card | — | Bottom sheet with full details + timeline |
| Pull-to-refresh | Pull down | `DiagnosticsService/RunCheck` | Full re-check |

#### M39 States
- **Loading**: Health score skeleton + card shimmer
- **All healthy**: Green 100% with "Mọi thứ hoạt động tốt! 🎉"
- **Critical issue**: Red banner at top auto-expanded, push notification sent
- **Repairing**: Progress bar on issue card "Đang sửa..." with steps

---

## Additional Settings Screens

## 100. Referral Center

**Route**: `/settings/referral`
**Purpose**: Referral program dashboard — share, track, and earn credits/discounts.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🎁 Giới thiệu bạn bè                                            │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Your Referral Link ───────────────────────────────────────┐  │
│ │ creativanta.vn/r/QUANNG2026                                 │  │
│ │ [📋 Copy] [Zalo] [📘 Facebook] [📧 Email] [📱 SMS]        │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Stats ────────────────────────────────────────────────────┐  │
│ │ Đã chia sẻ    │ Đã đăng ký │ Paid converts │ Credits ✨  │  │
│ │ 45 clicks     │ 12 signups  │ 3 paid users  │ 150 earned  │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ How It Works ─────────────────────────────────────────────┐  │
│ │ 1. Share your link → friend signs up (both get 50 credits) │  │
│ │ 2. Friend upgrades → you get 20% of first month as credits │  │
│ │ 3. Multiple referrals? More rewards! (see tiers below)      │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Reward Tiers ─────────────────────────────────────────────┐  │
│ │ 🥉 Bronze (1-5 refs)   → 50 credits/ref                   │  │
│ │ 🥈 Silver (6-15 refs)  → 75 credits/ref + badge            │  │
│ │ 🥇 Gold   (16+ refs)   → 100 credits/ref + 1 month free    │  │
│ │ Your tier: [🥈 Silver] — 3 more to Gold!                   │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Referral History ─────────────────────────────────────────┐  │
│ │ 👤 Nguyễn A · Signed up 5d ago · Pro plan · +50 cr ✅     │  │
│ │ 👤 Trần B  · Signed up 12d ago · Free · Pending upgrade    │  │
│ │ 👤 Lê C    · Signed up 20d ago · Pro plan · +50 cr ✅     │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Leaderboard: [📊 Top referrers this month →]                    │
└──────────────────────────────────────────────────────────────────┘
```

---

## 101. Credit Purchase

**Route**: `/settings/credits/purchase`
**Purpose**: Buy additional AI credits — credit packs, auto-refill, usage projection.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🪙 Mua thêm AI Credits                                          │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Current Balance ──────────────────────────────────────────┐  │
│ │ 🪙 120 credits remaining · Resets in 18 days              │  │
│ │ Usage rate: 15/day avg · Estimated depletion: 8 days ⚠️   │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Credit Packs ─────────────────────────────────────────────┐  │
│ │ ┌─────────────┐ ┌─────────────┐ ┌─────────────────────┐   │  │
│ │ │ 100 credits │ │ 300 credits │ │ ⭐ 500 credits      │   │  │
│ │ │ 99,000đ     │ │ 249,000đ   │ │ 399,000đ          │   │  │
│ │ │ 990đ/cr     │ │ 830đ/cr    │ │ 798đ/cr (save 20%)│   │  │
│ │ │ [Mua]       │ │ [Mua]      │ │ [Mua ⭐ Best]      │   │  │
│ │ └─────────────┘ └─────────────┘ └─────────────────────┘   │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Auto-Refill ──────────────────────────────────────────────┐  │
│ │ [☐ ON] Tự động mua khi còn dưới [50 ▾] credits           │  │
│ │ Pack: [100 credits ▾]                                      │  │
│ │ Payment: [Visa ****4242 ▾]                                 │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Usage History ────────────────────────────────────────────┐  │
│ │ 25/3 · Quick Edit × 3     · -75 credits                   │  │
│ │ 25/3 · AI Remix            · -43 credits                   │  │
│ │ 24/3 · Video Agent          · -52 credits                   │  │
│ │ [Xem tất cả →]                                             │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Payment methods: [💳 Visa ****4242] [+ Thêm thẻ]               │
└──────────────────────────────────────────────────────────────────┘
```

---

## 102. Workspace Members

**Route**: `/settings/workspace/members`
**Purpose**: Manage workspace members — invite, assign roles, remove.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 👥 Thành viên workspace                [+ Mời thành viên mới]  │
├──────────────────────────────────────────────────────────────────┤
│ Seats: 3/5 used · [📈 Upgrade for more]                        │
│                                                                  │
│ ┌─ Member Row ───────────────────────────────────────────────┐  │
│ │ 👤 Nguyễn Quân · Owner                                     │  │
│ │    quanng@email.com · Last active: now                      │  │
│ │    Permissions: All                                          │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Member Row ───────────────────────────────────────────────┐  │
│ │ 👤 Trần Minh · Editor                                      │  │
│ │    minh@email.com · Last active: 2h ago                     │  │
│ │    Permissions: Create, Edit, Publish                       │  │
│ │    [✏ Change role ▾] [🗑 Remove]                           │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Member Row ───────────────────────────────────────────────┐  │
│ │ 👤 Lê Hoa · Viewer                                         │  │
│ │    hoa@email.com · Last active: 3d ago                      │  │
│ │    Permissions: View only                                    │  │
│ │    [✏ Change role ▾] [🗑 Remove]                           │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Pending Invites ──────────────────────────────────────────┐  │
│ │ 📧 linh@email.com · Role: Editor · Sent 1d ago            │  │
│ │ [🔄 Resend] [❌ Cancel invite]                             │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Roles Reference ──────────────────────────────────────────┐  │
│ │ Owner: Full access + billing · Editor: Create/edit/publish │  │
│ │ Viewer: Read-only · Custom: [Configure →]                  │  │
│ └────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### Invite Flow
1. Click "+ Mời" → Modal: email + role selector
2. Email sent with invite link
3. Recipient clicks → login/signup → joins workspace
4. Pending row shows status

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Invite | "+ Mời" → email + role → Send | `WorkspaceService/InviteMember` | Email sent, pending row |
| Change role | Role dropdown | `WorkspaceService/UpdateMemberRole` | Permissions updated |
| Remove | 🗑 Remove → confirm | `WorkspaceService/RemoveMember` | Member removed |
| Resend invite | 🔄 Resend | `WorkspaceService/ResendInvite` | Email resent |
| Cancel invite | ❌ Cancel | `WorkspaceService/CancelInvite` | Invite revoked |

---

## 103. API Keys (Pro+ only)

**Route**: `/settings/api`
**Purpose**: Manage API access tokens for external integrations.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🔑 API Keys                                    [+ Create Key]   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ⚠ API keys grant access to your workspace data. Keep them safe.│
│                                                                  │
│ ┌─ Key Row ──────────────────────────────────────────────────┐  │
│ │ "Production" · Created: 15/3/2026                           │  │
│ │ Key: cr_live_...4a2b (click to reveal)                      │  │
│ │ Scopes: [read:content] [write:content] [read:analytics]    │  │
│ │ Last used: 2h ago · Requests today: 145                    │  │
│ │ [📋 Copy] [✏ Edit scopes] [🔄 Rotate] [🗑 Revoke]        │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Key Row ──────────────────────────────────────────────────┐  │
│ │ "Development" · Created: 10/3/2026                          │  │
│ │ Key: cr_test_...8c3d                                        │  │
│ │ Scopes: [read:content] [read:analytics]                    │  │
│ │ Last used: 5d ago · Requests today: 0                      │  │
│ │ [📋 Copy] [✏ Edit scopes] [🔄 Rotate] [🗑 Revoke]        │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ API Documentation ────────────────────────────────────────┐  │
│ │ [📖 API Docs →] [🧪 API Playground →]                     │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Rate limit: 10,000 requests/day (Pro plan)                      │
└──────────────────────────────────────────────────────────────────┘
```

---

### M64. Mobile Billing/Subscription

**Route**: `/settings/billing` (mobile)
**Purpose**: View subscription plan, credit balance, and manage billing on mobile.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Gói & Thanh toán                                               │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Current Plan Card ────────────────────────────────────────┐   │
│ │ ⭐ Pro Plan                                    [Active]    │   │
│ │ 499,000 VND/month · Renews 15/04/2026                      │   │
│ │ ┌─ Usage ─────────────────────────────────────────────┐    │   │
│ │ │ AI Credits:  [████████░░] 320/500                    │    │   │
│ │ │ Storage:     [██████░░░░] 15 GB / 50 GB              │    │   │
│ │ │ Members:     [██████████] 3/5                         │    │   │
│ │ └──────────────────────────────────────────────────────┘    │   │
│ │ [🪙 Mua thêm credits] [⬆ Nâng cấp gói]                   │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                  │
│ ── Plan Comparison (swipeable cards) ──                           │
│ ┌──────────────┐  ┌──────────────┐  ┌──────────────┐            │
│ │ Free          │  │ ⭐ Pro       │  │ 💎 Business  │            │
│ │ 0đ/month     │  │ 499K/month   │  │ 999K/month   │            │
│ │ 100 credits  │  │ 500 credits  │  │ 2000 credits │            │
│ │ 5 GB storage │  │ 50 GB        │  │ 200 GB       │            │
│ │ 1 member     │  │ 5 members    │  │ 15 members   │            │
│ │ [Current]    │  │ [⭐ Active]  │  │ [Upgrade →]  │            │
│ └──────────────┘  └──────────────┘  └──────────────┘            │
│                                                                  │
│ ── Payment History ──                                            │
│ ┌────────────────────────────────────────────────────────────┐   │
│ │ 27/3 · Pro subscription   · 499,000đ · ✅ Paid [📥 PDF]  │   │
│ │ 25/3 · 100 credits        · 99,000đ  · ✅ Paid [📥 PDF]  │   │
│ │ 27/2 · Pro subscription   · 499,000đ · ✅ Paid [📥 PDF]  │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                  │
│ [💳 Quản lý phương thức thanh toán →]                            │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M64 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Buy credits | "Mua thêm credits" | — | → M-version of §101 Credit Purchase (bottom sheet) |
| Upgrade plan | "Nâng cấp" | — | Bottom sheet: plan comparison + checkout |
| Download invoice | 📥 on invoice row | `BillingService/DownloadInvoice` | PDF opens in viewer |
| Manage payment | "Quản lý phương thức" | — | → Stripe customer portal |

---

### M65. Mobile Referral

**Route**: `/settings/referral` (mobile)
**Purpose**: Share referral link and track rewards on mobile.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Giới thiệu bạn bè                                             │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Hero Card ────────────────────────────────────────────────┐   │
│ │ 🎁 Giới thiệu bạn bè — Nhận 50 credits mỗi người!        │   │
│ │                                                            │   │
│ │ Link: creativanta.vn/r/QUANNG2026                          │   │
│ │ [📋 Copy link]                                             │   │
│ │                                                            │   │
│ │ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐             │   │
│ │ │ Zalo │ │ FB   │ │Messgr│ │Email │ │ SMS  │             │   │
│ │ └──────┘ └──────┘ └──────┘ └──────┘ └──────┘             │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                  │
│ ┌─ Stats (horizontal scroll) ────────────────────────────────┐  │
│ │ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐       │  │
│ │ │ 👆 Clicks│ │ 📝 Sign  │ │ 💳 Paid  │ │ 🪙 Earned│       │  │
│ │ │ 45       │ │ ups: 12  │ │ 3        │ │ 150 cr   │       │  │
│ │ └──────────┘ └──────────┘ └──────────┘ └──────────┘       │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Reward Tier Progress ─────────────────────────────────────┐  │
│ │ 🥈 Silver (12 refs)  [████████████░░░░] → 🥇 Gold (16)   │  │
│ │ 4 more referrals to Gold (100 cr/ref + 1 month free!)     │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Referral History ──                                           │
│ ┌────────────────────────────────────────────────────────────┐  │
│ │ 👤 Nguyễn A · 5d ago · Pro plan · +50 cr ✅               │  │
│ │ 👤 Trần B  · 12d ago · Free · Pending upgrade             │  │
│ │ 👤 Lê C    · 20d ago · Pro plan · +50 cr ✅               │  │
│ └────────────────────────────────────────────────────────────┘  │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M65 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Copy link | "Copy link" | — | Clipboard + toast |
| Share | Tap social icon | Native share | Opens sharing app |
| View referral detail | Tap referral row | — | Bottom sheet: referral timeline |

---

### M66. Mobile Performance Coach

**Route**: `/performance` (mobile)
**Purpose**: AI-powered content performance insights and improvement suggestions.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Performance Coach                          [Period: 7d ▾]      │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Weekly Report Card (Hero) ────────────────────────────────┐  │
│ │ 📊 Tuần này của bạn                                        │  │
│ │ ┌──────────────────────────────────────────────────────┐   │  │
│ │ │ Overall score: 78/100 (▲5 vs last week)              │   │  │
│ │ │ Grade: B+ "Đang tiến bộ tốt!"                       │   │  │
│ │ └──────────────────────────────────────────────────────┘   │  │
│ │                                                            │  │
│ │ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐                      │  │
│ │ │Views │ │Engage│ │Revenue│ │Growth│                      │  │
│ │ │85K   │ │4.2%  │ │8.5M  │ │+2.1K │                      │  │
│ │ │▲12%  │ │▲0.5% │ │▲18%  │ │subs  │                      │  │
│ │ └──────┘ └──────┘ └──────┘ └──────┘                      │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── AI Improvement Suggestions ──                                 │
│ ┌─ Suggestion Card (swipeable) ──────────────────────────────┐  │
│ │ 💡 Insight #1                                              │  │
│ │ "Video ngắn dưới 60s có engagement cao hơn 2.3x so        │  │
│ │  với video dài. Hãy ưu tiên format short-form."            │  │
│ │ Impact: 🟢 High · Effort: 🟡 Medium                       │  │
│ │ [✅ Apply] [📋 Save to Ideas] [→ Skip]                     │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Suggestion Card ──────────────────────────────────────────┐  │
│ │ 💡 Insight #2                                              │  │
│ │ "Đăng bài vào 18:00-20:00 có reach cao hơn 45%            │  │
│ │  so với buổi sáng. Cân nhắc điều chỉnh lịch đăng."        │  │
│ │ Impact: 🟢 High · Effort: 🟢 Low                          │  │
│ │ [✅ Apply] [📋 Save to Ideas] [→ Skip]                     │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Content Strategy Cards ──                                     │
│ ┌────────────────────────────────────────────────────────────┐  │
│ │ 📈 Best performing: "Serum review" (45K views)             │  │
│ │ 📉 Underperforming: "Product haul" (2K views)              │  │
│ │ 🎯 Suggested next: "Before/after skincare routine"         │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Pull-to-refresh for latest insights                              │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M66 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Apply suggestion | "Apply" | — | → Relevant screen (publish calendar, idea board, etc.) |
| Save to ideas | "Save to Ideas" | `IdeaService/Create` | Idea created from suggestion |
| Skip suggestion | "Skip" | — | Next suggestion card swipes in |
| Change period | Period dropdown | Refetch insights | Cards update |
| Pull-to-refresh | Pull down | `PerformanceService/Refresh` | Latest insights loaded |

---

## 99b. Notification Preferences

**Route**: `/settings/notifications`
**Purpose**: Configure notification channels and types per category. Referenced from §7 and M42.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Cài đặt   🔔 Thông báo                                        │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Global Controls ──────────────────────────────────────────┐  │
│ │ Pause all notifications:   [OFF ●]                         │  │
│ │ Quiet hours: [22:00] to [07:00]  [● Enabled]              │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── Per-Category Settings ──                                      │
│                                                                  │
│ ┌─ Category: Inbox & Messages ───────────────────────────────┐  │
│ │                        │ 📱 Push │ 📧 Email │ 🔔 In-app   │  │
│ │ New message            │ [✅]    │ [☐]      │ [✅]        │  │
│ │ New comment            │ [✅]    │ [☐]      │ [✅]        │  │
│ │ Mention                │ [✅]    │ [✅]     │ [✅]        │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Category: Commerce ───────────────────────────────────────┐  │
│ │                        │ 📱 Push │ 📧 Email │ 🔔 In-app   │  │
│ │ New order              │ [✅]    │ [✅]     │ [✅]        │  │
│ │ Refund request         │ [✅]    │ [✅]     │ [✅]        │  │
│ │ Low stock              │ [☐]     │ [✅]     │ [✅]        │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Category: AI & Studio ────────────────────────────────────┐  │
│ │                        │ 📱 Push │ 📧 Email │ 🔔 In-app   │  │
│ │ Generation complete    │ [✅]    │ [☐]      │ [✅]        │  │
│ │ Credits low            │ [✅]    │ [✅]     │ [✅]        │  │
│ │ Agent completed        │ [✅]    │ [☐]      │ [✅]        │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Category: System ─────────────────────────────────────────┐  │
│ │                        │ 📱 Push │ 📧 Email │ 🔔 In-app   │  │
│ │ Connector error        │ [✅]    │ [✅]     │ [✅]        │  │
│ │ Security alert         │ [✅]    │ [✅]     │ [✅]        │  │
│ │ Billing reminder       │ [☐]     │ [✅]     │ [✅]        │  │
│ │ Weekly digest          │ [☐]     │ [✅]     │ [☐]         │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ [💾 Lưu cài đặt]                                                 │
└──────────────────────────────────────────────────────────────────┘
```

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Toggle notification | Click checkbox | `UserService/UpdatePreferences` | Preference saved |
| Toggle quiet hours | Enable/disable | `UserService/UpdatePreferences` | Quiet hours active |
| Set quiet hours | Time pickers | `UserService/UpdatePreferences` | Do not disturb window set |
| Pause all | Toggle "Pause" | `UserService/UpdatePreferences` | All notifications paused |
| Save | "Lưu cài đặt" | `UserService/UpdatePreferences` | Toast "Đã cập nhật" |

