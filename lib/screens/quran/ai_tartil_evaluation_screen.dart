import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../data/quran_dataset.dart';
import 'recitation_history_screen.dart';

class AiTartilEvaluationScreen extends StatefulWidget {
  final SurahModel? surah;
  final int ayahNumber;

  const AiTartilEvaluationScreen({
    super.key,
    this.surah,
    this.ayahNumber = 1,
  });

  @override
  State<AiTartilEvaluationScreen> createState() => _AiTartilEvaluationScreenState();
}

class _AiTartilEvaluationScreenState extends State<AiTartilEvaluationScreen> with SingleTickerProviderStateMixin {
  bool _isRecording = false;
  bool _hasAnalyzed = true; // start with realistic analyzed state per mockup
  int _recordSeconds = 9;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _toggleRecord() {
    setState(() {
      if (_isRecording) {
        _isRecording = false;
        _hasAnalyzed = true;
      } else {
        _isRecording = true;
        _hasAnalyzed = false;
        _recordSeconds = 0;
      }
    });

    if (_isRecording) {
      // Simulate 3 seconds recording then auto evaluate
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _isRecording) {
          setState(() {
            _isRecording = false;
            _hasAnalyzed = true;
            _recordSeconds = 9;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final surah = widget.surah ?? kQuranSurahs.firstWhere(
      (s) => s.number == 78,
      orElse: () => kQuranSurahs.first,
    );
    final ayah = surah.ayahs.firstWhere(
      (a) => a.number == widget.ayahNumber,
      orElse: () => surah.ayahs.first,
    );

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
          'Uji Pelafalan Tartil & Makhraj',
          style: GoogleFonts.syne(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.primary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: AppColors.primary, size: 22),
            tooltip: 'Riwayat & Portofolio Tahsin',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RecitationHistoryScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.secondary, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('AI Talaqqi menghitung akurasi makharijul huruf & hukum tajwid berbasis riwayat Hafsh.')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Target Verse Card with Tajwid Breakdown
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.surfaceContainerHigh),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryFixed,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'QS. ${surah.name}: Ayat ${ayah.number}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      Text(
                        'Rasm Utsmani Madinah',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Arabic Text with golden ayah symbol
                  Text(
                    '${ayah.arabic} ﴿${ayah.number}﴾',
                    textAlign: TextAlign.center,
                    style: AppTheme.quranArabic(fontSize: 32).copyWith(height: 1.8),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    '"${ayah.translation}"',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.secondary, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),

                  // Tajwid word pills
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildTajwidBadge('عَمَّ', 'Ghunnah Musyaddadah', const Color(0xFFEC4899)),
                      _buildTajwidBadge('يَتَسَآءَلُونَ', 'Mad Wajib Muttashil (4-5)', const Color(0xFF6366F1)),
                      _buildTajwidBadge('﴿١﴾', 'Waqaf Tanda Akhir', const Color(0xFFF59E0B)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Live Audio Waveform / Recorder Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isRecording
                      ? [const Color(0xFF7F1D1D), const Color(0xFF450A0A)]
                      : [AppColors.primary, AppColors.primaryContainer],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: (_isRecording ? Colors.red : AppColors.primary).withAlpha(60),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _isRecording ? Icons.fiber_manual_record : Icons.mic,
                            color: _isRecording ? Colors.redAccent : Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isRecording ? 'Merekam Suara Anda...' : 'Status Perekaman',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '00:0$_recordSeconds • 44.1 kHz',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.white70),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Simulated Waveform Bars
                  SizedBox(
                    height: 50,
                    child: AnimatedBuilder(
                      animation: _waveController,
                      builder: (context, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(24, (index) {
                            final factor = (index % 5 + 1) * 0.18;
                            final animValue = _isRecording
                                ? (_waveController.value * factor * 40 + 8)
                                : (_hasAnalyzed ? (index % 4 + 1) * 8.0 + 6 : 8.0);
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2.2),
                              width: 4,
                              height: animValue.clamp(6.0, 48.0),
                              decoration: BoxDecoration(
                                color: _isRecording
                                    ? Colors.redAccent
                                    : (index < 18 ? const Color(0xFF10B981) : Colors.white60),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Record Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isRecording ? Colors.red : Colors.white,
                          foregroundColor: _isRecording ? Colors.white : AppColors.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        icon: Icon(_isRecording ? Icons.stop : Icons.mic, size: 20),
                        label: Text(
                          _isRecording ? 'Selesai Rekam' : (_hasAnalyzed ? 'Uji Ulang Rekaman' : 'Mulai Rekam Suara'),
                          style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                        onPressed: _toggleRecord,
                      ),
                      if (_hasAnalyzed && !_isRecording) ...[
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white54),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          icon: const Icon(Icons.play_arrow, size: 18),
                          label: Text(
                            'Dengar',
                            style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Memutar rekaman pelafalan santri (00:09)...')),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // AI Instant Analysis Breakdown
            if (_hasAnalyzed) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.surfaceContainerHigh),
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
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withAlpha(25),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.verified, color: Color(0xFF10B981), size: 18),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Hasil Analisis AI Tartil',
                              style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withAlpha(30),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF10B981).withAlpha(80)),
                          ),
                          child: Text(
                            '92% • Mumtaz',
                            style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF10B981)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Point by point
                    _buildFeedbackPoint(
                      isSuccess: true,
                      title: "Huruf 'Ain & Ghunnah (عَمَّ)",
                      desc: "Fasih sempurna: Suara keluar tepat dari wasathul halq (tengah tenggorokan) dengan dengung 2 harakat.",
                    ),
                    const SizedBox(height: 8),
                    _buildFeedbackPoint(
                      isSuccess: false,
                      title: "Mad Wajib Muttashil (يَتَسَآءَلُونَ)",
                      desc: "Perlu perhatian: Panjang mad terbaca ~3 harakat. Tambahkan tarikan nafas agar mencapai 4-5 harakat penuh.",
                    ),
                    const SizedBox(height: 12),

                    // Ustadz AI quote
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.school, color: AppColors.primary, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rekomendasi Ustadz AI (Sanad Hafsh):',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '"Bagus sekali bacaan antum pada makhraj Halq. Kuatkan konsistensi ayunan mad saat menghadapi hamzah dalam satu kalimat agar tartil semakin menyejukkan hati."',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 11.5, height: 1.4, color: AppColors.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Audio comparison
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: const Icon(Icons.play_circle_outline, size: 16),
                            label: Text(
                              'Bacaan Anda',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Memutar rekaman santri...')),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: const Icon(Icons.volume_up, size: 16),
                            label: Text(
                              'Qari Sanad',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Memutar contoh tartil Syaikh Mishary Rashid Al-Afasy...')),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Bottom Button: Lanjut ke Ayat berikutnya
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: Text(
                    'Lanjut ke Ayat 2 (عَنِ النَّبَإِ الْعَظِيمِ)',
                    style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Memuat evaluasi Ayat ke-2 Surah An-Naba\'...')),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTajwidBadge(String word, String law, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Column(
        children: [
          Text(
            word,
            style: AppTheme.quranArabic(fontSize: 16).copyWith(color: color, fontWeight: FontWeight.w700),
          ),
          Text(
            law,
            style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackPoint({required bool isSuccess, required String title, required String desc}) {
    final color = isSuccess ? const Color(0xFF10B981) : const Color(0xFFD97706);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(isSuccess ? Icons.check_circle : Icons.warning_amber_rounded, color: color, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: color),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: GoogleFonts.plusJakartaSans(fontSize: 11, height: 1.4, color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
