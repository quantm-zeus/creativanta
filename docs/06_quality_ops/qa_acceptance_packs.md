---
layer: quality_ops
canonical: true
source_file: impl_c1_qa_acceptance_packs.md
last_verified: 2026-03-30
---

# C1 — QA Acceptance Test Packs

> **Upstream**: Product Freeze (Acceptance Traceability), All Detail Design Packs

---

## 1. Test Path Matrix (Per Module)

Every module must pass 5 acceptance paths:

| Path | Description | Example |
|---|---|---|
| **Happy** | Full data, all connected, nominal flow | Script → Approve → Generate → Publish → Success |
| **Degraded** | Partial data, some connections degraded | Publish with degraded capability → manual fallback |
| **Missing Data** | Beginner state, empty workspace | New user, no connections → guided empty states |
| **Broken** | Error state with repair guidance | OAuth expired → repair wizard → reconnect |
| **Audit** | Full traceability trail verified | Every state change emits audit_event |

---

## 2. Module Test Summaries

### M01 Home
- Happy: Dashboard shows action cards, profit mini, pending items
- Degraded: Some connectors down → shows warning, still functional
- Missing: New user → onboarding wizard, setup checklist
- Broken: All connectors fail → full diagnostics panel
- Audit: Every card action logged

### M02-M04 Intelligence
- Happy: Trends detected, opportunities scored, conversion works
- Degraded: Some signal sources unavailable → confidence drops, shown
- Missing: No watchlists → suggest creation
- Broken: Crawler failures → diagnostics + manual entry
- Audit: Opportunity state changes traced

### M05-M06 Content Creation
- Happy: Idea → Script → Approval → Ready for production
- Degraded: AI generation fails → fallback provider
- Missing: No ideas → AI generator suggested
- Broken: AI timeout → retry with queue position
- Audit: Approval chain fully auditable

### M07 AI Studio
- Happy: Generate asset → review → approve → ready
- Degraded: Primary AI down → fallback provider auto-switch
- Missing: No character/pack → default settings
- Broken: Generation stuck → cancel + retry + DLQ
- Audit: Credit deduction traced per generation

### M08 Continuity OS
- Happy: Create character → attach voice → generate with continuity → asset matches character/brand spec
- Degraded: Primary voice provider down → fallback voice used, quality warning shown
- Missing: Character pack incomplete (no voice) → generation blocked with specific missing-field message
- Broken: Drift detection finds high divergence → asset flagged, re-generation offered
- Audit: Digital Twin consent verification → consent record logged, EU AI Act metadata attached

### M09 Asset Derivatives
- Happy: Generate → derive clips/thumbnails/text → all derivatives linked to parent with lineage
- Degraded: Batch derivative (100+ items) partial failure → successful items complete, failures queued for retry
- Missing: Source asset deleted (soft) → derivatives show orphan warning, cannot promote
- Broken: Lineage chain broken (parent missing) → block packaging transition per RULE-M09-001
- Audit: Derivative promotion to standalone asset → lineage preserved, new asset_id generated

### M10-M11 Publish
- Happy: Package QA → schedule → publish → success
- Degraded: Platform API slow → retry with backoff
- Missing: No connected accounts → guide to connect
- Broken: Publish fails all retries → DLQ → manual fallback + export
- Audit: Publish logs immutable, capability snapshot preserved

### M12 Engagement
- Happy: Thread received → AI intent → triage → reply → resolve
- Degraded: Some platforms no DM API → manual note
- Missing: No threads → encourage publishing
- Broken: Sync failure → stale data warning + manual refresh
- Audit: All replies logged with author

### M13-M16 Commerce
- Happy: Product → offer → affiliate link → order imported → reconciled
- Degraded: Platform API returns partial data → confidence=low shown
- Missing: No products → import wizard
- Broken: Order sync fails → DLQ + manual import CSV option
- Audit: Order lifecycle fully traced

### M17 Live Commerce War Room
- Happy: Plan → Go Live → Pin offers → End → Post-live proof document generated with revenue data
- Degraded: WebSocket reconnect during live session → auto-reconnect <3s, no data loss
- Missing: No product pinned during session → summary generated with content-only metrics
- Broken: Platform stream disconnect → session paused, reconnect attempted, manual fallback offered
- Audit: Highlight marked during session → highlight timestamp + clip marked for M09 derivatives

### M18 Seeding CRM
- Happy: Create sample request → ship → track → log outcome → cost recorded to M19, proof generated
- Degraded: Shipping API unavailable → manual tracking fallback, status updated manually
- Missing: Outcome not logged within SLA → follow-up task auto-created per RULE-M18-005
- Broken: Duplicate sample request for same product+creator → dedup detection, merge or reject
- Audit: Sample cost exceeds budget threshold → alert to workspace owner, approval required

