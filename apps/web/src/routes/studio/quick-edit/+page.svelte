<script lang="ts">
	import { onMount } from 'svelte';
	import {
		analyzeTranscriptClient,
		buildCutIntervals,
		calculateQuickEditCredits,
		computeRetainedTimeline,
		repairWordTranscript,
		SAMPLE_SMART_HOOKS,
		type QuickEditAddons,
		type TranscriptWord,
		type TranscriptAnalysis
	} from '$lib/production/quickedit';

	// State steps: 'upload' | 'analyzing' | 'editing' | 'submitted'
	let step: 'upload' | 'analyzing' | 'editing' | 'submitted' = 'upload';
	let analyzeProgress = 0;
	let analyzeStage = '';

	// Video and Transcript state
	let fileName = 'coffee_routine_raw.mp4';
	let durationSec = 145; // 2:25 video
	let currentTimeSec = 0;
	let isPlaying = false;
	let showBeforePreview = false;

	// User credit balance
	let userBalance = 320;

	// Add-on configuration
	let addons: QuickEditAddons = {
		autoCaptions: true,
		captionStyle: 'bounce',
		addHook: false,
		hookType: 'question',
		hookId: 'hook_q_01',
		beatSync: false,
		soundGenre: 'chill',
		bRoll: false,
		platformPreset: 'tiktok',
		audioEnhancement: false,
		targetLufs: -14.0,
		reframeRatio: '9:16'
	};

	// Sample initial transcript words
	let words: TranscriptWord[] = [
		{ wordId: 'w1', text: 'Xin chào các bạn,', startMs: 0, endMs: 1400, confidence: 0.99, isFiller: false, isDeleted: false },
		{ wordId: 'w2', text: 'ừm', startMs: 1500, endMs: 1950, confidence: 0.95, isFiller: true, isDeleted: false },
		{ wordId: 'w3', text: 'hôm nay mình sẽ chia sẻ', startMs: 2000, endMs: 3800, confidence: 0.98, isFiller: false, isDeleted: false },
		{ wordId: 'w4', text: 'kiểu', startMs: 3900, endMs: 4300, confidence: 0.91, isFiller: true, isDeleted: false },
		{ wordId: 'w5', text: '5 bí quyết', startMs: 4400, endMs: 5300, confidence: 0.97, isFiller: false, isDeleted: false },
		{ wordId: 'w6', text: 'chăm sóc da buổi sáng', startMs: 5350, endMs: 7200, confidence: 0.98, isFiller: false, isDeleted: false },
		{ wordId: 'w7', text: 'đoạn này mình nói vấp', startMs: 7500, endMs: 9200, confidence: 0.96, isFiller: false, isDeleted: false },
		{ wordId: 'w8', text: 'rất đơn giản và hiệu quả', startMs: 9400, endMs: 11500, confidence: 0.99, isFiller: false, isDeleted: false },
		{ wordId: 'w9', text: 'à', startMs: 11600, endMs: 12000, confidence: 0.92, isFiller: true, isDeleted: false },
		{ wordId: 'w10', text: 'hãy cùng theo dõi nhé!', startMs: 12100, endMs: 14000, confidence: 0.99, isFiller: false, isDeleted: false }
	];

	let analysis: TranscriptAnalysis = {
		fillerCount: 0,
		pauseCount: 0,
		hookQualityScore: 7.0,
		estimatedTimeSavedMs: 0,
		finalDurationMs: 14000,
		detectedFillers: [],
		deadPauses: [],
		hookFeedback: ''
	};

	// Modal state for ASR repair (EC-M07-Q01)
	let showRepairModal = false;
	let repairWord: TranscriptWord | null = null;
	let repairInputText = '';
	let repairStartMs = 0;
	let repairEndMs = 0;
	let repairErrorMessage = '';

	// Confirmation modal state (Acceptance Criterion 1)
	let showConfirmModal = false;
	let submittedJobId = '';
	let draftSavedNotification = '';

	// Reactive credit calculation
	$: creditCost = calculateQuickEditCredits(addons);
	$: balanceAfter = userBalance - creditCost.totalCredits;

	// Reactive cuts & timeline calculation
	$: activeCuts = buildCutIntervals(words, analysis.deadPauses, true, true);
	$: timeline = computeRetainedTimeline(durationSec * 1000, activeCuts);

	function runAnalysis(sample = true) {
		step = 'analyzing';
		analyzeProgress = 10;
		analyzeStage = 'Đang tải lên và trích xuất audio...';

		const timer = setInterval(() => {
			analyzeProgress += 25;
			if (analyzeProgress === 35) {
				analyzeStage = 'Chuyển đổi giọng nói thành văn bản (Whisper ASR)...';
			} else if (analyzeProgress === 60) {
				analyzeStage = 'Phát hiện filler words ("ừm", "à", "kiểu") & khoảng lặng...';
			} else if (analyzeProgress === 85) {
				analyzeStage = 'Đánh giá chất lượng hook 3 giây đầu & phân đoạn...';
			} else if (analyzeProgress >= 100) {
				clearInterval(timer);
				const res = analyzeTranscriptClient(words, 1500);
				words = res.taggedWords;
				analysis = res.analysis;
				step = 'editing';
			}
		}, 300);
	}

	function toggleWordDeleted(wordId: string) {
		words = words.map((w) => {
			if (w.wordId === wordId) {
				return { ...w, isDeleted: !w.isDeleted };
			}
			return w;
		});
	}

	function autoCutAllFillers() {
		words = words.map((w) => {
			if (w.isFiller) {
				return { ...w, isDeleted: true };
			}
			return w;
		});
	}

	function restoreAllCuts() {
		words = words.map((w) => ({ ...w, isDeleted: false }));
	}

	function openRepairModal(w: TranscriptWord) {
		repairWord = w;
		repairInputText = w.text;
		repairStartMs = w.startMs;
		repairEndMs = w.endMs;
		repairErrorMessage = '';
		showRepairModal = true;
	}

	function submitRepair() {
		if (!repairWord) return;
		const res = repairWordTranscript(words, repairWord.wordId, repairInputText, repairStartMs, repairEndMs);
		if (res.fallbackMode && res.error) {
			repairErrorMessage = res.error;
			return;
		}
		words = res.words;
		const analyzed = analyzeTranscriptClient(words, 1500);
		words = analyzed.taggedWords;
		analysis = analyzed.analysis;
		showRepairModal = false;
	}

	function saveDraft() {
		draftSavedNotification = 'Đã lưu bản nháp chỉnh sửa thành công (Draft saved)';
		setTimeout(() => {
			draftSavedNotification = '';
		}, 3500);
	}

	function triggerApplyEdits() {
		showConfirmModal = true;
	}

	function confirmApply() {
		if (balanceAfter < 0) {
			return; // Insufficient credits
		}
		userBalance -= creditCost.totalCredits;
		submittedJobId = `job-quickedit-${Date.now()}`;
		showConfirmModal = false;
		step = 'submitted';
	}
