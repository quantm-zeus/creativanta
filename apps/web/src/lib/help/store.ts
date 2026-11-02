/**
 * Contextual Help Center & Knowledge Base Store for Creativanta Go V5
 * Per docs/02_features/platform/help_center.md and docs/04_contracts/database_schema.md §17.9A-§17.9D.
 */

import { writable, derived } from 'svelte/store';

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
    bodyMarkdown: `### 1. Tổng quan về 6 Chế độ Vận hành
Creativanta V5 thiết kế giao diện phù hợp với từng vai trò cụ thể:
- **Solo Creator**: Ưu tiên ý tưởng kịch bản, xu hướng âm thanh và sản xuất video AI.
- **Seller**: Tập trung cảnh báo tồn kho, xử lý đơn hàng và vi phạm SLA sàn TMĐT.
- **Affiliate Operator**: Theo dõi hoa hồng tạm tính, tuyển chọn deal hoa hồng cao và phát hiện link tiếp thị bị lỗi.
- **Live Operator**: Kịch bản phiên live, sắp xếp deal flash sale và điều phối chốt đơn thời gian thực.
- **Agency / MCN**: Giám sát KPI mạng lưới creator, phân quyền chiến dịch và đối soát tài chính đa bên.
- **Brand Collaboration**: Duyệt brief sáng tạo từ KOC/KOL và theo dõi chỉ số ROI chiến dịch minh bạch.

### 2. Cách chuyển đổi chế độ
Nhấp vào trình chọn vai trò tại thanh điều hướng trên cùng (Header) để chuyển đổi tức thì. Lựa chọn này được lưu cục bộ trên thiết bị của bạn.`,
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
    bodyMarkdown: `### 1. Nguyên tắc trung thực số liệu
Trong Creativanta, mọi con số hiển thị đều có thể truy xuất nguồn gốc:
- **Dữ liệu chính thức (Official)**: Đồng bộ trực tiếp từ API của TikTok Shop, Shopee, YouTube hoặc ngân hàng.
- **Dữ liệu nhập liệu (Imported)**: Do chính người dùng tải lên qua bảng tính hoặc đối soát thủ công.
- **Dữ liệu suy luận (Inferred)**: Dự báo qua thuật toán AI/Machine Learning dựa trên xu hướng quá khứ.
- **Dữ liệu mẫu (Demo Fixture)**: Phục vụ trải nghiệm ban đầu, luôn mang nhãn DEMO rõ ràng.

### 2. Cam kết cách ly dữ liệu mẫu
Tuyệt đối **KHÔNG BAO GIỜ** cộng gộp số liệu demo vào tổng doanh thu thực tế, tiền hoa hồng hay số dư tín dụng của khách hàng.`,
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
    bodyMarkdown: `### Khi nào cần cấp lại quyền?
TikTok Shop và Shopee yêu cầu người bán cấp quyền lại định kỳ 30 ngày một lần để bảo vệ an toàn tài khoản.

### Các bước khắc phục:
1. Vào **Cài đặt** > **Kênh kết nối** (/settings/connections).
2. Tìm kênh có trạng thái màu đỏ hoặc cảnh báo "Hết hạn quyền truy cập".
3. Nhấp vào nút **Cấp lại quyền (Re-authorize)**.
4. Đăng nhập vào trang xác thực chính thức của TikTok Shop Partner Portal.
5. Sau khi hoàn tất, hệ thống sẽ tự động đồng bộ lại đơn hàng và kịch bản trong vòng 60 giây.`,
    moduleRef: 'M11',
    targetModes: ['seller', 'live_operator', 'creator'],
    articleType: 'troubleshooting',
    estimatedReadMinutes: 2,
    helpfulVotes: 35,
    unhelpfulVotes: 2,
    lastReviewedAt: '2026-10-28T00:00:00Z',
    tags: ['connector', 'oauth', 'tiktok', 'repair']
  },
  {
    id: 'art-004',
    categoryId: 'cat-credits-billing',
    slug: 'ai-credits-consumption-rules',
    title: 'Quy tắc tính toán và hạn mức AI Credits',
    summary: 'Tìm hiểu cách hệ thống tính tín dụng khi tạo kịch bản, lồng tiếng và sinh video AI để quản lý chi phí hiệu quả.',
    bodyMarkdown: `### 1. Bảng quy đổi AI Credit
- Tạo kịch bản ngắn (Short Script): 1 Credit
- Sinh ý tưởng đa góc nhìn: 2 Credits
- Render video AI 15s tiêu chuẩn: 10 Credits
- Render video AI độ phân giải cao 60s: 35 Credits

### 2. Nguyên tắc trừ Credit theo Lot (ADR-004)
Hệ thống sử dụng cơ chế trừ credit theo số dư thực tế không âm. Nếu một tác vụ sinh video gặp lỗi từ phía nhà cung cấp hạ tầng (Provider Error), credit sẽ được tự động hoàn lại vào tài khoản trong vòng 120 giây.`,
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
    bodyMarkdown: `### Cột mốc P0-08: Shells, Thông báo & Trợ giúp ngữ cảnh
- **6 Chế độ Vận hành**: Ra mắt bộ chuyển đổi danh tính hoàn chỉnh cho Creator, Seller, Affiliate, Live, Agency và Brand.
- **Trung tâm thông báo (Notifications Center)**: Thông báo có phạm vi workspace/user, phân loại 4 cấp độ ưu tiên và hỗ trợ đánh dấu đã đọc.
- **Trung tâm trợ giúp (Help Center)**: Tìm kiếm tài liệu trực tiếp, xem theo phân hệ (M01-M23), và đánh giá độ hữu ích.
- **Minh bạch số liệu**: Tính năng "Tại sao có số này?" giải trình công thức và phân lập hoàn toàn dữ liệu mẫu khỏi tổng doanh số khách hàng.`,
    moduleRef: 'help',
    targetModes: ['creator', 'seller', 'affiliate_operator', 'live_operator', 'agency_mcn', 'brand_collaboration'],
    articleType: 'changelog',
    estimatedReadMinutes: 2,
    helpfulVotes: 99,
    unhelpfulVotes: 0,
    lastReviewedAt: '2026-11-02T00:00:00Z',
    tags: ['changelog', 'release_notes', 'p0_08']
  }
];

export const isHelpDrawerOpen = writable<boolean>(false);
export const selectedArticleId = writable<string | null>(null);
export const searchQuery = writable<string>('');
export const activeModuleFilter = writable<string | null>(null);
export const kbArticles = writable<KBArticle[]>(KB_ARTICLES);
export const userRatings = writable<Record<string, boolean>>({});

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
