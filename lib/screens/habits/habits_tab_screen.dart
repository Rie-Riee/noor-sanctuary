import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../search/universal_search_sheet.dart';

class HabitItem {
  final String id;
  String title;
  String category; // 'Sholat', 'Dzikir & Tilawah', 'Sedekah', 'Puasa', 'Kustom'
  String frequency; // 'Setiap Hari', 'Hari Tertentu', 'Pekanan'
  List<String> days;
  int quantity;
  String unit; // 'Rakaat', 'Halaman', 'Menit', 'Kali', 'Juz', 'Rupiah'
  String reminderTime;
  String intention;
  bool isSoundEnabled;
  bool isCompleted;
  bool isPrivate;
  bool isCustom;

  HabitItem({
    required this.id,
    required this.title,
    this.category = 'Sholat',
    this.frequency = 'Setiap Hari',
    this.days = const [],
    this.quantity = 1,
    this.unit = 'Kali',
    this.reminderTime = '04:40 WIB',
    this.intention = '',
    this.isSoundEnabled = true,
    this.isCompleted = false,
    this.isPrivate = false,
    this.isCustom = false,
  });
}

class HabitsTabScreen extends StatefulWidget {
  const HabitsTabScreen({super.key});

  @override
  State<HabitsTabScreen> createState() => _HabitsTabScreenState();
}

class _HabitsTabScreenState extends State<HabitsTabScreen> {
  bool _isCalendarExpanded = false;
  int _selectedDate = 14; // Jum'at, 14 Ramadhan

  // Sholat Fardhu status (Starts unchecked, user checks themselves after praying!)
  final Map<String, bool> _fardhuStatus = {
    'Subuh': false,
    'Dzuhur': false,
    'Ashar': false,
    'Maghrib': false,
    'Isya & Tarawih': false,
  };

  // Dedicated Yaumiyah habits state (Starts unchecked, user checks themselves!)
  bool _dhuhaDone = false;
  bool _sedekahDone = false;
  bool _tilawahDone = false;
  bool _dzikirDone = false;
  bool _mulkDone = false;
  final List<HabitItem> _customHabits = [];

