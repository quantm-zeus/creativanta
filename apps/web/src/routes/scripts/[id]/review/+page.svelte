<script lang="ts">
  import { page } from '$app/state';
  import { type ScriptApprovalState, type ScriptLifecycleState } from '$lib/script';
  import ApprovalStatusBadge from '$lib/script/ApprovalStatusBadge.svelte';
  import RejectionModal from '$lib/script/RejectionModal.svelte';
  import ConcurrentConflictBanner from '$lib/content/ConcurrentConflictBanner.svelte';
  import { isReviewStale } from '$lib/content';

  const scriptId = $derived(page.params.id || 'scr-001');

  let scriptTitle = $state('Kịch bản Video Ngắn: Skincare Mùa Hè Kiềm Dầu 3 Bước');
  let formatType = $state('9:16 vertical short');
  let durationTarget = $state(60);
  let versionIndex = $state(2);
  let lifecycleState = $state<ScriptLifecycleState>('in_review');
  let approvalState = $state<ScriptApprovalState>('pending_approval');
  let rejectionReason = $state('');

  // Concurrency tracking: Reviewer snapshot time vs script updated_at
  let reviewerSnapshotTime = $state(new Date().toISOString());
  let scriptUpdatedAt = $state(new Date().toISOString());
  let showRejectionModal = $state(false);
  let showStaleSimulation = $state(false);

  const staleCheck = $derived(
    showStaleSimulation
      ? { isStale: true, reason: 'Tác giả vừa cập nhật cảnh 2 cách đây 5 giây. Vui lòng tải lại trước khi phê duyệt (EC-M06-003).' }
      : isReviewStale(scriptUpdatedAt, reviewerSnapshotTime)
  );

  let comments = $state([
    { id: 'c-1', section: 'Hook', author: 'Quân (Quản lý)', content: 'Hook 5 giây rất bắt tai, giữ nguyên nhịp.', severity: 'positive' },
    { id: 'c-2', section: 'CTA', author: 'Quân (Quản lý)', content: 'CTA kêu gọi giỏ hàng rõ ràng, hợp chính sách TikTok Shop.', severity: 'positive' }
  ]);

  let newCommentText = $state('');
  let feedbackMessage = $state('');

  function handleApprove() {
    if (staleCheck.isStale) {
      alert('Không thể phê duyệt: Phiên bản kịch bản đã bị thay đổi kể từ khi bạn mở trang (EC-M06-003). Vui lòng tải lại trang.');
      return;
    }
    approvalState = 'approved';
    lifecycleState = 'approved';
    feedbackMessage = '✓ Đã phê duyệt kịch bản thành công!';
  }

  function handleRejectConfirm(reason: string) {
    if (staleCheck.isStale) {
      alert('Không thể từ chối: Kịch bản đã được tác giả cập nhật mới. Vui lòng tải lại.');
      return;
    }
    approvalState = 'rejected';
    lifecycleState = 'revision_required';
    rejectionReason = reason;
    showRejectionModal = false;
    feedbackMessage = `Đã từ chối kịch bản và gửi phản hồi: "${reason}"`;
  }

  function handleAddComment() {
    if (!newCommentText.trim()) return;
    comments.push({
      id: 'c-' + (comments.length + 1),
      section: 'Chung',
      author: 'Bạn (Người duyệt)',
      content: newCommentText.trim(),
      severity: 'neutral'
    });
    newCommentText = '';
  }

  function handleReloadLatest() {
    reviewerSnapshotTime = new Date().toISOString();
    scriptUpdatedAt = new Date().toISOString();
    showStaleSimulation = false;
    feedbackMessage = 'Đã tải lại phiên bản mới nhất từ tác giả.';
  }
</script>

