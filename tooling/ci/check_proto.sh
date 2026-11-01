#!/usr/bin/env bash
# ==============================================================================
# Creativanta CI/CD - Protobuf Transport Quality Gate
# Canonical Source: docs/06_quality_ops/ci_cd_pipeline.md (Transport stage)
# Pinned Toolchain: Buf 1.75.0
# Zero Greenwashing: Missing proto definitions, lint errors, or breaking changes
# fail immediately.
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

cd "${REPO_ROOT}"

echo "=== Protobuf Transport Quality Gate ==="

# 1. Zero Greenwashing: Proto Artifact Check
if [ ! -d "protos" ] && [ ! -f "buf.yaml" ]; then
    echo "FATAL: Neither 'protos' directory nor 'buf.yaml' was found! Protobuf artifacts are missing." >&2
    exit 1
fi

# 2. Toolchain check
if ! command -v buf >/dev/null 2>&1; then
    echo "FATAL: 'buf' binary not found in PATH." >&2
    exit 1
fi

BUF_VER=$(buf --version | sed 's/v//')
echo "Detected Buf version: $BUF_VER"

if [[ "${STRICT_TOOLCHAIN:-1}" == "1" && "$BUF_VER" != "1.75.0"* ]]; then
    echo "FATAL: Buf version violation. Required: 1.75.0, Got: $BUF_VER" >&2
    exit 1
fi

# 3. Buf Lint
echo "Running buf lint..."
buf lint

# 4. Buf Breaking Change Check (if git tracking base exists)
if git rev-parse --verify origin/main >/dev/null 2>&1; then
    echo "Running buf breaking against origin/main..."
    buf breaking --against '.git#branch=origin/main'
elif git rev-parse --verify HEAD~1 >/dev/null 2>&1; then
    echo "Running buf breaking against HEAD~1..."
    buf breaking --against '.git#commit=HEAD~1'
fi

# 5. Generated code drift check
if [ -f "buf.gen.yaml" ]; then
    echo "Checking code generation drift (buf generate)..."
    buf generate
    DIFF=$(git status --porcelain -- apps/api/gen apps/web/src/lib/gen apps/mobile/lib/gen 2>/dev/null)
    if [ -n "$DIFF" ]; then
        echo "FATAL: Protobuf code generation drift detected! Commit generated files." >&2
        echo "$DIFF" >&2
        exit 1
    fi
fi

echo "=== Protobuf Transport Quality Gate: ALL CHECKS PASSED ==="
