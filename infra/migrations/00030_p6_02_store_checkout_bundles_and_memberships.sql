-- ============================================================================
-- Creativanta P6-02 Migration: Store, Checkout, Bundles, Digital Delivery & Memberships
-- Canonical Sources: docs/04_contracts/database_schema.md (§10.3, §19.3, §19.4, §19.4B, §19.7)
--                    docs/02_features/commerce/creator_store.md (RULE-M15-001 to RULE-M15-007)
--                    docs/02_features/commerce/product_hub.md (RULE-M13-001 to RULE-M13-007)
--                    docs/04_contracts/domain_event_catalog.md (§8, §19)
--                    docs/04_contracts/rbac_permission_matrix.md
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. store_pages Table (§19.3)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS store_pages (
  store_page_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id          UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  title                 VARCHAR(255) NOT NULL,
  slug                  VARCHAR(100) NOT NULL,
  description           TEXT,
  layout                JSONB DEFAULT '{}'::jsonb,
  theme_overrides       JSONB DEFAULT '{}'::jsonb,
  status                VARCHAR(20) NOT NULL DEFAULT 'draft',
  custom_domain         VARCHAR(255),
  seo_config            JSONB DEFAULT '{}'::jsonb,
  widget_config         JSONB DEFAULT '{}'::jsonb,
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at            TIMESTAMPTZ,
  CONSTRAINT uq_store_pages_tenant_pk
    UNIQUE (workspace_id, store_page_id),
  CONSTRAINT uq_store_pages_workspace_slug
    UNIQUE (workspace_id, slug),
  CONSTRAINT chk_store_pages_status
    CHECK (status IN ('draft', 'published', 'hidden', 'retired'))
);

CREATE INDEX IF NOT EXISTS idx_store_pages_workspace ON store_pages(workspace_id);
CREATE INDEX IF NOT EXISTS idx_store_pages_status ON store_pages(status);
CREATE INDEX IF NOT EXISTS idx_store_pages_slug ON store_pages(workspace_id, slug);

ALTER TABLE store_pages ENABLE ROW LEVEL SECURITY;
ALTER TABLE store_pages FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON store_pages;
CREATE POLICY tenant_isolation ON store_pages
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON store_pages;
CREATE POLICY admin_ops_scope ON store_pages
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 2. membership_plans Table (§19.4)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS membership_plans (
  plan_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id          UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  title                 VARCHAR(255) NOT NULL,
  description           TEXT,
  price                 NUMERIC(18,6) NOT NULL,
  currency              VARCHAR(5) DEFAULT 'VND',
  billing_interval      VARCHAR(10) NOT NULL DEFAULT 'monthly',
  benefits              JSONB DEFAULT '[]'::jsonb,
  entitlement_config    JSONB NOT NULL DEFAULT '{}'::jsonb, -- creator-store content/feature/support entitlements, NOT SaaS workspace privileges
  status                VARCHAR(20) NOT NULL DEFAULT 'draft',
  subscriber_count      INTEGER DEFAULT 0,
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at            TIMESTAMPTZ,
  CONSTRAINT uq_membership_plans_tenant_pk
    UNIQUE (workspace_id, plan_id),
  CONSTRAINT chk_membership_plans_status
    CHECK (status IN ('draft', 'active', 'hidden', 'paused', 'retired')),
  CONSTRAINT chk_membership_plans_billing_interval
    CHECK (billing_interval IN ('monthly', 'quarterly', 'yearly')),
  CONSTRAINT chk_membership_plans_price_non_negative
    CHECK (price >= 0),
  CONSTRAINT chk_membership_plans_subscriber_count_non_negative
    CHECK (subscriber_count >= 0)
);

CREATE INDEX IF NOT EXISTS idx_membership_plans_workspace ON membership_plans(workspace_id);
CREATE INDEX IF NOT EXISTS idx_membership_plans_status ON membership_plans(status);

