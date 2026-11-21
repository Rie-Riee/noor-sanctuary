import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class DzikirPagiPetangScreen extends StatefulWidget {
  const DzikirPagiPetangScreen({super.key});

  @override
  State<DzikirPagiPetangScreen> createState() => _DzikirPagiPetangScreenState();
}

class _DzikirPagiPetangScreenState extends State<DzikirPagiPetangScreen> {
  bool _isPlayingAudio = false;
  String _activeTab = 'Pagi'; // 'Pagi' or 'Petang'

  final List<Map<String, dynamic>> _dhikrItems = [
    {
      'title': 'Membaca Ayat Kursi',
      'ref': 'QS. Al-Baqarah: 255 • 1x',
      'target': 1,
      'count': 0,
      'arabic': 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ...',
      'benefit': 'Barangsiapa membacanya di pagi hari, ia akan dilindungi dari gangguan jin hingga petang.',
    },
    {
      'title': 'Surat Al-Ikhlas, Al-Falaq, & An-Naas',
      'ref': 'HR. Abu Dawud & Tirmidzi • 3x',
      'target': 3,
      'count': 0,
      'arabic': 'قُلْ هُوَ اللَّهُ أَحَدٌ ﴿١﴾ ...',
      'benefit': 'Mencukupkan dari segala keburukan dan marabahaya sepanjang hari.',
    },
    {
      'title': 'Sayyidul Istighfar (Puncak Doa Ampunan)',
      'ref': 'HR. Bukhari no. 6306 • 1x',
      'target': 1,
      'count': 0,
      'arabic': 'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَٰهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ...',
      'benefit': 'Barangsiapa membacanya dengan yakin lalu wafat pada hari itu, niscaya ia termasuk penghuni surga.',
    },
    {
      'title': 'Kalimat Perlindungan Segala Bahaya',
      'ref': 'HR. Abu Dawud & Tirmidzi • 3x',
      'target': 3,
      'count': 0,
      'arabic': 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
      'benefit': 'Tidak ada sesuatu pun di bumi maupun di langit yang dapat memudaratkannya.',
    },
    {
      'title': 'Tasbih & Tahmid 100 Kali',
      'ref': 'HR. Muslim no. 2691 • 100x',
      'target': 100,
      'count': 0,
      'arabic': 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
      'benefit': 'Dihapuskan dosa-dosanya meskipun sebanyak buih di lautan.',
    },
  ];

  void _incrementDhikr(int index) {
    setState(() {
      final item = _dhikrItems[index];
      if (item['count'] < item['target']) {
        item['count']++;
      }
    });
  }

  void _resetAll() {
    setState(() {
      for (var item in _dhikrItems) {
        item['count'] = 0;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Semua hitungan dzikir berhasil direset.')),
    );
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
          'Dzikir Pagi & Petang Khusyu\'',
          style: GoogleFonts.syne(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: 'Reset Hitungan',
            onPressed: _resetAll,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Morning / Evening Tab Selector
                  Row(
                    children: ['Pagi', 'Petang'].map((tab) {
                      final isSel = tab == _activeTab;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: GestureDetector(
                            onTap: () => setState(() => _activeTab = tab),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSel ? AppColors.primary : AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(
                                  'Dzikir $tab',
                                  style: GoogleFonts.syne(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: isSel ? Colors.white : AppColors.onSurface,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Header Info Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.secondaryContainer.withAlpha(140),
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
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Waktu Utama Dimulai',
                                    style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Riwayat Shahih Ma\'tsur',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.secondary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Menenangkan Qalb Bersama Dzikir $_activeTab',
                          style: GoogleFonts.syne(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _activeTab == 'Pagi'
                              ? 'Waktu afdhal dibaca ba\'da Shubuh hingga terbit matahari. Melindungi diri, membentangkan rezeki, dan menghadirkan sakinah.'
                              : 'Waktu afdhal dibaca ba\'da Ashar hingga menjelang Maghrib. Menutup lembaran hari dengan ketenangan dan perlindungan Ilahi.',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Audio Tartil Player Bar
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.hairline),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primary,
                          child: IconButton(
                            icon: Icon(_isPlayingAudio ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 20),
                            onPressed: () => setState(() => _isPlayingAudio = !_isPlayingAudio),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Audio Tartil Al-Ma\'tsurat',
                                style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                              ),
                              Text(
                                'Syaikh Misyari Rasyid Al-Afasy • 18:45',
                                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '1.0x',
                            style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Dhikr Cards List with Tap Targets
                  Text(
                    'Untaian Dzikir & Penghitung Ketuk',
                    style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                  ),
                  const SizedBox(height: 10),

                  ...List.generate(_dhikrItems.length, (idx) {
                    final item = _dhikrItems[idx];
                    final isComplete = item['count'] >= item['target'];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: isComplete ? AppColors.mistySage.withAlpha(120) : AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: isComplete ? AppColors.primary : AppColors.hairline,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item['title'],
                                  style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item['ref'],
                                  style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.secondary),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Arabic Verse
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow.withAlpha(160),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              item['arabic'],
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              style: AppTheme.quranArabic(fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: 8),

                          Text(
                            item['benefit'],
                            style: GoogleFonts.plusJakartaSans(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.onSurfaceVariant),
                          ),
                          const SizedBox(height: 12),

                          // Tap Button Counter
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Progres: ${item['count']} / ${item['target']} kali',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isComplete ? AppColors.tertiary : AppColors.secondary,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: isComplete ? null : () => _incrementDhikr(idx),
                                icon: Icon(isComplete ? Icons.check : Icons.touch_app, size: 16),
                                label: Text(isComplete ? 'Selesai' : 'Ketuk (+1)'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isComplete ? AppColors.tertiary : AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
