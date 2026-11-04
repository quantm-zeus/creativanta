-- ============================================================================
-- Creativanta P6-03 Migration: Affiliate Links, Attribution, Commissions & Payouts
-- Canonical Sources: docs/04_contracts/database_schema.md (§10.4, §10.4B, §22.14)
--                    docs/02_features/commerce/affiliate_network.md (RULE-M16-001 to RULE-M16-009)
--                    docs/02_features/finance/operating_ledger.md (RULE-M19-001 to RULE-M19-004)
--                    docs/04_contracts/financial_computation_contract.md (§1 Recognition)
--                    docs/04_contracts/domain_event_catalog.md (§8, §15D, §19)
--                    docs/04_contracts/rbac_permission_matrix.md (§2.7)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. affiliate_links Table (§10.4)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS affiliate_links (
  affiliate_link_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id                    UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  product_id                      UUID,
  offer_id                        UUID,
  campaign_id                     UUID,
  platform                        VARCHAR(50) NOT NULL,
  original_url                    TEXT NOT NULL,
  tracked_url                     TEXT NOT NULL,
  short_code                      VARCHAR(50),
  commission_rate                 NUMERIC(5,2),
  lifecycle_state                 VARCHAR(20) NOT NULL DEFAULT 'active', -- draft, active, paused, revoked, expired
  last_health_check_at            TIMESTAMPTZ,
  health_status                   VARCHAR(30) DEFAULT 'healthy', -- healthy, warning, broken, expired, product_unavailable
  click_count                     INTEGER NOT NULL DEFAULT 0,
  conversion_count                INTEGER NOT NULL DEFAULT 0,
  revenue_attributed              NUMERIC(18,6) NOT NULL DEFAULT 0,
  expires_at                      TIMESTAMPTZ,
  suggested_replacement_product_id UUID,
  created_at                      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at                      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at                      TIMESTAMPTZ,
  CONSTRAINT uq_affiliate_links_tenant_pk
    UNIQUE (workspace_id, affiliate_link_id),
  CONSTRAINT chk_affiliate_links_lifecycle
    CHECK (lifecycle_state IN ('draft', 'active', 'paused', 'revoked', 'expired')),
  CONSTRAINT chk_affiliate_links_health
    CHECK (health_status IN ('healthy', 'warning', 'broken', 'expired', 'product_unavailable'))
);

CREATE INDEX IF NOT EXISTS idx_affiliate_links_workspace ON affiliate_links(workspace_id);
CREATE INDEX IF NOT EXISTS idx_affiliate_links_state ON affiliate_links(lifecycle_state);
CREATE INDEX IF NOT EXISTS idx_affiliate_links_health ON affiliate_links(health_status);
CREATE INDEX IF NOT EXISTS idx_affiliate_links_short_code ON affiliate_links(short_code);

ALTER TABLE affiliate_links ENABLE ROW LEVEL SECURITY;
ALTER TABLE affiliate_links FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON affiliate_links;
CREATE POLICY tenant_isolation ON affiliate_links
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON affiliate_links;
CREATE POLICY admin_ops_scope ON affiliate_links
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 2. creator_assignments Table
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS creator_assignments (
  assignment_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id          UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  campaign_id           UUID REFERENCES campaigns(campaign_id) ON DELETE CASCADE,
  creator_entity_id     UUID NOT NULL,
  affiliate_link_id     UUID REFERENCES affiliate_links(affiliate_link_id) ON DELETE SET NULL,
  coupon_id             UUID REFERENCES coupons(coupon_id) ON DELETE SET NULL,
  status                VARCHAR(20) NOT NULL DEFAULT 'active', -- active, completed, cancelled
  notes                 TEXT,
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at            TIMESTAMPTZ,
  CONSTRAINT uq_creator_assignments_tenant_pk
    UNIQUE (workspace_id, assignment_id),
  CONSTRAINT chk_creator_assignments_status
    CHECK (status IN ('active', 'completed', 'cancelled'))
);

CREATE INDEX IF NOT EXISTS idx_creator_assignments_workspace ON creator_assignments(workspace_id);
CREATE INDEX IF NOT EXISTS idx_creator_assignments_campaign ON creator_assignments(campaign_id);
CREATE INDEX IF NOT EXISTS idx_creator_assignments_creator ON creator_assignments(creator_entity_id);

