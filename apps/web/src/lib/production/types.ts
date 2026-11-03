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
	trendId?: string;
	costUSD: string;
	continuityScore?: number;
}

export interface SoundTrackItem {
	trackId: string;
	workspaceId: string;
	title: string;
	category: 'music' | 'sfx' | 'ambient';
	genre: string;
	mood: string;
	bpm: number;
	durationSeconds: number;
	fileUrl: string;
	licenseType: string;
	licenseId: string;
	isVerifiedLicense: boolean;
	waveformPeaks: number[];
	createdAt: string;
}

export interface TranslationJobItem {
	jobId: string;
	workspaceId: string;
	sourceAssetId: string;
	targetLanguages: string[];
	lipSyncEnabled: boolean;
	culturalAdaptationEnabled: boolean;
	translateCaptions: boolean;
	voiceOption: 'native' | 'cloned';
	voiceCloneId?: string;
	status: 'queued' | 'processing' | 'completed' | 'failed';
	qualityScores: Record<string, number>;
	repairNotes: Record<string, string>;
	outputAssetIds: Record<string, string>;
	totalCreditsUsed: string;
	quoteId: string;
	createdAt: string;
	updatedAt: string;
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
	trendId?: string;
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

export interface VoiceCloneOption {
	voiceCloneId: string;
	name: string;
	characterId: string;
	cloneStatus: 'ready' | 'pending' | 'revoked';
	consentRecordId: string;
	consentStatus: 'active' | 'revoked' | 'pending';
	qualityScore: number;
	repairApplied: boolean;
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

export interface StyleElements {
	colorPalette: string;
	cutPacing: string;
	textStyle: string;
	musicStyle: string;
	transitions: string;
	hookPattern: string;
	visualMood: string;
	avgCutDurationMs: number;
	colorPaletteHex: string[];
}

export interface StylePack {
	stylePackId: string;
	workspaceId: string;
	name: string;
	sourceAssetId: string;
	extractedStyle: StyleElements;
	isActive: boolean;
	continuityPackId?: string;
	createdAt: string;
	updatedAt: string;
}

export interface CharacterPreviewQuote {
	quoteId: string;
	creditsRequired: string;
	durationSeconds: number;
	provider: string;
	canAfford: boolean;
}

export interface DriftEvaluationResult {
	assetId: string;
	packId: string;
	packVersion: number;
	driftScore: number;
	driftSeverity: 'none' | 'low_drift' | 'moderate_drift' | 'high_drift';
	isBlocked: boolean;
	violationReasons: string[];
	violationId?: string;
}

export interface ContinuityViolation {
	violationId: string;
	workspaceId: string;
	assetId: string;
	packId: string;
	violationType: string;
	severity: 'warning' | 'blocking';
	description: string;
	driftScore: number;
	resolved: boolean;
	resolvedBy?: string;
	resolvedAt?: string;
	overrideReason?: string;
}

// M09: Derivative Library & Repurpose Hub
export interface DerivativeItem {
	assetId: string;
	parentAssetId: string;
	title: string;
	derivativeType: 'clip' | 'variant' | 'remix' | 'repurpose' | 'thumbnail' | string;
	targetChannel: 'tiktok' | 'youtube_shorts' | 'instagram_reels' | 'facebook' | string;
	aspectRatio: string;
	ctaVariant?: string;
	subtitleLanguage?: string;
	durationSeconds: number;
	resolution: string;
	fileUrl?: string;
	qualityState: string;
	generationState: string;
	tags: string[];
	views: number;
	engagementRate: number;
	ctr: number;
	createdAt: string;
	updatedAt: string;
}

export interface BatchItemError {
	assetId: string;
	errorCode: string;
	errorMessage: string;
}

export interface BatchTagResult {
	totalItems: number;
	succeededCount: number;
	failedCount: number;
	succeededAssetIds: string[];
	failures: BatchItemError[];
	summary: string;
}

export interface DerivativeLineageNode {
	assetId: string;
	parentAssetId: string;
	title: string;
	derivativeType: string;
	assetType: string;
	qualityState: string;
	depth: number;
	views: number;
	engagementRate: number;
	ctr: number;
	isSourceDeleted: boolean;
	children?: DerivativeLineageNode[];
}

export interface DerivativeStats {
	sourceAssetId: string;
	totalDerivatives: number;
	aggregateViews: number;
	averageEngagementRate: number;
	averageCtr: number;
	topPerformingDerivativeId: string;
	topDerivatives?: DerivativeItem[];
}

// M10: Packaging QA & Pre-publish Scorecard
export interface PackagingScoreComponent {
	componentName: 'hook' | 'title' | 'caption' | 'cta' | 'disclosure' | 'link' | string;
	score: number;
	weight: number;
	status: 'pass' | 'warning' | 'blocked';
	findings: string;
	suggestedFix: string;
	isHardBlocked: boolean;
	canOverride: boolean;
}

export interface ReadinessCheckItem {
	checkId: string;
	platform: string;
	checkType: string;
	status: 'pass' | 'warning' | 'blocked';
	currentValue: string;
	requiredValue: string;
	suggestedFix: string;
	isHardBlocked: boolean;
	canOverride: boolean;
}

export interface ComplianceScanDetail {
	scanId: string;
	category: 'copyright' | 'content_policy' | 'platform_rules' | 'shadowban_risk' | 'consent' | string;
	status: 'pass' | 'pass_with_warnings' | 'review_required' | 'blocked';
	findingDescription: string;
	matchedWork?: string;
	matchConfidence?: string;
	isHardBlocked: boolean;
	canOverride: boolean;
}

export interface OverrideAuditRecord {
	overrideId: string;
	checkIdOrCategory: string;
	overriddenByUserId: string;
	actorRole: string;
	reason: string;
	createdAt: string;
}

export interface PackagingReport {
	reportId: string;
	assetId: string;
	publishItemId: string;
	overallPackagingScore: number;
	scoreStatus: 'pass' | 'below_recommended' | 'critical';
	components: PackagingScoreComponent[];
	readinessChecks: ReadinessCheckItem[];
	complianceDetails: ComplianceScanDetail[];
	complianceOverallResult: string;
	hasHardBlocks: boolean;
	hardBlockReasons: string[];
	readyForPackaging: boolean;
	readyToPublish: boolean;
	appliedOverrides: OverrideAuditRecord[];
	createdAt: string;
}

export interface UploadPreset {
	presetId: string;
	presetName: string;
	targetPlatform: string;
	aspectRatio: string;
	maxDurationSeconds: number;
	titleTemplate: string;
	defaultHashtags: string[];
	defaultCta: string;
	disclosureRequired: boolean;
}
