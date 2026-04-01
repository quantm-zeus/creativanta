---
layer: screens
module: M14
canonical: true
platform: web
screen_id: SCR-W-M14-001
last_updated: 2026-04-02
---

# Screen: Monetization OS (Web) — M14

## Screen ID
`SCR-W-M14-001`

## Purpose
Central monetization management surface for offers, coupons, campaigns, and conversion tracking. Aggregates offers from multiple channels (Creator Store, Social, Affiliate, Link-in-Bio) into a unified view with ROI metrics.

## Entry Points
- Left sidebar → "Monetization" (icon: 💰)
- Home action card → "Conversion Opportunity" CTA
- Product Hub → "Create Offer" CTA

## Layout

### Top Bar
- Page title: "Monetization OS"
- Operator mode badge (contextual terminology)
- CTA: "+ New Offer" button (primary)

### Tab Navigation
| Tab | Content | Badge |
|---|---|---|
| Active Offers | Offer cards with status, conversion rate, revenue | Count of active offers |
| Campaigns | Campaign list with date range, budget, ROI | Running campaign count |
| Coupons | Coupon codes with usage stats | Active coupon count |
| Analytics | Conversion funnels, channel attribution, ROI dashboard | — |

### Offer Card (repeating)
| Element | Source | Notes |
|---|---|---|
| Offer title | `offers.title` | Editable inline |
| Offer type badge | `offers.offer_type` | product_offer, digital_offer, membership_offer, etc. |
| Pricing | `offers.pricing_value` + `offers.pricing_currency` | NUMERIC(18,6) |
| Lifecycle status | `offers.lifecycle_state` | draft → active → paused → expired → retired |
| Conversion rate | `monetization_offer_views.converted / total` | Percentage with trend arrow |
| Revenue generated | Aggregated from `order_items` linked to offer | NUMERIC(18,6) |
| Channel distribution | `monetization_offer_views.channel` | Pie chart mini |
| CTA | "Edit" / "Pause" / "View Analytics" | Based on lifecycle_state |

### Analytics Panel
| Metric | Source | Visualization |
|---|---|---|
| Total offer views | `monetization_offer_views` count | Number + trend |
| Conversion rate | converted / total views | Percentage + line chart |
| Revenue by channel | `monetization_offer_views.channel` × order amount | Stacked bar chart |
| Top performing offers | Sorted by conversion rate | Ranked list |
| Funnel: View → Click → Purchase | offer_views → order_items | Funnel chart |

## Data Sources

| Data | Table/RPC | Auth |
|---|---|---|
| Offers CRUD | `OfferService/*` (§2.6.2) | Editor+ |
| Coupons CRUD | `CouponService/*` (§2.6.7) | Manager+ |
| Campaigns | `CampaignService/*` (§2.6.4) | Manager+ |
| Offer views | `monetization_offer_views` | Member (read) |
| Orders | `OrderService/List` (§2.6.3) | Member (read) |

## State Machine
Uses `offers.lifecycle_state` — see `02_features/commerce/monetization_os.md` §State Machine.

## Error Handling
| Error Code | Display |
|---|---|
| COMMERCE_NOTFOUND_001 | "Offer không tồn tại." |
| COMMERCE_CONFLICT_002 | "Mã giảm giá đã tồn tại." |
| BILLING_LIMIT_002 | Upgrade prompt for tier-gated features |

## RBAC
| Action | Required Permission |
|---|---|
| View offers | `offer:read` (Member+) |
| Create/edit offer | `offer:write` (Editor+) |
| Create coupon | `coupon:manage` (Manager+) |
| View analytics | `analytics:read` (Member+) |

## Cross-references
- Feature: `02_features/commerce/monetization_os.md`
- API: `04_contracts/api_endpoint_map.md` §2.6.2 OfferService
- DB: `04_contracts/database_schema.md` §10.2 offers, §22.15 monetization_offer_views
- Events: `04_contracts/domain_event_catalog.md` §6 (offer lifecycle events)
