# Creativanta P0-01 toolchain

Pinned 2026-10-31. Local installs under `~/.local/opt/creativanta/` and command links in `~/.local/bin/`, kept outside repository and production services.

Go 1.27.3 · Flutter 3.47.9 · Dart 3.13.7 · Node 24.21.0 · pnpm 10.34.9 · Buf 1.75.0.

`bash tooling/dev/doctor.sh` checks versions and the D0 docs gate. Android emulator and Xcode are not present on this VPS; integration tests require dedicated runners. No OpenBao or production credentials are used.

Rust cleanup on 2026-10-31 removed 24 generated build-cache directories from six Rust worktrees (~37 GiB); kept source and top-level executable binaries. Cargo can regenerate caches during future rebuilds.
