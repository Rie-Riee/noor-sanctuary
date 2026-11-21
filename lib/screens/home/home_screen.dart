import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/sanctuary_mode.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../utils/prayer_calculator.dart';
import '../modules/tasbih_dialog.dart';
import '../modules/knowledge_modules_sheet.dart';
import '../streaming/detail_jadwal_majelis_screen.dart';
import '../murottal/murottal_pemanasan_screen.dart';
import '../sedekah/jurnal_sedekah_screen.dart';
import '../masjid/rute_masjid_screen.dart';
import '../notification/pusat_notifikasi_screen.dart';
import '../compass/qibla_compass_screen.dart';
import '../dzikir/dzikir_pagi_petang_screen.dart';
import '../reels/reels_syiar_screen.dart';
import '../ai_chat/tanya_ustadz_chat_screen.dart';
import '../sisterhood/sisterhood_screen.dart';
import '../profile/profile_screen.dart';
import '../search/universal_search_sheet.dart';

class HomeScreen extends StatefulWidget {
  final SanctuaryMode mode;
  final VoidCallback onSwitchMode;
  final ValueChanged<SanctuaryMode>? onModeChanged;
  final VoidCallback onLogout;
  final Function(int tabIndex)? onNavigateTab;

  const HomeScreen({
    super.key,
    required this.mode,
    required this.onSwitchMode,
    this.onModeChanged,
    required this.onLogout,
    this.onNavigateTab,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _tadabburExpanded = false;
  late Timer _clockTimer;
  DateTime _currentClock = DateTime.now();
  final TextEditingController _aiQuestionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Real live clock timer updating every 1 second
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentClock = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    _aiQuestionController.dispose();
    super.dispose();
  }

  void _showProfileModal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileScreen(
          mode: widget.mode,
          onSwitchMode: widget.onSwitchMode,
          onLogout: widget.onLogout,
          onSelectMode: (newMode) {
            if (newMode != widget.mode) {
              widget.onModeChanged?.call(newMode);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prayerStatus = RealPrayerService.calculateStatus(_currentClock);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 850;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(0, 0, 0, isDesktop ? 40 : 170),
          child: Column(
            children: [
              // 1. Top Sanctuary Header (ONLY on mobile; desktop web has scaffold top bar)
              if (!isDesktop) _buildHeader(),

              // Content Container
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 36 : 16,
                  vertical: isDesktop ? 20 : 0,
                ),
                child: isDesktop
                    // DESKTOP RESPONSIVE 2-COLUMN DASHBOARD
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column: Main Hero, Timeline & Interactive Highlights
                          Expanded(
                            flex: 62,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (widget.mode == SanctuaryMode.sisterhood) ...[
                                  _buildSisterhoodBanner(),
                                  const SizedBox(height: 16),
                                ] else if (widget.mode == SanctuaryMode.kids) ...[
                                  _buildKidsBanner(),
                                  const SizedBox(height: 16),
                                ],
                                _buildArchitecturalHero(prayerStatus),
                                const SizedBox(height: 16),
                                _buildInteractiveHighlightsRow(),
                                const SizedBox(height: 16),
                                _buildMurottalBanner(),
                                const SizedBox(height: 20),
                                _buildRuangIbadahGrid(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          // Right Column: AI Assistant, Tadabbur, Kajian, Quick Utilities
                          Expanded(
                            flex: 38,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildUstadzAICard(),
                                const SizedBox(height: 20),
                                _buildAyatPilihanCard(),
                                const SizedBox(height: 20),
                                _buildKajianCard(),
                                const SizedBox(height: 20),
                                _buildQuickFeaturesRow(),
                              ],
                            ),
                          ),
                        ],
                      )
                    // MOBILE SINGLE COLUMN VERTICAL FLOW
                    : Column(
                        children: [
                          if (widget.mode == SanctuaryMode.sisterhood) ...[
                            _buildSisterhoodBanner(),
                            const SizedBox(height: 14),
                          ] else if (widget.mode == SanctuaryMode.kids) ...[
                            _buildKidsBanner(),
                            const SizedBox(height: 14),
                          ],
                          _buildArchitecturalHero(prayerStatus),
                          const SizedBox(height: 16),
                          _buildInteractiveHighlightsRow(),
                          const SizedBox(height: 16),
                          _buildMurottalBanner(),
                          const SizedBox(height: 20),
                          _buildRuangIbadahGrid(),
                          const SizedBox(height: 20),
                          _buildAyatPilihanCard(),
                          const SizedBox(height: 20),
                          _buildUstadzAICard(),
                          const SizedBox(height: 20),
                          _buildKajianCard(),
                          const SizedBox(height: 20),
                          _buildQuickFeaturesRow(),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSisterhoodBanner() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SisterhoodScreen()));
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primaryFixed.withAlpha(150),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withAlpha(60)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.local_florist, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sisterhood Mode Aktif',
                    style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                  Text(
                    'Ketuk untuk lihat Siklus Thaharah, Haid & Fiqih Muslimah',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildKidsBanner() {
    return GestureDetector(
      onTap: () {
        if (widget.onModeChanged != null) {
          widget.onModeChanged!(SanctuaryMode.kids);
        } else {
          widget.onSwitchMode();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.tertiaryFixed.withAlpha(160),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.tertiary.withAlpha(60)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.stars, color: Colors.amber, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kids Sanctuary Ceria Aktif ⭐',
                    style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.tertiary),
                  ),
                  Text(
                    'Buka Belajar Iqra Tracing Huruf & Kuis Sambung Ayat',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.tertiary),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface.withAlpha(220),
        border: const Border(bottom: BorderSide(color: AppColors.hairline)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'NOOR',
                      style: GoogleFonts.syne(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.auto_awesome, size: 14, color: AppColors.primary),
                  ],
                ),
                Text(
                  '14 RAMADHAN 1446 H',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: AppColors.secondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Mode pill indicator
              GestureDetector(
                onTap: widget.onSwitchMode,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.mode.accentBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(widget.mode.icon, size: 12, color: AppColors.primary),
                      const SizedBox(width: 3),
                      Text(
                        widget.mode.badge,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onPrimaryFixed,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 2),

              // Search Button
              IconButton(
                icon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 20),
                tooltip: 'Cari Surah, Kajian, Amalan...',
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: () => showUniversalSearch(context, onNavigateTab: widget.onNavigateTab),
              ),

              // Notification icon with badge
              IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.notifications_outlined, color: AppColors.primary, size: 20),
                    Positioned(
                      top: 1,
                      right: 1,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PusatNotifikasiScreen()));
                },
              ),
              const SizedBox(width: 2),

              // Profile Avatar
              GestureDetector(
                onTap: _showProfileModal,
                child: const CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArchitecturalHero(PrayerStatus prayerStatus) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.hairline),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Hero Canvas with Exquisite Mosque Architecture Visual (100% matched with Stitch/Figma)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: SizedBox(
              height: 290,
              child: Stack(
                children: [
                  // Atmospheric Mosque Artwork (from local bundled assets, 100% reliable)
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/mosque_hero.png',
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDNEKUTPeu_mHfwUd86MaA_Q00gn62pSFTIauAy3mH40xggsFL-sWxAjBuHTK83yAC5-dJYA4Jfsu5o5YIBWDYzNwlOD5G9NjBkQX2eIBiA2wONPtLIM6Bm8i1NtQkiJJtGIR_5faMtdAsKYXxsqKcoTRRbL5dP40MYISp5oEoGzWrJ30wTso4d-HTGUuDpG2Nl5Rd2CGt5wcLt1g6XET3fjTXE34ZrgXxrJXH16Uo',
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        );
                      },
                    ),
                  ),

                  // Ambient Gradient Scrim to ensure crisp typography
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.surfaceContainerLowest,
                            AppColors.surfaceContainerLowest.withAlpha(120),
                            Colors.black.withAlpha(25),
                          ],
                          stops: const [0.0, 0.45, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Live Mihrab Focus & Architectural Framing Content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Top Badges Row: Adzan Aktif & Qibla Pill
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLowest.withAlpha(230),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 4)],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                    ),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        'ADZAN AKTIF (${prayerStatus.activePrayerName.toUpperCase()})',
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.8,
                                          color: AppColors.primary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const QiblaCompassScreen()));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLowest.withAlpha(230),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 4)],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.explore, size: 13, color: AppColors.primary),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Kiblat 295° NW',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Central Solat Countdown Arch
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Arabesque Ornamental Motif
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(width: 24, height: 1, color: AppColors.secondary.withAlpha(120)),
                                const SizedBox(width: 6),
                                const Icon(Icons.grid_goldenratio, size: 16, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Container(width: 24, height: 1, color: AppColors.secondary.withAlpha(120)),
                              ],
                            ),
                            const SizedBox(height: 4),

                            Text(
                              'MENUJU SHALAT BERIKUTNYA',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 2),

                            // Next Prayer Name in Noto Serif + Time in Gold
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  prayerStatus.nextPrayerName,
                                  style: GoogleFonts.notoSerif(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${prayerStatus.nextPrayerTime} WIB',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            // Tactile Countdown Pill with Live Clock
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerHigh.withAlpha(220),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.grid_goldenratio, size: 15, color: AppColors.primary),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${RealPrayerService.formatDuration(prayerStatus.remainingToNext)} LAGI',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(width: 1, height: 12, color: AppColors.outlineVariant),
                                  const SizedBox(width: 8),
                                  Text(
                                    RealPrayerService.formatClock(_currentClock),
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                ],
                              ),
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

          // Five Daily Prayers Architectural Timeline Niche (100% matched with Stitch)
          Container(
            padding: const EdgeInsets.all(14),
            color: AppColors.surfaceContainerLowest,
            child: Row(
              children: prayerStatus.scheduleItems.map((p) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: p.isActive ? AppColors.primaryFixed : AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: p.isActive
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withAlpha(35),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      children: [
                        if (p.isActive)
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(bottom: 3),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        Text(
                          p.name.toUpperCase(),
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: p.isActive ? AppColors.primary : AppColors.onSurfaceVariant.withAlpha(180),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          p.time,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: p.isActive ? FontWeight.w800 : FontWeight.w600,
                            color: p.isActive ? AppColors.primary : AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (p.isActive)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Aktif',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          )
                        else
                          Icon(
                            p.statusIcon,
                            size: 13,
                            color: p.isPassed ? AppColors.outline : AppColors.outlineVariant,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveHighlightsRow() {
    final items = [
      {
        'title': 'Kompas Kiblat',
        'icon': Icons.explore,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QiblaCompassScreen())),
      },
      {
        'title': 'Dzikir Pagi',
        'icon': Icons.wb_twilight,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DzikirPagiPetangScreen())),
      },
      {
        'title': 'Syiar Shorts',
        'icon': Icons.video_library,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReelsSyiarScreen())),
      },
      {
        'title': 'Live Majelis',
        'icon': Icons.live_tv,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DetailJadwalMajelisScreen())),
      },
    ];

    return Row(
      children: items.map((it) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: GestureDetector(
              onTap: it['action'] as VoidCallback,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.hairline),
                ),
                child: Column(
                  children: [
                    Icon(it['icon'] as IconData, size: 20, color: AppColors.primary),
                    const SizedBox(height: 4),
                    Text(
                      it['title'] as String,
                      style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMurottalBanner() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MurottalPemanasanScreen()));
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.secondaryContainer.withAlpha(150),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.hairline),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.graphic_eq, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Murottal Pemanasan Menjelang Sholat',
                    style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                  Text(
                    'QS. Ar-Rahman • Syaikh Mishary Rashid Al-Afasy',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const Icon(Icons.play_circle_fill, color: AppColors.primary, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildRuangIbadahGrid() {
    final modules = [
      {
        'title': 'Hadits',
        'subtitle': 'Shahih Bukhari',
        'icon': Icons.menu_book,
        'color': AppColors.powderBlue,
        'action': () => _openModule(KnowledgeModuleType.hadits),
      },
      {
        'title': 'Doa Harian',
        'subtitle': 'Hisnul Muslim',
        'icon': Icons.self_improvement,
        'color': AppColors.lavender,
        'action': () => _openModule(KnowledgeModuleType.doaHarian),
      },
      {
        'title': 'Kisah Nabi',
        'subtitle': '25 Sirah Nabawi',
        'icon': Icons.history_edu,
        'color': AppColors.mistySage,
        'action': () => _openModule(KnowledgeModuleType.kisahNabi),
      },
      {
        'title': 'Tasbih',
        'subtitle': 'Haptic Counter',
        'icon': Icons.all_inclusive,
        'color': AppColors.blushPink,
        'action': () => showDialog(context: context, builder: (_) => const TasbihDialog()),
      },
      {
        'title': 'Asmaul Husna',
        'subtitle': '99 Nama Indah',
        'icon': Icons.stars,
        'color': AppColors.softPeriwinkle,
        'action': () => _openModule(KnowledgeModuleType.asmaulHusna),
      },
      {
        'title': 'Tajwid Visual',
        'subtitle': 'Hukum Nun & Mad',
        'icon': Icons.hearing,
        'color': AppColors.surfaceContainerHigh,
        'action': () => _openModule(KnowledgeModuleType.tajwidVisual),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(Icons.grid_goldenratio, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ruang Ibadah & Ilmu',
                      style: GoogleFonts.notoSerif(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '6 Kategori',
              style: GoogleFonts.spaceGrotesk(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant.withAlpha(180)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: MediaQuery.of(context).size.width >= 850 ? 1.25 : 0.95,
          ),
          itemCount: modules.length,
          itemBuilder: (context, idx) {
            final m = modules[idx];
            return GestureDetector(
              onTap: m['action'] as VoidCallback,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration: BoxDecoration(
                  color: m['color'] as Color,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(6),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(220),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(m['icon'] as IconData, color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      m['title'] as String,
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      m['subtitle'] as String,
                      style: GoogleFonts.plusJakartaSans(fontSize: 9, color: AppColors.onSurfaceVariant),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _openModule(KnowledgeModuleType type) {
    showDialog(
      context: context,
      builder: (_) => KnowledgeModuleSheet(initialType: type),
    );
  }

  Widget _buildAyatPilihanCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.hairline),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(10),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
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
                    const Icon(Icons.grid_goldenratio, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'AYAT HARI INI • QS. AL-INSYIRAH [94]: 5',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: AppColors.secondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.share_outlined, size: 18, color: AppColors.secondary),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ayat pilihan berhasil disalin.')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow.withAlpha(150),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: AppTheme.quranArabic(fontSize: 26),
                ),
                const SizedBox(height: 8),
                Text(
                  '"Maka sesungguhnya beserta kesulitan ada kemudahan."',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: AppColors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.menu_book, size: 14, color: AppColors.secondary),
                  const SizedBox(width: 4),
                  Text(
                    'Tafsir Ringkas Ibnu Katsir',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                  ),
                ],
              ),
              InkWell(
                onTap: () => setState(() => _tadabburExpanded = !_tadabburExpanded),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Tadabbur Singkat',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                      const SizedBox(width: 2),
                      Icon(_tadabburExpanded ? Icons.expand_less : Icons.expand_more, size: 15, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
            ],
          ),

          if (_tadabburExpanded)
            Container(
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kata al-\'usr (kesulitan) disebutkan dalam bentuk makrifah (pasti/satu), sedangkan kata yusran (kemudahan) disebutkan dua kali dalam bentuk nakirah (berlipat tak terbatas). Satu kesulitan tidak akan pernah mampu mengalahkan dua kemudahan ilahi.',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.onSurface, height: 1.45),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Kitab At-Taysir • Imam As-Sa\'di',
                      style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.secondary),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUstadzAICard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.softPeriwinkle,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(10),
            blurRadius: 16,
            offset: const Offset(0, 4),
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
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.smart_toy, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tanya Al-Ustadz AI',
                        style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                      Text(
                        'SANAD TERVERIFIKASI & DALIL SHAHIH',
                        style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primary.withAlpha(180)),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'AI FIQH 2.0',
                  style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Konsultasikan kaidah fikih, keabsahan sanad hadits, atau perbandingan fatwa ulama empat madzhab secara objektif.',
            style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.primary, height: 1.4),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              'Hukum puasa safar?',
              'Tata cara shalat jama\' qashar?',
              'Zakat mal tabungan emas',
            ].map((q) {
              return ActionChip(
                label: Text(q),
                labelStyle: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                backgroundColor: Colors.white,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TanyaUstadzChatScreen(initialQuestion: q),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _aiQuestionController,
                  style: GoogleFonts.plusJakartaSans(fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'Tuliskan pertanyaan ibadah atau muamalah...',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                  ),
                  onSubmitted: (q) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TanyaUstadzChatScreen(initialQuestion: q),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.send, size: 18),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TanyaUstadzChatScreen(initialQuestion: _aiQuestionController.text),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKajianCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.hairline),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(10),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.grid_goldenratio, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Kajian Terkurasi Hari Ini',
                          style: GoogleFonts.notoSerif(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const DetailJadwalMajelisScreen()));
                  },
                  child: Text(
                    'Lihat Semua',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.secondary),
                  ),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const DetailJadwalMajelisScreen()));
            },
            child: Container(
              height: 180,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/ustadzah_kajian.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withAlpha(150),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(200),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '01:00 MIN PREVIEW',
                        style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(220),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow, color: AppColors.primary, size: 28),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(220),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'TAZKIYATUN NAFS',
                        style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Menjaga Hati di Kala Overthinking',
                  style: GoogleFonts.notoSerif(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ustadzah Haneen Akira menguraikan rahasia berserah diri (tawakkal) ketika pikiran masa depan membuat dada terasa sesak dan gelisah.',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant, height: 1.4),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppColors.secondaryFixed,
                            child: Text(
                              'HA',
                              style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primary),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Ustzh. Haneen Akira',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.forum_outlined, size: 14, color: AppColors.secondary),
                        const SizedBox(width: 4),
                        Text('142', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary)),
                        const SizedBox(width: 12),
                        const Icon(Icons.favorite_border, size: 14, color: AppColors.secondary),
                        const SizedBox(width: 4),
                        Text('2.4k', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFeaturesRow() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const JurnalSedekahScreen()));
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.hairline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.volunteer_activism, color: AppColors.primary, size: 24),
                  const SizedBox(height: 8),
                  Text(
                    'Jurnal Sedekah',
                    style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                  Text(
                    'Subuh & Dhuha',
                    style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const RuteMasjidScreen()));
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.hairline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.near_me, color: AppColors.primary, size: 24),
                  const SizedBox(height: 8),
                  Text(
                    'Rute Masjid',
                    style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                  Text(
                    'Kompas 295° NW',
                    style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
