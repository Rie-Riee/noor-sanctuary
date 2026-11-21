import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class RangkumanKuisScreen extends StatefulWidget {
  final String quizTitle;
  final int totalQuestions;
  final int correctAnswers;
  final int xpGained;

  const RangkumanKuisScreen({
    super.key,
    this.quizTitle = 'Sambung Ayat Juz \'Amma',
    this.totalQuestions = 7,
    this.correctAnswers = 7,
    this.xpGained = 50,
  });

  @override
  State<RangkumanKuisScreen> createState() => _RangkumanKuisScreenState();
}

class _RangkumanKuisScreenState extends State<RangkumanKuisScreen> {
  final List<bool> _expandedItems = [true, false, false];

  final List<Map<String, dynamic>> _dalilList = [
    {
      'title': '1. Makna \'An-Naba\' Al-\'Azhim\'',
      'accuracy': 'Tepat 100%',
      'answer': 'Berita Besar (Hari Kebangkitan)',
      'dalil': 'QS. An-Naba\': 2–3 — Merujuk pada ba\'ats (kebangkitan ruh dan jasad pada yaumul akhir).',
      'tafsir': 'Imam Ibnu Katsir menjelaskan bahwa kabar agung ini adalah keniscayaan hari berbangkit yang diingkari oleh kaum musyrikin Quraisy.',
    },
    {
      'title': '2. Ketentuan Rakaat Masbuk',
      'accuracy': 'Tepat 100%',
      'answer': 'Dihitung 1 Rakaat jika Mendapati Ruku\' Sempurna',
      'dalil': 'HR. Abu Dawud no. 893 — "Barangsiapa mendapati ruku\' bersama imam, maka ia telah mendapati rakaat tersebut."',
      'tafsir': 'Kesepakatan jumhur ulama fikih bahwa thuma\'ninah saat ruku\' bersama imam mengabsahkan satu rakaat penuh bagi makmum masbuk.',
    },
    {
      'title': '3. Langkah Awal di Madinah',
      'accuracy': 'Tepat 100%',
      'answer': 'Membangun Masjid & Mempersaudarakan Sahabat',
      'dalil': 'Sirah Nabawiyah Ibnu Hisyam — Peletakan batu pertama Masjid Nabawi dan Piagam Madinah.',
      'tafsir': 'Fondasi peradaban Islam ditegakkan di atas tauhid (rumah ibadah) dan ukhuwah islamiyah yang melintasi sekat kesukuan.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 850;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Quiz Completion Summary',
          style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {},
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
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Banner: Close Button, Mumtaz Badge, Share Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          elevation: 1,
                        ),
                        icon: const Icon(Icons.close, size: 20, color: AppColors.onSurfaceVariant),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE9C46A), Color(0xFFF4A261)],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE9C46A).withAlpha(100),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🎉', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 6),
                            Text(
                              'SELESAI KUIS • MUMTAZ!',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                color: const Color(0xFF332000),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFF4A261),
                          foregroundColor: Colors.white,
                          shape: const CircleBorder(),
                        ),
                        icon: const Icon(Icons.share, size: 20),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Kartu Prestasi Juara disalin untuk dibagikan!')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Hero Trophy & Congratulation Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF282142),
                          Color(0xFF433B61),
                          Color(0xFF2E334D),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(50),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Golden Trophy with Ribbon
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFE9C46A).withAlpha(40),
                                border: Border.all(color: const Color(0xFFE9C46A), width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFE9C46A).withAlpha(120),
                                    blurRadius: 18,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.emoji_events,
                                size: 52,
                                color: Color(0xFFFDCB6E),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD35400),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white.withAlpha(150), width: 1),
                                ),
                                child: Text(
                                  '👑 MUMTAZ!',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Sempurna & Istiqomah!',
                          style: GoogleFonts.syne(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Semua soal dijawab dengan tepat & mendalam',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            color: Colors.white.withAlpha(200),
                          ),
                        ),
                        const SizedBox(height: 22),

                        // 3 Key Stats Box
                        Row(
                          children: [
                            _buildStatTile('${widget.correctAnswers} / ${widget.totalQuestions}', 'BENAR'),
                            const SizedBox(width: 10),
                            _buildStatTile('${((widget.correctAnswers / widget.totalQuestions) * 100).toInt()}%', 'AKURASI'),
                            const SizedBox(width: 10),
                            _buildStatTile('+${widget.xpGained} ★', 'XP ILMU'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section 1: STATISTIK KEBERHASILAN
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
                          const SizedBox(width: 8),
                          Text(
                            'STATISTIK KEBERHASILAN',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0ED),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFF7043).withAlpha(100)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.local_fire_department, size: 13, color: Color(0xFFFF5722)),
                            const SizedBox(width: 4),
                            Text(
                              'Streak Aktif',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFFF5722),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Two Metrics Card
                  Row(
                    children: [
                      // Metric 1: Istiqomah
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFDF5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFFFEAA7)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFF9F43),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.local_fire_department, size: 16, color: Colors.white),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFEAA7),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '+1 Hari',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF8C5300),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Istiqomah',
                                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '8 Hari Berturut',
                                style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.onSurface),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Metric 2: Tempo per Soal
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFBBF7D0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF10B981),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.bolt, size: 16, color: Colors.white),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFBBF7D0),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Cepat',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF047857),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Tempo per Soal',
                                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '19 Detik / Poin',
                                style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.onSurface),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Topik yang Dikuasai Sempurna Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.hairline),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Topik yang Dikuasai Sempurna:',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildTopicChip(Icons.menu_book, 'Surah An-Naba\'', AppColors.primaryFixed, AppColors.primary),
                            _buildTopicChip(Icons.mosque, 'Fiqih Sholat', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
                            _buildTopicChip(Icons.history_edu, 'Sirah Nabawiyah', const Color(0xFFFEF3C7), const Color(0xFF92400E)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section 2: INTISARI DALIL SHAHIH
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF59E0B),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'INTISARI DALIL SHAHIH',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                              color: AppColors.onSurfaceVariant,
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
                          '✓ 7 Soal Tuntas',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF047857),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Accordion of Dalil
                  ...List.generate(_dalilList.length, (idx) {
                    final item = _dalilList[idx];
                    final isExpanded = _expandedItems[idx];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.hairline),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                            leading: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: Color(0xFF10B981),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check, size: 14, color: Colors.white),
                            ),
                            title: Text(
                              item['title'] as String,
                              style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFECFDF5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item['accuracy'] as String,
                                    style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w700, color: const Color(0xFF047857)),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(isExpanded ? Icons.expand_less : Icons.expand_more, size: 18, color: AppColors.secondary),
                              ],
                            ),
                            onTap: () {
                              setState(() => _expandedItems[idx] = !isExpanded);
                            },
                          ),
                          if (isExpanded)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(height: 1),
                                  const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Jawaban: ',
                                        style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                                      ),
                                      Expanded(
                                        child: Text(
                                          item['answer'] as String,
                                          style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700, color: const Color(0xFF047857)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceContainerLow,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.menu_book, size: 15, color: AppColors.primary),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            item['dalil'] as String,
                                            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant, height: 1.4),
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
                    );
                  }),
                  const SizedBox(height: 20),

                  // Section 3: KELANJUTAN THOLABUL 'ILMI
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'KELANJUTAN THOLABUL \'ILMI',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        'Rekomendasi Hikmah',
                        style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Recommendation 1
                  _buildRecommendationCard(
                    icon: Icons.menu_book,
                    category: 'TAFSIR MENDALAM',
                    title: 'Baca Tafsir Surah An-Naba\'',
                    subtitle: 'Kajian ayat per ayat tema yaumul akhir',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Membuka Tafsir Surah An-Naba\' di Al-Qur\'an 30 Juz...')),
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  // Recommendation 2
                  _buildRecommendationCard(
                    icon: Icons.edit_note,
                    category: 'TAZKIYATUN NAFS',
                    title: 'Jurnal Refleksi Qolbu',
                    subtitle: 'Tulis intisari hikmah dan komitmen ibadah harian',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Membuka Jurnal Refleksi Qolbu...')),
                      );
                    },
                  ),
                  const SizedBox(height: 18),

                  // Hadith Quote Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0EDFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              '99',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '"Barangsiapa menempuh jalan untuk menuntut ilmu, Allah akan mudahkan baginya jalan menuju surga."',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.primary,
                                  height: 1.45,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'HR. Muslim no. 2699',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Bottom Action Buttons
                  ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow_rounded, size: 22),
                    label: const Text('Mainkan Kuis Khazanah Berikutnya'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                      textStyle: GoogleFonts.plusJakartaSans(fontSize: 13.5, fontWeight: FontWeight.w700),
                      elevation: 3,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.card_giftcard, size: 18),
                    label: const Text('Bagikan Kartu Prestasi Juara'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFD97706),
                      side: const BorderSide(color: Color(0xFFF59E0B)),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      textStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Kartu prestasi juara siap dibagikan ke media sosial!')),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatTile(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(20),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withAlpha(35)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(fontSize: 9.5, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicChip(IconData icon, String label, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: textCol),
          const SizedBox(width: 5),
          Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: textCol)),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard({
    required IconData icon,
    required String category,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.hairline),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.surfaceContainerLow, shape: BoxShape.circle),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category, style: GoogleFonts.spaceGrotesk(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.secondary)),
            const SizedBox(height: 2),
            Text(title, style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
          ],
        ),
        subtitle: Text(subtitle, style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.onSurfaceVariant)),
        trailing: const Icon(Icons.arrow_forward, size: 18, color: AppColors.secondary),
        onTap: onTap,
      ),
    );
  }
}
