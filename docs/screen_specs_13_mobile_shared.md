# Screen Specs 13 — Mobile-Only Screens & Shared Components

> **Upstream**: Pack 01 §6 (Mobile Patterns), A5 Design System Tokens
> **Screens**: 15 mobile-only screens + shared component specifications

---

## Mobile-Only Screens

### M1. Mobile Home / Today Feed

**Route**: `/ (mobile root)`
**Purpose**: Action-first daily feed — today's tasks, content pipeline status, quick actions.

### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ⚡ Creativanta              🔔 3  👤                             │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Xin chào, Quân! 👋                                              │
│ Hôm nay bạn có 5 việc cần làm                                  │
│                                                                  │
│ ┌─ Quick Actions (horizontal scroll) ────────────────────────┐ │
│ │ [📝 Tạo ý tưởng] [🎬 AI Studio] [📤 Đăng bài] [💬 Inbox] │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Today Cards (vertical scroll) ────────────────────────────┐ │
│ │ ┌── Action Card ──────────────────────────────────────────┐│ │
│ │ │ 📤 2 bài chờ đăng hôm nay                              ││ │
│ │ │ "5 tips nấu ăn" — 19:00 TikTok                         ││ │
│ │ │ "Serum review" — 20:00 Instagram                        ││ │
│ │ │ [Xem lịch →]                                             ││ │
│ │ └──────────────────────────────────────────────────────────┘│ │
│ │                                                              │ │
│ │ ┌── Action Card ──────────────────────────────────────────┐│ │
│ │ │ 💬 23 tin nhắn chưa đọc                                 ││ │
│ │ │ 🔴 3 purchase intents cần trả lời                       ││ │
│ │ │ [Mở Inbox →]                                             ││ │
│ │ └──────────────────────────────────────────────────────────┘│ │
│ │                                                              │ │
│ │ ┌── Action Card ──────────────────────────────────────────┐│ │
│ │ │ 📊 Performance hôm qua                                  ││ │
│ │ │ 👁 12.4K reach · ❤ 890 likes · +45 followers            ││ │
│ │ │ [Xem chi tiết →]                                         ││ │
│ │ └──────────────────────────────────────────────────────────┘│ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
├─ Bottom Nav ─────────────────────────────────────────────────────┤
│ [🏠 Home] [💡 Ideas] [🎬 Studio] [💬 Inbox] [📊 More]         │
└──────────────────────────────────────────────────────────────────┘
```

### Bottom Navigation
| Tab | Icon | Route | Badge |
|---|---|---|---|
| Home | 🏠 | `/` | — |
| Ideas | 💡 | `/ideas` | New ideas count |
| Studio | 🎬 | `/studio` | Queue count |
| Inbox | 💬 | `/inbox` | Unread count |
| More | 📊 | — | Shows dropdown: Analytics, Products, Settings |

---

### M2. Mobile Copilot

**Route**: Always-available floating button → bottom sheet
**Purpose**: Quick AI assistant on mobile — ask anything, get help.

### Layout
```
┌─ Bottom Sheet (85% height) ──────────────────────────────────────┐
│ 🤖 AI Copilot                                          [✕]      │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Quick Suggestions ────────────────────────────────────────┐ │
│ │ [Gợi ý ý tưởng mới] [Phân tích xu hướng] [Viết caption]  │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Chat Interface ───────────────────────────────────────────┐ │
│ │ 🤖 Xin chào! Tôi có thể giúp gì cho bạn?                 │ │
│ │                                                              │ │
│ │ 👤 Gợi ý cho tôi 3 ý tưởng video về skincare              │ │
│ │                                                              │ │
│ │ 🤖 Dựa trên xu hướng hiện tại, đây là 3 ý tưởng...        │ │
│ │    1. "5 lỗi skincare mùa hè" (Score: 85)                 │ │
│ │    2. "So sánh serum dưới 200K" (Score: 78)                │ │
│ │    3. "Routine 3 bước cho da dầu" (Score: 82)              │ │
│ │    [💾 Lưu 3 ý tưởng này]                                 │ │
│ │                                                              │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ [Hỏi gì đó...                                       🎤 📎 💬] │
└──────────────────────────────────────────────────────────────────┘
```

### Features
- Voice input (🎤) for hands-free
- Context-aware: knows current screen, recent actions
- Quick actions: results have CTAs to take action (save idea, open editor, etc.)
- Streaming response with typing indicator
- History preserved within session

---

### M3. Mobile Notification Center

**Route**: `/notifications` (mobile)
**Purpose**: Full-screen notification list with grouping, swipe actions, and quick navigation.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Thông báo                [Mark all read] [⚙️ Notification prefs]│
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Filter: [All] [📩 Messages] [🛍️ Commerce] [🤖 AI] [⚙️ System]  │
│                                                                  │
│ ── Hôm nay ──                                                    │
│ ┌────────────────────────────────────────────────────────────┐   │
│ │ 🟢 💬 Tin nhắn mới từ @Minh trên TikTok       · 5 min ago│   │
│ │ "Sản phẩm này còn hàng không?"                             │   │
│ │ ← Swipe: [🗑 Delete] [📌 Pin]                             │   │
│ ├────────────────────────────────────────────────────────────┤   │
│ │ 🟢 🤖 Quick Edit hoàn thành                    · 30 min ago│   │
│ │ "Video review serum đã sẵn sàng"                           │   │
│ │ [👁 Xem video]                                             │   │
│ ├────────────────────────────────────────────────────────────┤   │
│ │ ⚪ 🛍️ Đơn hàng mới #12456                      · 2h ago  │   │
│ │ "Serum Vitamin C × 1 — 350,000đ"                           │   │
│ │ [📦 Xem đơn hàng]                                         │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                  │
│ ── Hôm qua ──                                                    │
│ ┌────────────────────────────────────────────────────────────┐   │
│ │ ⚪ ⚙️ Token YouTube sắp hết hạn               · 1 day ago│   │
│ │ "Gia hạn trước 30/3 để tránh mất kết nối"                 │   │
│ │ [🔄 Gia hạn ngay]                                         │   │
│ ├────────────────────────────────────────────────────────────┤   │
│ │ ⚪ 📊 Báo cáo tuần sẵn sàng                   · 1 day ago│   │
│ │ "Xem performance coach tuần này"                           │   │
│ │ [📊 Xem báo cáo]                                          │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                  │
│ Pull-to-refresh for new notifications                            │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M3 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Mark all read | "Mark all read" | `NotificationService/MarkAllRead` | All dots → grey |
| Tap notification | Tap row | `NotificationService/MarkRead` | → Relevant screen |
| Delete | Swipe left | `NotificationService/Delete` | Row removed |
| Pin | Swipe right | `NotificationService/Pin` | Row pinned to top |
| Filter | Tap filter chip | — | List filtered by category |
| Pull-to-refresh | Pull down | `NotificationService/List` | New notifications loaded |
| Notification prefs | ⚙️ icon | — | → §99b Notification Preferences |

#### M3 States
- **Loading**: Skeleton rows with icon + text shimmer
- **Empty**: "Không có thông báo nào 🔔" + illustration
- **Unread indicator**: 🟢 dot on unread items, ⚪ on read

---

### M9. Mobile Analytics Snapshot

**Route**: `/analytics` (mobile)
**Purpose**: Simplified analytics optimized for mobile viewing.

### Layout
```
┌─ Screen ─────────────────────────────────────────────────────────┐
│ ← 📊 Analytics                               [Period: 7d ▾]     │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Metric Cards (2×2 grid) ──────────────────────────────────┐ │
│ │ ┌──────────┐ ┌──────────┐                                   │ │
│ │ │ 👁 Reach │ │ ❤ Engage│                                   │ │
│ │ │ 1.2M ↑24%│ │ 6.2% ↑  │                                   │ │
│ │ └──────────┘ └──────────┘                                   │ │
│ │ ┌──────────┐ ┌──────────┐                                   │ │
│ │ │ 👥 Follow│ │ 💰 Rev  │                                   │ │
│ │ │ 52K ↑12% │ │ 45M ↑22%│                                   │ │
│ │ └──────────┘ └──────────┘                                   │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Mini Chart (swipeable) ───────────────────────────────────┐ │
│ │ [Reach trend line — landscape-friendly]                     │ │
│ │ ← Swipe for: Engagement / Revenue / Followers →            │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Top Posts This Period ─────────────────────────────────────┐ │
│ │ 1. [🎬] "5 tips nấu ăn" — 24.3K views · 8.2% eng          │ │
│ │ 2. [🎬] "Serum review" — 12.1K views · 6.1% eng            │ │
│ │ 3. [🎬] "Kem chống nắng" — 8.9K views · 5.4% eng          │ │
│ │ [Xem tất cả →]                                              │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ [📊 Full analytics (open web)]                                  │
└──────────────────────────────────────────────────────────────────┘
```

---

### M10. Mobile Quick Capture

**Purpose**: Camera-first quick capture — snap a photo/video → immediately enter content pipeline.

### Layout
```
┌─ Full Screen ────────────────────────────────────────────────────┐
│                                                                  │
│ [Camera viewfinder — full screen]                                │
│                                                                  │
│                                                                  │
│                                                                  │
│                                                                  │
│                                                                  │
│                                                                  │
│                                                                  │
│                                                                  │
│ ┌─ Overlay Controls ─────────────────────────────────────────┐ │
│ │ [🔄 Flip] [⚡ Flash] [✨ Filter]                            │ │
│ │                                                              │ │
│ │            [⏺ Capture / 🔴 Record]                          │ │
│ │                                                              │ │
│ │ [🖼️ Gallery]                     Mode: [Photo] [Video]      │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ After capture:                                                   │
│ ┌─ Post-capture Actions ─────────────────────────────────────┐ │
│ │ [✂️ Edit] [📝 Add to script] [📤 Quick publish]            │ │
│ │ [🎬 Send to Studio] [💾 Save to assets]                    │ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

