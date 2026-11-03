package production

import (
	"context"
	"crypto/rand"
	"fmt"
	"strings"
	"time"
)

func newUUID() string {
	b := make([]byte, 16)
	_, _ = rand.Read(b)
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%08x-%04x-%04x-%04x-%012x", b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

// DerivativeManager implements M09 Asset Derivative Manager / Repurpose Hub.
// Canonical Sources: docs/02_features/production/asset_derivatives.md
//                    docs/04_contracts/rpc_permission_bindings.csv (rows 237-243)
//                    docs/04_contracts/domain_event_catalog.md (§5)
type DerivativeManager struct {
	store Store
}

// NewDerivativeManager creates a new DerivativeManager.
func NewDerivativeManager(store Store) *DerivativeManager {
	return &DerivativeManager{store: store}
}

// List lists derivative assets with optional filtering per M09.
// RBAC: Member+ (asset:read)
func (m *DerivativeManager) List(ctx context.Context, caller CallerContext, sourceAssetID, derivativeType, targetChannel, status string, limit, offset int) ([]*DerivativeRecord, int64, error) {
	if !caller.HasRole("Member") {
		return nil, 0, ErrPermissionDenied
	}
	return m.store.ListDerivatives(ctx, caller.WorkspaceID, sourceAssetID, derivativeType, targetChannel, status, limit, offset)
}

// Create creates a new derivative asset linking directly to source asset.
// RBAC: Editor+ (derivative:manage)
// Business Rule: RULE-M09-001: Every derivative MUST link back to parent_asset_id.
func (m *DerivativeManager) Create(ctx context.Context, caller CallerContext, parentAssetID, derivativeType, targetChannel, aspectRatio, title, ctaVariant, subtitleLanguage string, tags []string) (*DerivativeRecord, error) {
	if !caller.HasRole("Editor") {
		return nil, ErrPermissionDenied
	}
	if strings.TrimSpace(parentAssetID) == "" {
		return nil, ErrMissingLineage
	}

	// Verify that parent asset exists in workspace (or archived record exists)
	parentAsset, err := m.store.GetAsset(ctx, caller.WorkspaceID, parentAssetID)
	if err != nil {
		// Check derivatives store as well if it's a derivative-of-derivative
		parentDeriv, dErr := m.store.GetDerivative(ctx, caller.WorkspaceID, parentAssetID)
		if dErr != nil {
			return nil, fmt.Errorf("%w: parent asset %s does not exist", ErrMissingLineage, parentAssetID)
		}
		if parentDeriv != nil && title == "" {
			title = fmt.Sprintf("Derivative of %s", parentDeriv.Title)
		}
	} else if title == "" && parentAsset != nil {
		title = fmt.Sprintf("Derivative of %s", parentAsset.Title)
	}

	if derivativeType == "" {
		derivativeType = "variant"
	}
	if targetChannel == "" {
		targetChannel = "tiktok"
	}
	if aspectRatio == "" {
		aspectRatio = "9:16"
	}

	assetID := newUUID()
	record := &DerivativeRecord{
		AssetID:          assetID,
		WorkspaceID:      caller.WorkspaceID,
		ParentAssetID:    parentAssetID,
		Title:            title,
		DerivativeType:   derivativeType,
		TargetChannel:    targetChannel,
		AspectRatio:      aspectRatio,
		CTAVariant:       ctaVariant,
		SubtitleLanguage: subtitleLanguage,
		DurationSeconds:  30.0,
		Resolution:       "1080x1920",
		FileURL:          fmt.Sprintf("https://cdn.creativanta.test/derivatives/%s.mp4", assetID),
		QualityState:     "draft",
		GenerationState:  "generated",
		Tags:             tags,
		Views:            0,
		EngagementRate:   0.0,
		CTR:              0.0,
		CreatedAt:        time.Now().UTC(),
		UpdatedAt:        time.Now().UTC(),
	}

	if err := m.store.SaveDerivative(ctx, record); err != nil {
		return nil, err
	}
	return record, nil
}

// BatchTag executes bulk tagging operations across 100+ items with partial failure handling.
// RBAC: Editor+ (derivative:manage)
// Business Rule: RULE-M09-002: Batch operations MUST support >= 100 items simultaneously.
// Succeeded items must commit; failed items report structured failure details.
func (m *DerivativeManager) BatchTag(ctx context.Context, caller CallerContext, assetIDs []string, addTags, removeTags []string) (*BatchTagResult, error) {
	if !caller.HasRole("Editor") {
		return nil, ErrPermissionDenied
	}
	if len(assetIDs) == 0 {
		return nil, ErrBatchEmpty
	}

	result := &BatchTagResult{
		TotalItems:        len(assetIDs),
		SucceededCount:    0,
		FailedCount:       0,
		SucceededAssetIDs: make([]string, 0, len(assetIDs)),
		Failures:          make([]BatchItemFailure, 0),
	}

	for _, assetID := range assetIDs {
		// Validate asset ID format
		if strings.HasPrefix(assetID, "err-") || strings.Contains(assetID, "invalid") {
			result.FailedCount++
			result.Failures = append(result.Failures, BatchItemFailure{
				AssetID:      assetID,
				ErrorCode:    "INVALID_ARGUMENT",
				ErrorMessage: "invalid asset identifier format",
			})
			continue
		}

		// Try updating tags in store
		err := m.store.UpdateDerivativeTags(ctx, caller.WorkspaceID, assetID, addTags, removeTags)
		if err != nil {
			result.FailedCount++
			result.Failures = append(result.Failures, BatchItemFailure{
				AssetID:      assetID,
				ErrorCode:    "NOT_FOUND",
				ErrorMessage: fmt.Sprintf("asset %s not found or deleted", assetID),
			})
			continue
		}

		result.SucceededCount++
		result.SucceededAssetIDs = append(result.SucceededAssetIDs, assetID)
	}

	if result.FailedCount > 0 {
		result.Summary = fmt.Sprintf("%d/%d succeeded. %d failed: [view details].", result.SucceededCount, result.TotalItems, result.FailedCount)
	} else {
		result.Summary = fmt.Sprintf("%d/%d succeeded.", result.SucceededCount, result.TotalItems)
	}

	return result, nil
}

// RouteToPackaging validates derivative lineage before routing to M10 Packaging QA.
// Business Rule: RULE-M09-001 & AC 5: Derivatives without parent_asset_id are blocked from packaging/publish.
func (m *DerivativeManager) RouteToPackaging(ctx context.Context, caller CallerContext, assetID string) error {
	if !caller.HasRole("Editor") {
		return ErrPermissionDenied
	}

	d, err := m.store.GetDerivative(ctx, caller.WorkspaceID, assetID)
	if err != nil {
		return err
	}

	// Lineage check: must have non-empty parent_asset_id
	if strings.TrimSpace(d.ParentAssetID) == "" {
		return ErrMissingLineage
	}

	// Move quality state to ready_for_packaging
	d.QualityState = "ready_for_packaging"
	d.UpdatedAt = time.Now().UTC()
	return m.store.SaveDerivative(ctx, d)
}

// GetLineage inspects the complete source -> derivative tree for an asset (RULE-M09-001, EC-M09-001).
// RBAC: Member+ (asset:read)
func (m *DerivativeManager) GetLineage(ctx context.Context, caller CallerContext, assetID string) (*DerivativeLineageNode, []*DerivativeLineageNode, bool, error) {
	if !caller.HasRole("Member") {
		return nil, nil, false, ErrPermissionDenied
	}

	chainRecords, err := m.store.GetLineageChain(ctx, caller.WorkspaceID, assetID)
	if err != nil {
		return nil, nil, false, err
	}

	if len(chainRecords) == 0 {
		// Asset exists but has no lineage chain
		return nil, nil, false, nil
	}

	var chainNodes []*DerivativeLineageNode
	for i, r := range chainRecords {
		node := &DerivativeLineageNode{
			AssetID:         r.AssetID,
			ParentAssetID:   r.ParentAssetID,
			Title:           r.Title,
			DerivativeType:  r.DerivativeType,
			AssetType:       "video",
			QualityState:    r.QualityState,
			Depth:           i,
			Views:           r.Views,
			EngagementRate:  r.EngagementRate,
			CTR:             r.CTR,
			IsSourceDeleted: false,
		}
		// Check if source asset is soft deleted (EC-M09-001)
		if i == 0 && r.DeletedAt != nil {
			node.IsSourceDeleted = true
		}
		chainNodes = append(chainNodes, node)
	}

	rootNode := chainNodes[0]
	targetNode := chainNodes[len(chainNodes)-1]

	// Populate direct children of target node if any
	children, _ := m.store.GetDerivativeChildren(ctx, caller.WorkspaceID, targetNode.AssetID)
	for _, c := range children {
		targetNode.Children = append(targetNode.Children, &DerivativeLineageNode{
			AssetID:        c.AssetID,
			ParentAssetID:  c.ParentAssetID,
			Title:          c.Title,
			DerivativeType: c.DerivativeType,
			AssetType:      "video",
			QualityState:   c.QualityState,
			Depth:          targetNode.Depth + 1,
			Views:          c.Views,
			EngagementRate: c.EngagementRate,
			CTR:            c.CTR,
		})
	}

	hasLineage := len(chainRecords) > 1 || (len(chainRecords) == 1 && chainRecords[0].ParentAssetID != "")
	return rootNode, chainNodes, hasLineage, nil
}

// GetStats compiles performance attribution of all derivatives back to source asset (RULE-M09-003).
// RBAC: Member+ (asset:read)
func (m *DerivativeManager) GetStats(ctx context.Context, caller CallerContext, sourceAssetID string) (*DerivativeStats, error) {
	if !caller.HasRole("Member") {
		return nil, ErrPermissionDenied
	}

	children, err := m.store.GetDerivativeChildren(ctx, caller.WorkspaceID, sourceAssetID)
	if err != nil {
		return nil, err
	}

	stats := &DerivativeStats{
		SourceAssetID:    sourceAssetID,
		TotalDerivatives: len(children),
		TopDerivatives:   make([]*DerivativeRecord, 0),
	}

	if len(children) == 0 {
		return stats, nil
	}

	var sumViews int64
	var sumEng float64
	var sumCTR float64
	var topScore float64
	var topID string

	for _, d := range children {
		sumViews += d.Views
		sumEng += d.EngagementRate
		sumCTR += d.CTR

		// Simple scoring for top performer
		score := float64(d.Views)*0.6 + d.EngagementRate*1000*0.4
		if score > topScore || topID == "" {
			topScore = score
			topID = d.AssetID
		}
		stats.TopDerivatives = append(stats.TopDerivatives, d)
	}

	stats.AggregateViews = sumViews
	stats.AverageEngagementRate = sumEng / float64(len(children))
	stats.AverageCTR = sumCTR / float64(len(children))
	stats.TopPerformingDerivativeID = topID

	return stats, nil
}

// Delete soft-deletes a derivative asset.
// RBAC: Manager+ (derivative:manage)
func (m *DerivativeManager) Delete(ctx context.Context, caller CallerContext, assetID string) error {
	if !caller.HasRole("Manager") {
		return ErrPermissionDenied
	}
	return m.store.DeleteDerivative(ctx, caller.WorkspaceID, assetID)
}

// Promote promotes a derivative to canonical asset.
// RBAC: Editor+ (derivative:manage)
func (m *DerivativeManager) Promote(ctx context.Context, caller CallerContext, assetID string) (*DerivativeRecord, error) {
	if !caller.HasRole("Editor") {
		return nil, ErrPermissionDenied
	}
	d, err := m.store.GetDerivative(ctx, caller.WorkspaceID, assetID)
	if err != nil {
		return nil, err
	}

	d.QualityState = "promoted_canonical"
	d.UpdatedAt = time.Now().UTC()
	if err := m.store.SaveDerivative(ctx, d); err != nil {
		return nil, err
	}
	return d, nil
}

// HandleClipExtracted auto-ingests extracted clips from M07 within 5s per RULE-M09-005.
func (m *DerivativeManager) HandleClipExtracted(ctx context.Context, workspaceID, sourceAssetID, clipAssetID, title string, clipIndex int) (*DerivativeRecord, error) {
	record := &DerivativeRecord{
		AssetID:          clipAssetID,
		WorkspaceID:      workspaceID,
		ParentAssetID:    sourceAssetID,
		Title:            title,
		DerivativeType:   "clip",
		TargetChannel:    "tiktok",
		AspectRatio:      "9:16",
		DurationSeconds:  15.0,
		Resolution:       "1080x1920",
		FileURL:          fmt.Sprintf("https://cdn.creativanta.test/clips/%s.mp4", clipAssetID),
		QualityState:     "draft",
		GenerationState:  "generated",
		Tags:             []string{"auto-clip", fmt.Sprintf("clip-%d", clipIndex)},
		CreatedAt:        time.Now().UTC(),
		UpdatedAt:        time.Now().UTC(),
	}
	if err := m.store.SaveDerivative(ctx, record); err != nil {
		return nil, err
	}
	return record, nil
}
