import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class RuteMasjidScreen extends StatefulWidget {
  const RuteMasjidScreen({super.key});

  @override
  State<RuteMasjidScreen> createState() => _RuteMasjidScreenState();
}

class _RuteMasjidScreenState extends State<RuteMasjidScreen> {
  int _selectedMosqueIndex = 0;
  bool _isNavigating = false;

  final List<Map<String, dynamic>> _mosques = [
    {
      'name': 'Masjid Raya Al-Ikhlas',
      'distance': '350 m',
      'walkTime': '4 Menit',
      'capacity': '2.500 Jamaah',
      'qibla': '295° NW',
      'facilities': ['Tempat Wudhu Luas', 'Saf Ber-AC', 'Area Muslimah Ramah Anak', 'Parkir Luas'],
      'isClosest': true,
    },
    {
      'name': 'Masjid Jami\' As-Salam',
      'distance': '650 m',
      'walkTime': '8 Menit',
      'capacity': '1.200 Jamaah',
      'qibla': '295° NW',
      'facilities': ['Tempat Wudhu Bersih', 'Kajian Ba\'da Dzuhur', 'Kantin Halal'],
      'isClosest': false,
    },
    {
      'name': 'Musholla An-Nur',
      'distance': '900 m',
      'walkTime': '11 Menit',
      'capacity': '300 Jamaah',
      'qibla': '295° NW',
      'facilities': ['Air Dingin & Hangat', 'Mukena Bersih'],
      'isClosest': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final selected = _mosques[_selectedMosqueIndex];

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Panduan Rute Masjid & Kiblat',
          style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // GPS Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.hairline),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.near_me, color: AppColors.primary, size: 20),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'JAKARTA PUSAT, DKI JAKARTA',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                                ),
                                Text(
                                  'Radius 1.5 km • Kompas Sinkron',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.tertiaryFixed,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'GPS Akurat (±3m)',
                            style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.onTertiaryFixed),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Stylized Map Graphics Card
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.hairline),
                    ),
                    child: Stack(
                      children: [
                        // Stylized Map Background Pattern
                        CustomPaint(
                          size: const Size(double.infinity, 200),
                          painter: _MapCanvasPainter(),
                        ),

                        // User Pin
                        Positioned(
                          bottom: 30,
                          left: 40,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: AppColors.secondary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.person_pin_circle, color: Colors.white, size: 20),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 4)],
                                ),
                                child: Text(
                                  'Posisi Anda',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.secondary),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Mosque Pin
                        Positioned(
                          top: 25,
                          right: 50,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.mosque, color: Colors.white, size: 22),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 4)],
                                ),
                                child: Text(
                                  selected['name'],
                                  style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Bottom trail info bar
                        Positioned(
                          bottom: 10,
                          left: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(230),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.park, size: 16, color: AppColors.tertiary),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Rute Ramah Pejalan Kaki & Beratap',
                                      style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.onSurface),
                                    ),
                                  ],
                                ),
                                Text(
                                  selected['distance'],
                                  style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Selected Mosque Details Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.hairline),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(10),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
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
                              child: Text(
                                selected['name'],
                                style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.powderBlue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                selected['qibla'],
                                style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.directions_walk, size: 16, color: AppColors.secondary),
                            const SizedBox(width: 4),
                            Text(
                              '${selected['distance']} • ${selected['walkTime']} berjalan kaki',
                              style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.secondary),
                            ),
                            const SizedBox(width: 12),
                            const Icon(Icons.people_outline, size: 16, color: AppColors.secondary),
                            const SizedBox(width: 4),
                            Text(
                              selected['capacity'],
                              style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.secondary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Facility Pills
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: (selected['facilities'] as List<String>).map((fac) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                fac,
                                style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),

                        // Navigation Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() => _isNavigating = !_isNavigating);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(_isNavigating
                                      ? 'Navigasi suara menuju ${selected['name']} aktif. Belok kiri 100m lagi.'
                                      : 'Navigasi dihentikan.'),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isNavigating ? AppColors.tertiary : AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(_isNavigating ? Icons.navigation : Icons.directions, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  _isNavigating ? 'Navigasi Berjalan (Ketuk untuk Selesai)' : 'Mulai Petunjuk Arah Berjalan',
                                  style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // List of Other Mosques
                  Text(
                    'Pilihan Masjid Terdekat Lainnya',
                    style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.onSurface),
                  ),
                  const SizedBox(height: 10),

                  ...List.generate(_mosques.length, (idx) {
                    final m = _mosques[idx];
                    final isCurrent = idx == _selectedMosqueIndex;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedMosqueIndex = idx),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isCurrent ? AppColors.powderBlue.withAlpha(120) : AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: isCurrent ? AppColors.primary : AppColors.hairline),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isCurrent ? AppColors.primary : AppColors.surfaceContainerLow,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.mosque, color: isCurrent ? Colors.white : AppColors.primary, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    m['name'],
                                    style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                                  ),
                                  Text(
                                    '${m['distance']} • ${m['walkTime']}',
                                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              isCurrent ? Icons.check_circle : Icons.chevron_right,
                              color: isCurrent ? AppColors.primary : AppColors.outlineVariant,
                            ),
                          ],
                        ),
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

class _MapCanvasPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = AppColors.surfaceContainerHighest.withAlpha(160)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final path1 = Path()
      ..moveTo(0, size.height * 0.4)
      ..cubicTo(size.width * 0.3, size.height * 0.4, size.width * 0.4, size.height * 0.8, size.width, size.height * 0.6);
    canvas.drawPath(path1, roadPaint);

    final path2 = Path()
      ..moveTo(size.width * 0.25, 0)
      ..lineTo(size.width * 0.25, size.height);
    canvas.drawPath(path2, roadPaint);

    final trailPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final walkingTrail = Path()
      ..moveTo(size.width * 0.25, size.height * 0.7)
      ..cubicTo(size.width * 0.4, size.height * 0.65, size.width * 0.6, size.height * 0.35, size.width * 0.8, size.height * 0.3);
    canvas.drawPath(walkingTrail, trailPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
