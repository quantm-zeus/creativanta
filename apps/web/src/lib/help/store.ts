/**
 * Contextual Help Center, Changelog, Beta Program, Status Page & Support SLAs Store
 * Per docs/02_features/platform/help_center.md, docs/01_business/legal_compliance.md §7,
 * and docs/04_contracts/database_schema.md §17.7-§17.10.
 */

import { writable, derived, get } from 'svelte/store';

// =============================================================================
// 1. Knowledge Base Types & Canonical Data
// =============================================================================

export interface KBCategory {
  id: string;
  slug: string;
  displayName: string;
  description: string;
  icon: string;
  articleCount: number;
}

export interface KBArticle {
  id: string;
  categoryId: string;
  slug: string;
  title: string;
  summary: string;
  bodyMarkdown: string;
  moduleRef: string;
  targetModes: string[];
  articleType: 'getting_started' | 'how_to' | 'faq' | 'troubleshooting' | 'changelog';
  estimatedReadMinutes: number;
  helpfulVotes: number;
  unhelpfulVotes: number;
  lastReviewedAt: string;
  lastReviewedBy?: string;
  reviewNotes?: string;
  tags: string[];
}

export const KB_CATEGORIES: KBCategory[] = [
  {
    id: 'cat-getting-started',
    slug: 'getting-started',
    displayName: 'Bắt đầu nhanh (Getting Started)',
    description: 'Làm quen với giao diện V5, 6 chế độ vận hành và luồng công việc cốt lõi.',
    icon: 'rocket',
    articleCount: 3
  },
  {
    id: 'cat-daily-decisions',
    slug: 'daily-decisions',
    displayName: 'Hệ thống quyết định (M01)',
    description: 'Cách đọc Morning Brief, thẻ hành động ưu tiên và diễn giải số liệu.',
    icon: 'compass',
    articleCount: 2
  },
  {
    id: 'cat-troubleshooting',
    slug: 'troubleshooting',
    displayName: 'Khắc phục sự cố (Troubleshooting)',
    description: 'Sửa lỗi kết nối kênh, xử lý SLA đơn hàng và giải quyết lỗi phân phối.',
    icon: 'wrench',
    articleCount: 3
  },
  {
    id: 'cat-credits-billing',
    slug: 'credits-billing',
    displayName: 'AI Credits & Thanh toán (M23)',
    description: 'Quy tắc trừ credit minh bạch, cơ chế đối soát và chính sách không hoàn tiền theo lot.',
    icon: 'credit-card',
    articleCount: 2
  },
  {
    id: 'cat-changelog',
    slug: 'changelog',
    displayName: 'Nhật ký cập nhật & Beta',
    description: 'Thông tin tính năng mới, lộ trình phát hành các Phase P0-P8 và thay đổi hợp đồng.',
    icon: 'sparkles',
    articleCount: 1
  }
];

