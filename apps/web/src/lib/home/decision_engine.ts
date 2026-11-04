/**
 * Daily Decision Engine (M01) — Shared Mode Priorities, Routes & Onboarding
 * Canonical Source: docs/02_features/platform/home_decision_engine.md
 *                   docs/01_business/user_segments_and_modes.md
 *                   docs/04_contracts/database_schema.md §27.1
 */

import type { OperatorModeId } from '$lib/constants/modes';

export type UIStateType = 'normal' | 'loading' | 'empty' | 'error' | 'repair';

export type DataSourceBadge = 'OFFICIAL' | 'IMPORTED' | 'INFERRED' | 'DEMO';

export type ConfidenceLevel = 'HIGH' | 'MEDIUM' | 'LOW';

export interface WebDecisionCard {
  cardId: string;
  cardFamily: string;
  title: string;
  description: string;
  primaryCtaLabel: string;
  primaryCtaRoute: string;
  isActionAvailable: boolean;
  unavailableReason: string;
  dataSource: DataSourceBadge;
  confidence: ConfidenceLevel;
  whyThisMatters: string;
  priorityRank: number;
  moduleRef: string;
  stateType: UIStateType;
  repairInstructions?: string;
}

export interface WebOnboardingStep {
  stepNumber: number; // 1..5
  stepKey: string;
  title: string;
  description: string;
  isCompleted: boolean;
  isAvailable: boolean;
  unavailableReason?: string;
}

export interface WebOnboardingProgress {
  steps: WebOnboardingStep[];
  completedCount: number;
  totalSteps: number;
  isFirstValueComplete: boolean;
  isClosedLoopComplete: boolean;
}

/**
 * Shared route dictionary mapping Web routes to Canonical Modules and Mobile targets
 */
export interface SharedRouteMapping {
  route: string;
  moduleRef: string;
  vietnameseTitle: string;
  mobileTabOrScreen: string;
  domain: string;
}

