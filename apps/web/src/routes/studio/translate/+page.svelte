<script lang="ts">
	import { calculateTranslationQuoteClient, type TranslationJobItem, type VoiceCloneOption } from '$lib/production';

	interface TargetLang {
		code: string;
		name: string;
		flag: string;
		baseQuality: number;
	}

	const AVAILABLE_LANGUAGES: TargetLang[] = [
		{ code: 'vi', name: 'Tiếng Việt', flag: '🇻🇳', baseQuality: 96.0 },
		{ code: 'ja', name: '日本語 (Japanese)', flag: '🇯🇵', baseQuality: 92.0 },
		{ code: 'es', name: 'Español (Spanish)', flag: '🇪🇸', baseQuality: 93.0 },
		{ code: 'th', name: 'ไทย (Thai)', flag: '🇹🇭', baseQuality: 89.0 },
		{ code: 'id', name: 'Bahasa Indonesia', flag: '🇮🇩', baseQuality: 87.5 },
		{ code: 'ko', name: '한국어 (Korean)', flag: '🇰🇷', baseQuality: 91.0 },
		{ code: 'zh', name: '中文 (Chinese)', flag: '🇨🇳', baseQuality: 90.0 },
		{ code: 'fr', name: 'Français (French)', flag: '🇫🇷', baseQuality: 88.0 },
		{ code: 'de', name: 'Deutsch (German)', flag: '🇩🇪', baseQuality: 87.0 }
	];

	// Form State
	let selectedSourceAsset = 'asset-video-review-spf50';
	let selectedLangCodes: string[] = ['ja', 'es', 'vi'];
	let lipSyncEnabled = true;
	let culturalAdaptationEnabled = true;
	let translateCaptions = true;

	// Voice Option State (Acceptance Target 1: Consent Required)
	let voiceOption: 'native' | 'cloned' = 'native';
	let selectedVoiceCloneId = 'vc-mai-01';

	let voiceClones: VoiceCloneOption[] = [
		{
			voiceCloneId: 'vc-mai-01',
			name: 'Mai - Cố Vấn Làm Đẹp (Voice Clone)',
			characterId: 'char-mai-01',
			cloneStatus: 'ready',
			consentRecordId: 'consent-mai-verified',
			consentStatus: 'active',
			qualityScore: 92.5,
			repairApplied: false
		},
		{
			voiceCloneId: 'vc-an-02',
			name: 'An - Reviewer Công Nghệ (Consent Revoked)',
			characterId: 'char-an-02',
			cloneStatus: 'revoked',
			consentRecordId: 'consent-an-revoked',
			consentStatus: 'revoked',
			qualityScore: 71.0,
			repairApplied: true
		}
	];

	// Quote Calculation (Acceptance Target 3: Measured Quote & Volume Discount)
	$: quote = calculateTranslationQuoteClient(
		selectedLangCodes.length,
		lipSyncEnabled,
		culturalAdaptationEnabled
	);

	// Side-by-side Script Review & Quality Repair (Acceptance Target 2)
	let originalScriptSegment = 'Xin chào các bạn, hôm nay mình sẽ trải nghiệm dòng kem chống nắng thuần chay mới nhất này!';
	let localizedSegments: Record<string, string> = {
		vi: 'Xin chào các bạn, hôm nay mình sẽ trải nghiệm dòng kem chống nắng thuần chay mới nhất này!',
		ja: '皆さんこんにちは！今日は最新のヴィーガン日焼け止めを実際にレビューしていきます！',
		es: '¡Hola a todos! ¡Hoy voy a probar este nuevo protector solar vegano!',
		th: 'สวัสดีค่ะทุกคน วันนี้เราจะมารีวิวครีมกันแดดวีแกนตัวใหม่ล่าสุดกันนะคะ!'
	};

	let customRepairs: Record<string, string> = {};
	let activeReviewLang = 'ja';

	// History of Translation Jobs
	let jobs: TranslationJobItem[] = [
		{
			jobId: 'job-trans-01',
			workspaceId: 'ws-studio',
			sourceAssetId: 'asset-video-review-spf50',
			targetLanguages: ['ja', 'es'],
			lipSyncEnabled: true,
			culturalAdaptationEnabled: true,
			translateCaptions: true,
			voiceOption: 'native',
			status: 'completed',
			qualityScores: { ja: 92.0, es: 93.0 },
			repairNotes: {
				ja: 'Post-production speech normalization (-14 LUFS) and lip-sync alignment applied',
				es: 'Post-production speech normalization (-14 LUFS) and lip-sync alignment applied'
			},
			outputAssetIds: { ja: 'asset-trans-ja-01', es: 'asset-trans-es-01' },
			totalCreditsUsed: '63',
			quoteId: 'quote-trans-001',
			createdAt: '2026-10-30T09:00:00Z',
			updatedAt: '2026-10-30T09:05:00Z'
		}
	];

	let isSubmitting = false;
	let executionMessage = '';
	let errorMessage = '';

	function toggleLanguage(code: string) {
		if (selectedLangCodes.includes(code)) {
			selectedLangCodes = selectedLangCodes.filter((c) => c !== code);
		} else {
			selectedLangCodes = [...selectedLangCodes, code];
		}
	}

	function handleApplyCustomRepair(lang: string) {
		customRepairs[lang] = 'Custom script repair applied by user; voiceover re-synthesized';
		executionMessage = `Đã lưu bản sửa kịch bản cho ${lang.toUpperCase()}. Điểm chất lượng được cập nhật và âm thanh chuẩn hóa -14 LUFS.`;
	}

	function handleCreateTranslation() {
		errorMessage = '';
		executionMessage = '';

		if (selectedLangCodes.length === 0) {
			errorMessage = 'Vui lòng chọn ít nhất một ngôn ngữ đích để dịch thuật.';
			return;
		}

		// Acceptance Target 1: Consent Required for Cloned Voice
		if (voiceOption === 'cloned') {
			const clone = voiceClones.find((c) => c.voiceCloneId === selectedVoiceCloneId);
			if (!clone || clone.consentStatus === 'revoked') {
				errorMessage = 'Không thể sử dụng giọng nhân bản này: Sự đồng thuận hình ảnh/giọng nói (Likeness Consent) chưa được cấp hoặc đã bị thu hồi (RULE-M08-002).';
				return;
			}
		}

		isSubmitting = true;
		setTimeout(() => {
			const qualityScores: Record<string, number> = {};
			const repairNotes: Record<string, string> = {};
			const outputAssetIds: Record<string, string> = {};

			for (const code of selectedLangCodes) {
				const langObj = AVAILABLE_LANGUAGES.find((l) => l.code === code);
				qualityScores[code] = (langObj?.baseQuality || 88.0) + (customRepairs[code] ? 4.0 : 0);
				repairNotes[code] = customRepairs[code] || 'Post-production speech normalization (-14 LUFS) and lip-sync alignment applied';
				outputAssetIds[code] = `asset-out-${code}-${Date.now()}`;
			}

			const newJob: TranslationJobItem = {
				jobId: `job-trans-${Date.now()}`,
				workspaceId: 'ws-studio',
				sourceAssetId: selectedSourceAsset,
				targetLanguages: [...selectedLangCodes],
				lipSyncEnabled,
				culturalAdaptationEnabled,
				translateCaptions,
				voiceOption,
				voiceCloneId: voiceOption === 'cloned' ? selectedVoiceCloneId : undefined,
				status: 'completed',
				qualityScores,
				repairNotes,
				outputAssetIds,
				totalCreditsUsed: quote.totalCredits,
				quoteId: `quote-${Date.now()}`,
				createdAt: new Date().toISOString(),
				updatedAt: new Date().toISOString()
			};

			jobs = [newJob, ...jobs];
			isSubmitting = false;
			executionMessage = `Khởi tạo chiến dịch dịch thuật thành công! Đã trừ ${quote.totalCredits} credits (Giảm giá số lượng: ${(quote.discountPct * 100).toFixed(0)}%).`;
		}, 700);
	}