export const KB_ARTICLES: KBArticle[] = [
  {
    id: 'art-001',
    categoryId: 'cat-getting-started',
    slug: '6-operator-modes-guide',
    title: 'Hướng dẫn lựa chọn và chuyển đổi 6 Chế độ Vận hành',
    summary: 'Tìm hiểu sự khác biệt giữa Creator, Seller, Affiliate, Live, Agency và Brand để tối ưu nhịp làm việc hằng ngày.',
    bodyMarkdown: `### 1. Tổng quan về 6 Chế độ Vận hành\nCreativanta V5 thiết kế giao diện phù hợp với từng vai trò cụ thể:\n- Solo Creator, Seller, Affiliate, Live, Agency, Brand.`,
    moduleRef: 'M01',
    targetModes: ['creator', 'seller', 'affiliate_operator', 'live_operator', 'agency_mcn', 'brand_collaboration'],
    articleType: 'getting_started',
    estimatedReadMinutes: 3,
    helpfulVotes: 42,
    unhelpfulVotes: 1,
    lastReviewedAt: '2026-10-31T00:00:00Z',
    tags: ['operator_modes', 'navigation', 'beginner']
  },
  {
    id: 'art-002',
    categoryId: 'cat-daily-decisions',
    slug: 'understanding-why-this-number',
    title: 'Tính minh bạch số liệu: Tại sao có số này (Why This Number)?',
    summary: 'Giải thích cơ chế phân loại nguồn dữ liệu và tại sao Creativanta không bao giờ trộn dữ liệu mẫu vào doanh thu thực.',
    bodyMarkdown: `### 1. Nguyên tắc trung thực số liệu\nTrong Creativanta, mọi con số hiển thị đều có thể truy xuất nguồn gốc.`,
    moduleRef: 'M01',
    targetModes: ['creator', 'seller', 'affiliate_operator', 'live_operator', 'agency_mcn', 'brand_collaboration'],
    articleType: 'how_to',
    estimatedReadMinutes: 4,
    helpfulVotes: 78,
    unhelpfulVotes: 0,
    lastReviewedAt: '2026-10-30T00:00:00Z',
    tags: ['why_this_number', 'honesty', 'metrics', 'audit']
  },
  {
    id: 'art-003',
    categoryId: 'cat-troubleshooting',
    slug: 'reconnect-tiktok-shop-channel',
    title: 'Cách sửa lỗi kết nối tài khoản TikTok Shop & Shopee',
    summary: 'Hướng dẫn từng bước cấp lại quyền ủy quyền OAuth khi token hết hạn hoặc kết nối bị gián đoạn.',
    bodyMarkdown: `### Các bước khắc phục:\n1. Vào Cài đặt > Kênh kết nối.\n2. Chọn Cấp lại quyền.`,
    moduleRef: 'M11',
    targetModes: ['seller', 'live_operator', 'creator'],
    articleType: 'troubleshooting',
    estimatedReadMinutes: 2,
    helpfulVotes: 35,
    unhelpfulVotes: 2,
    lastReviewedAt: '2026-07-15T00:00:00Z', // >90 days ago -> STALE FOR REVIEW (§2.4)
    tags: ['connector', 'oauth', 'tiktok', 'repair']
  },
  {
    id: 'art-004',
    categoryId: 'cat-credits-billing',
    slug: 'ai-credits-consumption-rules',
    title: 'Quy tắc tính toán và hạn mức AI Credits',
    summary: 'Tìm hiểu cách hệ thống tính tín dụng khi tạo kịch bản, lồng tiếng và sinh video AI để quản lý chi phí hiệu quả.',
    bodyMarkdown: `### 1. Bảng quy đổi AI Credit\n- Tạo kịch bản: 1 Credit\n- Render video 15s: 10 Credits.`,
    moduleRef: 'M23',
    targetModes: ['creator', 'seller', 'agency_mcn'],
    articleType: 'how_to',
    estimatedReadMinutes: 3,
    helpfulVotes: 51,
    unhelpfulVotes: 3,
    lastReviewedAt: '2026-10-29T00:00:00Z',
    tags: ['credits', 'pricing', 'm23', 'video_studio']
  },
  {
    id: 'art-005',
    categoryId: 'cat-changelog',
    slug: 'v5-release-notes-p0-08',
    title: 'Nhật ký cập nhật Creativanta V5 — Cột mốc P0-08',
    summary: 'Chi tiết các nâng cấp về Khung điều hướng 6 chế độ, Trung tâm thông báo ngữ cảnh và Trung tâm trợ giúp tích hợp.',
    bodyMarkdown: `### Cột mốc P0-08: Shells, Thông báo & Trợ giúp ngữ cảnh`,
    moduleRef: 'help',
    targetModes: ['creator', 'seller', 'affiliate_operator', 'live_operator', 'agency_mcn', 'brand_collaboration'],
    articleType: 'changelog',
    estimatedReadMinutes: 2,
    helpfulVotes: 99,
    unhelpfulVotes: 0,
    lastReviewedAt: '2026-11-02T00:00:00Z',
    tags: ['changelog', 'release_notes', 'p0_08']
  },
  {
    id: 'art-006',
    categoryId: 'cat-troubleshooting',
    slug: 'low-quality-article-sample',
    title: 'Xử lý lỗi mã giảm giá đối tác',
    summary: 'Hướng dẫn cơ bản về coupon.',
    bodyMarkdown: `Nội dung ngắn chưa đầy đủ.`,
    moduleRef: 'M14',
    targetModes: ['seller'],
    articleType: 'troubleshooting',
    estimatedReadMinutes: 1,
    helpfulVotes: 1,
    unhelpfulVotes: 4, // 20% helpful (<60% threshold)
    lastReviewedAt: '2026-10-20T00:00:00Z',
    tags: ['coupon', 'troubleshooting']
  }
];

