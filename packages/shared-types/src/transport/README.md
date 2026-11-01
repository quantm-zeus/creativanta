# Creativanta TypeScript Connect Transport Client

This directory provides documentation and architectural rules for Creativanta's TypeScript ConnectRPC client transport layer.

## Overview

Creativanta services communicate using Connect protocols with Protocol Buffers v2 (`@bufbuild/protobuf` and `@connectrpc/connect`).

### Core Rules and Guarantees

1. **Financial Decimal Precision**:
   - Money fields (`Money.amount`) are serialized as exact decimal strings.
   - Floating-point representations (`float`, `double`) are strictly prohibited per DB-H-001.

2. **Command Context & Idempotency**:
   - State-changing commands take a `CommandContext` message containing a client-generated `idempotencyKey` and a strongly-typed `workspaceId` wrapped in `UUID`.
   - Replays with identical payloads return `replayed: true`.
   - Replays with conflicting payloads return `ConnectError` with code `Code.AlreadyExists`.

3. **Workspace Scoping & Pagination Security**:
   - Every request must include the `x-workspace-id` HTTP header.
   - Pagination tokens (`nextPageToken`) are cryptographically or logically scoped to the emitting workspace.
   - Submitting a token under a mismatched workspace header is rejected with `Code.InvalidArgument`.

4. **Cancellation and Streaming**:
   - All methods accept standard `AbortSignal` for timeout and cancellation.
   - Server-streaming methods (`watch`) return an `AsyncIterable` that cleanly throws an abort/cancellation error when the `AbortController` triggers.
