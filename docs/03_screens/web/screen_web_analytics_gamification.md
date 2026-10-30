# Screen: Web — Gamification Dashboard

> **Screen ID**: W079
> **Module**: gamification — see canonical feature owner in screen_task_map.csv
> **Route**: `/gamification`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 02, PRD §23.24, A1 Schema (gamification_levels, achievements, quests, xp_events), B5 RBAC §2.7

---

## 1. Purpose & Context

Creator engagement through game mechanics — levels with XP progression, daily/weekly quests, achievement badges, posting streaks, and leaderboard. Gamification drives consistent content creation and platform feature adoption.

### User Goals
- See my current level and progress to next level
- Complete quests for XP rewards
- Collect achievement badges
- Maintain posting streaks for bonus XP
- Compare with other creators on leaderboard

### Business Goals
- Drive daily active usage through quests
- Encourage feature adoption (first live, first AI, etc.)
- Build habit loops with streaks
- Increase content output through consistency rewards

### Entry Points
- Sidebar: "🎮 Level & Achievements"
- Home Dashboard: level progress widget
- Notification: "🎯 Quest completed! +50 XP"
- Performance Coach (W076): "Leaderboard" link

### Exit Points
- "Weekly Report Card →" → Performance Coach (W076)
- "Leaderboard →" → Leaderboard sub-page
- Quest "Start →" → relevant feature screen

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 🎮 Level & Achievements                                             │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Creator Level ───────────────────────────────────────────────┐   │
│ │ ⭐ Level 12 — "Content Pro"                                   │   │
│ │ XP: 2,840 / 3,200 [████████████████░░░] 88%                  │   │
│ │ Next: Level 13 "Influencer" — 360 XP to go                   │   │
│ │                                                                │   │
│ │ 🔥 Streak: 14 ngày liên tục posting                          │   │
│ │ Best streak: 21 ngày · Streak bonus: +10% XP                 │   │
│ │                                                                │   │
│ │ Recent XP: +50 (quest) · +25 (post) · +10 (comment reply)   │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Active Quests ───────────────────────────────────────────────┐   │
│ │ 📅 Daily Quests (reset at midnight)                           │   │
│ │ 🎯 "Post 1 content today" — ☑ Done — +15 XP                 │   │
│ │ 🎯 "Reply to 5 comments" — 3/5 — +20 XP                     │   │
│ │ 🎯 "Check analytics" — ☐ Not started — +10 XP               │   │
│ │                                                                │   │
│ │ 📅 Weekly Quests (reset Monday)                                │   │
│ │ 🎯 "Publish 3 videos" — 2/3 done — +50 XP                   │   │
│ │ 🎯 "Reply to 10 comments" — 7/10 — +30 XP                   │   │
│ │ 🎯 "Complete first live session" — ☐ — +100 XP               │   │
│ │                                                                │   │
│ │ 🏆 Monthly Challenge                                          │   │
│ │ 🎯 "Reach 100K total views this month" — 78K/100K — +200 XP │   │
│ │ [████████████████████████████████░░░░░░░░░] 78%               │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Achievement Grid ────────────────────────────────────────────┐   │
│ │ Earned (6/20):                                                 │   │
│ │ [🌟 First Post] [🔥 7-Day Streak] [🎬 10 Videos] [💰 1st Sale]│  │
│ │ [🤖 AI Master] [🎤 First Live]                                │   │
│ │                                                                │   │
│ │ Locked (14):                                                   │   │
│ │ [⬜ 30-Day Streak] [⬜ 100 Videos] [⬜ 10K Followers]         │   │
│ │ [⬜ Brand Deal]    [⬜ 1M Views]    [⬜ Revenue 10M]          │   │
│ │ [⬜ ... 8 more]                                                │   │
│ │                                                                │   │
│ │ 💡 Next achievable: "30-Day Streak" — 16 more days posting    │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Leaderboard (Top 10) ────────────────────────────────────────┐   │
│ │ 🥇 @creator_a · Level 18 · 12,500 XP                         │   │
│ │ 🥈 @creator_b · Level 16 · 10,200 XP                         │   │
│ │ 🥉 @creator_c · Level 15 · 9,800 XP                          │   │
│ │ ...                                                            │   │
│ │ 📍 Your rank: #42 of 1,200 creators                           │   │
│ │ [→ View full leaderboard]                                      │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ [📊 Weekly Report Card →] [🏆 Full Leaderboard →]                   │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
GamificationDashboardPage
├── AppShell (shared)
├── PageHeader
│   └── PageTitle ("🎮 Level & Achievements")
├── CreatorLevelCard
│   ├── LevelNumber + Title
│   ├── XPProgressBar (current/required)
│   ├── NextLevel (name + XP remaining)
│   ├── StreakSection
│   │   ├── CurrentStreak (with 🔥 if active)
│   │   ├── BestStreak
│   │   └── StreakBonus (% XP multiplier)
│   └── RecentXPList (last 3 XP events)
├── QuestsSection
│   ├── DailyQuestsGroup (reset midnight)
│   │   └── QuestItem[] (description, progress, XP reward, status)
│   ├── WeeklyQuestsGroup (reset Monday)
│   │   └── QuestItem[]
│   └── MonthlyChallenge
│       ├── Description + progress bar
│       └── XPReward
├── AchievementGrid
│   ├── EarnedBadges[] (icon + name, unlocked)
│   ├── LockedBadges[] (grayed out with lock icon)
│   └── NextAchievableHint
├── LeaderboardPreview
│   ├── TopThree (gold/silver/bronze)
│   ├── UserRank (highlighted)
│   └── ViewFullLink
└── ActionBar
    ├── WeeklyReportLink
    └── FullLeaderboardLink
