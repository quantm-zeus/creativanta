---
layer: quality_ops
canonical: true
created: 2026-04-01
last_updated: 2026-04-06
---

# Seed Data & Development Fixtures

> **Purpose**: Provides consistent test data for local development, CI, and demo environments.
> **Resolves**: Review §9 finding "Seed data: ❌ Missing"

---

## 1. Seed Execution Order

> FK dependencies dictate the order (`workspaces` references `regions` and `currencies`). Run in this exact sequence under the migration/superuser role (`creativanta`).

| # | Table(s) | Count | Description |
|---|----------|-------|-------------|
| 1 | `currencies` + `regions` | 2, 3 | Global currencies (VND, USD) and regions (VN, US, SEA) |
| 2 | `users` | 5 | System users with different roles |
| 3 | `workspaces` | 3 | Pro, Starter/Free, Business tier workspaces |
| 4 | `workspace_members` | 8 | Members across workspaces with different roles |
| 5 | `connected_accounts` | 4 | TikTok, Shopee, YouTube, Facebook |
| 6 | `signals` → `trends` → `trend_signals` | 10, 3, 6 | Intelligence data |
| 7 | `ideas` | 10 | Ideas across all status values |
| 8 | `scripts` + `hooks` + `shot_lists` | 5, 10, 15 | Script Lab data |
| 9 | `characters` + `continuity_packs` | 3, 2 | Continuity data |
| 10 | `assets` + `generation_jobs` | 8, 4 | AI production data |
| 11 | `products` + `offers` + `skus` | 5, 8, 12 | Commerce catalog |
| 12 | `orders` + `order_items` | 10, 25 | Order history |
| 13 | `publish_items` + `publish_logs` | 6, 12 | Published content |
| 14 | `threads` + `messages` | 8, 30 | Engagement inbox |
| 15 | `ai_credit_transactions` | 20 | Credit history |
| 16 | `profit_snapshots` + `cost_items` | 5, 15 | Finance data |
| 17 | `workflows` + `workflow_runs` | 3, 6 | Automation data |
| 18 | `achievement_definitions` [GLOBAL] + `achievement_records` | 10, 15 | Gamification |

---

## 2. Seed Users

```sql
-- User 1: Workspace Owner (Pro tier)
INSERT INTO users (user_id, clerk_id, email, display_name, avatar_url, locale, created_at)
VALUES
  ('11111111-1111-1111-1111-111111111101', 'user_seed_owner', 'owner@demo.creativanta.app', 'Minh Nguyen', NULL, 'vi-VN', NOW()),
  ('11111111-1111-1111-1111-111111111102', 'user_seed_manager', 'manager@demo.creativanta.app', 'Lan Tran', NULL, 'vi-VN', NOW()),
  ('11111111-1111-1111-1111-111111111103', 'user_seed_editor', 'editor@demo.creativanta.app', 'Duc Le', NULL, 'vi-VN', NOW()),
  ('11111111-1111-1111-1111-111111111104', 'user_seed_viewer', 'viewer@demo.creativanta.app', 'Huong Pham', NULL, 'vi-VN', NOW()),
  ('11111111-1111-1111-1111-111111111105', 'user_seed_admin', 'admin@demo.creativanta.app', 'Admin User', NULL, 'en-US', NOW());
```

## 3. Seed Workspaces

```sql
-- Column mapping from canonical database_schema.md:
-- owner_id → owner_user_id, name → display_name, tier → subscription_tier
-- locale/timezone not in canonical schema (stored in settings JSONB)
INSERT INTO workspaces (workspace_id, owner_user_id, display_name, slug, subscription_tier, created_at)
VALUES
  ('22222222-2222-2222-2222-222222222201', '11111111-1111-1111-1111-111111111101', 'Demo Creator Studio', 'demo-studio', 'pro', NOW()),
  ('22222222-2222-2222-2222-222222222202', '11111111-1111-1111-1111-111111111101', 'Free Tier Test', 'free-test', 'free', NOW()),
  ('22222222-2222-2222-2222-222222222203', '11111111-1111-1111-1111-111111111105', 'Business Agency', 'biz-agency', 'business', NOW());
```

## 4. Seed Members

```sql
INSERT INTO workspace_members (workspace_id, user_id, role, invited_by, joined_at)
VALUES
  -- Demo Studio: Owner + Manager + Editor + Viewer
  ('22222222-2222-2222-2222-222222222201', '11111111-1111-1111-1111-111111111101', 'owner', NULL, NOW()),
  ('22222222-2222-2222-2222-222222222201', '11111111-1111-1111-1111-111111111102', 'manager', '11111111-1111-1111-1111-111111111101', NOW()),
  ('22222222-2222-2222-2222-222222222201', '11111111-1111-1111-1111-111111111103', 'editor', '11111111-1111-1111-1111-111111111101', NOW()),
  ('22222222-2222-2222-2222-222222222201', '11111111-1111-1111-1111-111111111104', 'viewer', '11111111-1111-1111-1111-111111111102', NOW()),
  -- Free workspace: Owner only
  ('22222222-2222-2222-2222-222222222202', '11111111-1111-1111-1111-111111111101', 'owner', NULL, NOW()),
  -- Business workspace: Admin + Manager + Editor
  ('22222222-2222-2222-2222-222222222203', '11111111-1111-1111-1111-111111111105', 'owner', NULL, NOW()),
  ('22222222-2222-2222-2222-222222222203', '11111111-1111-1111-1111-111111111102', 'manager', '11111111-1111-1111-1111-111111111105', NOW()),
  ('22222222-2222-2222-2222-222222222203', '11111111-1111-1111-1111-111111111103', 'editor', '11111111-1111-1111-1111-111111111105', NOW());
```

