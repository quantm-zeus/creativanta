-- Canonical local/dev seed data for Creativanta
-- Source: docs/06_quality_ops/seed_data.md
-- Last updated: 2026-10-29
-- Execution role: Run as the migration/owner superuser role ('creativanta') so multi-workspace
-- fixtures can be inserted in a single transaction across FORCE ROW LEVEL SECURITY tables.

BEGIN;

INSERT INTO currencies (currency_id, code, symbol, decimal_places, display_format)
VALUES
  ('33333333-3333-3333-3333-333333333301', 'VND', 'đ', 0, '#.###đ'),
  ('33333333-3333-3333-3333-333333333302', 'USD', '$', 2, '$#.##')
ON CONFLICT (code) DO NOTHING;

INSERT INTO regions (region_id, code, name, default_currency_code)
VALUES
  ('44444444-4444-4444-4444-444444444401', 'VN', 'Vietnam', 'VND'),
  ('44444444-4444-4444-4444-444444444402', 'US', 'United States', 'USD'),
  ('44444444-4444-4444-4444-444444444403', 'SEA', 'Southeast Asia', 'VND')
ON CONFLICT (code) DO NOTHING;

INSERT INTO users (user_id, clerk_id, email, display_name, locale, timezone)
VALUES
  ('11111111-1111-1111-1111-111111111101', 'user_seed_owner', 'owner@demo.creativanta.app', 'Minh Nguyen', 'vi-VN', 'Asia/Ho_Chi_Minh'),
  ('11111111-1111-1111-1111-111111111102', 'user_seed_manager', 'manager@demo.creativanta.app', 'Lan Tran', 'vi-VN', 'Asia/Ho_Chi_Minh'),
  ('11111111-1111-1111-1111-111111111103', 'user_seed_editor', 'editor@demo.creativanta.app', 'Duc Le', 'vi-VN', 'Asia/Ho_Chi_Minh'),
  ('11111111-1111-1111-1111-111111111104', 'user_seed_viewer', 'viewer@demo.creativanta.app', 'Huong Pham', 'vi-VN', 'Asia/Ho_Chi_Minh'),
  ('11111111-1111-1111-1111-111111111105', 'user_seed_admin', 'admin@demo.creativanta.app', 'Admin User', 'en-US', 'Asia/Ho_Chi_Minh')
ON CONFLICT (clerk_id) DO NOTHING;

INSERT INTO workspaces (
  workspace_id, workspace_type, display_name, slug, default_operator_mode,
  primary_region_id, primary_currency_id, subscription_tier, owner_user_id
)
VALUES
  ('22222222-2222-2222-2222-222222222201', 'standard', 'Demo Creator Studio', 'demo-studio', 'creator', '44444444-4444-4444-4444-444444444401', '33333333-3333-3333-3333-333333333301', 'pro', '11111111-1111-1111-1111-111111111101'),
  ('22222222-2222-2222-2222-222222222202', 'standard', 'Starter Workspace', 'starter-workspace', 'creator', '44444444-4444-4444-4444-444444444401', '33333333-3333-3333-3333-333333333301', 'starter', '11111111-1111-1111-1111-111111111101'),
  ('22222222-2222-2222-2222-222222222203', 'standard', 'Business Agency', 'business-agency', 'agency_mcn', '44444444-4444-4444-4444-444444444403', '33333333-3333-3333-3333-333333333301', 'business', '11111111-1111-1111-1111-111111111105')
ON CONFLICT (slug) DO NOTHING;

INSERT INTO workspace_members (
  workspace_member_id, workspace_id, user_id, role, invited_by
)
VALUES
  ('55555555-5555-5555-5555-555555555501', '22222222-2222-2222-2222-222222222201', '11111111-1111-1111-1111-111111111101', 'owner', NULL),
  ('55555555-5555-5555-5555-555555555502', '22222222-2222-2222-2222-222222222201', '11111111-1111-1111-1111-111111111102', 'manager', '11111111-1111-1111-1111-111111111101'),
  ('55555555-5555-5555-5555-555555555503', '22222222-2222-2222-2222-222222222201', '11111111-1111-1111-1111-111111111103', 'editor', '11111111-1111-1111-1111-111111111101'),
  ('55555555-5555-5555-5555-555555555504', '22222222-2222-2222-2222-222222222201', '11111111-1111-1111-1111-111111111104', 'viewer', '11111111-1111-1111-1111-111111111102'),
  ('55555555-5555-5555-5555-555555555505', '22222222-2222-2222-2222-222222222203', '11111111-1111-1111-1111-111111111105', 'owner', NULL)
ON CONFLICT (workspace_id, user_id) DO NOTHING;

INSERT INTO ideas (idea_id, workspace_id, title, status, idea_score, created_by)
VALUES
  ('66666666-6666-6666-6666-666666666601', '22222222-2222-2222-2222-222222222201', 'Trend unboxing video Tet', 'draft', 72.5, '11111111-1111-1111-1111-111111111101'),
  ('66666666-6666-6666-6666-666666666602', '22222222-2222-2222-2222-222222222201', 'Shopee lipstick review', 'candidate', 85.3, '11111111-1111-1111-1111-111111111101'),
  ('66666666-6666-6666-6666-666666666603', '22222222-2222-2222-2222-222222222201', 'Morning routine tutorial', 'selected', 91.0, '11111111-1111-1111-1111-111111111102')
