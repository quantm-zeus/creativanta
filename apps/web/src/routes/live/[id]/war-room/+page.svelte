<script lang="ts">
  import { page } from '$app/stores';
  import {
    LiveWarRoomClient,
    type LiveSession,
    type CueCard,
    type Highlight,
    type TraceableOrderLink,
    type CommentTriageItem
  } from '$lib/commerce/live_war_room';

  const sessionId = $page.params.id || 'live-session-demo';
  const workspaceId = '019086a1-7c3e-7000-8000-000000000001';

  const client = new LiveWarRoomClient();
  const initRes = client.createSession(workspaceId, 'Livestream Siêu Deal Tháng 11', 'tiktok_live', 'client-init');
  client.startSession('client-start');

  let session = $state<LiveSession>(client.getSession()!);
  let isLive = $state<boolean>(true);
  let liveDurationSeconds = $state<number>(2745); // 00:45:45
  let peakViewers = $state<number>(1420);
  let currentViewers = $state<number>(1150);

  // Cue Cards
  const initialCue = client.addCueCard(
    'product_highlight',
    'Serum HA 50ml — Giảm ngay 30%',
    'Nhắc khách mã FLASH50K chỉ còn 5 phút chốt đơn!',
    'prod-serum-01',
    'off-serum-sale',
    'cue-init-1'
  );
  let cueCards = $state<CueCard[]>(client.getCueCards());

  // Products
  let pinnedProduct = $state<{ id: string; name: string; originalPrice: string; livePrice: string; stock: number; isPinned: boolean }>({
    id: 'prod-serum-01',
    name: 'Serum Phục Hồi & Dưỡng Ẩm HA',
    originalPrice: '350.000đ',
    livePrice: '249.000đ',
    stock: 42,
    isPinned: true
  });

  // Comments stream & AI triage
  let comments = $state<CommentTriageItem[]>([
    LiveWarRoomClient.triageComment('c-1', sessionId, 'Ngọc Anh', 'Shop ơi da dầu mụn dùng serum này được không?'),
    LiveWarRoomClient.triageComment('c-2', sessionId, 'Minh Trí', 'Giá bao nhiêu shop, chốt 2 chai có freeship không?'),
    LiveWarRoomClient.triageComment('c-3', sessionId, 'Thu Hằng', 'Hàng chính hãng không shop ơi sợ fake quá!'),
    LiveWarRoomClient.triageComment('c-4', sessionId, 'Thanh Vân', 'Đã đặt 1 đơn rồi nhé shop, giao nhanh giùm m!'),
  ]);

  // Highlights
  let highlights = $state<Highlight[]>(client.getHighlights());

  // Orders & Revenue
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
  let orders = $state<TraceableOrderLink[]>(client.getOrders());

  function formatTime(totalSeconds: number): string {
    const hrs = Math.floor(totalSeconds / 3600);
    const mins = Math.floor((totalSeconds % 3600) / 60);
    const secs = totalSeconds % 60;
    return `${hrs.toString().padStart(2, '0')}:${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  }

  function handleTriggerCue(cueId: string) {
    client.triggerCueCard(cueId, `trig-${Date.now()}`);
    cueCards = client.getCueCards();
  }

  function handleTogglePin() {
    pinnedProduct.isPinned = !pinnedProduct.isPinned;
    client.highlightProduct(pinnedProduct.id, 'off-serum-sale', pinnedProduct.isPinned, liveDurationSeconds, `pin-${Date.now()}`);
  }

  function handleMarkHighlight(type: string, title: string) {
    client.createHighlight(
      title,
      type,
      Math.max(0, liveDurationSeconds - 30),
      liveDurationSeconds,
      'Marked from war room',
      'off-serum-sale',
      `hl-${Date.now()}`
    );
    highlights = client.getHighlights();
  }

  let newCommentText = $state('');
  function handleAddMockComment() {
    if (!newCommentText.trim()) return;
    const triaged = LiveWarRoomClient.triageComment(`c-${Date.now()}`, sessionId, 'Khách hàng', newCommentText.trim());
    comments = [triaged, ...comments];
    newCommentText = '';
  }
</script>

<div class="min-h-screen bg-neutral-950 text-neutral-100 flex flex-col font-sans">
  <!-- Top Command Bar -->
  <header class="bg-neutral-900 border-b border-neutral-800 px-6 py-3 flex items-center justify-between">
    <div class="flex items-center gap-4">
      <span class="inline-flex items-center gap-2 px-3 py-1 rounded-full text-xs font-semibold bg-red-950/80 text-red-400 border border-red-800/60 animate-pulse">
        <span class="w-2 h-2 rounded-full bg-red-500"></span> LIVE
      </span>
      <h1 class="text-base font-bold text-neutral-100 truncate">{session.title}</h1>
      <span class="text-xs text-neutral-400 font-mono bg-neutral-800 px-2 py-0.5 rounded">{formatTime(liveDurationSeconds)}</span>
      <span class="text-xs text-neutral-400 flex items-center gap-1">
        👁 <strong class="text-neutral-200">{currentViewers.toLocaleString()}</strong> đang xem (đỉnh: {peakViewers.toLocaleString()})
      </span>
    </div>

    <div class="flex items-center gap-3">
      <a
        href={`/live/${sessionId}/summary`}
        class="text-xs px-3 py-1.5 rounded-lg border border-neutral-700 hover:bg-neutral-800 transition font-medium flex items-center gap-1.5"
      >
        📊 Xem báo cáo tổng kết
      </a>
      <a
        href={`/live/${sessionId}/summary`}
        class="text-xs px-3 py-1.5 rounded-lg bg-red-600 hover:bg-red-500 font-semibold text-white transition"
      >
        Kết thúc phiên live
      </a>
    </div>
  </header>

  <!-- 3-Column Split War Room Body -->
  <main class="flex-1 grid grid-cols-12 gap-0 overflow-hidden">
    <!-- Col 1: Product Queue & Cue Cards (25%) -->
    <section class="col-span-3 border-r border-neutral-800 p-4 overflow-y-auto space-y-4 bg-neutral-900/40">
      <div>
        <h2 class="text-xs font-bold uppercase tracking-wider text-neutral-400 mb-3 flex items-center justify-between">
          <span>Sản phẩm đang ghim</span>
          <span class="text-[10px] text-emerald-400 font-medium">Kho: {pinnedProduct.stock}</span>
        </h2>
        <div class="bg-neutral-800/80 border border-neutral-700/80 rounded-xl p-3.5 space-y-2.5">
          <div class="flex justify-between items-start">
            <h3 class="font-semibold text-sm text-neutral-100 leading-snug">{pinnedProduct.name}</h3>
            {#if pinnedProduct.isPinned}
              <span class="text-[10px] bg-red-500/20 text-red-300 border border-red-500/30 px-1.5 py-0.5 rounded font-bold">GHIM</span>
            {/if}
          </div>
          <div class="flex items-baseline gap-2">
            <span class="text-lg font-bold text-red-400">{pinnedProduct.livePrice}</span>
            <span class="text-xs text-neutral-500 line-through">{pinnedProduct.originalPrice}</span>
          </div>

          <div class="grid grid-cols-2 gap-2 pt-2">
            <button
              onclick={handleTogglePin}
              class={`text-xs py-1.5 px-2 rounded-lg font-medium border transition ${
                pinnedProduct.isPinned
                  ? 'border-neutral-600 bg-neutral-700/60 hover:bg-neutral-700 text-neutral-200'
                  : 'border-red-600 bg-red-600/20 text-red-300 hover:bg-red-600/30'
              }`}
            >
              {pinnedProduct.isPinned ? '📌 Bỏ ghim' : '📌 Ghim ngay'}
            </button>
            <button
              onclick={() => handleMarkHighlight('best_sale', 'Flash Deal Pin')}
              class="text-xs py-1.5 px-2 rounded-lg font-medium border border-amber-600/60 bg-amber-600/10 text-amber-300 hover:bg-amber-600/20 transition"
            >
              ⚡ Flash Deal
            </button>
          </div>
        </div>
      </div>

      <!-- Cue Cards -->
      <div>
        <h2 class="text-xs font-bold uppercase tracking-wider text-neutral-400 mb-2">Thẻ nhắc bài (Cue Cards)</h2>
        <div class="space-y-2">
          {#each cueCards as cue}
            <div class={`border rounded-xl p-3 space-y-1.5 transition ${cue.status === 'used' ? 'bg-neutral-900/60 border-neutral-800 opacity-60' : 'bg-neutral-800/60 border-neutral-700'}`}>
              <div class="flex items-center justify-between">
                <span class="text-[10px] font-mono px-1.5 py-0.5 rounded bg-neutral-700 text-neutral-300 uppercase">{cue.cueType}</span>
                <span class={`text-[10px] font-medium ${cue.status === 'used' ? 'text-emerald-400' : 'text-amber-400'}`}>
                  {cue.status === 'used' ? '✓ Đã nhắc' : 'Chưa nhắc'}
                </span>
              </div>
              <h4 class="text-xs font-semibold text-neutral-200">{cue.title}</h4>
              <p class="text-xs text-neutral-400">{cue.body}</p>
              {#if cue.status !== 'used'}
                <button
                  onclick={() => handleTriggerCue(cue.cueCardId)}
                  class="w-full mt-1.5 text-xs py-1 bg-emerald-600/20 hover:bg-emerald-600/30 text-emerald-300 border border-emerald-600/40 rounded font-medium transition"
                >
                  Xác nhận đã nhắc
                </button>
              {/if}
            </div>
          {/each}
        </div>
      </div>

      <!-- Quick Highlights Tagging -->
      <div>
        <h2 class="text-xs font-bold uppercase tracking-wider text-neutral-400 mb-2">Đánh dấu điểm nhấn (Highlights)</h2>
        <div class="grid grid-cols-2 gap-2">
          <button
            onclick={() => handleMarkHighlight('product_demo', 'Demo thoa kem')}
            class="text-xs p-2 bg-neutral-800 hover:bg-neutral-700 border border-neutral-700 rounded-lg text-left"
          >
            🧪 Demo sản phẩm
          </button>
          <button
            onclick={() => handleMarkHighlight('viral_moment', 'Khách chốt ồ ạt')}
            class="text-xs p-2 bg-neutral-800 hover:bg-neutral-700 border border-neutral-700 rounded-lg text-left"
          >
            🔥 Đỉnh chốt đơn
          </button>
          <button
            onclick={() => handleMarkHighlight('objection_handling', 'Giải đáp da nhạy cảm')}
            class="text-xs p-2 bg-neutral-800 hover:bg-neutral-700 border border-neutral-700 rounded-lg text-left"
          >
            🛡 Xử lý từ chối
          </button>
          <button
            onclick={() => handleMarkHighlight('giveaway', 'Giveaway mini')}
            class="text-xs p-2 bg-neutral-800 hover:bg-neutral-700 border border-neutral-700 rounded-lg text-left"
          >
            🎁 Tặng quà
          </button>
        </div>
      </div>
    </section>

    <!-- Col 2: Chat Triage (50%) -->
    <section class="col-span-6 border-r border-neutral-800 flex flex-col h-full bg-neutral-950">
      <div class="px-5 py-3 border-b border-neutral-800 flex items-center justify-between bg-neutral-900/30">
        <div>
          <h2 class="text-sm font-bold text-neutral-100 flex items-center gap-2">
            <span>💬 Luồng bình luận & AI Triage</span>
            <span class="text-xs px-2 py-0.5 rounded-full bg-blue-950 text-blue-400 border border-blue-800">
              {comments.filter((c) => c.isPriority).length} ưu tiên
            </span>
          </h2>
          <p class="text-xs text-neutral-400">AI tự động phân loại ý định mua và thắc mắc phản hồi</p>
        </div>
      </div>

      <!-- Comments Stream -->
      <div class="flex-1 p-5 overflow-y-auto space-y-3">
        {#each comments as c}
          <div class={`p-3 rounded-xl border text-sm transition ${
            c.intent === 'purchase_intent'
              ? 'bg-emerald-950/30 border-emerald-800/60'
              : c.intent === 'objection'
              ? 'bg-amber-950/30 border-amber-800/60'
              : 'bg-neutral-900/60 border-neutral-800'
          }`}>
            <div class="flex items-center justify-between mb-1">
              <span class="font-semibold text-xs text-neutral-300">{c.author}</span>
              <div class="flex items-center gap-1.5">
                {#if c.intent === 'purchase_intent'}
                  <span class="text-[10px] px-2 py-0.5 rounded bg-emerald-500/20 text-emerald-300 border border-emerald-500/30 font-bold">🛒 Ý ĐỊNH MUA</span>
                {:else if c.intent === 'objection'}
                  <span class="text-[10px] px-2 py-0.5 rounded bg-amber-500/20 text-amber-300 border border-amber-500/30 font-bold">⚠️ PHẢN HỒI/LO NGẠI</span>
                {:else}
                  <span class="text-[10px] px-2 py-0.5 rounded bg-neutral-800 text-neutral-400">HỎI ĐÁP</span>
                {/if}
              </div>
            </div>
            <p class="text-neutral-200">{c.text}</p>
          </div>
        {/each}
      </div>

      <!-- Quick Reply / Simulation Input -->
      <div class="p-3 border-t border-neutral-800 bg-neutral-900/50 flex gap-2">
        <input
          type="text"
          bind:value={newCommentText}
          placeholder="Giả lập bình luận của khách để thử AI triage..."
          class="flex-1 bg-neutral-950 border border-neutral-700 rounded-lg px-3 py-2 text-sm text-neutral-200 focus:outline-none focus:border-red-500"
          onkeydown={(e) => e.key === 'Enter' && handleAddMockComment()}
        />
        <button
          onclick={handleAddMockComment}
          class="px-4 py-2 bg-neutral-800 hover:bg-neutral-700 border border-neutral-700 rounded-lg text-sm font-medium transition"
        >
          Gửi
        </button>
      </div>
    </section>

    <!-- Col 3: Live Stats & Attributed Revenue (25%) -->
    <section class="col-span-3 p-4 overflow-y-auto space-y-4 bg-neutral-900/40">
      <div>
        <h2 class="text-xs font-bold uppercase tracking-wider text-neutral-400 mb-3">Hiệu suất trực tiếp</h2>
        <div class="grid grid-cols-2 gap-2.5">
          <div class="bg-neutral-800/80 border border-neutral-700/80 rounded-xl p-3">
            <span class="text-[10px] text-neutral-400">Đơn hàng live</span>
            <div class="text-xl font-bold text-neutral-100 mt-1">{orders.length}</div>
          </div>
          <div class="bg-neutral-800/80 border border-neutral-700/80 rounded-xl p-3">
            <span class="text-[10px] text-neutral-400">Tỷ lệ tương tác</span>
            <div class="text-xl font-bold text-emerald-400 mt-1">14.8%</div>
          </div>
        </div>

        <div class="bg-neutral-800/80 border border-neutral-700/80 rounded-xl p-3.5 mt-3">
          <span class="text-[10px] text-neutral-400 uppercase tracking-wider font-semibold">Doanh thu ghi nhận (Traceable)</span>
          <div class="text-2xl font-black text-red-400 mt-1">747.000đ</div>
          <span class="text-[10px] text-neutral-400">Nguồn: <strong class="text-emerald-400 font-mono">live_attributed</strong></span>
        </div>
      </div>

      <!-- Highlights marked list -->
      <div>
        <h2 class="text-xs font-bold uppercase tracking-wider text-neutral-400 mb-2">
          Điểm nhấn đã đánh dấu ({highlights.length})
        </h2>
        {#if highlights.length === 0}
          <p class="text-xs text-neutral-500 italic">Chưa đánh dấu điểm nhấn nào.</p>
        {:else}
          <div class="space-y-2">
            {#each highlights as hl}
              <div class="bg-neutral-800/60 border border-neutral-700/60 rounded-lg p-2.5 text-xs">
                <div class="flex justify-between font-medium text-neutral-200">
                  <span>{hl.title}</span>
                  <span class="font-mono text-neutral-400">{hl.startOffsetSeconds}s - {hl.endOffsetSeconds}s</span>
                </div>
                <div class="text-[10px] text-neutral-400 mt-1 flex justify-between">
                  <span>Loại: {hl.highlightType}</span>
                  <span class="text-amber-400">Điểm: {hl.engagementScore}</span>
                </div>
              </div>
            {/each}
          </div>
        {/if}
      </div>

      <!-- Recent Orders Feed -->
      <div>
        <h2 class="text-xs font-bold uppercase tracking-wider text-neutral-400 mb-2">Đơn hàng mới nhảy</h2>
        <div class="space-y-2">
          {#each orders as o}
            <div class="bg-neutral-800/40 border border-neutral-700/40 rounded-lg p-2 text-xs flex justify-between items-center">
              <div>
                <span class="font-mono text-[10px] text-neutral-400">{o.orderId}</span>
                <div class="text-neutral-300 font-medium">Khách {o.customerId}</div>
              </div>
              <span class="font-bold text-emerald-400">{parseInt(o.amount).toLocaleString()}đ</span>
            </div>
          {/each}
        </div>
      </div>
    </section>
  </main>
</div>
