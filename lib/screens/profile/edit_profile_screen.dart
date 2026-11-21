import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/sanctuary_mode.dart';
import '../../theme/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  final SanctuaryMode currentMode;
  final Function(String name, String kunyah)? onProfileSaved;
  final ValueChanged<SanctuaryMode>? onSwitchMode;

  const EditProfileScreen({
    super.key,
    required this.currentMode,
    this.onProfileSaved,
    this.onSwitchMode,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _kunyahController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;

  int _selectedAvatarIndex = 0;
  late SanctuaryMode _selectedMode;
  String _selectedMadzhab = 'Syafi\'i (Standar Kemenag RI)';
  String _selectedQari = 'Syaikh Misyari Rasyid Al-Afasy (Tartil Merdu)';

  bool _hideSedekahHistory = true;
  bool _communityStreakStatus = true;
  final List<String> _pinDigits = ['8', '2', '5', '1'];

  final List<IconData> _avatarIcons = [
    Icons.person_pin,
    Icons.face_3_rounded,
    Icons.mosque_rounded,
    Icons.directions_walk_rounded,
    Icons.sentiment_satisfied_alt_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _selectedMode = widget.currentMode;
    _nameController = TextEditingController(text: 'Aisyah Nurul Iman');
    _kunyahController = TextEditingController(text: 'Ummu Rayyan');
    _emailController = TextEditingController(text: 'aisyah.nurul@sanctuary.id');
    _phoneController = TextEditingController(text: '+62 812-3456-7890');
    _cityController = TextEditingController(text: 'Jakarta Pusat (WIB / GMT+7)');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _kunyahController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _handleSave() {
    widget.onProfileSaved?.call(
      _nameController.text.trim(),
      _kunyahController.text.trim(),
    );

    if (_selectedMode != widget.currentMode) {
      widget.onSwitchMode?.call(_selectedMode);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perubahan profil & preferensi ibadah berhasil disimpan!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  void _showChangePinDialog() {
    final pinControllers = List.generate(4, (_) => TextEditingController());
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            'Ubah PIN Kids Mode',
            style: GoogleFonts.syne(fontWeight: FontWeight.w700),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Masukkan 4 digit PIN baru untuk proteksi mode santri anak:'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (i) {
                    return SizedBox(
                      width: 48,
                      child: TextField(
                        controller: pinControllers[i],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: AppColors.surfaceContainerLow,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                setState(() {
                  for (int i = 0; i < 4; i++) {
                    if (pinControllers[i].text.isNotEmpty) {
                      _pinDigits[i] = pinControllers[i].text;
                    }
                  }
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PIN Bunda berhasil diperbarui!')),
                );
              },
              child: const Text('Simpan PIN'),
            ),
          ],
        );
      },
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
          'Edit Profile',
          style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, -4)),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: AppColors.outlineVariant),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Batal',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: _handleSave,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_rounded, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'Simpan Perubahan',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar Header
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primaryFixed, width: 3),
                        ),
                        child: CircleAvatar(
                          radius: 46,
                          backgroundColor: AppColors.lavender,
                          child: Icon(
                            _avatarIcons[_selectedAvatarIndex],
                            size: 48,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _nameController.text,
                    style: GoogleFonts.syne(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Personalisasikan ritme spiritual & identitas diri',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Pilihan Avatar Santun
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PILIHAN AVATAR SANTUN',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: AppColors.outline,
                  ),
                ),
                Text(
                  '5 Siluet Santun',
                  style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_avatarIcons.length, (idx) {
                final isSelected = _selectedAvatarIndex == idx;
                return GestureDetector(
                  onTap: () => setState(() => _selectedAvatarIndex = idx),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppColors.primaryFixed : AppColors.hairline,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      _avatarIcons[idx],
                      color: isSelected ? Colors.white : AppColors.primary,
                      size: 24,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // Section: Data Pribadi
            _buildSectionHeader(Icons.person_outline_rounded, 'Data Pribadi'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.hairline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('Nama Lengkap'),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _nameController,
                    suffixIcon: Icons.edit_outlined,
                  ),
                  const SizedBox(height: 16),

                  _buildFieldLabelWithBadge('Nama Panggilan / Kunyah', 'Tampil di Salam Harian'),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _kunyahController,
                    suffixIcon: Icons.face_rounded,
                  ),
                  const SizedBox(height: 16),

                  _buildFieldLabelWithBadge('Alamat Email', '✔ Terverifikasi'),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _emailController,
                    suffixIcon: Icons.check_circle_rounded,
                    suffixColor: Colors.green,
                  ),
                  const SizedBox(height: 16),

                  _buildFieldLabelWithBadge('Nomor WhatsApp', '✔ Sinkron Notifikasi OTP'),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _phoneController,
                    suffixIcon: Icons.chat_rounded,
                  ),
                  const SizedBox(height: 16),

                  _buildFieldLabel('Kota & Zona Waktu Domisili'),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 18, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _cityController.text,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.powderBlue,
                          foregroundColor: AppColors.primary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Lokasi & zona waktu berhasil disinkronkan dengan GPS!')),
                          );
                        },
                        icon: const Icon(Icons.sync_rounded, size: 16),
                        label: Text(
                          'Sync',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Menyelaraskan akurasi adzan & perhitungan arah kiblat setempat.',
                    style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section: Preferensi Pengalaman Ibadah
            _buildSectionHeader(Icons.spa_outlined, 'Preferensi Pengalaman Ibadah'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.hairline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mode Utama Tampilan Aplikasi',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Mode 1: General Sanctuary
                  _buildModeRadio(
                    mode: SanctuaryMode.general,
                    title: 'General Sanctuary',
                    badge: 'Tenang & Rekomendasi',
                    description: 'Jadwal sholat presisi, mushaf reflektif harian, & dzikir hening.',
                  ),
                  const SizedBox(height: 8),

                  // Mode 2: Sisterhood Mode
                  _buildModeRadio(
                    mode: SanctuaryMode.sisterhood,
                    title: 'Sisterhood Mode',
                    badge: 'Aksen Khusus Nisa\'',
                    description: 'Kalkulator haidh & suci, fiqih nisa\', serta ukhuwah akhwat.',
                  ),
                  const SizedBox(height: 8),

                  // Mode 3: Kids Mode Otomatis
                  _buildModeRadio(
                    mode: SanctuaryMode.kids,
                    title: 'Kids Mode Otomatis',
                    badge: 'Ceria Ramah Anak',
                    description: 'Kisah 25 nabi ilustratif, doa harian ceria, & kuis interaktif.',
                  ),
                  const SizedBox(height: 20),

                  // Madzhab Fiqih Sholat
                  Text(
                    'Madzhab Fiqih Sholat & Perhitungan Ashar',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedMadzhab,
                        items: [
                          'Syafi\'i (Standar Kemenag RI)',
                          'Hanafi (Perhitungan Ashar 2x Bayangan)',
                          'Maliki (Standar Maghribi)',
                          'Hanbali (Standar Umm Al-Qura)',
                        ].map((m) {
                          return DropdownMenuItem(
                            value: m,
                            child: Text(
                              m,
                              style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w600),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedMadzhab = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Pilihan Qari Default Tilawah
                  Text(
                    'Pilihan Qari Default Tilawah',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedQari,
                        items: [
                          'Syaikh Misyari Rasyid Al-Afasy (Tartil Merdu)',
                          'Syaikh Abdurrahman As-Sudais (Khadimul Haramain)',
                          'Syaikh Maher Al-Mu\'aiqly (Tartil Khusyu\')',
                          'Syaikh Sa\'ad Al-Ghamdi (Menenangkan)',
                        ].map((q) {
                          return DropdownMenuItem(
                            value: q,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    q,
                                    style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Icon(Icons.graphic_eq_rounded, size: 16, color: AppColors.primary),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedQari = val);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section: Privasi & Ketenangan Qalbu
            _buildSectionHeader(Icons.security_rounded, 'Privasi & Ketenangan Qalbu'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.hairline),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Sembunyikan Riwayat Sedekah',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      'Menjaga keikhlasan amal tanpa jejak leaderboard publik.',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.outline),
                    ),
                    value: _hideSedekahHistory,
                    activeThumbColor: AppColors.primary,
                    activeTrackColor: AppColors.primaryFixed,
                    onChanged: (val) => setState(() => _hideSedekahHistory = val),
                  ),
                  const Divider(),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Status Keistiqomahan Komunitas',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      'Saling menyemangati mutaba\'ah harian dengan sahabat ukhuwah.',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.outline),
                    ),
                    value: _communityStreakStatus,
                    activeThumbColor: AppColors.primary,
                    activeTrackColor: AppColors.primaryFixed,
                    onChanged: (val) => setState(() => _communityStreakStatus = val),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Kunci Pengaman PIN Kids Mode',
                              style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700),
                            ),
                            const Icon(Icons.lock_rounded, size: 16, color: AppColors.outline),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Cegah keluar dari mode anak tanpa izin orang tua.',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.outline),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            ..._pinDigits.map((d) {
                              return Container(
                                width: 38,
                                height: 38,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.hairline),
                                ),
                                child: Center(
                                  child: Text(
                                    d,
                                    style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              );
                            }),
                            const Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.lavender,
                                foregroundColor: AppColors.primary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: _showChangePinDialog,
                              child: Text(
                                'Ubah PIN',
                                style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
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
            const SizedBox(height: 24),

            // Outlined Button: Keluar dari Sesi Akun
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                side: BorderSide(color: AppColors.outlineVariant),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sesi akun diakhiri.')),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.logout_rounded, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Keluar dari Sesi Akun',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Link: Hapus Akun Permanen
            Center(
              child: TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Hapus Akun Permanen?'),
                      content: const Text(
                        'Seluruh riwayat tilawah, jurnal ibadah, dan progres mutaba\'ah akan dihapus secara permanen dari Cloud Sanctuary.',
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.outline),
                label: Text(
                  'Hapus Akun Permanen',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: AppColors.outline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }

  Widget _buildFieldLabelWithBadge(String label, String badge) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.lavender.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            badge,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    IconData? suffixIcon,
    Color? suffixColor,
  }) {
    return TextField(
      controller: controller,
      style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 18, color: suffixColor ?? AppColors.outline) : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildModeRadio({
    required SanctuaryMode mode,
    required String title,
    required String badge,
    required String description,
  }) {
    final isSelected = _selectedMode == mode;
    return GestureDetector(
      onTap: () => setState(() => _selectedMode = mode),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryFixed.withValues(alpha: 0.3) : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 18,
                color: isSelected ? AppColors.primary : AppColors.outline,
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
                        title,
                        style: GoogleFonts.syne(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          badge,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      color: AppColors.onSurfaceVariant,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
