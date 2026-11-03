<script lang="ts">
	import {
		validateRemixOriginality,
		validateReferenceUrlClient,
		RemixOriginalityGate,
		CANONICAL_SIMILARITY_THRESHOLD
	} from '$lib/production';
	import type { FidelityLevel, CreativeDNA, OriginalityCheckResult, RemixBlueprint } from '$lib/production';

	// Wizard Phases: 1: Input, 2: DNA Report, 3: Polish & Export
	let currentPhase: 1 | 2 | 3 = 1;

	// Phase 1 inputs
	let inputMode: 'url' | 'upload' = 'url';
	let referenceUrl = 'https://tiktok.com/@creator/video/73918274912';
	let uploadedFileName = '';
	let fidelity: FidelityLevel = 'adapt';
	let topic = 'Mẹo chăm sóc da mùa hè và bí quyết giữ ẩm tự nhiên';
	let characterId = 'char-mila';
	let brandPackId = 'brand-default';
	let targetPlatforms = ['TikTok', 'Reels'];

	// URL Validation state (DRM / Geo-blocked / SSRF detection)
	let urlValidationError: {
		isDRM: boolean;
		isGeoBlocked: boolean;
		errorMessage?: string;
		actionableAdvice?: string;
	} | null = null;

	let isAnalyzing = false;
	let isGenerating = false;
	let isRegenerating = false;

	// Phase 2: Creative DNA Blueprint
	let blueprint: RemixBlueprint | null = null;

	// Phase 3: Originality result & Output
	let originalityResult: OriginalityCheckResult | null = null;
	let customScript = '';
	let isEditingScript = false;

	function handleUrlChange() {
		if (inputMode === 'url' && referenceUrl.trim()) {
			const check = validateReferenceUrlClient(referenceUrl);
			if (!check.isValid) {
				urlValidationError = {
					isDRM: check.isDRM,
					isGeoBlocked: check.isGeoBlocked,
					errorMessage: check.errorMessage,
					actionableAdvice: check.actionableAdvice
				};
			} else {
				urlValidationError = null;
			}
		} else {
			urlValidationError = null;
		}
	}

	async function analyzeReference() {
		if (inputMode === 'url') {
			const check = validateReferenceUrlClient(referenceUrl);
			if (!check.isValid) {
				urlValidationError = {
					isDRM: check.isDRM,
					isGeoBlocked: check.isGeoBlocked,
					errorMessage: check.errorMessage,
					actionableAdvice: check.actionableAdvice
				};
				return;
			}
		}

		isAnalyzing = true;
		urlValidationError = null;

		// Simulated DNA extraction
		setTimeout(() => {
			isAnalyzing = false;
			blueprint = {
				blueprintId: `bp-${Date.now()}`,
				workspaceId: 'ws-current',
				referenceAssetId: 'ref-asset-sample',
				referenceUrl: inputMode === 'url' ? referenceUrl : undefined,
				referenceTranscript: 'Video hướng dẫn quy trình dưỡng da 4 bước buổi tối với kem chống nắng và serum thảo mộc.',
				remixScript: `Kịch bản chuyển thể phong cách năng động: ${topic}. Bước 1 làm sạch sâu, bước 2 cấp ẩm tức thì, bước 3 khóa ẩm toàn diện. Hãy bắt đầu ngay hôm nay!`,
				fidelityLevel: fidelity,
				originalityScore: 82.5,
				similarityPercentage: 17.5,
				status: 'analyzed',
				createdAt: new Date().toISOString(),
				updatedAt: new Date().toISOString(),
				creativeDna: {
					sceneCount: 6,
					hookType: 'Question',
					contentStructureJson: JSON.stringify(['Hook (3s)', 'Problem (5s)', 'Tip 1 (6s)', 'Tip 2 (6s)', 'CTA (5s)', 'Outro (3s)']),
					pacingProfileJson: JSON.stringify({ rhythm: 'Fast-Medium-Fast', avgCutSec: 4.6 }),
					visualStyleJson: JSON.stringify({ palette: 'Bright Vibrant', cameraMotion: 'Quick zooms & whip pans' }),
					audioProfileJson: JSON.stringify({ genre: 'Pop Electronic', voiceMusicRatio: '70/30' }),
					transitionMapJson: JSON.stringify({ intro: 'zoom_in', body: 'crossfade', outro: 'fade_out' }),
					totalDurationSeconds: 28,
					engagementStructureJson: JSON.stringify({ pattern: 'Question-Proof-Action', viralScore: 88 })
				}
			};
			customScript = blueprint.remixScript;
			currentPhase = 2;
		}, 400);
	}

	async function generateRemix() {
		if (!blueprint) return;
		isGenerating = true;

		setTimeout(() => {
			isGenerating = false;
			// Evaluate script similarity
			// If fidelity is match_1to1 and customScript is identical to reference transcript, simulate similarity >= 30%
			let sim = 18.5;
			if (fidelity === 'match_1to1' && customScript.includes('hướng dẫn quy trình dưỡng da 4 bước')) {
				sim = 35.0; // Over canonical 30% limit
			}

			const evalResult = validateRemixOriginality(sim);
			originalityResult = evalResult;

			if (evalResult.passed) {
				blueprint!.status = 'generated';
				blueprint!.similarityPercentage = sim;
				blueprint!.originalityScore = 100 - sim;
			} else {
				blueprint!.status = 'rejected';
				blueprint!.rejectionReason = evalResult.explanation;
			}
			currentPhase = 3;
		}, 500);
	}

	async function regenerateScene() {
		isRegenerating = true;
		setTimeout(() => {
			isRegenerating = false;
			// Lower similarity to 12%
			originalityResult = validateRemixOriginality(12.0);
			if (blueprint) {
				blueprint.status = 'generated';
				blueprint.similarityPercentage = 12.0;
				blueprint.originalityScore = 88.0;
			}
		}, 400);
	}

	function handleSwitchFidelity() {
		fidelity = 'loose';
		if (blueprint) {
			blueprint.fidelityLevel = 'loose';
		}
		currentPhase = 2;
	}

	function handleManualEdit() {
		isEditingScript = true;
	}
