---
layer: features
module: gamification
domain: platform
status: READY
created: 2026-04-01
canonical: true
upstream: PRD v3.1 §37.3
---

# Gamification — Achievements, Streaks & Challenges

> **Upstream**: PRD §37.3, Design Pack 10 (Growth)
> **DB tables**: `creator_progress` (§14.1, includes streak columns), `achievement_definitions` [GLOBAL] (§14.2), `achievement_records` (§14.2), `challenge_definitions` [GLOBAL] (§22.10), `challenge_progress` (§22.11)
> **Screens**: 4 (achievement gallery, streak dashboard, challenge board, rewards)

---

## 1. Purpose

Gamification drives user engagement and retention through **Achievements** (milestone-based badges), **Streaks** (consistency rewards), and **Challenges** (time-bound goals). Integrated with the credit system for tangible rewards.

### Scope

**Covers**: Achievement definitions, progress tracking, streak monitoring, challenge lifecycle, credit reward integration, leaderboards, badge gallery.

**Does NOT cover (Non-goals for this module)**:
- Social/community features or user-to-user interactions (not in v1)
- External platform gamification (e.g., TikTok badges)
- Competitive ranking across workspaces (workspace-scoped only)
- Custom achievement creation by end users (admin-only)

### Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Creator | Any member | View achievements, track streaks, join challenges |
| Admin (Internal) | Internal Admin | Create/manage achievement definitions, create challenges |
| System | System | Check streak conditions, evaluate achievement triggers, distribute rewards |

## 2. Business Rules

| Rule | Description |
|------|-------------|
| RULE-GAM-001 | Achievement definitions are GLOBAL (same across all workspaces) |
| RULE-GAM-002 | Achievement progress is per-user, tracked by `trigger_condition` JSONB matching |
| RULE-GAM-003 | Streaks reset at midnight UTC if condition not met |
| RULE-GAM-004 | Streak rewards scale: 7-day = 10 credits, 30-day = 50 credits, 90-day = 200 credits |
| RULE-GAM-005 | Challenges are time-bound (1-30 days), created by admin |
| RULE-GAM-006 | Challenge participation is opt-in, progress tracked per-user |
| RULE-GAM-007 | Credit rewards auto-deposited via `CreditService/Grant` on completion |
| RULE-GAM-008 | Achievement unlock triggers canonical `achievement.unlocked` event |

## 3. Key Flows

### 3.1 Achievement System
1. System defines achievement templates (e.g., "First Video Published", "100 Followers")
2. User actions trigger condition checks (event-driven)
3. When condition met → achievement unlocked → notification + badge + optional credits
4. Progress tracked incrementally (e.g., "45/100 followers")

### 3.2 Streak System
1. Streak condition defined (e.g., "publish content daily")
2. System checks at midnight UTC
3. If condition met → streak count increments
4. If missed → streak resets to 0 (with grace period option)
5. Milestone rewards at 7, 30, 90 days

### 3.3 Challenge System
1. Admin creates challenge with goals, duration, rewards
2. Users opt-in during enrollment period
3. Progress tracked against goals
4. At deadline: winners determined, rewards distributed
5. Leaderboard visible during challenge

## 4. State Machine — Challenge

| From | To | Trigger | Condition |
|------|----|---------|-----------|
| — | draft | Admin creates | — |
| draft | enrolling | Admin publishes | Start date reached |
| enrolling | active | Enrollment closes | Min participants met |
| active | completed | End date reached | — |
| completed | rewarded | Rewards distributed | — |
| draft | cancelled | Admin cancels | Before publish |

## 4.1 Edge Cases

### EC-GAM-001: Streak interrupted by platform downtime
- Condition: System downtime at midnight UTC prevents streak check
- Expected behavior: Grace period extended by downtime duration. Streak NOT reset due to system fault. Admin can manually restore streaks via `GamificationService/AdminRestoreStreak`.

### EC-GAM-002: Achievement condition met retroactively
- Condition: Achievement "100 Published Videos" added after user already has 150 published videos
- Expected behavior: Backfill job checks existing data. Achievement auto-unlocked with `unlocked_at` = job run time. Notification sent: "You've earned a new achievement!"

### EC-GAM-003: Challenge with zero participants
- Condition: Challenge enrollment period ends with 0 opt-ins
- Expected behavior: Challenge transitions to `cancelled` (not `active`). Admin notified. No rewards distributed.

## 5. API Surface

> See `04_contracts/api_endpoint_map.md` §8 (Gamification) + §30 Extended

| Service | Key RPCs |
|---------|----------|
| `GamificationService` | ListAchievements, GetProgress, CheckStreak, ListChallenges, JoinChallenge, GetLeaderboard |

## 6. Acceptance Criteria

```gherkin
Feature: Achievement Unlocking
  Scenario: User publishes first video
    Given a user with 0 published videos
    When user publishes a video successfully
    Then "First Video" achievement is unlocked
    And notification sent with badge image
    And 10 credits auto-deposited

Feature: Streak System
  Scenario: 7-day publishing streak
    Given a user who published content 6 consecutive days
    When user publishes on day 7
    Then streak count = 7
    And 10 credit reward deposited
    And "7-Day Streak" badge unlocked
```

## 7. Cross-references

- **DB**: `04_contracts/database_schema.md` §14 Gamification
- **API**: `04_contracts/api_endpoint_map.md` §8 + §30
- **Events**: `04_contracts/domain_event_catalog.md` §14 (`achievement.unlocked`, `streak.broken`), §15C (`gamification.challenge.*`). Canonical unlock event name is `achievement.unlocked`. No canonical `streak.milestone` event exists yet; implementers MUST NOT invent one without contract update.
- **Credits**: `02_features/platform/reporting_admin_billing.md` (credit grant integration)
