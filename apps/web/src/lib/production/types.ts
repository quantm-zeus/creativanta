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
