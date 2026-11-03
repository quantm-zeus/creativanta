<script lang="ts">
  import type { StyleElements, StylePack } from '$lib/production/types';
  import { calculateStyleExtractionQuote } from '$lib/production';

  // Workspace state
  let creditsBalance = $state(85);
  let isAnalyzing = $state(false);
  let feedbackMessage = $state('');
  let errorMessage = $state('');

  // Reference videos selection (1-5 videos)
  let referenceVideos = $state<Array<{ id: string; name: string; duration: string }>>([
    { id: 'ref-01', name: 'my_review_highlight_01.mp4', duration: '0:45' },
    { id: 'ref-02', name: 'lifestyle_unboxing_02.mp4', duration: '1:12' }
  ]);
  let newVideoName = $state('');

  // Style Pack extraction state
  let extractedElements = $state<StyleElements | null>(null);
  let packName = $state('My Fast Cut Skincare Style');
  let isSaving = $state(false);

  // Existing Style Packs in Continuity OS
  let stylePacks = $state<StylePack[]>([
    {
      stylePackId: 'sp-001',
      workspaceId: 'ws-demo',
      name: 'Tech Review Fast Cut Style',
      sourceAssetId: 'ref-01',
      extractedStyle: {
        colorPalette: 'Cool cyan & high contrast darks',
        cutPacing: 'Nhanh (1.5s/cắt)',
        textStyle: 'Modern sans-serif, uppercase yellow highlight',
        musicStyle: 'Tech ambient / electro beat, 125 BPM',
        transitions: 'Wipe & quick zoom in',
        hookPattern: 'Bold problem statement with glitch effect',
        visualMood: 'Studio lighting, macro product shots',
        avgCutDurationMs: 1500,
        colorPaletteHex: ['#00FFFF', '#111827', '#FBBF24', '#374151']
      },
      isActive: true,
      continuityPackId: 'pack-style-tech-01',
      createdAt: '2026-11-01T08:00:00Z',
      updatedAt: '2026-11-01T08:00:00Z'
    }
  ]);

  function handleAddReferenceVideo() {
    errorMessage = '';
    if (referenceVideos.length >= 5) {
      errorMessage = 'Tối đa 5 video tham chiếu theo đặc tả W032.';
      return;
    }
    const id = `ref-0${referenceVideos.length + 1}`;
    const name = newVideoName.trim() || `reference_clip_${id}.mp4`;
    referenceVideos = [...referenceVideos, { id, name, duration: '0:50' }];
    newVideoName = '';
  }

  function handleRemoveReferenceVideo(id: string) {
    errorMessage = '';
    referenceVideos = referenceVideos.filter((v) => v.id !== id);
  }

  function handleAnalyzeStyle() {
    errorMessage = '';
    feedbackMessage = '';
    const quoteCheck = calculateStyleExtractionQuote(referenceVideos.length);
    if (!quoteCheck.isValid) {
      errorMessage = quoteCheck.errorMessage || 'Số lượng video không hợp lệ.';
      return;
    }

    if (creditsBalance < quoteCheck.creditsRequired) {
      errorMessage = `Số dư không đủ (${creditsBalance} credits). Cần ${quoteCheck.creditsRequired} credits để trích xuất phong cách.`;
      return;
    }

    isAnalyzing = true;
    setTimeout(() => {
      creditsBalance -= quoteCheck.creditsRequired;
      extractedElements = {
        colorPalette: 'Warm tones, high contrast & pastel balance',
        cutPacing: 'Nhanh (avg 1.8s/cut)',
        textStyle: 'Bold sans-serif, bottom-center with soft drop shadow',
        musicStyle: 'Upbeat lo-fi pop, BPM 115-125',
        transitions: 'Jump cuts, occasional subtle zoom',
        hookPattern: 'Text overlay question in first 2-3s',
        visualMood: 'Bright, lifestyle, warm ambient lighting',
        avgCutDurationMs: 1800,
        colorPaletteHex: ['#FF6B6B', '#4ECDC4', '#FFE66D', '#2C3E50']
      };
      isAnalyzing = false;
      feedbackMessage = `✓ Đã trích xuất thành công 7 yếu tố phong cách (đã trừ ${quoteCheck.creditsRequired} credits).`;
    }, 400);
  }

  function handleSaveStylePack() {
    if (!packName.trim()) {
      errorMessage = 'Vui lòng nhập tên Style Pack.';
      return;
    }
    if (!extractedElements) {
      errorMessage = 'Chưa có dữ liệu phong cách trích xuất.';
      return;
    }

    isSaving = true;
    const newPack: StylePack = {
      stylePackId: `sp-${Date.now()}`,
      workspaceId: 'ws-demo',
      name: packName.trim(),
      sourceAssetId: referenceVideos[0]?.id || 'ref-01',
      extractedStyle: extractedElements,
      isActive: true,
      continuityPackId: `pack-style-${Date.now()}`,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };

    stylePacks = [newPack, ...stylePacks];
    isSaving = false;
    feedbackMessage = `✓ Style Pack "${newPack.name}" đã được lưu vào Continuity OS và sẵn sàng áp dụng.`;
  }

  function handleApplyStylePack(pack: StylePack) {
    feedbackMessage = `✓ Đã áp dụng Style Pack "${pack.name}" cho video sản xuất tiếp theo.`;
  }

  function handleDeleteStylePack(packId: string) {
    stylePacks = stylePacks.filter((p) => p.stylePackId !== packId);
    feedbackMessage = '✓ Đã xóa Style Pack.';
  }
