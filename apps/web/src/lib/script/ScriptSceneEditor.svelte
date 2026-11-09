<script lang="ts">
  import {
    calculateTotalDuration,
    calculateWordCount,
    cloneScenes,
    updateSceneInList,
    updateShotInList,
    validateScenesForSubmission,
    type Scene,
    type Shot
  } from './index';

  interface Props {
    scenes: Scene[];
    onUpdateScenes: (scenes: Scene[]) => void;
  }

  let { scenes = $bindable([]), onUpdateScenes }: Props = $props();

  let totalDuration = $derived(calculateTotalDuration(scenes));
  let totalWords = $derived(calculateWordCount(scenes));
  let validation = $derived(validateScenesForSubmission(scenes));

  function updateSceneField(sceneIndex: number, patch: Partial<Scene>) {
    scenes = updateSceneInList(scenes, sceneIndex, patch);
    onUpdateScenes(scenes);
  }

  function updateShotField(sceneIndex: number, shotIndex: number, patch: Partial<Shot>) {
    scenes = updateShotInList(scenes, sceneIndex, shotIndex, patch);
    onUpdateScenes(scenes);
  }

  function addScene() {
    const newScene: Scene = {
      sceneId: `sc-${Date.now()}`,
      scriptId: '',
      workspaceId: '',
      sceneIndex: scenes.length,
      description: `Phân cảnh #${scenes.length + 1}`,
      content: '',
      durationSeconds: 10,
      visualNotes: '',
      audioNotes: '',
      shotList: [],
      createdAt: new Date().toISOString()
    };
    scenes = [...cloneScenes(scenes), newScene];
    onUpdateScenes(scenes);
  }

  function removeScene(index: number) {
    scenes = cloneScenes(scenes)
      .filter((_, i) => i !== index)
      .map((sc, i) => ({ ...sc, sceneIndex: i }));
    onUpdateScenes(scenes);
  }

  function addShot(sceneIndex: number) {
    const cloned = cloneScenes(scenes);
    const target = cloned[sceneIndex];
    if (!target) return;
    const newShot: Shot = {
      shotId: `sh-${Date.now()}`,
      sceneId: target.sceneId,
      workspaceId: '',
      shotIndex: target.shotList.length,
      shotType: 'Medium Shot',
      description: '',
      durationSeconds: 3,
      createdAt: new Date().toISOString()
    };
    target.shotList = [...target.shotList, newShot];
    scenes = cloned;
    onUpdateScenes(scenes);
  }

  function removeShot(sceneIndex: number, shotIndex: number) {
    const cloned = cloneScenes(scenes);
    const target = cloned[sceneIndex];
    if (!target) return;
    target.shotList = target.shotList
      .filter((_, i) => i !== shotIndex)
      .map((sh, i) => ({ ...sh, shotIndex: i }));
    scenes = cloned;
    onUpdateScenes(scenes);
  }
</script>