---

### M11. Mobile Onboarding

**Route**: First launch
**Purpose**: 5-step guided onboarding optimized for mobile.

```
Step 1: Welcome
┌──────────────────────────────────────────┐
│ [Illustration: Creator at work]          │
│                                          │
│ Chào mừng đến Creativanta! 🎬           │
│ Nền tảng AI giúp bạn sáng tạo          │
│ nội dung và bán hàng hiệu quả.         │
│                                          │
│ [Tiếp tục →]                            │
│                                          │
│ ● ○ ○ ○ ○                              │
└──────────────────────────────────────────┘

Step 2: Choose Mode
┌──────────────────────────────────────────┐
│ Bạn là ai? (chọn 1)                    │
│                                          │
│ [🎯 Creator — Tạo nội dung & bán hàng] │
│ [💼 Manager — Quản lý team content]     │
│ [👀 Explorer — Khám phá tính năng]      │
│                                          │
│ ○ ● ○ ○ ○                              │
└──────────────────────────────────────────┘

Step 3: Connect first platform
Step 4: Set niche/category
Step 5: Ready! → Home
```

---

### M42. Mobile Settings

**Route**: `/settings` (mobile)
**Purpose**: Centralized mobile settings hub with grouped sections and quick navigation.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Cài đặt                                                        │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Profile Header ───────────────────────────────────────────┐   │
│ │ [Avatar 64px] Nguyễn Quân                                  │   │
│ │               quan@email.com · Pro plan                     │   │
│ │               [✏️ Sửa hồ sơ →]                             │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                  │
│ ── Tài khoản ──                                                  │
│ ┌────────────────────────────────────────────────────────────┐   │
│ │ 👤 Hồ sơ cá nhân                                    [→]  │   │
│ │ 🔒 Bảo mật & Mật khẩu                               [→]  │   │
│ │ 🔔 Thông báo                                        [→]  │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                  │
│ ── Workspace ──                                                  │
│ ┌────────────────────────────────────────────────────────────┐   │
│ │ 🏢 Workspace settings                               [→]  │   │
│ │ 🔗 Tài khoản liên kết                  3 connected  [→]  │   │
│ │ 👥 Thành viên                           3/5 seats    [→]  │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                  │
│ ── Gói & Thanh toán ──                                           │
│ ┌────────────────────────────────────────────────────────────┐   │
│ │ 💳 Gói đăng ký                          [Pro] ⭐    [→]  │   │
│ │ 🪙 AI Credits                           320/500     [→]  │   │
│ │ 🎁 Giới thiệu bạn bè                               [→]  │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                  │
│ ── Tùy chọn ──                                                   │
│ ┌────────────────────────────────────────────────────────────┐   │
│ │ 🌐 Ngôn ngữ                          Tiếng Việt    [→]  │   │
│ │ 🎨 Giao diện                         Dark mode     [→]  │   │
│ │ 🔑 API Keys                                   Pro  [→]  │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                  │
│ ── Hỗ trợ ──                                                     │
│ ┌────────────────────────────────────────────────────────────┐   │
│ │ ❓ Trung tâm hỗ trợ                                 [→]  │   │
│ │ 🐛 Chẩn đoán hệ thống              Health: 🟢 96%  [→]  │   │
│ │ 📖 Thuật ngữ                                        [→]  │   │
│ │ 📋 Điều khoản & Chính sách                          [→]  │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                  │
│ ┌────────────────────────────────────────────────────────────┐   │
│ │ 🚪 Đăng xuất                                              │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                  │
│ v1.0.0 · Creativanta                                             │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M42 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Edit profile | Tap "Sửa hồ sơ" | — | → M27 User Settings |
| Security | Tap "Bảo mật" | — | → Clerk security page |
| Notifications | Tap "Thông báo" | — | → Notification preferences |
| Connections | Tap "Tài khoản liên kết" | — | → M38 |
| Subscription | Tap "Gói đăng ký" | — | → M64 Billing |
| Theme toggle | Tap "Giao diện" | — | Bottom sheet: Light/Dark/Auto |
| Sign out | Tap "Đăng xuất" → confirm | `AuthService/SignOut` | → Login screen |

