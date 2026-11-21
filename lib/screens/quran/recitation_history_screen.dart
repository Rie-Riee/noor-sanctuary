import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class RecitationHistoryScreen extends StatelessWidget {
  const RecitationHistoryScreen({super.key});

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
          'Riwayat & Portofolio Tahsin',
          style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.secondary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Analytics Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryContainer],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ringkasan Evaluasi AI',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(35),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Qira\'at Hafsh',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryStat('84%', 'Rata-rata Akurasi'),
                      Container(width: 1, height: 38, color: Colors.white24),
                      _buildSummaryStat('48 Sesi', 'Total Rekaman'),
                      Container(width: 1, height: 38, color: Colors.white24),
                      _buildSummaryStat('12 Surah', 'Teruji Mutqin'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Progress Wave Indicator
                  Container(
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(35),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.graphic_eq, color: Color(0xFF10B981), size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Tren Kenaikan: +6.4% Tartil',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                          ],
                        ),
                        Text(
                          'Konsisten 14 Hari',
                          style: GoogleFonts.plusJakartaSans(fontSize: 10, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            Text(
              'Riwayat Sesi Uji Tartil',
              style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
            const SizedBox(height: 12),

            _buildHistoryCard(
              context,
              surahTitle: 'QS. An-Naba\' [Ayat 1]',
              date: 'Hari ini • 08:30 WIB',
              score: 92,
              scoreLabel: 'Mumtaz',
              scoreColor: const Color(0xFF10B981),
              feedback: 'Makhraj huruf Halq dan Ghunnah terbaca fasih. Tambah sedikit panjang Mad Wajib.',
              isAudioPlayable: true,
            ),
            const SizedBox(height: 12),

            _buildHistoryCard(
              context,
              surahTitle: 'QS. Al-Fatihah [Ayat 1-7]',
              date: 'Kemarin • 19:45 WIB',
              score: 96,
              scoreLabel: 'Mumtaz',
              scoreColor: const Color(0xFF10B981),
              feedback: 'Pelafalan huruf Shad (ص) dan Dhad (ض) sangat bersih dan berbobot.',
              isAudioPlayable: true,
            ),
            const SizedBox(height: 12),

            _buildHistoryCard(
              context,
              surahTitle: 'QS. Al-Ikhlas [Ayat 1-4]',
              date: '2 hari lalu • 06:15 WIB',
              score: 100,
              scoreLabel: 'Mutqin',
              scoreColor: const Color(0xFF10B981),
              feedback: 'Sempurna! Qalqalah kubra pada akhir ayat terbaca memantul dengan ketukan tepat.',
              isAudioPlayable: true,
            ),
            const SizedBox(height: 12),

            _buildHistoryCard(
              context,
              surahTitle: 'QS. Al-Mulk [Ayat 1-2]',
              date: '3 hari lalu • 21:00 WIB',
              score: 78,
              scoreLabel: 'Perlu Latihan',
              scoreColor: const Color(0xFFD97706),
              feedback: 'Ghunnah pada mim bertasydid belum mencapai 2 harakat penuh. Kurangi ketergesaan.',
              isAudioPlayable: true,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(fontSize: 10, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(
    BuildContext context, {
    required String surahTitle,
    required String date,
    required int score,
    required String scoreLabel,
    required Color scoreColor,
    required String feedback,
    required bool isAudioPlayable,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.surfaceContainerHigh),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
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
                    surahTitle,
                    style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                  Text(
                    date,
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: scoreColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: scoreColor.withAlpha(80)),
                ),
                child: Row(
                  children: [
                    Text(
                      '$score%',
                      style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: scoreColor),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      scoreLabel,
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: scoreColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.school_outlined, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    feedback,
                    style: GoogleFonts.plusJakartaSans(fontSize: 11.5, height: 1.4, color: AppColors.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.play_circle, color: AppColors.primary, size: 28),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Putar rekaman Anda',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Memutar rekaman audio santri...')),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Rekaman Suara Anda (00:09)',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                  ),
                ],
              ),
              TextButton.icon(
                icon: const Icon(Icons.refresh, size: 14, color: AppColors.secondary),
                label: Text(
                  'Uji Ulang',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