export const isHelpDrawerOpen = writable<boolean>(false);
export const selectedArticleId = writable<string | null>(null);
export const searchQuery = writable<string>('');
export const activeModuleFilter = writable<string | null>(null);
export const kbArticles = writable<KBArticle[]>(KB_ARTICLES);
export const userRatings = writable<Record<string, boolean>>({});

// Stale article detection: unreviewed > 90 days (§2.4, Acceptance Target 1)
export function isArticleStale(article: KBArticle, refDateMs: number = Date.parse('2026-11-04T00:00:00Z')): boolean {
  const reviewedMs = Date.parse(article.lastReviewedAt);
  const diffDays = (refDateMs - reviewedMs) / (1000 * 60 * 60 * 24);
  return diffDays > 90;
}

export const staleArticles = derived(kbArticles, ($articles) =>
  $articles.filter((a) => isArticleStale(a))
);

export const lowRatingArticles = derived(kbArticles, ($articles) =>
  $articles.filter((a) => {
    const total = a.helpfulVotes + a.unhelpfulVotes;
    return total >= 3 && a.helpfulVotes / total < 0.6;
  })
);

export const helpStore = {
  isOpen: {
    subscribe: isHelpDrawerOpen.subscribe,
    open: (moduleRef?: string) => {
      if (moduleRef) {
        activeModuleFilter.set(moduleRef);
      } else {
        activeModuleFilter.set(null);
      }
      selectedArticleId.set(null);
      isHelpDrawerOpen.set(true);
    },
    close: () => isHelpDrawerOpen.set(false),
    toggle: () => isHelpDrawerOpen.update((v) => !v)
  },
  selectedArticleId,
  searchQuery,
  activeModuleFilter,
  articles: kbArticles,
  userRatings,
  rateArticle: (articleId: string, helpful: boolean) => {
    userRatings.update((ratings) => ({ ...ratings, [articleId]: helpful }));
    kbArticles.update((list) =>
      list.map((art) => {
        if (art.id === articleId) {
          return {
            ...art,
            helpfulVotes: helpful ? art.helpfulVotes + 1 : art.helpfulVotes,
            unhelpfulVotes: !helpful ? art.unhelpfulVotes + 1 : art.unhelpfulVotes
          };
        }
        return art;
      })
    );
  },
  reviewArticle: (articleId: string, reviewerId: string, notes: string) => {
    kbArticles.update((list) =>
      list.map((art) => {
        if (art.id === articleId) {
          return {
            ...art,
            lastReviewedAt: new Date().toISOString(),
            lastReviewedBy: reviewerId,
            reviewNotes: notes
          };
        }
        return art;
      })
    );
  }
};

export const filteredArticles = derived(
  [kbArticles, searchQuery, activeModuleFilter],
  ([$articles, $query, $module]) => {
    let result = $articles;
    if ($module) {
      result = result.filter(
        (a) => a.moduleRef.toLowerCase().includes($module.toLowerCase()) || a.moduleRef === 'help'
      );
    }
    if ($query && $query.trim().length > 0) {
      const q = $query.toLowerCase().trim();
      result = result.filter(
        (a) =>
          a.title.toLowerCase().includes(q) ||
          a.summary.toLowerCase().includes(q) ||
          a.tags.some((t) => t.toLowerCase().includes(q))
      );
    }
    return result;
  }
);

// =============================================================================
// 2. Beta Program Store (§4, Acceptance Target 2: "Beta grant once")
// =============================================================================

export interface BetaEnrollment {
  workspaceId: string;
  tier: string;
  status: 'active' | 'opted_out';
  bonusCreditsGranted: boolean;
  bonusCreditsAmount: number;
  creditsAwarded: number;
  enabledFlags: string[];
  enrolledAt: string;
}

