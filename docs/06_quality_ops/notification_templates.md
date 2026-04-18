---
layer: quality_ops
canonical: true
source_file: impl_d2_email_sms_push_templates.md
last_verified: 2026-03-30
---

# D2 — Email, SMS & Push Notification Templates

> **Upstream**: Pack 03, Pack 01 (Notification UX)

---

## 1. Channels

| Channel | Provider (Dev) | Provider (Prod) | Format |
|---|---|---|---|
| Email | Mailpit (local) | Resend | MJML → HTML |
| Push (Mobile) | — | FCM (Android), APNs (iOS) | JSON payload |
| In-App | — | WebSocket → Svelte 5 Runes ($state) | Notification component |
| SMS | — | Twilio (P2, not v1) | Plain text |

---

## 2. Email Templates

| Template Key | Trigger | Subject (vi) |
|---|---|---|
| `welcome` | User signup | Chào mừng bạn đến với Creativanta! |
| `workspace_invite` | Member invited | Bạn được mời tham gia {workspace} |
| `script_approval_request` | Script submitted | [{workspace}] Script "{title}" cần duyệt |
| `script_approved` | Script approved | ✅ Script "{title}" đã được duyệt |
| `publish_succeeded` | Publish success | 🎉 Đã đăng thành công lên {platform} |
| `publish_failed` | Publish failed | ⚠️ Đăng bài thất bại trên {platform} |
| `morning_brief` | Daily 6:30 AM | ☀️ Briefing hôm nay cho {workspace} |
| `credit_low` | Credits < 20% | ⚠️ Tín dụng AI sắp hết ({remaining} còn lại) |
| `credit_exhausted` | Credits = 0 | 🔴 Đã hết tín dụng AI |
| `payment_failed` | Stripe event | ⚠️ Thanh toán thất bại |
| `payment_succeeded` | Stripe event | ✅ Thanh toán thành công |
| `security_alert` | Suspicious login | 🔒 Đăng nhập bất thường phát hiện |
| `weekly_report` | Weekly cron | 📊 Báo cáo tuần #{week} |

---

## 3. Push Notification Templates

| Template | Priority | Grouping | Deep Link |
|---|---|---|---|
| `thread_urgent` | HIGH | `thread_{thread_id}` | `/inbox/{id}` |
| `approval_pending` | HIGH | `approval` | `/scripts/{id}/review` |
| `publish_result` | NORMAL | `publish` | `/publish/{id}` |
| `profit_anomaly` | HIGH | `finance` | `/profit/anomalies` |
| `achievement_unlocked` | LOW | `gamification` | `/achievements` |
| `morning_brief` | NORMAL | `brief` | `/brief` |
| `sla_breach` | HIGH | `thread_{thread_id}` | `/inbox/{id}` |
| `workflow_approval` | HIGH | `workflow` | `/workflows/{id}` |

---

## 4. In-App Notification Structure

```typescript
interface InAppNotification {
  id: string;
  priority: 'urgent' | 'high' | 'normal' | 'low';
  title: string;
  body: string;
  deepLink: string;
  actionButtons?: Array<{label: string; action: string}>;
  groupKey: string;
  readAt: string | null;
  createdAt: string;
}
```

---

## 5. Sending Rules

| Rule | Description |
|---|---|
| De-duplicate | Same event → same user → max 1 notification per 5min |
| Quiet hours | Suppress non-urgent push 22:00-7:00 (user timezone) |
| Batch | Low-priority events batch every 15min |
| Channel fallback | Push fails → In-app. Email independent channel |
| User preferences | User can disable per-channel, per-type |

---

## 6. Admin Site Email Templates (S26 — Internal Only)

| Template Key | Trigger | Recipient | Subject |
|---|---|---|---|
| `admin_moderation_alert` | Content flagged (high severity) | Content Admin | 🔴 [Moderation] Nội dung bị gắn cờ: {object_ref} |
| `admin_fraud_alert` | Fraud case detected | Content Admin | 🔴 [Fraud] Nghi ngờ gian lận: {case_id} |
| `admin_user_suspension` | User suspended | Suspended user | ⚠️ Tài khoản tạm dừng |
| `admin_impersonation_notify` | Impersonation started | Target user (optional) | 🔒 Phiên hỗ trợ đang diễn ra |
| `admin_incident_alert` | Incident detected | Tech Admin | 🔴 [Incident] {severity}: {affected_services} |
| `admin_sla_breach` | Support SLA breached | Support Admin | ⚠️ [SLA Breach] Ticket #{ticket_id} |

---

## 7. S16 Creator Pro Notifications

| Template Key | Trigger | Channel | Subject/Title |
|---|---|---|---|
| `brand_deal_deadline` | 3 days before deadline | Push + Email | ⏰ Brand deal "{title}" sắp đến hạn |
| `brand_deal_status` | Deal status changed | Push + In-App | 📋 Brand deal cập nhật: {from} → {to} |
| `media_kit_ready` | AI generation complete | In-App | ✅ Media Kit đã sẵn sàng |
| `rate_card_suggested` | AI suggestion ready | In-App | 💡 Gợi ý Rate Card mới |

---

## 8. Unhandled Edge Case Templates

| Template Key | Trigger | Channel | Subject |
|---|---|---|---|
| `account_frozen` | User freezes account | Email | 🔒 Tài khoản đã bị đóng băng |
| `workspace_freeze` | Emergency freeze | Push + Email | 🔒 Workspace đã bị đóng băng bởi Owner |
| `export_ready` | Data export completed | Email + In-App | 📦 File xuất dữ liệu đã sẵn sàng |
| `referral_reward` | Referral qualified | Push + In-App | 🎁 Bạn nhận được {credits} credits từ giới thiệu |
| `subscription_renewal` | 3 days before renewal | Email | 📅 Gói đăng ký sắp gia hạn |
| `dunning_attempt` | Payment retry scheduled | Email | ⚠️ Thanh toán sẽ được thử lại vào {date} |
