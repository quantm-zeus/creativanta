# Creativanta API — P0-01 foundation

**Status: incomplete P0-01 bootstrap; not production ready.**

- Go module: Go 1.27.3, `github.com/quantm-zeus/creativanta/apps/api`.
- `cmd/api`: public API *process*, loopback by default `127.0.0.1:3000`; only `GET /healthz` and `GET /readyz`.
- `cmd/admin-api`: independent Admin API *process*, default `127.0.0.1:3001`, no auth bypass or privileged endpoints.
- `/healthz` returns liveness (HTTP 200). `/readyz` returns **503** until backing identity/data services exist; no fake ready response.
- `cmd/worker`, `cmd/outbox` and `cmd/migrate` deliberately refuse to start (exit code 2), because durable job roles, migrations and schema do not yet exist. They are entrypoint skeletons, not implementations.
- Both HTTP listeners reject wildcard/non-loopback addresses to prevent unintentional exposure during P0. Production traffic must wait for real authentication, ingress controls and RBAC.

Run quality checks:

```sh
cd apps/api
go test -count=1 ./...
go test -race ./...
go vet ./...
test -z "$(gofmt -l cmd internal)"
```

Later slices: P0-02 Protobuf/ConnectRPC and identity metadata; P0-03 Clerk; P0-04 RLS; P0-05 durable jobs; P0-06 credits; P0-07 admin/capabilities. No authentication or backend business functionality is currently implemented.
