-- ============================================================================
-- Creativanta P1-04 Migration: Reconciliation Records, Matches & Proof Bundles
-- Canonical Source: docs/04_contracts/database_schema.md (§11.5, §19.9E, §26.9)
--                   docs/04_contracts/financial_computation_contract.md (§4)
--                   docs/02_features/finance/operating_ledger.md (M19)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. Reconciliation Records (§19.9E)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS reconciliation_records (
  record_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  scope_type              VARCHAR(50) NOT NULL, -- order_batch, settlement_batch, affiliate_period, campaign
  scope_description       TEXT,
  related_order_ids       UUID[] DEFAULT '{}',
  related_settlement_ids  UUID[] DEFAULT '{}',
  matched_amount          NUMERIC(18,6) NOT NULL DEFAULT 0,
  discrepancy_amount      NUMERIC(18,6) NOT NULL DEFAULT 0,
  discrepancy_reason      TEXT,
  reconciliation_state    reconciliation_state NOT NULL DEFAULT 'imported_only',
  currency                VARCHAR(5) NOT NULL DEFAULT 'VND',
  mismatches              JSONB DEFAULT '[]'::jsonb,
  override_reason         TEXT,
  override_by             UUID REFERENCES users(user_id),
  override_at             TIMESTAMPTZ,
  audit_event_id          UUID,
  period_start            DATE,
  period_end              DATE,
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_reconciliation_records_tenant_pk UNIQUE (workspace_id, record_id)
);

CREATE INDEX IF NOT EXISTS idx_rr_workspace ON reconciliation_records(workspace_id);
CREATE INDEX IF NOT EXISTS idx_rr_state ON reconciliation_records(reconciliation_state);

ALTER TABLE reconciliation_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE reconciliation_records FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON reconciliation_records;
CREATE POLICY tenant_isolation ON reconciliation_records
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON reconciliation_records;
CREATE POLICY admin_ops_scope ON reconciliation_records
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 2. Proof Bundles (§11.5)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS proof_bundles (
  proof_bundle_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  claim_scope             VARCHAR(100) NOT NULL,
  claim_summary           TEXT NOT NULL,
  supporting_evidence_ids UUID[] NOT NULL DEFAULT '{}',
  source_class_context    JSONB DEFAULT '{}'::jsonb,
  confidence              confidence_band DEFAULT 'medium',
  coverage_summary        TEXT,
  unresolved_gaps         TEXT,
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at              TIMESTAMPTZ,
  CONSTRAINT uq_proof_bundles_tenant_pk UNIQUE (workspace_id, proof_bundle_id)
);

CREATE INDEX IF NOT EXISTS idx_proof_bundles_workspace ON proof_bundles(workspace_id);

ALTER TABLE proof_bundles ENABLE ROW LEVEL SECURITY;
ALTER TABLE proof_bundles FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON proof_bundles;
CREATE POLICY tenant_isolation ON proof_bundles
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON proof_bundles;
CREATE POLICY admin_ops_scope ON proof_bundles
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 3. Reconciliation Matches (§4 Partial Match Capacity)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS reconciliation_matches (
  match_id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  record_id               UUID,
  settlement_id           UUID NOT NULL,
  line_id                 UUID NOT NULL,
  order_id                UUID NOT NULL,
  allocated_amount        NUMERIC(18,6) NOT NULL,
  currency                VARCHAR(5) NOT NULL DEFAULT 'VND',
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_reconciliation_matches_tenant_pk UNIQUE (workspace_id, match_id),
  CONSTRAINT fk_rm_record_tenant
    FOREIGN KEY (workspace_id, record_id) REFERENCES reconciliation_records(workspace_id, record_id) ON DELETE SET NULL,
  CONSTRAINT fk_rm_settlement_tenant
    FOREIGN KEY (workspace_id, settlement_id) REFERENCES settlements(workspace_id, settlement_id) ON DELETE CASCADE,
  CONSTRAINT fk_rm_line_tenant
    FOREIGN KEY (workspace_id, line_id) REFERENCES settlement_lines(workspace_id, line_id) ON DELETE CASCADE,
  CONSTRAINT fk_rm_order_tenant
    FOREIGN KEY (workspace_id, order_id) REFERENCES orders(workspace_id, order_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_rm_workspace ON reconciliation_matches(workspace_id);
CREATE INDEX IF NOT EXISTS idx_rm_order ON reconciliation_matches(workspace_id, order_id);
CREATE INDEX IF NOT EXISTS idx_rm_line ON reconciliation_matches(workspace_id, line_id);

ALTER TABLE reconciliation_matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE reconciliation_matches FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON reconciliation_matches;
CREATE POLICY tenant_isolation ON reconciliation_matches
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON reconciliation_matches;
CREATE POLICY admin_ops_scope ON reconciliation_matches
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 4. Orders capacity column
-- ----------------------------------------------------------------------------
ALTER TABLE orders ADD COLUMN IF NOT EXISTS matched_amount NUMERIC(18,6) NOT NULL DEFAULT 0;

-- ----------------------------------------------------------------------------
-- 5. Role Grants
-- ----------------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON
  reconciliation_records,
  proof_bundles,
  reconciliation_matches
TO app_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON
  reconciliation_records,
  proof_bundles,
  reconciliation_matches
TO admin_user;

-- +goose Down
REVOKE ALL PRIVILEGES ON
  reconciliation_records,
  proof_bundles,
  reconciliation_matches
FROM app_user, admin_user;

DROP TABLE IF EXISTS reconciliation_matches CASCADE;
DROP TABLE IF EXISTS proof_bundles CASCADE;
DROP TABLE IF EXISTS reconciliation_records CASCADE;
ALTER TABLE orders DROP COLUMN IF EXISTS matched_amount;
