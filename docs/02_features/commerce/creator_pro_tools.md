---
layer: features
module: S16
domain: commerce
status: READY
created: 2026-04-01
last_updated: 2026-04-02
canonical: true
upstream: PRD v3.1 §16, §37.1
---

# S16 — Creator Pro Tools

> **Upstream**: PRD §16, §37.1 (Content ROI), Pack 08 (Creator Economy)
> **DB tables**: `link_in_bio_pages`, `link_in_bio_items`, `media_kits`, `rate_cards`, `brand_deals`
> **Screens**: 10 (link-in-bio editor, media kit builder, rate card, brand deal pipeline, revenue tracker, tax export)

---

## 1. Purpose

Creator Pro Tools enables creators to monetize their personal brand through **Link-in-Bio pages**, **Media Kits**, **Rate Cards**, and **Brand Deal management** — all integrated with the Creativanta platform.

## 1.1 Scope

### Covers
- Link-in-Bio page builder with drag-and-drop items
- Link-in-Bio domain protection & anti-abuse (shared domain + custom domain)
- Media Kit auto-generation from connected platform analytics
- Rate Card management (per-platform, per-content-type pricing)
- Brand Deal pipeline (inquiry → payment tracking)
- Deliverable tracking with proof-of-work via `publish_items`
- Revenue Per Content Tracker with RPM tracking and UTM attribution
- Tax Report Export (monthly/quarterly/yearly)

### Does NOT cover (Non-goals for this module)
- Content creation or video production (owned by M08 AI Video Studio)
- Payment processing or invoicing (owned by external payment provider)
- Platform-specific creator program enrollment (external)
- Influencer marketplace / brand discovery (not in v1)
- Brand deal CRM pipeline (kanban), contract templates, brand marketplace (P2)

## 1.2 Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Creator | Editor+ | Build link-in-bio page, generate media kit, manage rate cards |
| Agency Manager | Manager+ | Manage brand deals, negotiate sponsorships, track payments |
| Sponsor | External | Submit inquiry via public form |
| System (AI) | System | Auto-generate media kit stats, score sponsor fit |

## 2. Business Rules

| Rule | Description |
|------|-------------|
| RULE-S16-001 | Link-in-Bio pages are workspace-scoped, one active page per workspace |
| RULE-S16-002 | Media Kits auto-populate from analytics data (last 90 days) |
| RULE-S16-003 | Rate Cards support multiple currencies using workspace default |
| RULE-S16-004 | Brand Deals follow lifecycle: `inquiry → negotiation → contracted → in_progress → delivered → paid → closed` |
| RULE-S16-005 | Deliverable tracking tied to `publish_items` for proof-of-work |
| RULE-S16-006 | Link-in-Bio URLs scanned via Google Safe Browsing API. AUP violations: warn → 48h → auto-remove |
| RULE-S16-007 | Mass link creation throttle: max 20 links/day/workspace (anti-spam bot) |
| RULE-S16-008 | Revenue Per Content uses UTM auto-tagging for attribution chain: content → clicks → orders → revenue → profit |
| RULE-S16-009 | RPM (Revenue Per Mille) calculated per platform, per content type. Alert on RPM drop >20% |
| RULE-S16-010 | Tax reports available: monthly, quarterly, yearly in PDF/Excel/CSV format |

## 3. Key Flows

### 3.1 Link-in-Bio Management (with Domain Protection)
1. Creator creates/edits page layout (drag-and-drop items)
2. Items can be: link, product embed, video embed, social link, custom HTML
3. System scans each URL destination via Google Safe Browsing API
4. Published to `creativanta.link/{slug}` (Free/Starter) or custom domain (Pro+)
5. Analytics tracked per-item (clicks, conversions)
6. Visitors can report suspicious links → AUP review → warn/remove

### 3.2 Media Kit Generation
1. System auto-generates from analytics (followers, engagement rate, demographics)
2. Creator customizes sections, adds portfolio items
3. Exports as branded PDF or shareable link
4. Stats refresh daily via background job

### 3.3 Brand Deal Pipeline
1. Sponsor inquiry arrives (via form or manual entry)
2. Creator evaluates fit (AI scoring optional)
3. Negotiation → contracted (terms, deliverables, payment schedule)
4. Creator delivers content → marks deliverables complete
5. Payment tracked in Finance module

## 4. State Machine — Brand Deal Lifecycle

| From | To | Trigger | Condition |
|------|----|---------|-----------|
| inquiry | negotiation | Creator responds | — |
| inquiry | declined | Creator declines | — |
| negotiation | contracted | Both parties agree | Terms finalized |
| contracted | in_progress | First deliverable started | — |
| in_progress | delivered | All deliverables marked complete | — |
| delivered | paid | Payment confirmed | — |
| paid | closed | Auto-close after 30 days | — |
| * | cancelled | Either party cancels | Refund rules apply |

## 4.1 Edge Cases

### EC-S16-001: Link-in-Bio page with broken product embeds
- Condition: Product referenced by a link-in-bio item is discontinued or archived
- Expected behavior: Item displays "Product unavailable" placeholder. Creator notified to update page. Page remains live with other items functional.

