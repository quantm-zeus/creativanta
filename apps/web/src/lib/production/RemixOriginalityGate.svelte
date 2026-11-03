<script lang="ts">
	import type { OriginalityCheckResult } from './types';
	import { CANONICAL_SIMILARITY_THRESHOLD } from './index';

	export let result: OriginalityCheckResult;
	export let onAdjustFidelity: (() => void) | undefined = undefined;
	export let onEditScript: (() => void) | undefined = undefined;
</script>

<div
	class="originality-gate rounded-xl border p-4 transition-all {result.passed
		? 'border-emerald-500/40 bg-emerald-950/20'
		: 'border-rose-500/50 bg-rose-950/25'}"
	data-testid="remix-originality-gate"
>
	<div class="flex items-center justify-between gap-4">
		<div class="flex items-center gap-3">
			<span class="text-2xl" role="img" aria-label="Status icon">
				{result.passed ? '🛡️' : '⚠️'}
			</span>
			<div>
				<div class="flex items-center gap-2">
					<h4 class="font-semibold {result.passed ? 'text-emerald-400' : 'text-rose-400'}">
						{result.passed ? 'Originality Safeguard Passed' : 'Originality Safeguard Blocked'}
					</h4>
					<span
						class="rounded-full px-2 py-0.5 text-xs font-mono font-medium {result.passed
							? 'bg-emerald-500/20 text-emerald-300'
							: 'bg-rose-500/20 text-rose-300'}"
					>
						Threshold: &lt; {CANONICAL_SIMILARITY_THRESHOLD}%
					</span>
				</div>
				<p class="text-sm text-neutral-300 mt-0.5">{result.explanation}</p>
			</div>
		</div>

		<div class="text-right shrink-0">
			<div class="text-2xl font-bold font-mono {result.passed ? 'text-emerald-400' : 'text-rose-400'}">
				{result.similarityPercentage.toFixed(1)}%
			</div>
			<div class="text-xs text-neutral-400">Script Similarity</div>
		</div>
	</div>

	<!-- Progress / Similarity Meter -->
	<div class="mt-3">
		<div class="flex justify-between text-xs text-neutral-400 mb-1">
			<span>Originality Score: {result.originalityScore.toFixed(1)}%</span>
			<span>Canonical Limit: {CANONICAL_SIMILARITY_THRESHOLD}%</span>
		</div>
		<div class="h-2 w-full overflow-hidden rounded-full bg-neutral-800">
			<div
				class="h-full transition-all duration-500 {result.passed ? 'bg-emerald-500' : 'bg-rose-500'}"
				style="width: {Math.min(100, Math.max(5, result.similarityPercentage))}%"
			></div>
		</div>
	</div>

	{#if !result.passed}
		<div class="mt-4 rounded-lg border border-rose-500/30 bg-rose-900/30 p-3 text-xs text-rose-200">
			<div class="font-semibold flex items-center gap-1.5 text-rose-300">
				<span>⛔</span> Generation blocked to prevent copyright/plagiarism violation (RULE-M07-003, SAFE-2026-02).
			</div>
			<p class="mt-1 text-neutral-300">
				Credits were <strong>not deducted</strong> for this output. You can revise your remix using one of these options:
			</p>

			{#if result.actionableAlternatives && result.actionableAlternatives.length > 0}
				<div class="mt-2.5 flex flex-wrap gap-2">
					{#if onAdjustFidelity}
						<button
							type="button"
							on:click={onAdjustFidelity}
							class="rounded bg-rose-500/20 px-2.5 py-1 text-xs font-medium text-rose-200 hover:bg-rose-500/30 transition-colors"
						>
							🔄 Switch to 'Loose Inspiration' Fidelity
						</button>
					{/if}
					{#if onEditScript}
						<button
							type="button"
							on:click={onEditScript}
							class="rounded bg-neutral-800 border border-neutral-700 px-2.5 py-1 text-xs font-medium text-neutral-200 hover:bg-neutral-700 transition-colors"
						>
							✏️ Edit Script Manually
						</button>
					{/if}
				</div>
			{/if}
		</div>
	{/if}
</div>