</script>

<svelte:head>
	<title>Quick Edit Mode (W022) — Creativanta</title>
</svelte:head>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-6">
	<!-- App Shell Header -->
	<div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-gray-800 pb-5">
		<div>
			<div class="flex items-center gap-3 mb-1">
				<a href="/studio" class="text-xs font-semibold px-2.5 py-1 rounded bg-gray-800 hover:bg-gray-700 text-gray-300 transition-colors">
					← Studio
				</a>
				<span class="text-xl">✂️</span>
				<h1 class="text-xl font-bold text-white tracking-tight">
					Quick Edit Mode {#if step === 'editing'}· <span class="font-mono text-sm text-gray-300">{fileName}</span>{/if}
				</h1>
				<span class="text-xs px-2 py-0.5 rounded-full bg-blue-950 text-blue-300 border border-blue-800 font-mono">
					W022 · M07
				</span>
			</div>
			<p class="text-xs text-gray-400">
				Biên tập video bằng cách gạch chữ — Xóa text là xóa hình, không cần timeline chuyên nghiệp.
			</p>
		</div>

		<div class="flex items-center gap-4">
			{#if draftSavedNotification}
				<div class="text-xs px-3 py-1.5 rounded-lg bg-emerald-950 text-emerald-300 border border-emerald-800 flex items-center gap-1.5 animate-fade-in">
					<span>💾</span>
					<span>{draftSavedNotification}</span>
				</div>
			{/if}
			<div class="bg-gray-900 border border-gray-800 rounded-lg px-3 py-1.5 text-right">
				<div class="text-[10px] text-gray-400">Số dư khả dụng</div>
				<div class="text-sm font-bold font-mono text-emerald-400">🪙 {userBalance} credits</div>
			</div>
		</div>
	</div>

	<!-- STEP 1: UPLOAD SCREEN -->
	{#if step === 'upload'}
		<div class="max-w-2xl mx-auto py-12">
			<div class="border-2 border-dashed border-gray-700 hover:border-blue-500 rounded-2xl p-10 text-center transition-all bg-gray-900/40">
				<span class="text-5xl block mb-4">📎</span>
				<h2 class="text-lg font-bold text-white mb-2">Tải video lên để chỉnh sửa nhanh</h2>
				<p class="text-xs text-gray-400 mb-6">
					Kéo thả file vào đây hoặc nhấp chọn file từ thiết bị (MP4, MOV, WebM · Tối đa 30 phút)
				</p>
				<div class="flex flex-col sm:flex-row items-center justify-center gap-3">
					<button
						type="button"
						on:click={() => runAnalysis(true)}
						class="px-5 py-2.5 text-xs font-semibold rounded-xl bg-blue-600 hover:bg-blue-500 text-white shadow-lg shadow-blue-600/20 transition-all flex items-center gap-2">
						<span>📂</span>
						<span>Chọn video từ máy</span>
					</button>
					<button
						type="button"
						on:click={() => runAnalysis(true)}
						class="px-4 py-2.5 text-xs font-semibold rounded-xl bg-gray-800 hover:bg-gray-700 text-gray-200 border border-gray-700 transition-all">
						<span>⚡</span>
						<span>Tải video mẫu kiểm thử (coffee_routine.mp4)</span>
					</button>
				</div>
			</div>
		</div>

	<!-- STEP 2: ANALYZING PROGRESS -->
	{:else if step === 'analyzing'}
		<div class="max-w-xl mx-auto py-16">
			<div class="bg-gray-900 border border-gray-800 rounded-2xl p-8 space-y-6">
				<div class="flex items-center justify-between">
					<div class="flex items-center gap-3">
						<span class="text-2xl animate-spin">🔄</span>
						<h2 class="text-base font-bold text-white">Đang phân tích video bằng AI...</h2>
					</div>
					<span class="text-sm font-mono text-blue-400 font-bold">{analyzeProgress}%</span>
				</div>

				<div class="w-full bg-gray-800 rounded-full h-2.5 overflow-hidden">
					<div class="bg-blue-600 h-2.5 rounded-full transition-all duration-300" style="width: {analyzeProgress}%"></div>
				</div>

				<div class="space-y-2 text-xs text-gray-300 pt-2">
					<div class="flex items-center gap-2">
						<span class="text-emerald-400">✅</span>
						<span>Tải tệp & trích xuất track âm thanh</span>
					</div>
					<div class="flex items-center gap-2">
						<span class={analyzeProgress >= 35 ? 'text-emerald-400' : 'text-gray-500'}>
							{analyzeProgress >= 35 ? '✅' : '🔄'}
						</span>
						<span>Chuyển đổi thành transcript có timestamp (Whisper ASR)</span>
					</div>
					<div class="flex items-center gap-2">
						<span class={analyzeProgress >= 60 ? 'text-emerald-400' : 'text-gray-500'}>
							{analyzeProgress >= 60 ? '✅' : '⬜'}
						</span>
						<span>Phát hiện từ đệm ("ừm", "à", "kiểu") & dead pauses</span>
					</div>
					<div class="flex items-center gap-2">
						<span class={analyzeProgress >= 85 ? 'text-emerald-400' : 'text-gray-500'}>
							{analyzeProgress >= 85 ? '✅' : '⬜'}
						</span>
						<span>Phân tích chất lượng hook 3s đầu & cấu trúc kịch bản</span>
					</div>
				</div>

				<p class="text-[11px] text-gray-500 italic text-center">
					{analyzeStage}
				</p>
			</div>
		</div>

	<!-- STEP 3: MAIN EDITING CANVAS -->
	{:else if step === 'editing'}
		<!-- Analysis Banner & Quick Controls -->
		<div class="bg-gray-900/80 border border-gray-800 rounded-xl p-4 flex flex-col md:flex-row md:items-center justify-between gap-4">
			<div class="flex flex-wrap items-center gap-4 text-xs">
				<div class="flex items-center gap-1.5 text-amber-400">
					<span>🗑</span>
					<span><strong>{analysis.fillerCount}</strong> filler words</span>
				</div>
				<div class="flex items-center gap-1.5 text-purple-400">
					<span>⏸</span>
					<span><strong>{analysis.pauseCount}</strong> dead pauses</span>
				</div>
				<div class="flex items-center gap-1.5 text-emerald-400">
					<span>⏱</span>
					<span>Thời lượng: <strong>{Math.round(timeline.finalDurationMs / 1000)}s</strong> (tiết kiệm {Math.round(timeline.timeSavedMs / 1000)}s)</span>
				</div>
				<div class="flex items-center gap-1.5 px-2 py-0.5 rounded bg-gray-800 text-blue-300 font-mono">
					<span>🎯 Hook: {analysis.hookQualityScore}/10</span>
				</div>
			</div>

			<div class="flex items-center gap-2">
				<button
					type="button"
					on:click={autoCutAllFillers}
					class="px-3 py-1.5 text-xs font-semibold rounded-lg bg-amber-500/20 text-amber-300 border border-amber-500/40 hover:bg-amber-500/30 transition-all flex items-center gap-1.5">
					<span>🪄</span>
					<span>Tự động cắt toàn bộ từ đệm</span>
				</button>
				<button
					type="button"
					on:click={restoreAllCuts}
					class="px-3 py-1.5 text-xs font-semibold rounded-lg bg-gray-800 text-gray-300 hover:bg-gray-700 transition-all">
					⟲ Khôi phục
				</button>
			</div>
		</div>

		<!-- Split View: Transcript (40%) and Video Preview (60%) -->
		<div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
			<!-- LEFT: Transcript Editor -->
			<div class="lg:col-span-5 bg-gray-900 border border-gray-800 rounded-xl p-5 flex flex-col h-[520px]">
				<div class="flex items-center justify-between pb-3 border-b border-gray-800 mb-3">
					<h3 class="text-xs font-bold text-gray-300 uppercase tracking-wider flex items-center gap-2">
						<span>📝</span>
						<span>Transcript (Bấm vào từ để cắt/giữ)</span>
					</h3>
					<span class="text-[11px] text-gray-500">Gạch ngang = đã cắt</span>
				</div>

				<div class="flex-1 overflow-y-auto space-y-3 pr-2 leading-relaxed">
					{#each words as w (w.wordId)}
						<div class="inline-block m-1">
							<span
								role="button"
								tabindex="0"
								on:click={() => toggleWordDeleted(w.wordId)}
								on:keydown={(e) => e.key === 'Enter' && toggleWordDeleted(w.wordId)}
								class="inline-flex items-center gap-1 px-2 py-1 rounded-md text-xs cursor-pointer select-none transition-all
									{w.isDeleted
										? 'line-through bg-red-950/60 text-red-400 border border-red-900/60 opacity-60'
										: w.isFiller
											? 'bg-amber-950/60 text-amber-200 border border-amber-800/80 hover:bg-amber-900/80'
											: 'bg-gray-800 text-gray-100 hover:bg-gray-700 border border-gray-700'}">
								<span>{w.text}</span>
								{#if w.isFiller}
									<span class="text-[9px] px-1 py-0.2 rounded bg-amber-900 text-amber-300 font-mono">filler</span>
								{/if}
							</span>

							<!-- Repair action icon -->
							<button
								type="button"
								title="Sửa từ / thời gian (ASR repair)"
								on:click|stopPropagation={() => openRepairModal(w)}
								class="text-[10px] text-gray-500 hover:text-blue-400 ml-0.5 p-0.5">
								✏️
							</button>
						</div>
					{/each}
				</div>

				<div class="pt-3 border-t border-gray-800 text-[11px] text-gray-400 flex items-center justify-between">
					<span>💡 Bấm ✏️ để sửa từ phát âm sai hoặc chỉnh mốc thời gian</span>
					<span class="text-emerald-400">Zero drift verified ✅</span>
				</div>
			</div>

			<!-- RIGHT: Video Player & Enhancement Preview -->
			<div class="lg:col-span-7 bg-gray-900 border border-gray-800 rounded-xl p-5 flex flex-col justify-between h-[520px]">
				<!-- Video Display Box -->
				<div class="relative bg-black rounded-lg overflow-hidden flex-1 flex items-center justify-center border border-gray-800">
					<!-- Simulated Player Canvas -->
					<div class="text-center space-y-2 p-6">
						<span class="text-4xl block">🎬</span>
						<div class="text-sm font-semibold text-white">Video Preview · {addons.reframeRatio}</div>
						<p class="text-xs text-gray-400 max-w-sm">
							{#if showBeforePreview}
								<span class="text-amber-400 font-mono">[Bản gốc chưa cắt]</span> 00:03 / 02:25
							{:else}
								<span class="text-emerald-400 font-mono">[Bản sau khi cắt & tối ưu]</span> 00:03 / {Math.round(timeline.finalDurationMs / 1000)}s
							{/if}
						</p>

						<!-- Simulated Subtitle Overlay -->
						{#if addons.autoCaptions}
							<div class="mt-4 inline-block px-4 py-1.5 rounded-lg bg-black/80 border border-yellow-400/60 text-yellow-300 font-bold text-sm tracking-wide shadow-lg">
								{#if addons.captionStyle === 'bounce'}
									💥 5 BÍ QUYẾT CHĂM SÓC DA
								{:else if addons.captionStyle === 'karaoke'}
									🎤 5 bí quyết chăm sóc da
								{:else if addons.captionStyle === 'highlight'}
									🌟 5 BÍ QUYẾT [CHĂM SÓC DA]
								{:else}
									⌨️ 5 bí quyết chăm sóc da...
								{/if}
							</div>
						{/if}
					</div>

					<!-- Before / After Toggle Button Overlay -->
					<div class="absolute top-3 right-3 flex items-center bg-gray-900/90 border border-gray-700 rounded-lg p-1 text-[11px]">
						<button
							type="button"
							on:click={() => (showBeforePreview = false)}
							class="px-2.5 py-1 rounded font-semibold transition-all {!showBeforePreview ? 'bg-blue-600 text-white' : 'text-gray-400'}">
							Sau chỉnh sửa
						</button>
						<button
							type="button"
							on:click={() => (showBeforePreview = true)}
							class="px-2.5 py-1 rounded font-semibold transition-all {showBeforePreview ? 'bg-amber-600 text-white' : 'text-gray-400'}">
							Gốc (Trước)
						</button>
					</div>
				</div>

				<!-- AI Analysis / Quality Snapshot -->
				<div class="mt-4 pt-3 border-t border-gray-800 grid grid-cols-3 gap-3 text-center text-xs">
					<div class="bg-gray-800/40 rounded-lg p-2">
						<span class="text-gray-400 block text-[10px]">Tỉ lệ khung hình</span>
						<span class="text-white font-mono font-semibold">{addons.reframeRatio} (Auto-crop)</span>
					</div>
					<div class="bg-gray-800/40 rounded-lg p-2">
						<span class="text-gray-400 block text-[10px]">Chuẩn âm lượng</span>
						<span class="text-emerald-400 font-mono font-semibold">-14.0 LUFS ✅</span>
					</div>
					<div class="bg-gray-800/40 rounded-lg p-2">
						<span class="text-gray-400 block text-[10px]">Nhạc bản quyền</span>
						<span class="text-blue-400 font-mono font-semibold">ACRCloud Cleared ✅</span>
					</div>
				</div>
			</div>
		</div>

		<!-- BOTTOM: EDIT PLAN & ADDONS CONFIGURATOR -->
		<div class="bg-gray-900 border border-gray-800 rounded-xl p-5 space-y-5">
			<div class="flex items-center justify-between pb-3 border-b border-gray-800">
				<h2 class="text-sm font-bold text-white flex items-center gap-2">
					<span>⚙️</span>
					<span>Kế hoạch chỉnh sửa & Tính năng bổ trợ (Edit Plan & Add-ons)</span>
				</h2>
				<span class="text-xs text-gray-400 font-mono">15 credits cơ bản + Tùy chọn nâng cao</span>
			</div>

			<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 text-xs">
				<!-- 1. Auto Captions -->
				<div class="bg-gray-800/40 border border-gray-700/60 rounded-lg p-3 space-y-2">
					<label class="flex items-center justify-between font-semibold text-gray-200 cursor-pointer">
						<span class="flex items-center gap-2">
							<input type="checkbox" bind:checked={addons.autoCaptions} class="rounded text-blue-600" />
							<span>💬 Phụ đề hoạt họa</span>
						</span>
						<span class="text-emerald-400 font-mono text-[11px]">Đã gồm</span>
					</label>
					{#if addons.autoCaptions}
						<select bind:value={addons.captionStyle} class="w-full bg-gray-900 border border-gray-700 rounded p-1.5 text-gray-200">
							<option value="bounce">Kiểu Bounce (TikTok trending)</option>
							<option value="karaoke">Kiểu Karaoke (Highlight từng từ)</option>
							<option value="highlight">Kiểu Highlight (Pill nổi bật)</option>
							<option value="typewriter">Kiểu Typewriter (Đánh máy)</option>
						</select>
					{/if}
				</div>

				<!-- 2. Smart Hook -->
				<div class="bg-gray-800/40 border border-gray-700/60 rounded-lg p-3 space-y-2">
					<label class="flex items-center justify-between font-semibold text-gray-200 cursor-pointer">
						<span class="flex items-center gap-2">
							<input type="checkbox" bind:checked={addons.addHook} class="rounded text-blue-600" />
							<span>🎯 Thêm Hook mở đầu</span>
						</span>
						<span class="text-amber-400 font-mono text-[11px]">+3 credits</span>
					</label>
					{#if addons.addHook}
						<select bind:value={addons.hookType} class="w-full bg-gray-900 border border-gray-700 rounded p-1.5 text-gray-200">
							<option value="question">Câu hỏi gợi tò mò (Question)</option>
							<option value="shock">Cảnh báo / Gây sốc (Shock)</option>
							<option value="story">Kể chuyện cá nhân (Story)</option>
							<option value="pov">Góc nhìn hài hước (POV)</option>
							<option value="listicle">Danh sách mẹo (Listicle)</option>
							<option value="contrast">Đối lập trước/sau (Contrast)</option>
						</select>
					{/if}
				</div>

				<!-- 3. Beat Sync Music -->
				<div class="bg-gray-800/40 border border-gray-700/60 rounded-lg p-3 space-y-2">
					<label class="flex items-center justify-between font-semibold text-gray-200 cursor-pointer">
						<span class="flex items-center gap-2">
							<input type="checkbox" bind:checked={addons.beatSync} class="rounded text-blue-600" />
							<span>🎵 Beat-sync nhạc nền</span>
						</span>
						<span class="text-amber-400 font-mono text-[11px]">+5 credits</span>
					</label>
					{#if addons.beatSync}
						<select bind:value={addons.soundGenre} class="w-full bg-gray-900 border border-gray-700 rounded p-1.5 text-gray-200">
							<option value="chill">Chill Lo-Fi (85 BPM)</option>
							<option value="upbeat">Upbeat Viral (120 BPM)</option>
							<option value="electronic">Electronic Pulse (128 BPM)</option>
							<option value="acoustic">Acoustic Vlog (105 BPM)</option>
							<option value="dramatic">Cinematic Dramatic (90 BPM)</option>
							<option value="tech_pulse">Tech Minimal (124 BPM)</option>
						</select>
					{/if}
				</div>

				<!-- 4. AI B-Roll -->
				<div class="bg-gray-800/40 border border-gray-700/60 rounded-lg p-3 space-y-2">
					<label class="flex items-center justify-between font-semibold text-gray-200 cursor-pointer">
						<span class="flex items-center gap-2">
							<input type="checkbox" bind:checked={addons.bRoll} class="rounded text-blue-600" />
							<span>🎞️ AI B-Roll chèn cảnh</span>
						</span>
						<span class="text-amber-400 font-mono text-[11px]">+10 credits</span>
					</label>
					<p class="text-[11px] text-gray-400">Tự động sinh cảnh đệm bằng Flux/Veo thay thế stock footage</p>
				</div>

				<!-- 5. Platform Preset -->
				<div class="bg-gray-800/40 border border-gray-700/60 rounded-lg p-3 space-y-2">
					<div class="flex items-center justify-between font-semibold text-gray-200">
						<span class="flex items-center gap-2">
							<span>📱 Tối ưu nền tảng</span>
						</span>
						<span class="text-amber-400 font-mono text-[11px]">
							{addons.platformPreset !== 'none' ? '+3 credits' : 'Chưa chọn'}
						</span>
					</div>
					<select bind:value={addons.platformPreset} aria-label="Tối ưu nền tảng" class="w-full bg-gray-900 border border-gray-700 rounded p-1.5 text-gray-200">
						<option value="none">Không áp dụng (Giữ nguyên)</option>
						<option value="tiktok">TikTok (Nhịp nhanh, 9:16)</option>
						<option value="youtube_shorts">YouTube Shorts (Giữ nhịp đều, 9:16)</option>
						<option value="reels">Instagram Reels (1:1 hoặc 9:16)</option>
					</select>
				</div>

				<!-- 6. Audio Enhancement -->
				<div class="bg-gray-800/40 border border-gray-700/60 rounded-lg p-3 space-y-2">
					<label class="flex items-center justify-between font-semibold text-gray-200 cursor-pointer">
						<span class="flex items-center gap-2">
							<input type="checkbox" bind:checked={addons.audioEnhancement} class="rounded text-blue-600" />
							<span>🔊 Lọc ồn & -14 LUFS</span>
						</span>
						<span class="text-amber-400 font-mono text-[11px]">+3 credits</span>
					</label>
					<p class="text-[11px] text-gray-400">Khử tạp âm môi trường và chuẩn hóa âm lượng theo RULE-M07-005</p>
				</div>
			</div>

			<!-- Footer Credit Bar & Actions -->
			<div class="pt-4 border-t border-gray-800 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
				<div class="space-y-1">
					<div class="text-sm font-semibold text-white flex items-center gap-2">
						<span>Chi phí ước tính:</span>
						<span class="text-emerald-400 font-mono font-bold">🪙 {creditCost.totalCredits} credits</span>
						<span class="text-xs text-gray-500 font-normal">
							(15 cơ bản + {creditCost.addonCredits} tính năng thêm)
						</span>
					</div>
					<div class="text-xs text-gray-400">
						Số dư còn lại sau khi xuất: <strong class="text-white font-mono">{balanceAfter} credits</strong>
					</div>
				</div>

				<div class="flex items-center gap-3">
					<button
						type="button"
						on:click={saveDraft}
						class="px-4 py-2 text-xs font-semibold rounded-lg bg-gray-800 hover:bg-gray-700 text-gray-200 border border-gray-700 transition-all flex items-center gap-1.5">
						<span>💾</span>
						<span>Lưu bản nháp</span>
					</button>

					<button
						type="button"
						on:click={triggerApplyEdits}
						class="px-5 py-2 text-xs font-bold rounded-lg bg-blue-600 hover:bg-blue-500 text-white shadow-lg shadow-blue-600/20 transition-all flex items-center gap-2">
						<span>🚀</span>
						<span>Áp dụng chỉnh sửa ({creditCost.totalCredits} credits)</span>
					</button>
				</div>
			</div>
		</div>

	<!-- STEP 4: SUBMITTED CONFIRMATION -->
	{:else if step === 'submitted'}
		<div class="max-w-xl mx-auto py-16 text-center space-y-6">
			<div class="w-16 h-16 rounded-full bg-emerald-950 text-emerald-400 border border-emerald-800 flex items-center justify-center text-3xl mx-auto">
				✅
			</div>
			<div class="space-y-2">
				<h2 class="text-xl font-bold text-white">Yêu cầu Quick Edit đã được khởi tạo!</h2>
				<p class="text-xs text-gray-400">
					Hệ thống đang tiến hành cắt gọt video, đồng bộ beat nhạc, chèn phụ đề hoạt họa và chuẩn hóa âm lượng.
				</p>
			</div>
			<div class="bg-gray-900 border border-gray-800 rounded-xl p-4 text-left text-xs font-mono space-y-1">
				<div class="text-gray-400">Mã Job: <strong class="text-white">{submittedJobId}</strong></div>
				<div class="text-gray-400">Số credits đã trừ: <strong class="text-emerald-400">{creditCost.totalCredits} credits</strong></div>
				<div class="text-gray-400">Thời lượng dự kiến: <strong class="text-white">~{Math.round(timeline.finalDurationMs / 1000)} giây</strong></div>
			</div>
			<div class="flex items-center justify-center gap-3">
				<a href="/studio/queue" class="px-5 py-2 text-xs font-semibold rounded-lg bg-blue-600 text-white hover:bg-blue-500 transition-all">
					Xem tiến độ tại Generation Queue
				</a>
				<button
					type="button"
					on:click={() => (step = 'upload')}
					class="px-4 py-2 text-xs font-semibold rounded-lg bg-gray-800 text-gray-300 hover:bg-gray-700 transition-all">
					Chỉnh sửa video khác
				</button>
			</div>
		</div>
	{/if}
</div>

<!-- ASR REPAIR MODAL (EC-M07-Q01) -->
{#if showRepairModal && repairWord}
	<div class="fixed inset-0 bg-black/80 backdrop-blur-sm z-50 flex items-center justify-center p-4 animate-fade-in">
		<div class="bg-gray-900 border border-gray-800 rounded-2xl max-w-md w-full p-6 space-y-4 shadow-2xl">
			<div class="flex items-center justify-between pb-3 border-b border-gray-800">
				<h3 class="text-sm font-bold text-white flex items-center gap-2">
					<span>✏️</span>
					<span>Sửa lỗi chính tả / ASR (EC-M07-Q01)</span>
				</h3>
				<button type="button" on:click={() => (showRepairModal = false)} class="text-gray-400 hover:text-white">✕</button>
			</div>

			<div class="space-y-3 text-xs">
				<div>
					<label for="repair-text-input" class="block text-gray-400 mb-1">Nội dung từ hiển thị</label>
					<input
						id="repair-text-input"
						type="text"
						bind:value={repairInputText}
						class="w-full bg-gray-800 border border-gray-700 rounded-lg p-2 text-white font-medium focus:border-blue-500 focus:outline-none" />
				</div>

				<div class="grid grid-cols-2 gap-3">
					<div>
						<label for="repair-start-ms" class="block text-gray-400 mb-1">Bắt đầu (ms)</label>
						<input
							id="repair-start-ms"
							type="number"
							bind:value={repairStartMs}
							class="w-full bg-gray-800 border border-gray-700 rounded-lg p-2 text-white font-mono" />
					</div>
					<div>
						<label for="repair-end-ms" class="block text-gray-400 mb-1">Kết thúc (ms)</label>
						<input
							id="repair-end-ms"
							type="number"
							bind:value={repairEndMs}
							class="w-full bg-gray-800 border border-gray-700 rounded-lg p-2 text-white font-mono" />
					</div>
				</div>

				{#if repairErrorMessage}
					<div class="p-3 rounded-lg bg-red-950/80 border border-red-800 text-red-300 text-[11px] flex items-start gap-2">
						<span>⚠️</span>
						<span>{repairErrorMessage}</span>
					</div>
				{/if}
			</div>

			<div class="pt-3 border-t border-gray-800 flex items-center justify-end gap-2">
				<button
					type="button"
					on:click={() => (showRepairModal = false)}
					class="px-3 py-1.5 text-xs font-semibold rounded-lg bg-gray-800 hover:bg-gray-700 text-gray-300">
					Hủy bỏ
				</button>
				<button
					type="button"
					on:click={submitRepair}
					class="px-4 py-1.5 text-xs font-semibold rounded-lg bg-blue-600 hover:bg-blue-500 text-white shadow-lg shadow-blue-600/20">
					Cập nhật mốc thời gian
				</button>
			</div>
		</div>
	</div>
{/if}

<!-- CREDIT CONFIRMATION MODAL (Acceptance Criterion 1) -->
{#if showConfirmModal}
	<div class="fixed inset-0 bg-black/80 backdrop-blur-sm z-50 flex items-center justify-center p-4 animate-fade-in">
		<div class="bg-gray-900 border border-gray-800 rounded-2xl max-w-md w-full p-6 space-y-5 shadow-2xl">
			<div class="flex items-center gap-3">
				<span class="text-3xl p-2 bg-blue-950/60 rounded-xl border border-blue-800 text-blue-400">🪙</span>
				<div>
					<h3 class="text-base font-bold text-white">Xác nhận tạo video</h3>
					<p class="text-xs text-gray-400">Kiểm tra thông số khấu trừ trước khi đưa vào hàng đợi</p>
				</div>
			</div>

			<div class="bg-gray-800/60 rounded-xl p-4 space-y-2 text-xs font-mono">
				<div class="flex justify-between text-gray-300">
					<span>Estimated cost:</span>
					<strong class="text-emerald-400">{creditCost.totalCredits} credits</strong>
				</div>
				<div class="flex justify-between text-gray-300">
					<span>Your balance:</span>
					<strong class="text-white">{userBalance} credits</strong>
				</div>
				<div class="border-t border-gray-700 pt-2 flex justify-between text-gray-300">
					<span>Balance after:</span>
					<strong class={balanceAfter >= 0 ? 'text-white' : 'text-red-400'}>{balanceAfter} credits</strong>
				</div>
			</div>

			{#if balanceAfter < 0}
				<div class="p-3 rounded-lg bg-red-950/80 border border-red-800 text-red-300 text-xs">
					⚠️ Số dư không đủ để thực hiện yêu cầu này. Vui lòng nạp thêm credits hoặc bỏ bớt các add-on.
				</div>
			{/if}

			<div class="flex items-center justify-end gap-3 pt-2">
				<button
					type="button"
					on:click={() => (showConfirmModal = false)}
					class="px-4 py-2 text-xs font-semibold rounded-lg bg-gray-800 hover:bg-gray-700 text-gray-300 transition-all">
					Cancel
				</button>
				<button
					type="button"
					disabled={balanceAfter < 0}
					on:click={confirmApply}
					class="px-5 py-2 text-xs font-bold rounded-lg bg-blue-600 hover:bg-blue-500 disabled:opacity-50 text-white shadow-lg shadow-blue-600/20 transition-all">
					Generate
				</button>
			</div>
		</div>
	</div>
{/if}
