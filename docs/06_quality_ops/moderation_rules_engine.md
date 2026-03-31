---
layer: quality_ops
canonical: true
source_file: impl_d4_moderation_rules_engine.md
last_verified: 2026-03-30
---

# D4 — Content Moderation Rules Engine

> **Upstream**: Pack 04 §9, Pack 07 (Legal), EU AI Act

---

## 1. Moderation Pipeline

```
Content Submit → Pre-screen (automated) → Score → Decision
                      ↓
             ┌─ Pass (score < threshold) → Allow
             ├─ Review Required (borderline) → Human queue
             └─ Block (score > threshold) → Reject + explain
```

---

## 2. Automated Checks

| Check | Provider | Applies To | Action |
|---|---|---|---|
| **Harmful content** | OpenAI Moderation API | All text | Block if flagged |
| **Safety filter** | Gemini Safety Settings | AI-generated content | Block/warn per category |
| **Copyright audio** | ACRCloud (P2) | Video/audio assets | Flag if detected |
| **Platform policy** | Custom rules | Publish items | Warn if violates platform TOS |
| **Profanity filter** | Custom dictionary | Captions, replies | Flag for review |
| **AI disclosure** | System | AI-generated content | Auto-add disclosure |

---

## 3. Moderation States

```
visible → flagged → hidden → deleted
              ↓
          reviewed → visible (cleared)
                   → hidden (confirmed violation)
```

---

## 4. Platform-Specific Rules

| Platform | Key Rules |
|---|---|
| TikTok | No medical claims, no copyrighted music, disclose partnerships |
| YouTube | Community Guidelines, copyright claims, age-restrict mature |
| Instagram | No manipulated media without label, shopping rules |
| Facebook | No misleading content, ad transparency |

---

## 5. EU AI Act Compliance

| Requirement | Implementation |
|---|---|
| AI content labeling | Metadata `ai_generated: true` on all AI outputs |
| C2PA provenance | Inject manifest on generated video/images |
| Transparency | User sees "AI generated" badge on content |
| Consent | AI clone requires explicit consent record |
| Right to object | User can request no-AI processing |

---

## 6. Escalation Matrix

| Severity | Response Time | Handler |
|---|---|---|
| Critical (illegal content) | Immediate block | System + Admin alert |
| High (copyright, harassment) | < 1h review | Admin queue |
| Medium (policy borderline) | < 24h review | Team queue |
| Low (profanity, minor) | Batch review | Workspace owner |
