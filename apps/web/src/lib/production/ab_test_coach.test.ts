import { describe, it, expect } from 'vitest';
import {
	STANDARD_OBSERVATIONAL_NOTICE,
	type ABExperiment,
	type ABVariant,
	evaluateExperiment,
	validateM11ScalingGates,
	scaleExperimentWinner,
	ScalingGateError
} from './ab_test_coach';

describe('P5-05: Experiment Lab & Performance Coach (Web Client & Engine)', () => {
	const sampleConclusiveExp: ABExperiment = {
		experimentId: 'exp-conclusive-01',
		workspaceId: 'ws-test',
		sourceAssetId: 'asset-base-01',
		title: 'Conclusive Hook Test',
		hypothesis: 'Question hook retains more viewers',
		variantAssetIds: ['var-win-a', 'var-lose-b'],
		variantCount: 2,
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
				variantId: 'v-1',
				assetId: 'var-win-a',
				variantType: 'hook',
				variantLabel: 'Variant A',
				impressions: 2500,
				views: 2500,
				clicks: 250,
				ctr: 0.10,
				conversions: 20,
				engagementRate: 8.5
			},
			{
				variantId: 'v-2',
				assetId: 'var-lose-b',
				variantType: 'hook',
				variantLabel: 'Variant B',
				impressions: 2200,
				views: 2200,
				clicks: 110,
				ctr: 0.05,
				conversions: 8,
				engagementRate: 5.0
			}
		]
	};

	describe('Acceptance Target 1: Low Exposure -> Inconclusive', () => {
		it('returns inconclusive when variants have low exposure (<1000 views per variant after 72h)', () => {
			const lowExposureExp: ABExperiment = {
				...sampleConclusiveExp,
				variants: [
					{
						variantId: 'v-1',
						assetId: 'var-a',
						variantType: 'thumbnail',
						variantLabel: 'Variant A',
						impressions: 20,
						views: 20,
						clicks: 2,
						ctr: 0.10,
						conversions: 0,
						engagementRate: 10.0
					},
					{
						variantId: 'v-2',
						assetId: 'var-b',
						variantType: 'thumbnail',
						variantLabel: 'Variant B',
						impressions: 20,
						views: 20,
						clicks: 1,
						ctr: 0.05,
						conversions: 0,
						engagementRate: 5.0
					},
					{
						variantId: 'v-3',
						assetId: 'var-c',
						variantType: 'thumbnail',
						variantLabel: 'Variant C',
						impressions: 20,
						views: 20,
						clicks: 1,
						ctr: 0.05,
						conversions: 0,
						engagementRate: 5.0
					}
				]
			};

			const result = evaluateExperiment(lowExposureExp, 1000, 1.2);
			expect(result.resultStatus).toBe('inconclusive');
			expect(result.winnerAssetId).toBeUndefined();
			expect(result.isObservational).toBe(true);
			expect(result.inconclusiveReason).toContain('insufficient exposure (<1000 impressions');
		});

		it('safely handles zero exposure / missing denominator without division by zero', () => {
			const zeroExp: ABExperiment = {
				...sampleConclusiveExp,
				targetMetric: 'click_through',
				variants: [
					{
						variantId: 'v-1',
						assetId: 'var-a',
						variantType: 'cta',
						variantLabel: 'Variant A',
						impressions: 0,
						views: 0,
						clicks: 0,
						ctr: 0,
						conversions: 0,
						engagementRate: 0
					},
					{
						variantId: 'v-2',
						assetId: 'var-b',
						variantType: 'cta',
						variantLabel: 'Variant B',
						impressions: 0,
						views: 0,
						clicks: 0,
						ctr: 0,
						conversions: 0,
						engagementRate: 0
					}
				]
			};

			const result = evaluateExperiment(zeroExp, 1000, 1.5);
			expect(result.resultStatus).toBe('inconclusive');
			expect(result.winnerAssetId).toBeUndefined();
			expect(result.isObservational).toBe(true);
		});

		it('evaluates to inconclusive if exposure is adequate but lift multiplier is below threshold', () => {
			const tieExp: ABExperiment = {
				...sampleConclusiveExp,
				variants: [
					{
						variantId: 'v-1',
						assetId: 'var-a',
						variantType: 'music',
						variantLabel: 'Variant A',
						impressions: 1500,
						views: 1500,
						clicks: 100,
						ctr: 0.066,
						conversions: 5,
						engagementRate: 6.2
					},
					{
						variantId: 'v-2',
						assetId: 'var-b',
						variantType: 'music',
						variantLabel: 'Variant B',
						impressions: 1500,
						views: 1500,
						clicks: 95,
						ctr: 0.063,
						conversions: 4,
						engagementRate: 6.0
					}
				]
			};

			const result = evaluateExperiment(tieExp, 1000, 1.2);
			expect(result.resultStatus).toBe('inconclusive');
			expect(result.winnerAssetId).toBeUndefined();
			expect(result.inconclusiveReason).toContain('statistical lift below threshold');
		});
	});

	describe('Acceptance Target 2: Observational Label Retained', () => {
		it('retains observational label even when test is statistically conclusive with a declared winner', () => {
			const result = evaluateExperiment(sampleConclusiveExp, 1000, 1.2);
			expect(result.resultStatus).toBe('conclusive');
			expect(result.winnerAssetId).toBe('var-win-a');
			// Observational label retained (API behavior §7)
			expect(result.isObservational).toBe(true);
			expect(result.summary).toContain('observational recommendation');
		});

		it('validates STANDARD_OBSERVATIONAL_NOTICE format', () => {
			expect(STANDARD_OBSERVATIONAL_NOTICE).toContain('Observational recommendation');
			expect(STANDARD_OBSERVATIONAL_NOTICE).toContain('not causal proof');
		});
	});

	describe('Acceptance Target 3: Scaling Rechecks M11 Gates', () => {
		const baseGateParams = {
			callerRole: 'Editor',
			platformCapabilityState: 'active' as const,
			hasPackagingHardBlocks: false,
			packagingComplianceResult: 'pass' as const,
			priorPostWithinCooldown: false
		};

		it('Gate 1 failure: rejects scaling if caller lacks publish permission (Contributor role)', () => {
			expect(() => {
				validateM11ScalingGates({
					...baseGateParams,
					callerRole: 'Contributor',
					targetPlatform: 'tiktok'
				});
			}).toThrowError(ScalingGateError);

			try {
				validateM11ScalingGates({
					...baseGateParams,
					callerRole: 'Contributor',
					targetPlatform: 'tiktok'
				});
			} catch (err: any) {
				expect(err.gate).toBe('permission');
				expect(err.message).toContain('caller lacks publish:execute');
			}
		});

		it('Gate 2 failure: rejects scaling if target platform capability is degraded or revoked', () => {
			expect(() => {
				validateM11ScalingGates({
					...baseGateParams,
					platformCapabilityState: 'degraded',
					targetPlatform: 'instagram'
				});
			}).toThrowError(ScalingGateError);

			try {
				validateM11ScalingGates({
					...baseGateParams,
					platformCapabilityState: 'degraded',
					targetPlatform: 'instagram'
				});
			} catch (err: any) {
				expect(err.gate).toBe('capability');
				expect(err.message).toContain('connector is degraded');
			}
		});

		it('Gate 3 failure: rejects scaling if packaging QA compliance is blocked', () => {
			expect(() => {
				validateM11ScalingGates({
					...baseGateParams,
					hasPackagingHardBlocks: true,
					packagingComplianceResult: 'blocked',
					targetPlatform: 'tiktok'
				});
			}).toThrowError(ScalingGateError);

			try {
				validateM11ScalingGates({
					...baseGateParams,
					hasPackagingHardBlocks: true,
					packagingComplianceResult: 'blocked',
					targetPlatform: 'tiktok'
				});
			} catch (err: any) {
				expect(err.gate).toBe('policy');
				expect(err.message).toContain('compliance scan blocked');
			}
		});

		it('Gate 4 failure: rejects scaling if duplicate post was already published within 24h cooldown', () => {
			expect(() => {
				validateM11ScalingGates({
					...baseGateParams,
					priorPostWithinCooldown: true,
					targetPlatform: 'tiktok'
				});
			}).toThrowError(ScalingGateError);

			try {
				validateM11ScalingGates({
					...baseGateParams,
					priorPostWithinCooldown: true,
					targetPlatform: 'tiktok'
				});
			} catch (err: any) {
				expect(err.gate).toBe('duplicate_post');
				expect(err.message).toContain('within cooldown window');
			}
		});

		it('All 4 Gates Pass: executes scaling and marks status scaled while retaining observational label', () => {
			const conclusiveExp: ABExperiment = {
				...sampleConclusiveExp,
				status: 'completed',
				resultStatus: 'conclusive',
				winnerAssetId: 'var-win-a'
			};

			const scaledResult = scaleExperimentWinner(conclusiveExp, ['tiktok', 'youtube'], baseGateParams);
			expect(scaledResult.resultStatus).toBe('scaled');
			expect(scaledResult.winnerAssetId).toBe('var-win-a');
			expect(scaledResult.scheduledItemIds).toHaveLength(2);
			expect(scaledResult.observationalLabelRetained).toBe(true);
			expect(scaledResult.message).toContain('across verified M11 gates');
		});
	});
});
