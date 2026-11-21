import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class MurottalAudioSanctuaryScreen extends StatefulWidget {
  const MurottalAudioSanctuaryScreen({super.key});

  @override
  State<MurottalAudioSanctuaryScreen> createState() => _MurottalAudioSanctuaryScreenState();
}

class _MurottalAudioSanctuaryScreenState extends State<MurottalAudioSanctuaryScreen> with SingleTickerProviderStateMixin {
  bool _isPlaying = true;
  bool _isTalaqqiActive = true;
  int _talaqqiDelaySeconds = 5;
  int _selectedQariIndex = 0;
  late AnimationController _animController;

  final List<Map<String, String>> _qaris = [
    {
      'name': 'Syaikh Mishary Rashid Al-Afasy',
      'country': 'Kuwait • Hafs \'an \'Ashim',
      'avatar': 'MA',
    },
    {
      'name': 'Syaikh Abdurrahman As-Sudais',
      'country': 'Imam Masjidil Haram • Makkah',
      'avatar': 'AS',
    },
    {
      'name': 'Syaikh Sa\'ad Al-Ghamdi',
      'country': 'Arab Saudi • Tartil Khusyu\'',
      'avatar': 'SG',
    },
    {
      'name': 'Syaikh Hani Ar-Rifa\'i',
      'country': 'Arab Saudi • Nada Syahdu',
      'avatar': 'HR',
    },
    {
      'name': 'Syaikh Maher Al-Mu\'aiqly',
      'country': 'Imam Masjidil Haram • Makkah',
      'avatar': 'MM',
    },
  ];

  final List<Map<String, dynamic>> _curatedPlaylists = [
    {
      'title': 'Penyejuk Hati Kala Cemas',
      'surahs': 'QS. Al-Insyirah, Ad-Dhuha, Ar-Rahman',
      'duration': '22 Menit',
      'icon': Icons.spa_outlined,
      'color': const Color(0xFF10B981),
    },
    {
      'title': 'Sunnah Malam & Hari Jumat',
      'surahs': 'QS. Al-Kahf, As-Sajdah, Al-Mulk',
      'duration': '48 Menit',
      'icon': Icons.nightlight_round,
      'color': const Color(0xFF6366F1),
    },
    {
      'title': 'Ruqyah Syar\'iyyah & Dzikir Pagi',
      'surahs': 'QS. Al-Baqarah 1-5, Ayat Kursi, Al-Mu\'awwidzatain',
      'duration': '35 Menit',
      'icon': Icons.shield_outlined,
      'color': const Color(0xFFF59E0B),
    },
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
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
          'Murottal Qari & Audio Sanctuary',
          style: GoogleFonts.syne(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.primary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.equalizer, color: AppColors.primary),
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
            // Hero Player Card (Mockup 6)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E2744), Color(0xFF433B61)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(50),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Calligraphy Box
                  Container(
                    width: 140,
                    height: 140,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(20),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.white30, width: 1.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'سورة الكهف',
                          style: AppTheme.quranArabic(fontSize: 32).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Al-Kahf',
                          style: GoogleFonts.syne(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  Text(
                    'Surah Al-Kahf (Ayat 1-110)',
                    style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _qaris[_selectedQariIndex]['name']!,
                    style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w600, color: const Color(0xFFD3C8F7)),
                  ),
                  Text(
                    'Riwayat Hafs \'an \'Ashim • Murattal Studio HQ (320 kbps)',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.white60),
                  ),
                  const SizedBox(height: 16),

                  // Waveform visualizer
                  SizedBox(
                    height: 38,
                    child: AnimatedBuilder(
                      animation: _animController,
                      builder: (context, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(28, (index) {
                            final factor = (index % 6 + 1) * 0.15;
                            final height = _isPlaying
                                ? (_animController.value * factor * 28 + 6)
                                : 6.0;
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 1.8),
                              width: 3.5,
                              height: height.clamp(4.0, 36.0),
                              decoration: BoxDecoration(
                                color: index < 14 ? const Color(0xFF10B981) : Colors.white60,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Audio Slider
                  Row(
                    children: [
                      Text('18:42', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.white70)),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 3,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          ),
                          child: Slider(
                            value: 0.41,
                            activeColor: const Color(0xFF10B981),
                            inactiveColor: Colors.white24,
                            onChanged: (v) {},
                          ),
                        ),
                      ),
                      Text('45:10', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.white70)),
                    ],
                  ),

                  // Player Controller
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shuffle, color: Colors.white70, size: 20),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_previous, color: Colors.white, size: 28),
                        onPressed: () {},
                      ),
                      InkWell(
                        onTap: () => setState(() => _isPlaying = !_isPlaying),
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 32,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next, color: Colors.white, size: 28),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.repeat, color: Colors.white70, size: 20),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Mode Talaqqi Khusyu' (Pause Setiap Ayat)
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
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: AppColors.primaryFixed,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.headphones, color: AppColors.primary, size: 18),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mode Talaqqi Khusyu\'',
                                style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                              ),
                              Text(
                                'Pause Otomatis Setiap Ayat',
                                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Switch(
                        value: _isTalaqqiActive,
                        activeTrackColor: AppColors.primary,
                        onChanged: (v) => setState(() => _isTalaqqiActive = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Memberikan jeda waktu otomatis bagi santri untuk menirukan pelafalan makhraj secara mandiri sebelum melangkah ke ayat berikutnya.',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11.5, height: 1.4, color: AppColors.onSurfaceVariant),
                  ),
                  if (_isTalaqqiActive) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          'Jeda Tiruan Santri: ',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                        const SizedBox(width: 8),
                        ...[3, 5, 7].map((seconds) {
                          final isSelected = _talaqqiDelaySeconds == seconds;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: InkWell(
                              onTap: () => setState(() => _talaqqiDelaySeconds = seconds),
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '$seconds Detik',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected ? Colors.white : AppColors.onSurface,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Qari Mu'tamad Dunia Picker
            Text(
              'Qari Mu\'tamad Dunia',
              style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_qaris.length, (index) {
                  final qari = _qaris[index];
                  final isSelected = _selectedQariIndex == index;

                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () {
                        setState(() => _selectedQariIndex = index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Audio dialihkan ke ${qari['name']}')),
                        );
                      },
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        width: 170,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryFixed.withAlpha(150) : AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.surfaceContainerHigh,
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: isSelected ? AppColors.primary : AppColors.surfaceContainerHigh,
                              child: Text(
                                qari['avatar']!,
                                style: GoogleFonts.syne(fontSize: 11, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : AppColors.primary),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              qari['name']!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.syne(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                            ),
                            Text(
                              qari['country']!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 18),

            // Curated Playlists
            Text(
              'Playlist Tilawah Pilihan',
              style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
            const SizedBox(height: 10),
            ..._curatedPlaylists.map((pl) {
              final color = pl['color'] as Color;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.surfaceContainerHigh),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: color.withAlpha(30),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(pl['icon'] as IconData, color: color, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pl['title'] as String,
                              style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                            ),
                            Text(
                              pl['surahs'] as String,
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.play_circle_fill, color: AppColors.primary, size: 28),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Memulai putar: ${pl['title']}')),
                        );
                      },
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 14),

            // Offline Download Storage Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.cloud_download_outlined, color: AppColors.primary, size: 24),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Download Offline 30 Juz',
                            style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                          Text(
                            '1.4 GB • Dengarkan tanpa kuota internet',
                            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      minimumSize: Size.zero,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Mengunduh paket audio tilawah 30 juz secara bertahap...')),
                      );
                    },
                    child: Text('Kelola', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700)),
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
