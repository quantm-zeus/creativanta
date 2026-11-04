<script lang="ts">
  import {
    helpStore,
    filteredArticles,
    KB_CATEGORIES,
    supportStore,
    calculateSupportSLA,
    type KBArticle,
    type SupportTicketItem
  } from '$lib/help/store';

  const tickets = supportStore.tickets;

  let currentTab: 'kb' | 'tickets' | 'new_ticket' = 'kb';
  let searchQuery = '';
  let activeModule: string | null = null;

  // New ticket state
  let ticketSubject = '';
  let ticketPriority: 'urgent' | 'high' | 'normal' | 'low' = 'normal';
  let ticketMessage = '';
  let userPlanTier = 'pro'; // Default active workspace tier
  let createdTicketNotice: string | null = null;
  let csatScore = 5;

  $: helpStore.searchQuery.set(searchQuery);
  $: helpStore.activeModuleFilter.set(activeModule);

  $: sla = calculateSupportSLA(userPlanTier);

  function handleCreateTicket() {
    if (!ticketSubject.trim() || !ticketMessage.trim()) return;
    const ticket = supportStore.createTicket(userPlanTier, ticketSubject, ticketPriority, ticketMessage);
    createdTicketNotice = `Đã tạo yêu cầu hỗ trợ #${ticket.ticketNumber}. Phản hồi đầu tiên cam kết trong ${sla.responseHours} giờ.`;
    ticketSubject = '';
    ticketMessage = '';
    currentTab = 'tickets';
  }

  function handleRateArticle(artId: string, helpful: boolean) {
    helpStore.rateArticle(artId, helpful);
  }

  function handleCloseTicket(ticketId: string) {
    supportStore.closeTicket(ticketId, csatScore);
  }
</script>

<svelte:head>
  <title>Trung tâm Hỗ trợ & Tri thức — Creativanta</title>
</svelte:head>

