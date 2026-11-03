<script lang="ts">
  import type { CopilotMessage } from './index';
  import QuotePreviewCard from './QuotePreviewCard.svelte';

  interface Props {
    message: CopilotMessage;
    onConfirmQuote?: (messageId: string) => void;
    onCancelQuote?: (messageId: string) => void;
  }

  let { message, onConfirmQuote, onCancelQuote }: Props = $props();

  let isUser = $derived(message.sender === 'user');
  let isAssistant = $derived(message.sender === 'assistant');
  let isRefusal = $derived(message.isRefusal);
</script>

<div
  class="flex flex-col mb-4 {isUser ? 'items-end' : 'items-start'}"
  data-testid="copilot-message-{message.id}"
>
  <div class="flex items-center gap-2 mb-1 px-1">
    <span class="text-xs font-medium text-gray-500">
      {isUser ? 'Bạn' : 'Copilot Trợ Lý'}
    </span>
    <span class="text-[10px] text-gray-400">
      {new Date(message.createdAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
    </span>
  </div>

  <div
    class="max-w-[85%] rounded-2xl px-4 py-3 text-sm leading-relaxed shadow-xs transition-all {isUser
      ? 'bg-[#0e3a2f] text-white rounded-tr-none'
      : isRefusal
        ? 'bg-rose-50 border border-rose-200 text-rose-900 rounded-tl-none'
        : 'bg-white border border-gray-200 text-gray-800 rounded-tl-none'}"
  >
    {#if isRefusal}
      <div class="flex items-center gap-1.5 font-semibold text-rose-700 mb-1 text-xs">
        <span>⛔</span> Từ chối quyền truy cập
      </div>
    {/if}

    <p class="whitespace-pre-wrap">{message.content}</p>

    <!-- Embedded Quote Preview Card if action requires confirmation -->
    {#if message.quotePreview}
      <QuotePreviewCard
        quote={message.quotePreview}
        onConfirm={() => onConfirmQuote?.(message.id)}
        onCancel={() => onCancelQuote?.(message.id)}
      />
    {/if}

    <!-- Citations / References if available -->
    {#if message.citations && message.citations.length > 0}
      <div class="mt-2.5 pt-2 border-t border-gray-100 flex flex-wrap gap-1.5 text-xs">
        <span class="text-gray-400 text-[11px] block w-full">Nguồn tham chiếu:</span>
        {#each message.citations as cit}
          <span class="inline-flex items-center gap-1 px-2 py-0.5 rounded bg-gray-100 text-gray-700 text-[11px]">
            🔗 {cit.title}
          </span>
        {/each}
      </div>
    {/if}
  </div>
</div>
