---
layer: features
module: M10
canonical: true
domain: production
status: DRAFT
last_updated: 2026-03-30
---

# Feature: Packaging QA / Upload Copilot / Experiment Lab (M10)

## Purpose

A video can be technically perfect from M07 but fail commercially because the hook is weak, the CTA is missing, the caption has no hashtags, the disclosure is absent for a sponsored post, or the thumbnail doesn't match the brand. Creators who skip pre-publish quality checks suffer lower reach, compliance issues, and missed conversion opportunities.

M10 exists as the **pre-publish quality gate** that scores, validates, and optimizes content before it enters the publish pipeline (M11). It provides a structured packaging checklist, trust-critical compliance checks, experiment design (A/B testing infrastructure), and readiness assessment — ensuring no content goes out without passing the quality bar the creator sets.

## Scope

### Covers
- Packaging Score: composite quality score from hook/title/caption/CTA/disclosure components
- Component scores: Hook Score, Title Score, Caption Score, CTA Check, Disclosure Check, Coupon/Link Check
- Readiness checklist: per-platform requirements (character limits, aspect ratio, length, music copyright)
- Override policy: trust-critical checks require override reason
- A/B Experiment Lab: design experiments, create variants, track results
- Upload presets: saved configurations for recurring publishing setups
- Compliance scan: copyright, policy, platform rules
- QA panel mandatory on every publish attempt

### Does NOT cover (Non-goals)
- Content creation and AI generation (owned by M07)
- Derivative management (owned by M09)
- Publish execution and scheduling (owned by M11)
- Post-publish analytics and coaching (owned by M07 EF-09 Performance Coach)

## Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Creator | Editor+ | Run QA checks, fix gaps, override non-critical issues, design experiments |
| Manager | Manager+ | Override trust-critical checks with reason, review override audit log |
| System (QA) | System | Compute packaging score, run compliance scan, check readiness, evaluate experiment results |

## Business Rules

1. **RULE-M10-001**: Every publish attempt MUST have a packaging QA panel visible before execution. The QA panel MUST show: overall packaging score, per-component scores (hook, title, caption, CTA, disclosure, links), readiness checklist status, and compliance scan result. Users cannot skip the QA panel — it is rendered inline in the publish flow (PRD §23.10 AC).
2. **RULE-M10-002**: Trust-critical checks (disclosure for sponsored content, copyright for music/media, platform policy compliance) MUST require an explicit override reason (≥10 characters) from Manager+ if bypassed. The override MUST be logged with: actor, timestamp, override reason, and the specific check being bypassed. Overrides without reason are forbidden (PRD §23.10 AC).
3. **RULE-M10-003**: Packaging Score is a composite (0-100) computed from weighted component scores. Components and suggested weights:
   - Hook Score (25%): first 3s effectiveness, hook type matching trend patterns
   - Title Score (20%): SEO quality, keyword presence, character count compliance
   - Caption Score (20%): hashtag count/quality, caption length, engagement hooks
   - CTA Check (15%): CTA present, CTA placement, CTA clarity
   - Disclosure Check (10%): required disclosures present (sponsored, AI-generated, affiliate)
   - Link/Coupon Check (10%): links valid, coupons active, redirect chain healthy
   Scores below 50 show "⚠️ Below recommended quality." Scores below 30 show "🔴 Critical issues found."
4. **RULE-M10-004**: Every readiness gap and error MUST have EITHER a suggested fix action OR an override option. Dead-end errors with no actionable path are forbidden. Example: "Missing disclosure → [Add disclosure] or [Override (Manager+)]" (PRD §23.10 AC).
5. **RULE-M10-005**: Compliance scan results follow 4 classes: `pass`, `pass_with_warnings`, `review_required`, `blocked`. Blocked content MUST NOT proceed to M11 without Manager+ override. `review_required` generates notification to reviewer (Pack 04 §8.2).
6. **RULE-M10-006**: A/B Experiments MUST define: hypothesis, variant count (2-5), success metric (CTR/engagement/views), monitoring duration (24-72h), and auto-winner criteria. Experiments link to M07 EF-10 (Video A/B Testing) for variant generation and M11 for spread-schedule publishing.

## Main Flow

