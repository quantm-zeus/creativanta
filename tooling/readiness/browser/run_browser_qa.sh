#!/usr/bin/env bash
# ==============================================================================
# Creativanta — Headless Browser Responsive UX & Accessibility QA Gate
# Canonical Sources:
# - docs/00_index/BUILD_EXECUTION_CONTRACT.md (Hard Gate D4/D5)
# - docs/06_quality_ops/accessibility_spec.md (WCAG 2.1 AA)
# - docs/06_quality_ops/ci_cd_pipeline.md
#
# Pinned Versions:
# - Node: 24 (24.21.0)
# - pnpm: 10.34.9
# - Playwright: @playwright/test 1.50.1
# - Chromium Headless Shell: 133.0.6943.16
#
# Zero Greenwashing:
# - If browser headless shell is missing, exit 1 immediately with blocked status.
# - Fails closed on any unexpected error or broken viewports.
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

cd "${REPO_ROOT}"

echo "=== Creativanta Headless Browser QA Runner ==="

# 1. Check Toolchain
NODE_VER=$(node -v | sed 's/v//')
PNPM_VER=$(pnpm -v)
echo "Node: v${NODE_VER}, pnpm: ${PNPM_VER}"

# 2. Check & Configure Unprivileged Shared Libraries for Chromium Headless Shell
UNPRIVILEGED_DEPS="/home/whaleorcale/.local/lib/chromium-deps/usr/lib/x86_64-linux-gnu"
if [ -d "${UNPRIVILEGED_DEPS}" ]; then
  export LD_LIBRARY_PATH="${UNPRIVILEGED_DEPS}:${LD_LIBRARY_PATH:-}"
  echo "Configured unprivileged Chromium shared library path: ${UNPRIVILEGED_DEPS}"
fi

# 3. Check Chromium Headless Shell
LOCAL_SHELL="/home/whaleorcale/.cache/ms-playwright/chromium_headless_shell-1155/chrome-linux/headless_shell"
PW_CACHE_DIR="${PLAYWRIGHT_BROWSERS_PATH:-${HOME}/.cache/ms-playwright}"
DISCOVERED_SHELL=""
if [ -d "${PW_CACHE_DIR}" ]; then
  DISCOVERED_SHELL="$(find "${PW_CACHE_DIR}" -maxdepth 3 -name headless_shell -type f -executable 2>/dev/null | head -n 1 || true)"
fi

if [ -n "${CHROMIUM_EXECUTABLE_PATH:-}" ]; then
  SHELL_BIN="${CHROMIUM_EXECUTABLE_PATH}"
elif [ -f "${LOCAL_SHELL}" ]; then
  SHELL_BIN="${LOCAL_SHELL}"
elif [ -n "${DISCOVERED_SHELL}" ] && [ -x "${DISCOVERED_SHELL}" ]; then
  SHELL_BIN="${DISCOVERED_SHELL}"
else
  # Check if playwright provides browser
  SHELL_BIN=""
fi

if [ -n "${SHELL_BIN}" ] && [ -x "${SHELL_BIN}" ]; then
  echo "Found Chromium Headless Shell: ${SHELL_BIN}"
  SHELL_VER=$("${SHELL_BIN}" --version 2>/dev/null || echo "Unknown")
  echo "Binary version: ${SHELL_VER}"
else
  echo "Checking Playwright default Chromium installation..."
  if ! pnpm exec playwright install-deps --dry-run >/dev/null 2>&1 && [ -z "${SHELL_BIN}" ]; then
    echo "FATAL: Chromium Headless Shell not found and cannot be executed!" >&2
    echo "Please ensure Chromium headless shell is installed via 'pnpm exec playwright install chromium-headless-shell'." >&2
    exit 1
  fi
fi

# 4. Verify & Build Web & Admin Applications (Bound to Current Source Fingerprint)
echo "Checking SvelteKit build artifacts and source fingerprints..."
FP_SCRIPT="${SCRIPT_DIR}/build_fingerprint.mjs"
for app in web admin; do
  if [ "${BROWSER_QA_FORCE_REBUILD:-0}" = "1" ] || ! node "${FP_SCRIPT}" verify "${app}" "${REPO_ROOT}" >/dev/null 2>&1; then
    if [ "${BROWSER_QA_REJECT_STALE_BUILD:-0}" = "1" ]; then
      echo "FATAL: Stale, missing, or unverified build artifact for apps/${app}:" >&2
      node "${FP_SCRIPT}" verify "${app}" "${REPO_ROOT}" >&2
      exit 1
    fi
    echo "Building apps/${app} for current source fingerprint..."
    rm -rf "apps/${app}/build"
    pnpm "build:${app}"
    node "${FP_SCRIPT}" stamp "${app}" "${REPO_ROOT}"
  fi
  node "${FP_SCRIPT}" verify "${app}" "${REPO_ROOT}"
done

# 5. Create Readiness Output Directory
mkdir -p build/readiness/2026-11-05

# 6. Execute Playwright Test Suite across Desktop (1440px), Tablet (768px), and Mobile (390px)
echo "Executing Playwright Chromium Headless Test Suite..."
pnpm exec playwright test --config tooling/readiness/browser/playwright.config.ts "$@"

# 7. Verify Real Browser Execution & Zero Skipped Gates
python3 - <<'PY'
import json, pathlib, sys
report_path = pathlib.Path("build/readiness/2026-11-05/browser_results.json")
if not report_path.is_file():
    print("FATAL: build/readiness/2026-11-05/browser_results.json was not generated!", file=sys.stderr)
    sys.exit(1)
data = json.load(report_path.open())
stats = data.get("stats", {})
expected = int(stats.get("expected", 0))
unexpected = int(stats.get("unexpected", 0))
flaky = int(stats.get("flaky", 0))
skipped = int(stats.get("skipped", 0))
print(f"Verified Playwright results: expected={expected}, unexpected={unexpected}, flaky={flaky}, skipped={skipped}")
if expected <= 0 or unexpected != 0 or flaky != 0 or skipped != 0:
    print("FATAL: Browser QA requires expected > 0 and zero unexpected/flaky/skipped tests!", file=sys.stderr)
    sys.exit(1)
PY

echo "=== Browser Responsive UX & Accessibility QA Gate Passed Successfully ==="
