<script lang="ts">
  import { page } from '$app/stores';
  import { kbArticles, helpStore, type KBArticle } from '$lib/help/store';

  $: slug = $page.params.slug;
  $: article = $kbArticles.find((a) => a.slug === slug);

  let rated = false;
  let feedbackMessage = '';

  function handleRate(helpful: boolean) {
    if (!article) return;
    helpStore.rateArticle(article.id, helpful);
    rated = true;
    feedbackMessage = helpful ? 'Cảm ơn bạn đã phản hồi hữu ích!' : 'Cảm ơn phản hồi của bạn. Chúng tôi sẽ cải thiện bài viết này.';
  }
</script>

<svelte:head>
  <title>{article ? article.title : 'Bài viết'} — Trung tâm Trợ giúp Creativanta</title>
</svelte:head>

<div class="max-w-4xl mx-auto px-4 py-8 space-y-6">
  <!-- Breadcrumb -->
  <nav class="flex items-center gap-2 text-xs text-gray-500">
    <a href="/support" class="hover:underline text-indigo-600 font-semibold">← Trung tâm hỗ trợ</a>
    <span>/</span>
    <span>{article?.moduleRef ?? 'M01'}</span>
    <span>/</span>
    <span class="text-gray-800 dark:text-gray-200 font-medium truncate">{article?.title ?? slug}</span>
  </nav>

  {#if !article}
    <div class="p-8 text-center rounded-2xl border border-dashed border-gray-300 dark:border-gray-700">
      <h2 class="text-lg font-bold text-gray-900 dark:text-white">Không tìm thấy bài viết</h2>
      <p class="text-sm text-gray-500 mt-2">Bài viết với đường dẫn "{slug}" không tồn tại hoặc đã được gỡ bỏ.</p>
      <a href="/support" class="inline-block mt-4 px-4 py-2 rounded-xl bg-indigo-600 text-white text-xs font-bold">
        Quay lại Trung tâm hỗ trợ
      </a>
    </div>
  {:else}
    <article class="p-8 rounded-3xl border border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-900 space-y-6 shadow-sm">
      <!-- Article Header -->
      <div class="border-b border-gray-100 dark:border-gray-800 pb-6">
        <div class="flex items-center gap-2 mb-3">
          <span class="px-2.5 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider bg-indigo-50 dark:bg-indigo-950/60 text-indigo-600 dark:text-indigo-400">
            {article.moduleRef}
          </span>
          <span class="text-xs text-gray-400">⏱ Đọc ~{article.estimatedReadMinutes} phút</span>
          <span class="text-xs text-gray-400">· Cập nhật: {new Date(article.lastReviewedAt).toLocaleDateString('vi-VN')}</span>
        </div>
        <h1 class="text-2xl md:text-3xl font-extrabold text-gray-900 dark:text-white tracking-tight">
          {article.title}
        </h1>
        <p class="text-sm text-gray-600 dark:text-gray-300 mt-2 leading-relaxed">
          {article.summary}
        </p>
      </div>

      <!-- Article Body -->
      <div class="prose dark:prose-invert max-w-none text-sm text-gray-800 dark:text-gray-200 leading-relaxed whitespace-pre-line">
        {article.bodyMarkdown}
      </div>

      <!-- Feedback Section -->
      <div class="mt-8 pt-6 border-t border-gray-100 dark:border-gray-800 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h4 class="text-xs font-bold text-gray-900 dark:text-white">Bài viết này có giải quyết được vấn đề của bạn?</h4>
          {#if feedbackMessage}
            <p class="text-xs text-green-600 dark:text-green-400 mt-1">{feedbackMessage}</p>
          {/if}
        </div>

        {#if !rated}
          <div class="flex items-center gap-2">
            <button
              on:click={() => handleRate(true)}
              class="px-4 py-2 rounded-xl text-xs font-bold border border-gray-300 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-800 flex items-center gap-1.5"
            >
              👍 Có ({article.helpfulVotes})
            </button>
            <button
              on:click={() => handleRate(false)}
              class="px-4 py-2 rounded-xl text-xs font-bold border border-gray-300 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-800 flex items-center gap-1.5"
            >
              👎 Chưa ({article.unhelpfulVotes})
            </button>
          </div>
        {/if}
      </div>
    </article>
  {/if}
</div>
