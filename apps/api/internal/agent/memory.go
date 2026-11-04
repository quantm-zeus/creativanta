package agent

import (
	"fmt"
	"strings"
	"sync"
	"time"
)

const (
	// DefaultMaxMemoryBytes is 50MB per EC-M21-003; can be configured per run.
	DefaultMaxMemoryBytes int64 = 50 * 1024 * 1024
	// CompressionThresholdRatio triggers summarization when memory exceeds 80% capacity.
	CompressionThresholdRatio = 0.80
)

// BoundedMemory manages temporary session-scoped working memory per RULE-M21-003 and EC-M21-003.
// Agent memory is strictly non-canonical and never overrides the canonical operating graph.
type BoundedMemory struct {
	mu           sync.RWMutex
	maxBytes     int64
	totalBytes   int64
	isCompressed bool
	summary      string
	entries      []AgentMemoryEntry
}

// NewBoundedMemory creates a bounded memory manager with a configurable maximum byte size.
func NewBoundedMemory(maxBytes int64) *BoundedMemory {
	if maxBytes <= 0 {
		maxBytes = DefaultMaxMemoryBytes
	}
	return &BoundedMemory{
		maxBytes: maxBytes,
		entries:  make([]AgentMemoryEntry, 0),
	}
}

// AddObservation appends an observation to working memory.
// If capacity approaches the threshold (>80%), older observations are automatically
// compressed and summarized to keep working memory strictly bounded.
func (m *BoundedMemory) AddObservation(key, value string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	entrySize := len(key) + len(value)
	now := time.Now().UTC()

	// Check if adding this entry approaches or exceeds capacity
	threshold := int64(float64(m.maxBytes) * CompressionThresholdRatio)
	if m.totalBytes+int64(entrySize) >= threshold {
		m.compressLocked()
	}

	// If still exceeding hard limit after compression, truncate value strictly within bounds
	if m.totalBytes+int64(entrySize) > m.maxBytes {
		allowedValueLen := m.maxBytes - m.totalBytes - int64(len(key))
		if allowedValueLen <= 0 {
			value = ""
			entrySize = len(key)
			if int64(entrySize) > m.maxBytes-m.totalBytes {
				// At absolute hard limit, drop oldest entry
				if len(m.entries) > 0 {
					m.totalBytes -= int64(m.entries[0].ByteSize)
					m.entries = m.entries[1:]
				}
			}
		} else {
			suffix := "... [truncated]"
			if allowedValueLen <= int64(len(suffix)) {
				value = value[:allowedValueLen]
			} else {
				value = value[:allowedValueLen-int64(len(suffix))] + suffix
			}
			entrySize = len(key) + len(value)
		}
	}

	entry := AgentMemoryEntry{
		Key:        key,
		Value:      value,
		ByteSize:   entrySize,
		ObservedAt: now,
	}

	m.entries = append(m.entries, entry)
	m.totalBytes += int64(entrySize)
	return nil
}

// compressLocked rolls older observations into a consolidated text summary.
func (m *BoundedMemory) compressLocked() {
	if len(m.entries) <= 1 {
		return
	}

	// Keep the most recent entry intact, summarize all previous entries
	cutoff := len(m.entries) - 1
	var summaryParts []string
	if m.summary != "" {
		summaryParts = append(summaryParts, m.summary)
	}

	for i := 0; i < cutoff; i++ {
		e := m.entries[i]
		summaryParts = append(summaryParts, fmt.Sprintf("[%s]: %s", e.Key, e.Value))
	}

	compressedSummary := strings.Join(summaryParts, " | ")
	if len(compressedSummary) > 1024 {
		compressedSummary = compressedSummary[:1020] + "..."
	}

	recent := m.entries[cutoff:]
	m.entries = recent
	m.summary = compressedSummary
	m.isCompressed = true

	// Recalculate total bytes
	var newTotal int64
	for _, e := range m.entries {
		newTotal += int64(e.ByteSize)
	}
	newTotal += int64(len(m.summary))
	m.totalBytes = newTotal
}

// Snapshot returns a copy of current working memory for inspection and persistence in agent_runs.
func (m *BoundedMemory) Snapshot() *AgentMemory {
	m.mu.RLock()
	defer m.mu.RUnlock()

	entriesCopy := make([]AgentMemoryEntry, len(m.entries))
	copy(entriesCopy, m.entries)

	return &AgentMemory{
		TotalBytes:   m.totalBytes,
		MaxBytes:     m.maxBytes,
		IsCompressed: m.isCompressed,
		Summary:      m.summary,
		Entries:      entriesCopy,
	}
}

// Clear flushes ephemeral memory upon run completion per RULE-M21-003.
func (m *BoundedMemory) Clear() {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.entries = nil
	m.totalBytes = 0
	m.summary = ""
	m.isCompressed = false
}