export interface BetaFeedback {
  id: string;
  featureKey: string;
  rating: number; // 1-5
  feedbackText: string;
  isBugReport: boolean;
  createdAt: string;
}

const betaEnrollmentsStore = writable<Record<string, BetaEnrollment>>({});
const betaFeedbacksStore = writable<BetaFeedback[]>([]);

export const betaStore = {
  enrollments: { subscribe: betaEnrollmentsStore.subscribe },
  feedbacks: { subscribe: betaFeedbacksStore.subscribe },

  // ACCEPTANCE TARGET 2: "Beta grant once"
  enroll: (workspaceId: string, tier: string): { success: boolean; creditsAwarded: number; message: string } => {
    const t = tier.toLowerCase().trim();
    if (t === 'free' || !t) {
      throw new Error('Gói Free không đủ điều kiện tham gia Beta. Vui lòng nâng cấp từ Starter.');
    }

    const current = get(betaEnrollmentsStore)[workspaceId];
    if (!current) {
      // First enrollment: grant 50 bonus credits once!
      const newRec: BetaEnrollment = {
        workspaceId,
        tier: t,
        status: 'active',
        bonusCreditsGranted: true,
        bonusCreditsAmount: 50,
        creditsAwarded: 50,
        enabledFlags: ['beta_video_continuity', 'beta_live_radar', 'beta_recipe_v2'],
        enrolledAt: new Date().toISOString()
      };
      betaEnrollmentsStore.update((m) => ({ ...m, [workspaceId]: newRec }));
      return { success: true, creditsAwarded: 50, message: 'Đăng ký thành công! Đã cộng 50 AI credits trải nghiệm.' };
    }

    // Re-enrollment: reactivates flags, but GRANTS 0 CREDITS!
    const updatedRec: BetaEnrollment = {
      ...current,
      status: 'active',
      creditsAwarded: 0,
      enabledFlags: ['beta_video_continuity', 'beta_live_radar', 'beta_recipe_v2']
    };
    betaEnrollmentsStore.update((m) => ({ ...m, [workspaceId]: updatedRec }));
    return { success: true, creditsAwarded: 0, message: 'Chào mừng trở lại! Đã kích hoạt lại cờ tính năng Beta.' };
  },

  optOut: (workspaceId: string) => {
    betaEnrollmentsStore.update((m) => {
      const rec = m[workspaceId];
      if (!rec) return m;
      return {
        ...m,
        [workspaceId]: {
          ...rec,
          status: 'opted_out',
          enabledFlags: []
        }
      };
    });
  },

  submitFeedback: (featureKey: string, rating: number, text: string, isBug: boolean) => {
    if (rating < 1 || rating > 5) {
      throw new Error('Đánh giá phải từ 1 đến 5 sao.');
    }
    const fb: BetaFeedback = {
      id: 'fb-' + Math.random().toString(36).substring(2, 9),
      featureKey,
      rating,
      feedbackText: text,
      isBugReport: isBug,
      createdAt: new Date().toISOString()
    };
    betaFeedbacksStore.update((list) => [fb, ...list]);
  }
};

// =============================================================================
// 3. Public Status Page Store (§5, Acceptance Target 3: Subscription Privacy)
// =============================================================================

export interface StatusComponent {
  id: string;
  name: string;
  status: 'operational' | 'degraded_performance' | 'partial_outage' | 'major_outage';
  latencyMs: number;
}

export interface StatusIncident {
  id: string;
  title: string;
  severity: 'P0_critical' | 'P1_high' | 'P2_medium';
  status: 'investigating' | 'mitigated' | 'resolved';
  affectedServices: string[];
  updates: Array<{ timestamp: string; message: string }>;
}

