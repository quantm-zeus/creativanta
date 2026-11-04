<script lang="ts">
  import {
    statusStore,
    type StatusComponent,
    type StatusIncident
  } from '$lib/help/store';

  const components = statusStore.components;
  const incidents = statusStore.incidents;
  const subscriberCount = statusStore.subscriberCount;

  let subscribeChannel: 'email' | 'webhook' = 'email';
  let subscribeTarget = '';
  let generatedPrivacyToken: string | null = null;
  let unsubscribeToken = '';
  let unsubscribeSuccess = false;
  let subscribeError = '';

  $: allOperational = $components.every((c) => c.status === 'operational');

  function handleSubscribe() {
    subscribeError = '';
    generatedPrivacyToken = null;
    try {
      const res = statusStore.subscribe(subscribeChannel, subscribeTarget);
      generatedPrivacyToken = res.privacyToken;
      subscribeTarget = '';
    } catch (err: any) {
      subscribeError = err.message || 'Lỗi đăng ký';
    }
  }

  function handleUnsubscribe() {
    subscribeError = '';
    unsubscribeSuccess = false;
    try {
      statusStore.unsubscribe(unsubscribeToken);
      unsubscribeSuccess = true;
      unsubscribeToken = '';
    } catch (err: any) {
      subscribeError = err.message || 'Lỗi hủy đăng ký';
    }
  }

  function getStatusBadge(status: string) {
    switch (status) {
      case 'operational':
        return { label: 'Hoạt động bình thường', class: 'bg-green-100 text-green-800 dark:bg-green-950/60 dark:text-green-300 border-green-300 dark:border-green-800' };
      case 'degraded_performance':
        return { label: 'Hiệu năng suy giảm', class: 'bg-yellow-100 text-yellow-800 dark:bg-yellow-950/60 dark:text-yellow-300 border-yellow-300 dark:border-yellow-800' };
      case 'partial_outage':
        return { label: 'Gián đoạn một phần', class: 'bg-orange-100 text-orange-800 dark:bg-orange-950/60 dark:text-orange-300 border-orange-300 dark:border-orange-800' };
      case 'major_outage':
        return { label: 'Sự cố nghiêm trọng', class: 'bg-red-100 text-red-800 dark:bg-red-950/60 dark:text-red-300 border-red-300 dark:border-red-800' };
      default:
        return { label: status, class: 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-300' };
    }
  }
</script>

<svelte:head>
  <title>Trạng thái Hệ thống — Creativanta Status</title>
</svelte:head>

<div class="max-w-5xl mx-auto px-4 py-8 space-y-8">
  <!-- System Status Header Banner -->
  <div class="rounded-2xl p-6 shadow-sm border {allOperational ? 'bg-gradient-to-r from-emerald-50 to-teal-50 dark:from-emerald-950/30 dark:to-teal-950/30 border-emerald-200 dark:border-emerald-800' : 'bg-gradient-to-r from-amber-50 to-orange-50 dark:from-amber-950/30 dark:to-orange-950/30 border-amber-200 dark:border-amber-800'}">
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
      <div class="flex items-center space-x-4">
        <div class="w-12 h-12 rounded-xl flex items-center justify-center text-2xl {allOperational ? 'bg-emerald-500 text-white' : 'bg-amber-500 text-white'}">
          {allOperational ? '✓' : '⚠️'}
        </div>
        <div>
          <h1 class="text-2xl font-bold text-gray-900 dark:text-white">
            {allOperational ? 'Tất cả hệ thống đang hoạt động bình thường' : 'Một số thành phần gặp sự cố hoặc suy giảm hiệu năng'}
          </h1>
          <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">
            Cập nhật tự động thời gian thực • Giám sát 8 thành phần trọng yếu theo SLA §5.1
          </p>
        </div>
      </div>
      <div class="text-right">
        <div class="text-xs uppercase font-semibold text-gray-400">Độ khả dụng 30 ngày</div>
        <div class="text-xl font-black text-emerald-600 dark:text-emerald-400">99.98%</div>
      </div>
    </div>
  </div>

  <!-- Monitored Components (§5.1 8 Monitored Components) -->
  <div class="space-y-4">
    <div class="flex items-center justify-between">
      <h2 class="text-lg font-bold text-gray-900 dark:text-white">
        Trạng thái thành phần hạ tầng (8 dịch vụ)
      </h2>
      <span class="text-xs text-gray-500">Mục tiêu Uptime SLA: 99.9%</span>
    </div>

    <div class="bg-white dark:bg-gray-900 rounded-xl border border-gray-200 dark:border-gray-800 divide-y divide-gray-100 dark:divide-gray-800">
      {#each $components as comp}
        {@const badge = getStatusBadge(comp.status)}
        <div class="p-4 flex flex-col sm:flex-row sm:items-center justify-between gap-2">
          <div class="flex items-center space-x-3">
            <span class="w-2.5 h-2.5 rounded-full {comp.status === 'operational' ? 'bg-emerald-500' : 'bg-amber-500'}"></span>
            <span class="font-medium text-gray-800 dark:text-gray-200">{comp.name}</span>
          </div>
          <div class="flex items-center space-x-4">
            <span class="text-xs text-gray-400">Độ trễ: <strong class="text-gray-600 dark:text-gray-300">{comp.latencyMs}ms</strong></span>
            <span class="text-xs font-semibold px-2.5 py-1 rounded-full border {badge.class}">
              {badge.label}
            </span>
          </div>
        </div>
      {/each}
    </div>
  </div>

  <!-- Incident Reports Section -->
  <div class="space-y-4">
    <h2 class="text-lg font-bold text-gray-900 dark:text-white">Sự cố gần đây</h2>
    {#if $incidents.length === 0}
      <div class="p-8 text-center bg-gray-50 dark:bg-gray-900/50 rounded-xl border border-gray-200 dark:border-gray-800 text-gray-500">
        Không có sự cố nào trong 90 ngày qua. Toàn bộ dịch vụ chạy ổn định.
      </div>
    {:else}
      <div class="space-y-4">
        {#each $incidents as inc}
          <div class="p-5 bg-white dark:bg-gray-900 rounded-xl border border-gray-200 dark:border-gray-800 space-y-3">
            <div class="flex items-center justify-between">
              <div class="flex items-center space-x-2">
                <span class="text-xs font-bold px-2 py-0.5 rounded bg-red-100 text-red-800">{inc.severity}</span>
                <h3 class="font-bold text-gray-900 dark:text-white">{inc.title}</h3>
              </div>
              <span class="text-xs text-gray-500">Trạng thái: {inc.status}</span>
            </div>
            <div class="space-y-2 border-l-2 border-gray-200 dark:border-gray-700 pl-4">
              {#each inc.updates as update}
                <div class="text-sm">
                  <span class="text-xs text-gray-400 font-mono">{update.timestamp}</span>
                  <p class="text-gray-700 dark:text-gray-300">{update.message}</p>
                </div>
              {/each}
            </div>
          </div>
        {/each}
      </div>
    {/if}
  </div>

  <!-- Subscription with Strict Privacy Protection (§5.4, Acceptance Target 3) -->
  <div class="bg-gray-50 dark:bg-gray-900/70 border border-gray-200 dark:border-gray-800 rounded-2xl p-6 space-y-6">
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-gray-200 dark:border-gray-800 pb-4">
      <div>
        <h2 class="text-lg font-bold text-gray-900 dark:text-white">
          🔔 Đăng ký nhận thông báo sự cố & bảo trì
        </h2>
        <p class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">
          Nhận thông báo ngay khi có sự cố P0/P1 hoặc kế hoạch nâng cấp hạ tầng.
        </p>
      </div>
      <div class="text-xs font-semibold text-gray-600 dark:text-gray-400 bg-white dark:bg-gray-800 px-3 py-1.5 rounded-lg border border-gray-200 dark:border-gray-700 self-start">
        Tổng người đăng ký hiện tại: <span class="text-indigo-600 dark:text-indigo-400 font-bold">{$subscriberCount}</span> (Bảo mật danh tính)
      </div>
    </div>

    <!-- Strict Privacy Notice -->
    <div class="p-3.5 rounded-xl bg-blue-50 dark:bg-blue-950/40 border border-blue-200 dark:border-blue-900 text-xs text-blue-800 dark:text-blue-300 flex items-start space-x-2">
      <span class="text-base">🔒</span>
      <div>
        <strong>Cam kết bảo mật thông tin đăng ký (Subscription Privacy Invariant):</strong>
        <p class="mt-0.5 text-blue-700 dark:text-blue-400">
          Email hoặc URL Webhook của bạn tuyệt đối không được lưu công khai hay hiển thị trên giao diện trạng thái.
          Mỗi lượt đăng ký được cấp một Mã Token Bí Mật dùng riêng để quản lý hoặc hủy nhận tin mà không tiết lộ bất kỳ thông tin nhận dạng nào.
        </p>
      </div>
    </div>

    {#if subscribeError}
      <div class="p-3 bg-red-50 dark:bg-red-950/40 border border-red-200 dark:border-red-900 text-red-700 dark:text-red-300 text-sm rounded-lg">
        {subscribeError}
      </div>
    {/if}

    {#if generatedPrivacyToken}
      <div class="p-4 bg-emerald-50 dark:bg-emerald-950/40 border border-emerald-200 dark:border-emerald-800 rounded-xl space-y-2">
        <div class="text-sm font-bold text-emerald-800 dark:text-emerald-300">
          ✓ Đăng ký thành công! Vui lòng lưu lại Mã Token Bí Mật của bạn:
        </div>
        <div class="p-2.5 bg-white dark:bg-gray-800 font-mono text-xs rounded border border-emerald-300 dark:border-emerald-700 text-gray-900 dark:text-white select-all">
          {generatedPrivacyToken}
        </div>
        <p class="text-xs text-emerald-700 dark:text-emerald-400">
          Token này dùng để hủy nhận tin sau này. Hệ thống không lưu trữ công khai email của bạn.
        </p>
      </div>
    {/if}

    {#if unsubscribeSuccess}
      <div class="p-3 bg-green-50 dark:bg-green-950/40 border border-green-200 dark:border-green-800 text-green-700 dark:text-green-300 text-sm rounded-lg">
        Đã hủy đăng ký thông báo sự cố thành công.
      </div>
    {/if}

    <!-- Form Area -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <!-- Subscribe Form -->
      <div class="space-y-3">
        <h3 class="text-sm font-semibold text-gray-800 dark:text-gray-200">Đăng ký mới</h3>
        <div class="flex space-x-3">
          <label class="flex items-center space-x-1.5 text-xs text-gray-700 dark:text-gray-300">
            <input type="radio" bind:group={subscribeChannel} value="email" class="text-indigo-600" />
            <span>Email</span>
          </label>
          <label class="flex items-center space-x-1.5 text-xs text-gray-700 dark:text-gray-300">
            <input type="radio" bind:group={subscribeChannel} value="webhook" class="text-indigo-600" />
            <span>Webhook URL</span>
          </label>
        </div>
        <div class="flex gap-2">
          <input
            type="text"
            bind:value={subscribeTarget}
            placeholder={subscribeChannel === 'email' ? 'nhanvien@congty.com' : 'https://api.yourdomain.com/status-hook'}
            class="flex-1 px-3 py-2 text-sm rounded-lg border border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-indigo-500"
          />
          <button
            on:click={handleSubscribe}
            class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white text-sm font-semibold rounded-lg shadow-sm transition"
          >
            Đăng ký
          </button>
        </div>
      </div>

      <!-- Unsubscribe Form -->
      <div class="space-y-3">
        <h3 class="text-sm font-semibold text-gray-800 dark:text-gray-200">Hủy đăng ký qua Token</h3>
        <p class="text-xs text-gray-500">Nhập Token bí mật đã nhận khi đăng ký để ngừng nhận thông báo:</p>
        <div class="flex gap-2">
          <input
            type="text"
            bind:value={unsubscribeToken}
            placeholder="tok_priv_..."
            class="flex-1 px-3 py-2 text-sm font-mono rounded-lg border border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-indigo-500"
          />
          <button
            on:click={handleUnsubscribe}
            class="px-4 py-2 bg-gray-200 dark:bg-gray-700 hover:bg-gray-300 dark:hover:bg-gray-600 text-gray-800 dark:text-gray-200 text-sm font-semibold rounded-lg transition"
          >
            Hủy nhận tin
          </button>
        </div>
      </div>
    </div>
  </div>
</div>
