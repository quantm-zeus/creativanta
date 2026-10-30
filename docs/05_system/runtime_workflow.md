---
layer: system
canonical: true
source_file: creativanta_detail_design_pack_03_event_workflow_agent_runtime_contract_v_3_1.md
last_verified: 2026-03-30
purpose: Event model, workflow/agent runtime, approval, retry/DLQ, recipe, audit, observability, and real-time communication contracts
---

# Creativanta — Detail Design Pack 03 — Event Backbone / Workflow / Agent Runtime Contract v3.1

## 0. Traceability Header

- **Upstream sections used**: Product Freeze sections 10–17, 21–34, 39–46.
- **Canonical objects touched**: Publish Job, Queue Item, Approval Request, Publish Item, Publish Log, Thread, Offer, Campaign, Coupon, Affiliate Link, Membership Plan, Order, Refund, Reconciliation Record, Workflow, Workflow Run, Agent Run, Recipe Template, Live Session, Sample Request, Sample Shipment, Evidence Object, Diagnostics Record.
- **State machines touched**: Publish Job, Queue Item, Approval Request, Publish Item, Offer/Campaign/Store/Monetization Support, Order/Refund/Settlement/Reconciliation/Cost, Workflow Run, Agent Run, Recipe Template, Live Session, Sample Request, Sample Shipment.
- **Read / write ownership respected**: runtime chỉ phát events và side effects qua aggregate owners; append-only truth records immutable.
- **Acceptance scenarios inherited**: idempotent execution, approval gates, retry/dead-letter repair, auditability, runtime diagnostics, recipe install/run safety, live/seeding orchestration.
- **See also**: S26 §15 (Job Queue & Background Task Monitor) — admin-side visibility into queue health, DLQ management, workflow/saga state inspection.

## 1. Mục tiêu

Pack này khóa backbone runtime cho:
- domain events
- integration events
- workflow execution
- recipe installation/execution
- agent planning/execution
- approvals, retries, diagnostics, audit

## 2. Event Model

### 2.1 Event Families
- domain events
- integration events
- projection update events
- diagnostics events
- audit events
- billing/metering events

### 2.2 Domain Event Rules
Domain events phải:
- phát ra từ aggregate owner
- immutable
- có event time, actor/context, aggregate ref
- không chứa business meaning mơ hồ

### 2.3 Required Metadata
Mọi event bắt buộc có:
- event_id
- event_type
- emitted_at
- workspace scope
- actor/system context
- aggregate_type
- aggregate_id
- correlation_id
- causation_id nếu có

## 3. Canonical Event Inventory

### 3.1 Decision / Creation
- TrendDetected
- TrendCreated
- OpportunityCreated
- OpportunityPrioritized
- OpportunityAssigned
- OpportunityConverted
- IdeaCreated
- ScriptDrafted
- ScriptSubmittedForApproval
- ScriptApproved
- ScriptRejected
- AssetBriefCreated
- AssetGenerationRequested
- AssetGenerated
- AssetGenerationFailed
- AssetApproved
- AssetRejected

### 3.1B Video Production (M07 — Production Modes)

> **Naming reconciliation (Audit v5 — M2)**: Event names below use CamelCase for readability. Implementation MUST map these to the canonical `{domain}.{entity}.{action}` pattern defined in `domain_event_catalog.md` §15B. Example: `VideoEditJobCreated` → `production.video_edit_job.created`.

#### CamelCase → Canonical dot.notation Mapping Table

> **EVT-H-001 Resolution**: This table provides the authoritative mapping between Pack 03's CamelCase display names and the canonical dot.notation event_type strings used in Rust code. The `event_type: String` field in `DomainEvent` MUST use the dot.notation column exclusively.