export const SHARED_ROUTE_MAP: Record<string, SharedRouteMapping> = {
  '/': {
    route: '/',
    moduleRef: 'M01',
    vietnameseTitle: 'Tổng quan / Quyết định',
    mobileTabOrScreen: 'HomeTab',
    domain: 'platform'
  },
  '/kham-pha': {
    route: '/kham-pha',
    moduleRef: 'M02',
    vietnameseTitle: 'Khám phá xu hướng (Radar)',
    mobileTabOrScreen: 'ExploreTab',
    domain: 'intelligence'
  },
  '/ideas': {
    route: '/ideas',
    moduleRef: 'M05',
    vietnameseTitle: 'Ý tưởng & Góc Hook (Idea Engine)',
    mobileTabOrScreen: 'IdeasView',
    domain: 'content'
  },
  '/scripts': {
    route: '/scripts',
    moduleRef: 'M06',
    vietnameseTitle: 'Kịch bản bán hàng (Script Lab)',
    mobileTabOrScreen: 'ScriptLabView',
    domain: 'content'
  },
  '/studio': {
    route: '/studio',
    moduleRef: 'M07',
    vietnameseTitle: 'Sản xuất video AI (Video Studio)',
    mobileTabOrScreen: 'CreateTab',
    domain: 'production'
  },
  '/xuat-ban': {
    route: '/xuat-ban',
    moduleRef: 'M11',
    vietnameseTitle: 'Lịch đăng & Xuất bản (Publish Hub)',
    mobileTabOrScreen: 'PublishView',
    domain: 'publish'
  },
  '/inbox': {
    route: '/inbox',
    moduleRef: 'M12',
    vietnameseTitle: 'Hộp thư hợp nhất (Unified Inbox)',
    mobileTabOrScreen: 'InboxTab',
    domain: 'engagement'
  },
  '/kinh-doanh': {
    route: '/kinh-doanh',
    moduleRef: 'M13',
    vietnameseTitle: 'Sản phẩm & Tồn kho (Product Hub)',
    mobileTabOrScreen: 'CommerceDashboard',
    domain: 'commerce'
  },
  '/finance': {
    route: '/finance',
    moduleRef: 'M19',
    vietnameseTitle: 'Sổ cái & Lợi nhuận (Operating Ledger)',
    mobileTabOrScreen: 'FinanceDashboard',
    domain: 'finance'
  },
  '/affiliates': {
    route: '/affiliates',
    moduleRef: 'M16',
    vietnameseTitle: 'Mạng lưới liên kết (Affiliate Network)',
    mobileTabOrScreen: 'AffiliateView',
    domain: 'commerce'
  },
  '/offers': {
    route: '/offers',
    moduleRef: 'M14',
    vietnameseTitle: 'Ưu đãi & Khuyến mãi (Monetization OS)',
    mobileTabOrScreen: 'OffersView',
    domain: 'commerce'
  },
  '/coupons': {
    route: '/coupons',
    moduleRef: 'M14',
    vietnameseTitle: 'Mã giảm giá (Coupon Manager)',
    mobileTabOrScreen: 'CouponsView',
    domain: 'commerce'
  },
  '/attribution': {
    route: '/attribution',
    moduleRef: 'M16',
    vietnameseTitle: 'Đối soát hoa hồng (Attribution)',
    mobileTabOrScreen: 'AttributionView',
    domain: 'finance'
  },
  '/live': {
    route: '/live',
    moduleRef: 'M17',
    vietnameseTitle: 'Phòng chiến Live (War Room)',
    mobileTabOrScreen: 'LiveWarRoomView',
    domain: 'commerce'
  },
  '/workflows': {
    route: '/workflows',
    moduleRef: 'M20',
    vietnameseTitle: 'Quy trình tự động (Workflow Studio)',
    mobileTabOrScreen: 'WorkflowsView',
    domain: 'automation'
  },
  '/creator-pro': {
    route: '/creator-pro',
    moduleRef: 'S16',
    vietnameseTitle: 'Hợp tác nhãn hàng (Creator Pro)',
    mobileTabOrScreen: 'CreatorProView',
    domain: 'commerce'
  },
  '/workspaces': {
    route: '/workspaces',
    moduleRef: 'M22',
    vietnameseTitle: 'Quản trị Workspace đa Creator',
    mobileTabOrScreen: 'WorkspaceSwitchSheet',
    domain: 'platform'
  },
  '/campaigns': {
    route: '/campaigns',
    moduleRef: 'M14',
    vietnameseTitle: 'Chiến dịch thương hiệu (Campaigns)',
    mobileTabOrScreen: 'CampaignsView',
    domain: 'commerce'
  },
  '/seeding': {
    route: '/seeding',
    moduleRef: 'M18',
    vietnameseTitle: 'Gửi mẫu & CRM (Seeding)',
    mobileTabOrScreen: 'SeedingView',
    domain: 'commerce'
  },
  '/settings/diagnostics': {
    route: '/settings/diagnostics',
    moduleRef: 'M22',
    vietnameseTitle: 'Chẩn đoán kết nối & Token',
    mobileTabOrScreen: 'DiagnosticsView',
    domain: 'platform'
  },
  '/settings/connections': {
    route: '/settings/connections',
    moduleRef: 'M22',
    vietnameseTitle: 'Kênh kết nối & Phân quyền',
    mobileTabOrScreen: 'ConnectionsView',
    domain: 'platform'
  }
};

/**
 * Six Mode Canonical Priorities Matrix
 */
