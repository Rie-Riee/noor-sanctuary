import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class VideoPlayerDetailScreen extends StatefulWidget {
  final String title;
  final String speaker;
  final String category;
  final String duration;
  final String imageUrl;

  const VideoPlayerDetailScreen({
    super.key,
    this.title = 'Menata Hati Menghadapi Takdir & Ketetapan Ilahi',
    this.speaker = 'Ustadz Dr. Firanda Andirja, M.A.',
    this.category = 'Tazkiyatun Nafs',
    this.duration = '45:10',
    this.imageUrl = 'https://lh3.googleusercontent.com/aida-public/AB6AXuAzMYHUOXTR1QbuHGbaobxIY6z97DGxR80d6Qis-SPBTuXmPk-ytGM5LopnrMTSKH0YG75y4Z3itBwfhe0Yc4bdnb8o3YZB-C5KxCvpP8XtFqqIg4wthKmeD3BUKxOKGvjMPVQ5mdTrieFAxDW98SM_8skamYU1D_xkgdu3BdvPGDDlEEtZu16lXQJLejGCxIldy5x5GoOy1yCR8i4nGT9F5p2DqNC-Q1muakg71S8',
  });

  @override
  State<VideoPlayerDetailScreen> createState() => _VideoPlayerDetailScreenState();
}

class _VideoPlayerDetailScreenState extends State<VideoPlayerDetailScreen> {
  bool _isPlaying = true;
  bool _isAudioOnly = false;
  bool _isBookmarked = false;
  bool _isFollowing = false;
  double _progress = 0.41; // 18:24 of 45:10
  int _speedIndex = 0;
  final List<String> _speeds = ['1.0x', '1.25x', '1.5x', '0.75x'];
  int _activeSegmentTab = 0; // 0: Transkrip, 1: Bookmark, 2: Rangkuman, 3: Terkait
  final TextEditingController _noteController = TextEditingController();
  final List<String> _savedNotes = [];

