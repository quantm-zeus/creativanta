-- +goose Up
-- Forward-only remediation migration 00049 (preserves immutable 00001..00048 checksums):
-- 1. Adds user_self_clerk_bootstrap RLS policy on users so authenticated Clerk sessions can
--    bootstrap their internal user_id and discover workspaces under app_user RLS before
--    selecting an x-workspace-id header (Security F1 / Data F5 / Release F1).
-- 2. Adds returns external identity columns (source_platform, external_return_id), runs a
--    preflight data-integrity check, replaces single-column FKs on orders and returns with
--    composite tenant FKs, and creates partial unique indexes idx_refunds_external_identity
--    and idx_returns_external_identity (Security F1 / Data F5 / Release F1).
-- 3. Backfills any legacy unbounded/NULL admin_sessions.expired_at rows to started_at + 8 hours
--    and sets an 8-hour default TTL on admin_sessions.expired_at (Security F2).

DROP POLICY IF EXISTS user_self_clerk_bootstrap ON users;
CREATE POLICY user_self_clerk_bootstrap ON users
    FOR SELECT
    TO app_user
    USING (
        NULLIF(current_setting('app.current_clerk_id', true), '') IS NOT NULL
        AND (
            clerk_id = NULLIF(current_setting('app.current_clerk_id', true), '')
            OR external_auth_id = NULLIF(current_setting('app.current_clerk_id', true), '')
        )
    );

ALTER TABLE returns
    ADD COLUMN IF NOT EXISTS source_platform VARCHAR(50),
    ADD COLUMN IF NOT EXISTS external_return_id VARCHAR(255);

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM orders o
        LEFT JOIN connected_accounts ca
          ON ca.workspace_id = o.workspace_id
         AND ca.connected_account_id = o.connected_account_id
        WHERE o.connected_account_id IS NOT NULL
          AND ca.connected_account_id IS NULL
    ) THEN
        RAISE EXCEPTION 'migration 00049 preflight failed: orders contains cross-tenant connected_account_id reference';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM orders o
        LEFT JOIN products p
          ON p.workspace_id = o.workspace_id
         AND p.product_id = o.product_id
        WHERE o.product_id IS NOT NULL
          AND p.product_id IS NULL
    ) THEN
        RAISE EXCEPTION 'migration 00049 preflight failed: orders contains cross-tenant product_id reference';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM orders o
        LEFT JOIN offers f
          ON f.workspace_id = o.workspace_id
         AND f.offer_id = o.offer_id
        WHERE o.offer_id IS NOT NULL
          AND f.offer_id IS NULL
    ) THEN
        RAISE EXCEPTION 'migration 00049 preflight failed: orders contains cross-tenant offer_id reference';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM orders o
        LEFT JOIN entities e
          ON e.workspace_id = o.workspace_id
         AND e.entity_id = o.customer_entity_id
        WHERE o.customer_entity_id IS NOT NULL
          AND e.entity_id IS NULL
    ) THEN
        RAISE EXCEPTION 'migration 00049 preflight failed: orders contains cross-tenant customer_entity_id reference';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM returns r
        LEFT JOIN refunds rf
          ON rf.workspace_id = r.workspace_id
         AND rf.refund_id = r.refund_id
        WHERE r.refund_id IS NOT NULL
          AND rf.refund_id IS NULL
    ) THEN
        RAISE EXCEPTION 'migration 00049 preflight failed: returns contains cross-tenant refund_id reference';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM refunds
        WHERE external_refund_id IS NOT NULL
          AND deleted_at IS NULL
        GROUP BY workspace_id, order_id, source_platform, external_refund_id
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'migration 00049 preflight failed: refunds contains duplicate active external_refund_id identity';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM returns
        WHERE external_return_id IS NOT NULL
          AND deleted_at IS NULL
        GROUP BY workspace_id, order_id, source_platform, external_return_id
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'migration 00049 preflight failed: returns contains duplicate active external_return_id identity';
    END IF;
END $$;

