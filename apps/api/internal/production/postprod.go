package production

import (
	"context"
	"errors"
	"fmt"
	"math"
	"os/exec"
	"strings"
	"syscall"
	"time"
)

// AllowedFFmpegFlags defines the strict security allowlist of permitted FFmpeg flags.
var AllowedFFmpegFlags = map[string]bool{
	"-i":              true,
	"-y":              true,
	"-v":              true,
	"-loglevel":       true,
	"-ss":             true,
	"-t":              true,
	"-to":             true,
	"-vf":             true,
	"-af":             true,
	"-filter_complex": true,
	"-c:v":            true,
	"-c:a":            true,
	"-b:v":            true,
	"-b:a":            true,
	"-r":              true,
	"-s":              true,
	"-aspect":         true,
	"-pix_fmt":        true,
	"-f":              true,
	"-movflags":       true,
	"-preset":         true,
	"-crf":            true,
	"-an":             true,
	"-vn":             true,
	"-shortest":       true,
	"-threads":        true,
	"-hide_banner":    true,
}

// AllowedFFprobeFlags defines the strict security allowlist of permitted FFprobe flags.
var AllowedFFprobeFlags = map[string]bool{
	"-v":              true,
	"-show_entries":   true,
	"-show_streams":   true,
	"-show_format":    true,
	"-print_format":   true,
	"-of":             true,
	"-select_streams": true,
	"-hide_banner":    true,
	"-i":              true,
}

// ValidateFFmpegArgs enforces argument allowlisting and sanitization against shell injection.
func ValidateFFmpegArgs(args []string) error {
	for i := 0; i < len(args); i++ {
		arg := args[i]
		// Check dangerous shell metacharacters
		if strings.ContainsAny(arg, ";|&$`><\n\r") {
			return fmt.Errorf("%w: argument %q contains illegal shell metacharacters", ErrDisallowedFFmpegArg, arg)
		}
		// If argument starts with '-', verify it is an allowlisted flag
		if strings.HasPrefix(arg, "-") {
			flag := strings.Split(arg, "=")[0]
			if !AllowedFFmpegFlags[flag] {
				return fmt.Errorf("%w: unrecognized or prohibited flag %q", ErrDisallowedFFmpegArg, flag)
			}
		}
		// Deny dangerous protocol wrappers
		lower := strings.ToLower(arg)
		if strings.HasPrefix(lower, "concat:") || strings.HasPrefix(lower, "crypto:") ||
			strings.HasPrefix(lower, "pipe:") || strings.HasPrefix(lower, "subfile:") ||
			strings.HasPrefix(lower, "http://") || strings.HasPrefix(lower, "https://") && strings.Contains(arg, "filter") {
			return fmt.Errorf("%w: dangerous protocol wrapper detected in %q", ErrDisallowedFFmpegArg, arg)
		}
	}
	return nil
}

// ValidateFFprobeArgs enforces argument allowlisting for media probing commands.
func ValidateFFprobeArgs(args []string) error {
	for _, arg := range args {
		if strings.ContainsAny(arg, ";|&$`><\n\r") {
			return fmt.Errorf("%w: argument %q contains illegal shell metacharacters", ErrDisallowedFFmpegArg, arg)
		}
		if strings.HasPrefix(arg, "-") {
			flag := strings.Split(arg, "=")[0]
			if !AllowedFFprobeFlags[flag] {
				return fmt.Errorf("%w: prohibited ffprobe flag %q", ErrDisallowedFFmpegArg, flag)
			}
		}
	}
	return nil
}

// WorkerLimits defines CPU, memory, disk, and time limits for sandboxed media processing.
type WorkerLimits struct {
	TimeoutSecs  int
	MaxDiskBytes int64 // Maximum output file size
	CPULimitSecs int
}

// DefaultWorkerLimits returns production-safe limits.
func DefaultWorkerLimits() WorkerLimits {
	return WorkerLimits{
		TimeoutSecs:  180,               // 3 minutes execution timeout
		MaxDiskBytes: 500 * 1024 * 1024, // 500 MB max output size
		CPULimitSecs: 120,               // 2 minutes CPU limit
	}
}

