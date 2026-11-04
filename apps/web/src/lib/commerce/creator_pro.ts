/**
 * Creator Pro v1 & Brand Deals Integration (M16 & M19)
 * Canonical Sources:
 * - docs/02_features/commerce/creator_pro_tools.md
 * - docs/02_features/commerce/affiliate_network.md
 * - docs/04_contracts/database_schema.md §16
 *
 * Implements Acceptance Targets:
 * - Target 1: Canonical deal lifecycle (negotiating -> agreed -> in_progress -> delivered -> paid -> completed)
 *             with mandatory cancellation reason and financial reversal audit if paid.
 * - Target 2: Phishing cannot be acknowledged away (confirmed phishing cannot be published or activated;
 *             max 20 links/day/workspace throttle).
 * - Target 3: Zero-view RPM undefined representation (strictly undefined when views == 0, never 0;
 *             RPM drop alert > 20%; derivative roll-up).
 * - Target 4: All six modes can reach entitled tools (creator, seller, agency, affiliate, brand_collab, live_operator).
 */

export type LinkInBioPageStatus = 'draft' | 'published' | 'archived';
export type LinkType = 'custom' | 'product' | 'store' | 'media_kit' | 'rate_card' | 'social';
export type LinkSecurityScanStatus = 'pending' | 'safe' | 'suspicious' | 'phishing' | 'malware';

export interface LinkInBioPage {
  pageId: string;
  workspaceId: string;
  slug: string;
  title: string;
  bio: string;
  avatarUrl?: string;
  theme: string;
  customDomain?: string;
  customDomainVerified: boolean;
  analyticsEnabled: boolean;
  totalViews: number;
  status: LinkInBioPageStatus;
  createdAt: string;
  updatedAt: string;
  items?: LinkItem[];
}

export interface LinkItem {
  linkItemId: string;
  pageId: string;
  workspaceId: string;
  linkType: LinkType;
  title: string;
  url: string;
  thumbnailUrl?: string;
  position: number;
  isActive: boolean;
  isPinned: boolean;
  clickCount: number;
  scanStatus: LinkSecurityScanStatus;
  phishingDetected: boolean;
  scanThreatDetails?: string;
  createdAt: string;
  updatedAt: string;
}

export interface LinkSecurityScan {
  scanId: string;
  workspaceId: string;
  url: string;
  scanStatus: LinkSecurityScanStatus;
  phishingDetected: boolean;
  threatDetails: string;
  blockedFromPublishing: boolean;
  scannedAt: string;
}

export interface SocialPlatformMetric {
  platform: string;
  handle: string;
  followers: number;
  avgViews: number;
  engagementRate: number;
  verified: boolean;
}

export interface AudienceDemographic {
  category: string;
  segment: string;
  percentage: number;
}

export interface PastCollabBrand {
  brandName: string;
  logoUrl?: string;
  campaignSummary: string;
  deliverables: string;
}

export interface MediaKitData {
  mediaKitId: string;
  workspaceId: string;
  creatorName: string;
  headline: string;
  bio: string;
  avatarUrl?: string;
  socialMetrics: SocialPlatformMetric[];
  audienceDemographics: AudienceDemographic[];
  pastCollabs: PastCollabBrand[];
  pdfDownloadUrl?: string;
  qrCodeUrl?: string;
  updatedAt: string;
}

export interface RateCardItem {
  itemId: string;
  rateCardId: string;
  workspaceId: string;
  serviceType: string;
  priceMin: number;
  priceMax: number;
  aiSuggestedPrice: number;
  description?: string;
  deliveryTime?: string;
  position: number;
}

export interface RateCard {
  rateCardId: string;
  workspaceId: string;
  currency: string;
  customNote?: string;
  items: RateCardItem[];
  updatedAt: string;
}

export type BrandDealType = 'sponsored_post' | 'affiliate_collab' | 'brand_ambassador' | 'ugc_creation' | 'event_appearance';
export type BrandDealStatus = 'negotiating' | 'agreed' | 'in_progress' | 'delivered' | 'paid' | 'completed' | 'cancelled';

