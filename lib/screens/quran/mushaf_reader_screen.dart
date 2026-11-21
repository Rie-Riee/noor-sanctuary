import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../data/quran_dataset.dart';
import 'font_rasm_settings_sheet.dart';
import 'ai_tartil_evaluation_screen.dart';
import 'tafsir_tematik_screen.dart';
import 'murottal_audio_sanctuary_screen.dart';

class MushafReaderScreen extends StatefulWidget {
  final SurahModel surah;
  final int initialAyah;
  final bool initialMushafKontinu;

  const MushafReaderScreen({
    super.key,
    required this.surah,
    this.initialAyah = 1,
    this.initialMushafKontinu = false,
  });

  @override
  State<MushafReaderScreen> createState() => _MushafReaderScreenState();
}

class _MushafReaderScreenState extends State<MushafReaderScreen> {
  late bool _isMushafKontinu;
  double _fontSize = 26.0;
  String _fontFamily = 'Uthmanic Hafs';
  String _rasm = "Rasm 'Utsmani Madinah";
  bool _coloredTajwid = true;

  final Set<int> _bookmarkedAyahs = {1};
  int _activePlayingAyah = 1;
  bool _isPlaying = true;
  bool _talaqqiMode = true;

  @override
  void initState() {
    super.initState();
    _isMushafKontinu = widget.initialMushafKontinu;
  }

  void _openFontSettings() {
    FontRasmSettingsSheet.show(
      context,
      currentFontSize: _fontSize,
      currentFontFamily: _fontFamily,
      currentRasm: _rasm,
      coloredTajwid: _coloredTajwid,
      onFontSizeChanged: (v) => setState(() => _fontSize = v),
      onFontFamilyChanged: (v) => setState(() => _fontFamily = v),
      onRasmChanged: (v) => setState(() => _rasm = v),
      onTajwidToggled: (v) => setState(() => _coloredTajwid = v),
    );
  }

