/**
 * A/B Testing Engine & Performance Coach Client (M07 EF-09, EF-10, M10)
 * Canonical Sources:
 * - docs/02_features/production/ai_video_studio.md (EF-09, EF-10)
 * - docs/02_features/production/packaging_qa.md
 * - docs/04_contracts/api_behavior_contracts.md (§7: 1,000 min views, observational label retained)
 * - docs/03_screens/web/screen_web_studio_ab_testing.md (W027)
 * - docs/03_screens/mobile/screen_mobile_performance_coach.md (M039)
 */

export const STANDARD_OBSERVATIONAL_NOTICE = 'Observational recommendation - not causal proof or guaranteed revenue uplift.';

export interface ABVariant {
	variantId: string;
	assetId: string;
	publishItemId?: string;
	variantType: 'thumbnail' | 'title' | 'hook' | 'cta' | 'music' | 'full_video';
	variantLabel: string;
	impressions: number;
	views: number;
	clicks: number;
	ctr: number;
	conversions: number;
	engagementRate: number;
}

export interface AutoWinnerCriteria {
	metric: 'views' | 'engagement_rate' | 'click_through' | 'watch_time';
	thresholdMultiplier: number; // default 1.2 or 1.5
	minDurationHours: number; // default 48 or 72
	minImpressions: number; // default 1000
}

export interface ABExperiment {
	experimentId: string;
	workspaceId: string;
	sourceAssetId: string;
	title: string;
	hypothesis: string;
	variantAssetIds: string[];
	variantCount: number;
	targetMetric: string;
	minDurationHours: number;
	minImpressionsPerVariant: number;
	autoWinnerThresholdMultiplier: number;
	status: 'pending' | 'running' | 'completed' | 'cancelled';
	resultStatus: 'pending' | 'conclusive' | 'inconclusive' | 'scaled';
	winnerAssetId?: string;
	isObservational: boolean;
	inconclusiveReason?: string;
	variants: ABVariant[];
	criteria?: AutoWinnerCriteria;
	startedAt?: string;
	completedAt?: string;
	createdAt: string;
	updatedAt: string;
}

export interface PerformanceInsight {
	insightId: string;
	title: string;
	description: string;
	category: 'hook' | 'retention' | 'engagement' | 'format' | 'timing' | 'sound';
	impactLevel: 'high' | 'medium' | 'low';
	effortLevel: 'low' | 'medium' | 'high';
	suggestedAction: string;
	targetAssetId?: string;
	isObservational: boolean;
}

export interface VideoScorecard {
	assetId: string;
	title: string;
	packagingScore: number;
	hookScore: number;
	retentionRate3s: number;
	completionRate: number;
	engagementRate: number;
	views: number;
	likes: number;
	comments: number;
	shares: number;
	grade: string;
	strengths: string[];
	dropOffPoints: string[];
	improvementTips: string[];
	isObservational: boolean;
	observationalNotice: string;
}

export interface ImprovementItem {
	itemId: string;
	title: string;
	description: string;
	formatRecommendation: string;
	soundSuggestion: string;
	impact: 'High' | 'Medium' | 'Low';
	effort: 'Low' | 'Medium' | 'High';
	actionCta: string;
}

export interface ImprovementPlan {
	planId: string;
	workspaceId: string;
	period: string;
	currentScore: number;
	previousScore: number;
	scoreChange: number;
	bestPostTitle: string;
	bestPostEr: number;
	worstPostTitle: string;
	worstPostEr: number;
	actionItems: ImprovementItem[];
	isObservational: boolean;
	observationalNotice: string;
}

export interface IndustryBenchmark {
	benchmarkId: string;
	platform: string;
	niche: string;
	avgEngagementRate: number;
	avg3sRetention: number;
	avgCompletionRate: number;
	avgCtr: number;
	sampleSize: number;
	isObservational: boolean;
}

export interface IndustryComparison {
	platform: string;
	niche: string;
	workspaceEngagementRate: number;
	industryAvgEngagementRate: number;
	erDeltaPercent: number;
	workspace3sRetention: number;
	industryAvg3sRetention: number;
	retentionDeltaPercent: number;
	percentileRank: string;
	summary: string;
	isObservational: boolean;
	observationalNotice: string;
}

