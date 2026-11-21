import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class MurottalPemanasanScreen extends StatefulWidget {
  const MurottalPemanasanScreen({super.key});

  @override
  State<MurottalPemanasanScreen> createState() => _MurottalPemanasanScreenState();
}

class _MurottalPemanasanScreenState extends State<MurottalPemanasanScreen> {
  bool _isPlaying = true;
  double _progress = 0.26;
  bool _isFavorite = false;
  String _activeAmbience = 'Hening Alam';

  final List<String> _ambienceOptions = [
    'Hening Alam',
    'Hujan Gerimis Madinah',
    'Angin Padang Pasir',
    'Burung Berkicau Fajar',
  ];

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
          'Murottal Pemanasan Sholat',
          style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.pink : AppColors.secondary,
            ),
            onPressed: () {
              setState(() => _isFavorite = !_isFavorite);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(_isFavorite ? 'Disimpan ke Murottal Favorit' : 'Dihapus dari Favorit')),
              );
            },
          ),
        ],
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
                  // Countdown Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.hairline),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
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
                                'Persiapan Menuju Dzuhur',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSecondaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '11 Menit 40 Detik',
                              style: GoogleFonts.syne(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                            Text(
                              'Adzan 12:02 WIB',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Lantunan ayat penyejuk kalbu untuk menenangkan pikiran dari hiruk-pikuk duniawi sebelum menghadap Ilahi.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Murottal Player Sanctuary Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: AppColors.hairline),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(12),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Qari Info
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: AppColors.primaryContainer,
                              child: const Icon(Icons.person, color: Colors.white, size: 28),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryFixed,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          'Sedang Diputar',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.onPrimaryFixed,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Bayati Khusyu\'',
                                        style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'QS. Ar-Rahman [55: 1-27]',
                                    style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                                  ),
                                  Text(
                                    'Syaikh Mishary Rashid Al-Afasy',
                                    style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.onSurfaceVariant),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Animated Waveform Visualizer
                        Container(
                          height: 60,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(24, (idx) {
                              final heights = [12, 24, 38, 48, 30, 18, 42, 28, 14, 36, 48, 26, 18, 32, 44, 20, 12, 38, 46, 28, 16, 34, 22, 14];
                              final h = _isPlaying ? heights[idx % heights.length].toDouble() : 10.0;
                              return AnimatedContainer(
                                duration: Duration(milliseconds: 200 + (idx * 30)),
                                width: 4,
                                height: h,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withAlpha(_isPlaying ? 200 : 80),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Scrubber Slider
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: AppColors.surfaceContainerHigh,
                            thumbColor: AppColors.primary,
                          ),
                          child: Slider(
                            value: _progress,
                            onChanged: (v) {
                              setState(() => _progress = v);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '03:45',
                                style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.secondary),
                              ),
                              Row(
                                children: [
                                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Streaming HD 320kbps',
                                    style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Text(
                                '14:20',
                                style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.secondary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Playback Controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.repeat, color: AppColors.secondary),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.replay_10, size: 28, color: AppColors.primary),
                              onPressed: () {
                                setState(() => _progress = (_progress - 0.05).clamp(0.0, 1.0));
                              },
                            ),
                            // Main Play/Pause Button
                            GestureDetector(
                              onTap: () {
                                setState(() => _isPlaying = !_isPlaying);
                              },
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withAlpha(40),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.forward_10, size: 28, color: AppColors.primary),
                              onPressed: () {
                                setState(() => _progress = (_progress + 0.05).clamp(0.0, 1.0));
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.spa_outlined, color: AppColors.secondary),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Background Ambience selector
                  Text(
                    'Lapisan Suara Relaksasi (Ambience)',
                    style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.onSurface),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _ambienceOptions.map((amb) {
                      final isSelected = amb == _activeAmbience;
                      return ChoiceChip(
                        selected: isSelected,
                        label: Text(amb),
                        labelStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppColors.onPrimary : AppColors.primary,
                        ),
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surfaceContainerLow,
                        showCheckmark: false,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        onSelected: (v) {
                          if (v) setState(() => _activeAmbience = amb);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