---

### M43. Mobile Gamification

**Route**: `/gamification` (mobile)
**Purpose**: Display user level, streaks, quests, and achievements in an engaging mobile layout.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Thành tích                                                     │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Level Card (Hero) ────────────────────────────────────────┐   │
│ │ ┌────────────────────────────────────────────────────────┐ │   │
│ │ │ 🏆 Level 12 — Content Creator Pro                      │ │   │
│ │ │ [████████████████░░░░] 2,450 / 3,000 XP               │ │   │
│ │ │ 550 XP to Level 13                                     │ │   │
│ │ └────────────────────────────────────────────────────────┘ │   │
│ │                                                            │   │
│ │ 🔥 Streak: 15 ngày liên tiếp!                             │   │
│ │ [🔥🔥🔥🔥🔥🔥🔥 M T W T F S S]                          │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                  │
│ ── Nhiệm vụ hôm nay (3/5) ──                                    │
│ ┌────────────────────────────────────────────────────────────┐   │
│ │ ✅ Đăng nhập hôm nay                          +10 XP     │   │
│ │ ✅ Trả lời 5 tin nhắn                          +25 XP     │   │
│ │ ✅ Tạo 1 ý tưởng mới                          +15 XP     │   │
│ │ ⬜ Đăng 1 bài viết                             +50 XP     │   │
│ │ ⬜ Sử dụng AI Studio                           +30 XP     │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                  │
│ ── Thành tích gần đây (horizontal scroll) ──                     │
│ ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐          │
│ │ 🥇       │  │ 📈       │  │ 🎨       │  │ 🔥       │          │
│ │ First    │  │ 10K      │  │ AI       │  │ 7-day   │          │
│ │ Sale     │  │ Views    │  │ Creator  │  │ Streak  │          │
│ │ ✅ Got   │  │ ✅ Got   │  │ ✅ Got   │  │ ✅ Got   │          │
│ └──────────┘  └──────────┘  └──────────┘  └──────────┘          │
│                                                                  │
│ ── Bảng xếp hạng tuần ──                                        │
│ ┌────────────────────────────────────────────────────────────┐   │
│ │ 🥇 quan_creator · 2,450 XP                                │   │
│ │ 🥈 minh_beauty  · 1,890 XP                                │   │
│ │ 🥉 hoa_food     · 1,560 XP                                │   │
│ │ You are ranked #1 this week! 🎉                            │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                  │
│ [📊 Xem tất cả thành tích →]                                    │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M43 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| View quest detail | Tap quest | — | Bottom sheet: quest description + progress |
| Claim reward | Complete quest → claim animation | `GamificationService/ClaimReward` | XP added + confetti animation |
| View achievement | Tap badge | — | Bottom sheet: achievement detail + unlock date |
| View leaderboard | Tap leaderboard area | — | Full leaderboard screen (bottom sheet) |
| Share achievement | Long press badge | — | Share sheet with badge image |