export interface M11ScalingGateCheckParams {
	callerRole: string; // Owner, Admin, Manager, Editor, Contributor, Member
	targetPlatform: string; // tiktok, instagram, youtube, shopee
	platformCapabilityState: 'active' | 'degraded' | 'unsupported' | 'revoked';
	hasPackagingHardBlocks: boolean;
	packagingComplianceResult: 'pass' | 'pass_with_warnings' | 'review_required' | 'blocked';
	priorPostWithinCooldown: boolean;
}

export interface ScaleWinnerResult {
	experimentId: string;
	winnerAssetId: string;
	scheduledItemIds: string[];
	targetPlatforms: string[];
	resultStatus: 'scaled';
	observationalLabelRetained: boolean;
	message: string;
}

export class ScalingGateError extends Error {
	gate: 'permission' | 'capability' | 'policy' | 'duplicate_post';
	constructor(gate: 'permission' | 'capability' | 'policy' | 'duplicate_post', message: string) {
		super(message);
		this.name = 'ScalingGateError';
		this.gate = gate;
	}
}

/**
 * Acceptance Target 1: Low Exposure -> Inconclusive
 * Acceptance Target 2: Observational Label Retained
 */
export function evaluateExperiment(
	experiment: ABExperiment,
	minImpressions: number = 1000,
	thresholdMultiplier: number = 1.2
): {
	status: 'completed';
	resultStatus: 'conclusive' | 'inconclusive';
	winnerAssetId?: string;
	isObservational: boolean;
	inconclusiveReason?: string;
	summary: string;
} {
	const variants = experiment.variants || [];

	// Acceptance Target 1: Low exposure check (<1000 views per variant or zero views)
	let hasZeroViews = false;
	let allMeetImpressions = variants.length >= 2;

	let topVariant: ABVariant | null = null;
	let secondVariant: ABVariant | null = null;

	for (const v of variants) {
		if (v.impressions <= 0 && v.views <= 0) {
			hasZeroViews = true;
		}
		if (v.impressions < minImpressions && v.views < minImpressions) {
			allMeetImpressions = false;
		}

		const metricValue =
			experiment.targetMetric === 'click_through' || experiment.targetMetric === 'ctr'
				? v.views > 0
					? v.clicks / v.views
					: v.ctr
				: experiment.targetMetric === 'views'
					? v.views
					: v.engagementRate;

		if (!topVariant) {
			topVariant = v;
		} else {
			const topVal =
				experiment.targetMetric === 'click_through' || experiment.targetMetric === 'ctr'
					? topVariant.views > 0
						? topVariant.clicks / topVariant.views
						: topVariant.ctr
					: experiment.targetMetric === 'views'
						? topVariant.views
						: topVariant.engagementRate;

			if (metricValue > topVal) {
				secondVariant = topVariant;
				topVariant = v;
			} else if (!secondVariant) {
				secondVariant = v;
			} else {
				const secondVal =
					experiment.targetMetric === 'click_through' || experiment.targetMetric === 'ctr'
						? secondVariant.views > 0
							? secondVariant.clicks / secondVariant.views
							: secondVariant.ctr
						: experiment.targetMetric === 'views'
							? secondVariant.views
							: secondVariant.engagementRate;

				if (metricValue > secondVal) {
					secondVariant = v;
				}
			}
		}
	}

	// Insufficient exposure -> inconclusive
	if (hasZeroViews || !allMeetImpressions) {
		return {
			status: 'completed',
			resultStatus: 'inconclusive',
			winnerAssetId: undefined,
			isObservational: true, // Acceptance Target 2: Observational label retained!
			inconclusiveReason: `insufficient exposure (<${minImpressions} impressions per variant); comparison retained as observational without automated scaling`,
			summary: `Inconclusive: insufficient exposure (<${minImpressions} impressions per variant). Observational label retained.`
		};
	}

	// Adequate exposure: check statistical lift threshold
	const topVal =
		experiment.targetMetric === 'click_through' || experiment.targetMetric === 'ctr'
			? topVariant && topVariant.views > 0
				? topVariant.clicks / topVariant.views
				: topVariant?.ctr || 0
			: experiment.targetMetric === 'views'
				? topVariant?.views || 0
				: topVariant?.engagementRate || 0;

	const secondVal =
		experiment.targetMetric === 'click_through' || experiment.targetMetric === 'ctr'
			? secondVariant && secondVariant.views > 0
				? secondVariant.clicks / secondVariant.views
				: secondVariant?.ctr || 0
			: experiment.targetMetric === 'views'
				? secondVariant?.views || 0
				: secondVariant?.engagementRate || 0;

	const isLiftSignificant =
		(secondVal === 0 && topVal > 0) || (secondVal > 0 && topVal / secondVal >= thresholdMultiplier);

	if (isLiftSignificant && topVariant) {
		const lift = secondVal > 0 ? (topVal / secondVal).toFixed(2) : 'max';
		return {
			status: 'completed',
			resultStatus: 'conclusive',
			winnerAssetId: topVariant.assetId,
			isObservational: true, // Acceptance Target 2: Observational label retained!
			summary: `Conclusive: winning variant ${topVariant.variantLabel} achieved ${lift}x lift. Labeled observational recommendation.`
		};
	}

	return {
		status: 'completed',
		resultStatus: 'inconclusive',
		winnerAssetId: undefined,
		isObservational: true, // Acceptance Target 2: Observational label retained!
		inconclusiveReason: 'statistical lift below threshold; retain as observational without automated scaling',
		summary: 'Inconclusive: variant lift below threshold multiplier. Labeled observational recommendation.'
	};
}

