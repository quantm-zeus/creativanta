package production

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"strings"
	"time"

	"connectrpc.com/connect"
	"google.golang.org/protobuf/types/known/timestamppb"

	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	productionv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/production/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/production/v1/productionv1connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

var _ productionv1connect.QuickEditServiceHandler = (*Service)(nil)

// ============================================================================
// QuickEditServiceHandler Implementation
// ============================================================================

// SaveDraft persists an in-progress quick edit draft.
// RBAC: Editor+ (production_job:manage).
func (s *Service) SaveDraft(
	ctx context.Context,
	req *connect.Request[productionv1.QuickEditServiceSaveDraftRequest],
) (*connect.Response[productionv1.QuickEditServiceSaveDraftResponse], error) {
	msg := req.Msg
	if msg.GetContext() == nil || msg.GetContext().GetWorkspaceId() == nil {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}

	wsID := msg.GetContext().GetWorkspaceId().GetValue()
	if wsID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("workspace_id required"))
	}

	caller := extractCallerContext(ctx, wsID)
	if !caller.HasRole("Editor") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	draftID := msg.GetDraftId()
	if draftID == "" {
		draftID = GenerateDeterministicID(fmt.Sprintf("draft-%s-%d", wsID, time.Now().UnixNano()))
	}

	// Calculate credit cost: 15 base + add-ons
	estCredits := s.CalculateQuickEditCost(msg.GetAddons())

	cuts := make([]CutIntervalRecord, 0, len(msg.GetCuts()))
	for _, c := range msg.GetCuts() {
		cuts = append(cuts, CutIntervalRecord{
			StartMS: c.GetStartMs(),
			EndMS:   c.GetEndMs(),
			Reason:  c.GetReason(),
		})
	}

	addons := msg.GetAddons()
	addonsCfg := QuickEditAddonsConfig{
		AutoCaptions:     addons.GetAutoCaptions(),
		CaptionStyle:     addons.GetCaptionStyle(),
		AddHook:          addons.GetAddHook(),
		HookID:           addons.GetHookId(),
		HookType:         addons.GetHookType(),
		BeatSync:         addons.GetBeatSync(),
		SoundID:          addons.GetSoundId(),
		BRoll:            addons.GetBRoll(),
		BRollScene:       addons.GetBRollScene(),
		PlatformPreset:   addons.GetPlatformPreset(),
		AudioEnhancement: addons.GetAudioEnhancement(),
		TargetLUFS:       addons.GetTargetLufs(),
		ReframeRatio:     addons.GetReframeRatio(),
	}

	name := msg.GetName()
	if name == "" {
		name = "Quick Edit Draft"
	}

	draftRecord := &QuickEditDraftRecord{
		DraftID:          draftID,
		WorkspaceID:      caller.WorkspaceID,
		AssetID:          msg.GetAssetId(),
		TranscriptID:     msg.GetTranscriptId(),
		Name:             name,
		Cuts:             cuts,
		Addons:           addonsCfg,
		EstimatedCredits: estCredits,
		CreatedBy:        caller.UserID,
		CreatedAt:        time.Now().UTC(),
		UpdatedAt:        time.Now().UTC(),
	}

	if err := s.store.SaveQuickEditDraft(ctx, draftRecord); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	protoDraft := &productionv1.QuickEditDraft{
		DraftId:          draftRecord.DraftID,
		WorkspaceId:      &commonv1.UUID{Value: draftRecord.WorkspaceID},
		AssetId:          draftRecord.AssetID,
		TranscriptId:     draftRecord.TranscriptID,
		Name:             draftRecord.Name,
		Cuts:             msg.GetCuts(),
		Addons:           msg.GetAddons(),
		EstimatedCredits: estCredits.String(),
		CreatedAt:        timestamppb.New(draftRecord.CreatedAt),
		UpdatedAt:        timestamppb.New(draftRecord.UpdatedAt),
	}

	return connect.NewResponse(&productionv1.QuickEditServiceSaveDraftResponse{
		Draft: protoDraft,
	}), nil
}