### EC-S16-002: Media Kit with insufficient analytics data
- Condition: Creator has fewer than 30 days of connected platform data
- Expected behavior: Media Kit generation shows "Insufficient data" for affected metrics. Available metrics still displayed. Tooltip: "Connect platforms and wait for 30+ days of data for full media kit."

### EC-S16-003: Multiple concurrent brand deal negotiations
- Condition: Creator has 5+ deals in `negotiation` state simultaneously
- Expected behavior: System warns "You have [N] active negotiations. Consider finalizing or declining some." No hard limit — just advisory.

### EC-S16-004: Sponsor submits duplicate inquiry
- Condition: Same sponsor email submits inquiry within 7 days of previous one
- Expected behavior: System de-duplicates and appends new message to existing inquiry thread. Creator sees updated timestamp.

## 5. Revenue Per Content Tracker

> Source: PRD §37.1 (Content ROI), S16 §5

### 5.1 Purpose
Dashboard displaying revenue attribution per content piece, with UTM auto-tagging and production mode correlation.

### 5.2 Metrics Per Content

| Metric | Source | Calculation |
|---|---|---|
| Views | Platform API | Direct |
| Engagement | Platform API | Likes + comments + shares + saves |
| Link clicks | UTM tracking | Creativanta tracked |
| Orders attributed | Affiliate/UTM correlation | Order count with matching UTM |
| Revenue attributed | Order values | Sum of order values |
| Cost to produce | AI credits + estimated time | System tracked |
| Production mode | M07 metadata | Quick Edit / Clip Factory / Multi-Merge / AI Remix |
| Source content ROI | Derivative tracking | Revenue from all clips/remixes → attributed to source |
| ROI % | Computed | (Revenue − Cost) / Cost × 100% |
| RPM | Computed | Revenue / (Views / 1000) |

### 5.3 RPM Tracking
- RPM calculated per platform, per content type
- Trend chart: RPM over time (weekly/monthly)
- Benchmark: compare with anonymized average (if data available)
- Alert: RPM drop >20% vs previous period → notification

---

## 6. Tax Report Export

> Source: S16 §7

### 6.1 Purpose
Export income reports for tax filing purposes.

### 6.2 Report Parameters
- Periods: monthly, quarterly, yearly
- Formats: PDF, Excel (XLSX), CSV

### 6.3 Report Content
- Total revenue per platform
- Total revenue per source (affiliate, sponsorship, product sales)
- AI credit expenses
- Subscription expenses
- Net income before tax
- Transaction detail list

---

## 7. Domain Protection & Anti-Abuse

> Source: S16 §2.4

### 7.1 Shared Domain Protection

`creativanta.link` is a shared domain — subject to abuse risk and platform blacklisting.

**Anti-abuse rules:**
- Link destination pre-check: Google Safe Browsing API scan when link added
- AUP violation handling: flagged → warning → auto-remove if not fixed within 48h
- Mass link creation throttle: max 20 links/day/workspace
- Link reporting: any visitor can report link → AUP review pipeline

**Shared domain reputation monitoring:**
- Monitor `creativanta.link` on Google Safe Browsing, VirusTotal, platform blocklists
- Alert ops if domain flagged on any blocklist
- Emergency: suspend all AUP-violating pages if shared domain threatened

### 7.2 Custom Domain (Pro+ Tiers)
- Pro/Business/Enterprise: support custom domain (e.g., `links.brand.com`)
- Setup: CNAME record → verification → SSL auto-provision
- Benefits: isolated domain reputation, professional branding, no shared domain blacklist risk
- Free/Starter: `creativanta.link/{username}` only

---

## 8. Tier Gating Matrix

> Source: S16 §8.3

### 8.1 Feature Gating Per Tier

| Feature | Free | Starter | Pro | Business |
|---|---|---|---|---|
| Link-in-Bio | ✅ (3 links) | ✅ (10 links) | ✅ (unlimited) | ✅ |
| Link-in-Bio Custom Domain | ❌ | ❌ | ✅ | ✅ |
| Media Kit | ❌ | ✅ (1 template) | ✅ (all templates) | ✅ + custom |
| Rate Card AI | ❌ | ❌ | ✅ | ✅ |
| Revenue per Content | ✅ (basic) | ✅ | ✅ (with RPM) | ✅ |
| Brand Deals | ❌ | ✅ (5 deals) | ✅ (unlimited) | ✅ |
| Tax Export | ❌ | ✅ | ✅ | ✅ |

### 8.2 Mode Availability

| Mode | Access Level |
|---|---|
| Creator Mode | Full access to all Creator Pro features |
| Seller Mode | Revenue + Tax Export only |
| Agency Mode | Per-creator views (multi-workspace aggregation) |
| Affiliate Mode | Revenue + Rate Card only |
| Brand Collab Mode | Full access |
| Beginner Mode | Guided unlock via progressive disclosure |

---

## 9. API Surface

> See `04_contracts/api_endpoint_map.md` §5 (S16 Creator Pro) — 7 services, 28+ RPCs

