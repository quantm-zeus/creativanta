<script lang="ts">
  import { onDestroy } from 'svelte';
  import { page } from '$app/state';
  import {
    createScriptReviewSession,
    type Scene,
    type ScriptApprovalState,
    type ScriptEditorLoadState,
    type ScriptLifecycleState
  } from '$lib/script';
  import { authStore } from '$lib/auth';
  import ApprovalStatusBadge from '$lib/script/ApprovalStatusBadge.svelte';
  import RejectionModal from '$lib/script/RejectionModal.svelte';
  import ConcurrentConflictBanner from '$lib/content/ConcurrentConflictBanner.svelte';
  import { isReviewStale } from '$lib/content';

  const initialScriptId = page.params.id || 'scr-001';
  const reviewSession = createScriptReviewSession(initialScriptId);

  const scriptId = $derived(page.params.id || 'scr-001');

  let loadState = $state<ScriptEditorLoadState>('waiting_context');
  let scriptTitle = $state('');
  let formatType = $state('');
  let durationTarget = $state(0);
  let versionIndex = $state<number | null>(null);
  let lifecycleState = $state<ScriptLifecycleState>('draft');
  let approvalState = $state<ScriptApprovalState>('not_submitted');
  let rejectionReason = $state('');
  let scenes = $state<Scene[]>([]);
  let reviewerSnapshotTime = $state<string | null>(null);
  let scriptUpdatedAt = $state<string | null>(null);
  let isConflict = $state(false);
  let conflictReason = $state('');
  let isProcessingReview = $state(false);
  let isReverifying = $state(false);
  let reviewError = $state<string | null>(null);
  let feedbackMessage = $state('');
  let showRejectionModal = $state(false);

  const unsubscribeSession = reviewSession.subscribe((snap) => {
    loadState = snap.loadState;
    scriptTitle = snap.title;
    formatType = snap.formatType;
    durationTarget = snap.durationTargetSeconds;
    versionIndex = snap.versionIndex;
    lifecycleState = snap.lifecycleState;
    approvalState = snap.approvalState;
    rejectionReason = snap.rejectionReason;
    scenes = snap.scenes;
    reviewerSnapshotTime = snap.reviewerSnapshotTime;
    scriptUpdatedAt = snap.scriptUpdatedAt;
    isConflict = snap.isConflict;
    conflictReason = snap.conflictReason;
    isProcessingReview = snap.isProcessingReview;
    isReverifying = snap.isReverifying;
    reviewError = snap.error;
    feedbackMessage = snap.feedbackMessage;
  });

  onDestroy(() => {
    unsubscribeSession();
  });

  $effect(() => {
    const routeScriptId = page.params.id || 'scr-001';
    const userId = $authStore.user?.id ?? null;
    const workspaceId = $authStore.activeWorkspace?.id ?? null;
    const authState = $authStore.state;
    const isDiscoveryLoading = $authStore.isDiscoveryLoading;

    void reviewSession.syncContext({
      scriptId: routeScriptId,
      userId,
      workspaceId,
      authState,
      isDiscoveryLoading
    });
  });

  const staleCheck = $derived(
    isConflict
      ? {
          isStale: true,
          reason:
            conflictReason ||
            'Tác giả vừa cập nhật kịch bản kể từ khi bạn mở trang. Vui lòng tải lại trước khi phê duyệt (EC-M06-003).'
        }
      : reviewerSnapshotTime && scriptUpdatedAt
        ? isReviewStale(scriptUpdatedAt, reviewerSnapshotTime)
        : { isStale: false, reason: '' }
  );

  const isMutationLocked = $derived(
    loadState !== 'loaded' ||
      versionIndex === null ||
      scenes.length === 0 ||
      isReverifying ||
      isProcessingReview ||
      staleCheck.isStale
  );

  const sceneTimings = $derived.by(() => {
    let cursor = 0;
    return scenes.map((sc) => {
      const start = cursor;
      const dur = Number(sc.durationSeconds || 0) || 0;
      const end = start + dur;
      cursor = end;
      return { start, end, duration: dur };
    });
  });

  let comments = $state<
    Array<{ id: string; section: string; author: string; content: string; severity: string }>
  >([]);
  let newCommentText = $state('');

  function toggleConflictSimulation() {
    reviewSession.setConflictSimulation(!isConflict);
  }

  async function handleApprove() {
    await reviewSession.approve();
  }

  async function handleRejectConfirm(reason: string) {
    const res = await reviewSession.reject(reason);
    if (res.ok) {
      showRejectionModal = false;
    }
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

  async function handleReloadLatest() {
    await reviewSession.syncContext({
      scriptId: page.params.id || scriptId,
      userId: $authStore.user?.id ?? null,
      workspaceId: $authStore.activeWorkspace?.id ?? null,
      authState: $authStore.state,
      isDiscoveryLoading: $authStore.isDiscoveryLoading,
      force: true
    });
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
        <h1 class="text-base font-bold text-gray-900">📋 Kiểm duyệt: {scriptTitle || scriptId}</h1>
        <ApprovalStatusBadge lifecycle={lifecycleState} approval={approvalState} />
        <span class="rounded bg-gray-100 px-2 py-0.5 font-mono text-xs text-gray-600">
          {versionIndex !== null ? `v${versionIndex}` : 'Chưa đồng bộ'}
        </span>
      </div>

      <div class="flex items-center gap-2">
        <button
          onclick={toggleConflictSimulation}
          disabled={loadState !== 'loaded' || isProcessingReview || isReverifying}
          class="rounded-lg border border-dashed border-gray-300 px-2 py-1 text-[11px] text-gray-600 hover:bg-gray-100 disabled:opacity-50 transition"
          title="Mô phỏng trường hợp tác giả sửa kịch bản khi người duyệt đang mở"
        >
          {isConflict ? 'Tắt mô phỏng xung đột' : '⚡ Thử nghiệm xung đột sửa đổi (EC-M06-003)'}
        </button>

        {#if approvalState === 'pending_approval' || approvalState === 'not_submitted'}
          <button
            onclick={() => (showRejectionModal = true)}
            disabled={isMutationLocked}
            class="rounded-lg border border-red-300 bg-white px-3.5 py-1.5 text-xs font-semibold text-red-700 hover:bg-red-50 disabled:opacity-50 disabled:cursor-not-allowed transition"
            data-testid="btn-reject-review"
          >
            ❌ Yêu cầu sửa đổi
          </button>
          <button
            onclick={handleApprove}
            disabled={isMutationLocked}
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

    {#if reviewError}
      <div
        class="rounded-xl border border-red-200 bg-red-50 p-4 text-xs text-red-800 flex items-center justify-between gap-4"
        role="alert"
      >
        <div>
          <strong class="font-bold">Thao tác kiểm duyệt bị khóa (fail-closed):</strong>
          <span class="ml-1">{reviewError}</span>
        </div>
        <button
          onclick={handleReloadLatest}
          class="shrink-0 rounded-lg border border-red-300 bg-white px-3 py-1.5 text-xs font-semibold text-red-700 hover:bg-red-100 transition"
        >
          Tải lại từ máy chủ
        </button>
      </div>
    {:else if loadState !== 'loaded'}
      <div
        class="rounded-xl border border-amber-200 bg-amber-50 p-4 text-xs text-amber-900 flex items-center justify-between gap-4"
        role="status"
      >
        <span>
          {loadState === 'loading'
            ? 'Đang tải nội dung kịch bản và phân cảnh từ máy chủ (ScriptService/Get)...'
            : 'Đang chờ xác thực phiên làm việc và ngữ cảnh workspace. Thao tác phê duyệt và từ chối tạm khóa (fail-closed).'}
        </span>
      </div>
    {/if}

    {#if feedbackMessage}
      <div class="rounded-xl border border-emerald-200 bg-emerald-50 p-3 text-xs text-emerald-800 font-medium" role="status">
        {feedbackMessage}
      </div>
    {/if}

    <!-- Split View: Read-only Content (65%) + Review Notes Panel (35%) -->
    <div class="grid grid-cols-1 gap-6 lg:grid-cols-12">
      <!-- Script Content (Read-only, rendered strictly from loaded server payload) -->
      <div class="space-y-4 lg:col-span-8">
        <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm space-y-4" data-testid="review-script-content">
          <div class="border-b border-gray-100 pb-3 flex justify-between items-center text-xs text-gray-500">
            <span>Định dạng: <strong class="text-gray-800">{formatType || 'Chưa đồng bộ'}</strong></span>
            <span>Mục tiêu thời lượng: <strong class="text-gray-800">{durationTarget}s</strong></span>
            <span>Số cảnh: <strong class="text-gray-800">{scenes.length} cảnh</strong></span>
          </div>

          {#if loadState === 'loaded' && scenes.length > 0}
            {#each scenes as scene, sceneIdx (scene.sceneId || sceneIdx)}
              <article
                class="rounded-lg border border-gray-200 p-4 space-y-2"
                data-testid="review-scene-card-{sceneIdx}"
              >
                <div class="flex items-center justify-between text-xs font-bold text-gray-800">
                  <span class="flex items-center gap-1.5">
                    🎬 Cảnh {sceneIdx + 1}: {scene.description || `Phân cảnh #${sceneIdx + 1}`}
                  </span>
                  <span class="font-mono text-gray-500">
                    {sceneTimings[sceneIdx]?.start ?? 0}-{sceneTimings[sceneIdx]?.end ?? 0}s ({scene.durationSeconds}s)
                  </span>
                </div>
                <p
                  class="text-sm text-gray-800 bg-gray-50 rounded p-3 leading-relaxed"
                  data-testid="review-scene-content-{sceneIdx}"
                >
                  {scene.content}
                </p>
                {#if scene.visualNotes}
                  <p class="text-xs text-gray-500 italic">
                    Ghi chú hình ảnh: {scene.visualNotes}
                  </p>
                {/if}
                {#if scene.audioNotes}
                  <p class="text-xs text-gray-500 italic">
                    Ghi chú âm thanh: {scene.audioNotes}
                  </p>
                {/if}
                {#if scene.shotList && scene.shotList.length > 0}
                  <div class="pt-1 space-y-1">
                    {#each scene.shotList as shot, shotIdx (shot.shotId || shotIdx)}
                      <div class="text-[11px] text-gray-600 font-mono">
                        #{shotIdx + 1} [{shot.shotType}] {shot.description} ({shot.durationSeconds}s)
                      </div>
                    {/each}
                  </div>
                {/if}
              </article>
            {/each}
          {:else}
            <div
              class="rounded-lg border border-dashed border-gray-300 bg-gray-50 p-6 text-center text-xs text-gray-600"
              data-testid="review-scenes-empty-guard"
            >
              Chưa có dữ liệu phân cảnh được xác nhận từ máy chủ (ScriptService/Get). Không hiển thị nội dung mẫu để tránh phê duyệt nhầm phiên bản (fail-closed).
            </div>
          {/if}
        </div>
      </div>

      <!-- Reviewer Feedback & Comments Panel (35%) -->
      <div class="space-y-4 lg:col-span-4">
        <div class="rounded-xl border border-gray-200 bg-white p-5 shadow-sm space-y-4">
          <h3 class="font-bold text-gray-900 text-sm">Ghi chú phê duyệt & Phản hồi</h3>

          {#if rejectionReason}
            <div class="rounded-lg bg-red-50 p-3 text-xs text-red-800 border border-red-100">
              <span class="font-semibold">Lý do từ chối hiện tại:</span> {rejectionReason}
            </div>
          {/if}

          <!-- Existing Comments -->
          <div class="space-y-3">
            {#if comments.length === 0}
              <p class="text-xs text-gray-400 italic">Chưa có ghi chú phản hồi trong phiên này.</p>
            {:else}
              {#each comments as c (c.id)}
                <div class="rounded-lg bg-gray-50 p-3 text-xs border border-gray-100">
                  <div class="flex justify-between font-semibold text-gray-700 mb-1">
                    <span>{c.author}</span>
                    <span class="text-[10px] text-gray-400">Vị trí: {c.section}</span>
                  </div>
                  <p class="text-gray-800">{c.content}</p>
                </div>
              {/each}
            {/if}
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
      onCancel={() => {
        showRejectionModal = false;
      }}
    />
  {/if}
</div>
