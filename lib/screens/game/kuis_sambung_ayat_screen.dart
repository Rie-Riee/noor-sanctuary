import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import 'rangkuman_kuis_screen.dart';

class KuisSambungAyatScreen extends StatefulWidget {
  final String title;
  final String category;

  const KuisSambungAyatScreen({
    super.key,
    this.title = 'Sambung Ayat Juz \'Amma',
    this.category = 'Juz \'Amma Challenge',
  });

  @override
  State<KuisSambungAyatScreen> createState() => _KuisSambungAyatScreenState();
}

class _KuisSambungAyatScreenState extends State<KuisSambungAyatScreen> with SingleTickerProviderStateMixin {
  int _currentQuestionIndex = 2; // Soal 3 dari 7 (index 2) as in the mockup!
  int? _selectedOptionIndex;
  bool _isPlayingAudio = true;
  int _streakCount = 5;
  int _remainingSeconds = 35;
  Timer? _countdownTimer;

  late AnimationController _waveformController;

  final List<Map<String, dynamic>> _questions = [
    {
      'surah': 'Surah An-Naba\' • Juz 30',
      'ayatPemantik': 'QS. An-Naba\': 1',
      'arabicPemantik': 'عَمَّ يَتَسَآءَلُونَ ﴿١﴾',
      'translationPemantik': '"Tentang apakah mereka saling bertanya-tanya?"',
      'qari': 'Syaikh Mishary Rashid Al-Afasy',
      'audioTime': '0:04 / 0:09',
      'prompt': 'Lanjutan ayat berikutnya adalah:',
      'hikmah': 'An-Naba\' al-\'Azhim merujuk pada berita besar peristiwa hari kebangkitan ruh & jasad serta tauhid murni yang pasti ditegakkan.',
      'options': [
        {
          'label': 'A',
          'ayat': 'QS. An-Naba\': 2',
          'arabic': 'عَنِ النَّبَإِ الْعَظِيمِ ﴿٢﴾',
          'translation': '"Tentang berita yang besar (hari berbangkit)."',
          'isCorrect': true,
        },
        {
          'label': 'B',
          'ayat': 'QS. An-Naba\': 3',
          'arabic': 'الَّذِي هُمْ فِيهِ مُخْتَلِفُونَ ﴿٣﴾',
          'translation': '"Yang dalam hal itu mereka berselisih."',
          'isCorrect': false,
        },
        {
          'label': 'C',
          'ayat': 'QS. An-Naba\': 4',
          'arabic': 'كَلَّا سَيَعْلَمُونَ ﴿٤﴾',
          'translation': '"Sekali-kali tidak! Kelak mereka akan mengetahui."',
          'isCorrect': false,
        },
        {
          'label': 'D',
          'ayat': 'QS. An-Naba\': 5',
          'arabic': 'ثُمَّ كَلَّا سَيَعْلَمُونَ ﴿٥﴾',
          'translation': '"Kemudian sekali-kali tidak! Kelak mereka akan mengetahui."',
          'isCorrect': false,
        },
      ],
    },
    {
      'surah': 'Surah An-Nazi\'at • Juz 30',
      'ayatPemantik': 'QS. An-Nazi\'at: 1',
      'arabicPemantik': 'وَالنَّازِعَاتِ غَرْقًا ﴿١﴾',
      'translationPemantik': '"Demi (malaikat-malaikat) yang mencabut (nyawa) dengan keras,"',
      'qari': 'Syaikh Mishary Rashid Al-Afasy',
      'audioTime': '0:03 / 0:08',
      'prompt': 'Pilih sambungan ayat ke-2 yang tepat:',
      'hikmah': 'Sumpah Allah dengan para malaikat yang bertugas mencabut nyawa orang kafir dengan keras dan mencabut nyawa orang mukmin dengan lemah lembut.',
      'options': [
        {
          'label': 'A',
          'ayat': 'QS. An-Nazi\'at: 2',
          'arabic': 'وَالنَّاشِطَاتِ نَشْطًا ﴿٢﴾',
          'translation': '"dan (malaikat-malaikat) yang mencabut (nyawa) dengan lemah-lembut,"',
          'isCorrect': true,
        },
        {
          'label': 'B',
          'ayat': 'QS. An-Nazi\'at: 3',
          'arabic': 'وَالسَّابِحَاتِ سَبْحًا ﴿٣﴾',
          'translation': '"dan (malaikat-malaikat) yang turun dari langit dengan cepat,"',
          'isCorrect': false,
        },
        {
          'label': 'C',
          'ayat': 'QS. An-Nazi\'at: 4',
          'arabic': 'فَالسَّابِقَاتِ سَبْقًا ﴿٤﴾',
          'translation': '"dan (malaikat-malaikat) yang mendahului dengan kencang,"',
          'isCorrect': false,
        },
        {
          'label': 'D',
          'ayat': 'QS. An-Nazi\'at: 5',
          'arabic': 'فَالْمُدَبِّرَاتِ أَمْرًا ﴿٥﴾',
          'translation': '"dan (malaikat-malaikat) yang mengatur urusan (dunia)."',
          'isCorrect': false,
        },
      ],
    },
    {
      'surah': 'Surah Al-Insyiqaq • Juz 30',
      'ayatPemantik': 'QS. Al-Insyiqaq: 1',
      'arabicPemantik': 'إِذَا السَّمَاءُ انْشَقَّتْ ﴿١﴾',
      'translationPemantik': '"Apabila langit terbelah,"',
      'qari': 'Syaikh Mishary Rashid Al-Afasy',
      'audioTime': '0:05 / 0:10',
      'prompt': 'Lanjutan ayat berikutnya adalah:',
      'hikmah': 'Ketundukan mutlak seluruh makhluk dan alam semesta kepada Rabbul \'Alamin di saat kiamat.',
      'options': [
        {
          'label': 'A',
          'ayat': 'QS. Al-Insyiqaq: 2',
          'arabic': 'وَأَذِنَتْ لِرَبِّهَا وَحُقَّتْ ﴿٢﴾',
          'translation': '"dan patuh kepada Rabbnya, dan sudah semestinya langit itu patuh,"',
          'isCorrect': true,
        },
        {
          'label': 'B',
          'ayat': 'QS. Al-Insyiqaq: 3',
          'arabic': 'وَإِذَا الْأَرْضُ مُدَّتْ ﴿٣﴾',
          'translation': '"dan apabila bumi diratakan,"',
          'isCorrect': false,
        },
        {
          'label': 'C',
          'ayat': 'QS. Al-Insyiqaq: 4',
          'arabic': 'وَأَلْقَتْ مَا فِيهَا وَتَخَلَّتْ ﴿٤﴾',
          'translation': '"dan memuntahkan apa yang ada di dalamnya dan menjadi kosong,"',
          'isCorrect': false,
        },
        {
          'label': 'D',
          'ayat': 'QS. Al-Insyiqaq: 5',
          'arabic': 'وَأَذِنَتْ لِرَبِّهَا وَحُقَّتْ ﴿٥﴾',
          'translation': '"dan patuh kepada Rabbnya, dan sudah semestinya patuh."',
          'isCorrect': false,
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    // Default select correct option (0) to match the mockup visual!
    _selectedOptionIndex = 0;

    _waveformController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _waveformController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = null;
        _remainingSeconds = 40;
      });
    } else {
      // Completed, open summary screen!
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => RangkumanKuisScreen(
            quizTitle: widget.title,
            totalQuestions: 7,
            correctAnswers: 7,
            xpGained: 100,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final curQ = _questions[_currentQuestionIndex % _questions.length];
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 850;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active Quiz Session',
              style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            Text(
              widget.category,
              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_isPlayingAudio ? Icons.volume_up : Icons.volume_off),
            onPressed: () {
              setState(() => _isPlayingAudio = !_isPlayingAudio);
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Soal kuis ditandai ke koleksi muroja\'ah.')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 680 : double.infinity),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress & Streak Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.hairline),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(8),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // 3/7 Badge
                            Container(
                              width: 38,
                              height: 38,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2E274D),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${_currentQuestionIndex + 1}/7',
                                  style: GoogleFonts.syne(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sambung Ayat',
                                    style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                                  ),
                                  Text(
                                    curQ['surah'] as String,
                                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                                  ),
                                ],
                              ),
                            ),
                            // Streak Pill
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF3CD),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('🔥', style: TextStyle(fontSize: 11)),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$_streakCount Streak!',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF856404),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Timer Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.timer_outlined, size: 13, color: AppColors.onSurfaceVariant),
                                  const SizedBox(width: 4),
                                  Text(
                                    '00:${_remainingSeconds.toString().padLeft(2, '0')}',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Dots / Bar Progress
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (_currentQuestionIndex + 1) / 7,
                            minHeight: 4,
                            backgroundColor: AppColors.surfaceContainerHigh,
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Question Card: Ayat Pemantik
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFFAFAFE),
                          const Color(0xFFF3F0FC),
                          AppColors.surfaceContainerLowest,
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
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryFixed,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.volume_up, size: 13, color: AppColors.primary),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Dengarkan Potongan',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                curQ['ayatPemantik'] as String,
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1D4ED8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // Arabic Calligraphy
                        Text(
                          curQ['arabicPemantik'] as String,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.amiri(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            height: 2.1,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Translation
                        Text(
                          curQ['translationPemantik'] as String,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: AppColors.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Audio Waveform Player
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.hairline),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() => _isPlayingAudio = !_isPlayingAudio);
                                },
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2E274D),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _isPlayingAudio ? Icons.pause : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              // Animated Waveform Bars
                              Expanded(
                                child: AnimatedBuilder(
                                  animation: _waveformController,
                                  builder: (context, child) {
                                    final val = _waveformController.value;
                                    final barColors = [
                                      const Color(0xFF10B981),
                                      const Color(0xFF3B82F6),
                                      const Color(0xFFF59E0B),
                                      const Color(0xFFEC4899),
                                      const Color(0xFF8B5CF6),
                                      const Color(0xFF10B981),
                                      const Color(0xFF3B82F6),
                                      const Color(0xFFF59E0B),
                                      const Color(0xFF6366F1),
                                    ];
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: List.generate(9, (bIdx) {
                                        final heightFactor = (bIdx % 2 == 0) ? (0.4 + 0.6 * val) : (1.0 - 0.5 * val);
                                        return Container(
                                          width: 3.5,
                                          height: 24 * heightFactor,
                                          decoration: BoxDecoration(
                                            color: barColors[bIdx],
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        );
                                      }),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Mishary Rashid',
                                    style: GoogleFonts.syne(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                                  ),
                                  Text(
                                    curQ['audioTime'] as String,
                                    style: GoogleFonts.spaceGrotesk(fontSize: 9.5, color: AppColors.secondary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Prompt Row: Lanjutan ayat berikutnya adalah
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.help_outline, size: 16, color: AppColors.primary),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            curQ['prompt'] as String,
                            style: GoogleFonts.syne(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFA7F3D0)),
                        ),
                        child: Text(
                          '+100 Poin',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF047857),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 4 Answer Options (A, B, C, D)
                  ...List.generate((curQ['options'] as List).length, (optIdx) {
                    final opt = (curQ['options'] as List)[optIdx] as Map<String, dynamic>;
                    final isSelected = _selectedOptionIndex == optIdx;
                    final isCorrect = opt['isCorrect'] as bool;

                    Color borderColor = AppColors.hairline;
                    Color bgColor = AppColors.surfaceContainerLowest;
                    if (isSelected) {
                      if (isCorrect) {
                        borderColor = const Color(0xFF10B981);
                        bgColor = const Color(0xFFF0FDF4);
                      } else {
                        borderColor = const Color(0xFFEF4444);
                        bgColor = const Color(0xFFFEF2F2);
                      }
                    }

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedOptionIndex = optIdx;
                          if (isCorrect) {
                            _streakCount++;
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: (isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withAlpha(40),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
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
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: isSelected && isCorrect ? const Color(0xFF10B981) : AppColors.surfaceContainerLow,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          opt['label'] as String,
                                          style: GoogleFonts.syne(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: isSelected && isCorrect ? Colors.white : AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEFF6FF),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        opt['ayat'] as String,
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF1D4ED8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (isSelected && isCorrect)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF10B981),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.check, size: 12, color: Colors.white),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Jawaban Benar',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppColors.outlineVariant, width: 1.5),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Arabic Option Text
                            Container(
                              width: double.infinity,
                              alignment: Alignment.centerRight,
                              child: Text(
                                opt['arabic'] as String,
                                textDirection: TextDirection.rtl,
                                style: GoogleFonts.amiri(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                  height: 1.8,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              opt['translation'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 10),

                  // Bottom Hikmah Kilat Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF9ED),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFFFE6B3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF59E0B),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.lightbulb, size: 16, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'HIKMAH KILAT',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.8,
                                      color: const Color(0xFF92400E),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text('•', style: TextStyle(color: Color(0xFFD97706), fontSize: 10)),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDE9FE),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Tafsir Ibnu Katsir',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                curQ['hikmah'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  color: const Color(0xFF78350F),
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
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
      // Sticky Bottom Action Bar
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 14,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.hearing, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF433B61),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  textStyle: GoogleFonts.plusJakartaSans(fontSize: 13.5, fontWeight: FontWeight.w700),
                  elevation: 2,
                ),
                onPressed: _nextQuestion,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Lanjut Ayat Berikutnya'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
