-- ============================================================================
-- Creativanta P6-08 Migration: Cross-Domain Commerce Conversions & Lineage
-- Canonical Sources: docs/04_contracts/database_schema.md (§5.4, §5.5, §6.1, §6.2, §9.2, §10.5, §12.1, §10.2, §16.5, §19.10)
--                    docs/02_features/intelligence/opportunity_board.md (RULE-M04-004, RULE-M04-006, EC-M04-002)
--                    docs/02_features/content/idea_engine.md (RULE-M05-001, RULE-M05-002, RULE-M05-003)
--                    docs/02_features/engagement/unified_inbox.md (RULE-M12-003, RULE-M12-005)
--                    docs/04_contracts/domain_event_catalog.md (§3, §4, §7, §8)
--                    docs/04_contracts/rbac_permission_matrix.md (§2.2, §2.3, §2.7, §2.11, §2.12, §2.13)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. cross_domain_conversions Table (Shared Lineage & Audit)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS cross_domain_conversions (
  conversion_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id        UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  source_type         VARCHAR(50) NOT NULL, -- opportunity, idea, thread
  source_id           UUID NOT NULL,
  target_type         VARCHAR(50) NOT NULL, -- campaign, live_session, offer, sample_request, brand_deal
  target_id           UUID NOT NULL,
  converted_by        UUID NOT NULL,
  status              VARCHAR(20) NOT NULL DEFAULT 'completed',
  lineage_depth       INTEGER NOT NULL DEFAULT 1,
  root_source_type    VARCHAR(50),
  root_source_id      UUID,
  metadata            JSONB NOT NULL DEFAULT '{}',
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_cross_domain_conversions_tenant_pk
    UNIQUE (workspace_id, conversion_id),
  CONSTRAINT chk_cdc_source_type
    CHECK (source_type IN ('opportunity', 'idea', 'thread')),
  CONSTRAINT chk_cdc_target_type
    CHECK (target_type IN ('campaign', 'live_session', 'offer', 'sample_request', 'brand_deal')),
  CONSTRAINT chk_cdc_status
    CHECK (status IN ('completed', 'failed', 'rolled_back')),
  CONSTRAINT chk_cdc_lineage_depth
    CHECK (lineage_depth >= 1)
);

CREATE INDEX IF NOT EXISTS idx_cdc_workspace ON cross_domain_conversions(workspace_id);
CREATE INDEX IF NOT EXISTS idx_cdc_source ON cross_domain_conversions(workspace_id, source_type, source_id);
CREATE INDEX IF NOT EXISTS idx_cdc_target ON cross_domain_conversions(workspace_id, target_type, target_id);
CREATE INDEX IF NOT EXISTS idx_cdc_created_at ON cross_domain_conversions(workspace_id, created_at DESC);

ALTER TABLE cross_domain_conversions ENABLE ROW LEVEL SECURITY;
ALTER TABLE cross_domain_conversions FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON cross_domain_conversions;
CREATE POLICY tenant_isolation ON cross_domain_conversions
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

GRANT SELECT, INSERT, UPDATE, DELETE ON cross_domain_conversions TO app_user;

-- +goose Down
DROP POLICY IF EXISTS tenant_isolation ON cross_domain_conversions;
DROP TABLE IF EXISTS cross_domain_conversions;
