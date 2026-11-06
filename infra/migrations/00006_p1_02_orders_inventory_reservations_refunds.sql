-- ============================================================================
-- Creativanta P1-02 Migration: Orders, Stock Ledger, Reservations & Refunds
-- Canonical Source: docs/04_contracts/database_schema.md (§10.3, §19.5, §19.6, §19.9G, §19.9H, §26.11, §26.12)
--                   docs/04_contracts/inventory_computation_contract.md (§1–§4)
--                   docs/02_features/commerce/product_hub.md (M13)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. Inventory Locations (§19.9G)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS inventory_locations (
  location_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id  UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  name          VARCHAR(255) NOT NULL,
  location_type VARCHAR(30) NOT NULL, -- warehouse, store, supplier, in_transit
  address       JSONB DEFAULT '{}'::jsonb,
  is_default    BOOLEAN DEFAULT false,
  status        VARCHAR(20) NOT NULL DEFAULT 'active',
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_inventory_locations_tenant_pk UNIQUE (workspace_id, location_id)
);

CREATE INDEX IF NOT EXISTS idx_inventory_locations_workspace ON inventory_locations(workspace_id);
ALTER TABLE inventory_locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory_locations FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON inventory_locations;
CREATE POLICY tenant_isolation ON inventory_locations
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON inventory_locations;
CREATE POLICY admin_ops_scope ON inventory_locations
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 2. Orders (§10.3)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS orders (
  order_id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id            UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  source_class            source_class NOT NULL DEFAULT 'imported',
  source_platform         VARCHAR(50),
  external_order_id       VARCHAR(255),
  connected_account_id    UUID,
  tax_amount              NUMERIC(18,6) NOT NULL DEFAULT 0,
  tax_jurisdiction        VARCHAR(10),
  tax_note                VARCHAR(100),
  exchange_rate_snapshot  JSONB NOT NULL DEFAULT '{}'::jsonb,
  recognized_at           TIMESTAMPTZ,
  source_updated_at       TIMESTAMPTZ,
  import_fingerprint      VARCHAR(128),
  lifecycle_state         VARCHAR(20) NOT NULL DEFAULT 'created',
  amount                  NUMERIC(18,6) NOT NULL,
  currency                VARCHAR(5) NOT NULL DEFAULT 'VND',
  product_id              UUID,
  offer_id                UUID,
  campaign_id             UUID,
  post_id                 UUID,
  live_session_id         UUID,
  customer_entity_id      UUID,
  items                   JSONB DEFAULT '[]'::jsonb,
  fee_breakdown           JSONB DEFAULT '{}'::jsonb,
  shipping_address        JSONB,
  reconciliation_state    reconciliation_state DEFAULT 'awaiting_evidence',
  evidence_refs           JSONB DEFAULT '[]'::jsonb,
  metadata                JSONB DEFAULT '{}'::jsonb,
  ordered_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at              TIMESTAMPTZ,
  CONSTRAINT uq_orders_tenant_pk UNIQUE (workspace_id, order_id),
  CONSTRAINT fk_orders_connected_account_id_tenant FOREIGN KEY (workspace_id, connected_account_id) REFERENCES connected_accounts(workspace_id, connected_account_id),
  CONSTRAINT fk_orders_product_id_tenant FOREIGN KEY (workspace_id, product_id) REFERENCES products(workspace_id, product_id),
  CONSTRAINT fk_orders_offer_id_tenant FOREIGN KEY (workspace_id, offer_id) REFERENCES offers(workspace_id, offer_id),
  CONSTRAINT fk_orders_customer_entity_id_tenant FOREIGN KEY (workspace_id, customer_entity_id) REFERENCES entities(workspace_id, entity_id),
  CONSTRAINT chk_orders_lifecycle_state CHECK (
    lifecycle_state IN ('created', 'confirmed', 'fulfilled', 'completed', 'refunded', 'partially_refunded', 'returned', 'cancelled')
  )
);

