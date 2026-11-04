-- ============================================================================
-- Creativanta P5-03 Migration: Attribution, Metrics & Derivative Feedback
-- Canonical Sources: docs/04_contracts/database_schema.md (§19.15, §19.9D, §11, §7.3)
--                    docs/04_contracts/financial_computation_contract.md (§3)
--                    docs/02_features/production/asset_derivatives.md (RULE-M09-003, EC-M09-004)
--                    docs/02_features/finance/operating_ledger.md (RULE-M19-001, RULE-M19-002)
--                    docs/02_features/commerce/creator_pro_tools.md (RULE-S16-008, RULE-S16-009)
--                    docs/04_contracts/domain_event_catalog.md (§6, §10)
--                    docs/04_contracts/rbac_permission_matrix.md
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. Ensure composite tenant unique key on channel_posts for FK references
-- ----------------------------------------------------------------------------
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'uq_channel_posts_tenant_pk'
  ) THEN
    ALTER TABLE channel_posts ADD CONSTRAINT uq_channel_posts_tenant_pk UNIQUE (workspace_id, channel_post_id);
  END IF;
END $$;

-- ----------------------------------------------------------------------------
-- 2. content_attribution_records Table (§19.15)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS content_attribution_records (
  attribution_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id           UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  publish_item_id        UUID,
  channel_post_id        UUID,
  order_id               UUID NOT NULL,
  attribution_type       VARCHAR(30) NOT NULL, -- direct_click, utm_match, affiliate, organic
  revenue_attributed     NUMERIC(18,6) NOT NULL,
  source_class           source_class NOT NULL DEFAULT 'inferred',
  confidence             confidence_band NOT NULL DEFAULT 'medium',
  utm_source             VARCHAR(100),
  utm_medium             VARCHAR(100),
  utm_campaign           VARCHAR(100),
  metadata               JSONB DEFAULT '{}'::jsonb,
  created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_content_attribution_records_tenant_pk
    UNIQUE (workspace_id, attribution_id),
  CONSTRAINT fk_content_attribution_records_publish_item_id_tenant
    FOREIGN KEY (workspace_id, publish_item_id)
    REFERENCES publish_items(workspace_id, publish_item_id) ON DELETE SET NULL,
  CONSTRAINT fk_content_attribution_records_channel_post_id_tenant
    FOREIGN KEY (workspace_id, channel_post_id)
    REFERENCES channel_posts(workspace_id, channel_post_id) ON DELETE SET NULL,
  CONSTRAINT fk_content_attribution_records_order_id_tenant
    FOREIGN KEY (workspace_id, order_id)
    REFERENCES orders(workspace_id, order_id) ON DELETE CASCADE,
  CONSTRAINT chk_content_attribution_revenue_positive
    CHECK (revenue_attributed >= 0)
);

CREATE INDEX IF NOT EXISTS idx_car_workspace ON content_attribution_records(workspace_id);
CREATE INDEX IF NOT EXISTS idx_car_publish ON content_attribution_records(publish_item_id);
CREATE INDEX IF NOT EXISTS idx_car_order ON content_attribution_records(order_id);
CREATE INDEX IF NOT EXISTS idx_car_channel_post ON content_attribution_records(channel_post_id);

ALTER TABLE content_attribution_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE content_attribution_records FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON content_attribution_records;
CREATE POLICY tenant_isolation ON content_attribution_records
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON content_attribution_records;
CREATE POLICY admin_ops_scope ON content_attribution_records
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON content_attribution_records TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON content_attribution_records TO admin_user;

-- ----------------------------------------------------------------------------
-- 3. channel_post_metrics Table (Post Metrics Snapshots & Denominator Status)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS channel_post_metrics (
  metric_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id           UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  channel_post_id        UUID NOT NULL,
  views                  BIGINT,
  likes                  BIGINT NOT NULL DEFAULT 0,
  comments               BIGINT NOT NULL DEFAULT 0,
  shares                 BIGINT NOT NULL DEFAULT 0,
  saves                  BIGINT NOT NULL DEFAULT 0,
  clicks                 BIGINT,
  is_views_unknown       BOOLEAN NOT NULL DEFAULT false,
  is_clicks_unknown      BOOLEAN NOT NULL DEFAULT false,
  unknown_reason         VARCHAR(100),
  source_class           source_class NOT NULL DEFAULT 'official',
  confidence             confidence_band NOT NULL DEFAULT 'high',
  captured_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_channel_post_metrics_tenant_pk
    UNIQUE (workspace_id, metric_id),
  CONSTRAINT fk_channel_post_metrics_channel_post_id_tenant
    FOREIGN KEY (workspace_id, channel_post_id)
    REFERENCES channel_posts(workspace_id, channel_post_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_cpm_workspace ON channel_post_metrics(workspace_id);
CREATE INDEX IF NOT EXISTS idx_cpm_channel_post ON channel_post_metrics(channel_post_id);
CREATE INDEX IF NOT EXISTS idx_cpm_captured ON channel_post_metrics(captured_at DESC);

ALTER TABLE channel_post_metrics ENABLE ROW LEVEL SECURITY;
ALTER TABLE channel_post_metrics FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON channel_post_metrics;
CREATE POLICY tenant_isolation ON channel_post_metrics
  FOR ALL
  TO app_user
  USING (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  )
  WITH CHECK (
    workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid
  );

DROP POLICY IF EXISTS admin_ops_scope ON channel_post_metrics;
CREATE POLICY admin_ops_scope ON channel_post_metrics
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

GRANT SELECT, INSERT, UPDATE, DELETE ON channel_post_metrics TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON channel_post_metrics TO admin_user;

-- +goose Down
REVOKE SELECT, INSERT, UPDATE, DELETE ON channel_post_metrics FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON channel_post_metrics FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON channel_post_metrics;
DROP POLICY IF EXISTS tenant_isolation ON channel_post_metrics;
DROP TABLE IF EXISTS channel_post_metrics CASCADE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON content_attribution_records FROM admin_user;
REVOKE SELECT, INSERT, UPDATE, DELETE ON content_attribution_records FROM app_user;
DROP POLICY IF EXISTS admin_ops_scope ON content_attribution_records;
DROP POLICY IF EXISTS tenant_isolation ON content_attribution_records;
DROP TABLE IF EXISTS content_attribution_records CASCADE;

ALTER TABLE channel_posts DROP CONSTRAINT IF EXISTS uq_channel_posts_tenant_pk;
