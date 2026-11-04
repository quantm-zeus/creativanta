package workflow

import (
	"crypto/rand"
	"encoding/json"
	"fmt"
	"time"
)

func newUUID() string {
	var b [16]byte
	_, _ = rand.Read(b[:])
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%08x-%04x-%04x-%04x-%012x",
		b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

// ExportWorkflow creates a portable payload JSON per database_schema.md §27.4.
func ExportWorkflow(w *Workflow) (*PortableWorkflowPayload, error) {
	if w == nil {
		return nil, ErrWorkflowNotFound
	}
	if err := ValidateWorkflowGraph(&w.ActionChain); err != nil {
		return nil, fmt.Errorf("cannot export invalid workflow: %w", err)
	}

	payload := &PortableWorkflowPayload{
		SchemaVersion: 1,
		Title:         w.Title,
		Description:   w.Description,
		WorkflowType:  w.WorkflowType,
		TriggerConfig: w.TriggerConfig,
		Graph:         w.ActionChain,
		LicenseNotice: "Creativanta Portable Workflow Template v1.0. Proprietary to tenant workspace.",
		Parameters: map[string]any{
			"exported_at": time.Now().UTC().Format(time.RFC3339),
			"version":     w.Version,
		},
	}
	return payload, nil
}

// ImportWorkflow validates and imports a portable payload JSON per database_schema.md §27.4.
func ImportWorkflow(workspaceID string, payload *PortableWorkflowPayload) (*Workflow, error) {
	if payload == nil {
		return nil, fmt.Errorf("%w: payload is nil", ErrInvalidGraphStructure)
	}
	if payload.SchemaVersion != 1 {
		return nil, fmt.Errorf("%w: unsupported payload schema_version %d", ErrInvalidGraphStructure, payload.SchemaVersion)
	}
	if err := ValidateWorkflowGraph(&payload.Graph); err != nil {
		return nil, fmt.Errorf("imported graph validation failed: %w", err)
	}

	now := time.Now().UTC()
	workflowType := payload.WorkflowType
	if workflowType == "" {
		workflowType = "custom"
	}

	w := &Workflow{
		WorkflowID:           newUUID(),
		WorkspaceID:          workspaceID,
		Title:                payload.Title,
		Description:          payload.Description,
		WorkflowType:         workflowType,
		Status:               WorkflowStatusDraft, // Always starts in draft
		Version:              1,                   // Initial version
		TriggerConfig:        payload.TriggerConfig,
		ActionChain:          payload.Graph,
		ApprovalRequirements: []string{},
		TierLimitCheck:       true,
		RunCount:             0,
		CreatedAt:            now,
		UpdatedAt:            now,
	}

	return w, nil
}

// CloneWorkflow creates an exact draft duplicate of an existing workflow with a new ID.
func CloneWorkflow(w *Workflow, newTitle string) (*Workflow, error) {
	if w == nil {
		return nil, ErrWorkflowNotFound
	}

	// Deep clone via JSON
	data, err := json.Marshal(w)
	if err != nil {
		return nil, err
	}

	var clone Workflow
	if err := json.Unmarshal(data, &clone); err != nil {
		return nil, err
	}

	now := time.Now().UTC()
	clone.WorkflowID = newUUID()
	if newTitle != "" {
		clone.Title = newTitle
	} else {
		clone.Title = fmt.Sprintf("Clone of %s", w.Title)
	}
	clone.Status = WorkflowStatusDraft
	clone.Version = 1
	clone.RunCount = 0
	clone.ActivepiecesFlowID = ""
	clone.CreatedAt = now
	clone.UpdatedAt = now
	clone.DeletedAt = nil

	return &clone, nil
}