#### M43 States
- **Loading**: Level bar skeleton + quest list shimmer
- **All quests done**: "🎉 Đã hoàn thành tất cả nhiệm vụ! Quay lại ngày mai."
- **Streak broken**: "😢 Streak bị mất. Bắt đầu lại từ 1 ngày."
- **Level up**: Full-screen celebration overlay with new badge

---

### M44. Mobile Search

**Route**: Search trigger from any screen
**Purpose**: Universal search on mobile with recent + suggested.

```
┌─ Full Screen ────────────────────────────────────────────────────┐
│ [🔍 Search...                                           ✕]      │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Recent:                                                          │
│ 📝 "5 tips nấu ăn" · Script                                    │
│ 🛍️ "Serum Vitamin C" · Product                                  │
│ 💬 "Nguyễn Văn A" · Contact                                    │
│                                                                  │
│ Quick actions:                                                   │
│ [📝 Tạo ý tưởng] [📤 Đăng bài] [🤖 Ask Copilot]              │
│                                                                  │
│ ── After typing ──                                               │
│ Results grouped: [Ideas] [Scripts] [Products] [Contacts]        │
│ [All] tab with mixed results ranked by relevance                │
└──────────────────────────────────────────────────────────────────┘
```

---

## Shared Components Specification

### SC1. App Shell (Web)
```
┌─ Sidebar (240px collapsed: 56px) ───────────────────────────────┐
│ Logo                                                             │
│ ── Navigation ──                                                 │
│ 🏠 Home                                                         │
│ 📊 Intelligence                                                  │
│ 💡 Ideas                                                        │
│ 📝 Scripts                                                      │
│ 🎬 AI Studio                                                    │
│ 📤 Publish                                                      │
│ 💬 Inbox (23)                                                   │
│ 🛍️ Commerce ▾                                                   │
│   ├ Products                                                     │
│   ├ Orders                                                       │
│   ├ Offers                                                       │
│   └ Campaigns                                                    │
│ 💰 Profit                                                       │
│ ⚡ Workflows                                                    │
│ 📊 Analytics                                                    │
│ ── Shortcuts ──                                                  │
│ 🔔 Notifications (3)                                            │
│ 🤖 Copilot                                                      │
│ ⚙️ Settings                                                     │
│ 👤 Profile                                                      │
│ ── Footer ──                                                     │
│ [Workspace selector ▾]                                          │
│ [🪙 Credits: 320/500]                                           │
└──────────────────────────────────────────────────────────────────┘
```

