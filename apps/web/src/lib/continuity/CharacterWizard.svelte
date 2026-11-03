<script lang="ts">
  import type { CharacterType } from './types';
  import ConsentModal from './ConsentModal.svelte';

  interface Props {
    workspaceTier?: string;
    activeCharacterCount?: number;
    isQuotaExceeded?: boolean;
    onCancel?: () => void;
    onSave?: (data: {
      name: string;
      characterType: CharacterType;
      description: string;
      voiceSettingsJson: string;
      visualSettingsJson: string;
      isDefault: boolean;
      consentRecordId: string;
      previewVerified: boolean;
    }) => void;
  }

  let {
    workspaceTier = 'free',
    activeCharacterCount = 0,
    isQuotaExceeded = false,
    onCancel,
    onSave,
  }: Props = $props();

  let currentStep = $state(1); // 1: Type -> 2: Profile -> 3: Preview -> 4: Save
  let characterType = $state<CharacterType>('ai_generated');
  let name = $state('');
  let description = $state('');
  let avatarUrl = $state('');
  let speakingTone = $state('friendly');
  let personalityTagsInput = $state('chuyên gia, thân thiện');
  let voicePreset = $state('ai_voice_vi_female_01');
  let isDefault = $state(false);

  // Digital Twin Likeness Consent state (RULE-M08-002, EC-M08-001)
  let consentVerified = $state(false);
  let consentRecordId = $state('');
  let showConsentModal = $state(false);

  // Step 3 Preview State (RULE-M08-001, AC 1)
  let previewVerified = $state(false);
  let previewVideoUrl = $state('');
  let isGeneratingPreview = $state(false);

  let errorMsg = $state('');

  function handleTypeSelect(type: CharacterType) {
    if (type === 'digital_twin' && workspaceTier === 'free') {
      errorMsg = 'Tính năng Digital Twin chỉ dành cho gói Pro trở lên (PRD §23.8). Vui lòng nâng cấp gói.';
      return;
    }
    errorMsg = '';
    characterType = type;
    if (type === 'digital_twin' && !consentVerified) {
      showConsentModal = true;
    }
  }

  function handleConsentGranted(payload: { sourceFootageUrl: string; consentVideoUrl: string }) {
    consentVerified = true;
    consentRecordId = 'consent_' + Date.now();
    showConsentModal = false;
  }

  function goToStep2() {
    errorMsg = '';
    if (characterType === 'digital_twin' && !consentVerified) {
      errorMsg = 'Nhân vật Digital Twin bắt buộc phải hoàn thành xác thực chân dung trước khi tiếp tục (RULE-M08-002).';
      showConsentModal = true;
      return;
    }
    currentStep = 2;
  }

  function goToStep3() {
    errorMsg = '';
    if (!name.trim()) {
      errorMsg = 'Vui lòng nhập tên nhân vật trước khi tạo bản xem trước.';
      return;
    }
    currentStep = 3;
    if (!previewVerified) {
      generatePreviewVideo();
    }
  }

  function generatePreviewVideo() {
    isGeneratingPreview = true;
    setTimeout(() => {
      isGeneratingPreview = false;
      previewVerified = true;
      previewVideoUrl = 'https://cdn.creativanta.io/previews/15s_test_video_' + Date.now() + '.mp4';
    }, 600);
  }

  function goToStep4() {
    errorMsg = '';
    if (!previewVerified) {
      errorMsg = 'Hệ thống yêu cầu xác thực video xem trước 15s trước khi lưu nhân vật (RULE-M08-001, AC 1).';
      return;
    }
    currentStep = 4;
  }

  function handleFinalSave() {
    errorMsg = '';
    if (!name.trim()) {
      errorMsg = 'Tên nhân vật không được để trống.';
      return;
    }
    if (!previewVerified) {
      errorMsg = 'Chưa xác thực video xem trước (Step 3).';
      return;
    }

    onSave?.({
      name,
      characterType,
      description,
      voiceSettingsJson: JSON.stringify({ preset: voicePreset, tone: speakingTone }),
      visualSettingsJson: JSON.stringify({ avatarUrl, tags: personalityTagsInput.split(',').map((s) => s.trim()) }),
      isDefault,
      consentRecordId,
      previewVerified,
    });
  }
</script>

