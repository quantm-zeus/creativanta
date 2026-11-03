<script lang="ts">
  import {
    CharacterQuotaIndicator,
    CharacterCard,
    CharacterWizard,
    type Character,
    isSlotQuotaExceeded,
  } from '$lib/continuity';

  let showBuilder = false;
  let workspaceTier = 'free';

  let characters: Character[] = [
    {
      characterId: 'char-mai-01',
      workspaceId: 'ws-studio',
      name: 'Mai',
      characterType: 'ai_generated',
      description: 'Nữ · 25-30 · Phong cách: Ấm áp, tự nhiên · Cố vấn làm đẹp',
      speakingTone: 'Ấm áp',
      personalityTags: ['làm đẹp', 'tự nhiên', 'nữ'],
      isDefault: true,
      consentVerified: true,
      status: 'ready',
      createdAt: '2026-10-30T10:00:00Z',
      updatedAt: '2026-10-30T10:00:00Z',
    },
  ];

  $: activeCount = characters.filter((c) => c.status !== 'archived').length;
  $: quotaExceeded = isSlotQuotaExceeded(activeCount, workspaceTier);

  function handleSetDefault(charId: string) {
    characters = characters.map((c) => ({
      ...c,
      isDefault: c.characterId === charId,
    }));
  }

  function handleArchive(charId: string) {
    characters = characters.map((c) => {
      if (c.characterId === charId) {
        return { ...c, status: 'archived', isDefault: false };
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
      workspaceId: 'ws-studio',
      name: data.name,
      characterType: data.characterType,
      description: data.description,
      speakingTone: 'Tự nhiên',
      personalityTags: ['studio'],
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
    showBuilder = false;
  }
</script>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-6">
  <!-- Screen Header (W037) -->
  <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b">
    <div>
      <div class="flex items-center gap-2">
        <span class="text-2xl">🎭</span>
        <h1 class="text-2xl font-bold text-gray-900 tracking-tight">Thư viện nhân vật (Characters — W037)</h1>
      </div>
      <p class="text-sm text-gray-500 mt-1">
        Tạo và quản lý nhân vật video AI nhất quán cho video demo sản phẩm, hướng dẫn và nội dung UGC.
      </p>
    </div>

    <button
      type="button"
      on:click={() => (showBuilder = true)}
      class="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-xl text-xs font-semibold shadow-sm transition-colors flex items-center gap-1.5"
    >
      <span>➕</span> Tạo character mới
    </button>
  </div>

  <!-- Quota Indicator (RULE-M08-003) -->
  <CharacterQuotaIndicator
    {activeCount}
    tier={workspaceTier}
    onUpgradeClick={() => alert('Nâng cấp gói lên Pro để mở thêm slot nhân vật')}
  />

  {#if showBuilder}
    <div class="py-4">
      <CharacterWizard
        {workspaceTier}
        activeCharacterCount={activeCount}
        isQuotaExceeded={quotaExceeded}
        onCancel={() => (showBuilder = false)}
        onSave={handleSaveCharacter}
      />
    </div>
  {:else}
    <!-- 3-Column Character Grid (W037) -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
      {#each characters as char (char.characterId)}
        <CharacterCard
          character={char}
          onSetDefault={() => handleSetDefault(char.characterId)}
          onArchive={() => handleArchive(char.characterId)}
          onEdit={() => (showBuilder = true)}
          onUseInStudio={() => alert(`Đưa nhân vật ${char.name} vào chế độ AI Studio`)}
        />
      {/each}
    </div>
  {/if}
</div>