### M19 Profit OS
- Happy: Revenue → fees → costs → net profit with high confidence
- Degraded: Some costs estimated → confidence=medium, gaps shown
- Missing: No settlements → guide to connect commerce platforms
- Broken: Reconciliation conflict → queue for manual review
- Audit: Every override logged with reason

### M20-M21 Workflow
- Happy: Trigger → execute → complete → side effects recorded
- Degraded: External action fails → partial success + diagnostics
- Missing: No workflows → recipe suggestions
- Broken: Flow stuck → timeout → DLQ → manual intervention
- Audit: All workflow runs logged with I/O

### S16 Creator Pro Tools
- Happy: Link-in-bio created → clicks tracked → analytics visible
- Degraded: AI media kit generation slow → queued, user notified
- Missing: No brand deals → suggest features
- Broken: Rate card AI fails → fallback to manual entry
- Audit: Deal status changes, media kit generation credited

### help / S19 Customer Support
- Happy: Bug report → ticket → AI classify → agent assign → resolve → survey
- Degraded: AI chatbot confidence low → escalate to human
- Missing: No tickets → help center suggests articles
- Broken: Support system down → email fallback
- Audit: SLA tracking, escalation chain, satisfaction scores

### S26 Internal Admin (admin.creativanta.app)
- Happy: Admin login → MFA → dashboard loads → actions work
- Degraded: Monitoring system partial → show available data
- Missing: No incidents → clean dashboard
- Broken: Admin site unavailable → VPN failover
- Audit: ALL admin actions logged to immutable audit_events

---

## 3. Cross-Module Integration Tests

| Test | Modules | Verification |
|---|---|---|
| Full content loop | M02→M05→M06→M07→M10→M11 | Trend → published content |
| Commerce loop | M13→M14→M16→M19 | Product → offer → order → profit |
| Thread conversion | M12→M14→M16 | Comment → offer → affiliate link |
| Workflow automation | M20→M11→M12 | Auto-publish → auto-reply workflow |
| Approval chain | M06→M07→M11 | Multi-step approval + audit |
| Credit lifecycle | M23→M07 | Credit deduction → warning → block |
| Refund flow | M13→M19→M23 | Order → refund → settlement → profit recalc |
| Admin moderation | S26→M07→D2 | Content flagged → admin reviews → action → notify |
| Support escalation | help→S26→D2 | Ticket → SLA breach → admin alert → resolve |
| Creator Pro loop | S16→M19→M23 | Brand deal → revenue → profit attribution |
| Admin impersonation | S26→M01 | Login → impersonate → see user view → end |
| Subscription lifecycle | M23→Stripe | Trial → payment → renew/cancel → downgrade |

---

## 4. Non-Functional Tests

| Test | Tool | Criteria |
|---|---|---|
| Load test | k6 | See C3 targets |
| Accessibility | axe-core, Lighthouse | WCAG 2.1 AA |
| Accessibility implementation contract | Manual + shared-spec review | Must follow `06_quality_ops/accessibility_spec.md` and shared screen specs |
| Mobile responsiveness | BrowserStack | iOS Safari, Android Chrome |
| i18n | Manual | All strings translated, no hardcoded text |
| Security | OWASP ZAP, cargo audit | No critical/high findings |
| Admin site security | Manual | VPN-only, MFA required, audit trail |

---

## 5. Extended Feature Acceptance Scenarios (Audit v5 — M6)

> **Ref**: Pack 04 §9.5-9.16, Pack 08 §3.4, PRD §37.3, Freeze §46A.8

### AI Remix Studio (Pack 04 §9.5)
| Test | Input | Expected Output | Verification |
|---|---|---|---|
| Originality pass | Reference video → remix with originality score 85% | Remix generated, asset created | `originality_score > 70` |
| Originality fail (blocked) | Reference video → remix with similarity 60% | Remix BLOCKED, credits NOT deducted | Error returned with suggestions |
| Script 0% copy | Deep copy of transcript | Generation blocked at Phase 2 | `transcript_similarity = 0%` enforced |
| Rate limit (anti-abuse) | 21st remix in same day | Request rejected | `429 Too Many Requests` |
| Mass-cloning flag | >50 remixes/week from unique sources | Auto-flag for review | Admin moderation case created |

### Credit Reservation (Pack 08 §3.4)
| Test | Input | Expected Output | Verification |
|---|---|---|---|
| Reserve → commit (normal) | 8 credits reserved, 6 actually used | 6 deducted, 2 returned | `balance = initial - 6` |
| Reserve → release (AI failure) | 8 credits reserved, AI fails | All 8 restored | `balance = initial` |
| Reserve → timeout | Held, never submitted for 30min | DB sweeper releases once | Cache loss does not affect correctness |
| Unknown provider timeout | In-flight result unknown at lease expiry | Reconciling, hold retained; status probe | No repeat submit/debit; manual escalation after 24h |
| Insufficient balance (hard block) | Request 10 credits with 5 balance | Request rejected immediately | `credits_exhausted` error |
| Concurrent reservations | 2 simultaneous requests, enough for 1 | First succeeds, second blocked | No negative balance possible |

