<script lang="ts">
  import {
    helpStore,
    isHelpDrawerOpen,
    selectedArticleId,
    activeModuleFilter,
    kbArticles,
    userRatings,
    filteredArticles,
    KB_CATEGORIES,
    type KBArticle
  } from '$lib/help/store';

  let currentArticleId = $derived($selectedArticleId);
  let allArticles = $derived($kbArticles);
  let searchQueryInput = $state('');
  let activeCategory = $state<string | null>(null);

  let activeArticle = $derived(
    currentArticleId ? allArticles.find((a) => a.id === currentArticleId) : null
  );

  let displayedArticles = $derived(
    $filteredArticles.filter((art) => {
      if (activeCategory) {
        return art.categoryId === activeCategory;
      }
      return true;
    })
  );

  function handleSearchInput(e: Event) {
    const val = (e.target as HTMLInputElement).value;
    searchQueryInput = val;
    helpStore.searchQuery.set(val);
  }

  function handleKeydown(event: KeyboardEvent) {
    if (event.key === 'Escape') {
      if (currentArticleId) {
        selectedArticleId.set(null);
      } else {
        isHelpDrawerOpen.set(false);
      }
    }
  }

  function selectArticle(article: KBArticle) {
    selectedArticleId.set(article.id);
  }

  function handleVote(articleId: string, helpful: boolean) {
    helpStore.rateArticle(articleId, helpful);
  }

  let userRating = $derived(
    activeArticle ? $userRatings[activeArticle.id] : undefined
  );
</script>

<svelte:window onkeydown={handleKeydown} />

