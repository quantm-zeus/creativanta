# Creativanta P0-01 toolchain

Pinned 2026-10-31. Local installs under `~/.local/opt/creativanta/` and command links in `~/.local/bin/`, kept outside repository and production services.

Go 1.27.3 · Flutter 3.47.9 · Dart 3.13.7 · Node 24.21.0 · pnpm 10.34.9 · Buf 1.75.0 · govulncheck 1.9.0.

`bash tooling/dev/doctor.sh` checks versions and the D0 docs gate. Android emulator and Xcode are not present on this VPS; integration tests require dedicated runners. No OpenBao or production credentials are used.

Rust cleanup on 2026-10-31 removed 24 generated build-cache directories from six Rust worktrees (~37 GiB); kept source and top-level executable binaries. Cargo can regenerate caches during future rebuilds.

## Isolated development PostgreSQL and asynchronous queue

Dev services are pinned by OCI digest in `tooling/dev/compose.yaml`:

- PostgreSQL **17.10**, local only at `127.0.0.1:15432`, image digest `sha256:7958605b...`; role `creativanta_dev` is **only** a local bootstrap role, NOT production `app_user` or `admin_user`.
- Dragonfly **2.0.2**, optional async profile at `127.0.0.1:16379`, image digest `sha256:061f00b...`; not activated by default. The actual event/outbox semantics are P0-05.
- Dedicated `creativanta-p0` Compose project and database volume, separate from existing Evergreen/PEP containers.

```bash
bash tooling/dev/dev-services.sh up      # Create local-only password and start PostgreSQL
bash tooling/dev/dev-services.sh ps      # Check containers
bash tooling/dev/dev-services.sh async   # Optional Dragonfly dev profile
bash tooling/dev/dev-services.sh down    # Stop without deleting the database volume
```

Secrets are generated into `.env.dev.local` (0600), ignored by Git. **Do not use production OpenBao keys**. The volume is persistent until explicitly removed by its owner. P0-01 only verifies a working PostgreSQL process; **schema, tenant roles and RLS are still unimplemented until P0-04**. No database data from the production system was copied.
