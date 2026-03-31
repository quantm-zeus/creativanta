---
layer: quality_ops
canonical: true
source_file: impl_c2_security_threat_model.md
last_verified: 2026-03-30
---

# C2 — Security Threat Model

> **Upstream**: Product Freeze §43, Pack 07 (Legal), Pack 08 (Pricing)

---

## 1. Attack Surface Map

| Surface | Assets | Threats | Mitigations |
|---|---|---|---|
| **Web App** | User sessions, UI | XSS, CSRF, clickjacking | CSP headers, SameSite cookies, frame-ancestors |
| **API Layer** | Business data | Injection, broken auth, BOLA | Input validation, JWT+RBAC, RLS |
| **OAuth Tokens** | Platform access | Token theft, replay | AES-256-GCM encryption at rest, short-lived tokens |
| **AI Pipeline** | Prompts, outputs | Prompt injection, data leakage | Input sanitization, output filtering, sandbox |
| **File Upload** | User content | Malware, oversized files | File type validation, size limits, virus scan |
| **Webhooks** | Event data | Spoofing, replay | Signature verification, idempotency keys |
| **Database** | All business data | SQL injection, data breach | Parameterized queries (SQLx), RLS, encryption |
| **Admin Site** | Internal tools | Privilege escalation | VPN-only, MFA, separate auth, audit log |

---

## 2. OWASP Top 10 (2025) Coverage

| # | Vulnerability | Risk | Mitigation |
|---|---|---|---|
| A01 | Broken Access Control | HIGH | PostgreSQL RLS + Rust Tower RBAC middleware + permission checks |
| A02 | Cryptographic Failures | MED | AES-256-GCM tokens, Argon2id passwords, TLS everywhere |
| A03 | Injection | HIGH | SQLx compile-time SQL verification, Protobuf typed inputs |
| A04 | Insecure Design | MED | Threat modeling (this doc), security reviews |
| A05 | Security Misconfiguration | MED | Docker hardening, minimal images, no default passwords |
| A06 | Vulnerable Components | MED | Cargo audit, npm audit, automated Dependabot |
| A07 | Auth Failures | HIGH | Clerk (managed IdP), JWT validation, rate limiting auth endpoints |
| A08 | Data Integrity Failures | MED | Webhook signature verification, Protobuf schema validation |
| A09 | Logging/Monitoring Gaps | LOW | Structured tracing, Sentry, audit events for all critical actions |
| A10 | SSRF | MED | URL allowlisting for platform APIs, no user-supplied URL fetch |

---

## 3. Multi-Tenant Isolation

```
Defense-in-Depth Layers:
1. JWT → extract workspace_id (Tower middleware)
2. Rust service → validate workspace_id belongs to user
3. PostgreSQL RLS → SET LOCAL app.current_tenant_id
4. Query → RLS policy automatically filters ALL data
5. Audit → every cross-tenant attempt logged
```

**Critical Rule**: No query can ever return data from another workspace, even if application code has a bug. RLS is the safety net.

---

## 4. Secrets Management

| Secret | Storage | Rotation |
|---|---|---|
| Database passwords | `.env` (dev), Infisical (prod) | 90 days |
| API keys (AI providers) | `.env` / Infisical | On compromise |
| OAuth tokens (platforms) | PostgreSQL (AES-256-GCM encrypted) | Auto-refresh |
| Clerk webhook secret | `.env` / Infisical | On rotation |
| Stripe webhook secret | `.env` / Infisical | On rotation |
| JWT signing keys | Clerk-managed | Clerk-managed |
| R2 access keys | `.env` / Infisical | 90 days |

---

## 5. Rate Limiting Strategy

| Endpoint | Limit | Window | Response |
|---|---|---|---|
| Auth endpoints | 10 req | 1 min/IP | 429 + Retry-After |
| AI generation | 20 req | 1 min/workspace | 429 + queue position |
| Publish | 60 req | 1 min/workspace | 429 |
| Webhooks | 1000 req | 1 min/global | 429 |
| Public API | 100 req | 1 min/API key | 429 + X-RateLimit headers |
| File upload | 30 req | 1 min/workspace | 429 |

Implementation: Sliding window counter via Dragonfly, Tower middleware.

---

## 6. Content Security

| Concern | Mitigation |
|---|---|
| User-uploaded malware | File type allowlist, max size (500MB video), ClamAV scan |
| AI-generated harmful content | OpenAI Moderation API pre-check, Gemini safety filters |
| Copyright infringement | ACRCloud audio fingerprinting, originality score for remixes |
| EU AI Act compliance | C2PA metadata injection, AI-generated content labeling |
| Data deletion (GDPR prep) | Soft delete + hard delete pipeline, export endpoint |
| Consent management | Click-wrap ToS, explicit AI data opt-in, 5-year retention |

---

## 7. Incident Response Checklist

1. **Detect**: Sentry alert / user report / monitoring trigger
2. **Contain**: Disable affected endpoint / rotate compromised key
3. **Assess**: Scope of data exposure, affected workspaces
4. **Notify**: Affected users within 72 hours (GDPR requirement)
5. **Remediate**: Patch vulnerability, deploy fix
6. **Post-mortem**: Document root cause, prevention measures

---

## Developer Implementation Checklist
> Pass checklist này trước khi merge bất kỳ feature branch nào.

### Multi-tenancy
- [ ] Mọi query có WHERE workspace_id = current_tenant_id
- [ ] Bảng mới có ENABLE ROW LEVEL SECURITY (xem DB-C-002)
- [ ] Bảng mới có FORCE ROW LEVEL SECURITY (xem DB-C-001)
- [ ] Policy đã được tạo: CREATE POLICY tenant_isolation ON <table>

### Security
- [ ] Không có secret trong code — dùng env vars
- [ ] Input validation ở server side
- [ ] Mọi endpoint check RBAC permission trước execute
- [ ] Mọi write action có audit event

### Data integrity
- [ ] Money/credit fields dùng NUMERIC(18,6), không REAL/FLOAT (xem DB-H-001)
- [ ] Production tables có deleted_at TIMESTAMPTZ (xem DB-H-003)
- [ ] State transitions có audit trail

### AI-specific
- [ ] Generation job ghi: provider, model, cost, latency, status, lineage
- [ ] Originality check pass trước khi expose AI remix output (<30% similarity)
- [ ] Digital twin / voice clone có consent verification (xem legal_compliance.md)
