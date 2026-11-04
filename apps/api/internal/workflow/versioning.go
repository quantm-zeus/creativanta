package workflow

import (
	"fmt"
	"time"
)

// IncrementVersion increments the workflow version and updates its updated_at timestamp.
func IncrementVersion(w *Workflow, expectedVersion int32) error {
	if expectedVersion > 0 && w.Version != expectedVersion {
		return fmt.Errorf("%w: current version is %d, expected %d", ErrVersionMismatch, w.Version, expectedVersion)
	}
	w.Version++
	w.UpdatedAt = time.Now().UTC()
	return nil
}