| Service | Key RPCs |
|---------|----------|
| `LinkInBioService` | GetPage, UpdatePage, GetAnalytics, PublishPage, ScanLink, ReportLink |
| `MediaKitService` | Generate, Get, Update, ExportPDF |
| `RateCardService` | Create, List, Update, Delete |
| `BrandDealService` | ListDeals, UpdateStatus, UpdateDeliverable, UpdatePayment |
| `SponsorInquiryService` | List, Respond, Decline, GetStats |
| `RevenueTrackerService` | GetPerContent, GetRPMTrends, GetROI, GetTopPerformers |
| `TaxReportService` | Generate, Download, ListReports |

## 10. Acceptance Criteria

```gherkin
Feature: Link-in-Bio Editor
  Scenario: Creator creates a link-in-bio page
    Given a workspace without a link-in-bio page
    When creator fills title, adds 3 items (link, product, social)
    Then page is saved as draft with 3 items
    And preview URL is generated

Feature: Brand Deal Pipeline
  Scenario: Full deal lifecycle
    Given a sponsor inquiry for workspace
    When creator responds → negotiates → contracts → delivers → gets paid
    Then deal status follows: inquiry → negotiation → contracted → in_progress → delivered → paid → closed
    And each transition is logged in audit_events

Feature: Link-in-Bio Domain Protection
  Scenario: Phishing link detected
    Given a creator adds a new link to their Link-in-Bio page
    When the system scans the URL via Google Safe Browsing API
    And the URL is flagged as phishing
    Then a warning is displayed to the creator
    And the link is NOT published until creator removes or overrides (with AUP acknowledgment)

  Scenario: Custom domain setup
    Given a Pro user navigates to Link-in-Bio settings
    When they enter a custom domain and configure CNAME
    Then system verifies CNAME → provisions SSL certificate
    And Link-in-Bio page is live on custom domain

  Scenario: Shared domain reputation threatened
    Given the shared domain `creativanta.link` appears on a blocklist
    When ops receives alert
    Then all AUP-violating Link-in-Bio pages are suspended
    And legitimate pages display "Temporarily unavailable" message

Feature: Revenue Per Content
  Scenario: Content ROI tracking
    Given a creator views the Revenue per Content dashboard
    When content has associated UTM-tracked orders
    Then each content piece shows: views, clicks, revenue, cost, ROI%, RPM
    And AI suggests "Create more content like [top performer]"

  Scenario: RPM drop alert
    Given a creator's RPM drops >20% vs previous period
    When system detects the decline
    Then notification sent: "RPM dropped from X to Y on [platform]"
    And dashboard highlights affected content

Feature: Tax Report Export
  Scenario: Creator exports tax report
    Given a creator on Starter+ tier
    When they request a yearly tax report in Excel format
    Then report includes: revenue per platform, per source, AI expenses, net income
    And file downloads as .xlsx with correct totals

Feature: Tier Gating
  Scenario: Free tier link limit enforcement
    Given a Free tier workspace with 3 Link-in-Bio items
    When creator tries to add a 4th item
    Then system shows: "Free tier limit: 3 items. [Upgrade to Starter for 10 items]"
    And the item is NOT added

Feature: Domain Protection — Mass Creation Throttle
  Scenario: Mass link creation blocked
    Given a creator has created 20 links today
    When they attempt to create link #21
    Then system blocks: "Daily limit reached (20 links/day). Try again tomorrow."
    And audit event logged with workspace_id

Feature: Revenue Per Content
  Scenario: Derivative revenue attribution
    Given a source video has 5 published clips
    When each clip generates tracked revenue
    Then source video "Derivative Performance" section shows per-clip revenue
    And roll-up total across all derivatives is calculated

Feature: Custom Domain
  Scenario: Custom domain CNAME verification failure
    Given a Pro user enters custom domain but CNAME is not configured
    When system checks DNS records
    Then status shows: "CNAME not found. Add CNAME record pointing to creativanta.link"
    And domain remains unverified with retry option
```

> **Schema Cross-reference (GAP-M001 verification)**: Full field-level definitions for `link_in_bio_pages`, `link_in_bio_items`, `media_kits`, `rate_cards`, and `brand_deals` are in [database_schema.md §16](../../04_contracts/database_schema.md). Revenue tracking uses `profit_snapshots` and `cost_items` in §11. This feature spec does NOT inline schemas to avoid duplication — the canonical source is always the DB schema contract.

## 11. Cross-references

- **DB**: `04_contracts/database_schema.md` §16 Creator Pro Tools
- **API**: `04_contracts/api_endpoint_map.md` §5 S16
- **RBAC**: `04_contracts/rbac_permission_matrix.md` (Editor+ for pages, Manager+ for deals)
- **Screens**: `03_screens/web/screen_web_creator_pro_*.md`
- **Pricing**: `01_business/pricing_and_credits.md` (tier gating alignment)
- **Finance**: `02_features/finance/operating_ledger.md` (revenue attribution feeds)
- **Affiliate**: `02_features/commerce/affiliate_network.md` (UTM + link health overlap)
