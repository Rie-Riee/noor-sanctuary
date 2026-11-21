import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../ai_chat/tanya_ustadz_chat_screen.dart';
import '../habits/habits_tab_screen.dart';
import '../search/universal_search_sheet.dart';

/// Data Model untuk Pencatatan Harian Haid & Gejala (Authentic Period Tracker Log)
class DailyPeriodLog {
  int day;
  String status; // 'haid', 'suci', 'istihadhah', 'nifas'
  String flow; // 'Deras (Heavy)', 'Sedang (Medium)', 'Ringan (Light)', 'Bercak (Spotting)', 'Tidak Ada'
  String bloodColor; // 'Merah Segar (Ahmar)', 'Merah Gelap (Aswad)', 'Coklat (Kudrah)', 'Kuning (Sufrah)'
  List<String> symptoms;
  List<String> moods;
  String notes;
  int cycleDay;

  DailyPeriodLog({
    required this.day,
    this.status = 'haid',
    this.flow = 'Sedang (Medium)',
    this.bloodColor = 'Merah Segar (Ahmar)',
    this.symptoms = const ['Kram Perut Ringan', 'Lelah / Lemah'],
    this.moods = const ['Sensitif', 'Tenang'],
    this.notes = '',
    this.cycleDay = 1,
  });
}

class SisterhoodScreen extends StatefulWidget {
  final VoidCallback? onProfileTap;

  const SisterhoodScreen({super.key, this.onProfileTap});

  @override
  State<SisterhoodScreen> createState() => _SisterhoodScreenState();
}

class _SisterhoodScreenState extends State<SisterhoodScreen> {
  String _selectedStatus = 'haid'; // 'haid', 'suci', 'istihadhah', 'nifas'
  int _currentCycleDay = 14; // Current day of 28-day cycle (Day 14)
  int _cycleDay = 4; // Day 4 of active period
  final int _cycleTotalEstimate = 7; // Average period duration: 7 days
  final int _cycleLength = 28; // Standard 28-day cycle
  int _selectedCalendarDay = 14; // Default selected date in calendar inspector

  // Qadha Puasa Ramadhan Tracker
  final int _qadhaPuasaDebt = 7; // 7 days of missed fast due to period in Ramadan
  int _qadhaPuasaPaid = 2; // 2 days already made up

  // Period, Fertility & Ovulation day sets in Ramadan 1446 H
  final Set<int> _haidDays = {10, 11, 12, 13, 14, 15, 16};
  final Set<int> _istihadhahDays = {17};
  final Set<int> _fertileDays = {23, 24, 25, 26, 27};
  final int _ovulationDay = 26;

  // Rich daily logs map for all 30 days of Ramadan
  late Map<int, DailyPeriodLog> _dailyLogs;

  // Sisterhood Habit Checklist
  final List<HabitItem> _customSisterhoodHabits = [];
  late List<HabitItem> _sisterhoodHabits;

  // Sholat Fardhu status for Suci mode (starts unchecked, user checks themselves!)
  final Map<String, bool> _fardhuStatus = {
    'Subuh': false,
    'Dzuhur': false,
    'Ashar': false,
    'Maghrib': false,
    'Isya & Tarawih': false,
  };

