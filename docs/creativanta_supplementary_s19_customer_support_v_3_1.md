# Creativanta — Supplementary Spec S19 — Customer Support & Help v3.1

## 0. Traceability Header

- **Upstream**: PRD §29 (beginner-friendly), Product Freeze §39 (Product Identity)
- **Pack dependencies**: Pack 01 (FE UX), Pack 03 (Event/Notification), Pack 08 (Admin), S26 (Internal Admin — admin-side support console)
- **Scope**: Launch requirement — sản phẩm không thể ra mắt mà không có support strategy.

---

## 1. Mục tiêu

Xây dựng hệ thống hỗ trợ khách hàng đa tầng: AI-first (giảm chi phí) → human escalation (đảm bảo chất lượng), với SLA rõ ràng theo plan.

---

## 2. Support Channels

| Channel | Availability | Tiers |
|---|---|---|
| **Help Center** (self-serve) | 24/7 | All |
| **AI Chatbot** (first-line) | 24/7 | All |
| **In-app bug report** | 24/7 | All |
| **Email support** | Business hours (9-18 VN) | All |
| **Live chat** (human) | Business hours | Pro+ |
| **Priority phone** | Business hours | Business/Enterprise |

---

## 3. SLA Per Plan

| Metric | Free | Starter | Pro | Business | Enterprise |
|---|---|---|---|---|---|
| First response | 48h | 24h | 8h | 2h | 1h |
| Resolution target | 5 days | 3 days | 1 day | 8h | 4h |
| Support hours | Business | Business | Extended | 24/7 | 24/7 + dedicated |
| Escalation access | Email | Email + chat | Email + chat + priority | All + phone | All + TAM |
| Incident updates | Status page | + email | + SMS | + phone | + Slack/Teams |

---

## 4. Help Center

### 4.1 Structure
- Knowledge base articles organized by module (M01-M23)
- Getting started guides per operator mode (6 modes)
- Video tutorials (embedded, ≤ 3min each)
- FAQ section (top 50 questions)
- Troubleshooting guides per domain

### 4.2 Search
- Full-text search across all articles
- Vietnamese + English
- Search analytics: track unanswered queries → create new articles
- Contextual suggestions based on current screen

### 4.3 Maintenance
- Articles reviewed monthly
- Stale content flagged after 90 days without update
- Version history per article

---

## 5. AI Chatbot (First-Line Support)

### 5.1 Capabilities
- Answer questions from knowledge base (RAG-based)
- Guide users through common workflows (step-by-step)
- Collect bug report details (auto-capture screen, browser, account info)
- Escalate to human when confidence < 70% or user requests

### 5.2 Behavior
- Language: Vietnamese primary, English secondary, auto-detect
- Tone: friendly, helpful, concise
- No hallucination: only answer from verified knowledge base
- Credit cost: 0 (included in subscription, không dùng AI credits)

### 5.3 Escalation Trigger
- User says "nói chuyện với người thật" / "human agent"
- AI confidence < 70%
- Issue involves billing/payment
- Issue involves data loss/security
- 3+ failed resolution attempts

---

## 6. In-App Bug Report

### 6.1 Auto-Capture Data
- Current screen URL/route
- Browser/device info (user agent)
- User account ID + workspace ID
- Last 20 console errors (if available)
- Screenshot (optional, user-initiated)
- Network request failures (last 5 min)
- User's operator mode + plan tier

### 6.2 User Input
- Category: Bug, Feature request, Question, Other
- Description (required, ≥ 20 chars)
- Severity: Critical / High / Medium / Low
- Attachment: screenshot, screen recording (optional)

### 6.3 Flow
```
User clicks "Report" (?) → Auto-capture data → User fills form
→ Submit → Ticket created → AI auto-classify priority
→ Route to team → User gets ticket ID + estimated response time
```

---

## 7. Escalation Matrix

| Level | Handler | Trigger | Response Time |
|---|---|---|---|
| L0 | AI Chatbot | All initial queries | Instant |
| L1 | Support agent | AI escalation / user request | Per SLA tier |
| L2 | Senior support / specialist | L1 cannot resolve / technical issue | 2× SLA |
| L3 | Engineering team | Bug confirmed / data issue | 24h max |
| L4 | Management | SLA breach / security incident / legal | 1h max |

---

## 8. Changelog & Announcements

### 8.1 Changelog
- Published with each release
- Format: [date] - [version] - [category: Feature/Fix/Improvement]
- Sections: New Features, Bug Fixes, Improvements, Breaking Changes
- Accessible from: app footer link, Help Center, in-app notification

### 8.2 In-App Announcements
- New feature spotlight: modal/banner on first visit after release
- Dismissable, "Don't show again" option
- Max 1 announcement per session
- Targeting: per-tier, per-mode, per-region

### 8.3 Beta Program
- Opt-in from Settings → Beta Features
- Feature flags control access
- Beta feedback widget embedded in beta features
- Beta users get early access + bonus credits (50)
- Graduation criteria: stable for 2 weeks, >80% positive feedback

---

## 9. Public Status Page

### 9.1 Components Monitored
- Web app availability
- Mobile app backend
- API availability
- Database
- AI services (per provider)
- Platform connectors (TikTok, Shopee, etc.)
- Payment processing
- Email/SMS delivery

### 9.2 Incident Communication
- Severity levels: Operational / Degraded / Partial Outage / Major Outage
- Update frequency: every 30 min during incident
- Post-mortem published within 48h for major incidents
- Email notification to affected users

### 9.3 Maintenance Windows
- Scheduled maintenance: announced 72h in advance
- Preferred window: 2:00-5:00 AM ICT (low traffic)
- Zero-downtime deploys preferred (blue-green/canary)
- Duration estimate provided

---

## 10. FE/UX Contract

### 10.1 Support Access Points
- "?" icon (bottom-right on web, help tab on mobile)
- Settings → Help & Support
- Command Hub: "help" / "support" / "bug" keywords
- Contextual help links on error screens

### 10.2 Ticket Status UI
- My Tickets page in Settings
- Status: Open → In Progress → Awaiting Response → Resolved → Closed
- Push notification on status change
- Satisfaction survey on ticket close (1-5 stars + optional comment)

---

## 11. Acceptance Scenarios

- User gặp lỗi → click Report → auto-capture info → submit → nhận ticket ID + estimated response
- User hỏi chatbot "làm sao publish video" → chatbot hướng dẫn step-by-step → user thành công
- Chatbot không trả lời được → escalate to human → agent response within SLA
- Major outage → status page updated within 15 min → email sent → post-mortem within 48h
- New feature released → in-app announcement → user clicks "Learn more" → help article