<div class="min-h-screen bg-gray-50 pb-16">
  <!-- Header Bar -->
  <header class="sticky top-0 z-20 border-b border-gray-200 bg-white/95 px-6 py-3 backdrop-blur shadow-sm">
    <div class="mx-auto flex max-w-7xl items-center justify-between">
      <div class="flex items-center gap-3">
        <a href="/scripts/{scriptId}" class="text-sm font-semibold text-gray-500 hover:text-gray-900 transition">
          ← Chỉnh sửa kịch bản
        </a>
        <div class="h-4 w-px bg-gray-300"></div>
        <h1 class="text-base font-bold text-gray-900">📋 Kiểm duyệt: {scriptTitle}</h1>
        <ApprovalStatusBadge lifecycle={lifecycleState} approval={approvalState} />
        <span class="rounded bg-gray-100 px-2 py-0.5 font-mono text-xs text-gray-600">v{versionIndex}</span>
      </div>

      <div class="flex items-center gap-2">
        <button
          onclick={() => showStaleSimulation = !showStaleSimulation}
          class="rounded-lg border border-dashed border-gray-300 px-2 py-1 text-[11px] text-gray-600 hover:bg-gray-100 transition"
          title="Mô phỏng trường hợp tác giả sửa kịch bản khi người duyệt đang mở"
        >
          {showStaleSimulation ? 'Tắt mô phỏng xung đột' : '⚡ Thử nghiệm xung đột sửa đổi (EC-M06-003)'}
        </button>

        {#if approvalState === 'pending_approval' || approvalState === 'not_submitted'}
          <button
            onclick={() => showRejectionModal = true}
            disabled={staleCheck.isStale}
            class="rounded-lg border border-red-300 bg-white px-3.5 py-1.5 text-xs font-semibold text-red-700 hover:bg-red-50 disabled:opacity-50 disabled:cursor-not-allowed transition"
            data-testid="btn-reject-review"
          >
            ❌ Yêu cầu sửa đổi
          </button>
          <button
            onclick={handleApprove}
            disabled={staleCheck.isStale}
            class="rounded-lg bg-emerald-600 px-3.5 py-1.5 text-xs font-semibold text-white shadow hover:bg-emerald-700 disabled:opacity-50 disabled:cursor-not-allowed transition"
            data-testid="btn-approve-review"
          >
            ✅ Phê duyệt kịch bản
          </button>
        {/if}
      </div>
    </div>
  </header>

  <main class="mx-auto mt-6 max-w-7xl px-6 space-y-6">
    <!-- Stale Review / Conflict Warning Banner -->
    <ConcurrentConflictBanner
      isStale={staleCheck.isStale}
      reason={staleCheck.reason}
      onReload={handleReloadLatest}
    />

    {#if feedbackMessage}
      <div class="rounded-xl border border-emerald-200 bg-emerald-50 p-3 text-xs text-emerald-800 font-medium">
        {feedbackMessage}
      </div>
    {/if}

    <!-- Split View: Read-only Content (65%) + Review Notes Panel (35%) -->
    <div class="grid grid-cols-1 gap-6 lg:grid-cols-12">
      <!-- Script Content (Read-only) -->
      <div class="space-y-4 lg:col-span-8">
        <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm space-y-4">
          <div class="border-b border-gray-100 pb-3 flex justify-between items-center text-xs text-gray-500">
            <span>Định dạng: <strong class="text-gray-800">{formatType}</strong></span>
            <span>Mục tiêu thời lượng: <strong class="text-gray-800">{durationTarget}s</strong></span>
            <span>Số cảnh: <strong class="text-gray-800">3 cảnh</strong></span>
          </div>

          <!-- Scene 1: Hook -->
          <div class="rounded-lg border border-gray-200 p-4 space-y-2">
            <div class="flex items-center justify-between text-xs font-bold text-gray-800">
              <span class="flex items-center gap-1.5">🎣 Cảnh 1: Hook mở đầu</span>
              <span class="font-mono text-gray-500">0-5s (5s)</span>
            </div>
            <p class="text-sm text-gray-800 bg-gray-50 rounded p-3 leading-relaxed">
              "Nếu hè này da bạn đổ dầu như chảo mỡ, hãy dừng ngay 2 bước này!"
            </p>
            <p class="text-xs text-gray-500 italic">Ghi chú hình ảnh: Quay cận mặt bóng dầu, biểu cảm thất vọng.</p>
          </div>

          <!-- Scene 2: Body -->
          <div class="rounded-lg border border-gray-200 p-4 space-y-2">
            <div class="flex items-center justify-between text-xs font-bold text-gray-800">
              <span class="flex items-center gap-1.5">📖 Cảnh 2: Thân bài & Hướng dẫn</span>
              <span class="font-mono text-gray-500">5-40s (35s)</span>
            </div>
            <p class="text-sm text-gray-800 bg-gray-50 rounded p-3 leading-relaxed">
              "Chỉ cần đổi sang toner dạng nước và gel dưỡng mỏng nhẹ. Bí quyết là vỗ toner khi da còn ẩm để thẩm thấu sâu."
            </p>
            <p class="text-xs text-gray-500 italic">Ghi chú hình ảnh: Texture kem tan nhanh trên da, ánh sáng tự nhiên studio.</p>
          </div>

          <!-- Scene 3: CTA -->
          <div class="rounded-lg border border-gray-200 p-4 space-y-2">
            <div class="flex items-center justify-between text-xs font-bold text-gray-800">
              <span class="flex items-center gap-1.5">🎯 Cảnh 3: CTA kêu gọi</span>
              <span class="font-mono text-gray-500">40-60s (20s)</span>
            </div>
            <p class="text-sm text-gray-800 bg-gray-50 rounded p-3 leading-relaxed">
              "Bấm vào giỏ hàng góc trái để nhận ưu đãi hè này nhé!"
            </p>
            <p class="text-xs text-gray-500 italic">Ghi chú hình ảnh: Chỉ tay vào giỏ hàng TikTok Shop.</p>
          </div>
        </div>
      </div>

      <!-- Reviewer Feedback & Comments Panel (35%) -->
      <div class="space-y-4 lg:col-span-4">
        <div class="rounded-xl border border-gray-200 bg-white p-5 shadow-sm space-y-4">
          <h3 class="font-bold text-gray-900 text-sm">Ghi chú phê duyệt & Phản hồi</h3>

          <!-- Existing Comments -->
          <div class="space-y-3">
            {#each comments as c (c.id)}
              <div class="rounded-lg bg-gray-50 p-3 text-xs border border-gray-100">
                <div class="flex justify-between font-semibold text-gray-700 mb-1">
                  <span>{c.author}</span>
                  <span class="text-[10px] text-gray-400">Vị trí: {c.section}</span>
                </div>
                <p class="text-gray-800">{c.content}</p>
              </div>
            {/each}
          </div>

          <!-- Add Comment Form -->
          <div class="border-t border-gray-100 pt-3 space-y-2">
            <label for="review-comment-input" class="text-xs font-semibold text-gray-700">Thêm phản hồi cho tác giả:</label>
            <textarea
              id="review-comment-input"
              bind:value={newCommentText}
              rows="3"
              placeholder="Nhập nhận xét cụ thể từng phân đoạn..."
              class="w-full rounded-lg border border-gray-200 p-2 text-xs focus:border-indigo-500 focus:outline-none"
            ></textarea>
            <button
              onclick={handleAddComment}
              class="w-full rounded-lg bg-indigo-600 py-1.5 text-xs font-semibold text-white hover:bg-indigo-700 transition"
            >
              Gửi nhận xét
            </button>
          </div>
        </div>
      </div>
    </div>
  </main>

  <!-- Rejection Modal enforcing ≥10 chars (RULE-M06-002, EC-M06-002) -->
  {#if showRejectionModal}
    <RejectionModal
      isOpen={showRejectionModal}
      {scriptTitle}
      onConfirm={handleRejectConfirm}
      onCancel={() => { showRejectionModal = false; }}
    />
  {/if}
</div>
