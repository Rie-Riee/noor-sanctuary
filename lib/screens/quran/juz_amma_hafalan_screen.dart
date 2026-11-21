import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../data/quran_dataset.dart';
import 'ai_tartil_evaluation_screen.dart';
import 'mushaf_reader_screen.dart';
import '../game/kuis_sambung_ayat_screen.dart';

class JuzAmmaHafalanScreen extends StatefulWidget {
  const JuzAmmaHafalanScreen({super.key});

  @override
  State<JuzAmmaHafalanScreen> createState() => _JuzAmmaHafalanScreenState();
}

class _JuzAmmaHafalanScreenState extends State<JuzAmmaHafalanScreen> {
  int _selectedFilter = 0; // 0: Semua, 1: Mutqin, 2: Sedang Dihafal, 3: Belum

  final List<Map<String, dynamic>> _juzAmmaSurahs = [
    {
      'number': 78,
      'name': 'An-Naba\'',
      'arabic': 'النبأ',
      'ayahs': 40,
      'status': 'Sedang Dihafal',
      'progress': 0.70,
      'statusLabel': '70% Terhafal',
      'badgeColor': const Color(0xFF6366F1),
    },
    {
      'number': 79,
      'name': 'An-Nazi\'at',
      'arabic': 'النازعات',
      'ayahs': 46,
      'status': 'Belum Dimulai',
      'progress': 0.0,
      'statusLabel': 'Belum Dimulai',
      'badgeColor': AppColors.secondary,
    },
    {
      'number': 80,
      'name': '\'Abasa',
      'arabic': 'عبس',
      'ayahs': 42,
      'status': 'Belum Dimulai',
      'progress': 0.0,
      'statusLabel': 'Belum Dimulai',
      'badgeColor': AppColors.secondary,
    },
    {
      'number': 81,
      'name': 'At-Takwir',
      'arabic': 'التكوير',
      'ayahs': 29,
      'status': 'Mutqin / Lancar',
      'progress': 1.0,
      'statusLabel': 'Lancar • Muroja\'ah Kemarin',
      'badgeColor': const Color(0xFF10B981),
    },
    {
      'number': 82,
      'name': 'Al-Infitar',
      'arabic': 'الانفطار',
      'ayahs': 19,
      'status': 'Mutqin / Lancar',
      'progress': 0.96,
      'statusLabel': '96% AI',
      'badgeColor': const Color(0xFF10B981),
    },
    {
      'number': 93,
      'name': 'Ad-Dhuha',
      'arabic': 'الضحى',
      'ayahs': 11,
      'status': 'Mutqin / Lancar',
      'progress': 1.0,
      'statusLabel': 'Mutqin',
      'badgeColor': const Color(0xFF10B981),
    },
    {
      'number': 94,
      'name': 'Al-Insyirah',
      'arabic': 'الانشراح',
      'ayahs': 8,
      'status': 'Mutqin / Lancar',
      'progress': 1.0,
      'statusLabel': 'Mutqin',
      'badgeColor': const Color(0xFF10B981),
    },
    {
      'number': 112,
      'name': 'Al-Ikhlas',
      'arabic': 'الإخلاص',
      'ayahs': 4,
      'status': 'Mutqin / Lancar',
      'progress': 1.0,
      'statusLabel': 'Mutqin',
      'badgeColor': const Color(0xFF10B981),
    },
    {
      'number': 113,
      'name': 'Al-Falaq',
      'arabic': 'الفلق',
      'ayahs': 5,
      'status': 'Mutqin / Lancar',
      'progress': 1.0,
      'statusLabel': 'Mutqin',
      'badgeColor': const Color(0xFF10B981),
    },
    {
      'number': 114,
      'name': 'An-Nas',
      'arabic': 'الناس',
      'ayahs': 6,
      'status': 'Mutqin / Lancar',
      'progress': 1.0,
      'statusLabel': 'Mutqin',
      'badgeColor': const Color(0xFF10B981),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _juzAmmaSurahs.where((item) {
      if (_selectedFilter == 1) return item['status'] == 'Mutqin / Lancar';
      if (_selectedFilter == 2) return item['status'] == 'Sedang Dihafal';
      if (_selectedFilter == 3) return item['status'] == 'Belum Dimulai';
      return true;
    }).toList();

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
          'Juz \'Amma Tracker & Hafalan',
          style: GoogleFonts.syne(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.primary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.secondary, size: 20),
            onPressed: () {},
          ),
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
            // Donut Chart Hero Card (Mockup 5)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(24),
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
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_awesome, size: 13, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          'Target Ramadhan 1445 H',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Pencapaian Hafalan Juz 30 (Juz \'Amma)',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.syne(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),

                  // Donut representation
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: 0.65,
                          strokeWidth: 10,
                          backgroundColor: AppColors.surfaceContainerHigh,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '65%',
                            style: GoogleFonts.syne(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primary),
                          ),
                          Text(
                            'MUTQIN',
                            style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.secondary),
                          ),
                          Text(
                            '24 / 37 Surah',
                            style: GoogleFonts.plusJakartaSans(fontSize: 9.5, color: AppColors.secondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // 3 Key Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDonutStat(Icons.flag_outlined, '13 Surah', 'Menuju Khatam'),
                      Container(width: 1, height: 32, color: AppColors.surfaceContainerHigh),
                      _buildDonutStat(Icons.schedule, '1 Surah', 'Per 3 Hari'),
                      Container(width: 1, height: 32, color: AppColors.surfaceContainerHigh),
                      _buildDonutStat(Icons.nightlight_outlined, '14 Hari', 'Sisa Ramadhan'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(0, 'Semua (37)'),
                  const SizedBox(width: 8),
                  _buildFilterChip(1, 'Mutqin / Lancar (24)'),
                  const SizedBox(width: 8),
                  _buildFilterChip(2, 'Sedang Menghafal (5)'),
                  const SizedBox(width: 8),
                  _buildFilterChip(3, 'Belum (8)'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Card: Fokus Hafalan Utama (QS. An-Naba' 70%)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF5F3FF), Color(0xFFEDE9FE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.primary.withAlpha(60)),
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
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'FOKUS HAFALAN UTAMA',
                            style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primaryFixed,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Surah ke-78',
                          style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'QS. An-Naba\'',
                        style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                      Text(
                        '70%',
                        style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '40 Ayat — Berita Besar (28 dari 40 Ayat Terselesaikan)',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const LinearProgressIndicator(
                      value: 0.70,
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Pilihan fokus hafalan dapat diubah ke surah lain.')),
                            );
                          },
                          child: Text(
                            'Ubah Target',
                            style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.mic, size: 16),
                          label: Text(
                            'Uji Mandiri AI',
                            style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AiTartilEvaluationScreen()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Card: Jadwal Muraja'ah Hari Ini
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.surfaceContainerHigh),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.alarm, color: AppColors.primary, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Jadwal Muroja\'ah Hari Ini',
                        style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '5 Surah pendek penjaga kelancaran hafalan:',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: ['Al-Insyirah', 'At-Tin', 'Al-\'Alaq', 'Al-Qadr', 'Al-Bayyinah'].map((surah) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          surah,
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.shuffle, size: 16),
                      label: Text(
                        'Mulai Uji Sambung Ayat Acak',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const KuisSambungAyatScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Daftar Surah (78 — 114)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daftar Surah (78 — 114)',
                  style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
                Text(
                  'Urut Mushaf',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ...filtered.map((item) {
              final isDone = item['status'] == 'Mutqin / Lancar';
              final isStudying = item['status'] == 'Sedang Dihafal';

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isStudying ? AppColors.primary : AppColors.surfaceContainerHigh,
                    width: isStudying ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isDone
                                ? const Color(0xFFD1FAE5)
                                : (isStudying ? AppColors.primaryFixed : AppColors.surfaceContainerLow),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${item['number']}',
                            style: GoogleFonts.syne(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isDone ? const Color(0xFF065F46) : AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  item['name'],
                                  style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                                ),
                                if (isDone) ...[
                                  const SizedBox(width: 4),
                                  const Icon(Icons.check_circle, size: 14, color: Color(0xFF10B981)),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${item['ayahs']} Ayat • ${item['statusLabel']}',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        if (isDone) ...[
                          IconButton(
                            icon: const Icon(Icons.replay, color: AppColors.secondary, size: 18),
                            tooltip: 'Uji Muroja\'ah AI',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const AiTartilEvaluationScreen()),
                              );
                            },
                          ),
                        ] else if (isStudying) ...[
                          IconButton(
                            icon: const Icon(Icons.play_arrow, color: AppColors.primary, size: 20),
                            onPressed: () {
                              final surah = kQuranSurahs.firstWhere((s) => s.number == item['number'], orElse: () => kQuranSurahs.first);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => MushafReaderScreen(surah: surah)),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.mic, color: AppColors.primary, size: 20),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const AiTartilEvaluationScreen()),
                              );
                            },
                          ),
                        ] else ...[
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.outlineVariant),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              minimumSize: Size.zero,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Target hafalan Surah ${item['name']} diaktifkan!')),
                              );
                            },
                            child: Text(
                              'Mulai',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDonutStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
        ),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(fontSize: 9.5, color: AppColors.secondary),
        ),
      ],
    );
  }

  Widget _buildFilterChip(int index, String label) {
    final isSelected = _selectedFilter == index;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.surfaceContainerLow,
      labelStyle: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? Colors.white : AppColors.onSurface,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.outlineVariant.withAlpha(80),
      ),
      onSelected: (val) => setState(() => _selectedFilter = index),
    );
  }
}
