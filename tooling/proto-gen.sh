#!/usr/bin/env bash
# Reproducible P0-02 four-target Proto generation; generated code is committed.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
mode="${1:-verify}"
[[ "$mode" == generate || "$mode" == verify ]] || { echo 'Usage: tooling/proto-gen.sh {generate|verify}' >&2; exit 2; }

for tool in buf protoc-gen-go protoc-gen-connect-go protoc-gen-es protoc-gen-dart go pnpm dart; do
  command -v "$tool" >/dev/null || { echo "FATAL missing $tool" >&2; exit 1; }
done

[[ "$(buf --version)" == 1.75.0 ]] || { echo 'FATAL: Buf 1.75.0 required' >&2; exit 1; }
[[ "$(protoc-gen-go --version)" == 'protoc-gen-go v1.36.12' ]] || { echo 'FATAL: protoc-gen-go v1.36.12 required' >&2; exit 1; }
[[ "$(protoc-gen-connect-go --version)" == '1.21.1' ]] || { echo 'FATAL: protoc-gen-connect-go v1.21.1 required' >&2; exit 1; }
[[ "$(protoc-gen-es --version)" == 'protoc-gen-es v2.16.0' ]] || { echo 'FATAL: protoc-gen-es v2.16.0 required' >&2; exit 1; }
dart pub global list | grep -Fq 'protoc_plugin 25.1.0' || { echo 'FATAL: protoc_plugin 25.1.0 required' >&2; exit 1; }

echo 'PROTO_SOURCE_LINT'
buf lint
echo 'GENERATE_GO_TS_DART'
buf generate --template buf.gen.yaml
# protoc-gen-es emits an extra blank EOF line; normalize consistently for Git whitespace checks.
python3 - <<'PY'
from pathlib import Path
for path in Path('packages/shared-types/src').rglob('*.ts'):
    source = path.read_text(encoding='utf8')
    path.write_text(source.rstrip('\n') + '\n', encoding='utf8')
PY

echo 'GO_COMPILE'
(cd apps/api && GOTOOLCHAIN=local go test ./gen/... && GOTOOLCHAIN=local go mod verify)
echo 'TS_COMPILE'
pnpm --dir packages/shared-types check
echo 'DART_COMPILE'
(cd apps/mobile && dart analyze lib/generated)

if [[ "$mode" == verify ]]; then
  echo 'REJECT_GENERATED_CODE_DRIFT'
  generated=(apps/api/gen packages/shared-types/src apps/mobile/lib/generated)
  git diff --exit-code -- "${generated[@]}"
  if [[ -n "$(git ls-files --others --exclude-standard -- "${generated[@]}")" ]]; then
    echo 'FATAL: untracked generated code; run generate and commit it' >&2
    git ls-files --others --exclude-standard -- "${generated[@]}" >&2
    exit 1
  fi
fi

echo "PROTO_4_TARGETS_PASS mode=$mode"