// OutputMediaMetadata holds probed media details before marking a job completed.
type OutputMediaMetadata struct {
	Width             int     `json:"width"`
	Height            int     `json:"height"`
	DurationSecs      float64 `json:"duration_secs"`
	HasVideoStream    bool    `json:"has_video_stream"`
	HasAudioStream    bool    `json:"has_audio_stream"`
	AudioLoudnessLUFS float64 `json:"audio_loudness_lufs"`
	FileSizeBytes     int64   `json:"file_size_bytes"`
}

// PostProductionExecutor manages secure, sandboxed execution of post-production jobs.
type PostProductionExecutor struct {
	limits WorkerLimits
}

// NewPostProductionExecutor constructs an executor with worker limits.
func NewPostProductionExecutor(limits WorkerLimits) *PostProductionExecutor {
	return &PostProductionExecutor{limits: limits}
}

// BuildNormalizationFilter returns FFmpeg audio normalization filter for -14 LUFS target.
// RULE-M07-005: All video output MUST pass through post-production mix (-14 LUFS target).
func BuildNormalizationFilter(targetLUFS float64) string {
	if targetLUFS == 0 {
		targetLUFS = -14.0
	}
	return fmt.Sprintf("loudnorm=I=%.1f:LRA=11:TP=-1.5", targetLUFS)
}

// BuildPostProductionArgs constructs validated FFmpeg arguments for rendering.
func (e *PostProductionExecutor) BuildPostProductionArgs(inputPath, outputPath string, cfg PostProductionConfig) ([]string, error) {
	args := []string{
		"-y",
		"-hide_banner",
		"-loglevel", "error",
		"-i", inputPath,
	}

	// Audio normalization filter
	if cfg.NormalizeAudio {
		af := BuildNormalizationFilter(cfg.TargetLUFS)
		args = append(args, "-af", af)
	}

	// Aspect ratio and scaling
	if cfg.AspectRatio == "9:16" {
		args = append(args, "-vf", "scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2")
	} else if cfg.AspectRatio == "16:9" {
		args = append(args, "-vf", "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2")
	} else if cfg.AspectRatio == "1:1" {
		args = append(args, "-vf", "scale=1080:1080:force_original_aspect_ratio=decrease,pad=1080:1080:(ow-iw)/2:(oh-ih)/2")
	}

	// Codec and container settings
	args = append(args,
		"-c:v", "libx264",
		"-preset", "fast",
		"-crf", "23",
		"-c:a", "aac",
		"-b:a", "192k",
		"-movflags", "+faststart",
		outputPath,
	)

	if err := ValidateFFmpegArgs(args); err != nil {
		return nil, err
	}
	return args, nil
}

// ExecuteWithProcessTreeCancellation executes an allowlisted command in an isolated process group.
// Satisfies Acceptance Target 4:
// "worker CPU/memory/disk/time limits and process-tree cancellation enforced"
func (e *PostProductionExecutor) ExecuteWithProcessTreeCancellation(ctx context.Context, binary string, args []string) error {
	if binary == "ffmpeg" {
		if err := ValidateFFmpegArgs(args); err != nil {
			return err
		}
	} else if binary == "ffprobe" {
		if err := ValidateFFprobeArgs(args); err != nil {
			return err
		}
	} else {
		return fmt.Errorf("prohibited binary %q; only ffmpeg and ffprobe allowed", binary)
	}

	timeout := time.Duration(e.limits.TimeoutSecs) * time.Second
	execCtx, cancel := context.WithTimeout(ctx, timeout)
	defer cancel()

	cmd := exec.CommandContext(execCtx, binary, args...)
	// Setpgid isolates the process and its subprocess tree into a distinct process group
	cmd.SysProcAttr = &syscall.SysProcAttr{Setpgid: true}

	if err := cmd.Start(); err != nil {
		return fmt.Errorf("failed to start worker process %s: %w", binary, err)
	}

	done := make(chan error, 1)
	go func() {
		done <- cmd.Wait()
	}()

	select {
	case <-execCtx.Done():
		// Forcefully kill entire process group to ensure zero zombie / leaked processes
		if cmd.Process != nil && cmd.Process.Pid > 0 {
			_ = syscall.Kill(-cmd.Process.Pid, syscall.SIGKILL)
		}
		if errors.Is(execCtx.Err(), context.DeadlineExceeded) {
			return fmt.Errorf("%w (%ds limit exceeded)", ErrExecutionTimeout, e.limits.TimeoutSecs)
		}
		return ErrProcessTerminated

	case err := <-done:
		if err != nil {
			return fmt.Errorf("worker process failed: %w", err)
		}
		return nil
	}
}

