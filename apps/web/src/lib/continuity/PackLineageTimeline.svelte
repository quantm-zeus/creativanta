<script lang="ts">
  import type { ContinuityPack, PackVersion } from './types';

  interface Props {
    pack: ContinuityPack;
    versionHistory?: PackVersion[];
  }

  let { pack, versionHistory = [] }: Props = $props();

  let selectedVersionIndex = $state(pack.version);

  let activeVersion = $derived(
    versionHistory.find((v) => v.versionIndex === selectedVersionIndex) || {
      versionIndex: pack.version,
      name: pack.name,
      approvedReferences: pack.approvedReferences || [],
      rulesSummary: pack.rulesSummary,
      status: pack.status,
      snapshotReason: 'Phiên bản hiện tại',
      createdAt: pack.updatedAt || pack.createdAt,
    }
  );
</script>

<div class="bg-white border rounded-xl p-5 shadow-sm space-y-4">
  <div class="flex items-center justify-between pb-3 border-b">
    <div>
      <h3 class="font-bold text-gray-900 text-sm flex items-center gap-2">
        <span>📜</span> Lịch sử phiên bản & Dòng dõi chuẩn (Pack Lineage — Target 2)
      </h3>
      <p class="text-xs text-gray-500">
        Mỗi lần cập nhật Character Pack đều tăng phiên bản và lưu trữ bất biến các phiên bản cũ để truy xuất nguồn gốc.
      </p>
    </div>
    <span class="px-2.5 py-1 rounded-full text-xs font-bold bg-primary-50 text-primary-700 border border-primary-200">
      v{pack.version} Hiện tại
    </span>
  </div>

  <!-- Version selector tabs -->
  <div class="flex items-center gap-2 overflow-x-auto pb-2">
    {#each versionHistory as ver}
      <button
        type="button"
        onclick={() => (selectedVersionIndex = ver.versionIndex)}
        class="px-3 py-1.5 rounded-lg text-xs font-medium border transition-colors flex items-center gap-1.5 cursor-pointer {selectedVersionIndex === ver.versionIndex ? 'bg-primary-600 text-white border-primary-600' : 'bg-gray-50 text-gray-700 hover:bg-gray-100 border-gray-200'}"
      >
        <span>v{ver.versionIndex}</span>
        {#if ver.versionIndex === pack.version}
          <span class="text-[10px] px-1 py-0.2 bg-white/20 rounded">Active</span>
        {/if}
      </button>
    {/each}
  </div>

  <!-- Selected version detail view -->
  <div class="bg-gray-50 p-4 rounded-xl border border-gray-200 space-y-3 text-xs">
    <div class="flex items-center justify-between">
      <div class="font-semibold text-gray-900">
        Phiên bản {activeVersion.versionIndex}: {activeVersion.name}
      </div>
      <span class="text-gray-500">
        Lý do: <span class="font-medium text-gray-800">{activeVersion.snapshotReason}</span>
      </span>
    </div>

    {#if activeVersion.rulesSummary}
      <div class="p-2.5 bg-white border rounded text-gray-700">
        <span class="font-medium text-gray-900">Quy tắc chuẩn:</span> {activeVersion.rulesSummary}
      </div>
    {/if}

    <!-- Canonical approved references -->
    <div>
      <div class="font-semibold text-gray-900 mb-2 flex items-center justify-between">
        <span>Tài liệu tham chiếu chuẩn ({activeVersion.approvedReferences.length})</span>
        <span class="text-[11px] text-gray-500">Bất biến theo phiên bản</span>
      </div>

      {#if activeVersion.approvedReferences.length === 0}
        <p class="text-gray-400 italic">Chưa có tài liệu tham chiếu nào được duyệt trong phiên bản này.</p>
      {:else}
        <div class="grid grid-cols-1 md:grid-cols-2 gap-2">
          {#each activeVersion.approvedReferences as ref}
            <div class="p-2.5 bg-white border rounded-lg flex items-center justify-between gap-2 shadow-2xs">
              <div class="flex items-center gap-2 truncate">
                <span class="px-1.5 py-0.5 rounded bg-gray-100 text-[10px] font-mono uppercase text-gray-600">
                  {ref.referenceType}
                </span>
                <span class="font-medium text-gray-800 truncate">{ref.name}</span>
              </div>
              <span class="shrink-0 text-[10px] px-1.5 py-0.5 rounded font-semibold bg-emerald-50 text-emerald-700 border border-emerald-200">
                {ref.status}
              </span>
            </div>
          {/each}
        </div>
      {/if}
    </div>
  </div>
</div>
