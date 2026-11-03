<script lang="ts">
  import { page } from '$app/state';
  import {
    type Script,
    type Scene,
    type ScriptLifecycleState,
    type ScriptApprovalState
  } from '$lib/script';
  import ApprovalStatusBadge from '$lib/script/ApprovalStatusBadge.svelte';
  import ScriptSceneEditor from '$lib/script/ScriptSceneEditor.svelte';
  import SourceChainLineage from '$lib/content/SourceChainLineage.svelte';
  import ConcurrentConflictBanner from '$lib/content/ConcurrentConflictBanner.svelte';
  import CreativeAssistantPublishGuard from '$lib/content/CreativeAssistantPublishGuard.svelte';
  import { hasPublishIntent, type SourceChainLineage as LineageData } from '$lib/content';

  const scriptId = $derived(page.params.id || 'scr-001');

  let scriptTitle = $state('Kịch bản Video Ngắn: Skincare Mùa Hè Kiềm Dầu 3 Bước');
  let formatType = $state('9:16 vertical short');
  let durationTarget = $state(60);
  let versionIndex = $state(2);
  let lifecycleState = $state<ScriptLifecycleState>('draft');
  let approvalState = $state<ScriptApprovalState>('not_submitted');
  let rejectionReason = $state('');

  let scenes = $state<Scene[]>([
    {
      sceneId: 'sc-1',
      scriptId: 'scr-001',
      workspaceId: 'ws-current-tenant',
      sceneIndex: 0,
      description: 'Hook mở đầu',
      content: 'Nếu hè này da bạn đổ dầu như chảo mỡ, hãy dừng ngay 2 bước này!',
      durationSeconds: 5,
      visualNotes: 'Quay cận mặt bóng dầu, biểu cảm thất vọng',
      audioNotes: 'Nhạc dồn dập, tiếng còi stop',
      shotList: [],
      createdAt: new Date().toISOString()
    },
    {
      sceneId: 'sc-2',
      scriptId: 'scr-001',
      workspaceId: 'ws-current-tenant',
      sceneIndex: 1,
      description: 'Giải pháp & Hướng dẫn',
      content: 'Chỉ cần đổi sang toner dạng nước và gel dưỡng mỏng nhẹ...',
      durationSeconds: 35,
      visualNotes: 'Texture kem tan nhanh trên da',
      audioNotes: 'Nhạc nhẹ nhàng, voice ấm áp',
      shotList: [],
      createdAt: new Date().toISOString()
    },
    {
      sceneId: 'sc-3',
      scriptId: 'scr-001',
      workspaceId: 'ws-current-tenant',
      sceneIndex: 2,
      description: 'CTA Kêu gọi',
      content: 'Bấm vào giỏ hàng góc trái để nhận ưu đãi hè này nhé!',
      durationSeconds: 20,
      visualNotes: 'Chỉ tay vào giỏ hàng TikTok Shop',
      audioNotes: 'Nhạc chốt vui nhộn',
      shotList: [],
      createdAt: new Date().toISOString()
    }
  ]);

  let isConflict = $state(false);
  let conflictReason = $state('');
  let saveFeedback = $state('');
  let aiQuery = $state('');
  let aiRefusalNotice = $state('');
  let activeTab = $state<'ai' | 'brief' | 'review'>('ai');

  const lineage: LineageData = $derived({
    workspaceId: 'ws-current-tenant',
    scriptId: scriptId,
    trend: {
      id: 'tr-peptide',
      type: 'trend',
      title: 'Skincare Routine Peptide',
      state: 'active',
      routeUrl: '/trends/tr-peptide',
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    },
    opportunity: {
      id: 'opp-skincare',
      type: 'opportunity',
      title: 'Sáng tạo video routine peptide',
      state: 'converted',
      routeUrl: '/opportunities/opp-skincare',
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    },
    idea: {
      id: 'idea-001',
      type: 'idea',
      title: 'Hướng dẫn skincare mùa hè cho da dầu',
      state: 'converted',
      routeUrl: '/ideas/idea-001',
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    },
    script: {
      id: scriptId,
      type: 'script',
      title: scriptTitle,
      state: `${lifecycleState} | ${approvalState}`,
      routeUrl: `/scripts/${scriptId}`,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    },
    assetBrief: {
      id: 'brief-001',
      type: 'asset_brief',
      title: 'Asset Brief: ' + scriptTitle,
      state: 'ready',
      routeUrl: `/scripts/${scriptId}/brief`,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    },
    isComplete: approvalState === 'approved',
    isProductionReady: lifecycleState === 'ready_for_production',
    lineageHash: 'proof-lineage-7a8b9c0d1e2f3a4b',
    emittedEvents: ['script.created']
  });

  function handleSave() {
    versionIndex += 1;
    saveFeedback = `Đã lưu phiên bản v${versionIndex} lúc ${new Date().toLocaleTimeString('vi-VN')}`;
    isConflict = false;
    setTimeout(() => {
      saveFeedback = '';
    }, 4000);
  }

  function handleSubmitForReview() {
    if (scenes.length === 0 || scenes.some(s => !s.content.trim())) {
      alert('Không thể gửi duyệt: Kịch bản phải có ít nhất 1 cảnh và tất cả cảnh phải có nội dung (EC-M06-001).');
      return;
    }
    lifecycleState = 'in_review';
    approvalState = 'pending_approval';
    saveFeedback = 'Đã gửi kịch bản cho quản lý phê duyệt.';
  }

  function handleAiAsk() {
    if (!aiQuery.trim()) return;

    if (hasPublishIntent(aiQuery)) {
      aiRefusalNotice =
        'Tính năng xuất bản và lên lịch thuộc Publish Hub (Module M11, Phase P5). ' +
        'Trợ lý sáng tạo chỉ hỗ trợ soạn thảo kịch bản, không thể tự động xuất bản hoặc đăng bài.';
      aiQuery = '';
      return;
    }

    aiRefusalNotice = '';
    alert(`🤖 Gợi ý sáng tạo cho "${aiQuery}": Hãy tập trung vào việc tạo sự bất ngờ trong 3 giây đầu với hook câu hỏi.`);
    aiQuery = '';
  }
