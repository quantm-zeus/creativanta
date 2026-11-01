#!/usr/bin/env bash
# Isolated Creativanta development services, never production.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"
umask 077
if [[ ! -f .env.dev.local ]]; then
  python3 - <<'PY'
from pathlib import Path
import os,secrets
path=Path('.env.dev.local')
try:
 fd=os.open(path,os.O_WRONLY|os.O_CREAT|os.O_EXCL,0o600)
except FileExistsError:
 pass
else:
 with os.fdopen(fd,'w') as f:
  f.write('CV_DB_DEV_PASSWORD='+secrets.token_urlsafe(34)+'\n')
PY
fi
command -v docker >/dev/null || { echo 'Docker is required' >&2; exit 1; }
base=(docker compose --env-file .env.dev.local -f tooling/dev/compose.yaml)
case "${1:-}" in
  up)
    "${base[@]}" --profile database up -d --wait postgres
    "${base[@]}" exec -T postgres psql -U creativanta_dev -d creativanta_dev -Atqc 'SELECT 1;' | grep -qx 1
    echo 'Creativanta dev PostgreSQL is healthy (localhost:15432)'
    ;;
  down)
    "${base[@]}" --profile database --profile async down
    echo 'Development containers stopped; data volume preserved'
    ;;
  ps)
    "${base[@]}" --profile database --profile async ps
    ;;
  async)
    "${base[@]}" --profile async up -d --wait dragonfly
    echo 'Optional dev Dragonfly is healthy (localhost:16379)'
    ;;
  *)
    echo 'Usage: bash tooling/dev/dev-services.sh {up|down|ps|async}' >&2
    exit 2
    ;;
esac