  bool _isAdzanSounded(int hour, int minute) {
    if (_selectedCalendarDay < 14) return true; // Past days: all prayers have passed
    if (_selectedCalendarDay > 14) return false; // Future days: none have passed

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

  @override
  void initState() {
    super.initState();
    _initDailyLogs();
    _initHabits();
  }

  void _initDailyLogs() {
    _dailyLogs = {};
    for (int d = 1; d <= 30; d++) {
      if (_haidDays.contains(d)) {
        final periodDay = d - 9; // Day 1 to 7 of period
        String flow = 'Sedang (Medium)';
        String color = 'Merah Segar (Ahmar)';
        List<String> symptoms = ['Kram Perut Ringan', 'Lelah / Lemah'];
        if (d == 10) {
          flow = 'Ringan (Light)';
          symptoms = ['Kram Perut', 'Sakit Pinggang'];
        } else if (d == 11 || d == 12) {
          flow = 'Deras (Heavy)';
          color = 'Merah Gelap (Aswad)';
          symptoms = ['Kram Perut', 'Sakit Pinggang', 'Sakit Kepala'];
        } else if (d == 13 || d == 14) {
          flow = 'Sedang (Medium)';
          symptoms = ['Kram Ringan', 'Lelah'];
        } else if (d == 15) {
          flow = 'Ringan (Light)';
          symptoms = ['Lelah'];
        } else if (d == 16) {
          flow = 'Bercak (Spotting)';
          color = 'Coklat (Kudrah)';
          symptoms = ['Normal'];
        }

        _dailyLogs[d] = DailyPeriodLog(
          day: d,
          status: 'haid',
          flow: flow,
          bloodColor: color,
          symptoms: symptoms,
          moods: ['Sensitif', 'Butuh Ketenangan'],
          notes: 'Fase haid hari ke-$periodDay. Gugur sholat & puasa Ramadhan.',
          cycleDay: periodDay,
        );
      } else if (_istihadhahDays.contains(d)) {
        _dailyLogs[d] = DailyPeriodLog(
          day: d,
          status: 'istihadhah',
          flow: 'Bercak (Spotting)',
          bloodColor: 'Kuning (Sufrah)',
          symptoms: ['Sisa Flek Thaharah'],
          moods: ['Tenang'],
          notes: 'Darah penyakit / flek setelah mandi wajib. Kaidah Fiqih: Wajib wudhu setiap sholat.',
          cycleDay: 8,
        );
      } else {
        _dailyLogs[d] = DailyPeriodLog(
          day: d,
          status: 'suci',
          flow: 'Tidak Ada',
          bloodColor: 'Tidak Ada',
          symptoms: _fertileDays.contains(d) ? ['Lendir Serviks Bening', 'Masa Subur'] : ['Tubuh Segar & Sehat'],
          moods: ['Tenang', 'Khusyu\'', 'Bersemangat'],
          notes: _fertileDays.contains(d) ? 'Masa subur (Peluang kehamilan tinggi).' : 'Fase suci thaharah. Wajib sholat 5 waktu & berpuasa.',
          cycleDay: d,
        );
      }
    }
  }

  void _addNewSisterhoodHabit(HabitItem item) {
    setState(() {
      _customSisterhoodHabits.insert(0, item);
      _sisterhoodHabits.insert(0, item);
    });
    _showFeedback('Target amalan "${item.title}" berhasil ditambahkan 🌸');
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
                onSave: _addNewSisterhoodHabit,
              ),
            );
          },
        );
      },
    );
  }

  void _initHabits() {
    final isHaid = _selectedStatus == 'haid' || _selectedStatus == 'nifas';

    if (isHaid) {
      _sisterhoodHabits = [
        ..._customSisterhoodHabits,
        HabitItem(
          id: 'sh_1',
          title: 'Dzikir Pagi Al-Ma\'tsurat & Istighfar 100x',
          category: 'Dzikir & Doa',
          frequency: 'Setiap Hari',
          quantity: 15,
          unit: 'Menit',
          reminderTime: '05:30 WIB',
          isCompleted: false,
        ),
        HabitItem(
          id: 'sh_2',
          title: 'Sholawat Nabi Muhammad SAW 100x',
          category: 'Dzikir & Doa',
          frequency: 'Setiap Hari',
          quantity: 100,
          unit: 'Kali',
          reminderTime: '07:00 WIB',
          isCompleted: false,
        ),
        HabitItem(
          id: 'sh_3',
          title: 'Sedekah Subuh Kencleng Barakah',
          category: 'Sedekah',
          frequency: 'Setiap Hari',
          quantity: 1,
          unit: 'Kali',
          reminderTime: '06:00 WIB',
          isCompleted: false,
        ),
        HabitItem(
          id: 'sh_4',
          title: 'Mendengar Murottal Surah Maryam & Ar-Rahman',
          category: 'Tilawah & Audio',
          frequency: 'Setiap Hari',
          quantity: 20,
          unit: 'Menit',
          reminderTime: '10:00 WIB',
          isCompleted: false,
        ),
        HabitItem(
          id: 'sh_5',
          title: 'Menyimak Kajian Fiqih Wanita (Ustzh. Halimah)',
          category: 'Kajian & Fiqih',
          frequency: 'Setiap Hari',
          quantity: 30,
          unit: 'Menit',
          reminderTime: '16:30 WIB',
          isCompleted: false,
        ),
        HabitItem(
          id: 'sh_6',
          title: 'Membaca Terjemah & Tadabbur Surah Al-Mulk',
          category: 'Tadabbur',
          frequency: 'Setiap Hari',
          quantity: 15,
          unit: 'Menit',
          reminderTime: '21:00 WIB',
          isCompleted: false,
        ),
        HabitItem(
          id: 'sh_7',
          title: 'Munajat Hening Doa & Dzikir Petang',
          category: 'Dzikir & Doa',
          frequency: 'Setiap Hari',
          quantity: 15,
          unit: 'Menit',
          reminderTime: '17:45 WIB',
          isCompleted: false,
        ),
      ];
    } else {
      _sisterhoodHabits = [
        ..._customSisterhoodHabits,
        HabitItem(
          id: 'sh_dhuha',
          title: 'Sholat Dhuha 4 Rakaat',
          category: 'Sholat Sunnah',
          frequency: 'Setiap Hari',
          quantity: 4,
          unit: 'Rakaat',
          reminderTime: '08:15 WIB',
          isCompleted: false,
        ),
        HabitItem(
          id: 'sh_sedekah',
          title: 'Sedekah Subuh Kencleng',
          category: 'Sedekah',
          frequency: 'Setiap Hari',
          quantity: 25000,
          unit: 'Rupiah',
          reminderTime: '05:30 WIB',
          isCompleted: false,
        ),
        HabitItem(
          id: 'sh_tilawah',
          title: 'Tilawah 1 Juz (Juz 14 • Al-Hijr & An-Nahl)',
          category: 'Dzikir & Tilawah',
          frequency: 'Setiap Hari',
          quantity: 10,
          unit: 'Lembar',
          reminderTime: '16:00 WIB',
          isCompleted: false,
        ),
        HabitItem(
          id: 'sh_dzikir',
          title: 'Dzikir Pagi & Petang Al-Ma\'tsurat',
          category: 'Dzikir & Tilawah',
          frequency: 'Setiap Hari',
          quantity: 15,
          unit: 'Menit',
          reminderTime: '17:30 WIB',
          isCompleted: false,
        ),
        HabitItem(
          id: 'sh_mulk',
          title: 'Surah Al-Mulk Sebelum Tidur',
          category: 'Dzikir & Tilawah',
          frequency: 'Setiap Hari',
          quantity: 30,
          unit: 'Ayat',
          reminderTime: '21:30 WIB',
          isCompleted: false,
        ),
      ];
    }
  }

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
                      _showFeedback('Alhamdulillah! Sholat Maghrib & Refleksi Qolbu berhasil dicatat ke jurnal 🤲');
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
                  Center(
                    child: Container(
                      width: 280,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4A3E6D), Color(0xFF1E1B4B)],
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
                              const Icon(Icons.spa, color: Colors.white, size: 18),
                              const SizedBox(width: 6),
                              Text('SISTERHOOD SANCTUARY', style: GoogleFonts.syne(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1.2)),
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
                              border: Border.all(color: const Color(0xFFFCE7F3), width: 3),
                            ),
                            child: const Center(
                              child: Text('86%', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text('Istiqomah Thaharah', style: GoogleFonts.notoSerif(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                          const SizedBox(height: 4),
                          Text('Ibadah Penuh Ketenangan Jiwa', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.white70)),
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
                      _showFeedback('Gambar story siap dibagikan ke Instagram!');
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

  void _showMurottalMaryamModal() {
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
                          const Icon(Icons.headphones_rounded, color: Color(0xFFDB2777), size: 22),
                          const SizedBox(width: 8),
                          Text(
                            'Murottal Penyejuk Qolbu',
                            style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                        ],
                      ),
                      IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF831843), Color(0xFF4A044E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
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
                            child: Icon(Icons.spa, color: Color(0xFFFBCFE8), size: 36),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Surah Maryam & Ar-Rahman',
                          style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Syaikh Mishary Rashid Al-Afasy • Audio Murottal Khusus Relaksasi',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFFFBCFE8)),
                        ),
                        const SizedBox(height: 20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: const LinearProgressIndicator(
                            value: 0.35,
                            minHeight: 6,
                            backgroundColor: Colors.white24,
                            color: Color(0xFFFBCFE8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('04:15', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: Colors.white70)),
                            Text('18:40', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: Colors.white70)),
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
                                color: Color(0xFFFBCFE8),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.pause, color: Color(0xFF831843), size: 28),
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
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF831843),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _showFeedback('Alhamdulillah, mendengarkan murottal penyejuk hati tuntas 🌸');
                    },
                    child: const Text('Tandai Selesai Mendengar ✓', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showMandiWajibModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 6),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.water_drop, color: AppColors.primary, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Tata Cara Mandi Wajib (Ghusl)',
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
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Niat Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryFixed.withAlpha(80),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primary.withAlpha(40)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.menu_book, color: AppColors.primary, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                'Niat Mandi Wajib Setelah Haid',
                                style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'نَوَيْتُ الْغُسْلَ لِرَفْعِ الْحَدَثِ الْأَكْبَرِ مِنَ الْحَيْضِ فَرْضًا لِلّٰهِ تَعَالَى',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.amiri(fontSize: 20, fontWeight: FontWeight.bold, height: 1.8),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Nawaitul ghusla lirof\'il hadatsil akbari minal haidhi fardhan lillaahi ta\'aalaa.',
                            style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontStyle: FontStyle.italic, color: AppColors.secondary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '"Aku berniat mandi untuk menghilangkan hadats besar dari haid fardhu karena Allah Ta\'ala."',
                            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    Text(
                      '5 Rukun Mandi Wajib (Madzhab Syafi\'i):',
                      style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                    const SizedBox(height: 12),

                    _buildStepItem(1, 'Membaca Basmalah & Berniat', 'Niat di dalam hati bersamaan saat air pertama kali menyentuh anggota tubuh.'),
                    _buildStepItem(2, 'Mencuci Kedua Telapak Tangan 3 Kali', 'Membersihkan tangan dari kotoran sebelum menyentuh air bersih.'),
                    _buildStepItem(3, 'Membersihkan Kemaluan & Najis', 'Membersihkan sisa darah dan najis dengan tangan kiri hingga bersih dan suci.'),
                    _buildStepItem(4, 'Berwudhu Sempurna Seperti Wudhu Sholat', 'Melakukan wudhu lengkap sebelum membasuh seluruh tubuh.'),
                    _buildStepItem(5, 'Mengguyur Air ke Seluruh Tubuh', 'Meratakan air ke seluruh rambut hingga pangkal kulit kepala (3 kali), lalu ke seluruh tubuh dari sisi kanan kemudian kiri.'),

                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _selectedStatus = 'suci';
                          _initHabits();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Alhamdulillah, status diperbarui menjadi FASE SUCI (THAHARAH)!'),
                            backgroundColor: Color(0xFF10B981),
                          ),
                        );
                      },
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: Text('Saya Sudah Mandi Wajib (Tandai Suci)', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepItem(int step, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: AppColors.primaryFixed,
            child: Text('$step', style: GoogleFonts.syne(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primary)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                const SizedBox(height: 2),
                Text(desc, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Interactive Bottom Sheet untuk mencatat data harian periode haid (Flo/Clue style)
  void _showDailyLogBottomSheet(int day) {
    final currentLog = _dailyLogs[day] ??
        DailyPeriodLog(
          day: day,
          status: _haidDays.contains(day) ? 'haid' : 'suci',
        );

    String tempStatus = currentLog.status;
    String tempFlow = currentLog.flow;
    String tempColor = currentLog.bloodColor;
    final Set<String> tempSymptoms = Set.from(currentLog.symptoms);
    final Set<String> tempMoods = Set.from(currentLog.moods);
    final notesCtrl = TextEditingController(text: currentLog.notes);

    final symptomOptions = [
      'Kram Perut',
      'Sakit Pinggang',
      'Sakit Kepala / Migrain',
      'Lelah / Lemah',
      'Mual',
      'Jerawat',
      'Mengidam Makanan',
      'Perut Kembung',
      'Nyeri Payudara',
    ];

    final moodOptions = [
      'Tenang & Damai',
      'Sensitif / Rapuh',
      'Mudah Kesal',
      'Mengantuk',
      'Khusyu\'',
      'Cemas',
    ];

    final flowOptions = [
      'Bercak (Spotting)',
      'Ringan (Light)',
      'Sedang (Medium)',
      'Deras (Heavy)',
      'Tidak Ada',
    ];

    final colorOptions = [
      'Merah Segar (Ahmar)',
      'Merah Gelap (Aswad)',
      'Coklat Keruh (Kudrah)',
      'Kuning (Sufrah)',
      'Tidak Ada',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.88,
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 6),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Catat Log Harian • Tanggal $day Ramadhan',
                              style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primary),
                            ),
                            Text(
                              'Pencatatan Aliran Darah, Warna & Gejala Fisik',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        // 1. Status Darah
                        Text('Status Siklus Hari Ini:', style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildChoiceTile(
                              label: '🩸 Haid',
                              isSelected: tempStatus == 'haid',
                              onTap: () => setModalState(() => tempStatus = 'haid'),
                            ),
                            const SizedBox(width: 8),
                            _buildChoiceTile(
                              label: '💧 Suci',
                              isSelected: tempStatus == 'suci',
                              onTap: () => setModalState(() => tempStatus = 'suci'),
                            ),
                            const SizedBox(width: 8),
                            _buildChoiceTile(
                              label: '🟡 Istihadhah',
                              isSelected: tempStatus == 'istihadhah',
                              onTap: () => setModalState(() => tempStatus = 'istihadhah'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // 2. Aliran Darah (Flow)
                        Text('Aliran Darah (Flow):', style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: flowOptions.map((f) {
                            final isSel = tempFlow == f;
                            return ChoiceChip(
                              label: Text(f),
                              selected: isSel,
                              selectedColor: const Color(0xFFF43F5E),
                              backgroundColor: AppColors.surfaceContainerLow,
                              labelStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                color: isSel ? Colors.white : AppColors.onSurface,
                              ),
                              onSelected: (_) => setModalState(() => tempFlow = f),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 18),

                        // 3. Warna Darah (Kaidah Fiqih Thaharah)
                        Text('Warna Darah (Kaidah Fiqih Thaharah):', style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        const SizedBox(height: 4),
                        Text('Membantu menentukan batas suci, haid murni, atau darah istihadhah', style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.secondary)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: colorOptions.map((c) {
                            final isSel = tempColor == c;
                            return ChoiceChip(
                              label: Text(c),
                              selected: isSel,
                              selectedColor: AppColors.primary,
                              backgroundColor: AppColors.surfaceContainerLow,
                              labelStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                color: isSel ? Colors.white : AppColors.onSurface,
                              ),
                              onSelected: (_) => setModalState(() => tempColor = c),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 18),

                        // 4. Gejala Fisik (Symptoms)
                        Text('Gejala Fisik yang Dirasakan:', style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: symptomOptions.map((s) {
                            final isSel = tempSymptoms.contains(s);
                            return FilterChip(
                              label: Text(s),
                              selected: isSel,
                              selectedColor: AppColors.primaryFixed,
                              backgroundColor: AppColors.surfaceContainerLow,
                              labelStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                color: isSel ? AppColors.primary : AppColors.onSurface,
                              ),
                              onSelected: (val) {
                                setModalState(() {
                                  if (val) {
                                    tempSymptoms.add(s);
                                  } else {
                                    tempSymptoms.remove(s);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 18),

                        // 5. Suasana Hati (Mood)
                        Text('Suasana Hati (Mood):', style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: moodOptions.map((m) {
                            final isSel = tempMoods.contains(m);
                            return FilterChip(
                              label: Text(m),
                              selected: isSel,
                              selectedColor: const Color(0xFFE0E7FF),
                              backgroundColor: AppColors.surfaceContainerLow,
                              labelStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                color: isSel ? const Color(0xFF4338CA) : AppColors.onSurface,
                              ),
                              onSelected: (val) {
                                setModalState(() {
                                  if (val) {
                                    tempMoods.add(m);
                                  } else {
                                    tempMoods.remove(m);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 18),

                        // 6. Catatan Pribadi
                        Text('Catatan Tambahan:', style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: notesCtrl,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: 'Tuliskan catatan kondisi tubuh, obat yang diminum, dll...',
                            hintStyle: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.secondary.withAlpha(160)),
                            filled: true,
                            fillColor: AppColors.surfaceContainerLow,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.all(12),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Save Button
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          icon: const Icon(Icons.save, size: 18),
                          label: Text('Simpan Catatan Siklus', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
                          onPressed: () {
                            setState(() {
                              currentLog.status = tempStatus;
                              currentLog.flow = tempFlow;
                              currentLog.bloodColor = tempColor;
                              currentLog.symptoms = tempSymptoms.toList();
                              currentLog.moods = tempMoods.toList();
                              currentLog.notes = notesCtrl.text;

                              if (tempStatus == 'haid') {
                                _haidDays.add(day);
                                _istihadhahDays.remove(day);
                              } else if (tempStatus == 'istihadhah') {
                                _istihadhahDays.add(day);
                                _haidDays.remove(day);
                              } else {
                                _haidDays.remove(day);
                                _istihadhahDays.remove(day);
                              }
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Catatan siklus tanggal $day Ramadhan berhasil disimpan!'),
                                backgroundColor: AppColors.primary,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChoiceTile({required String label, required bool isSelected, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isSelected ? AppColors.primary : AppColors.hairline),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 850;
    final isHaid = _selectedStatus == 'haid' || _selectedStatus == 'nifas';

    final completedCount = _sisterhoodHabits.where((h) => h.isCompleted).length;
    final totalCount = _sisterhoodHabits.isEmpty ? 1 : _sisterhoodHabits.length;
    final progress = (completedCount / totalCount).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: isDesktop
          ? null
          : AppBar(
              titleSpacing: 16,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Sisterhood',
                        style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCE7F3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Thaharah',
                          style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w700, color: const Color(0xFFDB2777)),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '14 Ramadhan 1446 H • Siklus & Ibadah',
                    style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  tooltip: 'Pencarian Universal',
                  icon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 21),
                  onPressed: () => showUniversalSearch(context),
                ),
                IconButton(
                  tooltip: 'Panduan Mandi Wajib',
                  icon: const Icon(Icons.menu_book, color: AppColors.primary, size: 21),
                  onPressed: _showMandiWajibModal,
                ),
              ],
            ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 1240 : 640),
            child: Scrollbar(
              thumbVisibility: isDesktop,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  isDesktop ? 32 : 16,
                  isDesktop ? 20 : 12,
                  isDesktop ? 32 : 16,
                  isDesktop ? 50 : 160, // Ample clearance for mobile floating dock
                ),
                child: isDesktop
                    // DESKTOP RESPONSIVE TWO-COLUMN VIEW
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column (flex: 50): Desktop Header, Status Switcher, Cycle Wheel, Period Calendar, Day Inspector, Qadha Puasa, Cycle Insights
                          Expanded(
                            flex: 50,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildDesktopHeader(),
                                const SizedBox(height: 18),
                                _buildStatusSwitcherPills(),
                                const SizedBox(height: 18),
                                _buildCycleWheelHeroCard(isHaid),
                                const SizedBox(height: 20),
                                _buildPeriodCalendarCard(),
                                const SizedBox(height: 20),
                                _buildSelectedDayInspectorCard(),
                                const SizedBox(height: 20),
                                _buildQadhaPuasaCard(),
                                const SizedBox(height: 20),
                                _buildCycleInsightsCard(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 26),
                          // Right Column (flex: 50): Habit Progress, Actions, Fiqih, Sholat / Suspension, Amalan Yaumiyah, Green Deen, Muhasabah, Inline Stats
                          Expanded(
                            flex: 50,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildHabitProgressCard(progress, completedCount, totalCount, isHaid),
                                const SizedBox(height: 16),
                                _buildActionButtonsStrip(),
                                const SizedBox(height: 16),
                                _buildFiqihGuidanceBox(isHaid),
                                const SizedBox(height: 16),
                                if (!isHaid) ...[
                                  _buildSholatFardhuSection(),
                                  const SizedBox(height: 16),
                                ] else ...[
                                  _buildHaidSholatSuspensionBanner(),
                                  const SizedBox(height: 16),
                                ],
                                _buildHabitsSection(isHaid),
                                const SizedBox(height: 18),
                                _buildGreenDeenCard(),
                                const SizedBox(height: 18),
                                _buildMuhasabahCard(),
                                const SizedBox(height: 18),
                                _buildStatistikKeistiqomahanInlineCard(),
                              ],
                            ),
                          ),
                        ],
                      )
                    // MOBILE SINGLE COLUMN VERTICAL FLOW
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sisterhood Sanctuary',
                                      style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Thaharah, Siklus Haid & Amalan Muslimah',
                                      style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              if (widget.onProfileTap != null)
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: widget.onProfileTap,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    child: Tooltip(
                                      message: 'Lihat Profil Muslimah',
                                      child: const CircleAvatar(
                                        radius: 17,
                                        backgroundColor: Color(0xFFFCE7F3),
                                        child: Icon(Icons.female_rounded, color: Color(0xFFDB2777), size: 18),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _buildStatusSwitcherPills(),
                          const SizedBox(height: 16),
                          _buildHabitProgressCard(progress, completedCount, totalCount, isHaid),
                          const SizedBox(height: 14),
                          _buildActionButtonsStrip(isMobile: true),
                          const SizedBox(height: 18),
                          _buildCycleWheelHeroCard(isHaid, isMobile: true),
                          const SizedBox(height: 18),
                          _buildPeriodCalendarCard(),
                          const SizedBox(height: 18),
                          _buildSelectedDayInspectorCard(),
                          const SizedBox(height: 18),
                          _buildQadhaPuasaCard(),
                          const SizedBox(height: 18),
                          _buildCycleInsightsCard(),
                          const SizedBox(height: 18),
                          _buildFiqihGuidanceBox(isHaid),
                          const SizedBox(height: 16),
                          if (!isHaid) ...[
                            _buildSholatFardhuSection(),
                            const SizedBox(height: 16),
                          ] else ...[
                            _buildHaidSholatSuspensionBanner(),
                            const SizedBox(height: 16),
                          ],
                          _buildHabitsSection(isHaid),
                          const SizedBox(height: 18),
                          _buildGreenDeenCard(),
                          const SizedBox(height: 18),
                          _buildMuhasabahCard(),
                          const SizedBox(height: 18),
                          _buildStatistikKeistiqomahanInlineCard(),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // DESKTOP CLEAN HEADER (No duplicate appbar)
  // ==========================================
  Widget _buildDesktopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Sisterhood Sanctuary',
                  style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE7F3),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '✦ Thaharah & Siklus',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFDB2777),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Pencatatan haid akurat, kalender kesuburan, manajemen qadha puasa & fiqih thaharah',
              style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.secondary),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // STATUS SWITCHER PILLS (FLO / CLUE STYLE)
  // ==========================================
  Widget _buildStatusSwitcherPills() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        children: [
          _buildPillTab(
            label: '🩸 Sedang Haid',
            isSelected: _selectedStatus == 'haid',
            activeColor: const Color(0xFFE11D48),
            onTap: () {
              setState(() {
                _selectedStatus = 'haid';
                _cycleDay = 4;
                _initHabits();
              });
              _showFeedback('Mode beralih ke Sedang Haid (Rukhsah & Amalan Khusus) 🩸');
            },
          ),
          _buildPillTab(
            label: '💧 Masa Suci',
            isSelected: _selectedStatus == 'suci',
            activeColor: const Color(0xFF059669),
            onTap: () {
              setState(() {
                _selectedStatus = 'suci';
                _initHabits();
              });
              _showFeedback('Mode beralih ke Masa Suci (Wajib Sholat & Puasa) 💧');
            },
          ),
          _buildPillTab(
            label: '🟡 Istihadhah',
            isSelected: _selectedStatus == 'istihadhah',
            activeColor: const Color(0xFFD97706),
            onTap: () {
              setState(() {
                _selectedStatus = 'istihadhah';
                _initHabits();
              });
              _showFeedback('Mode beralih ke Istihadhah (Wajib Wudhu Tiap Sholat) 🟡');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPillTab({
    required String label,
    required bool isSelected,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: activeColor.withAlpha(50),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.secondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 1. CYCLE WHEEL & STATUS DIAL HERO CARD (FLO/CLUE STYLE)
  // ==========================================
  Widget _buildCycleWheelHeroCard(bool isHaid, {bool isMobile = false}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isHaid
              ? [const Color(0xFFFFF1F2), const Color(0xFFFFE4E6)]
              : [const Color(0xFFF0FDF4), const Color(0xFFDCFCE7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isHaid ? const Color(0xFFFECDD3) : const Color(0xFFBBF7D0),
        ),
        boxShadow: [
          BoxShadow(
            color: (isHaid ? const Color(0xFFF43F5E) : const Color(0xFF10B981)).withAlpha(20),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 4),
                        ],
                      ),
                      child: Icon(
                        isHaid ? Icons.water_drop : Icons.spa,
                        color: isHaid ? const Color(0xFFE11D48) : const Color(0xFF059669),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'STATUS SIKLUS HARI INI',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                              color: isHaid ? const Color(0xFFBE123C) : const Color(0xFF047857),
                            ),
                          ),
                          Text(
                            '14 Ramadhan • Hari ke-$_currentCycleDay Siklus',
                            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withAlpha(6), blurRadius: 4),
                  ],
                ),
                child: Text(
                  isHaid ? 'FASE HAID (HARI KE-$_cycleDay)' : 'FASE SUCI (THAHARAH)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: isHaid ? const Color(0xFFE11D48) : const Color(0xFF059669),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Big Cycle Dial Circle
          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: isHaid ? const Color(0xFFFDA4AF) : const Color(0xFF86EFAC),
                width: 7,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isHaid ? const Color(0xFFE11D48) : const Color(0xFF10B981)).withAlpha(25),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hari ke-$_cycleDay',
                  style: GoogleFonts.syne(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: isHaid ? const Color(0xFF9F1239) : const Color(0xFF065F46),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isHaid ? 'Aliran: Deras (Heavy)' : 'Kondisi: Bersih & Suci',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isHaid ? const Color(0xFFE11D48) : const Color(0xFF059669),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isHaid ? 'Hari $_cycleDay dari $_cycleTotalEstimate hari' : 'Subur dalam 9 hari',
                  style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Insight tags
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(isHaid ? Icons.block : Icons.check_circle, size: 14, color: isHaid ? Colors.red : Colors.green),
                    const SizedBox(width: 5),
                    Text(
                      isHaid ? 'Gugur Sholat & Puasa' : 'Wajib Sholat & Puasa',
                      style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700, color: isHaid ? Colors.red[800] : Colors.green[800]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.favorite, size: 13, color: Color(0xFFDB2777)),
                    const SizedBox(width: 5),
                    Text(
                      'Peluang Hamil: Sangat Rendah',
                      style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700, color: const Color(0xFF9D174D)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action Buttons
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE11D48),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                  ),
                  icon: const Icon(Icons.edit_calendar, size: 16),
                  label: Text('Catat Gejala & Aliran Hari Ini', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                  onPressed: () => _showDailyLogBottomSheet(14),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 1,
                  ),
                  icon: const Icon(Icons.water_drop_outlined, size: 16),
                  label: Text('Darah Berhenti (Panduan Mandi)', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                  onPressed: _showMandiWajibModal,
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE11D48),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                    ),
                    icon: const Icon(Icons.edit_calendar, size: 16),
                    label: Text('Catat Gejala & Aliran Hari Ini', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                    onPressed: () => _showDailyLogBottomSheet(14),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 1,
                  ),
                  icon: const Icon(Icons.water_drop_outlined, size: 16),
                  label: Text('Darah Berhenti', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700)),
                  onPressed: _showMandiWajibModal,
                ),
              ],
            ),
        ],
      ),
    );
  }

  // ==========================================
  // 2. AUTHENTIC PERIOD & FERTILITY CALENDAR
  // ==========================================
  Widget _buildPeriodCalendarCard() {
    const weekdays = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Ahd'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.hairline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Calendar Header with Month Switcher
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_month, color: Color(0xFFE11D48), size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Kalender Haid & Kesuburan',
                            style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Ramadhan 1446 H (Maret – April 2026)',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Menampilkan riwayat bulan Sya\'ban 1446 H.')),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Menampilkan prediksi bulan Syawwal 1446 H.')),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Weekday Labels (Pixel-perfect alignment with 7 grid columns)
          Row(
            children: weekdays.map((w) {
              return Expanded(
                child: Center(
                  child: Text(
                    w,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.outline),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),

          // 30 Days Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 30,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              final day = index + 1;
              final isHaidDay = _haidDays.contains(day);
              final isIstihadhah = _istihadhahDays.contains(day);
              final isFertile = _fertileDays.contains(day);
              final isOvulation = day == _ovulationDay;
              final isToday = day == 14;
              final isSelected = day == _selectedCalendarDay;

              Color bg = AppColors.surfaceContainerLow;
              Color textColor = AppColors.onSurface;
              Widget? iconIndicator;

              if (isHaidDay) {
                bg = const Color(0xFFFEE2E2); // Soft red/pink
                textColor = const Color(0xFF991B1B);
                iconIndicator = const Icon(Icons.water_drop, size: 9, color: Color(0xFFDC2626));
              } else if (isIstihadhah) {
                bg = const Color(0xFFFEF3C7); // Soft amber
                textColor = const Color(0xFF92400E);
                iconIndicator = const Icon(Icons.circle, size: 6, color: Color(0xFFD97706));
              } else if (isOvulation) {
                bg = const Color(0xFFCCFBF1); // Teal
                textColor = const Color(0xFF0F766E);
                iconIndicator = const Icon(Icons.star, size: 9, color: Color(0xFF0D9488));
              } else if (isFertile) {
                bg = const Color(0xFFE0F2FE); // Soft light blue/teal
                textColor = const Color(0xFF0369A1);
                iconIndicator = const Icon(Icons.local_florist, size: 8, color: Color(0xFF0284C7));
              }

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCalendarDay = day;
                    _currentCycleDay = day;
                    if (_haidDays.contains(day)) {
                      _selectedStatus = 'haid';
                      _cycleDay = (day - 9).clamp(1, 15);
                    } else if (_istihadhahDays.contains(day)) {
                      _selectedStatus = 'istihadhah';
                    } else {
                      _selectedStatus = 'suci';
                    }
                    _initHabits();
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    color: bg,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : (isToday ? const Color(0xFFE11D48) : Colors.transparent),
                      width: isSelected || isToday ? 2.2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withAlpha(40),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$day',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: isToday || isHaidDay || isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        if (iconIndicator != null) ...[
                          const SizedBox(height: 1),
                          iconIndicator,
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Authentic Period Legend
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Wrap(
              spacing: 14,
              runSpacing: 8,
              children: [
                _buildLegendItem(const Color(0xFFFEE2E2), const Color(0xFFDC2626), '🩸 Haid (Aktif)'),
                _buildLegendItem(const Color(0xFFE0F2FE), const Color(0xFF0284C7), '🌸 Masa Subur'),
                _buildLegendItem(const Color(0xFFCCFBF1), const Color(0xFF0D9488), '⭐ Puncak Ovulasi'),
                _buildLegendItem(const Color(0xFFFEF3C7), const Color(0xFFD97706), '🟡 Istihadhah / Flek'),
                _buildLegendItem(AppColors.surfaceContainerLowest, AppColors.outline, '⚪ Suci (Wajib Ibadah)'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color bg, Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 1.5),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }

  // ==========================================
  // 3. SELECTED DAY INSPECTOR CARD (Flo-Style Daily Breakdown)
  // ==========================================
  Widget _buildSelectedDayInspectorCard() {
    final log = _dailyLogs[_selectedCalendarDay] ??
        DailyPeriodLog(
          day: _selectedCalendarDay,
          status: _haidDays.contains(_selectedCalendarDay) ? 'haid' : 'suci',
        );

    final isSelectedHaid = log.status == 'haid';
    final isSelectedIstihadhah = log.status == 'istihadhah';
    final isSelectedFertile = _fertileDays.contains(_selectedCalendarDay);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.hairline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 12,
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
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelectedHaid ? const Color(0xFFFEE2E2) : AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isSelectedHaid ? Icons.water_drop : Icons.event_note,
                        color: isSelectedHaid ? const Color(0xFFE11D48) : AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rabu, $_selectedCalendarDay Ramadhan 1446 H',
                            style: GoogleFonts.syne(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.primary),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            isSelectedHaid
                                ? 'Hari ke-${_selectedCalendarDay - 9} Haid • Siklus Hari ke-$_selectedCalendarDay'
                                : (isSelectedIstihadhah ? 'Flek / Istihadhah' : (isSelectedFertile ? 'Masa Subur (Fertile)' : 'Fase Suci Thaharah')),
                            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryFixed,
                  foregroundColor: AppColors.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.edit, size: 13),
                label: Text('Edit Log', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700)),
                onPressed: () => _showDailyLogBottomSheet(_selectedCalendarDay),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Flow & Color indicators
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Aliran Darah (Flow)', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary)),
                      const SizedBox(height: 2),
                      Text(log.flow, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
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
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Warna Darah (Fiqih)', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary)),
                      const SizedBox(height: 2),
                      Text(log.bloodColor, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Symptoms & Moods
          Text('Gejala Fisik & Suasana Hati:', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ...log.symptoms.map((s) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: const Color(0xFFFCE7F3), borderRadius: BorderRadius.circular(8)),
                    child: Text(s, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600, color: const Color(0xFFBE185D))),
                  )),
              ...log.moods.map((m) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: const Color(0xFFE0E7FF), borderRadius: BorderRadius.circular(8)),
                    child: Text(m, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600, color: const Color(0xFF4338CA))),
                  )),
            ],
          ),
          const SizedBox(height: 14),

          // Kaidah Fiqih Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelectedHaid ? const Color(0xFFFFF1F2) : const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isSelectedHaid ? const Color(0xFFFECDD3) : const Color(0xFFBBF7D0)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isSelectedHaid ? Icons.info_outline : Icons.check_circle_outline,
                  color: isSelectedHaid ? const Color(0xFFE11D48) : const Color(0xFF059669),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isSelectedHaid
                            ? 'Status Fiqih: Gugur Sholat & Puasa (Wajib Qadha Puasa)'
                            : (isSelectedIstihadhah
                                ? 'Status Fiqih: Darah Istihadhah (Wajib Sholat & Puasa setelah Wudhu tiap waktu)'
                                : 'Status Fiqih: Wajib Menunaikan Sholat Fardhu 5 Waktu & Puasa'),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isSelectedHaid ? const Color(0xFF9F1239) : const Color(0xFF065F46),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isSelectedHaid
                            ? 'Amalan pengganti utama: Perbanyak istighfar, dzikir pagi-petang, shalawat, dan menyimak kajian tafsir Al-Qur\'an.'
                            : 'Manfaatkan masa suci untuk mengejar target khataman Al-Qur\'an dan sholat sunnah rawatib & tarawih.',
                        style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.onSurfaceVariant, height: 1.35),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 4. STATISTIK & ANALISIS SIKLUS (CYCLE INSIGHTS)
  // ==========================================
  Widget _buildCycleInsightsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(26),
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
                    const Icon(Icons.analytics_outlined, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Analisis Siklus & Pola Haid',
                        style: GoogleFonts.syne(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.primary),
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
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Teratur', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF15803D))),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Panjang Siklus', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary)),
                      const SizedBox(height: 2),
                      Text('$_cycleLength Hari', style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
                      Text('Normal (21–35 hari)', style: GoogleFonts.plusJakartaSans(fontSize: 9.5, color: const Color(0xFF15803D))),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Durasi Haid', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary)),
                      const SizedBox(height: 2),
                      Text('6.5 Hari', style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFFE11D48))),
                      Text('Ghalib Syafi\'i (6–7 hari)', style: GoogleFonts.plusJakartaSans(fontSize: 9.5, color: AppColors.secondary)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Riwayat 3 Bulan Terakhir
          Text('Riwayat 3 Siklus Terakhir:', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
          const SizedBox(height: 8),

          _buildCycleHistoryRow('Ramadhan 1446 H', '10 – 16 Ramadhan (7 Hari)', 'Sedang Berlangsung', const Color(0xFFE11D48)),
          const SizedBox(height: 6),
          _buildCycleHistoryRow('Sya\'ban 1446 H', '12 – 18 Sya\'ban (7 Hari)', 'Siklus: 28 Hari (Normal)', const Color(0xFF15803D)),
          const SizedBox(height: 6),
          _buildCycleHistoryRow('Rajab 1446 H', '14 – 20 Rajab (7 Hari)', 'Siklus: 29 Hari (Normal)', const Color(0xFF15803D)),
        ],
      ),
    );
  }

  Widget _buildCycleHistoryRow(String month, String dates, String status, Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(month, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
              Text(dates, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary)),
            ],
          ),
          Text(status, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: statusColor)),
        ],
      ),
    );
  }

  // ==========================================
  // 5. KALKULATOR & TRACKER QADHA PUASA RAMADHAN
  // ==========================================
  Widget _buildQadhaPuasaCard() {
    final remainingDebt = _qadhaPuasaDebt - _qadhaPuasaPaid;
    final progress = (_qadhaPuasaPaid / _qadhaPuasaDebt).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(26),
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
                    const Icon(Icons.receipt_long, color: Color(0xFF0284C7), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Buku Qadha Puasa Ramadhan',
                        style: GoogleFonts.syne(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('Hutang: $remainingDebt Hari', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF0369A1))),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Kewajiban qadha puasa Ramadhan akibat haid (QS. Al-Baqarah: 185). Lunasi sebelum tiba Ramadhan berikutnya.',
            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary, height: 1.4),
          ),
          const SizedBox(height: 14),

          // Progress bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progres Pelunasan', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary)),
              Text('$_qadhaPuasaPaid dari $_qadhaPuasaDebt Hari (${(progress * 100).toInt()}%)',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.surfaceContainerLow,
              color: const Color(0xFF0284C7),
            ),
          ),
          const SizedBox(height: 14),

          // Action button
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.add_task, size: 16),
                  label: Text('Catat Sudah Qadha 1 Hari', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700)),
                  onPressed: () {
                    if (_qadhaPuasaPaid < _qadhaPuasaDebt) {
                      setState(() => _qadhaPuasaPaid++);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Alhamdulillah! 1 hari puasa qadha tercatat. Sisa: ${(_qadhaPuasaDebt - _qadhaPuasaPaid)} hari.'),
                          backgroundColor: const Color(0xFF0284C7),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Maa Syaa Allah! Seluruh hutang puasa qadha Anda telah lunas tuntas.')),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 6. HABIT PROGRESS & MUTABA'AH (CIRCULAR ARC RING)
  // ==========================================
  Widget _buildHabitProgressCard(double progress, int completedCount, int totalCount, bool isHaid) {
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
            color: (isHaid ? const Color(0xFFE11D48) : AppColors.primary).withAlpha(12),
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
                    color: isHaid ? const Color(0xFFBE123C) : AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$percent% Tercapai',
                  style: GoogleFonts.syne(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.onSurface),
                ),
                const SizedBox(height: 4),
                Text(
                  isHaid
                      ? '$completedCount dari $totalCount amalan khusus haid telah disempurnakan dengan penuh keikhlasan.'
                      : '$completedCount dari $totalCount amalan yaumiyah & sholat telah disempurnakan dengan khusyuk.',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.onSurfaceVariant, height: 1.4),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.verified, size: 16, color: isHaid ? const Color(0xFFE11D48) : AppColors.tertiary),
                    const SizedBox(width: 4),
                    Text(
                      'Istiqomah 9 Hari',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isHaid ? const Color(0xFFBE123C) : AppColors.tertiary,
                      ),
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
                  color: isHaid ? const Color(0xFFE11D48) : AppColors.primary,
                ),
              ),
              Icon(
                Icons.spa,
                size: 24,
                color: isHaid ? const Color(0xFFE11D48) : AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // ACTION BUTTONS STRIP
  // ==========================================
  Widget _buildActionButtonsStrip({bool isMobile = false}) {
    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildActionPill(
                  icon: Icons.edit_calendar,
                  label: 'Catat Siklus',
                  onTap: () => _showDailyLogBottomSheet(_selectedCalendarDay),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionPill(
                  icon: Icons.water_drop_outlined,
                  label: 'Mandi Wajib',
                  onTap: _showMandiWajibModal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildActionPill(
                  icon: Icons.chat_bubble_outline,
                  label: 'Tanya Fiqih',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const TanyaUstadzChatScreen()));
                  },
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
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _buildActionPill(
            icon: Icons.edit_calendar,
            label: 'Catat Siklus',
            onTap: () => _showDailyLogBottomSheet(_selectedCalendarDay),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildActionPill(
            icon: Icons.water_drop_outlined,
            label: 'Mandi Wajib',
            onTap: _showMandiWajibModal,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildActionPill(
            icon: Icons.chat_bubble_outline,
            label: 'Tanya Fiqih',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TanyaUstadzChatScreen()));
            },
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.hairline),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: AppColors.primary),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.primary),
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
  // SHOLAT FARDHU 5 WAKTU & RAWATIB (SUCI MODE)
  // ==========================================
  Widget _buildSholatFardhuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(width: 4, height: 16, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Sholat Fardhu & Rawatib',
                      style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            TextButton.icon(
              onPressed: _showCatatSholatModal,
              icon: const Icon(Icons.edit_calendar, size: 15, color: AppColors.primary),
              label: Text('Jurnal Sujud', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
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
    final isFutureDate = _selectedCalendarDay > 14;

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
  // FIQIH HAID SHOLAT SUSPENSION BANNER (HAID MODE)
  // ==========================================
  Widget _buildHaidSholatSuspensionBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFFECDD3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF43F5E).withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFFFE4E6),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.spa_rounded, color: Color(0xFFE11D48), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Fase Haid: Sholat Fardhu Digugurkan',
                        style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF9F1239)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE4E6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('Rukhsah Syar\'i', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFFBE123C))),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Berdasarkan Ijma\' Ulama, wanita haid haram sholat dan tidak perlu meng-qadha sholat. Tetap raih pahala berlimpah dengan istighfar, shalawat, sedekah, dan mendengar Al-Qur\'an.',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF881337), height: 1.4),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: _showMandiWajibModal,
                  child: Row(
                    children: [
                      const Icon(Icons.menu_book, size: 14, color: Color(0xFFE11D48)),
                      const SizedBox(width: 6),
                      Text(
                        'Pelajari Fiqih Thaharah & Mandi Wajib →',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFFE11D48)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 7. FIQIH GUIDANCE & TANYA AI
  // ==========================================
  Widget _buildFiqihGuidanceBox(bool isHaid) {
    return Container(
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
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.auto_stories, color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Fiqih Thaharah & Fatwa',
                        style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: const BorderSide(color: AppColors.primaryFixed),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const TanyaUstadzChatScreen()));
                },
                icon: const Icon(Icons.chat_bubble_outline, size: 12, color: AppColors.primary),
                label: Text('Tanya AI', style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isHaid
                ? 'Saat haid, Anda tetap mendapatkan pahala besar melalui: istighfar, mendengarkan murottal, bersholawat, bersedekah, serta berbakti kepada keluarga.'
                : 'Setelah suci, segerakan mandi wajib agar tidak terlewat waktu sholat fardhu.',
            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary, height: 1.4),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 8. HABITS LIST (AUTHENTIC CIRCLE BUTTONS & AUDIO ACTION)
  // ==========================================
  Widget _buildHabitsSection(bool isHaid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                isHaid ? 'Amalan Hari Ini (Khusus Haid)' : 'Target Ibadah Hari Ini',
                style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            TextButton.icon(
              icon: const Icon(Icons.add, size: 14),
              label: const Text('Tambah'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
              ),
              onPressed: _showAddHabitModal,
            ),
          ],
        ),
        const SizedBox(height: 8),
        ..._sisterhoodHabits.map((item) {
          final done = item.isCompleted;
          final isAudio = item.title.contains('Murottal') || item.title.contains('Mulk');

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: done ? AppColors.primary.withAlpha(50) : AppColors.hairline),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildCircleCheckButton(
                  isDone: done,
                  isDarkTheme: true,
                  onTap: () {
                    setState(() {
                      item.isCompleted = !done;
                    });
                    _showFeedback(item.isCompleted ? 'Alhamdulillah! Target "${item.title}" tercapai 🌸' : 'Amalan ditandai belum selesai');
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: done ? FontWeight.w600 : FontWeight.w500,
                          decoration: done ? TextDecoration.lineThrough : null,
                          color: done ? AppColors.secondary : AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${item.quantity} ${item.unit}',
                              style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primary),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            item.reminderTime,
                            style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isAudio) ...[
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFCE7F3),
                      foregroundColor: const Color(0xFFDB2777),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.headphones_rounded, size: 13),
                    label: Text('Audio', style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700)),
                    onPressed: _showMurottalMaryamModal,
                  ),
                  const SizedBox(width: 6),
                ],
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.outline),
                  tooltip: 'Hapus Amalan',
                  onPressed: () {
                    setState(() {
                      _customSisterhoodHabits.removeWhere((h) => h.id == item.id);
                      _sisterhoodHabits.removeWhere((h) => h.id == item.id);
                    });
                    _showFeedback('Amalan berhasil dihapus');
                  },
                ),
              ],
            ),
          );
        }),

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

  // ==========================================
  // 9. GREEN DEEN & SEDEKAH AIR (ECO-SPIRITUALITY)
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
  // 10. MUHASABAH & REFLEKSI QOLBU
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
              Row(
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
                  Text(
                    'Muhasabah & Refleksi',
                    style: GoogleFonts.syne(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
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
            '“Alhamdulillah atas ketenangan hati hari ini. Ikhlas menerima takdir rukhsah haid di bulan Ramadhan dan berikhtiar istiqomah melunasi qadha puasa kelak.”',
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
  // 11. STATISTIK KEISTIQOMAHAN (INLINE CARD)
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
                          fontSize: 14.5,
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
              Text(
                'Tingkat: 87%',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Category Dots Legend (Wrap to prevent overflow on mobile)
          Wrap(
            spacing: 10,
            runSpacing: 6,
            children: [
              _buildCategoryLegendDot(const Color(0xFF312E4A), 'Wajib/Rukhsah (60%)'),
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
                          text: 'Dzikir Pagi Al-Ma\'tsurat ',
                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                        const TextSpan(text: 'dan '),
                        TextSpan(
                          text: 'Sedekah Subuh.',
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (socialH > 0)
                  Container(
                    width: 32,
                    height: socialH,
                    decoration: const BoxDecoration(
                      color: Color(0xFFA7F3D0),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                  ),
                if (sunnahH > 0)
                  Container(
                    width: 32,
                    height: sunnahH,
                    color: const Color(0xFFC7D2FE),
                  ),
                if (wajibH > 0)
                  Container(
                    width: 32,
                    height: wajibH,
                    decoration: const BoxDecoration(
                      color: Color(0xFF312E4A),
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                    ),
                  ),
              ],
            ),
          ),
        const SizedBox(height: 6),
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
