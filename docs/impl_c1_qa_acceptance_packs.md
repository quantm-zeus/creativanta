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

### S19 Customer Support
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
| Support escalation | S19→S26→D2 | Ticket → SLA breach → admin alert → resolve |
| Creator Pro loop | S16→M19→M23 | Brand deal → revenue → profit attribution |
| Admin impersonation | S26→M01 | Login → impersonate → see user view → end |
| Subscription lifecycle | M23→Stripe | Trial → payment → renew/cancel → downgrade |

---

## 4. Non-Functional Tests

| Test | Tool | Criteria |
|---|---|---|
| Load test | k6 | See C3 targets |
| Accessibility | axe-core, Lighthouse | WCAG 2.1 AA |
| Mobile responsiveness | BrowserStack | iOS Safari, Android Chrome |
| i18n | Manual | All strings translated, no hardcoded text |
| Security | OWASP ZAP, cargo audit | No critical/high findings |
| Admin site security | Manual | VPN-only, MFA required, audit trail |
