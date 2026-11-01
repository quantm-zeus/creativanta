#!/usr/bin/env bash
# P0-02 production transport seam + Go/TS/Dart pure wire validation.
# Run after pinned toolchain + pnpm install + flutter pub get in CI.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"
test -f apps/api/internal/transportauth/interceptor.go
test -f apps/api/internal/transportauth/interceptor_http_test.go
test -f packages/shared-types/src/transport/validation.ts
test -f packages/shared-types/test/validation.test.ts
test -f apps/mobile/lib/core/transport_validation.dart
test -f apps/mobile/test/transport_validation_test.dart

echo 'P0_02_CANONICAL_ERROR_REGISTRY'
python3 - <<'PY'
from pathlib import Path
import re
r=Path.cwd()
catalog=(r/'docs/04_contracts/error_catalog.md').read_text()
codes=set(re.findall(r'^\|\s*([A-Z]+_[A-Z]+_[0-9]{3})\s*\|',catalog,flags=re.M))
go=(r/'apps/api/internal/transportauth/interceptor.go').read_text()
mapping=set(re.findall(r'^\s*"([A-Z]+_[A-Z]+_[0-9]{3})"\s*:',go,flags=re.M))
assert mapping, 'No safety error mapping installed'
assert mapping <= codes, 'Unregistered transport error codes: '+str(sorted(mapping-codes))
for item in ('AUTH_FORBIDDEN_001','SYSTEM_INTERNAL_001','SYSTEM_NOTFOUND_001','ADMIN_FORBIDDEN_001'):
 assert item in mapping, item
print('ERROR_REGISTRY_PASS',len(mapping),'registered transport codes')
PY

echo 'P0_02_TEST_ONLY_FIXTURE_MUST_NOT_ENTER_PRODUCTION'
if grep -R -n -E 'transportfixture|TransportFixtureService|transport/test/v1' apps/api/cmd/api apps/api/cmd/admin-api --include='*.go';then
  echo 'FAIL: test fixture leaked into API/Admin server' >&2
  exit 1
fi
echo 'P0_02_FAIL_CLOSED_INTERCEPTOR'
(cd apps/api && GOTOOLCHAIN=local go test -race -count=1 ./internal/transportauth)
echo 'P0_02_TYPESCRIPT_WIRE_VALIDATION'
pnpm --dir packages/shared-types exec vitest run test/validation.test.ts
echo 'P0_02_DART_WIRE_VALIDATION'
(cd apps/mobile && flutter test --no-pub test/transport_validation_test.dart)
echo 'P0_02_PRODUCTION_TRANSPORT_SEAM_TESTS_PASS'