// CalculateQuickEditCost computes credits for Quick Edit: base 15 credits + add-ons.
func (s *Service) CalculateQuickEditCost(addons *productionv1.QuickEditAddons) tenantdb.ExactDecimal {
	baseCost, _ := tenantdb.ParseExactDecimal("15.000000") // Base quick edit: 15 credits
	if addons == nil {
		return baseCost
	}

	additional := 0
	if addons.GetAddHook() {
		additional += 3 // +3 credits for AI hook
	}
	if addons.GetBeatSync() {
		additional += 5 // +5 credits for beat sync
	}
	if addons.GetBRoll() {
		additional += 10 // +10 credits for B-roll generation
	}
	if addons.GetPlatformPreset() != "" {
		additional += 3 // +3 credits for platform preset
	}
	if addons.GetAudioEnhancement() {
		additional += 3 // +3 credits for audio enhancement
	}

	addonCost, _ := tenantdb.ParseExactDecimal(fmt.Sprintf("%d.000000", additional))
	total, _ := baseCost.Add(addonCost)
	return total
}

// ListSoundLibrary delegates to SoundStudioManager for sound library browsing.
func (s *Service) ListSoundLibrary(
	ctx context.Context,
	req *connect.Request[productionv1.SoundStudioServiceListSoundLibraryRequest],
) (*connect.Response[productionv1.SoundStudioServiceListSoundLibraryResponse], error) {
	return s.SoundStudio.ListSoundLibrary(ctx, req)
}

// ============================================================================
// Smart Hook Library (50+ Curated Hooks across 6 Categories)
// ============================================================================

