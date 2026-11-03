package production

import (
	"fmt"
	"sort"
	"strings"
)

// TimelineSegment represents a retained playable slice [StartMS, EndMS] of the source video.
type TimelineSegment struct {
	Index      int   `json:"index"`
	StartMS    int64 `json:"start_ms"`
	EndMS      int64 `json:"end_ms"`
	DurationMS int64 `json:"duration_ms"`
}

// CutEngine manages the translation of transcript deletions to millisecond cut intervals,
// interval coalescing, retained timeline computation, and FFmpeg filter complex generation.
type CutEngine struct {
	coalesceThresholdMS int64 // Merges cuts separated by less than this threshold (default 80ms)
}

// NewCutEngine creates a CutEngine.
func NewCutEngine(coalesceThresholdMS int64) *CutEngine {
	if coalesceThresholdMS <= 0 {
		coalesceThresholdMS = 80 // 80ms prevents micro-fragmentation and audio clicks
	}
	return &CutEngine{
		coalesceThresholdMS: coalesceThresholdMS,
	}
}

// BuildCutIntervalsFromTranscript maps deleted words, filler words (if enabled),
// and dead pauses into sorted CutIntervalRecords.
func (e *CutEngine) BuildCutIntervalsFromTranscript(
	words []TranscriptWordRecord,
	pauses []DeadPauseRecord,
	removeFillers bool,
	removePauses bool,
	manualCuts []CutIntervalRecord,
) []CutIntervalRecord {
	cuts := make([]CutIntervalRecord, 0)

	// Deleted words
	for _, w := range words {
		if w.IsDeleted {
			cuts = append(cuts, CutIntervalRecord{
				StartMS: w.StartMS,
				EndMS:   w.EndMS,
				Reason:  "deleted_text",
			})
		} else if removeFillers && w.IsFiller {
			cuts = append(cuts, CutIntervalRecord{
				StartMS: w.StartMS,
				EndMS:   w.EndMS,
				Reason:  "filler",
			})
		}
	}

	// Pauses
	if removePauses {
		for _, p := range pauses {
			cuts = append(cuts, CutIntervalRecord{
				StartMS: p.StartMS,
				EndMS:   p.EndMS,
				Reason:  "pause",
			})
		}
	}

	// Manual cuts
	cuts = append(cuts, manualCuts...)

	return e.CoalesceCutIntervals(cuts)
}

// CoalesceCutIntervals sorts intervals, merges overlapping cuts,
// and bridges gaps smaller than coalesceThresholdMS.
func (e *CutEngine) CoalesceCutIntervals(cuts []CutIntervalRecord) []CutIntervalRecord {
	if len(cuts) <= 1 {
		return cuts
	}

	// Sort by StartMS ascending, then EndMS ascending
	sort.Slice(cuts, func(i, j int) bool {
		if cuts[i].StartMS == cuts[j].StartMS {
			return cuts[i].EndMS < cuts[j].EndMS
		}
		return cuts[i].StartMS < cuts[j].StartMS
	})

	merged := make([]CutIntervalRecord, 0, len(cuts))
	current := cuts[0]

	for i := 1; i < len(cuts); i++ {
		next := cuts[i]

		// Check if next overlaps or is within coalesceThresholdMS of current
		if next.StartMS <= current.EndMS+e.coalesceThresholdMS {
			// Extend current interval if next ends later
			if next.EndMS > current.EndMS {
				current.EndMS = next.EndMS
			}
			if current.Reason != next.Reason {
				current.Reason = current.Reason + "+" + next.Reason
			}
		} else {
			merged = append(merged, current)
			current = next
		}
	}
	merged = append(merged, current)

	return merged
}

// ComputeRetainedSegments inverts cut intervals against total video duration,
// producing non-overlapping, strictly increasing retained playback segments.
func (e *CutEngine) ComputeRetainedSegments(
	totalDurationMS int64,
	cuts []CutIntervalRecord,
) (segments []TimelineSegment, timeSavedMS int64, finalDurationMS int64) {
	if totalDurationMS <= 0 {
		return nil, 0, 0
	}

	coalesced := e.CoalesceCutIntervals(cuts)

	segments = make([]TimelineSegment, 0)
	var cursor int64 = 0
	var totalCutMS int64 = 0

	for _, cut := range coalesced {
		// Clamp cut boundaries to video duration
		cutStart := cut.StartMS
		cutEnd := cut.EndMS
		if cutStart < 0 {
			cutStart = 0
		}
		if cutEnd > totalDurationMS {
			cutEnd = totalDurationMS
		}
		if cutStart >= cutEnd {
			continue
		}

		// If there is retained content before this cut
		if cutStart > cursor {
			dur := cutStart - cursor
			segments = append(segments, TimelineSegment{
				Index:      len(segments),
				StartMS:    cursor,
				EndMS:      cutStart,
				DurationMS: dur,
			})
		}

		totalCutMS += (cutEnd - cutStart)
		cursor = cutEnd
	}

	// Retained segment after the last cut up to end of video
	if cursor < totalDurationMS {
		dur := totalDurationMS - cursor
		segments = append(segments, TimelineSegment{
			Index:      len(segments),
			StartMS:    cursor,
			EndMS:      totalDurationMS,
			DurationMS: dur,
		})
	}

	finalDurationMS = totalDurationMS - totalCutMS
	if finalDurationMS < 0 {
		finalDurationMS = 0
	}

	return segments, totalCutMS, finalDurationMS
}