</script>

<div class="mx-auto max-w-5xl px-4 py-8 text-neutral-100">
	<!-- Page Header -->
	<div class="mb-6 flex items-center justify-between">
		<div class="flex items-center gap-3">
			<a href="/studio" class="rounded-lg bg-neutral-800 p-2 text-neutral-400 hover:text-white transition-colors">
				←
			</a>
			<div>
				<h1 class="text-2xl font-bold flex items-center gap-2">
					<span>🔄</span> AI Remix Studio
				</h1>
				<p class="text-sm text-neutral-400">
					Phân tích Creative DNA và tái tạo video gốc với rào cản bảo vệ tính độc bản (&lt; {CANONICAL_SIMILARITY_THRESHOLD}% similarity).
				</p>
			</div>
		</div>

		<!-- Step Wizard Indicator -->
		<div class="flex items-center gap-2 text-xs font-medium">
			<span class="rounded px-2.5 py-1 {currentPhase === 1 ? 'bg-primary-600 text-white font-bold' : 'bg-neutral-800 text-neutral-400'}">
				1. Input
			</span>
			<span class="text-neutral-600">→</span>
			<span class="rounded px-2.5 py-1 {currentPhase === 2 ? 'bg-primary-600 text-white font-bold' : 'bg-neutral-800 text-neutral-400'}">
				2. DNA Report
			</span>
			<span class="text-neutral-600">→</span>
			<span class="rounded px-2.5 py-1 {currentPhase === 3 ? 'bg-primary-600 text-white font-bold' : 'bg-neutral-800 text-neutral-400'}">
				3. Polish & Safeguards
			</span>
		</div>
	</div>

	<!-- ========================================================================= -->
	<!-- Phase 1: Input -->
	<!-- ========================================================================= -->
	{#if currentPhase === 1}
		<div class="space-y-6">
			<!-- Reference Input Source -->
			<div class="rounded-xl border border-neutral-800 bg-neutral-900/60 p-6">
				<h2 class="text-base font-semibold mb-4 flex items-center gap-2">
					<span>📎</span> Video nguồn tham khảo
				</h2>

				<div class="flex gap-4 mb-4">
					<button
						type="button"
						on:click={() => { inputMode = 'url'; handleUrlChange(); }}
						class="rounded-lg px-4 py-2 text-sm font-medium transition-colors {inputMode === 'url' ? 'bg-primary-600 text-white' : 'bg-neutral-800 text-neutral-400'}"
					>
						🔗 Dán liên kết video (URL)
					</button>
					<button
						type="button"
						on:click={() => { inputMode = 'upload'; urlValidationError = null; }}
						class="rounded-lg px-4 py-2 text-sm font-medium transition-colors {inputMode === 'upload' ? 'bg-primary-600 text-white' : 'bg-neutral-800 text-neutral-400'}"
					>
						📁 Tải lên tệp video
					</button>
				</div>

				{#if inputMode === 'url'}
					<div>
						<label for="reference-url" class="block text-xs font-medium text-neutral-400 mb-1">
							URL video (TikTok, Instagram Reels, YouTube Shorts, MP4 link):
						</label>
						<input
							id="reference-url"
							type="url"
							bind:value={referenceUrl}
							on:input={handleUrlChange}
							placeholder="https://tiktok.com/@creator/video/..."
							class="w-full rounded-lg border border-neutral-700 bg-neutral-950 px-4 py-2.5 text-sm text-white focus:border-primary-500 focus:outline-none"
						/>
					</div>
				{:else}
					<div class="rounded-lg border-2 border-dashed border-neutral-700 p-8 text-center">
						<div class="text-3xl mb-2">📤</div>
						<p class="text-sm font-medium text-neutral-300">Kéo thả tệp video tại đây hoặc nhấn để chọn</p>
						<p class="text-xs text-neutral-500 mt-1">Hỗ trợ MP4, MOV lên tới 500MB</p>
						{#if uploadedFileName}
							<div class="mt-3 inline-block rounded bg-primary-950 border border-primary-800 px-3 py-1 text-xs text-primary-300">
								✓ {uploadedFileName}
							</div>
						{/if}
					</div>
				{/if}

				<!-- Usable DRM / Geo-blocking Structured Error Banner (EC-M07-R01) -->
				{#if urlValidationError}
					<div
						class="mt-4 rounded-lg border border-amber-500/50 bg-amber-950/30 p-4 text-xs text-amber-200"
						data-testid="drm-error-banner"
					>
						<div class="font-semibold flex items-center gap-1.5 text-amber-300">
							<span>⛔</span> {urlValidationError.errorMessage}
						</div>
						<p class="mt-1 text-neutral-300">
							{urlValidationError.actionableAdvice}
						</p>
						<div class="mt-2.5 flex gap-2">
							<button
								type="button"
								on:click={() => { inputMode = 'upload'; urlValidationError = null; }}
								class="rounded bg-amber-500/20 px-2.5 py-1 text-xs font-medium text-amber-200 hover:bg-amber-500/30 transition-colors"
							>
								📁 Tải lên tệp video thay thế
							</button>
							<button
								type="button"
								on:click={() => { referenceUrl = ''; urlValidationError = null; }}
								class="rounded bg-neutral-800 px-2.5 py-1 text-xs font-medium text-neutral-300 hover:bg-neutral-700 transition-colors"
							>
								🔄 Nhập URL khác
							</button>
						</div>
					</div>
				{/if}
			</div>

			<!-- Settings Panel -->
			<div class="rounded-xl border border-neutral-800 bg-neutral-900/60 p-6 space-y-4">
				<h2 class="text-base font-semibold flex items-center gap-2">
					<span>⚙️</span> Thiết lập Remix & Định hướng nội dung
				</h2>

				<!-- Fidelity Level Selector -->
				<div>
					<span class="block text-xs font-medium text-neutral-400 mb-2">
						Mức độ bám sát kịch bản gốc (Fidelity Level):
					</span>
					<div class="grid grid-cols-1 md:grid-cols-3 gap-3">
						<label
							class="flex cursor-pointer flex-col rounded-lg border p-3.5 transition-all {fidelity === 'match_1to1'
								? 'border-primary-500 bg-primary-950/20'
								: 'border-neutral-800 bg-neutral-950'}"
						>
							<div class="flex items-center gap-2">
								<input type="radio" bind:group={fidelity} value="match_1to1" class="text-primary-600" />
								<span class="font-semibold text-sm">Match 1:1</span>
							</div>
							<span class="text-xs text-neutral-400 mt-1">Bám sát nhịp điệu và kết cấu chính xác.</span>
						</label>

						<label
							class="flex cursor-pointer flex-col rounded-lg border p-3.5 transition-all {fidelity === 'adapt'
								? 'border-primary-500 bg-primary-950/20'
								: 'border-neutral-800 bg-neutral-950'}"
						>
							<div class="flex items-center gap-2">
								<input type="radio" bind:group={fidelity} value="adapt" class="text-primary-600" />
								<span class="font-semibold text-sm">Adapt (Khuyên dùng)</span>
							</div>
							<span class="text-xs text-neutral-400 mt-1">Giữ tinh thần cốt lõi, thay đổi góc nhìn và bối cảnh.</span>
						</label>

						<label
							class="flex cursor-pointer flex-col rounded-lg border p-3.5 transition-all {fidelity === 'loose'
								? 'border-primary-500 bg-primary-950/20'
								: 'border-neutral-800 bg-neutral-950'}"
						>
							<div class="flex items-center gap-2">
								<input type="radio" bind:group={fidelity} value="loose" class="text-primary-600" />
								<span class="font-semibold text-sm">Loose Inspiration</span>
							</div>
							<span class="text-xs text-neutral-400 mt-1">Độc bản cao nhất, chỉ lấy cảm hứng từ cấu trúc hook.</span>
						</label>
					</div>
				</div>

				<!-- Topic input -->
				<div>
					<label for="remix-topic" class="block text-xs font-medium text-neutral-400 mb-1">
						Chủ đề hoặc sản phẩm cần làm mới:
					</label>
					<input
						id="remix-topic"
						type="text"
						bind:value={topic}
						class="w-full rounded-lg border border-neutral-700 bg-neutral-950 px-4 py-2 text-sm text-white focus:border-primary-500 focus:outline-none"
					/>
				</div>

				<!-- Character & Brand -->
				<div class="grid grid-cols-1 md:grid-cols-2 gap-4">
					<div>
						<label for="remix-character" class="block text-xs font-medium text-neutral-400 mb-1">
							Diễn viên / Avatar AI:
						</label>
						<select
							id="remix-character"
							bind:value={characterId}
							class="w-full rounded-lg border border-neutral-700 bg-neutral-950 px-3 py-2 text-sm text-white focus:border-primary-500 focus:outline-none"
						>
							<option value="char-mila">🎭 Mila (Beauty & Lifestyle)</option>
							<option value="char-david">🎭 David (Tech Reviewer)</option>
							<option value="char-elena">🎭 Elena (E-commerce Host)</option>
						</select>
					</div>

					<div>
						<label for="remix-brandpack" class="block text-xs font-medium text-neutral-400 mb-1">
							Brand Pack:
						</label>
						<select
							id="remix-brandpack"
							bind:value={brandPackId}
							class="w-full rounded-lg border border-neutral-700 bg-neutral-950 px-3 py-2 text-sm text-white focus:border-primary-500 focus:outline-none"
						>
							<option value="brand-default">🏷️ Creativanta Official Brand</option>
							<option value="brand-skincare">🏷️ Glow Botanics Studio</option>
						</select>
					</div>
				</div>
			</div>

			<!-- Action CTA -->
			<div class="flex items-center justify-between pt-2">
				<div class="text-xs text-neutral-400 flex items-center gap-1.5">
					<span>💳</span> Chi phí phân tích Creative DNA: <strong>~8 credits</strong>
				</div>
				<button
					type="button"
					on:click={analyzeReference}
					disabled={isAnalyzing || (inputMode === 'url' && !!urlValidationError)}
					class="rounded-lg bg-primary-600 px-6 py-2.5 text-sm font-semibold text-white shadow-lg hover:bg-primary-500 disabled:opacity-50 transition-all flex items-center gap-2"
				>
					{#if isAnalyzing}
						<span>⏳ Đang giải mã DNA...</span>
					{:else}
						<span>🔍 Phân tích Creative DNA</span>
					{/if}
				</button>
			</div>
		</div>
	{/if}

	<!-- ========================================================================= -->
	<!-- Phase 2: Creative DNA Report -->
	<!-- ========================================================================= -->
	{#if currentPhase === 2 && blueprint}
		<div class="space-y-6">
			<div class="rounded-xl border border-neutral-800 bg-neutral-900/60 p-6">
				<div class="flex items-center justify-between mb-4">
					<h2 class="text-base font-semibold flex items-center gap-2">
						<span>🧬</span> Báo cáo Creative DNA đã trích xuất
					</h2>
					<button
						type="button"
						on:click={() => currentPhase = 1}
						class="text-xs text-neutral-400 hover:text-white transition-colors"
					>
						← Thay đổi video nguồn
					</button>
				</div>

				<div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
					<div class="rounded-lg bg-neutral-950 p-3 border border-neutral-800">
						<div class="text-xs text-neutral-400">Thời lượng</div>
						<div class="text-lg font-bold font-mono">{blueprint.creativeDna.totalDurationSeconds}s</div>
					</div>
					<div class="rounded-lg bg-neutral-950 p-3 border border-neutral-800">
						<div class="text-xs text-neutral-400">Số phân cảnh</div>
						<div class="text-lg font-bold font-mono">{blueprint.creativeDna.sceneCount} scenes</div>
					</div>
					<div class="rounded-lg bg-neutral-950 p-3 border border-neutral-800">
						<div class="text-xs text-neutral-400">Loại Hook mở đầu</div>
						<div class="text-lg font-bold text-primary-400">{blueprint.creativeDna.hookType}</div>
					</div>
					<div class="rounded-lg bg-neutral-950 p-3 border border-neutral-800">
						<div class="text-xs text-neutral-400">Fidelity áp dụng</div>
						<div class="text-lg font-bold capitalize text-neutral-200">{blueprint.fidelityLevel}</div>
					</div>
				</div>

				<!-- Visual Timeline Structure Bar -->
				<div class="mb-6">
					<div class="text-xs font-medium text-neutral-400 mb-2">Cấu trúc nhịp điệu phân cảnh:</div>
					<div class="flex h-10 w-full overflow-hidden rounded-lg border border-neutral-700 bg-neutral-950 text-xs">
						<div class="flex items-center justify-center bg-rose-900/60 border-r border-neutral-700 px-2 font-mono text-rose-200" style="width: 15%">
							Hook 3s
						</div>
						<div class="flex items-center justify-center bg-amber-900/60 border-r border-neutral-700 px-2 font-mono text-amber-200" style="width: 20%">
							Problem 5s
						</div>
						<div class="flex items-center justify-center bg-indigo-900/60 border-r border-neutral-700 px-2 font-mono text-indigo-200" style="width: 25%">
							Solution 6s
						</div>
						<div class="flex items-center justify-center bg-purple-900/60 border-r border-neutral-700 px-2 font-mono text-purple-200" style="width: 25%">
							Proof 6s
						</div>
						<div class="flex items-center justify-center bg-emerald-900/60 px-2 font-mono text-emerald-200" style="width: 15%">
							CTA 5s
						</div>
					</div>
				</div>

				<!-- Script Draft Preview -->
				<div class="rounded-lg border border-neutral-800 bg-neutral-950 p-4">
					<div class="flex items-center justify-between mb-2">
						<label for="blueprint-script" class="text-xs font-semibold text-neutral-300">
							Kịch bản Remix dự kiến:
						</label>
						<span class="text-xs text-neutral-500">Được tối ưu để đảm bảo tính độc bản &lt; {CANONICAL_SIMILARITY_THRESHOLD}%</span>
					</div>
					<textarea
						id="blueprint-script"
						bind:value={customScript}
						rows="3"
						class="w-full rounded border border-neutral-800 bg-neutral-900 p-2.5 text-xs text-neutral-200 focus:border-primary-500 focus:outline-none"
					></textarea>
				</div>
			</div>

			<!-- Generate Action CTA -->
			<div class="flex items-center justify-between pt-2">
				<div class="text-xs text-neutral-400 flex items-center gap-1.5">
					<span>💳</span> Tạo video Remix hoàn chỉnh: <strong>~35 credits</strong>
				</div>
				<button
					type="button"
					on:click={generateRemix}
					disabled={isGenerating}
					class="rounded-lg bg-primary-600 px-6 py-2.5 text-sm font-semibold text-white shadow-lg hover:bg-primary-500 disabled:opacity-50 transition-all flex items-center gap-2"
				>
					{#if isGenerating}
						<span>⏳ Đang sản xuất video...</span>
					{:else}
						<span>🔄 Tạo video Remix (~35 cr)</span>
					{/if}
				</button>
			</div>
		</div>
	{/if}

	<!-- ========================================================================= -->
	<!-- Phase 3: Polish & Export (Originality Gate Guard) -->
	<!-- ========================================================================= -->
	{#if currentPhase === 3 && originalityResult}
		<div class="space-y-6">
			<!-- Canonical Originality Gate Component -->
			<RemixOriginalityGate
				result={originalityResult}
				onAdjustFidelity={handleSwitchFidelity}
				onEditScript={handleManualEdit}
			/>

			<!-- Side-by-Side Comparison Player -->
			<div class="rounded-xl border border-neutral-800 bg-neutral-900/60 p-6">
				<h3 class="text-base font-semibold mb-4 flex items-center gap-2">
					<span>📺</span> So sánh trực quan (Side-by-Side Preview)
				</h3>

				<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
					<!-- Reference Video Player -->
					<div class="rounded-lg border border-neutral-800 bg-neutral-950 p-4 text-center">
						<div class="text-xs font-semibold text-neutral-400 mb-2">Video gốc tham khảo</div>
						<div class="aspect-[9/16] w-full max-w-[240px] mx-auto rounded-lg bg-neutral-900 flex items-center justify-center border border-neutral-800">
							<span class="text-4xl text-neutral-600">▶️</span>
						</div>
						<div class="mt-2 text-xs text-neutral-500 font-mono">Reference URL: {referenceUrl}</div>
					</div>

					<!-- Remix Output Player -->
					<div class="rounded-lg border border-neutral-800 bg-neutral-950 p-4 text-center">
						<div class="text-xs font-semibold text-neutral-400 mb-2">Bản Remix tạo ra</div>
						<div class="aspect-[9/16] w-full max-w-[240px] mx-auto rounded-lg bg-neutral-900 flex items-center justify-center border border-neutral-800 relative overflow-hidden">
							{#if originalityResult.passed}
								<span class="text-4xl text-primary-400">✨</span>
							{:else}
								<div class="absolute inset-0 bg-rose-950/80 backdrop-blur-sm flex flex-col items-center justify-center p-4">
									<span class="text-3xl mb-1">⛔</span>
									<span class="text-xs font-semibold text-rose-300">Bị chặn: Trùng lặp &gt;= 30%</span>
								</div>
							{/if}
						</div>
						<div class="mt-2 text-xs text-neutral-400">
							{originalityResult.passed ? 'Sẵn sàng tải về hoặc đăng tải' : 'Yêu cầu sửa đổi trước khi xuất bản'}
						</div>
					</div>
				</div>
			</div>

			<!-- Per-Scene Regenerate Controls -->
			<div class="rounded-xl border border-neutral-800 bg-neutral-900/60 p-6 flex items-center justify-between">
				<div>
					<h4 class="text-sm font-semibold">Tái tạo phân cảnh (Per-Scene Regenerate)</h4>
					<p class="text-xs text-neutral-400 mt-0.5">Làm mới hook hoặc cảnh giải pháp nếu muốn hạ thấp hơn nữa độ tương đồng.</p>
				</div>
				<div class="flex gap-3">
					<button
						type="button"
						on:click={regenerateScene}
						disabled={isRegenerating}
						class="rounded-lg border border-neutral-700 bg-neutral-800 px-4 py-2 text-xs font-medium text-neutral-200 hover:bg-neutral-700 disabled:opacity-50 transition-colors"
					>
						{isRegenerating ? '⏳ Đang tái tạo...' : '🔄 Tái tạo Hook — 15 cr'}
					</button>
					{#if originalityResult.passed}
						<button
							type="button"
							class="rounded-lg bg-emerald-600 px-5 py-2 text-xs font-semibold text-white shadow-lg hover:bg-emerald-500 transition-colors"
						>
							🚀 Xuất video hoàn thiện
						</button>
					{/if}
				</div>
			</div>
		</div>
	{/if}
</div>
