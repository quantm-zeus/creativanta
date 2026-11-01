# Creativanta generated Protobuf contracts

This package holds **only Buf-generated** TypeScript descriptors from the canonical `protos/` tree. Files inside `src/creativanta/` are generated; edit `.proto` and run `tooling/proto-gen.sh generate`, not the outputs.

`creativanta/transport/test/v1/fixture.proto` is strictly a test-only handler contract. It MUST NOT be registered in production API/Admin API.

`pnpm --dir packages/shared-types check` verifies generated TS descriptors; actual Connect TS client transport tests are implemented in the P0-02 client slice.
