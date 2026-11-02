/**
 * Scoped Notifications Store for Creativanta Go V5
 * Per docs/04_contracts/database_schema.md §13.5 and Pack 01 §S05.1.
 */

import { writable, derived } from 'svelte/store';

export type NotificationPriority = 'urgent' | 'high' | 'normal' | 'low';
export type NotificationChannel = 'in_app' | 'push' | 'email';

export interface ScopedNotification {
  id: string;
  workspaceId: string;
  userId: string;
  priority: NotificationPriority;
  channel: NotificationChannel;
  title: string;
  body: string;
  deepLink?: string;
  actionLabel?: string;
  actionUrl?: string;
  createdAt: string;
  readAt?: string | null;
  dismissedAt?: string | null;
  moduleRef?: string;
}

const INITIAL_NOTIFICATIONS: ScopedNotification[] = [
  {
    id: 'notif-001',
    workspaceId: 'ws-demo',
    userId: 'user-demo',
    priority: 'urgent',
    channel: 'in_app',
    title: 'Cảnh báo vi phạm SLA xử lý đơn hàng (M19)',
    body: 'Có 3 đơn hàng Shopee đã quá hạn xử lý 18 giờ. Cần xác nhận gửi hàng trước 16:00 hôm nay để tránh điểm phạt sàn.',
    deepLink: '/kinh-doanh',
    actionLabel: 'Xử lý đơn hàng',
    actionUrl: '/kinh-doanh',
    createdAt: new Date(Date.now() - 1000 * 60 * 35).toISOString(),
    readAt: null,
    dismissedAt: null,
    moduleRef: 'M19'
  },
  {
    id: 'notif-002',
    workspaceId: 'ws-demo',
    userId: 'user-demo',
    priority: 'high',
    channel: 'in_app',
    title: 'Cần cấp lại quyền tài khoản TikTok Shop (M11)',
    body: 'Token kết nối kênh TikTok Shop hết hạn sau 30 ngày. Vui lòng cấp lại quyền để không gián đoạn đồng bộ kịch bản và sản phẩm.',
    deepLink: '/settings/connections',
    actionLabel: 'Cấp lại quyền',
    actionUrl: '/settings/connections',
    createdAt: new Date(Date.now() - 1000 * 60 * 120).toISOString(),
    readAt: null,
    dismissedAt: null,
    moduleRef: 'M11'
  },
  {
    id: 'notif-003',
    workspaceId: 'ws-demo',
    userId: 'user-demo',
    priority: 'normal',
    channel: 'in_app',
    title: 'Bài viết trung tâm trợ giúp mới: Tối ưu kịch bản AI Video Studio',
    body: 'Tài liệu hướng dẫn kỹ thuật viết prompt viral và cách gắn thẻ CTA tăng tỷ lệ chuyển đổi cho nhà sáng tạo.',
    deepLink: '#help',
    actionLabel: 'Đọc tài liệu',
    createdAt: new Date(Date.now() - 1000 * 60 * 360).toISOString(),
    readAt: null,
    dismissedAt: null,
    moduleRef: 'M07'
  },
  {
    id: 'notif-004',
    workspaceId: 'ws-demo',
    userId: 'user-demo',
    priority: 'low',
    channel: 'in_app',
    title: 'Báo cáo tóm tắt tuần đã sẵn sàng (M01)',
    body: 'Báo cáo chỉ số tăng trưởng tuần qua đã được tổng hợp xong trong Morning Brief.',
    deepLink: '/',
    actionLabel: 'Xem tóm tắt',
    createdAt: new Date(Date.now() - 1000 * 60 * 1440).toISOString(),
    readAt: new Date(Date.now() - 1000 * 60 * 720).toISOString(),
    dismissedAt: null,
    moduleRef: 'M01'
  }
];

export const isNotificationDrawerOpen = writable<boolean>(false);

function createNotificationStore() {
  const { subscribe, update, set } = writable<ScopedNotification[]>(INITIAL_NOTIFICATIONS);

  return {
    subscribe,
    isOpen: {
      subscribe: isNotificationDrawerOpen.subscribe,
      open: () => isNotificationDrawerOpen.set(true),
      close: () => isNotificationDrawerOpen.set(false),
      toggle: () => isNotificationDrawerOpen.update((v) => !v)
    },
    markRead: (id: string) => {
      update((list) =>
        list.map((n) => (n.id === id ? { ...n, readAt: new Date().toISOString() } : n))
      );
    },
    markAllRead: () => {
      const now = new Date().toISOString();
      update((list) => list.map((n) => ({ ...n, readAt: n.readAt || now })));
    },
    dismiss: (id: string) => {
      const now = new Date().toISOString();
      update((list) =>
        list.map((n) => (n.id === id ? { ...n, dismissedAt: now } : n))
      );
    },
    addNotification: (notif: ScopedNotification) => {
      update((list) => [notif, ...list]);
    },
    reset: () => set(INITIAL_NOTIFICATIONS)
  };
}

export const notificationStore = createNotificationStore();

export const activeNotifications = derived(notificationStore, ($list) =>
  $list.filter((n) => !n.dismissedAt)
);

export const unreadCount = derived(activeNotifications, ($list) =>
  $list.filter((n) => !n.readAt).length
);

export const urgentCount = derived(activeNotifications, ($list) =>
  $list.filter((n) => !n.readAt && n.priority === 'urgent').length
);
