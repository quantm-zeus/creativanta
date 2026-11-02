-- ============================================================================
-- Creativanta P0-06 Migration: Credit Lots, Quotes & Billing Foundations
-- Canonical Source: docs/04_contracts/database_schema.md (§4.1, §19.1B, §19.1C, §26.1–§26.5, §26.11–§26.12)
--                   docs/04_contracts/credit_accounting_contract.md (§1–§4)
-- ============================================================================

-- +goose Up

-- ----------------------------------------------------------------------------
-- 1. Align Workspace Default AI Credit Allocation to Canonical Free Tier (50)
-- ----------------------------------------------------------------------------
ALTER TABLE workspaces ALTER COLUMN ai_credits_remaining SET DEFAULT 50;
ALTER TABLE workspaces ALTER COLUMN ai_credits_monthly_limit SET DEFAULT 50;

-- ----------------------------------------------------------------------------
-- 2. Verified Provider Rate Cards (§26.1 [GLOBAL])
-- ----------------------------------------------------------------------------
CREATE TABLE ai_provider_rates (
  rate_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  provider     VARCHAR(30) NOT NULL,
  model_id     VARCHAR(100) NOT NULL,
  version      VARCHAR(50) NOT NULL,
  currency     VARCHAR(3) NOT NULL DEFAULT 'USD' CHECK (currency = 'USD'),
  unit_rates   JSONB NOT NULL,
  source_url   TEXT NOT NULL,
  verified_at  TIMESTAMPTZ NOT NULL,
  valid_until  TIMESTAMPTZ NOT NULL,
  enabled      BOOLEAN NOT NULL DEFAULT true,
  UNIQUE (provider, model_id, version)
);
CREATE INDEX idx_apr_lookup ON ai_provider_rates(provider, model_id, enabled, valid_until DESC);