export const MODE_DECISION_CARDS: Record<OperatorModeId, WebDecisionCard[]> = {
  creator: [
    {
      cardId: 'card-creator-trend',
      cardFamily: 'top_opportunities',
      title: 'Cơ hội xu hướng FMCG & Đồ gia dụng thông minh',
      description: 'Âm thanh và chủ đề xu hướng tăng trưởng 120% trong 24 giờ qua trên TikTok Shop.',
      primaryCtaLabel: 'Khám phá tín hiệu xu hướng',
      primaryCtaRoute: '/kham-pha',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Bắt nhịp xu hướng sớm tăng lượt xem tự nhiên lên gấp 3 lần.',
      priorityRank: 1,
      moduleRef: 'M02',
      stateType: 'normal'
    },
    {
      cardId: 'card-creator-ideas',
      cardFamily: 'ideas_and_scripts',
      title: '5 ý tưởng video mới từ Trend Radar',
      description: 'Ý tưởng nội dung kèm 3 góc hook đã sẵn sàng để phát triển thành kịch bản hoàn chỉnh.',
      primaryCtaLabel: 'Mở Idea Engine',
      primaryCtaRoute: '/ideas',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Chuyển hóa tín hiệu xu hướng thành nội dung cụ thể trong vòng 24h.',
      priorityRank: 2,
      moduleRef: 'M05',
      stateType: 'normal'
    },
    {
      cardId: 'card-creator-script',
      cardFamily: 'ideas_and_scripts',
      title: '3 kịch bản AI Video Studio đề xuất',
      description: 'Kịch bản dạng unboxing và review thực tế được tạo tự động cho sản phẩm chọn lọc.',
      primaryCtaLabel: 'Mở Script Lab',
      primaryCtaRoute: '/scripts',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Kịch bản có cấu trúc giữ chân người xem qua 3 giây đầu tiên.',
      priorityRank: 3,
      moduleRef: 'M06',
      stateType: 'normal'
    },
    {
      cardId: 'card-creator-publish',
      cardFamily: 'publish_schedule',
      title: 'Lịch đăng bài khung giờ vàng (19:30 - 21:00)',
      description: 'Lên lịch sẵn bài đăng đa kênh TikTok, Reels và YouTube Shorts.',
      primaryCtaLabel: 'Mở Publish Hub',
      primaryCtaRoute: '/xuat-ban',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Đăng đúng khung giờ vàng tiếp cận tối đa tệp khán giả mục tiêu.',
      priorityRank: 4,
      moduleRef: 'M11',
      stateType: 'normal'
    },
    {
      cardId: 'card-creator-comments',
      cardFamily: 'customer_messages',
      title: 'Bình luận cần phản hồi & tương tác khán giả',
      description: '12 bình luận hỏi mua và quan tâm nội dung đang chờ tương tác trong Hộp thư.',
      primaryCtaLabel: 'Mở Unified Inbox',
      primaryCtaRoute: '/inbox',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Tương tác nhanh trong 1 giờ đầu giúp đẩy video vào luồng phân phối.',
      priorityRank: 5,
      moduleRef: 'M12',
      stateType: 'normal'
    },
    {
      cardId: 'card-creator-earnings',
      cardFamily: 'revenue_today',
      title: 'Thu nhập & hoa hồng ước tính hôm nay',
      description: 'Theo dõi doanh thu hoa hồng affiliate và thưởng hiệu suất từ các video đang phân phối.',
      primaryCtaLabel: 'Xem Sổ cái lợi nhuận',
      primaryCtaRoute: '/finance',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Nắm bắt thu nhập thực tế đã đối soát để tối ưu hóa nguồn lực sáng tạo.',
      priorityRank: 6,
      moduleRef: 'M19',
      stateType: 'normal'
    },
    {
      cardId: 'card-creator-repair',
      cardFamily: 'diagnostics_issues',
      title: 'Kiểm tra kết nối tài khoản & phân quyền',
      description: 'Toàn bộ tài khoản và kết nối nền tảng hoạt động bình thường.',
      primaryCtaLabel: 'Xem chẩn đoán hệ thống',
      primaryCtaRoute: '/settings/diagnostics',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Đảm bảo token kết nối luôn hợp lệ để không gián đoạn lịch đăng.',
      priorityRank: 7,
      moduleRef: 'M22',
      stateType: 'normal'
    }
  ],

  seller: [
    {
      cardId: 'card-seller-orders',
      cardFamily: 'order_queue',
      title: 'Hàng đợi đơn hàng cần xử lý',
      description: 'Kiểm tra và chuẩn bị hàng cho các đơn mới phát sinh để đáp ứng SLA sàn.',
      primaryCtaLabel: 'Mở danh sách đơn hàng',
      primaryCtaRoute: '/kinh-doanh',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'IMPORTED',
      confidence: 'HIGH',
      whyThisMatters: 'Giao hàng đúng SLA sàn để tránh phạt tỷ lệ trễ hạn.',
      priorityRank: 1,
      moduleRef: 'M13',
      stateType: 'normal'
    },
    {
      cardId: 'card-seller-revenue',
      cardFamily: 'revenue_today',
      title: 'Doanh thu bán hàng hôm nay',
      description: 'Theo dõi số liệu doanh số bán hàng và biên lợi nhuận từ các kênh liên kết.',
      primaryCtaLabel: 'Xem đối soát lợi nhuận',
      primaryCtaRoute: '/finance',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Đánh giá nhịp bán hàng và dòng tiền trong ngày.',
      priorityRank: 2,
      moduleRef: 'M19',
      stateType: 'normal'
    },
    {
      cardId: 'card-seller-stock',
      cardFamily: 'low_stock_alert',
      title: 'Cảnh báo tồn kho an toàn',
      description: 'Kiểm tra lượng tồn kho khả dụng và dự báo điểm đặt hàng lại cho các SKU bán chạy.',
      primaryCtaLabel: 'Kiểm tra kho hàng',
      primaryCtaRoute: '/kinh-doanh',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Tránh tình trạng đứt hàng khi chiến dịch quảng cáo đang chạy.',
      priorityRank: 3,
      moduleRef: 'M13',
      stateType: 'normal'
    },
    {
      cardId: 'card-seller-profit',
      cardFamily: 'profit_anomalies',
      title: 'Đối soát biên lợi nhuận & chi phí sàn',
      description: 'Phát hiện chênh lệch phí vận chuyển hoặc chiết khấu chưa khớp giữa sàn và sổ cái.',
      primaryCtaLabel: 'Xem phân tích lợi nhuận',
      primaryCtaRoute: '/finance',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Bảo vệ biên lợi nhuận ròng trước các loại phí sàn phát sinh bất ngờ.',
      priorityRank: 4,
      moduleRef: 'M19',
      stateType: 'normal'
    },
    {
      cardId: 'card-seller-messages',
      cardFamily: 'customer_messages',
      title: 'Hộp thư khách hàng & SLA phản hồi',
      description: 'Xử lý tin nhắn hỏi mua, đổi trả và tư vấn sản phẩm trước thời hạn SLA 15 phút.',
      primaryCtaLabel: 'Mở Hộp thư hợp nhất',
      primaryCtaRoute: '/inbox',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Phản hồi khách mua nhanh tăng tỷ lệ chốt đơn thêm 35%.',
      priorityRank: 5,
      moduleRef: 'M12',
      stateType: 'normal'
    }
  ],

  affiliate_operator: [
    {
      cardId: 'card-affiliate-links',
      cardFamily: 'link_health',
      title: 'Tình trạng liên kết tiếp thị (Link Health)',
      description: 'Kiểm tra tính khả dụng và chuyển hướng của 100% affiliate links đã phân phối.',
      primaryCtaLabel: 'Xem danh sách links',
      primaryCtaRoute: '/affiliates',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Link hỏng làm mất doanh thu hoa hồng ngay lập tức khi video lên xu hướng.',
      priorityRank: 1,
      moduleRef: 'M16',
      stateType: 'normal'
    },
    {
      cardId: 'card-affiliate-opportunities',
      cardFamily: 'top_opportunities',
      title: 'Cơ hội sản phẩm có độ khớp cao (High-Fit)',
      description: '5 sản phẩm xu hướng có hoa hồng 18-25% phù hợp với tệp khán giả kênh.',
      primaryCtaLabel: 'Khám phá cơ hội',
      primaryCtaRoute: '/kham-pha',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Lựa chọn sản phẩm có chuyển đổi cao tối ưu hóa doanh thu trên mỗi lượt xem.',
      priorityRank: 2,
      moduleRef: 'M04',
      stateType: 'normal'
    },
    {
      cardId: 'card-affiliate-offers',
      cardFamily: 'top_converting_offers',
      title: 'Ưu đãi có tỷ lệ chuyển đổi cao nhất',
      description: '3 ưu đãi độc quyền kèm coupon giảm giá đặc biệt đang hoạt động hiệu quả.',
      primaryCtaLabel: 'Lấy mã ưu đãi',
      primaryCtaRoute: '/offers',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Gắn ưu đãi độc quyền tăng tỷ lệ nhấp và chuyển đổi đơn hàng.',
      priorityRank: 3,
      moduleRef: 'M14',
      stateType: 'normal'
    },
    {
      cardId: 'card-affiliate-coupons',
      cardFamily: 'coupon_health',
      title: 'Mã giảm giá sắp hết hạn (Expiring Coupons)',
      description: '2 coupon tài trợ sẽ hết hạn trong 48 giờ tới, cần nhắc nhở người xem sử dụng.',
      primaryCtaLabel: 'Quản lý mã giảm giá',
      primaryCtaRoute: '/coupons',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Tạo cảm giác gấp gáp để thúc đẩy quyết định mua hàng chốt sale.',
      priorityRank: 4,
      moduleRef: 'M14',
      stateType: 'normal'
    },
    {
      cardId: 'card-affiliate-attribution',
      cardFamily: 'attributed_revenue',
      title: 'Doanh thu hoa hồng ghi nhận (Attributed Revenue)',
      description: 'Theo dõi số dư hoa hồng đã đối soát và sẵn sàng thanh toán.',
      primaryCtaLabel: 'Xem phân bổ hoa hồng',
      primaryCtaRoute: '/attribution',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Kiểm tra minh bạch dòng tiền hoa hồng đối soát từ các mạng tiếp thị.',
      priorityRank: 5,
      moduleRef: 'M16',
      stateType: 'normal'
    }
  ],

  live_operator: [
    {
      cardId: 'card-live-readiness',
      cardFamily: 'live_readiness',
      title: 'Checklist sẵn sàng phiên Live (War Room)',
      description: 'Kiểm tra đường truyền, kịch bản ghim sản phẩm và voucher tài trợ trước giờ live.',
      primaryCtaLabel: 'Mở War Room',
      primaryCtaRoute: '/live',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Chuẩn bị kỹ trước giờ phát sóng tránh sự cố kỹ thuật và tối ưu GMV phiên live.',
      priorityRank: 1,
      moduleRef: 'M17',
      stateType: 'normal'
    },
    {
      cardId: 'card-live-cue',
      cardFamily: 'cue_cards',
      title: 'Thẻ kịch bản & thứ tự ghim sản phẩm (Cue Cards)',
      description: 'Lịch trình 15 sản phẩm kèm thời điểm tung deal chớp nhoáng (Flash Sale) trong phiên live.',
      primaryCtaLabel: 'Xem kịch bản live',
      primaryCtaRoute: '/live',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Giữ nhịp điệu phiên live liền mạch và kích thích người xem đặt hàng đúng thời điểm.',
      priorityRank: 2,
      moduleRef: 'M17',
      stateType: 'normal'
    },
    {
      cardId: 'card-live-offers',
      cardFamily: 'pinned_offers',
      title: 'Sản phẩm ghim & Voucher độc quyền phiên live',
      description: 'Cấu hình số lượng tồn kho và mức giảm giá đặc biệt chỉ áp dụng trong livestream.',
      primaryCtaLabel: 'Thiết lập ưu đãi live',
      primaryCtaRoute: '/offers',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Ưu đãi độc quyền livestream là yếu tố quyết định chuyển đổi trực tiếp.',
      priorityRank: 3,
      moduleRef: 'M14',
      stateType: 'normal'
    },
    {
      cardId: 'card-live-comments',
      cardFamily: 'comment_surge',
      title: 'Điều phối bình luận & câu hỏi trực tiếp',
      description: 'Hàng đợi câu hỏi về size/màu sắc từ người xem cần người dẫn hoặc trợ lý giải đáp ngay.',
      primaryCtaLabel: 'Xem bình luận live',
      primaryCtaRoute: '/inbox',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Trả lời câu hỏi người xem ngay lập tức trên sóng tăng tỷ lệ chốt đơn.',
      priorityRank: 4,
      moduleRef: 'M12',
      stateType: 'normal'
    },
    {
      cardId: 'card-live-highlights',
      cardFamily: 'post_live_summary',
      title: 'Cắt khoảnh khắc nổi bật (Highlights) & Đánh giá sau live',
      description: 'Tự động trích xuất các khoảnh khắc nổ đơn cao điểm để tạo video ngắn phân phối lại.',
      primaryCtaLabel: 'Tạo clip nổi bật',
      primaryCtaRoute: '/studio',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Tái sử dụng nội dung live thành video ngắn kéo đơn hàng dài hạn sau buổi live.',
      priorityRank: 5,
      moduleRef: 'M09',
      stateType: 'normal'
    }
  ],

  agency_mcn: [
    {
      cardId: 'card-agency-approvals',
      cardFamily: 'pending_approvals',
      title: 'Hàng đợi phê duyệt kịch bản & video đối tác',
      description: '4 kịch bản và 2 video từ các creator trong mạng lưới đang chờ khách hàng duyệt.',
      primaryCtaLabel: 'Xem hàng đợi phê duyệt',
      primaryCtaRoute: '/workflows',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Bảo đảm chất lượng nội dung và đúng cam kết thương hiệu trước khi đăng tải.',
      priorityRank: 1,
      moduleRef: 'M20',
      stateType: 'normal'
    },
    {
      cardId: 'card-agency-diagnostics',
      cardFamily: 'diagnostics_issues',
      title: 'Chẩn đoán tình trạng đa workspace & Token',
      description: 'Kiểm tra trạng thái kết nối và phân quyền của 12 workspace khách hàng được quản lý.',
      primaryCtaLabel: 'Xem chẩn đoán hệ thống',
      primaryCtaRoute: '/settings/diagnostics',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Phát hiện sớm lỗi mất kết nối token để tránh gián đoạn tiến độ chiến dịch.',
      priorityRank: 2,
      moduleRef: 'M22',
      stateType: 'normal'
    },
    {
      cardId: 'card-agency-creators',
      cardFamily: 'creator_scorecards',
      title: 'Bảng điểm hiệu suất creator (Scorecards)',
      description: 'Đánh giá mức độ hoàn thành KPI, tỷ lệ đúng hạn và điểm chất lượng nội dung.',
      primaryCtaLabel: 'Xem danh sách creator',
      primaryCtaRoute: '/workspaces',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Phân bổ hợp đồng và ngân sách cho creator có hiệu suất cao nhất.',
      priorityRank: 3,
      moduleRef: 'M22',
      stateType: 'normal'
    },
    {
      cardId: 'card-agency-deliverables',
      cardFamily: 'at_risk_deliverables',
      title: 'Hạng mục bàn giao có rủi ro trễ hạn',
      description: '1 video tài trợ cần giao khách hàng trong vòng 24 giờ tới đang ở khâu dựng.',
      primaryCtaLabel: 'Xử lý tiến độ bàn giao',
      primaryCtaRoute: '/campaigns',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Đảm bảo SLA bàn giao với nhãn hàng để duy trì quan hệ đối tác lâu dài.',
      priorityRank: 4,
      moduleRef: 'M14',
      stateType: 'normal'
    },
    {
      cardId: 'card-agency-reports',
      cardFamily: 'report_deadlines',
      title: 'Báo cáo định kỳ cho khách hàng & nhãn hàng',
      description: 'Tổng hợp số liệu tiếp cận, lượt xem và chuyển đổi cho báo cáo tuần của chiến dịch.',
      primaryCtaLabel: 'Xuất báo cáo đối tác',
      primaryCtaRoute: '/creator-pro',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Minh bạch số liệu hiệu quả giúp gia hạn hợp đồng quản lý với khách hàng.',
      priorityRank: 5,
      moduleRef: 'S16',
      stateType: 'normal'
    }
  ],

  brand_collaboration: [
    {
      cardId: 'card-brand-inquiries',
      cardFamily: 'sponsor_inquiries',
      title: 'Yêu cầu hợp tác & booking tài trợ mới',
      description: 'Kiểm tra các lời mời hợp tác từ nhãn hàng gửi vào hộp thư.',
      primaryCtaLabel: 'Mở danh sách booking',
      primaryCtaRoute: '/creator-pro',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Phản hồi nhãn hàng nhanh trong 24h giúp giữ deal giá trị cao.',
      priorityRank: 1,
      moduleRef: 'S16',
      stateType: 'normal'
    },
    {
      cardId: 'card-brand-deliverables',
      cardFamily: 'deliverable_deadlines',
      title: 'Hạn chót bàn giao nội dung tài trợ (Deadlines)',
      description: '2 bài đăng sponsored post đã được duyệt, chuẩn bị lên sóng theo lịch cam kết.',
      primaryCtaLabel: 'Kiểm tra lịch phát sóng',
      primaryCtaRoute: '/xuat-ban',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Tuân thủ đúng khung giờ cam kết trong hợp đồng tài trợ thương hiệu.',
      priorityRank: 2,
      moduleRef: 'M11',
      stateType: 'normal'
    },
    {
      cardId: 'card-brand-proof',
      cardFamily: 'proof_bundles',
      title: 'Gói chứng nhận kết quả nghiệm thu (Proof Bundles)',
      description: 'Tập hợp ảnh chụp màn hình chỉ số, link bài đăng và xác nhận đối soát lượt xem.',
      primaryCtaLabel: 'Tạo gói nghiệm thu',
      primaryCtaRoute: '/seeding',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Bằng chứng nghiệm thu đầy đủ giúp giải ngân hợp đồng tài trợ nhanh chóng.',
      priorityRank: 3,
      moduleRef: 'M18',
      stateType: 'normal'
    },
    {
      cardId: 'card-brand-invoices',
      cardFamily: 'payout_tracking',
      title: 'Theo dõi thanh toán hợp đồng & Giải ngân (Payouts)',
      description: '1 hóa đơn thanh toán đợt 2 của nhãn hàng đang chờ đối soát tài khoản.',
      primaryCtaLabel: 'Kiểm tra tiến độ thanh toán',
      primaryCtaRoute: '/finance',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Đảm bảo đối soát chính xác các đợt thanh toán từ đối tác thương hiệu.',
      priorityRank: 4,
      moduleRef: 'M19',
      stateType: 'normal'
    },
    {
      cardId: 'card-brand-evidence',
      cardFamily: 'performance_evidence',
      title: 'Bằng chứng chuyển đổi & ROI chiến dịch',
      description: 'Báo cáo phân bổ đơn hàng và tỷ lệ chuyển đổi mã giảm giá tài trợ độc quyền.',
      primaryCtaLabel: 'Xem bằng chứng ROI',
      primaryCtaRoute: '/attribution',
      isActionAvailable: true,
      unavailableReason: '',
      dataSource: 'OFFICIAL',
      confidence: 'HIGH',
      whyThisMatters: 'Chứng minh ROI thực tế là chìa khóa để ký hợp đồng tài trợ dài hạn.',
      priorityRank: 5,
      moduleRef: 'M16',
      stateType: 'normal'
    }
  ]
};

