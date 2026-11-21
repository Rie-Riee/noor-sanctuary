import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../data/quran_dataset.dart';
import 'mushaf_reader_screen.dart';
import 'katalog_tilawah_juz_screen.dart';
import 'juz_amma_hafalan_screen.dart';
import 'murottal_audio_sanctuary_screen.dart';
import 'ai_tartil_evaluation_screen.dart';
import 'tajwid_tracing_screen.dart';
import '../search/universal_search_sheet.dart';

class QuranTabScreen extends StatefulWidget {
  final VoidCallback? onProfileTap;

  const QuranTabScreen({super.key, this.onProfileTap});

  @override
  State<QuranTabScreen> createState() => _QuranTabScreenState();
}

class _QuranTabScreenState extends State<QuranTabScreen> {
  int _topSegmentIndex = 0; // 0: Surah (114), 1: Juz (30), 2: Hafalan & AI Mic
  int _selectedFilter = 0; // 0: Semua, 1: Makkiyyah, 2: Madaniyyah, 3: Surah Pilihan
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _savedHikmah = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSurahTap(SurahModel surah) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MushafReaderScreen(surah: surah),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredSurahs = kQuranSurahs.where((s) {
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesName = s.name.toLowerCase().contains(query);
        final matchesMeaning = s.meaning.toLowerCase().contains(query);
        final matchesNumber = s.number.toString().contains(query);
        if (!matchesName && !matchesMeaning && !matchesNumber) return false;
      }

      if (_selectedFilter == 1) return s.type.toLowerCase().contains('makki');
      if (_selectedFilter == 2) return s.type.toLowerCase().contains('madani');
      if (_selectedFilter == 3) {
        return [1, 18, 36, 55, 56, 67, 78].contains(s.number);
      }
      return true;
    }).toList();

    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 850;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 1240 : 640),
            child: Scrollbar(
              thumbVisibility: isDesktop,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  isDesktop ? 32 : 18,
                  isDesktop ? 20 : 12,
                  isDesktop ? 32 : 18,
                  isDesktop ? 50 : 170, // Clearance for mobile floating dock
                ),
                child: isDesktop
                    // DESKTOP RESPONSIVE TWO-COLUMN VIEW
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column (flex: 52): Header, Search, Hero Tilawah, AI Tartil, Hikmah
                          Expanded(
                            flex: 52,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDesktopHeader(),
                                const SizedBox(height: 18),
                                _buildSearchAndSegments(),
                                const SizedBox(height: 18),
                                _buildLanjutkanTilawahCard(),
                                const SizedBox(height: 18),
                                _buildAiTartilCard(),
                                const SizedBox(height: 20),
                                _buildHikmahKalamullahCard(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 28),
                          // Right Column (flex: 48): Khazanah 4 Cards & Daftar Surah
                          Expanded(
                            flex: 48,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildKhazanahQuickAccess(),
                                const SizedBox(height: 22),
                                _buildSurahListSection(filteredSurahs),
                              ],
                            ),
                          ),
                        ],
                      )
                    // MOBILE SINGLE COLUMN VERTICAL FLOW
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMobileHeader(),
                          const SizedBox(height: 16),
                          _buildSearchAndSegments(),
                          const SizedBox(height: 18),
                          _buildLanjutkanTilawahCard(),
                          const SizedBox(height: 18),
                          _buildAiTartilCard(),
                          const SizedBox(height: 20),
                          _buildKhazanahQuickAccess(),
                          const SizedBox(height: 22),
                          _buildSurahListSection(filteredSurahs),
                          const SizedBox(height: 20),
                          _buildHikmahKalamullahCard(),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // DESKTOP TOP HEADER (Clean, no duplicate app bar)
  // ==========================================
  Widget _buildDesktopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Qur\'an Sanctuary & Tilawah',
                  style: GoogleFonts.syne(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryFixed,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '✦ 30 Juz Madinah',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Tartil, Talaqqi Qari, Hafalan Juz \'Amma & Tafsir Tematik Rujukan Shahih',
              style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.secondary),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // MOBILE TOP BAR (NOOR Qur'An Sanctuary)
  // ==========================================
  Widget _buildMobileHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryFixed,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.menu_book, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'NOOR',
                      style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    ),
                  ],
                ),
                Text(
                  'Qur\'An Sanctuary',
                  style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.search, color: AppColors.primary, size: 22),
              onPressed: () => showUniversalSearch(context),
            ),
            IconButton(
              icon: const Icon(Icons.bookmark_outline, color: AppColors.secondary, size: 22),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Membuka Penanda Baca & Terakhir Dibaca...')),
                );
              },
            ),
            const SizedBox(width: 4),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onProfileTap,
              child: Tooltip(
                message: 'Lihat Profil Pengguna',
                child: CircleAvatar(
                  radius: 17,
                  backgroundColor: AppColors.primaryFixed,
                  child: const Icon(Icons.person, color: AppColors.primary, size: 18),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // SEARCH & TOP SEGMENTS (Surah | Juz | Hafalan)
  // ==========================================
  Widget _buildSearchAndSegments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.surfaceContainerHigh),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(5),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Cari Surah, Ayat, Juz, atau Topik...',
              hintStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.secondary.withAlpha(160)),
              prefixIcon: const Icon(Icons.search, color: AppColors.secondary, size: 20),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.mic, color: AppColors.primary, size: 20),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AiTartilEvaluationScreen()),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.tune, color: AppColors.secondary, size: 18),
                    onPressed: () {
                      setState(() {
                        _selectedFilter = (_selectedFilter + 1) % 4;
                      });
                    },
                  ),
                ],
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: _buildTopSegment(
                index: 0,
                label: 'Surah (114)',
                icon: Icons.format_list_bulleted,
                onTap: () => setState(() => _topSegmentIndex = 0),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTopSegment(
                index: 1,
                label: 'Juz (30)',
                icon: Icons.menu_book,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const KatalogTilawahJuzScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTopSegment(
                index: 2,
                label: 'Hafalan & AI',
                icon: Icons.auto_awesome,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const JuzAmmaHafalanScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // HERO CARD: LANJUTKAN TILAWAH (Surah An-Naba')
  // ==========================================
  Widget _buildLanjutkanTilawahCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF3F1FD), Color(0xFFE8E5FB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.primary.withAlpha(50)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(20),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'LANJUTKAN TILAWAH',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withAlpha(6), blurRadius: 4),
                  ],
                ),
                child: Text(
                  'Juz 30 • Halaman 582',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Surah An-Naba\'',
                      style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.primary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Ayat 1–2 • Berita Besar',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.secondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'النبأ',
                style: AppTheme.quranArabic(fontSize: 32).copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Preview Arabic verse quote
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surfaceContainerHigh),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'عَمَّ يَتَسَآءَلُونَ ﴿١﴾ عَنِ النَّبَإِ الْعَظِيمِ ﴿٢﴾',
                  textAlign: TextAlign.right,
                  style: AppTheme.quranArabic(fontSize: 20).copyWith(height: 1.8),
                ),
                const SizedBox(height: 6),
                Text(
                  'QS. 78: 1–2: "Tentang apakah mereka saling bertanya-tanya? Tentang berita yang besar..."',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Progress bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progres Tilawah', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary)),
              Text('2 dari 40 Ayat (5%)', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 2 / 40,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 14),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: Text(
                    'Lanjut Baca (Ayat 2)',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                  onPressed: () {
                    final surah = kQuranSurahs.firstWhere((s) => s.number == 78, orElse: () => kQuranSurahs.first);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MushafReaderScreen(surah: surah, initialAyah: 2)),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.play_arrow, color: AppColors.primary, size: 22),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MurottalAudioSanctuaryScreen()),
                  );
                },
              ),
              const SizedBox(width: 6),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.mic, color: AppColors.primary, size: 20),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AiTartilEvaluationScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // AI TARTIL & MAKHRAJ CARD
  // ==========================================
  Widget _buildAiTartilCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF352D4E), Color(0xFF4A416B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(50),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(35),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '• AI TARTIL 2.0',
                      style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Akurasi Tinggi Qira\'at Hafsh',
                      style: GoogleFonts.plusJakartaSans(fontSize: 10, color: Colors.white70),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withAlpha(40),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '100% Bebas Biaya',
                  style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF34D399)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(25),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.graphic_eq, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Pendamping Makhraj & Tartil',
                      style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lafalkan ayat ke mikrofon. AI mendeteksi makharijul huruf, mad thabi\'i, ghunnah, dan ikhfa\' secara instan dengan verifikasi rujukan asatidzah.',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11.5, height: 1.45, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Waveform status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.waves, color: Color(0xFF10B981), size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Siap mendengarkan bacaan Anda',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ],
                ),
                const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 16),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Action buttons
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.mic, size: 18),
                label: Text(
                  'Mulai Rekam Suara',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AiTartilEvaluationScreen()),
                  );
                },
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white38),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  final fatihah = kQuranSurahs.firstWhere((s) => s.number == 1, orElse: () => kQuranSurahs.first);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AiTartilEvaluationScreen(surah: fatihah, ayahNumber: 1),
                    ),
                  );
                },
                child: Text(
                  'Coba Al-Fatihah >',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // KHAZANAH AL-QUR'AN QUICK ACCESS (4 Cards)
  // ==========================================
  Widget _buildKhazanahQuickAccess() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Khazanah Al-Qur\'an',
              style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
            Text(
              'Akses Cepat',
              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
            ),
          ],
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: _buildQuickAccessCard(
                title: 'Mushaf Madinah',
                subtitle: '30 Juz Rasm \'Utsmani',
                icon: Icons.auto_stories,
                color: const Color(0xFF6366F1),
                onTap: () {
                  final surah = kQuranSurahs.firstWhere((s) => s.number == 78, orElse: () => kQuranSurahs.first);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MushafReaderScreen(surah: surah, initialMushafKontinu: true),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildQuickAccessCard(
                title: 'Murottal Qari',
                subtitle: 'Multi Qari & Offline',
                icon: Icons.headphones,
                color: const Color(0xFF10B981),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MurottalAudioSanctuaryScreen()),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: _buildQuickAccessCard(
                title: 'Juz \'Amma Tracker',
                subtitle: 'Hafalan 37 Surah',
                icon: Icons.check_circle_outline,
                color: const Color(0xFF8B5CF6),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const JuzAmmaHafalanScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildQuickAccessCard(
                title: 'Tajwid Visual',
                subtitle: 'Warna & Panduan Hukum',
                icon: Icons.draw_outlined,
                color: const Color(0xFFF59E0B),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TajwidTracingScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // SURAH LIST SECTION
  // ==========================================
  Widget _buildSurahListSection(List<SurahModel> filteredSurahs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daftar Surah',
              style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
            Text(
              'Urutan Mushaf',
              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Filter Tabs
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterPill(0, 'Semua'),
              const SizedBox(width: 8),
              _buildFilterPill(1, 'Makkiyyah'),
              const SizedBox(width: 8),
              _buildFilterPill(2, 'Madaniyyah'),
              const SizedBox(width: 8),
              _buildFilterPill(3, 'Surah Pilihan'),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // List of Surahs
        ...filteredSurahs.map((surah) {
          final isSelectedSurah = surah.number == 18;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelectedSurah ? AppColors.primary : AppColors.surfaceContainerHigh,
                width: isSelectedSurah ? 1.5 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(5),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: InkWell(
              onTap: () => _onSurahTap(surah),
              borderRadius: BorderRadius.circular(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelectedSurah ? AppColors.primary : AppColors.primaryFixed,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            surah.number < 10 ? '0${surah.number}' : '${surah.number}',
                            style: GoogleFonts.syne(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isSelectedSurah ? Colors.white : AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      surah.name,
                                      style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  if (surah.badge != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isSelectedSurah ? AppColors.primaryFixed : AppColors.surfaceContainerLow,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        surah.badge!,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    )
                                  else
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceContainerLow,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        surah.type,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 9.5,
                                          color: AppColors.secondary,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${surah.meaning} • ${surah.ayahsCount} Ayat',
                                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        surah.arabic,
                        style: AppTheme.quranArabic(fontSize: 19).copyWith(color: AppColors.primary),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.download_for_offline_outlined, color: AppColors.secondary, size: 19),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'Unduh Audio Offline',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Audio Surah ${surah.name} diunduh ke penyimpanan lokal.')),
                          );
                        },
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        icon: const Icon(Icons.play_circle_outline, color: AppColors.primary, size: 21),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'Putar Murottal',
                        onPressed: () => _onSurahTap(surah),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ==========================================
  // HIKMAH KALAMULLAH HARI INI CARD
  // ==========================================
  Widget _buildHikmahKalamullahCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withAlpha(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: AppColors.primary, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'HIKMAH KALAMULLAH HARI INI',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'QS. Al-Baqarah: 186',
                  style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Arabic
          Text(
            'وَإِذَا سَأَلَكَ عِبَادِي عَنِّي فَإِنِّي قَرِيبٌ ۖ أُجِيبُ دَعْوَةَ الدَّاعِ إِذَا دَعَانِ',
            textAlign: TextAlign.right,
            style: AppTheme.quranArabic(fontSize: 22).copyWith(height: 1.8),
          ),
          const SizedBox(height: 10),

          // Translation
          Text(
            '"Dan apabila hamba-hamba-Ku bertanya kepadamu (Muhammad) tentang Aku, maka sesungguhnya Aku adalah dekat. Aku mengabulkan permohonan orang yang berdoa apabila dia berdoa kepada-Ku..."',
            style: GoogleFonts.plusJakartaSans(fontSize: 12, height: 1.5, color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.favorite_border, size: 14, color: AppColors.secondary),
                  const SizedBox(width: 6),
                  Text(
                    'Fokus: Kedekatan Doa & Tawakkal',
                    style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.secondary),
                  ),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _savedHikmah ? const Color(0xFF10B981) : AppColors.primaryFixed,
                  foregroundColor: _savedHikmah ? Colors.white : AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                icon: Icon(_savedHikmah ? Icons.check : Icons.bookmark_add, size: 14),
                label: Text(
                  _savedHikmah ? 'Tersimpan' : 'Simpan ke Jurnal',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                ),
                onPressed: () {
                  setState(() => _savedHikmah = true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Hikmah Kalamullah disimpan ke Jurnal Hati.')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopSegment({
    required int index,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isSelected = _topSegmentIndex == index;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.surfaceContainerHigh,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: AppColors.primary.withAlpha(30), blurRadius: 6, offset: const Offset(0, 2))]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: isSelected ? Colors.white : AppColors.secondary),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.surfaceContainerHigh),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.syne(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(int index, String label) {
    final isSelected = _selectedFilter == index;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.surfaceContainerLowest,
      labelStyle: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? Colors.white : AppColors.onSurface,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.surfaceContainerHigh,
      ),
      onSelected: (val) => setState(() => _selectedFilter = index),
    );
  }
}
