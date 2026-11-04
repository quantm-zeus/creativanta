<script lang="ts">
	import {
		STANDARD_OBSERVATIONAL_NOTICE,
		type ABExperiment,
		type ABVariant,
		evaluateExperiment,
		scaleExperimentWinner,
		ScalingGateError
	} from '$lib/production/ab_test_coach';

	// State
	let selectedSourceAssetId = $state('asset-serum-01');
	let testTitle = $state('Serum Review Hook Test');
	let hypothesis = $state('Question hook increases initial 3s retention and comment CTR');
	let winnerCriteria = $state<'engagement_rate' | 'click_through' | 'views'>('engagement_rate');
	let testDuration = $state('48h');
	let autoWinner = $state(true);
	let targetPlatform = $state('tiktok');

	// Dimensions
	let hookVariation = $state(true);
	let thumbnailVariation = $state(true);
	let ctaVariation = $state(false);
	let musicVariation = $state(false);

	let callerRole = $state('Editor');
	let platformCapability = $state<'active' | 'degraded' | 'unsupported' | 'revoked'>('active');
	let packagingBlocked = $state(false);
	let priorDuplicatePost = $state(false);

	let activeExperiments = $state<ABExperiment[]>([
		{
			experimentId: 'exp-serum-review',
			workspaceId: 'ws-demo',
			sourceAssetId: 'asset-serum-01',
			title: 'Serum Review Hook Test',
			hypothesis: 'Question hook retains more viewers',
			variantAssetIds: ['var-a', 'var-b', 'var-c'],
			variantCount: 3,
			targetMetric: 'engagement_rate',
			minDurationHours: 48,
			minImpressionsPerVariant: 1000,
			autoWinnerThresholdMultiplier: 1.2,
			status: 'running',
			resultStatus: 'pending',
			isObservational: true,
			createdAt: new Date().toISOString(),
			updatedAt: new Date().toISOString(),
			variants: [
				{
					variantId: 'var-a',
					assetId: 'asset-var-a',
					variantType: 'hook',
					variantLabel: 'Variant A (Question Hook)',
					impressions: 2400,
					views: 2400,
					clicks: 196,
					ctr: 0.082,
					conversions: 18,
					engagementRate: 8.2
				},
				{
					variantId: 'var-b',
					assetId: 'asset-var-b',
					variantType: 'hook',
					variantLabel: 'Variant B (Statistical Hook)',
					impressions: 1800,
					views: 1800,
					clicks: 110,
					ctr: 0.061,
					conversions: 11,
					engagementRate: 6.1
				},
				{
					variantId: 'var-c',
					assetId: 'asset-var-c',
					variantType: 'hook',
					variantLabel: 'Variant C (Contrarian Hook)',
					impressions: 2100,
					views: 2100,
					clicks: 113,
					ctr: 0.054,
					conversions: 9,
					engagementRate: 5.4
				}
			]
		},
		{
			experimentId: 'exp-low-exposure',
			workspaceId: 'ws-demo',
			sourceAssetId: 'asset-lip-02',
			title: 'Lipstick Color Thumbnail Test',
			hypothesis: 'Bright thumbnail drives higher CTR',
			variantAssetIds: ['var-low-1', 'var-low-2'],
			variantCount: 2,
			targetMetric: 'click_through',
			minDurationHours: 48,
			minImpressionsPerVariant: 1000,
			autoWinnerThresholdMultiplier: 1.2,
			status: 'running',
			resultStatus: 'pending',
			isObservational: true,
			createdAt: new Date().toISOString(),
			updatedAt: new Date().toISOString(),
			variants: [
				{
					variantId: 'var-low-1',
					assetId: 'asset-thumb-1',
					variantType: 'thumbnail',
					variantLabel: 'Variant A (Ruby Red)',
					impressions: 25,
					views: 25,
					clicks: 2,
					ctr: 0.08,
					conversions: 0,
					engagementRate: 4.0
				},
				{
					variantId: 'var-low-2',
					assetId: 'asset-thumb-2',
					variantType: 'thumbnail',
					variantLabel: 'Variant B (Nude Pink)',
					impressions: 20,
					views: 20,
					clicks: 1,
					ctr: 0.05,
					conversions: 0,
					engagementRate: 3.5
				}
			]
		}
	]);

	let actionMessage = $state<string | null>(null);
	let actionError = $state<string | null>(null);

	function handleEvaluate(exp: ABExperiment) {
		actionMessage = null;
		actionError = null;

		const result = evaluateExperiment(exp, exp.minImpressionsPerVariant, exp.autoWinnerThresholdMultiplier);
		exp.status = result.status;
		exp.resultStatus = result.resultStatus;
		exp.winnerAssetId = result.winnerAssetId;
		exp.isObservational = result.isObservational;
		exp.inconclusiveReason = result.inconclusiveReason;

		if (result.resultStatus === 'conclusive') {
			actionMessage = `Đã xác định Winner (${result.winnerAssetId}). ${STANDARD_OBSERVATIONAL_NOTICE}`;
		} else {
			actionMessage = `Kết quả Inconclusive: ${result.inconclusiveReason}. ${STANDARD_OBSERVATIONAL_NOTICE}`;
		}
	}

	function handleScale(exp: ABExperiment) {
		actionMessage = null;
		actionError = null;

		try {
			const res = scaleExperimentWinner(exp, ['tiktok', 'youtube'], {
				callerRole,
				platformCapabilityState: platformCapability,
				hasPackagingHardBlocks: packagingBlocked,
				packagingComplianceResult: packagingBlocked ? 'blocked' : 'pass',
				priorPostWithinCooldown: priorDuplicatePost
			});

			exp.resultStatus = 'scaled';
			actionMessage = `${res.message} ${STANDARD_OBSERVATIONAL_NOTICE}`;
		} catch (err: any) {
			if (err instanceof ScalingGateError) {
				actionError = `M11 Gate Blocked [${err.gate}]: ${err.message}`;
			} else {
				actionError = err.message || 'Lỗi khi scale winner';
			}
		}
	}
