<script lang="ts">
  import { page } from '$app/stores';
  import {
    LiveWarRoomClient,
    type PostLiveProofSummary
  } from '$lib/commerce/live_war_room';

  const sessionId = $page.params.id || 'live-session-demo';
  const workspaceId = '019086a1-7c3e-7000-8000-000000000001';

  const client = new LiveWarRoomClient();
  client.createSession(workspaceId, 'Livestream Siêu Deal Tháng 11 — Tổng kết', 'tiktok_live');
  client.startSession();

  // Seed sample highlights
  client.createHighlight('Intro & Deal Drop', 'intro', 0, 45);
  client.createHighlight('Serum HA Demo & Flash Deal', 'product_demo', 120, 180, 'Thoa kem trực tiếp');
  client.createHighlight('Giải đáp da nhạy cảm & Chốt đơn', 'objection_handling', 300, 360);

  // Seed orders
  client.attachOrder({
    orderId: 'ORD-LIVE-101',
    productId: 'prod-serum-01',
    offerId: 'off-serum-sale',
    customerId: 'cust-882',
    amount: '249000.000000',
    currency: 'VND',
    createdAt: new Date().toISOString(),
    reconciliationState: 'matched'
  });
  client.attachOrder({
    orderId: 'ORD-LIVE-102',
    productId: 'prod-serum-01',
    offerId: 'off-serum-sale',
    customerId: 'cust-903',
    amount: '498000.000000',
    currency: 'VND',
    createdAt: new Date().toISOString(),
    reconciliationState: 'matched'
  });
  client.attachOrder({
    orderId: 'ORD-LIVE-103',
    productId: 'prod-serum-01',
    offerId: 'off-serum-sale',
    customerId: 'cust-914',
    amount: '249000.000000',
    currency: 'VND',
    createdAt: new Date().toISOString(),
    reconciliationState: 'matched'
  });

  let summary = $state<PostLiveProofSummary>(client.generatePostLiveProofSummary());
  let extractedSuccess = $state<boolean>(false);
  let extractionInProgress = $state<boolean>(false);

  function handleExtractClips() {
    extractionInProgress = true;
    setTimeout(() => {
      client.extractHighlights('source-recording-master-001', `ext-${Date.now()}`);
      summary = client.generatePostLiveProofSummary();
      extractionInProgress = false;
      extractedSuccess = true;
    }, 400);
  }
</script>