| CamelCase (Pack 03 Display) | Canonical dot.notation (Code) | Section |
|---|---|---|
| TrendDetected | `trend.signal_detected` | §3.1 |
| TrendCreated | `trend.created` | §3.1 |
| OpportunityCreated | `opportunity.created` | §3.1 |
| OpportunityPrioritized | `opportunity.state_changed` | §3.1 |
| OpportunityAssigned | `opportunity.state_changed` | §3.1 |
| OpportunityConverted | `opportunity.converted` | §3.1 |
| IdeaCreated | `idea.created` | §3.1 |
| ScriptDrafted | `script.created` | §3.1 |
| ScriptSubmittedForApproval | `script.submitted_for_approval` | §3.1 |
| ScriptApproved | `script.approved` | §3.1 |
| ScriptRejected | `script.rejected` | §3.1 |
| AssetBriefCreated | `content_brief.created` | §3.1 |
| AssetGenerationRequested | `asset.generation_started` | §3.1 |
| AssetGenerated | `asset.generation_completed` | §3.1 |
| AssetGenerationFailed | `asset.generation_failed` | §3.1 |
| AssetApproved | `asset.approved` | §3.1 |
| AssetRejected | `asset.rejected` | §3.1 |
| VideoEditJobCreated | `production.video_edit_job.created` | §3.1B |
| VideoEditJobStarted | `production.video_edit_job.started` | §3.1B |
| VideoEditJobCompleted | `production.video_edit_job.completed` | §3.1B |
| VideoEditJobFailed | `production.video_edit_job.failed` | §3.1B |
| QuickEditApplied | `production.quick_edit.applied` | §3.1B |
| ClipFactoryAnalyzed | `production.clip_factory.analyzed` | §3.1B |
| ClipFactoryClipsProposed | `production.clip_factory.clips_proposed` | §3.1B |
| ViralityScoreCalculated | `production.virality_score.calculated` | §3.1B |
| MultiMergeAssembled | `production.multi_merge.assembled` | §3.1B |
| RemixAnalysisStarted | `production.remix.analysis_started` | §3.1B |
| CreativeDnaExtracted | `production.remix.creative_dna_extracted` | §3.1B |
| RemixGenerationCompleted | `production.remix.generation_completed` | §3.1B |
| RemixOriginalityChecked | `production.remix.originality_checked` | §3.1B |
| PublishJobCreated | `publish.queued` | §3.2 |
| PublishExecutionSucceeded | `publish.succeeded` | §3.2 |
| PublishExecutionFailed | `publish.failed` | §3.2 |
| ConnectorDegraded | `connector.degraded` | §3.2 |
| ConnectorRecovered | `connector.recovered` | §3.2 |
| ThreadCreated | `thread.created` | §3.3 |
| OrderImported | `order.imported` | §3.3 |
| OrderStateUpdated | `order.state_changed` | §3.3 |
| RefundRequested | `refund.requested` | §3.3 |
| RefundCompleted | `refund.completed` | §3.3 |
| WorkflowRunStarted | `workflow_run.started` | §3.4 |
| WorkflowRunCompleted | `workflow_run.completed` | §3.4 |
| WorkflowRunFailed | `workflow_run.failed` | §3.4 |
| AgentRunCompleted | `agent_run.completed` | §3.4 |
| RecipeTemplatePublished | `recipe.installed` | §3.4 |
| ProofBundleAssembled | `proof_bundle.assembled` | §3.5 |
| LiveSessionStarted | `live.session_started` | §3.5 |
| LiveSessionEnded | `live.session_ended` | §3.5 |
| SampleRequestCreated | `sample_request.created` | §3.5 |
| SampleShipmentShipped | `sample.shipped` | §3.5 |

- VideoEditJobCreated
- VideoEditJobStarted
- VideoEditJobCompleted
- VideoEditJobFailed
- QuickEditApplied
- ClipFactoryAnalyzed
- ClipFactoryClipsProposed
- ViralityScoreCalculated
- MultiMergeAssembled
- RemixAnalysisStarted
- CreativeDnaExtracted
- RemixGenerationCompleted
- RemixOriginalityChecked

### 3.1C Extended Production (M07 — Pack 04 §9.6-9.16)

#### CamelCase → Canonical dot.notation Mapping Table (§3.1C)

