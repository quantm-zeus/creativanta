<script lang="ts">
	import {
		calculateViralityScore,
		deriveHookStrategy,
		buildClipLineagePayload,
		CANONICAL_PATTERN_ONLY_BADGE,
		CANONICAL_AUDIO_LUFS,
		type ClipProposal,
		type ClipVariantConfig,
		type ProcessedClipOutput
	} from '$lib/production/clipfactory';

	// Workflow State: 'select' | 'analyzing' | 'review' | 'processing' | 'completed'
	let step: 'select' | 'analyzing' | 'review' | 'processing' | 'completed' = 'review';
	let userBalance = 350;

	// Source Video Options
	let sourceTitle = 'Podcast Công Nghệ & Khởi Nghiệp AI Ep.12';
	let sourceAssetId = 'asset-src-long-podcast-001';
	let sourceDurationS = 1800; // 30 mins
	let hasSpeech = true;
	let hasTrendData = false; // Default false to demonstrate Acceptance Target 2 "⚠️ Pattern-only"
	let selectedTrendTopic = 'AI Startup Workflows 2026';

	// Batch selection and variant settings
	let activeClipIndex = 0;
	let showLineageModal = false;
	let lineageModalClip: ProcessedClipOutput | null = null;
	let isAnalyzing = false;
	let notification = '';

	// Sample clips extracted by Clip Factory Engine
	let clips: ClipProposal[] = [
		{
			clipId: 'clip-p4-01',
			startS: 45.0,
			endS: 88.0,
			durationS: 43.0,
			title: 'Bí quyết tăng tốc sản phẩm AI trong 48 giờ',
			hookType: 'speech_hook',
			hookDescription: 'Speech hook: "Nếu bạn vẫn đang code AI bằng tay mà không dùng..."',
			viralityScore: calculateViralityScore(88, 92, 85, 80, 0, false),
			transcriptSnippet: 'Nếu bạn vẫn đang code AI bằng tay mà không dùng mô hình tự động hóa, bạn đang lãng phí 90% thời gian của team...',
			selected: true
		},
		{
			clipId: 'clip-p4-02',
			startS: 310.0,
			endS: 355.0,
			durationS: 45.0,
			title: 'Khoảnh khắc mở hộp & demo sản phẩm cực cuốn',
			hookType: 'visual_hook',
			hookDescription: 'Visual hook: Dynamic product zoom & beat drop transition',
			viralityScore: calculateViralityScore(82, 85, 90, 88, 0, false),
			transcriptSnippet: '',
			selected: true
		},
		{
			clipId: 'clip-p4-03',
			startS: 720.0,
			endS: 765.0,
			durationS: 45.0,
			title: '3 sai lầm chết người khi pitching quỹ đầu tư',
			hookType: 'speech_hook',
			hookDescription: 'Speech hook: "Đừng bao giờ nói câu này với nhà đầu tư mạo hiểm"',
			viralityScore: calculateViralityScore(94, 96, 91, 85, 0, false),
			transcriptSnippet: 'Đừng bao giờ nói câu này với nhà đầu tư mạo hiểm nếu bạn không muốn bị loại ngay từ vòng slide đầu tiên...',
			selected: true
		}
	];

	// Variant configs map per clip ID
	let variantConfigs: Record<string, ClipVariantConfig> = {
		'clip-p4-01': {
			clipId: 'clip-p4-01',
			targetRatios: ['9:16', '1:1'],
			subtitleFirst: true,
			ctaText: 'Follow để đón xem phần 2',
			generateHighlightReel: false,
			targetPlatforms: ['tiktok', 'reels']
		},
		'clip-p4-02': {
			clipId: 'clip-p4-02',
			targetRatios: ['9:16'],
			subtitleFirst: false,
			ctaText: 'Mua ngay link bio',
			generateHighlightReel: false,
			targetPlatforms: ['tiktok', 'shorts']
		},
		'clip-p4-03': {
			clipId: 'clip-p4-03',
			targetRatios: ['9:16', '16:9'],
			subtitleFirst: true,
			ctaText: 'Lưu lại bí kíp ngay!',
			generateHighlightReel: false,
			targetPlatforms: ['tiktok', 'reels', 'shorts']
		}
	};

	let processedOutputs: ProcessedClipOutput[] = [];

	$: selectedClips = clips.filter((c) => c.selected);
	$: totalVariantsCount = selectedClips.reduce((acc, c) => {
		const cfg = variantConfigs[c.clipId];
		const ratioCount = cfg?.targetRatios.length || 1;
		return acc + ratioCount;
	}, 0);
	$: totalCreditCost = totalVariantsCount * 5; // 5 credits per clip variant

	function toggleTrendData() {
		hasTrendData = !hasTrendData;
		clips = clips.map((clip) => {
			const relevance = hasTrendData ? 88 : 0;
			const newScore = calculateViralityScore(
				clip.viralityScore.engagementPrediction,
				clip.viralityScore.hookStrength,
				clip.viralityScore.pacingScore,
				clip.viralityScore.audioEnergy,
				relevance,
				hasTrendData
			);
			return { ...clip, viralityScore: newScore };
		});
		notification = hasTrendData
			? 'Đã liên kết dữ liệu xu hướng thực tế từ M02/M03'
			: 'Thiếu dữ liệu xu hướng: Chấm điểm chuyển sang nhãn "⚠️ Pattern-only"';
		setTimeout(() => (notification = ''), 4000);
	}

	function toggleSpeechMode() {
		hasSpeech = !hasSpeech;
		clips = clips.map((clip) => {
			const strategy = deriveHookStrategy(
				hasSpeech,
				hasSpeech ? clip.transcriptSnippet : '',
				'Visual beat & motion detection'
			);
			const newScore = calculateViralityScore(
				clip.viralityScore.engagementPrediction,
				strategy.hookStrengthScore,
				clip.viralityScore.pacingScore,
				clip.viralityScore.audioEnergy,
				clip.viralityScore.contentRelevance,
				hasTrendData
			);
			return {
				...clip,
				hookType: strategy.hookType,
				hookDescription: strategy.hookDescription,
				viralityScore: newScore
			};
		});
		notification = hasSpeech
			? 'Đã bật phân tích giọng nói (Speech Analysis Path)'
			: 'Không có giọng nói: Kích hoạt chế độ Visual Path & Beat Analysis (EC-M07-C01)';
		setTimeout(() => (notification = ''), 4000);
	}

	function handleProcessBatch() {
		if (userBalance < totalCreditCost) {
			alert('Không đủ credits để xuất hàng loạt clip!');
			return;
		}

		userBalance -= totalCreditCost;
		step = 'processing';

		// Generate mock outputs with exact source lineage
		setTimeout(() => {
			const outputs: ProcessedClipOutput[] = [];
			for (const clip of selectedClips) {
				const cfg = variantConfigs[clip.clipId] || {
					clipId: clip.clipId,
					targetRatios: ['9:16'],
					subtitleFirst: false,
					generateHighlightReel: false,
					targetPlatforms: ['tiktok']
				};

				for (const ratio of cfg.targetRatios) {
					const outputAssetId = `asset-clip-${clip.clipId}-${ratio.replace(':', 'x')}`;
					const lineagePayload = buildClipLineagePayload(
						sourceAssetId,
						clip.clipId,
						clip.startS,
						clip.endS,
						ratio,
						hasTrendData,
						cfg.ctaText
					);

					outputs.push({
						outputAssetId,
						clipId: clip.clipId,
						ratio,
						title: `${clip.title} [${ratio}]`,
						durationS: clip.durationS,
						videoUrl: `https://cdn.creativanta.test/clips/${outputAssetId}.mp4`,
						lineageJson: JSON.stringify(lineagePayload, null, 2),
						isHighlightReel: false,
						ctaApplied: !!cfg.ctaText,
						audioLufs: CANONICAL_AUDIO_LUFS
					});
				}
			}
			processedOutputs = outputs;
			step = 'completed';
		}, 1000);
	}

	function inspectLineage(output: ProcessedClipOutput) {
		lineageModalClip = output;
		showLineageModal = true;
	}