ALTER TABLE orders
    DROP CONSTRAINT IF EXISTS orders_connected_account_id_fkey,
    DROP CONSTRAINT IF EXISTS orders_product_id_fkey,
    DROP CONSTRAINT IF EXISTS orders_offer_id_fkey,
    DROP CONSTRAINT IF EXISTS orders_customer_entity_id_fkey,
    DROP CONSTRAINT IF EXISTS fk_orders_connected_account_id_tenant,
    DROP CONSTRAINT IF EXISTS fk_orders_product_id_tenant,
    DROP CONSTRAINT IF EXISTS fk_orders_offer_id_tenant,
    DROP CONSTRAINT IF EXISTS fk_orders_customer_entity_id_tenant,
    ADD CONSTRAINT fk_orders_connected_account_id_tenant
        FOREIGN KEY (workspace_id, connected_account_id) REFERENCES connected_accounts(workspace_id, connected_account_id),
    ADD CONSTRAINT fk_orders_product_id_tenant
        FOREIGN KEY (workspace_id, product_id) REFERENCES products(workspace_id, product_id),
    ADD CONSTRAINT fk_orders_offer_id_tenant
        FOREIGN KEY (workspace_id, offer_id) REFERENCES offers(workspace_id, offer_id),
    ADD CONSTRAINT fk_orders_customer_entity_id_tenant
        FOREIGN KEY (workspace_id, customer_entity_id) REFERENCES entities(workspace_id, entity_id);

ALTER TABLE returns
    DROP CONSTRAINT IF EXISTS returns_refund_id_fkey,
    DROP CONSTRAINT IF EXISTS fk_returns_refund_id_tenant,
    ADD CONSTRAINT fk_returns_refund_id_tenant
        FOREIGN KEY (workspace_id, refund_id) REFERENCES refunds(workspace_id, refund_id);

CREATE UNIQUE INDEX IF NOT EXISTS idx_refunds_external_identity
    ON refunds(workspace_id, order_id, source_platform, external_refund_id)
    WHERE external_refund_id IS NOT NULL AND deleted_at IS NULL;

CREATE UNIQUE INDEX IF NOT EXISTS idx_returns_external_identity
    ON returns(workspace_id, order_id, source_platform, external_return_id)
    WHERE external_return_id IS NOT NULL AND deleted_at IS NULL;

UPDATE admin_sessions
SET expired_at = started_at + INTERVAL '8 hours'
WHERE expired_at IS NULL
   OR expired_at <= started_at
   OR expired_at > started_at + INTERVAL '8 hours';

ALTER TABLE admin_sessions
    ALTER COLUMN expired_at SET DEFAULT (NOW() + INTERVAL '8 hours');

-- +goose Down
ALTER TABLE admin_sessions
    ALTER COLUMN expired_at DROP DEFAULT;

DROP INDEX IF EXISTS idx_returns_external_identity;
DROP INDEX IF EXISTS idx_refunds_external_identity;

ALTER TABLE returns
    DROP CONSTRAINT IF EXISTS fk_returns_refund_id_tenant,
    DROP CONSTRAINT IF EXISTS returns_refund_id_fkey,
    ADD CONSTRAINT returns_refund_id_fkey
        FOREIGN KEY (refund_id) REFERENCES refunds(refund_id);

ALTER TABLE returns
    DROP COLUMN IF EXISTS external_return_id,
    DROP COLUMN IF EXISTS source_platform;

ALTER TABLE orders
    DROP CONSTRAINT IF EXISTS fk_orders_customer_entity_id_tenant,
    DROP CONSTRAINT IF EXISTS fk_orders_offer_id_tenant,
    DROP CONSTRAINT IF EXISTS fk_orders_product_id_tenant,
    DROP CONSTRAINT IF EXISTS fk_orders_connected_account_id_tenant,
    DROP CONSTRAINT IF EXISTS orders_customer_entity_id_fkey,
    DROP CONSTRAINT IF EXISTS orders_offer_id_fkey,
    DROP CONSTRAINT IF EXISTS orders_product_id_fkey,
    DROP CONSTRAINT IF EXISTS orders_connected_account_id_fkey,
    ADD CONSTRAINT orders_connected_account_id_fkey
        FOREIGN KEY (connected_account_id) REFERENCES connected_accounts(connected_account_id),
    ADD CONSTRAINT orders_product_id_fkey
        FOREIGN KEY (product_id) REFERENCES products(product_id),
    ADD CONSTRAINT orders_offer_id_fkey
        FOREIGN KEY (offer_id) REFERENCES offers(offer_id),
    ADD CONSTRAINT orders_customer_entity_id_fkey
        FOREIGN KEY (customer_entity_id) REFERENCES entities(entity_id);

DROP POLICY IF EXISTS user_self_clerk_bootstrap ON users;
