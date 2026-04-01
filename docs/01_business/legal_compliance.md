---
layer: business
canonical: true
source: creativanta_legal_compliance_consent_contract_v_3_1.md, creativanta_supplementary_s19_customer_support_v_3_1.md
last_updated: 2026-03-30
---

# Legal & Compliance

> ⚠️ HUMAN REVIEW REQUIRED
> File này được tổng hợp bởi AI từ legal docs.
> PHẢI được review bởi người có thẩm quyền trước khi implement.
> Reviewer: **Pending — Product Owner / Legal Counsel** (required before Phase 0 launch) | Review date: **Pre-launch mandatory** | Status: ⚠️ AWAITING HUMAN REVIEW

---

## 1. Key Compliance Requirements

Các yêu cầu compliance ảnh hưởng **trực tiếp** đến implementation:

| Requirement | Impact | Priority |
|---|---|---|
| **Cookie consent banner** | Phải hiện ngay lần đầu truy cập, trước mọi tracking (trừ strictly necessary) | P0 — Launch blocker |
| **ToS + Privacy Policy acceptance** | Click-wrap bắt buộc trước khi sử dụng | P0 — Launch blocker |
| **AI content labeling** | "AI-assisted" badge mandatory trên mọi AI output trong UI | P0 — EU AI Act (Aug 2026) |
| **C2PA metadata** | Machine-readable AI content tagging embedded in exports | P1 — EU AI Act |
| **DMCA process** | Takedown trong 48 giờ, 3-strike policy | P0 — Legal |
| **Age verification** | Minimum 18 tuổi, self-declaration + payment verification | P0 — Launch blocker |
| **Data export** | Within 72 hours, JSON + CSV format | P1 — GDPR/PDPA |
| **Account deletion** | 14-day grace → complete within 30 days | P1 — GDPR/PDPA |
| **Pre-publish compliance scan** | Check music copyright, hashtag limits, disclosure, banned keywords | P0 — Platform compliance |
| **Financial data disclaimer** | Source class + confidence badge on all financial surfaces | P0 — Liability protection |

---

## 2. Consent Flows

### 2.1 Consent Types

| Consent Type | When | Must Have |
|---|---|---|
| **Cookie consent** | First visit | Accept All / Reject All / Customize |
| **ToS acceptance** | Account creation + major ToS changes | Click-wrap checkbox |
| **Privacy policy** | Account creation | Acknowledgment |
| **AI data usage** | Settings | Explicit opt-in, default OFF |
| **Connected account scopes** | Each connect flow | Scope disclosure before OAuth |
| **AI Remix disclaimer** | Before each Remix | Checkbox + confirm |
| **Digital Twin consent** | Character creation | Explicit consent verification |

### 2.2 Consent States

| State | Mô tả |
|---|---|
| **Not requested** | Consent chưa được hỏi |
| **Granted** | User đồng ý |
| **Denied** | User từ chối |
| **Withdrawn** | User rút lại consent trước đó |
| **Expired** | Cookie consent hết hạn sau 12 tháng |

### 2.3 Consent Rules
- Consent record lưu với: timestamp, IP, user agent, choices
- Withdraw consent phải dễ dàng như grant consent
- Cookie consent re-ask sau 12 tháng
- AI training consent: user data KHÔNG dùng để train models chung — default OFF

---

## 3. Data Retention Rules

| Data Type | Active | After Deletion | Legal Retention |
|---|---|---|---|
| Personal data | Suốt subscription | Purge 30 days after grace | — |
| Content data | Suốt subscription | Purge 30 days | — |
| AI generation history | Suốt subscription | Purge 30 days | — |
| Financial/billing records | Suốt subscription | — | 7 năm (tax law), anonymized |
| Consent records | Suốt active + 5 năm | — | 5 năm after expired/withdrawn |
| ToS acceptance | Suốt active + 3 năm | — | 3 năm |
| DMCA records | — | — | 5 năm |
| AUP violations | — | — | 3 năm |
| Audit trail | — | — | 3 năm, anonymized |
| Backup data | — | Purge 90 days | — |

---

## 4. GDPR Obligations