export const CANONICAL_STATUS_COMPONENTS: StatusComponent[] = [
  { id: 'web_app', name: 'Web Application (SvelteKit)', status: 'operational', latencyMs: 45 },
  { id: 'mobile_backend', name: 'Mobile Backend (API Endpoints)', status: 'operational', latencyMs: 38 },
  { id: 'public_api', name: 'Public Developer API', status: 'operational', latencyMs: 52 },
  { id: 'database', name: 'PostgreSQL Primary', status: 'operational', latencyMs: 12 },
  { id: 'ai_services', name: 'AI Services (Generation Endpoints)', status: 'operational', latencyMs: 180 },
  { id: 'platform_connectors', name: 'Platform Connectors (TikTok, Shopee)', status: 'operational', latencyMs: 95 },
  { id: 'payment_processing', name: 'Payment Processing (Stripe)', status: 'operational', latencyMs: 110 },
  { id: 'notification_delivery', name: 'Notification Delivery (Email/SMS)', status: 'operational', latencyMs: 65 }
];

const statusComponentsStore = writable<StatusComponent[]>(CANONICAL_STATUS_COMPONENTS);
const statusIncidentsStore = writable<StatusIncident[]>([]);
const subscriberCountStore = writable<number>(142); // Anonymized subscriber count

export const statusStore = {
  components: { subscribe: statusComponentsStore.subscribe },
  incidents: { subscribe: statusIncidentsStore.subscribe },
  subscriberCount: { subscribe: subscriberCountStore.subscribe },

  // ACCEPTANCE TARGET 3: Subscription Privacy
  // Subscriber's private contact details are kept client-side/token-protected only
  // Public response payload only surfaces the total count.
  subscribe: (channel: 'email' | 'webhook', target: string): { privacyToken: string } => {
    if (!target) throw new Error('Vui lòng nhập địa chỉ nhận thông báo.');
    subscriberCountStore.update((c) => c + 1);
    const token = 'tok_priv_' + Math.random().toString(36).substring(2, 12);
    return { privacyToken: token };
  },

  unsubscribe: (token: string): boolean => {
    if (!token.startsWith('tok_priv_')) {
      throw new Error('Mã token hủy đăng ký không hợp lệ.');
    }
    subscriberCountStore.update((c) => Math.max(0, c - 1));
    return true;
  }
};

// =============================================================================
// 4. Customer Support SLAs Store (§7, legal_compliance.md §7.2)
// =============================================================================

export interface SupportTicketItem {
  id: string;
  ticketNumber: string;
  subject: string;
  priority: 'urgent' | 'high' | 'normal' | 'low';
  status: 'open' | 'in_progress' | 'waiting_user' | 'resolved' | 'closed';
  category: 'technical' | 'billing' | 'content' | 'feature_request';
  planTier: string;
  responseDueMinutes: number;
  resolutionDueMinutes: number;
  isSlaBreached: boolean;
  csatScore?: number;
}

export interface SupportMessageItem {
  id: string;
  ticketId: string;
  authorType: 'user' | 'admin' | 'system';
  body: string;
  isInternalNote: boolean;
  createdAt: string;
}

// Plan SLAs per legal_compliance.md §7.2
export function calculateSupportSLA(planTier: string): { responseHours: number; resolutionHours: number } {
  switch (planTier.toLowerCase().trim()) {
    case 'enterprise':
      return { responseHours: 1, resolutionHours: 4 };
    case 'business':
      return { responseHours: 2, resolutionHours: 8 };
    case 'pro':
      return { responseHours: 8, resolutionHours: 24 };
    case 'starter':
      return { responseHours: 24, resolutionHours: 72 };
    default: // free
      return { responseHours: 48, resolutionHours: 120 };
  }
}

// Internal Note Isolation helper: workspace users never see internal notes!
export function filterMessagesForWorkspace(messages: SupportMessageItem[]): SupportMessageItem[] {
  return messages.filter((m) => !m.isInternalNote);
}

const supportTicketsStore = writable<SupportTicketItem[]>([]);
const supportMessagesStore = writable<SupportMessageItem[]>([]);