</script>

<div class="mx-auto max-w-6xl space-y-8 p-6 text-slate-100">
	<!-- Page Header -->
	<div class="flex items-center justify-between border-b border-slate-700 pb-4">
		<div>
			<h1 class="text-2xl font-bold tracking-tight text-white flex items-center gap-2">
				<span>🧪</span> Studio — A/B Testing Engine (EF-10 / M10)
			</h1>
			<p class="text-sm text-slate-400">
				Tạo biến thể hook, CTA, thumbnail, nhạc nền và đánh giá winner có kiểm soát bằng chứng thống kê.
			</p>
		</div>
		<div class="flex items-center gap-3">
			<span class="rounded bg-sky-900/60 px-3 py-1 text-xs font-semibold text-sky-300 border border-sky-600">
				W027 · SvelteKit
			</span>
			<span class="rounded bg-emerald-900/60 px-3 py-1 text-xs font-semibold text-emerald-300 border border-emerald-600">
				M07 / M10
			</span>
		</div>
	</div>

	<!-- Observational Banner -->
	<div class="rounded-lg border border-amber-500/40 bg-amber-950/20 p-4 text-xs text-amber-200 flex items-start gap-3">
		<span class="text-base">💡</span>
		<div>
			<strong class="font-semibold text-amber-300">Quy tắc bằng chứng quan sát (API Behavior §7):</strong>
			Mọi so sánh organic không qua phân phối ngẫu nhiên tương đương phải được gắn nhãn
			<span class="underline font-mono">observational</span>, không tự động suy diễn quan hệ nhân quả hay bảo đảm doanh thu.
			Thử nghiệm dưới 1.000 views/variant luôn giữ trạng thái <em>inconclusive</em>.
		</div>
	</div>

	<!-- Status & Toast Feedback -->
	{#if actionMessage}
		<div class="rounded-md border border-emerald-500/50 bg-emerald-950/40 p-4 text-sm text-emerald-200" role="status">
			✅ {actionMessage}
		</div>
	{/if}
	{#if actionError}
		<div class="rounded-md border border-rose-500/50 bg-rose-950/40 p-4 text-sm text-rose-200" role="alert">
			⛔ {actionError}
		</div>
	{/if}

	<!-- Setup Section -->
	<div class="grid grid-cols-1 gap-6 lg:grid-cols-3">
		<!-- Left: Source & Dimensions -->
		<div class="space-y-6 lg:col-span-2">
			<!-- Source Selector -->
			<div class="rounded-xl border border-slate-700 bg-slate-800/80 p-5 shadow-lg space-y-4">
				<h2 class="text-base font-semibold text-white flex items-center gap-2">
					<span>🎬</span> Chọn Video Gốc (Source Video)
				</h2>
				<div>
					<label for="base-video" class="block text-xs font-medium text-slate-400 mb-1">Base Video từ thư viện</label>
					<select
						id="base-video"
						bind:value={selectedSourceAssetId}
						class="w-full rounded-md border border-slate-600 bg-slate-900 px-3 py-2 text-sm text-white focus:border-sky-500 focus:outline-none"
					>
						<option value="asset-serum-01">Serum Review — Video chính (30s, 9:16)</option>
						<option value="asset-lip-02">Lipstick Swatch — Video chính (15s, 9:16)</option>
						<option value="asset-unboxing-03">Unboxing Daily Vlog (45s, 9:16)</option>
					</select>
				</div>
				<div class="grid grid-cols-2 gap-4">
					<div>
						<label for="test-title" class="block text-xs font-medium text-slate-400 mb-1">Tên thử nghiệm</label>
						<input
							id="test-title"
							type="text"
							bind:value={testTitle}
							class="w-full rounded-md border border-slate-600 bg-slate-900 px-3 py-2 text-sm text-white focus:border-sky-500 focus:outline-none"
						/>
					</div>
					<div>
						<label for="test-hypo" class="block text-xs font-medium text-slate-400 mb-1">Giả thuyết thử nghiệm</label>
						<input
							id="test-hypo"
							type="text"
							bind:value={hypothesis}
							class="w-full rounded-md border border-slate-600 bg-slate-900 px-3 py-2 text-sm text-white focus:border-sky-500 focus:outline-none"
						/>
					</div>
				</div>
			</div>

			<!-- Variant Dimensions -->
			<div class="rounded-xl border border-slate-700 bg-slate-800/80 p-5 shadow-lg space-y-4">
				<h2 class="text-base font-semibold text-white flex items-center gap-2">
					<span>📐</span> Yếu Tố Thử Nghiệm (Variant Dimensions)
				</h2>
				<div class="grid grid-cols-2 gap-4">
					<label class="flex items-center gap-3 rounded-lg border border-slate-700 p-3 hover:bg-slate-700/40 cursor-pointer">
						<input type="checkbox" bind:checked={hookVariation} class="h-4 w-4 rounded border-slate-600 text-sky-600" />
						<div>
							<div class="text-sm font-medium text-white">Hook (3 giây đầu)</div>
							<div class="text-xs text-slate-400">AI sinh 3 phong cách mở đầu</div>
						</div>
					</label>
					<label class="flex items-center gap-3 rounded-lg border border-slate-700 p-3 hover:bg-slate-700/40 cursor-pointer">
						<input type="checkbox" bind:checked={thumbnailVariation} class="h-4 w-4 rounded border-slate-600 text-sky-600" />
						<div>
							<div class="text-sm font-medium text-white">Thumbnail (Ảnh bìa)</div>
							<div class="text-xs text-slate-400">3 biến thể tiêu đề ảnh bìa</div>
						</div>
					</label>
					<label class="flex items-center gap-3 rounded-lg border border-slate-700 p-3 hover:bg-slate-700/40 cursor-pointer">
						<input type="checkbox" bind:checked={ctaVariation} class="h-4 w-4 rounded border-slate-600 text-sky-600" />
						<div>
							<div class="text-sm font-medium text-white">Call to Action (CTA)</div>
							<div class="text-xs text-slate-400">Vị trí và nội dung kêu gọi</div>
						</div>
					</label>
					<label class="flex items-center gap-3 rounded-lg border border-slate-700 p-3 hover:bg-slate-700/40 cursor-pointer">
						<input type="checkbox" bind:checked={musicVariation} class="h-4 w-4 rounded border-slate-600 text-sky-600" />
						<div>
							<div class="text-sm font-medium text-white">Nhạc nền (Audio)</div>
							<div class="text-xs text-slate-400">Năng lượng và nhịp điệu khác nhau</div>
						</div>
					</label>
				</div>
			</div>
		</div>

		<!-- Right: Test Settings & M11 Scaling Controls -->
		<div class="space-y-6">
			<div class="rounded-xl border border-slate-700 bg-slate-800/80 p-5 shadow-lg space-y-4">
				<h2 class="text-base font-semibold text-white flex items-center gap-2">
					<span>⚙️</span> Cài Đặt Thử Nghiệm
				</h2>
				<div class="space-y-3">
					<div>
						<label for="winner-crit" class="block text-xs font-medium text-slate-400 mb-1">Tiêu chí chọn Winner</label>
						<select
							id="winner-crit"
							bind:value={winnerCriteria}
							class="w-full rounded-md border border-slate-600 bg-slate-900 px-3 py-2 text-sm text-white focus:border-sky-500 focus:outline-none"
						>
							<option value="engagement_rate">Engagement Rate (Tương tác / Views)</option>
							<option value="click_through">Click-Through Rate (CTR link/giỏ hàng)</option>
							<option value="views">Lượt xem (Views)</option>
						</select>
					</div>
					<div>
						<label for="duration-sel" class="block text-xs font-medium text-slate-400 mb-1">Thời gian giám sát</label>
						<select
							id="duration-sel"
							bind:value={testDuration}
							class="w-full rounded-md border border-slate-600 bg-slate-900 px-3 py-2 text-sm text-white focus:border-sky-500 focus:outline-none"
						>
							<option value="24h">24 giờ (Xem trước sơ bộ)</option>
							<option value="48h">48 giờ (Khuyến nghị chuẩn)</option>
							<option value="72h">72 giờ (Chu kỳ đầy đủ)</option>
						</select>
					</div>
					<div class="pt-2">
						<label class="flex items-center gap-2 text-xs font-medium text-slate-300 cursor-pointer">
							<input type="checkbox" bind:checked={autoWinner} class="h-4 w-4 rounded border-slate-600 text-sky-600" />
							<span>Tự động chọn winner nếu đạt ngưỡng chứng minh</span>
						</label>
					</div>
				</div>
			</div>

			<!-- M11 Simulation Toolbar for Quality Gates -->
			<div class="rounded-xl border border-sky-800/60 bg-sky-950/20 p-5 shadow-lg space-y-3">
				<h3 class="text-xs font-semibold text-sky-300 uppercase tracking-wider">
					M11 Gate Verification Controls (P5-05)
				</h3>
				<div class="space-y-2 text-xs">
					<div>
						<label for="caller-role" class="block text-slate-400 mb-0.5">Caller Role (Gate 1 Permission)</label>
						<select id="caller-role" bind:value={callerRole} class="w-full rounded border border-slate-700 bg-slate-900 px-2 py-1 text-white">
							<option value="Editor">Editor (Authorized)</option>
							<option value="Manager">Manager (Authorized)</option>
							<option value="Contributor">Contributor (Denied - Gate 1)</option>
						</select>
					</div>
					<div>
						<label for="cap-state" class="block text-slate-400 mb-0.5">Target Platform Connector (Gate 2)</label>
						<select id="cap-state" bind:value={platformCapability} class="w-full rounded border border-slate-700 bg-slate-900 px-2 py-1 text-white">
							<option value="active">Active (Supported)</option>
							<option value="degraded">Degraded (Denied - Gate 2)</option>
							<option value="revoked">Revoked (Denied - Gate 2)</option>
						</select>
					</div>
					<div class="flex items-center justify-between pt-1">
						<span class="text-slate-400">Packaging QA Hard Block (Gate 3)</span>
						<input type="checkbox" bind:checked={packagingBlocked} class="h-4 w-4 rounded border-slate-600 text-rose-600" />
					</div>
					<div class="flex items-center justify-between">
						<span class="text-slate-400">Duplicate Post &lt;24h (Gate 4)</span>
						<input type="checkbox" bind:checked={priorDuplicatePost} class="h-4 w-4 rounded border-slate-600 text-rose-600" />
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Active Experiments List -->
	<div class="space-y-6">
		<h2 class="text-xl font-bold text-white flex items-center justify-between">
			<span>🧪 Thử Nghiệm Đang Chạy ({activeExperiments.length})</span>
			<span class="text-xs font-normal text-slate-400">Dữ liệu cập nhật theo chu kỳ 5 phút</span>
		</h2>

		<div class="space-y-4">
			{#each activeExperiments as exp (exp.experimentId)}
				<div class="rounded-xl border border-slate-700 bg-slate-800/90 p-5 shadow-lg space-y-4">
					<div class="flex items-start justify-between">
						<div>
							<div class="flex items-center gap-3">
								<h3 class="text-base font-semibold text-white">{exp.title}</h3>
								<span
									class="rounded px-2.5 py-0.5 text-xs font-medium uppercase tracking-wider {exp.resultStatus ===
									'conclusive'
										? 'bg-emerald-900/60 text-emerald-300 border border-emerald-600'
										: exp.resultStatus === 'scaled'
											? 'bg-purple-900/60 text-purple-300 border border-purple-600'
											: exp.resultStatus === 'inconclusive'
												? 'bg-rose-900/60 text-rose-300 border border-rose-600'
												: 'bg-sky-900/60 text-sky-300 border border-sky-600'}"
								>
									{exp.resultStatus}
								</span>
								{#if exp.isObservational}
									<span class="rounded bg-amber-900/40 px-2 py-0.5 text-xs text-amber-300 border border-amber-600">
										💡 Observational
									</span>
								{/if}
							</div>
							<p class="text-xs text-slate-400 mt-1">Giả thuyết: {exp.hypothesis}</p>
						</div>

						<div class="flex items-center gap-2">
							<button
								type="button"
								onclick={() => handleEvaluate(exp)}
								class="rounded-md bg-sky-600 px-3 py-1.5 text-xs font-semibold text-white hover:bg-sky-500 shadow"
							>
								Đánh giá (Evaluate)
							</button>
							{#if exp.resultStatus === 'conclusive'}
								<button
									type="button"
									onclick={() => handleScale(exp)}
									class="rounded-md bg-emerald-600 px-3 py-1.5 text-xs font-semibold text-white hover:bg-emerald-500 shadow"
								>
									🚀 Scale Winner (M11)
								</button>
							{/if}
						</div>
					</div>

					{#if exp.inconclusiveReason}
						<div class="rounded-md border border-rose-500/40 bg-rose-950/30 p-3 text-xs text-rose-300">
							⚠️ {exp.inconclusiveReason}
						</div>
					{/if}

					<!-- Variants Table -->
					<div class="overflow-x-auto rounded-lg border border-slate-700 bg-slate-900/60">
						<table class="w-full text-left text-xs">
							<thead class="border-b border-slate-700 bg-slate-800/80 text-slate-300">
								<tr>
									<th class="p-3">Biến thể</th>
									<th class="p-3">Loại</th>
									<th class="p-3 text-right">Lượt xem (Views)</th>
									<th class="p-3 text-right">Clicks</th>
									<th class="p-3 text-right">CTR</th>
									<th class="p-3 text-right">Engagement Rate</th>
									<th class="p-3 text-center">Trạng thái</th>
								</tr>
							</thead>
							<tbody class="divide-y divide-slate-800">
								{#each exp.variants as variant}
									<tr class="{exp.winnerAssetId === variant.assetId ? 'bg-emerald-950/20' : ''} hover:bg-slate-800/40">
										<td class="p-3 font-medium text-white flex items-center gap-2">
											{#if exp.winnerAssetId === variant.assetId}
												<span class="text-amber-400">🏆</span>
											{/if}
											{variant.variantLabel}
										</td>
										<td class="p-3 text-slate-400 uppercase">{variant.variantType}</td>
										<td class="p-3 text-right text-slate-200 font-mono">
											{variant.views.toLocaleString()}
											{#if variant.views < 1000}
												<span class="text-rose-400 ml-1 text-[10px]" title="Dưới ngưỡng 1.000 views">(&lt;1K)</span>
											{/if}
										</td>
										<td class="p-3 text-right text-slate-200 font-mono">{variant.clicks.toLocaleString()}</td>
										<td class="p-3 text-right text-slate-200 font-mono">{(variant.ctr * 100).toFixed(1)}%</td>
										<td class="p-3 text-right text-slate-200 font-mono">{variant.engagementRate.toFixed(1)}%</td>
										<td class="p-3 text-center">
											{#if exp.winnerAssetId === variant.assetId}
												<span class="rounded bg-emerald-900/80 px-2 py-0.5 font-bold text-emerald-300 border border-emerald-500">
													WINNER (Observational)
												</span>
											{:else if exp.resultStatus === 'inconclusive'}
												<span class="text-slate-500">Inconclusive</span>
											{:else}
												<span class="text-slate-400">Running</span>
											{/if}
										</td>
									</tr>
								{/each}
							</tbody>
						</table>
					</div>
				</div>
			{/each}
		</div>
	</div>
</div>