### 4.1 Data Subject Rights

| Right | Implementation | SLA |
|---|---|---|
| **Access** (Right to know) | Export data qua Settings | 30 ngày |
| **Rectification** | Sửa data qua workspace settings | Immediate |
| **Erasure** (Right to be forgotten) | Delete account flow | 14-day grace → 30 days |
| **Portability** | Export JSON + CSV | 72 giờ |
| **Object** | Opt-out marketing, analytics | Immediate |
| **Restrict processing** | Tạm dừng xử lý data | Upon request |

### 4.2 Data Processing Rules
- Data chỉ xử lý cho declared purposes
- Third-party processors phải có DPA (Data Processing Agreement)
- Cross-workspace data isolation bắt buộc
- International data transfer: SCCs khi cần

### 4.3 Account Deletion Scope
- **Deleted permanently**: personal data, content, AI history, file/blob storage, connected account tokens
- **Retained (anonymized)**: financial records (7 năm), consent records (5 năm), audit trail (3 năm), DMCA/AUP records (5 năm)
- **Out of control**: content already published trên third-party platforms
- Third-party cleanup: notify platforms of token revocation within 24 hours

---

## 5. Digital Twin / Voice Clone Consent

> Critical cho M07 (AI Video Studio) và M08 (Continuity OS)

### 5.1 Character Types & Consent

| Character Type | Consent Required | Notes |
|---|---|---|
| **Stock avatar** | No extra consent | System-provided |
| **AI Generated** | Standard AI usage consent | User creates from prompts |
| **Digital Twin** | **Explicit consent verification** | User's own likeness — high trust |
| **Voice clone** | **Explicit consent verification** | User's own voice — high trust |

### 5.2 Digital Twin Rules
- User phải confirm "Tôi là chủ sở hữu hợp pháp của diện mạo này"
- Digital Twin consent riêng biệt, không gộp vào general ToS
- Clone giọng nói gắn liền với Character — consent flow chung
- Tier gating: Digital Twin chỉ Pro+ (1 character), Business (5), Enterprise (unlimited)

### 5.3 AI Remix Consent
- User phải accept disclaimer trước Phase 1:
  - Video tham chiếu không vi phạm IP
  - User chịu trách nhiệm output
  - AI chỉ học CẤU TRÚC — không copy nội dung
  - Output hoàn toàn mới bằng AI generation

---

## 6. Content Moderation Requirements

### 6.1 EU AI Act Compliance (Art. 50 — Effective Aug 2026)

| AI Feature | Risk Tier | Requirements |
|---|---|---|
| Script generation | Minimal | Transparency disclosure |
| AI video editing | Minimal | Content labeling |
| Product description AI | Minimal | Transparency disclosure |
| Trend prediction | Minimal | Source data disclosure |
| Compliance scan | Limited | Accuracy monitoring |
| Financial insights AI | Limited | "Not financial advice" disclaimer + human review flag |
| Inbox auto-reply | Limited | User notification that AI is responding |

### 6.2 AI Content Labeling
- **Visible indicator**: "AI-assisted" badge trên mọi AI output trong Creativanta UI
- **Machine-readable**: C2PA standard tagging trong exported images/videos
- **Dual-layer**: visible label cho humans + metadata cho machines
- **Exemption**: content với substantial human editorial review có thể skip visible label (human oversight must be documented)

### 6.3 Pre-Publish Compliance Scan (M10)

| Check | Platforms | Action |
|---|---|---|
| Music copyright | TikTok, YouTube, Instagram | Warn if unlicensed |
| Hashtag limit | TikTok (max 5) | Block if > limit |
| Commercial disclosure | All | Warn if #ad missing |
| Banned keywords | Shopee, TikTok | Flag + suggest alternatives |
| AI content label | TikTok, YouTube | Remind to label |
| Nudity/violence | All | AI scan + flag + block |
| Product claim | Shopee, TikTok Shop | Flag misleading claims |

Scan results: `pass` | `pass_with_warnings` | `review_required` | `blocked`

### 6.4 Acceptable Use Policy (AUP) Enforcement