<div class="max-w-7xl mx-auto px-4 py-8 space-y-8">
  <!-- Header -->
  <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-gray-200 dark:border-gray-800 pb-6">
    <div>
      <h1 class="text-3xl font-extrabold text-gray-900 dark:text-white tracking-tight">
        🆘 Trung tâm Hỗ trợ & Tri thức
      </h1>
      <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">
        Tự phục vụ tìm kiếm giải pháp theo phân hệ (M01–M23) hoặc gửi yêu cầu hỗ trợ chuyên sâu có cam kết SLA.
      </p>
    </div>

    <!-- Tab selection -->
    <div class="inline-flex rounded-lg border border-gray-200 dark:border-gray-800 p-1 bg-gray-50 dark:bg-gray-900">
      <button
        class="px-4 py-2 text-sm font-semibold rounded-md transition-colors {currentTab === 'kb' ? 'bg-indigo-600 text-white shadow' : 'text-gray-600 dark:text-gray-300 hover:text-gray-900'}"
        on:click={() => (currentTab = 'kb')}
      >
        📖 Kiến thức (KB)
      </button>
      <button
        class="px-4 py-2 text-sm font-semibold rounded-md transition-colors {currentTab === 'tickets' ? 'bg-indigo-600 text-white shadow' : 'text-gray-600 dark:text-gray-300 hover:text-gray-900'}"
        on:click={() => (currentTab = 'tickets')}
      >
        🎫 Yêu cầu của tôi
      </button>
      <button
        class="px-4 py-2 text-sm font-semibold rounded-md transition-colors {currentTab === 'new_ticket' ? 'bg-indigo-600 text-white shadow' : 'text-gray-600 dark:text-gray-300 hover:text-gray-900'}"
        on:click={() => (currentTab = 'new_ticket')}
      >
        + Tạo yêu cầu mới
      </button>
    </div>
  </div>

  {#if createdTicketNotice}
    <div class="p-4 rounded-xl bg-green-50 dark:bg-green-950/40 border border-green-200 dark:border-green-800 text-green-800 dark:text-green-300 flex items-center justify-between">
      <span>{createdTicketNotice}</span>
      <button on:click={() => (createdTicketNotice = null)} class="text-sm font-bold underline">Đóng</button>
    </div>
  {/if}

  <!-- TAB 1: KNOWLEDGE BASE -->
  {#if currentTab === 'kb'}
    <!-- Search Bar -->
    <div class="relative">
      <input
        type="text"
        bind:value={searchQuery}
        placeholder="🔍 Tìm kiếm bài viết, lỗi kỹ thuật, token mạng xã hội hoặc quy tắc AI credit..."
        class="w-full px-5 py-4 text-base rounded-2xl border border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-900 text-gray-900 dark:text-white shadow-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none"
      />
    </div>

    <!-- Module Filters -->
    <div class="flex flex-wrap items-center gap-2">
      <span class="text-xs font-semibold uppercase tracking-wider text-gray-400">Phân hệ:</span>
      <button
        class="px-3 py-1 rounded-full text-xs font-medium border {activeModule === null ? 'bg-indigo-500 text-white border-indigo-500' : 'bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300 border-gray-200 dark:border-gray-700'}"
        on:click={() => (activeModule = null)}
      >
        Tất cả
      </button>
      {#each ['M01', 'M07', 'M11', 'M13', 'M19', 'M22', 'M23'] as mod}
        <button
          class="px-3 py-1 rounded-full text-xs font-medium border {activeModule === mod ? 'bg-indigo-500 text-white border-indigo-500' : 'bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300 border-gray-200 dark:border-gray-700'}"
          on:click={() => (activeModule = mod)}
        >
          {mod}
        </button>
      {/each}
    </div>

    <!-- Categories Grid -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
      {#each KB_CATEGORIES as cat}
        <div class="p-4 rounded-xl border border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-900 hover:border-indigo-400 transition-all">
          <div class="text-2xl mb-2">
            {cat.icon === 'rocket' ? '🚀' : cat.icon === 'compass' ? '🧭' : cat.icon === 'wrench' ? '🔧' : cat.icon === 'credit-card' ? '💳' : '✨'}
          </div>
          <h3 class="font-bold text-sm text-gray-900 dark:text-white">{cat.displayName}</h3>
          <p class="text-xs text-gray-500 dark:text-gray-400 mt-1 line-clamp-2">{cat.description}</p>
        </div>
      {/each}
    </div>

    <!-- Article Results List -->
    <div class="space-y-4">
      <h2 class="text-lg font-bold text-gray-900 dark:text-white">
        Danh sách bài viết hướng dẫn ({$filteredArticles.length})
      </h2>

      {#if $filteredArticles.length === 0}
        <div class="p-8 text-center rounded-2xl border border-dashed border-gray-300 dark:border-gray-700 text-gray-500">
          Không tìm thấy bài viết phù hợp. Bạn có thể <button on:click={() => (currentTab = 'new_ticket')} class="text-indigo-600 font-semibold underline">tạo yêu cầu hỗ trợ</button>.
        </div>
      {:else}
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          {#each $filteredArticles as art}
            <div class="p-5 rounded-2xl border border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-900 flex flex-col justify-between hover:shadow-md transition-shadow">
              <div>
                <div class="flex items-center gap-2 mb-2">
                  <span class="px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-wider bg-indigo-50 dark:bg-indigo-950/60 text-indigo-600 dark:text-indigo-400">
                    {art.moduleRef}
                  </span>
                  <span class="text-xs text-gray-400">⏱ ~{art.estimatedReadMinutes} phút</span>
                </div>
                <a href="/support/articles/{art.slug}" class="font-bold text-base text-gray-900 dark:text-white hover:text-indigo-600 dark:hover:text-indigo-400">
                  {art.title}
                </a>
                <p class="text-xs text-gray-500 dark:text-gray-400 mt-2 line-clamp-3">
                  {art.summary}
                </p>
              </div>

              <div class="mt-4 pt-3 border-t border-gray-100 dark:border-gray-800 flex items-center justify-between text-xs text-gray-400">
                <span>Hữu ích: 👍 {art.helpfulVotes}</span>
                <div class="flex items-center gap-1">
                  <button on:click={() => handleRateArticle(art.id, true)} class="hover:text-green-600 p-1">👍</button>
                  <button on:click={() => handleRateArticle(art.id, false)} class="hover:text-red-600 p-1">👎</button>
                </div>
              </div>
            </div>
          {/each}
        </div>
      {/if}
    </div>
  {/if}

  <!-- TAB 2: MY TICKETS -->
  {#if currentTab === 'tickets'}
    <div class="space-y-4">
      <h2 class="text-lg font-bold text-gray-900 dark:text-white">Yêu cầu hỗ trợ đã gửi ({$tickets.length})</h2>

      {#if $tickets.length === 0}
        <div class="p-8 text-center rounded-2xl border border-dashed border-gray-300 dark:border-gray-700 text-gray-500">
          Chưa có yêu cầu hỗ trợ nào. Khi gặp sự cố kỹ thuật hoặc đối soát, hãy tạo yêu cầu để đội ngũ hỗ trợ giải quyết theo cam kết SLA.
        </div>
      {:else}
        <div class="space-y-3">
          {#each $tickets as ticket}
            <div class="p-5 rounded-2xl border border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-900 flex flex-col md:flex-row md:items-center justify-between gap-4">
              <div>
                <div class="flex items-center gap-2">
                  <span class="font-mono text-xs font-bold text-indigo-600">{ticket.ticketNumber}</span>
                  <span class="px-2 py-0.5 rounded text-[10px] font-bold uppercase {ticket.status === 'open' ? 'bg-blue-50 text-blue-700' : ticket.status === 'closed' ? 'bg-green-50 text-green-700' : 'bg-yellow-50 text-yellow-700'}">
                    {ticket.status}
                  </span>
                  <span class="text-xs text-gray-400">Gói {ticket.planTier.toUpperCase()}</span>
                </div>
                <h3 class="font-bold text-base text-gray-900 dark:text-white mt-1">{ticket.subject}</h3>
                <p class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">
                  SLA phản hồi: {Math.round(ticket.responseDueMinutes / 60)}h · SLA xử lý: {Math.round(ticket.resolutionDueMinutes / 60)}h
                </p>
              </div>

              {#if ticket.status !== 'closed'}
                <div class="flex items-center gap-2">
                  <select bind:value={csatScore} class="text-xs border rounded px-2 py-1 bg-white dark:bg-gray-800">
                    <option value={5}>⭐️ 5 - Rất hài lòng</option>
                    <option value={4}>⭐️ 4 - Hài lòng</option>
                    <option value={3}>⭐️ 3 - Bình thường</option>
                    <option value={2}>⭐️ 2 - Chưa hài lòng</option>
                    <option value={1}>⭐️ 1 - Rất tệ</option>
                  </select>
                  <button
                    on:click={() => handleCloseTicket(ticket.id)}
                    class="px-3 py-1.5 text-xs font-bold rounded-lg bg-green-600 text-white hover:bg-green-700"
                  >
                    Đóng ticket
                  </button>
                </div>
              {:else if ticket.csatScore}
                <div class="text-xs font-semibold text-green-600">
                  Đã đánh giá: {ticket.csatScore} sao
                </div>
              {/if}
            </div>
          {/each}
        </div>
      {/if}
    </div>
  {/if}

  <!-- TAB 3: CREATE NEW TICKET -->
  {#if currentTab === 'new_ticket'}
    <div class="max-w-2xl mx-auto p-6 rounded-2xl border border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-900 space-y-6">
      <div>
        <h2 class="text-xl font-bold text-gray-900 dark:text-white">📝 Gửi yêu cầu hỗ trợ mới</h2>
        <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">
          Cam kết thời gian phản hồi: <strong>{sla.responseHours} giờ</strong> (Gói {userPlanTier.toUpperCase()}).
        </p>
      </div>

      <div class="space-y-4">
        <div>
          <label for="sub" class="block text-xs font-semibold text-gray-700 dark:text-gray-300 mb-1">Tiêu đề yêu cầu</label>
          <input
            id="sub"
            type="text"
            bind:value={ticketSubject}
            placeholder="Mô tả tóm tắt sự cố (ví dụ: Lỗi token kết nối TikTok Shop)"
            class="w-full px-4 py-2.5 text-sm rounded-xl border border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-800 text-gray-900 dark:text-white outline-none focus:ring-2 focus:ring-indigo-500"
          />
        </div>

        <div>
          <label for="prio" class="block text-xs font-semibold text-gray-700 dark:text-gray-300 mb-1">Mức độ ưu tiên</label>
          <select
            id="prio"
            bind:value={ticketPriority}
            class="w-full px-4 py-2.5 text-sm rounded-xl border border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-800 text-gray-900 dark:text-white outline-none focus:ring-2 focus:ring-indigo-500"
          >
            <option value="low">Thấp — Yêu cầu tính năng / câu hỏi chung</option>
            <option value="normal">Bình thường — Sự cố không chặn dòng công việc</option>
            <option value="high">Cao — Lỗi ảnh hưởng tới sản xuất / xuất bản</option>
            <option value="urgent">Khẩn cấp — Gián đoạn doanh thu / cổng thanh toán</option>
          </select>
        </div>

        <div>
          <label for="msg" class="block text-xs font-semibold text-gray-700 dark:text-gray-300 mb-1">Nội dung chi tiết</label>
          <textarea
            id="msg"
            rows="5"
            bind:value={ticketMessage}
            placeholder="Vui lòng cung cấp chi tiết: các bước tái hiện, mã lỗi hiển thị hoặc liên kết sản phẩm bị ảnh hưởng..."
            class="w-full px-4 py-2.5 text-sm rounded-xl border border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-800 text-gray-900 dark:text-white outline-none focus:ring-2 focus:ring-indigo-500"
          ></textarea>
        </div>

        <button
          on:click={handleCreateTicket}
          disabled={!ticketSubject.trim() || !ticketMessage.trim()}
          class="w-full py-3 rounded-xl bg-indigo-600 hover:bg-indigo-700 disabled:opacity-50 text-white font-bold text-sm shadow transition-colors"
        >
          Gửi yêu cầu hỗ trợ (SLA {sla.responseHours}h)
        </button>
      </div>
    </div>
  {/if}
</div>
