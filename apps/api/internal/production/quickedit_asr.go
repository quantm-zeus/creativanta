package production

import (
	"context"
	"fmt"
	"strings"
	"time"
	"unicode"
)

// ASREngine handles Whisper ASR transcript parsing, filler detection,
// dead pause extraction, hook evaluation, and transcript repair (EC-M07-Q01).
type ASREngine struct {
	fillerWords map[string]string // normalized lower word -> filler type
}

// NewASREngine constructs an ASREngine preloaded with Vietnamese and English filler vocabularies.
func NewASREngine() *ASREngine {
	fillers := map[string]string{
		// Vietnamese fillers
		"ừm":           "filler_vi",
		"à":            "filler_vi",
		"ờ":            "filler_vi",
		"kiểu":         "filler_vi",
		"thì là":       "filler_vi",
		"như là":       "filler_vi",
		"nói chung là": "filler_vi",
		"cái này":      "filler_vi",

		// English fillers
		"um":        "filler_en",
		"uh":        "filler_en",
		"like":      "filler_en",
		"you know":  "filler_en",
		"basically": "filler_en",
		"actually":  "filler_en",
		"sort of":   "filler_en",
		"kind of":   "filler_en",
	}

	return &ASREngine{
		fillerWords: fillers,
	}
}

// NormalizeWord strips punctuation and lowercases text for matching.
func NormalizeWord(w string) string {
	var sb strings.Builder
	for _, r := range strings.ToLower(w) {
		if unicode.IsLetter(r) || unicode.IsDigit(r) || r == ' ' {
			sb.WriteRune(r)
		}
	}
	return strings.TrimSpace(sb.String())
}

// IsFiller checks whether a word matches known filler patterns.
func (e *ASREngine) IsFiller(wordText string) (bool, string) {
	norm := NormalizeWord(wordText)
	if fType, ok := e.fillerWords[norm]; ok {
		return true, fType
	}
	return false, ""
}

// ParseTranscript analyzes words, tags fillers, detects dead pauses, and calculates hook quality.
func (e *ASREngine) ParseTranscript(words []TranscriptWordRecord, minPauseMS int64) (
	taggedWords []TranscriptWordRecord,
	analysis TranscriptAnalysisRecord,
) {
	if minPauseMS <= 0 {
		minPauseMS = 1500 // 1.5s default per spec
	}

	taggedWords = make([]TranscriptWordRecord, len(words))
	fillerCount := 0
	detectedFillers := make([]string, 0)
	deadPauses := make([]DeadPauseRecord, 0)

	var prevEndMS int64 = 0

	for i, w := range words {
		tw := w
		isF, fType := e.IsFiller(tw.Text)
		if isF {
			tw.IsFiller = true
			tw.FillerType = fType
			fillerCount++
			detectedFillers = append(detectedFillers, tw.Text)
		}

		// Detect dead pause before this word
		if i > 0 && tw.StartMS > prevEndMS {
			gap := tw.StartMS - prevEndMS
			if gap >= minPauseMS {
				deadPauses = append(deadPauses, DeadPauseRecord{
					StartMS:    prevEndMS,
					EndMS:      tw.StartMS,
					DurationMS: gap,
				})
			}
		}

		prevEndMS = tw.EndMS
		taggedWords[i] = tw
	}

	// Calculate hook quality score (first 3s)
	hookScore, hookFeedback := e.EvaluateHook(words)

	// Calculate estimated savings: filler durations + dead pause durations
	var savedMS int64 = 0
	for _, w := range taggedWords {
		if w.IsFiller || w.IsDeleted {
			savedMS += (w.EndMS - w.StartMS)
		}
	}
	for _, p := range deadPauses {
		savedMS += p.DurationMS
	}

	var totalDurationMS int64 = 0
	if len(words) > 0 {
		totalDurationMS = words[len(words)-1].EndMS
	}
	finalDurationMS := totalDurationMS - savedMS
	if finalDurationMS < 0 {
		finalDurationMS = 0
	}

	analysis = TranscriptAnalysisRecord{
		FillerCount:          fillerCount,
		PauseCount:           len(deadPauses),
		HookQualityScore:     hookScore,
		EstimatedTimeSavedMS: savedMS,
		FinalDurationMS:      finalDurationMS,
		DetectedFillers:      detectedFillers,
		DeadPauses:           deadPauses,
		HookFeedback:         hookFeedback,
	}

	return taggedWords, analysis
}

