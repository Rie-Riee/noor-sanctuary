import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/sanctuary_mode.dart';
import '../theme/app_colors.dart';
import 'home/home_screen.dart';
import 'habits/habits_tab_screen.dart';
import 'quran/quran_tab_screen.dart';
import 'game/game_sanctuary_tab_screen.dart';
import 'media/media_sanctuary_tab_screen.dart';
import 'compass/qibla_compass_screen.dart';
import 'sisterhood/sisterhood_screen.dart';
import 'kids/kids_sanctuary_screen.dart';
import 'kids/pin_orang_tua_dialog.dart';
import 'notification/pusat_notifikasi_screen.dart';
import 'search/universal_search_sheet.dart';
import 'profile/profile_screen.dart';

class MainScaffold extends StatefulWidget {
  final SanctuaryMode mode;
  final VoidCallback onSwitchMode;
  final ValueChanged<SanctuaryMode>? onModeChanged;
  final VoidCallback onLogout;

  const MainScaffold({
    super.key,
    required this.mode,
    required this.onSwitchMode,
    this.onModeChanged,
    required this.onLogout,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;
  int _hoveredIndex = -1;
  late final PageController _pageController;
  late SanctuaryMode _currentMode;

  @override
  void initState() {
    super.initState();
    _currentMode = widget.mode;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void didUpdateWidget(MainScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mode != oldWidget.mode) {
      setState(() {
        _currentMode = widget.mode;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
      if (_pageController.hasClients) {
        _pageController.jumpToPage(index);
      }
    }
  }

  void _handleModeChange(SanctuaryMode newMode) {
    if (_currentMode != newMode) {
      if (_currentMode == SanctuaryMode.kids && newMode != SanctuaryMode.kids) {
        // Require Parental PIN gate when exiting Kids Mode
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PinOrangTuaScreen(
              onSuccess: () {
                setState(() {
                  _currentMode = newMode;
                });
                widget.onModeChanged?.call(newMode);
              },
            ),
          ),
        );
        return;
      }
      setState(() {
        _currentMode = newMode;
      });
      widget.onModeChanged?.call(newMode);
    }
  }

  void _showQuickModePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryFixed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.swap_horiz_rounded, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pilih Ruang Ibadah / Akun',
                          style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                        Text(
                          'Beralih instan tanpa keluar dari sesi aplikasi',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...SanctuaryMode.values.map((mode) {
                  final isSelected = _currentMode == mode;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryFixed.withAlpha(80) : AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.hairline,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          mode.icon,
                          color: isSelected ? Colors.white : AppColors.primary,
                          size: 18,
                        ),
                      ),
                      title: Row(
                        children: [
                          Text(
                            '${mode.accountName} • ${mode.title}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : AppColors.outlineVariant.withAlpha(80),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              mode.badge,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        '${mode.accountRole} — ${mode.description}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.outline),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20)
                          : const Icon(Icons.chevron_right_rounded, color: AppColors.outline, size: 20),
                      onTap: () {
                        Navigator.pop(ctx);
                        _handleModeChange(mode);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle_rounded, color: Color(0xFF34D399), size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Beralih ke ${mode.title} ✦',
                                    style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showProfileModal(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileScreen(
          mode: _currentMode,
          onSwitchMode: () => _showQuickModePicker(context),
          onLogout: widget.onLogout,
          onSelectMode: (newMode) {
            _handleModeChange(newMode);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Color(0xFF34D399), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Berhasil beralih ke mode ${newMode.title} ✦',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 850;

    // Build tabs dynamically based on active mode
    final List<Widget> screens = [
      HomeScreen(
        mode: _currentMode,
        onSwitchMode: () => _showQuickModePicker(context),
        onModeChanged: _handleModeChange,
        onLogout: widget.onLogout,
        onNavigateTab: _onTabSelected,
      ),
      if (_currentMode == SanctuaryMode.sisterhood)
        SisterhoodScreen(onProfileTap: () => _showProfileModal(context))
      else if (_currentMode == SanctuaryMode.kids)
        KidsSanctuaryScreen(
          onExitKidsMode: () => _handleModeChange(SanctuaryMode.general),
          onProfileTap: () => _showProfileModal(context),
        )
      else
        HabitsTabScreen(onProfileTap: () => _showProfileModal(context)),
      QuranTabScreen(onProfileTap: () => _showProfileModal(context)),
      GameSanctuaryTabScreen(
        onSwitchToKids: () {
          if (_currentMode != SanctuaryMode.kids) {
            _handleModeChange(SanctuaryMode.kids);
          }
        },
        onProfileTap: () => _showProfileModal(context),
      ),
      MediaSanctuaryTabScreen(
        mode: _currentMode,
        onProfileTap: () => _showProfileModal(context),
      ),
      const QiblaCompassScreen(),
    ];

    // Rich Navigation Items with descriptive pertanda (hints, micro-badges, and labels)
    final List<Map<String, dynamic>> navItems = [
      {
        'icon': Icons.mosque,
        'label': 'Home',
        'badge': 'Sholat',
        'hint': 'Beranda Utama: Waktu Sholat Realtime, Jam WIB & Amalan Harian',
      },
      if (_currentMode == SanctuaryMode.sisterhood)
        {
          'icon': Icons.local_florist,
          'label': 'Sisterhood',
          'badge': 'Thaharah',
          'hint': 'Sisterhood Sanctuary: Siklus Haid, Masa Suci & Fiqih Muslimah',
        }
      else if (_currentMode == SanctuaryMode.kids)
        {
          'icon': Icons.stars,
          'label': 'Kids',
          'badge': 'Ceria',
          'hint': 'Kids Sanctuary: Belajar Iqra, Tracing Huruf & Kuis Berkah',
        }
      else
        {
          'icon': Icons.task_alt,
          'label': 'Habits',
          'badge': 'Amalan',
          'hint': 'Mutaba\'ah Yaumiyah: Evaluasi & Target Ibadah Harian',
        },
      {
        'icon': Icons.menu_book,
        'label': 'Qur\'an',
        'badge': '30 Juz',
        'hint': 'Mushaf Digital: Baca Al-Qur\'an 30 Juz & Audio Tilawah',
      },
      {
        'icon': Icons.military_tech_rounded,
        'label': 'Game',
        'badge': 'Khazanah',
        'hint': 'Arena Edukatif: Kuis Sambung Ayat, Sirah & Fiqih',
      },
      {
        'icon': Icons.play_circle,
        'label': 'Media',
        'badge': 'Kajian',
        'hint': 'Media Syiar: Video Dakwah Singkat & Live Majelis Streaming',
      },
      if (isDesktop)
        {
          'icon': Icons.explore,
          'label': 'Kiblat',
          'badge': '295° NW',
          'hint': 'Arah Kiblat: Kompas Ka\'bah Presisi 295° NW & Waktu Adzan',
        },
    ];

    // ==========================================
    // 1. DESKTOP / WIDESCREEN WEB LAYOUT
    // Navigation is exclusively in the top navigation bar.
    // No floating mobile bottom nav dock on desktop.
    // ==========================================
    if (isDesktop) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        body: Column(
          children: [
            // Clean Unified Top Navigation Bar with Responsive Elastic Scaling
            Container(
              height: 70,
              padding: EdgeInsets.symmetric(horizontal: screenWidth > 1320 ? 24 : 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                border: const Border(bottom: BorderSide(color: AppColors.hairline)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(6),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Left Brand: Logo + Title + Hijri Date
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withAlpha(50),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.mosque, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                'NOOR SANCTUARY',
                                style: GoogleFonts.syne(
                                  fontSize: screenWidth > 1200 ? 15 : 13.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.0,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.auto_awesome, size: 12, color: AppColors.primary),
                            ],
                          ),
                          Text(
                            screenWidth > 1250
                                ? '14 RAMADHAN 1446 H • JAKARTA (WIB)'
                                : '14 RAMADHAN 1446 H',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Center: Desktop Nav Pills with smooth animated indicator
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(navItems.length, (idx) {
                      final item = navItems[idx];
                      final isSelected = _currentIndex == idx;
                      final hPad = screenWidth > 1320 ? 12.0 : (screenWidth > 1150 ? 8.0 : 5.0);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _onTabSelected(idx),
                          child: Tooltip(
                            message: item['hint'] as String,
                            waitDuration: const Duration(milliseconds: 300),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOutCubic,
                              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 7),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primaryFixed : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    item['icon'] as IconData,
                                    size: 16,
                                    color: isSelected ? AppColors.primary : AppColors.secondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    item['label'] as String,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                      color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  const Spacer(),

                  // Right: Mode Badge & Quick User Actions
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Active Mode Switcher Pill
                      GestureDetector(
                        onTap: () => _showQuickModePicker(context),
                        child: Tooltip(
                          message: 'Beralih Moda: ${_currentMode.title}',
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth > 1200 ? 12 : 8,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _currentMode.accentBg,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: AppColors.hairline),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(_currentMode.icon, size: 14, color: AppColors.primary),
                                if (screenWidth > 1100) ...[
                                  const SizedBox(width: 6),
                                  Text(
                                    _currentMode.title,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.onPrimaryFixed,
                                    ),
                                  ),
                                ],
                                const SizedBox(width: 4),
                                const Icon(Icons.swap_horiz, size: 14, color: AppColors.primary),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),

                      // Universal Search Button
                      IconButton(
                        tooltip: 'Pencarian Komprehensif (Surah, Kajian, Amalan)',
                        icon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 20),
                        padding: const EdgeInsets.all(6),
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        onPressed: () => showUniversalSearch(context, onNavigateTab: _onTabSelected),
                      ),

                      // Notification Bell
                      IconButton(
                        tooltip: 'Pusat Notifikasi & Pengingat',
                        padding: const EdgeInsets.all(6),
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        icon: Stack(
                          children: [
                            const Icon(Icons.notifications_outlined, color: AppColors.primary, size: 20),
                            Positioned(
                              right: 1,
                              top: 1,
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
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const PusatNotifikasiScreen()));
                        },
                      ),
                      const SizedBox(width: 4),

                      // User Profile Avatar (Synchronized with Active Mode)
                      GestureDetector(
                        onTap: () => _showProfileModal(context),
                        child: Tooltip(
                          message: 'Profil ${_currentMode.accountName} (${_currentMode.accountRole})',
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: _currentMode.accountColor,
                                child: Icon(
                                  _currentMode.accountIcon,
                                  size: 17,
                                  color: Colors.white,
                                ),
                              ),
                              if (screenWidth >= 1240) ...[
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _currentMode.accountName,
                                      style: GoogleFonts.syne(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                                    ),
                                    Text(
                                      _currentMode.accountRole,
                                      style: GoogleFonts.plusJakartaSans(fontSize: 9.5, color: AppColors.secondary),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Main Web Canvas Container with Smooth Page Slide Animation
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1240),
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (idx) => setState(() => _currentIndex = idx),
                    children: screens,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // ==========================================
    // 2. MOBILE / GADGET INSPECT LAYOUT
    // ==========================================
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // Smooth Tab Page Transition
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (idx) => setState(() => _currentIndex = idx),
            children: screens,
          ),

          // Pinned Floating Bottom Navigation with Pre-Tap Pertanda
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: _buildFloatingBottomNav(navItems),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // FLOATING BOTTOM NAV BAR WITH PERTANDA & ANIMATIONS
  // ==========================================
  Widget _buildFloatingBottomNav(List<Map<String, dynamic>> navItems) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest.withAlpha(235),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.hairline),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(22),
                blurRadius: 24,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(navItems.length, (idx) {
              final item = navItems[idx];
              final isSelected = _currentIndex == idx;
              final isHovered = _hoveredIndex == idx;

              return Expanded(
                child: Tooltip(
                  message: item['hint'] as String,
                  triggerMode: TooltipTriggerMode.manual,
                  waitDuration: const Duration(milliseconds: 250),
                  showDuration: const Duration(seconds: 3),
                  preferBelow: false,
                  verticalOffset: 24,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(40),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  textStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => setState(() => _hoveredIndex = idx),
                    onExit: (_) => setState(() => _hoveredIndex = -1),
                    child: GestureDetector(
                      onTap: () => _onTabSelected(idx),
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : isHovered
                                  ? AppColors.primaryFixed.withAlpha(90)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withAlpha(70),
                                    blurRadius: 14,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 1. Icon with Micro Animation
                            AnimatedScale(
                              scale: isSelected ? 1.15 : (isHovered ? 1.08 : 1.0),
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                item['icon'] as IconData,
                                size: 21,
                                color: isSelected
                                    ? Colors.white
                                    : (isHovered ? AppColors.primary : AppColors.secondary),
                              ),
                            ),
                            const SizedBox(height: 3),

                            // 2. Always-Visible Label
                            Text(
                              item['label'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : (isHovered ? AppColors.primary : AppColors.onSurface),
                                letterSpacing: -0.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 1),

                            // 3. Pre-Tap Pertanda (Micro Badge / Status)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white.withAlpha(45)
                                    : (isHovered
                                        ? AppColors.primary.withAlpha(25)
                                        : AppColors.surfaceContainerLow),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item['badge'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 8.5,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white.withAlpha(230)
                                      : (isHovered ? AppColors.primary : AppColors.onSurfaceVariant),
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