/**
 * Standard 5-Step Operating Loop Onboarding Definitions
 */
export const CANONICAL_ONBOARDING_STEPS: readonly Omit<WebOnboardingStep, 'isCompleted'>[] = [
  {
    stepNumber: 1,
    stepKey: 'connect_data',
    title: '1. Kết nối kênh bán hoặc nhập tệp dữ liệu mẫu',
    description: 'Kết nối TikTok Shop / Shopee hoặc nhập tệp CSV đơn hàng & chi phí mẫu.',
    isAvailable: true
  },
  {
    stepNumber: 2,
    stepKey: 'select_offer',
    title: '2. Tạo danh mục hoặc chọn sản phẩm kinh doanh',
    description: 'Chọn sản phẩm chủ lực hoặc thiết lập ưu đãi độc quyền trên Product Hub (M13).',
    isAvailable: true
  },
  {
    stepNumber: 3,
    stepKey: 'create_content',
    title: '3. Tạo kịch bản & sản xuất video AI đầu tiên',
    description: 'Tự động tạo kịch bản viral và sản xuất video ngắn bằng AI Video Studio (M07).',
    isAvailable: true
  },
  {
    stepNumber: 4,
    stepKey: 'publish',
    title: '4. Lên lịch & xuất bản đa kênh chuẩn giờ vàng',
    description: 'Phân phối đồng thời lên TikTok, Reels và YouTube Shorts bằng Publish Hub (M11).',
    isAvailable: true
  },
  {
    stepNumber: 5,
    stepKey: 'track_outcome',
    title: '5. Đối soát doanh số & đo lường biên lợi nhuận ròng',
    description: 'Theo dõi báo cáo đối soát doanh thu, chi phí và chứng từ trên Sổ cái (M19).',
    isAvailable: true
  }
];

