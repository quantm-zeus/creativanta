---
layer: features
module: M06
canonical: true
domain: content
status: READY
last_updated: 2026-03-30
---

# Feature: Script Lab (M06)

## Purpose

An idea without a script is just a thought; a script without structure, approval, and production handoff is just a text file. Creators need a structured environment to transform ideas into **production-ready scripts** with scenes, shots, CTAs, disclosure blocks, and channel-specific rewrites — all governed by an explicit approval workflow to maintain content quality and compliance.

M06 exists to be the **structured authoring and approval gateway** between ideation (M05) and production (M07). It enforces that every script has a clear lifecycle (`draft → approved/rejected`), links back to its idea, and produces an Asset Brief that feeds the AI production pipeline with all necessary context (continuity refs, format targets, platform-specific parameters).

## Scope

### Covers
- Script authoring (scenes, shot lists, CTA blocks, disclosure blocks)
- Script lifecycle state machine (draft → in_review → approved/revision_required → ready_for_production → archived)
- Approval state machine (not_submitted → pending_approval → approved/rejected)
- Rejection MUST include reason text
- Channel rewrite logic (TikTok vs YouTube vs Reels)
- Format templates (short_form, long_form, live, review, tutorial)
- Script → Asset Brief conversion
- Duration targeting with per-scene breakdown
- Script compare (diff between versions)
- Continuity reference attachment (Character Pack, Brand Pack)
- Mobile review and approval

### Does NOT cover (Non-goals for this module)
- Idea creation and scoring (owned by M05)
- AI video/image generation from scripts (owned by M07)
- Continuity pack management (owned by M08)
- Asset quality scoring and packaging (owned by M10)
- Publishing and scheduling (owned by M11)

## Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Creator/Editor | Contributor+ | Draft scripts, add scenes/shots/CTAs, request approval |
| Manager/Admin | Manager+ | Approve/reject scripts, provide rejection reasons, assign revisions |
| Seller | Editor+ | Create product-focused scripts (review, showcase, comparison) |
| System (AI) | System | Generate channel rewrites, suggest CTAs, estimate duration, check disclosure requirements |

## Business Rules

1. **RULE-M06-001**: Script lifecycle MUST follow the defined state machine — `lifecycle_state` tracks creation progress, `approval_state` tracks review progress. These are two independent state machines that both must be in valid terminal states before production handoff (PRD §23.6, DB schema §6.4: separate `lifecycle_state` and `approval_state`).
2. **RULE-M06-002**: Script rejection (`approval_state = 'rejected'`) MUST include a `rejection_reason` text field. Empty rejection reasons are forbidden — the system MUST validate that a reason ≥10 characters is provided before accepting the rejection (PRD §23.6 AC, Pack 02 §9.2).
3. **RULE-M06-003**: Every script MUST reference its source idea via `idea_id` FK. Orphan scripts without an idea reference are permitted ONLY when created directly from an Opportunity conversion (M04 → M06), in which case `idea_id` may be NULL but `continuity_refs` or creator context must be present (DB schema §6.4, Pack 02 §9.2).
4. **RULE-M06-004**: Channel rewrite MUST produce a platform-specific variant of the script while preserving core message and continuity. Rewritten scripts share the same `idea_id` but differ in `format_type`, `duration_target_seconds`, and `publish_target_profiles`. Each rewrite is a separate script row, not a version of the same script (PRD §23.6: "channel rewrites").
5. **RULE-M06-005**: Script → Asset Brief conversion MUST populate: `output_type`, `target_format` (aspect ratio), `target_duration_seconds`, `target_platforms`, `continuity_requirements`, `brand_voice_requirements`, and `production_instructions`. The Asset Brief status MUST start as `'draft'` and transition to `'ready'` only when all required fields are populated (DB schema §6.5).
6. **RULE-M06-006**: `script.ready_for_production` event MUST only be emitted when BOTH `lifecycle_state = 'ready_for_production'` AND `approval_state = 'approved'`. This event triggers M07 to make the script available for AI generation (Domain event catalog §4).
7. **RULE-M06-007**: Disclosure blocks MUST be auto-suggested based on the script's `offer_product_hooks` (commercial content → disclosure required) and target platform policies. The user may dismiss but the system MUST log the dismissal (PRD §23.6: "disclosure insertion").