1. **User enters publish flow**: content selected → QA panel appears automatically
   - calls `PackagingService/Score` (Editor+)
   - System computes packaging score from component analysis
   - see [04_contracts/api_endpoint_map.md#2.4](../04_contracts/api_endpoint_map.md)
2. **QA panel display**: shows overall score + per-component breakdown + readiness checklist
   - 🟢 Pass items shown green
   - 🟡 Warning items shown yellow with suggested fix
   - 🔴 Blocked items shown red with required action or override path
3. **User fixes gaps**: applies suggested fixes (add CTA, add disclosure, fix hashtags)
   - Score recalculates in real-time as fixes applied
4. **Trust-critical override** (if needed): Manager+ provides override reason
   - Override logged with full audit trail
5. **Compliance scan**: calls `PackagingService/ScanCompliance` (Editor+)
   - Checks: copyright, content policy, platform rules, shadowban risk (S14.1)
   - emits `publish.packaging_scored` and `publish.compliance_scanned`
6. **Readiness confirmed**: all checks pass (or overridden) → content enters M11 publish queue

## Alternate Flows

### A1: A/B Experiment Design
- Trigger: User clicks "Create A/B Test" instead of direct publish
- Steps: Define hypothesis → select variant dimensions (hook/CTA/thumbnail/music) → M07 generates variants → set success metric → set monitoring duration → spread-schedule via M11
- Result: Experiment created, variants tracked, auto-winner selection after monitoring period

### A2: Upload Preset Application
- Trigger: User selects a saved upload preset (e.g., "TikTok Daily Post" preset)
- Steps: Preset auto-fills: target platform, format, hashtag template, disclosure template, CTA template. QA panel re-scores with preset values applied.
- Result: Faster publish setup, consistency across recurring publishing patterns

## Edge Cases

### EC-M10-001: Sponsored Content Without Disclosure
- Condition: Content references an offer/product hook (from `scripts.offer_product_hooks`) but has no disclosure block
- Expected behavior: QA panel shows 🔴 "Disclosure required for sponsored/commercial content. [Add disclosure] [Override (Manager+)]." If Editor tries to proceed without adding disclosure, system blocks. Only Manager+ can override with reason: explains why disclosure is not needed (e.g., "not sponsored, personal recommendation").
- Reference: RULE-M10-002, PRD §23.6 disclosure

### EC-M10-002: Music Copyright Detected During Scan
- Condition: Compliance scan identifies copyrighted music via ACRCloud fingerprint
- Expected behavior: QA panel shows 🔴 "Copyrighted music detected: [Song Name] by [Artist]. Platform [TikTok] may mute or remove. [Replace music] [Proceed at risk (Manager+ override)]." If user replaces music, rescan runs automatically.
- Reference: Pack 04 §9.2.8, S14.2

### EC-M10-003: QA Score Zero Due to Missing All Components
- Condition: User drags a raw, unpackaged video file to the publish flow with no title, caption, CTA, hooks, or packaging
- Expected behavior: Packaging score = 0. QA panel shows: "Content not packaged. [Set up with Upload Copilot]." Upload Copilot guides through minimum required fields in step-by-step wizard. User cannot override a score of 0 — minimum packaging is enforced.
- Reference: RULE-M10-001, RULE-M10-004

### EC-M10-004: Override Audit Trail Inspection
- Condition: Admin audits all overrides made in the last 30 days
- Expected behavior: System provides override audit log: date, actor, content, check bypassed, override reason, outcome. Overrides with outcomes that led to platform penalties are highlighted.
- Reference: RULE-M10-002

## Related Contracts

| Topic | File | Section |
|---|---|---|
| DB tables | [04_contracts/database_schema.md](../04_contracts/database_schema.md) | §8.1 (publish_items — packaging_score, compliance_scan_result, compliance_details) |
| API | [04_contracts/api_endpoint_map.md](../04_contracts/api_endpoint_map.md) | §2.4 (PackagingService: Score, ScanCompliance) |
| Events | [04_contracts/domain_event_catalog.md](../04_contracts/domain_event_catalog.md) | §6 (publish.packaging_scored, publish.compliance_scanned) |
| RBAC | [04_contracts/rbac_permission_matrix.md](../04_contracts/rbac_permission_matrix.md) | §2.4 (packaging:score — Editor+; packaging:override — Manager+) |
| Pack 05 | [Pack 05 — Publish Contract](../creativanta_detail_design_pack_05_connector_capability_publish_inbox_contract_v_3_1.md) | §4 (Publish inputs), §5 (Publish logs) |
| Shadowban | [Pack 05 — S14](../creativanta_detail_design_pack_05_connector_capability_publish_inbox_contract_v_3_1.md) | §S14.1 (Shadowban Risk Score), §S14.2 (Pre-Publish Content Scan) |

## Related Screens

| Platform | Screen | Notes |
|---|---|---|
| Web | QA Panel (inline in publish flow) | Score dashboard, component breakdown, fix CTAs, override controls |
| Web | Compliance Scan result | Horizontal card: pass/warning/blocked per check |
| Web | Experiment Lab (A/B design) | Hypothesis, variant dimensions, metric selection, monitoring config |
| Mobile | Quick readiness check | Simplified pass/fail checklist, quick fix, quick queue |

## Acceptance Criteria

1. **Given** a user enters the publish flow for any content, **when** the QA panel loads, **then** it MUST display: overall packaging score (0-100), per-component scores (hook, title, caption, CTA, disclosure, links), readiness checklist, and compliance scan status — the user MUST NOT be able to bypass this panel.

2. **Given** a compliance scan detects copyrighted music, **when** a Manager+ clicks override, **then** the system MUST require a reason ≥10 characters — and the override MUST be logged with actor, timestamp, check bypassed, and reason text.

3. **Given** content with `packaging_score < 30`, **when** the QA panel renders, **then** it MUST show "🔴 Critical issues found" — and every red item MUST have EITHER a suggested fix action OR an override path (never a dead-end).

4. **Given** a user creates an A/B experiment with 3 variants, **when** the experiment monitoring period ends (72h), **then** the system MUST auto-report the winner based on the defined success metric — and offer "Scale winner to more platforms."

5. **Given** a content item with commercial product hooks and no disclosure, **when** the QA panel scans, **then** it MUST flag the disclosure check as 🔴 blocked — only a Manager+ override with reason can allow it to proceed.

## Open Questions / Blockers

- [NONE] — No critical blockers specific to M10 in OPEN_BLOCKERS.md.