CREATE INDEX IF NOT EXISTS idx_orders_workspace ON orders(workspace_id);
CREATE INDEX IF NOT EXISTS idx_orders_state ON orders(lifecycle_state);
CREATE INDEX IF NOT EXISTS idx_orders_platform ON orders(source_platform);
CREATE UNIQUE INDEX IF NOT EXISTS idx_orders_external_identity ON orders(workspace_id, connected_account_id, source_platform, external_order_id)
  WHERE external_order_id IS NOT NULL AND connected_account_id IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS idx_orders_import_fingerprint ON orders(workspace_id, import_fingerprint)
  WHERE import_fingerprint IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_orders_ordered ON orders(ordered_at DESC);

ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON orders;
CREATE POLICY tenant_isolation ON orders
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON orders;
CREATE POLICY admin_ops_scope ON orders
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 3. Stock Movements Ledger (§19.9H) - Append Only
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS stock_movements (
  movement_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id      UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  sku_id            UUID NOT NULL,
  location_id       UUID NOT NULL,
  movement_type     VARCHAR(30) NOT NULL, -- purchase, sale, return, adjustment, transfer, damage, platform_sync
  movement_key      VARCHAR(255) NOT NULL,
  quantity          INTEGER NOT NULL CHECK (quantity <> 0),
  reference_type    VARCHAR(50), -- order, return, manual, platform_import
  reference_id      UUID,
  source_created_at TIMESTAMPTZ,
  reason            TEXT,
  metadata          JSONB DEFAULT '{}'::jsonb,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_stock_movements_key UNIQUE (workspace_id, movement_key),
  CONSTRAINT fk_stock_movements_sku_id_tenant FOREIGN KEY (workspace_id, sku_id) REFERENCES product_skus(workspace_id, sku_id) ON DELETE CASCADE,
  CONSTRAINT fk_stock_movements_location_id_tenant FOREIGN KEY (workspace_id, location_id) REFERENCES inventory_locations(workspace_id, location_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_sm_workspace ON stock_movements(workspace_id);
CREATE INDEX IF NOT EXISTS idx_sm_sku_location ON stock_movements(workspace_id, sku_id, location_id);
CREATE INDEX IF NOT EXISTS idx_sm_reference ON stock_movements(workspace_id, reference_type, reference_id);

ALTER TABLE stock_movements ENABLE ROW LEVEL SECURITY;
ALTER TABLE stock_movements FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON stock_movements;
CREATE POLICY tenant_isolation ON stock_movements
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON stock_movements;
CREATE POLICY admin_ops_scope ON stock_movements
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 4. Inventory Balances (§26.11)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS inventory_balances (
  balance_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id  UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  sku_id        UUID NOT NULL,
  location_id   UUID NOT NULL,
  on_hand       INTEGER NOT NULL DEFAULT 0,
  reserved      INTEGER NOT NULL DEFAULT 0 CHECK (reserved >= 0),
  opening_at    TIMESTAMPTZ,
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_inventory_balances_tenant_sku_loc UNIQUE (workspace_id, sku_id, location_id),
  CONSTRAINT fk_inventory_balances_sku_id_tenant FOREIGN KEY (workspace_id, sku_id) REFERENCES product_skus(workspace_id, sku_id) ON DELETE CASCADE,
  CONSTRAINT fk_inventory_balances_location_id_tenant FOREIGN KEY (workspace_id, location_id) REFERENCES inventory_locations(workspace_id, location_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_ib_workspace ON inventory_balances(workspace_id);
CREATE INDEX IF NOT EXISTS idx_ib_sku ON inventory_balances(workspace_id, sku_id);

ALTER TABLE inventory_balances ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory_balances FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON inventory_balances;
CREATE POLICY tenant_isolation ON inventory_balances
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON inventory_balances;
CREATE POLICY admin_ops_scope ON inventory_balances
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 5. Stock Reservations (§26.12)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS stock_reservations (
  reservation_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id    UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  order_id        UUID NOT NULL,
  sku_id          UUID NOT NULL,
  location_id     UUID NOT NULL,
  reservation_key VARCHAR(255) NOT NULL,
  quantity        INTEGER NOT NULL CHECK (quantity > 0),
  status          VARCHAR(20) NOT NULL DEFAULT 'held' CHECK (status IN ('held','consumed','released','expired')),
  expires_at      TIMESTAMPTZ,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_stock_reservations_key UNIQUE (workspace_id, reservation_key),
  CONSTRAINT fk_stock_reservations_order_id_tenant FOREIGN KEY (workspace_id, order_id) REFERENCES orders(workspace_id, order_id) ON DELETE CASCADE,
  CONSTRAINT fk_stock_reservations_sku_id_tenant FOREIGN KEY (workspace_id, sku_id) REFERENCES product_skus(workspace_id, sku_id) ON DELETE CASCADE,
  CONSTRAINT fk_stock_reservations_location_id_tenant FOREIGN KEY (workspace_id, location_id) REFERENCES inventory_locations(workspace_id, location_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_sr_workspace ON stock_reservations(workspace_id);
CREATE INDEX IF NOT EXISTS idx_sr_order ON stock_reservations(workspace_id, order_id);
CREATE INDEX IF NOT EXISTS idx_sr_expires ON stock_reservations(workspace_id, status, expires_at) WHERE status = 'held';

ALTER TABLE stock_reservations ENABLE ROW LEVEL SECURITY;
ALTER TABLE stock_reservations FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON stock_reservations;
CREATE POLICY tenant_isolation ON stock_reservations
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON stock_reservations;
CREATE POLICY admin_ops_scope ON stock_reservations
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 6. Refunds (§19.5)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS refunds (
  refund_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id        UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  order_id            UUID NOT NULL,
  refund_type         VARCHAR(20) NOT NULL, -- full, partial, credit
  amount              NUMERIC(18,6) NOT NULL CHECK (amount > 0),
  currency            VARCHAR(5) NOT NULL DEFAULT 'VND',
  reason              TEXT NOT NULL,
  lifecycle_state     VARCHAR(20) NOT NULL DEFAULT 'requested',
  source_class        source_class NOT NULL DEFAULT 'imported',
  source_platform     VARCHAR(50),
  external_refund_id  VARCHAR(255),
  settlement_id       UUID,
  evidence_refs       JSONB DEFAULT '[]'::jsonb,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at          TIMESTAMPTZ,
  CONSTRAINT uq_refunds_tenant_pk UNIQUE (workspace_id, refund_id),
  CONSTRAINT fk_refunds_order_id_tenant FOREIGN KEY (workspace_id, order_id) REFERENCES orders(workspace_id, order_id) ON DELETE CASCADE,
  CONSTRAINT chk_refunds_lifecycle_state CHECK (
    lifecycle_state IN ('requested', 'approved', 'rejected', 'processing', 'completed', 'failed', 'cancelled')
  )
);

CREATE INDEX IF NOT EXISTS idx_refunds_workspace ON refunds(workspace_id);
CREATE INDEX IF NOT EXISTS idx_refunds_order ON refunds(workspace_id, order_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_refunds_external_identity
  ON refunds(workspace_id, order_id, source_platform, external_refund_id)
  WHERE external_refund_id IS NOT NULL AND deleted_at IS NULL;

ALTER TABLE refunds ENABLE ROW LEVEL SECURITY;
ALTER TABLE refunds FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON refunds;
CREATE POLICY tenant_isolation ON refunds
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON refunds;
CREATE POLICY admin_ops_scope ON refunds
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 7. Returns (§19.6)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS returns (
  return_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id        UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  order_id            UUID NOT NULL,
  refund_id           UUID,
  return_type         VARCHAR(20) NOT NULL, -- full, partial
  items               JSONB DEFAULT '[]'::jsonb,
  lifecycle_state     VARCHAR(20) NOT NULL DEFAULT 'initiated',
  source_platform     VARCHAR(50),
  external_return_id  VARCHAR(255),
  tracking_number     VARCHAR(100),
  evidence_photo_url  TEXT,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at          TIMESTAMPTZ,
  CONSTRAINT uq_returns_tenant_pk UNIQUE (workspace_id, return_id),
  CONSTRAINT fk_returns_order_id_tenant FOREIGN KEY (workspace_id, order_id) REFERENCES orders(workspace_id, order_id) ON DELETE CASCADE,
  CONSTRAINT fk_returns_refund_id_tenant FOREIGN KEY (workspace_id, refund_id) REFERENCES refunds(workspace_id, refund_id),
  CONSTRAINT chk_returns_lifecycle_state CHECK (
    lifecycle_state IN ('initiated', 'approved', 'shipped_back', 'received', 'inspected', 'closed', 'rejected')
  )
);

CREATE INDEX IF NOT EXISTS idx_returns_workspace ON returns(workspace_id);
CREATE INDEX IF NOT EXISTS idx_returns_order ON returns(workspace_id, order_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_returns_external_identity
  ON returns(workspace_id, order_id, source_platform, external_return_id)
  WHERE external_return_id IS NOT NULL AND deleted_at IS NULL;

ALTER TABLE returns ENABLE ROW LEVEL SECURITY;
ALTER TABLE returns FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation ON returns;
CREATE POLICY tenant_isolation ON returns
  FOR ALL
  TO app_user
  USING (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_tenant_id', true), '')::uuid);

DROP POLICY IF EXISTS admin_ops_scope ON returns;
CREATE POLICY admin_ops_scope ON returns
  FOR ALL
  TO admin_user
  USING (true)
  WITH CHECK (true);

-- ----------------------------------------------------------------------------
-- 8. Runtime Grants for app_user and admin_user
-- ----------------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON
  inventory_locations,
  orders,
  refunds,
  returns
TO app_user;

GRANT SELECT, INSERT ON
  stock_movements
TO app_user;

GRANT SELECT, INSERT, UPDATE ON
  inventory_balances,
  stock_reservations
TO app_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON
  inventory_locations,
  orders,
  stock_movements,
  inventory_balances,
  stock_reservations,
  refunds,
  returns
TO admin_user;

-- +goose Down
REVOKE ALL PRIVILEGES ON
  inventory_locations,
  orders,
  stock_movements,
  inventory_balances,
  stock_reservations,
  refunds,
  returns
FROM app_user, admin_user;

DROP TABLE IF EXISTS returns CASCADE;
DROP TABLE IF EXISTS refunds CASCADE;
DROP TABLE IF EXISTS stock_reservations CASCADE;
DROP TABLE IF EXISTS inventory_balances CASCADE;
DROP TABLE IF EXISTS stock_movements CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS inventory_locations CASCADE;