## Main Flow

1. **Script created**: from idea conversion (M05) or direct creation
   - calls `ScriptService/Create` (Contributor+)
   - writes to `scripts` table with `idea_id`, `title`, `format_type`, `body` (structured scenes)
   - `lifecycle_state = 'draft'`, `approval_state = 'not_submitted'`
   - emits `script.created`
   - see [04_contracts/api_endpoint_map.md#2.3](../04_contracts/api_endpoint_map.md)
2. **User authors scenes**: populates `body` JSONB with scene array `[{scene_id, content, notes, duration_target}]`
   - Adds CTA blocks and disclosure blocks
   - Attaches continuity refs (Character Pack, Brand Pack)
   - Sets `duration_target_seconds` and `publish_target_profiles`
3. **User submits for approval**: calls `ScriptService/SubmitApproval` (Editor+)
   - `lifecycle_state = 'in_review'`, `approval_state = 'pending_approval'`
   - emits `script.submitted_for_approval` → notification to assigned reviewer
4. **Reviewer approves**: calls `ScriptService/Approve` (Manager+)
   - `approval_state = 'approved'`, `approved_by` set
   - emits `script.approved` → unblocks M07/M10
5. **OR Reviewer rejects**: calls `ScriptService/Reject` (Manager+)
   - `approval_state = 'rejected'`, rejection reason stored
   - `lifecycle_state = 'revision_required'`
   - emits `script.rejected` → notification to author
   - Author revises → re-submits (step 3)
6. **Script → Asset Brief**: user triggers conversion
   - Creates `asset_briefs` row with script reference and production specs
   - emits `script.ready_for_production` (only when both states are terminal-valid)
7. **Channel rewrite**: user requests platform-specific rewrite (e.g., TikTok → YouTube)
   - AI rewrites preserving core message, adjusting duration/pacing/CTA for target platform
   - New script row created with same `idea_id`, different `format_type` and `publish_target_profiles`

## Alternate Flows

### A1: Direct Creation Without Idea
- Trigger: User creates script directly from Opportunity (M04) or from blank
- Steps: Script created with `idea_id = NULL`. System prompts to link continuity refs for context.
- Result: Valid script, though provenance tracking to original idea is absent

### A2: Bulk Channel Rewrite
- Trigger: User requests rewrites for 3 platforms simultaneously (TikTok, YouTube Shorts, Reels)
- Steps: AI generates 3 rewrite variants. Each becomes a separate script row sharing the same `idea_id`. User reviews each variant independently.
- Result: 3 platform-optimized scripts ready for independent approval

### A3: Script Compare
- Trigger: User wants to compare current version vs previous submission
- Steps: System loads current and previous `body` JSONB. Visual diff highlights changes per scene.
- Result: Side-by-side comparison with change markers

## Edge Cases

### EC-M06-001: Approval Without Complete Scenes
- Condition: Editor submits a script for approval that has empty scene content (body has scene entries but `content` fields are blank)
- Expected behavior: System blocks submission with validation error: "Script has [N] empty scenes. Complete all scene content before submitting for approval." `approval_state` remains `'not_submitted'`.
- Reference: PRD §23.6 (approval state rõ ràng)

### EC-M06-002: Rejection Without Reason
- Condition: Manager calls `ScriptService/Reject` with empty or very short reason text (<10 chars)
- Expected behavior: System returns 422 validation error: "Rejection reason must be at least 10 characters. Please provide specific feedback." Script remains in `pending_approval` state.
- Reference: RULE-M06-002, Pack 02 §8.1

### EC-M06-003: Concurrent Approval and Edit
- Condition: Author edits the script body while a Manager is reviewing the same script
- Expected behavior: If Manager approves, approval applies to the version at approval time (optimistic concurrency via `updated_at`). If the author saved changes after the Manager loaded the script, the Manager gets a 409 Conflict: "Script was updated since you started reviewing. Please reload."
- Reference: Pack 02 §8.2 (state transition validation)

### EC-M06-004: Channel Rewrite Produces Disclosure-Required Content
- Condition: Original script is non-commercial, but TikTok rewrite auto-inserts product hooks from `offer_product_hooks` based on campaign context
- Expected behavior: System auto-suggests disclosure block for the rewritten script. If user dismisses, the system logs the dismissal with timestamp and reason. FE shows a "⚠️ Disclosure recommended" badge on the rewritten script.
- Reference: RULE-M06-007, PRD §23.6 (disclosure insertion)

## State Machine

Object: script | DB columns: `scripts.lifecycle_state` + `scripts.approval_state`
see [04_contracts/database_schema.md#6.4](../04_contracts/database_schema.md)

### Lifecycle State Machine

| From | To | Trigger | Condition |
|---|---|---|---|
| — | draft | Script created | `title` populated |
| draft | in_review | User submits for approval | Body has ≥1 scene with content |
| in_review | approved | (synced from approval_state) | `approval_state = 'approved'` |
| in_review | revision_required | Reviewer rejects | `approval_state = 'rejected'` |
| revision_required | in_review | Author re-submits | Updated body |
| approved | ready_for_production | Asset Brief created | Asset brief linked + complete |
| any | archived | User archives | Any |
| archived | draft | User un-archives | Any |

### Approval State Machine

| From | To | Trigger | Condition |
|---|---|---|---|
| — | not_submitted | Script created | Default |
| not_submitted | pending_approval | User submits | `lifecycle_state` must be valid |
| pending_approval | approved | Manager approves | `approved_by` set |
| pending_approval | rejected | Manager rejects | `rejection_reason` ≥ 10 chars |
| rejected | pending_approval | Author re-submits | Updated content |

## Related Contracts

| Topic | File | Section |
|---|---|---|
| DB tables | [04_contracts/database_schema.md](../04_contracts/database_schema.md) | §6.4 (scripts), §6.5 (asset_briefs), §6.6 (scenes, shot_lists) |
| API | [04_contracts/api_endpoint_map.md](../04_contracts/api_endpoint_map.md) | §2.3 (ScriptService: Create, Get, Update, SubmitApproval, Approve, Reject) |
| Events | [04_contracts/domain_event_catalog.md](../04_contracts/domain_event_catalog.md) | §4 (script.created, script.submitted_for_approval, script.approved, script.rejected, script.ready_for_production) |
| RBAC | [04_contracts/rbac_permission_matrix.md](../04_contracts/rbac_permission_matrix.md) | §2.3 (script:create — Contributor+; script:submit — Editor+; script:approve/reject — Manager+) |

## Related Screens

| Platform | Screen | Notes |
|---|---|---|
| Web | Script Editor | Scene-based body editor, CTA/disclosure blocks, continuity ref selector |
| Web | Script Approval Queue | Filterable by status, reviewer assignment, approval CTA |
| Web | Script Compare | Side-by-side diff view for version comparison |
| Mobile | Script review + approve/reject | Read-only body view, approve/reject actions, comment |

## Acceptance Criteria

1. **Given** a Manager types "No" as the only rejection reason (3 characters), **when** they submit the rejection, **then** the system MUST return a validation error requiring at least 10 characters — the script's `approval_state` MUST remain `'pending_approval'`.

2. **Given** a script with `lifecycle_state = 'approved'` and `approval_state = 'approved'`, **when** the user creates an Asset Brief from this script, **then** the system MUST emit `script.ready_for_production` with `{script_id, asset_brief_id}` — and the Asset Brief MUST contain `script_id`, `output_type`, `target_format`, and `continuity_requirements`.

3. **Given** a script created from an idea (M05), **when** the script detail page is loaded, **then** the page MUST display a "Source Idea: [idea title]" link that navigates to the idea detail — confirming the `idea_id` FK is populated.

4. **Given** a user requests a TikTok → YouTube channel rewrite, **when** the rewrite completes, **then** a new, separate script row MUST be created with the same `idea_id`, `format_type = 'long_form'`, adjusted `duration_target_seconds`, and YouTube-specific `publish_target_profiles`.

5. **Given** a script with commercial `offer_product_hooks` and no disclosure blocks, **when** the user submits for approval, **then** the system MUST auto-suggest a disclosure block — and if the user dismisses, the dismissal MUST be logged with actor and timestamp.

## Open Questions / Blockers

- [NONE] — No critical blockers specific to M06 in OPEN_BLOCKERS.md.