</script>

<div class="max-w-6xl mx-auto px-4 py-8 space-y-6">
  <!-- Header -->
  <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b pb-4">
    <div>
      <div class="flex items-center gap-2">
        <a href="/studio" class="text-xs text-primary-600 hover:underline">← Studio Launcher</a>
        <span class="text-xs text-gray-400">/</span>
        <span class="text-xs font-semibold text-gray-700">W032 Style Learning</span>
      </div>
      <h1 class="text-2xl font-bold text-gray-900 mt-1 flex items-center gap-2">
        <span>🎨</span> Học & Áp dụng Phong cách (Style Learning & Transfer)
      </h1>
      <p class="text-sm text-gray-600 mt-0.5">
        Trích xuất phong cách dựng từ video mẫu thành Style Pack tái sử dụng trên Continuity OS (M07 EF-07).
      </p>
    </div>
    <div class="flex items-center gap-3">
      <div class="px-3 py-1.5 bg-amber-50 border border-amber-200 rounded-lg text-xs font-semibold text-amber-800 flex items-center gap-1.5">
        <span>⚡ Số dư credits:</span>
        <span class="text-sm font-bold">{creditsBalance}</span>
      </div>
    </div>
  </div>

  <!-- Banners -->
  {#if feedbackMessage}
    <div class="p-4 bg-emerald-50 border border-emerald-200 text-emerald-800 text-sm rounded-xl flex items-center justify-between">
      <span>{feedbackMessage}</span>
      <button type="button" onclick={() => (feedbackMessage = '')} class="text-xs font-bold text-emerald-700">✕</button>
    </div>
  {/if}
  {#if errorMessage}
    <div class="p-4 bg-rose-50 border border-rose-200 text-rose-800 text-sm rounded-xl flex items-center justify-between">
      <span>⚠️ {errorMessage}</span>
      <button type="button" onclick={() => (errorMessage = '')} class="text-xs font-bold text-rose-700">✕</button>
    </div>
  {/if}

  <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
    <!-- Left Column: Input Videos & Analysis -->
    <div class="lg:col-span-6 space-y-6">
      <div class="bg-white p-5 border rounded-2xl shadow-sm space-y-4">
        <div class="flex items-center justify-between">
          <h2 class="text-base font-bold text-gray-900 flex items-center gap-2">
            <span>📎</span> 1. Video tham chiếu ({referenceVideos.length}/5)
          </h2>
          <span class="text-xs text-gray-500">Tối thiểu 1, tối đa 5 video</span>
        </div>

        <div class="space-y-2">
          {#each referenceVideos as vid (vid.id)}
            <div class="flex items-center justify-between p-3 bg-gray-50 border rounded-xl text-xs">
              <div class="flex items-center gap-2 overflow-hidden">
                <span class="text-base">🎬</span>
                <span class="font-medium text-gray-800 truncate">{vid.name}</span>
                <span class="text-gray-400">({vid.duration})</span>
              </div>
              <button
                type="button"
                onclick={() => handleRemoveReferenceVideo(vid.id)}
                class="text-gray-400 hover:text-rose-600 font-bold px-2 py-1 rounded"
                title="Xóa video này"
              >
                ✕
              </button>
            </div>
          {/each}
        </div>

        {#if referenceVideos.length < 5}
          <div class="flex gap-2">
            <input
              type="text"
              bind:value={newVideoName}
              placeholder="Tên file hoặc URL video tham chiếu..."
              class="flex-1 px-3 py-2 border rounded-xl text-xs focus:ring-2 focus:ring-primary-500 outline-none"
            />
            <button
              type="button"
              onclick={handleAddReferenceVideo}
              class="px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-800 text-xs font-semibold rounded-xl"
            >
              + Thêm video
            </button>
          </div>
        {/if}

        <div class="p-3 bg-blue-50/70 border border-blue-100 rounded-xl text-xs text-blue-800 space-y-1">
          <div class="font-semibold">💡 Báo giá trích xuất phong cách (EF-07):</div>
          <p>Mỗi lượt phân tích tối đa 5 video có chi phí cố định là <strong>15 credits</strong>. Phong cách sau khi học sẽ lưu trực tiếp vào kho Continuity OS của workspace.</p>
        </div>

        <button
          type="button"
          onclick={handleAnalyzeStyle}
          disabled={isAnalyzing || referenceVideos.length === 0}
          class="w-full py-3 bg-primary-600 hover:bg-primary-700 disabled:opacity-50 text-white text-sm font-bold rounded-xl shadow-sm transition flex items-center justify-center gap-2 cursor-pointer"
        >
          {#if isAnalyzing}
            <div class="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
            <span>Đang giải mã Creative DNA & trích xuất phong cách...</span>
          {:else}
            <span>🔍 Phân tích phong cách — 15 credits (Đã báo giá)</span>
          {/if}
        </button>
      </div>

      <!-- Saved Style Packs List -->
      <div class="bg-white p-5 border rounded-2xl shadow-sm space-y-4">
        <div class="flex items-center justify-between">
          <h2 class="text-base font-bold text-gray-900 flex items-center gap-2">
            <span>📚</span> Kho Style Pack ({stylePacks.length})
          </h2>
          <a href="/continuity" class="text-xs text-primary-600 hover:underline">Quản lý trên Continuity OS →</a>
        </div>

        <div class="space-y-3">
          {#each stylePacks as pack (pack.stylePackId)}
            <div class="p-4 border rounded-xl space-y-2 hover:border-gray-300 transition">
              <div class="flex items-center justify-between">
                <span class="font-bold text-sm text-gray-900">{pack.name}</span>
                <span class="px-2 py-0.5 bg-emerald-50 text-emerald-700 border border-emerald-200 text-[10px] font-semibold rounded-md">
                  Đang kích hoạt
                </span>
              </div>
              <div class="text-xs text-gray-600 line-clamp-2">
                {pack.extractedStyle.colorPalette} · Nhịp: {pack.extractedStyle.cutPacing} · {pack.extractedStyle.transitions}
              </div>
              <div class="flex items-center justify-between pt-2 border-t text-xs">
                <span class="text-gray-400 text-[11px]">Tạo ngày: {pack.createdAt.substring(0, 10)}</span>
                <div class="flex items-center gap-2">
                  <button
                    type="button"
                    onclick={() => handleApplyStylePack(pack)}
                    class="px-3 py-1 bg-primary-50 text-primary-700 hover:bg-primary-100 font-semibold rounded-lg text-xs"
                  >
                    ▶ Áp dụng
                  </button>
                  <button
                    type="button"
                    onclick={() => handleDeleteStylePack(pack.stylePackId)}
                    class="text-gray-400 hover:text-rose-600 px-2 py-1 text-xs"
                  >
                    Xóa
                  </button>
                </div>
              </div>
            </div>
          {/each}
        </div>
      </div>
    </div>

    <!-- Right Column: Extracted Elements & Save -->
    <div class="lg:col-span-6 space-y-6">
      <div class="bg-white p-5 border rounded-2xl shadow-sm space-y-4">
        <h2 class="text-base font-bold text-gray-900 flex items-center gap-2">
          <span>✨</span> 2. Các yếu tố phong cách đã trích xuất (7 Elements)
        </h2>

        {#if extractedElements}
          <div class="grid grid-cols-1 md:grid-cols-2 gap-3 text-xs">
            <div class="p-3 bg-gray-50 border rounded-xl space-y-1.5">
              <div class="font-semibold text-gray-700 flex items-center gap-1.5">
                <span>🎨</span> Bảng màu (Color Palette)
              </div>
              <div class="text-gray-900 font-medium">{extractedElements.colorPalette}</div>
              <div class="flex items-center gap-1.5 pt-1">
                {#each extractedElements.colorPaletteHex as hex}
                  <div class="w-5 h-5 rounded-md border border-gray-300 shadow-xs" style="background-color: {hex}" title={hex}></div>
                {/each}
              </div>
            </div>

            <div class="p-3 bg-gray-50 border rounded-xl space-y-1.5">
              <div class="font-semibold text-gray-700 flex items-center gap-1.5">
                <span>✂️</span> Nhịp cắt (Cut Pacing)
              </div>
              <div class="text-gray-900 font-medium">{extractedElements.cutPacing}</div>
              <div class="text-gray-500 text-[11px]">Độ dài trung bình: {extractedElements.avgCutDurationMs}ms</div>
            </div>

            <div class="p-3 bg-gray-50 border rounded-xl space-y-1.5">
              <div class="font-semibold text-gray-700 flex items-center gap-1.5">
                <span>📝</span> Kiểu chữ & Caption (Text Style)
              </div>
              <div class="text-gray-900 font-medium">{extractedElements.textStyle}</div>
            </div>

            <div class="p-3 bg-gray-50 border rounded-xl space-y-1.5">
              <div class="font-semibold text-gray-700 flex items-center gap-1.5">
                <span>🎵</span> Phong cách âm nhạc (Music Style)
              </div>
              <div class="text-gray-900 font-medium">{extractedElements.musicStyle}</div>
            </div>

            <div class="p-3 bg-gray-50 border rounded-xl space-y-1.5">
              <div class="font-semibold text-gray-700 flex items-center gap-1.5">
                <span>🎬</span> Chuyển cảnh (Transitions)
              </div>
              <div class="text-gray-900 font-medium">{extractedElements.transitions}</div>
            </div>

            <div class="p-3 bg-gray-50 border rounded-xl space-y-1.5">
              <div class="font-semibold text-gray-700 flex items-center gap-1.5">
                <span>📊</span> Mẫu Hook (Hook Pattern)
              </div>
              <div class="text-gray-900 font-medium">{extractedElements.hookPattern}</div>
            </div>

            <div class="p-3 bg-gray-50 border rounded-xl space-y-1.5 md:col-span-2">
              <div class="font-semibold text-gray-700 flex items-center gap-1.5">
                <span>🎭</span> Mood hình ảnh (Visual Mood)
              </div>
              <div class="text-gray-900 font-medium">{extractedElements.visualMood}</div>
            </div>
          </div>

          <!-- Save to Continuity OS section -->
          <div class="pt-4 border-t space-y-3">
            <div>
              <label for="pack-name-input" class="block text-xs font-semibold text-gray-900 mb-1">
                Tên Style Pack lưu trữ
              </label>
              <input
                id="pack-name-input"
                type="text"
                bind:value={packName}
                placeholder="Ví dụ: My Skincare Style..."
                class="w-full px-3 py-2 border rounded-xl text-sm focus:ring-2 focus:ring-primary-500 outline-none"
              />
            </div>

            <div class="flex items-center gap-3">
              <button
                type="button"
                onclick={handleSaveStylePack}
                disabled={isSaving}
                class="flex-1 py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs rounded-xl shadow-xs transition cursor-pointer"
              >
                💾 Lưu vào Continuity OS
              </button>
              <a
                href="/studio/multi-merge"
                class="px-4 py-2.5 bg-gray-100 hover:bg-gray-200 text-gray-800 font-semibold text-xs rounded-xl transition text-center"
              >
                ▶ Áp dụng cho Multi-Merge
              </a>
            </div>
          </div>
        {:else}
          <div class="py-16 text-center text-gray-400 space-y-3">
            <span class="text-4xl block">🎨</span>
            <p class="text-sm font-medium">Chưa có phong cách nào được phân tích</p>
            <p class="text-xs text-gray-500 max-w-sm mx-auto">
              Tải lên từ 1 đến 5 video tham chiếu và nhấn "Phân tích phong cách" để AI giải mã Creative DNA và trích xuất 7 yếu tố phong cách.
            </p>
          </div>
        {/if}
      </div>
    </div>
  </div>
</div>
