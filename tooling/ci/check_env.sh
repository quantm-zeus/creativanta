#!/usr/bin/env bash
# Strict local Creativanta P0-01 toolchain audit; CI jobs check their own selected tools.
set -euo pipefail

need() {
  command -v "$1" >/dev/null 2>&1 || { echo "FATAL: missing required tool: $1" >&2; exit 1; }
}
need go
need flutter
need dart
need node
need pnpm
need buf
need govulncheck

GO_VERSION="$(go version)"
[[ "$GO_VERSION" == *'go1.27.3 '* ]] || { echo "FATAL: $GO_VERSION, require Go 1.27.3" >&2; exit 1; }
FLUTTER_VERSION="$(flutter --version | head -n 1)"
[[ "$FLUTTER_VERSION" == 'Flutter 3.47.9 '* ]] || { echo "FATAL: $FLUTTER_VERSION, require Flutter 3.47.9" >&2; exit 1; }
DART_VERSION="$(dart --version 2>&1)"
[[ "$DART_VERSION" == 'Dart SDK version: 3.13.7 '* ]] || { echo "FATAL: $DART_VERSION, require Dart 3.13.7" >&2; exit 1; }
NODE_VERSION="$(node --version)"
[[ "$NODE_VERSION" == v24.* ]] || { echo "FATAL: $NODE_VERSION, require Node 24" >&2; exit 1; }
PNPM_VERSION="$(pnpm --version)"
[[ "$PNPM_VERSION" == 10.34.9 ]] || { echo "FATAL: $PNPM_VERSION, require pnpm 10.34.9" >&2; exit 1; }
BUF_VERSION="$(buf --version)"
[[ "$BUF_VERSION" == 1.75.0 ]] || { echo "FATAL: $BUF_VERSION, require Buf 1.75.0" >&2; exit 1; }
VULN_VERSION="$(govulncheck -version)"
[[ "$VULN_VERSION" == *'Scanner: govulncheck@v1.9.0'* ]] || { echo "FATAL: require govulncheck v1.9.0" >&2; exit 1; }
echo 'P0_TOOLCHAIN_PASS: Go 1.27.3, Flutter 3.47.9, Dart 3.13.7, Node 24, pnpm 10.34.9, Buf 1.75.0, govulncheck 1.9.0'