### Product Showcase Batch (Pack 04 §9.6)
| Test | Input | Expected Output | Verification |
|---|---|---|---|
| Full batch success | 5 products, spin_360 style | 5 videos generated | All `showcase_job.status = completed` |
| Partial batch failure | 5 products, 2 missing images | 3 succeed, 2 fail | `partially_completed`, credits for 3 only |
| Empty product images | Product with no images uploaded | Job fails gracefully | Error: "Product requires images" |
| Character + product | Product with review_style + character | Video with AI presenter | Character referenced in output |

### Gamification Challenges (PRD §37.3)
| Test | Input | Expected Output | Verification |
|---|---|---|---|
| Challenge completion | User reaches target_value | `completed = true`, credits awarded | `reward_credited = true` |
| Duplicate completion attempt | Same challenge completed twice | Second attempt → no double credit | UNIQUE constraint prevents |
| Weekly rotation | Monday 00:00 UTC+7 | Old challenges archived, new ones active | `challenge_definitions.is_active` toggled |
| Max 3 active challenges | Admin creates 4th concurrent challenge | 4th challenge queued for next week | Validation error or auto-schedule |
| Streak reset | User misses a day | Streak counter resets to 0 | `creator_progress.streak_count = 0` |

### Link-to-Video Scraping (Pack 04 §9.9)
| Test | Input | Expected Output | Verification |
|---|---|---|---|
| Shopee URL → video | Valid Shopee product URL | Product data scraped, video generated | `platform_detected = 'shopee'` |
| Anti-bot blocked URL | URL returns 403 | Scrape fails → manual input fallback | UI shows manual data form |
| Invalid URL | Non-product URL (e.g., blog post) | Scrape returns insufficient data | Error: "Could not detect product" |
| Price change after scrape | Price changes between scrape and publish | Disclaimer added: "Price at time of creation" | Disclaimer visible in output |

### Content Repurpose Pipeline (PRD §36)
| Test | Input | Expected Output | Verification |
|---|---|---|---|
| Full pipeline (all enabled) | 10-min video, all outputs enabled | 50+ content pieces (clips, posts, thumbnails, blog, audio, captions) | All output types present |
| Free tier video limit | 6-min video on Free tier (max 5min) | Rejected | Error: "Video exceeds tier limit" |
| All outputs are drafts | Pipeline completes | All publish_items have `status = draft` | No auto-publish |
| Partial pipeline (clips only) | Config: only auto_clips enabled | Only clips generated | Other output types empty |

### AB Testing Engine (Pack 04 §9.15)
| Test | Input | Expected Output | Verification |
|---|---|---|---|
| 2-variant test start | Source asset → 2 variants published | Experiment running, metrics tracked | `status = running` |
| Auto-winner detection | Variant A gets 3x engagement after 48h | Winner auto-declared | `winner_asset_id` set |
| Manual winner override | User manually picks winner | Winner updated | `status = completed` |
| Experiment cancelled | User cancels running test | Test stopped, no winner | `status = cancelled` |

### Voice Cloning (Pack 04 §12B)
| Test | Input | Expected Output | Verification |
|---|---|---|---|
| Clone with consent | Audio samples + consent checkbox | Voice clone requested from provider | `consent_record_id` linked |
| Clone without consent | Audio samples, no consent | Request blocked | Error: "Voice cloning requires consent" |
| Clone quality check | Provider returns quality_score < threshold | Warning shown to user | Quality score visible |
| Clone in generation | Clone voice used in video generation | Video uses cloned voice | `character.voice_clone_id` referenced |

## 6. Mandatory phase integrity packs (2026-10-29)

- P0: direct tenant-junction reads, foreign-parent writes, missing context, runtime superuser/BYPASSRLS refusal, TRUNCATE denial, non-owner workspace discovery, internal-note/user-directory denial, membership revocation and delayed/reordered Clerk webhooks.
- Credit fixtures and state outcomes: [Credit accounting](../04_contracts/credit_accounting_contract.md).
- Finance fixtures F01–F09 and exact expected arithmetic: [Financial computation](../04_contracts/financial_computation_contract.md).
- Async process-kill/replay/unknown-side-effect fixtures: [Queue design](../05_system/queue_retry_design.md).
- Each phase: all delivered feature paths plus explicit later-phase scope; all original scope items must have accepted evidence by P8. [Build execution](../00_index/BUILD_EXECUTION_CONTRACT.md) owns packets/gates.
- Release: business endpoint failures must fail the smoke script; cold restore and rollback use the exact tested artifacts. Provider approvals and Enterprise embedding rights require actual evidence; fixtures cannot create them.
