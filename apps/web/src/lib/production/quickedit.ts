// Quick Edit Web Domain Engine (W022 - M07)
// Canonical Sources: docs/02_features/production/ai_video_studio.md
//                    docs/03_screens/web/screen_web_studio_quick_edit.md

export interface TranscriptWord {
	wordId: string;
	text: string;
	startMs: number;
	endMs: number;
	confidence: number;
	isFiller: boolean;
	fillerType?: string;
	isDeleted: boolean;
}

export interface DeadPause {
	startMs: number;
	endMs: number;
	durationMs: number;
}

export interface TranscriptAnalysis {
	fillerCount: number;
	pauseCount: number;
	hookQualityScore: number;
	estimatedTimeSavedMs: number;
	finalDurationMs: number;
	detectedFillers: string[];
	deadPauses: DeadPause[];
	hookFeedback: string;
}

export interface QuickEditAddons {
	autoCaptions: boolean;
	captionStyle: 'bounce' | 'karaoke' | 'highlight' | 'typewriter';
	addHook: boolean;
	hookType: 'question' | 'shock' | 'story' | 'pov' | 'listicle' | 'contrast';
	hookId?: string;
	beatSync: boolean;
	soundGenre: 'chill' | 'upbeat' | 'dramatic' | 'electronic' | 'acoustic' | 'tech_pulse';
	bRoll: boolean;
	platformPreset: 'none' | 'tiktok' | 'youtube_shorts' | 'reels';
	audioEnhancement: boolean;
	targetLufs: number; // default -14.0 LUFS per RULE-M07-005
	reframeRatio: '9:16' | '16:9' | '1:1';
}

export interface CutInterval {
	startMs: number;
	endMs: number;
	reason: string;
}

export interface SmartHook {
	hookId: string;
	hookText: string;
	hookType: 'question' | 'shock' | 'story' | 'pov' | 'listicle' | 'contrast';
	effectivenessScore: number;
}

// Calculate Quick Edit credits: Base 15 credits + add-ons
export function calculateQuickEditCredits(addons: QuickEditAddons): {
	baseCredits: number;
	addonCredits: number;
	totalCredits: number;
} {
	const baseCredits = 15;
	let addonCredits = 0;

	if (addons.addHook) addonCredits += 3;
	if (addons.beatSync) addonCredits += 5;
	if (addons.bRoll) addonCredits += 10;
	if (addons.platformPreset !== 'none') addonCredits += 3;
	if (addons.audioEnhancement) addonCredits += 3;

	return {
		baseCredits,
		addonCredits,
		totalCredits: baseCredits + addonCredits
	};
}

// Vietnamese and English filler dictionary
const FILLER_WORDS = new Set([
	'ừm', 'à', 'ờ', 'kiểu', 'thì là', 'như là', 'thì', 'là', 'nói chung là', 'cái này',
	'um', 'uh', 'like', 'you know', 'basically', 'actually', 'sort of', 'kind of'
]);

export function isFillerWord(text: string): boolean {
	const clean = text.toLowerCase().replace(/[^a-z0-9àáảãạăằắẳẵặâầấẩẫậèéẻẽẹêềếểễệìíỉĩịòóỏõọôồốổỗộơờớởỡợùúủũụưừứửữựỳýỷỹỵđ\s]/gi, '').trim();
	return FILLER_WORDS.has(clean);
}

