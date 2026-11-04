package workflow

import (
	"context"
	"fmt"
	"time"
)

// DLQManager handles dead-letter queue operations per database_schema.md §18.4G and Pack 03 §7.2.
type DLQManager struct {
	store Store
}

func NewDLQManager(store Store) *DLQManager {
	return &DLQManager{store: store}
}

// PushToDLQ captures a failed or intervention-requiring run into the dead-letter queue.
func (dm *DLQManager) PushToDLQ(ctx context.Context, item *DLQItem) error {
	if item.DLQID == "" {
		item.DLQID = newUUID()
	}
	if item.Status == "" {
		item.Status = "pending"
	}
	if item.CreatedAt.IsZero() {
		item.CreatedAt = time.Now().UTC()
	}
	if item.LastErrorAt.IsZero() {
		item.LastErrorAt = item.CreatedAt
	}
	if item.RetryHistory == nil {
		item.RetryHistory = make([]map[string]any, 0)
	}
	return dm.store.CreateDLQItem(ctx, item)
}

// GetDLQItem retrieves a dead-letter item by ID.
func (dm *DLQManager) GetDLQItem(ctx context.Context, caller CallerContext, dlqID string) (*DLQItem, error) {
	if err := checkPerm(caller, "workflow:read"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}
	return dm.store.GetDLQItem(ctx, caller.WorkspaceID, dlqID)
}

// ListDLQItems lists dead-letter queue items with optional status filtering.
func (dm *DLQManager) ListDLQItems(ctx context.Context, caller CallerContext, status string, limit, offset int) ([]DLQItem, int, error) {
	if err := checkPerm(caller, "workflow:read"); err != nil {
		return nil, 0, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}
	return dm.store.ListDLQItems(ctx, caller.WorkspaceID, status, limit, offset)
}

// RetryDLQItem retries a dead-lettered workflow run, transitioning DLQ item to retrying.
func (dm *DLQManager) RetryDLQItem(ctx context.Context, caller CallerContext, dlqID string) (*WorkflowRun, error) {
	if err := checkPerm(caller, "workflow:edit"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}

	item, err := dm.store.GetDLQItem(ctx, caller.WorkspaceID, dlqID)
	if err != nil {
		return nil, err
	}

	run, err := dm.store.GetWorkflowRun(ctx, caller.WorkspaceID, item.OriginalMessageID)
	if err != nil {
		return nil, fmt.Errorf("workflow run %s not found for DLQ item: %w", item.OriginalMessageID, err)
	}

	now := time.Now().UTC()
	item.Status = "retrying"
	item.AttemptCount++
	item.RetryHistory = append(item.RetryHistory, map[string]any{
		"retried_at": now.Format(time.RFC3339),
		"retried_by": caller.UserID,
		"action":     "single_retry",
	})
	if err := dm.store.UpdateDLQItem(ctx, item); err != nil {
		return nil, err
	}

	run.Status = WorkflowRunStatusQueued
	run.StartedAt = nil
	run.CompletedAt = nil
	run.UpdatedAt = now
	if err := dm.store.UpdateWorkflowRun(ctx, run); err != nil {
		return nil, err
	}

	return run, nil
}

// RepairAndRetryDLQItem applies repair parameters, resolves DLQ item, and re-triggers execution.
func (dm *DLQManager) RepairAndRetryDLQItem(
	ctx context.Context,
	caller CallerContext,
	dlqID string,
	repairContext map[string]any,
) (*WorkflowRun, error) {
	if err := checkPerm(caller, "workflow:edit"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}

	item, err := dm.store.GetDLQItem(ctx, caller.WorkspaceID, dlqID)
	if err != nil {
		return nil, err
	}

	run, err := dm.store.GetWorkflowRun(ctx, caller.WorkspaceID, item.OriginalMessageID)
	if err != nil {
		return nil, fmt.Errorf("workflow run %s not found: %w", item.OriginalMessageID, err)
	}

	now := time.Now().UTC()
	item.Status = "resolved"
	item.ResolvedAt = &now
	item.ResolvedBy = caller.UserID
	item.ResolutionNotes = fmt.Sprintf("Repaired with %d parameters by %s", len(repairContext), caller.UserID)
	item.RetryHistory = append(item.RetryHistory, map[string]any{
		"repaired_at":    now.Format(time.RFC3339),
		"repaired_by":    caller.UserID,
		"repair_context": repairContext,
	})
	if err := dm.store.UpdateDLQItem(ctx, item); err != nil {
		return nil, err
	}

	// Merge repair context into trigger event
	if run.TriggerEvent == nil {
		run.TriggerEvent = make(map[string]any)
	}
	for k, v := range repairContext {
		run.TriggerEvent[k] = v
	}

	run.Status = WorkflowRunStatusQueued
	run.StartedAt = nil
	run.CompletedAt = nil
	run.UpdatedAt = now
	if run.ResultSummary == nil {
		run.ResultSummary = make(map[string]any)
	}
	run.ResultSummary["repaired"] = true
	run.ResultSummary["repair_notes"] = item.ResolutionNotes

	if err := dm.store.UpdateWorkflowRun(ctx, run); err != nil {
		return nil, err
	}

	return run, nil
}

// DiscardDLQItem marks a DLQ item as discarded with an audited reason.
func (dm *DLQManager) DiscardDLQItem(
	ctx context.Context,
	caller CallerContext,
	dlqID string,
	reason string,
) (*DLQItem, error) {
	if err := checkPerm(caller, "workflow:edit"); err != nil {
		return nil, fmt.Errorf("%w: %v", ErrUnauthorized, err)
	}

	item, err := dm.store.GetDLQItem(ctx, caller.WorkspaceID, dlqID)
	if err != nil {
		return nil, err
	}

	now := time.Now().UTC()
	item.Status = "discarded"
	item.ResolvedAt = &now
	item.ResolvedBy = caller.UserID
	item.ResolutionNotes = reason

	if err := dm.store.UpdateDLQItem(ctx, item); err != nil {
		return nil, err
	}

	return item, nil
}