</script>

<svelte:head>
	<title>Clip Factory (1→N Mode 2) — Creativanta</title>
</svelte:head>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-6">
	<!-- Shell Header with mandatory h1 -->
	<div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-gray-800 pb-5">
		<div>
			<div class="flex items-center gap-3 mb-1">
				<a href="/studio" class="text-xs font-semibold px-2.5 py-1 rounded bg-gray-800 hover:bg-gray-700 text-gray-300 transition-colors">
					← Studio
				</a>
				<span class="text-2xl">✂️</span>
				<h1 class="text-xl font-bold text-white tracking-tight">
					Clip Factory (1→N)
				</h1>
				<span class="text-xs px-2 py-0.5 rounded-full bg-purple-950 text-purple-300 border border-purple-800 font-mono">
					W023 · Mode 2 (M07)
				</span>
			</div>
			<p class="text-xs text-gray-400">
				Phân tích video dài thành các clip ngắn viral đa tỷ lệ, chấm điểm virality 5 chiều và bọc CTA.
			</p>
		</div>

		<div class="flex items-center gap-4">
			{#if notification}
				<div class="text-xs px-3 py-1.5 rounded-lg bg-indigo-950 text-indigo-300 border border-indigo-800 flex items-center gap-1.5 animate-pulse">
					<span>ℹ️</span>
					<span>{notification}</span>
				</div>
			{/if}
			<div class="bg-gray-900 border border-gray-800 rounded-lg px-3 py-1.5 text-right">
				<div class="text-[10px] text-gray-400">Số dư khả dụng</div>
				<div class="text-sm font-bold font-mono text-emerald-400">🪙 {userBalance} credits</div>
			</div>
		</div>
	</div>

	<!-- Source Video Metadata & Simulation Controls Bar -->
	<div class="bg-gray-900/80 border border-gray-800 rounded-xl p-4 flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
		<div class="space-y-1">
			<div class="text-xs text-gray-400">Video nguồn đang xử lý:</div>
			<div class="text-sm font-semibold text-white flex items-center gap-2">
				<span>📹</span>
				<span>{sourceTitle}</span>
				<span class="font-mono text-xs text-gray-500">({sourceAssetId}) · 30:00</span>
			</div>
		</div>

		<!-- Acceptance Target Controls -->
		<div class="flex flex-wrap items-center gap-3">
			<button
				type="button"
				class="text-xs px-3 py-1.5 rounded-lg border transition-colors flex items-center gap-2 {hasSpeech ? 'bg-blue-950 text-blue-300 border-blue-800' : 'bg-amber-950 text-amber-300 border-amber-800'}"
				on:click={toggleSpeechMode}
			>
				<span>{hasSpeech ? '🎙️ Có giọng nói (Speech)' : '🎵 Không có giọng nói (Visual Path)'}</span>
			</button>

			<button
				type="button"
				class="text-xs px-3 py-1.5 rounded-lg border transition-colors flex items-center gap-2 {hasTrendData ? 'bg-emerald-950 text-emerald-300 border-emerald-800' : 'bg-orange-950 text-orange-300 border-orange-800'}"
				on:click={toggleTrendData}
			>
				<span>{hasTrendData ? '📈 Dữ liệu Trend: Đã liên kết' : '⚠️ Trend Data: Thiếu (Pattern-only)'}</span>
			</button>
		</div>
	</div>

	<!-- Review Board: Clip Proposals -->
	{#if step === 'review' || step === 'select'}
		<div class="space-y-4">
			<div class="flex items-center justify-between">
				<div class="flex items-center gap-2">
					<h2 class="text-base font-semibold text-white">Danh sách clip đề xuất ({clips.length})</h2>
					<span class="text-xs text-gray-400">Được sắp xếp theo tiềm năng lan truyền (Virality Score)</span>
				</div>
				<div class="text-xs text-gray-400">
					Đã chọn: <span class="text-white font-bold">{selectedClips.length}</span> clip ·
					<span class="text-purple-400 font-bold">{totalVariantsCount}</span> biến thể
				</div>
			</div>

			<div class="grid grid-cols-1 md:grid-cols-3 gap-4">
				{#each clips as clip, idx}
					<div class="bg-gray-900 border rounded-xl p-4 flex flex-col justify-between space-y-3 {clip.selected ? 'border-purple-600/80 shadow-lg shadow-purple-950/20' : 'border-gray-800 opacity-70'}">
						<!-- Card Header -->
						<div class="space-y-2">
							<div class="flex items-center justify-between">
								<span class="font-mono text-xs px-2 py-0.5 rounded bg-gray-800 text-gray-300">
									⏱️ {Math.floor(clip.startS / 60)}:{(clip.startS % 60).toString().padStart(2, '0')} - {Math.floor(clip.endS / 60)}:{(clip.endS % 60).toString().padStart(2, '0')} ({clip.durationS}s)
								</span>
								<input
									type="checkbox"
									bind:checked={clip.selected}
									class="rounded bg-gray-800 border-gray-700 text-purple-600 focus:ring-purple-500 h-4 w-4"
								/>
							</div>

							<h3 class="text-sm font-semibold text-white line-clamp-2">{clip.title}</h3>

							<!-- Hook Type Badge (Acceptance Target 1) -->
							<div class="flex items-center gap-1.5">
								{#if clip.hookType === 'visual_hook'}
									<span class="text-[11px] px-2 py-0.5 rounded bg-amber-950 text-amber-300 border border-amber-800 flex items-center gap-1">
										<span>👁️ Visual Hook</span>
									</span>
								{:else}
									<span class="text-[11px] px-2 py-0.5 rounded bg-blue-950 text-blue-300 border border-blue-800 flex items-center gap-1">
										<span>🗣️ Speech Hook</span>
									</span>
								{/if}
								<span class="text-[10px] text-gray-400 truncate">{clip.hookDescription}</span>
							</div>

							<!-- Virality Score & Badge (Acceptance Target 2) -->
							<div class="bg-gray-950 border border-gray-800/80 rounded-lg p-2.5 space-y-1.5">
								<div class="flex items-center justify-between">
									<div class="flex items-center gap-1.5">
										<span class="text-xs font-bold text-emerald-400 font-mono">
											{clip.viralityScore.compositeScore}/100
										</span>
										<span class="text-[10px] text-gray-400">Virality</span>
									</div>
									<!-- Mandatory Target 2 Label -->
									<span class="text-[10px] px-2 py-0.5 rounded font-semibold {clip.viralityScore.hasTrendData ? 'bg-emerald-950 text-emerald-300 border border-emerald-800' : 'bg-orange-950 text-orange-300 border border-orange-800'}">
										{clip.viralityScore.scoreBadge}
									</span>
								</div>

								<!-- 5-Dimension Bars -->
								<div class="grid grid-cols-5 gap-1 pt-1 text-[9px] text-gray-400 text-center font-mono">
									<div>
										<div class="h-1 bg-gray-800 rounded overflow-hidden mb-1">
											<div class="h-full bg-blue-500" style="width: {clip.viralityScore.engagementPrediction}%"></div>
										</div>
										<span>Eng</span>
									</div>
									<div>
										<div class="h-1 bg-gray-800 rounded overflow-hidden mb-1">
											<div class="h-full bg-purple-500" style="width: {clip.viralityScore.hookStrength}%"></div>
										</div>
										<span>Hook</span>
									</div>
									<div>
										<div class="h-1 bg-gray-800 rounded overflow-hidden mb-1">
											<div class="h-full bg-cyan-500" style="width: {clip.viralityScore.pacingScore}%"></div>
										</div>
										<span>Pace</span>
									</div>
									<div>
										<div class="h-1 bg-gray-800 rounded overflow-hidden mb-1">
											<div class="h-full bg-amber-500" style="width: {clip.viralityScore.audioEnergy}%"></div>
										</div>
										<span>Audio</span>
									</div>
									<div>
										<div class="h-1 bg-gray-800 rounded overflow-hidden mb-1">
											<div class="h-full bg-emerald-500" style="width: {clip.viralityScore.contentRelevance}%"></div>
										</div>
										<span>Trend</span>
									</div>
								</div>
							</div>

							<!-- Transcript / Scene Note -->
							{#if clip.transcriptSnippet}
								<p class="text-xs text-gray-400 line-clamp-2 italic">
									"{clip.transcriptSnippet}"
								</p>
							{/if}
						</div>

						<!-- Variant Configuration for this Clip -->
						{#if variantConfigs[clip.clipId]}
							<div class="border-t border-gray-800 pt-2 space-y-2 text-xs">
								<div class="flex items-center justify-between text-gray-400">
									<span>Tỷ lệ khung hình:</span>
									<div class="flex items-center gap-2">
										{#each ['9:16', '16:9', '1:1'] as ratio}
											<label class="flex items-center gap-1 cursor-pointer">
												<input
													type="checkbox"
													value={ratio}
													checked={variantConfigs[clip.clipId].targetRatios.includes(ratio)}
													on:change={(e) => {
														const cfg = variantConfigs[clip.clipId];
														if (e.currentTarget.checked) {
															cfg.targetRatios = [...cfg.targetRatios, ratio];
														} else {
															cfg.targetRatios = cfg.targetRatios.filter((r) => r !== ratio);
														}
														variantConfigs = { ...variantConfigs };
													}}
													class="rounded bg-gray-800 border-gray-700 text-purple-600 focus:ring-purple-500 h-3.5 w-3.5"
												/>
												<span class="text-[11px] font-mono">{ratio}</span>
											</label>
										{/each}
									</div>
								</div>

								<div class="flex items-center gap-2">
									<span class="text-gray-400 shrink-0">CTA:</span>
									<input
										type="text"
										bind:value={variantConfigs[clip.clipId].ctaText}
										placeholder="Nhập CTA cuối clip..."
										class="w-full bg-gray-950 border border-gray-800 rounded px-2 py-1 text-xs text-white placeholder-gray-600 focus:border-purple-600 focus:outline-none"
									/>
								</div>
							</div>
						{/if}
					</div>
				{/each}
			</div>

			<!-- Batch Processing Action Bar -->
			<div class="bg-gray-900 border border-gray-800 rounded-xl p-4 flex flex-col sm:flex-row items-center justify-between gap-4 sticky bottom-4 shadow-xl">
				<div class="flex items-center gap-3">
					<span class="text-xl">⚡</span>
					<div>
						<div class="text-xs text-gray-400">Tổng chi phí xuất batch:</div>
						<div class="text-sm font-semibold text-white">
							<span class="text-purple-400">{selectedClips.length}</span> clip ·
							<span class="text-purple-400">{totalVariantsCount}</span> biến thể =
							<span class="text-emerald-400 font-mono">🪙 {totalCreditCost} credits</span>
						</div>
					</div>
				</div>

				<button
					type="button"
					on:click={handleProcessBatch}
					disabled={selectedClips.length === 0}
					class="w-full sm:w-auto px-6 py-2.5 rounded-lg bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-purple-500 hover:to-indigo-500 text-white font-semibold text-sm transition-all shadow-lg disabled:opacity-50 disabled:cursor-not-allowed"
				>
					Xử lý & Xuất {totalVariantsCount} clip biến thể →
				</button>
			</div>
		</div>
	{/if}

	<!-- Processing Step -->
	{#if step === 'processing'}
		<div class="bg-gray-900 border border-gray-800 rounded-xl p-12 text-center space-y-4">
			<div class="inline-block animate-spin text-4xl">⏳</div>
			<h2 class="text-lg font-bold text-white">Đang kết xuất {totalVariantsCount} biến thể clip...</h2>
			<p class="text-xs text-gray-400 max-w-md mx-auto">
				Đang cắt ghép theo timecodes chính xác, chuẩn hóa âm lượng -14.0 LUFS và ghi nhận nguồn gốc source lineage.
			</p>
		</div>
	{/if}

	<!-- Completed Step & Lineage Inspection (Acceptance Target 3) -->
	{#if step === 'completed'}
		<div class="space-y-4">
			<div class="flex items-center justify-between">
				<div>
					<h2 class="text-base font-semibold text-white flex items-center gap-2">
						<span>🎉</span>
						<span>Đã xuất thành công {processedOutputs.length} clip biến thể!</span>
					</h2>
					<p class="text-xs text-gray-400">
						Tất cả clip con đều mang đầy đủ thuộc tính source lineage (ParentAssetID == {sourceAssetId}) và đạt chuẩn -14.0 LUFS.
					</p>
				</div>
				<button
					type="button"
					on:click={() => (step = 'review')}
					class="text-xs px-3 py-1.5 rounded-lg bg-gray-800 hover:bg-gray-700 text-gray-300"
				>
					← Quay lại review board
				</button>
			</div>

			<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
				{#each processedOutputs as out}
					<div class="bg-gray-900 border border-gray-800 rounded-xl p-4 space-y-3">
						<div class="flex items-center justify-between">
							<span class="text-xs font-mono px-2 py-0.5 rounded bg-purple-950 text-purple-300 border border-purple-800">
								{out.ratio}
							</span>
							<span class="text-[11px] text-emerald-400 font-mono">
								🔊 {out.audioLufs} LUFS
							</span>
						</div>

						<h3 class="text-sm font-semibold text-white line-clamp-1">{out.title}</h3>

						<div class="bg-black/50 rounded-lg p-2 font-mono text-[11px] text-gray-400 truncate">
							Asset ID: <span class="text-gray-200">{out.outputAssetId}</span>
						</div>

						<div class="flex items-center justify-between pt-2 border-t border-gray-800">
							<span class="text-[11px] text-gray-400">Lineage: Derivative Clip</span>
							<button
								type="button"
								on:click={() => inspectLineage(out)}
								class="text-xs px-2.5 py-1 rounded bg-gray-800 hover:bg-gray-700 text-purple-300 transition-colors"
							>
								🔍 Xem Source Lineage JSON
							</button>
						</div>
					</div>
				{/each}
			</div>
		</div>
	{/if}

	<!-- Source Lineage Modal (Acceptance Target 3) -->
	{#if showLineageModal && lineageModalClip}
		<div class="fixed inset-0 z-50 flex items-center justify-center bg-black/80 backdrop-blur-sm p-4">
			<div class="bg-gray-900 border border-gray-800 rounded-2xl max-w-2xl w-full p-6 space-y-4 shadow-2xl">
				<div class="flex items-center justify-between border-b border-gray-800 pb-3">
					<div class="flex items-center gap-2">
						<span class="text-xl">🧬</span>
						<h3 class="text-base font-bold text-white">Source Lineage Record (AC-5 / AT-3)</h3>
					</div>
					<button
						type="button"
						on:click={() => (showLineageModal = false)}
						class="text-gray-400 hover:text-white text-lg"
					>
						✕
					</button>
				</div>

				<div class="space-y-2 text-xs text-gray-300">
					<p>
						Minh chứng liên kết phả hệ: Clip con này được dẫn xuất từ video dài gốc
						<span class="font-mono text-purple-300">{sourceAssetId}</span>, duy trì đầy đủ
						timecodes, chuẩn chuẩn hóa âm lượng (-14.0 LUFS) và cấu hình biến thể.
					</p>

					<div class="bg-black rounded-xl p-4 font-mono text-xs text-emerald-400 overflow-x-auto max-h-80 border border-gray-800">
						<pre>{lineageModalClip.lineageJson}</pre>
					</div>
				</div>

				<div class="flex justify-end pt-2">
					<button
						type="button"
						on:click={() => (showLineageModal = false)}
						class="px-4 py-2 rounded-lg bg-gray-800 hover:bg-gray-700 text-white text-xs font-semibold"
					>
						Đóng
					</button>
				</div>
			</div>
		</div>
	{/if}
</div>
