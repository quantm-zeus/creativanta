---
layer: features
module: help
canonical: true
domain: platform
status: SPECIFIED
created: 2026-04-02
last_updated: 2026-10-29
upstream: S19 §4, §8, §9
---

# Help Center, Changelog & Community Programs

> **Upstream**: S19 (Customer Support) §4, §8, §9
> **Surfaces**: Help center (in-app + web), changelog (in-app), beta program, public status page

---

## 1. Purpose

Users need self-serve support resources to reduce ticket volume and enable independent problem-solving. This spec covers the **Help Center knowledge base**, **Changelog & Announcements**, **Beta Program**, and **Public Status Page** — all customer-facing support infrastructure.

## 2. Help Center

### 2.1 Knowledge Base Structure

Content organized by module (M01–M23) for findability:

| Category | Modules | Content Types |
|---|---|---|
| Getting Started | M01 (Home), M22 (Connectors) | Setup guides, first steps, operator mode selection |
| Intelligence | M02, M03, M04 | Trend tracking, competitor analysis, opportunities |
| Content Creation | M05, M06, M07, M08, M09, M10 | Script writing, video production, packaging |
| Publishing | M11, M12 | Multi-platform publish, inbox management |
| Commerce | M13, M14, M15, M16, M17, M18 | Products, monetization, affiliate, live commerce |
| Finance | M19 | Profit tracking, cost entry, reconciliation |
| Automation | M20, M21 | Workflows, recipes, agents |
| Account & Billing | M23 | Subscription, team, settings, billing |

### 2.2 Content Types

| Type | Format | Example |
|---|---|---|
| **Getting Started Guides** | 5-step walkthroughs per operator mode | "Getting started as a Seller" |
| **How-to Articles** | Step-by-step with screenshots | "How to connect TikTok Shop" |
| **Video Tutorials** | ≤3 min per topic | "Quick Edit basics" |
| **FAQ** | Top 50 questions | "How do AI credits work?" |
| **Troubleshooting** | Symptom → Diagnosis → Fix | "Why is my publish job stuck?" |
| **API Documentation** | Endpoint reference (Starter+ tier) | "Public API authentication" |

### 2.3 Search & Navigation
- Full-text search across all articles
- Contextual suggestions: when user is on M07, suggest M07-related articles
- Recently viewed articles
- Popular articles ranking
- Related articles sidebar
- Multi-language support (Vietnamese primary, English secondary)

### 2.4 Content Maintenance
- Stale content flag: articles not updated in 90 days → flagged for review
- Monthly review cadence: ops team reviews flagged articles
- Article feedback: "Was this helpful?" → Yes/No + comment
- Low-rating articles (<60% helpful) → priority queue for rewrite
- Version history: track article changes over time

### 2.5 Contextual Help Integration
- In-app "?" icon next to complex features → opens relevant help article
- Empty state help: when a feature section is empty, show contextual guide
- Error-linked help: error messages include "Learn more" link to relevant article
- Onboarding tooltips: first-time use of features → contextual tooltip with article link

## 3. Changelog & Announcements

### 3.1 Changelog Format

Each entry follows:

```markdown
## [Date] — [Title]

**Category**: Feature / Improvement / Fix / Breaking Change
**Affected Modules**: M01, M07, ...

[Description — 2-3 sentences with screenshots/GIFs if applicable]

**Impact**: [Who is affected and how]
```

### 3.2 In-App Announcement System

| Parameter | Rule |
|---|---|
| Frequency | Max 1 announcement per session per user |
| Targeting | Per tier, per operator mode, per region |
| Dismissal | User can dismiss; dismissed announcements don't reappear |
| Types | Feature launch (modal), improvement (banner), fix (toast), breaking change (blocking modal) |
| Priority | Breaking changes > Feature launches > Improvements > Fixes |

### 3.3 Distribution Channels
- In-app notification badge (bell icon)
- In-app modal/banner for major features
- Email digest (opt-in, weekly)
- Push notification for breaking changes only

## 4. Beta Program

