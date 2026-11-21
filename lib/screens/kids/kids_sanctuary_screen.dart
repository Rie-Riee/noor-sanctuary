import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import 'pin_orang_tua_dialog.dart';

class DrawnStroke {
  final List<Offset> points;
  final Color color;
  final double width;

  DrawnStroke({
    required this.points,
    required this.color,
    this.width = 10.0,
  });
}

class KidsSanctuaryScreen extends StatefulWidget {
  final VoidCallback onExitKidsMode;

  const KidsSanctuaryScreen({super.key, required this.onExitKidsMode});

  @override
  State<KidsSanctuaryScreen> createState() => _KidsSanctuaryScreenState();
}

class _KidsSanctuaryScreenState extends State<KidsSanctuaryScreen> {
  int _stars = 36;
  int _selectedLetterIndex = 0;
  int _quizScore = 0;
  int _currentQuizIndex = 0;
  int? _selectedQuizOption;
  bool _quizAnswered = false;
  bool _isDrawing = false;

  Color _selectedBrushColor = AppColors.primary;
  double _brushWidth = 10.0;
  final List<DrawnStroke> _strokes = [];

  // 8 Core Hijaiyah Letters with Pronunciation
  final List<Map<String, dynamic>> _letters = [
    {'arabic': 'أ', 'latin': 'Alif', 'sound': 'A (Tenggorokan)'},
    {'arabic': 'ب', 'latin': 'Ba', 'sound': 'Ba (Bibir Rapat)'},
    {'arabic': 'ت', 'latin': 'Ta', 'sound': 'Ta (Ujung Lidah Gigi Atas)'},
    {'arabic': 'ث', 'latin': 'Tsa', 'sound': 'Tsa (Ujung Lidah Gigi Bawah)'},
    {'arabic': 'ج', 'latin': 'Jim', 'sound': 'Ja (Tengah Lidah Langit-langit)'},
    {'arabic': 'ح', 'latin': 'Ha', 'sound': 'Ha (Tengah Tenggorokan Bersih)'},
    {'arabic': 'خ', 'latin': 'Kha', 'sound': 'Kho (Tenggorokan Atas)'},
    {'arabic': 'د', 'latin': 'Dal', 'sound': 'Da (Ujung Lidah Pangkal Gigi)'},
  ];

  // Colorful Crayon Palette for Kids
  final List<Map<String, dynamic>> _brushColors = [
    {'name': 'Emerald', 'color': Color(0xFF059669)},
    {'name': 'Sky', 'color': Color(0xFF0284C7)},
    {'name': 'Amber', 'color': Color(0xFFD97706)},
    {'name': 'Rose', 'color': Color(0xFFE11D48)},
    {'name': 'Purple', 'color': Color(0xFF7C3AED)},
    {'name': 'Navy', 'color': AppColors.primary},
  ];

