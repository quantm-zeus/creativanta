---
layer: quality_ops
canonical: true
last_updated: 2026-10-29
---

# Seed Data and Fixture Policy

## 1. Executable source and ownership

[seed_data.sql](seed_data.sql) is the sole source for runnable seed values and ordering. This file owns intent/environment policy, not a second copy of INSERT statements. Execute only on a disposable local/test/demo database with migration credentials, never the runtime API role or a live customer database.

Required order: currencies/regions → users → workspaces → memberships → content/catalog → credit lots → credit ledger/history and reconciled workspace projections → illustrative finance data. Schema migrations and narrow grants must be installed first. All IDs and unique source keys are deterministic; running the script twice cannot duplicate fixtures. `ON_ERROR_STOP=1` is mandatory for psql.

## 2. Current seed coverage

The executable seed contains five users, three workspaces (Pro/Starter/Business), five memberships, three ideas, three products, four credit source lots, six credit transactions, one UI-only profit snapshot and two costs. It does not claim to seed all modules or execute financial recognition. Pro ledger and lots reconcile to 2,420 credits; Starter to 500; Business to 10,000; reserved is zero. Purchased credit is a separate non-expiring lot.

The UI-only profit snapshot is illustrative data for rendering. It must never be used as accepted evidence of financial accuracy or as an official source-class profit claim. Financial acceptance uses the independently specified golden fixtures in [Financial computation](../04_contracts/financial_computation_contract.md).

## 3. Phase fixtures

Each slice adds its deterministic fixtures and evidence packet. P0 needs two-tenant junction/FK/security/revocation/replay/reservation recovery cases; P1 needs completed/pending/refunded orders, partial settlements and historical FX/COGS; later phases add their canonical objects, manual/degraded states and permission cases. Use product_skus and affiliate_commissions; do not introduce order_items, skus or commissions as parallel canonical objects.

Fixture data must contain no real customer tokens, biometric/voice samples, private messages or personal data. Provider test adapters are labeled and cannot satisfy a live access/permission/license gate. Clear generated media/storage objects after tests with a scoped cleanup identity.

## 4. Execution and verification

Use the migration connection in a disposable environment:

```bash
psql "$MIGRATION_DATABASE_URL" -v ON_ERROR_STOP=1 -f docs/06_quality_ops/seed_data.sql
```

Then rerun and compare row counts, source keys, credit lot/ledger/projection totals and tenant visibility under app_user. Seed SQL execution is a required P0 check; static parsing alone does not establish it. Retain stdout/exit status in the phase packet without printing credentials. A reset must require an explicitly disposable database and cannot reuse production secrets.