// GetSmartHookLibrary returns 60 battle-tested hooks across 6 categories.
func GetSmartHookLibrary() []HookItem {
	return []HookItem{
		// 1. Question (10 hooks)
		{"hook_q_01", "Bạn có đang mắc phải 3 sai lầm này khi làm video?", "question", 9.2, "library"},
		{"hook_q_02", "Tại sao 90% creator bỏ cuộc chỉ sau 1 tháng?", "question", 8.8, "library"},
		{"hook_q_03", "Làm sao để kiếm 1000 đơn đầu tiên từ video ngắn?", "question", 9.4, "library"},
		{"hook_q_04", "Điều gì xảy ra nếu bạn đăng video liên tục 30 ngày?", "question", 8.5, "library"},
		{"hook_q_05", "Bí quyết giữ chân người xem 3 giây đầu là gì?", "question", 9.1, "library"},
		{"hook_q_06", "Liệu công cụ AI này có thể thay thế hoàn toàn editor?", "question", 8.9, "library"},
		{"hook_q_07", "Có bao giờ bạn tự hỏi tại sao video người khác luôn viral?", "question", 8.4, "library"},
		{"hook_q_08", "Đây là cách chuyên gia làm content, bạn đã biết chưa?", "question", 8.7, "library"},
		{"hook_q_09", "Serum này có thực sự thần thánh như lời đồn không?", "question", 8.6, "library"},
		{"hook_q_10", "Ai bảo làm affiliate TikTok Shop bây giờ đã quá muộn?", "question", 9.0, "library"},

		// 2. Shock (10 hooks)
		{"hook_sh_01", "Dừng lại ngay! Bạn đang đốt tiền vào quảng cáo vô ích.", "shock", 9.6, "library"},
		{"hook_sh_02", "Sự thật gây sốc về thuật toán đề xuất năm 2026.", "shock", 9.3, "library"},
		{"hook_sh_03", "Đừng bao giờ làm video kiểu này nếu không muốn bị bóp tương tác!", "shock", 9.5, "library"},
		{"hook_sh_04", "Đây là bí mật các agency triệu đô không muốn bạn biết.", "shock", 9.4, "library"},
		{"hook_sh_05", "Tôi đã mất 50 triệu chỉ vì một sai lầm ngớ ngẩn này.", "shock", 9.1, "library"},
		{"hook_sh_06", "Cảnh báo khẩn cấp cho tất cả các nhà sáng tạo nội dung!", "shock", 8.9, "library"},
		{"hook_sh_07", "Thương hiệu lớn đang âm thầm dùng chiêu này để hút khách.", "shock", 8.8, "library"},
		{"hook_sh_08", "Không thể tin được kết quả sau 7 ngày áp dụng công thức này.", "shock", 9.0, "library"},
		{"hook_sh_09", "Bỏ ngay thói quen này trước khi kênh của bạn bị đóng băng vĩnh viễn.", "shock", 9.2, "library"},
		{"hook_sh_10", "Cú lừa ngoạn mục trong ngành bán hàng online bạn cần cảnh giác!", "shock", 9.3, "library"},

		// 3. Story (10 hooks)
		{"hook_st_01", "Từ một người không dám nói trước ống kính, tôi đã làm điều này...", "story", 8.9, "library"},
		{"hook_st_02", "Cách tôi biến 500k tiền vốn thành kênh TikTok 100k follow.", "story", 9.2, "library"},
		{"hook_st_03", "Ngày đầu tiên khởi nghiệp tôi đã khóc vì đơn hàng số không...", "story", 8.7, "library"},
		{"hook_st_04", "Một câu nói của khách hàng đã thay đổi hoàn toàn cách tôi làm sản phẩm.", "story", 8.8, "library"},
		{"hook_st_05", "Hành trình 90 ngày tự học edit video từ con số 0.", "story", 8.5, "library"},
		{"hook_st_06", "Tôi đã từng nghĩ mình không có duyên bán hàng cho đến khi gặp người này.", "story", 8.9, "library"},
		{"hook_st_07", "Câu chuyện đằng sau clip 5 triệu view đưa doanh thu chạm đỉnh.", "story", 9.4, "library"},
		{"hook_st_08", "Bị gia đình phản đối kịch liệt, tôi đã chứng minh bằng kết quả này.", "story", 8.6, "library"},
		{"hook_st_09", "Khi tôi chuẩn bị bỏ cuộc thì điều kỳ diệu này đã xảy ra.", "story", 8.8, "library"},
		{"hook_st_10", "Tôi đã từ bỏ công việc văn phòng 8 tiếng để chọn con đường này như thế nào?", "story", 8.7, "library"},

		// 4. POV (10 hooks)
		{"hook_pov_01", "POV: Bạn vừa tìm thấy chiếc tool AI tự động cắt hết từ đệm trong 3 giây.", "pov", 9.5, "library"},
		{"hook_pov_02", "POV: Khi sếp bảo bạn làm 10 video trong một buổi chiều.", "pov", 9.1, "library"},
		{"hook_pov_03", "POV: Khách hàng hỏi sao giá đắt thế và đây là cách bạn trả lời.", "pov", 8.8, "library"},
		{"hook_pov_04", "POV: Video đăng lên lúc nửa đêm và sáng dậy thấy nổ 100 đơn.", "pov", 9.3, "library"},
		{"hook_pov_05", "POV: Bạn phát hiện ra bí mật edit video của các idol TikTok.", "pov", 9.0, "library"},
		{"hook_pov_06", "POV: Buổi sáng của một solo creator quản lý 5 kênh cùng lúc.", "pov", 8.7, "library"},
		{"hook_pov_07", "POV: Cảm giác khi video đầu tiên cán mốc 1 triệu view.", "pov", 8.9, "library"},
		{"hook_pov_08", "POV: Bạn nhận được hợp đồng tài trợ đầu tiên trong đời.", "pov", 8.6, "library"},
		{"hook_pov_09", "POV: Khi đối thủ sao chép content của bạn nhưng không sao chép được thần thái.", "pov", 9.2, "library"},
		{"hook_pov_10", "POV: Trải nghiệm ăn ngủ cùng studio để chuẩn bị cho siêu sale.", "pov", 8.5, "library"},

		// 5. Listicle (10 hooks)
		{"hook_li_01", "Top 5 website miễn phí giúp bạn làm content chuyên nghiệp hơn cả agency.", "listicle", 9.4, "library"},
		{"hook_li_02", "3 bước đơn giản biến video thô thành kiệt tác triệu view.", "listicle", 9.2, "library"},
		{"hook_li_03", "4 công thức viết caption giữ chân người xem đến giây cuối cùng.", "listicle", 8.9, "library"},
		{"hook_li_04", "5 món phụ kiện dưới 500k biến góc quay bình thường thành studio triệu đô.", "listicle", 9.0, "library"},
		{"hook_li_05", "3 chỉ số quan trọng nhất quyết định video của bạn có lên xu hướng hay không.", "listicle", 9.3, "library"},
		{"hook_li_06", "7 nguồn âm nhạc không bản quyền cực chill dành cho dân vlog.", "listicle", 8.8, "library"},
		{"hook_li_07", "4 kiểu mở đầu video khiến người lướt qua phải dừng lại xem ngay lập tức.", "listicle", 9.5, "library"},
		{"hook_li_08", "5 lỗi sai cơ bản khi set up ánh sáng làm da bị xỉn màu.", "listicle", 8.7, "library"},
		{"hook_li_09", "3 chiêu tâm lý học bán hàng giúp khách chốt đơn không do dự.", "listicle", 9.1, "library"},
		{"hook_li_10", "6 thói quen giúp bạn sản xuất 30 video mỗi tháng mà không bị kiệt sức.", "listicle", 8.9, "library"},

		// 6. Contrast (10 hooks)
		{"hook_co_01", "Người mới dùng timeline cắt gọt mất cả tiếng, chuyên gia chỉ gạch text 10 giây.", "contrast", 9.5, "library"},
		{"hook_co_02", "Video 1 triệu view và video 100 view khác nhau đúng 3 giây đầu tiên này.", "contrast", 9.4, "library"},
		{"hook_co_03", "Trong khi bạn đang loay hoay tìm ý tưởng, họ đã lên lịch tự động cho cả tuần.", "contrast", 8.9, "library"},
		{"hook_co_04", "Người nghiệp dư nói về tính năng, người bán đỉnh cao nói về cảm xúc.", "contrast", 9.1, "library"},
		{"hook_co_05", "Đừng chi 20 triệu mua máy ảnh xịn, chỉ cần đổi góc sáng này là điện thoại đẹp hơn.", "contrast", 9.2, "library"},
		{"hook_co_06", "Cách làm video năm 2024 vs cách làm video bứt phá năm 2026.", "contrast", 8.8, "library"},
		{"hook_co_07", "Kênh nhiều follow chưa chắc nhiều tiền, kênh ít follow mà biết làm funnel này mới đỉnh.", "contrast", 9.3, "library"},
		{"hook_co_08", "Nói nhiều không bằng nói trúng: Bí quyết rút ngắn kịch bản mà chuyển đổi tăng gấp 3.", "contrast", 9.0, "library"},
		{"hook_co_09", "Cùng một sản phẩm nhưng một bên bán được 1000 cái còn một bên ế ẩm vì lý do này.", "contrast", 9.2, "library"},
		{"hook_co_10", "Khác biệt giữa creator kiếm tiền lẻ và creator xây dựng doanh nghiệp truyền thông.", "contrast", 8.7, "library"},
	}
}

// GetHooksByCategory returns hooks filtered by hook category.
func GetHooksByCategory(cat string) []HookItem {
	all := GetSmartHookLibrary()
	if cat == "" {
		return all
	}
	var res []HookItem
	for _, h := range all {
		if strings.EqualFold(h.HookType, cat) {
			res = append(res, h)
		}
	}
	return res
}

// GenerateDeterministicID produces a stable pseudo-random ID for testing.
func GenerateDeterministicID(seed string) string {
	sum := sha256.Sum256([]byte(seed))
	hexStr := hex.EncodeToString(sum[:])
	return fmt.Sprintf("%s-%s-%s-%s-%s", hexStr[0:8], hexStr[8:12], hexStr[12:16], hexStr[16:20], hexStr[20:32])
}
