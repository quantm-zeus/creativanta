<script lang="ts">
	import type { SoundTrackItem } from '$lib/production';

	type SoundTab = 'music_gen' | 'beat_sync' | 'speech_to_song' | 'sfx';

	let activeTab: SoundTab = 'music_gen';

	// Music form state
	let prompt = 'Ambient corporate background music with soft piano and warm synth';
	let genre = 'ambient';
	let mood = 'chill';
	let durationSeconds = 30;
	let bpm = 120;
	let licenseType = 'commercial_royalty_free';
	let confirmRightsHolder = true;

	// SFX form state
	let sfxPrompt = 'Cinematic whoosh with deep bass drop';
	let sfxCategory = 'cinematic';

	// Beat sync state
	let selectedAudioName = 'Product_Video_Voiceover.mp3';
	let detectedBpm = 124;
	let tempoConfidence = 96;
	let beatMarkers = [0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0];
	let downbeats = [0.5, 2.5, 4.5];

	// Playback state
	let isPlaying = false;
	let currentPlaybackTime = 0;
	let volume = 80;
	let autoDuckingEnabled = true;

	// Measured quote calculations
	$: musicQuoteCredits = 8;
	$: sfxQuoteCredits = 5;

	// Mock track library & generated tracks
	let tracks: SoundTrackItem[] = [
		{
			trackId: 'track-bgm-01',
			workspaceId: 'ws-studio',
			title: 'Sunset Drive (Lo-fi Chill)',
			category: 'music',
			genre: 'lo-fi',
			mood: 'chill',
			bpm: 85,
			durationSeconds: 45,
			fileUrl: 'https://cdn.creativanta.test/sound/sunset_drive.mp3',
			licenseType: 'commercial_royalty_free',
			licenseId: 'CREATIVANTA-BGM-LIC-001',
			isVerifiedLicense: true,
			waveformPeaks: [0.2, 0.4, 0.7, 0.9, 0.8, 0.6, 0.5, 0.8, 0.95, 0.7, 0.4, 0.2],
			createdAt: '2026-10-30T10:00:00Z'
		},
		{
			trackId: 'track-bgm-02',
			workspaceId: 'ws-studio',
			title: 'Apex Rush (Synthwave)',
			category: 'music',
			genre: 'synthwave',
			mood: 'energetic',
			bpm: 128,
			durationSeconds: 60,
			fileUrl: 'https://cdn.creativanta.test/sound/apex_rush.mp3',
			licenseType: 'commercial_royalty_free',
			licenseId: 'CREATIVANTA-BGM-LIC-002',
			isVerifiedLicense: true,
			waveformPeaks: [0.3, 0.6, 0.85, 0.95, 0.9, 0.8, 0.75, 0.9, 1.0, 0.8, 0.5, 0.3],
			createdAt: '2026-10-30T11:30:00Z'
		},
		{
			trackId: 'track-sfx-01',
			workspaceId: 'ws-studio',
			title: 'Subtle UI Click & Chime',
			category: 'sfx',
			genre: 'ui',
			mood: 'minimal',
			bpm: 120,
			durationSeconds: 2,
			fileUrl: 'https://cdn.creativanta.test/sound/click_chime.mp3',
			licenseType: 'cc0_commercial',
			licenseId: 'CREATIVANTA-SFX-LIC-003',
			isVerifiedLicense: true,
			waveformPeaks: [0.8, 0.6, 0.3, 0.1],
			createdAt: '2026-10-30T12:00:00Z'
		}
	];

	let currentTrack: SoundTrackItem = tracks[0];
	let isGenerating = false;
	let generationSuccessMessage = '';

	function handleGenerateMusic() {
		if (!confirmRightsHolder) {
			alert('Vui lòng xác nhận quyền sử dụng và điều khoản âm thanh bản quyền trước khi tạo.');
			return;
		}
		isGenerating = true;
		setTimeout(() => {
			const newTrack: SoundTrackItem = {
				trackId: `track-music-${Date.now()}`,
				workspaceId: 'ws-studio',
				title: `AI Music: ${genre.toUpperCase()} (${mood})`,
				category: 'music',
				genre,
				mood,
				bpm,
				durationSeconds,
				fileUrl: 'https://cdn.creativanta.test/sound/gen_sample.mp3',
				licenseType: 'commercial_royalty_free',
				licenseId: `CREATIVANTA-BGM-LIC-${Date.now()}`,
				isVerifiedLicense: true,
				waveformPeaks: [0.2, 0.5, 0.8, 0.9, 0.7, 0.6, 0.8, 0.95, 0.6, 0.4, 0.2],
				createdAt: new Date().toISOString()
			};
			tracks = [newTrack, ...tracks];
			currentTrack = newTrack;
			isGenerating = false;
			generationSuccessMessage = `Tạo thành công bản nhạc "${newTrack.title}" (-14 LUFS, 8 credits đã trừ).`;
		}, 600);
	}

	function handleGenerateSFX() {
		isGenerating = true;
		setTimeout(() => {
			const newSfx: SoundTrackItem = {
				trackId: `track-sfx-${Date.now()}`,
				workspaceId: 'ws-studio',
				title: `SFX: ${sfxPrompt.slice(0, 24)}`,
				category: 'sfx',
				genre: sfxCategory,
				mood: 'action',
				bpm: 120,
				durationSeconds: 4,
				fileUrl: 'https://cdn.creativanta.test/sound/sfx_sample.mp3',
				licenseType: 'cc0_commercial',
				licenseId: `CREATIVANTA-SFX-LIC-${Date.now()}`,
				isVerifiedLicense: true,
				waveformPeaks: [0.9, 0.7, 0.4, 0.2],
				createdAt: new Date().toISOString()
			};
			tracks = [newSfx, ...tracks];
			currentTrack = newSfx;
			isGenerating = false;
			generationSuccessMessage = `Tạo thành công hiệu ứng âm thanh (5 credits đã trừ).`;
		}, 500);
	}

	function selectTrack(track: SoundTrackItem) {
		currentTrack = track;
		isPlaying = false;
	}

	function togglePlay() {
		isPlaying = !isPlaying;
	}