-- ----------------------------------------------------------------------------
-- 3. Immutable Cost-Based Credit Quotes (§26.2)
-- ----------------------------------------------------------------------------
CREATE TABLE ai_credit_quotes (
  quote_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id           UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  request_hash           VARCHAR(64) NOT NULL,
  operation_type         VARCHAR(50) NOT NULL,
  rate_version           VARCHAR(50) NOT NULL,
  provider_plan          JSONB NOT NULL,
  cost_ceiling_usd       NUMERIC(18,6) NOT NULL CHECK (cost_ceiling_usd >= 0),
  usd_per_credit_floor   NUMERIC(18,6) NOT NULL CHECK (usd_per_credit_floor > 0),
  gross_margin_floor     NUMERIC(5,4) NOT NULL CHECK (gross_margin_floor >= 0 AND gross_margin_floor < 1),
  quoted_credits         NUMERIC(18,6) NOT NULL CHECK (quoted_credits > 0),
  expires_at             TIMESTAMPTZ NOT NULL,
  created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_acq_workspace_expires ON ai_credit_quotes(workspace_id, expires_at DESC);

-- ----------------------------------------------------------------------------
-- 4. Durable Credit Lots by Source & Expiry (§26.3)
-- ----------------------------------------------------------------------------
CREATE TABLE ai_credit_lots (
  lot_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id       UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  source_type        VARCHAR(20) NOT NULL
                     CHECK (source_type IN ('subscription', 'purchased', 'promotional', 'overage')),
  granted_credits    NUMERIC(18,6) NOT NULL CHECK (granted_credits >= 0),
  remaining_credits  NUMERIC(18,6) NOT NULL CHECK (remaining_credits >= 0),
  reserved_credits   NUMERIC(18,6) NOT NULL DEFAULT 0,
  expires_at         TIMESTAMPTZ,
  external_grant_key VARCHAR(120) NOT NULL,
  created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CHECK (reserved_credits >= 0 AND reserved_credits <= remaining_credits AND remaining_credits <= granted_credits),
  CHECK (source_type <> 'purchased' OR expires_at IS NULL),
  CHECK (source_type <> 'subscription' OR expires_at IS NOT NULL),
  UNIQUE (workspace_id, external_grant_key)
);
CREATE INDEX idx_acl_consumption
  ON ai_credit_lots(workspace_id, source_type, expires_at ASC NULLS LAST, created_at ASC)
  WHERE remaining_credits > reserved_credits;

-- ----------------------------------------------------------------------------
-- 5. Credit Reservations & State Machine (§26.4)
-- ----------------------------------------------------------------------------
CREATE TABLE ai_credit_reservations (
  reservation_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id        UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  quote_id            UUID NOT NULL REFERENCES ai_credit_quotes(quote_id) ON DELETE RESTRICT,
  idempotency_key     VARCHAR(120) NOT NULL,
  request_hash        VARCHAR(64) NOT NULL,
  status              VARCHAR(20) NOT NULL
                      CHECK (status IN ('held', 'in_flight', 'reconciling', 'committed', 'released', 'expired')),
  reserved_credits    NUMERIC(18,6) NOT NULL CHECK (reserved_credits > 0),
  actual_credits      NUMERIC(18,6),
  expires_at          TIMESTAMPTZ NOT NULL,
  last_heartbeat_at   TIMESTAMPTZ,
  provider_request_id VARCHAR(120),
  terminal_reason     TEXT,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CHECK (actual_credits IS NULL OR (actual_credits >= 0 AND actual_credits <= reserved_credits)),
  UNIQUE (workspace_id, idempotency_key)
);
CREATE INDEX idx_acr_active
  ON ai_credit_reservations(workspace_id, status, expires_at)
  WHERE status IN ('held', 'in_flight', 'reconciling');

-- ----------------------------------------------------------------------------
-- 6. Reservation-to-Lot Allocations (§26.5)
-- ----------------------------------------------------------------------------
CREATE TABLE ai_credit_reservation_allocations (
  allocation_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id   UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  reservation_id UUID NOT NULL REFERENCES ai_credit_reservations(reservation_id) ON DELETE CASCADE,
  lot_id         UUID NOT NULL REFERENCES ai_credit_lots(lot_id) ON DELETE RESTRICT,
  credits        NUMERIC(18,6) NOT NULL CHECK (credits > 0),
  UNIQUE (reservation_id, lot_id)
);
CREATE INDEX idx_acra_lot ON ai_credit_reservation_allocations(workspace_id, lot_id);

-- ----------------------------------------------------------------------------
-- 7. Billing Invoices (§19.1B) & Payment Methods (§19.1C)
-- ----------------------------------------------------------------------------
CREATE TABLE invoices (
  invoice_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id       UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  subscription_id    UUID REFERENCES subscriptions(subscription_id) ON DELETE SET NULL,
  stripe_invoice_id  VARCHAR(100) UNIQUE,
  invoice_number     VARCHAR(50) NOT NULL,
  status             VARCHAR(20) NOT NULL DEFAULT 'draft',
  currency           VARCHAR(3) NOT NULL DEFAULT 'USD',
  subtotal           NUMERIC(18,6) NOT NULL DEFAULT 0,
  discount_amount    NUMERIC(18,6) NOT NULL DEFAULT 0,
  tax_amount         NUMERIC(18,6) NOT NULL DEFAULT 0,
  total              NUMERIC(18,6) NOT NULL DEFAULT 0,
  amount_paid        NUMERIC(18,6) NOT NULL DEFAULT 0,
  amount_due         NUMERIC(18,6) NOT NULL DEFAULT 0,
  invoice_pdf_url    TEXT,
  hosted_invoice_url TEXT,
  period_start       TIMESTAMPTZ,
  period_end         TIMESTAMPTZ,
  due_date           TIMESTAMPTZ,
  paid_at            TIMESTAMPTZ,
  line_items         JSONB NOT NULL DEFAULT '[]',
  created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT chk_invoices_status CHECK (status IN ('draft', 'open', 'paid', 'void', 'uncollectible'))
);
CREATE INDEX idx_invoices_workspace ON invoices(workspace_id, created_at DESC);
CREATE INDEX idx_invoices_status ON invoices(workspace_id, status);

CREATE TABLE payment_methods (
  payment_method_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id             UUID NOT NULL REFERENCES workspaces(workspace_id) ON DELETE CASCADE,
  stripe_payment_method_id VARCHAR(100) UNIQUE NOT NULL,
  type                     VARCHAR(20) NOT NULL DEFAULT 'card',
  card_brand               VARCHAR(20),
  card_last4               VARCHAR(4),
  card_exp_month           SMALLINT,
  card_exp_year            SMALLINT,
  is_default               BOOLEAN NOT NULL DEFAULT false,
  billing_details          JSONB NOT NULL DEFAULT '{}',
  created_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at               TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_pm_workspace ON payment_methods(workspace_id);
CREATE UNIQUE INDEX idx_pm_default ON payment_methods(workspace_id) WHERE is_default = true;

-- ----------------------------------------------------------------------------
-- 8. Composite Tenant Keys & Same-Tenant Foreign Keys (§26.11)
-- ----------------------------------------------------------------------------
ALTER TABLE ai_credit_quotes ADD CONSTRAINT uq_ai_credit_quotes_tenant_pk UNIQUE (workspace_id, quote_id);
ALTER TABLE ai_credit_lots ADD CONSTRAINT uq_ai_credit_lots_tenant_pk UNIQUE (workspace_id, lot_id);
ALTER TABLE ai_credit_reservations ADD CONSTRAINT uq_ai_credit_reservations_tenant_pk UNIQUE (workspace_id, reservation_id);

ALTER TABLE ai_credit_reservations ADD CONSTRAINT fk_ai_credit_reservations_quote_id_tenant
  FOREIGN KEY (workspace_id, quote_id) REFERENCES ai_credit_quotes(workspace_id, quote_id);
ALTER TABLE ai_credit_reservation_allocations ADD CONSTRAINT fk_ai_credit_reservation_allocations_reservation_id_tenant
  FOREIGN KEY (workspace_id, reservation_id) REFERENCES ai_credit_reservations(workspace_id, reservation_id) ON DELETE CASCADE;
ALTER TABLE ai_credit_reservation_allocations ADD CONSTRAINT fk_ai_credit_reservation_allocations_lot_id_tenant
  FOREIGN KEY (workspace_id, lot_id) REFERENCES ai_credit_lots(workspace_id, lot_id);
ALTER TABLE invoices ADD CONSTRAINT fk_invoices_subscription_id_tenant
  FOREIGN KEY (workspace_id, subscription_id) REFERENCES subscriptions(workspace_id, subscription_id);

ALTER TABLE ai_credit_transactions
  ADD CONSTRAINT fk_act_reservation FOREIGN KEY (reservation_id) REFERENCES ai_credit_reservations(reservation_id),
  ADD CONSTRAINT fk_act_lot FOREIGN KEY (lot_id) REFERENCES ai_credit_lots(lot_id),
  ADD CONSTRAINT fk_act_reservation_tenant FOREIGN KEY (workspace_id, reservation_id) REFERENCES ai_credit_reservations(workspace_id, reservation_id),
  ADD CONSTRAINT fk_act_lot_tenant FOREIGN KEY (workspace_id, lot_id) REFERENCES ai_credit_lots(workspace_id, lot_id);

-- ----------------------------------------------------------------------------
-- 9. Append-Only Immutability Trigger on ai_credit_transactions
--    (credit_accounting_contract.md §4: never mutate an existing debit/ledger row)
-- ----------------------------------------------------------------------------
-- +goose StatementBegin
CREATE OR REPLACE FUNCTION protect_credit_transaction_immutability()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  RAISE EXCEPTION 'ai_credit_transactions is append-only; use a compensating transaction referencing reference_transaction_id instead of %', TG_OP
    USING ERRCODE = '55000';
END;
$$;
-- +goose StatementEnd

CREATE TRIGGER trg_ai_credit_transactions_immutable
  BEFORE UPDATE OR DELETE ON ai_credit_transactions
  FOR EACH ROW EXECUTE FUNCTION protect_credit_transaction_immutability();

-- ----------------------------------------------------------------------------
-- 10. Row-Level Security (ENABLE + FORCE + tenant_isolation)
-- ----------------------------------------------------------------------------
ALTER TABLE ai_credit_quotes ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_credit_quotes FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON ai_credit_quotes
  USING (workspace_id = NULLIF(current_setting('app.current_workspace_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_workspace_id', true), '')::uuid);

ALTER TABLE ai_credit_lots ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_credit_lots FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON ai_credit_lots
  USING (workspace_id = NULLIF(current_setting('app.current_workspace_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_workspace_id', true), '')::uuid);

ALTER TABLE ai_credit_reservations ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_credit_reservations FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON ai_credit_reservations
  USING (workspace_id = NULLIF(current_setting('app.current_workspace_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_workspace_id', true), '')::uuid);

ALTER TABLE ai_credit_reservation_allocations ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_credit_reservation_allocations FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON ai_credit_reservation_allocations
  USING (workspace_id = NULLIF(current_setting('app.current_workspace_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_workspace_id', true), '')::uuid);

ALTER TABLE invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE invoices FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON invoices
  USING (workspace_id = NULLIF(current_setting('app.current_workspace_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_workspace_id', true), '')::uuid);

ALTER TABLE payment_methods ENABLE ROW LEVEL SECURITY;
ALTER TABLE payment_methods FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON payment_methods
  USING (workspace_id = NULLIF(current_setting('app.current_workspace_id', true), '')::uuid)
  WITH CHECK (workspace_id = NULLIF(current_setting('app.current_workspace_id', true), '')::uuid);

-- ----------------------------------------------------------------------------
-- 11. Narrow Role Grants (§26.12 — NEVER GRANT ALL)
-- ----------------------------------------------------------------------------
GRANT SELECT ON ai_provider_rates TO app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ai_provider_rates TO admin_user;

GRANT SELECT, INSERT ON ai_credit_quotes TO app_user;
GRANT SELECT, INSERT, UPDATE ON ai_credit_lots, ai_credit_reservations TO app_user;
GRANT SELECT, INSERT ON ai_credit_reservation_allocations TO app_user;
GRANT SELECT, INSERT, UPDATE ON invoices, payment_methods TO app_user;

GRANT SELECT ON ai_credit_quotes, ai_credit_lots, ai_credit_reservations, ai_credit_reservation_allocations, invoices, payment_methods TO admin_user;

-- +goose Down
REVOKE ALL ON ai_provider_rates, ai_credit_quotes, ai_credit_lots, ai_credit_reservations, ai_credit_reservation_allocations, invoices, payment_methods FROM app_user, admin_user;

DROP TRIGGER IF EXISTS trg_ai_credit_transactions_immutable ON ai_credit_transactions;
DROP FUNCTION IF EXISTS protect_credit_transaction_immutability();

ALTER TABLE ai_credit_transactions
  DROP CONSTRAINT IF EXISTS fk_act_lot_tenant,
  DROP CONSTRAINT IF EXISTS fk_act_reservation_tenant,
  DROP CONSTRAINT IF EXISTS fk_act_lot,
  DROP CONSTRAINT IF EXISTS fk_act_reservation;

DROP TABLE IF EXISTS payment_methods CASCADE;
DROP TABLE IF EXISTS invoices CASCADE;
DROP TABLE IF EXISTS ai_credit_reservation_allocations CASCADE;
DROP TABLE IF EXISTS ai_credit_reservations CASCADE;
DROP TABLE IF EXISTS ai_credit_lots CASCADE;
DROP TABLE IF EXISTS ai_credit_quotes CASCADE;
DROP TABLE IF EXISTS ai_provider_rates CASCADE;
