import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/sanctuary_mode.dart';
import '../../theme/app_colors.dart';
import '../kids/pin_orang_tua_dialog.dart';
import '../sisterhood/catat_siklus_screen.dart';
import 'edit_profile_screen.dart';
import 'logout_confirmation_dialog.dart';
import 'setting_modals.dart';

class ProfileScreen extends StatefulWidget {
  final SanctuaryMode mode;
  final VoidCallback onSwitchMode;
  final VoidCallback onLogout;
  final ValueChanged<SanctuaryMode>? onSelectMode;

  const ProfileScreen({
    super.key,
    required this.mode,
    required this.onSwitchMode,
    required this.onLogout,
    this.onSelectMode,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late SanctuaryMode _currentMode;
  String _userName = 'Aisyah Nurul Iman';
  String _userKunyah = 'Ummu Rayyan';

  // Sisterhood preferences
  bool _sholatReminder = true;
  bool _privacyCycle = true;

  // Kids preferences
  bool _kidsAdzanReminder = true;

  @override
  void initState() {
    super.initState();
    _currentMode = widget.mode;
  }

  void _switchSanctuaryMode(SanctuaryMode targetMode) {
    if (_currentMode == SanctuaryMode.kids && targetMode != SanctuaryMode.kids) {
      // Require PIN Bunda to exit kids mode!
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PinOrangTuaScreen(
            onSuccess: () {
              setState(() => _currentMode = targetMode);
              widget.onSelectMode?.call(targetMode);
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
        ),
      );
    } else {
      setState(() => _currentMode = targetMode);
      widget.onSelectMode?.call(targetMode);
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  void _openEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          currentMode: _currentMode,
          onProfileSaved: (name, kunyah) {
            setState(() {
              if (name.isNotEmpty) _userName = name;
              if (kunyah.isNotEmpty) _userKunyah = kunyah;
            });
          },
          onSwitchMode: _switchSanctuaryMode,
        ),
      ),
    );
  }