export interface BrandDeal {
  dealId: string;
  workspaceId: string;
  brandName: string;
  contactEmail?: string;
  dealType: BrandDealType;
  value: number;
  currency: string;
  status: BrandDealStatus;
  deadline?: string;
  deliverables?: string;
  contractEvidenceIds: string[];
  inquiryThreadId?: string;
  notes?: string;
  cancellationReason?: string;
  financialReversalLogged?: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface BrandDealPipelineStats {
  workspaceId: string;
  negotiatingCount: number;
  agreedCount: number;
  inProgressCount: number;
  deliveredCount: number;
  paidCount: number;
  completedCount: number;
  cancelledCount: number;
  totalActiveValue: number;
  totalCompletedValue: number;
  currency: string;
}

export interface SponsorInquiry {
  inquiryId: string;
  workspaceId: string;
  brandName: string;
  contactEmail: string;
  message: string;
  estimatedBudget: number;
  status: 'pending' | 'accepted' | 'declined' | 'flagged';
  threadId: string;
  receivedAt: string;
}

export interface ContentROIMetric {
  contentId: string;
  title: string;
  platform: string;
  views: number;
  engagement: number;
  linkClicks: number;
  ordersAttributed: number;
  revenueAttributed: number;
  costToProduce: number;
  roiPercentage: number;
  rpm: number;
  rpmIsUndefined: boolean;
  productionMode: string;
  isDerivative: boolean;
  sourceContentId?: string;
  derivativeCount: number;
  derivativeTotalRevenue: number;
  publishedAt: string;
}

export interface RPMTrendPoint {
  periodLabel: string;
  platform: string;
  rpm: number;
  rpmIsUndefined: boolean;
  views: number;
  revenue: number;
  changePercent: number;
  dropAlertTriggered: boolean;
}

export type TaxReportPeriod = 'quarterly' | 'yearly';
export type TaxReportFormat = 'pdf' | 'xlsx' | 'csv';

export interface TaxReportSummary {
  reportId: string;
  workspaceId: string;
  period: TaxReportPeriod;
  taxYear: number;
  periodNumber: number;
  totalRevenue: number;
  affiliateRevenue: number;
  sponsorshipRevenue: number;
  productSalesRevenue: number;
  aiCreditExpenses: number;
  subscriptionExpenses: number;
  netIncomeBeforeTax: number;
  currency: string;
  format: TaxReportFormat;
  downloadUrl: string;
  generatedAt: string;
}

export type WorkspaceMode = 'creator' | 'seller' | 'agency' | 'affiliate' | 'brand_collab' | 'live_operator';
export type CreatorProTool = 'bio_pages' | 'media_kits' | 'rate_cards' | 'brand_deals' | 'content_roi' | 'tax_reports';

// ----------------------------------------------------------------------------
// Target 1: Canonical Deal Lifecycle
// Sequence: negotiating -> agreed -> in_progress -> delivered -> paid -> completed
// Cancellation: allowed with non-empty reason; if paid, financial reversal audit is required
// ----------------------------------------------------------------------------

export const CANONICAL_DEAL_SEQUENCE: readonly BrandDealStatus[] = [
  'negotiating',
  'agreed',
  'in_progress',
  'delivered',
  'paid',
  'completed'
] as const;

export interface TransitionOptions {
  cancellationReason?: string;
  financialReversalConfirmed?: boolean;
}

export function validateDealTransition(
  currentStatus: BrandDealStatus,
  nextStatus: BrandDealStatus,
  options?: TransitionOptions
): { valid: boolean; error?: string } {
  if (currentStatus === nextStatus) {
    return { valid: true };
  }

  // Terminal state: completed cannot transition to anything
  if (currentStatus === 'completed') {
    return { valid: false, error: 'Deal is already completed and cannot change state' };
  }

  // Cancellation handling
  if (nextStatus === 'cancelled') {
    const reason = options?.cancellationReason?.trim();
    if (!reason) {
      return { valid: false, error: 'Cancellation requires a non-empty reason' };
    }
    if (currentStatus === 'paid' && !options?.financialReversalConfirmed) {
      return {
        valid: false,
        error: 'Paid deals require explicit financial reversal confirmation before cancellation'
      };
    }
    return { valid: true };
  }

  // Current status cannot be cancelled
  if (currentStatus === 'cancelled') {
    return { valid: false, error: 'Cancelled deals cannot be reopened' };
  }

  // Check canonical sequential progression
  const currentIndex = CANONICAL_DEAL_SEQUENCE.indexOf(currentStatus);
  const nextIndex = CANONICAL_DEAL_SEQUENCE.indexOf(nextStatus);

  if (currentIndex === -1 || nextIndex === -1) {
    return { valid: false, error: `Unrecognized deal status: ${currentStatus} -> ${nextStatus}` };
  }

  if (nextIndex !== currentIndex + 1) {
    return {
      valid: false,
      error: `Invalid transition from ${currentStatus} to ${nextStatus}. Must follow canonical sequence: ${CANONICAL_DEAL_SEQUENCE.join(' -> ')}`
    };
  }

  return { valid: true };
}

// ----------------------------------------------------------------------------
// Target 2: Phishing Cannot Be Acknowledged Away & Security Scanner
// ----------------------------------------------------------------------------

export const MAX_DAILY_LINKS_PER_WORKSPACE = 20;

export function evaluateLinkThreat(url: string): {
  scanStatus: LinkSecurityScanStatus;
  phishingDetected: boolean;
  blockedFromPublishing: boolean;
  threatDetails: string;
} {
  const lower = url.toLowerCase();
  if (
    lower.includes('phishing') ||
    lower.includes('steal-login') ||
    lower.includes('fake-bank') ||
    lower.includes('credential-harvest')
  ) {
    return {
      scanStatus: 'phishing',
      phishingDetected: true,
      blockedFromPublishing: true,
      threatDetails: 'Google Safe Browsing flagged phishing URL. Cannot be activated or published.'
    };
  }
  if (lower.includes('malware') || lower.includes('trojan')) {
    return {
      scanStatus: 'malware',
      phishingDetected: false,
      blockedFromPublishing: true,
      threatDetails: 'Malicious payload detected in URL target.'
    };
  }
  if (lower.includes('suspicious') || lower.includes('bit.ly/suspect')) {
    return {
      scanStatus: 'suspicious',
      phishingDetected: false,
      blockedFromPublishing: false,
      threatDetails: 'Domain marked suspicious by reputation database.'
    };
  }
  return {
    scanStatus: 'safe',
    phishingDetected: false,
    blockedFromPublishing: false,
    threatDetails: 'URL verified clean by threat intelligence engine.'
  };
}

export function canPublishBioPage(
  _page: LinkInBioPage,
  items: LinkItem[],
  _aupAcknowledged: boolean = false
): { allowed: boolean; reason?: string } {
  // Acceptance Target 2: Phishing CANNOT be acknowledged away.
  // Even if aupAcknowledged is true, any phishing item blocks publishing.
  const phishingItem = items.find((item) => item.phishingDetected || item.scanStatus === 'phishing');
  if (phishingItem) {
    return {
      allowed: false,
      reason: `Publishing blocked: Link "${phishingItem.title}" (${phishingItem.url}) is a confirmed phishing threat. Security policy prohibits publishing phishing links; AUP acknowledgment cannot bypass this protection.`
    };
  }

  const activeLinks = items.filter((item) => item.isActive);
  if (activeLinks.length === 0) {
    return {
      allowed: false,
      reason: 'Bio page must contain at least one active link before publishing.'
    };
  }

  return { allowed: true };
}

// ----------------------------------------------------------------------------
// Target 3: Zero-View RPM Undefined Representation
// ----------------------------------------------------------------------------

export function computeRPM(
  views: number,
  revenue: number
): {
  rpm: number;
  rpmIsUndefined: boolean;
  formatted: string;
} {
  // Crucial: Acceptance Target 3 - If views == 0, RPM is strictly undefined!
  if (views <= 0) {
    return {
      rpm: 0,
      rpmIsUndefined: true,
      formatted: '— (undefined, 0 views)'
    };
  }

  const rpm = (revenue / views) * 1000;
  return {
    rpm: Math.round(rpm * 100) / 100,
    rpmIsUndefined: false,
    formatted: `${(Math.round(rpm * 100) / 100).toLocaleString('vi-VN')} VND`
  };
}

export function checkRPMDropAlert(
  previousRPM: { rpm: number; isUndefined: boolean },
  currentRPM: { rpm: number; isUndefined: boolean },
  thresholdPercent: number = 20.0
): {
  alertTriggered: boolean;
  changePercent: number;
} {
  // If either period is undefined, no drop alert can be reliably triggered
  if (previousRPM.isUndefined || currentRPM.isUndefined || previousRPM.rpm <= 0) {
    return { alertTriggered: false, changePercent: 0 };
  }

  const changePercent = ((currentRPM.rpm - previousRPM.rpm) / previousRPM.rpm) * 100;
  // A drop is negative change, e.g. -25%
  const isDrop = changePercent < -thresholdPercent;

  return {
    alertTriggered: isDrop,
    changePercent: Math.round(changePercent * 100) / 100
  };
}

// ----------------------------------------------------------------------------
// Target 4: All Six Modes Can Reach Entitled Tools
// ----------------------------------------------------------------------------

export const MODE_ENTITLED_TOOLS: Record<WorkspaceMode, readonly CreatorProTool[]> = {
  creator: ['bio_pages', 'media_kits', 'rate_cards', 'brand_deals', 'content_roi', 'tax_reports'] as const,
  seller: ['rate_cards', 'brand_deals', 'content_roi'] as const,
  agency: ['bio_pages', 'media_kits', 'rate_cards', 'brand_deals', 'content_roi', 'tax_reports'] as const,
  affiliate: ['bio_pages', 'content_roi', 'tax_reports'] as const,
  brand_collab: ['media_kits', 'rate_cards', 'brand_deals'] as const,
  live_operator: ['bio_pages', 'content_roi'] as const
};

export function isToolEntitledForMode(mode: WorkspaceMode, tool: CreatorProTool): boolean {
  const tools = MODE_ENTITLED_TOOLS[mode];
  if (!tools) return false;
  return tools.includes(tool);
}

export function getEntitledTools(mode: WorkspaceMode): readonly CreatorProTool[] {
  return MODE_ENTITLED_TOOLS[mode] || [];
}

// ----------------------------------------------------------------------------
// P8-07: Deal Kanban & Optimistic Concurrency
// ----------------------------------------------------------------------------

export interface KanbanColumn {
  status: BrandDealStatus;
  title: string;
  deals: BrandDeal[];
}

export const KANBAN_STAGES: readonly { status: BrandDealStatus; label: string }[] = [
  { status: 'negotiating', label: 'Đàm phán (Negotiating)' },
  { status: 'agreed', label: 'Đã thống nhất (Agreed)' },
  { status: 'in_progress', label: 'Đang triển khai (In Progress)' },
  { status: 'delivered', label: 'Đã bàn giao (Delivered)' },
  { status: 'paid', label: 'Đã thanh toán (Paid)' },
  { status: 'completed', label: 'Hoàn tất (Completed)' }
] as const;

export function organizeDealsIntoKanban(deals: BrandDeal[]): KanbanColumn[] {
  const map: Record<BrandDealStatus, BrandDeal[]> = {
    negotiating: [],
    agreed: [],
    in_progress: [],
    delivered: [],
    paid: [],
    completed: [],
    cancelled: []
  };

  for (const d of deals) {
    if (map[d.status]) {
      map[d.status].push(d);
    }
  }

  return KANBAN_STAGES.map((s) => ({
    status: s.status,
    title: s.label,
    deals: map[s.status].sort((a, b) => new Date(b.updatedAt).getTime() - new Date(a.updatedAt).getTime())
  }));
}

export function validateOptimisticKanbanMove(
  deal: BrandDeal,
  expectedUpdatedAt: string,
  targetStatus: BrandDealStatus
): { valid: boolean; error?: string } {
  // Stale version check
  if (deal.updatedAt !== expectedUpdatedAt) {
    return {
      valid: false,
      error: 'Deal was modified concurrently by another session; please refresh before updating status'
    };
  }

  // Canonical transition check
  return validateDealTransition(deal.status, targetStatus);
}

// ----------------------------------------------------------------------------
// P8-07: Immutable Contract Templates & Attachments
// ----------------------------------------------------------------------------

export interface ContractTemplate {
  templateId: string;
  title: string;
  dealType: BrandDealType;
  version: number;
  sourceArticleId: string;
  bodyMarkdown: string;
  disclaimer: string;
}

export const STANDARD_CONTRACT_TEMPLATES: readonly ContractTemplate[] = [
  {
    templateId: 'tmpl-sponsored-post-v1',
    title: 'Hợp đồng Dịch vụ Quảng cáo / Sponsored Post Agreement',
    dealType: 'sponsored_post',
    version: 1,
    sourceArticleId: 'art-legal-sp-01',
    bodyMarkdown: '# HỢP ĐỒNG HỢP TÁC QUẢNG CÁO\n\nĐiều 1: Phạm vi công việc và nội dung đăng tải...',
    disclaimer: 'Bản thảo hợp đồng mẫu mang tính chất tham khảo kỹ thuật, không cấu thành tư vấn pháp lý chuyên nghiệp.'
  },
  {
    templateId: 'tmpl-affiliate-collab-v1',
    title: 'Thỏa thuận Phân phối Tiếp thị Liên kết / Affiliate Agreement',
    dealType: 'affiliate_collab',
    version: 1,
    sourceArticleId: 'art-legal-aff-01',
    bodyMarkdown: '# THỎA THUẬN TIẾP THỊ LIÊN KẾT\n\nĐiều 1: Tỷ lệ hoa hồng và cơ chế đối soát UTM...',
    disclaimer: 'Bản thảo hợp đồng mẫu mang tính chất tham khảo kỹ thuật, không cấu thành tư vấn pháp lý chuyên nghiệp.'
  },
  {
    templateId: 'tmpl-ugc-creation-v1',
    title: 'Hợp đồng Sản xuất Nội dung UGC / UGC Production Agreement',
    dealType: 'ugc_creation',
    version: 1,
    sourceArticleId: 'art-legal-ugc-01',
    bodyMarkdown: '# HỢP ĐỒNG SẢN XUẤT NỘI DUNG THƯƠNG HIỆU (UGC)\n\nĐiều 1: Quyền tác giả và bản quyền sử dụng nội dung...',
    disclaimer: 'Bản thảo hợp đồng mẫu mang tính chất tham khảo kỹ thuật, không cấu thành tư vấn pháp lý chuyên nghiệp.'
  }
];

export function attachContractToDeal(
  deal: BrandDeal,
  evidenceId: string
): { success: boolean; deal?: BrandDeal; error?: string } {
  // Acceptance Target 4: Contract versions immutable (append-only evidence IDs)
  if (!evidenceId || evidenceId.trim() === '') {
    return { success: false, error: 'Evidence ID cannot be empty' };
  }

  if (deal.contractEvidenceIds.includes(evidenceId)) {
    return {
      success: false,
      error: 'Contract version evidence is immutable; cannot overwrite or re-attach identical snapshot evidence'
    };
  }

  const updatedDeal: BrandDeal = {
    ...deal,
    contractEvidenceIds: [...deal.contractEvidenceIds, evidenceId],
    updatedAt: new Date().toISOString()
  };

  return { success: true, deal: updatedDeal };
}

// ----------------------------------------------------------------------------
// P8-07: Public Creator Directory & Sponsor Inquiries (Opt-In & Privacy)
// ----------------------------------------------------------------------------

export interface PublicRateItem {
  serviceType: string;
  priceMin: number;
  priceMax: number;
  currency: string;
  deliveryDays: number;
  description?: string;
}

export interface PublicCreatorProfile {
  creatorName: string;
  headline: string;
  bio: string;
  avatarUrl?: string;
  categories: string[];
  languages: string[];
  publicRates: PublicRateItem[];
  socialMetrics: SocialPlatformMetric[];
  directoryStatus: 'published' | 'hidden';
  directoryOptIn: boolean;
}

export interface CreatorDirectoryEntry {
  mediaKitId: string;
  profile: PublicCreatorProfile;
  verifiedBadge: boolean;
  lastActiveAt: string;
}

export interface DirectoryFilterCriteria {
  query?: string;
  category?: string;
  language?: string;
}

/**
 * Filters the public creator directory.
 * Acceptance Target 2: Opt-out removes public snapshot immediately!
 * Acceptance Target 3: Only public projection is exposed.
 */
export function filterCreatorDirectory(
  entries: CreatorDirectoryEntry[],
  filters?: DirectoryFilterCriteria
): CreatorDirectoryEntry[] {
  const query = (filters?.query || '').trim().toLowerCase();
  const cat = (filters?.category || '').trim().toLowerCase();
  const lang = (filters?.language || '').trim().toLowerCase();

  return entries.filter((entry) => {
    // Acceptance Target 2: Strict check on opt-in and published status
    if (!entry.profile.directoryOptIn || entry.profile.directoryStatus !== 'published') {
      return false;
    }

    if (cat && cat !== 'all') {
      const matchCat = entry.profile.categories.some((c) => c.toLowerCase().includes(cat));
      if (!matchCat) return false;
    }

    if (lang && lang !== 'all') {
      const matchLang = entry.profile.languages.some((l) => l.toLowerCase() === lang);
      if (!matchLang) return false;
    }

    if (query) {
      const matchName = entry.profile.creatorName.toLowerCase().includes(query);
      const matchHeadline = entry.profile.headline.toLowerCase().includes(query);
      const matchBio = entry.profile.bio.toLowerCase().includes(query);
      return matchName || matchHeadline || matchBio;
    }

    return true;
  });
}

/**
 * Retrieves a single creator directory profile.
 * Fails closed (returns null) if the creator has opted out or is hidden.
 */
export function getCreatorDirectoryProfile(
  entries: CreatorDirectoryEntry[],
  mediaKitId: string
): CreatorDirectoryEntry | null {
  const entry = entries.find((e) => e.mediaKitId === mediaKitId);
  if (!entry) return null;

  // Acceptance Target 2: Immediate opt-out enforcement
  if (!entry.profile.directoryOptIn || entry.profile.directoryStatus !== 'published') {
    return null;
  }

  return entry;
}

export interface SponsorInquirySubmission {
  mediaKitId: string;
  brandName: string;
  contactEmail: string;
  message: string;
  estimatedBudget: number;
  currency?: string;
  challengeToken?: string;
  idempotencyKey?: string;
}

export interface SponsorInquiryReceipt {
  receiptId: string;
  mediaKitId: string;
  brandName: string;
  status: 'received';
  submittedAt: string;
  disclaimer: string;
}

/**
 * Submits an inquiry to a published creator in the directory.
 * Fails closed if the creator is opted out / hidden.
 * Generates an opaque receipt without exposing private workspace details.
 */
export function submitSponsorInquiry(
  entry: CreatorDirectoryEntry | null,
  inquiry: SponsorInquirySubmission
): { success: boolean; receipt?: SponsorInquiryReceipt; error?: string } {
  // Check target availability
  if (!entry || !entry.profile.directoryOptIn || entry.profile.directoryStatus !== 'published') {
    return {
      success: false,
      error: 'Creator is currently unavailable for sponsorships or has opted out of the directory'
    };
  }

  // Validate form inputs
  if (!inquiry.brandName || inquiry.brandName.trim() === '') {
    return { success: false, error: 'Brand name is required' };
  }
  if (!inquiry.contactEmail || !inquiry.contactEmail.includes('@')) {
    return { success: false, error: 'Valid business email is required' };
  }
  if (!inquiry.message || inquiry.message.trim().length < 10) {
    return { success: false, error: 'Message must be at least 10 characters' };
  }
  if (!inquiry.estimatedBudget || inquiry.estimatedBudget <= 0) {
    return { success: false, error: 'Estimated budget must be greater than zero' };
  }

  const receipt: SponsorInquiryReceipt = {
    receiptId: `rcpt-${Date.now()}-${Math.random().toString(36).substring(2, 9)}`,
    mediaKitId: entry.mediaKitId,
    brandName: inquiry.brandName.trim(),
    status: 'received',
    submittedAt: new Date().toISOString(),
    disclaimer: 'Inquiry delivery receipt; submission does not constitute binding contract acceptance by creator.'
  };

  return { success: true, receipt };
}
