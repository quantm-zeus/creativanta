<script lang="ts">
  import { page } from '$app/state';
  import { type AssetBrief, type AssetBriefStatus } from '$lib/script';
  import { isAssetBriefComplete } from '$lib/content';

  const scriptId = $derived(page.params.id || 'scr-001');

  let outputType = $state('ai_video');
  let targetFormat = $state('9:16');
  let targetDurationSeconds = $state(45);
  let continuityJson = $state('{"character_pack_id": "char-anna", "voice_id": "vn-female-warm"}');
  let brandVoiceJson = $state('{"tone": "confident_friendly", "language": "vi-VN"}');
  let productionInstructions = $state('Quay cận cảnh kết cấu serum, ánh sáng tự nhiên studio, nhịp cắt nhanh.');
  let briefStatus = $state<AssetBriefStatus>('draft');
  let saveFeedback = $state('');

  const isComplete = $derived(
    isAssetBriefComplete({
      outputType,
      targetFormat,
      targetDurationSeconds,
      continuityRequirementsJson: continuityJson
    })
  );

  function handleSaveBrief() {
    if (isComplete) {
      briefStatus = 'ready';
      saveFeedback = '✓ Asset Brief đã đầy đủ thông số và sẵn sàng sản xuất (RULE-M06-005).';
    } else {
      briefStatus = 'draft';
      saveFeedback = 'Đã lưu bản nháp (vẫn còn thiếu thông số bắt buộc).';
    }
    setTimeout(() => {
      saveFeedback = '';
    }, 4000);
  }

  function handleProduce() {
    if (!isComplete) {
      alert('Asset Brief chưa hoàn thiện: Vui lòng điền đủ loại xuất, tỷ lệ khung hình, thời lượng và thông số nhân vật (RULE-M06-005).');
      return;
    }
    alert('🎬 Sẵn sàng chuyển giao sang AI Video Studio (Module M07, Phase P4).');
  }
</script>

<div class="min-h-screen bg-gray-50 pb-16">
  <!-- Header Bar -->
  <header class="sticky top-0 z-20 border-b border-gray-200 bg-white/95 px-6 py-3 backdrop-blur shadow-sm">
    <div class="mx-auto flex max-w-7xl items-center justify-between">
      <div class="flex items-center gap-3">
        <a href="/scripts/{scriptId}" class="text-sm font-semibold text-gray-500 hover:text-gray-900 transition">
          ← Kịch bản gốc
        </a>
        <div class="h-4 w-px bg-gray-300"></div>
        <h1 class="text-base font-bold text-gray-900">📋 Biên tập Asset Brief (M06/M07)</h1>
        {#if isComplete}
          <span class="rounded-full bg-emerald-100 px-2.5 py-0.5 text-xs font-semibold text-emerald-800">
            ✓ Hoàn thiện (Ready)
          </span>
        {:else}
          <span class="rounded-full bg-amber-100 px-2.5 py-0.5 text-xs font-semibold text-amber-800">
            Bản nháp (Draft)
          </span>
        {/if}
      </div>

      <div class="flex items-center gap-3">
        {#if saveFeedback}
          <span class="text-xs text-emerald-600 font-medium">{saveFeedback}</span>
        {/if}
        <button
          onclick={handleSaveBrief}
          class="rounded-lg border border-gray-300 bg-white px-3.5 py-1.5 text-xs font-semibold text-gray-700 hover:bg-gray-50 transition"
        >
          💾 Lưu Asset Brief
        </button>
        <button
          onclick={handleProduce}
          class="rounded-lg bg-emerald-600 px-4 py-1.5 text-xs font-bold text-white shadow hover:bg-emerald-700 transition"
        >
          🎬 Sản xuất với AI Video Studio →
        </button>
      </div>
    </div>
  </header>

  <main class="mx-auto mt-6 max-w-5xl px-6 space-y-6">
    <!-- Production Specs Card -->
    <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm space-y-5">
      <h2 class="text-sm font-bold text-gray-900 border-b border-gray-100 pb-2">
        1. Thông số kỹ thuật sản xuất (Production Targets)
      </h2>

      <div class="grid grid-cols-1 gap-4 sm:grid-cols-3">
        <div>
          <label for="output-type-select" class="block text-xs font-semibold text-gray-700 mb-1">Loại đầu ra (Output Type)</label>
          <select
            id="output-type-select"
            bind:value={outputType}
            class="w-full rounded-lg border border-gray-300 bg-white px-3 py-2 text-xs focus:border-emerald-500 focus:outline-none"
          >
            <option value="ai_video">AI Video (Video Studio M07)</option>
            <option value="ai_avatar">AI Avatar Talk (Nhân vật ảo)</option>
            <option value="voiceover">Thu âm lồng tiếng (Voiceover)</option>
          </select>
        </div>

        <div>
          <label for="target-format-select" class="block text-xs font-semibold text-gray-700 mb-1">Tỷ lệ khung hình (Target Format)</label>
          <select
            id="target-format-select"
            bind:value={targetFormat}
            class="w-full rounded-lg border border-gray-300 bg-white px-3 py-2 text-xs focus:border-emerald-500 focus:outline-none"
          >
            <option value="9:16">9:16 (TikTok, Shorts, Reels)</option>
            <option value="16:9">16:9 (YouTube ngang)</option>
            <option value="1:1">1:1 (Facebook, Instagram Square)</option>
          </select>
        </div>

        <div>
          <label for="duration-seconds-input" class="block text-xs font-semibold text-gray-700 mb-1">Thời lượng mục tiêu (giây)</label>
          <input
            id="duration-seconds-input"
            type="number"
            bind:value={targetDurationSeconds}
            min="10"
            max="300"
            class="w-full rounded-lg border border-gray-300 px-3 py-2 text-xs focus:border-emerald-500 focus:outline-none"
          />
        </div>
      </div>
    </div>

    <!-- Continuity & Character Requirements -->
    <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm space-y-5">
      <h2 class="text-sm font-bold text-gray-900 border-b border-gray-100 pb-2">
        2. Gói nhận diện & Tính nhất quán (Continuity & Brand Voice)
      </h2>

      <div class="space-y-4">
        <div>
          <label for="continuity-req-input" class="block text-xs font-semibold text-gray-700 mb-1">
            Yêu cầu nhân vật & khuôn mặt (Continuity Requirements JSON):
          </label>
          <textarea
            id="continuity-req-input"
            bind:value={continuityJson}
            rows="3"
            class="w-full font-mono rounded-lg border border-gray-300 p-2.5 text-xs focus:border-emerald-500 focus:outline-none"
          ></textarea>
        </div>

        <div>
          <label for="brand-voice-input" class="block text-xs font-semibold text-gray-700 mb-1">
            Giọng nói thương hiệu (Brand Voice Requirements JSON):
          </label>
          <textarea
            id="brand-voice-input"
            bind:value={brandVoiceJson}
            rows="2"
            class="w-full font-mono rounded-lg border border-gray-300 p-2.5 text-xs focus:border-emerald-500 focus:outline-none"
          ></textarea>
        </div>

        <div>
          <label for="prod-instructions-input" class="block text-xs font-semibold text-gray-700 mb-1">
            Chỉ dẫn đạo diễn & phân cảnh hình ảnh (Production Instructions):
          </label>
          <textarea
            id="prod-instructions-input"
            bind:value={productionInstructions}
            rows="3"
            class="w-full rounded-lg border border-gray-300 p-2.5 text-xs focus:border-emerald-500 focus:outline-none"
          ></textarea>
        </div>
      </div>
    </div>
  </main>
</div>
