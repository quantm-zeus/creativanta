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

