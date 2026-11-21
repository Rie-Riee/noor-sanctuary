import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class SettingModals {
  // 1. NOTIFIKASI & WAKTU IBADAH
  static void showNotifikasiSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        String selectedMuadzin = 'Syaikh Mishary Rashid';
        int preAdzanMinutes = 10;
        final prayerToggles = {
          'Subuh': true,
          'Dzuhur': true,
          'Ashar': true,
          'Maghrib': true,
          'Isya': true,
        };
        bool playDoaAfterAdzan = true;

        return StatefulBuilder(
          builder: (context, setState) {
            return _buildModalContainer(
              context,
              title: 'Notifikasi & Waktu Ibadah',
              icon: Icons.notifications_active_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SUARA MUADZIN ADZAN',
                    style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.outline),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedMuadzin,
                        items: [
                          'Syaikh Mishary Rashid',
                          'Adzan Makkah Al-Mukarramah',
                          'Adzan Madinah Al-Munawwarah',
                          'Adzan Masjid Al-Aqsa',
                          'Adzan Tarim Hadramaut',
                        ].map((m) => DropdownMenuItem(value: m, child: Text(m, style: GoogleFonts.plusJakartaSans(fontSize: 13)))).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => selectedMuadzin = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'PENGINGAT SEBELUM ADZAN',
                    style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.outline),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [5, 10, 15, 20].map((m) {
                      final isSel = preAdzanMinutes == m;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => preAdzanMinutes = m),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSel ? AppColors.primary : AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                '$m Menit',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isSel ? Colors.white : AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'ALARM ADZAN WAKTU SHOLAT',
                    style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.outline),
                  ),
                  const SizedBox(height: 8),
                  ...prayerToggles.keys.map((p) {
                    return SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: Text(p, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600)),
                      value: prayerToggles[p]!,
                      activeThumbColor: AppColors.primary,
                      activeTrackColor: AppColors.primaryFixed,
                      onChanged: (val) => setState(() => prayerToggles[p] = val),
                    );
                  }),
                  const Divider(),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Putar Doa Setelah Adzan Otomatis', style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700)),
                    subtitle: Text('Lafadz doa Allahumma Robba Hadzihid Da\'wah', style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.outline)),
                    value: playDoaAfterAdzan,
                    activeThumbColor: AppColors.primary,
                    activeTrackColor: AppColors.primaryFixed,
                    onChanged: (val) => setState(() => playDoaAfterAdzan = val),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 2. METODE PERHITUNGAN & MADZHAB
  static void showMadzhabSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        String selectedAuthority = 'Kemenag RI (Subuh 20°, Isya 18°)';
        String selectedMadzhab = 'Syafi\'i / Maliki / Hanbali';
        int ikhtiyat = 2;

        return StatefulBuilder(
          builder: (context, setState) {
            return _buildModalContainer(
              context,
              title: 'Metode Perhitungan & Madzhab',
              icon: Icons.explore_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OTORITAS PERHITUNGAN SHOLAT',
                    style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.outline),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedAuthority,
                        items: [
                          'Kemenag RI (Subuh 20°, Isya 18°)',
                          'Muslim World League (MWL)',
                          'Umm Al-Qura Makkah Al-Mukarramah',
                          'Egyptian General Authority of Survey',
                          'ISNA (Islamic Society of North America)',
                        ].map((a) => DropdownMenuItem(value: a, child: Text(a, style: GoogleFonts.plusJakartaSans(fontSize: 12)))).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => selectedAuthority = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'MADZHAB PERHITUNGAN ASHAR',
                    style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.outline),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => selectedMadzhab = 'Syafi\'i / Maliki / Hanbali'),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: selectedMadzhab == 'Syafi\'i / Maliki / Hanbali' ? AppColors.primary : AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Syafi\'i (Mayoritas)',
                                  style: GoogleFonts.syne(fontSize: 11.5, fontWeight: FontWeight.w700, color: selectedMadzhab == 'Syafi\'i / Maliki / Hanbali' ? Colors.white : AppColors.primary),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '1x Panjang Bayangan',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 9.5, color: selectedMadzhab == 'Syafi\'i / Maliki / Hanbali' ? Colors.white70 : AppColors.outline),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => selectedMadzhab = 'Hanafi'),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: selectedMadzhab == 'Hanafi' ? AppColors.primary : AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Hanafi',
                                  style: GoogleFonts.syne(fontSize: 11.5, fontWeight: FontWeight.w700, color: selectedMadzhab == 'Hanafi' ? Colors.white : AppColors.primary),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '2x Panjang Bayangan',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 9.5, color: selectedMadzhab == 'Hanafi' ? Colors.white70 : AppColors.outline),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Waktu Pengaman (Ikhtiyat)', style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700)),
                          Text('Tambahan kehati-hatian waktu masuk sholat', style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.outline)),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, size: 20),
                            onPressed: () {
                              if (ikhtiyat > 0) setState(() => ikhtiyat--);
                            },
                          ),
                          Text('+$ikhtiyat mnt', style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, size: 20),
                            onPressed: () => setState(() => ikhtiyat++),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 3. UNDUHAN AUDIO MUROTTAL & OFFLINE
  static void showOfflineDownloadSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        bool offlineMode = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return _buildModalContainer(
              context,
              title: 'Unduhan Audio & Offline',
              icon: Icons.cloud_download_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Penyimpanan Audio Lokal', style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700)),
                            Text('1.4 GB / 30 Juz', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: const LinearProgressIndicator(
                            value: 0.85,
                            minHeight: 8,
                            backgroundColor: AppColors.outlineVariant,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text('114 Surah lengkap tersimpan dalam format High Quality Audio.', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Mode Offline Penuh', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
                    subtitle: Text('Gunakan data lokal tanpa memakai kuota internet.', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.outline)),
                    value: offlineMode,
                    activeThumbColor: AppColors.primary,
                    activeTrackColor: AppColors.primaryFixed,
                    onChanged: (val) => setState(() => offlineMode = val),
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.refresh_rounded, color: AppColors.primary),
                    title: const Text('Sinkronkan Ulang Audio Murottal'),
                    subtitle: const Text('Periksa kelengkapan file audio yang rusak atau terputus'),
                    onTap: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Memeriksa integritas 30 Juz audio lokal...')),
                      );
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.delete_sweep_outlined, color: Colors.red),
                    title: const Text('Bersihkan Cache Audio', style: TextStyle(color: Colors.red)),
                    subtitle: const Text('Hapus file murottal untuk mengosongkan 1.4 GB penyimpanan'),
                    onTap: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cache audio berhasil dibersihkan.')),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 4. TAMPILAN & UKURAN FONT ARAB
  static void showFontSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        double arabicSize = 28.0;
        double translationSize = 13.0;
        String selectedKhat = 'Khat Utsmani Madinah';
        bool showTajwid = true;

        return StatefulBuilder(
          builder: (context, setState) {
            return _buildModalContainer(
              context,
              title: 'Tampilan & Ukuran Font Arab',
              icon: Icons.text_fields_rounded,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Live Preview Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.hairline),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.amiri(
                            fontSize: arabicSize,
                            height: 1.8,
                            color: showTajwid ? const Color(0xFF1B5E20) : AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: translationSize,
                            color: AppColors.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  Text('JENIS KHAT AL-QUR\'AN', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.outline)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['Khat Utsmani Madinah', 'Indopak (Standar Kemenag)', 'Rasm Tradisional'].map((k) {
                      final isSel = selectedKhat == k;
                      return ChoiceChip(
                        label: Text(k, style: const TextStyle(fontSize: 11)),
                        selected: isSel,
                        selectedColor: AppColors.primaryFixed,
                        onSelected: (val) {
                          if (val) setState(() => selectedKhat = k);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ukuran Font Ayat Arab', style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700)),
                      Text('${arabicSize.toInt()} pt', style: GoogleFonts.syne(fontSize: 12, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  Slider(
                    value: arabicSize,
                    min: 22.0,
                    max: 40.0,
                    divisions: 9,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => arabicSize = val),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ukuran Terjemahan & Latin', style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700)),
                      Text('${translationSize.toInt()} pt', style: GoogleFonts.syne(fontSize: 12, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  Slider(
                    value: translationSize,
                    min: 11.0,
                    max: 18.0,
                    divisions: 7,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => translationSize = val),
                  ),

                  const Divider(),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Warna Kaidah Tajwid', style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700)),
                    subtitle: Text('Iqlab, Idgham, Ikhfa, dan Mad dengan panduan warna', style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.outline)),
                    value: showTajwid,
                    activeThumbColor: AppColors.primary,
                    activeTrackColor: AppColors.primaryFixed,
                    onChanged: (val) => setState(() => showTajwid = val),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 5. PRIVASI & KEAMANAN DATA
  static void showPrivacySettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        bool biometricEnabled = true;
        bool localEncrypt = true;

        return StatefulBuilder(
          builder: (context, setState) {
            return _buildModalContainer(
              context,
              title: 'Privasi & Keamanan Data',
              icon: Icons.fingerprint_rounded,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Kunci Biometrik (Fingerprint / Face ID)', style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700)),
                    subtitle: Text('Meminta otentikasi saat membuka aplikasi & riwayat ibadah', style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.outline)),
                    value: biometricEnabled,
                    activeThumbColor: AppColors.primary,
                    activeTrackColor: AppColors.primaryFixed,
                    onChanged: (val) => setState(() => biometricEnabled = val),
                  ),
                  const Divider(),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Enkripsi Database Lokal (AES-256)', style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700)),
                    subtitle: Text('Catatan thaharah, mutaba\'ah, dan doa terenkripsi di perangkat', style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.outline)),
                    value: localEncrypt,
                    activeThumbColor: AppColors.primary,
                    activeTrackColor: AppColors.primaryFixed,
                    onChanged: (val) => setState(() => localEncrypt = val),
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.cloud_sync_outlined, color: AppColors.primary),
                    title: const Text('Cadangkan Data ke Cloud Sanctuary ID'),
                    subtitle: const Text('Terakhir dicadangkan hari ini pukul 05:40 WIB'),
                    onTap: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pencadangan data ibadah ke Cloud Sanctuary berhasil!')),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Widget _buildModalContainer(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDesktop = screenWidth > 640;

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 580,
          maxHeight: screenHeight * 0.9,
        ),
        margin: isDesktop
            ? EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              )
            : null,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: isDesktop
              ? BorderRadius.circular(32)
              : const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: isDesktop
              ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(40),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  )
                ]
              : null,
        ),
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: AppColors.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(icon, size: 22, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          title,
                          style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20, color: AppColors.outline),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(height: 20),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