<div class="min-h-screen bg-neutral-950 text-neutral-100 font-sans p-8 max-w-7xl mx-auto space-y-8">
  <!-- Header -->
  <header class="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-neutral-800 pb-6">
    <div>
      <div class="flex items-center gap-3">
        <span class="px-2.5 py-0.5 rounded-full text-xs font-semibold bg-emerald-950 text-emerald-400 border border-emerald-800">
          HOÀN THÀNH
        </span>
        <span class="text-xs font-mono text-neutral-400">ID: {sessionId}</span>
      </div>
      <h1 class="text-2xl font-bold text-neutral-100 mt-2">{summary.sessionTitle}</h1>
      <p class="text-sm text-neutral-400">Báo cáo chứng thực hiệu suất phiên live & Chứng chỉ doanh thu M19</p>
    </div>

    <div class="flex items-center gap-3">
      <a
        href={`/live/${sessionId}/war-room`}
        class="text-xs px-3.5 py-2 rounded-lg border border-neutral-700 hover:bg-neutral-800 text-neutral-300 transition font-medium"
      >
        ← Quay lại War Room
      </a>
      <button
        onclick={handleExtractClips}
        disabled={extractionInProgress || extractedSuccess}
        class="text-xs px-4 py-2 rounded-lg bg-red-600 hover:bg-red-500 disabled:opacity-50 text-white font-semibold transition flex items-center gap-2"
      >
        {#if extractionInProgress}
          <span class="animate-spin">⏳</span> Đang trích xuất M07...
        {:else if extractedSuccess}
          ✓ Đã đăng ký {summary.extractedClipAssetIds.length} clip vào M09
        {:else}
          ✂ Trích xuất điểm nhấn sang M09
        {/if}
      </button>
    </div>
  </header>

  <!-- Proof Document Badge / M19 Proof Layer Header -->
  <div class="bg-gradient-to-r from-emerald-950/40 via-neutral-900 to-neutral-900 border border-emerald-800/40 rounded-2xl p-5 flex flex-col md:flex-row md:items-center justify-between gap-4">
    <div class="space-y-1">
      <div class="flex items-center gap-2">
        <span class="text-xs font-bold text-emerald-400 uppercase tracking-wider">M19 Proof Document</span>
        <span class="text-xs text-neutral-500">·</span>
        <span class="text-xs font-mono text-neutral-400">Bundle ID: {summary.proofBundleId}</span>
      </div>
      <p class="text-sm text-neutral-300">
        Doanh thu được kiểm chứng bằng chuỗi liên kết: <strong class="text-neutral-100">Live Session → Sản phẩm → Ưu đãi → Đơn hàng</strong>.
      </p>
    </div>
    <div class="flex items-center gap-2 self-start md:self-auto bg-neutral-950/80 border border-neutral-800 px-3 py-1.5 rounded-xl text-xs font-mono">
      <span class="text-neutral-400">source_class:</span>
      <span class="text-emerald-400 font-bold">{summary.sourceClass}</span>
    </div>
  </div>

  <!-- Key Metrics 4-Box Grid -->
  <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
    <div class="bg-neutral-900 border border-neutral-800 rounded-2xl p-5 space-y-1">
      <span class="text-xs text-neutral-400 font-medium">Tổng doanh thu live</span>
      <div class="text-2xl font-black text-red-400">
        {parseInt(summary.totalRevenue).toLocaleString()}đ
      </div>
      <span class="text-[11px] text-neutral-500">Chuẩn NUMERIC(18,6) không lệch số</span>
    </div>

    <div class="bg-neutral-900 border border-neutral-800 rounded-2xl p-5 space-y-1">
      <span class="text-xs text-neutral-400 font-medium">Đơn hàng ghi nhận</span>
      <div class="text-2xl font-black text-neutral-100">{summary.orders.length}</div>
      <span class="text-[11px] text-emerald-400">100% đối soát thành công</span>
    </div>

    <div class="bg-neutral-900 border border-neutral-800 rounded-2xl p-5 space-y-1">
      <span class="text-xs text-neutral-400 font-medium">Điểm nhấn đã đánh dấu</span>
      <div class="text-2xl font-black text-amber-400">{summary.highlights.length}</div>
      <span class="text-[11px] text-neutral-500">{summary.extractedClipAssetIds.length} clip sẵn sàng trong M09</span>
    </div>

    <div class="bg-neutral-900 border border-neutral-800 rounded-2xl p-5 space-y-1">
      <span class="text-xs text-neutral-400 font-medium">Nền tảng phát sóng</span>
      <div class="text-2xl font-black text-neutral-100 capitalize">{summary.platform.replace('_', ' ')}</div>
      <span class="text-[11px] text-neutral-500">TikTok Commerce Connector</span>
    </div>
  </div>

  <!-- Traceable Revenue Orders Table (Acceptance Target 3) -->
  <section class="bg-neutral-900 border border-neutral-800 rounded-2xl p-6 space-y-4">
    <div class="flex items-center justify-between">
      <div>
        <h2 class="text-base font-bold text-neutral-100">Chuỗi doanh thu đối soát (Traceable Orders)</h2>
        <p class="text-xs text-neutral-400">Mỗi đơn hàng được chứng thực minh bạch từ phiên live đến đối soát kế toán</p>
      </div>
      <span class="text-xs font-mono bg-neutral-800 text-neutral-300 px-2.5 py-1 rounded-lg">
        {summary.orders.length} đơn hàng liên kết
      </span>
    </div>

    <div class="overflow-x-auto border border-neutral-800 rounded-xl">
      <table class="w-full text-left text-xs">
        <thead class="bg-neutral-950 text-neutral-400 uppercase tracking-wider font-semibold border-b border-neutral-800">
          <tr>
            <th class="p-3">Mã đơn hàng</th>
            <th class="p-3">Sản phẩm</th>
            <th class="p-3">Gói ưu đãi</th>
            <th class="p-3">Khách hàng</th>
            <th class="p-3">Số tiền</th>
            <th class="p-3">Đối soát M19</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-neutral-800/60 font-mono">
          {#each summary.orders as order}
            <tr class="hover:bg-neutral-800/30 transition">
              <td class="p-3 font-bold text-neutral-200">{order.orderId}</td>
              <td class="p-3 text-neutral-300">{order.productId}</td>
              <td class="p-3 text-neutral-400">{order.offerId}</td>
              <td class="p-3 text-neutral-400">{order.customerId}</td>
              <td class="p-3 font-bold text-red-400">
                {parseInt(order.amount).toLocaleString()} {order.currency}
              </td>
              <td class="p-3">
                <span class="px-2 py-0.5 rounded text-[10px] bg-emerald-950 text-emerald-400 border border-emerald-800">
                  {order.reconciliationState}
                </span>
              </td>
            </tr>
          {/each}
        </tbody>
      </table>
    </div>
  </section>

  <!-- Highlights & M09 Derivatives Section (Acceptance Target 2) -->
  <section class="bg-neutral-900 border border-neutral-800 rounded-2xl p-6 space-y-4">
    <div class="flex items-center justify-between">
      <div>
        <h2 class="text-base font-bold text-neutral-100">Điểm nhấn phiên live & Phái sinh M09 (Highlights)</h2>
        <p class="text-xs text-neutral-400">M07 cắt tự động từ timeline, M09 quản lý vòng đời video phái sinh</p>
      </div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      {#each summary.highlights as hl}
        <div class="bg-neutral-950 border border-neutral-800 rounded-xl p-4 space-y-3">
          <div class="flex justify-between items-start">
            <span class="text-[10px] uppercase font-bold px-2 py-0.5 rounded bg-neutral-800 text-neutral-300">
              {hl.highlightType}
            </span>
            <span class="text-xs font-mono text-amber-400 font-semibold">
              Điểm: {hl.engagementScore}
            </span>
          </div>

          <div>
            <h3 class="font-bold text-sm text-neutral-100">{hl.title}</h3>
            <span class="text-xs font-mono text-neutral-400">Thời gian: {hl.startOffsetSeconds}s - {hl.endOffsetSeconds}s</span>
          </div>

          <div class="pt-2 border-t border-neutral-800/80 text-xs">
            {#if hl.assetId}
              <div class="flex items-center justify-between text-emerald-400 font-mono">
                <span>✓ Clip M09:</span>
                <span class="truncate max-w-[120px]">{hl.assetId}</span>
              </div>
            {:else}
              <span class="text-neutral-500 italic">Chưa tạo clip phái sinh</span>
            {/if}
          </div>
        </div>
      {/each}
    </div>
  </section>
</div>
