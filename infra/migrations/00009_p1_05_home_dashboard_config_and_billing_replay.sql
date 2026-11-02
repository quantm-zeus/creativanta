-- ============================================================================
-- Creativanta P1-05 Migration: Home Dashboard Config & Billing Event Replay Guard
-- Canonical Source: docs/04_contracts/database_schema.md (§13.1, §18.9, §22.14, §26.11, §26.12, §27.1)
--                   docs/05_system/queue_retry_design.md (§7 & Schedule interpretation)
--                   docs/04_contracts/credit_accounting_contract.md (§1, §4, §5)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. Home Dashboard Config (§22.14)
--    Stores workspace-level operator mode defaults, card overrides, and
--    configured local morning_brief_time (default 07:00). Personal onboarding
--    completion authority remains in user_preferences (§18.9, §27.1).
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS home_dashboard_config (
  config_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL UNIQUE REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  operator_mode           VARCHAR(30) NOT NULL DEFAULT 'creator'
                          CHECK (operator_mode IN ('creator', 'seller', 'affiliate_operator', 'live_operator', 'agency_mcn', 'brand_collaboration')),
  card_order_override     JSONB,
  snoozed_cards           JSONB DEFAULT '[]'::jsonb,
  dismissed_cards         UUID[] DEFAULT '{}',
  morning_brief_enabled   BOOLEAN DEFAULT true,
  morning_brief_channels  JSONB DEFAULT '["push", "email"]'::jsonb,
  morning_brief_time      TIME DEFAULT '07:00',
  onboarding_completed    BOOLEAN DEFAULT false,
  onboarding_progress     JSONB DEFAULT '{"step": 0, "completed_steps": []}'::jsonb,
  beginner_tips_dismissed BOOLEAN DEFAULT false,
  last_home_visit_at      TIMESTAMPTZ,
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_home_dashboard_config_tenant_pk UNIQUE (workspace_id, config_id)
);

CREATE INDEX IF NOT EXISTS idx_hdc_workspace ON home_dashboard_config(workspace_id);

ALTER TABLE home_dashboard_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE home_dashboard_config FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON home_dashboard_config;
CREATE POLICY tenant_isolation ON home_dashboard_config
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON home_dashboard_config;
CREATE POLICY admin_ops_scope ON home_dashboard_config
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 2. Billing Events Replay Idempotency Index (§13.1 & credit_accounting_contract.md §4)
--    Ensures each Stripe webhook event ID is recorded at most once per workspace.
-- ----------------------------------------------------------------------------
CREATE UNIQUE INDEX IF NOT EXISTS idx_be_workspace_stripe_event
  ON billing_events(workspace_id, stripe_event_id)
  WHERE stripe_event_id IS NOT NULL;

DROP POLICY IF EXISTS admin_ops_scope ON billing_events;
CREATE POLICY admin_ops_scope ON billing_events
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 3. Narrow Role Grants (§26.12 — NEVER GRANT ALL)
-- ----------------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON home_dashboard_config TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON home_dashboard_config TO admin_user;
GRANT SELECT, INSERT ON billing_events TO admin_user;

-- +goose Down
REVOKE SELECT, INSERT, UPDATE, DELETE ON home_dashboard_config FROM app_user, admin_user;
REVOKE SELECT, INSERT ON billing_events FROM admin_user;
DROP POLICY IF EXISTS admin_ops_scope ON billing_events;
DROP INDEX IF EXISTS idx_be_workspace_stripe_event;
DROP TABLE IF EXISTS home_dashboard_config CASCADE;
