<script lang="ts">
  import {
    notificationStore,
    isNotificationDrawerOpen,
    activeNotifications,
    unreadCount,
    urgentCount,
    type ScopedNotification
  } from '$lib/notification/store';

  let filterTab: 'all' | 'unread' | 'urgent' = $state('all');

  let notifs = $derived($activeNotifications);

  let filteredList = $derived(
    notifs.filter((n) => {
      if (filterTab === 'unread') return !n.readAt;
      if (filterTab === 'urgent') return n.priority === 'urgent';
      return true;
    })
  );

  function handleKeydown(event: KeyboardEvent) {
    if (event.key === 'Escape') {
      isNotificationDrawerOpen.set(false);
    }
  }

  function formatTime(iso: string) {
    try {
      const d = new Date(iso);
      return d.toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' }) + ' ' +
             d.toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit' });
    } catch {
      return iso;
    }
  }

  function getPriorityBadge(priority: string) {
    switch (priority) {
      case 'urgent':
        return { label: 'Khẩn cấp', class: 'bg-[#d94a31] text-[#ffffff]' };
      case 'high':
        return { label: 'Cao', class: 'bg-[#fbeee9] text-[#d94a31] border border-[#d94a31]/30' };
      case 'normal':
        return { label: 'Bình thường', class: 'bg-[#f4f0e8] text-[#274333]' };
      case 'low':
      default:
        return { label: 'Tham khảo', class: 'bg-[#f4f0e8] text-[#616c63]' };
    }
  }
</script>

<svelte:window onkeydown={handleKeydown} />

