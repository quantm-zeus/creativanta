---
layer: business
canonical: true
source: creativanta_prd_v_3_1_revised_part_2.md (§24–§30), creativanta_prd_v_3_1_revised_part_1.md (§28)
last_updated: 2026-03-30
---

# Business Rules

> File này chứa các invariants không thể vi phạm. Mọi implementation PHẢI tuân thủ.

---

## 1. Cross-Module Contract Rules (INVARIANTS)

Các contract sau là **bất khả vi phạm** — vi phạm bất kỳ rule nào dưới đây là lỗi nghiêm trọng cấp product.

---

**RULE-001: Trend/Signal → Opportunity/Idea**
- Rule: "Trend/Signal phải đi tiếp được sang Opportunity hoặc Idea."
- If violated: Signal trở thành dead-end data — user không chuyển được intelligence thành action.

**RULE-002: Opportunity → Downstream Objects**
- Rule: "Opportunity phải đi tiếp được sang Idea, Script, Campaign hoặc Live Plan."
- If violated: Opportunity Board thành dashboard trưng bày, không tạo business value.

**RULE-003: Script → Asset Brief + Publish**
- Rule: "Script phải đi tiếp được sang Asset Brief và Publish."
- If violated: Script lơ lửng giữa pipeline — creation và distribution bị đứt.

**RULE-004: Asset → Packaging + Publish**
- Rule: "Asset phải đi tiếp được sang Packaging và Publish."
- If violated: Asset production không nối được output — content tạo xong không publish được.

**RULE-005: Publish → Logs + Engagement/Commerce/Proof**
- Rule: "Publish phải để lại logs và quay về Engagement / Commerce / Proof."
- If violated: Post-publish performance, engagement, revenue attribution bị mất — closed loop bị phá.

**RULE-006: Thread → Actionable Outcomes**
- Rule: "Thread phải đi tiếp được sang reply, task, idea, offer, seeding hoặc campaign action."
- If violated: Inbox thành read-only view — engagement intent không chuyển thành business action.

**RULE-007: Offer/Campaign → Financial Objects**
- Rule: "Offer/Campaign phải nối về Order / Settlement / Cost / Profit."
- If violated: Commerce operations tách rời khỏi financial truth — profit/loss không thể track.

**RULE-008: Proof/Profit → Evidence Drilldown**
- Rule: "Proof/Profit phải mở ngược ra Evidence và source context."
- If violated: Profit claims trở thành assertion không verify được — đánh mất trust layer.

**RULE-009: Workflow/Agent → Canonical Objects Only**
- Rule: "Workflow/Agent phải dùng canonical objects, không tạo parallel state ngoài graph."
- If violated: Automation tạo shadow data — One Graph bị phá, auditability mất.

---

## 2. State Machine Requirements

15 objects sau **bắt buộc** phải có standardized state machines trong downstream specs:

| # | Object Name | Feature Doc Path | Status |
|---|---|---|---|
| 1 | Opportunity | `02_features/intelligence/opportunity_board.md` | NEEDS SPEC |
| 2 | Script | `02_features/creation/script_lab.md` | NEEDS SPEC |
| 3 | Asset | `02_features/production/ai_video_studio.md` | NEEDS SPEC |
| 4 | Publish Job | `02_features/publish/publish_hub.md` | NEEDS SPEC |
| 5 | Publish Item | `02_features/publish/publish_hub.md` | NEEDS SPEC |
| 6 | Thread | `02_features/engagement/unified_inbox.md` | NEEDS SPEC |
| 7 | Offer | `02_features/commerce/monetization_os.md` | NEEDS SPEC |
| 8 | Order | `02_features/commerce/product_hub.md` | NEEDS SPEC |
| 9 | Refund | `02_features/commerce/product_hub.md` | NEEDS SPEC |
| 10 | Reconciliation Record | `02_features/finance/operating_ledger.md` | NEEDS SPEC |
| 11 | Workflow Run | `02_features/automation/workflow_studio.md` | NEEDS SPEC |
| 12 | Agent Run | `02_features/automation/workflow_studio.md` | NEEDS SPEC |
| 13 | Sample Request | `02_features/commerce/seeding_crm.md` | NEEDS SPEC |
| 14 | Sample Shipment | `02_features/commerce/seeding_crm.md` | NEEDS SPEC |
| 15 | Live Session | `02_features/commerce/live_war_room.md` | NEEDS SPEC |

> PRD khóa rule này ở cấp sản phẩm; state transition table chi tiết nằm ở Feature Docs và Detail Design.

---

## 3. Feature Gating Rules

Source: PRD §30.4

### 3.1 Gate Priority (QUAN TRỌNG NHẤT)
- **Tier gates** checked **TRƯỚC** role/permission gates
- If tier blocks feature → role doesn't matter
- If tier allows feature → role determines access level