</script>

<svelte:head>
	<title>AI Sound Studio (W028) | Creativanta</title>
</svelte:head>

<div class="min-h-screen bg-slate-950 text-slate-100 p-6 md:p-8">
	<!-- Header -->
	<div class="max-w-7xl mx-auto mb-8 flex flex-col md:flex-row md:items-center md:justify-between gap-4 border-b border-slate-800 pb-6">
		<div>
			<div class="flex items-center gap-3">
				<span class="text-3xl">🎵</span>
				<h1 class="text-2xl md:text-3xl font-bold tracking-tight">AI Sound Studio</h1>
				<span class="text-xs bg-indigo-500/20 text-indigo-300 border border-indigo-500/30 px-2 py-0.5 rounded-full font-mono">W028 · EF-06</span>
			</div>
			<p class="text-slate-400 text-sm mt-1">Soạn nhạc nền bản quyền, hiệu ứng âm thanh SFX, đồng bộ nhịp phách (Beat Sync) chuẩn -14 LUFS.</p>
		</div>

		<!-- Studio Sub-Navigation Tabs -->
		<div class="flex items-center gap-1 bg-slate-900 border border-slate-800 p-1 rounded-xl">
			<button
				class="px-3.5 py-1.5 rounded-lg text-sm font-medium transition-all {activeTab === 'music_gen' ? 'bg-indigo-600 text-white shadow' : 'text-slate-400 hover:text-white'}"
				on:click={() => (activeTab = 'music_gen')}
			>
				🎼 Tạo Nhạc Nền
			</button>
			<button
				class="px-3.5 py-1.5 rounded-lg text-sm font-medium transition-all {activeTab === 'beat_sync' ? 'bg-indigo-600 text-white shadow' : 'text-slate-400 hover:text-white'}"
				on:click={() => (activeTab = 'beat_sync')}
			>
				🥁 Beat Sync
			</button>
			<button
				class="px-3.5 py-1.5 rounded-lg text-sm font-medium transition-all {activeTab === 'speech_to_song' ? 'bg-indigo-600 text-white shadow' : 'text-slate-400 hover:text-white'}"
				on:click={() => (activeTab = 'speech_to_song')}
			>
				🎤 Speech-to-Song
			</button>
			<button
				class="px-3.5 py-1.5 rounded-lg text-sm font-medium transition-all {activeTab === 'sfx' ? 'bg-indigo-600 text-white shadow' : 'text-slate-400 hover:text-white'}"
				on:click={() => (activeTab = 'sfx')}
			>
				⚡ Sound Effects
			</button>
		</div>
	</div>

	{#if generationSuccessMessage}
		<div class="max-w-7xl mx-auto mb-6 bg-emerald-950/40 border border-emerald-500/40 p-4 rounded-xl flex items-center justify-between text-emerald-200 text-sm">
			<div class="flex items-center gap-2">
				<span class="text-emerald-400">✓</span>
				<span>{generationSuccessMessage}</span>
			</div>
			<button class="text-xs text-emerald-400 hover:underline" on:click={() => (generationSuccessMessage = '')}>Đóng</button>
		</div>
	{/if}

	<!-- Main Workspace Grid -->
	<div class="max-w-7xl mx-auto grid grid-cols-1 lg:grid-cols-12 gap-8">
		<!-- Left Column: Studio Controls (7 cols) -->
		<div class="lg:col-span-7 space-y-6">
			{#if activeTab === 'music_gen'}
				<!-- Music Generator Card -->
				<div class="bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-xl space-y-5">
					<div class="flex items-center justify-between">
						<h2 class="font-semibold text-lg flex items-center gap-2">
							<span>🎹</span> Soạn Nhạc Nền AI (Stable Audio / MusicGen)
						</h2>
						<span class="text-xs font-semibold px-2.5 py-1 bg-amber-500/20 text-amber-300 border border-amber-500/30 rounded-md">
							Báo giá: {musicQuoteCredits} Credits
						</span>
					</div>

					<div>
						<label for="music-prompt" class="block text-xs font-medium text-slate-300 mb-1.5">Mô tả phong cách nhạc (Prompt)</label>
						<textarea
							id="music-prompt"
							bind:value={prompt}
							rows="3"
							class="w-full bg-slate-950 border border-slate-700 rounded-xl p-3 text-sm text-slate-100 placeholder-slate-500 focus:outline-none focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 transition-all"
							placeholder="VD: Upbeat electronic house beat with catchy synth melody for e-commerce unboxing..."
						></textarea>
					</div>

					<div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
						<div>
							<label for="music-genre" class="block text-xs font-medium text-slate-300 mb-1.5">Thể loại (Genre)</label>
							<select
								id="music-genre"
								bind:value={genre}
								class="w-full bg-slate-950 border border-slate-700 rounded-xl px-3 py-2 text-sm text-slate-200 focus:outline-none focus:border-indigo-500"
							>
								<option value="ambient">Ambient / Background</option>
								<option value="lo-fi">Lo-Fi Hip-Hop</option>
								<option value="synthwave">Synthwave / Retro</option>
								<option value="corporate">Corporate / Tech</option>
								<option value="cinematic">Cinematic Epic</option>
								<option value="upbeat_pop">Upbeat Pop</option>
							</select>
						</div>

						<div>
							<label for="music-mood" class="block text-xs font-medium text-slate-300 mb-1.5">Cảm xúc (Mood)</label>
							<select
								id="music-mood"
								bind:value={mood}
								class="w-full bg-slate-950 border border-slate-700 rounded-xl px-3 py-2 text-sm text-slate-200 focus:outline-none focus:border-indigo-500"
							>
								<option value="chill">Chill & Thư giãn</option>
								<option value="energetic">Năng động & Hứng khởi</option>
								<option value="inspiring">Truyền cảm hứng</option>
								<option value="dramatic">Kịch tính & Gay cấn</option>
								<option value="playful">Vui tươi & Trẻ trung</option>
							</select>
						</div>
					</div>

					<div class="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-2">
						<div>
							<div class="flex justify-between text-xs text-slate-300 mb-1">
								<span>Thời lượng</span>
								<span class="font-mono text-indigo-400">{durationSeconds}s</span>
							</div>
							<input
								type="range"
								min="10"
								max="120"
								step="5"
								bind:value={durationSeconds}
								class="w-full accent-indigo-500"
							/>
						</div>

						<div>
							<div class="flex justify-between text-xs text-slate-300 mb-1">
								<span>Nhịp độ (BPM)</span>
								<span class="font-mono text-indigo-400">{bpm} BPM</span>
							</div>
							<input
								type="range"
								min="60"
								max="160"
								step="2"
								bind:value={bpm}
								class="w-full accent-indigo-500"
							/>
						</div>
					</div>

					<!-- Licensed Input & Terms (Acceptance Target 3) -->
					<div class="p-3.5 bg-slate-950/70 border border-slate-800 rounded-xl space-y-2.5">
						<div class="flex items-center justify-between text-xs">
							<span class="font-semibold text-slate-300 flex items-center gap-1.5">
								<span>🛡️</span> Giấy phép bản quyền (Licensing)
							</span>
							<span class="px-2 py-0.5 bg-emerald-500/20 text-emerald-300 border border-emerald-500/30 rounded text-[11px] font-mono">
								Commercial Royalty-Free
							</span>
						</div>
						<p class="text-xs text-slate-400 leading-relaxed">
							Âm thanh tạo ra từ Creativanta Sound Studio được cấp mã bản quyền thương mại vĩnh viễn, an toàn chống bản quyền tự động trên TikTok, YouTube Shorts và Meta Ads.
						</p>
						<label class="flex items-center gap-2.5 text-xs text-slate-300 cursor-pointer pt-1">
							<input type="checkbox" bind:checked={confirmRightsHolder} class="accent-indigo-500 rounded" />
							<span>Tôi xác nhận sử dụng nhạc nền cho mục đích thương mại hợp pháp và đồng ý điều khoản bản quyền.</span>
						</label>
					</div>

					<!-- Action Buttons -->
					<div class="pt-2 flex items-center justify-between">
						<div class="text-xs text-slate-400">
							Chuẩn âm thanh: <span class="font-mono text-slate-300">-14 LUFS (EBU R128)</span>
						</div>
						<button
							disabled={isGenerating || !confirmRightsHolder}
							on:click={handleGenerateMusic}
							class="px-5 py-2.5 bg-indigo-600 hover:bg-indigo-500 disabled:opacity-50 text-white font-medium text-sm rounded-xl shadow-lg transition-all flex items-center gap-2"
						>
							{#if isGenerating}
								<span class="animate-spin text-sm">⏳</span> Đang soạn nhạc...
							{:else}
								<span>✨</span> Tạo Nhạc Nền ({musicQuoteCredits} Credits)
							{/if}
						</button>
					</div>
				</div>

			{:else if activeTab === 'beat_sync'}
				<!-- Beat Sync Card -->
				<div class="bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-xl space-y-5">
					<div class="flex items-center justify-between">
						<h2 class="font-semibold text-lg flex items-center gap-2">
							<span>🥁</span> Tự Động Khớp Nhịp Video (Beat Sync)
						</h2>
						<span class="text-xs font-mono text-emerald-400 bg-emerald-500/10 px-2 py-1 rounded">
							Miễn phí phân tích (0 Cr)
						</span>
					</div>

					<p class="text-sm text-slate-400">
						Tự động phân tích phách mạnh (Downbeat), nhịp điệu (BPM) và đề xuất điểm cắt cảnh (Suggested Cut Points) theo tiết tấu nhạc.
					</p>

					<div class="p-4 bg-slate-950 border border-slate-800 rounded-xl space-y-3">
						<div class="flex items-center justify-between text-sm">
							<span class="text-slate-300">File âm thanh đang phân tích:</span>
							<span class="font-mono text-indigo-400 font-semibold">{selectedAudioName}</span>
						</div>
						<div class="grid grid-cols-2 sm:grid-cols-3 gap-3 pt-2">
							<div class="p-3 bg-slate-900/80 rounded-lg border border-slate-800/80">
								<div class="text-xs text-slate-400">Tốc độ (BPM)</div>
								<div class="text-xl font-bold font-mono text-indigo-300">{detectedBpm}</div>
							</div>
							<div class="p-3 bg-slate-900/80 rounded-lg border border-slate-800/80">
								<div class="text-xs text-slate-400">Độ tin cậy nhịp</div>
								<div class="text-xl font-bold font-mono text-emerald-300">{tempoConfidence}%</div>
							</div>
							<div class="p-3 bg-slate-900/80 rounded-lg border border-slate-800/80 col-span-2 sm:col-span-1">
								<div class="text-xs text-slate-400">Điểm cắt đề xuất</div>
								<div class="text-xl font-bold font-mono text-amber-300">{beatMarkers.length} cues</div>
							</div>
						</div>
					</div>

					<!-- Visual Beat Markers -->
					<div class="space-y-2">
						<div class="text-xs text-slate-400 flex justify-between">
							<span>Sơ đồ nhịp phách timeline</span>
							<span class="text-slate-500">Màu vàng: Downbeat · Màu tím: Beat</span>
						</div>
						<div class="h-10 bg-slate-950 rounded-lg p-2 flex items-center gap-1.5 border border-slate-800 overflow-x-auto">
							{#each beatMarkers as marker, idx}
								<div
									class="h-full rounded-sm flex items-end justify-center text-[9px] font-mono px-1 transition-all {downbeats.includes(marker) ? 'bg-amber-500 text-slate-950 font-bold w-6' : 'bg-indigo-500/50 text-indigo-200 w-4'}"
									title="Điểm phách {marker}s"
								>
									{idx + 1}
								</div>
							{/each}
						</div>
					</div>

					<button
						class="w-full py-2.5 bg-slate-800 hover:bg-slate-700 text-slate-200 text-sm font-medium rounded-xl border border-slate-700 transition-all flex items-center justify-center gap-2"
					>
						<span>✂️</span> Áp dụng điểm cắt nhịp vào Timeline Video Studio
					</button>
				</div>

			{:else if activeTab === 'speech_to_song'}
				<!-- Speech to Song Card -->
				<div class="bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-xl space-y-5">
					<div class="flex items-center justify-between">
						<h2 class="font-semibold text-lg flex items-center gap-2">
							<span>🎤</span> Biến Giọng Nói Thành Giai Điệu (Speech-to-Song)
						</h2>
						<span class="text-xs font-semibold px-2.5 py-1 bg-amber-500/20 text-amber-300 border border-amber-500/30 rounded-md">
							Báo giá: 10 Credits
						</span>
					</div>

					<p class="text-sm text-slate-400">
						Tự động điều chỉnh cao độ (Pitch correction & Auto-tune) của lời thoại thoại bán hàng và ghép giai điệu nhạc nền jingle bắt tai.
					</p>

					<div class="p-4 bg-slate-950 border border-slate-800 rounded-xl space-y-3">
						<label for="sts-style" class="block text-xs font-medium text-slate-300">Chọn phong cách jingle:</label>
						<select id="sts-style" class="w-full bg-slate-900 border border-slate-700 rounded-xl px-3 py-2 text-sm text-slate-200">
							<option>Commercial Jingle (Vui tươi, bắt tai)</option>
							<option>Acoustic Folk (Ấm áp, mộc mạc)</option>
							<option>R&B Hook (Thời thượng, cuốn hút)</option>
						</select>
					</div>

					<button
						class="px-5 py-2.5 bg-indigo-600 hover:bg-indigo-500 text-white font-medium text-sm rounded-xl shadow-lg transition-all flex items-center gap-2"
					>
						<span>✨</span> Tạo Audio Jingle (10 Credits)
					</button>
				</div>

			{:else if activeTab === 'sfx'}
				<!-- SFX Generator Card -->
				<div class="bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-xl space-y-5">
					<div class="flex items-center justify-between">
						<h2 class="font-semibold text-lg flex items-center gap-2">
							<span>⚡</span> Tạo Hiệu Ứng Âm Thanh (AI Sound Effects)
						</h2>
						<span class="text-xs font-semibold px-2.5 py-1 bg-amber-500/20 text-amber-300 border border-amber-500/30 rounded-md">
							Báo giá: {sfxQuoteCredits} Credits
						</span>
					</div>

					<div>
						<label for="sfx-prompt" class="block text-xs font-medium text-slate-300 mb-1.5">Mô tả hiệu ứng âm thanh</label>
						<input
							id="sfx-prompt"
							type="text"
							bind:value={sfxPrompt}
							class="w-full bg-slate-950 border border-slate-700 rounded-xl p-3 text-sm text-slate-100 placeholder-slate-500 focus:outline-none focus:border-indigo-500"
							placeholder="VD: Heavy sword slice, futuristic laser blast, cash register ka-ching..."
						/>
					</div>

					<div>
						<label for="sfx-cat" class="block text-xs font-medium text-slate-300 mb-1.5">Nhóm hiệu ứng</label>
						<select
							id="sfx-cat"
							bind:value={sfxCategory}
							class="w-full bg-slate-950 border border-slate-700 rounded-xl px-3 py-2 text-sm text-slate-200 focus:outline-none focus:border-indigo-500"
						>
							<option value="cinematic">Cinematic (Impact, Whoosh, Rise)</option>
							<option value="commerce">Thương mại (Ka-ching, Pop, Notification)</option>
							<option value="nature">Tự nhiên & Môi trường (Gió, mưa, sóng biển)</option>
							<option value="ui">Giao diện (Click, Swish, Toggle)</option>
						</select>
					</div>

					<div class="pt-2 flex items-center justify-between">
						<span class="text-xs text-slate-400">Giấy phép: <strong class="text-slate-300">CC0 Public Domain</strong></span>
						<button
							disabled={isGenerating}
							on:click={handleGenerateSFX}
							class="px-5 py-2.5 bg-indigo-600 hover:bg-indigo-500 disabled:opacity-50 text-white font-medium text-sm rounded-xl shadow-lg transition-all flex items-center gap-2"
						>
							{#if isGenerating}
								<span class="animate-spin text-sm">⏳</span> Đang tạo SFX...
							{:else}
								<span>✨</span> Tạo SFX ({sfxQuoteCredits} Credits)
							{/if}
						</button>
					</div>
				</div>
			{/if}

			<!-- Waveform Preview Player (Free 0-Credit Preview per W028) -->
			<div class="bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-xl space-y-4">
				<div class="flex items-center justify-between">
					<div class="flex items-center gap-2">
						<span class="text-lg">🎧</span>
						<h3 class="font-semibold text-sm text-slate-200">Trình Phát & Nghe Thử Âm Thanh</h3>
					</div>
					<span class="text-[11px] font-mono px-2 py-0.5 bg-emerald-500/20 text-emerald-300 border border-emerald-500/30 rounded">
						Nghe thử miễn phí (0 Cr)
					</span>
				</div>

				<div class="p-4 bg-slate-950 border border-slate-800 rounded-xl space-y-3">
					<div class="flex items-center justify-between text-xs">
						<span class="font-medium text-slate-200 truncate max-w-xs">{currentTrack.title}</span>
						<span class="font-mono text-slate-400">{currentTrack.durationSeconds}s · {currentTrack.bpm} BPM</span>
					</div>

					<!-- Visual Waveform Display -->
					<div class="h-16 flex items-center justify-between gap-1 px-2 py-1 bg-slate-900/60 rounded-lg">
						{#each currentTrack.waveformPeaks as peak}
							<div
								class="w-full bg-indigo-500 hover:bg-indigo-400 rounded-sm transition-all"
								style="height: {Math.max(15, peak * 100)}%;"
							></div>
						{/each}
					</div>

					<!-- Playback Controls -->
					<div class="flex items-center justify-between gap-4 pt-1">
						<button
							on:click={togglePlay}
							class="w-10 h-10 rounded-full bg-indigo-600 hover:bg-indigo-500 text-white flex items-center justify-center shadow transition-all"
							aria-label={isPlaying ? 'Tạm dừng' : 'Phát nhạc'}
						>
							{#if isPlaying}
								<span>⏸</span>
							{:else}
								<span>▶</span>
							{/if}
						</button>

						<!-- Volume & Auto-Ducking -->
						<div class="flex items-center gap-6 text-xs text-slate-400">
							<div class="flex items-center gap-2">
								<span>🔊</span>
								<input
									type="range"
									min="0"
									max="100"
									bind:value={volume}
									class="w-20 accent-indigo-500"
									aria-label="Âm lượng"
								/>
								<span class="font-mono w-7 text-right">{volume}%</span>
							</div>

							<label class="flex items-center gap-2 cursor-pointer text-slate-300">
								<input type="checkbox" bind:checked={autoDuckingEnabled} class="accent-indigo-500 rounded" />
								<span>Auto-Ducking (-18 dB)</span>
							</label>
						</div>
					</div>
				</div>
			</div>
		</div>

		<!-- Right Column: Sound Library & Licensing (5 cols) -->
		<div class="lg:col-span-5 space-y-6">
			<div class="bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-xl space-y-4">
				<div class="flex items-center justify-between">
					<h3 class="font-semibold text-sm text-slate-200 flex items-center gap-2">
						<span>📚</span> Thư Viện Bản Nhạc Đã Tạo ({tracks.length})
					</h3>
					<span class="text-xs text-slate-400">Bản quyền đã cấp</span>
				</div>

				<div class="space-y-2.5 max-h-[520px] overflow-y-auto pr-1">
					{#each tracks as track}
						<div
							class="p-3.5 rounded-xl border transition-all cursor-pointer {track.trackId === currentTrack.trackId ? 'bg-indigo-950/40 border-indigo-500/60 shadow-md' : 'bg-slate-950/60 border-slate-800/80 hover:border-slate-700'}"
							on:click={() => selectTrack(track)}
							on:keydown={(e) => e.key === 'Enter' && selectTrack(track)}
							tabindex="0"
							role="button"
						>
							<div class="flex items-start justify-between gap-2">
								<div>
									<div class="text-sm font-semibold text-slate-100 flex items-center gap-1.5">
										<span>{track.category === 'music' ? '🎵' : '⚡'}</span>
										<span class="truncate">{track.title}</span>
									</div>
									<div class="text-xs text-slate-400 mt-0.5">
										{track.genre} · {track.mood} · {track.durationSeconds}s · {track.bpm} BPM
									</div>
								</div>
								{#if track.isVerifiedLicense}
									<span class="text-[10px] font-mono bg-emerald-500/10 text-emerald-400 border border-emerald-500/30 px-1.5 py-0.5 rounded">
										Verified
									</span>
								{/if}
							</div>

							<div class="mt-2.5 flex items-center justify-between text-[11px] text-slate-500 font-mono border-t border-slate-800/60 pt-2">
								<span>{track.licenseId}</span>
								<span class="text-indigo-400 hover:underline">Phát thử ▷</span>
							</div>
						</div>
					{/each}
				</div>
			</div>

			<!-- Quality & Loudness Invariant Box -->
			<div class="p-4 bg-indigo-950/20 border border-indigo-500/30 rounded-2xl text-xs space-y-2 text-slate-300">
				<div class="font-semibold text-indigo-300 flex items-center gap-1.5">
					<span>ℹ️</span> Tiêu Chuẩn Hậu Kỳ Âm Thanh (Acceptance Target 2)
				</div>
				<ul class="space-y-1 list-disc list-inside text-slate-400">
					<li>Tất cả bản nhạc xuất xưởng đều tự động chuẩn hóa về <strong class="text-slate-200">-14 LUFS</strong> theo chuẩn EBU R128.</li>
					<li>Bộ lọc khử nhiễu tự động và cân bằng âm lượng (True Peak dưới -1.0 dBFS).</li>
					<li>Tự động hạ âm lượng nhạc nền (Auto-ducking -18 dB) khi phát hiện đoạn có giọng đọc thoại.</li>
				</ul>
			</div>
		</div>
	</div>
</div>