<div class="space-y-6" data-testid="script-scene-editor">
  <div class="flex items-center justify-between rounded-xl bg-slate-50 p-4 border border-slate-200">
    <div class="flex items-center gap-6 text-sm">
      <div>
        <span class="text-xs text-gray-500 uppercase font-semibold">Tổng thời lượng:</span>
        <p class="text-lg font-bold text-slate-800">{totalDuration}s</p>
      </div>
      <div>
        <span class="text-xs text-gray-500 uppercase font-semibold">Số từ:</span>
        <p class="text-lg font-bold text-slate-800">{totalWords} từ</p>
      </div>
      <div>
        <span class="text-xs text-gray-500 uppercase font-semibold">Số phân cảnh:</span>
        <p class="text-lg font-bold text-slate-800">{scenes.length}</p>
      </div>
    </div>

    {#if !validation.valid}
      <div class="rounded-lg bg-amber-50 px-3 py-1.5 text-xs text-amber-800 border border-amber-200">
        ⚠️ {validation.error}
      </div>
    {/if}
  </div>

  <div class="space-y-4">
    {#each scenes as scene, sceneIdx}
      <div class="rounded-xl border border-gray-200 bg-white p-5 shadow-sm transition hover:border-indigo-300">
        <div class="flex items-center justify-between border-b border-gray-100 pb-3">
          <div class="flex items-center gap-2">
            <span class="rounded bg-indigo-100 px-2 py-0.5 text-xs font-bold text-indigo-700">
              Cảnh #{sceneIdx + 1}
            </span>
            <input
              type="text"
              value={scene.description}
              oninput={(e) =>
                updateSceneField(sceneIdx, {
                  description: (e.currentTarget as HTMLInputElement).value
                })}
              placeholder="Tên hoặc mô tả phân cảnh..."
              class="border-b border-transparent px-1 font-semibold text-gray-800 focus:border-indigo-500 focus:outline-none"
            />
          </div>

          <div class="flex items-center gap-3">
            <div class="flex items-center gap-1.5 text-xs">
              <span class="text-gray-500">Thời lượng:</span>
              <input
                type="number"
                value={scene.durationSeconds}
                oninput={(e) =>
                  updateSceneField(sceneIdx, {
                    durationSeconds: Number((e.currentTarget as HTMLInputElement).value) || 0
                  })}
                min="1"
                class="w-14 rounded border border-gray-200 px-1 py-0.5 text-center font-mono focus:border-indigo-500 focus:outline-none"
              />
              <span class="text-gray-400">giây</span>
            </div>
            <button
              type="button"
              onclick={() => removeScene(sceneIdx)}
              class="text-xs text-gray-400 hover:text-rose-600 focus:outline-none"
              title="Xóa phân cảnh"
            >
              🗑️
            </button>
          </div>
        </div>

        <div class="mt-4 grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label for="scene-content-{sceneIdx}" class="block text-xs font-semibold text-gray-700">
              Nội dung thoại / Lời bình (Content) *
            </label>
            <textarea
              id="scene-content-{sceneIdx}"
              rows={4}
              value={scene.content}
              oninput={(e) =>
                updateSceneField(sceneIdx, {
                  content: (e.currentTarget as HTMLTextAreaElement).value
                })}
              placeholder="Nhập lời thoại của diễn viên hoặc voiceover cho phân cảnh này..."
              class="mt-1 w-full rounded-lg border {scene.content.trim() === '' ? 'border-amber-300 bg-amber-50/30' : 'border-gray-300'} p-3 text-sm focus:border-indigo-500 focus:outline-none"
            ></textarea>
            {#if scene.content.trim() === ''}
              <p class="mt-1 text-[11px] text-amber-600">
                Phân cảnh cần có nội dung trước khi gửi duyệt (EC-M06-001).
              </p>
            {/if}
          </div>

          <div class="space-y-3">
            <div>
              <label for="scene-visual-{sceneIdx}" class="block text-xs font-semibold text-gray-700">Ghi chú hình ảnh (Visual Notes)</label>
              <input
                id="scene-visual-{sceneIdx}"
                type="text"
                value={scene.visualNotes}
                oninput={(e) =>
                  updateSceneField(sceneIdx, {
                    visualNotes: (e.currentTarget as HTMLInputElement).value
                  })}
                placeholder="Góc quay, động tác diễn viên, b-roll minh họa..."
                class="mt-1 w-full rounded-lg border border-gray-300 p-2 text-xs focus:border-indigo-500 focus:outline-none"
              />
            </div>
            <div>
              <label for="scene-audio-{sceneIdx}" class="block text-xs font-semibold text-gray-700">Ghi chú âm thanh (Audio Notes)</label>
              <input
                id="scene-audio-{sceneIdx}"
                type="text"
                value={scene.audioNotes}
                oninput={(e) =>
                  updateSceneField(sceneIdx, {
                    audioNotes: (e.currentTarget as HTMLInputElement).value
                  })}
                placeholder="Nhạc nền, hiệu ứng sound effect sfx, tone giọng..."
                class="mt-1 w-full rounded-lg border border-gray-300 p-2 text-xs focus:border-indigo-500 focus:outline-none"
              />
            </div>
          </div>
        </div>

        <!-- Shots List (§6.6) -->
        <div class="mt-4 rounded-lg bg-gray-50 p-3">
          <div class="flex items-center justify-between">
            <span class="text-xs font-bold text-gray-600 uppercase tracking-wide">
              Danh sách góc máy (Shot List: {scene.shotList.length})
            </span>
            <button
              type="button"
              onclick={() => addShot(sceneIdx)}
              class="text-xs font-semibold text-indigo-600 hover:text-indigo-800"
            >
              + Thêm Shot
            </button>
          </div>

          {#if scene.shotList.length > 0}
            <div class="mt-2 space-y-2">
              {#each scene.shotList as shot, shotIdx}
                <div class="flex items-center gap-3 rounded bg-white p-2 border border-gray-200 text-xs">
                  <span class="font-mono text-gray-400">#{shotIdx + 1}</span>
                  <select
                    value={shot.shotType}
                    onchange={(e) =>
                      updateShotField(sceneIdx, shotIdx, {
                        shotType: (e.currentTarget as HTMLSelectElement).value
                      })}
                    class="rounded border border-gray-200 p-1 text-xs"
                  >
                    <option value="Close Up">Close Up</option>
                    <option value="Medium Shot">Medium Shot</option>
                    <option value="Wide Shot">Wide Shot</option>
                    <option value="POV">POV</option>
                    <option value="Product Macro">Product Macro</option>
                  </select>
                  <input
                    type="text"
                    value={shot.description}
                    oninput={(e) =>
                      updateShotField(sceneIdx, shotIdx, {
                        description: (e.currentTarget as HTMLInputElement).value
                      })}
                    placeholder="Mô tả shot máy..."
                    class="flex-1 rounded border border-gray-200 px-2 py-1 text-xs"
                  />
                  <input
                    type="number"
                    value={shot.durationSeconds}
                    oninput={(e) =>
                      updateShotField(sceneIdx, shotIdx, {
                        durationSeconds: Number((e.currentTarget as HTMLInputElement).value) || 0
                      })}
                    min="1"
                    class="w-12 rounded border border-gray-200 p-1 text-center font-mono text-xs"
                  />
                  <span class="text-gray-400">s</span>
                  <button
                    type="button"
                    onclick={() => removeShot(sceneIdx, shotIdx)}
                    class="text-gray-400 hover:text-rose-600"
                  >
                    ✕
                  </button>
                </div>
              {/each}
            </div>
          {/if}
        </div>
      </div>
    {/each}
  </div>

  <div class="flex justify-center pt-2">
    <button
      type="button"
      onclick={addScene}
      class="inline-flex items-center gap-2 rounded-xl border border-dashed border-indigo-400 bg-indigo-50/50 px-6 py-3 text-sm font-bold text-indigo-700 hover:bg-indigo-50 focus:outline-none"
      data-testid="add-scene-btn"
    >
      <span>+</span> Thêm phân cảnh mới
    </button>
  </div>
</div>
