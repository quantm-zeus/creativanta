<script lang="ts">
  import {
    type Script,
    type ScriptLifecycleState,
    type ScriptApprovalState,
    type AssetBrief
  } from '$lib/script';
  import ApprovalStatusBadge from '$lib/script/ApprovalStatusBadge.svelte';
  import ChannelRewriteModal from '$lib/script/ChannelRewriteModal.svelte';

  const currentWorkspaceId = 'ws-current-tenant';

  let filterTab = $state<'all' | 'draft' | 'in_review' | 'approved' | 'ready_for_production'>('all');

  let scripts = $state<Script[]>([
    {
      scriptId: 'scr-001',
      workspaceId: currentWorkspaceId,
      ideaId: 'idea-001',
      sourceIdeaTitle: 'Hướng dẫn skincare mùa hè cho da dầu',
      title: 'Kịch bản Video Ngắn: Skincare Mùa Hè Kiềm Dầu 3 Bước',
      formatType: '9:16 vertical short',
      durationTargetSeconds: 60,
      scenes: [
        {
          sceneId: 'sc-1',
          scriptId: 'scr-001',
          workspaceId: currentWorkspaceId,
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
          workspaceId: currentWorkspaceId,
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
          workspaceId: currentWorkspaceId,
          sceneIndex: 2,
          description: 'CTA Kêu gọi',
          content: 'Bấm vào giỏ hàng góc trái để nhận ưu đãi hè này nhé!',
          durationSeconds: 10,
          visualNotes: 'Chỉ tay vào giỏ hàng TikTok Shop',
          audioNotes: 'Nhạc chốt vui nhộn',
          shotList: [],
          createdAt: new Date().toISOString()
        }
      ],
      ctaBlocks: [
        {
          ctaId: 'cta-1',
          text: 'Mua ngay nhận ưu đãi 20%',
          buttonText: 'Xem sản phẩm',
          destinationUrl: 'https://shop.creativanta.com',
          ctaType: 'commerce_link'
        }
      ],
      disclosureBlocks: [],
      lifecycleState: 'ready_for_production',
      approvalState: 'approved',
      publishTargetProfiles: [{ platform: 'TikTok', format: '9:16 vertical short', accountId: 'acc-tiktok-1' }],
      continuityRefs: ['ref-lighting-warm'],
      offerProductHooks: ['hook-oil-free-gel'],
      versionIndex: 2,
      createdBy: 'user-001',
      approvedBy: 'user-manager-1',
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    },
    {
      scriptId: 'scr-002',
      workspaceId: currentWorkspaceId,
      ideaId: 'idea-002',
      sourceIdeaTitle: 'Top 3 sai lầm thoa kem chống nắng',
      title: 'Review Chống Nắng Không Để Lại Vệt Trắng',
      formatType: '9:16 vertical short',
      durationTargetSeconds: 45,
      scenes: [
        {
          sceneId: 'sc-21',
          scriptId: 'scr-002',
          workspaceId: currentWorkspaceId,
          sceneIndex: 0,
          description: 'Cảnh mở đầu',
          content: 'Bôi kem chống nắng mà mặt như đắp bột mì là do bạn chưa biết tips này!',
          durationSeconds: 6,
          visualNotes: 'So sánh 2 bên mặt vệt trắng vs tệp da',
          audioNotes: 'Âm thanh buzz',
          shotList: [],
          createdAt: new Date().toISOString()
        }
      ],
      ctaBlocks: [],
      disclosureBlocks: [],
      lifecycleState: 'in_review',
      approvalState: 'pending_approval',
      publishTargetProfiles: [{ platform: 'Reels', format: '9:16 vertical short', accountId: 'acc-reels-1' }],
      continuityRefs: [],
      offerProductHooks: [],
      versionIndex: 1,
      createdBy: 'user-002',
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    }
  ]);

  let rewriteModalOpen = $state(false);
  let selectedScriptForRewrite = $state<Script | null>(null);

  let filteredScripts = $derived.by(() => {
    if (filterTab === 'all') return scripts;
    if (filterTab === 'draft') return scripts.filter((s) => s.lifecycleState === 'draft');
    if (filterTab === 'in_review') return scripts.filter((s) => s.approvalState === 'pending_approval' || s.lifecycleState === 'in_review');
    if (filterTab === 'approved') return scripts.filter((s) => s.approvalState === 'approved');
    if (filterTab === 'ready_for_production') return scripts.filter((s) => s.lifecycleState === 'ready_for_production');
    return scripts;
  });

  function openRewriteModal(s: Script) {
    selectedScriptForRewrite = s;
    rewriteModalOpen = true;
  }

  function handleRewrite(platform: string, format: string, duration: number) {
    if (!selectedScriptForRewrite) return;
    const newScript: Script = {
      ...selectedScriptForRewrite,
      scriptId: `scr-${Date.now()}`,
      title: `${selectedScriptForRewrite.title} (${platform} Adaptation)`,
      formatType: format,
      durationTargetSeconds: duration,
      lifecycleState: 'draft',
      approvalState: 'not_submitted',
      versionIndex: 1,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };
    scripts = [newScript, ...scripts];
    rewriteModalOpen = false;
    selectedScriptForRewrite = null;
  }