<div class="bg-white border rounded-2xl p-6 shadow-sm max-w-2xl mx-auto space-y-6">
  <!-- Wizard Step Indicator -->
  <div class="flex items-center justify-between pb-4 border-b">
    <div>
      <span class="text-xs uppercase font-bold text-primary-600 tracking-wider">Trình tạo nhân vật 4 bước (RULE-M08-001)</span>
      <h2 class="text-lg font-bold text-gray-900 mt-0.5">
        {#if currentStep === 1}Bước 1: Chọn loại nhân vật (Character Type)
        {:else if currentStep === 2}Bước 2: Thiết lập hồ sơ (Profile & Voice)
        {:else if currentStep === 3}Bước 3: Video xem trước 15s (Preview Test)
        {:else}Bước 4: Lưu & Cấu hình mặc định (Save & Settings){/if}
      </h2>
    </div>

    <!-- Stepper pills -->
    <div class="flex items-center gap-1.5 text-xs font-semibold">
      {#each [1, 2, 3, 4] as s}
        <span
          class="w-6 h-6 rounded-full flex items-center justify-center transition-colors {currentStep === s ? 'bg-primary-600 text-white' : currentStep > s ? 'bg-emerald-100 text-emerald-800' : 'bg-gray-100 text-gray-500'}"
        >
          {s}
        </span>
      {/each}
    </div>
  </div>

  {#if isQuotaExceeded}
    <div class="p-4 bg-rose-50 border border-rose-200 rounded-xl text-xs text-rose-800 space-y-2">
      <p class="font-bold">⚠️ Đã đạt hạn ngạch số lượng nhân vật cho gói {workspaceTier} ({activeCharacterCount} nhân vật).</p>
      <p>Hệ thống chặn tạo nhân vật mới theo quy tắc RULE-M08-003. Vui lòng nâng cấp gói hoặc lưu trữ bớt nhân vật hiện có để tiếp tục.</p>
    </div>
  {/if}

  {#if errorMsg}
    <div class="p-3 bg-rose-50 border border-rose-200 text-rose-700 rounded-lg text-xs font-medium">
      {errorMsg}
    </div>
  {/if}

  <!-- STEP 1: CHOOSE TYPE -->
  {#if currentStep === 1}
    <div class="space-y-4">
      <div class="grid grid-cols-1 md:grid-cols-3 gap-3">
        <!-- AI Generated -->
        <button
          type="button"
          onclick={() => handleTypeSelect('ai_generated')}
          class="p-4 border-2 rounded-xl text-left transition-all cursor-pointer {characterType === 'ai_generated' ? 'border-primary-600 bg-primary-50/50' : 'border-gray-200 hover:border-gray-300'}"
        >
          <div class="text-2xl mb-2">🤖</div>
          <div class="font-bold text-gray-900 text-sm">AI Generated</div>
          <p class="text-xs text-gray-500 mt-1">Tạo nhân vật hoàn toàn từ mô tả văn bản và kiểu dáng AI.</p>
        </button>

        <!-- Digital Twin -->
        <button
          type="button"
          onclick={() => handleTypeSelect('digital_twin')}
          class="p-4 border-2 rounded-xl text-left transition-all relative cursor-pointer {characterType === 'digital_twin' ? 'border-primary-600 bg-primary-50/50' : 'border-gray-200 hover:border-gray-300'}"
        >
          <div class="text-2xl mb-2">👤</div>
          <div class="font-bold text-gray-900 text-sm">Digital Twin</div>
          <p class="text-xs text-gray-500 mt-1">Bản sao chân thực từ video thực tế. Yêu cầu xác thực chân dung.</p>
          {#if consentVerified}
            <span class="absolute top-2 right-2 px-1.5 py-0.5 bg-emerald-100 text-emerald-800 text-[10px] font-bold rounded">
              ✓ Đã duyệt
            </span>
          {/if}
        </button>

        <!-- Stock Avatar -->
        <button
          type="button"
          onclick={() => handleTypeSelect('stock')}
          class="p-4 border-2 rounded-xl text-left transition-all cursor-pointer {characterType === 'stock' ? 'border-primary-600 bg-primary-50/50' : 'border-gray-200 hover:border-gray-300'}"
        >
          <div class="text-2xl mb-2">🎭</div>
          <div class="font-bold text-gray-900 text-sm">Stock Avatar</div>
          <p class="text-xs text-gray-500 mt-1">Sử dụng thư viện diễn viên AI có sẵn của Creativanta.</p>
        </button>
      </div>

      <div class="flex items-center justify-end gap-2 pt-4 border-t">
        {#if onCancel}
          <button
            type="button"
            onclick={onCancel}
            class="px-4 py-2 text-xs font-medium text-gray-700 hover:bg-gray-100 rounded-lg cursor-pointer"
          >
            Hủy
          </button>
        {/if}
        <button
          type="button"
          onclick={goToStep2}
          disabled={isQuotaExceeded}
          class="px-5 py-2 bg-primary-600 hover:bg-primary-700 text-white text-xs font-semibold rounded-lg shadow-sm disabled:opacity-50 cursor-pointer"
        >
          Tiếp tục: Hồ sơ →
        </button>
      </div>
    </div>
  {/if}

  <!-- STEP 2: PROFILE SETUP -->
  {#if currentStep === 2}
    <div class="space-y-4 text-xs">
      <div>
        <label for="char-name" class="block font-semibold text-gray-900 mb-1">Tên nhân vật *</label>
        <input
          id="char-name"
          type="text"
          bind:value={name}
          placeholder="Ví dụ: Chef Hùng, MC Mai Anh..."
          class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-primary-500 outline-none text-sm"
        />
      </div>

      <div>
        <label for="char-desc" class="block font-semibold text-gray-900 mb-1">Mô tả đặc điểm & phong thái</label>
        <textarea
          id="char-desc"
          bind:value={description}
          rows="2"
          placeholder="Giọng điệu ấm áp, chuyên nghiệp, tự tin chia sẻ kiến thức ẩm thực..."
          class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-primary-500 outline-none"
        ></textarea>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
        <div>
          <label for="char-tone" class="block font-semibold text-gray-900 mb-1">Giọng điệu (Speaking tone)</label>
          <select
            id="char-tone"
            bind:value={speakingTone}
            class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-primary-500 outline-none"
          >
            <option value="formal">Trang trọng (Formal)</option>
            <option value="casual">Gần gũi (Casual)</option>
            <option value="fun">Hài hước (Fun)</option>
            <option value="energetic">Nhiệt huyết (Energetic)</option>
            <option value="calm">Điềm tĩnh (Calm)</option>
            <option value="inspiring">Truyền cảm hứng (Inspiring)</option>
          </select>
        </div>

        <div>
          <label for="char-voice" class="block font-semibold text-gray-900 mb-1">Giọng đọc (Voice Preset)</label>
          <select
            id="char-voice"
            bind:value={voicePreset}
            class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-primary-500 outline-none"
          >
            <option value="ai_voice_vi_female_01">Nữ Miền Bắc — Tự nhiên (Preset 01)</option>
            <option value="ai_voice_vi_male_01">Nam Miền Bắc — Trầm ấm (Preset 02)</option>
            <option value="ai_voice_vi_female_02">Nữ Miền Nam — Nhẹ nhàng (Preset 03)</option>
            <option value="custom_cloned_voice">Giọng nhân bản (ElevenLabs Cloned)</option>
          </select>
        </div>
      </div>

      <div>
        <label for="char-tags" class="block font-semibold text-gray-900 mb-1">Thẻ tính cách (phân cách bằng dấu phẩy, tối đa 5)</label>
        <input
          id="char-tags"
          type="text"
          bind:value={personalityTagsInput}
          placeholder="nhiệt tình, chuyên gia, hài hước"
          class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-primary-500 outline-none"
        />
      </div>

      <div class="flex items-center justify-between pt-4 border-t">
        <button
          type="button"
          onclick={() => (currentStep = 1)}
          class="px-4 py-2 text-xs font-medium text-gray-700 hover:bg-gray-100 rounded-lg cursor-pointer"
        >
          ← Quay lại
        </button>
        <button
          type="button"
          onclick={goToStep3}
          class="px-5 py-2 bg-primary-600 hover:bg-primary-700 text-white text-xs font-semibold rounded-lg shadow-sm cursor-pointer"
        >
          Tiếp tục: Tạo xem trước 15s →
        </button>
      </div>
    </div>
  {/if}

  <!-- STEP 3: PREVIEW TEST VIDEO (RULE-M08-001, AC 1) -->
  {#if currentStep === 3}
    <div class="space-y-4 text-xs">
      <div class="p-4 bg-gray-50 border rounded-xl space-y-3">
        <div class="flex items-center justify-between">
          <div class="font-bold text-gray-900">Bản xem trước 15 giây (Preview Verification)</div>
          {#if previewVerified}
            <span class="px-2 py-0.5 rounded font-bold bg-emerald-100 text-emerald-800 text-[11px]">
              ✓ Đã xác thực
            </span>
          {/if}
        </div>
        <p class="text-gray-600">
          Theo tiêu chí chấp nhận AC 1: Hệ thống tạo video thử nghiệm 15 giây kết hợp ngoại hình và giọng đọc để bạn duyệt trước khi lưu vào thư viện. Bạn có thể quay lại Bước 2 để tinh chỉnh bất kỳ lúc nào.
        </p>

        {#if isGeneratingPreview}
          <div class="py-8 text-center text-gray-500 font-medium space-y-2">
            <div class="animate-spin w-6 h-6 border-2 border-primary-600 border-t-transparent rounded-full mx-auto"></div>
            <div>Đang render video thử nghiệm 15s...</div>
          </div>
        {:else if previewVideoUrl}
          <div class="aspect-video bg-black/90 rounded-lg overflow-hidden flex items-center justify-center text-white relative">
            <div class="text-center p-4">
              <span class="text-3xl block mb-2">▶️</span>
              <p class="font-semibold text-sm">Xem trước: {name} (15 giây)</p>
              <p class="text-[11px] text-gray-400 mt-1">Giọng điệu: {speakingTone} · Tỷ lệ: 9:16 & 16:9</p>
            </div>
          </div>
        {/if}
      </div>

      <div class="flex items-center justify-between pt-4 border-t">
        <button
          type="button"
          onclick={() => (currentStep = 2)}
          class="px-4 py-2 text-xs font-medium text-gray-700 hover:bg-gray-100 rounded-lg cursor-pointer"
        >
          ← Quay lại Bước 2 điều chỉnh
        </button>
        <button
          type="button"
          onclick={goToStep4}
          disabled={!previewVerified}
          class="px-5 py-2 bg-primary-600 hover:bg-primary-700 text-white text-xs font-semibold rounded-lg shadow-sm disabled:opacity-50 cursor-pointer"
        >
          Tiếp tục: Lưu nhân vật →
        </button>
      </div>
    </div>
  {/if}

  <!-- STEP 4: SAVE & SETTINGS (RULE-M08-006, RULE-M08-004) -->
  {#if currentStep === 4}
    <div class="space-y-4 text-xs">
      <div class="p-4 bg-gray-50 border rounded-xl space-y-2.5">
        <div class="font-bold text-gray-900 text-sm">Xác nhận thông tin nhân vật</div>
        <div class="grid grid-cols-2 gap-2 text-gray-700">
          <div><span class="font-medium text-gray-900">Tên:</span> {name}</div>
          <div><span class="font-medium text-gray-900">Loại:</span> {characterType}</div>
          <div><span class="font-medium text-gray-900">Giọng đọc:</span> {voicePreset}</div>
          <div><span class="font-medium text-gray-900">Giọng điệu:</span> {speakingTone}</div>
        </div>
      </div>

      <!-- Single default character setting (RULE-M08-006) -->
      <div class="p-3 bg-amber-50/60 border border-amber-200 rounded-xl space-y-1">
        <label class="flex items-start gap-2.5 cursor-pointer">
          <input
            type="checkbox"
            bind:checked={isDefault}
            class="mt-0.5 rounded text-amber-600 focus:ring-amber-500"
          />
          <div>
            <span class="font-bold text-gray-900">Đặt làm nhân vật mặc định của workspace</span>
            <p class="text-[11px] text-gray-600 mt-0.5">
              Mỗi workspace chỉ có tối đa 1 nhân vật mặc định (RULE-M08-006). Khi chọn, nhân vật này sẽ tự động được chọn khi bạn bắt đầu tạo video trong Studio.
            </p>
          </div>
        </label>
      </div>

      <div class="flex items-center justify-between pt-4 border-t">
        <button
          type="button"
          onclick={() => (currentStep = 3)}
          class="px-4 py-2 text-xs font-medium text-gray-700 hover:bg-gray-100 rounded-lg cursor-pointer"
        >
          ← Quay lại Bước 3
        </button>
        <button
          type="button"
          onclick={handleFinalSave}
          class="px-5 py-2 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold rounded-lg shadow-sm cursor-pointer"
        >
          💾 Lưu vào thư viện & Tạo Character Pack
        </button>
      </div>
    </div>
  {/if}
</div>

<ConsentModal
  show={showConsentModal}
  onClose={() => (showConsentModal = false)}
  onGrant={handleConsentGranted}
/>