{#if $isHelpDrawerOpen}
  <!-- Backdrop -->
  <div
    class="fixed inset-0 z-40 bg-black/40 backdrop-blur-xs transition-opacity"
    onclick={() => isHelpDrawerOpen.set(false)}
    onkeydown={(e) => e.key === 'Escape' && isHelpDrawerOpen.set(false)}
    role="button"
    tabindex="0"
    aria-label="Đóng trung tâm trợ giúp"
  ></div>

  <!-- Slide-over Drawer Panel -->
  <div
    class="fixed inset-y-0 right-0 z-50 flex w-full max-w-lg flex-col bg-[#fbf9f5] border-l border-[#e7e2d7] shadow-2xl transition-transform"
    role="dialog"
    aria-modal="true"
    aria-labelledby="help-drawer-title"
  >
    <!-- Drawer Header -->
    <div class="flex items-center justify-between border-b border-[#e7e2d7] px-5 py-4 bg-[#ffffff]">
      <div class="flex items-center gap-2">
        <span class="flex h-7 w-7 items-center justify-center rounded-full bg-[#274333] text-xs font-bold text-[#ffffff]">
          ?
        </span>
        <div>
          <h2 id="help-drawer-title" class="text-base font-bold text-[#242924] leading-none">
            Trung tâm trợ giúp (Help Center)
          </h2>
          <span class="text-[11px] text-[#616c63]">Tài liệu hướng dẫn & giải đáp thắc mắc</span>
        </div>
      </div>

      <button
        type="button"
        onclick={() => isHelpDrawerOpen.set(false)}
        class="rounded-md p-1.5 text-[#616c63] hover:bg-[#f4f0e8] hover:text-[#242924] focus:outline-hidden focus:ring-2 focus:ring-[#274333]"
        aria-label="Đóng trợ giúp"
      >
        <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
        </svg>
      </button>
    </div>

    <!-- Search & Active Module Filter Bar -->
    <div class="border-b border-[#e7e2d7] px-5 py-3 bg-[#ffffff] space-y-2">
      <div class="relative">
        <input
          type="search"
          placeholder="Tìm kiếm tài liệu, lỗi hoặc câu hỏi..."
          value={searchQueryInput}
          oninput={handleSearchInput}
          class="w-full rounded-md border border-[#e7e2d7] bg-[#fbf9f5] py-2 pl-9 pr-4 text-xs text-[#242924] placeholder-[#616c63] focus:border-[#274333] focus:outline-hidden focus:ring-1 focus:ring-[#274333]"
        />
        <svg class="absolute left-3 top-2.5 h-4 w-4 text-[#616c63]" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
        </svg>
      </div>

      {#if $activeModuleFilter}
        <div class="flex items-center justify-between text-xs bg-[#f4f0e8] px-2.5 py-1 rounded">
          <span class="text-[#274333] font-medium">
            Đang lọc theo phân hệ: <strong class="font-mono">{$activeModuleFilter}</strong>
          </span>
          <button
            type="button"
            onclick={() => activeModuleFilter.set(null)}
            class="text-[11px] text-[#616c63] hover:text-[#242924] underline"
          >
            Hiện tất cả
          </button>
        </div>
      {/if}
    </div>

    <!-- Article Detail View OR Articles List -->
    {#if activeArticle}
      <!-- Detail Article View -->
      <div class="flex-1 overflow-y-auto p-5">
        <!-- Back Button -->
        <button
          type="button"
          onclick={() => selectedArticleId.set(null)}
          class="flex items-center gap-1.5 text-xs font-semibold text-[#274333] hover:underline mb-4"
        >
          <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
          </svg>
          Quay lại danh sách tài liệu
        </button>

        <article class="space-y-4">
          <div class="border-b border-[#e7e2d7] pb-3">
            <div class="flex items-center gap-2 mb-1.5">
              <span class="rounded bg-[#274333]/10 px-2 py-0.5 text-[10px] font-mono font-semibold text-[#274333]">
                {activeArticle.moduleRef}
              </span>
              <span class="text-[11px] text-[#616c63]">
                Thời lượng đọc: ~{activeArticle.estimatedReadMinutes} phút
              </span>
            </div>
            <h1 class="text-lg font-bold text-[#242924] leading-snug">
              {activeArticle.title}
            </h1>
            <p class="text-xs text-[#616c63] mt-1">
              {activeArticle.summary}
            </p>
          </div>

          <!-- Body Content -->
          <div class="prose prose-sm text-xs leading-relaxed text-[#242924] whitespace-pre-line">
            {activeArticle.bodyMarkdown}
          </div>

          <!-- Rating & Feedback Section -->
          <div class="mt-8 rounded-lg border border-[#e7e2d7] bg-[#ffffff] p-4">
            <h4 class="text-xs font-bold text-[#242924]">
              Bài viết này có hữu ích với bạn không?
            </h4>
            {#if userRating !== undefined}
              <div class="mt-2 flex items-center gap-2 text-xs text-[#274333] font-medium">
                <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                </svg>
                Cảm ơn bạn đã phản hồi! Đánh giá này giúp cải thiện tài liệu Creativanta.
              </div>
            {:else}
              <div class="mt-2.5 flex items-center gap-3">
                <button
                  type="button"
                  onclick={() => handleVote(activeArticle.id, true)}
                  class="rounded-md border border-[#274333] bg-[#274333] px-3 py-1.5 text-xs font-semibold text-[#ffffff] hover:bg-[#1f3629] transition-colors"
                >
                  👍 Có, rất hữu ích ({activeArticle.helpfulVotes})
                </button>
                <button
                  type="button"
                  onclick={() => handleVote(activeArticle.id, false)}
                  class="rounded-md border border-[#e7e2d7] bg-[#fbf9f5] px-3 py-1.5 text-xs font-semibold text-[#616c63] hover:bg-[#f4f0e8] transition-colors"
                >
                  👎 Chưa giải quyết được ({activeArticle.unhelpfulVotes})
                </button>
              </div>
            {/if}
          </div>
        </article>
      </div>
    {:else}
      <!-- Categories Chips -->
      <div class="border-b border-[#e7e2d7] px-5 py-2.5 bg-[#fbf9f5] overflow-x-auto">
        <div class="flex items-center gap-1.5 text-xs whitespace-nowrap">
          <button
            type="button"
            onclick={() => activeCategory = null}
            class="rounded px-2.5 py-1 font-medium transition-colors {!activeCategory ? 'bg-[#274333] text-[#ffffff]' : 'text-[#616c63] hover:bg-[#f4f0e8]'}"
          >
            Tất cả chủ đề
          </button>
          {#each KB_CATEGORIES as cat}
            <button
              type="button"
              onclick={() => activeCategory = cat.id}
              class="rounded px-2.5 py-1 font-medium transition-colors {activeCategory === cat.id ? 'bg-[#274333] text-[#ffffff]' : 'text-[#616c63] hover:bg-[#f4f0e8]'}"
            >
              {cat.displayName}
            </button>
          {/each}
        </div>
      </div>

      <!-- Articles List -->
      <div class="flex-1 overflow-y-auto p-5 space-y-3">
        {#if displayedArticles.length === 0}
          <div class="py-16 text-center">
            <p class="text-sm font-medium text-[#242924]">Không tìm thấy tài liệu phù hợp</p>
            <p class="mt-1 text-xs text-[#616c63]">Thử từ khoá khác hoặc gửi yêu cầu hỗ trợ trực tiếp.</p>
          </div>
        {:else}
          {#each displayedArticles as article (article.id)}
            <div
              class="rounded-lg border border-[#e7e2d7] bg-[#ffffff] p-4 shadow-2xs hover:border-[#274333] hover:shadow-xs transition-all cursor-pointer"
              onclick={() => selectArticle(article)}
              onkeydown={(e) => e.key === 'Enter' && selectArticle(article)}
              role="button"
              tabindex="0"
            >
              <div class="flex items-center justify-between text-[11px] text-[#616c63] mb-1">
                <span class="rounded bg-[#f4f0e8] px-1.5 py-0.5 font-mono font-medium text-[#274333]">
                  {article.moduleRef}
                </span>
                <span>~{article.estimatedReadMinutes} phút đọc</span>
              </div>
              <h3 class="text-sm font-semibold text-[#242924] leading-snug">
                {article.title}
              </h3>
              <p class="mt-1 text-xs text-[#616c63] line-clamp-2">
                {article.summary}
              </p>
              <div class="mt-2.5 flex items-center justify-between text-[11px] text-[#616c63] pt-2 border-t border-[#f4f0e8]">
                <span>👍 {article.helpfulVotes} lượt thấy hữu ích</span>
                <span class="text-[#274333] font-semibold flex items-center gap-1">
                  Đọc tiếp →
                </span>
              </div>
            </div>
          {/each}
        {/if}
      </div>
    {/if}

    <!-- Drawer Footer -->
    <div class="border-t border-[#e7e2d7] bg-[#ffffff] p-3 text-center text-xs text-[#616c63]">
      <p>Cần hỗ trợ sâu hơn? Mở ticket tại <a href="/settings" class="text-[#274333] underline">Trung tâm trợ giúp cá nhân</a></p>
    </div>
  </div>
{/if}