/**
 * Acceptance Target 3: Scaling Rechecks M11 Gates
 * Evaluates Permission, Capability, Policy, and Duplicate-Post gates.
 */
export function validateM11ScalingGates(params: M11ScalingGateCheckParams): void {
	// Gate 1: Permission Gate (Editor+)
	const allowedRoles = ['Owner', 'Admin', 'Manager', 'Editor'];
	if (!allowedRoles.includes(params.callerRole)) {
		throw new ScalingGateError(
			'permission',
			'M11 gate failure: caller lacks publish:execute or publish:schedule permission'
		);
	}

	// Gate 2: Capability Gate (Connector Active)
	if (params.platformCapabilityState !== 'active') {
		throw new ScalingGateError(
			'capability',
			`M11 gate failure: target platform connector is ${params.platformCapabilityState}`
		);
	}

	// Gate 3: Policy Gate (No hard blocks)
	if (params.hasPackagingHardBlocks || params.packagingComplianceResult === 'blocked') {
		throw new ScalingGateError(
			'policy',
			'M11 gate failure: packaging QA compliance scan blocked or has unresolved hard blocks'
		);
	}

	// Gate 4: Duplicate-Post Gate
	if (params.priorPostWithinCooldown) {
		throw new ScalingGateError(
			'duplicate_post',
			`M11 gate failure: identical content already published to ${params.targetPlatform} within cooldown window`
		);
	}
}

/**
 * Executes scaling of an eligible winning variant across M11 gates.
 */
export function scaleExperimentWinner(
	experiment: ABExperiment,
	platforms: string[],
	gateParams: Omit<M11ScalingGateCheckParams, 'targetPlatform'>
): ScaleWinnerResult {
	if (experiment.resultStatus !== 'conclusive' || !experiment.winnerAssetId) {
		throw new Error(
			'experiment is not eligible for scaling: must be completed, conclusive, with a valid winner'
		);
	}

	const targetPlatforms = platforms.length > 0 ? platforms : ['tiktok', 'instagram'];

	// Validate gates for all target platforms
	for (const platform of targetPlatforms) {
		validateM11ScalingGates({
			...gateParams,
			targetPlatform: platform
		});
	}

	const scheduledItemIds = targetPlatforms.map((p) => `sch-${experiment.winnerAssetId}-${p}`);

	return {
		experimentId: experiment.experimentId,
		winnerAssetId: experiment.winnerAssetId,
		scheduledItemIds,
		targetPlatforms,
		resultStatus: 'scaled',
		observationalLabelRetained: true,
		message: `Winner ${experiment.winnerAssetId} successfully scaled to ${targetPlatforms.length} platforms across verified M11 gates.`
	};
}
