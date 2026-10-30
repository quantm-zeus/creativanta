---
layer: features
module: copilot
canonical: true
domain: platform
status: SPECIFIED
created: 2026-04-02
upstream: PRD v3.1 §34, Pack 08 §7.7, Pricing §11
---

# Copilot — AI Operations Assistant

> **Upstream**: PRD §34, Pack 08 §7.7
> **API**: `CopilotService` — see `04_contracts/api_endpoint_map.md §2.8`
> **DB tables**: `copilot_sessions` (§19.12 — messages stored as JSONB column within sessions)

---

## 1. Purpose

Copilot is a **cross-cutting AI assistant** embedded throughout Creativanta that answers operational questions in natural language, executes multi-step actions, and surfaces contextual insights. It reduces the learning curve for beginners and serves as a power shortcut for advanced users — eliminating the need to navigate deep menus for common operations.

Copilot is NOT a general chatbot. It is scoped to the user's workspace data, connected platform metrics, and Creativanta actions.

## 2. Scope

### Covers
- Natural language query interface (text + optional voice input)
- Workspace-scoped data retrieval (analytics, orders, profits, trends)
- Multi-step action execution (create script, generate video, schedule post)
- Contextual awareness (current screen, active operator mode, recent actions)
- Credit-aware operation (queries = 0 credits; generative actions = standard credit cost)
- Daily query limits per tier
- Conversational context within session (multi-turn)

