<script lang="ts">
	import type { PackagingReport, PackagingScoreComponent } from './types';
	import { applyWorkspaceOverride, OverridePolicyError } from './derivative_packaging';

	export let report: PackagingReport;
	export let userRole: string = 'Editor';
	export let userId: string = 'usr-current';
	export let onReportUpdated: (updated: PackagingReport) => void = () => {};

	let overrideModalOpen = false;
	let selectedComponent: PackagingScoreComponent | null = null;
	let overrideReason = '';
	let errorMessage = '';

	function getScoreColor(score: number): string {
		if (score >= 80) return 'text-emerald-400';
		if (score >= 60) return 'text-amber-400';
		return 'text-rose-400';
	}

	function getStatusBadge(status: string, isHardBlocked: boolean): { label: string; class: string } {
		if (isHardBlocked) {
			return { label: 'Chặn cứng (Hard Block)', class: 'bg-rose-900/60 text-rose-300 border-rose-700' };
		}
		if (status === 'pass') {
			return { label: 'Đạt (Pass)', class: 'bg-emerald-900/60 text-emerald-300 border-emerald-700' };
		}
		if (status === 'warning') {
			return { label: 'Cần xem xét (Warning)', class: 'bg-amber-900/60 text-amber-300 border-amber-700' };
		}
		return { label: 'Bị chặn (Blocked)', class: 'bg-rose-900/60 text-rose-300 border-rose-700' };
	}

	function openOverrideDialog(comp: PackagingScoreComponent) {
		selectedComponent = comp;
		overrideReason = '';
		errorMessage = '';
		overrideModalOpen = true;
	}

	function handleConfirmOverride() {
		if (!selectedComponent) return;
		try {
			const updated = applyWorkspaceOverride(
				report,
				selectedComponent.componentName,
				overrideReason,
				userRole,
				userId
			);
			report = updated;
			onReportUpdated(updated);
			overrideModalOpen = false;
		} catch (err: unknown) {
			if (err instanceof OverridePolicyError) {
				errorMessage = err.message;
			} else {
				errorMessage = 'Failed to record override';
			}
		}
	}
</script>

