<script lang="ts">
  import {
    CharacterQuotaIndicator,
    CharacterCard,
    PackLineageTimeline,
    CharacterWizard,
    ConsentModal,
    type Character,
    type ContinuityPack,
    type PackVersion,
    type ConsentRecord,
    isSlotQuotaExceeded,
  } from '$lib/continuity';

  let currentTab: 'characters' | 'brand_packs' | 'voices' = 'characters';
  let showWizard = false;
  let showConsentModal = false;
  let consentRevokeMode = false;
  let workspaceTier = 'free';

  // Sample initial state adhering strictly to Acceptance Targets
  let characters: Character[] = [
    {
      characterId: 'char-01',
      workspaceId: 'ws-demo',
      name: 'Mila',
      characterType: 'ai_generated',
      description: 'Thân thiện, tràn đầy năng lượng, phù hợp video hướng dẫn & giải thích sản phẩm.',
      speakingTone: 'friendly',
      personalityTags: ['năng lượng', 'thân thiện', 'giải thích'],
      isDefault: true, // Target 3: Exactly one default
      consentVerified: true,
      status: 'ready',
      characterPackId: 'pack-mila-01',
      createdAt: '2026-10-30T10:00:00Z',
      updatedAt: '2026-10-30T10:00:00Z',
    },
  ];

  let samplePack: ContinuityPack = {
    packId: 'pack-mila-01',
    workspaceId: 'ws-demo',
    packType: 'character',
    name: 'Mila Character Pack',
    version: 2,
    rulesSummary: 'Góc nghiêng 45 độ, trang phục pastel thanh lịch, ánh sáng tự nhiên.',
    approvedReferences: [
      {
        referenceId: 'ref-01',
        name: 'Mila Headshot 2026',
        mediaUrl: 'https://cdn.creativanta.io/canon/mila_face_v2.png',
        referenceType: 'headshot',
        status: 'approved',
      },
      {
        referenceId: 'ref-02',
        name: 'Mila Voice Sample Warm',
        mediaUrl: 'https://cdn.creativanta.io/canon/mila_voice_warm.wav',
        referenceType: 'voice_sample',
        status: 'approved',
      },
    ],
    status: 'active',
    createdAt: '2026-10-30T10:00:00Z',
    updatedAt: '2026-11-01T15:30:00Z',
  };

  let packLineage: PackVersion[] = [
    {
      versionId: 'ver-01',
      workspaceId: 'ws-demo',
      packId: 'pack-mila-01',
      versionIndex: 1,
      name: 'Mila Character Pack v1',
      packType: 'character',
      approvedReferences: [
        {
          referenceId: 'ref-01-old',
          name: 'Mila Original Headshot',
          mediaUrl: 'https://cdn.creativanta.io/canon/mila_face_v1.png',
          referenceType: 'headshot',
          status: 'superseded',
        },
      ],
      rulesSummary: 'Phiên bản khởi tạo ban đầu',
      status: 'deprecated',
      snapshotReason: 'Khởi tạo hồ sơ nhân vật',
      createdAt: '2026-10-30T10:00:00Z',
    },
    {
      versionId: 'ver-02',
      workspaceId: 'ws-demo',
      packId: 'pack-mila-01',
      versionIndex: 2,
      name: 'Mila Character Pack v2',
      packType: 'character',
      approvedReferences: samplePack.approvedReferences,
      rulesSummary: samplePack.rulesSummary,
      status: 'active',
      snapshotReason: 'Cập nhật ảnh mẫu chuẩn 4K & mẫu giọng tự nhiên',
      createdAt: '2026-11-01T15:30:00Z',
    },
  ];

  let currentConsentRecord: ConsentRecord | null = {
    consentId: 'consent-001',
    userId: 'user-01',
    workspaceId: 'ws-demo',
    consentType: 'digital_twin',
    version: '1.0-GDPR',
    granted: true,
    faceMatchVerified: true,
    createdAt: '2026-10-30T09:00:00Z',
  };

  $: activeCount = characters.filter((c) => c.status !== 'archived').length;
  $: quotaExceeded = isSlotQuotaExceeded(activeCount, workspaceTier);

  // Target 3: Exactly one default character
  function handleSetDefault(charId: string) {
    characters = characters.map((c) => ({
      ...c,
      isDefault: c.characterId === charId,
    }));
  }

  // A4: Archive character to free quota slot
  function handleArchive(charId: string) {
    characters = characters.map((c) => {
      if (c.characterId === charId) {
        return {
          ...c,
          status: 'archived',
          isDefault: false,
        };
      }
      return c;
    });
  }

  function handleSaveCharacter(data: {
    characterType: any;
    name: string;
    description: string;
    isDefault: boolean;
    consentRecordId?: string;
  }) {
    const newChar: Character = {
      characterId: 'char-' + Date.now(),
      workspaceId: 'ws-demo',
      name: data.name,
      characterType: data.characterType,
      description: data.description,
      speakingTone: 'Tự nhiên',
      personalityTags: ['mới'],
      isDefault: data.isDefault,
      consentVerified: data.characterType === 'digital_twin' ? !!data.consentRecordId : true,
      status: 'ready',
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };

    if (newChar.isDefault) {
      characters = characters.map((c) => ({ ...c, isDefault: false }));
    }

    characters = [...characters, newChar];
    showWizard = false;
  }

  // Target 1: Revoked consent blocks generation
  function handleRevokeConsent(payload: { consentId: string; reason: string }) {
    if (currentConsentRecord) {
      currentConsentRecord.granted = false;
      currentConsentRecord.revokedAt = new Date().toISOString();
      currentConsentRecord.revokedReason = payload.reason;
    }
    // Automatically disable all digital twins relying on this consent
    characters = characters.map((c) => {
      if (c.characterType === 'digital_twin') {
        return { ...c, consentVerified: false };
      }
      return c;
    });
    showConsentModal = false;
  }
