import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import 'rangkuman_kuis_screen.dart';

class PetualanganSirahScreen extends StatefulWidget {
  const PetualanganSirahScreen({super.key});

  @override
  State<PetualanganSirahScreen> createState() => _PetualanganSirahScreenState();
}

class _PetualanganSirahScreenState extends State<PetualanganSirahScreen> {
  int? _selectedTacticalOption;
  bool _isIbrahSaved = false;

  final List<Map<String, dynamic>> _options = [
    {
      'label': 'A',
      'name': 'Abdullah bin Uraiqit',
      'desc': 'Ahli navigasi gurun Bani Ad-Dail yang amanah.',
      'isCorrect': true,
    },
    {
      'label': 'B',
      'name': 'Amir bin Fuhairah',
      'desc': 'Penggembala kambing penghapus jejak-jejak pasir.',
      'isCorrect': false,
    },
    {
      'label': 'C',
      'name': 'Suraqah bin Malik',
      'desc': 'Pemburu hadiah kafir yang kudanya terperosok pasir.',
      'isCorrect': false,
    },
    {
      'label': 'D',
      'name': 'Abu Dzar Al-Ghifari',
      'desc': 'Sahabat yang berani menyatakan keislaman di Makkah.',
      'isCorrect': false,
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
          'Seerah Quest Game',
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
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subheader Badges: Babak & XP
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E264D),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE9C46A),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'BABAK 2: LEMBAH RAHASIA',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE9FE),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.bolt, size: 14, color: Color(0xFF7C3AED)),
                            const SizedBox(width: 4),
                            Text(
                              '+150 XP',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF7C3AED),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 1. PETA EKSPEDISI HIJRAH 622 M CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFEFE9F4),
                          Color(0xFFDED6E8),
                          Color(0xFFB8AFC7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(20),
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
                                const Icon(Icons.explore_outlined, size: 15, color: Color(0xFF433B61)),
                                const SizedBox(width: 6),
                                Text(
                                  'PETA EKSPEDISI HIJRAH 622 M',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                    color: const Color(0xFF433B61),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E264D),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Pos 2 / 4',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Jalur Pesisir Rahasia',
                          style: GoogleFonts.syne(fontSize: 17, fontWeight: FontWeight.w800, color: const Color(0xFF2E264D)),
                        ),
                        const SizedBox(height: 14),

                        // Interactive Expedition Trail Graphic
                        Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/media_spotlight.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withAlpha(80),
                                      Colors.transparent,
                                      Colors.black.withAlpha(120),
                                    ],
                                  ),
                                ),
                              ),
                              // Node 1: Gua Tsur (Done)
                              Positioned(
                                left: 24,
                                bottom: 20,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF10B981),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.check, size: 18, color: Colors.white),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: Colors.black.withAlpha(150), borderRadius: BorderRadius.circular(6)),
                                      child: const Text('Gua Tsur', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ),
                              // Node 2: Kemah Ummu Ma'bad (Active)
                              Positioned(
                                left: 120,
                                top: 35,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2E264D),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: const Color(0xFFFDCB6E), width: 3),
                                        boxShadow: [
                                          BoxShadow(color: const Color(0xFFFDCB6E).withAlpha(180), blurRadius: 10),
                                        ],
                                      ),
                                      child: const Icon(Icons.star, size: 24, color: Color(0xFFFDCB6E)),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(color: const Color(0xFF2E264D), borderRadius: BorderRadius.circular(10)),
                                      child: Column(
                                        children: const [
                                          Text('Kemah Ummu Ma\'bad', style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold)),
                                          Text('Pos Aktif Sekarang', style: TextStyle(color: Color(0xFFFDCB6E), fontSize: 8)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Node 3: Quba (Locked)
                              Positioned(
                                right: 90,
                                top: 25,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(color: Colors.white.withAlpha(180), shape: BoxShape.circle),
                                      child: const Icon(Icons.lock_outline, size: 16, color: Color(0xFF433B61)),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: Colors.black.withAlpha(150), borderRadius: BorderRadius.circular(6)),
                                      child: const Text('Quba\'', style: TextStyle(color: Colors.white, fontSize: 9)),
                                    ),
                                  ],
                                ),
                              ),
                              // Node 4: Madinah (Flag)
                              Positioned(
                                right: 20,
                                top: 16,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(color: Colors.white.withAlpha(180), shape: BoxShape.circle),
                                      child: const Icon(Icons.flag_outlined, size: 16, color: Color(0xFF433B61)),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: Colors.black.withAlpha(150), borderRadius: BorderRadius.circular(6)),
                                      child: const Text('Madinah', style: TextStyle(color: Colors.white, fontSize: 9)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Bottom Card On Map
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(color: Color(0xFFEDE9FE), shape: BoxShape.circle),
                                child: const Icon(Icons.location_on, size: 18, color: AppColors.primary),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Kemah Ummu Ma\'bad • Lembah Qudaid',
                                      style: GoogleFonts.syne(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                                    ),
                                    Text(
                                      'Persinggahan mukjizat susu melimpah di tengah padang tandus.',
                                      style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.secondary),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.settings_outlined, size: 18, color: AppColors.secondary),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // 2. MISI CERITA SIRAH (QUEST DIALOG)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
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
                                const Icon(Icons.campaign_outlined, size: 16, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Text(
                                  'MISI CERITA SIRAH',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3E8FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Quest Dialog',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF6B21A8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Mukjizat di Kemah Ummu Ma\'bad',
                          style: GoogleFonts.syne(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.onSurface),
                        ),
                        const SizedBox(height: 14),

                        // Scene Illustration
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/images/podcast_malam.png',
                                width: double.infinity,
                                height: 160,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(160),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.near_me, size: 12, color: Colors.white70),
                                      SizedBox(width: 5),
                                      Text(
                                        'Lembah Qudaid — Persinggahan Hijaz',
                                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Dialog Bubble
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.onSurface, height: 1.5),
                                  children: const [
                                    TextSpan(text: 'Ummu Ma\'bad: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                    TextSpan(text: '"Kambing ini kurus kering dan tertinggal kafilah karena kemarau panjang, wahai musafir..."\n\n'),
                                    TextSpan(text: 'Rasulullah ﷺ: ', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                                    TextSpan(text: 'Mengusap kambing itu seraya mengucap Asma Allah, seketika memancar susu deras yang mengenyangkan seisi kafilah!'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Hikmah Chip
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3E8FF),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.verified_outlined, size: 16, color: Color(0xFF7C3AED)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Hikmah: Berkah iman melipatgandakan ikhtiar yang tampak terbatas.',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF581C87)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // 3. TANTANGAN TAKTIK HIJRAH (+50 Poin)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
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
                                const Icon(Icons.psychology_outlined, size: 17, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Text(
                                  'TANTANGAN TAKTIK HIJRAH',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDE9FE),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '+50 Poin',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Siapa ahli navigasi terpercaya yang memandu Rasulullah ﷺ melewati rute rahasia pesisir?',
                          style: GoogleFonts.syne(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.onSurface, height: 1.35),
                        ),
                        const SizedBox(height: 14),

                        // Options with accurate Quiz verification
                        ...List.generate(_options.length, (idx) {
                          final opt = _options[idx];
                          final isSelected = _selectedTacticalOption == idx;
                          final isCorrect = opt['isCorrect'] as bool;
                          final hasAnswered = _selectedTacticalOption != null;
                          final isAnswerCorrect = hasAnswered && _options[_selectedTacticalOption!]['isCorrect'] as bool;
                          final isMissedCorrect = hasAnswered && !isAnswerCorrect && isCorrect;

                          // Color schemes based on answer state
                          Color cardBg = Colors.white;
                          Color borderColor = AppColors.hairline;
                          double borderWidth = 1;
                          Color circleBg = AppColors.surfaceContainerLow;
                          Color letterColor = AppColors.primary;
                          Widget? trailingIcon;

                          if (isSelected) {
                            if (isCorrect) {
                              cardBg = const Color(0xFFF0FDF4); // emerald 50
                              borderColor = const Color(0xFF10B981); // emerald 500
                              borderWidth = 2;
                              circleBg = const Color(0xFF10B981);
                              letterColor = Colors.white;
                              trailingIcon = Container(
                                width: 22,
                                height: 22,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check, size: 14, color: Colors.white),
                              );
                            } else {
                              cardBg = const Color(0xFFFEF2F2); // red 50
                              borderColor = const Color(0xFFEF4444); // red 500
                              borderWidth = 2;
                              circleBg = const Color(0xFFEF4444);
                              letterColor = Colors.white;
                              trailingIcon = Container(
                                width: 22,
                                height: 22,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEF4444),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, size: 14, color: Colors.white),
                              );
                            }
                          } else if (isMissedCorrect) {
                            // If user picked wrong answer, reveal correct answer with subtle green highlight
                            cardBg = const Color(0xFFF0FDF4).withAlpha(140);
                            borderColor = const Color(0xFF10B981).withAlpha(160);
                            borderWidth = 1.5;
                            circleBg = const Color(0xFFD1FAE5);
                            letterColor = const Color(0xFF047857);
                            trailingIcon = Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD1FAE5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Kunci Benar',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF065F46),
                                ),
                              ),
                            );
                          } else {
                            trailingIcon = Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.outlineVariant, width: 1.5),
                              ),
                            );
                          }

                          return GestureDetector(
                            onTap: () {
                              setState(() => _selectedTacticalOption = idx);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: cardBg,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: borderColor,
                                  width: borderWidth,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: circleBg,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        opt['label'] as String,
                                        style: GoogleFonts.syne(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: letterColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              opt['name'] as String,
                                              style: GoogleFonts.syne(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w700,
                                                color: isSelected && !isCorrect ? const Color(0xFF991B1B) : AppColors.onSurface,
                                              ),
                                            ),
                                            if (isSelected && isCorrect) ...[
                                              const SizedBox(width: 6),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFD1FAE5),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  'Benar',
                                                  style: GoogleFonts.plusJakartaSans(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w700,
                                                    color: const Color(0xFF047857),
                                                  ),
                                                ),
                                              ),
                                            ],
                                            if (isSelected && !isCorrect) ...[
                                              const SizedBox(width: 6),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFFEE2E2),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  'Salah',
                                                  style: GoogleFonts.plusJakartaSans(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w700,
                                                    color: const Color(0xFFB91C1C),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        Text(
                                          opt['desc'] as String,
                                          style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.secondary),
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailingIcon,
                                ],
                              ),
                            ),
                          );
                        }),

                        // Detailed Answer Feedback Banner
                        if (_selectedTacticalOption != null) ...[
                          const SizedBox(height: 6),
                          Builder(builder: (context) {
                            final selectedOpt = _options[_selectedTacticalOption!];
                            final isCorrect = selectedOpt['isCorrect'] as bool;

                            if (isCorrect) {
                              return Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0FDF4),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFF86EFAC)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 22),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Masya Allah, Jawaban Anda Benar! (+50 Poin)',
                                            style: GoogleFonts.syne(fontSize: 12.5, fontWeight: FontWeight.w700, color: const Color(0xFF15803D)),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            'Abdullah bin Uraiqit adalah penunjuk jalan Bani Ad-Dail yang amanah dan diakui keahlian navigasinya dalam memandu rute pesisir rahasia.',
                                            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF166534), height: 1.35),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF2F2),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFFCA5A5)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.cancel_rounded, color: Color(0xFFDC2626), size: 22),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Afwan, Jawaban Kurang Tepat (0 Poin)',
                                            style: GoogleFonts.syne(fontSize: 12.5, fontWeight: FontWeight.w700, color: const Color(0xFFB91C1C)),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            'Pemandu rute rahasia pesisir adalah (A) Abdullah bin Uraiqit. Tokoh pilihan Anda (${selectedOpt['name']}) memiliki peran lain dalam tarikh (seperti penghapus jejak atau pemburu hadiah).',
                                            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF991B1B), height: 1.35),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // 4. PILAR STRATEGI KENABIAN
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEDE9FE), Color(0xFFE2D9F3)],
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.lightbulb_outline, size: 16, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Text(
                                  'PILAR STRATEGI KENABIAN',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                              child: Text('Pelajaran Inti', style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tawakkal Tertinggi & Presisi Taktis',
                          style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.onSurface),
                        ),
                        const SizedBox(height: 8),
                        _buildPilarItem('Profesionalisme Total', 'Mempekerjakan navigator terbaik gurun yang memegang teguh amanah.'),
                        const SizedBox(height: 6),
                        _buildPilarItem('Taktik Kejutan', 'Memilih rute pesisir terjal yang berlawanan dengan prediksi musuh.'),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            icon: Icon(_isIbrahSaved ? Icons.bookmark : Icons.bookmark_border, size: 16),
                            label: Text(_isIbrahSaved ? 'Tersimpan' : 'Simpan Ibrah'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              elevation: 1,
                            ),
                            onPressed: () {
                              setState(() => _isIbrahSaved = !_isIbrahSaved);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(_isIbrahSaved ? 'Ibrah hijrah disimpan ke jurnal qolbu!' : 'Ibrah dihapus.')),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Bottom Action Buttons
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF433B61),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                      elevation: 2,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RangkumanKuisScreen(
                            quizTitle: 'Petualangan Sirah: Jejak Hijrah',
                            totalQuestions: 4,
                            correctAnswers: 4,
                            xpGained: 150,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lanjut Perjalanan ke Masjid Quba\'',
                          style: GoogleFonts.plusJakartaSans(fontSize: 13.5, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.collections_bookmark_outlined, size: 16),
                    label: const Text('Koleksi Hikmah Tersimpan (3)'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 46),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Membuka 3 koleksi hikmah sirah tersimpan...')),
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

  Widget _buildPilarItem(String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_outline, size: 15, color: Color(0xFF10B981)),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurface, height: 1.4),
              children: [
                TextSpan(text: '$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: desc),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