/**
 * Evaluates onboarding state with strict distinction between first-value and closed-loop completion.
 */
export function evaluateOnboardingState(completedStepNumbers: number[]): WebOnboardingProgress {
  const completedSet = new Set(completedStepNumbers);
  const steps: WebOnboardingStep[] = CANONICAL_ONBOARDING_STEPS.map((def) => ({
    ...def,
    isCompleted: completedSet.has(def.stepNumber)
  }));

  const completedCount = steps.filter((s) => s.isCompleted).length;
  // First-value is achieved when Step 1 (connect/import) is done
  const isFirstValueComplete = completedSet.has(1);
  // Full-loop completion requires all 5 steps
  const isClosedLoopComplete = completedCount === 5;

  return {
    steps,
    completedCount,
    totalSteps: 5,
    isFirstValueComplete,
    isClosedLoopComplete
  };
}

// ============================================================================
// P8-09 Full-Scope Platform Acceptance & Release Decision Engine
// ============================================================================

export interface WebFullScopeAcceptanceVerdict {
  isReadyLocal: boolean;
  totalModules: number;
  totalModes: number;
  totalTasks: number;
  unmetExternalGatesCount: number;
  externalGates: string[];
  releaseDecision: 'CONDITIONAL_READY_LOCAL' | 'RELEASE_BLOCKED' | 'LAUNCH_APPROVED';
  productionLaunchApproved: boolean;
  summary: string;
}

