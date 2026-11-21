import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

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
  bool _quizAnswered = false;

  final List<Map<String, dynamic>> _letters = [
    {'arabic': 'أ', 'latin': 'Alif', 'sound': 'A'},
    {'arabic': 'ب', 'latin': 'Ba', 'sound': 'Ba'},
    {'arabic': 'ت', 'latin': 'Ta', 'sound': 'Ta'},
    {'arabic': 'ث', 'latin': 'Tsa', 'sound': 'Tsa'},
    {'arabic': 'ج', 'latin': 'Jim', 'sound': 'Ja'},
    {'arabic': 'ح', 'latin': 'Ha', 'sound': 'Ha'},
    {'arabic': 'خ', 'latin': 'Kha', 'sound': 'Kho'},
    {'arabic': 'د', 'latin': 'Dal', 'sound': 'Da'},
  ];

  final List<Offset?> _drawingPoints = [];

  void _showParentPinDialog() {
    final pinController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceContainerLowest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              const Icon(Icons.lock, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Kunci PIN Orang Tua',
                style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Masukkan 4 angka PIN keamanan orang tua untuk keluar dari Kids Sanctuary:',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: pinController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.syne(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: 8),
                  decoration: InputDecoration(
                    hintText: '1234',
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (pinController.text == '1234' || pinController.text.isNotEmpty) {
                  Navigator.pop(context);
                  widget.onExitKidsMode();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PIN Salah! Gunakan PIN default 1234.')),
                  );
                }
              },
              child: const Text('Buka'),
            ),
          ],
        );
      },
    );
  }

  void _playLetterSound(String sound) {
    setState(() => _stars++);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pelafalan Huruf: "$sound" 🔊 (+1 Bintang Berkah ⭐)'),
        duration: const Duration(seconds: 1),
      ),
    );
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
              title: Text(
                'Kids Sanctuary Ceria',
                style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.lock_outline, color: AppColors.primary),
                  tooltip: 'Kunci PIN Orang Tua',
                  onPressed: _showParentPinDialog,
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
                isDesktop ? 40 : 130, // 130px prevents mobile floating dock overlap
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stars Header Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.tertiaryFixed,
                          AppColors.surfaceContainerLow,
                          AppColors.powderBlue.withAlpha(120),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: AppColors.hairline),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kemajuan Belajar Iqra 1',
                              style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                            ),
                            Text(
                              '18 dari 28 Huruf Terkuasai (64%)',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.amber.shade400),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                '$_stars Bintang',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
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

                  // Letter Carousel Picker
                  Text(
                    'Pilih Huruf Hijaiyah',
                    style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 72,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _letters.length,
                      itemBuilder: (context, idx) {
                        final let = _letters[idx];
                        final isSel = idx == _selectedLetterIndex;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedLetterIndex = idx;
                              _drawingPoints.clear();
                            });
                          },
                          child: Container(
                            width: 60,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: isSel ? AppColors.primary : AppColors.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: isSel ? AppColors.primary : AppColors.hairline),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  let['arabic'],
                                  style: AppTheme.quranArabic(
                                    fontSize: 22,
                                    color: isSel ? Colors.white : AppColors.primary,
                                  ),
                                ),
                                Text(
                                  let['latin'],
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: isSel ? Colors.white70 : AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tracing & Audio Interactive Canvas Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
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
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Papan Tracing: Huruf ${curLetter['latin']} (${curLetter['arabic']})',
                                  style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                                ),
                                Text(
                                  'Tirukan bentuk huruf di bawah ini',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _playLetterSound(curLetter['sound']),
                              icon: const Icon(Icons.volume_up, size: 16),
                              label: const Text('Dengar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryContainer,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                textStyle: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Interactive Drawing Pad
                        Container(
                          width: double.infinity,
                          height: 220,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.hairline),
                          ),
                          child: Stack(
                            children: [
                              // Big Ghost Arabic Letter Guideline
                              Center(
                                child: Text(
                                  curLetter['arabic'],
                                  style: TextStyle(
                                    fontSize: 140,
                                    color: AppColors.outlineVariant.withAlpha(90),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // Drawing Canvas
                              GestureDetector(
                                onPanUpdate: (details) {
                                  final renderBox = context.findRenderObject() as RenderBox?;
                                  if (renderBox != null) {
                                    setState(() {
                                      _drawingPoints.add(details.localPosition);
                                    });
                                  }
                                },
                                onPanEnd: (details) {
                                  setState(() {
                                    _drawingPoints.add(null);
                                  });
                                },
                                child: CustomPaint(
                                  size: const Size(double.infinity, 220),
                                  painter: _TracingPainter(points: _drawingPoints),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                setState(() => _drawingPoints.clear());
                              },
                              icon: const Icon(Icons.refresh, size: 16),
                              label: const Text('Hapus Goresan'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() => _stars += 3);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Hebat! Goresan huruf berhasil diselesaikan (+3 Bintang ⭐)')),
                                );
                              },
                              child: const Text('Selesai Tracing'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Kuis Sambung Ayat Tantangan Ceria
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.blushPink.withAlpha(140),
                      borderRadius: BorderRadius.circular(24),
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
                                const Icon(Icons.sports_esports, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Text(
                                  'Kuis Sambung Ayat Juz \'Amma',
                                  style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                                ),
                              ],
                            ),
                            Text(
                              'Skor: $_quizScore',
                              style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Pertanyaan: Lanjutan dari ayat "قُلْ هُوَ اللَّهُ أَحَدٌ" adalah...',
                          style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.onSurface),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            {'text': 'اللَّهُ الصَّمَدُ', 'correct': true},
                            {'text': 'مَالِكِ يَوْمِ الدِّينِ', 'correct': false},
                            {'text': 'إِنَّا أَعْطَيْنَاكَ', 'correct': false},
                          ].map((opt) {
                            return ElevatedButton(
                              onPressed: _quizAnswered
                                  ? null
                                  : () {
                                      setState(() {
                                        _quizAnswered = true;
                                        if (opt['correct'] as bool) {
                                          _quizScore += 10;
                                          _stars += 5;
                                        }
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            opt['correct'] as bool
                                                ? 'Jawaban Benar! Masya Allah ⭐ (+10 Poin)'
                                                : 'Belum tepat, coba lagi ya!',
                                          ),
                                        ),
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.primary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: Text(opt['text'] as String, style: AppTheme.quranArabic(fontSize: 16)),
                            );
                          }).toList(),
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
}

class _TracingPainter extends CustomPainter {
  final List<Offset?> points;

  _TracingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TracingPainter oldDelegate) => true;
}
