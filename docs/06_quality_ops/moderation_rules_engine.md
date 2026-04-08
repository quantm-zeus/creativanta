---
layer: quality_ops
canonical: true
source_file: impl_d4_moderation_rules_engine.md
last_verified: 2026-04-07
---

# D4 — Content Moderation Rules Engine

> **Upstream**: Pack 04 §9, Pack 07 (Legal), EU AI Act

---

## 1. Moderation Pipeline

> **CANONICAL DECISION (2026-04-07)**: moderation decisions use a normalized `0-100` risk score after provider/category mapping. This file is now the source-of-truth for launch-default allow/review/block thresholds. Screen-level examples must follow this policy, not invent draft values.

```
Content Submit → Pre-screen (automated) → Score → Decision
                      ↓
             ┌─ Pass (score < threshold) → Allow
             ├─ Review Required (borderline) → Human queue
             └─ Block (score > threshold) → Reject + explain
```

### 1.1 Default Decision Bands

| Normalized Risk Score | Default Decision | Notes |
|---|---|---|
| `0-24` | **Allow** | No provider block signal, no strict-category override, no hard-match rule |
| `25-59` | **Human review required** | Borderline, mixed-provider, or policy-sensitive content |
| `60-100` | **Block** | High-risk content or any strict-category block threshold reached |

Scoring rules:
- The system normalizes provider outputs into a single `0-100` risk score per object and category.
- Provider disagreement escalates to the higher band, never the lower one.
- Hard-block categories can skip the default bands and block immediately.
- Thresholds are launch defaults. Trust & Safety may tune them in runtime config, but any policy change must be audit-logged with reason, actor, and effective date.

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

### 2.1 Category Overrides

| Category | Review Threshold | Block Threshold | Launch Default Action |
|---|---|---|---|
| **Sexual / nudity (adult)** | `45` | `60` | Hide from publish path; human review if borderline |
| **Sexual / minors** | `1` | `1` | Immediate block + admin alert |
| **Harassment / hate** | `35` | `60` | Review targeted abuse early; block on high-confidence threat/hate |
| **Violence / graphic violence** | `40` | `60` | Review violent depictions early; block graphic or credible-threat cases |
| **Self-harm / suicide** | `30` | `50` | Escalate faster than default; instruction/intent content blocks |
| **Illicit / violent wrongdoing / scam / phishing** | `30` | `50` | Review early; block exploitative or fraud-enabling content |
| **Doxxing / privacy exposure** | `25` | `50` | Hide and escalate quickly because personal-data exposure is high-risk |
| **Profanity only (no hate/targeted abuse)** | `50` | `80` | Default to review, not auto-block, for mild profanity |
| **Copyright audio / IP claims** | `40` | `100` | Review on match; block only after confirmed match/notice or repeated confirmed violation |

Hard-block rules:
- `sexual/minors`, explicit child exploitation, and explicit non-consensual intimate imagery are blocked immediately.
- Credible violent threats, terrorist/extremist praise, and self-harm instructions are blocked immediately even before human review.
- Doxxing with exposed personal data, credential theft, or payment-fraud instructions are blocked immediately when the relevant rule matches with high confidence.

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
| Critical (illegal content / hard-block category) | Immediate auto-block + human confirmation within **4h** | System + ContentMod / SuperAdmin |
| High (copyright, harassment, self-harm, fraud) | **< 24h** review | Admin queue |
| Medium (policy borderline) | **< 72h** review | Team queue |
| Low (profanity, minor policy cleanup) | Batch review within 7 days | Workspace owner or admin queue |
