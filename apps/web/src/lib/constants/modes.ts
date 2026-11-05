/**
 * Six Canonical Operator Modes for Creativanta Trend-to-Profit OS
 * Per docs/02_features/platform/home_decision_engine.md and Pack 01 §S05.1.
 */

import { writable } from 'svelte/store';

export type OperatorModeId =
  | 'creator'
  | 'seller'
  | 'affiliate_operator'
  | 'live_operator'
  | 'agency_mcn'
  | 'brand_collaboration';

export interface OperatorModeDef {
  id: OperatorModeId;
  name: string;
  shortLabel: string;
  tagline: string;
  description: string;
  icon: string;
  primaryModule: string;
  priorityBrief: string;
  focusMetrics: string[];
}

export const OPERATOR_MODES: readonly OperatorModeDef[] = [
  {
    id: 'creator',
    name: 'Solo Creator',
    shortLabel: 'Creator',
    tagline: 'Sáng tạo nội dung & thương hiệu cá nhân',
    description: 'Tập trung sáng tạo kịch bản, sản xuất video AI, bảo vệ bản quyền và phát triển quan hệ hợp tác nhãn hàng.',
    icon: 'sparkles',
    primaryModule: 'M05-M10',
    priorityBrief: 'Xu hướng âm thanh hot & 3 ý tưởng video AI có tỷ lệ viral cao nhất hôm nay.',
    focusMetrics: ['Lượt xem video 24h', 'Tỷ lệ xem hết (Completion Rate)', 'AI Credit khả dụng']
  },
  {
    id: 'seller',
    name: 'Seller / Nhà bán hàng',
    shortLabel: 'Seller',
    tagline: 'Vận hành shop đa sàn & tối ưu chuyển đổi',
    description: 'Tối ưu danh mục sản phẩm, theo dõi đơn hàng, xử lý tồn kho và giải quyết khiếu nại khách hàng.',
    icon: 'store',
    primaryModule: 'M13-M19',
    priorityBrief: 'Cảnh báo 12 đơn hàng sắp chạm trần SLA sàn và 2 mã SKU bán chạy sắp hết hàng.',
    focusMetrics: ['Doanh thu gộp thực tế (GMV)', 'Đơn hàng cần xử lý', 'Tỷ lệ hoàn hàng (Return Rate)']
  },
  {
    id: 'affiliate_operator',
    name: 'Affiliate Operator',
    shortLabel: 'Affiliate',
    tagline: 'Tiếp thị liên kết & tối ưu hoa hồng',
    description: 'Tuyển chọn deal hoa hồng cao, quản trị link tracking đa kênh, đối soát hoa hồng và phát hiện link gãy.',
    icon: 'link',
    primaryModule: 'M15-M18',
    priorityBrief: '4 deal hoa hồng độc quyền mới và 1 link affiliate Shopee bị báo lỗi 404 cần sửa.',
    focusMetrics: ['Hoa hồng tạm tính (Estimated Commission)', 'Số click chuyển đổi', 'Link cần sửa (Broken Links)']
  },
  {
    id: 'live_operator',
    name: 'Live Operator',
    shortLabel: 'Live Stream',
    tagline: 'Vận hành phiên live & chốt đơn tức thì',
    description: 'Chuẩn bị kịch bản phiên live, sắp xếp deal ghim flash sale, điều phối trợ lý live và đối soát doanh số trực tiếp.',
    icon: 'video-camera',
    primaryModule: 'M11-M14',
    priorityBrief: 'Kịch bản live 20:00 tối nay đã sẵn sàng 8 deal flash sale độc quyền.',
    focusMetrics: ['Doanh số phiên live gần nhất', 'Mắt xem đỉnh điểm (Peak CCU)', 'Tỷ lệ chốt giỏ hàng (Conversion)']
  },
  {
    id: 'agency_mcn',
    name: 'Agency / MCN',
    shortLabel: 'Agency / MCN',
    tagline: 'Quản trị mạng lưới đa creator & nhãn hàng',
    description: 'Phân quyền đội ngũ, giám sát KPI creator, quản trị chiến dịch tổng hợp và chia sẻ doanh thu minh bạch.',
    icon: 'users',
    primaryModule: 'M20-M23',
    priorityBrief: '3 chiến dịch chuẩn bị nghiệm thu giai đoạn 1 và 5 creator chưa gửi link bài nghiệm thu.',
    focusMetrics: ['Tổng GMV mạng lưới', 'Creator đang hoạt động', 'Chiến dịch đang chạy']
  },
  {
    id: 'brand_collaboration',
    name: 'Brand Collaboration',
    shortLabel: 'Brand',
    tagline: 'Booking KOC & đo lường hiệu quả chiến dịch',
    description: 'Tìm kiếm KOC phù hợp tệp khách hàng, duyệt brief sáng tạo, cấp mã giảm giá độc quyền và đo lường ROI chi tiết.',
    icon: 'shield-check',
    primaryModule: 'M17-M22',
    priorityBrief: '6 kịch bản video từ KOC chờ nhãn hàng duyệt trước 15:00 để kịp lịch đăng.',
    focusMetrics: ['ROI chiến dịch', 'KOC tham gia', 'Brief chờ duyệt']
  }
] as const;

export const DEFAULT_OPERATOR_MODE: OperatorModeId = 'creator';

export const OPERATOR_MODE_STORAGE_KEY = 'creativanta_operator_mode';
export const LEGACY_ACTIVE_MODE_STORAGE_KEY = 'creativanta_active_mode';

export function isValidOperatorModeId(value: unknown): value is OperatorModeId {
  return typeof value === 'string' && OPERATOR_MODES.some((m) => m.id === value);
}

export function readPersistedOperatorMode(): OperatorModeId {
  if (typeof localStorage === 'undefined') {
    return DEFAULT_OPERATOR_MODE;
  }
  try {
    const primary = localStorage.getItem(OPERATOR_MODE_STORAGE_KEY);
    if (isValidOperatorModeId(primary)) {
      return primary;
    }
    const secondary = localStorage.getItem(LEGACY_ACTIVE_MODE_STORAGE_KEY);
    if (isValidOperatorModeId(secondary)) {
      return secondary;
    }
  } catch {
    // ignore storage errors
  }
  return DEFAULT_OPERATOR_MODE;
}

export function persistOperatorMode(mode: OperatorModeId): void {
  if (typeof localStorage === 'undefined') {
    return;
  }
  try {
    localStorage.setItem(OPERATOR_MODE_STORAGE_KEY, mode);
    localStorage.setItem(LEGACY_ACTIVE_MODE_STORAGE_KEY, mode);
  } catch {
    // ignore storage errors
  }
}

function createModeStore() {
  const initial: OperatorModeId = readPersistedOperatorMode();
  const { subscribe, set } = writable<OperatorModeId>(initial);

  return {
    subscribe,
    setMode: (mode: OperatorModeId) => {
      if (!isValidOperatorModeId(mode)) {
        return;
      }
      persistOperatorMode(mode);
      set(mode);
    },
    syncFromStorage: (): OperatorModeId => {
      const mode = readPersistedOperatorMode();
      persistOperatorMode(mode);
      set(mode);
      return mode;
    },
    getModeDef: (modeId: OperatorModeId): OperatorModeDef => {
      return OPERATOR_MODES.find((m) => m.id === modeId) || OPERATOR_MODES[0];
    }
  };
}

export const modeStore = createModeStore();