```

---

## 5. XP System

| Action | XP | Frequency Cap |
|---|---|---|
| Publish content | +25 | 5/day |
| Reply to comment | +5 | 20/day |
| Complete quest | +15-200 | Per quest |
| First sale through content | +50 | Once |
| Complete live session | +30 | 1/day |
| Use AI feature | +10 | 3/day |
| Streak day | +5 | 1/day |
| Streak bonus (>7 days) | +10% multiplier | Passive |
| Streak bonus (>30 days) | +25% multiplier | Passive |

---

## 6. Level Tiers

| Level Range | Title | XP Required |
|---|---|---|
| 1-5 | Beginner | 0-500 |
| 6-10 | Creator | 500-2,000 |
| 11-15 | Content Pro | 2,000-5,000 |
| 16-20 | Influencer | 5,000-12,000 |
| 21-25 | Star Creator | 12,000-25,000 |
| 26-30 | Legend | 25,000+ |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Level card shimmer |
| LOADED | Data received | Full gamification dashboard |
| LEVEL_UP | Just leveled up | 🎉 Celebration animation + new title reveal |
| QUEST_COMPLETE | Just completed quest | ✅ Animation + XP counter increment |
| STREAK_BROKEN | Missed a day | "😢 Streak bị gián đoạn. Streak mới: 0 ngày. Bắt đầu lại!" |
| ERROR | API failed | Error with retry |

---
## 8. Edge Cases

| Edge Case | Handling |
|---|---|
| Level-up triggered during session | 🎉 Full-screen celebration: confetti + new title reveal + "Bạn lên Level {n}!" |
| Streak breaks (missed day) | "😢 Streak gián đoạn ({n} ngày). Bắt đầu lại từ 0!" with reset animation |
| Max level reached (Level 30) | Banner: "🏆 Legend! Bạn đã đạt cấp tối đa!" — XP still accumulates for leaderboard |
| Quest completed but XP not credited | Optimistic UI (show complete), server reconcile on next load |
| Leaderboard user not ranked (new user) | "📍 Bạn chưa có xếp hạng. Hoàn thành quest để lên bảng!" |

---

## 9. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached dashboard | Auto-retry online |
| Quest completion fail | XP write error | Optimistic UI reverted, toast: "Không ghi nhận. [Thử lại]" | Retry |
| Leaderboard load fail | API timeout | Section: "Không tải được bảng xếp hạng. [Thử lại]" | Retry |
| Achievement unlock fail | API error | Silent retry (non-blocking) | Next page load |
| XP event stream lost | SSE disconnect | Silent reconnect, reconcile on reopen | Auto-reconnect |

---

## 10. Accessibility

| Element | Requirement |
|---|---|
| XP progress bar | `role="progressbar"`, `aria-valuenow="{xp}"`, `aria-valuemin="0"`, `aria-valuemax="{required}"`, `aria-label="XP: {current}/{required}"` |
| Quest items | `role="listitem"`, `aria-label="{quest}: {progress}/{total}, phần thưởng {xp} XP"` |
| Achievement badges (earned) | `aria-label="Đã đạt: {badge_name}"` |
| Achievement badges (locked) | `aria-label="Chưa đạt: {badge_name}, điều kiện: {condition}"` |
| Streak counter | `aria-label="Streak: {n} ngày liên tục, bonus {multiplier}%"` |

---

## 11. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Level card shimmer |
| Level card | 200-400ms | XP bar animates fill (500ms ease-out) |
| Quests | 300-600ms | Quest items stagger in |
| Achievements | 400-800ms | Badge grid fades in |
| Leaderboard | 500-1000ms | Rows slide in |
| Level-up | 0ms (event) | Confetti + scale animation (2s) |

---

## 12. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `gamification.viewed` | Page load | `level`, `xp`, `streak`, `source` |
| `gamification.challenge.completed` | Quest done | `quest_id`, `quest_type`, `xp_earned` |<!-- AUDIT-FIX 2026-04-19: quest_completed → challenge.completed to match canonical domain_event_catalog.md line 422 (Quest=Challenge per glossary §Gamification) -->
| `gamification.achievement_unlocked` | Badge earned | `achievement_id`, `achievement_name` |
| `gamification.level_up` | Level increased | `from_level`, `to_level`, `total_xp` |
| `gamification.streak.milestone` | Streak change | `streak_days`, `is_broken` |<!-- AUDIT-FIX 2026-04-19: streak_updated → streak.milestone to match canonical domain_event_catalog.md line 275 (no generic .updated event; catalog defines streak.milestone/broken/frozen) -->
| `gamification.leaderboard_viewed` | Leaderboard section visible | `user_rank`, `total_creators` |
| `gamification.quest_started` | Quest "Start →" CTA | `quest_id`, `target_route` |
| `gamification.full_leaderboard_clicked` | Full leaderboard link | — |

---

## 13. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/gamification/+page.svelte`
- **Server load**: `+page.server.ts` → `GamificationService/GetDashboard(user_id)` (level, quests, achievements, streak)
- **XP bar**: Svelte `tweened` store for smooth fill animation
- **Quest tracking**: `GamificationService/GetActiveQuests(user_id)` — progress computed server-side
- **Achievements**: `GamificationService/GetAchievements(user_id)` — earned + locked
- **Leaderboard**: `GamificationService/GetLeaderboard(limit=10, user_id)` — top 10 + user rank
- **SSE**: `/events/gamification` → real-time XP events, quest completions, level-ups
- **Confetti**: `canvas-confetti` (client-side only, loaded dynamically on level-up)
- **Quest reset**: Daily quests reset at midnight (server cron), weekly at Monday 0:00

