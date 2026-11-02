import { describe, expect, it, beforeEach } from 'vitest';
import { get } from 'svelte/store';
import {
  notificationStore,
  activeNotifications,
  unreadCount,
  urgentCount
} from './store';

describe('Scoped Notifications Store (M01 / §13.5)', () => {
  beforeEach(() => {
    notificationStore.reset();
  });

  it('initializes with seed scoped notifications', () => {
    const list = get(activeNotifications);
    expect(list.length).toBeGreaterThanOrEqual(3);
  });

  it('calculates unread count and urgent count properly', () => {
    const unread = get(unreadCount);
    const urgent = get(urgentCount);

    expect(unread).toBeGreaterThan(0);
    expect(urgent).toBeGreaterThanOrEqual(1);
  });

  it('marks a notification as read', () => {
    const unreadBefore = get(unreadCount);

    notificationStore.markRead('notif-001');

    const unreadAfter = get(unreadCount);
    expect(unreadAfter).toBe(unreadBefore - 1);
  });

  it('marks all notifications as read', () => {
    notificationStore.markAllRead();

    const unread = get(unreadCount);
    expect(unread).toBe(0);
  });

  it('dismisses a notification and excludes it from active list', () => {
    const totalBefore = get(activeNotifications).length;

    notificationStore.dismiss('notif-002');

    const totalAfter = get(activeNotifications).length;
    expect(totalAfter).toBe(totalBefore - 1);
  });

  it('controls drawer open and close states', () => {
    let open = false;
    const unsub = notificationStore.isOpen.subscribe((v) => (open = v));

    expect(open).toBe(false);
    notificationStore.isOpen.open();
    expect(open).toBe(true);
    notificationStore.isOpen.close();
    expect(open).toBe(false);
    notificationStore.isOpen.toggle();
    expect(open).toBe(true);

    unsub();
  });
});