| Violation Level | Action |
|---|---|
| First | Warning + content removal |
| Second | Temporary feature restriction (24-72h) |
| Third | Account suspension (7-30 days) |
| Severe (fraud, illegal) | Immediate termination |

Appeal process available trong 30 ngày.

---

## 7. Customer Support Operations

> Distilled từ S19 (Customer Support & Help v3.1)
> Full support spec: `02_features/platform/reporting_admin_billing.md`

### 7.1 Support Ticket States

```
Open → In Progress → Awaiting Response → Resolved → Closed
```

- Push notification on status change
- Satisfaction survey on ticket close (1-5 stars + optional comment)

### 7.2 SLA Rules Per Plan

| Metric | Free | Starter | Pro | Business | Enterprise |
|---|---|---|---|---|---|
| First response | 48h | 24h | 8h | 2h | 1h |
| Resolution target | 5 days | 3 days | 1 day | 8h | 4h |
| Support hours | Business | Business | Extended | 24/7 | 24/7 + dedicated |

### 7.3 Escalation Paths

| Level | Handler | Trigger | Response Time |
|---|---|---|---|
| L0 | AI Chatbot | All initial queries | Instant |
| L1 | Support agent | AI escalation / user request | Per SLA tier |
| L2 | Senior support | L1 cannot resolve / technical | 2× SLA |
| L3 | Engineering | Bug confirmed / data issue | 24h max |
| L4 | Management | SLA breach / security / legal | 1h max |

### 7.4 AI Chatbot Escalation Triggers
- User explicitly requests human agent
- AI confidence < 70%
- Issue involves billing/payment
- Issue involves data loss/security
- 3+ failed resolution attempts

### 7.5 Data Access Policies for Support Agents
- Support agents access per-workspace data only when ticket is active
- No cross-workspace data visibility
- Financial data: read-only for support, override requires L3+
- Admin override tools: reason field mandatory, audit trail automatic
- All support actions logged in audit event stream

### 7.6 Support Channels

| Channel | Availability | Tiers |
|---|---|---|
| Help Center (self-serve) | 24/7 | All |
| AI Chatbot (first-line) | 24/7 | All |
| In-app bug report | 24/7 | All |
| Email support | Business hours | All |
| Live chat (human) | Business hours | Pro+ |
| Priority phone | Business hours | Business/Enterprise |

---

## 8. Implementation Checklist

Verify trước ship — mỗi item phải pass:

- [ ] Cookie consent banner hiển thị ngay lần đầu truy cập
- [ ] Cookie consent có "Accept All", "Reject All", "Customize"
- [ ] No tracking trước consent (trừ strictly necessary)
- [ ] ToS + Privacy Policy acceptance bắt buộc trước sử dụng
- [ ] ToS change management: 30 ngày notice cho major changes
- [ ] Age verification gate (18+) active
- [ ] AI content labeling: "AI-assisted" badge visible trên mọi AI output
- [ ] C2PA metadata embedded trong exported media
- [ ] DMCA process operational (takedown 48h)
- [ ] AUP enforcement graduated penalty system active
- [ ] Pre-publish compliance scan operational (music, hashtag, disclosure, keywords)
- [ ] Financial data hiển thị source class + confidence + disclaimer
- [ ] Data export flow operational (JSON + CSV, 72h SLA)
- [ ] Account deletion flow operational (14-day grace → 30-day completion)
- [ ] Connected account disconnect revokes tokens + clears cached data within 24h
- [ ] Consent records persisted with timestamp, IP, user agent
- [ ] Legal documents accessible từ footer link (ToS, Privacy, Cookie, AUP, DMCA, AI Disclaimer)
- [ ] Digital Twin consent verification active
- [ ] AI data usage consent toggle in Settings (default OFF)
- [ ] Support ticket system operational with SLA per tier
- [ ] Diagnostics hierarchy: user-facing → operator → engineering → audit

> Cross-ref: Platform-specific compliance detail: `04_contracts/connector_specs.md`
> Cross-ref: Security threat model: `06_quality_ops/security_threat_model.md`
> Cross-ref: RBAC permissions: `04_contracts/rbac_permission_matrix.md`