| CamelCase (Pack 04 Display) | Canonical dot.notation (Code) |
|---|---|
| ProductShowcaseJobCreated | `production.product_showcase.created` |
| ProductShowcaseJobCompleted | `production.product_showcase.completed` |
| ProductShowcaseBatchQueued | `production.product_showcase.batch_queued` |
| ImageToVideoGenerated | `production.image_to_video.generated` |<!-- AUDIT-FIX 2026-04-19: renamed .completed → .generated to match domain_event_catalog.md line 397 (canonical name). -->
| ThumbnailGenerated | `production.thumbnail.generated` |
| ThumbnailABTestStarted | `production.thumbnail.ab_test_started` |
| LinkToVideoScraped | `production.link_to_video.scraped` |
| LinkToVideoGenerated | `production.link_to_video.generated` |<!-- AUDIT-FIX 2026-04-19: renamed .completed → .generated to match domain_event_catalog.md line 401 (canonical name). -->
| TranslationJobStarted | `production.translation.started` |
| TranslationLanguageCompleted | `production.translation.language_completed` |
| TranslationJobCompleted | `production.translation.completed` |
| SoundStudioTrackGenerated | `production.sound_studio.track_generated` |
| StylePackExtracted | `production.style_pack.extracted` |
| StylePackApplied | `production.style_pack.applied` |
| VideoAgentPipelineStarted | `production.video_agent.pipeline_started` |
| VideoAgentPipelineCompleted | `production.video_agent.pipeline_completed` |
| PerformanceReportGenerated | `production.performance_report.generated` |
| ABTestExperimentStarted | `production.ab_test.started` |<!-- AUDIT-FIX 2026-04-19: renamed .experiment_started → .started to match domain_event_catalog.md line 411 (canonical name). -->
| ABTestWinnerDetermined | `production.ab_test.winner_determined` |
| CreatorXPEarned | `xp.earned` |<!-- AUDIT-FIX 2026-04-19: renamed gamification.xp.earned → xp.earned to match domain_event_catalog.md line 273 (canonical name has no gamification. prefix). -->
| CreatorLevelUp | `gamification.level.up` |
| CreatorStreakUpdated | `streak.milestone` |<!-- AUDIT-FIX 2026-04-19: renamed gamification.streak.updated → streak.milestone. Catalog (line 275) only defines streak.milestone/broken/frozen — no generic ".updated" event. The display name "StreakUpdated" maps semantically to the forward-progress milestone event; streak.broken/.frozen are separate lifecycle events emitted under their own display names. -->
| CreatorAchievementUnlocked | `achievement.unlocked` |
| CreatorQuestCompleted | `gamification.challenge.completed` |<!-- AUDIT-FIX 2026-04-19: renamed gamification.quest.completed → gamification.challenge.completed. Glossary §Gamification defines "Challenge"; schema §22.10 describes challenge_definitions as "Quest/challenge configs" — Quest and Challenge are synonyms. Canonical catalog (line 422) uses "challenge". -->

- ProductShowcaseJobCreated
- ProductShowcaseJobCompleted
- ProductShowcaseBatchQueued
- ImageToVideoGenerated
- ThumbnailGenerated
- ThumbnailABTestStarted
- LinkToVideoScraped
- LinkToVideoGenerated
- TranslationJobStarted
- TranslationLanguageCompleted
- TranslationJobCompleted
- SoundStudioTrackGenerated
- StylePackExtracted
- StylePackApplied
- VideoAgentPipelineStarted
- VideoAgentPipelineCompleted
- PerformanceReportGenerated
- ABTestExperimentStarted
- ABTestWinnerDetermined
- CreatorXPEarned
- CreatorLevelUp
- CreatorStreakUpdated
- CreatorAchievementUnlocked
- CreatorQuestCompleted

### 3.2 Publish / Capability
- PublishJobCreated
- PublishJobQueued
- PublishJobDispatched
- PublishExecutionStarted
- PublishExecutionSucceeded
- PublishExecutionFailed
- PublishRequiresManualFallback
- QueueItemCreated
- QueueItemClaimed
- QueueItemExpired
- ApprovalRequested
- ApprovalApproved
- ApprovalRejected
- ApprovalExpired
- PublishLogAppended
- ChannelPostSynced
- CapabilitySnapshotCaptured
- ConnectorDegraded
- ConnectorRecovered

### 3.3 Engagement / Commerce
- ThreadCreated
- ThreadIntentUpdated
- ThreadAssigned
- ThreadNextActionUpdated
- FollowUpTaskCreated
- OfferActivated
- OfferPaused
- CampaignStarted
- CouponActivated
- AffiliateLinkGenerated
- MembershipPlanActivated
- StorePagePublished
- OrderImported
- OrderStateUpdated
- RefundRequested
- RefundCompleted
- RefundFailed
- SettlementImported
- CostItemRecorded
- ReconciliationOpened
- ReconciliationResolved

### 3.4 Workflow / Agent
- WorkflowCreated
- WorkflowPublished
- WorkflowRunQueued
- WorkflowRunStarted
- WorkflowRunWaitingApproval
- WorkflowRunFailed
- WorkflowRunCompleted
- AgentRunPlanned
- AgentRunAwaitingApproval
- AgentRunExecuting
- AgentRunHandedOff
- AgentRunCompleted
- AgentRunFailed
- RecipeTemplatePublished
- TriggerEventCaptured
- ActionLogAppended