## 5. Seed Ideas (All Status Values)

```sql
-- Column mapping: 'source' not in canonical schema (ideas table has no source column)
INSERT INTO ideas (idea_id, workspace_id, title, status, idea_score, created_by, created_at)
VALUES
  (gen_random_uuid(), '22222222-2222-2222-2222-222222222201', 'Trend unboxing video Tết', 'draft', 72.5, '11111111-1111-1111-1111-111111111101', NOW()),
  (gen_random_uuid(), '22222222-2222-2222-2222-222222222201', 'Review son mới Shopee', 'candidate', 85.3, '11111111-1111-1111-1111-111111111101', NOW()),
  (gen_random_uuid(), '22222222-2222-2222-2222-222222222201', 'Tutorial makeup cơ bản', 'selected', 91.0, '11111111-1111-1111-1111-111111111102', NOW()),
  (gen_random_uuid(), '22222222-2222-2222-2222-222222222201', 'So sánh kem chống nắng', 'converted', 88.7, '11111111-1111-1111-1111-111111111103', NOW()),
  (gen_random_uuid(), '22222222-2222-2222-2222-222222222201', 'Chia sẻ routine buổi sáng', 'archived', 55.0, '11111111-1111-1111-1111-111111111101', NOW());
```

## 6. Seed Products & Offers

```sql
-- Column mapping: name → title, sku_code → (moved to product_skus table), status → catalog_status
-- base_price uses NUMERIC(18,6) in schema (DB-H-001 resolved)
INSERT INTO products (product_id, workspace_id, title, product_type, catalog_status, category, base_price, currency, created_at)
VALUES
  (gen_random_uuid(), '22222222-2222-2222-2222-222222222201', 'Son MAC Ruby Woo', 'physical', 'active', 'cosmetics', 450000.000000, 'VND', NOW()),
  (gen_random_uuid(), '22222222-2222-2222-2222-222222222201', 'Kem chống nắng Anessa', 'physical', 'active', 'skincare', 380000.000000, 'VND', NOW()),
  (gen_random_uuid(), '22222222-2222-2222-2222-222222222201', 'Phấn mắt Romand', 'physical', 'draft', 'cosmetics', 250000.000000, 'VND', NOW());
```

## 7. Seed Credit Transactions

```sql
-- Table mapping: credit_transactions → ai_credit_transactions (canonical)
-- Column mapping: type → transaction_type, amount → credits
INSERT INTO ai_credit_transactions (transaction_id, workspace_id, transaction_type, credits, balance_after, description, created_at)
VALUES
  (gen_random_uuid(), '22222222-2222-2222-2222-222222222201', 'monthly_allocation', 1000, 1000, 'Welcome credits (Pro tier)', NOW() - INTERVAL '30 days'),
  (gen_random_uuid(), '22222222-2222-2222-2222-222222222201', 'deduction', -50, 950, 'AI Video Generation #1', NOW() - INTERVAL '25 days'),
  (gen_random_uuid(), '22222222-2222-2222-2222-222222222201', 'deduction', -30, 920, 'AI Script Generation', NOW() - INTERVAL '20 days'),
  (gen_random_uuid(), '22222222-2222-2222-2222-222222222201', 'monthly_allocation', 500, 1420, 'Monthly renewal credits', NOW() - INTERVAL '1 day');
```

## 8. Execution Script

> **Note**: `seed_data.sql` now exists as the executable companion to this document. This markdown file remains the canonical explanation of seed intent, ordering, and environment policy; `seed_data.sql` is the canonical runnable fixture.

```bash
#!/bin/bash
# Run from project root
# Usage: ./scripts/seed.sh [environment]

ENV=${1:-dev}

if [ "$ENV" = "dev" ]; then
  DB_URL="postgresql://creativanta:dev_password_123@localhost:5432/creativanta_dev"
elif [ "$ENV" = "test" ]; then
  DB_URL="postgresql://creativanta:dev_password_123@localhost:5432/creativanta_test"
else
  echo "Unknown environment: $ENV"
  exit 1
fi

echo "Seeding $ENV database..."
psql "$DB_URL" -f docs/06_quality_ops/seed_data.sql
```

## 9. Environment-Specific Behavior

| Environment | Seed Data | Credit Balance | AI Calls |
|---|---|---|---|
| `dev` | Full seed (above) | Pre-loaded 1420 credits | Mock provider |
| `test` | Minimal (users + workspaces only) | 0 credits | Mock provider |
| `staging` | Full seed | Real credits (sandbox) | Real provider (sandbox) |
| `prod` | NEVER seed | — | — |

## Cross-references

- **Docker**: `06_quality_ops/docker_dev_environment.md` (DB initialization)
- **Schema**: `04_contracts/database_schema.md` (table definitions)
- **Business rules**: `01_business/business_rules.md` (status values, credit rules)
- **Executable fixture**: `06_quality_ops/seed_data.sql`