// Parse words, detect fillers, extract pauses, evaluate hook
export function analyzeTranscriptClient(words: TranscriptWord[], minPauseMs = 1500): {
	taggedWords: TranscriptWord[];
	analysis: TranscriptAnalysis;
} {
	const taggedWords: TranscriptWord[] = [];
	const detectedFillers: string[] = [];
	const deadPauses: DeadPause[] = [];
	let prevEndMs = 0;

	for (let i = 0; i < words.length; i++) {
		const w = { ...words[i] };
		if (isFillerWord(w.text)) {
			w.isFiller = true;
			detectedFillers.push(w.text);
		}

		if (i > 0 && w.startMs > prevEndMs) {
			const gap = w.startMs - prevEndMs;
			if (gap >= minPauseMs) {
				deadPauses.push({
					startMs: prevEndMs,
					endMs: w.startMs,
					durationMs: gap
				});
			}
		}

		prevEndMs = w.endMs;
		taggedWords.push(w);
	}

	// Calculate hook score (0-10) based on first 3 seconds
	let hookScore = 7.0;
	let hookFeedback = 'Mở đầu tương đối tốt';
	const first3sWords = taggedWords.filter((w) => w.startMs <= 3000);
	const first3sText = first3sWords.map((w) => w.text.toLowerCase()).join(' ');

	if (first3sWords.some((w) => w.isFiller)) {
		hookScore -= 2.0;
	}
	if (first3sText.includes('?') || first3sText.includes('tại sao') || first3sText.includes('làm sao')) {
		hookScore += 2.5;
	}
	if (first3sText.includes('đừng') || first3sText.includes('bí mật') || first3sText.includes('cảnh báo')) {
		hookScore += 1.5;
	}
	if (hookScore > 10.0) hookScore = 10.0;
	if (hookScore < 1.0) hookScore = 1.0;

	if (hookScore >= 8.5) {
		hookFeedback = 'Hook rất mạnh: mở đầu dứt khoát, kích thích tò mò cao';
	} else if (hookScore < 5.0) {
		hookFeedback = 'Mở đầu hơi chậm hoặc có filler words, nên cắt đoạn thừa đầu video';
	}

	// Calculate saved time
	let savedMs = 0;
	for (const w of taggedWords) {
		if (w.isFiller || w.isDeleted) {
			savedMs += (w.endMs - w.startMs);
		}
	}
	for (const p of deadPauses) {
		savedMs += p.durationMs;
	}

	const totalMs = words.length > 0 ? words[words.length - 1].endMs : 0;
	const finalDurationMs = Math.max(0, totalMs - savedMs);

	return {
		taggedWords,
		analysis: {
			fillerCount: detectedFillers.length,
			pauseCount: deadPauses.length,
			hookQualityScore: Number(hookScore.toFixed(1)),
			estimatedTimeSavedMs: savedMs,
			finalDurationMs,
			detectedFillers,
			deadPauses,
			hookFeedback
		}
	};
}

// Build coalesced cut intervals from deletions, fillers and pauses
export function buildCutIntervals(
	words: TranscriptWord[],
	pauses: DeadPause[],
	removeFillers: boolean,
	removePauses: boolean,
	coalesceThresholdMs = 80
): CutInterval[] {
	const rawCuts: CutInterval[] = [];

	for (const w of words) {
		if (w.isDeleted) {
			rawCuts.push({ startMs: w.startMs, endMs: w.endMs, reason: 'deleted_text' });
		} else if (removeFillers && w.isFiller) {
			rawCuts.push({ startMs: w.startMs, endMs: w.endMs, reason: 'filler' });
		}
	}

	if (removePauses) {
		for (const p of pauses) {
			rawCuts.push({ startMs: p.startMs, endMs: p.endMs, reason: 'pause' });
		}
	}

	if (rawCuts.length <= 1) {
		return rawCuts;
	}

	// Sort by startMs
	rawCuts.sort((a, b) => a.startMs - b.startMs);

	const merged: CutInterval[] = [];
	let current = { ...rawCuts[0] };

	for (let i = 1; i < rawCuts.length; i++) {
		const next = rawCuts[i];
		if (next.startMs <= current.endMs + coalesceThresholdMs) {
			if (next.endMs > current.endMs) {
				current.endMs = next.endMs;
			}
			current.reason = `${current.reason}+${next.reason}`;
		} else {
			merged.push(current);
			current = { ...next };
		}
	}
	merged.push(current);

	return merged;
}