### 4.1 Participation Rules
- Opt-in via Settings → Beta Program
- Available to all paid tiers (Starter+)
- Beta features behind feature flags
- 50 bonus credits upon enrollment
- Can opt-out at any time (beta features disabled)

### 4.2 Graduation Criteria
Beta features graduate to GA (General Availability) when:
- 2 weeks stable in beta (no P0/P1 bugs)
- >80% positive feedback from beta participants
- Performance within acceptable thresholds

### 4.3 Feedback Collection
- In-app feedback widget on beta features
- Rating: 1-5 stars + free text
- Bug report shortcut (auto-captures context)
- Monthly beta participant survey

## 5. Public Status Page

> Source: S19 §9

### 5.1 Monitored Components

| Component | Check Interval | Note |
|---|---|---|
| Web Application | 30s | SvelteKit frontend |
| Mobile Backend | 30s | API endpoints |
| Public API | 30s | Developer API |
| Database | 30s | PostgreSQL |
| AI Services | 60s | Generation endpoints |
| Platform Connectors | 60s | TikTok, Shopee, etc. |
| Payment Processing | 60s | Stripe |
| Email / SMS | 120s | Notification delivery |

### 5.2 Incident Communication Protocol

| Severity | Initial Update | Ongoing Updates | Post-Mortem |
|---|---|---|---|
| P0 (Critical) | Within 15 min | Every 30 min | Within 48 hours |
| P1 (Major) | Within 30 min | Every 1 hour | Within 5 days |
| P2 (Minor) | Within 4 hours | End of day | If impactful |

### 5.3 Maintenance Windows
- Advance notice: 72 hours minimum
- Preferred time: 2:00–5:00 AM ICT (UTC+7)
- Zero-downtime deployment preferred
- Rollback ready within 5 minutes

### 5.4 Subscriber Notifications
- Email subscription for status updates
- Webhook for programmatic consumers
- RSS feed for status changes

## 6. Acceptance Criteria

```gherkin
Feature: Help Center
  Scenario: Contextual help on M07
    Given a user is on the AI Video Studio page
    When they click the "?" help icon
    Then the help panel opens with M07-related articles
    And search is pre-filtered to "AI Video Studio"

  Scenario: Stale content detection
    Given an article was last updated 95 days ago
    When the ops team views the content dashboard
    Then the article is flagged as "Needs Review" with last-updated date

Feature: Changelog
  Scenario: In-app announcement targeting
    Given a new feature announced for Pro+ users
    When a Free user logs in
    Then the announcement is NOT shown
    When a Pro user logs in
    Then the announcement modal appears (max 1 per session)
    When the user dismisses it
    Then the modal does not reappear

Feature: Beta Program
  Scenario: Beta enrollment
    Given a Starter user navigates to Settings → Beta Program
    When they opt in
    Then they receive 50 bonus credits
    And beta feature flags are enabled for their workspace

Feature: Public Status Page
  Scenario: P0 incident communication
    Given a P0 incident is detected
    When ops acknowledges the incident
    Then status page updates within 15 minutes
    And email subscribers are notified
    And ongoing updates published every 30 minutes until resolution
```

## 7. Cross-references

- **Support SLA**: `01_business/legal_compliance.md §7`
- **DB**: `04_contracts/database_schema.md` §17.8-§17.9D (`support_tickets`, `support_ticket_messages`, `kb_categories`, `kb_articles`, `kb_article_versions`, `article_ratings`)
- **API**: `04_contracts/api_endpoint_map.md` §19.4-§19.5A (`SupportService`, `KBService`, `KBAdminService`)
- **Internal Admin**: `02_features/platform/internal_admin.md` (ops manages status page)
- **Runbook**: `06_quality_ops/runbook.md` (incident procedures)
- **DR/Failover**: `06_quality_ops/runbook.md §9` (disaster recovery, backup, failover architecture)
- **Observability**: `05_system/observability.md` (health checks feed status page)
- **Contextual Help→Home**: `02_features/platform/home_decision_engine.md` (contextual learning integration)