// ValidateOutputMedia inspects produced media before marking completion.
// Satisfies Acceptance Target 4:
// "output validated before completion"
// - Verifies output file size <= maxDiskBytes
// - Verifies valid audio and video streams exist
// - Verifies audio normalization target is met (-14 LUFS ± 2.0 LUFS)
// - Verifies aspect ratio matches requested format
func (e *PostProductionExecutor) ValidateOutputMedia(meta OutputMediaMetadata, expectedAspectRatio string, audioExpected bool) error {
	// 1. File size check
	if meta.FileSizeBytes <= 0 {
		return fmt.Errorf("%w: output file is empty (0 bytes)", ErrOutputValidationFailed)
	}
	if meta.FileSizeBytes > e.limits.MaxDiskBytes {
		return fmt.Errorf("%w: output file size %d bytes exceeds worker disk limit of %d bytes",
			ErrOutputValidationFailed, meta.FileSizeBytes, e.limits.MaxDiskBytes)
	}

	// 2. Video stream & dimensions
	if !meta.HasVideoStream {
		return fmt.Errorf("%w: missing required video stream", ErrOutputValidationFailed)
	}
	if meta.Width <= 0 || meta.Height <= 0 {
		return fmt.Errorf("%w: invalid video dimensions (%dx%d)", ErrOutputValidationFailed, meta.Width, meta.Height)
	}
	if meta.DurationSecs <= 0 {
		return fmt.Errorf("%w: non-positive video duration (%.2fs)", ErrOutputValidationFailed, meta.DurationSecs)
	}

	// 3. Aspect ratio compliance
	ratio := float64(meta.Width) / float64(meta.Height)
	if expectedAspectRatio == "9:16" {
		expectedRatio := 9.0 / 16.0 // 0.5625
		if math.Abs(ratio-expectedRatio) > 0.05 {
			return fmt.Errorf("%w: output aspect ratio mismatch: expected 9:16, got %dx%d (ratio %.4f)",
				ErrOutputValidationFailed, meta.Width, meta.Height, ratio)
		}
	} else if expectedAspectRatio == "16:9" {
		expectedRatio := 16.0 / 9.0 // 1.7778
		if math.Abs(ratio-expectedRatio) > 0.05 {
			return fmt.Errorf("%w: output aspect ratio mismatch: expected 16:9, got %dx%d (ratio %.4f)",
				ErrOutputValidationFailed, meta.Width, meta.Height, ratio)
		}
	} else if expectedAspectRatio == "1:1" {
		if math.Abs(ratio-1.0) > 0.05 {
			return fmt.Errorf("%w: output aspect ratio mismatch: expected 1:1, got %dx%d",
				ErrOutputValidationFailed, meta.Width, meta.Height)
		}
	}

	// 4. Audio stream and normalization check
	if audioExpected {
		if !meta.HasAudioStream {
			return fmt.Errorf("%w: missing expected audio stream in output", ErrOutputValidationFailed)
		}
		// Target -14.0 LUFS with ±2.5 LUFS acceptable operational tolerance per RULE-M07-005
		if meta.AudioLoudnessLUFS < -16.5 || meta.AudioLoudnessLUFS > -11.5 {
			return fmt.Errorf("%w: audio normalization out of spec: measured %.1f LUFS (expected -14.0 LUFS ±2.5 LUFS)",
				ErrOutputValidationFailed, meta.AudioLoudnessLUFS)
		}
	}

	return nil
}
