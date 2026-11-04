-- ============================================================================
-- Creativanta P6-06 Migration: Seeding Sample Requests & Shipments (M18)
-- Canonical Sources: docs/04_contracts/database_schema.md (§19.10, §22.14)
--                    docs/02_features/commerce/seeding_crm.md (RULE-M18-001 to RULE-M18-006)
--                    docs/04_contracts/domain_event_catalog.md (§19)
--                    docs/04_contracts/rbac_permission_matrix.md (§2.12)
--                    docs/04_contracts/financial_computation_contract.md (§3 Aggregation)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. sample_requests Table (§19.10)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS sample_requests (
  request_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id        UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  campaign_id         UUID REFERENCES campaigns(campaign_id) ON DELETE SET NULL,
  product_id          UUID REFERENCES products(product_id) ON DELETE RESTRICT,
  creator_entity_id   UUID REFERENCES entities(entity_id) ON DELETE RESTRICT,
  status              VARCHAR(20) NOT NULL DEFAULT 'requested',
  quantity            INTEGER NOT NULL DEFAULT 1,
  outcome_status      VARCHAR(20) NOT NULL DEFAULT 'pending',
  outcome             JSONB NOT NULL DEFAULT '{}',
  follow_up_status    VARCHAR(20) NOT NULL DEFAULT 'pending_followup',
  shipping_address    JSONB DEFAULT '{}',
  content_requirements TEXT,
  deadline            DATE,
  decline_reason      TEXT,
  notes               TEXT,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at          TIMESTAMPTZ,
  CONSTRAINT uq_sample_requests_tenant_pk
    UNIQUE (workspace_id, request_id),
  CONSTRAINT chk_sample_requests_status
    CHECK (status IN ('requested', 'approved', 'declined', 'fulfilled', 'cancelled')),
  CONSTRAINT chk_sample_requests_outcome_status
    CHECK (outcome_status IN ('pending', 'logged')),
  CONSTRAINT chk_sample_requests_follow_up_status
    CHECK (follow_up_status IN ('pending_followup', 'contacted', 'responded', 'no_response')),
  CONSTRAINT chk_sample_requests_quantity_positive
    CHECK (quantity > 0)
);

CREATE INDEX IF NOT EXISTS idx_sample_requests_workspace ON sample_requests(workspace_id);
CREATE INDEX IF NOT EXISTS idx_sample_requests_campaign ON sample_requests(campaign_id);
CREATE INDEX IF NOT EXISTS idx_sample_requests_product ON sample_requests(product_id);
CREATE INDEX IF NOT EXISTS idx_sample_requests_creator ON sample_requests(creator_entity_id);
CREATE INDEX IF NOT EXISTS idx_sample_requests_status ON sample_requests(status);
CREATE INDEX IF NOT EXISTS idx_sample_requests_outcome_status ON sample_requests(outcome_status);
CREATE INDEX IF NOT EXISTS idx_sample_requests_follow_up_status ON sample_requests(follow_up_status);

ALTER TABLE sample_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE sample_requests FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON sample_requests;
CREATE POLICY tenant_isolation ON sample_requests
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON sample_requests;
CREATE POLICY admin_ops_scope ON sample_requests
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 2. sample_shipments Table (§19.10)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS sample_shipments (
  shipment_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  request_id          UUID NOT NULL REFERENCES sample_requests(request_id) ON DELETE CASCADE,
  workspace_id        UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  tracking_number     VARCHAR(100),
  carrier             VARCHAR(50),
  shipping_cost       NUMERIC(18,6) NOT NULL DEFAULT 0,
  shipped_at          TIMESTAMPTZ,
  delivered_at        TIMESTAMPTZ,
  status              VARCHAR(20) NOT NULL DEFAULT 'preparing',
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_sample_shipments_tenant_pk
    UNIQUE (workspace_id, shipment_id),
  CONSTRAINT chk_sample_shipments_status
    CHECK (status IN ('preparing', 'shipped', 'delivered', 'lost', 'returned', 'closed'))
);

CREATE INDEX IF NOT EXISTS idx_sample_shipments_workspace ON sample_shipments(workspace_id);
CREATE INDEX IF NOT EXISTS idx_sample_shipments_request ON sample_shipments(request_id);
CREATE INDEX IF NOT EXISTS idx_sample_shipments_status ON sample_shipments(status);
CREATE INDEX IF NOT EXISTS idx_sample_shipments_tracking ON sample_shipments(tracking_number);

-- Tenant Foreign Key
ALTER TABLE sample_shipments
  DROP CONSTRAINT IF EXISTS fk_sample_shipments_request_id_tenant;
ALTER TABLE sample_shipments
  ADD CONSTRAINT fk_sample_shipments_request_id_tenant
  FOREIGN KEY (workspace_id, request_id)
  REFERENCES sample_requests(workspace_id, request_id)
  ON DELETE CASCADE;

ALTER TABLE sample_shipments ENABLE ROW LEVEL SECURITY;
ALTER TABLE sample_shipments FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON sample_shipments;
CREATE POLICY tenant_isolation ON sample_shipments
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON sample_shipments;
CREATE POLICY admin_ops_scope ON sample_shipments
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 3. Grants
-- ----------------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON sample_requests TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON sample_requests TO admin_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON sample_shipments TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON sample_shipments TO admin_user;

-- +goose Down
DROP POLICY IF EXISTS admin_ops_scope ON sample_shipments;
DROP POLICY IF EXISTS tenant_isolation ON sample_shipments;
DROP TABLE IF EXISTS sample_shipments CASCADE;

DROP POLICY IF EXISTS admin_ops_scope ON sample_requests;
DROP POLICY IF EXISTS tenant_isolation ON sample_requests;
DROP TABLE IF EXISTS sample_requests CASCADE;