</script>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-6">
  <!-- Screen Header (W019) -->
  <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b">
    <div>
      <div class="flex items-center gap-2">
        <span class="text-2xl">🧬</span>
        <h1 class="text-2xl font-bold text-gray-900 tracking-tight">Continuity Packs (M08)</h1>
      </div>
      <p class="text-sm text-gray-500 mt-1">
        Hệ thống quản lý tính nhất quán cho AI: Định nghĩa nhân vật, thương hiệu, và giọng đọc dùng xuyên suốt các video.
      </p>
    </div>

    <div class="flex items-center gap-3">
      <button
        type="button"
        on:click={() => {
          consentRevokeMode = currentConsentRecord?.granted ?? false;
          showConsentModal = true;
        }}
        class="px-3.5 py-2 border rounded-xl text-xs font-semibold text-gray-700 bg-white hover:bg-gray-50 shadow-2xs transition-colors flex items-center gap-1.5"
      >
        <span>🛡️</span> {currentConsentRecord?.granted ? 'Quản lý chấp thuận chân dung' : 'Cấp quyền chân dung'}
      </button>

      <button
        type="button"
        on:click={() => (showWizard = true)}
        class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-xl text-xs font-semibold shadow-sm transition-colors flex items-center gap-1.5"
      >
        <span>➕</span> Tạo mới
      </button>
    </div>
  </div>

  <!-- Quota Indicator (RULE-M08-003) -->
  <CharacterQuotaIndicator
    {activeCount}
    tier={workspaceTier}
    onUpgradeClick={() => alert('Chuyển hướng đến cổng đăng ký gói Pro')}
  />

  <!-- Tabs (W019) -->
  <div class="flex items-center gap-2 border-b">
    <button
      type="button"
      on:click={() => (currentTab = 'characters')}
      class="px-4 py-2.5 text-xs font-bold border-b-2 transition-colors flex items-center gap-1.5 {currentTab === 'characters' ? 'border-primary-600 text-primary-600' : 'border-transparent text-gray-500 hover:text-gray-900'}"
    >
      <span>🎭</span> Nhân vật ({characters.length})
    </button>
    <button
      type="button"
      on:click={() => (currentTab = 'brand_packs')}
      class="px-4 py-2.5 text-xs font-bold border-b-2 transition-colors flex items-center gap-1.5 {currentTab === 'brand_packs' ? 'border-primary-600 text-primary-600' : 'border-transparent text-gray-500 hover:text-gray-900'}"
    >
      <span>🎨</span> Brand Packs (1)
    </button>
    <button
      type="button"
      on:click={() => (currentTab = 'voices')}
      class="px-4 py-2.5 text-xs font-bold border-b-2 transition-colors flex items-center gap-1.5 {currentTab === 'voices' ? 'border-primary-600 text-primary-600' : 'border-transparent text-gray-500 hover:text-gray-900'}"
    >
      <span>🎤</span> Voices (1)
    </button>
  </div>

  <!-- Content Area -->
  {#if currentTab === 'characters'}
    <div class="space-y-6">
      <!-- Character Grid -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {#each characters as char (char.characterId)}
          <CharacterCard
            character={char}
            onSetDefault={() => handleSetDefault(char.characterId)}
            onArchive={() => handleArchive(char.characterId)}
            onEdit={() => (showWizard = true)}
            onUseInStudio={() => alert(`Sử dụng ${char.name} trong AI Studio`)}
          />
        {/each}
      </div>

      <!-- Pack Lineage Section (Acceptance Target 2) -->
      <PackLineageTimeline pack={samplePack} versionHistory={packLineage} />
    </div>
  {:else if currentTab === 'brand_packs'}
    <div class="bg-white border rounded-xl p-6 text-center space-y-2">
      <span class="text-3xl block">🎨</span>
      <h3 class="font-bold text-gray-900 text-sm">Spring 2026 Brand Pack</h3>
      <p class="text-xs text-gray-500 max-w-md mx-auto">
        Tập hợp logo, bảng màu, phông chữ và phong cách hình ảnh chuẩn thương hiệu để đưa vào prompt video AI.
      </p>
    </div>
  {:else}
    <div class="bg-white border rounded-xl p-6 text-center space-y-2">
      <span class="text-3xl block">🎤</span>
      <h3 class="font-bold text-gray-900 text-sm">ElevenLabs Cloned Voice Pack</h3>
      <p class="text-xs text-gray-500 max-w-md mx-auto">
        Giọng đọc mẫu đã được kiểm duyệt bản quyền chân dung âm thanh, sẵn sàng cho bộ tạo TTS.
      </p>
    </div>
  {/if}
</div>

<!-- 4-Step Wizard Modal -->
{#if showWizard}
  <div class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm overflow-y-auto">
    <div class="w-full max-w-2xl my-8">
      <CharacterWizard
        {workspaceTier}
        activeCharacterCount={activeCount}
        isQuotaExceeded={quotaExceeded}
        onCancel={() => (showWizard = false)}
        onSave={handleSaveCharacter}
      />
    </div>
  </div>
{/if}

<!-- Consent Modal -->
<ConsentModal
  show={showConsentModal}
  currentRecord={currentConsentRecord}
  isRevokeMode={consentRevokeMode}
  onClose={() => (showConsentModal = false)}
  onGrant={() => {
    if (currentConsentRecord) {
      currentConsentRecord.granted = true;
      currentConsentRecord.revokedAt = undefined;
    }
    showConsentModal = false;
  }}
  onRevoke={handleRevokeConsent}
/>
