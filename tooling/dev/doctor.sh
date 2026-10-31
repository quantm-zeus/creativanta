#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../../"
echo '[P0-00] Toolchain verification'
command -v go >/dev/null && go version | grep -q 'go1.27.3'
command -v flutter >/dev/null && flutter --version | grep -q 'Flutter 3.47.9'
command -v dart >/dev/null && dart --version 2>&1 | grep -q 'Dart SDK version: 3.13.7'
command -v node >/dev/null && test "$(node -v)" = 'v24.21.0'
command -v pnpm >/dev/null && test "$(pnpm --version)" = '10.34.9'
command -v buf >/dev/null && test "$(buf --version)" = '1.75.0'
echo '[P0-00] Tool versions: PASS'
PYTHONDONTWRITEBYTECODE=1 python3 tooling/build_plan.py
PYTHONDONTWRITEBYTECODE=1 python3 tooling/check_docs.py
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tooling/tests
echo '[P0-00] D0 and 23 tooling tests: PASS'
echo '[P0-00] Important: this is NOT evidence for D1-D5 or P0-01 acceptance'
