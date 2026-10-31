#!/usr/bin/env bash
# ==============================================================================
# Creativanta CI/CD - Toolchain Version Verification
# Enforces exact pinned versions per ADR-015, tech_stack_adr.md, and CI contract.
# No greenwashing: any version mismatch or missing tool fails immediately.
# ==============================================================================
set -euo pipefail

PINNED_GO="1.27.3"
PINNED_FLUTTER="3.47.9"
PINNED_NODE="24"
PINNED_PNPM="10.34.9"
PINNED_BUF="1.75.0"

echo "=== Verifying Toolchain Pinned Versions ==="

# 1. Check Go
if command -v go >/dev/null 2>&1; then
    GO_ACTUAL=$(go version | awk '{print $3}' | sed 's/go//')
    echo "Found Go: $GO_ACTUAL (Expected: $PINNED_GO)"
    if [[ "$GO_ACTUAL" != "$PINNED_GO"* ]]; then
        echo "FATAL: Go version mismatch! Expected $PINNED_GO, got $GO_ACTUAL" >&2
        exit 1
    fi
else
    echo "WARNING: 'go' not found in current PATH." >&2
fi

# 2. Check Node
if command -v node >/dev/null 2>&1; then
    NODE_ACTUAL=$(node -v | sed 's/v//')
    echo "Found Node: $NODE_ACTUAL (Expected major: $PINNED_NODE)"
    if [[ "$NODE_ACTUAL" != "$PINNED_NODE"* ]]; then
        echo "FATAL: Node version mismatch! Expected major $PINNED_NODE, got $NODE_ACTUAL" >&2
        exit 1
    fi
else
    echo "WARNING: 'node' not found in current PATH." >&2
fi

# 3. Check pnpm
if command -v pnpm >/dev/null 2>&1; then
    PNPM_ACTUAL=$(pnpm -v)
    echo "Found pnpm: $PNPM_ACTUAL (Expected: $PINNED_PNPM)"
    if [[ "$PNPM_ACTUAL" != "$PINNED_PNPM" ]]; then
        echo "FATAL: pnpm version mismatch! Expected $PINNED_PNPM, got $PNPM_ACTUAL" >&2
        exit 1
    fi
else
    echo "WARNING: 'pnpm' not found in current PATH." >&2
fi

# 4. Check Flutter
if command -v flutter >/dev/null 2>&1; then
    FLUTTER_ACTUAL=$(flutter --version | head -n 1 | awk '{print $2}')
    echo "Found Flutter: $FLUTTER_ACTUAL (Expected: $PINNED_FLUTTER)"
    if [[ "$FLUTTER_ACTUAL" != "$PINNED_FLUTTER"* ]]; then
        echo "FATAL: Flutter version mismatch! Expected $PINNED_FLUTTER, got $FLUTTER_ACTUAL" >&2
        exit 1
    fi
else
    echo "WARNING: 'flutter' not found in current PATH." >&2
fi

# 5. Check Buf
if command -v buf >/dev/null 2>&1; then
    BUF_ACTUAL=$(buf --version | sed 's/v//')
    echo "Found Buf: $BUF_ACTUAL (Expected: $PINNED_BUF)"
    if [[ "$BUF_ACTUAL" != "$PINNED_BUF"* ]]; then
        echo "FATAL: Buf version mismatch! Expected $PINNED_BUF, got $BUF_ACTUAL" >&2
        exit 1
    fi
else
    echo "WARNING: 'buf' not found in current PATH." >&2
fi

echo "Toolchain verification passed."