---

## 14. Localization Notes

- Levels: "Người mới" (1-5), "Creator" (6-10), "Content Pro" (11-15), "Influencer" (16-20), "Star Creator" (21-25), "Legend" (26-30)
- XP: "2.840 / 3.200 XP", "Còn 360 XP"
- Streak: "🔥 14 ngày liên tục", "Kỷ lục: 21 ngày"
- Quests: "Đăng 1 bài hôm nay", "Trả lời 5 bình luận"
- Badges: "Bài đầu tiên", "Streak 7 ngày", "10 video", "Bán hàng đầu tiên"

---

## 15. Design Tokens

| Token | Usage |
|---|---|
| `--color-level-beginner` | Level 1-5 badge |
| `--color-level-creator` | Level 6-10 badge |
| `--color-level-pro` | Level 11-15 badge |
| `--color-level-influencer` | Level 16-20 badge (gold) |
| `--color-level-star` | Level 21-25 badge (purple) |
| `--color-level-legend` | Level 26-30 badge (holographic) |
| `--color-xp-bar` | XP progress bar fill |
| `--color-streak-active` | 🔥 Active streak glow |
| `--color-surface-elevated` | Cards |

---

## 16. Related Screens

| Screen | Relationship |
|---|---|
| [W077] Performance Metrics | Weekly report card |
| [W075] Analytics Overview | Performance data feeding XP |
| [M038] Mobile Gamification | Mobile equivalent |

---

## 17. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 edge cases (level-up, streak break, max level), 5 errors, XP bar/quest a11y, 8 analytics, SvelteKit impl (SSE, confetti, cron), 9 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
