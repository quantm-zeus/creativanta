---
layer: quality_ops
canonical: true
source_file: impl_d5_i18n_guide.md
last_verified: 2026-03-30
last_updated: 2026-10-30
---

# D5 — Internationalization (i18n) Guide

> **Upstream**: Tech Stack ADR v4 (Paraglide.js)
> **Primary**: Vietnamese | **Secondary**: English

---

## 1. Tech Stack
- **Web**: Paraglide.js (Inlang) — compiled i18n, tree-shakeable, type-safe
- **Mobile**: Flutter `intl` + `flutter_localizations`
- **Backend**: Error messages in locale-aware format

## 2. Translation File Structure

### Web (Paraglide.js)
```
apps/web/messages/
├── vi.json    # Vietnamese (primary, complete)
├── en.json    # English (secondary)
```

### Mobile (Flutter ARB)
```
apps/mobile/lib/l10n/
├── app_vi.arb   # Vietnamese
├── app_en.arb   # English
```

## 3. Key Convention
```
{module}_{screen}_{element}_{variant}
```
Examples:
- `home_dashboard_title` → "Tổng quan hôm nay"
- `publish_queue_empty_state` → "Chưa có bài nào trong hàng chờ"
- `profit_anomaly_alert` → "Biên lợi nhuận giảm {percent}%"

## 4. Rules
1. **Vietnamese first**: All UI text written in Vietnamese, English added after
2. **No hardcoded strings**: All user-facing text through i18n system
3. **Code/API in English**: Variable names, API fields, logs always English
4. **Pluralization**: Vietnamese doesn't pluralize, but English messages need ICU plural syntax
5. **Number/Date formats**: Region-aware via `regions` table settings
   - VN: `1.234.567đ`, `26/03/2026`
   - EN: `$1,234,567`, `03/26/2026`
6. **Currency**: Always display with currency symbol, VND no decimals

## 5. Copilot Language
- Auto-detect user's locale from workspace settings
- Vietnamese primary, English secondary
- AI responses in user's language
- Code snippets / technical terms remain English
