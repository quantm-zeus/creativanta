---
layer: features
module: M01
canonical: true
domain: platform
status: SPECIFIED
last_updated: 2026-10-29
---

# Feature: Home / Daily Decision Engine (M01)

## Purpose

Creators and operators begin each workday overwhelmed — scattered dashboards, disconnected alerts, and no single surface that answers "what should I do next to grow revenue/profit?" Home exists to eliminate that chaos by serving as a **daily decision engine**, not a static dashboard.

Home dynamically compiles the highest-impact actions across all domains (intelligence, content, commerce, engagement, finance, diagnostics) into a prioritized, mode-aware action surface. It adapts its card order, terminology, and CTAs to the active operator mode (creator, seller, affiliate_operator, live_operator, agency_mcn, brand_collaboration), ensuring every user type sees their most relevant decisions first.

## Scope

### Covers
- Rendering prioritized action cards (6 card families) per operator mode
- Morning Brief entry point (condensed daily summary via push/email/in-app)
- Copilot entry point (contextual AI assistant for operational questions)
- Why/diagnostics drawer for every card and KPI
- Assign/snooze/dismiss interactions on decision cards
- Beginner onboarding checklist overlay (first closed-loop guidance)
- Connector/capability issue surfacing
- Profit anomaly surfacing with drill-down to proof

### Does NOT cover (Non-goals for this module)
- Trend scoring logic (owned by M02)
- Opportunity prioritization algorithm (owned by M04)
- Thread triage/reply execution (owned by M12)
- Profit calculation and reconciliation (owned by M19)
- Workflow execution and approval processing (owned by M20)
- Full diagnostics management (owned by M23)

## Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Solo Creator | Owner/Editor | Review action cards, capture idea, quick publish, reply to threads |
| Seller | Owner/Manager | Triage order/refund anomalies, act on stock alerts, inspect profit |
| Affiliate Operator | Editor | Check link health, act on conversion opportunities, share coupons |
| Live Operator | Manager | Review live readiness, cue/highlight prep, post-live follow-up |
| Agency Manager | Manager/Admin | Review cross-workspace approvals, diagnostics, assignment handoffs |
| Brand Collaboration Operator | Manager | Review sponsor inquiries, deliverable status, proof bundles |
| Beginner (any mode) | Any | Follow onboarding checklist, explore guided recipes |

## Business Rules

> INVARIANTS — rút từ PRD §18, §23.1, Pack 01 §5 AC. Bắt buộc implement đúng.

1. **RULE-M01-001**: Every Home card MUST have exactly one primary CTA that leads to an actionable object — dead-end dashboard cards are forbidden (PRD §18.3).
2. **RULE-M01-002**: Home MUST render action cards reflecting the active `workspaces.default_operator_mode` — card family order, terminology, and KPI emphasis MUST follow the canonical 6-mode priority matrix (Pack 01 §S05.1).
3. **RULE-M01-003**: Home MUST NOT be a static dashboard displaying only numbers — it must surface prioritized decisions with "why this matters" context, using action language (PRD §18.1, §18.4).
4. **RULE-M01-004**: Every KPI and score displayed on Home MUST have a "Why this number" drawer that shows data sources, confidence band, missing data caveats, and next steps (Pack 01 §7.2).
5. **RULE-M01-005**: Home MUST provide a first closed-loop onboarding experience for beginners following the 5-step sequence: connect account → create/select product/offer → create idea→script→asset → publish/fallback → track outcome (Pack 01 §5 onboarding).
6. **RULE-M01-006**: All 6 canonical operator modes MUST be represented — never collapse to fewer than 6 (PRD §8.2).
7. **RULE-M01-007**: Profit/revenue cards on Home MUST carry source badge and confidence badge — estimated and official truth MUST NOT be merged without labeling (PRD §15.7).

## Main Flow