</script>

<svelte:head>
	<title>AI Translation & Localization Studio (W033) | Creativanta</title>
</svelte:head>

<div class="min-h-screen bg-slate-950 text-slate-100 p-6 md:p-8">
	<!-- Header -->
	<div class="max-w-7xl mx-auto mb-8 flex flex-col md:flex-row md:items-center md:justify-between gap-4 border-b border-slate-800 pb-6">
		<div>
			<div class="flex items-center gap-3">
				<span class="text-3xl">🌐</span>
				<h1 class="text-2xl md:text-3xl font-bold tracking-tight">AI Translation & Localization Studio</h1>
				<span class="text-xs bg-indigo-500/20 text-indigo-300 border border-indigo-500/30 px-2 py-0.5 rounded-full font-mono">W033 · EF-05</span>
			</div>
			<p class="text-slate-400 text-sm mt-1">Dịch video sang hơn 29 ngôn ngữ, đồng bộ cử động môi (Lip-Sync SyncLabs), thích ứng văn hóa và lồng tiếng chuẩn -14 LUFS.</p>
		</div>

		<div class="flex items-center gap-3">
			<a
				href="/studio/sound"
				class="px-4 py-2 bg-slate-900 hover:bg-slate-800 border border-slate-700 text-slate-200 text-xs font-medium rounded-xl transition-all flex items-center gap-2"
			>
				<span>🎵</span> Đến Sound Studio (W028)
			</a>
		</div>
	</div>

	<!-- Alert Messages -->
	{#if errorMessage}
		<div class="max-w-7xl mx-auto mb-6 bg-rose-950/40 border border-rose-500/40 p-4 rounded-xl flex items-center justify-between text-rose-200 text-sm">
			<div class="flex items-center gap-2">
				<span class="text-rose-400 font-bold">⚠️</span>
				<span>{errorMessage}</span>
			</div>
			<button class="text-xs text-rose-400 hover:underline" on:click={() => (errorMessage = '')}>Đóng</button>
		</div>
	{/if}

	{#if executionMessage}
		<div class="max-w-7xl mx-auto mb-6 bg-emerald-950/40 border border-emerald-500/40 p-4 rounded-xl flex items-center justify-between text-emerald-200 text-sm">
			<div class="flex items-center gap-2">
				<span class="text-emerald-400 font-bold">✓</span>
				<span>{executionMessage}</span>
			</div>
			<button class="text-xs text-emerald-400 hover:underline" on:click={() => (executionMessage = '')}>Đóng</button>
		</div>
	{/if}

	<!-- Main Two-Column Layout -->
	<div class="max-w-7xl mx-auto grid grid-cols-1 lg:grid-cols-12 gap-8">
		<!-- Left Column: Configuration & Quote (7 cols) -->
		<div class="lg:col-span-7 space-y-6">
			<!-- Video Source Selection -->
			<div class="bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-xl space-y-4">
				<h2 class="font-semibold text-base flex items-center gap-2">
					<span>🎬</span> 1. Chọn Video Gốc Cần Bản Địa Hóa
				</h2>
				<select
					bind:value={selectedSourceAsset}
					class="w-full bg-slate-950 border border-slate-700 rounded-xl px-3.5 py-2.5 text-sm text-slate-200 focus:outline-none focus:border-indigo-500"
				>
					<option value="asset-video-review-spf50">Video review kem chống nắng SPF50 (Thời lượng: 60s · Tiếng Việt gốc)</option>
					<option value="asset-video-smartwatch">Video quảng cáo đồng hồ Chronograph (Thời lượng: 45s · Tiếng Anh gốc)</option>
				</select>
			</div>

			<!-- Target Languages Multi-select -->
			<div class="bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-xl space-y-4">
				<div class="flex items-center justify-between">
					<h2 class="font-semibold text-base flex items-center gap-2">
						<span>🗺️</span> 2. Chọn Ngôn Ngữ Đích ({selectedLangCodes.length} đã chọn)
					</h2>
					<span class="text-xs text-slate-400">Tối đa 29 ngôn ngữ</span>
				</div>

				<div class="grid grid-cols-2 sm:grid-cols-3 gap-2.5">
					{#each AVAILABLE_LANGUAGES as lang}
						<button
							type="button"
							class="p-2.5 rounded-xl border text-left text-xs font-medium transition-all flex items-center justify-between {selectedLangCodes.includes(lang.code) ? 'bg-indigo-950/60 border-indigo-500/70 text-white shadow-sm' : 'bg-slate-950/60 border-slate-800 text-slate-400 hover:border-slate-700'}"
							on:click={() => toggleLanguage(lang.code)}
						>
							<div class="flex items-center gap-2">
								<span class="text-base">{lang.flag}</span>
								<span>{lang.name}</span>
							</div>
							{#if selectedLangCodes.includes(lang.code)}
								<span class="text-indigo-400 font-bold">✓</span>
							{/if}
						</button>
					{/each}
				</div>
			</div>

			<!-- Voice Mode & Likeness Consent Check (Acceptance Target 1) -->
			<div class="bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-xl space-y-4">
				<h2 class="font-semibold text-base flex items-center gap-2">
					<span>🎙️</span> 3. Chọn Chế Độ Giọng Đọc Lồng Tiếng
				</h2>

				<div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
					<label class="p-4 rounded-xl border cursor-pointer transition-all {voiceOption === 'native' ? 'bg-indigo-950/50 border-indigo-500/80 shadow' : 'bg-slate-950 border-slate-800 hover:border-slate-700'}">
						<div class="flex items-center gap-2">
							<input type="radio" value="native" bind:group={voiceOption} class="accent-indigo-500" />
							<span class="font-semibold text-sm text-slate-100">Giọng Bản Xứ AI (Native AI)</span>
						</div>
						<p class="text-xs text-slate-400 mt-2 leading-relaxed">
							Tự động tuyển chọn giọng đọc người bản ngữ phù hợp độ tuổi, giới tính và ngữ điệu video gốc.
						</p>
					</label>

					<label class="p-4 rounded-xl border cursor-pointer transition-all {voiceOption === 'cloned' ? 'bg-indigo-950/50 border-indigo-500/80 shadow' : 'bg-slate-950 border-slate-800 hover:border-slate-700'}">
						<div class="flex items-center gap-2">
							<input type="radio" value="cloned" bind:group={voiceOption} class="accent-indigo-500" />
							<span class="font-semibold text-sm text-slate-100">Giọng Nhân Bản Số (Voice Clone)</span>
						</div>
						<p class="text-xs text-slate-400 mt-2 leading-relaxed">
							Giữ nguyên âm sắc đặc trưng của người nói gốc qua tất cả các ngôn ngữ (yêu cầu xác thực đồng thuận).
						</p>
					</label>
				</div>

				{#if voiceOption === 'cloned'}
					<!-- Voice Clone Picker & Consent Warning -->
					<div class="p-4 bg-slate-950 border border-slate-800 rounded-xl space-y-3">
						<label for="clone-select" class="block text-xs font-medium text-slate-300">Chọn Bản Nhân Bản Giọng (Voice Clone ID)</label>
						<select
							id="clone-select"
							bind:value={selectedVoiceCloneId}
							class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3 py-2 text-sm text-slate-200"
						>
							{#each voiceClones as vc}
								<option value={vc.voiceCloneId}>
									{vc.name} [{vc.consentStatus === 'active' ? '✓ Consent Verified' : '⛔ Consent Revoked'}]
								</option>
							{/each}
						</select>

						{#if voiceClones.find((c) => c.voiceCloneId === selectedVoiceCloneId)?.consentStatus === 'revoked'}
							<div class="p-3 bg-rose-950/40 border border-rose-500/40 rounded-lg text-xs text-rose-300 flex items-start gap-2">
								<span class="text-rose-400 font-bold">⛔</span>
								<div>
									<strong>Sự đồng thuận đã bị thu hồi:</strong> Bản nhân bản giọng này không thể sử dụng để xuất bản hoặc lồng tiếng mới theo điều khoản pháp lý và bảo vệ danh tính (RULE-M08-002).
								</div>
							</div>
						{:else}
							<div class="p-3 bg-emerald-950/30 border border-emerald-500/30 rounded-lg text-xs text-emerald-300 flex items-center gap-2">
								<span class="text-emerald-400">🛡️</span>
								<span>Đã xác minh văn bản đồng thuận likeness consent (Hợp lệ cho dịch thuật đa ngôn ngữ).</span>
							</div>
						{/if}
					</div>
				{/if}
			</div>

			<!-- Enhancements & Features -->
			<div class="bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-xl space-y-4">
				<h2 class="font-semibold text-base flex items-center gap-2">
					<span>✨</span> 4. Tùy Chọn Nâng Cao
				</h2>

				<div class="space-y-3">
					<label class="flex items-center justify-between p-3 bg-slate-950 border border-slate-800 rounded-xl cursor-pointer">
						<div>
							<div class="text-xs font-semibold text-slate-200">Khớp khẩu hình vi mô (Lip-Sync SyncLabs)</div>
							<div class="text-[11px] text-slate-400">Tự động căn chỉnh cử động môi của diễn viên khớp từng âm vị ngôn ngữ mới (+10 cr/ngôn ngữ)</div>
						</div>
						<input type="checkbox" bind:checked={lipSyncEnabled} class="accent-indigo-500 w-4 h-4 rounded" />
					</label>

					<label class="flex items-center justify-between p-3 bg-slate-950 border border-slate-800 rounded-xl cursor-pointer">
						<div>
							<div class="text-xs font-semibold text-slate-200">Bản địa hóa văn hóa (Cultural Adaptation)</div>
							<div class="text-[11px] text-slate-400">Tự động chuyển đổi đơn vị đo, thành ngữ và phong cách xưng hô phù hợp thị trường (+5 cr/ngôn ngữ)</div>
						</div>
						<input type="checkbox" bind:checked={culturalAdaptationEnabled} class="accent-indigo-500 w-4 h-4 rounded" />
					</label>

					<label class="flex items-center justify-between p-3 bg-slate-950 border border-slate-800 rounded-xl cursor-pointer">
						<div>
							<div class="text-xs font-semibold text-slate-200">Xuất file phụ đề đa ngữ (.SRT / .VTT)</div>
							<div class="text-[11px] text-slate-400">Bao gồm phụ đề động đóng gói sẵn kèm video xuất bản</div>
						</div>
						<input type="checkbox" bind:checked={translateCaptions} class="accent-indigo-500 w-4 h-4 rounded" />
					</label>
				</div>
			</div>

			<!-- Measured Quote Summary Card (Acceptance Target 3) -->
			<div class="bg-gradient-to-br from-indigo-950/60 to-slate-900 border border-indigo-500/40 rounded-2xl p-6 shadow-xl space-y-4">
				<div class="flex items-center justify-between">
					<h2 class="font-semibold text-base text-indigo-200 flex items-center gap-2">
						<span>💳</span> Báo Giá Đo Lường (Measured Quote)
					</h2>
					{#if quote.discountPct > 0}
						<span class="px-2.5 py-0.5 bg-emerald-500/20 text-emerald-300 border border-emerald-500/30 rounded-full text-xs font-bold font-mono">
							Giảm giá: {(quote.discountPct * 100).toFixed(0)}%
						</span>
					{/if}
				</div>

				<div class="grid grid-cols-2 sm:grid-cols-4 gap-3 text-xs">
					<div class="p-3 bg-slate-950/70 rounded-xl border border-slate-800">
						<span class="text-slate-400 block">Số ngôn ngữ</span>
						<span class="text-lg font-bold font-mono text-slate-100">{selectedLangCodes.length}</span>
					</div>
					<div class="p-3 bg-slate-950/70 rounded-xl border border-slate-800">
						<span class="text-slate-400 block">Giá / ngôn ngữ</span>
						<span class="text-lg font-bold font-mono text-slate-100">{quote.costPerLanguage} Cr</span>
					</div>
					<div class="p-3 bg-slate-950/70 rounded-xl border border-slate-800">
						<span class="text-slate-400 block">Chiết khấu SL</span>
						<span class="text-lg font-bold font-mono text-emerald-400">-{(quote.discountPct * 100).toFixed(0)}%</span>
					</div>
					<div class="p-3 bg-slate-950/70 rounded-xl border border-indigo-500/40">
						<span class="text-indigo-300 block font-medium">Tổng Credits</span>
						<span class="text-xl font-bold font-mono text-indigo-300">{quote.totalCredits}</span>
					</div>
				</div>

				<div class="text-[11px] text-slate-400 leading-relaxed">
					* Công thức chiết khấu số lượng: 1 ngôn ngữ (0%), 2 ngôn ngữ (10%), 3 ngôn ngữ (20%), 4+ ngôn ngữ (30% tối đa). Báo giá được khóa cố định trước khi thực thi (Bound Quote).
				</div>

				<button
					disabled={isSubmitting || selectedLangCodes.length === 0}
					on:click={handleCreateTranslation}
					class="w-full py-3 bg-indigo-600 hover:bg-indigo-500 disabled:opacity-50 text-white font-semibold text-sm rounded-xl shadow-lg transition-all flex items-center justify-center gap-2"
				>
					{#if isSubmitting}
						<span class="animate-spin">⏳</span> Đang tạo chiến dịch dịch thuật...
					{:else}
						<span>🚀</span> Bắt Đầu Dịch Thuật & Bản Địa Hóa ({quote.totalCredits} Credits)
					{/if}
				</button>
			</div>
		</div>

		<!-- Right Column: Script Review & Quality Repair (5 cols) -->
		<div class="lg:col-span-5 space-y-6">
			<!-- Script Side-by-Side Review & Repair (Acceptance Target 2) -->
			<div class="bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-xl space-y-4">
				<div class="flex items-center justify-between">
					<h3 class="font-semibold text-sm text-slate-200 flex items-center gap-2">
						<span>📝</span> So Sánh & Sửa Chữa Kịch Bản (Repair)
					</h3>
					<span class="text-xs font-mono text-emerald-400 bg-emerald-500/10 px-2 py-0.5 rounded">
						-14 LUFS Standard
					</span>
				</div>

				<!-- Language Subtabs for Script Review -->
				<div class="flex gap-1.5 overflow-x-auto pb-1">
					{#each selectedLangCodes as code}
						<button
							class="px-2.5 py-1 text-xs rounded-lg font-medium transition-all {activeReviewLang === code ? 'bg-indigo-600 text-white' : 'bg-slate-950 text-slate-400 hover:text-white'}"
							on:click={() => (activeReviewLang = code)}
						>
							{AVAILABLE_LANGUAGES.find((l) => l.code === code)?.flag} {code.toUpperCase()}
						</button>
					{/each}
				</div>

				<!-- Original Source Segment -->
				<div class="space-y-1.5">
					<span class="text-[11px] font-semibold text-slate-400 uppercase tracking-wider">Kịch bản thoại gốc (Tiếng Việt)</span>
					<div class="p-3 bg-slate-950 border border-slate-800 rounded-xl text-xs text-slate-300 leading-relaxed">
						{originalScriptSegment}
					</div>
				</div>

				<!-- Localized Segment & In-Place Editor -->
				<div class="space-y-1.5">
					<div class="flex items-center justify-between">
						<span class="text-[11px] font-semibold text-slate-400 uppercase tracking-wider">Bản dịch máy & Khẩu hình ({activeReviewLang.toUpperCase()})</span>
						<span class="text-xs font-mono text-indigo-400">
							Điểm chất lượng: {AVAILABLE_LANGUAGES.find((l) => l.code === activeReviewLang)?.baseQuality || 90.0}%
						</span>
					</div>
					<textarea
						bind:value={localizedSegments[activeReviewLang]}
						rows="4"
						class="w-full bg-slate-950 border border-slate-700 rounded-xl p-3 text-xs text-slate-100 placeholder-slate-500 focus:outline-none focus:border-indigo-500"
					></textarea>
				</div>

				<div class="flex items-center justify-between pt-1">
					<span class="text-[11px] text-slate-500">
						{#if customRepairs[activeReviewLang]}
							<span class="text-emerald-400">✓ Đã áp dụng sửa chữa thủ công</span>
						{:else}
							Sửa kịch bản để tự động tổng hợp lại audio
						{/if}
					</span>
					<button
						type="button"
						on:click={() => handleApplyCustomRepair(activeReviewLang)}
						class="px-3 py-1.5 bg-slate-800 hover:bg-slate-700 text-slate-200 text-xs font-medium rounded-lg border border-slate-700 transition-all"
					>
						Lưu Sửa Chữa (Repair)
					</button>
				</div>
			</div>

			<!-- Recent Translation Jobs Queue -->
			<div class="bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-xl space-y-4">
				<div class="flex items-center justify-between">
					<h3 class="font-semibold text-sm text-slate-200 flex items-center gap-2">
						<span>⏱️</span> Lịch Sử Chiến Dịch Dịch Thuật ({jobs.length})
					</h3>
					<span class="text-xs text-slate-400">Trạng thái thời gian thực</span>
				</div>

				<div class="space-y-3">
					{#each jobs as job}
						<div class="p-3.5 bg-slate-950 border border-slate-800 rounded-xl space-y-2 text-xs">
							<div class="flex items-center justify-between">
								<span class="font-mono text-indigo-400 font-semibold">{job.jobId}</span>
								<span class="px-2 py-0.5 bg-emerald-500/20 text-emerald-300 border border-emerald-500/30 rounded text-[10px] font-semibold uppercase">
									{job.status}
								</span>
							</div>

							<div class="flex items-center gap-1.5 flex-wrap">
								<span class="text-slate-400">Ngôn ngữ:</span>
								{#each job.targetLanguages as l}
									<span class="px-1.5 py-0.5 bg-slate-800 rounded font-mono text-[10px] text-slate-300">{l.toUpperCase()}</span>
								{/each}
								<span class="text-slate-500 ml-auto font-mono">{job.totalCreditsUsed} Cr</span>
							</div>

							<div class="text-[11px] text-slate-500 border-t border-slate-800/80 pt-2 space-y-1">
								{#each Object.entries(job.repairNotes) as [code, note]}
									<div class="truncate">
										<strong class="text-slate-400">{code.toUpperCase()}:</strong> {note}
									</div>
								{/each}
							</div>
						</div>
					{/each}
				</div>
			</div>
		</div>
	</div>
</div>