  void _cycleSpeed() {
    setState(() {
      _speedIndex = (_speedIndex + 1) % _speeds.length;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kecepatan putar diatur ke ${_speeds[_speedIndex]}'),
        duration: const Duration(milliseconds: 900),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _saveNote() {
    final note = _noteController.text.trim();
    if (note.isEmpty) return;
    setState(() {
      _savedNotes.insert(0, '[18:24] $note');
      _noteController.clear();
    });
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Catatan faedah berhasil disimpan ke jurnal qolbu!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _copyAyat(String ayatText) {
    Clipboard.setData(ClipboardData(text: ayatText));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lafadz ayat & faedah disalin ke papan klip!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 850;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Video Player Detail',
          style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: _isAudioOnly ? 'Mode Video' : 'Mode Audio Saja',
            icon: Icon(_isAudioOnly ? Icons.videocam : Icons.headphones, size: 22),
            onPressed: () {
              setState(() => _isAudioOnly = !_isAudioOnly);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(_isAudioOnly ? 'Mode Audio Saja aktif (hemat kuota).' : 'Kembali ke mode video HD.')),
              );
            },
          ),
          IconButton(
            tooltip: 'Simpan',
            icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border, size: 22),
            onPressed: () {
              setState(() => _isBookmarked = !_isBookmarked);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(_isBookmarked ? 'Kajian disimpan ke daftar faedah.' : 'Dihapus dari daftar faedah.')),
              );
            },
          ),
          IconButton(
            tooltip: 'Bagikan',
            icon: const Icon(Icons.share, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tautan kajian berhasil disalin!')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 1200 : 640),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                isDesktop ? 24 : 16,
                isDesktop ? 16 : 8,
                isDesktop ? 24 : 16,
                isDesktop ? 40 : 100,
              ),
              child: isDesktop
                  // DESKTOP RESPONSIVE 2-COLUMN VIEW
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 58,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _build16x9PlayerContainer(),
                              const SizedBox(height: 18),
                              _buildTitleAndSpeakerCard(),
                              const SizedBox(height: 14),
                              _buildActionPillsRow(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 42,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSegmentTabs(),
                              const SizedBox(height: 16),
                              _buildActiveSegmentContent(),
                              const SizedBox(height: 16),
                              _buildQuickNoteBar(),
                            ],
                          ),
                        ),
                      ],
                    )
                  // MOBILE SINGLE COLUMN VERTICAL FLOW
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _build16x9PlayerContainer(),
                        const SizedBox(height: 16),
                        _buildTitleAndSpeakerCard(),
                        const SizedBox(height: 12),
                        _buildActionPillsRow(),
                        const SizedBox(height: 18),
                        _buildSegmentTabs(),
                        const SizedBox(height: 16),
                        _buildActiveSegmentContent(),
                        const SizedBox(height: 18),
                        _buildQuickNoteBar(),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 1. CINEMATIC VIDEO PLAYER CONTAINER (16:9)
  // ==========================================
  Widget _build16x9PlayerContainer() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            children: [
              // Background Video Image / Audio Artwork
              Positioned.fill(
                child: _isAudioOnly
                    ? Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryContainer],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.headphones, size: 54, color: AppColors.primaryFixed),
                              const SizedBox(height: 10),
                              Text(
                                'Mode Audio Saja (320kbps Hifi)',
                                style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                              Text(
                                'Hemat kuota data • Bebas gangguan layar',
                                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/kajian_1.png', fit: BoxFit.cover),
                      ),
              ),

              // Gradient Scrim
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withAlpha(160),
                        Colors.transparent,
                        Colors.black.withAlpha(200),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.4, 1.0],
                    ),
                  ),
                ),
              ),

              // Top Floating Utility Badges
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(140),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Audio Hifi 320kbps',
                            style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () => setState(() => _isAudioOnly = !_isAudioOnly),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _isAudioOnly ? AppColors.primary : Colors.black.withAlpha(140),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.headphones, size: 13, color: AppColors.primaryFixed),
                                const SizedBox(width: 4),
                                Text(
                                  _isAudioOnly ? 'Mode Video' : 'Mode Audio Saja',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(color: Colors.black.withAlpha(140), shape: BoxShape.circle),
                          child: const Icon(Icons.picture_in_picture_alt, size: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Center Play/Pause Button
              Center(
                child: GestureDetector(
                  onTap: () => setState(() => _isPlaying = !_isPlaying),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withAlpha(220),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(60),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Controls Toolbar
              Positioned(
                bottom: 8,
                left: 12,
                right: 12,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Scrubbing Timeline Slider
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 3.5,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                        activeTrackColor: AppColors.primaryFixed,
                        inactiveTrackColor: Colors.white30,
                        thumbColor: AppColors.primaryFixed,
                      ),
                      child: Slider(
                        value: _progress,
                        onChanged: (v) => setState(() => _progress = v),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '18:24 / ${widget.duration}',
                          style: GoogleFonts.spaceGrotesk(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text('1080p HD', style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: _cycleSpeed,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                child: Text(
                                  _speeds[_speedIndex],
                                  style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.fullscreen, size: 20, color: Colors.white),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 2. LECTURE TITLE & SPEAKER METADATA
  // ==========================================
  Widget _buildTitleAndSpeakerCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_stories, size: 13, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    widget.category,
                    style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.tertiaryFixed,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified, size: 12, color: AppColors.tertiary),
                  const SizedBox(width: 3),
                  Text(
                    'Sanad Shahih',
                    style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.onTertiaryFixed),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                const SizedBox(width: 4),
                Text('100% Bebas Iklan', style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.secondary)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          widget.title,
          style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.onSurface, height: 1.3),
        ),
        const SizedBox(height: 12),

        // Speaker Bio Card
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryFixed,
                child: const Icon(Icons.person, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.speaker,
                            style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.check_circle, size: 14, color: AppColors.primary),
                      ],
                    ),
                    Text(
                      'Pemateri Dewan Asatidzah • Madinah Alumni',
                      style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.secondary),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFollowing ? AppColors.surfaceContainerHigh : AppColors.primary,
                  foregroundColor: _isFollowing ? AppColors.primary : Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  textStyle: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                  elevation: 0,
                ),
                onPressed: () {
                  setState(() => _isFollowing = !_isFollowing);
                },
                child: Text(_isFollowing ? 'Mengikuti' : 'Ikuti'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Audience Stats
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              const Icon(Icons.visibility, size: 13, color: AppColors.secondary),
              const SizedBox(width: 4),
              Text('42.5k Jamaah', style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.secondary)),
              const Text(' • ', style: TextStyle(color: AppColors.outlineVariant)),
              const Icon(Icons.calendar_today, size: 13, color: AppColors.secondary),
              const SizedBox(width: 4),
              Text('14 Ramadhan 1445 H', style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.secondary)),
              const Spacer(),
              const Icon(Icons.verified_user, size: 13, color: AppColors.primary),
              const SizedBox(width: 4),
              Text('Shahih Fiqh', style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.primary)),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 3. INTERACTIVE ACTION ROW
  // ==========================================
  Widget _buildActionPillsRow() {
    final actions = [
      {'icon': Icons.download, 'label': 'Unduh Offline'},
      {'icon': Icons.playlist_add, 'label': 'Simpan Faedah'},
      {'icon': Icons.menu_book, 'label': 'Kutipan Dalil'},
      {'icon': Icons.share, 'label': 'Sebar Kebaikan'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: actions.map((a) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              avatar: Icon(a['icon'] as IconData, size: 15, color: AppColors.primary),
              label: Text(a['label'] as String),
              labelStyle: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.onSurface),
              backgroundColor: AppColors.surfaceContainerHigh,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${a['label']} dipilih.')),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================
  // 4. SEGMENT TABS
  // ==========================================
  Widget _buildSegmentTabs() {
    final tabs = ['Transkrip & Dalil', 'Bookmark Waktu', 'Rangkuman', 'Terkait'];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: List.generate(tabs.length, (idx) {
          final isSel = idx == _activeSegmentTab;
          return Expanded(
            child: InkWell(
              onTap: () => setState(() => _activeSegmentTab = idx),
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSel ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    tabs[idx],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: isSel ? FontWeight.w700 : FontWeight.w600,
                      color: isSel ? Colors.white : AppColors.secondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ==========================================
  // 5. INTERACTIVE TRANSCRIPT & HIGHLIGHT
  // ==========================================
  Widget _buildActiveSegmentContent() {
    if (_activeSegmentTab == 1) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(18)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bookmark Waktu Tersimpan', style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
            const SizedBox(height: 8),
            _buildTranscriptSegment('05:40', 'Kepasrahan versus tawakkal hakiki.'),
            _buildTranscriptSegment('18:20', 'Kaidah Al-Insyirah 6: Dua kemudahan mengalahkan satu kesulitan.'),
          ],
        ),
      );
    } else if (_activeSegmentTab == 2) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(18)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rangkuman Intisari Kajian', style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
            const SizedBox(height: 6),
            Text(
              '1. Setiap musibah membawa kasih sayang terselubung.\n2. Makrifah vs nakirah dalam QS. Al-Insyirah menegaskan kepastian jalan keluar.\n3. Bangun husnudzan sejak detik pertama takdir dihadapkan.',
              style: GoogleFonts.plusJakartaSans(fontSize: 12, height: 1.5, color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      );
    } else if (_activeSegmentTab == 3) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(18)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kajian Rekomendasi Terkait', style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
            const SizedBox(height: 8),
            Text('• Tafsir Surah Ar-Rahman — Merengkuh Kasih Sayang Ilahi (Ust. Firanda)', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.primary)),
            const SizedBox(height: 6),
            Text('• Fiqih Sabar & Ridho dalam Ujian Berat (Ust. Salim A. Fillah)', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.primary)),
          ],
        ),
      );
    }

    // Default: Transkrip & Dalil
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text('SINKRONISASI REALTIME', style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.0, color: AppColors.primary)),
              ],
            ),
            Text('Bahasa Indonesia • Arab Naskh', style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.secondary)),
          ],
        ),
        const SizedBox(height: 10),

        // Timeline Segment 1: [05:40]
        _buildTranscriptSegment(
          '05:40',
          '“Banyak manusia keliru membedakan antara kepasrahan yang bermakna kemalasan dan tawakkal yang hakiki. Tawakkal selalu menuntut ikhtiar maksimal dari raga, sembari hati bersandar bulat kepada Ar-Rahman.”',
        ),

        // Timeline Segment 2: [12:05]
        _buildTranscriptSegment(
          '12:05',
          '“Kaidah pertama saat ditimpa musibah yang mendadak: bangun husnudzan bahwa di balik takdir yang terasa pahit tersimpan hikmah yang amat luas yang kelak membuatmu bersujud syukur.”',
        ),

        // Timeline Segment 3: CURRENT ACTIVE TIMESTAMP [18:20] HIGHLIGHT CARD
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryFixed.withAlpha(90),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary.withAlpha(120), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        const Icon(Icons.graphic_eq, size: 13, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          '18:20 • Sedang Berjalan',
                          style: GoogleFonts.spaceGrotesk(fontSize: 10.5, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.content_copy, size: 16, color: AppColors.primary),
                        onPressed: () => _copyAyat('إِنَّ مَعَ الْعُسْرِ يُسْرًا\n"Sesungguhnya sesudah kesulitan itu ada kemudahan." (QS. Al-Insyirah: 6)'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark, size: 16, color: AppColors.primary),
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Faedah ayat ini ditandai.'))),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Sacred Arabic Calligraphy Block
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Text(
                      'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: AppTheme.quranArabic(fontSize: 22),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'QS. Al-Insyirah [94]: Ayat 6',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                    Text(
                      '“Sesungguhnya sesudah kesulitan itu ada kemudahan.”',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontStyle: FontStyle.italic, color: AppColors.secondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text: 'Penjelasan Ustadz: ',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                  children: [
                    TextSpan(
                      text: 'Perhatikan bahwa kata al-\'usr (kesulitan) menggunakan bentuk ma\'rifah (tertentu), sedangkan kata yusran (kemudahan) berbentuk nakirah (tak terbatas). Satu kesulitan tidak akan pernah mampu mengalahkan dua limpahan kemudahan Allah.',
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.normal, color: AppColors.onSurface, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Timeline Segment 4: [24:15]
        _buildTranscriptSegment(
          '24:15',
          '“Bagaimana para sahabat terdahulu mengkondisikan jiwa saat doanya belum terkabul dalam hitungan bulan maupun tahun...”',
        ),
      ],
    );
  }

  Widget _buildTranscriptSegment(String timestamp, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    const Icon(Icons.play_circle, size: 12, color: AppColors.onSecondaryContainer),
                    const SizedBox(width: 4),
                    Text(timestamp, style: GoogleFonts.spaceGrotesk(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.onSecondaryContainer)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.bookmark_add_outlined, size: 16, color: AppColors.secondary),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Menit $timestamp dibookmark.'))),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(text, style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.onSurfaceVariant, height: 1.4)),
        ],
      ),
    );
  }

  // ==========================================
  // 6. BOTTOM PERSISTENT QUICK NOTE BAR
  // ==========================================
  Widget _buildQuickNoteBar() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.hairline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle),
            child: const Icon(Icons.edit_note, color: AppColors.onPrimaryContainer, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _noteController,
              style: GoogleFonts.plusJakartaSans(fontSize: 12),
              decoration: InputDecoration(
                hintText: 'Tulis refleksi faedah pada menit 18:24...',
                hintStyle: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                border: InputBorder.none,
                isDense: true,
              ),
              onSubmitted: (_) => _saveNote(),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              textStyle: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
            ),
            onPressed: _saveNote,
            child: const Text('Catat'),
          ),
        ],
      ),
    );
  }
}
