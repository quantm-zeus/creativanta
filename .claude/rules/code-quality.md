---
description: Code style and quality standards for Creativanta tech stack
---
# Code Quality Rules

## Rust (backend)
- Use thiserror for library errors, anyhow for application errors
- Use SeaORM 2.0 entity pattern — do not write raw SQL unless necessary
- Async-first: use Tokio, avoid blocking calls in async context
- Error handling: never use .unwrap() in production code — use ? operator

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
