<script lang="ts">
  import { copilotStore } from './index';
  import CopilotMessageBubble from './CopilotMessageBubble.svelte';

  const {
    session,
    isOpen,
    userRole,
    creditBalance,
    isTyping,
    close,
    sendMessage,
    confirmQuoteInMessage
  } = copilotStore;

  let currentSession = $derived($session);
  let open = $derived($isOpen);
  let role = $derived($userRole);
  let balance = $derived($creditBalance);
  let typing = $derived($isTyping);

  let inputVal = $state('');

  function handleSend() {
    if (!inputVal.trim()) return;
    sendMessage(inputVal);
    inputVal = '';
  }

  function handleKeydown(e: KeyboardEvent) {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSend();
    }
    if (e.key === 'Escape') {
      close();
    }
  }

  function quickPrompt(text: string) {
    inputVal = text;
    handleSend();
  }
</script>

{#if open}
  <!-- Backdrop -->
  <div
    class="fixed inset-0 bg-black/30 backdrop-blur-xs z-50 transition-opacity"
    onclick={close}
    onkeydown={(e) => e.key === 'Escape' && close()}
    role="button"
    tabindex="0"
    aria-label="Đóng Copilot"
  ></div>

  <!-- Slide-in Drawer -->
  <aside
    class="fixed top-0 right-0 bottom-0 w-full sm:w-[440px] bg-[#fbf9f5] border-l border-gray-200 z-50 flex flex-col shadow-2xl transition-transform duration-300"
    data-testid="copilot-sidebar"
  >
    <!-- Header -->
    <div class="px-5 py-4 bg-white border-b border-gray-200 flex items-center justify-between">
      <div class="flex items-center gap-2.5">
        <div class="w-8 h-8 rounded-lg bg-[#0e3a2f] flex items-center justify-center text-white text-base">
          ✨
        </div>
        <div>
          <h3 class="text-sm font-bold text-gray-900 leading-tight">Creativanta Copilot</h3>
          <p class="text-[11px] text-gray-500">Trợ lý không gian làm việc (M23)</p>
        </div>
      </div>

      <div class="flex items-center gap-2">
        <!-- Credit Badge -->
        <span
          class="text-xs px-2.5 py-1 rounded-full bg-emerald-50 text-emerald-800 border border-emerald-200 font-medium"
          data-testid="copilot-credit-badge"
        >
          🪙 {balance} cr
        </span>
        <!-- Close Button -->
        <button
          type="button"
          onclick={close}
          class="text-gray-400 hover:text-gray-700 p-1.5 rounded-lg hover:bg-gray-100 transition cursor-pointer"
          aria-label="Đóng"
          data-testid="copilot-close-btn"
        >
          ✕
        </button>
      </div>
    </div>

    <!-- Role status strip -->
    <div class="bg-gray-50 px-5 py-2 border-b border-gray-100 text-[11px] text-gray-500 flex items-center justify-between">
      <span>Vai trò hiện tại: <strong class="text-gray-800 font-semibold uppercase">{role}</strong></span>
      <span>Phiên: {currentSession.id.substring(0, 15)}...</span>
    </div>

    <!-- Messages Container -->
    <div class="flex-1 overflow-y-auto px-5 py-4" data-testid="copilot-messages-container">
      {#each currentSession.messages as msg (msg.id)}
        <CopilotMessageBubble
          message={msg}
          onConfirmQuote={(id) => confirmQuoteInMessage(id, true)}
          onCancelQuote={(id) => confirmQuoteInMessage(id, false)}
        />
      {/each}

      {#if typing}
        <div class="flex items-center gap-2 text-xs text-gray-400 py-2">
          <span class="inline-block animate-bounce">●</span>
          <span class="inline-block animate-bounce [animation-delay:0.2s]">●</span>
          <span class="inline-block animate-bounce [animation-delay:0.4s]">●</span>
          <span>Copilot đang suy nghĩ...</span>
        </div>
      {/if}
    </div>

    <!-- Quick Prompts Chips -->
    <div class="px-5 py-2.5 bg-white border-t border-gray-100">
      <span class="text-[11px] text-gray-400 block mb-1.5 font-medium">Gợi ý nhanh:</span>
      <div class="flex flex-wrap gap-1.5">
        <button
          type="button"
          onclick={() => quickPrompt('Xóa sản phẩm này')}
          class="text-xs px-2.5 py-1 rounded-md bg-rose-50 text-rose-700 hover:bg-rose-100 border border-rose-200 transition cursor-pointer"
          data-testid="prompt-delete-product"
        >
          🗑️ Xóa sản phẩm
        </button>
        <button
          type="button"
          onclick={() => quickPrompt('Doanh thu tháng này thế nào?')}
          class="text-xs px-2.5 py-1 rounded-md bg-amber-50 text-amber-700 hover:bg-amber-100 border border-amber-200 transition cursor-pointer"
          data-testid="prompt-query-finance"
        >
          📊 Xem doanh thu
        </button>
        <button
          type="button"
          onclick={() => quickPrompt('Viết kịch bản video TikTok 30s')}
          class="text-xs px-2.5 py-1 rounded-md bg-emerald-50 text-emerald-700 hover:bg-emerald-100 border border-emerald-200 transition cursor-pointer"
          data-testid="prompt-generate-script"
        >
          🎬 Viết kịch bản AI (5 cr)
        </button>
      </div>
    </div>

    <!-- Input Footer -->
    <div class="p-4 bg-white border-t border-gray-200">
      <div class="flex items-end gap-2">
        <textarea
          bind:value={inputVal}
          onkeydown={handleKeydown}
          placeholder="Hỏi Copilot hoặc yêu cầu hỗ trợ..."
          rows="2"
          class="flex-1 resize-none rounded-xl border border-gray-300 p-2.5 text-sm focus:border-[#0e3a2f] focus:outline-none focus:ring-1 focus:ring-[#0e3a2f]"
          data-testid="copilot-input"
        ></textarea>
        <button
          type="button"
          onclick={handleSend}
          disabled={!inputVal.trim()}
          class="px-4 py-2.5 bg-[#0e3a2f] text-white rounded-xl text-sm font-semibold hover:bg-[#134e3f] disabled:opacity-40 disabled:cursor-not-allowed transition cursor-pointer h-[42px] flex items-center justify-center"
          data-testid="copilot-send-btn"
        >
          Gửi
        </button>
      </div>
    </div>
  </aside>
{/if}