### SC2. Top Bar (Web)
```
┌─ Top Bar ────────────────────────────────────────────────────────┐
│ [☰ Toggle sidebar]  Page Title    [🔍 Search/Cmd ⌘K]           │
│                      [Breadcrumb]  [🤖 Copilot] [🔔 3] [👤]    │
└──────────────────────────────────────────────────────────────────┘
```

### SC3. Trust Badge (Global)
Used on any data display to show source reliability:
```
┌─ Trust Badge ────────────────────┐
│ Source: [Official | Imported |    │
│          Estimated | AI | Mixed] │
│ Confidence: [High | Med | Low]   │
│ Freshness: [Live | Stale | Old]  │
│ [Why? ▾]                         │
└──────────────────────────────────┘
```

### SC4. Empty State Template
```
┌─ Empty State ────────────────────┐
│ [Illustration]                   │
│ "Chưa có [object] nào"          │
│ "Tạo [object] đầu tiên để..."   │
│ [Primary CTA]                    │
│ [Secondary: Learn more]          │
└──────────────────────────────────┘
```

### SC5. Error State Template
```
┌─ Error State ────────────────────┐
│ [Error illustration]             │
│ "Đã có lỗi xảy ra"             │
│ "Error: [specific message]"      │
│ [Thử lại] [Báo cáo lỗi]        │
└──────────────────────────────────┘
```