ALTER TABLE creator_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE creator_assignments FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON creator_assignments;
CREATE POLICY tenant_isolation ON creator_assignments
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON creator_assignments;
CREATE POLICY admin_ops_scope ON creator_assignments
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 3. affiliate_attributions Table
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS affiliate_attributions (
  attribution_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id          UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  order_id              UUID NOT NULL,
  affiliate_link_id     UUID NOT NULL REFERENCES affiliate_links(affiliate_link_id) ON DELETE CASCADE,
  creator_entity_id     UUID,
  click_id              VARCHAR(100),
  touchpoint_count      INTEGER NOT NULL DEFAULT 1,
  is_multi_touch        BOOLEAN NOT NULL DEFAULT FALSE,
  source_class          VARCHAR(30) NOT NULL, -- official, imported, inferred, estimated, unreconciled
  confidence            VARCHAR(20) NOT NULL, -- high, medium, low
  attribution_note      TEXT,
  order_amount          NUMERIC(18,6) NOT NULL,
  attributed_revenue    NUMERIC(18,6) NOT NULL,
  commission_amount     NUMERIC(18,6) NOT NULL,
  currency              VARCHAR(5) NOT NULL DEFAULT 'VND',
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_affiliate_attributions_tenant_pk
    UNIQUE (workspace_id, attribution_id),
  CONSTRAINT chk_affiliate_attributions_source
    CHECK (source_class IN ('official', 'imported', 'inferred', 'estimated', 'unreconciled')),
  CONSTRAINT chk_affiliate_attributions_confidence
    CHECK (confidence IN ('high', 'medium', 'low'))
);

CREATE INDEX IF NOT EXISTS idx_affiliate_attributions_workspace ON affiliate_attributions(workspace_id);
CREATE INDEX IF NOT EXISTS idx_affiliate_attributions_order ON affiliate_attributions(order_id);
CREATE INDEX IF NOT EXISTS idx_affiliate_attributions_link ON affiliate_attributions(affiliate_link_id);
CREATE INDEX IF NOT EXISTS idx_affiliate_attributions_source ON affiliate_attributions(source_class);

ALTER TABLE affiliate_attributions ENABLE ROW LEVEL SECURITY;
ALTER TABLE affiliate_attributions FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON affiliate_attributions;
CREATE POLICY tenant_isolation ON affiliate_attributions
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON affiliate_attributions;
CREATE POLICY admin_ops_scope ON affiliate_attributions
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 4. affiliate_commissions Table (§10.4B)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS affiliate_commissions (
  commission_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id          UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  affiliate_link_id     UUID NOT NULL REFERENCES affiliate_links(affiliate_link_id) ON DELETE CASCADE,
  order_id              UUID NOT NULL,
  creator_entity_id     UUID,
  commission_amount     NUMERIC(18,6) NOT NULL,
  currency              VARCHAR(5) NOT NULL DEFAULT 'VND',
  status                VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, confirmed, clawed_back, paid_out
  hold_until            TIMESTAMPTZ NOT NULL,
  clawback_reason       VARCHAR(50), -- refund, partial_refund, fraud
  clawback_amount       NUMERIC(18,6),
  payout_id             UUID,
  confirmed_at          TIMESTAMPTZ,
  clawed_back_at        TIMESTAMPTZ,
  paid_out_at           TIMESTAMPTZ,
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_affiliate_commissions_tenant_pk
    UNIQUE (workspace_id, commission_id),
  CONSTRAINT chk_affiliate_commissions_status
    CHECK (status IN ('pending', 'confirmed', 'clawed_back', 'paid_out'))
);

CREATE INDEX IF NOT EXISTS idx_affiliate_commissions_workspace ON affiliate_commissions(workspace_id);
CREATE INDEX IF NOT EXISTS idx_affiliate_commissions_link ON affiliate_commissions(affiliate_link_id);
CREATE INDEX IF NOT EXISTS idx_affiliate_commissions_status ON affiliate_commissions(status);
CREATE INDEX IF NOT EXISTS idx_affiliate_commissions_hold ON affiliate_commissions(hold_until) WHERE status = 'pending';