  // Quiz Questions for Kids
  final List<Map<String, dynamic>> _quizQuestions = [
    {
      'question': 'Lanjutan dari ayat: "قُلْ هُوَ اللَّهُ أَحَدٌ" (QS. Al-Ikhlas: 1) adalah...',
      'options': [
        {'text': 'اللَّهُ الصَّمَدُ', 'correct': true},
        {'text': 'مَالِكِ يَوْمِ الدِّينِ', 'correct': false},
        {'text': 'إِنَّا أَعْطَيْنَاكَ', 'correct': false},
      ],
    },
    {
      'question': 'Lanjutan dari ayat: "إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ" (QS. Al-Kautsar: 1) adalah...',
      'options': [
        {'text': 'فَصَلِّ لِرَبِّكَ وَانْحَرْ', 'correct': true},
        {'text': 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ', 'correct': false},
        {'text': 'وَتَوَاصَوْا بِالصَّبْرِ', 'correct': false},
      ],
    },
    {
      'question': 'Lanjutan dari ayat: "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ" (QS. Al-Falaq: 1) adalah...',
      'options': [
        {'text': 'مِنْ شَرِّ مَا خَلَقَ', 'correct': true},
        {'text': 'مِنْ شَرِّ الْوَسْوَاسِ', 'correct': false},
        {'text': 'إِيَّاكَ نَعْبُدُ', 'correct': false},
      ],
    },
  ];

  // Shalat Daily Star Tracker for Kids
  final Map<String, bool> _prayerStars = {
    'Subuh': true,
    'Dzuhur': true,
    'Ashar': false,
    'Maghrib': false,
    'Isya': false,
  };

  void _showParentPinDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PinOrangTuaScreen(
          onSuccess: widget.onExitKidsMode,
        ),
      ),
    );
  }

  void _playLetterSound(String sound) {
    setState(() => _stars++);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pelafalan Huruf: "$sound" 🔊 (+1 Bintang Berkah ⭐)'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _togglePrayerStar(String prayer) {
    setState(() {
      final current = _prayerStars[prayer] ?? false;
      _prayerStars[prayer] = !current;
      if (!current) {
        _stars += 2;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Alhamdulillah shalat $prayer terlaksana! (+2 Bintang ⭐)'),
            backgroundColor: const Color(0xFF059669),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 850;
    final curLetter = _letters[_selectedLetterIndex];

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: (isDesktop && !Navigator.canPop(context))
          ? null
          : AppBar(
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Color(0xFFDCFCE7), shape: BoxShape.circle),
                    child: const Icon(Icons.face_rounded, color: Color(0xFF15803D), size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Kids Sanctuary Ceria',
                    style: GoogleFonts.syne(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.lock_rounded, color: AppColors.primary),
                  tooltip: 'Kunci PIN Orang Tua (1234)',
                  onPressed: _showParentPinDialog,
                ),
              ],
            ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 1240 : 640),
            child: SingleChildScrollView(
              physics: _isDrawing ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                isDesktop ? 36 : 18,
                isDesktop ? 20 : 12,
                isDesktop ? 36 : 18,
                isDesktop ? 50 : 170, // 170px clearance for mobile floating dock
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Parental Protection Notice Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed.withAlpha(120),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primary.withAlpha(60)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.shield_rounded, color: AppColors.primary, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Zona Aman Santri Cilik • Ahmad Rayyan',
                                style: GoogleFonts.syne(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                              ),
                              Text(
                                'Beralih ke Akun Bunda memerlukan PIN Orang Tua (1234)',
                                style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: _showParentPinDialog,
                          icon: const Icon(Icons.lock_rounded, size: 13),
                          label: Text('Keluar (PIN)', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 2. Stars & Gamification Header Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.tertiaryFixed,
                          AppColors.surfaceContainerLow,
                          AppColors.powderBlue.withAlpha(130),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: AppColors.hairline),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.tertiary.withAlpha(15),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Kemajuan Belajar Iqra 1',
                                  style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withAlpha(30),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text('Level 3', style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w700, color: Colors.green[800])),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '18 dari 28 Huruf Terkuasai (64%)',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.amber.shade400),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                '$_stars Bintang',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.brown.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. Hijaiyah Letter Selector Carousel
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pilih Huruf Hijaiyah',
                        style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                      ),
                      Text(
                        'Geser untuk memilih 👉',
                        style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 74,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _letters.length,
                      itemBuilder: (context, idx) {
                        final let = _letters[idx];
                        final isSel = idx == _selectedLetterIndex;
                        return Container(
                          width: 64,
                          margin: const EdgeInsets.only(right: 8),
                          child: Material(
                            color: isSel ? AppColors.primary : AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                setState(() {
                                  _selectedLetterIndex = idx;
                                  _strokes.clear();
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: isSel ? AppColors.primary : AppColors.hairline),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      let['arabic'] as String,
                                      style: AppTheme.quranArabic(
                                        fontSize: 24,
                                        color: isSel ? Colors.white : AppColors.primary,
                                      ),
                                    ),
                                    Text(
                                      let['latin'] as String,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w700,
                                        color: isSel ? Colors.white70 : AppColors.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 4. Interactive Drawing & Tracing Card (100% Mobile Touch Responsive)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(28),
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
                        // Card Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Papan Tracing: Huruf ${curLetter['latin']} (${curLetter['arabic']})',
                                    style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                                  ),
                                  Text(
                                    'Goreskan jari Anda mengikuti bentuk huruf di bawah ini',
                                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () => _playLetterSound(curLetter['sound'] as String),
                              icon: const Icon(Icons.volume_up_rounded, size: 16),
                              label: const Text('Dengar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryContainer,
                                foregroundColor: AppColors.onPrimary,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                textStyle: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Brush Tools: Color Palette & Thickness Picker
                        Row(
                          children: [
                            Text(
                              'Warna Spidol:',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: Row(
                                  children: _brushColors.map((b) {
                                    final col = b['color'] as Color;
                                    final isColorSel = _selectedBrushColor == col;
                                    return GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () => setState(() => _selectedBrushColor = col),
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 3),
                                        width: isColorSel ? 26 : 22,
                                        height: isColorSel ? 26 : 22,
                                        decoration: BoxDecoration(
                                          color: col,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isColorSel ? Colors.black : Colors.white,
                                            width: isColorSel ? 2.5 : 1.5,
                                          ),
                                          boxShadow: isColorSel ? [BoxShadow(color: col.withAlpha(120), blurRadius: 6)] : null,
                                        ),
                                        child: isColorSel ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Thickness button
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => setState(() => _brushWidth = 6.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: _brushWidth == 6.0 ? AppColors.primary : Colors.transparent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Container(width: 4, height: 4, decoration: BoxDecoration(color: _brushWidth == 6.0 ? Colors.white : AppColors.primary, shape: BoxShape.circle)),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () => setState(() => _brushWidth = 10.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: _brushWidth == 10.0 ? AppColors.primary : Colors.transparent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Container(width: 8, height: 8, decoration: BoxDecoration(color: _brushWidth == 10.0 ? Colors.white : AppColors.primary, shape: BoxShape.circle)),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () => setState(() => _brushWidth = 16.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: _brushWidth == 16.0 ? AppColors.primary : Colors.transparent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Container(width: 12, height: 12, decoration: BoxDecoration(color: _brushWidth == 16.0 ? Colors.white : AppColors.primary, shape: BoxShape.circle)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Interactive Tracing Pad Canvas
                        Container(
                          width: double.infinity,
                          height: 240,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: AppColors.hairline),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Stack(
                              children: [
                                // Big Ghost Arabic Letter Template Guide
                                Center(
                                  child: Text(
                                    curLetter['arabic'] as String,
                                    style: TextStyle(
                                      fontSize: 150,
                                      color: AppColors.outlineVariant.withAlpha(90),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                // Tracing Gesture Pad (Locks scroll while drawing!)
                                Positioned.fill(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onPanDown: (details) {
                                      setState(() {
                                        _isDrawing = true;
                                      });
                                    },
                                    onPanStart: (details) {
                                      setState(() {
                                        _isDrawing = true;
                                        _strokes.add(DrawnStroke(
                                          points: [details.localPosition],
                                          color: _selectedBrushColor,
                                          width: _brushWidth,
                                        ));
                                      });
                                    },
                                    onPanUpdate: (details) {
                                      if (_strokes.isNotEmpty) {
                                        setState(() {
                                          _strokes.last.points.add(details.localPosition);
                                        });
                                      }
                                    },
                                    onPanEnd: (details) {
                                      setState(() {
                                        _isDrawing = false;
                                      });
                                    },
                                    onPanCancel: () {
                                      setState(() {
                                        _isDrawing = false;
                                      });
                                    },
                                    onTapDown: (details) {
                                      // Support single tap dots (for dots in Ba, Ta, Tsa, Jim, etc.)
                                      setState(() {
                                        _strokes.add(DrawnStroke(
                                          points: [details.localPosition],
                                          color: _selectedBrushColor,
                                          width: _brushWidth,
                                        ));
                                      });
                                    },
                                    child: CustomPaint(
                                      painter: _TracingPainter(strokes: _strokes),
                                      size: Size.infinite,
                                    ),
                                  ),
                                ),

                                // Clear guidance badge
                                if (_strokes.isEmpty)
                                  Positioned(
                                    bottom: 12,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withAlpha(200),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'Sentuh & goreskan jari Anda di atas huruf ✍️',
                                          style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.outline),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Action Buttons: Undo, Clear, Complete Tracing
                        Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: _strokes.isEmpty
                                  ? null
                                  : () {
                                      setState(() {
                                        if (_strokes.isNotEmpty) _strokes.removeLast();
                                      });
                                    },
                              icon: const Icon(Icons.undo_rounded, size: 16),
                              label: const Text('Urung'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              onPressed: _strokes.isEmpty
                                  ? null
                                  : () {
                                      setState(() => _strokes.clear());
                                    },
                              icon: const Icon(Icons.delete_outline_rounded, size: 16),
                              label: const Text('Hapus'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                            ),
                            const Spacer(),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() => _stars += 3);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Hebat! Goresan huruf berhasil diselesaikan (+3 Bintang ⭐)'),
                                    backgroundColor: Color(0xFF059669),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                              label: Text(
                                'Selesai Tracing',
                                style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 5. Kuis Sambung Ayat Juz 'Amma (Always Interactive & Replayable!)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.blushPink.withAlpha(140),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: AppColors.hairline),
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
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                  child: const Icon(Icons.sports_esports_rounded, color: AppColors.primary, size: 18),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Kuis Sambung Ayat Ceria',
                                  style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Skor: $_quizScore Poin',
                                style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _quizQuestions[_currentQuizIndex]['question'] as String,
                          style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.onSurface),
                        ),
                        const SizedBox(height: 12),

                        // Interactive Quiz Choice Buttons
                        Column(
                          children: List.generate(
                            (_quizQuestions[_currentQuizIndex]['options'] as List).length,
                            (optIdx) {
                              final opt = (_quizQuestions[_currentQuizIndex]['options'] as List)[optIdx] as Map<String, dynamic>;
                              final isSelected = _selectedQuizOption == optIdx;
                              final isCorrect = opt['correct'] as bool;

                              Color btnBg = Colors.white;
                              Color textColor = AppColors.primary;
                              if (_quizAnswered && isSelected) {
                                btnBg = isCorrect ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2);
                                textColor = isCorrect ? const Color(0xFF15803D) : const Color(0xFFB91C1C);
                              }

                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                width: double.infinity,
                                child: Material(
                                  color: btnBg,
                                  borderRadius: BorderRadius.circular(16),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: () {
                                      setState(() {
                                        _selectedQuizOption = optIdx;
                                        _quizAnswered = true;
                                        if (isCorrect) {
                                          _quizScore += 10;
                                          _stars += 5;
                                        }
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            isCorrect
                                                ? 'Masya Allah Benar! ⭐ (+10 Poin, +5 Bintang)'
                                                : 'Belum tepat, coba lagi ya adik-adik!',
                                          ),
                                          backgroundColor: isCorrect ? const Color(0xFF059669) : AppColors.error,
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: isSelected
                                              ? (isCorrect ? const Color(0xFF15803D) : const Color(0xFFB91C1C))
                                              : AppColors.hairline,
                                          width: isSelected ? 1.5 : 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Pilihan ${optIdx + 1}',
                                            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.outline),
                                          ),
                                          Text(
                                            opt['text'] as String,
                                            style: AppTheme.quranArabic(fontSize: 18, color: textColor),
                                          ),
                                          if (_quizAnswered && isSelected)
                                            Icon(
                                              isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                                              size: 18,
                                              color: isCorrect ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
                                            )
                                          else
                                            const SizedBox(width: 18),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Quiz Next & Retry Controls
                        if (_quizAnswered) ...[
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _quizAnswered = false;
                                    _selectedQuizOption = null;
                                  });
                                },
                                icon: const Icon(Icons.refresh_rounded, size: 16),
                                label: const Text('Coba Lagi'),
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _quizAnswered = false;
                                    _selectedQuizOption = null;
                                    _currentQuizIndex = (_currentQuizIndex + 1) % _quizQuestions.length;
                                  });
                                },
                                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                                label: Text(
                                  _currentQuizIndex < _quizQuestions.length - 1 ? 'Soal Berikutnya' : 'Ulang Dari Awal',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 6. Celengan Shalat 5 Waktu Santri Cilik
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: AppColors.hairline),
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
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(color: Colors.amber.shade100, shape: BoxShape.circle),
                                  child: const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Celengan Bintang Shalat 5 Waktu',
                                  style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                                ),
                              ],
                            ),
                            Text(
                              '+2 ⭐ / Shalat',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.amber[800]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: _prayerStars.keys.map((p) {
                            final isDone = _prayerStars[p] ?? false;
                            return Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => _togglePrayerStar(p),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isDone ? Colors.amber.shade100 : AppColors.surfaceContainerLow,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: isDone ? Colors.amber.shade400 : AppColors.hairline),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        isDone ? Icons.star_rounded : Icons.star_border_rounded,
                                        size: 22,
                                        color: isDone ? Colors.amber.shade800 : AppColors.outline,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        p,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 10,
                                          fontWeight: isDone ? FontWeight.w800 : FontWeight.w600,
                                          color: isDone ? Colors.brown.shade800 : AppColors.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 7. Kisah 25 Nabi Bergambar Interaktif
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.mistySage.withAlpha(120),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: AppColors.hairline),
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
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                  child: const Icon(Icons.auto_stories_rounded, color: AppColors.primary, size: 18),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Kisah Teladan 25 Nabi',
                                  style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                              child: Text('3 Kisah Hari Ini', style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildStoryTile(
                          title: 'Nabi Yunus AS & Ikan Paus',
                          subtitle: 'Doa dalam kegelapan: La ilaha illa Anta subhanaka...',
                          icon: Icons.water_rounded,
                          onPlay: () {
                            setState(() => _stars++);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Memutar audio kisah Nabi Yunus AS 🔊 (+1 Bintang ⭐)')),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        _buildStoryTile(
                          title: 'Nabi Nuh AS & Bahtera Raksasa',
                          subtitle: 'Kisah ketaatan dan kesabaran membangun kapal besar',
                          icon: Icons.directions_boat_rounded,
                          onPlay: () {
                            setState(() => _stars++);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Memutar audio kisah Nabi Nuh AS 🔊 (+1 Bintang ⭐)')),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        _buildStoryTile(
                          title: 'Nabi Ibrahim AS & Api yang Dingin',
                          subtitle: 'Mukjizat api yang menjadi dingin dan menyelamatkan',
                          icon: Icons.local_fire_department_rounded,
                          onPlay: () {
                            setState(() => _stars++);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Memutar audio kisah Nabi Ibrahim AS 🔊 (+1 Bintang ⭐)')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoryTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onPlay,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryFixed.withAlpha(100),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.syne(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.play_circle_fill, color: AppColors.primary, size: 28),
            onPressed: onPlay,
          ),
        ],
      ),
    );
  }
}

class _TracingPainter extends CustomPainter {
  final List<DrawnStroke> strokes;

  _TracingPainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      final paint = Paint()
        ..color = stroke.color
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = stroke.width;

      if (stroke.points.isEmpty) continue;

      if (stroke.points.length == 1) {
        // Draw dot for single tap
        canvas.drawCircle(stroke.points.first, stroke.width / 2, paint);
      } else {
        for (int i = 0; i < stroke.points.length - 1; i++) {
          canvas.drawLine(stroke.points[i], stroke.points[i + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TracingPainter oldDelegate) => true;
}