### 3.5 Trust / Proof / Operations
- EvidenceCollected
- ProofBundleAssembled
- ProfitSnapshotRefreshed
- LiveSessionStarted
- LiveSessionEnded
- SampleRequestCreated
- SampleShipmentShipped
- DiagnosticsOpened
- DiagnosticsResolved
- AdminOverrideApplied
- AuditEventCaptured

## 4. Workflow Runtime Contract

### 4.1 Runtime Components
- trigger listener
- rule evaluator
- condition resolver
- action executor
- approval gate
- diagnostics emitter
- audit emitter
- retry manager
- dead-letter handler

### 4.2 Workflow Node Types
- trigger node
- condition node
- transform node
- action node
- approval node
- wait node
- fallback node
- diagnostics node
- handoff node
- terminal node

### 4.3 Required Runtime Fields
Workflow run phải có:
- run identity
- workflow version
- trigger context
- current node
- node results summary
- approval status if any
- side effects summary
- diagnostics refs
- audit refs

## 5. Agent Runtime Contract

### 5.1 Agent Phases
- planning
- plan review / approval if required
- execution
- observation / evidence collection
- handoff or completion

### 5.2 Agent Action Rule
Agent chỉ được mutate canonical objects qua allowed actions có:
- permission check
- capability check
- audit requirement check
- policy check
- optional approval gate

### 5.3 Agent Memory Rule
Agent memory tạm thời không được thay canonical graph. Muốn thành truth phải emit action và write qua aggregate owner.

## 6. Approval Contract

### 6.1 Actions Requiring Approval
- external publish
- price or offer activation changes
- destructive archive/retire
- reconciliation override
- payout/commission affecting actions
- force-complete / force-cancel workflow or agent run

### 6.2 Approval Fields
- approval_request_id
- requested action
- impacted objects
- requested by
- approver(s)
- expires_at
- outcome
- reason

### 6.3 Approval / Queue Rule
- approval object phải mở ngược được tới queue item, affected object và audit trail khi có
- approval outcome không được cập nhật chỉ trong event log; canonical approval request state phải được cập nhật bởi owner tương ứng
- queue expiration, rejection và manual removal đều phải emit diagnostics + audit events khi có business impact

## 7. Retry / Dead-Letter Contract

### 7.1 Retry Rule
Retry phải hỗ trợ:
- transient retry
- bounded retry
- manual retry
- retry with repair

### 7.2 Dead-Letter Rule
Dead-letter item phải giữ:
- original context
- failure summary
- retry history
- suggested repair path
- canonical object refs

## 8. Diagnostics Contract

### 8.1 Runtime Diagnostics Must Include
- failure type
- affected node/action
- user-facing explanation
- operator explanation
- recommended next step
- fallback if available

### 8.2 Workflow/Agent Failure Rule
Không được fail im lặng. Mọi run failed, partial hoặc handed_off phải có diagnostics summary.

## 9. Recipe Contract

### 9.1 Recipe Template Fields
- recipe identity
- recipe category
- required capabilities
- required objects/data inputs
- parameter schema
- trigger compatibility
- expected outputs
- safety/approval notes

### 9.2 Install Rule
Cài recipe phải kiểm tra:
- workspace eligibility
- capability availability
- dependency conflicts
- required permissions

## 10. Audit Contract

### 10.1 Audit Required For
- business-critical side effects
- approvals
- overrides
- force retries / cancels
- external execution attempts

### 10.2 Audit Fields
- actor
- action
- affected objects
- old/new state summary
- reason if applicable
- timestamp
- correlation id

## 11. Observability Handoff

Queue topics, ordering, idempotency, retry/DLQ and recovery semantics are owned by [Queue design](queue_retry_design.md); implementation must satisfy its restart/replay fixtures. [Workflow integration](../06_quality_ops/activepieces_integration.md) owns the baseline executor/optional-adapter boundary and runtime budgets. Canonical object/step state remains in PostgreSQL regardless of adapter.

---

## 11A. Real-time Communication Contract

### 11A.1 Protocol Selection

| Surface | Protocol | Fallback |
|---|---|---|
| Live War Room (M17) | WebSocket | Long-polling |
| Unified Inbox (M12) | WebSocket / SSE | Long-polling |
| Publish Job progress (M11) | SSE | Polling 3s |
| Workflow Run status (M20) | SSE | Polling 5s |
| Agent Run status (M21) | SSE | Polling 5s |
| Connector health (M22) | Polling | — (30s interval) |
| AI generation progress (M07) | SSE | Polling 5s |
| Notification delivery | WebSocket | Push notification + polling |
| Approval queue updates | WebSocket | Polling 10s |