1. User opens Home — system reads `workspaces.default_operator_mode`
   - calls `WorkspaceService/Get`
   - see [04_contracts/api_endpoint_map.md#2.1](../../04_contracts/api_endpoint_map.md)
2. System assembles Home projection from multiple domain sources:
   - Trend/Opportunity data (M02, M04) → "Top Opportunities" cards
   - Thread SLA/urgency (M12) → "Urgent Threads" cards
   - Approval queue (M20, M11) → "Pending Approvals" cards
   - Profit anomaly (M19) → "Profit Anomalies" cards
   - Connector health (M22) → "Diagnostics Issues" cards
   - see [04_contracts/domain_event_catalog.md#3](../../04_contracts/domain_event_catalog.md) (intelligence events feeding Home)
3. System reorders cards by operator mode priority matrix
4. User taps a card CTA → navigates to the relevant object detail page
   - e.g., Opportunity detail, Thread detail, Approval detail, Profit drill-down
5. User may dismiss/snooze/assign cards — emits UI action, persists in Home projection state
6. Morning Brief generation (cron) compiles top 3-5 items into brief
   - emits `morning_brief.generated`
   - see [04_contracts/domain_event_catalog.md#13](../../04_contracts/domain_event_catalog.md)

## Alternate Flows

### A1: Beginner First Visit (No Data)
- Trigger: User opens Home for the first time, no connected accounts, no content
- Steps: System shows onboarding checklist overlay instead of action cards. Each completed step adds data to Home projection. Partial setup state visible as progress bar.
- Result: After 5-step completion, Home transitions to standard action card layout

### A2: Connector Broken / Degraded
- Trigger: `account.token_expired` or `account.sync_failed` event received
- Steps: System surfaces "Connector / Diagnostics Issues" card at elevated priority. Card includes repair CTA leading to Connected Accounts page with Repair Wizard.
- Result: User either repairs or acknowledges degraded state

### A3: Mode Switch
- Trigger: User changes `default_operator_mode` in Settings
- Steps: Home re-assembles card priority order, KPI emphasis, and terminology per new mode
- Result: Home reflects new mode immediately without page reload

## Edge Cases

> Tối thiểu 3. Phải handle tường minh.

### EC-M01-001: All Connectors Disconnected
- Condition: User has no active connected accounts — most data sources are empty
- Expected behavior: Home shows "Setup Required" state with guided connect flow. Action cards that depend on connector data show graceful empty states with "Connect [Platform] to see [data type]" CTAs. Home MUST NOT show blank cards or cryptic "no data" messages.
- Reference: Pack 01 §8.1 (Empty State), PRD §20.4

### EC-M01-002: Conflicting Profit Data Sources
- Condition: Revenue from official source and inferred attribution produce different totals
- Expected behavior: Home profit card shows both values with source badge labels (Official vs Inferred). Confidence badge reflects the reconciliation gap. "Why this number" drawer explains the discrepancy and suggests reconciliation action.
- Reference: PRD §15.1, §16.3

### EC-M01-003: Morning Brief Generation Fails
- Condition: Cron job for `morning_brief.generated` fails due to timeout or missing projection data
- Expected behavior: Brief delivery is skipped for that cycle. Push/email channel reports "Brief unavailable — open Home for latest updates." No stale brief is re-sent. Next cron cycle retries independently.
- Reference: 04_contracts/domain_event_catalog.md §13

### EC-M01-004: High-Volume Card Suppression
- Condition: >50 pending approvals or >100 urgent threads simultaneously
- Expected behavior: Home groups cards into summary cards with count + "View All" CTA. Individual cards shown for top 5 by priority. Suppressed items remain accessible via Approval Queue / Inbox.
- Reference: Pack 01 §5 (card families)

## State Machine

Home does not manage a first-class state machine itself — it is a **projection surface**. However, the Morning Brief has a simple lifecycle:

Object: morning_brief | Not a DB entity — ephemeral projection
see [04_contracts/domain_event_catalog.md#13](../../04_contracts/domain_event_catalog.md)

| From | To | Trigger | Condition |
|---|---|---|---|
| — | generated | Cron schedule (daily) | Workspace has at least 1 connected account |
| generated | delivered | Push/email sent | Channel delivery succeeds |
| generated | failed | Push/email fails | Channel delivery error |

## Related Contracts

| Topic | File | Section |
|---|---|---|
| DB tables | [04_contracts/database_schema.md](../../04_contracts/database_schema.md) | §4 (workspaces), §5 (intelligence), §11 (profit_snapshots), §13 (diagnostics_records) |
| API | [04_contracts/api_endpoint_map.md](../../04_contracts/api_endpoint_map.md) | §2.1 (WorkspaceService), §2.2 (Intelligence RPCs), §2.8 (Copilot) |
| Events | [04_contracts/domain_event_catalog.md](../../04_contracts/domain_event_catalog.md) | §3 (intelligence → M01), §7 (thread SLA → M01), §10 (profit anomaly → M01), §12 (capability/credits → M01), §13 (morning_brief) |
| RBAC | [04_contracts/rbac_permission_matrix.md](../../04_contracts/rbac_permission_matrix.md) | §2.1 (workspace read), §2.2 (trend/opportunity read), §2.10 (diagnostics read) |

## Related Screens

| Platform | Screen | Notes |
|---|---|---|
| Web | Home / Daily Decision Engine | 6 card families, mode-aware layout, why drawer |
| Mobile | 🏠 Home tab (bottom nav) | Morning Brief default, action cards, quick actions |
| Mobile | Notifications Center | Accessible from Home top bar |
| Web/Mobile | Onboarding Checklist | Overlay on Home for beginners |

## Acceptance Criteria

1. **Given** a user with operator mode `seller` opens Home, **when** the page loads, **then** the card order MUST follow Seller priority: Order Queue → Revenue Today → Low Stock Alert → Profit Summary → Customer Messages (Pack 01 §S05.1).

2. **Given** a Home action card for "Profit Anomaly Detected", **when** the user taps the card, **then** the system navigates to the Profit Snapshot detail page with the anomaly pre-selected — the card MUST NOT lead to a dead-end summary.

3. **Given** a beginner user with no connected accounts, **when** they open Home for the first time, **then** the system MUST show the onboarding checklist overlay with step 1 "Connect Account" as the primary CTA and progress indicator showing 0/5 steps completed.

4. **Given** a KPI card showing "Revenue Today: 5,200,000đ", **when** the user taps "Why this number", **then** the drawer MUST display: data source(s) with source badge (Official/Imported/Inferred), confidence band, last sync timestamp, and if confidence < High, what's missing to improve it.

5. **Given** a connector with `connection_status = 'expired'`, **when** Home renders, **then** a "Connector Issue" card MUST appear in the Diagnostics card family with a "Reconnect" primary CTA and "View Diagnostics" secondary CTA.

## Open Questions / Blockers

> ✅ **RESOLVED: SCR-M-001** (2026-03-31) — All screen specs consolidated in `docs/03_screens/` (current canonical inventory: 243 files across web/mobile/admin/shared after 2026-04-06 S26 completion). Cross-links now use canonical `03_screens/` paths.

---

## Contextual Learning System (PRD §36A, §27)

> Home is the primary entry point for the Contextual Learning System — a progressive disclosure mechanism that reduces cognitive load for beginners while staying invisible to experienced users.

### Learning Layers

| Layer | Trigger | Content | Mode |
|---|---|---|---|
| **First-use tooltips** | User encounters feature for 1st time | Brief explanation + "Learn more" link | All modes |
| **Module-scoped help overlay** | User clicks "?" icon on any module | Module-specific guide, top 3 actions, related articles | All modes |
| **Progressive feature reveal** | User completes key milestones | Unlock next level features with celebration | Beginner |
| **Operator mode learning path** | User selects operator mode | Mode-specific recommended feature sequence | Beginner |
| **Contextual AI tips** | System detects user stuck (>60s inactivity on a form) | "Bạn cần trợ giúp? [Xem hướng dẫn] [Hỏi Copilot]" | Beginner |

### Beginner Mode UX Rules (PRD §27)
- **No "learn module" prerequisite**: user never forced to complete training before accessing features
- **Task-first navigation**: prioritize flow by task/loop, not by internal taxonomy
- **Concrete CTAs**: use "Tạo video bán hàng" not abstract "Create asset"
- **4 mandatory state types**: empty states, partial setup states, broken states, repair states — all with contextual help
- **Recipe-first entry**: allow user to start from recipe, object, or suggested action — no command-heavy UX

### Learning Path Per Operator Mode

| Mode | Recommended Sequence | Prize |
|---|---|---|
| Creator | Connect → Idea → Script → Video → Publish → Track | "Debut Creator" badge + 20 credits |
| Seller | Connect Shop → List Product → Create Video Ad → Publish → Track Sales | "First Sale" badge + 20 credits |
| Affiliate | Connect → Browse Offers → Generate Link → Share → Track Revenue | "Link Legend" badge + 20 credits |

### Implementation Notes
- Contextual tips stored as content items (managed by ops via internal admin)
- Tips suppressible: user can dismiss permanently via "Don't show again"
- Tips language follows workspace language setting
- Analytics: track tip dismissal rate, Copilot handoff rate, feature activation rate after tip exposure

### Cross-references
- **Help Center**: `02_features/platform/help_center.md` (article links from tooltips)
- **Copilot**: `02_features/platform/copilot.md` (handoff from contextual tips)
- **Gamification**: `02_features/platform/gamification.md` (achievement badges for learning path completion)