</script>

<div class="min-h-screen bg-gray-50 pb-16">
  <!-- Top Navigation & Action Bar -->
  <header class="sticky top-0 z-20 border-b border-gray-200 bg-white/95 px-6 py-3 backdrop-blur shadow-sm">
    <div class="mx-auto flex max-w-7xl items-center justify-between">
      <div class="flex items-center gap-4">
        <a href="/scripts" class="text-sm font-semibold text-gray-500 hover:text-gray-900 transition">
          ← Danh sách kịch bản
        </a>
        <div class="h-4 w-px bg-gray-300"></div>
        <input
          type="text"
          bind:value={scriptTitle}
          class="rounded-lg border-transparent px-2 py-1 font-bold text-gray-900 text-lg hover:border-gray-300 focus:border-blue-500 focus:bg-white focus:outline-none transition"
        />
        <ApprovalStatusBadge lifecycle={lifecycleState} approval={approvalState} />
        <span class="rounded bg-gray-100 px-2 py-0.5 font-mono text-xs text-gray-600">v{versionIndex}</span>
      </div>

      <div class="flex items-center gap-3">
        {#if saveFeedback}
          <span class="text-xs text-emerald-600 font-medium">{saveFeedback}</span>
        {/if}
        <button
          onclick={handleSave}
          class="rounded-lg border border-gray-300 bg-white px-3.5 py-1.5 text-xs font-semibold text-gray-700 hover:bg-gray-50 transition"
        >
          💾 Lưu bản nháp
        </button>

        {#if approvalState === 'not_submitted' || approvalState === 'rejected'}
          <button
            onclick={handleSubmitForReview}
            class="rounded-lg bg-blue-600 px-3.5 py-1.5 text-xs font-semibold text-white shadow hover:bg-blue-700 transition"
          >
            📤 Gửi duyệt kịch bản
          </button>
        {/if}

        <a
          href="/scripts/{scriptId}/review"
          class="rounded-lg border border-indigo-200 bg-indigo-50 px-3.5 py-1.5 text-xs font-semibold text-indigo-700 hover:bg-indigo-100 transition"
        >
          📋 Chế độ duyệt
        </a>

        <a
          href="/scripts/{scriptId}/brief"
          class="rounded-lg bg-emerald-600 px-3.5 py-1.5 text-xs font-semibold text-white shadow hover:bg-emerald-700 transition"
        >
          🎬 Asset Brief →
        </a>
      </div>
    </div>
  </header>

  <main class="mx-auto mt-6 max-w-7xl px-6 space-y-6">
    <!-- Source Chain Lineage Breadcrumb -->
    <SourceChainLineage {lineage} />

    <!-- Concurrent Conflict Banner if triggered -->
    <ConcurrentConflictBanner
      isStale={isConflict}
      reason={conflictReason}
      onReload={() => { isConflict = false; }}
    />

    <!-- Main Workspace Split View -->
    <div class="grid grid-cols-1 gap-6 lg:grid-cols-12">
      <!-- Left Column: Scene Editor (65%) -->
      <div class="space-y-6 lg:col-span-8">
        <ScriptSceneEditor
          {scenes}
          onUpdateScenes={(newScenes: Scene[]) => { scenes = newScenes; }}
        />
      </div>

      <!-- Right Column: Context, AI Assistant & Brief Tabs (35%) -->
      <div class="space-y-6 lg:col-span-4">
        <!-- Sidebar Navigation Tabs -->
        <div class="rounded-xl border border-gray-200 bg-white p-4 shadow-sm">
          <div class="flex border-b border-gray-200 pb-2 gap-2 text-xs font-semibold">
            <button
              onclick={() => activeTab = 'ai'}
              class="rounded-md px-3 py-1.5 transition {activeTab === 'ai' ? 'bg-purple-100 text-purple-800' : 'text-gray-500 hover:bg-gray-100'}"
            >
              🤖 Trợ lý AI
            </button>
            <button
              onclick={() => activeTab = 'brief'}
              class="rounded-md px-3 py-1.5 transition {activeTab === 'brief' ? 'bg-emerald-100 text-emerald-800' : 'text-gray-500 hover:bg-gray-100'}"
            >
              📋 Asset Brief
            </button>
            <button
              onclick={() => activeTab = 'review'}
              class="rounded-md px-3 py-1.5 transition {activeTab === 'review' ? 'bg-blue-100 text-blue-800' : 'text-gray-500 hover:bg-gray-100'}"
            >
              ℹ️ Kiểm duyệt
            </button>
          </div>

          <!-- Tab Content: AI Assistant -->
          {#if activeTab === 'ai'}
            <div class="mt-4 space-y-4">
              <CreativeAssistantPublishGuard refusalNotice={aiRefusalNotice} />

              <div class="rounded-lg bg-purple-50 p-3 text-xs text-purple-900 border border-purple-100">
                <span class="font-bold">Trợ lý sáng tạo Script Lab:</span>
                <p class="mt-1 text-purple-800">
                  Hỏi về hook, gợi ý thân bài, điều chỉnh độ dài hoặc viết lại theo nền tảng TikTok / YouTube Shorts.
                </p>
              </div>

              <div class="space-y-2">
                <label for="ai-prompt-input" class="text-xs font-semibold text-gray-700">Yêu cầu trợ lý AI:</label>
                <textarea
                  id="ai-prompt-input"
                  bind:value={aiQuery}
                  rows="3"
                  placeholder="Ví dụ: Gợi ý 3 câu hook gây tò mò cho cảnh 1..."
                  class="w-full rounded-lg border border-gray-200 p-2 text-xs focus:border-purple-500 focus:outline-none"
                ></textarea>
                <button
                  onclick={handleAiAsk}
                  class="w-full rounded-lg bg-purple-600 py-1.5 text-xs font-semibold text-white shadow hover:bg-purple-700 transition"
                >
                  ⚡ Gửi yêu cầu sáng tạo
                </button>
              </div>
            </div>
          {:else if activeTab === 'brief'}
            <div class="mt-4 space-y-3 text-xs">
              <p class="text-gray-600 leading-relaxed">
                Asset Brief chứa định dạng xuất, bảng phân cảnh camera, và yêu cầu liên tục (Continuity Pack) để AI Studio sản xuất video.
              </p>
              <a
                href="/scripts/{scriptId}/brief"
                class="block w-full text-center rounded-lg bg-emerald-600 py-2 text-xs font-semibold text-white hover:bg-emerald-700 transition"
              >
                Mở biên tập Asset Brief đầy đủ
              </a>
            </div>
          {:else}
            <div class="mt-4 space-y-3 text-xs">
              <div class="flex justify-between py-1 border-b border-gray-100">
                <span class="text-gray-500">Trạng thái duyệt:</span>
                <span class="font-bold">{approvalState}</span>
              </div>
              <div class="flex justify-between py-1 border-b border-gray-100">
                <span class="text-gray-500">Phiên bản hiện tại:</span>
                <span class="font-bold font-mono">v{versionIndex}</span>
              </div>
              <a
                href="/scripts/{scriptId}/review"
                class="block w-full text-center rounded-lg border border-indigo-600 py-2 text-xs font-semibold text-indigo-700 hover:bg-indigo-50 transition"
              >
                Xem chế độ phê duyệt
              </a>
            </div>
          {/if}
        </div>
      </div>
    </div>
  </main>
</div>
