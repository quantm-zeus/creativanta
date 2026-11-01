#!/usr/bin/env bash
# P0-01 must keep worker, outbox and migrate fail-closed before durable contracts ship.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DIR="$(mktemp -d)"
trap 'rm -rf "$DIR"' EXIT
cd "$ROOT/apps/api"
for role in worker outbox migrate; do
  GOTOOLCHAIN=local go build -o "$DIR/$role" "./cmd/$role"
  set +e
  "$DIR/$role" > "$DIR/$role.log" 2>&1
  rc=$?
  set -e
  if [[ $rc -ne 2 ]]; then
    echo "FAIL: $role should exit 2 without required schema/credentials, got $rc" >&2
    cat "$DIR/$role.log" >&2
    exit 1
  fi
  if ! grep -q 'not implemented' "$DIR/$role.log"; then
    echo "FAIL: $role failed without explicit implementation gate" >&2
    exit 1
  fi
  echo "PASS: $role fails closed (exit 2)"
done
echo 'P0_ENTRYPOINTS_FAIL_CLOSED_PASS'
