import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../notification/pusat_notifikasi_screen.dart';
import '../search/universal_search_sheet.dart';
import 'kuis_sambung_ayat_screen.dart';
import 'petualangan_sirah_screen.dart';
import 'rangkuman_kuis_screen.dart';

class GameSanctuaryTabScreen extends StatefulWidget {
  final VoidCallback? onSwitchToKids;
  final VoidCallback? onProfileTap;

  const GameSanctuaryTabScreen({
    super.key,
    this.onSwitchToKids,
    this.onProfileTap,
  });

  @override
  State<GameSanctuaryTabScreen> createState() => _GameSanctuaryTabScreenState();
}

class _GameSanctuaryTabScreenState extends State<GameSanctuaryTabScreen> {
  int _selectedFilterIndex = 0;

  final List<Map<String, dynamic>> _filters = [
    {'label': 'Semua Arena', 'icon': Icons.grid_view_rounded},
    {'label': 'Kuis Fiqih', 'icon': Icons.balance_rounded},
    {'label': 'Ayat Quran', 'icon': Icons.menu_book_rounded},
    {'label': 'Sirah Nabawi', 'icon': Icons.history_edu_rounded},
    {'label': 'Tajwid Visual', 'icon': Icons.auto_awesome_rounded},
    {'label': 'Asmaul Husna', 'icon': Icons.stars_rounded},
  ];

  final List<Map<String, dynamic>> _gameCards = [
    {
      'title': 'Sambung Ayat Juz \'Amma',
      'tags': ['Tilawah & Tartil', 'Audio Qari'],
      'tagColors': [Color(0xFFE0F2FE), Color(0xFFEDE9FE)],
      'tagTextColors': [Color(0xFF0369A1), Color(0xFF6D28D9)],
      'desc': 'Tebak kelanjutan ayat dari Surah An-Naba\' sampai An-Nas, dilengkapi lantunan murottal syahdu dan koreksi tajwid realtime.',
      'footerLeft': '⇄ 37 Surah Siap Uji',
      'footerRight': 'Level: Bertahap',
      'icon': Icons.menu_book_rounded,
      'type': 'sambung_ayat',
    },
    {
      'title': 'Kuis 4 Madzhab & Fiqih Harian',
      'tags': ['Fiqih Ibadah', 'Dalil Shahih'],
      'tagColors': [Color(0xFFDCFCE7), Color(0xFFF3E8FF)],
      'tagTextColors': [Color(0xFF15803D), Color(0xFF7E22CE)],
      'desc': 'Kaji komparasi wudhu, thaharah, shalat jama\' qashar, serta muamalah kontemporer merujuk pada kitab fikih mu\'tabarah.',
      'footerLeft': '📖 120 Soal Diskusi',
      'footerRight': 'Level: Menengah',
      'icon': Icons.balance_rounded,
      'type': 'fiqih',
    },
    {
      'title': 'Petualangan Sirah Nabawiyah',
      'tags': ['Sejarah Islam', 'Peta Kronologis'],
      'tagColors': [Color(0xFFEDE9FE), Color(0xFFE0F2FE)],
      'tagTextColors': [Color(0xFF6D28D9), Color(0xFF0369A1)],
      'desc': 'Jelajahi peta interaktif perjalanan Nabi Muhammad ﷺ dari Makkah, Madinah, hingga pembebasan Al-Quds dengan rute historis.',
      'footerLeft': '📖 18 Babak Sejarah',
      'footerRight': 'Narasi Interaktif',
      'icon': Icons.explore_rounded,
      'type': 'sirah',
    },
    {
      'title': 'Labirin Tajwid & Makhraj Huruf',
      'tags': ['Ilmu Tajwid', 'Visual Anatomi'],
      'tagColors': [Color(0xFFFEE2E2), Color(0xFFEDE9FE)],
      'tagTextColors': [Color(0xFFB91C1C), Color(0xFF6D28D9)],
      'desc': 'Tantangan mencocokkan hukum Nun Sukun, Idgham, Ikhfa, dan titik artikulasi lisan makharijul huruf secara visual taktil.',
      'footerLeft': '🔤 14 Kaidah Tajwid',
      'footerRight': 'Visual Puzzle',
      'icon': Icons.spellcheck_rounded,
      'type': 'tajwid',
    },
    {
      'title': 'Tebak Makna 99 Asmaul Husna',
      'tags': ['Aqidah & Tauhid', 'Penyejuk Hati'],
      'tagColors': [Color(0xFFE0F2FE), Color(0xFFFEF3C7)],
      'tagTextColors': [Color(0xFF0369A1), Color(0xFFB45309)],
      'desc': 'Kenali dan resapi 99 nama agung Allah Ta\'ala melalui kuis arti kata, konteks doa ma\'tsur, dan tadabbur kebesaran-Nya.',
      'footerLeft': '☉ 99 Nama Suci',
      'footerRight': 'Tadabbur Qolbu',
      'icon': Icons.stars_rounded,
      'type': 'asmaul_husna',
    },
    {
      'title': 'TTS Khazanah & Kosakata Arab',
      'tags': ['Mufradat Arab', 'Pekan Ini'],
      'tagColors': [Color(0xFFDCFCE7), Color(0xFFEDE9FE)],
      'tagTextColors': [Color(0xFF15803D), Color(0xFF6D28D9)],
      'desc': 'Teka-teki silang santai bertema istilah fiqih, gelar sahabat Rasulullah ﷺ, dan kata serapan bahasa Al-Qur\'an.',
      'footerLeft': '✎ Edisi Pekan 14',
      'footerRight': 'Santai & Mengasah',
      'icon': Icons.grid_on_rounded,
      'type': 'tts',
    },
  ];

