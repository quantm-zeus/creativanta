---
layer: features
module: M21
canonical: true
domain: automation
status: DRAFT
last_updated: 2026-03-30
blockers:
  - API-M-001
---

# Feature: Recipe & Agent Center (M21)

## Purpose

Building workflows from scratch requires understanding triggers, conditions, actions, and platform nuances. Most operators want to start with a "recipe" — a pre-built workflow template for common patterns like "auto-reply to purchase inquiries" or "weekly content performance digest." Beyond templates, operators need intelligent agents that can plan multi-step actions, observe outcomes, and adapt — going beyond static if/then automation.

M21 exists as the **recipe marketplace and agent runtime center** — managing recipe discovery, installation, customization, and the agent planning/execution lifecycle. Every installed recipe MUST map to canonical workflow objects (M20), and every agent action MUST preserve auditability — recipes and agents are convenience layers, not escape hatches from the system's truth guarantees.

## Scope

### Covers (M21 owns recipe marketplace + agent runtime)
- Recipe marketplace: browse, search, install, rate, review pre-built workflow templates
- Recipe installation: install recipe → creates canonical workflow (M20) with user configuration
- Recipe lifecycle: published → installed → customized → updated → deprecated
- Agent runtime: AI agents that plan and execute multi-step actions
- Agent lifecycle: planned → awaiting_approval → executing → observing → handed_off → completed / failed
- Agent safety: permission checks, capability checks, approval gates for agent actions
- Agent memory: temporary agent context that does NOT override canonical truth
- Recipe governance: submission review, revenue share (70/30), DMCA/takedown (S22)

### Does NOT cover (M21 boundaries)
- **M20 owns**: workflow runtime execution (M21 installs recipes → M20 runs them)
- **M22 owns**: capability data (M21 queries, M22 provides)
- Workflow visual builder: M20 provides the builder; M21 provides the templates
- Independent AI model management: M21 uses system AI providers, doesn't manage models

## Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Recipe Consumer | Editor+ | Browse marketplace, install recipes, customize parameters, run agents |
| Recipe Creator | Pro+ | Build recipe templates, submit to marketplace, manage versions |
| Manager | Manager+ | Approve agent plans, configure agent permission scope, manage installed recipes |
| System (Marketplace) | System | Automated recipe scanning (malware, policy, quality), rating aggregation |
| System (Agent Runtime) | System | Agent planning, execution, observation, evidence collection, handoff |

## Business Rules