ALTER TABLE affiliate_commissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE affiliate_commissions FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON affiliate_commissions;
CREATE POLICY tenant_isolation ON affiliate_commissions
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON affiliate_commissions;
CREATE POLICY admin_ops_scope ON affiliate_commissions
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 5. affiliate_payouts Table
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS affiliate_payouts (
  payout_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id          UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  creator_entity_id     UUID NOT NULL,
  commission_ids        UUID[] NOT NULL DEFAULT '{}',
  total_amount          NUMERIC(18,6) NOT NULL,
  currency              VARCHAR(5) NOT NULL DEFAULT 'VND',
  status                VARCHAR(20) NOT NULL DEFAULT 'pending', -- pending, processing, completed, failed
  proof_hash            VARCHAR(128),
  proof_metadata        JSONB DEFAULT '{}'::jsonb,
  settlement_id         UUID,
  paid_at               TIMESTAMPTZ,
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_affiliate_payouts_tenant_pk
    UNIQUE (workspace_id, payout_id),
  CONSTRAINT chk_affiliate_payouts_status
    CHECK (status IN ('pending', 'processing', 'completed', 'failed'))
);

CREATE INDEX IF NOT EXISTS idx_affiliate_payouts_workspace ON affiliate_payouts(workspace_id);
CREATE INDEX IF NOT EXISTS idx_affiliate_payouts_creator ON affiliate_payouts(creator_entity_id);
CREATE INDEX IF NOT EXISTS idx_affiliate_payouts_status ON affiliate_payouts(status);

ALTER TABLE affiliate_payouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE affiliate_payouts FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON affiliate_payouts;
CREATE POLICY tenant_isolation ON affiliate_payouts
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON affiliate_payouts;
CREATE POLICY admin_ops_scope ON affiliate_payouts
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 6. affiliate_statements & affiliate_statement_items Tables
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS affiliate_statements (
  statement_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id          UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  platform              VARCHAR(50) NOT NULL,
  external_statement_ref VARCHAR(100) NOT NULL,
  period_start          DATE NOT NULL,
  period_end            DATE NOT NULL,
  total_commission      NUMERIC(18,6) NOT NULL DEFAULT 0,
  currency              VARCHAR(5) NOT NULL DEFAULT 'VND',
  reconciliation_state  VARCHAR(35) NOT NULL DEFAULT 'imported_only',
  item_count            INTEGER NOT NULL DEFAULT 0,
  reconciled_item_count INTEGER NOT NULL DEFAULT 0,
  imported_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_affiliate_statements_tenant_pk
    UNIQUE (workspace_id, statement_id),
  CONSTRAINT chk_affiliate_statements_reconciliation
    CHECK (reconciliation_state IN ('imported_only', 'inferred_pending_confirmation', 'partially_reconciled', 'fully_reconciled', 'conflict_detected', 'manually_overridden'))
);

CREATE INDEX IF NOT EXISTS idx_affiliate_statements_workspace ON affiliate_statements(workspace_id);
CREATE INDEX IF NOT EXISTS idx_affiliate_statements_state ON affiliate_statements(reconciliation_state);

ALTER TABLE affiliate_statements ENABLE ROW LEVEL SECURITY;
ALTER TABLE affiliate_statements FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON affiliate_statements;
CREATE POLICY tenant_isolation ON affiliate_statements
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON affiliate_statements;
CREATE POLICY admin_ops_scope ON affiliate_statements
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