### SC6. Confirmation Modal
```
┌─ Modal ──────────────────────────┐
│ ⚠️ Xác nhận                     │
│ "Bạn có chắc muốn [action]?"    │
│ "Hành động này không thể hoàn    │
│  tác."                           │
│ [Hủy]          [Xác nhận ✓]     │
└──────────────────────────────────┘
```

### SC7. Toast Notifications
- Success: green bar, checkmark icon, auto-dismiss 3s
- Error: red bar, X icon, manual dismiss + action button
- Warning: yellow bar, ! icon, auto-dismiss 5s
- Info: blue bar, i icon, auto-dismiss 3s
- Position: bottom-right (web), top (mobile)

### SC8. Loading Skeleton
- Card skeletons: shimmer animation, match card dimensions
- Table skeletons: rows with animated shimmer
- Avoid spinners — always use content-shaped skeletons

### SC9. Command Palette (⌘K)
- Fuzzy search across all entities
- Recent commands section
- Navigation commands: "Go to ideas", "Open settings"
- Action commands: "Create new script", "Quick publish"
- Context actions based on current page

---

## Additional Mobile Screens

### M59. Mobile Revenue Detail
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Doanh thu                                 [Period: 30d ▾]     │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Revenue Summary ──────────────────────────────────────────┐  │
│ │ Total: 25.6M VND ▲12%                                      │  │
│ │ [Swipeable chart: Revenue / Reach / RPM over 30d]           │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Per-Platform Cards (horizontal scroll) ───────────────────┐  │
│ │ ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │  │
│ │ │ TikTok Shop  │  │ Shopee       │  │ Website      │       │  │
│ │ │ 18.2M ▲15%  │  │ 5.4M ▲8%   │  │ 2.0M ▲5%    │       │  │
│ │ └──────────────┘  └──────────────┘  └──────────────┘       │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Top Content by Revenue ───────────────────────────────────┐  │
│ │ [🖼 thumb] "Serum review"     │ 8.5M VND │ 45K views      │  │
│ │ [🖼 thumb] "Top 5 skincare"   │ 5.2M VND │ 32K views      │  │
│ │ [🖼 thumb] "Unboxing haul"    │ 3.1M VND │ 28K views      │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Pull-to-refresh                                                  │
└──────────────────────────────────────────────────────────────────┘
```

#### M59 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Change period | Period dropdown | Refetch data | Charts update |
| Swipe chart | Swipe left/right | — | Switch between Revenue/Reach/RPM |
| View content detail | Tap content row | — | → Content analytics detail |
| Pull-to-refresh | Pull down | Refetch all | Data refreshed |

### M60. Mobile Reconciliation
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Đối soát                                                       │
├──────────────────────────────────────────────────────────────────┤
│ ┌─ Status Summary ───────────────────────────────────────────┐  │
│ │ 🟢 Matched: 45 │ 🟡 Anomalies: 3 │ 🔴 Critical: 1        │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Anomaly Card ──────────────────────────────────────────────┐  │
│ │ 🔴 Revenue mismatch — TikTok Shop                           │  │
│ │ Creativanta: 850K VND │ TikTok: 800K VND │ Diff: 50K       │  │
│ │ Order #12345 · Product: Serum Vitamin C                     │  │
│ │ [👁 Inspect] [✅ Acknowledge] [🚩 Flag]                     │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Anomaly Card ──────────────────────────────────────────────┐  │
│ │ 🟡 Missing order — Shopee                                   │  │
│ │ Shopee order #67890 not in Creativanta                       │  │
│ │ Amount: 320K VND · Date: 25/3                               │  │
│ │ [👁 Inspect] [✅ Acknowledge] [🚩 Flag]                     │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Swipe left → Acknowledge · Swipe right → Flag                    │
└──────────────────────────────────────────────────────────────────┘
```

#### M60 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Inspect | "Inspect" | — | Drawer: side-by-side comparison + proof |
| Acknowledge | Swipe left or button | `ReconciliationService/Acknowledge` | Anomaly marked resolved |
| Flag | Swipe right or "Flag" | `ReconciliationService/Flag` | Escalated to admin |

