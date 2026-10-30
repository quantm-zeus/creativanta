# Screen: Deal Contract Templates and Evidence

> **Screen ID**: W135
> **Module**: S16 — Creator Pro Tools
> **Route**: `/creator-pro/deals/:deal_id/contracts`
> **Platform**: Web; same actions in Mobile Brand Deal detail
> **Phase**: P8-07

## Feature and contract ownership

Read [Creator Pro §12](../../02_features/commerce/creator_pro_tools.md#12-retained-expansion--brand-collaboration-workspace) and [API behavior §8](../../04_contracts/api_behavior_contracts.md#8-reviewed-operator-projections-and-commands). Brand deal and evidence remain canonical objects.

## Layout and flow

Entry from a deal's “Tài liệu” tab. A version timeline lists title, source template/version, uploader, timestamp and evidence integrity. Primary actions: choose template, upload reviewed document, attach external signature proof. Selecting a template opens an editable draft preview with a clear drafting-aid notice, deal context and save/cancel. Preview/editing is local until the user submits a new immutable document version.

Submit through the evidence upload path, then attach the returned evidence ID to the deal. Never overwrite an older document. Mobile uses a full-height editor/upload sheet and the same version list. Leave-unsaved confirmation protects the local draft; retry uses the same upload/command identity.

## Actions, permissions and states

List templates: BrandDealService/ListContractTemplates with brand_deal:read. Attach: EvidenceService/Submit plus BrandDealService/AttachContract, requiring their named permissions and same-tenant evidence access. Deal status/finance changes use their separate existing commands, not document upload.

Show loading, no-documents, no-published-templates, upload-failed, scan-pending, permission-denied, foreign/missing document and conflict states. Each has retry, safe cancel or authorized repair. A quarantined upload cannot be attached. If the user lacks write permissions, preserve authorized read access with an explanation.

## UI acceptance

Given an old signed version, editing a draft creates a distinct evidence version and preserves the original hash. Given a foreign evidence ID, attach returns not-found without disclosure. Given a template update, previously attached documents remain unchanged. Keyboard/mobile users can preview, cancel and attach without drag-only interaction. No screen copy claims automated legal approval or completion of signature merely because a file was uploaded.