### 3.2 Over-Limit Behavior
- When user hits limit → hiển thị **inline upsell card**, **KHÔNG force redirect** ra landing page
- Free users thấy được Pro features (preview mode) nhưng không thể dùng
- Over-limit warning hiển thị khi đạt **80% quota**
- No dark patterns: upgrade flow phải clear, reversible, có cancel anytime

### 3.3 Block Types Per Tier
| Tier | Credit Exhaustion Behavior |
|---|---|
| **Free** | Hard block — không cho phép overage |
| **Starter** | Hard block — có thể mua credit packs bổ sung |
| **Pro** | Soft warning at 90% → hard block at 100% — có thể mua credit packs hoặc auto-buy |
| **Business** | Soft warning at 80% → email at 100% → allow 10% overage buffer → hard block at 110% |
| **Enterprise** | Custom budget alerts, no hard block, invoiced monthly |

### 3.4 Operator Mode & Tier
- Operator mode availability follows tier allocation
- **Không tạo separate pricing per mode** — mode phụ thuộc tier, không phải ngược lại

---

## 4. Money/Proof Integrity Rules

Source: PRD §28.5

Các rule bất khả vi phạm cho integrity tài chính:

| Rule | Mô tả |
|---|---|
| **No UI-side money logic** | UI không được tự tính money logic khác finance/proof layer — mọi số tiền phải từ backend canonical |
| **Override audit trail** | Manual override phải có reason và audit trail — không override im lặng |
| **Side-effect logging** | Business-critical agent/workflow actions phải lưu side effects đầy đủ |
| **Source class mandatory** | Mọi money-related object phải có source class (Official / Imported / Inferred / Estimated / Unreconciled) |
| **Evidence mandatory** | Mọi money-related object phải có evidence, proof bundle hoặc confidence reason |
| **No mixing truth levels** | Estimated hoặc Unreconciled values không được hiển thị như finalized truth — phải gắn nhãn rõ |
| **Unreconciled separation** | Unreconciled bucket riêng phải hiện rõ, không trộn vào clean data |

---

## 5. Reporting & Explainability Rules

Source: PRD §26

Mọi surface quan trọng phải trả lời được **5 câu hỏi** sau. Nếu thiếu bất kỳ câu nào, surface chưa đạt yêu cầu:

1. **Điều gì đang xảy ra?** — thông tin chính, metric, trạng thái
2. **Vì sao hệ thống nói vậy?** — reasoning, model, logic đằng sau
3. **Dữ liệu đến từ đâu?** — source class, provider, freshness
4. **Chỗ nào còn thiếu hoặc chưa chắc?** — gaps, confidence warnings, unresolved items
5. **Việc tiếp theo nên làm là gì?** — suggested actions, next steps, CTA

> Giải thích phải ưu tiên **plain language trước**, technical detail sau.

---

## 6. Admin/Support Override Rules

Source: PRD §29

### Diagnostics Hierarchy (4 Levels)
Sản phẩm phải support diagnostics từ non-tech user → engineering:

| Level | Name | Audience | Mô tả |
|---|---|---|---|
| L1 | **User-facing explanation** | End user | Plain-language explanation: "Tính năng X không hoạt động vì platform Y đang bảo trì" |
| L2 | **Operator diagnostics** | Workspace admin/manager | Capability status, connector health, state details, repair suggestions |
| L3 | **Engineering trace log** | Dev/support engineer | API logs, error traces, request IDs, latency metrics |
| L4 | **Audit event stream** | Compliance/security | Immutable audit trail, state changes, who-did-what |

### Support-Friendly Design Principles
- Standardized state machines → consistent vocabulary across all objects
- Self-serve diagnostics → user can investigate before filing ticket
- Repair wizards → guided fix flows for common issues (connector broken, data stale, etc.)
- Explanation-first UX → errors explain "why" before "what to do"
- Admin override tools → có kiểm soát, có audit trail, có reason field

---

## 7. Beginner UX Rules

Source: PRD §27

Để người non-tech dùng được, sản phẩm **PHẢI**:

| Rule | Mô tả |
|---|---|
| **No "learn module" prerequisite** | Không bắt user "học module" trước khi làm việc |
| **Task/loop-first navigation** | Ưu tiên flow theo task/loop hơn taxonomy nội bộ |
| **Concrete CTA** | Dùng CTA cụ thể ("Tạo video bán hàng") thay vì abstract score-only views |
| **4 state types mandatory** | Có empty states, partial setup states, broken states và repair states rõ ràng |
| **Trust in plain language** | Giải thích trust/capability bằng ngôn ngữ dễ hiểu, không jargon |
| **Recipe-first entry** | Cho phép user bắt đầu bằng recipe, object hoặc suggested action — không ép vào command-heavy UX |

> Cross-ref: UX detail specs → `03_screens/` (chỉ đọc SAU khi đã đọc feature docs)
