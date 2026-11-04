-- ============================================================================
-- Creativanta P6-04 Migration: Creator Pro Tools (Link-in-Bio, Media Kits,
-- Rate Cards, Brand Deals Lifecycle, Link Security Scans & Tax Reports)
-- Canonical Sources: docs/04_contracts/database_schema.md (§16, §16.1–§16.5)
--                    docs/02_features/commerce/creator_pro_tools.md (RULE-S16-001 to RULE-S16-010)
--                    docs/02_features/commerce/affiliate_network.md (Brand Deal Lifecycle)
--                    docs/04_contracts/domain_event_catalog.md (§15)
--                    docs/04_contracts/rbac_permission_matrix.md (§2.13)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. link_in_bio_pages Table (§16.1)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS link_in_bio_pages (
  page_id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  slug                    VARCHAR(100) UNIQUE NOT NULL,
  title                   VARCHAR(255),
  bio                     VARCHAR(300),
  avatar_url              TEXT,
  theme                   VARCHAR(20) NOT NULL DEFAULT 'minimal', -- minimal, bold, gradient, dark, custom
  custom_css              JSONB,
  custom_domain           VARCHAR(255),
  custom_domain_verified  BOOLEAN DEFAULT false,
  analytics_enabled       BOOLEAN DEFAULT true,
  total_views             INTEGER DEFAULT 0,
  status                  VARCHAR(20) NOT NULL DEFAULT 'active', -- active, suspended, archived
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at              TIMESTAMPTZ,
  CONSTRAINT uq_link_in_bio_pages_tenant_pk
    UNIQUE (workspace_id, page_id),
  CONSTRAINT chk_link_in_bio_pages_status
    CHECK (status IN ('active', 'suspended', 'archived')),
  CONSTRAINT chk_link_in_bio_pages_theme
    CHECK (theme IN ('minimal', 'bold', 'gradient', 'dark', 'custom'))
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_lib_slug ON link_in_bio_pages(slug);
CREATE INDEX IF NOT EXISTS idx_lib_workspace ON link_in_bio_pages(workspace_id);

ALTER TABLE link_in_bio_pages ENABLE ROW LEVEL SECURITY;
ALTER TABLE link_in_bio_pages FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON link_in_bio_pages;
CREATE POLICY tenant_isolation ON link_in_bio_pages
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON link_in_bio_pages;
CREATE POLICY admin_ops_scope ON link_in_bio_pages
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 2. link_items Table (§16.2)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS link_items (
  link_item_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  page_id                 UUID NOT NULL REFERENCES link_in_bio_pages(page_id) ON DELETE CASCADE,
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  link_type               VARCHAR(20) NOT NULL, -- url, product, video, social, download, email
  label                   VARCHAR(255) NOT NULL,
  url                     TEXT NOT NULL,
  icon                    VARCHAR(50),
  thumbnail_url           TEXT,
  position                SMALLINT NOT NULL DEFAULT 0,
  clicks                  INTEGER DEFAULT 0,
  is_active               BOOLEAN DEFAULT true,
  scan_status             VARCHAR(20) NOT NULL DEFAULT 'safe', -- safe, suspicious, phishing, malware, blocked
  phishing_detected       BOOLEAN DEFAULT false,
  scan_threat_details     TEXT,
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at              TIMESTAMPTZ,
  CONSTRAINT uq_link_items_tenant_pk
    UNIQUE (workspace_id, link_item_id),
  CONSTRAINT fk_link_items_page_id_tenant
    FOREIGN KEY (workspace_id, page_id) REFERENCES link_in_bio_pages(workspace_id, page_id) ON DELETE CASCADE,
  CONSTRAINT chk_link_items_type
    CHECK (link_type IN ('url', 'product', 'video', 'social', 'download', 'email')),
  CONSTRAINT chk_link_items_scan_status
    CHECK (scan_status IN ('safe', 'suspicious', 'phishing', 'malware', 'blocked'))
);

CREATE INDEX IF NOT EXISTS idx_li_page ON link_items(page_id);
CREATE INDEX IF NOT EXISTS idx_li_workspace ON link_items(workspace_id);

ALTER TABLE link_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE link_items FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON link_items;
CREATE POLICY tenant_isolation ON link_items
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON link_items;
CREATE POLICY admin_ops_scope ON link_items
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 3. rate_cards & rate_card_items Tables (§16.4)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS rate_cards (
  rate_card_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  currency                VARCHAR(5) NOT NULL DEFAULT 'VND',
  custom_note             TEXT,
  ai_suggested_at         TIMESTAMPTZ,
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at              TIMESTAMPTZ,
  CONSTRAINT uq_rate_cards_tenant_pk
    UNIQUE (workspace_id, rate_card_id)
);

CREATE INDEX IF NOT EXISTS idx_rate_cards_workspace ON rate_cards(workspace_id);

ALTER TABLE rate_cards ENABLE ROW LEVEL SECURITY;
ALTER TABLE rate_cards FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON rate_cards;
CREATE POLICY tenant_isolation ON rate_cards
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON rate_cards;
CREATE POLICY admin_ops_scope ON rate_cards
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

CREATE TABLE IF NOT EXISTS rate_card_items (
  item_id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  rate_card_id            UUID NOT NULL REFERENCES rate_cards(rate_card_id) ON DELETE CASCADE,
  service_type            VARCHAR(50) NOT NULL,
  price_min               NUMERIC(18,6),
  price_max               NUMERIC(18,6),
  ai_suggested_price      NUMERIC(18,6),
  description             TEXT,
  delivery_time           VARCHAR(50),
  position                SMALLINT DEFAULT 0,
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_rate_card_items_tenant_pk
    UNIQUE (workspace_id, item_id),
  CONSTRAINT fk_rate_card_items_rate_card_tenant
    FOREIGN KEY (workspace_id, rate_card_id) REFERENCES rate_cards(workspace_id, rate_card_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_rate_card_items_card ON rate_card_items(rate_card_id);
CREATE INDEX IF NOT EXISTS idx_rate_card_items_workspace ON rate_card_items(workspace_id);

ALTER TABLE rate_card_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE rate_card_items FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON rate_card_items;
CREATE POLICY tenant_isolation ON rate_card_items
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON rate_card_items;
CREATE POLICY admin_ops_scope ON rate_card_items
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 4. link_security_scans Table (Domain Protection & Anti-Abuse)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS link_security_scans (
  scan_id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  url                     TEXT NOT NULL,
  link_item_id            UUID REFERENCES link_items(link_item_id) ON DELETE SET NULL,
  scan_status             VARCHAR(20) NOT NULL DEFAULT 'safe', -- safe, suspicious, phishing, malware, blocked
  phishing_detected       BOOLEAN NOT NULL DEFAULT false,
  threat_details          TEXT,
  blocked_from_publishing BOOLEAN NOT NULL DEFAULT false,
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_link_security_scans_tenant_pk
    UNIQUE (workspace_id, scan_id),
  CONSTRAINT chk_link_security_scans_status
    CHECK (scan_status IN ('safe', 'suspicious', 'phishing', 'malware', 'blocked'))
);

CREATE INDEX IF NOT EXISTS idx_lss_workspace ON link_security_scans(workspace_id);
CREATE INDEX IF NOT EXISTS idx_lss_url ON link_security_scans(url);

ALTER TABLE link_security_scans ENABLE ROW LEVEL SECURITY;
ALTER TABLE link_security_scans FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON link_security_scans;
CREATE POLICY tenant_isolation ON link_security_scans
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON link_security_scans;
CREATE POLICY admin_ops_scope ON link_security_scans
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 5. tax_reports Table (§16 / S16 §6)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tax_reports (
  report_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  period                  VARCHAR(20) NOT NULL, -- monthly, quarterly, yearly
  tax_year                INTEGER NOT NULL,
  period_number           INTEGER NOT NULL DEFAULT 1,
  total_revenue           NUMERIC(18,6) NOT NULL DEFAULT 0,
  affiliate_revenue       NUMERIC(18,6) NOT NULL DEFAULT 0,
  sponsorship_revenue     NUMERIC(18,6) NOT NULL DEFAULT 0,
  product_sales_revenue   NUMERIC(18,6) NOT NULL DEFAULT 0,
  ai_credit_expenses      NUMERIC(18,6) NOT NULL DEFAULT 0,
  subscription_expenses   NUMERIC(18,6) NOT NULL DEFAULT 0,
  net_income_before_tax   NUMERIC(18,6) NOT NULL DEFAULT 0,
  currency                VARCHAR(5) NOT NULL DEFAULT 'VND',
  format                  VARCHAR(10) NOT NULL DEFAULT 'xlsx',
  report_data_url         TEXT,
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_tax_reports_tenant_pk
    UNIQUE (workspace_id, report_id),
  CONSTRAINT chk_tax_reports_period
    CHECK (period IN ('monthly', 'quarterly', 'yearly')),
  CONSTRAINT chk_tax_reports_format
    CHECK (format IN ('pdf', 'xlsx', 'csv'))
);

CREATE INDEX IF NOT EXISTS idx_tax_reports_workspace ON tax_reports(workspace_id);
CREATE INDEX IF NOT EXISTS idx_tax_reports_period ON tax_reports(tax_year, period);

ALTER TABLE tax_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE tax_reports FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON tax_reports;
CREATE POLICY tenant_isolation ON tax_reports
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON tax_reports;
CREATE POLICY admin_ops_scope ON tax_reports
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 6. brand_deals Enhancements (Canonical M16 Deal Lifecycle)
-- ----------------------------------------------------------------------------
ALTER TABLE brand_deals DROP CONSTRAINT IF EXISTS chk_brand_deals_status;
ALTER TABLE brand_deals ADD CONSTRAINT chk_brand_deals_status
  CHECK (status IN ('negotiating', 'agreed', 'in_progress', 'delivered', 'paid', 'completed', 'cancelled'));

CREATE UNIQUE INDEX IF NOT EXISTS uq_brand_deals_tenant_pk ON brand_deals(workspace_id, deal_id);
CREATE INDEX IF NOT EXISTS idx_bd_status ON brand_deals(status);

-- ----------------------------------------------------------------------------
-- 7. Table Grants
-- ----------------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON link_in_bio_pages TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON link_in_bio_pages TO admin_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON link_items TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON link_items TO admin_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON rate_cards TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON rate_cards TO admin_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON rate_card_items TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON rate_card_items TO admin_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON link_security_scans TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON link_security_scans TO admin_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON tax_reports TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON tax_reports TO admin_user;

-- +goose Down
DROP POLICY IF EXISTS admin_ops_scope ON tax_reports;
DROP POLICY IF EXISTS tenant_isolation ON tax_reports;
DROP TABLE IF EXISTS tax_reports CASCADE;

DROP POLICY IF EXISTS admin_ops_scope ON link_security_scans;
DROP POLICY IF EXISTS tenant_isolation ON link_security_scans;
DROP TABLE IF EXISTS link_security_scans CASCADE;

DROP POLICY IF EXISTS admin_ops_scope ON rate_card_items;
DROP POLICY IF EXISTS tenant_isolation ON rate_card_items;
DROP TABLE IF EXISTS rate_card_items CASCADE;

DROP POLICY IF EXISTS admin_ops_scope ON rate_cards;
DROP POLICY IF EXISTS tenant_isolation ON rate_cards;
DROP TABLE IF EXISTS rate_cards CASCADE;

DROP POLICY IF EXISTS admin_ops_scope ON link_items;
DROP POLICY IF EXISTS tenant_isolation ON link_items;
DROP TABLE IF EXISTS link_items CASCADE;

DROP POLICY IF EXISTS admin_ops_scope ON link_in_bio_pages;
DROP POLICY IF EXISTS tenant_isolation ON link_in_bio_pages;
DROP TABLE IF EXISTS link_in_bio_pages CASCADE;