export const supportStore = {
  tickets: { subscribe: supportTicketsStore.subscribe },
  messages: { subscribe: supportMessagesStore.subscribe },

  createTicket: (planTier: string, subject: string, priority: 'urgent' | 'high' | 'normal' | 'low', initialMsg: string) => {
    const sla = calculateSupportSLA(planTier);
    const id = 'tk-' + Math.random().toString(36).substring(2, 8);
    const ticketNum = 'TK-' + Math.floor(1000 + Math.random() * 9000);

    const ticket: SupportTicketItem = {
      id,
      ticketNumber: ticketNum,
      subject,
      priority,
      status: 'open',
      category: 'technical',
      planTier,
      responseDueMinutes: sla.responseHours * 60,
      resolutionDueMinutes: sla.resolutionHours * 60,
      isSlaBreached: false
    };

    supportTicketsStore.update((list) => [ticket, ...list]);

    if (initialMsg) {
      const msg: SupportMessageItem = {
        id: 'msg-' + Math.random().toString(36).substring(2, 8),
        ticketId: id,
        authorType: 'user',
        body: initialMsg,
        isInternalNote: false,
        createdAt: new Date().toISOString()
      };
      supportMessagesStore.update((list) => [...list, msg]);
    }

    return ticket;
  },

  closeTicket: (ticketId: string, csatScore: number) => {
    if (csatScore < 1 || csatScore > 5) {
      throw new Error('Điểm CSAT phải từ 1 đến 5 sao.');
    }
    supportTicketsStore.update((list) =>
      list.map((t) => (t.id === ticketId ? { ...t, status: 'closed', csatScore } : t))
    );
  },

  upsertRemoteTicket: (ticket: SupportTicketItem, initialMsg?: string) => {
    supportTicketsStore.update((list) => [ticket, ...list.filter((t) => t.id !== ticket.id)]);
    if (initialMsg) {
      const msg: SupportMessageItem = {
        id: `msg-${ticket.id}-1`,
        ticketId: ticket.id,
        authorType: 'user',
        body: initialMsg,
        isInternalNote: false,
        createdAt: new Date().toISOString()
      };
      supportMessagesStore.update((list) => [...list, msg]);
    }
  },

  reset: () => {
    supportTicketsStore.set([]);
    supportMessagesStore.set([]);
  }
};

import { callCanonicalRpc, generateIdempotencyKey, type CanonicalRpcOptions } from '$lib/api/client';
import { registerAuthResetHook } from '$lib/auth/store';

registerAuthResetHook(() => {
  supportStore.reset();
});

export interface SubmitSupportTicketRemoteInput {
  workspaceId?: string;
  planTier: string;
  subject: string;
  priority: 'urgent' | 'high' | 'normal' | 'low';
  initialMessage: string;
  category?: string;
}

export interface SubmitSupportTicketRemoteResult {
  ok: boolean;
  ticket?: SupportTicketItem;
  error?: string;
}

/**
 * Submits a support ticket to canonical `creativanta.admin.v1.SupportService/CreateTicket` (UF-07).
 * Never fabricates `#TK-...` ticket numbers in browser memory or clears user input when
 * unauthenticated or when backend persistence fails.
 */
