<script lang="ts">
  import type { Character } from './types';

  interface Props {
    character: Character;
    onSetDefault?: (characterId: string) => void;
    onArchive?: (characterId: string) => void;
    onDelete?: (characterId: string) => void;
    onEdit?: (character: Character) => void;
    onUseInStudio?: (characterId: string) => void;
  }

  let { character, onSetDefault, onArchive, onDelete, onEdit, onUseInStudio }: Props = $props();

  let typeLabel = $derived.by(() => {
    switch (character.characterType) {
      case 'digital_twin':
        return 'Digital Twin';
      case 'ai_generated':
        return 'AI Persona';
      case 'stock':
        return 'Stock Avatar';
      default:
        return character.characterType;
    }
  });
</script>

<div class="bg-white border rounded-xl overflow-hidden shadow-sm hover:shadow-md transition-shadow flex flex-col justify-between">
  <div class="p-5">
    <div class="flex items-start justify-between gap-3 mb-3">
      <div class="flex items-center gap-3">
        {#if character.avatarUrl}
          <img
            src={character.avatarUrl}
            alt={character.name}
            class="w-12 h-12 rounded-full object-cover border border-gray-200"
          />
        {:else}
          <div class="w-12 h-12 rounded-full bg-primary-100 text-primary-700 font-bold flex items-center justify-center text-lg">
            {character.name.charAt(0).toUpperCase()}
          </div>
        {/if}

        <div>
          <div class="flex items-center gap-2">
            <h3 class="font-bold text-gray-900 text-base">{character.name}</h3>
            {#if character.isDefault}
              <span class="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-xs font-semibold bg-amber-100 text-amber-800 border border-amber-300">
                ⭐ Mặc định
              </span>
            {/if}
          </div>
          <span class="text-xs font-medium px-2 py-0.5 rounded bg-gray-100 text-gray-700">
            {typeLabel}
          </span>
        </div>
      </div>
    </div>

    {#if character.description}
      <p class="text-xs text-gray-600 line-clamp-2 mb-3">
        {character.description}
      </p>
    {/if}

    <div class="space-y-1.5 text-xs text-gray-500 mb-4">
      {#if character.characterType === 'digital_twin'}
        <div class="flex items-center gap-1.5">
          <span class="font-medium">Chấp thuận chân dung:</span>
          {#if character.consentVerified}
            <span class="text-emerald-700 font-semibold bg-emerald-50 px-1.5 py-0.5 rounded">
              ✓ Đã xác thực
            </span>
          {:else}
            <span class="text-rose-700 font-semibold bg-rose-50 px-1.5 py-0.5 rounded">
              ✕ Chưa xác thực / Bị thu hồi
            </span>
          {/if}
        </div>
      {/if}

      {#if character.speakingTone}
        <div class="flex items-center gap-1.5">
          <span class="font-medium">Giọng điệu:</span>
          <span class="text-gray-800">{character.speakingTone}</span>
        </div>
      {/if}

      {#if character.personalityTags && character.personalityTags.length > 0}
        <div class="flex flex-wrap gap-1 mt-2">
          {#each character.personalityTags as tag}
            <span class="px-1.5 py-0.5 bg-gray-50 border border-gray-200 text-gray-600 rounded text-[11px]">
              #{tag}
            </span>
          {/each}
        </div>
      {/if}
    </div>
  </div>

  <div class="bg-gray-50 px-5 py-3 border-t flex items-center justify-between gap-2">
    <div class="flex items-center gap-2">
      {#if !character.isDefault && onSetDefault}
        <button
          type="button"
          onclick={() => onSetDefault(character.characterId)}
          class="text-xs font-medium text-gray-600 hover:text-amber-700 hover:underline cursor-pointer"
        >
          Đặt làm mặc định
        </button>
      {/if}
      {#if onArchive}
        <button
          type="button"
          onclick={() => onArchive(character.characterId)}
          class="text-xs font-medium text-gray-600 hover:text-gray-900 hover:underline cursor-pointer"
          title="Lưu trữ nhân vật để giải phóng slot (A4)"
        >
          Lưu trữ
        </button>
      {/if}
    </div>

    <div class="flex items-center gap-2">
      {#if onUseInStudio}
        <button
          type="button"
          onclick={() => onUseInStudio(character.characterId)}
          class="px-3 py-1.5 bg-primary-600 hover:bg-primary-700 text-white rounded-lg text-xs font-medium shadow-sm transition-colors cursor-pointer"
        >
          Sử dụng
        </button>
      {/if}
      {#if onEdit}
        <button
          type="button"
          onclick={() => onEdit(character)}
          class="px-2.5 py-1.5 bg-white border hover:bg-gray-50 text-gray-700 rounded-lg text-xs font-medium transition-colors cursor-pointer"
        >
          Sửa
        </button>
      {/if}
    </div>
  </div>
</div>