CREATE TABLE IF NOT EXISTS affiliate_statement_items (
  item_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  statement_id          UUID NOT NULL REFERENCES affiliate_statements(statement_id) ON DELETE CASCADE,
  external_order_id     VARCHAR(100) NOT NULL,
  order_amount          NUMERIC(18,6) NOT NULL,
  commission_amount     NUMERIC(18,6) NOT NULL,
  matched_order_id      UUID,
  matched_commission_id UUID,
  status                VARCHAR(30) NOT NULL DEFAULT 'unreconciled', -- unreconciled, matched, conflict
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_affiliate_statement_items_stmt ON affiliate_statement_items(statement_id);
CREATE INDEX IF NOT EXISTS idx_affiliate_statement_items_ext ON affiliate_statement_items(external_order_id);

-- ----------------------------------------------------------------------------
-- 7. link_health_records Table (§22.14)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS link_health_records (
  health_id                     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id                  UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  affiliate_link_id             UUID NOT NULL REFERENCES affiliate_links(affiliate_link_id) ON DELETE CASCADE,
  http_status                   INTEGER,
  product_status                VARCHAR(30), -- available, out_of_stock, discontinued, price_changed, unknown
  commission_status             VARCHAR(30), -- active, changed, suspended, unknown
  link_status                   VARCHAR(20) NOT NULL DEFAULT 'healthy', -- healthy, warning, broken, expired
  expiry_date                   TIMESTAMPTZ,
  suggested_action              TEXT,
  checked_at                    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  alert_sent                    BOOLEAN NOT NULL DEFAULT false,
  estimated_revenue_impact      NUMERIC(18,6), -- daily/monthly revenue at risk
  suggested_replacement_product_id UUID,
  created_at                    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_link_health_records_tenant_pk
    UNIQUE (workspace_id, health_id),
  CONSTRAINT chk_link_health_records_status
    CHECK (link_status IN ('healthy', 'warning', 'broken', 'expired'))
);

CREATE INDEX IF NOT EXISTS idx_link_health_records_workspace ON link_health_records(workspace_id);
CREATE INDEX IF NOT EXISTS idx_link_health_records_link ON link_health_records(affiliate_link_id);
CREATE INDEX IF NOT EXISTS idx_link_health_records_status ON link_health_records(link_status);
CREATE INDEX IF NOT EXISTS idx_link_health_records_checked ON link_health_records(checked_at DESC);

ALTER TABLE link_health_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE link_health_records FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON link_health_records;
CREATE POLICY tenant_isolation ON link_health_records
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON link_health_records;
CREATE POLICY admin_ops_scope ON link_health_records
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 8. Table Grants
-- ----------------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON affiliate_links TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON affiliate_links TO admin_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON creator_assignments TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON creator_assignments TO admin_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON affiliate_attributions TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON affiliate_attributions TO admin_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON affiliate_commissions TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON affiliate_commissions TO admin_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON affiliate_payouts TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON affiliate_payouts TO admin_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON affiliate_statements TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON affiliate_statements TO admin_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON affiliate_statement_items TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON affiliate_statement_items TO admin_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON link_health_records TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON link_health_records TO admin_user;

-- +goose Down
DROP POLICY IF EXISTS admin_ops_scope ON link_health_records;
DROP POLICY IF EXISTS tenant_isolation ON link_health_records;
DROP TABLE IF EXISTS link_health_records CASCADE;

DROP TABLE IF EXISTS affiliate_statement_items CASCADE;

DROP POLICY IF EXISTS admin_ops_scope ON affiliate_statements;
DROP POLICY IF EXISTS tenant_isolation ON affiliate_statements;
DROP TABLE IF EXISTS affiliate_statements CASCADE;

DROP POLICY IF EXISTS admin_ops_scope ON affiliate_payouts;
DROP POLICY IF EXISTS tenant_isolation ON affiliate_payouts;
DROP TABLE IF EXISTS affiliate_payouts CASCADE;

DROP POLICY IF EXISTS admin_ops_scope ON affiliate_commissions;
DROP POLICY IF EXISTS tenant_isolation ON affiliate_commissions;
DROP TABLE IF EXISTS affiliate_commissions CASCADE;

DROP POLICY IF EXISTS admin_ops_scope ON affiliate_attributions;
DROP POLICY IF EXISTS tenant_isolation ON affiliate_attributions;
DROP TABLE IF EXISTS affiliate_attributions CASCADE;

DROP POLICY IF EXISTS admin_ops_scope ON creator_assignments;
DROP POLICY IF EXISTS tenant_isolation ON creator_assignments;
DROP TABLE IF EXISTS creator_assignments CASCADE;

DROP POLICY IF EXISTS admin_ops_scope ON affiliate_links;
DROP POLICY IF EXISTS tenant_isolation ON affiliate_links;
DROP TABLE IF EXISTS affiliate_links CASCADE;
