export {
  OPERATOR_MODES,
  DEFAULT_OPERATOR_MODE,
  modeStore,
  type OperatorModeId,
  type OperatorModeDef
} from './modes';
export interface NavItem {
  id: 'overview' | 'explore' | 'create' | 'publish' | 'commerce';
  label: string;
  href: string;
  badge?: string;
  description: string;
  moduleRef: string;
}

export const JOB_NAV_ITEMS: readonly NavItem[] = [
  {
    id: 'overview',
    label: 'Tổng quan',
    href: '/',
    description: 'Hệ thống quyết định vận hành hằng ngày & nhịp việc ưu tiên',
    moduleRef: 'M01'
  },
  {
    id: 'explore',
    label: 'Khám phá',
    href: '/kham-pha',
    description: 'Trend Fusion Radar & phân tích đối thủ cạnh tranh',
    moduleRef: 'M02-M04'
  },
  {
    id: 'create',
    label: 'Sáng tạo',
    href: '/sang-tao',
    description: 'Idea Engine, Script Lab & AI Video Studio',
    moduleRef: 'M05-M10'
  },
  {
    id: 'publish',
    label: 'Xuất bản',
    href: '/xuat-ban',
    description: 'Publish Hub, Unified Inbox & phân phối đa kênh',
    moduleRef: 'M11-M12'
  },
  {
    id: 'commerce',
    label: 'Kinh doanh',
    href: '/kinh-doanh',
    description: 'Sổ cái vận hành, đơn hàng, affiliate & lợi nhuận thực tế',
    moduleRef: 'M13-M19'
  }
] as const;

export interface UnsupportedCapabilityNotice {
  domain: string;
  feature: string;
  status: 'UNAVAILABLE_P0' | 'REQUIRES_BACKEND_P0_02' | 'REQUIRES_IAM_P0_03';
  explanation: string;
}

export const P0_UNSUPPORTED_FEATURES: readonly UnsupportedCapabilityNotice[] = [
  {
    domain: 'Auth & Session',
    feature: 'Clerk / OAuth Integration',
    status: 'REQUIRES_IAM_P0_03',
    explanation: 'Chế độ Shell khách. Xác thực Clerk/MFA và phiên định danh chưa kết nối trong P0-01.'
  },
  {
    domain: 'Transport',
    feature: 'ConnectRPC Live Transport',
    status: 'REQUIRES_BACKEND_P0_02',
    explanation: 'RPC clients và Proto handlers đang chờ hoàn thiện ở P0-02; giao diện hiện chạy ở trạng thái tĩnh trung thực.'
  },
  {
    domain: 'Finance & Payments',
    feature: 'Cổng thanh toán Stripe & VNPay',
    status: 'UNAVAILABLE_P0',
    explanation: 'Hệ thống kế toán và cổng thanh toán chưa kết nối. Tuyệt đối không giả lập giao dịch tiền tệ.'
  },
  {
    domain: 'External Connectors',
    feature: 'TikTok, Shopee, YouTube, Meta Sync',
    status: 'UNAVAILABLE_P0',
    explanation: 'Kênh connector mạng xã hội và sàn thương mại điện tử chưa kết nối adapter.'
  }
] as const;