### M61. Mobile Agent Runs
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Agent Runs                                                     │
├──────────────────────────────────────────────────────────────────┤
│ ┌─ Filter Chips ─────────────────────────────────────────────┐  │
│ │ [All] [Running 2] [Completed 15] [Failed 1]                │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Run Card ──────────────────────────────────────────────────┐  │
│ │ 🤖 Clip Factory Agent              [🟢 Running]            │  │
│ │ "Generate serum review clip" · Started 5 min ago            │  │
│ │ Step 3/5: "Rendering video..."                              │  │
│ │ [Progress bar ████████░░ 60%]                                │  │
│ │ [⏸ Cancel]                                                  │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Run Card ──────────────────────────────────────────────────┐  │
│ │ 🤖 Script Writer Agent             [✅ Done]                │  │
│ │ "Write 3 captions for serum" · Completed 1h ago             │  │
│ │ 3 outputs generated · 15 credits used                       │  │
│ │ [👁 View output]                                             │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Run Card ──────────────────────────────────────────────────┐  │
│ │ 🤖 Trend Analyzer Agent            [🔴 Failed]             │  │
│ │ "Analyze skincare trends" · Failed 2h ago                   │  │
│ │ Error: "Timeout — API provider unavailable"                 │  │
│ │ [🔄 Retry] [👁 View logs]                                   │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

#### M61 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Cancel run | "Cancel" → confirm | `AgentService/Cancel` | Run stopped |
| View output | "View output" | — | → Output detail screen |
| Retry | "Retry" | `AgentService/Retry` | New run queued |
| View logs | "View logs" | — | Drawer with step-by-step log |

### M62. Mobile Recipe Library
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Kho công thức                              [🔍 Search]        │
├──────────────────────────────────────────────────────────────────┤
│ ┌─ Category Chips (horizontal scroll) ──────────────────────┐   │
│ │ [All] [Engagement] [Publishing] [Commerce] [Analytics]    │   │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Recipe Grid (2 columns) ──────────────────────────────────┐  │
│ │ ┌──────────────────┐  ┌──────────────────┐                  │  │
│ │ │ 📋               │  │ 📋               │                  │  │
│ │ │ Auto-respond     │  │ Daily trend      │                  │  │
│ │ │ to comments      │  │ digest           │                  │  │
│ │ │ 234 installs     │  │ 89 installs      │                  │  │
│ │ │ [Install ▾]      │  │ [Install ▾]      │                  │  │
│ │ └──────────────────┘  └──────────────────┘                  │  │
│ │                                                              │  │
│ │ ┌──────────────────┐  ┌──────────────────┐                  │  │
│ │ │ 📋               │  │ 📋               │                  │  │
│ │ │ Auto-publish     │  │ Competitor       │                  │  │
│ │ │ cross-platform   │  │ alert            │                  │  │
│ │ │ 156 installs     │  │ 67 installs      │                  │  │
│ │ │ [Install ▾]      │  │ [Install ▾]      │                  │  │
│ │ └──────────────────┘  └──────────────────┘                  │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

#### M62 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Search | Type in search | — | Grid filtered |
| Filter category | Tap chip | — | Grid filtered |
| View recipe | Tap card | — | Bottom sheet: description + steps |
| Install recipe | "Install" → confirm | `RecipeService/Install` | Workflow created from template |

### M63. Mobile Contact Detail
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Contact                                    [✏️ Edit] [⋮]      │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Contact Header ───────────────────────────────────────────┐  │
│ │ [Large Avatar]                                              │  │
│ │ Nguyễn Minh                                                 │  │
│ │ 🏷️ VIP · 💰 12.5M total spent · 📦 23 orders              │  │
│ │ Platforms: [TikTok ✓] [Shopee ✓] [Instagram ✓]             │  │
│ │ [💬 Message] [📞 Call] [📧 Email]                           │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Swipe Tabs ───────────────────────────────────────────────┐  │
│ │ [Messages] [Orders] [Content]                               │  │
│ ├──────────────────────────────────────────────────────────────┤  │
│ │ ── Messages Tab ──                                          │  │
│ │ [TikTok icon] "Sản phẩm này còn hàng không?" · 2h ago     │  │
│ │ [Shopee icon] "Đã nhận hàng, cảm ơn!" · 1d ago            │  │
│ │ [Instagram icon] "Collab ko ạ?" · 3d ago                   │  │
│ │                                                              │  │
│ │ ── Orders Tab ──                                            │  │
│ │ 📦 #12345 · Serum Vitamin C · 350K · ✅ Delivered · 25/3   │  │
│ │ 📦 #12340 · Moisturizer Set · 890K · ✅ Delivered · 20/3   │  │
│ │                                                              │  │
│ │ ── Content Tab ──                                           │  │
│ │ Tagged in: "Serum review" (12K views)                       │  │
│ │ Mentioned: "Skincare routine" (8K views)                    │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