  void _openGame(String type, String title) {
    if (type == 'sirah') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PetualanganSirahScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => KuisSambungAyatScreen(
            title: title,
            category: type == 'sambung_ayat' ? 'Juz \'Amma Challenge' : 'Kuis Khazanah',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 850;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 1240 : 640),
            child: Scrollbar(
              thumbVisibility: isDesktop,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  isDesktop ? 32 : 18,
                  isDesktop ? 20 : 14,
                  isDesktop ? 32 : 18,
                  isDesktop ? 50 : 170, // Clearance for bottom dock on mobile
                ),
                child: isDesktop
                    // DESKTOP TWO-COLUMN VIEW
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column (Arena & Quizzes)
                          Expanded(
                            flex: 60,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDesktopHeader(),
                                const SizedBox(height: 18),
                                _buildStreakHeroBanner(),
                                const SizedBox(height: 18),
                                _buildFilterChipsTrack(),
                                const SizedBox(height: 20),
                                _buildDailyChallengeBanner(),
                                const SizedBox(height: 24),
                                _buildArenaEdukatifSection(isDesktop: true),
                              ],
                            ),
                          ),
                          const SizedBox(width: 28),
                          // Right Column (Leaderboard, Kids Mode, Reflection)
                          Expanded(
                            flex: 40,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLeaderboardCard(),
                                const SizedBox(height: 24),
                                _buildSantriCilikCard(),
                                const SizedBox(height: 24),
                                _buildDalilRefleksiCard(),
                              ],
                            ),
                          ),
                        ],
                      )
                    // MOBILE SINGLE COLUMN VERTICAL FLOW
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTopBar(),
                          const SizedBox(height: 16),
                          _buildStreakHeroBanner(),
                          const SizedBox(height: 16),
                          _buildFilterChipsTrack(),
                          const SizedBox(height: 18),
                          _buildDailyChallengeBanner(),
                          const SizedBox(height: 24),
                          _buildArenaEdukatifSection(isDesktop: false),
                          const SizedBox(height: 24),
                          _buildLeaderboardCard(),
                          const SizedBox(height: 24),
                          _buildSantriCilikCard(),
                          const SizedBox(height: 24),
                          _buildDalilRefleksiCard(),
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
  // DESKTOP HEADER (Clean, no duplicate appbar)
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
                  'Khazanah Games & Arena Edukasi',
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
                    '✦ Interaktif',
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
              'Thalabul \'ilmi interaktif: Fiqih, Sirah Nabawiyah, Makhraj Huruf & Asmaul Husna',
              style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.secondary),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // 1. TOP BAR
  // ==========================================
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'NOOR ✦',
                    style: GoogleFonts.syne(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'KHAZANAH GAMES',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '14 Ramadhan 1446 H • Barakah Istiqomah',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.search_rounded, color: AppColors.primary),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              onPressed: () => showUniversalSearch(context),
            ),
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: AppColors.primary),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PusatNotifikasiScreen()));
              },
            ),
            const SizedBox(width: 6),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onProfileTap,
              child: Tooltip(
                message: 'Lihat Profil Pengguna',
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E264D),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 18),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // 2. STREAK HERO BANNER
  // ==========================================
  Widget _buildStreakHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2B2147),
            Color(0xFF453A68),
            Color(0xFF5B507D),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(40),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('🔥', style: TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withAlpha(40),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFF59E0B).withAlpha(120)),
                        ),
                        child: Text(
                          'STREAK JUZ 7 HARI',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: const Color(0xFFFDE68A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '32 Modul Tuntas',
                        style: GoogleFonts.syne(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.stars, color: Color(0xFFF59E0B), size: 14),
                  const SizedBox(width: 4),
                  Text(
                    'Santri Hafizh',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFFDE68A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                width: 90,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(40),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.82,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF59E0B), Color(0xFFFCD34D)],
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '82% Level Up',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 3. FILTER CHIPS TRACK
  // ==========================================
  Widget _buildFilterChipsTrack() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, idx) {
          final isSelected = _selectedFilterIndex == idx;
          final f = _filters[idx];
          return GestureDetector(
            onTap: () {
              setState(() => _selectedFilterIndex = idx);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF5B4294) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? const Color(0xFF5B4294) : AppColors.hairline,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF5B4294).withAlpha(40),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    f['icon'] as IconData,
                    size: 15,
                    color: isSelected ? Colors.white : AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    f['label'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ==========================================
  // 4. DAILY HERO CHALLENGE BANNER
  // ==========================================
  Widget _buildDailyChallengeBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            // Background Artwork
            Positioned.fill(
              child: Image.asset(
                'assets/images/mosque_hero.png',
                fit: BoxFit.cover,
              ),
            ),
            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withAlpha(140),
                      const Color(0xFF2E224A).withAlpha(210),
                      const Color(0xFF1E1736).withAlpha(245),
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.bolt, size: 13, color: Colors.black),
                            SizedBox(width: 4),
                            Text(
                              'TANTANGAN HARIAN',
                              style: TextStyle(color: Colors.black, fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(120),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.circle, size: 7, color: Color(0xFF10B981)),
                            SizedBox(width: 5),
                            Text(
                              '4.8k Santri Berlomba',
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text(
                        'SIRAH & SEJARAH',
                        style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8, color: const Color(0xFFFCD34D)),
                      ),
                      const Text(' • ', style: TextStyle(color: Colors.white54)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withAlpha(40),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '+150 Barakah Poin',
                          style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w700, color: const Color(0xFFFCD34D)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Kisah 25 Nabi & Sirah',
                    style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Jawab 5 soal harian, uji pengetahuan sejarah dakwah, dan kumpulkan trofi santri.',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.white.withAlpha(220), height: 1.4),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      // Social Avatars
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildMiniAvatar('A', const Color(0xFFE9C46A)),
                          Transform.translate(offset: const Offset(-8, 0), child: _buildMiniAvatar('F', const Color(0xFF818CF8))),
                          Transform.translate(offset: const Offset(-16, 0), child: _buildMiniAvatar('R', const Color(0xFF34D399))),
                          const SizedBox(width: 2),
                          Text(
                            '4.8k santri aktif',
                            style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: Colors.white70),
                          ),
                        ],
                      ),
                      // Action Button
                      ElevatedButton.icon(
                        icon: const Icon(Icons.play_arrow, size: 15),
                        label: const Text('Mulai Main'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF59E0B),
                          foregroundColor: const Color(0xFF2E224A),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          textStyle: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w800),
                          elevation: 3,
                        ),
                        onPressed: () => _openGame('sirah', 'Petualangan Sirah Nabawiyah'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniAvatar(String initial, Color bg) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
    );
  }

  // ==========================================
  // 5. ARENA KHAZANAH EDUKATIF
  // ==========================================
  Widget _buildArenaEdukatifSection({bool isDesktop = false}) {
    final cardWidgets = _gameCards.map((g) => _buildGameCard(g)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome, size: 16, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        'Arena Khazanah Edukatif',
                        style: GoogleFonts.syne(fontSize: 16.5, fontWeight: FontWeight.w800, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '6 mode permainan edukatif interaktif',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primaryFixed,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '6 Kategori',
                style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        if (isDesktop)
          // 2-Column Responsive Layout for Desktop
          Column(
            children: [
              for (int i = 0; i < cardWidgets.length; i += 2)
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: cardWidgets[i]),
                      const SizedBox(width: 14),
                      Expanded(
                        child: (i + 1 < cardWidgets.length)
                            ? cardWidgets[i + 1]
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
            ],
          )
        else
          // 1-Column Vertical Stack for Mobile
          Column(children: cardWidgets),
      ],
    );
  }

  Widget _buildGameCard(Map<String, dynamic> g) {
    final tags = g['tags'] as List<String>;
    final tagColors = g['tagColors'] as List<Color>;
    final tagTextColors = g['tagTextColors'] as List<Color>;

    return GestureDetector(
      onTap: () => _openGame(g['type'] as String, g['title'] as String),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.hairline),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(6),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Game Thumbnail Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(g['icon'] as IconData, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 12),
                // Tags and Title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(color: tagColors[0], borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              tags[0],
                              style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w700, color: tagTextColors[0]),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(color: tagColors[1], borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              tags[1],
                              style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w700, color: tagTextColors[1]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        g['title'] as String,
                        style: GoogleFonts.syne(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.onSurface),
                      ),
                    ],
                  ),
                ),
                // Play Circle Button
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E264D),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow, color: Colors.white, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              g['desc'] as String,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant, height: 1.45),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    g['footerLeft'] as String,
                    style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.secondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    g['footerRight'] as String,
                    style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 6. LEADERBOARD SANTRI ISTIQOMAH
  // ==========================================
  Widget _buildLeaderboardCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.military_tech_outlined, size: 18, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Papan Santri Istiqomah Pekan Ini',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Zona Kebaikan',
                  style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w700, color: const Color(0xFF6B21A8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Apresiasi keistiqomahan thalabul \'ilmi tanpa persaingan duniawi. Istiqomah setiap hari meraih barakah ilmu.',
            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary, height: 1.4),
          ),
          const SizedBox(height: 14),

          // Rank 1
          _buildLeaderboardRow(1, 'Ahmad Raihan', 'Santri Al-Azhar • 7 Hari Berturut', '42 Kuis', const Color(0xFF2E264D), Colors.white),
          const SizedBox(height: 8),

          // Rank 2
          _buildLeaderboardRow(2, 'Fatimah Az-Zahra', 'Tahfizh Madani • 6 Hari Berturut', '38 Kuis', const Color(0xFFEDE9FE), AppColors.primary),
          const SizedBox(height: 8),

          // Rank 3 (User)
          _buildLeaderboardRow(3, 'Anda (Hamba Allah)', 'Sanctuary Noor • 7 Hari Berturut', '32 Kuis', const Color(0xFF2E264D), Colors.white, isSelf: true),
        ],
      ),
    );
  }

  Widget _buildLeaderboardRow(int rank, String name, String subtitle, String score, Color bg, Color textCol, {bool isSelf = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isSelf ? const Color(0xFFF5F3FF) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isSelf ? AppColors.primaryFixed : AppColors.hairline),
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textCol),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.syne(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                    ),
                    if (isSelf) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(color: const Color(0xFF2E264D), borderRadius: BorderRadius.circular(6)),
                        child: const Text('Akun Anda', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary),
                ),
              ],
            ),
          ),
          Text(
            isSelf ? '★ $score' : '✓ $score',
            style: GoogleFonts.spaceGrotesk(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 7. SANTRI CILIK MODE BANNER
  // ==========================================
  Widget _buildSantriCilikCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEFF6FF), Color(0xFFF3F0FC)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(color: Color(0xFF3B82F6), shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'ZONA CERIA & RAMAH BUAH HATI',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: const Color(0xFF1D4ED8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.directions_car_rounded, size: 20, color: Color(0xFF2563EB)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Mode Santri Cilik — Tanpa Iklan',
            style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w800, color: const Color(0xFF1E3A8A)),
          ),
          const SizedBox(height: 4),
          Text(
            'Menanamkan kecintaan syiar Islam, adab islami, dan huruf hijaiyah lewat petualangan visual interaktif yang aman.',
            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant, height: 1.4),
          ),
          const SizedBox(height: 14),

          // 3 Mini Cards
          Row(
            children: [
              _buildMiniFeatureCard('🏝️', 'Pulau Hijaiyah', 'Mengenal Huruf'),
              const SizedBox(width: 8),
              _buildMiniFeatureCard('🎨', 'Kaligrafi', 'Kreativitas Adab'),
              const SizedBox(width: 8),
              _buildMiniFeatureCard('🌟', 'Rukun Islam', 'Lagu & Cerita'),
            ],
          ),
          const SizedBox(height: 14),

          // Button
          ElevatedButton.icon(
            icon: const Icon(Icons.family_restroom, size: 16),
            label: const Text('Buka Petualangan Santri Cilik'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E264D),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              textStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            onPressed: () {
              if (widget.onSwitchToKids != null) {
                widget.onSwitchToKids!();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mengalihkan ke Kids Sanctuary...')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMiniFeatureCard(String emoji, String title, String desc) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 6),
          ],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.syne(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.onSurface),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              desc,
              style: GoogleFonts.plusJakartaSans(fontSize: 8.5, color: AppColors.secondary),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 8. KUTIPAN DALIL & REFLEKSI PEKAN INI
  // ==========================================
  Widget _buildDalilRefleksiCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.bookmark_outline, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Kutipan Dalil & Refleksi',
                        style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('Tersimpan', style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w700, color: const Color(0xFF6B21A8))),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Dari Kuis: Sirah Nabawiyah #12',
                        style: GoogleFonts.spaceGrotesk(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '2 Jam Lalu',
                      style: GoogleFonts.plusJakartaSans(fontSize: 9.5, color: AppColors.secondary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '"Barangsiapa menempuh jalan untuk menuntut ilmu, maka Allah mudahkan baginya jalan menuju surga."',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: AppColors.onSurface,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '(HR. Muslim no. 2699)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryContainer,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          OutlinedButton.icon(
            icon: const Icon(Icons.history_edu, size: 16),
            label: const Text('Lihat Riwayat & Pembahasan Soal'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              textStyle: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RangkumanKuisScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