### Does NOT cover
- General knowledge queries unrelated to workspace (redirect to external search)
- Direct platform actions (posting to TikTok — that's M11 Publish Hub)
- Financial advice or legal guidance (explicit disclaimer)
- Training on user data (privacy boundary)

## 3. Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Any workspace member | Member+ | Ask questions, trigger actions, view suggestions |
| System (NLU) | System | Intent detection, entity extraction, action routing |
| System (LLM) | System | Generate responses, assemble multi-step plans |

## 4. Business Rules

| Rule | Description |
|------|-------------|
| RULE-COP-001 | Query-only operations (analytics lookups, status checks) consume 0 credits |
| RULE-COP-002 | Generative actions (create script, generate video) consume standard credit costs — cost preview shown before execution |
| RULE-COP-003 | Daily query limits: Free=20, Starter=100, Pro/Business=unlimited |
| RULE-COP-004 | Copilot operates within workspace RBAC — it cannot access data or perform actions beyond the user's permission level |
| RULE-COP-005 | Multi-step actions require explicit user confirmation at each step that consumes credits or has side-effects |
| RULE-COP-006 | Copilot must show data sources and confidence for any metrics it reports |
| RULE-COP-007 | Voice input (speech-to-text) available on mobile — transcribed before processing |
| RULE-COP-008 | Copilot MUST NOT hallucinate metrics — if data unavailable, respond: "Tôi không có dữ liệu này. Hãy kết nối [platform] để xem." |

## 5. Key Flows

### 5.1 Query Flow (0 credits)
1. User opens Copilot (via Home entry point, keyboard shortcut, or floating button)
2. User types/speaks question: e.g., "Bán gì chạy nhất tuần này?"
3. NLU detects intent: `analytics.top_products` + timeframe: `this_week`
4. System queries workspace analytics data
5. Response rendered with chart/table + source badges + "Why this data" explanation
6. Credits: 0

### 5.2 Action Flow (credits consumed)
1. User requests: "Tạo script bán hàng cho sản phẩm A"
2. NLU detects intent: `creation.generate_script` + entity: `product_A`
3. System shows credit cost preview: "Tạo script sẽ dùng 5 credits. [Xác nhận] [Hủy]"
4. User confirms → LLM generates script using product data + Brand Pack + trend context
5. Script created as draft in M06 Script Lab
6. Response: "Script đã tạo xong. [Xem script] [Chỉnh sửa] [Tạo video từ script]"

### 5.3 Multi-Step Workflow
1. User: "Tạo video quảng cáo cho sản phẩm mới"
2. Copilot proposes plan:
   - Step 1: Pull product info from M13 (0 credits)
   - Step 2: Generate script (5 credits)
   - Step 3: Generate video (20 credits)
   - Step 4: Create thumbnail (5 credits)
   - **Total estimated: 30 credits**
3. User approves → Copilot orchestrates steps sequentially
4. Each step shows progress, intermediate outputs reviewable
5. User can modify/cancel at any checkpoint

### 5.4 Contextual Entry Points

| Entry Point | Context Injected | Example |
|---|---|---|
| Home | Current operator mode, top actions | "What should I focus on today?" |
| M07 AI Video Studio | Current project, active mode | "Make this clip shorter" |
| M13 Product Hub | Selected product, stock/sales data | "How is product A performing?" |
| M19 Operating Ledger | Financial period, profit data | "Why did margin drop this week?" |
| M11 Publish Hub | Scheduled/published items | "When is the best time to post?" |

## 6. Conversation Model

### Session Management
- Sessions are workspace-scoped and user-scoped
- Session expires after 30 minutes of inactivity
- Multi-turn context: Copilot remembers conversation within session
- Session history viewable (last 30 days)
- Sessions are NOT shared between users (privacy)

### Intent Categories

| Category | Examples | Credits |
|---|---|---|
| **Analytics** | "Revenue today?", "Best product?", "Engagement rate?" | 0 |
| **Status** | "Any broken connectors?", "Pending orders?" | 0 |
| **Navigation** | "Open script lab", "Show profit dashboard" | 0 |
| **Creation** | "Write a script for...", "Generate a video..." | Standard |
| **Optimization** | "Improve this caption", "A/B test this hook" | Standard |
| **Scheduling** | "Schedule this for TikTok at 7pm" | 0 (action) |
| **Learning** | "How do I use Clip Factory?", "What is RPM?" | 0 |

### Guardrails
- Refuse requests outside workspace scope
- Refuse harmful/illegal content generation
- Refuse impersonation or misleading content
- Log all action executions for audit trail
- Rate limit: max 5 concurrent generative actions per workspace

## 7. Fallback Behavior

| Condition | Response |
|---|---|
| Intent not recognized | "Tôi không hiểu câu hỏi. Bạn có thể nói rõ hơn hoặc thử: [suggested queries]" |
| Data unavailable | "Dữ liệu chưa có. Hãy kết nối [platform] để bắt đầu tracking." |
| Credit limit reached | "Bạn đã dùng hết [N]/[limit] câu hỏi hôm nay. [Nâng cấp] để unlock unlimited." |
| Permission denied | "Bạn không có quyền thực hiện hành động này. Liên hệ Owner workspace." |
| System error | "Có lỗi xảy ra. [Thử lại] hoặc [Gửi báo cáo lỗi]" |

## 8. State Machine — Copilot Action

| From | To | Trigger | Condition |
|------|----|---------|-----------| 
| — | planning | User requests action | Intent classified as generative/action |
| planning | awaiting_confirmation | Plan generated | Credit cost estimated, steps listed |
| awaiting_confirmation | executing | User confirms | Credits reserved |
| awaiting_confirmation | cancelled | User cancels | No credits consumed |
| executing | completed | All steps succeed | Credits confirmed, results available |
| executing | partial_failure | Some steps fail | Completed steps preserved, failed steps retryable |
| executing | failed | Critical failure | Credits released, user notified |

## 9. API Surface

> See `04_contracts/api_endpoint_map.md §2.8`

| Service | Key RPCs |
|---------|----------|
| `CopilotService` | SendMessage, GetSession, ListSessions, GetSuggestions, ExecuteAction |

## 10. Acceptance Criteria

```gherkin
Feature: Copilot Queries
  Scenario: Analytics query (0 credits)
    Given a workspace with connected TikTok and sales data
    When user asks "Bán gì chạy nhất?"
    Then Copilot queries analytics data
    And shows top products with revenue chart
    And 0 credits are consumed

  Scenario: Generative action (credits consumed)
    Given a user asks "Tạo script cho sản phẩm A"
    When Copilot classifies intent as creation
    Then credit cost preview is shown: "5 credits. [Xác nhận] [Hủy]"
    When user confirms
    Then script is generated and saved as draft
    And 5 credits are deducted

  Scenario: Daily limit reached (Free tier)
    Given a Free user has made 20 queries today
    When they send query #21
    Then Copilot responds: "Bạn đã dùng hết 20/20 câu hỏi hôm nay."
    And upgrade CTA is shown

  Scenario: RBAC enforcement
    Given a Contributor asks "Delete product A"
    When Copilot checks permissions
    Then response: "Bạn không có quyền xóa sản phẩm. Cần Editor+ role."
    And no deletion occurs
```

## 11. Edge Cases

### EC-COP-001: Ambiguous Intent
- Condition: "Show me the numbers" — unclear which numbers
- Expected: Copilot asks clarifying question: "Bạn muốn xem: [Revenue] [Orders] [Engagement] [Credits]?"

### EC-COP-002: Cross-Module Action Chain
- Condition: User asks "Create a TikTok ad for product A" — spans M06+M07+M10+M11
- Expected: Copilot creates multi-step plan with cost estimate per step. User reviews and confirms the full plan before execution begins.

### EC-COP-003: Offline Platform Data
- Condition: User asks about TikTok metrics but TikTok connector is disconnected
- Expected: "TikTok không kết nối. [Kết nối lại] để xem dữ liệu. Dữ liệu cũ nhất có sẵn từ [date]."

## 12. Cross-references

- **Home**: `02_features/platform/home_decision_engine.md` (Copilot entry point)
- **API**: `04_contracts/api_endpoint_map.md §2.8` (CopilotService)
- **Events**: `04_contracts/domain_event_catalog.md` (copilot.session_started, copilot.session_ended)
- **Credits**: `01_business/pricing_and_credits.md` (query limits per tier)
- **RBAC**: `04_contracts/rbac_permission_matrix.md` (Copilot inherits user RBAC)
- **M06**: `02_features/content/script_lab.md` (script generation target)
- **M07**: `02_features/production/ai_video_studio.md` (video generation target)
