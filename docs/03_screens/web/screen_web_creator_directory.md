# Screen: Public Creator Directory

> **Screen ID**: W134
> **Module**: S16 — Creator Pro Tools
> **Route**: `/creators`, `/creators/:media_kit_id`
> **Platform**: Responsive Web; mobile browser and Flutter deep-link entry
> **Phase**: P8-07

## Feature and contract ownership

Read [Creator Pro §12](../../02_features/commerce/creator_pro_tools.md#12-retained-expansion--brand-collaboration-workspace), then [API behavior §8](../../04_contracts/api_behavior_contracts.md#8-reviewed-operator-projections-and-commands) and schema §27.2. The directory exposes only explicitly consented published snapshots.

## Layout and navigation

Entry from the public site or shared creator profile. Search text, category and language controls above a paginated card grid; mobile uses one column and a filter sheet. Cards show approved display name, bio excerpt, categories and profile link. Detail shows permitted portfolio URLs and explicitly public rates, followed by “Gửi đề nghị hợp tác”. No workspace email, raw analytics or private kit sections.

Inquiry opens a short form with verified sender email, message and anti-abuse challenge. Show delivery receipt without exposing internal thread ID; submitting an inquiry never promises the creator has accepted. Back returns to preserved search filters. On small screens, the same form is usable without a desktop-only step.

## Actions and states

| Action/state | Binding / behavior |
|---|---|
| Search / next page | CreatorDirectoryService/Search; public projection and opaque cursor |
| View profile | CreatorDirectoryService/Get; recheck visibility |
| Submit inquiry | SponsorInquiryService/Submit; validated sender, rate limit and replay-safe receipt |
| Empty search | Explain filters; clear filters CTA, no fabricated profiles |
| Profile withdrawn/hidden | Generic unavailable; no cached biography or private reason |
| Loading / error | Skeleton then retry; never substitute a stale opted-out profile |
| Throttled inquiry | Accessible error and retry time; keep unsent message locally for the session |

## UI acceptance

Keyboard and screen reader can operate filters, cards and form; labels/errors are localized vi/en. Given opt-out while detail is open, the next read/submit fails closed and clears visible cached profile content. Given duplicate submit, one moderated thread exists. Given a public user, inspecting the response cannot reveal workspace, email, private analytics, evidence or deal objects. See P8-07 for actual privacy/RLS evidence.
