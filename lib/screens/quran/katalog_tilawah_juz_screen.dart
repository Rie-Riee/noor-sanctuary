import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../data/quran_dataset.dart';
import 'mushaf_reader_screen.dart';
import 'ai_tartil_evaluation_screen.dart';

class KatalogTilawahJuzScreen extends StatefulWidget {
  const KatalogTilawahJuzScreen({super.key});

  @override
  State<KatalogTilawahJuzScreen> createState() => _KatalogTilawahJuzScreenState();
}

class _KatalogTilawahJuzScreenState extends State<KatalogTilawahJuzScreen> {
  int _activeSegment = 0; // 0: Juz 1-30, 1: 60 Hizb & Maqra'
  final Set<int> _expandedJuz = {};

  void _openJuzInReader(int juzNumber) {
    // Find surah corresponding to this juz
    SurahModel targetSurah = kQuranSurahs.firstWhere(
      (s) => s.juz == juzNumber,
      orElse: () {
        if (juzNumber == 30) {
          return kQuranSurahs.firstWhere((s) => s.number == 78, orElse: () => kQuranSurahs.first);
        } else if (juzNumber == 15) {
          return kQuranSurahs.firstWhere((s) => s.number == 18, orElse: () => kQuranSurahs.first);
        }
        return kQuranSurahs.first;
      },
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MushafReaderScreen(surah: targetSurah),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Katalog Tilawah & Target',
          style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryFixed,
              child: const Icon(Icons.person, size: 18, color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Top Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryContainer],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(35),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Mushaf Madinah Rasm Utsmani • Standar 604 Halaman',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Katalog Tilawah & Target',
                    style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Panduan terstruktur tilawah harian berdasar pembagian 30 Juz, 60 Hizb, dan 240 Maqra\' (Rub\' el Hizb).',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Progres Khataman Anda Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.surfaceContainerHigh),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PROGRES KHATAMAN ANDA',
                            style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.secondary, letterSpacing: 0.5),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '14 ',
                                style: GoogleFonts.syne(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.primary),
                              ),
                              Text(
                                '/ 30 Juz telah dituntaskan',
                                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.secondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryFixed,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.star, color: AppColors.primary, size: 22),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: 14 / 30,
                      backgroundColor: AppColors.surfaceContainerHigh,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '46.6% Tercapai',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                      Text(
                        'Sisa 16 Juz lagi',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Mini Stat Cards
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_month, color: AppColors.primary, size: 20),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sisa Waktu Ramadhan',
                                    style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary),
                                  ),
                                  Text(
                                    '14 Hari Tersisa',
                                    style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.speed, color: Color(0xFF10B981), size: 20),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ritme Rekomendasi',
                                    style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary),
                                  ),
                                  Text(
                                    '1.1 Juz / Hari',
                                    style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF10B981)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Segmented Filter
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _activeSegment = 0),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                          color: _activeSegment == 0 ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.menu_book, size: 16, color: _activeSegment == 0 ? Colors.white : AppColors.secondary),
                            const SizedBox(width: 6),
                            Text(
                              'Juz 1–30',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: _activeSegment == 0 ? FontWeight.w700 : FontWeight.w500,
                                color: _activeSegment == 0 ? Colors.white : AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _activeSegment = 1),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                          color: _activeSegment == 1 ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pie_chart_outline, size: 16, color: _activeSegment == 1 ? Colors.white : AppColors.secondary),
                            const SizedBox(width: 6),
                            Text(
                              '60 Hizb & Maqra\'',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: _activeSegment == 1 ? FontWeight.w700 : FontWeight.w500,
                                color: _activeSegment == 1 ? Colors.white : AppColors.secondary,
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
            const SizedBox(height: 16),

            // List of Juz Items (Juz 1, 15, 30 as in mockup)
            ...kJuzList.map((juz) {
              final isExpanded = _expandedJuz.contains(juz.number);

              Color statusBg;
              Color statusFg;
              if (juz.status == 'Selesai') {
                statusBg = const Color(0xFFD1FAE5);
                statusFg = const Color(0xFF065F46);
              } else if (juz.status == 'Sedang Dibaca') {
                statusBg = const Color(0xFFE0F2FE);
                statusFg = const Color(0xFF0369A1);
              } else {
                statusBg = AppColors.surfaceContainerHigh;
                statusFg = AppColors.secondary;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: juz.status == 'Sedang Dibaca' ? AppColors.primary : AppColors.surfaceContainerHigh,
                    width: juz.status == 'Sedang Dibaca' ? 1.5 : 1.0,
                  ),
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
                            Container(
                              width: 38,
                              height: 38,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.primaryFixed,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('JUZ', style: GoogleFonts.syne(fontSize: 8, fontWeight: FontWeight.w700, color: AppColors.primary)),
                                  Text('${juz.number}', style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      juz.title,
                                      style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: statusBg,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        juz.status,
                                        style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: statusFg),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  juz.pageRange,
                                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          juz.arabicName,
                          style: AppTheme.quranArabic(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Progress bar if reading
                    if (juz.status == 'Sedang Dibaca') ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Halaman 293 / 301', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary)),
                          Text('60% Juz', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: 0.60,
                          backgroundColor: AppColors.surfaceContainerHigh,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Surah Range Box
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.menu_book, size: 16, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${juz.surahRange} • ${juz.totalAyahs} Ayat',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.onSurface),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Hizb & Maqra Rincian Accordion
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (isExpanded) {
                            _expandedJuz.remove(juz.number);
                          } else {
                            _expandedJuz.add(juz.number);
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  juz.hizbInfo,
                                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  isExpanded ? 'Tutup' : 'Rincian',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                                ),
                                Icon(
                                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (isExpanded) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Struktur Hizb & Maqra\' (Rub\' el Hizb):',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '• Hizb 1: Al-Fatihah 1 s/d Al-Baqarah 74\n• Hizb 2: Al-Baqarah 75 s/d Al-Baqarah 141\n• Setiap Hizb terbagi atas 4 Maqra\' untuk memudahkan target harian 2-4 lembar shalat.',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, height: 1.45, color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),

                    // Action Buttons
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
                            icon: const Icon(Icons.auto_stories, size: 16),
                            label: Text(
                              juz.status == 'Sedang Dibaca' ? 'Lanjutkan Hal 293' : 'Buka ${juz.title}',
                              style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                            onPressed: () => _openJuzInReader(juz.number),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.surfaceContainerLow,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          icon: const Icon(Icons.play_arrow, color: AppColors.primary, size: 20),
                          tooltip: 'Putar Audio Murottal Juz',
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Memutar audio tartil ${juz.title}')),
                            );
                          },
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.surfaceContainerLow,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          icon: const Icon(Icons.mic, color: AppColors.primary, size: 20),
                          tooltip: 'Uji Hafalan Juz dengan AI',
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
            }),
            const SizedBox(height: 14),

            // Bottom Quote
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryFixed.withAlpha(120),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.primary.withAlpha(40)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.format_quote, color: AppColors.primary, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '"Sebaik-baik kalian adalah orang yang belajar Al-Qur\'an dan mengajarkannya."',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '— HR. Bukhari (No. 5027)',
                          style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.secondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