  bool _isAdzanSounded(int hour, int minute) {
    if (_selectedDate < 14) return true; // Past days: all prayers have passed
    if (_selectedDate > 14) return false; // Future days: none have passed

    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final prayerMinutes = hour * 60 + minute;
    return nowMinutes >= prayerMinutes;
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFF2A3043),
        duration: const Duration(milliseconds: 1500),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF34D399), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addNewHabit(HabitItem item) {
    setState(() {
      _customHabits.insert(0, item);
    });
    _showFeedback('Target amalan "${item.title}" berhasil ditambahkan!');
  }

  void _showAddHabitModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.92,
          minChildSize: 0.6,
          maxChildSize: 0.96,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: AddHabitFormSheet(
                scrollController: scrollController,
                onSave: _addNewHabit,
              ),
            );
          },
        );
      },
    );
  }

  // Sub-modal 1: Analitik & Grafik Statistik Keistiqomahan
  void _showAnalyticsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.92,
          minChildSize: 0.6,
          maxChildSize: 0.96,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(22),
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.insights, color: AppColors.primary, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            'Statistik Keistiqomahan Lengkap',
                            style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Hero Score Sanctuary Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, Color(0xFF3A3255)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
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
                                color: Colors.white.withAlpha(30),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Mutaba\'ah Yaumiyah',
                                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9E9CF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '⭐ Mumtaz & Istiqomah',
                                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF714B14), fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tingkat Konsistensi Jiwa',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.white70),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '86%',
                                      style: GoogleFonts.syne(fontSize: 42, fontWeight: FontWeight.w800, color: Colors.white),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF8BF8C4).withAlpha(40),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        '+12% pekan lalu',
                                        style: TextStyle(fontSize: 10, color: Color(0xFF8BF8C4), fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFF9E9CF), width: 4),
                              ),
                              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '118 dari 136 amalan tertunaikan dengan khusyu\' & thuma\'ninah di bulan suci Ramadhan ini.',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.white70, height: 1.4),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 30-Day Ramadan Heatmap Grid
                  Text(
                    'Peta Keistiqomahan 30 Hari Ramadhan',
                    style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 30,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                      childAspectRatio: 1.3,
                    ),
                    itemBuilder: (context, idx) {
                      final day = idx + 1;
                      final isPerfect = [1, 2, 4, 6, 7, 9, 10, 13, 14].contains(day);
                      final isHigh = [3, 8, 12].contains(day);
                      final isFuture = day > 14;

                      Color bg = isFuture
                          ? AppColors.surfaceContainerLow
                          : isPerfect
                              ? AppColors.primary
                              : isHigh
                                  ? AppColors.primaryFixed
                                  : AppColors.surfaceContainerHigh;

                      Color textC = isFuture
                          ? AppColors.outline
                          : isPerfect
                              ? Colors.white
                              : AppColors.primary;

                      return Container(
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('H-$day', style: TextStyle(fontSize: 9, color: textC.withAlpha(180))),
                            Text(isFuture ? '-' : isPerfect ? '100%' : '88%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: textC)),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Breakdown Kategori
                  Text(
                    'Distribusi Disiplin Ibadah',
                    style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                  ),
                  const SizedBox(height: 10),
                  _buildMetricRow('Sholat Fardhu 5 Waktu', 1.0, '100%'),
                  _buildMetricRow('Sunnah Rawatib & Dhuha', 0.88, '88%'),
                  _buildMetricRow('Tilawah & Khatam Qur\'an', 0.80, '80%'),
                  _buildMetricRow('Dzikir Pagi & Petang', 0.92, '92%'),
                  _buildMetricRow('Inisiatif Green Deen (Air)', 0.75, '75%'),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMetricRow(String label, double val, String percent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
              Text(percent, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: val,
              minHeight: 8,
              backgroundColor: AppColors.surfaceContainerLow,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // Sub-modal 2: Detail Tilawah 1 Juz
  void _showTilawahModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.92,
          minChildSize: 0.6,
          maxChildSize: 0.96,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(22),
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.auto_stories, color: AppColors.primary, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            'Detail Tilawah & Target 1 Juz',
                            style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                        ],
                      ),
                      IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Juz 14 • Surah Al-Hijr & An-Nahl', style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        const SizedBox(height: 4),
                        Text('Halaman 262 - 281 (10 Lembar / 20 Halaman)', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.secondary)),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('8 dari 10 Lembar Selesai', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                            Text('80%', style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: const LinearProgressIndicator(value: 0.8, minHeight: 10, color: AppColors.primary, backgroundColor: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Daftar 10 Lembar Juz 14', style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 10,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.2,
                    ),
                    itemBuilder: (context, idx) {
                      final lembar = idx + 1;
                      final isDone = lembar <= 8;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDone ? AppColors.surfaceContainerLow : AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isDone ? AppColors.primary.withAlpha(40) : AppColors.hairline),
                        ),
                        child: Row(
                          children: [
                            Icon(isDone ? Icons.check_circle : Icons.circle_outlined, color: isDone ? AppColors.primary : AppColors.outline, size: 20),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Lembar $lembar', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                                Text('Hal ${260 + (lembar * 2)} - ${261 + (lembar * 2)}', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary)),
                              ],
                            ),
                          ],
                        ),
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

  // Sub-modal 3: Bagikan ke Instagram Story
  void _showShareStoryModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.92,
          minChildSize: 0.6,
          maxChildSize: 0.96,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(22),
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.share, color: AppColors.primary, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            'Bagikan ke Instagram Story',
                            style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                        ],
                      ),
                      IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 9:16 Story Card Canvas Preview
                  Center(
                    child: Container(
                      width: 280,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, Color(0xFF2A3043)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 20, offset: const Offset(0, 8)),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.mosque, color: Colors.white, size: 18),
                              const SizedBox(width: 6),
                              Text('NOOR SANCTUARY', style: GoogleFonts.syne(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1.2)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('14 RAMADHAN 1446 H', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFFD6E4EF))),
                          const SizedBox(height: 24),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFF9E9CF), width: 3),
                            ),
                            child: const Center(
                              child: Text('86%', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text('Istiqomah Journey', style: GoogleFonts.notoSerif(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                          const SizedBox(height: 4),
                          Text('14 dari 17 amalan harian tuntas', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.white70)),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(20),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '“Amalan yang paling dicintai Allah adalah amalan yang berkelanjutan walaupun sedikit.”\n(HR. Bukhari)',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.white, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Bagikan ke Instagram Story'),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Gambar story berhasil diekspor ke galeri siap dibagikan!')),
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

  // Sub-modal 4: Form Catat Sholat Sunnah & Refleksi Qolbu
  void _showCatatSholatModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.92,
          minChildSize: 0.6,
          maxChildSize: 0.96,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(22),
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.self_improvement, color: AppColors.primary, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            'Catat Sholat & Refleksi Qolbu',
                            style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                        ],
                      ),
                      IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Pilih Sholat Sunnah yang Ditunaikan:',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Qabliyah Subuh (2 Rakaat)',
                      'Qabliyah Dzuhur (4 Rakaat)',
                      'Ba\'diyah Dzuhur (2 Rakaat)',
                      'Ba\'diyah Maghrib (2 Rakaat)',
                      'Ba\'diyah Isya (2 Rakaat)',
                      'Sholat Tahajjud (8 Rakaat)',
                      'Sholat Witir (3 Rakaat)',
                    ].map((s) {
                      return FilterChip(
                        label: Text(s, style: const TextStyle(fontSize: 11)),
                        selected: s.contains('Subuh') || s.contains('Qabliyah Dzuhur'),
                        selectedColor: AppColors.primaryFixed,
                        onSelected: (val) {},
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text('Kondisi Khusyuk Qolbu:', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['🌿 Sangat Tenang & Khusyuk', '✨ Cukup Tenang', '🌊 Berjuang Melawan Was-was'].map((k) {
                      return ChoiceChip(
                        label: Text(k, style: const TextStyle(fontSize: 11)),
                        selected: k.contains('Sangat Tenang'),
                        selectedColor: AppColors.primaryFixed,
                        onSelected: (val) {},
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text('Catatan Hati & Munajat:', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  const SizedBox(height: 8),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Tuliskan rasa syukur atau doa yang dipanjatkan...',
                      hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.outline),
                      filled: true,
                      fillColor: AppColors.surfaceContainerLow,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      setState(() {
                        _fardhuStatus['Maghrib'] = true;
                      });
                      Navigator.pop(context);
                      _showFeedback('Alhamdulillah! Sholat Maghrib & Refleksi Qolbu tersimpan di jurnal 🤲');
                    },
                    child: const Text('Simpan Refleksi Sholat', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Sub-modal 5: Panduan Dzikir Pagi & Petang
  void _showDzikirModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.92,
              minChildSize: 0.6,
              maxChildSize: 0.96,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(22),
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.radio_button_checked, color: Color(0xFF4F46E5), size: 22),
                              const SizedBox(width: 8),
                              Text(
                                'Panduan Dzikir Pagi & Petang',
                                style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                              ),
                            ],
                          ),
                          IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context)),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Tabs: Dzikir Pagi & Dzikir Petang
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 4, offset: const Offset(0, 1)),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.wb_sunny_outlined, size: 15, color: Color(0xFF0284C7)),
                                    const SizedBox(width: 6),
                                    Text('Dzikir Pagi', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF0284C7))),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.nights_stay_outlined, size: 15, color: AppColors.secondary),
                                    const SizedBox(width: 6),
                                    Text('Dzikir Petang', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.secondary)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Sanctuary Header Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEDE9FE), Color(0xFFF3F0FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFDDD6FE)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 6),
                                Text('Waktu Utama Dimulai', style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700, color: const Color(0xFF047857))),
                                const Spacer(),
                                Text('18 Untaian Ma\'tsur', style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w600, color: const Color(0xFF6B5E8A))),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Menenangkan Qalb Bersama Dzikir Shahih', style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF433B61))),
                            const SizedBox(height: 4),
                            Text(
                              'Waktu afdhal dibaca ba\'da Shubuh hingga terbit matahari. Melindungi diri, membentangkan rezeki, dan menghadirkan sakinah sepanjang hari.',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF4A4168), height: 1.4),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.schedule, size: 13, color: Color(0xFF6B5E8A)),
                                const SizedBox(width: 4),
                                Text('~18 Menit Tartil', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600, color: const Color(0xFF6B5E8A))),
                                const SizedBox(width: 12),
                                const Icon(Icons.verified, size: 13, color: Color(0xFF6B5E8A)),
                                const SizedBox(width: 4),
                                Text('Riwayat Bukhari & Muslim', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600, color: const Color(0xFF6B5E8A))),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Audio Tartil Bar
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D3142),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.white.withAlpha(25), shape: BoxShape.circle),
                              child: const Icon(Icons.graphic_eq, color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tartil Dzikir Pagi Al-Ma\'tsurat', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                                  Text('Syaikh Misyari Rasyid Al-Afasy • Audio Tartil Resmi', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: Colors.white70)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.play_circle_fill, color: Colors.white, size: 32),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Memutar Audio Murottal Tartil Dzikir Pagi 🎧')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 1. Sayyidul Istighfar
                      _buildDzikirCardItem(
                        number: '1',
                        title: 'Sayyidul Istighfar',
                        subtitle: 'Puncak permohonan ampunan • Dibaca 1x',
                        arabic: 'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
                        latin: '“Allāhumma anta rabbī lā ilāha illā anta, khalaqtanī wa anā \'abduka...”',
                        meaning: 'Ya Allah, Engkaulah Tuhanku, tidak ada Tuhan selain Engkau. Engkaulah yang menciptakanku dan aku adalah hamba-Mu...',
                        target: 1,
                      ),
                      const SizedBox(height: 14),

                      // 2. Ayat Kursi
                      _buildDzikirCardItem(
                        number: '2',
                        title: 'Ayat Kursi (QS. Al-Baqarah: 255)',
                        subtitle: 'Benteng perlindungan malam & siang • Dibaca 1x',
                        arabic: 'اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ...',
                        latin: '“Allāhu lā ilāha illā huwal-ḥayyul-qayyūm...”',
                        meaning: 'Allah, tidak ada tuhan selain Dia. Yang Mahahidup, Yang terus-menerus mengurus (makhluk-Nya)...',
                        target: 1,
                      ),
                      const SizedBox(height: 14),

                      // 3. Al-Mu'awwidzat (3 Qul)
                      _buildDzikirCardItem(
                        number: '3',
                        title: 'Al-Mu\'awwidzat (3 Qul: Al-Ikhlas, Al-Falaq, An-Nas)',
                        subtitle: 'Benteng syirik, dengki, dan bisikan was-was • Masing-masing 3x',
                        arabic: 'قُلْ هُوَ اللَّهُ أَحَدٌ ۝ قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ۝ قُلْ أَعُوذُ بِرَبِّ النَّاسِ ۝',
                        latin: '“Qul huwallāhu aḥad... Qul a‘ūżu birabbil-falaq... Qul a‘ūżu birabbin-nās...”',
                        meaning: 'Katakanlah: Dialah Allah, Yang Maha Esa... Katakanlah: Aku berlindung kepada Tuhan yang menguasai subuh... Katakanlah: Aku berlindung kepada Tuhannya manusia...',
                        target: 3,
                      ),
                      const SizedBox(height: 20),

                      // Action Button Selesaikan Dzikir
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF433B61),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () {
                          setState(() {
                            _dzikirDone = true;
                          });
                          Navigator.pop(context);
                          _showFeedback('Alhamdulillah! Dzikir Harian tuntas disempurnakan 📿');
                        },
                        child: const Text('Tandai Dzikir Hari Ini Selesai ✓', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // Sub-modal 6: Audio Murottal Surah Al-Mulk
  void _showMulkAudioModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.88,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(22),
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.headphones_rounded, color: Color(0xFF4338CA), size: 22),
                          const SizedBox(width: 8),
                          Text(
                            'Audio Surah Al-Mulk',
                            style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                        ],
                      ),
                      IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Player Hero Art
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF312E4A), Color(0xFF1E1B4B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: const Color(0xFF312E4A).withAlpha(30), blurRadius: 16, offset: const Offset(0, 6)),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(20),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(Icons.nightlight_round, color: Color(0xFFDDD6FE), size: 36),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Surah Al-Mulk (Kerajaan)',
                          style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Syaikh Mishary Rashid Al-Afasy • QS. 67 • 30 Ayat Lengkap',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFFDDD6FE)),
                        ),
                        const SizedBox(height: 20),
                        // Audio slider
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: const LinearProgressIndicator(
                            value: 0.45,
                            minHeight: 6,
                            backgroundColor: Colors.white24,
                            color: Color(0xFFDDD6FE),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('03:45', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: Colors.white70)),
                            Text('07:20', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: Colors.white70)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.replay_10, color: Colors.white70, size: 24),
                              onPressed: () {},
                            ),
                            const SizedBox(width: 16),
                            Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFFDDD6FE),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.pause, color: Color(0xFF312E4A), size: 28),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Audio Murottal dijeda.')),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              icon: const Icon(Icons.forward_10, color: Colors.white70, size: 24),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Fadhilah box
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFC7D2FE)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.shield_outlined, color: Color(0xFF4338CA), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Fadhilah Sunnah Sebelum Tidur', style: GoogleFonts.syne(fontSize: 12.5, fontWeight: FontWeight.w700, color: const Color(0xFF312E4A))),
                              const SizedBox(height: 4),
                              Text(
                                '“Surah Al-Mulk adalah pelindung dari siksa kubur (Al-Mani\'ah & Al-Munjiyah). Rasulullah ﷺ tidak tidur sampai membaca surah ini.” (HR. Tirmidzi).',
                                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF4338CA), height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF433B61),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      setState(() {
                        _mulkDone = true;
                      });
                      Navigator.pop(context);
                      _showFeedback('Alhamdulillah! Surah Al-Mulk tuntas disimak 🌙');
                    },
                    child: const Text('Tandai Selesai Mendengar & Tilawah ✓', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDzikirCardItem({
    required String number,
    required String title,
    required String subtitle,
    required String arabic,
    required String latin,
    required String meaning,
    required int target,
  }) {
    int counter = 0;
    return StatefulBuilder(
      builder: (context, setCardState) {
        final isDone = counter >= target;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isDone ? const Color(0xFFA7F3D0) : AppColors.hairline),
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(4), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isDone ? const Color(0xFFD1FAE5) : AppColors.surfaceContainerLow,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        number,
                        style: GoogleFonts.syne(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDone ? const Color(0xFF047857) : AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                        Text(subtitle, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow.withAlpha(120),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  arabic,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.amiri(fontSize: 18, height: 1.8, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 8),
              Text(latin, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.secondary)),
              const SizedBox(height: 4),
              Text(meaning, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant, height: 1.4)),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDone ? const Color(0xFFD1FAE5) : const Color(0xFF433B61),
                    foregroundColor: isDone ? const Color(0xFF047857) : Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: Icon(isDone ? Icons.check_circle : Icons.touch_app, size: 16),
                  label: Text(
                    isDone ? 'Selesai $counter/$target ✓' : 'Hitung Dzikir $counter/$target',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                  onPressed: () {
                    setCardState(() {
                      if (counter < target) {
                        counter++;
                      } else {
                        counter = 0;
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedFardhu = _fardhuStatus.values.where((v) => v).length;
    final completedYaumiyah = (_dhuhaDone ? 1 : 0) +
        (_sedekahDone ? 1 : 0) +
        (_tilawahDone ? 1 : 0) +
        (_dzikirDone ? 1 : 0) +
        (_mulkDone ? 1 : 0) +
        _customHabits.where((h) => h.isCompleted).length;

    // Total actual daily habits: 5 Sholat Fardhu + 5 Core Yaumiyah + Custom habits
    final int totalAll = 10 + _customHabits.length;
    final int completedAll = completedFardhu + completedYaumiyah;
    final progress = totalAll > 0 ? (completedAll / totalAll).clamp(0.0, 1.0) : 0.0;

    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 850;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: (isDesktop && !Navigator.canPop(context))
          ? null
          : AppBar(
              title: Text(
                'Mutaba\'ah & Habits Yaumiyah',
                style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              actions: [
                IconButton(
                  tooltip: 'Pencarian Universal',
                  icon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 22),
                  onPressed: () => showUniversalSearch(context),
                ),
                IconButton(
                  tooltip: 'Tambah Amalan Baru',
                  icon: const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 24),
                  onPressed: _showAddHabitModal,
                ),
              ],
            ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 1240 : 640),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                isDesktop ? 36 : 20,
                isDesktop ? 20 : 16,
                isDesktop ? 36 : 20,
                isDesktop ? 40 : 170, // Prevents mobile floating dock overlap
              ),
              child: isDesktop
                  // DESKTOP RESPONSIVE 2-COLUMN VIEW
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column (flex: 50): Hero Header, Date Strip, Progress Card, Actions & Sholat
                        Expanded(
                          flex: 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildHeroSanctuaryHeader(),
                              const SizedBox(height: 16),
                              _buildWeeklyDateStrip(),
                              if (_isCalendarExpanded) ...[
                                const SizedBox(height: 14),
                                _buildExpandedCalendar(),
                              ],
                              const SizedBox(height: 16),
                              _buildProgressHeroCard(progress, completedAll, totalAll),
                              const SizedBox(height: 16),
                              _buildActionButtonsStrip(),
                              const SizedBox(height: 20),
                              _buildSholatFardhuSection(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Right Column (flex: 50): Yaumiyah Habits, Green Deen, Muhasabah & Statistik Keistiqomahan
                        Expanded(
                          flex: 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildYaumiyahHabitsSection(),
                              const SizedBox(height: 20),
                              _buildGreenDeenCard(),
                              const SizedBox(height: 20),
                              _buildMuhasabahCard(),
                              const SizedBox(height: 20),
                              _buildStatistikKeistiqomahanInlineCard(),
                            ],
                          ),
                        ),
                      ],
                    )
                  // MOBILE SINGLE COLUMN FLOW
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeroSanctuaryHeader(),
                        const SizedBox(height: 16),
                        _buildWeeklyDateStrip(),
                        if (_isCalendarExpanded) ...[
                          const SizedBox(height: 14),
                          _buildExpandedCalendar(),
                        ],
                        const SizedBox(height: 16),
                        _buildProgressHeroCard(progress, completedAll, totalAll),
                        const SizedBox(height: 16),
                        _buildActionButtonsStrip(),
                        const SizedBox(height: 20),
                        _buildSholatFardhuSection(),
                        const SizedBox(height: 20),
                        _buildYaumiyahHabitsSection(),
                        const SizedBox(height: 20),
                        _buildGreenDeenCard(),
                        const SizedBox(height: 20),
                        _buildMuhasabahCard(),
                        const SizedBox(height: 20),
                        _buildStatistikKeistiqomahanInlineCard(),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 1. HERO SANCTUARY HEADER (STITCH)
  // ==========================================
  Widget _buildHeroSanctuaryHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.spa, size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                'Fase Maghfirah • 10 Hari Kedua',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSecondaryContainer,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Istiqomah Journey',
          style: GoogleFonts.syne(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: -0.5),
        ),
        const SizedBox(height: 4),
        Text(
          'Menjaga ritme ibadah yaumiyah dan pembersihan jiwa (Tazkiyatun Nafs) harian keluarga.',
          style: GoogleFonts.plusJakartaSans(fontSize: 12, height: 1.4, color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }

  // ==========================================
  // 2. WEEKLY HORIZONTAL DATE STRIP
  // ==========================================
  Widget _buildWeeklyDateStrip() {
    final days = [
      {'day': 'Ahd', 'date': 9},
      {'day': 'Sen', 'date': 10},
      {'day': 'Sel', 'date': 11},
      {'day': 'Rab', 'date': 12},
      {'day': 'Kam', 'date': 13},
      {'day': 'Jum', 'date': 14}, // Active Today
      {'day': 'Sab', 'date': 15},
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Pekan 14 Ramadhan 1446 H',
                style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.secondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isCalendarExpanded = !_isCalendarExpanded;
                });
              },
              child: Row(
                children: [
                  Icon(_isCalendarExpanded ? Icons.expand_less : Icons.calendar_month, size: 15, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    _isCalendarExpanded ? 'Tutup Kalender' : 'Kalender 30 Hari',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: days.map((d) {
            final isToday = d['date'] == 14;
            final isSelected = d['date'] == _selectedDate;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDate = d['date'] as int;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isToday ? 48 : 42,
                padding: EdgeInsets.symmetric(vertical: isToday ? 10 : 8),
                decoration: BoxDecoration(
                  color: isToday
                      ? AppColors.primary
                      : isSelected
                          ? AppColors.primaryFixed
                          : AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isToday
                      ? [BoxShadow(color: AppColors.primary.withAlpha(50), blurRadius: 8, offset: const Offset(0, 3))]
                      : null,
                ),
                child: Column(
                  children: [
                    Text(
                      d['day'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isToday ? Colors.white70 : AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${d['date']}',
                      style: GoogleFonts.syne(
                        fontSize: isToday ? 15 : 13,
                        fontWeight: FontWeight.w700,
                        color: isToday ? Colors.white : AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isToday
                            ? AppColors.secondaryFixed
                            : (d['date'] as int) < 14
                                ? AppColors.tertiaryFixed
                                : AppColors.outlineVariant,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // EXPANDABLE FULL 30-DAY RAMADAN CALENDAR
  Widget _buildExpandedCalendar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Kalender 30 Hari Ramadhan 1446 H', style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
              Text('Pilih Hari untuk Evaluasi', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary)),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 30,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1.25,
            ),
            itemBuilder: (context, idx) {
              final day = idx + 1;
              final isToday = day == 14;
              final isSelected = day == _selectedDate;
              final isDone = day <= 14;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = day;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isToday
                        ? AppColors.primary
                        : isSelected
                            ? AppColors.primaryFixed
                            : isDone
                                ? AppColors.surfaceContainerLow
                                : AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isToday || isSelected ? AppColors.primary : AppColors.hairline,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('H-$day', style: TextStyle(fontSize: 9, color: isToday ? Colors.white70 : AppColors.secondary)),
                        Text('$day', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isToday ? Colors.white : AppColors.onSurface)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 3. PROGRESS HERO CARD (SOFT LAVENDER GLOW)
  // ==========================================
  Widget _buildProgressHeroCard(double progress, int completedCount, int totalCount) {
    final percent = (progress * 100).toInt();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.hairline),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(12),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'KETERATURAN AMALAN',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$percent% Tercapai',
                  style: GoogleFonts.syne(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.onSurface),
                ),
                const SizedBox(height: 4),
                Text(
                  '$completedCount dari $totalCount amalan harian telah disempurnakan dengan penuh khusyuk.',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.onSurfaceVariant, height: 1.4),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.verified, size: 16, color: AppColors.tertiary),
                    const SizedBox(width: 4),
                    Text(
                      'Istiqomah 9 Hari',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.tertiary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          // Circular Arc Progress Ring
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 76,
                height: 76,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: AppColors.surfaceContainerLow,
                  color: AppColors.primary,
                ),
              ),
              const Icon(Icons.favorite, size: 22, color: AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // ACTION BUTTONS STRIP
  // ==========================================
  Widget _buildActionButtonsStrip() {
    return Row(
      children: [
        Expanded(
          child: _buildActionPill(
            icon: Icons.insights,
            label: 'Analitik',
            onTap: _showAnalyticsModal,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildActionPill(
            icon: Icons.auto_stories,
            label: 'Tilawah 1 Juz',
            onTap: _showTilawahModal,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildActionPill(
            icon: Icons.share,
            label: 'Bagikan Story',
            onTap: _showShareStoryModal,
          ),
        ),
      ],
    );
  }

  Widget _buildActionPill({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.hairline),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // CIRCULAR CHECKLIST BUTTON (AUTHENTIC DESIGN)
  // ==========================================
  Widget _buildCircleCheckButton({
    required bool isDone,
    required VoidCallback onTap,
    bool isDarkTheme = false,
    bool isEnabled = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: !isEnabled
                ? const Color(0xFFF1F5F9)
                : isDone
                    ? (isDarkTheme ? const Color(0xFF2D3142) : const Color(0xFFD1FAE5))
                    : Colors.transparent,
            shape: BoxShape.circle,
            border: !isEnabled
                ? Border.all(color: const Color(0xFFE2E8F0), width: 1.5)
                : isDone
                    ? null
                    : Border.all(color: const Color(0xFFCBD5E1), width: 1.8),
            boxShadow: (isEnabled && isDone)
                ? [
                    BoxShadow(
                      color: (isDarkTheme ? const Color(0xFF2D3142) : const Color(0xFF10B981)).withAlpha(45),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: !isEnabled
                ? const Icon(Icons.lock_outline, size: 14, color: Color(0xFF94A3B8))
                : isDone
                    ? Icon(
                        Icons.check,
                        size: 18,
                        color: isDarkTheme ? Colors.white : const Color(0xFF047857),
                      )
                    : null,
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 4. SHOLAT FARDHU 5 WAKTU & SUNNAH RAWATIB
  // ==========================================
  Widget _buildSholatFardhuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(width: 4, height: 16, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 8),
                Text(
                  'Sholat Fardhu & Rawatib',
                  style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                ),
              ],
            ),
            Row(
              children: [
                TextButton.icon(
                  onPressed: _showCatatSholatModal,
                  icon: const Icon(Icons.edit_calendar, size: 15, color: AppColors.primary),
                  label: Text('Jurnal Sujud', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Subuh (04:38)
        _buildSholatCard(
          name: 'Subuh',
          time: '04:38',
          hour: 4,
          minute: 38,
          icon: Icons.mosque,
          isCompleted: _fardhuStatus['Subuh'] ?? false,
          onToggle: (v) => setState(() => _fardhuStatus['Subuh'] = v),
        ),
        // Dzuhur (11:58)
        _buildSholatCard(
          name: 'Dzuhur',
          time: '11:58',
          hour: 11,
          minute: 58,
          icon: Icons.wb_sunny_outlined,
          isCompleted: _fardhuStatus['Dzuhur'] ?? false,
          onToggle: (v) => setState(() => _fardhuStatus['Dzuhur'] = v),
        ),
        // Ashar (15:13)
        _buildSholatCard(
          name: 'Ashar',
          time: '15:13',
          hour: 15,
          minute: 13,
          icon: Icons.groups,
          isCompleted: _fardhuStatus['Ashar'] ?? false,
          onToggle: (v) => setState(() => _fardhuStatus['Ashar'] = v),
        ),
        // Maghrib (18:05)
        _buildSholatCard(
          name: 'Maghrib',
          time: '18:05',
          hour: 18,
          minute: 5,
          icon: Icons.nights_stay_outlined,
          isCompleted: _fardhuStatus['Maghrib'] ?? false,
          onToggle: (v) => setState(() => _fardhuStatus['Maghrib'] = v),
        ),
        // Isya & Tarawih (19:14)
        _buildSholatCard(
          name: 'Isya & Tarawih',
          time: '19:14',
          hour: 19,
          minute: 14,
          icon: Icons.nightlight_round,
          isCompleted: _fardhuStatus['Isya & Tarawih'] ?? false,
          onToggle: (v) => setState(() => _fardhuStatus['Isya & Tarawih'] = v),
        ),
      ],
    );
  }

  Widget _buildSholatCard({
    required String name,
    required String time,
    required int hour,
    required int minute,
    required IconData icon,
    required bool isCompleted,
    required Function(bool) onToggle,
  }) {
    final isSounded = _isAdzanSounded(hour, minute);
    final isFutureDate = _selectedDate > 14;

    // Status description
    String statusDesc;
    if (isCompleted) {
      statusDesc = 'Selesai ditunaikan 🤲';
    } else if (isFutureDate) {
      statusDesc = 'Belum masuk waktu • Hari belum tiba';
    } else if (!isSounded) {
      final now = DateTime.now();
      final diff = (hour * 60 + minute) - (now.hour * 60 + now.minute);
      if (diff > 0 && diff <= 60) {
        statusDesc = 'Menunggu adzan • $diff menit lagi ($time WIB)';
      } else if (diff > 60) {
        final h = diff ~/ 60;
        final m = diff % 60;
        statusDesc = 'Menunggu adzan • $h jam ${m > 0 ? '$m mnt ' : ''}lagi ($time WIB)';
      } else {
        statusDesc = 'Belum masuk waktu (Adzan $time WIB)';
      }
    } else {
      statusDesc = 'Waktu sholat telah masuk • Silakan tunaikan';
    }

    return InkWell(
      onTap: () {
        if (!isSounded) {
          _showFeedback('Adzan $name belum berkumandang (pukul $time WIB). Belum dapat diceklis.');
          return;
        }
        final next = !isCompleted;
        onToggle(next);
        _showFeedback(next ? 'Alhamdulillah! Sholat $name selesai ditunaikan 🤲' : 'Sholat $name ditandai belum selesai');
      },
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: !isSounded
              ? const Color(0xFFF8FAFC)
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isCompleted
                ? const Color(0xFFA7F3D0).withAlpha(180)
                : (!isSounded ? const Color(0xFFE2E8F0) : AppColors.hairline),
          ),
          boxShadow: isSounded
              ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(5),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  _buildCircleCheckButton(
                    isDone: isCompleted,
                    isEnabled: isSounded,
                    isDarkTheme: false,
                    onTap: () {
                      if (!isSounded) {
                        _showFeedback('Adzan $name belum berkumandang (pukul $time WIB). Belum dapat diceklis.');
                        return;
                      }
                      final next = !isCompleted;
                      onToggle(next);
                      _showFeedback(next ? 'Alhamdulillah! Sholat $name selesai ditunaikan 🤲' : 'Sholat $name ditandai belum selesai');
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              name,
                              style: GoogleFonts.syne(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: !isSounded ? const Color(0xFF94A3B8) : AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              time,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: !isSounded ? const Color(0xFF94A3B8) : AppColors.secondary,
                              ),
                            ),
                            if (!isSounded) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Text(
                                  'Terkunci',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          statusDesc,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            color: isCompleted
                                ? const Color(0xFF047857)
                                : (!isSounded ? const Color(0xFF94A3B8) : AppColors.outline),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSounded && !isCompleted)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _showCatatSholatModal,
                    child: Text(
                      'Catat',
                      style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700),
                    ),
                  ),
                const SizedBox(width: 6),
                Icon(
                  icon,
                  size: 20,
                  color: isCompleted
                      ? AppColors.primary
                      : (!isSounded ? const Color(0xFFCBD5E1) : const Color(0xFF9CA3AF)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 5. AMALAN YAUMIYAH & SUNNAH UTAMA
  // ==========================================
  Widget _buildYaumiyahHabitsSection() {
    final yaumiyahDoneCount = (_dhuhaDone ? 1 : 0) +
        (_sedekahDone ? 1 : 0) +
        (_tilawahDone ? 1 : 0) +
        (_dzikirDone ? 1 : 0) +
        (_mulkDone ? 1 : 0) +
        _customHabits.where((h) => h.isCompleted).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Amalan Yaumiyah & Sunnah',
                      style: GoogleFonts.syne(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$yaumiyahDoneCount',
                  style: GoogleFonts.syne(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'Terlaksana',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 1. Sholat Dhuha Card
        _buildDhuhaCard(),
        const SizedBox(height: 10),

        // 2. Sedekah Subuh Card
        _buildSedekahCard(),
        const SizedBox(height: 10),

        // 3. Tilawah 1 Juz Card
        _buildTilawahCard(),
        const SizedBox(height: 10),

        // 4. Dzikir Pagi & Petang Card
        _buildDzikirCard(),
        const SizedBox(height: 10),

        // 5. Surah Al-Mulk Card
        _buildAlMulkCard(),
        const SizedBox(height: 10),

        // Custom habits
        ..._customHabits.map((item) => _buildCustomHabitCard(item)),

        // Dashed Add Custom Habit Button
        GestureDetector(
          onTap: _showAddHabitModal,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow.withAlpha(120),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.outlineVariant,
                style: BorderStyle.solid,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_circle, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  '+ Tambah Amalan Kustom',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDhuhaCard() {
    return InkWell(
      onTap: () {
        setState(() => _dhuhaDone = !_dhuhaDone);
        _showFeedback(_dhuhaDone ? 'Alhamdulillah! Sholat Dhuha tuntas ✨' : 'Sholat Dhuha ditandai belum selesai');
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _dhuhaDone ? const Color(0xFF0284C7).withAlpha(40) : AppColors.hairline,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(4), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE0F2FE),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.wb_sunny_rounded, color: Color(0xFF0284C7), size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sholat Dhuha',
                          style: GoogleFonts.syne(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '4 Rakaat • Selesai jam 08:15',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _buildCircleCheckButton(
              isDone: _dhuhaDone,
              isDarkTheme: true,
              onTap: () {
                setState(() => _dhuhaDone = !_dhuhaDone);
                _showFeedback(_dhuhaDone ? 'Alhamdulillah! Sholat Dhuha tuntas ✨' : 'Sholat Dhuha ditandai belum selesai');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSedekahCard() {
    return InkWell(
      onTap: () {
        setState(() => _sedekahDone = !_sedekahDone);
        _showFeedback(_sedekahDone ? 'Barakallahu fiik! Sedekah Subuh tercatat 🌿' : 'Sedekah Subuh ditandai belum selesai');
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _sedekahDone ? const Color(0xFF16A34A).withAlpha(40) : AppColors.hairline,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(4), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDCFCE7),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.volunteer_activism, color: Color(0xFF16A34A), size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sedekah Subuh',
                          style: GoogleFonts.syne(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Tercatat Rp 25.000 • Berkah Dini Hari',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _buildCircleCheckButton(
              isDone: _sedekahDone,
              isDarkTheme: true,
              onTap: () {
                setState(() => _sedekahDone = !_sedekahDone);
                _showFeedback(_sedekahDone ? 'Barakallahu fiik! Sedekah Subuh tercatat 🌿' : 'Sedekah Subuh ditandai belum selesai');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTilawahCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _tilawahDone ? const Color(0xFF7C3AED).withAlpha(40) : AppColors.hairline,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(4), blurRadius: 8, offset: const Offset(0, 2)),
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
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3E8FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.auto_stories, color: Color(0xFF7C3AED), size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tilawah 1 Juz',
                            style: GoogleFonts.syne(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Juz 14 • Al-Hijr & An-Nahl',
                            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE9FE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '80%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF7C3AED),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildCircleCheckButton(
                    isDone: _tilawahDone,
                    isDarkTheme: true,
                    onTap: () {
                      setState(() => _tilawahDone = !_tilawahDone);
                      _showFeedback(_tilawahDone ? 'Alhamdulillah! Target tilawah 1 Juz tuntas 📖' : 'Tilawah ditandai belum selesai');
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: const LinearProgressIndicator(
              value: 0.80,
              minHeight: 6,
              backgroundColor: Color(0xFFEDE9FE),
              color: Color(0xFF433B61),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '8 dari 10 lembar',
                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
              ),
              InkWell(
                onTap: _showTilawahModal,
                child: Text(
                  'Buka Tracker Lembar →',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDzikirCard() {
    return InkWell(
      onTap: _showDzikirModal,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _dzikirDone ? const Color(0xFF4F46E5).withAlpha(40) : AppColors.hairline,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(4), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE0E7FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.radio_button_checked, color: Color(0xFF4F46E5), size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dzikir Pagi & Petang',
                          style: GoogleFonts.syne(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Pagi Lengkap • Petang Menanti Maghrib',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.play_circle_outline, color: Color(0xFF9CA3AF), size: 24),
                  tooltip: 'Buka Panduan Dzikir',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  onPressed: _showDzikirModal,
                ),
                const SizedBox(width: 4),
                _buildCircleCheckButton(
                  isDone: _dzikirDone,
                  isDarkTheme: true,
                  onTap: () {
                    setState(() => _dzikirDone = !_dzikirDone);
                    _showFeedback(_dzikirDone ? 'Alhamdulillah! Dzikir petang selesai 📿' : 'Dzikir petang ditandai belum selesai');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlMulkCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFC7D2FE),
        ),
        boxShadow: [
          BoxShadow(color: const Color(0xFF6366F1).withAlpha(12), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.nightlight_round, color: Color(0xFF4338CA), size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Surah Al-Mulk',
                        style: GoogleFonts.syne(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E1B4B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Pengingat 21:30 Aktif • 30 Ayat',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: const Color(0xFF4338CA).withAlpha(180),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF4338CA),
                  elevation: 0,
                  side: const BorderSide(color: Color(0xFFC7D2FE)),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.headphones_rounded, size: 14),
                label: Text(
                  'Buka Audio',
                  style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700),
                ),
                onPressed: _showMulkAudioModal,
              ),
              const SizedBox(width: 8),
              _buildCircleCheckButton(
                isDone: _mulkDone,
                isDarkTheme: true,
                onTap: () {
                  setState(() => _mulkDone = !_mulkDone);
                  _showFeedback(_mulkDone ? 'Alhamdulillah! Surah Al-Mulk selesai disimak 🌙' : 'Surah Al-Mulk ditandai belum selesai');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomHabitCard(HabitItem item) {
    final done = item.isCompleted;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: done ? AppColors.primary.withAlpha(40) : AppColors.hairline),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(4), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.star_rounded, color: AppColors.primary, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: GoogleFonts.syne(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          decoration: done ? TextDecoration.lineThrough : null,
                          color: done ? AppColors.secondary : AppColors.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          '${item.quantity} ${item.unit}',
                          style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(item.reminderTime, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline)),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(4)),
                        child: const Text('Kustom', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Row(
            children: [
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.outline),
                tooltip: 'Hapus Amalan',
                onPressed: () {
                  setState(() {
                    _customHabits.removeWhere((h) => h.id == item.id);
                  });
                },
              ),
              _buildCircleCheckButton(
                isDone: done,
                isDarkTheme: true,
                onTap: () {
                  setState(() => item.isCompleted = !done);
                  _showFeedback(item.isCompleted ? 'Target amalan tercapai!' : 'Amalan ditandai belum selesai');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 6. GREEN DEEN & SEDEKAH AIR (ECO-SPIRITUALITY)
  // ==========================================
  Widget _buildGreenDeenCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.tertiary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppColors.tertiary.withAlpha(20), blurRadius: 12, offset: const Offset(0, 4)),
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
                    const Icon(Icons.water_drop, color: AppColors.tertiaryFixed, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Green Deen • Sedekah Air',
                        style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.tertiaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('Level 2', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.tertiaryFixed)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Sunnah menghemat air wudhu (1 Mud ~ 0.65L). Hari ini Anda menghemat wudhu 1.5L dari kuota 2.5L.',
            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.tertiaryFixed.withValues(alpha: 0.85), height: 1.4),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: const LinearProgressIndicator(
              value: 0.6,
              minHeight: 6,
              backgroundColor: AppColors.tertiaryContainer,
              color: AppColors.tertiaryFixed,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1.5L / 2.5L Terjaga', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.tertiaryFixed)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF111E19),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  _showFeedback('Alhamdulillah, hemat air wudhu 1.5L tercatat di jurnal Green Deen 💧');
                },
                child: const Text('Catat Hemat Air & Wakaf', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 7. MUHASABAH & REFLEKSI QOLBU
  // ==========================================
  Widget _buildMuhasabahCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.hairline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
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
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Muhasabah & Refleksi',
                        style: GoogleFonts.syne(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: _showCatatSholatModal,
                child: Text(
                  'Buka Lembar Arsip',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.notes, size: 16, color: Color(0xFF6B7280)),
              const SizedBox(width: 6),
              Text(
                'CATATAN HATI PETANG INI',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '“Alhamdulillah atas ketenangan hati hari ini. Mampu menahan lisan saat lelah berpuasa, dan diberi kemudahan mendampingi anak menghafal Surah Al-Balad.”',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt_outlined, size: 16),
                  label: Text(
                    'Buat Story 9:16',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE2E8F0),
                    foregroundColor: const Color(0xFF1E293B),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: _showShareStoryModal,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.edit_note, size: 16),
                  label: Text(
                    'Tulis Refleksi Jiwa',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEDE9FE),
                    foregroundColor: const Color(0xFF433B61),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: _showCatatSholatModal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 8. STATISTIK KEISTIQOMAHAN (INLINE CARD)
  // ==========================================
  Widget _buildStatistikKeistiqomahanInlineCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.hairline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
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
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Statistik Keistiqomahan',
                        style: GoogleFonts.syne(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: _showAnalyticsModal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Analitik →',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Category Dots Legend (Wrap to prevent mobile overflow)
          Wrap(
            spacing: 10,
            runSpacing: 6,
            children: [
              _buildCategoryLegendDot(const Color(0xFF312E4A), 'Wajib (60%)'),
              _buildCategoryLegendDot(const Color(0xFFC7D2FE), 'Sunnah (25%)'),
              _buildCategoryLegendDot(const Color(0xFFA7F3D0), 'Sosial/Air (15%)'),
            ],
          ),
          const SizedBox(height: 18),
          // 7-day Bar Chart
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildDayBarColumn(day: 'Ahd', wajibH: 52, sunnahH: 22, socialH: 14, isToday: false, isFuture: false),
              _buildDayBarColumn(day: 'Sen', wajibH: 58, sunnahH: 20, socialH: 14, isToday: false, isFuture: false),
              _buildDayBarColumn(day: 'Sel', wajibH: 48, sunnahH: 24, socialH: 14, isToday: false, isFuture: false),
              _buildDayBarColumn(day: 'Rab', wajibH: 58, sunnahH: 22, socialH: 14, isToday: false, isFuture: false),
              _buildDayBarColumn(day: 'Kam', wajibH: 60, sunnahH: 24, socialH: 14, isToday: false, isFuture: false),
              _buildDayBarColumn(day: 'Jum', wajibH: 68, sunnahH: 22, socialH: 10, isToday: true, isFuture: false),
              _buildDayBarColumn(day: 'Sab', wajibH: 0, sunnahH: 0, socialH: 0, isToday: false, isFuture: true),
            ],
          ),
          const SizedBox(height: 16),
          // Insights Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.trending_up, color: AppColors.primary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        color: AppColors.onSurface,
                        height: 1.4,
                      ),
                      children: [
                        const TextSpan(text: 'Amalan paling konsisten pekan ini adalah '),
                        TextSpan(
                          text: 'Sholat Subuh Berjamaah ',
                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                        const TextSpan(text: 'dan '),
                        TextSpan(
                          text: 'Sedekah Dini Hari.',
                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.secondary),
        ),
      ],
    );
  }

  Widget _buildDayBarColumn({
    required String day,
    required double wajibH,
    required double sunnahH,
    required double socialH,
    required bool isToday,
    required bool isFuture,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isFuture)
          Container(
            width: 32,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
          )
        else
          Container(
            width: 32,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: isToday
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(50),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ]
                  : null,
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Top segment: Sosial/Air
                Container(
                  width: 32,
                  height: wajibH + sunnahH + socialH,
                  decoration: const BoxDecoration(
                    color: Color(0xFFA7F3D0),
                  ),
                ),
                // Middle segment: Sunnah
                Container(
                  width: 32,
                  height: wajibH + sunnahH,
                  decoration: const BoxDecoration(
                    color: Color(0xFFC7D2FE),
                  ),
                ),
                // Bottom segment: Wajib
                Container(
                  width: 32,
                  height: wajibH,
                  decoration: BoxDecoration(
                    color: isToday ? const Color(0xFF3B3353) : const Color(0xFF4A4168),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),
        Text(
          day,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
            color: isToday ? AppColors.primary : AppColors.secondary,
          ),
        ),
      ],
    );
  }
}

// ==========================================
// FORM TAMBAH TARGET AMALAN KUSTOM (STITCH)
// ==========================================
class AddHabitFormSheet extends StatefulWidget {
  final ScrollController? scrollController;
  final Function(HabitItem item) onSave;

  const AddHabitFormSheet({
    super.key,
    this.scrollController,
    required this.onSave,
  });

  @override
  State<AddHabitFormSheet> createState() => _AddHabitFormSheetState();
}

class _AddHabitFormSheetState extends State<AddHabitFormSheet> {
  final TextEditingController _nameController = TextEditingController(text: 'Sholat Dhuha 8 Rakaat');
  final TextEditingController _intentionController = TextEditingController(
    text: 'Niat sholat sunnah Dhuha lillahi ta\'ala. Memohon kelapangan rezeki barakah dan ketenteraman batin di pagi hari.',
  );

  String _selectedFrequency = 'Setiap Hari';
  final Set<String> _selectedDays = {'Sen', 'Kam'};
  int _quantity = 8;
  String _selectedUnit = 'Rakaat';
  String _selectedCategory = 'Sholat';
  TimeOfDay _reminderTime = const TimeOfDay(hour: 6, minute: 15);
  final bool _isSoundEnabled = true;
  final bool _isPrivate = true;

  @override
  void dispose() {
    _nameController.dispose();
    _intentionController.dispose();
    super.dispose();
  }

  void _applyInspiration({
    required String name,
    required String category,
    required String freq,
    required int qty,
    required String unit,
    Set<String>? days,
    String? intention,
    TimeOfDay? time,
  }) {
    setState(() {
      _nameController.text = name;
      _selectedCategory = category;
      _selectedFrequency = freq;
      _quantity = qty;
      _selectedUnit = unit;
      if (days != null) {
        _selectedDays.clear();
        _selectedDays.addAll(days);
      }
      if (intention != null) {
        _intentionController.text = intention;
      }
      if (time != null) {
        _reminderTime = time;
      }
    });
  }

  void _handleSubmit() {
    final title = _nameController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan masukkan nama amalan terlebih dahulu.')),
      );
      return;
    }

    final hourStr = _reminderTime.hour.toString().padLeft(2, '0');
    final minuteStr = _reminderTime.minute.toString().padLeft(2, '0');
    final timeStr = '$hourStr:$minuteStr WIB';

    final newItem = HabitItem(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      category: _selectedCategory,
      frequency: _selectedFrequency,
      days: _selectedFrequency == 'Hari Tertentu' ? _selectedDays.toList() : const [],
      quantity: _quantity,
      unit: _selectedUnit,
      reminderTime: timeStr,
      intention: _intentionController.text.trim(),
      isSoundEnabled: _isSoundEnabled,
      isCompleted: false,
      isPrivate: _isPrivate,
      isCustom: true,
    );

    widget.onSave(newItem);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceContainerLowest,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 6),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.primary),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Tambah Target Amalan',
                      style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline, size: 20, color: AppColors.secondary),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.surfaceContainerHigh),
          Expanded(
            child: ListView(
              controller: widget.scrollController,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.mistySage, AppColors.surfaceContainerLow],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.hairline),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.spa, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('RANCANG AMALAN KUSTOM', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primary)),
                            Text('Ritme Ibadah Penuh Ketenangan', style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text('INSPIRASI AMALAN CEPAT', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primary)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildInspirationChip(
                      label: 'Puasa Sunnah (Senin-Kamis/Daud)',
                      onTap: () => _applyInspiration(
                        name: 'Puasa Sunnah Senin-Kamis / Daud',
                        category: 'Puasa',
                        freq: 'Hari Tertentu',
                        qty: 1,
                        unit: 'Hari',
                        days: {'Sen', 'Kam'},
                      ),
                    ),
                    _buildInspirationChip(
                      label: 'Tahajjud & Witir Sepertiga Malam',
                      onTap: () => _applyInspiration(
                        name: 'Tahajjud & Witir Sepertiga Malam',
                        category: 'Sholat',
                        freq: 'Setiap Hari',
                        qty: 3,
                        unit: 'Rakaat',
                      ),
                    ),
                    _buildInspirationChip(
                      label: 'Sholat Dhuha 8 Rakaat',
                      isSelected: _nameController.text.contains('Dhuha'),
                      onTap: () => _applyInspiration(
                        name: 'Sholat Dhuha 8 Rakaat',
                        category: 'Sholat',
                        freq: 'Setiap Hari',
                        qty: 8,
                        unit: 'Rakaat',
                      ),
                    ),
                    _buildInspirationChip(
                      label: 'Sedekah Subuh Jumat Berkah',
                      onTap: () => _applyInspiration(
                        name: 'Sedekah Subuh Jumat Berkah',
                        category: 'Sedekah',
                        freq: 'Hari Tertentu',
                        qty: 1,
                        unit: 'Kali',
                        days: {'Jum'},
                      ),
                    ),
                    _buildInspirationChip(
                      label: 'Muraja\'ah & Hafalan Surah',
                      onTap: () => _applyInspiration(
                        name: 'Muraja\'ah & Hafalan Surah Pilihan',
                        category: 'Dzikir & Tilawah',
                        freq: 'Setiap Hari',
                        qty: 2,
                        unit: 'Halaman',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('NAMA AMALAN', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primary)),
                const SizedBox(height: 6),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                Text('TARGET KUANTITAS & SATUAN', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primary)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: AppColors.primary),
                      onPressed: () {
                        if (_quantity > 1) setState(() => _quantity--);
                      },
                    ),
                    Text('$_quantity', style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: AppColors.primary),
                      onPressed: () => setState(() => _quantity++),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        children: ['Rakaat', 'Lembar', 'Halaman', 'Kali', 'Rupiah'].map((u) {
                          return ChoiceChip(
                            label: Text(u, style: const TextStyle(fontSize: 10)),
                            selected: _selectedUnit == u,
                            selectedColor: AppColors.primaryFixed,
                            onSelected: (val) {
                              if (val) setState(() => _selectedUnit = u);
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _handleSubmit,
                  child: const Text('Simpan Target Amalan', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInspirationChip({required String label, required VoidCallback onTap, bool isSelected = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryFixed : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.hairline),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppColors.primary : AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}