### 11A.2 Latency Requirements

| Surface | Max Latency (event → UI) |
|---|---|
| Live War Room actions | ≤ 500ms |
| Inbox new message | ≤ 2s |
| Publish status change | ≤ 3s |
| Workflow state change | ≤ 3s |
| Connector health update | ≤ 30s |
| Notification delivery | ≤ 5s |
| Profit anomaly alert | ≤ 1 min |

### 11A.3 Connection Management
- WebSocket connections phải auto-reconnect với exponential backoff (1s, 2s, 4s, 8s, max 30s)
- Heartbeat interval: 30s
- Connection status visible to user (connected / reconnecting / disconnected)
- Graceful degradation: nếu WebSocket unavailable → fallback to SSE → fallback to polling
- Max concurrent WebSocket connections per client: ≤ 3

### 11A.4 Event Delivery Guarantees
- At-least-once delivery cho business-critical events
- Idempotent client-side processing (event dedup by event_id)
- Ordered delivery per aggregate (using sequence numbers)
- Missed events recovery: khi reconnect, fetch events since last_received_sequence

### 11A.5 Mobile Real-time Contract
- Khi app ở foreground: maintain WebSocket/SSE connections
- Khi app ở background: close connections, rely on push notifications
- Khi app resume: reconnect + sync missed events
- Battery optimization: không maintain connection khi app idle > 5 min
- Network-aware: reduce real-time connections on cellular/metered networks

### 11A.6 Event Fan-out Architecture
- Events emitted by aggregate owners → event bus
- Event bus → per-surface channels (WebSocket rooms / SSE endpoints)
- Workspace-scoped isolation: user chỉ nhận events trong workspace scope
- RBAC filter: events chỉ fan-out tới users có read permission trên affected objects


## 11B. Transactional Email / SMS / Messaging Contract

### 11B.1 Email Template Catalog

| Trigger | Template | Priority |
|---|---|---|
| Account creation | Welcome + onboarding guide | Transactional |
| Email verification | Verify email link | Transactional |
| Password reset | Reset link (expires 1h) | Transactional |
| Login from new device | Security alert | Transactional |
| Payment success | Receipt + invoice | Transactional |
| Payment failed | Retry prompt | Transactional |
| Subscription renewal | Renewal confirmation | Transactional |
| Subscription cancellation | Cancellation + data export offer | Transactional |
| Trial expiring | 3-day warning + upgrade CTA | Lifecycle |
| Platform API degradation | Affected features + workaround | Operational |
| Data export ready | Download link (72h valid) | Transactional |
| Account deletion scheduled | Confirmation + 14-day cancel window | Transactional |
| ToS change | 30-day notice | Legal |
| Referral reward earned | Credit notification | Growth |
| AI credit low | Usage alert + top-up CTA | Lifecycle |

### 11B.2 SMS / Zalo Template Catalog (Optional — Pro+ tiers)
- MFA verification code
- Critical security alerts
- Payment failure alert (if email unresponsive)
- Live session starting reminder

### 11B.3 Email Infrastructure Rules
- Transactional email: dedicated sending domain (noreply@creativanta.com)
- Marketing email: separate sending domain (hello@creativanta.com)
- SPF, DKIM, DMARC records bắt buộc
- Bounce handling: auto-remove hard bounces, retry soft bounces 3x
- Unsubscribe: one-click List-Unsubscribe header (CAN-SPAM / GDPR)
- Marketing email frequency cap: max 2/week unless user opts in to more

### 11B.4 Notification Preference Center
- Per-channel toggles (email, push, in-app, SMS)
- Per-category toggles (transactional, lifecycle, marketing, operational)
- Digest option: daily summary instead of individual notifications
- Transactional emails: CANNOT be disabled (legal/security requirement)

---

## 11C. Product Analytics & Event Tracking Contract

### 11C.1 Analytics Event Taxonomy

| Category | Events | Purpose |
|---|---|---|
| **Acquisition** | signup_started, signup_completed, referral_clicked | Funnel measurement |
| **Activation** | onboarding_step_completed, first_publish, first_ai_generation | Time-to-value tracking |
| **Engagement** | feature_used, page_viewed, search_performed, workflow_created | Product usage patterns |
| **Retention** | session_start, session_end, daily_brief_viewed, task_completed | Stickiness measurement |
| **Revenue** | upgrade_started, upgrade_completed, addon_purchased, credit_purchased | Conversion tracking |
| **Churn** | downgrade_started, cancel_started, cancel_completed, data_export_requested | Risk identification |