  void _openLogoutConfirmation() {
    LogoutConfirmationDialog.show(
      context,
      currentMode: _currentMode,
      onLogout: widget.onLogout,
      onSwitchMode: _switchSanctuaryMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _currentMode == SanctuaryMode.sisterhood
              ? 'Profil & Pengaturan Sisterhood'
              : _currentMode == SanctuaryMode.kids
                  ? 'Profil & Pengaturan Kids Mode'
                  : 'Profil & Pengaturan',
          style: GoogleFonts.syne(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.primary),
        ),
        actions: [
          if (_currentMode == SanctuaryMode.kids)
            Container(
              margin: const EdgeInsets.only(right: 12),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryFixed,
                  foregroundColor: AppColors.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PinOrangTuaScreen(onSuccess: () {}),
                    ),
                  );
                },
                icon: const Icon(Icons.lock_rounded, size: 14),
                label: Text('Izin Orang Tua', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.qr_code_scanner_rounded, size: 20, color: AppColors.primary),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ID Barcode Sanctuary Santri Aktif: #SNC-8912-7840')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.share_outlined, size: 20, color: AppColors.primary),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tautan kartu profil santri disalin!')),
                );
              },
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: _currentMode == SanctuaryMode.sisterhood
            ? _buildSisterhoodProfile()
            : _currentMode == SanctuaryMode.kids
                ? _buildKidsProfile()
                : _buildGeneralProfile(),
      ),
    );
  }

  // ==========================================
  // 1. GENERAL SANCTUARY PROFIL
  // ==========================================
  Widget _buildGeneralProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.lavender.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryFixed, width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 36, color: AppColors.primary),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: AppColors.goldAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, size: 12, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userName,
                      style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$_userKunyah • aisyah.iman@sanctuary.id',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.outline),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryFixed.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 5, height: 5, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                          const SizedBox(width: 5),
                          Text(
                            'Santri Sanctuary • Aktif',
                            style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: AppColors.hairline),
                  ),
                ),
                onPressed: _openEditProfile,
                icon: const Icon(Icons.edit_outlined, size: 14),
                label: Text('Edit', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Section: Capaian Keistiqomahan
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.settings_outlined, size: 15, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  'CAPAIAN KEISTIQOMAHAN',
                  style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w800, letterSpacing: 0.5, color: AppColors.primary),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: AppColors.secondaryFixed, borderRadius: BorderRadius.circular(8)),
              child: Text('1446 H', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.onSecondaryFixed)),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 4 Stat Cards
        Row(
          children: [
            _buildStatCard(Icons.menu_book_rounded, '2x', 'Khatam\nQur\'an', AppColors.powderBlue),
            const SizedBox(width: 8),
            _buildStatCard(Icons.spa_rounded, '18.4k', 'Dzikir\nTasbih', AppColors.mistySage),
            const SizedBox(width: 8),
            _buildStatCard(Icons.groups_rounded, '34', 'Majelis\nIlmu', AppColors.lavender),
            const SizedBox(width: 8),
            _buildStatCard(Icons.volunteer_activism_rounded, '89 Hari', 'Sedekah\nSubuh', AppColors.secondaryFixed),
          ],
        ),
        const SizedBox(height: 24),

        // Section: Akses Khazanah Qalbu
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'AKSES KHAZANAH QALBU',
              style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w800, letterSpacing: 0.5, color: AppColors.outline),
            ),
            Text(
              'Sering Dibuka',
              style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 2x2 Grid Khazanah
        Row(
          children: [
            Expanded(
              child: _buildKhazanahTile(
                icon: Icons.auto_stories_outlined,
                title: 'Riwayat Tilawah',
                subtitle: 'Juz 15 • Hal 294',
                color: AppColors.lavender,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Membuka mushaf Juz 15 Halaman 294...')),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildKhazanahTile(
                icon: Icons.edit_note_rounded,
                title: 'Catatan Tadabbur',
                subtitle: '14 Renungan Jiwa',
                color: AppColors.mistySage,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Membuka 14 Catatan Tadabbur Qolbu...')),
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
              child: _buildKhazanahTile(
                icon: Icons.bookmark_border_rounded,
                title: 'Bookmark Doa & Wirid',
                subtitle: '27 Ayat & Wirid',
                color: AppColors.secondaryFixed,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Membuka daftar 27 Ayat & Doa tersimpan...')),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildKhazanahTile(
                icon: Icons.schedule_rounded,
                title: 'Jadwal Sholat & Adzan',
                subtitle: 'Ashar 15:18 WIB',
                color: AppColors.powderBlue,
                onTap: () => SettingModals.showNotifikasiSettings(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),

        // Section: Pengaturan Umum
        Text(
          'PENGATURAN UMUM',
          style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w800, letterSpacing: 0.5, color: AppColors.outline),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Column(
            children: [
              _buildSettingRow(
                icon: Icons.notifications_none_rounded,
                iconBg: AppColors.lavender,
                title: 'Notifikasi & Waktu Ibadah',
                subtitle: 'Adzan Syaikh Mishary • 10 mnt',
                onTap: () => SettingModals.showNotifikasiSettings(context),
              ),
              const Divider(height: 1),
              _buildSettingRow(
                icon: Icons.explore_outlined,
                iconBg: AppColors.powderBlue,
                title: 'Metode Perhitungan & Madzhab',
                subtitle: 'Syafi\'i • Kemenag RI (Subuh 20°)',
                onTap: () => SettingModals.showMadzhabSettings(context),
              ),
              const Divider(height: 1),
              _buildSettingRow(
                icon: Icons.cloud_download_outlined,
                iconBg: AppColors.mistySage,
                title: 'Unduhan Audio Murottal & Offline',
                subtitle: '30 Juz Tersimpan Lokal (1.4 GB)',
                onTap: () => SettingModals.showOfflineDownloadSettings(context),
              ),
              const Divider(height: 1),
              _buildSettingRow(
                icon: Icons.text_fields_rounded,
                iconBg: AppColors.secondaryFixed,
                title: 'Tampilan & Ukuran Font Arab',
                subtitle: 'Khat Utsmani Hafsh • Ukuran Standar',
                onTap: () => SettingModals.showFontSettings(context),
              ),
              const Divider(height: 1),
              _buildSettingRow(
                icon: Icons.fingerprint_rounded,
                iconBg: AppColors.lavender,
                title: 'Privasi & Keamanan Data',
                subtitle: 'Kunci Biometrik/PIN Aktif • Sinkron',
                onTap: () => SettingModals.showPrivacySettings(context),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Section: Akun Santri Cilik Tertaut (Family Control)
        _buildFamilyKidsAccountCard(),
        const SizedBox(height: 28),

        // Section: Suasana Sanctuary
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, size: 14, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  'SUASANA SANCTUARY',
                  style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w800, letterSpacing: 0.5, color: AppColors.primary),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(10)),
              child: Text('Beralih Instan', style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 3 Suasana Mode Radio Cards
        _buildModeCard(
          mode: SanctuaryMode.general,
          title: 'General Sanctuary',
          badge: 'Aktif',
          description: 'Ruang hening universal untuk tilawah, sholat, serta kedamaian harian tanpa distraksi.',
          icon: Icons.spa_outlined,
        ),
        const SizedBox(height: 10),
        _buildModeCard(
          mode: SanctuaryMode.sisterhood,
          title: '🌸 Sisterhood Mode',
          badge: 'Khusus Nisa\'',
          description: 'Aksen lavender-rose, pelacak siklus suci/haid islami, fiqih wanita & lingkaran ukhuwah.',
          icon: Icons.favorite_border_rounded,
        ),
        const SizedBox(height: 10),
        _buildModeCard(
          mode: SanctuaryMode.kids,
          title: '🎈 Kids Sanctuary',
          badge: 'Anak Santri',
          description: 'Petualangan ceria belajar Hijaiyah, animasi kisah 25 nabi & doa harian berpahala bintang.',
          icon: Icons.child_care_rounded,
        ),
        const SizedBox(height: 28),

        // Keluar Akun / Ganti Akun Section Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.logout_rounded, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Keluar Akun / Ganti Akun',
                    style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Data ibadah Anda terenkripsi aman di Cloud',
                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.outline),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lavender.withValues(alpha: 0.6),
                        foregroundColor: AppColors.primary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _openLogoutConfirmation,
                      child: Text('Ganti Akun', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _openLogoutConfirmation,
                      icon: const Icon(Icons.power_settings_new_rounded, size: 16),
                      label: Text('Keluar Sesi', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Footer Quote & Version
        Center(
          child: Column(
            children: [
              Text(
                '"Istiqomah adalah anugerah terindah bagi jiwa yang merindukan-Nya."',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.outline),
              ),
              const SizedBox(height: 6),
              Text(
                'Sanctuary App v2.4.0 • Dibuat dengan cinta untuk Ummah',
                style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outlineVariant),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  // ==========================================
  // 2. SISTERHOOD SANCTUARY PROFIL
  // ==========================================
  Widget _buildSisterhoodProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sisterhood User Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFFFD1DC)),
          ),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE91E63), width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.face_3_rounded, size: 36, color: Color(0xFFC2185B)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE91E63),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite, size: 12, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$_userName ($_userKunyah)',
                      style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'aisyah.nuruliman@sanctuary.id',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.outline),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD1DC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.auto_awesome, size: 10, color: Color(0xFFC2185B)),
                          const SizedBox(width: 4),
                          Text(
                            'Sisterhood Akhwat • Aktif',
                            style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w700, color: const Color(0xFFC2185B)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                onPressed: _openEditProfile,
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),

        // FITUR KHUSUS SISTERHOOD
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFE91E63), shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text(
                  'FITUR KHUSUS SISTERHOOD',
                  style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w800, letterSpacing: 0.5, color: const Color(0xFFC2185B)),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: const Color(0xFFFFE4E6), borderRadius: BorderRadius.circular(8)),
              child: Text('Eksklusif Mode', style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w700, color: const Color(0xFFC2185B))),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Status & Siklus Thaharah Card with Gauge Ring
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // Gauge Ring
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE91E63), width: 6),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('14', style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFFE91E63))),
                          Text('HARI SUCI', style: GoogleFonts.plusJakartaSans(fontSize: 7.5, fontWeight: FontWeight.w800, color: AppColors.outline)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                          child: Text('Fase Suci / Thuhur', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.green[800])),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Status & Siklus Thaharah',
                          style: GoogleFonts.syne(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Estimasi 12 hari lagi menuju siklus haid. Ibadah sholat & puasa wajib penuh.',
                          style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.onSurfaceVariant, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD81B60),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CatatSiklusScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.water_drop_outlined, size: 16),
                      label: Text('Catat Siklus Baru / Flek', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.outlineVariant),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Menampilkan riwayat siklus 12 bulan terakhir...')),
                        );
                      },
                      icon: const Icon(Icons.calendar_month_outlined, size: 16, color: AppColors.primary),
                      label: Text('Riwayat', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Khadijah Circle #04 Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: Color(0xFFFFE4E6), shape: BoxShape.circle),
                    child: const Icon(Icons.spa_rounded, size: 18, color: Color(0xFFE91E63)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Khadijah Circle #04', style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(6)),
                              child: Text('Halaqah Tilawah', style: GoogleFonts.plusJakartaSans(fontSize: 8.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                            ),
                          ],
                        ),
                        Text('Grup Khataman Bersama • Target Rajab', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline)),
                      ],
                    ),
                  ),
                  Text('75%', style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFFE91E63))),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: const LinearProgressIndicator(
                  value: 0.75,
                  minHeight: 6,
                  backgroundColor: Color(0xFFFFE4E6),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91E63)),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tugas Antum: Juz 14 (Al-Hijr)', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Membuka formulir setor bacaan halaqah...')),
                      );
                    },
                    child: Row(
                      children: [
                        Text('Setor Bacaan', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFFC2185B))),
                        const Icon(Icons.arrow_forward_ios, size: 10, color: Color(0xFFC2185B)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),

        // Ringkasan Ibadah Muslimah
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ringkasan Ibadah Muslimah', style: GoogleFonts.syne(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
            Text('Sinkronisasi Utama', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildSisterhoodStatTile(Icons.calendar_today_outlined, 'Hutang Puasa', '0 Hari (Lunas)', 'Qadha tuntas ✓', Colors.green),
            const SizedBox(width: 8),
            _buildSisterhoodStatTile(Icons.menu_book_rounded, 'Khatam Qur\'an', '2x Khatam', 'Tahun 1446 H', AppColors.primary),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildSisterhoodStatTile(Icons.pin_outlined, 'Total Dzikir', '18.4k Dzikir', 'Tasbih digital', AppColors.primary),
            const SizedBox(width: 8),
            _buildSisterhoodStatTile(Icons.school_outlined, 'Kajian Fiqih Nisa\'', '12 Sesi Hadir', 'Sertifikat Akhwat', const Color(0xFFC2185B)),
          ],
        ),
        const SizedBox(height: 12),

        // 3 Quick Pills
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildQuickPill(Icons.menu_book_rounded, 'Jurnal Thaharah', const Color(0xFFFFD1DC)),
            _buildQuickPill(Icons.volunteer_activism_rounded, 'Dhuha & Sedekah', const Color(0xFFFFE4E6)),
            _buildQuickPill(Icons.favorite_border_rounded, 'Doa Muslimah', const Color(0xFFFFE4E6)),
          ],
        ),
        const SizedBox(height: 24),

        // Preferensi & Pengaturan Ibadah
        Text('Preferensi & Pengaturan Ibadah', style: GoogleFonts.syne(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Column(
            children: [
              SwitchListTile(
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Color(0xFFFFE4E6), shape: BoxShape.circle),
                  child: const Icon(Icons.notifications_active_outlined, size: 18, color: Color(0xFFC2185B)),
                ),
                title: Text('Pengingat Mandi Wajib & Waktu Sholat', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                subtitle: Text('Notifikasi lembut sebelum waktu qadha & sholat berakhir', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline)),
                value: _sholatReminder,
                activeThumbColor: const Color(0xFFC2185B),
                activeTrackColor: const Color(0xFFFFCCD5),
                onChanged: (val) => setState(() => _sholatReminder = val),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.lavender, shape: BoxShape.circle),
                  child: const Icon(Icons.schedule_rounded, size: 18, color: AppColors.primary),
                ),
                title: Text('Metode Perhitungan Sholat', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                subtitle: Text('Kemenag RI • Subuh 20.0°, Ashar Syafi\'i', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                onTap: () => SettingModals.showMadzhabSettings(context),
              ),
              const Divider(height: 1),
              SwitchListTile(
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Color(0xFFFFE4E6), shape: BoxShape.circle),
                  child: const Icon(Icons.lock_outline_rounded, size: 18, color: Color(0xFFC2185B)),
                ),
                title: Text('Privasi Siklus (Kunci PIN / Biometrik)', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                subtitle: Text('Jaga kerahasiaan catatan thaharah & masa nifas', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline)),
                value: _privacyCycle,
                activeThumbColor: const Color(0xFFC2185B),
                activeTrackColor: const Color(0xFFFFCCD5),
                onChanged: (val) => setState(() => _privacyCycle = val),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Color(0xFFFFE4E6), shape: BoxShape.circle),
                  child: const Icon(Icons.volume_up_outlined, size: 18, color: Color(0xFFC2185B)),
                ),
                title: Text('Tampilan & Suara Adzan', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                subtitle: Text('Adzan Makkah lembut & tema Rose Sanctuary', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                onTap: () => SettingModals.showNotifikasiSettings(context),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Section: Akun Santri Cilik Tertaut (Family Control)
        _buildFamilyKidsAccountCard(),
        const SizedBox(height: 24),

        // Ganti Mode Aplikasi
        Text('Ganti Mode Aplikasi', style: GoogleFonts.syne(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
        Text('Beralih mode tampilan & modul ibadah', style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.outline)),
        const SizedBox(height: 10),

        _buildModeCard(
          mode: SanctuaryMode.general,
          title: 'General Sanctuary',
          badge: '',
          description: 'Fitur ibadah universal untuk seluruh keluarga',
          icon: Icons.spa_outlined,
        ),
        const SizedBox(height: 8),
        _buildModeCard(
          mode: SanctuaryMode.sisterhood,
          title: 'Sisterhood Mode',
          badge: 'Aktif',
          description: 'Fitur General + Fiqih Thaharah, Siklus, & Circle Khusus',
          icon: Icons.favorite_border_rounded,
        ),
        const SizedBox(height: 8),
        _buildModeCard(
          mode: SanctuaryMode.kids,
          title: 'Kids Sanctuary',
          badge: '',
          description: 'Petualangan belajar sholat & hafalan anak seru',
          icon: Icons.child_care_rounded,
        ),
        const SizedBox(height: 24),

        // Keluar Akun Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFFD1DC)),
          ),
          child: Column(
            children: [
              TextButton.icon(
                onPressed: _openLogoutConfirmation,
                icon: const Icon(Icons.logout_rounded, color: Color(0xFFC2185B)),
                label: Text(
                  'Keluar Akun / Ganti Akun',
                  style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFFC2185B)),
                ),
              ),
              Text(
                'Masuk sebagai Aisyah Nurul Iman. Semua data ibadah tersinkronisasi aman ke cloud.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Footer Hadits
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF5F7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(
                '"Dunia adalah perhiasan, dan sebaik-baik perhiasan dunia adalah wanita yang shalihah."',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(fontSize: 11, fontStyle: FontStyle.italic, color: const Color(0xFFC2185B)),
              ),
              const SizedBox(height: 4),
              Text(
                'HR. MUSLIM • NO. 1467',
                style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w800, color: const Color(0xFFC2185B)),
              ),
              const SizedBox(height: 6),
              Text('Sanctuary Muslimah Edition • v2.8.4', style: GoogleFonts.plusJakartaSans(fontSize: 9.5, color: AppColors.outlineVariant)),
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  // ==========================================
  // 3. KIDS SANCTUARY PROFIL
  // ==========================================
  Widget _buildKidsProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kids User Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFFDE7), Color(0xFFFFF8E1)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFFFE082)),
          ),
          child: Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 38,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.face_rounded, size: 48, color: Colors.green),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Lv.3', style: GoogleFonts.syne(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.black)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ahmad Rayyan',
                      style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFFFE082), borderRadius: BorderRadius.circular(8)),
                      child: Text('Anak', style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w700, color: Colors.brown)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text('Penjelajah Bintang Hijaiyah', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.outline)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFFE082)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '48 Bintang Terkumpul ✩',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w800, color: Colors.brown),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Akun Orang Tua Tertaut Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFFE082)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.lavender.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.family_restroom, size: 18, color: AppColors.primary),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Akun Orang Tua Tertaut',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                                ),
                                const SizedBox(width: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F5E9),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Terhubung',
                                    style: GoogleFonts.plusJakartaSans(fontSize: 8.5, fontWeight: FontWeight.w700, color: const Color(0xFF2E7D32)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 1),
                            Text(
                              'Ummu Rayyan (Aisyah)',
                              style: GoogleFonts.syne(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                            ),
                            Text(
                              'Batas layar & konten diawasi akun orang tua',
                              style: GoogleFonts.plusJakartaSans(fontSize: 9.5, color: AppColors.outline),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.shield_outlined, size: 18, color: AppColors.primary),
                        tooltip: 'Verifikasi Izin Orang Tua',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PinOrangTuaScreen(onSuccess: () {}),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Fitur Eksklusif Kids Mode
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.directions_car_rounded, size: 16, color: Colors.amber),
                const SizedBox(width: 6),
                Text(
                  'Fitur Eksklusif Kids Mode',
                  style: GoogleFonts.syne(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: const Color(0xFFFFECB3), borderRadius: BorderRadius.circular(8)),
              child: Text('KIDS SPECIAL', style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.brown)),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 1. Peta Petualangan Hijaiyah
        _buildKidsFeatureCard(
          iconLetter: 'ح',
          iconColor: Colors.amber[800]!,
          title: 'Peta Petualangan Hijaiyah',
          badge: 'Aktif',
          subtitle: 'Bintang(3) — Pulau Huruf Ha',
          actionText: 'Main',
          onTap: () {},
        ),
        const SizedBox(height: 10),

        // 2. Kisah 25 Nabi Anak
        _buildKidsFeatureCard(
          iconData: Icons.menu_book_rounded,
          iconColor: Colors.teal,
          title: 'Kisah 25 Nabi Anak',
          badge: '',
          subtitle: 'Nabi Nuh & Bahtera Kasih Sayang\nTerakhir dibaca bab 2',
          actionText: 'Baca',
          onTap: () {},
        ),
        const SizedBox(height: 10),

        // 3. Tantangan Dzikir Ceria
        _buildKidsFeatureCard(
          iconData: Icons.volunteer_activism_rounded,
          iconColor: Colors.lightBlue,
          title: 'Tantangan Dzikir Ceria',
          badge: '15 / 15 Selesai',
          subtitle: '15 butir Tasbih Pagi terselesaikan hari ini! ✨\n✔ Subhanallah wa Bihamdihi',
          actionText: 'Hebat',
          onTap: () {},
        ),
        const SizedBox(height: 24),

        // Pengaturan & Fitur Santun Anak (Diproteksi PIN)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.tune_rounded, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  'Pengaturan & Fitur Santun Anak',
                  style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ],
            ),
            Text('Diproteksi PIN', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline)),
          ],
        ),
        const SizedBox(height: 10),

        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.lavender, shape: BoxShape.circle),
                  child: const Icon(Icons.auto_stories_rounded, size: 18, color: AppColors.primary),
                ),
                title: Text('Capaian Hafalan Qur\'an', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                subtitle: Text('Juz \'Amma: 8 Surat Hafal Lancar', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline)),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryFixed,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {},
                  child: Text('Lihat', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700)),
                ),
              ),
              const Divider(height: 1),
              SwitchListTile(
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Color(0xFFFFF8E1), shape: BoxShape.circle),
                  child: const Icon(Icons.notifications_active_outlined, size: 18, color: Colors.amber),
                ),
                title: Text('Pengingat Sholat & Adzan Ceria', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                subtitle: Text('Suara adzan kartun santun anak', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline)),
                value: _kidsAdzanReminder,
                activeThumbColor: Colors.teal,
                activeTrackColor: Colors.teal.withValues(alpha: 0.3),
                onChanged: (val) => setState(() => _kidsAdzanReminder = val),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Color(0xFFFFEBEE), shape: BoxShape.circle),
                  child: const Icon(Icons.timer_outlined, size: 18, color: Colors.red),
                ),
                title: Text('Batas Waktu Layar (Screen Time)', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                subtitle: Text('45 Menit / Hari • Sisa 20 Menit', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline)),
                trailing: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PinOrangTuaScreen(onSuccess: () {}),
                      ),
                    );
                  },
                  child: Text('Ubah', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700)),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.mistySage, shape: BoxShape.circle),
                  child: const Icon(Icons.verified_user_outlined, size: 18, color: Colors.teal),
                ),
                title: Text('Filter Konten & Murattal Cilik', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                subtitle: Text('Bebas iklan, tempo qari ramah anak', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline)),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.teal.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                  child: Text('Aktif', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.teal[800])),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.lavender, shape: BoxShape.circle),
                  child: const Icon(Icons.pin_outlined, size: 18, color: AppColors.primary),
                ),
                title: Text('Kunci Izin Orang Tua (Parental Gate)', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                subtitle: Text('Proteksi PIN keluar mode & durasi layar', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline)),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PinOrangTuaScreen(onSuccess: () {}),
                      ),
                    );
                  },
                  child: Text('Atur PIN', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Ganti Mode Sanctuary (Perlu PIN)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ganti Mode Sanctuary', style: GoogleFonts.syne(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: AppColors.lavender, borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  const Icon(Icons.lock_rounded, size: 10, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text('Perlu PIN', style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: _buildKidsModeCard(SanctuaryMode.general, 'General', 'Mode Utama', Icons.spa_outlined),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildKidsModeCard(SanctuaryMode.sisterhood, 'Sisterhood', '+ Fikih Wanita', Icons.favorite_border_rounded),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildKidsModeCard(SanctuaryMode.kids, 'Kids Mode', 'Sedang Aktif', Icons.child_care_rounded, isSelected: true),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Keluar Akun (Verifikasi PIN)
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFFFCDD2)),
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PinOrangTuaScreen(onSuccess: _openLogoutConfirmation),
              ),
            );
          },
          icon: const Icon(Icons.logout_rounded, size: 16, color: Color(0xFFC62828)),
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Keluar Akun / Ganti Akun',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFFC62828)),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(6)),
                child: Text('Verifikasi PIN', style: GoogleFonts.plusJakartaSans(fontSize: 8.5, color: const Color(0xFFC62828))),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Center(
          child: Column(
            children: [
              Text('Sanctuary Kids Edition v2.4.0', style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.outline)),
              const SizedBox(height: 2),
              Text('Lingkungan Digital Islami Bersih, Terverifikasi & Aman', style: GoogleFonts.plusJakartaSans(fontSize: 9.5, color: AppColors.outlineVariant)),
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  // ==========================================
  // HELPER WIDGETS
  // ==========================================

  Widget _buildFamilyKidsAccountCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.family_restroom, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    'AKUN SANTRI CILIK TERTAUT',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Terhubung',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.face_rounded, size: 26, color: Colors.green),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Ahmad Rayyan',
                          style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8E1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '7 Tahun',
                            style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.brown),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Waktu Layar: Sisa 20/45 Menit • 8 Surat Hafalan',
                      style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.secondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _switchSanctuaryMode(SanctuaryMode.kids),
                  icon: const Icon(Icons.child_care_rounded, size: 16),
                  label: Text(
                    'Masuk Mode Anak',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.hairline),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PinOrangTuaScreen(onSuccess: () {}),
                    ),
                  );
                },
                icon: const Icon(Icons.tune_rounded, size: 14, color: AppColors.primary),
                label: Text(
                  'Atur Izin & PIN',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label, Color bg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: bg.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.hairline),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(fontSize: 9.5, color: AppColors.onSurfaceVariant, height: 1.2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKhazanahTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.hairline),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.syne(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(fontSize: 9.5, color: AppColors.outline),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconBg.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.outline),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: AppColors.outline),
    );
  }

  Widget _buildModeCard({
    required SanctuaryMode mode,
    required String title,
    required String badge,
    required String description,
    required IconData icon,
  }) {
    final isSelected = _currentMode == mode;
    return GestureDetector(
      onTap: () => _switchSanctuaryMode(mode),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryFixed.withValues(alpha: 0.3) : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.hairline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 20,
                color: isSelected ? AppColors.primary : AppColors.outline,
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
                          title,
                          style: GoogleFonts.syne(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (badge.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : AppColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            badge,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant, height: 1.35),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSisterhoodStatTile(IconData icon, String title, String value, String subtitle, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.hairline),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFFFE4E6), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 18, color: const Color(0xFFC2185B)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 9.5, color: AppColors.outline)),
                  Text(value, style: GoogleFonts.syne(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
                  Text(subtitle, style: GoogleFonts.plusJakartaSans(fontSize: 9, color: AppColors.outline)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickPill(IconData icon, String label, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFCCD5)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFFC2185B)),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700, color: const Color(0xFFC2185B)),
          ),
        ],
      ),
    );
  }

  Widget _buildKidsFeatureCard({
    String? iconLetter,
    IconData? iconData,
    required Color iconColor,
    required String title,
    required String badge,
    required String subtitle,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: iconLetter != null
                  ? Text(iconLetter, style: GoogleFonts.amiri(fontSize: 22, fontWeight: FontWeight.bold, color: iconColor))
                  : Icon(iconData, color: iconColor, size: 22),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: GoogleFonts.syne(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    if (badge.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(color: const Color(0xFFFFF8E1), borderRadius: BorderRadius.circular(6)),
                        child: Text(badge, style: GoogleFonts.plusJakartaSans(fontSize: 8.5, fontWeight: FontWeight.w700, color: Colors.brown)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: iconColor,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: onTap,
            child: Text(actionText, style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _buildKidsModeCard(SanctuaryMode mode, String title, String subtitle, IconData icon, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () => _switchSanctuaryMode(mode),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF8E1) : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.amber : AppColors.hairline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: isSelected ? Colors.amber : AppColors.lavender,
              child: Icon(icon, size: 16, color: isSelected ? Colors.white : AppColors.primary),
            ),
            const SizedBox(height: 6),
            Text(title, style: GoogleFonts.syne(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
            Text(subtitle, style: GoogleFonts.plusJakartaSans(fontSize: 8.5, color: isSelected ? Colors.brown : AppColors.outline)),
          ],
        ),
      ),
    );
  }
}
