#!/usr/bin/env bash
# P0-02 strict: generated contracts compile, remain tracked, and are backward compatible.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

if [ ! -w "${XDG_CONFIG_HOME:-$HOME/.config}" ] && [ -d "$HOME/.flutter_config" ]; then
  export XDG_CONFIG_HOME="$HOME/.flutter_config"
fi

if [ -z "${GOTMPDIR:-}" ] && [ -d "$HOME/tmp" ]; then
  export GOTMPDIR="$HOME/tmp"
fi

test -f buf.yaml && test -f buf.gen.yaml
test -f protos/creativanta/common/v1/types.proto
test -f protos/creativanta/common/v1/errors.proto
test -f protos/creativanta/transport/test/v1/fixture.proto
test -f apps/api/gen/creativanta/transport/test/v1/transporttestv1connect/fixture.connect.go
test -f packages/shared-types/src/creativanta/transport/test/v1/fixture_pb.ts
test -f apps/mobile/lib/generated/creativanta/transport/test/v1/fixture.pbgrpc.dart
test -f apps/api/internal/transportfixture/server_test.go
test -f apps/mobile/test/generated_proto_test.dart
test -f packages/shared-types/test/unit.test.ts

echo 'CONTRACT_CODEGEN_DRIFT'
bash tooling/proto-gen.sh verify

if ! git rev-parse --verify origin/main >/dev/null 2>&1; then
  echo 'FATAL: origin/main required for contract breaking gate' >&2
  exit 1
fi
if git ls-tree -r --name-only origin/main -- protos | grep -q '\.proto$';then
  echo 'CHECK_BACKWARD_COMPATIBILITY'
  buf breaking --against '.git#branch=origin/main'
else
  echo 'INITIAL_PROTO_BASELINE: origin/main contains zero protos'
fi

echo 'TEST_ONLY_FIXTURE_ISOLATION'
if grep -R -n -E 'transportfixture|TransportFixtureService' apps/api/cmd/api apps/api/cmd/admin-api --include='*.go';then
  echo 'FATAL: test fixture referenced by production API or Admin API' >&2
  exit 1
fi

echo 'GO_TRANSPORT_NEGATIVE_TESTS_AND_RACE'
(cd apps/api &&
 GOTOOLCHAIN=local go test -race -count=1 ./gen/... ./internal/transportfixture ./cmd/transport-fixture-test &&
 GOTOOLCHAIN=local go vet ./... &&
 GOTOOLCHAIN=local go mod verify)

echo 'UNIT_TYPESCRIPT'
pnpm --dir packages/shared-types test
echo 'UNIT_DART'
(cd apps/mobile && flutter test --no-pub test/generated_proto_test.dart)
echo 'P0_PROTO_CONTRACT_AND_LOCAL_TEST_PASS'