### 11C.2 Event Schema
```
{
  "event_name": "feature_used",
  "timestamp": "ISO8601",
  "user_id": "anonymized_hash",
  "workspace_id": "anonymized_hash",
  "session_id": "...",
  "properties": {
    "feature": "script_lab",
    "module": "M06",
    "action": "ai_generate",
    "tier": "pro",
    "platform": "web"
  }
}
```

### 11C.3 Privacy Rules for Analytics
- User ID: anonymized hash (NOT raw user_id)
- PII: NEVER included in analytics events
- Cookie consent: analytics events ONLY fire after user consent (§4 Pack 07)
- Data retention: raw events 90 days, aggregated metrics indefinitely
- User opt-out: analytics stop immediately, historical data deleted within 30 days

### 11C.4 A/B Testing & Feature Flags
- Feature flag system: per-workspace, per-tier, per-user targeting
- A/B test assignment: consistent hashing per user
- Experiment evaluation: minimum sample size before significance declared
- Feature rollout: canary (1%) → beta (10%) → GA (100%)
- Kill switch: any feature can be disabled instantly via flag

### 11C.5 Growth Metrics Dashboard (M23)
Following metrics phải trackable:
- DAU/MAU ratio
- Activation rate (first publish within 7 days)
- Feature adoption per module
- Conversion funnel (Free → Starter → Pro)
- Referral viral coefficient (k-factor)
- AI credit utilization rate per tier
- Churn prediction score per workspace

---

## 12. Acceptance Scenario Inventory

Runtime/event backbone bắt buộc cover tối thiểu các scenario sau:
- publish path từ Publish Job → Queue Item → Approval Request → Publish Item → Publish Log → Channel Post sync
- approval gates cho publish, price/offer changes, reconciliation override, workflow/agent force actions
- refund/reconciliation events link đúng về order/commercial scope và proof/audit surfaces
- recipe install/publish và workflow/agent execution giữ idempotency, correlation và handoff context
- live/seeding events không làm mất continuity giữa live session, sample request, sample shipment và related commerce/thread objects
- diagnostics, dead-letter và manual repair luôn truy ngược được về canonical objects bị ảnh hưởng
- transactional emails delivered for all critical lifecycle events (signup, payment, security)
- analytics events fire only after consent, use anonymized IDs, respect opt-out
- feature flags support per-workspace, per-tier targeting with instant kill switch
- A/B test assignments consistent per user across sessions

---

## S03. Mode-Aware Notification Priorities (Supplementary)

> **Ref**: PRD §32C (Notification), Pack 03 §11A

### S03.1 Notification Priority Per Mode

| Notification Type | Creator | Seller | Affiliate | Agency | Brand Collab | Beginner |
|---|---|---|---|---|---|---|
| New order | Medium | 🔴 Critical | Medium | High | Low | Medium |
| Publish failed | 🔴 Critical | High | Medium | 🔴 Critical | 🔴 Critical | High |
| Comment/DM received | High | Medium | Low | Medium | Medium | High |
| Trend alert | 🔴 Critical | Low | High | Medium | Medium | Medium |
| Revenue milestone | High | High | High | High | High | 🔴 Critical |
| Platform degraded | High | 🔴 Critical | 🔴 Critical | 🔴 Critical | Medium | Low |
| Brand deal inquiry | Medium | Low | Low | High | 🔴 Critical | Low |
| Affiliate link broken | Low | Low | 🔴 Critical | Medium | Low | Low |
| Workflow failed | High | Medium | Medium | 🔴 Critical | Medium | Low |
| Payment received | High | 🔴 Critical | High | High | High | High |
| Team member action | Low | Low | Low | 🔴 Critical | Medium | Low |
| Commission earned | Low | Low | 🔴 Critical | High | Low | Medium |

### S03.2 Do-Not-Disturb Rules
- Custom schedule per user (e.g., 22:00-07:00 mute all except Critical)
- Critical notifications bypass DND (payment failures, security alerts)
- Batch digest option: summarize non-critical notifications hourly/daily
- Mobile: respect OS-level notification settings

### S03.3 Notification Copy Standards
- Max 80 chars for push notification title
- Max 160 chars for push notification body
- Always include: [actor] [action] [object] format
- Example: "Shopee · Đơn hàng mới #1234 · 150.000đ · [Xem đơn]"
- Vietnamese primary, English secondary (per user language setting)
