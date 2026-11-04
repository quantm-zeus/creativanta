<script lang="ts">
  import {
    betaStore,
    type BetaEnrollment,
    type BetaFeedback
  } from '$lib/help/store';

  const enrollments = betaStore.enrollments;
  const feedbacks = betaStore.feedbacks;

  // Workspace simulation context
  let workspaceId = 'ws-curr-01';
  let workspaceTier: 'free' | 'starter' | 'pro' | 'business' | 'enterprise' = 'pro';

  // Feedback form state
  let feedbackFeature = 'beta_video_continuity';
  let feedbackRating = 5;
  let feedbackText = '';
  let feedbackIsBug = false;

  let enrollMessage = '';
  let enrollError = '';
  let feedbackSuccess = '';
  let feedbackError = '';

  $: currentEnrollment = ($enrollments[workspaceId] as BetaEnrollment | undefined);
  $: isEnrolled = currentEnrollment?.status === 'active';
  $: bonusCreditsGranted = currentEnrollment?.bonusCreditsGranted ?? false;

  function handleEnroll() {
    enrollError = '';
    enrollMessage = '';
    try {
      const res = betaStore.enroll(workspaceId, workspaceTier);
      enrollMessage = res.message;
    } catch (err: any) {
      enrollError = err.message || 'Lỗi tham gia Beta';
    }
  }

  function handleOptOut() {
    enrollError = '';
    enrollMessage = '';
    betaStore.optOut(workspaceId);
    enrollMessage = 'Đã hủy tham gia chương trình Beta. Các cờ tính năng thử nghiệm đã được tắt.';
  }

  function handleSubmitFeedback() {
    feedbackError = '';
    feedbackSuccess = '';
    if (!feedbackText.trim()) {
      feedbackError = 'Vui lòng nhập nội dung góp ý hoặc mô tả lỗi.';
      return;
    }
    try {
      betaStore.submitFeedback(feedbackFeature, feedbackRating, feedbackText, feedbackIsBug);
      feedbackSuccess = 'Cảm ơn bạn đã đóng góp phản hồi giúp cải thiện Creativanta!';
      feedbackText = '';
    } catch (err: any) {
      feedbackError = err.message || 'Lỗi gửi phản hồi';
    }
  }
</script>

<svelte:head>
  <title>Chương trình Thử nghiệm Beta — Creativanta</title>
</svelte:head>

