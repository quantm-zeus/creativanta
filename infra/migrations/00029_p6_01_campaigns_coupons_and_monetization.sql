-- ============================================================================
-- Creativanta P6-01 Migration: Campaigns, Coupons and Monetization Coordination
-- Canonical Sources: docs/04_contracts/database_schema.md (§10.2, §10.5, §19.2)
--                    docs/02_features/commerce/monetization_os.md (RULE-M14-001 to RULE-M14-007)
--                    docs/04_contracts/domain_event_catalog.md (§8, §19)
--                    docs/04_contracts/rbac_permission_matrix.md
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. Ensure offers table has tenant composite key and optional validity columns
-- ----------------------------------------------------------------------------
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'uq_offers_tenant_pk'
  ) THEN
    ALTER TABLE offers ADD CONSTRAINT uq_offers_tenant_pk UNIQUE (workspace_id, offer_id);
  END IF;
END $$;

ALTER TABLE offers ADD COLUMN IF NOT EXISTS valid_from TIMESTAMPTZ;
ALTER TABLE offers ADD COLUMN IF NOT EXISTS valid_until TIMESTAMPTZ;

-- ----------------------------------------------------------------------------
-- 2. campaigns Table (§10.5)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS campaigns (
  campaign_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id          UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  campaign_type         VARCHAR(30) NOT NULL, -- content, affiliate, seeding, live, brand_collab
  title                 VARCHAR(500) NOT NULL,
  objective             TEXT,
  status                VARCHAR(20) NOT NULL DEFAULT 'planned', -- planned, ready, live, paused, completed, cancelled
  start_date            DATE,
  end_date              DATE,
  budget                NUMERIC(18,6),
  budget_currency       VARCHAR(5) DEFAULT 'VND',
  related_product_ids   UUID[] DEFAULT '{}',
  related_offer_ids     UUID[] DEFAULT '{}',
  metadata              JSONB DEFAULT '{}'::jsonb,
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at            TIMESTAMPTZ,
  CONSTRAINT uq_campaigns_tenant_pk
    UNIQUE (workspace_id, campaign_id),
  CONSTRAINT chk_campaigns_status
    CHECK (status IN ('planned', 'ready', 'live', 'paused', 'completed', 'cancelled'))
);

CREATE INDEX IF NOT EXISTS idx_campaigns_workspace ON campaigns(workspace_id);
CREATE INDEX IF NOT EXISTS idx_campaigns_status ON campaigns(status);
CREATE INDEX IF NOT EXISTS idx_campaigns_type ON campaigns(campaign_type);

ALTER TABLE campaigns ENABLE ROW LEVEL SECURITY;
ALTER TABLE campaigns FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON campaigns;
CREATE POLICY tenant_isolation ON campaigns
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON campaigns;
CREATE POLICY admin_ops_scope ON campaigns
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 3. coupons Table (§19.2)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS coupons (
  coupon_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id          UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  code                  VARCHAR(50) NOT NULL,
  coupon_type           VARCHAR(20) NOT NULL, -- percentage, fixed_amount, free_shipping
  discount_value        NUMERIC(18,6) NOT NULL,
  min_order_amount      NUMERIC(18,6),
  max_uses              INTEGER,
  current_uses          INTEGER NOT NULL DEFAULT 0,
  lifecycle_state       VARCHAR(20) NOT NULL DEFAULT 'draft', -- draft, active, paused, expired, retired, revoked
  related_offer_ids     UUID[] DEFAULT '{}',
  related_campaign_ids  UUID[] DEFAULT '{}',
  valid_from            TIMESTAMPTZ,
  valid_until           TIMESTAMPTZ,
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at            TIMESTAMPTZ,
  CONSTRAINT uq_coupons_tenant_pk
    UNIQUE (workspace_id, coupon_id),
  CONSTRAINT uq_coupons_workspace_code
    UNIQUE (workspace_id, code),
  CONSTRAINT chk_coupons_lifecycle_state
    CHECK (lifecycle_state IN ('draft', 'active', 'paused', 'expired', 'retired', 'revoked')),
  CONSTRAINT chk_coupons_current_uses_non_negative
    CHECK (current_uses >= 0)
);

CREATE INDEX IF NOT EXISTS idx_coupons_workspace ON coupons(workspace_id);
CREATE INDEX IF NOT EXISTS idx_coupons_state ON coupons(lifecycle_state);
CREATE INDEX IF NOT EXISTS idx_coupons_code ON coupons(workspace_id, code);

ALTER TABLE coupons ENABLE ROW LEVEL SECURITY;
ALTER TABLE coupons FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON coupons;
CREATE POLICY tenant_isolation ON coupons
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON coupons;
CREATE POLICY admin_ops_scope ON coupons
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 4. coupon_redemptions Table (Traceability & Concurrency Ledger Linkage)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS coupon_redemptions (
  redemption_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id          UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  coupon_id             UUID NOT NULL,
  order_id              UUID,
  discount_amount       NUMERIC(18,6) NOT NULL,
  currency              VARCHAR(5) NOT NULL DEFAULT 'VND',
  redeemed_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  metadata              JSONB DEFAULT '{}'::jsonb,
  CONSTRAINT uq_coupon_redemptions_tenant_pk
    UNIQUE (workspace_id, redemption_id),
  CONSTRAINT fk_coupon_redemptions_coupon_id_tenant
    FOREIGN KEY (workspace_id, coupon_id)
    REFERENCES coupons(workspace_id, coupon_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_coupon_redemptions_workspace ON coupon_redemptions(workspace_id);
CREATE INDEX IF NOT EXISTS idx_coupon_redemptions_coupon ON coupon_redemptions(workspace_id, coupon_id);
CREATE INDEX IF NOT EXISTS idx_coupon_redemptions_order ON coupon_redemptions(workspace_id, order_id);

ALTER TABLE coupon_redemptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE coupon_redemptions FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON coupon_redemptions;
CREATE POLICY tenant_isolation ON coupon_redemptions
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON coupon_redemptions;
CREATE POLICY admin_ops_scope ON coupon_redemptions
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 5. Runtime Role Grants
-- ----------------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON campaigns TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON campaigns TO admin_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON coupons TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON coupons TO admin_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON coupon_redemptions TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON coupon_redemptions TO admin_user;

-- +goose Down
DROP POLICY IF EXISTS admin_ops_scope ON coupon_redemptions;
DROP POLICY IF EXISTS tenant_isolation ON coupon_redemptions;
DROP TABLE IF EXISTS coupon_redemptions;

DROP POLICY IF EXISTS admin_ops_scope ON coupons;
DROP POLICY IF EXISTS tenant_isolation ON coupons;
DROP TABLE IF EXISTS coupons;

DROP POLICY IF EXISTS admin_ops_scope ON campaigns;
DROP POLICY IF EXISTS tenant_isolation ON campaigns;
DROP TABLE IF EXISTS campaigns;