#### M63 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Message | "Message" | — | → Inbox composer with contact |
| Call | "Call" | — | Phone dialer (if number available) |
| Edit tags | "Edit" on tags | `ContactService/UpdateTags` | Tags updated |
| View order | Tap order row | — | → Order detail |
| View content | Tap content | — | → Content analytics |

---

## Additional Shared Components

### SC10. In-App Glossary
**Trigger**: Any underlined term → tooltip with definition
```
┌─ Glossary Tooltip ────────────┐
│ 📖 RPM (Revenue Per Mille)    │
│ Doanh thu trung bình trên     │
│ mỗi 1,000 lượt xem.          │
│ [📚 Xem tất cả thuật ngữ →]  │
└───────────────────────────────┘
```
- Context-aware: shows relevant terms per screen
- Can be disabled in settings

#### Glossary Full Page (`/glossary`)
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 📖 Thuật ngữ Creativanta                                         │
├──────────────────────────────────────────────────────────────────┤
│ [🔍 Tìm thuật ngữ...                                     ]      │
│                                                                  │
│ A-Z: [A] [B] [C] [D] [E] [F] ... [V] [X] [Y] [Z]              │
│                                                                  │
│ ── C ──                                                          │
│ ┌────────────────────────────────────────────────────────────┐  │
│ │ **CPM** (Cost Per Mille)                                   │  │
│ │ Chi phí trung bình cho mỗi 1,000 lượt hiển thị quảng cáo.│  │
│ │ Dùng trong: Analytics, Commerce                            │  │
│ └────────────────────────────────────────────────────────────┘  │
│ ┌────────────────────────────────────────────────────────────┐  │
│ │ **CTA** (Call to Action)                                   │  │
│ │ Lời kêu gọi hành động, thường là nút bấm hoặc link tại  │  │
│ │ cuối nội dung.                                             │  │
│ │ Dùng trong: Content, Publishing, Commerce                  │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── R ──                                                          │
│ ┌────────────────────────────────────────────────────────────┐  │
│ │ **RPM** (Revenue Per Mille)                                │  │
│ │ Doanh thu trung bình trên mỗi 1,000 lượt xem.            │  │
│ │ Dùng trong: Analytics, Profit                              │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ 📊 Total: 45 thuật ngữ                                          │
└──────────────────────────────────────────────────────────────────┘
```

#### Glossary Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Search | Type in search | Client-side filter | List filtered |
| Jump to letter | Click letter | Anchor scroll | Scroll to section |
| Copy definition | Long press / click copy | — | Clipboard + toast |

### SC11. Upsell Banner
```
┌─ Upsell Banner ─────────────────────────┐
│ ⭐ Nâng cấp để mở khóa [feature name]  │
│ Gói Pro: chỉ từ 499,000đ/tháng         │
│ [Xem gói ▾] [×]                         │
└──────────────────────────────────────────┘
```
- **Placement**: Inline when user hits tier limit
- **Dismissibility**: Can dismiss, won't show again for 24h
- **Variants**: Floating bar, inline card, modal (for hard limits)

### SC12. Onboarding Tooltip Sequence
```
┌─ Spotlight Tooltip ──────────────────────┐
│ 💡 Đây là Inbox — xem và trả lời tin    │
│ nhắn từ tất cả nền tảng tại đây.        │
│ [← Back] Step 3/5 [Next →] [Skip all]   │
└──────────────────────────────────────────┘
│ (Overlay dims rest of screen, spotlight  │
│  on the highlighted element)             │
```
- 5-step tour per module on first visit
- Can be dismissed and replayed from Help menu
- Adapts to mobile (bottom sheet instead of tooltip)