<div class="bg-gray-900 border border-gray-800 rounded-xl p-6 text-white space-y-6">
	<!-- Header & Overall Score -->
	<div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-gray-800 pb-5">
		<div>
			<div class="flex items-center gap-3">
				<h2 class="text-xl font-bold">Điểm chất lượng đóng gói (Packaging Score)</h2>
				{#if report.hasHardBlocks}
					<span class="px-2.5 py-0.5 rounded text-xs font-semibold bg-rose-900/60 text-rose-300 border border-rose-700">
						Chặn xuất bản (Hard Blocked)
					</span>
				{:else if report.readyToPublish}
					<span class="px-2.5 py-0.5 rounded text-xs font-semibold bg-emerald-900/60 text-emerald-300 border border-emerald-700">
						Sẵn sàng xuất bản (Ready)
					</span>
				{:else}
					<span class="px-2.5 py-0.5 rounded text-xs font-semibold bg-amber-900/60 text-amber-300 border border-amber-700">
						Dưới mức khuyến nghị
					</span>
				{/if}
			</div>
			<p class="text-xs text-gray-400 mt-1">
				Đánh giá 6 trọng số (Hook, Title, Caption, CTA, Disclosure, Links) trước khi phát hành.
			</p>
		</div>

		<!-- Big Score Display -->
		<div class="flex items-center gap-3 bg-gray-800/60 px-5 py-3 rounded-lg border border-gray-700">
			<div class="text-right">
				<div class="text-xs text-gray-400 font-medium">Tổng điểm</div>
				<div class="text-2xl font-black {getScoreColor(report.overallPackagingScore)}">
					{report.overallPackagingScore}<span class="text-sm text-gray-400">/100</span>
				</div>
			</div>
		</div>
	</div>

	<!-- Hard Block Alert Banner (SAFE-2026-02) -->
	{#if report.hasHardBlocks}
		<div class="bg-rose-950/40 border border-rose-700/60 rounded-lg p-4 space-y-2">
			<div class="flex items-center gap-2 text-rose-300 font-bold text-sm">
				<span>⛔</span>
				<span>Khóa an toàn bản quyền & quy định (Hard Block Invariant)</span>
			</div>
			<p class="text-xs text-rose-200/90 leading-relaxed">
				Nội dung thương mại thiếu nhãn hợp tác (#ad/#sponsored) hoặc vi phạm bản quyền âm nhạc/hình ảnh không thể xuất bản.
				<strong>Lưu ý: Không thể ghi đè (override) lỗi chặn cứng này ở cấp độ Workspace theo quy định SAFE-2026-02.</strong>
			</p>
			{#if report.hardBlockReasons.length > 0}
				<ul class="list-disc list-inside text-xs text-rose-300 space-y-1 pt-1">
					{#each report.hardBlockReasons as reason}
						<li>{reason}</li>
					{/each}
				</ul>
			{/if}
		</div>
	{/if}

	<!-- 6 Component Cards Breakdown -->
	<div class="space-y-3">
		<h3 class="text-sm font-semibold text-gray-300">Phân tích từng thành phần</h3>
		<div class="grid grid-cols-1 md:grid-cols-2 gap-3">
			{#each report.components as comp}
				{@const badge = getStatusBadge(comp.status, comp.isHardBlocked)}
				<div class="bg-gray-800/40 border border-gray-700/70 rounded-lg p-4 space-y-2">
					<div class="flex items-center justify-between">
						<div class="flex items-center gap-2">
							<span class="capitalize font-semibold text-sm">{comp.componentName}</span>
							<span class="text-xs text-gray-400">({comp.weight * 100}%)</span>
						</div>
						<div class="flex items-center gap-2">
							<span class="font-bold text-sm {getScoreColor(comp.score)}">{comp.score}đ</span>
							<span class="px-2 py-0.5 text-xs rounded border {badge.class}">
								{badge.label}
							</span>
						</div>
					</div>

					<!-- Findings & Fix Suggestions -->
					<div class="text-xs text-gray-300">
						<span class="text-gray-400">Kết quả:</span> {comp.findings}
					</div>
					{#if comp.suggestedFix}
						<div class="text-xs text-blue-300/90 bg-blue-950/30 p-2 rounded border border-blue-800/40">
							<span class="font-semibold">💡 Gợi ý khắc phục:</span> {comp.suggestedFix}
						</div>
					{/if}

					<!-- Action / Override Button -->
					<div class="pt-1 flex items-center justify-between text-xs">
						{#if comp.isHardBlocked}
							<span class="text-rose-400 italic">Không thể ghi đè (Chặn cứng)</span>
						{:else if comp.status === 'warning'}
							<button
								on:click={() => openOverrideDialog(comp)}
								class="px-2.5 py-1 bg-amber-600/30 hover:bg-amber-600/50 text-amber-200 border border-amber-500/50 rounded transition-colors"
							>
								Ghi đè ngoại lệ (Manager Override)...
							</button>
						{:else}
							<span class="text-emerald-400">✓ Đã đạt tiêu chuẩn</span>
						{/if}
					</div>
				</div>
			{/each}
		</div>
	</div>

	<!-- Readiness Checks -->
	<div class="border-t border-gray-800 pt-4 space-y-2">
		<h3 class="text-sm font-semibold text-gray-300">Kiểm tra thông số nền tảng (Readiness Checks)</h3>
		<div class="grid grid-cols-1 sm:grid-cols-2 gap-2 text-xs">
			{#each report.readinessChecks as r}
				<div class="flex items-center justify-between bg-gray-800/30 p-2.5 rounded border border-gray-800">
					<div>
						<div class="font-medium text-gray-200 capitalize">{r.checkType} ({r.platform})</div>
						<div class="text-gray-400">Giá trị: {r.currentValue} (Yêu cầu: {r.requiredValue})</div>
					</div>
					<span class="px-2 py-0.5 rounded {r.status === 'pass' ? 'bg-emerald-900/40 text-emerald-300' : 'bg-amber-900/40 text-amber-300'}">
						{r.status === 'pass' ? 'Đạt' : 'Cảnh báo'}
					</span>
				</div>
			{/each}
		</div>
	</div>

	<!-- Applied Overrides Audit Trail -->
	{#if report.appliedOverrides.length > 0}
		<div class="border-t border-gray-800 pt-4 space-y-2">
			<h3 class="text-sm font-semibold text-amber-300">Lịch sử ghi đè ngoại lệ (Applied Overrides)</h3>
			<div class="space-y-1.5">
				{#each report.appliedOverrides as ovr}
					<div class="bg-amber-950/20 border border-amber-800/40 p-2.5 rounded text-xs text-amber-200/90 flex justify-between items-center">
						<div>
							<span class="font-semibold text-white">[{ovr.actorRole}]</span> {ovr.reason}
						</div>
						<div class="text-amber-400 text-[10px] font-mono">
							{new Date(ovr.createdAt).toLocaleDateString()}
						</div>
					</div>
				{/each}
			</div>
		</div>
	{/if}
</div>

<!-- Manager Override Modal -->
{#if overrideModalOpen && selectedComponent}
	<div class="fixed inset-0 z-50 flex items-center justify-center bg-black/70 backdrop-blur-sm p-4">
		<div class="bg-gray-900 border border-gray-700 rounded-xl shadow-2xl max-w-lg w-full p-6 text-white space-y-4">
			<div class="flex items-center justify-between border-b border-gray-800 pb-3">
				<h3 class="font-bold text-base">Ghi đè cảnh báo (Manager Override)</h3>
				<button on:click={() => (overrideModalOpen = false)} class="text-gray-400 hover:text-white">✕</button>
			</div>

			<div class="text-sm text-gray-300 space-y-2">
				<p>
					Bạn đang ghi đè tiêu chí: <strong class="text-white capitalize">{selectedComponent.componentName}</strong>
				</p>
				<p class="text-xs text-gray-400">
					Vai trò hiện tại của bạn: <strong class="text-blue-400">{userRole}</strong> (Yêu cầu vai trò Manager trở lên).
				</p>
			</div>

			{#if errorMessage}
				<div class="bg-rose-950/60 border border-rose-800 text-rose-200 p-2.5 rounded text-xs">
					{errorMessage}
				</div>
			{/if}

			<div class="space-y-1.5">
				<label for="overrideReason" class="text-xs font-semibold text-gray-300">
					Lý do nghiệp vụ (Tối thiểu 10 ký tự):
				</label>
				<textarea
					id="overrideReason"
					bind:value={overrideReason}
					rows="3"
					placeholder="Nhập lý do chi tiết xác nhận cho phép xuất bản..."
					class="w-full bg-gray-800 border border-gray-700 rounded p-2.5 text-xs text-white placeholder-gray-500 focus:outline-none focus:border-blue-500"
				></textarea>
			</div>

			<div class="flex items-center justify-end gap-2 pt-2 border-t border-gray-800">
				<button
					on:click={() => (overrideModalOpen = false)}
					class="px-4 py-2 bg-gray-800 hover:bg-gray-700 text-gray-300 rounded text-xs font-medium"
				>
					Hủy bỏ
				</button>
				<button
					on:click={handleConfirmOverride}
					disabled={overrideReason.trim().length < 10}
					class="px-4 py-2 bg-amber-600 hover:bg-amber-500 disabled:bg-gray-700 disabled:text-gray-500 text-white rounded text-xs font-semibold transition-colors"
				>
					Xác nhận ghi đè
				</button>
			</div>
		</div>
	</div>
{/if}