<div class="max-w-5xl mx-auto px-4 py-8 space-y-8">
  <!-- Header -->
  <div class="border-b border-gray-200 dark:border-gray-800 pb-6">
    <div class="flex items-center space-x-3">
      <span class="text-3xl">🧪</span>
      <div>
        <h1 class="text-3xl font-extrabold text-gray-900 dark:text-white tracking-tight">
          Chương trình Thử nghiệm Beta (Early Access)
        </h1>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">
          Trải nghiệm sớm các tính năng đột phá trước khi phát hành chính thức cho toàn bộ người dùng.
        </p>
      </div>
    </div>
  </div>

  <!-- Workspace Tier Selector & Eligibility Simulator -->
  <div class="p-4 bg-gray-50 dark:bg-gray-900 rounded-xl border border-gray-200 dark:border-gray-800 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
    <div class="space-y-1">
      <div class="text-xs font-semibold text-gray-500 uppercase tracking-wider">Không gian làm việc hiện tại</div>
      <div class="text-sm font-medium text-gray-900 dark:text-white">Workspace ID: <code class="text-indigo-600 dark:text-indigo-400 font-mono">{workspaceId}</code></div>
    </div>
    <div class="flex items-center space-x-3">
      <label for="tier-select" class="text-xs text-gray-600 dark:text-gray-400 font-medium">Gói dịch vụ:</label>
      <select
        id="tier-select"
        bind:value={workspaceTier}
        class="text-sm px-3 py-1.5 rounded-lg border border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-800 text-gray-900 dark:text-white"
      >
        <option value="free">Free (Không đủ điều kiện)</option>
        <option value="starter">Starter</option>
        <option value="pro">Pro</option>
        <option value="business">Business</option>
        <option value="enterprise">Enterprise</option>
      </select>
    </div>
  </div>

  <!-- Enrollment Status Banner -->
  <div class="rounded-2xl p-6 border shadow-sm {isEnrolled ? 'bg-indigo-50/50 dark:bg-indigo-950/20 border-indigo-200 dark:border-indigo-800' : 'bg-white dark:bg-gray-900 border-gray-200 dark:border-gray-800'}">
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-6">
      <div class="space-y-2">
        <div class="flex items-center space-x-2">
          <span class="px-2.5 py-0.5 rounded-full text-xs font-bold {isEnrolled ? 'bg-indigo-600 text-white' : 'bg-gray-200 dark:bg-gray-700 text-gray-700 dark:text-gray-300'}">
            {isEnrolled ? 'ĐANG KÍCH HOẠT BETA' : 'CHƯA THAM GIA'}
          </span>
          {#if bonusCreditsGranted}
            <span class="px-2.5 py-0.5 rounded-full text-xs font-semibold bg-emerald-100 text-emerald-800 dark:bg-emerald-950/60 dark:text-emerald-300">
              ✓ Đã nhận thưởng 50 Credits (1 lần duy nhất)
            </span>
          {/if}
        </div>
        <h2 class="text-xl font-bold text-gray-900 dark:text-white">
          {isEnrolled ? 'Bạn đang có quyền truy cập sớm vào các tính năng Beta' : 'Tham gia trải nghiệm các công cụ AI thế hệ tiếp theo'}
        </h2>
        <p class="text-sm text-gray-600 dark:text-gray-400">
          Chỉ áp dụng cho các gói trả phí (Starter, Pro, Business, Enterprise). Gói Free không đủ điều kiện theo quy chế chương trình §4.1.
        </p>
      </div>

      <div class="flex items-center space-x-3">
        {#if !isEnrolled}
          <button
            on:click={handleEnroll}
            class="px-5 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white font-semibold text-sm rounded-xl shadow-sm transition flex items-center space-x-2"
          >
            <span>🚀 Đăng ký tham gia ngay</span>
            {#if !bonusCreditsGranted}
              <span class="text-xs bg-indigo-500 px-1.5 py-0.5 rounded text-indigo-100">+50 Credits</span>
            {/if}
          </button>
        {:else}
          <button
            on:click={handleOptOut}
            class="px-4 py-2 border border-red-300 dark:border-red-800 text-red-600 hover:bg-red-50 dark:hover:bg-red-950/40 text-sm font-semibold rounded-xl transition"
          >
            Rút khỏi Beta (Opt-out)
          </button>
        {/if}
      </div>
    </div>

    <!-- Alert / Feedback Messages -->
    {#if enrollError}
      <div class="mt-4 p-3 bg-red-50 dark:bg-red-950/40 border border-red-200 dark:border-red-900 text-red-700 dark:text-red-300 text-sm rounded-xl">
        {enrollError}
      </div>
    {/if}
    {#if enrollMessage}
      <div class="mt-4 p-3 bg-green-50 dark:bg-green-950/40 border border-green-200 dark:border-green-800 text-green-700 dark:text-green-300 text-sm rounded-xl">
        {enrollMessage}
      </div>
    {/if}
  </div>

  <!-- Beta Grant Once Notice (§4.2, Acceptance Target 2) -->
  <div class="p-4 rounded-xl bg-amber-50 dark:bg-amber-950/30 border border-amber-200 dark:border-amber-800 flex items-start space-x-3 text-xs text-amber-900 dark:text-amber-200">
    <span class="text-base">ℹ️</span>
    <div>
      <span class="font-bold">Quy tắc thưởng tín dụng (Beta Grant Once):</span>
      Phần thưởng 50 AI Credits chỉ được cộng chính xác một lần duy nhất cho mỗi không gian làm việc khi đăng ký lần đầu. Nếu bạn rời khỏi chương trình rồi đăng ký lại, các cờ tính năng sẽ được kích hoạt lại nhưng không cộng thêm credits mới.
    </div>
  </div>

  <!-- Active Beta Features List -->
  <div class="space-y-4">
    <h3 class="text-lg font-bold text-gray-900 dark:text-white">Các tính năng đang thử nghiệm (Beta Feature Flags)</h3>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <div class="p-4 bg-white dark:bg-gray-900 rounded-xl border border-gray-200 dark:border-gray-800 space-y-2">
        <div class="flex items-center justify-between">
          <span class="font-mono text-xs text-indigo-600 dark:text-indigo-400 font-bold">beta_video_continuity</span>
          <span class="text-xs px-2 py-0.5 rounded-full {isEnrolled ? 'bg-green-100 text-green-800 dark:bg-green-950/50 dark:text-green-300' : 'bg-gray-100 text-gray-500'}">
            {isEnrolled ? 'Bật' : 'Tắt'}
          </span>
        </div>
        <h4 class="font-semibold text-gray-900 dark:text-white text-sm">AI Video Continuity V2</h4>
        <p class="text-xs text-gray-500">Giữ khuôn mặt nhân vật và góc quay ổn định qua nhiều cảnh phân đoạn.</p>
      </div>

      <div class="p-4 bg-white dark:bg-gray-900 rounded-xl border border-gray-200 dark:border-gray-800 space-y-2">
        <div class="flex items-center justify-between">
          <span class="font-mono text-xs text-indigo-600 dark:text-indigo-400 font-bold">beta_live_radar</span>
          <span class="text-xs px-2 py-0.5 rounded-full {isEnrolled ? 'bg-green-100 text-green-800 dark:bg-green-950/50 dark:text-green-300' : 'bg-gray-100 text-gray-500'}">
            {isEnrolled ? 'Bật' : 'Tắt'}
          </span>
        </div>
        <h4 class="font-semibold text-gray-900 dark:text-white text-sm">Live Stream Radar</h4>
        <p class="text-xs text-gray-500">Phát hiện tín hiệu đột biến đơn hàng livestream và tự động ghim voucher.</p>
      </div>

      <div class="p-4 bg-white dark:bg-gray-900 rounded-xl border border-gray-200 dark:border-gray-800 space-y-2">
        <div class="flex items-center justify-between">
          <span class="font-mono text-xs text-indigo-600 dark:text-indigo-400 font-bold">beta_recipe_v2</span>
          <span class="text-xs px-2 py-0.5 rounded-full {isEnrolled ? 'bg-green-100 text-green-800 dark:bg-green-950/50 dark:text-green-300' : 'bg-gray-100 text-gray-500'}">
            {isEnrolled ? 'Bật' : 'Tắt'}
          </span>
        </div>
        <h4 class="font-semibold text-gray-900 dark:text-white text-sm">Recipe Automation V2</h4>
        <p class="text-xs text-gray-500">Trình kết nối luồng công việc tự động đa bước với độ trễ thấp dưới 200ms.</p>
      </div>
    </div>
  </div>

  <!-- Beta Feedback Submission (§4.3) -->
  <div class="p-6 bg-white dark:bg-gray-900 rounded-2xl border border-gray-200 dark:border-gray-800 space-y-6">
    <div class="border-b border-gray-200 dark:border-gray-800 pb-3">
      <h3 class="text-lg font-bold text-gray-900 dark:text-white">Gửi phản hồi hoặc Báo lỗi tính năng Beta</h3>
      <p class="text-xs text-gray-500 mt-1">Ý kiến đóng góp trực tiếp cho đội ngũ kỹ thuật đánh giá tiêu chuẩn phát hành chính thức.</p>
    </div>

    {#if feedbackSuccess}
      <div class="p-3 bg-emerald-50 dark:bg-emerald-950/40 border border-emerald-200 dark:border-emerald-800 text-emerald-700 dark:text-emerald-300 text-sm rounded-xl">
        {feedbackSuccess}
      </div>
    {/if}
    {#if feedbackError}
      <div class="p-3 bg-red-50 dark:bg-red-950/40 border border-red-200 dark:border-red-900 text-red-700 dark:text-red-300 text-sm rounded-xl">
        {feedbackError}
      </div>
    {/if}

    <div class="space-y-4">
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <div>
          <label for="feature-select" class="block text-xs font-semibold text-gray-700 dark:text-gray-300 mb-1">Tính năng phản hồi</label>
          <select
            id="feature-select"
            bind:value={feedbackFeature}
            class="w-full text-sm px-3 py-2 rounded-lg border border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-800 text-gray-900 dark:text-white"
          >
            <option value="beta_video_continuity">AI Video Continuity V2</option>
            <option value="beta_live_radar">Live Stream Radar</option>
            <option value="beta_recipe_v2">Recipe Automation V2</option>
          </select>
        </div>

        <div>
          <label for="rating-select" class="block text-xs font-semibold text-gray-700 dark:text-gray-300 mb-1">Mức độ hài lòng (1–5 sao)</label>
          <select
            id="rating-select"
            bind:value={feedbackRating}
            class="w-full text-sm px-3 py-2 rounded-lg border border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-800 text-gray-900 dark:text-white"
          >
            <option value={5}>⭐⭐⭐⭐⭐ (5 sao - Tuyệt vời)</option>
            <option value={4}>⭐⭐⭐⭐ (4 sao - Rất tốt)</option>
            <option value={3}>⭐⭐⭐ (3 sao - Bình thường)</option>
            <option value={2}>⭐⭐ (2 sao - Cần cải thiện)</option>
            <option value={1}>⭐ (1 sao - Rất kém)</option>
          </select>
        </div>
      </div>

      <div>
        <label for="feedback-content" class="block text-xs font-semibold text-gray-700 dark:text-gray-300 mb-1">Nội dung góp ý / Chi tiết lỗi</label>
        <textarea
          id="feedback-content"
          bind:value={feedbackText}
          rows="3"
          placeholder="Mô tả cụ thể trải nghiệm hoặc lỗi gặp phải khi sử dụng tính năng thử nghiệm..."
          class="w-full text-sm px-3 py-2 rounded-lg border border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-indigo-500"
        ></textarea>
      </div>

      <div class="flex items-center justify-between">
        <label class="flex items-center space-x-2 text-xs text-gray-700 dark:text-gray-300 cursor-pointer">
          <input type="checkbox" bind:checked={feedbackIsBug} class="rounded border-gray-300 text-indigo-600 focus:ring-indigo-500" />
          <span>Đây là báo cáo sự cố / bug kỹ thuật</span>
        </label>

        <button
          on:click={handleSubmitFeedback}
          class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white text-sm font-semibold rounded-lg shadow-sm transition"
        >
          Gửi đánh giá
        </button>
      </div>
    </div>

    <!-- Feedback List -->
    {#if $feedbacks.length > 0}
      <div class="border-t border-gray-200 dark:border-gray-800 pt-4 space-y-3">
        <h4 class="text-xs font-bold text-gray-500 uppercase tracking-wider">Lịch sử phản hồi của bạn</h4>
        <div class="space-y-2">
          {#each $feedbacks as fb}
            <div class="p-3 bg-gray-50 dark:bg-gray-800/50 rounded-lg text-xs space-y-1">
              <div class="flex items-center justify-between">
                <span class="font-mono font-semibold text-indigo-600 dark:text-indigo-400">{fb.featureKey}</span>
                <span class="text-yellow-500">{'★'.repeat(fb.rating)}{'☆'.repeat(5 - fb.rating)}</span>
              </div>
              <p class="text-gray-700 dark:text-gray-300">{fb.feedbackText}</p>
              {#if fb.isBugReport}
                <span class="inline-block px-1.5 py-0.5 rounded bg-red-100 text-red-800 dark:bg-red-950/50 dark:text-red-300 text-[10px] font-bold">Bug Report</span>
              {/if}
            </div>
          {/each}
        </div>
      </div>
    {/if}
  </div>
</div>