1. **RULE-M21-001**: **Installed recipes MUST map to canonical workflow objects.** When a recipe is installed, it creates a standard M20 workflow with the recipe's trigger, conditions, and actions. The installed workflow is fully editable by the user — it is NOT a black box. Recipe updates can be applied (user chooses: auto-update or pin to version), but the underlying workflow remains a standard M20 object (Pack 03 §9, PRD §23.21 AC).
2. **RULE-M21-002 (CRITICAL)**: **Recipes and agents MUST NOT break auditability.** Every action executed by a recipe-installed workflow or by an agent MUST produce the same audit trail as manually-triggered actions. Agent actions require: permission check, capability check (M22), audit requirement check, policy check, and optional approval gate. No "agent shortcut" that bypasses these checks (Pack 03 §5.2, §10).
3. **RULE-M21-003**: Agent memory is **temporary and non-canonical**. Agent planning context, intermediate observations, and working memory do NOT override the canonical graph. For any agent observation to become truth, it MUST be written through the appropriate aggregate owner via a standard action (emit event + write). Agent memory is session-scoped and discarded after run completion (Pack 03 §5.3).
4. **RULE-M21-004**: Agent lifecycle: `planned → awaiting_approval (if required) → executing → observing → handed_off / completed / failed`. Agent plans MUST be reviewable before execution for actions above a configurable risk threshold. High-risk actions (publish, price change, external communication) require explicit approval (Pack 03 §5.1, §6.1).
5. **RULE-M21-005**: Recipe installation requirements: workspace eligibility check (plan tier supports recipe's required features), capability availability (platform connectors required by recipe exist), dependency conflicts (recipe doesn't conflict with existing workflows), required permissions (user has permissions for recipe's actions) (Pack 03 §9.2).
6. **RULE-M21-006**: Recipe marketplace governance follows S22: 70/30 revenue share (creator/platform), 3-business-day review SLA, DMCA takedown within 48h, 3-strike policy, version updates with breaking change flags, 7-day refund window (Pack 06 §S22).

## Main Flow

### Recipe Flow

1. **Browse marketplace**: Operator searches recipes by category, rating, capability requirement
   - Categories: content, commerce, engagement, analytics, productivity
   - Filtering: platform requirements, plan tier compatibility, rating
2. **Install recipe**: Operator installs recipe into workspace
   - System checks: eligibility, capabilities, dependencies, permissions (RULE-M21-005)
   - If checks pass: recipe creates canonical M20 workflow
   - User configures parameters (e.g., threshold values, notification targets, schedule)
   - `recipe.installed` event emitted
3. **Customize**: Operator edits the installed workflow
   - Full access to M20 workflow builder — recipe is not locked
   - Customizations tracked as user modifications (separate from recipe template)
4. **Update handling**: Recipe creator publishes update
   - User notified: "Recipe [X] has an update available"
   - Breaking changes flagged explicitly
   - User chooses: apply update, pin to current version, or review diff first

### Agent Flow

1. **Agent activation**: Operator triggers agent for a task
   - "Analyze my top 10 performing videos and create scripts for similar content"
   - Agent enters `planning` phase
2. **Planning**: Agent creates action plan
   - Plan: list of steps with target modules, expected side effects, permission requirements
   - Plan visible to operator for review
   - `agent_run.planned` event
3. **Approval (if required)**: Manager reviews plan
   - High-risk actions highlighted
   - Manager approves, modifies, or rejects plan
   - `agent_run.awaiting_approval` → `agent_run.approved` or `agent_run.rejected`
4. **Execution**: Agent executes approved plan step by step
   - Each action: permission check → capability check → execute → log → observe
   - `agent_run.executing` state
   - Side effects logged with full audit trail (same as manual actions)
5. **Observation**: Agent reviews action outcomes
   - Compare expected vs actual results
   - Agent memory updated (non-canonical, session-scoped)
   - If unexpected result: agent may re-plan or hand off
6. **Completion or handoff**: Agent finishes
   - Success: `agent_run.completed`, results summary presented
   - Needs human: `agent_run.handed_off`, context preserved for operator
   - Failure: `agent_run.failed`, diagnostics record created

## Alternate Flows

### A1: Recipe Compatibility Failure
- Trigger: User attempts to install recipe requiring Shopee connector but workspace has no Shopee connected
- Steps: System checks capabilities → fails on `shopee.order.sync` requirement → installation blocked with explanation: "This recipe requires a Shopee connected account. [Connect Shopee] or [Browse alternatives]."
- Result: No broken installation; user guided to resolution

### A2: Agent Action Rejected by Capability Check
- Trigger: Agent plans to publish to TikTok but TikTok capability is `unsupported` for the required action
- Steps: Agent runtime queries M22 → capability check fails → agent receives "TikTok [action] currently unsupported" → agent re-plans around limitation OR hands off to operator with explanation
- Result: Agent respects capability constraints; no silent failures

### A3: Recipe Version Conflict with Breaking Change
- Trigger: Recipe creator publishes v2.0 with renamed parameters
- Steps: User notified with breaking change flag → diff view shows changes → user can: apply update (system migrates parameters where possible), pin to v1.x, or review and manually adjust
- Result: No silent breaking updates; user controls version adoption

## Edge Cases

### EC-M21-001: Agent Attempts Unauthorized Action
- Condition: Agent plan includes an action the user doesn't have permission for
- Expected behavior: During planning phase, permission check flags the action. Agent plan shows: "⚠️ Step 3: [Action] — requires Manager+ permission. You have Editor role." Agent cannot proceed with that step — it either skips (if optional) or halts plan with explanation. Agent NEVER escalates its own permissions.
- Reference: RULE-M21-002

### EC-M21-002: Installed Recipe's Underlying Workflow Manually Deleted
- Condition: User deletes the M20 workflow that was created from recipe installation
- Expected behavior: Recipe installation record shows `status = 'workflow_deleted'`. Recipe can be reinstalled (creates new workflow). Dashboard notification: "Recipe [X] workflow was removed. [Reinstall] to restore."
- Reference: RULE-M21-001

### EC-M21-003: Agent Memory Grows Large During Long Run
- Condition: Agent run persists for 30+ minutes with large observation context
- Expected behavior: Agent memory has configurable size limit (default: 50MB). When approaching limit: agent summarizes older observations (compresses context). At hard limit: agent pauses and offers handoff with current context summary. Memory is ALWAYS discarded after run completion — never persisted as canonical data.
- Reference: RULE-M21-003

## State Machine

### Agent Run Lifecycle

Object: agent_run | DB column: `agent_runs.status`

| From | To | Trigger | Condition |
|---|---|---|---|
| — | planned | Agent creates plan | Task + plan generated |
| planned | awaiting_approval | Plan requires approval | High-risk actions in plan |
| planned | executing | Plan auto-approved | No high-risk actions OR Manager pre-approved |
| awaiting_approval | executing | Manager approves | Approval granted |
| awaiting_approval | failed | Manager rejects | With rejection reason |
| executing | observing | Action completes | Agent evaluates result |
| observing | executing | Next action begins | More steps in plan |
| observing | handed_off | Agent can't auto-resolve | Human intervention needed |
| executing | completed | All actions succeed | Plan fully executed |
| executing | failed | Action fails (no recovery) | Diagnostics record created |
| handed_off | completed | Operator resolves | Manual completion after handoff |

### Recipe Installation State

| State | Description |
|---|---|
| installed | Recipe installed, workflow created and functional |
| customized | User has modified the installed workflow beyond recipe defaults |
| update_available | Recipe creator published new version |
| pinned | User pinned to specific version, ignoring updates |
| deprecated | Recipe creator or marketplace deprecated this recipe |
| workflow_deleted | Underlying workflow was manually deleted |

## Related Contracts

| Topic | File | Section |
|---|---|---|
| DB tables | [04_contracts/database_schema.md](../04_contracts/database_schema.md) | §13 (recipe_templates, agent_runs, agent_run_steps) |
| API | [04_contracts/api_endpoint_map.md](../04_contracts/api_endpoint_map.md) | §2.8 (Recipe/Agent — ~8 RPCs: Install, Run, Inspect) |
| Events | [04_contracts/domain_event_catalog.md](../04_contracts/domain_event_catalog.md) | §11 (recipe.installed, agent_run.planned, agent_run.completed, agent_run.failed, agent_run.handed_off) |
| RBAC | [04_contracts/rbac_permission_matrix.md](../04_contracts/rbac_permission_matrix.md) | §2.8 (recipe — Editor+ for install; agent — Editor+ for run, Manager+ for approval) |
| Pack 03 | [Pack 03 — Agent Runtime Contract](../creativanta_detail_design_pack_03_event_workflow_agent_runtime_contract_v_3_1.md) | §5 (Agent Runtime), §9 (Recipe Contract), §10 (Audit) |
| Pack 06 S22 | [Pack 06 — Recipe Governance](../creativanta_detail_design_pack_06_commerce_finance_proof_reporting_admin_contract_v_3_1.md) | §S22 (Marketplace governance, revenue share, DMCA) |

## Related Screens

| Platform | Screen | Notes |
|---|---|---|
| Web | Recipe marketplace | Browse, search, filter, install — rating, reviews, requirements shown |
| Web | Installed recipes | Per-workspace installed recipes with status, version, update availability |
| Web | Agent task launcher | Natural language input → agent plan preview → approve → execute |
| Web | Agent run inspector | Step-by-step execution view, observation results, audit trail, handoff context |
| Web | Recipe submission (Pro+) | Recipe builder, parameter schema editor, submission for review |
| Mobile | Quick recipe install | Compact marketplace, one-tap install for compatible recipes |
| Mobile | Agent results | Agent run summary, accept results or manual follow-up |

## Acceptance Criteria

1. **Given** a recipe is installed into a workspace, **when** the installation completes, **then** a canonical M20 workflow MUST exist with the recipe's trigger, conditions, and actions — the workflow MUST be fully editable via M20's workflow builder, NOT a black box.

2. **Given** an agent executes a plan with 5 steps, **when** each step completes, **then** every action MUST have the same audit trail as a manually-triggered action: actor (agent), action, affected objects, old/new state, timestamp, correlation_id — the agent MUST NOT bypass any permission or capability check.

3. **Given** a recipe requires Shopee connector capabilities, **when** a user without Shopee connected attempts to install it, **then** the installation MUST be blocked with a clear explanation: "This recipe requires Shopee. [Connect] or [Browse alternatives]."

4. **Given** an agent plan includes publishing content (high-risk action), **when** the plan is generated, **then** the plan MUST enter `'awaiting_approval'` state — a Manager+ MUST review and approve before execution proceeds.

5. **Given** an agent run completes, **when** the agent's working memory is inspected, **then** the memory MUST be session-scoped and non-canonical — no agent observation has been written directly to the canonical graph without going through the appropriate aggregate owner's write path.

## Open Questions / Blockers

> **⚠️ BLOCKER: API-M-001** — `04_contracts/api_endpoint_map.md` §2.8 lists Recipe/Agent with only ~8 high-level RPCs but lacks per-endpoint detail. Full `RecipeService` and `AgentService` RPC tables needed before implementation.
> See: [OPEN_BLOCKERS.md#API-M-001](../00_index/OPEN_BLOCKERS.md)