ON CONFLICT (idea_id) DO NOTHING;

INSERT INTO products (
  product_id, workspace_id, product_type, title, category, base_price, currency, catalog_status
)
VALUES
  ('77777777-7777-7777-7777-777777777701', '22222222-2222-2222-2222-222222222201', 'physical', 'Son MAC Ruby Woo', 'cosmetics', 450000.000000, 'VND', 'active'),
  ('77777777-7777-7777-7777-777777777702', '22222222-2222-2222-2222-222222222201', 'physical', 'Kem chong nang Anessa', 'skincare', 380000.000000, 'VND', 'active'),
  ('77777777-7777-7777-7777-777777777703', '22222222-2222-2222-2222-222222222201', 'physical', 'Phan mat Romand', 'cosmetics', 250000.000000, 'VND', 'draft')
ON CONFLICT (product_id) DO NOTHING;

INSERT INTO ai_credit_lots (lot_id, workspace_id, source_type, granted_credits, remaining_credits, external_grant_key, expires_at)
VALUES
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1', '22222222-2222-2222-2222-222222222201', 'subscription', 2000, 1920, 'seed:pro:period', NOW() + INTERVAL '1 month'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb2', '22222222-2222-2222-2222-222222222201', 'purchased', 500, 500, 'seed:pro:purchased', NULL),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb3', '22222222-2222-2222-2222-222222222202', 'subscription', 500, 500, 'seed:starter:period', NOW() + INTERVAL '1 month'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb4', '22222222-2222-2222-2222-222222222203', 'subscription', 10000, 10000, 'seed:business:period', NOW() + INTERVAL '1 month')
ON CONFLICT (workspace_id, external_grant_key) DO NOTHING;

INSERT INTO ai_credit_transactions (
  transaction_id, workspace_id, transaction_type, credits, balance_after, lot_id, idempotency_key, description
)
VALUES
  ('88888888-8888-8888-8888-888888888801', '22222222-2222-2222-2222-222222222201', 'monthly_allocation', 2000, 2000, 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1', 'seed:88888888-8888-8888-8888-888888888801', 'Pro subscription grant'),
  ('88888888-8888-8888-8888-888888888802', '22222222-2222-2222-2222-222222222201', 'deduction', -50, 1950, 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1', 'seed:88888888-8888-8888-8888-888888888802', 'AI Video Generation #1'),
  ('88888888-8888-8888-8888-888888888803', '22222222-2222-2222-2222-222222222201', 'deduction', -30, 1920, 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1', 'seed:88888888-8888-8888-8888-888888888803', 'AI Script Generation'),
  ('88888888-8888-8888-8888-888888888804', '22222222-2222-2222-2222-222222222201', 'top_up', 500, 2420, 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb2', 'seed:88888888-8888-8888-8888-888888888804', 'Verified purchased pack'),
  ('88888888-8888-8888-8888-888888888805', '22222222-2222-2222-2222-222222222202', 'monthly_allocation', 500, 500, 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb3', 'seed:starter:period', 'Starter allocation'),
  ('88888888-8888-8888-8888-888888888806', '22222222-2222-2222-2222-222222222203', 'monthly_allocation', 10000, 10000, 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb4', 'seed:business:period', 'Business allocation')
ON CONFLICT (transaction_id) DO NOTHING;

-- Seed owner role may reconcile fixture projections; runtime ledger entries are append-only.
UPDATE workspaces SET ai_credits_remaining = CASE subscription_tier WHEN 'pro' THEN 2420 WHEN 'starter' THEN 500 WHEN 'business' THEN 10000 END,
  ai_credits_reserved = 0,
  ai_credits_monthly_limit = CASE subscription_tier WHEN 'pro' THEN 2000 WHEN 'starter' THEN 500 WHEN 'business' THEN 10000 END
WHERE workspace_id IN ('22222222-2222-2222-2222-222222222201','22222222-2222-2222-2222-222222222202','22222222-2222-2222-2222-222222222203');

-- UI-only illustrative snapshot; not proof that recognized postings/finance fixtures pass.
INSERT INTO profit_snapshots (
  snapshot_id, workspace_id, scope_type, period_start, period_end,
  gross_revenue, platform_fees, affiliate_commissions, ai_credit_costs,
  other_costs, net_profit, confidence, currency, source_class_mix
)
VALUES
  ('99999999-9999-9999-9999-999999999901', '22222222-2222-2222-2222-222222222201', 'workspace', CURRENT_DATE - INTERVAL '30 days', CURRENT_DATE, 45000000.000000, 4500000.000000, 1200000.000000, 350000.000000, 800000.000000, 38150000.000000, 'low', 'VND', '{"estimated": 1.0}')
ON CONFLICT (snapshot_id) DO NOTHING;

INSERT INTO cost_items (
  cost_item_id, workspace_id, cost_type, amount, currency, description, source_class
)
VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '22222222-2222-2222-2222-222222222201', 'ads_spend', 1200000.000000, 'VND', 'Shopee ads week 1', 'official'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '22222222-2222-2222-2222-222222222201', 'service_tool', 350000.000000, 'VND', 'Creative tooling subscription', 'official')
ON CONFLICT (cost_item_id) DO NOTHING;

COMMIT;