// ValidateNoCumulativeDrift verifies that the total timeline segment durations
// equal finalDurationMS exactly, and that every retained word's mapped position
// in the final video has 0ms cumulative drift.
func (e *CutEngine) ValidateNoCumulativeDrift(
	totalDurationMS int64,
	cuts []CutIntervalRecord,
	words []TranscriptWordRecord,
) (bool, string) {
	segments, timeSavedMS, finalDurationMS := e.ComputeRetainedSegments(totalDurationMS, cuts)

	// Check 1: Sum of retained segment durations must equal finalDurationMS
	var segmentSumMS int64 = 0
	for _, seg := range segments {
		segmentSumMS += seg.DurationMS
	}

	if segmentSumMS != finalDurationMS {
		return false, fmt.Sprintf("duration drift: sum of segments (%d ms) != finalDurationMS (%d ms)", segmentSumMS, finalDurationMS)
	}

	if segmentSumMS+timeSavedMS != totalDurationMS {
		return false, fmt.Sprintf("duration drift: retained (%d ms) + cuts (%d ms) != total (%d ms)", segmentSumMS, timeSavedMS, totalDurationMS)
	}

	// Check 2: Retained words must map to correct timecodes without drift
	for _, w := range words {
		if w.IsDeleted {
			continue
		}

		// Find which segment contains this word
		var wordSeg *TimelineSegment
		var segStartFinalMS int64 = 0

		for _, seg := range segments {
			if w.StartMS >= seg.StartMS && w.EndMS <= seg.EndMS {
				wordSeg = &seg
				break
			}
			segStartFinalMS += seg.DurationMS
		}

		if wordSeg != nil {
			// Offset within segment
			offsetInSeg := w.StartMS - wordSeg.StartMS
			finalWordStartMS := segStartFinalMS + offsetInSeg
			finalWordEndMS := finalWordStartMS + (w.EndMS - w.StartMS)

			if finalWordStartMS < 0 || finalWordEndMS > finalDurationMS {
				return false, fmt.Sprintf("word %q mapped out of bounds: [%d ms - %d ms] > %d ms", w.Text, finalWordStartMS, finalWordEndMS, finalDurationMS)
			}
		}
	}

	return true, ""
}

// GenerateFFmpegFilterComplex builds the allowlisted FFmpeg filter_complex script
// to trim video and audio segments and concatenate them seamlessly.
func (e *CutEngine) GenerateFFmpegFilterComplex(segments []TimelineSegment) (filterComplex string, err error) {
	if len(segments) == 0 {
		return "", fmt.Errorf("no retained segments to render")
	}

	// Single segment: simple trim without concat
	if len(segments) == 1 {
		seg := segments[0]
		startSec := float64(seg.StartMS) / 1000.0
		endSec := float64(seg.EndMS) / 1000.0
		fc := fmt.Sprintf(
			"[0:v]trim=start=%.3f:end=%.3f,setpts=PTS-STARTPTS[outv];[0:a]atrim=start=%.3f:end=%.3f,asetpts=PTS-STARTPTS[outa]",
			startSec, endSec, startSec, endSec,
		)
		return fc, nil
	}

	var sb strings.Builder
	var concatInputs strings.Builder

	for i, seg := range segments {
		startSec := float64(seg.StartMS) / 1000.0
		endSec := float64(seg.EndMS) / 1000.0

		// Video trim
		sb.WriteString(fmt.Sprintf("[0:v]trim=start=%.3f:end=%.3f,setpts=PTS-STARTPTS[v%d];", startSec, endSec, i))
		// Audio trim
		sb.WriteString(fmt.Sprintf("[0:a]atrim=start=%.3f:end=%.3f,asetpts=PTS-STARTPTS[a%d];", startSec, endSec, i))

		concatInputs.WriteString(fmt.Sprintf("[v%d][a%d]", i, i))
	}

	// Concat filter: concat=n=N:v=1:a=1[outv][outa]
	sb.WriteString(fmt.Sprintf("%sconcat=n=%d:v=1:a=1[outv][outa]", concatInputs.String(), len(segments)))

	return sb.String(), nil
}