</script>

<div class="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
  <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
    <div>
      <h1 class="text-2xl font-black text-gray-900 tracking-tight sm:text-3xl flex items-center gap-2">
        <span>📝</span> Xưởng Kịch Bản (Script Lab — M06)
      </h1>
      <p class="mt-1 text-sm text-gray-500">
        Soạn thảo phân cảnh, danh sách góc máy, quy trình phê duyệt & đóng gói Asset Brief sẵn sàng sản xuất.
      </p>
    </div>
    <div class="flex items-center gap-3">
      <a
        href="/scripts/new"
        class="inline-flex items-center gap-2 rounded-xl bg-indigo-600 px-5 py-2.5 text-sm font-bold text-white shadow-sm hover:bg-indigo-700 focus:outline-none"
      >
        <span>+</span> Soạn kịch bản mới
      </a>
    </div>
  </div>

  <!-- Filter Tabs -->
  <div class="mt-8 border-b border-gray-200">
    <nav class="-mb-px flex space-x-6">
      {#each [
        { id: 'all', label: 'Tất cả' },
        { id: 'draft', label: 'Bản nháp' },
        { id: 'in_review', label: 'Chờ duyệt' },
        { id: 'approved', label: 'Đã duyệt' },
        { id: 'ready_for_production', label: 'Sẵn sàng sản xuất' }
      ] as tab}
        <button
          type="button"
          onclick={() => (filterTab = tab.id as any)}
          class="border-b-2 py-3 text-sm font-semibold transition {filterTab === tab.id
            ? 'border-indigo-600 text-indigo-600'
            : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'}"
        >
          {tab.label}
        </button>
      {/each}
    </nav>
  </div>

  <!-- Script List -->
  <div class="mt-6 grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3">
    {#each filteredScripts as item}
      <div class="flex flex-col justify-between rounded-2xl border border-gray-200 bg-white p-6 shadow-sm transition hover:shadow-md">
        <div>
          <div class="flex items-center justify-between gap-2">
            <span class="rounded bg-slate-100 px-2 py-0.5 font-mono text-[11px] font-semibold text-slate-700">
              {item.formatType}
            </span>
            <ApprovalStatusBadge lifecycle={item.lifecycleState} approval={item.approvalState} />
          </div>

          <h3 class="mt-3 text-base font-bold text-gray-900 line-clamp-2">
            {item.title}
          </h3>

          {#if item.sourceIdeaTitle}
            <div class="mt-2 flex items-center gap-1.5 text-xs text-indigo-700 bg-indigo-50/60 rounded-md p-2">
              <span class="text-xs">💡</span>
              <span class="font-medium truncate">Gốc: {item.sourceIdeaTitle}</span>
            </div>
          {/if}

          <div class="mt-4 flex items-center gap-4 text-xs text-gray-500 font-medium">
            <span>⏱️ {item.durationTargetSeconds}s mục tiêu</span>
            <span>🎬 {item.scenes.length} phân cảnh</span>
            <span>v{item.versionIndex}</span>
          </div>
        </div>

        <div class="mt-6 border-t border-gray-100 pt-4 flex items-center justify-between">
          <button
            type="button"
            onclick={() => openRewriteModal(item)}
            class="text-xs font-semibold text-indigo-600 hover:text-indigo-800"
          >
            Chuyển thể kênh 🔄
          </button>
          <a
            href="/scripts/{item.scriptId}"
            class="inline-flex items-center rounded-lg bg-gray-100 px-3 py-1.5 text-xs font-bold text-gray-800 hover:bg-gray-200"
          >
            Mở Studio →
          </a>
        </div>
      </div>
    {/each}
  </div>
</div>

{#if selectedScriptForRewrite}
  <ChannelRewriteModal
    isOpen={rewriteModalOpen}
    sourceTitle={selectedScriptForRewrite.title}
    sourceIdeaId={selectedScriptForRewrite.ideaId}
    onRewrite={handleRewrite}
    onCancel={() => {
      rewriteModalOpen = false;
      selectedScriptForRewrite = null;
    }}
  />
{/if}
