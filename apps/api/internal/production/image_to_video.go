package production

import (
	"errors"
	"fmt"
	"strings"

	productionv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/production/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// MotionStyleName converts ImageMotionStyle enum to canonical string.
func MotionStyleName(style productionv1.ImageMotionStyle) string {
	switch style {
	case productionv1.ImageMotionStyle_IMAGE_MOTION_STYLE_CINEMATIC_PAN:
		return "cinematic_pan"
	case productionv1.ImageMotionStyle_IMAGE_MOTION_STYLE_PRODUCT_ROTATE:
		return "product_rotate"
	case productionv1.ImageMotionStyle_IMAGE_MOTION_STYLE_PARALLAX_3D:
		return "parallax_3d"
	case productionv1.ImageMotionStyle_IMAGE_MOTION_STYLE_SUBTLE_MOVEMENT:
		return "subtle_movement"
	case productionv1.ImageMotionStyle_IMAGE_MOTION_STYLE_ZOOM_IN:
		return "zoom_in"
	case productionv1.ImageMotionStyle_IMAGE_MOTION_STYLE_CUSTOM_PROMPT:
		return "custom_prompt"
	case productionv1.ImageMotionStyle_IMAGE_MOTION_STYLE_KEN_BURNS:
		return "ken_burns"
	case productionv1.ImageMotionStyle_IMAGE_MOTION_STYLE_MORPH:
		return "morph"
	case productionv1.ImageMotionStyle_IMAGE_MOTION_STYLE_RANDOM:
		return "random"
	default:
		return "cinematic_pan"
	}
}

// EstimateImageToVideoCredits calculates credit cost based on quality tier and options.
func EstimateImageToVideoCredits(tier string, generateAIAutoMusic bool) tenantdb.ExactDecimal {
	base := 10 // standard
	switch strings.ToLower(strings.TrimSpace(tier)) {
	case "draft":
		base = 5
	case "premium":
		base = 25
	case "standard":
		base = 10
	default:
		base = 10
	}

	if generateAIAutoMusic {
		base += 5
	}

	return tenantdb.MustParseExactDecimal(fmt.Sprintf("%d.000000", base))
}

// ValidateImageToVideoConfig validates input parameters and returns warnings.
func ValidateImageToVideoConfig(cfg *productionv1.ImageToVideoConfig) ([]string, error) {
	if cfg == nil {
		return nil, errors.New("production: image_to_video_config is required")
	}

	images := cfg.GetImageUrls()
	if len(images) == 0 {
		return nil, errors.New("production: at least 1 image is required for image-to-video")
	}
	if len(images) > 20 {
		return nil, errors.New("production: maximum 20 images allowed for image-to-video conversion")
	}

	var warnings []string
	if len(images) == 1 {
		warnings = append(warnings, "Thêm ít nhất 1 ảnh nữa để tạo video trình chiếu sinh động hơn.")
	}

	duration := int(cfg.GetDurationSeconds())
	if duration > 0 && (duration < 3 || duration > 15) {
		warnings = append(warnings, "Thời lượng tối ưu cho video hoạt hóa từ ảnh là từ 3 đến 15 giây.")
	}

	if cfg.GetDefaultMotionStyle() == productionv1.ImageMotionStyle_IMAGE_MOTION_STYLE_MORPH && len(images) > 5 {
		warnings = append(warnings, "Hiệu ứng Morph AI hoạt động tự nhiên nhất khi số lượng ảnh từ 2 đến 4 hình có bố cục tương đồng.")
	}

	return warnings, nil
}
