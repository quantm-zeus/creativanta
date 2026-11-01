# P0-02 — Reproducible Protobuf Contract Foundation

Authoritative source: `docs/04_contracts/api_behavior_contracts.md`, `docs/04_contracts/protobuf_contracts.md`, `docs/04_contracts/error_catalog.md`. Tool versions: `toolchain.json`.

Physical files use versioned Buf-standard package paths `protos/creativanta/{common,transport}/.../v1/`, while the docs show unversioned domain directory examples. This is a conscious versioned filesystem layout for the first authored slice; it does not rename any existing published API (there was none).

**Important security boundary:** `creativanta.transport.test.v1.TransportFixtureService` is **test-only**, not a customer endpoint. Only integration tests may register its generated handler; production `cmd/api` and `cmd/admin-api` MUST NOT register it.

Generation, with pinned executables on PATH:

```sh
bash tooling/proto-gen.sh generate   # when authoring .proto; commit generated artifacts
bash tooling/proto-gen.sh verify     # after commit; enforces zero generated drift
buf lint
```

Outputs:
- Go protobuf + Connect: `apps/api/gen/creativanta/**`
- TypeScript descriptors: `packages/shared-types/src/creativanta/**`
- Flutter Dart protobuf/grpc: `apps/mobile/lib/generated/creativanta/**`

This proves schema compilation only. **P0-02 acceptance additionally requires** the same Go handler to be exercised from a real TS Connect client and a real Dart gRPC/HTTP2 client, validation+error+deadline/metadata/stream cancellation, signed tenant-bound cursor denial, duplicate/idempotency conflict semantics and no generated drift in CI. No real workspace auth or domain CRUD is available until P0-03 onward.

Pin and install codegen tools locally (matching `toolchain.json`):

```sh
GOBIN="$HOME/.local/bin" go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.36.12
GOBIN="$HOME/.local/bin" go install connectrpc.com/connect/cmd/protoc-gen-connect-go@v1.21.1
npm install --global --prefix "$HOME/.local/opt/creativanta/proto-es" @bufbuild/protoc-gen-es@2.16.0
dart pub global activate protoc_plugin 25.1.0
```

Scripts deliberately fail if any pinned binary/version is unavailable. No secrets or providers are used.
