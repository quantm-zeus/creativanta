-- ============================================================================
-- Creativanta P1-03 Migration: Settlements, Settlement Lines, Cost Items & Profit Snapshots
-- Canonical Source: docs/04_contracts/database_schema.md (§11.1, §11.2, §11.3, §26.9, §26.11, §26.12)
--                   docs/04_contracts/financial_computation_contract.md (§1–§5)
--                   docs/02_features/finance/operating_ledger.md (M19)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. Settlements (§11.1)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS settlements (
  settlement_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  source_class            source_class NOT NULL DEFAULT 'imported',
  source_platform         VARCHAR(50),
  external_settlement_id  VARCHAR(255),
  connected_account_id    UUID REFERENCES connected_accounts(connected_account_id),
  exchange_rate_snapshot  JSONB NOT NULL DEFAULT '{}'::jsonb,
  import_fingerprint      VARCHAR(128),
  gross_amount            NUMERIC(18,6) NOT NULL,
  net_amount              NUMERIC(18,6) NOT NULL,
  fees                    JSONB DEFAULT '{}'::jsonb,
  deductions              JSONB DEFAULT '{}'::jsonb,
  currency                VARCHAR(5) NOT NULL DEFAULT 'VND',
  settlement_state        VARCHAR(30) NOT NULL DEFAULT 'imported',
  reconciliation_state    reconciliation_state NOT NULL DEFAULT 'imported_only',
  related_order_ids       UUID[] DEFAULT '{}',
  effective_date          DATE,
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at              TIMESTAMPTZ,
  CONSTRAINT uq_settlements_tenant_pk UNIQUE (workspace_id, settlement_id),
  CONSTRAINT chk_settlements_state CHECK (settlement_state IN ('imported', 'normalized', 'ready_for_matching', 'archived'))
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_settlement_external ON settlements(workspace_id, connected_account_id, external_settlement_id)
  WHERE external_settlement_id IS NOT NULL AND connected_account_id IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS idx_settlement_import ON settlements(workspace_id, import_fingerprint)
  WHERE import_fingerprint IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_settlements_workspace ON settlements(workspace_id);

ALTER TABLE settlements ENABLE ROW LEVEL SECURITY;
ALTER TABLE settlements FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON settlements;
CREATE POLICY tenant_isolation ON settlements
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON settlements;
CREATE POLICY admin_ops_scope ON settlements
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 2. Settlement Lines (§26.9)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS settlement_lines (
  line_id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  settlement_id           UUID NOT NULL,
  external_line_id        VARCHAR(255) NOT NULL,
  external_order_id       VARCHAR(255),
  order_id                UUID,
  gross_amount            NUMERIC(18,6) NOT NULL,
  fee_amount              NUMERIC(18,6) NOT NULL DEFAULT 0,
  refund_amount           NUMERIC(18,6) NOT NULL DEFAULT 0,
  net_amount              NUMERIC(18,6) NOT NULL,
  matched_amount          NUMERIC(18,6) NOT NULL DEFAULT 0,
  currency                VARCHAR(5) NOT NULL,
  reconciliation_state    reconciliation_state NOT NULL DEFAULT 'imported_only',
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_settlement_lines_tenant_pk UNIQUE (workspace_id, line_id),
  CONSTRAINT uq_settlement_lines_ext UNIQUE (workspace_id, settlement_id, external_line_id),
  CONSTRAINT fk_settlement_lines_settlement_id_tenant
    FOREIGN KEY (workspace_id, settlement_id) REFERENCES settlements(workspace_id, settlement_id) ON DELETE CASCADE,
  CONSTRAINT fk_settlement_lines_order_id_tenant
    FOREIGN KEY (workspace_id, order_id) REFERENCES orders(workspace_id, order_id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_settlement_lines_workspace ON settlement_lines(workspace_id);
CREATE INDEX IF NOT EXISTS idx_settlement_lines_order ON settlement_lines(workspace_id, order_id);

ALTER TABLE settlement_lines ENABLE ROW LEVEL SECURITY;
ALTER TABLE settlement_lines FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON settlement_lines;
CREATE POLICY tenant_isolation ON settlement_lines
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON settlement_lines;
CREATE POLICY admin_ops_scope ON settlement_lines
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 3. Cost Items (§11.2)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS cost_items (
  cost_item_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  cost_type               VARCHAR(50) NOT NULL, -- platform_fee, shipping, ads_spend, ai_credits, commission, service_tool, cogs, seeding, other
  amount                  NUMERIC(18,6) NOT NULL,
  currency                VARCHAR(5) NOT NULL DEFAULT 'VND',
  description             TEXT,
  related_scope_type      VARCHAR(50), -- workspace, product, campaign, order, asset
  related_scope_id        UUID,
  source_class            source_class NOT NULL DEFAULT 'estimated',
  evidence_id             UUID,
  confidence_reason       TEXT,
  cost_state              VARCHAR(20) NOT NULL DEFAULT 'recorded', -- recorded,pending_evidence,reconciled,estimated,superseded
  effective_date          DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at              TIMESTAMPTZ,
  CONSTRAINT uq_cost_items_tenant_pk UNIQUE (workspace_id, cost_item_id)
);

CREATE INDEX IF NOT EXISTS idx_ci_workspace ON cost_items(workspace_id);
CREATE INDEX IF NOT EXISTS idx_ci_type ON cost_items(cost_type);
CREATE INDEX IF NOT EXISTS idx_ci_date ON cost_items(effective_date);

ALTER TABLE cost_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE cost_items FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON cost_items;
CREATE POLICY tenant_isolation ON cost_items
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON cost_items;
CREATE POLICY admin_ops_scope ON cost_items
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 4. Profit Snapshots (§11.3)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS profit_snapshots (
  snapshot_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  scope_type              VARCHAR(30) NOT NULL, -- workspace, product, platform, campaign, content, period
  scope_id                UUID,
  period_start            DATE NOT NULL,
  period_end              DATE NOT NULL,
  gross_revenue           NUMERIC(18,6) DEFAULT 0,
  platform_fees           NUMERIC(18,6) DEFAULT 0,
  shipping_costs          NUMERIC(18,6) DEFAULT 0,
  affiliate_commissions   NUMERIC(18,6) DEFAULT 0,
  refund_deductions       NUMERIC(18,6) DEFAULT 0,
  cogs                    NUMERIC(18,6) DEFAULT 0,
  ads_spend               NUMERIC(18,6) DEFAULT 0,
  ai_credit_costs         NUMERIC(18,6) DEFAULT 0,
  seeding_costs           NUMERIC(18,6) DEFAULT 0,
  other_costs             NUMERIC(18,6) DEFAULT 0,
  net_profit              NUMERIC(18,6) DEFAULT 0,
  margin_pct              NUMERIC(5,2),
  source_class_mix        JSONB DEFAULT '{}'::jsonb,
  confidence              confidence_band DEFAULT 'medium',
  freshness_at            TIMESTAMPTZ DEFAULT NOW(),
  currency                VARCHAR(5) NOT NULL DEFAULT 'VND',
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_profit_snapshots_tenant_pk UNIQUE (workspace_id, snapshot_id)
);

CREATE INDEX IF NOT EXISTS idx_ps_workspace ON profit_snapshots(workspace_id);
CREATE INDEX IF NOT EXISTS idx_ps_scope ON profit_snapshots(scope_type, scope_id);
CREATE INDEX IF NOT EXISTS idx_ps_period ON profit_snapshots(period_start, period_end);

ALTER TABLE profit_snapshots ENABLE ROW LEVEL SECURITY;
ALTER TABLE profit_snapshots FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON profit_snapshots;
CREATE POLICY tenant_isolation ON profit_snapshots
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON profit_snapshots;
CREATE POLICY admin_ops_scope ON profit_snapshots
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 5. Role Grants (§26.12)
-- ----------------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON
  settlements,
  settlement_lines,
  cost_items,
  profit_snapshots
TO app_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON
  settlements,
  settlement_lines,
  cost_items,
  profit_snapshots
TO admin_user;

-- +goose Down
REVOKE ALL PRIVILEGES ON
  settlements,
  settlement_lines,
  cost_items,
  profit_snapshots
FROM app_user, admin_user;

DROP TABLE IF EXISTS profit_snapshots CASCADE;
DROP TABLE IF EXISTS cost_items CASCADE;
DROP TABLE IF EXISTS settlement_lines CASCADE;
DROP TABLE IF EXISTS settlements CASCADE;
