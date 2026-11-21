import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/sedekah_entry.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import 'tambah_sedekah_screen.dart';

class JurnalSedekahScreen extends StatefulWidget {
  const JurnalSedekahScreen({super.key});

  @override
  State<JurnalSedekahScreen> createState() => _JurnalSedekahScreenState();
}

class _JurnalSedekahScreenState extends State<JurnalSedekahScreen> {
  int _currentTab = 0; // 0: Sholat Dhuha, 1: Infaq & Sedekah Harta
  int _selectedRakaat = 4;
  bool _isDhuhaDoneToday = false;
  final List<SedekahRecord> _records = List.from(SedekahRecord.sampleRecords);

  void _addNewRecord(SedekahRecord rec) {
    setState(() {
      _records.insert(0, rec);
    });
  }

  int get _totalSedekahAmount {
    return _records.fold(0, (sum, item) => sum + item.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Sedekah & Sholat Dhuha',
          style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          if (_currentTab == 1)
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
              tooltip: 'Catat Sedekah Baru',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TambahSedekahScreen(onSaved: _addNewRecord),
                  ),
                );
              },
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Explanation Card: Mengapa Dhuha & Sedekah Berdampingan?
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed.withAlpha(80),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary.withAlpha(40)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dua Dimensi Sedekah Harian',
                                style: GoogleFonts.syne(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Dalam Islam, sedekah terbagi dua: Sedekah Fisik (Sholat Dhuha sebagai hak 360 persendian tubuh) dan Sedekah Finansial (Infaq harta di waktu subuh).',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: AppColors.onSurfaceVariant,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Segmented Tabs
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.hairline),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _currentTab = 0),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _currentTab == 0 ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: _currentTab == 0
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(12),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.wb_sunny_outlined,
                                    size: 16,
                                    color: _currentTab == 0 ? AppColors.primary : AppColors.secondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '☀️ Sholat Dhuha',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12.5,
                                      fontWeight: _currentTab == 0 ? FontWeight.w700 : FontWeight.w500,
                                      color: _currentTab == 0 ? AppColors.primary : AppColors.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _currentTab = 1),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _currentTab == 1 ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: _currentTab == 1
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(12),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.volunteer_activism_outlined,
                                    size: 16,
                                    color: _currentTab == 1 ? AppColors.primary : AppColors.secondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '🪙 Infaq & Sedekah',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12.5,
                                      fontWeight: _currentTab == 1 ? FontWeight.w700 : FontWeight.w500,
                                      color: _currentTab == 1 ? AppColors.primary : AppColors.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // TAB CONTENT
                  if (_currentTab == 0) _buildDhuhaTab() else _buildSedekahTab(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // 1. TAB: SHOLAT DHUHA (Sedekah Persendian Tubuh)
  // =========================================================================
  Widget _buildDhuhaTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Waktu Dhuha Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Waktu Utama Sedang Berlangsung',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF92400E),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Waktu Dhuha Hari Ini',
                        style: GoogleFonts.syne(fontSize: 19, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                      ),
                      Text(
                        '06:22 WIB — 11:35 WIB (Jakarta)',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.secondary),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFEF3C7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.wb_sunny_rounded, color: Color(0xFFD97706), size: 26),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Hadith Dalil Sedekah Persendian
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.format_quote_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '“Setiap pagi, setiap ruas anggota tubuh kalian wajib disedekahi... Dan semua itu cukup digantikan dengan dua rakaat shalat Dhuha.”\n(HR. Muslim no. 720)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: AppColors.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Rakaat Selector
              Text(
                'Pilih Niat Rakaat Hari Ini:',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildRakaatOption(2, 'Minimal', 'Mencukupi sedekah 360 sendi'),
                  const SizedBox(width: 8),
                  _buildRakaatOption(4, 'Afdhal', 'Kebiasaan utama Rasulullah ﷺ'),
                  const SizedBox(width: 8),
                  _buildRakaatOption(8, 'Sempurna', 'Keberlimpahan rezeki & pahala'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Lafal Niat Sholat Dhuha
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.menu_book_outlined, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    'Lafal Niat Sholat Dhuha ($_selectedRakaat Rakaat)',
                    style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _selectedRakaat == 4
                          ? 'أُصَلِّيْ سُنَّةَ الضُّحَى أَرْبَعَ رَكَعَاتٍ لِلّٰهِ تَعَالَى'
                          : _selectedRakaat == 8
                              ? 'أُصَلِّيْ سُنَّةَ الضُّحَى ثَمَانِيَ رَكَعَاتٍ لِلّٰهِ تَعَالَى'
                              : 'أُصَلِّيْ سُنَّةَ الضُّحَى رَكْعَتَيْنِ لِلّٰهِ تَعَالَى',
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: AppTheme.quranArabic(fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedRakaat == 4
                          ? '“Ushallii sunnatadh-dhuhaa arba\'a raka\'aatin lillaahi ta\'aalaa.”'
                          : _selectedRakaat == 8
                              ? '“Ushallii sunnatadh-dhuhaa tsamaaniya raka\'aatin lillaahi ta\'aalaa.”'
                              : '“Ushallii sunnatadh-dhuhaa rak\'ataini lillaahi ta\'aalaa.”',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Artinya: “Aku niat sholat sunnah Dhuha $_selectedRakaat rakaat karena Allah Ta\'ala.”',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Doa Setelah Sholat Dhuha
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome_outlined, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    'Doa Setelah Sholat Dhuha',
                    style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'اَللّٰهُمَّ إِنَّ الضَّحَآءَ ضَحَاءُكَ، وَالْبَهَاءَ بَهَاءُكَ، وَالْجَمَالَ جَمَالُكَ، وَالْقُوَّةَ قُوَّتُكَ، وَالْقُدْرَةَ قُدْرَتُكَ، وَالْعِصْمَةَ عِصْمَتُكَ',
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: AppTheme.quranArabic(fontSize: 18),
              ),
              const SizedBox(height: 6),
              Text(
                '“Ya Allah, sesungguhnya waktu dhuha adalah waktu dhuha-Mu, keagungan adalah keagungan-Mu, keindahan adalah keindahan-Mu, kekuatan adalah kekuatan-Mu, kekuasaan adalah kekuasaan-Mu, dan penjagaan adalah penjagaan-Mu.”',
                style: GoogleFonts.plusJakartaSans(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.onSurfaceVariant, height: 1.35),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Checklist Status Ibadah Dhuha
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _isDhuhaDoneToday ? const Color(0xFFF0FDF4) : AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isDhuhaDoneToday ? const Color(0xFF86EFAC) : AppColors.hairline,
              width: _isDhuhaDoneToday ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              if (_isDhuhaDoneToday) ...[
                Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alhamdulillah, Dhuha Hari Ini Tuntas!',
                            style: GoogleFonts.syne(fontSize: 13.5, fontWeight: FontWeight.w700, color: const Color(0xFF15803D)),
                          ),
                          Text(
                            'Tercatat $_selectedRakaat Rakaat • Sedekah persendian telah ditunaikan',
                            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF166534)),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() => _isDhuhaDoneToday = false);
                      },
                      child: Text('Batal', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.grey[700])),
                    ),
                  ],
                ),
              ] else ...[
                Text(
                  'Sudahkah Anda Sholat Dhuha Hari Ini?',
                  style: GoogleFonts.syne(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tandai checklist untuk mencatat keistiqomahan ibadah harian Anda.',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      setState(() => _isDhuhaDoneToday = true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Alhamdulillah, Sholat Dhuha $_selectedRakaat rakaat tercatat dalam amalan hari ini!'),
                          backgroundColor: const Color(0xFF16A34A),
                        ),
                      );
                    },
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: Text(
                      'Tandai Sudah Sholat Dhuha ($_selectedRakaat Rakaat)',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRakaatOption(int rakaat, String title, String desc) {
    final isSelected = _selectedRakaat == rakaat;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRakaat = rakaat),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.hairline,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Text(
                '$rakaat Rakaat',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? Colors.white : AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withAlpha(50) : AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // 2. TAB: INFAQ & SEDEKAH HARTA
  // =========================================================================
  Widget _buildSedekahTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Verification & Malaikat Subuh Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.tertiaryFixed.withAlpha(180),
                AppColors.surfaceContainerLow,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified, size: 14, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          'Tercatat Malaikat Subuh',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '14 Ramadhan 1446 H',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Alhamdulillah, Sedekah Subuh Terverifikasi',
                style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.onSurface),
              ),
              const SizedBox(height: 4),
              Text(
                'Total Terhimpun: Rp $_totalSedekahAmount • ${_records.length} Catatan Sedekah',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
              ),
              const SizedBox(height: 14),

              // Angel Prayer Hadith
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(220),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'اللَّهُمَّ أَعْطِ مُنْفِقًا خَلَفًا',
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: AppTheme.quranArabic(fontSize: 19),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '“Ya Allah, berikanlah ganti keberkahan yang berlipat bagi hamba yang berinfak di pagi hari.” (HR. Bukhari & Muslim)',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Recent Sedekah History Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Riwayat Sedekah Mandiri',
              style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.onSurface),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.add, size: 16),
              label: Text('Catat Baru', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TambahSedekahScreen(onSaved: _addNewRecord),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),

        ..._records.map((r) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.hairline),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.mistySage,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.volunteer_activism, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.category,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                      ),
                      Text(
                        r.note,
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant),
                      ),
                      Text(
                        r.time,
                        style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Rp ${r.amount}',
                  style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
