-- ============================================================================
-- Creativanta P7-05 Migration: Public API Quotas, Rotation & Outbound Webhook Deliveries
-- Canonical Sources: docs/04_contracts/database_schema.md (§18.4, §18.4A, §18.4B, §18.5)
--                    docs/02_features/platform/public_api.md (RULE-S24-001..006, EC-S24-001..003)
--                    docs/04_contracts/domain_event_catalog.md (§21.2)
--                    docs/04_contracts/rbac_permission_matrix.md
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. Additional Indexes for api_keys and api_usage_daily Performance
-- ----------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_ak_ws_status
  ON api_keys(workspace_id, status);

CREATE INDEX IF NOT EXISTS idx_ak_expires_active
  ON api_keys(expires_at)
  WHERE status = 'active';

CREATE INDEX IF NOT EXISTS idx_aud_ws_date
  ON api_usage_daily(workspace_id, usage_date DESC);

-- ----------------------------------------------------------------------------
-- 2. api_webhook_deliveries Table (§18.4B delivery audit and replay trail)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS api_webhook_deliveries (
  delivery_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  webhook_subscription_id UUID NOT NULL REFERENCES api_webhook_subscriptions(webhook_subscription_id) ON DELETE CASCADE,
  webhook_event_id        UUID REFERENCES webhook_events(webhook_event_id) ON DELETE SET NULL,
  event_type              VARCHAR(100) NOT NULL,
  target_url              TEXT NOT NULL,
  status_code             INTEGER NOT NULL DEFAULT 0,
  attempt_number          INTEGER NOT NULL DEFAULT 1,
  delivery_status         VARCHAR(30) NOT NULL DEFAULT 'pending'
    CHECK (delivery_status IN ('pending', 'delivered', 'retrying', 'failed', 'replayed')),
  error_message           TEXT,
  request_signature       VARCHAR(128),
  response_body           TEXT,
  is_replay               BOOLEAN NOT NULL DEFAULT FALSE,
  delivered_at            TIMESTAMPTZ,
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_api_webhook_deliveries_tenant_pk
    UNIQUE (workspace_id, delivery_id)
);

CREATE INDEX IF NOT EXISTS idx_awd_workspace
  ON api_webhook_deliveries(workspace_id);

CREATE INDEX IF NOT EXISTS idx_awd_sub
  ON api_webhook_deliveries(webhook_subscription_id);

CREATE INDEX IF NOT EXISTS idx_awd_event
  ON api_webhook_deliveries(webhook_event_id);

CREATE INDEX IF NOT EXISTS idx_awd_status
  ON api_webhook_deliveries(delivery_status);

-- ----------------------------------------------------------------------------
-- 3. Row Level Security & Permissions
-- ----------------------------------------------------------------------------
ALTER TABLE api_webhook_deliveries ENABLE ROW LEVEL SECURITY;
ALTER TABLE api_webhook_deliveries FORCE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON api_webhook_deliveries
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

GRANT SELECT, INSERT, UPDATE, DELETE ON api_webhook_deliveries TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON api_webhook_deliveries TO admin_user;

-- +goose Down

DROP TABLE IF EXISTS api_webhook_deliveries CASCADE;
DROP INDEX IF EXISTS idx_aud_ws_date;
DROP INDEX IF EXISTS idx_ak_expires_active;
DROP INDEX IF EXISTS idx_ak_ws_status;
