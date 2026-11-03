export interface ProductionMode {
	id: string;
	title: string;
	description: string;
	icon: string;
	creditCost: number;
	durationSecs: number;
	route: string;
	badge?: string;
}

export interface BatchItemInput {
	index: number;
	itemId: string;
	itemName: string;
	prompt: string;
	referenceUrl?: string;
	imageUrls?: string[];
}

export interface BatchRowValidation {
	index: number;
	itemId: string;
	itemName: string;
	isValid: boolean;
	validationError?: string;
	estimatedCredits: string;
	estimatedCostUSD: string;
}

export interface BatchBudgetPreview {
	quoteId: string;
	quoteExpiresAt: string;
	totalItems: number;
	validItemsCount: number;
	invalidItemsCount: number;
	totalEstimatedCredits: string;
	totalCostCeilingUSD: string;
	currentAvailableCredits: string;
	sufficientCredits: boolean;
	items: BatchRowValidation[];
}

export interface GenerationJobItem {
	jobId: string;
	workspaceId: string;
	assetId: string;
	mode: string;
	title: string;
	prompt: string;
	provider: 'veo' | 'kling' | 'mock';
	status: 'queued' | 'processing' | 'completed' | 'failed' | 'cancelled';
	stage: string;
	progressPct: number;
	estimatedCredits: string;
	actualCredits?: string;
	estimatedCostUSD: string;
	actualCostUSD?: string;
	resultUrl?: string;
	errorMessage?: string;
	createdAt: string;
	updatedAt: string;
}

export interface AssetLineage {
	assetId: string;
	title: string;
	assetType: string;
	generationState: string;
	qualityState: string;
	sourceProvider: string;
	sourceModel: string;
	durationSeconds: number;
	resolution: string;
	storageUrl: string;
	upstreamScriptId?: string;
	upstreamCharacterId?: string;
	costUSD: string;
	continuityScore?: number;
}

export type FidelityLevel = 'match_1to1' | 'adapt' | 'loose';

export interface CreativeDNA {
	sceneCount: number;
	hookType: string;
	contentStructureJson: string;
	pacingProfileJson: string;
	visualStyleJson: string;
	audioProfileJson: string;
	transitionMapJson: string;
	totalDurationSeconds: number;
	engagementStructureJson: string;
}

export interface OriginalityCheckResult {
	similarityPercentage: number;
	canonicalThresholdPercentage: number; // 30.0%
	originalityScore: number;
	passed: boolean;
	explanation: string;
	actionableAlternatives: string[];
}

export interface RemixBlueprint {
	blueprintId: string;
	workspaceId: string;
	referenceAssetId: string;
	referenceUrl?: string;
	referenceTranscript?: string;
	outputAssetId?: string;
	creativeDna: CreativeDNA;
	remixScript: string;
	fidelityLevel: FidelityLevel;
	originalityScore: number;
	similarityPercentage: number;
	status: 'analyzing' | 'analyzed' | 'generating' | 'generated' | 'failed' | 'rejected';
	rejectionReason?: string;
	errorMessage?: string;
	createdAt: string;
	updatedAt: string;
}

export interface CopyrightCheckResult {
	mediaId: string;
	mediaTitle: string;
	isCopyrighted: boolean;
	licenseVerified: boolean;
	passed: boolean;
	warningMessage?: string;
	canBypassRisk: boolean; // Must always be false for hard copyright hits (SAFE-2026-02)
}

export interface MultiMergeTimelineItem {
	itemId: string;
	assetId: string;
	orderIndex: number;
	mediaType: 'video' | 'image' | 'audio';
	title: string;
	durationSeconds: number;
	transitionToNext?: string;
	transitionDurationSeconds?: number;
	thumbnailUrl?: string;
	licenseStatus?: 'licensed' | 'royalty_free' | 'copyrighted_unverified' | 'copyrighted_verified';
	licenseProofKey?: string;
	hasCopyrightHit?: boolean;
}

export interface MultiMergeSettings {
	targetDurationSec: number;
	autoTransitions: boolean;
	musicAssetId?: string;
	musicLicenseProof?: string;
	aspectRatio: '9:16' | '16:9' | '1:1';
	pacing: 'fast' | 'medium' | 'slow';
}