  @override
  Widget build(BuildContext context) {
    final surah = widget.surah;

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
          'QS. ${surah.name}',
          style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book, color: AppColors.secondary, size: 20),
            tooltip: 'Tafsir Tematik',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TafsirTematikScreen(surah: surah)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.text_fields, color: AppColors.primary, size: 22),
            tooltip: 'Preferensi Font & Rasm',
            onPressed: _openFontSettings,
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
      body: Stack(
        children: [
          // Main Scrollable Area
          Column(
            children: [
              // Top Information Banner Strip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  border: Border(bottom: BorderSide(color: AppColors.surfaceContainerHigh)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.primaryFixed,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${surah.number}',
                            style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Juz ${surah.juz} • Hal ${surah.page}',
                              style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                            ),
                            Text(
                              '${surah.type} • ${surah.ayahsCount} Ayat',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (_fontSize > 20) setState(() => _fontSize -= 2);
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('A-', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.secondary)),
                          ),
                        ),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () {
                            if (_fontSize < 36) setState(() => _fontSize += 2);
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('A+', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryFixed,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Hafsh',
                            style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // View Mode Segmented Bar (Per Ayat & Tadabbur vs Mushaf Kontinu)
              Container(
                margin: const EdgeInsets.fromLTRB(18, 12, 18, 8),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _isMushafKontinu = false),
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: !_isMushafKontinu ? AppColors.surfaceContainerLowest : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: !_isMushafKontinu
                                ? [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 4, offset: const Offset(0, 2))]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.format_list_bulleted,
                                size: 16,
                                color: !_isMushafKontinu ? AppColors.primary : AppColors.secondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Per Ayat & Tadabbur',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: !_isMushafKontinu ? FontWeight.w700 : FontWeight.w500,
                                  color: !_isMushafKontinu ? AppColors.primary : AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _isMushafKontinu = true),
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: _isMushafKontinu ? AppColors.surfaceContainerLowest : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: _isMushafKontinu
                                ? [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 4, offset: const Offset(0, 2))]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.auto_stories,
                                size: 16,
                                color: _isMushafKontinu ? AppColors.primary : AppColors.secondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Mushaf Kontinu',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: _isMushafKontinu ? FontWeight.w700 : FontWeight.w500,
                                  color: _isMushafKontinu ? AppColors.primary : AppColors.secondary,
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

              // Content: View 1 or View 2
              Expanded(
                child: _isMushafKontinu
                    ? _buildMushafKontinuView(surah)
                    : _buildPerAyatTadabburView(surah),
              ),
            ],
          ),

          // Floating Bottom Audio Player (Mockup 2 & 7)
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: _buildFloatingAudioPlayer(surah),
          ),
        ],
      ),
    );
  }

  // View 1: Per Ayat & Tadabbur (Mockup 2)
  Widget _buildPerAyatTadabburView(SurahModel surah) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 140),
      children: [
        // Mode indicator and jump links
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'MODE TADABBUR AKTIF',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Loncat ke: ',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                ),
                ...[1, 2, 3, 4, 5].map((ayahNo) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: InkWell(
                      onTap: () {
                        setState(() => _activePlayingAyah = ayahNo);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Menuju ke Ayat $ayahNo')),
                        );
                      },
                      child: Text(
                        '$ayahNo',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: _activePlayingAyah == ayahNo ? FontWeight.w700 : FontWeight.w500,
                          color: _activePlayingAyah == ayahNo ? AppColors.primary : AppColors.secondary,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Sunnah Hari Jumat / Bismillah Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF38324F), Color(0xFF554B73)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(40),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.share, size: 12, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      'SUNNAH HARI JUMAT',
                      style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                style: AppTheme.quranArabic(fontSize: 26).copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang',
                style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: Colors.white70, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Verse Cards
        ...surah.ayahs.map((ayah) {
          final isPlaying = _activePlayingAyah == ayah.number;
          final isBookmarked = _bookmarkedAyahs.contains(ayah.number);

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isPlaying ? AppColors.primary : AppColors.surfaceContainerHigh,
                width: isPlaying ? 1.5 : 1.0,
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Arabic text with golden circle ayah counter
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFD97706), width: 1.5),
                        color: const Color(0xFFFFFBEB),
                      ),
                      child: Text(
                        '${ayah.number}',
                        style: GoogleFonts.syne(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFFB45309)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        ayah.arabic,
                        textAlign: TextAlign.right,
                        style: AppTheme.quranArabic(fontSize: _fontSize).copyWith(height: 1.8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Kemenag translation box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TERJEMAHAN KEMENAG RI • Ayat ${ayah.number}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '"${ayah.translation}"',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12.5, height: 1.5, color: AppColors.onSurface),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Tadabbur box
                if (ayah.tadabburText != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFBBF7D0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.spa_outlined, color: Color(0xFF16A34A), size: 16),
                            const SizedBox(width: 6),
                            Text(
                              ayah.tadabburTitle ?? 'Tadabbur Kalam',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF15803D),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ayah.tadabburText!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            height: 1.45,
                            color: const Color(0xFF166534),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Action buttons: Dengar, AI Mic, Bookmark, Share, Tafsir
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isPlaying ? AppColors.primary : AppColors.surfaceContainerHigh,
                            foregroundColor: isPlaying ? Colors.white : AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 16),
                          label: Text(
                            'Dengar',
                            style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                          ),
                          onPressed: () {
                            setState(() {
                              _activePlayingAyah = ayah.number;
                              _isPlaying = !_isPlaying;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE0E7FF),
                            foregroundColor: const Color(0xFF4338CA),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.mic, size: 16),
                          label: Text(
                            'AI Mic',
                            style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AiTartilEvaluationScreen(
                                  surah: surah,
                                  ayahNumber: ayah.number,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.menu_book, color: AppColors.secondary, size: 18),
                          tooltip: 'Tafsir Ayat',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TafsirTematikScreen(surah: surah, startingAyah: ayah.number),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                            color: isBookmarked ? AppColors.primary : AppColors.secondary,
                            size: 18,
                          ),
                          tooltip: 'Simpan Bookmark',
                          onPressed: () {
                            setState(() {
                              if (isBookmarked) {
                                _bookmarkedAyahs.remove(ayah.number);
                              } else {
                                _bookmarkedAyahs.add(ayah.number);
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.share_outlined, color: AppColors.secondary, size: 18),
                          tooltip: 'Bagikan Ayat',
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Ayat ${ayah.number} disalin ke papan klip.')),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // View 2: Mushaf Kontinu 15 Baris (Mockup 7)
  Widget _buildMushafKontinuView(SurahModel surah) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 140),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFDFBF7),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFD4AF37), width: 3),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD4AF37).withAlpha(40),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // Ornate Surah Header Plate
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9E6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${surah.ayahsCount} Ayat',
                    style: GoogleFonts.syne(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF8C6B1C)),
                  ),
                  Text(
                    'سورة ${surah.arabic}',
                    style: AppTheme.quranArabic(fontSize: 22).copyWith(color: const Color(0xFF8C6B1C), fontWeight: FontWeight.bold),
                  ),
                  Text(
                    surah.type,
                    style: GoogleFonts.syne(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF8C6B1C)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Bismillah Calligraphy Box
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFDF5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                style: AppTheme.quranArabic(fontSize: 26).copyWith(color: const Color(0xFF2C2416)),
              ),
            ),
            const SizedBox(height: 16),

            // Continuous 15-line Uthmani Text
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: RichText(
                textAlign: TextAlign.justify,
                textDirection: TextDirection.rtl,
                text: TextSpan(
                  style: AppTheme.quranArabic(fontSize: _fontSize).copyWith(
                    color: const Color(0xFF1F1D1A),
                    height: 2.2,
                  ),
                  children: surah.ayahs.expand((ayah) {
                    return [
                      TextSpan(text: '${ayah.arabic} '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
                            color: const Color(0xFFFFFDF0),
                          ),
                          child: Text(
                            '${ayah.number}',
                            style: GoogleFonts.syne(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF8C6B1C)),
                          ),
                        ),
                      ),
                      const TextSpan(text: ' '),
                    ];
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Footer mushaf page bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9E6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD4AF37).withAlpha(100)),
              ),
              child: Text(
                'جزء ${surah.juz} • الحزب ٥٩ • صفحة ${surah.page}',
                style: GoogleFonts.syne(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF8C6B1C)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Floating Mini Audio Player (Mockup 2 & 7)
  Widget _buildFloatingAudioPlayer(SurahModel surah) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withAlpha(50)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.graphic_eq, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Syaikh Mishary Rasyid Al-Afasy',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                      Text(
                        'Surah ${surah.name} [78: 1-5]',
                        style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.secondary),
                      ),
                    ],
                  ),
                ],
              ),
              // Visualizer bars
              Row(
                children: List.generate(4, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    width: 3,
                    height: (index % 3 + 2) * 4.0 + (_isPlaying ? 6 : 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Audio Slider
          Row(
            children: [
              Text('01:24', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary)),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                  ),
                  child: Slider(
                    value: 0.32,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.surfaceContainerHigh,
                    onChanged: (v) {},
                  ),
                ),
              ),
              Text('04:30', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary)),
            ],
          ),

          // Player Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  setState(() => _talaqqiMode = !_talaqqiMode);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(_talaqqiMode ? 'Mode Talaqqi Khusyu\' Aktif' : 'Mode Talaqqi Nonaktif')),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _talaqqiMode ? AppColors.primaryFixed : AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.headphones, size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        'Talaqqi',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.repeat, size: 18, color: AppColors.secondary),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled, size: 36, color: AppColors.primary),
                    onPressed: () => setState(() => _isPlaying = !_isPlaying),
                  ),
                  IconButton(
                    icon: const Icon(Icons.open_in_new, size: 18, color: AppColors.secondary),
                    tooltip: 'Buka Audio Sanctuary',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MurottalAudioSanctuaryScreen()),
                      );
                    },
                  ),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.mic, size: 14),
                label: Text(
                  'AI Mic Koreksi',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AiTartilEvaluationScreen(surah: surah, ayahNumber: _activePlayingAyah),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