// Invert cuts against total duration to compute retained playback duration and prove zero drift
export function computeRetainedTimeline(
	totalDurationMs: number,
	cuts: CutInterval[]
): {
	retainedSegments: { startMs: number; endMs: number; durationMs: number }[];
	timeSavedMs: number;
	finalDurationMs: number;
	hasZeroDrift: boolean;
} {
	const retainedSegments: { startMs: number; endMs: number; durationMs: number }[] = [];
	let cursor = 0;
	let timeSavedMs = 0;

	for (const cut of cuts) {
		const cStart = Math.max(0, cut.startMs);
		const cEnd = Math.min(totalDurationMs, cut.endMs);
		if (cStart >= cEnd) continue;

		if (cStart > cursor) {
			retainedSegments.push({
				startMs: cursor,
				endMs: cStart,
				durationMs: cStart - cursor
			});
		}

		timeSavedMs += (cEnd - cStart);
		cursor = cEnd;
	}

	if (cursor < totalDurationMs) {
		retainedSegments.push({
			startMs: cursor,
			endMs: totalDurationMs,
			durationMs: totalDurationMs - cursor
		});
	}

	const finalDurationMs = totalDurationMs - timeSavedMs;
	const sumRetained = retainedSegments.reduce((acc, s) => acc + s.durationMs, 0);

	const hasZeroDrift = sumRetained === finalDurationMs && (sumRetained + timeSavedMs === totalDurationMs);

	return {
		retainedSegments,
		timeSavedMs,
		finalDurationMs,
		hasZeroDrift
	};
}

// Repair word transcript per EC-M07-Q01
export function repairWordTranscript(
	words: TranscriptWord[],
	wordId: string,
	newText: string,
	newStartMs?: number,
	newEndMs?: number
): {
	words: TranscriptWord[];
	error?: string;
	fallbackMode?: boolean;
} {
	const updated = words.map((w) => {
		if (w.wordId !== wordId) return { ...w };
		return {
			...w,
			text: newText,
			startMs: newStartMs !== undefined ? newStartMs : w.startMs,
			endMs: newEndMs !== undefined ? newEndMs : w.endMs,
			isFiller: isFillerWord(newText)
		};
	});

	// Validate alignment
	for (let i = 0; i < updated.length; i++) {
		const w = updated[i];
		if (w.startMs >= w.endMs) {
			return {
				words: updated,
				error: 'Auto-alignment failed. [Try segment mode] or [Manual cut].',
				fallbackMode: true
			};
		}
		if (i > 0 && w.startMs < updated[i - 1].startMs) {
			return {
				words: updated,
				error: 'Auto-alignment failed. [Try segment mode] or [Manual cut].',
				fallbackMode: true
			};
		}
	}

	return {
		words: updated,
		fallbackMode: false
	};
}

// Curated Smart Hook Library samples for UI
export const SAMPLE_SMART_HOOKS: SmartHook[] = [
	{ hookId: 'hook_q_01', hookText: 'Bạn có đang mắc phải 3 sai lầm này khi làm video?', hookType: 'question', effectivenessScore: 9.2 },
	{ hookId: 'hook_sh_01', hookText: 'Dừng lại ngay! Bạn đang đốt tiền vào quảng cáo vô ích.', hookType: 'shock', effectivenessScore: 9.6 },
	{ hookId: 'hook_st_01', hookText: 'Từ một người không dám nói trước ống kính, tôi đã làm điều này...', hookType: 'story', effectivenessScore: 8.9 },
	{ hookId: 'hook_pov_01', hookText: 'POV: Bạn vừa tìm thấy chiếc tool AI tự động cắt hết từ đệm trong 3 giây.', hookType: 'pov', effectivenessScore: 9.5 },
	{ hookId: 'hook_li_01', hookText: 'Top 5 website miễn phí giúp bạn làm content chuyên nghiệp hơn cả agency.', hookType: 'listicle', effectivenessScore: 9.4 },
	{ hookId: 'hook_co_01', hookText: 'Người mới dùng timeline cắt gọt mất cả tiếng, chuyên gia chỉ gạch text 10 giây.', hookType: 'contrast', effectivenessScore: 9.5 }
];
