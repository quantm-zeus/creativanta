---
description: Code style and quality standards for Creativanta tech stack
---
# Code Quality Rules

## Go (backend)
- Follow docs/05_system/tech_stack_adr.md ADR-015; one Go module at apps/api.
- Use net/http + ConnectRPC, pgx/v5 + sqlc, and versioned Goose SQL migrations.
- Pass context.Context and deadlines through DB/provider calls; bound goroutine concurrency and join workers during shutdown.
- Return and wrap errors with %w; no panic for expected request/provider failures.
- Use only the validated tenant transaction and sqlc WithTx for tenant queries. Never fall back to the pool in a tenant command.
- Money/credits use exact decimal arithmetic and decimal strings at transport boundaries; never float32/float64.
- Keep auth, permission, tier/object/approval/capability checks explicit; Go does not enforce these automatically.
- Run gofmt, go vet, go test -race, govulncheck and code-generation drift checks for the touched Go module.

## Svelte 5 (web frontend)
- Use Runes syntax: $state, $derived, $effect — NOT Svelte 4 stores
- Component props via $props() rune
- Use shadcn-svelte components for UI primitives
- TanStack Query for server state, $state for local UI state

## Flutter (mobile)
- Riverpod 2.x for all state management — no Provider, no Bloc
- go_router for all navigation — no Navigator.push directly
- Use Drift for local SQLite, Hive for key-value
- Platform-adaptive: Material 3 for Android, Cupertino for iOS

## General
- No hardcoded strings — use i18n keys (Paraglide for web, intl for Flutter)
- No hardcoded secrets — env vars only
- Vietnamese first for user-facing content