ALTER TABLE membership_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE membership_plans FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON membership_plans;
CREATE POLICY tenant_isolation ON membership_plans
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON membership_plans;
CREATE POLICY admin_ops_scope ON membership_plans
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 3. membership_subscriptions Table (§19.4B)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS membership_subscriptions (
  membership_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id              UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  plan_id                   UUID NOT NULL,
  customer_entity_id        UUID NOT NULL,
  status                    VARCHAR(20) NOT NULL DEFAULT 'active',
  provider_subscription_id  VARCHAR(255),
  current_period_start      TIMESTAMPTZ NOT NULL,
  current_period_end        TIMESTAMPTZ NOT NULL,
  entitlement_snapshot      JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at                TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at                TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_membership_subscriptions_tenant_pk
    UNIQUE (workspace_id, membership_id),
  CONSTRAINT uq_membership_subscriptions_provider_id
    UNIQUE (workspace_id, provider_subscription_id),
  CONSTRAINT chk_membership_subscriptions_status
    CHECK (status IN ('active', 'cancelled', 'expired')),
  CONSTRAINT fk_membership_subscriptions_plan_id_tenant
    FOREIGN KEY (workspace_id, plan_id)
    REFERENCES membership_plans(workspace_id, plan_id) ON DELETE CASCADE,
  CONSTRAINT fk_membership_subscriptions_customer_entity_id_tenant
    FOREIGN KEY (workspace_id, customer_entity_id)
    REFERENCES entities(workspace_id, entity_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_membership_subscriptions_workspace ON membership_subscriptions(workspace_id);
CREATE INDEX IF NOT EXISTS idx_membership_subscriptions_plan ON membership_subscriptions(workspace_id, plan_id);
CREATE INDEX IF NOT EXISTS idx_membership_subscriptions_customer ON membership_subscriptions(workspace_id, customer_entity_id);
CREATE INDEX IF NOT EXISTS idx_membership_subscriptions_status ON membership_subscriptions(status);

ALTER TABLE membership_subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE membership_subscriptions FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON membership_subscriptions;
CREATE POLICY tenant_isolation ON membership_subscriptions
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON membership_subscriptions;
CREATE POLICY admin_ops_scope ON membership_subscriptions
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 4. digital_deliveries Table (Digital fulfillment, tokens, licenses & entitlements)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS digital_deliveries (
  delivery_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id          UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  order_id              UUID NOT NULL,
  customer_entity_id    UUID,
  product_id            UUID,
  offer_id              UUID,
  delivery_type         VARCHAR(30) NOT NULL, -- download_link, license_key, access_grant
  entitlement_payload   JSONB NOT NULL DEFAULT '{}'::jsonb,
  status                VARCHAR(20) NOT NULL DEFAULT 'delivered', -- pending, delivered, revoked
  idempotency_key       VARCHAR(255) NOT NULL,
  download_count        INTEGER NOT NULL DEFAULT 0,
  max_downloads         INTEGER NOT NULL DEFAULT 5,
  expires_at            TIMESTAMPTZ,
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at            TIMESTAMPTZ,
  CONSTRAINT uq_digital_deliveries_tenant_pk
    UNIQUE (workspace_id, delivery_id),
  CONSTRAINT uq_digital_deliveries_idempotency
    UNIQUE (workspace_id, idempotency_key),
  CONSTRAINT chk_digital_deliveries_status
    CHECK (status IN ('pending', 'delivered', 'revoked')),
  CONSTRAINT chk_digital_deliveries_delivery_type
    CHECK (delivery_type IN ('download_link', 'license_key', 'access_grant')),
  CONSTRAINT chk_digital_deliveries_download_count_non_negative
    CHECK (download_count >= 0),
  CONSTRAINT fk_digital_deliveries_order_id_tenant
    FOREIGN KEY (workspace_id, order_id)
    REFERENCES orders(workspace_id, order_id) ON DELETE CASCADE,
  CONSTRAINT fk_digital_deliveries_product_id_tenant
    FOREIGN KEY (workspace_id, product_id)
    REFERENCES products(workspace_id, product_id) ON DELETE SET NULL,
  CONSTRAINT fk_digital_deliveries_offer_id_tenant
    FOREIGN KEY (workspace_id, offer_id)
    REFERENCES offers(workspace_id, offer_id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_digital_deliveries_workspace ON digital_deliveries(workspace_id);
CREATE INDEX IF NOT EXISTS idx_digital_deliveries_order ON digital_deliveries(workspace_id, order_id);
CREATE INDEX IF NOT EXISTS idx_digital_deliveries_customer ON digital_deliveries(workspace_id, customer_entity_id);
CREATE INDEX IF NOT EXISTS idx_digital_deliveries_idempotency ON digital_deliveries(workspace_id, idempotency_key);

ALTER TABLE digital_deliveries ENABLE ROW LEVEL SECURITY;
ALTER TABLE digital_deliveries FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON digital_deliveries;
CREATE POLICY tenant_isolation ON digital_deliveries
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON digital_deliveries;
CREATE POLICY admin_ops_scope ON digital_deliveries
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 5. Runtime Role Grants
-- ----------------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON store_pages TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON store_pages TO admin_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON membership_plans TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON membership_plans TO admin_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON membership_subscriptions TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON membership_subscriptions TO admin_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON digital_deliveries TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON digital_deliveries TO admin_user;

-- +goose Down
DROP POLICY IF EXISTS admin_ops_scope ON digital_deliveries;
DROP POLICY IF EXISTS tenant_isolation ON digital_deliveries;
DROP TABLE IF EXISTS digital_deliveries;

DROP POLICY IF EXISTS admin_ops_scope ON membership_subscriptions;
DROP POLICY IF EXISTS tenant_isolation ON membership_subscriptions;
DROP TABLE IF EXISTS membership_subscriptions;

DROP POLICY IF EXISTS admin_ops_scope ON membership_plans;
DROP POLICY IF EXISTS tenant_isolation ON membership_plans;
DROP TABLE IF EXISTS membership_plans;

DROP POLICY IF EXISTS admin_ops_scope ON store_pages;
DROP POLICY IF EXISTS tenant_isolation ON store_pages;
DROP TABLE IF EXISTS store_pages;