// EvaluateHook calculates a 0-10 hook quality score based on first 3000ms.
func (e *ASREngine) EvaluateHook(words []TranscriptWordRecord) (float64, string) {
	if len(words) == 0 {
		return 3.0, "Video không có lời thoại mở đầu"
	}

	score := 7.0 // Base neutral score

	// Check initial silence
	firstWordStart := words[0].StartMS
	if firstWordStart > 1000 {
		score -= 2.5
	}

	// Collect first 3 seconds words
	var first3sWords []string
	first3sFillers := 0
	for _, w := range words {
		if w.StartMS <= 3000 {
			first3sWords = append(first3sWords, strings.ToLower(w.Text))
			if isF, _ := e.IsFiller(w.Text); isF {
				first3sFillers++
			}
		}
	}

	first3sText := strings.Join(first3sWords, " ")

	if first3sFillers > 0 {
		score -= float64(first3sFillers) * 1.5
	}

	// Reward questions
	if strings.Contains(first3sText, "?") ||
		strings.Contains(first3sText, "tại sao") ||
		strings.Contains(first3sText, "làm sao") ||
		strings.Contains(first3sText, "how") ||
		strings.Contains(first3sText, "why") {
		score += 2.0
	}

	// Reward curiosity/shock keywords
	curiosityTerms := []string{"đừng", "bí mật", "cảnh báo", "bất ngờ", "never", "secret", "warning", "shocking", "5 tips", "sai lầm"}
	for _, term := range curiosityTerms {
		if strings.Contains(first3sText, term) {
			score += 1.5
			break
		}
	}

	if score > 10.0 {
		score = 10.0
	}
	if score < 1.0 {
		score = 1.0
	}

	var feedback string
	switch {
	case score >= 8.5:
		feedback = "Hook rất mạnh: mở đầu dứt khoát, kích thích tò mò cao"
	case score >= 6.5:
		feedback = "Hook khá tốt: thông điệp rõ ràng, có thể tối ưu thêm tốc độ mở đầu"
	case score >= 4.5:
		feedback = "Mở đầu hơi chậm hoặc có filler words, nên cắt đoạn thừa đầu video"
	default:
		feedback = "Mở đầu yếu: có khoảng lặng dài hoặc quá nhiều từ đệm trong 3s đầu"
	}

	return score, feedback
}

// RepairTranscript updates word timestamps and text corrections per EC-M07-Q01.
// If alignment is invalid or violates temporal monotonicity beyond threshold,
// it triggers manual fallback.
func (e *ASREngine) RepairTranscript(
	ctx context.Context,
	original *TranscriptRecord,
	corrections []TranscriptCorrectionItem,
) (*TranscriptRecord, error) {
	if original == nil {
		return nil, ErrTranscriptNotFound
	}

	repaired := *original
	repaired.Words = make([]TranscriptWordRecord, len(original.Words))
	copy(repaired.Words, original.Words)

	// Map words by ID for fast lookup
	wordIndex := make(map[string]int)
	for i, w := range repaired.Words {
		wordIndex[w.WordID] = i
	}

	// Apply corrections
	for _, c := range corrections {
		idx, found := wordIndex[c.WordID]
		if !found {
			continue
		}
		w := &repaired.Words[idx]

		if c.CorrectedText != "" {
			w.Text = c.CorrectedText
			// Re-evaluate filler status
			isF, fType := e.IsFiller(c.CorrectedText)
			w.IsFiller = isF
			w.FillerType = fType
		}

		if c.NewStartMS > 0 || c.NewEndMS > 0 {
			if c.NewStartMS > 0 {
				w.StartMS = c.NewStartMS
			}
			if c.NewEndMS > 0 {
				w.EndMS = c.NewEndMS
			}
		}

		if c.MarkCut {
			w.IsDeleted = true
		}
	}

	// Validate alignment consistency
	// Rule 1: Each word must have StartMS < EndMS
	// Rule 2: Words must be temporally ordered; overlap cannot exceed 500ms
	alignmentFailed := false
	var alignmentErrDetail string

	for i := 0; i < len(repaired.Words); i++ {
		w := repaired.Words[i]
		if w.StartMS >= w.EndMS {
			alignmentFailed = true
			alignmentErrDetail = fmt.Sprintf("word %q has invalid timecode [%d ms - %d ms]", w.Text, w.StartMS, w.EndMS)
			break
		}

		if i > 0 {
			prev := repaired.Words[i-1]
			// Check severe inversion (e.g. current start is earlier than previous start)
			if w.StartMS < prev.StartMS {
				alignmentFailed = true
				alignmentErrDetail = fmt.Sprintf("temporal inversion between %q (%d ms) and %q (%d ms)", prev.Text, prev.StartMS, w.Text, w.StartMS)
				break
			}
			// Check massive overlap (> 500ms)
			if prev.EndMS-w.StartMS > 500 {
				alignmentFailed = true
				alignmentErrDetail = fmt.Sprintf("excessive word overlap (%d ms) between %q and %q", prev.EndMS-w.StartMS, prev.Text, w.Text)
				break
			}
		}
	}

	if alignmentFailed {
		// Per EC-M07-Q01: If alignment fails, show "Auto-alignment failed. [Try segment mode] or [Manual cut]."
		repaired.AlignmentStatus = "manual_fallback"
		repaired.AlignmentError = "Auto-alignment failed. [Try segment mode] or [Manual cut]."
		repaired.UpdatedAt = time.Now().UTC()
		return &repaired, fmt.Errorf("%w: %s (detail: %s)", ErrAlignmentFailed, repaired.AlignmentError, alignmentErrDetail)
	}

	// Alignment succeeded
	repaired.AlignmentStatus = "repaired"
	repaired.AlignmentError = ""

	// Recompute counts and raw text
	repaired.Words, _ = e.ParseTranscript(repaired.Words, 1500)
	var rawWords []string
	fillerCount := 0
	for _, w := range repaired.Words {
		rawWords = append(rawWords, w.Text)
		if w.IsFiller {
			fillerCount++
		}
	}
	repaired.RawText = strings.Join(rawWords, " ")
	repaired.FillerCount = fillerCount
	repaired.UpdatedAt = time.Now().UTC()

	return &repaired, nil
}