{#if $isNotificationDrawerOpen}
  <!-- Backdrop -->
  <div
    class="fixed inset-0 z-40 bg-black/40 backdrop-blur-xs transition-opacity"
    onclick={() => isNotificationDrawerOpen.set(false)}
    onkeydown={(e) => e.key === 'Escape' && isNotificationDrawerOpen.set(false)}
    role="button"
    tabindex="0"
    aria-label="Đóng thông báo"
  ></div>

  <!-- Slide-over Drawer Panel -->
  <div
    class="fixed inset-y-0 right-0 z-50 flex w-full max-w-md flex-col bg-[#fbf9f5] border-l border-[#e7e2d7] shadow-2xl transition-transform"
    role="dialog"
    aria-modal="true"
    aria-labelledby="notification-drawer-title"
  >
    <!-- Drawer Header -->
    <div class="flex items-center justify-between border-b border-[#e7e2d7] px-5 py-4 bg-[#ffffff]">
      <div class="flex items-center gap-2.5">
        <h2 id="notification-drawer-title" class="text-base font-bold text-[#242924]">
          Trung tâm thông báo
        </h2>
        {#if $unreadCount > 0}
          <span class="rounded-full bg-[#d94a31] px-2 py-0.5 text-xs font-semibold text-[#ffffff]">
            {$unreadCount} mới
          </span>
        {/if}
      </div>

      <button
        type="button"
        onclick={() => isNotificationDrawerOpen.set(false)}
        class="rounded-md p-1.5 text-[#616c63] hover:bg-[#f4f0e8] hover:text-[#242924] focus:outline-hidden focus:ring-2 focus:ring-[#274333]"
        aria-label="Đóng cửa sổ thông báo"
      >
        <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
        </svg>
      </button>
    </div>

    <!-- Filter Tabs & Actions -->
    <div class="flex items-center justify-between border-b border-[#e7e2d7] px-5 py-2.5 bg-[#fbf9f5]">
      <div class="flex items-center gap-1.5 text-xs">
        <button
          type="button"
          onclick={() => filterTab = 'all'}
          class="rounded px-2.5 py-1 font-medium transition-colors {filterTab === 'all' ? 'bg-[#274333] text-[#ffffff]' : 'text-[#616c63] hover:bg-[#f4f0e8]'}"
        >
          Tất cả ({notifs.length})
        </button>
        <button
          type="button"
          onclick={() => filterTab = 'unread'}
          class="rounded px-2.5 py-1 font-medium transition-colors {filterTab === 'unread' ? 'bg-[#274333] text-[#ffffff]' : 'text-[#616c63] hover:bg-[#f4f0e8]'}"
        >
          Chưa đọc ({$unreadCount})
        </button>
        {#if $urgentCount > 0}
          <button
            type="button"
            onclick={() => filterTab = 'urgent'}
            class="rounded px-2.5 py-1 font-medium transition-colors {filterTab === 'urgent' ? 'bg-[#d94a31] text-[#ffffff]' : 'text-[#d94a31] hover:bg-[#fbeee9]'}"
          >
            Khẩn cấp ({$urgentCount})
          </button>
        {/if}
      </div>

      {#if $unreadCount > 0}
        <button
          type="button"
          onclick={() => notificationStore.markAllRead()}
          class="text-xs font-semibold text-[#274333] hover:underline cursor-pointer"
        >
          Đọc tất cả
        </button>
      {/if}
    </div>

    <!-- Notification List Content -->
    <div class="flex-1 overflow-y-auto p-4 space-y-3">
      {#if filteredList.length === 0}
        <div class="py-16 text-center">
          <div class="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-[#f4f0e8] text-[#616c63]">
            <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
            </svg>
          </div>
          <p class="mt-3 text-sm font-medium text-[#242924]">Không có thông báo nào</p>
          <p class="mt-1 text-xs text-[#616c63]">Bạn đã xử lý xong toàn bộ cảnh báo và cập nhật quan trọng.</p>
        </div>
      {:else}
        {#each filteredList as item (item.id)}
          {@const badge = getPriorityBadge(item.priority)}
          <div
            class="relative rounded-lg border p-4 transition-all duration-150 {item.readAt ? 'bg-[#ffffff] border-[#e7e2d7] opacity-80' : 'bg-[#ffffff] border-[#274333]/30 shadow-xs ring-1 ring-[#274333]/10'}"
          >
            <!-- Header of card -->
            <div class="flex items-start justify-between gap-2">
              <div class="flex items-center gap-2">
                <span class="rounded px-2 py-0.5 text-[10px] font-semibold {badge.class}">
                  {badge.label}
                </span>
                {#if item.moduleRef}
                  <span class="rounded bg-[#f4f0e8] px-1.5 py-0.5 text-[10px] font-mono font-medium text-[#616c63]">
                    {item.moduleRef}
                  </span>
                {/if}
              </div>

              <span class="text-[11px] text-[#616c63]">
                {formatTime(item.createdAt)}
              </span>
            </div>

            <!-- Body -->
            <div class="mt-2">
              <h3 class="text-sm font-semibold text-[#242924] leading-snug">
                {item.title}
              </h3>
              <p class="mt-1 text-xs text-[#616c63] leading-relaxed">
                {item.body}
              </p>
            </div>

            <!-- Actions -->
            <div class="mt-3 flex items-center justify-between pt-2 border-t border-[#f4f0e8]">
              <div class="flex items-center gap-2">
                {#if item.actionLabel && item.actionUrl}
                  <a
                    href={item.actionUrl}
                    onclick={() => {
                      notificationStore.markRead(item.id);
                      isNotificationDrawerOpen.set(false);
                    }}
                    class="rounded bg-[#274333] px-2.5 py-1 text-xs font-medium text-[#ffffff] hover:bg-[#1f3629] transition-colors"
                  >
                    {item.actionLabel}
                  </a>
                {/if}
                {#if !item.readAt}
                  <button
                    type="button"
                    onclick={() => notificationStore.markRead(item.id)}
                    class="rounded border border-[#e7e2d7] px-2 py-1 text-xs font-medium text-[#616c63] hover:bg-[#f4f0e8] transition-colors"
                  >
                    Đã đọc
                  </button>
                {/if}
              </div>

              <button
                type="button"
                onclick={() => notificationStore.dismiss(item.id)}
                class="text-xs text-[#616c63] hover:text-[#d94a31] transition-colors"
                title="Bỏ qua thông báo"
              >
                Bỏ qua
              </button>
            </div>
          </div>
        {/each}
      {/if}
    </div>

    <!-- Drawer Footer -->
    <div class="border-t border-[#e7e2d7] bg-[#ffffff] p-3 text-center text-xs text-[#616c63]">
      <p>Thông báo được đồng bộ theo Workspace và tài khoản đã xác thực.</p>
    </div>
  </div>
{/if}