/**
 * Evaluates full-scope platform acceptance across all 31 modules, 6 operator modes,
 * 60 build tasks, and explicit external launch gates for Web Decision Engine.
 */
export function evaluateWebFullScopeReleaseDecision(params: {
  auditedModuleCount: number;
  auditedModeCount: number;
  verifiedTaskCount: number;
  untrackedRemainingScopeCount: number;
  openExternalGatesCount: number;
  assertProductionLaunch: boolean;
}): WebFullScopeAcceptanceVerdict {
  const isComplete =
    params.auditedModuleCount === 31 &&
    params.auditedModeCount === 6 &&
    params.verifiedTaskCount >= 60 &&
    params.untrackedRemainingScopeCount === 0;

  if (!isComplete) {
    return {
      isReadyLocal: false,
      totalModules: params.auditedModuleCount,
      totalModes: params.auditedModeCount,
      totalTasks: params.verifiedTaskCount,
      unmetExternalGatesCount: params.openExternalGatesCount,
      externalGates: ['UNRESOLVED_SCOPE: Phạm vi chưa hoàn tất'],
      releaseDecision: 'RELEASE_BLOCKED',
      productionLaunchApproved: false,
      summary: 'Nghiệm thu toàn diện bị chặn: thiếu module, chế độ vận hành hoặc còn tồn đọng phạm vi.'
    };
  }

  if (params.assertProductionLaunch && params.openExternalGatesCount > 0) {
    return {
      isReadyLocal: true,
      totalModules: 31,
      totalModes: 6,
      totalTasks: 60,
      unmetExternalGatesCount: params.openExternalGatesCount,
      externalGates: ['EXT-GATES: Còn cổng pháp lý / đối tác chưa mở'],
      releaseDecision: 'RELEASE_BLOCKED',
      productionLaunchApproved: false,
      summary: 'Không được phép công bố phát hành sản xuất khi cổng đối tác và pháp lý bên ngoài chưa đáp ứng.'
    };
  }

  return {
    isReadyLocal: true,
    totalModules: 31,
    totalModes: 6,
    totalTasks: 60,
    unmetExternalGatesCount: params.openExternalGatesCount,
    externalGates: [
      'LEG-H-001: Ký duyệt pháp lý độc lập (PDPA/GDPR/DMCA)',
      'EXT-GATE-LIVE-PROVIDER: Phê duyệt từ đối tác TikTok/Shopee/Meta/YouTube',
      'EXT-GATE-STAGING-DR: Rehearsal DR trên staging VPS'
    ],
    releaseDecision: 'CONDITIONAL_READY_LOCAL',
    productionLaunchApproved: false,
    summary: 'Toàn bộ 31 module, 6 chế độ và 60 task đã đối soát đầy đủ. Sẵn sàng cho môi trường thử nghiệm và local (CONDITIONAL_READY_LOCAL).'
  };
}