export async function submitSupportTicketRemote(
  input: SubmitSupportTicketRemoteInput,
  options: CanonicalRpcOptions = {}
): Promise<SubmitSupportTicketRemoteResult> {
  const subject = (input.subject || '').trim();
  const message = (input.initialMessage || '').trim();

  if (!subject || !message) {
    return {
      ok: false,
      error: 'Vui lòng nhập đầy đủ tiêu đề và nội dung chi tiết yêu cầu hỗ trợ.'
    };
  }

  const rpcRes = await callCanonicalRpc<
    Record<string, unknown>,
    {
      ticket?: {
        ticket_id?: string;
        id?: string;
        ticket_number?: string;
        subject?: string;
        priority?: SupportTicketItem['priority'];
        status?: SupportTicketItem['status'];
        category?: SupportTicketItem['category'];
        response_due_minutes?: number;
        resolution_due_minutes?: number;
      };
    }
  >(
    'creativanta.admin.v1.SupportService/CreateTicket',
    {
      idempotency_key: options.idempotencyKey || generateIdempotencyKey('support-ticket'),
      workspace_id: input.workspaceId,
      subject,
      priority: input.priority,
      initial_message: message,
      category: input.category || 'technical',
      plan_tier: input.planTier
    },
    {
      ...options,
      workspaceId: options.workspaceId ?? input.workspaceId
    }
  );

  if (!rpcRes.ok) {
    return {
      ok: false,
      error: rpcRes.error.message
    };
  }

  const remote = rpcRes.data?.ticket;
  const ticketId = remote?.ticket_id || remote?.id;
  const ticketNumber = remote?.ticket_number;

  if (!ticketId || !ticketNumber) {
    return {
      ok: false,
      error: 'Phản hồi từ máy chủ thiếu mã yêu cầu hỗ trợ (ticket_id/ticket_number). Nội dung của bạn đã được giữ nguyên.'
    };
  }

  const sla = calculateSupportSLA(input.planTier);
  const ticket: SupportTicketItem = {
    id: ticketId,
    ticketNumber,
    subject: remote.subject || subject,
    priority: remote.priority || input.priority,
    status: remote.status || 'open',
    category: (remote.category || input.category || 'technical') as SupportTicketItem['category'],
    planTier: input.planTier,
    responseDueMinutes: remote.response_due_minutes ?? sla.responseHours * 60,
    resolutionDueMinutes: remote.resolution_due_minutes ?? sla.resolutionHours * 60,
    isSlaBreached: false
  };

  supportStore.upsertRemoteTicket(ticket, message);
  return { ok: true, ticket };
}

// =============================================================================
// 5. In-App Announcements & Session Throttling Store (§3.2)
// =============================================================================

export interface SystemAnnouncement {
  id: string;
  title: string;
  body: string;
  type: 'breaking_change' | 'feature_launch' | 'improvement' | 'fix';
  displayMode: 'blocking_modal' | 'modal' | 'banner' | 'toast';
  priority: number; // 4 = breaking, 3 = launch, 2 = improvement, 1 = fix
  targetPlans: string[];
  isDismissible: boolean;
}

export const CANONICAL_ANNOUNCEMENTS: SystemAnnouncement[] = [
  {
    id: 'ann-breaking-01',
    title: 'Cập nhật bảo mật kết nối Public API',
    body: 'Vui lòng cập nhật API keys trước ngày 15/11.',
    type: 'breaking_change',
    displayMode: 'blocking_modal',
    priority: 4,
    targetPlans: ['enterprise'],
    isDismissible: false
  },
  {
    id: 'ann-pro-feature-02',
    title: 'Tính năng mới: AI Video Continuity Studio',
    body: 'Tạo chuỗi video đồng nhất nhân vật cho thành viên Pro+.',
    type: 'feature_launch',
    displayMode: 'modal',
    priority: 3,
    targetPlans: ['pro', 'business', 'enterprise'],
    isDismissible: true
  },
  {
    id: 'ann-speed-improvement-03',
    title: 'Nâng cấp tốc độ xuất bản',
    body: 'Thời gian phân phối video nhanh hơn 40%.',
    type: 'improvement',
    displayMode: 'banner',
    priority: 2,
    targetPlans: [], // all
    isDismissible: true
  }
];

const dismissedAnnouncementsStore = writable<Record<string, boolean>>({});

export const announcementStore = {
  dismissed: { subscribe: dismissedAnnouncementsStore.subscribe },

  getAnnouncementForSession: (
    tier: string,
    sessionSeenCount: number,
    dismissedMap: Record<string, boolean>
  ): SystemAnnouncement | null => {
    // Rule: Max 1 announcement per session (§3.2)
    if (sessionSeenCount >= 1) {
      return null;
    }

    const t = tier.toLowerCase().trim();
    const eligible = CANONICAL_ANNOUNCEMENTS.filter((ann) => {
      if (dismissedMap[ann.id]) return false;
      if (ann.targetPlans.length > 0 && !ann.targetPlans.includes(t)) return false;
      return true;
    });

    if (eligible.length === 0) return null;
    eligible.sort((a, b) => b.priority - a.priority);
    return eligible[0];
  },

  dismiss: (announcementId: string) => {
    dismissedAnnouncementsStore.update((m) => ({ ...m, [announcementId]: true }));
  }
};
