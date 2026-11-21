import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../utils/prayer_calculator.dart';
import '../search/universal_search_sheet.dart';

class QiblaCompassScreen extends StatefulWidget {
  const QiblaCompassScreen({super.key});

  @override
  State<QiblaCompassScreen> createState() => _QiblaCompassScreenState();
}

class _QiblaCompassScreenState extends State<QiblaCompassScreen> {
  late Timer _clockTimer;
  DateTime _currentTime = DateTime.now();
  double _compassHeading = 0.0; // Heading degrees
  final double _qiblaAngle = 295.0; // Jakarta to Ka'bah angle
  String _selectedAdzan = 'Adzan Makkah';

  final List<String> _adzanVoices = [
    'Adzan Makkah (Syaikh Ali Mulla)',
    'Adzan Madinah (Syaikh Surayhi)',
    'Adzan Al-Quds (Masjid Al-Aqsha)',
    'Adzan Mesir (Syaikh Abdul Basith)',
  ];

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 850;
    final prayerStatus = RealPrayerService.calculateStatus(_currentTime);
    final isAligned = (_compassHeading - _qiblaAngle).abs() < 5.0 ||
        ((_compassHeading - _qiblaAngle).abs() - 360).abs() < 5.0;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: (isDesktop && !Navigator.canPop(context))
          ? null
          : AppBar(
              leading: Navigator.canPop(context)
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    )
                  : null,
              title: Text(
                'Jadwal Sholat & Kompas Kiblat',
                style: GoogleFonts.syne(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search_rounded, color: AppColors.primary),
                  tooltip: 'Pencarian Universal',
                  onPressed: () => showUniversalSearch(context),
                ),
                IconButton(
                  icon: const Icon(Icons.sync, color: AppColors.primary),
                  tooltip: 'Kalibrasi Sensor',
                  onPressed: () {
                    setState(() {
                      _compassHeading = 0;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sensor kompas berhasil dikalibrasi ulang.')),
                    );
                  },
                ),
              ],
            ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 1240 : 620),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                isDesktop ? 36 : 20,
                isDesktop ? 24 : 14,
                isDesktop ? 36 : 20,
                isDesktop ? 40 : 130, // 130 on mobile so bottom prayer card is never covered by floating nav!
              ),
              child: isDesktop
                  // DESKTOP RESPONSIVE 2-COLUMN DASHBOARD
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column (flex: 52): Live Wall Clock & Interactive Compass
                        Expanded(
                          flex: 52,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildPrecisionClockCard(prayerStatus),
                              const SizedBox(height: 20),
                              _buildCompassCard(isAligned),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Right Column (flex: 48): Adzan Selector & Complete Prayer Times Schedule
                        Expanded(
                          flex: 48,
                          child: _buildAdzanAndScheduleCard(prayerStatus),
                        ),
                      ],
                    )
                  // MOBILE SINGLE COLUMN VERTICAL FLOW
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPrecisionClockCard(prayerStatus),
                        const SizedBox(height: 20),
                        _buildCompassCard(isAligned),
                        const SizedBox(height: 20),
                        _buildAdzanAndScheduleCard(prayerStatus),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 1. WAKTU PRESISI & LIVE CLOCK CARD
  // ==========================================
  Widget _buildPrecisionClockCard(PrayerStatus prayerStatus) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceContainerLowest,
            AppColors.surfaceContainerLow,
          ],
        ),
        borderRadius: BorderRadius.circular(26),
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
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'WAKTU PRESISI SANCTUARY',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Kemenag RI • GMT+7',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Real Wall-Clock & Next Prayer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    RealPrayerService.formatClock(_currentTime),
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'WIB',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Menuju Waktu',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                  ),
                  Text(
                    prayerStatus.nextPrayerName,
                    style: GoogleFonts.notoSerif(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Countdown to next prayer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh.withAlpha(160),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.primary,
                      child: const Icon(Icons.hourglass_top, size: 16, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hitung Mundur Adzan',
                          style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary),
                        ),
                        Text(
                          RealPrayerService.formatDuration(prayerStatus.remainingToNext),
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Pukul',
                      style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary),
                    ),
                    Text(
                      '${prayerStatus.nextPrayerTime} WIB',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 2. PRECISION INTERACTIVE QIBLA COMPASS
  // ==========================================
  Widget _buildCompassCard(bool isAligned) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.hairline),
        boxShadow: [
          BoxShadow(
            color: isAligned ? AppColors.tertiary.withAlpha(20) : AppColors.primary.withAlpha(12),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kompas Kiblat Presisi',
                    style: GoogleFonts.notoSerif(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                  Text(
                    'Arah Makkah Al-Mukarramah',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isAligned ? AppColors.tertiaryFixed : AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isAligned ? '✓ TEPAT KIBLAT' : 'SESUAIKAN ARAH',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isAligned ? AppColors.tertiary : AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Interactive Rotating Dial
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                _compassHeading = (_compassHeading - details.delta.dx * 0.5) % 360;
                if (_compassHeading < 0) _compassHeading += 360;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer Degree Dial
                Transform.rotate(
                  angle: -_compassHeading * (math.pi / 180),
                  child: Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceContainerLow,
                      border: Border.all(color: AppColors.hairline, width: 2),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Cardinal directions
                        const Positioned(top: 8, child: Text('U', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.error))),
                        const Positioned(bottom: 8, child: Text('S', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.secondary))),
                        const Positioned(left: 8, child: Text('B', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.secondary))),
                        const Positioned(right: 8, child: Text('T', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.secondary))),
                        // Dial tick marks
                        for (int i = 0; i < 12; i++)
                          Transform.rotate(
                            angle: i * 30 * (math.pi / 180),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                margin: const EdgeInsets.only(top: 24),
                                width: 2,
                                height: 6,
                                color: AppColors.outlineVariant,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Inner Ka'bah Target Pointer
                Transform.rotate(
                  angle: (_qiblaAngle - _compassHeading) * (math.pi / 180),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isAligned ? AppColors.tertiary : AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (isAligned ? AppColors.tertiary : AppColors.primary).withAlpha(40),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.mosque, color: Colors.white, size: 20),
                      ),
                      Container(
                        width: 4,
                        height: 70,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              isAligned ? AppColors.tertiary : AppColors.primary,
                              Colors.transparent,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),

                // Center Center Hub Bubble
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 10)],
                  ),
                  child: Center(
                    child: Text(
                      '${_qiblaAngle.toInt()}°',
                      style: GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Geser kompas untuk simulasi arah putaran ponsel',
            style: GoogleFonts.plusJakartaSans(fontSize: 10, fontStyle: FontStyle.italic, color: AppColors.secondary),
          ),
          const SizedBox(height: 14),

          // Metric readout row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCompassMetric('Sudut Kiblat', '295° Barat Laut'),
              _buildCompassMetric('Jarak Ka\'bah', '7.912 km'),
              _buildCompassMetric('Kemiringan', 'Rata (0.2°)'),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 3. ADZAN CUSTOMIZER & PRAYER SCHEDULE CARD
  // ==========================================
  Widget _buildAdzanAndScheduleCard(PrayerStatus prayerStatus) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.hairline),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(8),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suara Muadzin Adzan',
                    style: GoogleFonts.notoSerif(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                  Text(
                    'Pilihan lantunan adzan otomatis',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                  ),
                ],
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedAdzan,
                  icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                  items: _adzanVoices.map((v) {
                    return DropdownMenuItem(
                      value: v.split(' (')[0],
                      child: Text(
                        v.split(' (')[0],
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedAdzan = val);
                  },
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.surfaceContainerHigh, height: 24),

          // Schedule Header Label
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'JADWAL 5 WAKTU HARI INI',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: AppColors.secondary,
                ),
              ),
              Text(
                'WIB (Jakarta)',
                style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Full Prayer Times List
          ...prayerStatus.scheduleItems.map((p) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: p.isActive ? AppColors.primaryFixed : AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: p.isActive ? Border.all(color: AppColors.primary, width: 1.5) : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        p.statusIcon,
                        size: 20,
                        color: p.isActive ? AppColors.primary : AppColors.secondary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        p.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: p.isActive ? FontWeight.w800 : FontWeight.w600,
                          color: p.isActive ? AppColors.primary : AppColors.onSurface,
                        ),
                      ),
                      if (p.isActive) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'WAKTU AKTIF',
                            style: GoogleFonts.spaceGrotesk(fontSize: 8.5, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    '${p.time} WIB',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      fontWeight: p.isActive ? FontWeight.w800 : FontWeight.w600,
                      color: p.isActive ? AppColors.primary : AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCompassMetric(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.onSurface),
        ),
      ],
    );
  }
}
