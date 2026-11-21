import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import 'video_player_detail_screen.dart';

class DocuseriesDetailScreen extends StatefulWidget {
  const DocuseriesDetailScreen({super.key});

  @override
  State<DocuseriesDetailScreen> createState() => _DocuseriesDetailScreenState();
}

class _DocuseriesDetailScreenState extends State<DocuseriesDetailScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['Semua Episode', 'Belum Ditonton', 'Favorit Faedah', 'Dilengkapi Transkrip'];

  final List<Map<String, dynamic>> _episodes = [
    {
      'number': 1,
      'title': 'Langkah Pertama di Masjid Quba\' — Pondasi Ketakwaan',
      'duration': '38 Menit',
      'speaker': 'Ust. Salim A. Fillah',
      'isCompleted': true,
      'isCurrent': false,
      'progress': 1.0,
      'summary': 'Detik-detik kedatangan Rasulullah ﷺ di pinggiran Yatsrib dan arsitektur sosial pertama yang ditegakkan melalui rumah ibadah.',
      'image': 'assets/images/mosque_hero.png',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDlv78BL2O9XhA_S2znce4xE_OL6IN0Zo4NEEKNA8qZI3M_evM60Ss722TxWi0jKatavNWl171NidqZvWojAtMzPPCHwYfNDPI0JbX871PkxGxUljMljXsZSkdpeMCwxDJQ70LxcrZRSqPcZuxtJlIvnXAWvu65J-Jf8oKljJQ3RQJTlYvI3sqgGtprsan-80WiDKmwWsDuK48oY8TTUQGLLxlj3_ygHUPq8coK_dY',
    },
    {
      'number': 2,
      'title': 'Mu\'akhah: Mempersaudarakan Dua Hati yang Asing',
      'duration': '44 Menit',
      'speaker': 'Ust. Salim A. Fillah',
      'isCompleted': true,
      'isCurrent': false,
      'progress': 1.0,
      'summary': 'Ikatan persaudaraan sejati antara kaum Muhajirin dan Anshar yang melampaui sekat kesukuan serta kekerabatan darah.',
      'image': 'assets/images/ustadzah_kajian.png',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCJJLbdWB2aPr9hbc22giLS5bYG3FEVyOAKTshcZ5LZDtUNSU6rkKG5ePhwCzh1nIairRTJKfVuCfb8-t6ivTQUXOL0aY4KrSfvevg1NyEOeJVNOpk1nJcgRmrR-l1kRfP2liHlyHxvNHthyU3E6hJRkpLWVUTi8Cr61ZKsmyCJStDgqn_3SEXpU77Rh8AoZHjKlkyEe65v1UzeINUkMbl4HFudGJmilA0V744lcl8',
    },
    {
      'number': 3,
      'title': 'Piagam Madinah: Konsensus Kebangsaan & Keadilan',
      'duration': '40 Menit',
      'speaker': 'Ust. Salim A. Fillah',
      'isCompleted': true,
      'isCurrent': false,
      'progress': 1.0,
      'summary': 'Telaah konstitusi tertulis pertama dunia modern yang menjamin hak asasi, kesetaraan beragama, dan kerukunan lintas iman.',
      'image': 'assets/images/kajian_1.png',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBAN15nt9f83SbKaDTZz3p6ZcusBbhGdYpB8wu5dG7zSBe3H-lCTVhdCPdtk__2vzftu8IlpSYjI3dWXVvL-vagN24cVHxtX43NZGp2maS3wgOAHNqfXsuDEH5L0ySwqC6g04-lSpGUVqjUZDA6rI_TwpXKRdKokLUtLg3ZXivO2z5UvSyJ7_XsqURtk7IeU-mlpST0JsBjlE6rtOHK72MHnnJBng-eqglkGvzKvfc',
    },
    {
      'number': 4,
      'title': 'Cahaya di Tengah Madinah: Menata Pasar & Ekonomi Ummat',
      'duration': '42 Menit',
      'speaker': 'Ust. Salim A. Fillah',
      'isCompleted': false,
      'isCurrent': true,
      'progress': 0.58,
      'timeLeft': '24m tersisa',
      'summary': 'Kemerdekaan ekonomi dimulai dari pendirian pasar mandiri tanpa monopoli, menegakkan sistem timbangan jujur dan permodalan syirkah.',
      'image': 'assets/images/media_spotlight.png',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAEn-IIp6ZKENx2cBs0QaP6SY4J_cC5_rnHBymlEVMN-E77f2auKeqUTc4qXDfG63BN3kBzgN17jxmT-VsptO919Ajx9xHUHDl-nM-rvTviqdyPH8ImLWEOed-Pehwj9IfY0jc-z85zjX8sIY8QJDzj7pBFG3xEq8NA-SSzn6dvq2YXwuouG2pJhRQChLWZlWO3uo7kZkq58XyZkAjj5IuWlZIlEy2juoP3dVJC9lo',
    },
    {
      'number': 5,
      'title': 'Ujian Kesabaran & Strategi Bertahan di Perang Badar',
      'duration': '48 Menit',
      'speaker': 'Ust. Salim A. Fillah',
      'isCompleted': false,
      'isCurrent': false,
      'progress': 0.0,
      'summary': 'Analisis topografi lembah Badar dan kepemimpinan strategis Rasulullah ﷺ dalam menjaga kedaulatan komunitas Madinah.',
      'image': 'assets/images/reel_2.png',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBlKR6OkXY7-qRoMloGCvUSvlT4SllswO2k_dcc-N4AuMw3PfJGjttYJlDlOJSI8kSv0lf5Jv0AC3C2kvPqcGbTJ8SsUANjI5bb-5nrReXPsjRjDzEyqdeL_PZONU4R6cC-oHgRXYtPNlEVyUwwB0aplfU7etrWN-4OXndsfbfwt1E5amJeeIRjBX_Q9OvZ8k8ao56zkxnSvBdlzJEwnPGgW0UTEfJ39e-0-UNS_h8',
    },
    {
      'number': 6,
      'title': 'Fathu Makkah: Puncak Pemaafan & Rekonsiliasi Akbar',
      'duration': '52 Menit',
      'speaker': 'Ust. Salim A. Fillah',
      'isCompleted': false,
      'isCurrent': false,
      'progress': 0.0,
      'summary': 'Kembalinya kaum beriman ke kota kelahiran tanpa setetes dendam; teladan diplomasi perdamaian universal terbesar dalam sejarah.',
      'image': 'assets/images/reel_3.png',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDD3myxP9HKhrLKL70EJWSiiJQSR6A3psoFo1fVhxJJs8if8kGGqEd_5f4uZowAv0t29nRwC76DRz4Mkd2rVYctM6O8NsXbiuJ-v05HBl6Y1nHOilyX79DGl3cCSJBSioacgC8yxsGWQih7r25sTTRjICz1wTYDcTOi0GCwkxW4xvZpCJxNf--Nxx_-iOsR8qWz1lpwsUmNM13ibc85g-sUwVWj4UUS3gNvLUglqhs',
    },
  ];

  void _openEpisodePlayer(Map<String, dynamic> ep) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoPlayerDetailScreen(
          title: ep['title'] as String,
          speaker: ep['speaker'] as String,
          category: 'Sirah Docuseries • Eps ${ep['number']}',
          duration: ep['duration'] as String,
          imageUrl: ep['imageUrl'] as String,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 850;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Docuseries Detail',
          style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: 'Audio Mode',
            icon: const Icon(Icons.headphones, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Audio podcast mode aktif.')),
              );
            },
          ),
          IconButton(
            tooltip: 'Simpan',
            icon: const Icon(Icons.bookmark_border, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Docuseries ditambahkan ke daftar putar.')),
              );
            },
          ),
          IconButton(
            tooltip: 'Bagikan',
            icon: const Icon(Icons.share, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tautan docuseries disalin!')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 1200 : 640),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                isDesktop ? 24 : 16,
                isDesktop ? 16 : 8,
                isDesktop ? 24 : 16,
                isDesktop ? 40 : 100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. SERIES HERO SHOWCASE
                  _buildHeroShowcase(),

                  const SizedBox(height: 24),

                  // 2. SEASON & FILTER SELECTOR
                  _buildSeasonAndFilterBar(),

                  const SizedBox(height: 18),

                  // 3. EPISODE LIST
                  _buildEpisodeListSection(),

                  const SizedBox(height: 24),

                  // 4. BONUS MATERIALS & BEHIND THE SCENES
                  _buildBonusMaterialsSection(),

                  const SizedBox(height: 20),

                  // 5. SANAD VERIFICATION FOOTER
                  _buildSanadVerificationFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 1. SERIES HERO SHOWCASE
  // ==========================================
  Widget _buildHeroShowcase() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(30),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Artwork with Play Trailer Button
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida/ALJJyrC7N8iLER0xfMs1yHW7ApgAzv8EiwS1XvfSe9rqj713rAZZt-oqSOFsoOxfdc7J4mDSjSXmlxZePwoIjCfhzV8NA7Y8i_CX5jY3iV4ypYLu3LKnO_m7RuncAsTI63UoBfkk0q_CWqF_SG-vufCXqtW8EdDc38FFJmTv-Pj7I4auiFvhJMAdBpydAAn2VFsQYmH-KgChDe1fY1IDq1a39DPqA5jhiri1I4tnA5g2IRcE',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/media_spotlight.png', fit: BoxFit.cover),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withAlpha(140),
                          Colors.transparent,
                          AppColors.primaryContainer,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
                // Badges
                Positioned(
                  top: 14,
                  left: 14,
                  right: 14,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(220),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          'EXCLUSIVE DOCUSERIES • 4K HDR',
                          style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(180),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.verified, size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              'Sanad Tarikh Mutawatir',
                              style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Center Play Button
                Positioned.fill(
                  child: Center(
                    child: GestureDetector(
                      onTap: () => _openEpisodePlayer(_episodes[3]), // Open current ep 4
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(230),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withAlpha(40), blurRadius: 16, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: const Icon(Icons.play_arrow, size: 36, color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Text Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Musim 1', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.primaryFixed)),
                      const Text(' • ', style: TextStyle(color: Colors.white38)),
                      Text('6 Episode Lengkap', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.primaryFixed)),
                      const Text(' • ', style: TextStyle(color: Colors.white38)),
                      Text('4j 15m', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.primaryFixed)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryFixed.withAlpha(40),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Bebas Iklan',
                          style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.primaryFixed),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Jejak Peradaban Hijrah: Cahaya di Tengah Madinah',
                    style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, height: 1.25),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text('Ust. Salim A. Fillah', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700, color: Colors.white)),
                      const Text(' • ', style: TextStyle(color: Colors.white38)),
                      Text('Kurator: Dewan Tarikh Nabawi', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.primaryFixed)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Menelusuri napak tilas persaudaraan Muhajirin & Anshar dengan rekonstruksi visual lanskap bersejarah secara autentik, meneladani strategi dakwah dan arsitektur peradaban Islam awal.',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.white.withAlpha(220), height: 1.45),
                  ),
                  const SizedBox(height: 16),

                  // Watch Progress & Action Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(140),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.play_circle, size: 16, color: AppColors.secondaryFixed),
                                const SizedBox(width: 6),
                                Text(
                                  'Lanjut Episode 4',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700, color: Colors.white),
                                ),
                              ],
                            ),
                            Text(
                              '60% selesai (24m sisa)',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.primaryFixed),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: 0.60,
                            minHeight: 5,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondaryFixed),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.play_circle_filled, size: 16),
                                label: const Text('Lanjut Nonton (Eps. 4)'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                  textStyle: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700),
                                ),
                                onPressed: () => _openEpisodePlayer(_episodes[3]),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.download_for_offline, size: 16),
                                label: const Text('Unduh Semua (1.8 GB)'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white54),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                  textStyle: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Proses pengunduhan docuseries dimulai di latar belakang.')),
                                  );
                                },
                              ),
                            ),
                          ],
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
    );
  }

  // ==========================================
  // 2. SEASON & FILTER BAR
  // ==========================================
  Widget _buildSeasonAndFilterBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Text(
                    'Musim 1: Fase Madinah Awal (6 Episode)',
                    style: GoogleFonts.syne(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.primary),
                ],
              ),
            ),
            Text(
              'Status: Aktif',
              style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.secondary),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(_filters.length, (idx) {
              final isSel = idx == _selectedFilterIndex;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(_filters[idx]),
                  selected: isSel,
                  onSelected: (val) => setState(() => _selectedFilterIndex = idx),
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surfaceContainerLow,
                  labelStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                    color: isSel ? Colors.white : AppColors.onSurfaceVariant,
                  ),
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 3. EPISODE LIST SECTION
  // ==========================================
  Widget _buildEpisodeListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daftar Rekonstruksi Sejarah',
              style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
            Text(
              '${_episodes.length} Episode Tersedia',
              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: _episodes.map((ep) => _buildEpisodeItem(ep)).toList(),
        ),
      ],
    );
  }

  Widget _buildEpisodeItem(Map<String, dynamic> ep) {
    final isCurrent = ep['isCurrent'] == true;
    final isCompleted = ep['isCompleted'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isCurrent ? AppColors.surfaceContainerHigh : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCurrent ? AppColors.primary : AppColors.hairline,
          width: isCurrent ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isCurrent ? 12 : 4),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openEpisodePlayer(ep),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isCurrent)
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'SEDANG DITONTON',
                        style: GoogleFonts.spaceGrotesk(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thumbnail
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: SizedBox(
                            width: 100,
                            height: 68,
                            child: Image.network(
                              ep['imageUrl'] as String,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Image.asset(ep['image'] as String, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(180),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              ep['duration'] as String,
                              style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        if (isCompleted)
                          Positioned.fill(
                            child: Container(
                              color: AppColors.primary.withAlpha(80),
                              child: const Center(
                                child: Icon(Icons.check_circle, color: Colors.white, size: 24),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Episode ${ep['number']}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: isCurrent ? AppColors.primary : AppColors.secondary,
                                ),
                              ),
                              if (isCompleted)
                                Row(
                                  children: [
                                    const Icon(Icons.check_circle, size: 12, color: AppColors.tertiary),
                                    const SizedBox(width: 3),
                                    Text('Selesai', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.tertiary, fontWeight: FontWeight.w600)),
                                  ],
                                )
                              else if (isCurrent)
                                Text(
                                  ep['timeLeft'] as String? ?? '',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary, fontWeight: FontWeight.w700),
                                ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            ep['title'] as String,
                            style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ep['speaker'] as String,
                            style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.secondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (isCurrent && ep['progress'] != null) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (ep['progress'] as num).toDouble(),
                      minHeight: 4,
                      backgroundColor: AppColors.surfaceContainerHighest,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  ep['summary'] as String,
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant, height: 1.35),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 4. BONUS MATERIALS & BEHIND THE SCENES
  // ==========================================
  Widget _buildBonusMaterialsSection() {
    final bonuses = [
      {'icon': Icons.map, 'title': 'Peta 3D Jalur Hijrah', 'desc': 'Topografi rute Gua Tsur ke Quba', 'action': 'Lihat Peta'},
      {'icon': Icons.menu_book, 'title': 'Diktat Sejarah PDF', 'desc': 'Rujukan Al-Bidayah wan-Nihayah', 'action': 'Unduh PDF'},
      {'icon': Icons.music_note, 'title': 'Soundtrack Qasidah', 'desc': 'Thala\'al Badru Alayna instrumen', 'action': 'Dengar'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Kajian Pendukung & Khazanah',
              style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
            Text(
              'Lihat Semua',
              style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          children: bonuses.map((b) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.hairline),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(b['icon'] as IconData, size: 20, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(b['title'] as String, style: GoogleFonts.syne(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                        Text(b['desc'] as String, style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.secondary)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${b['title']} dibuka.')));
                    },
                    child: Text(b['action'] as String, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ==========================================
  // 5. SANAD VERIFICATION FOOTER
  // ==========================================
  Widget _buildSanadVerificationFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.primaryFixed,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.verified_user, color: AppColors.primary, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'VERIFIKASI KEABSAHAN RIWAYAT',
            style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.0, color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(
            'Seluruh narasi serial ini ditinjau oleh Lembaga Penulisan Sirah Nabawiyah dan merujuk pada kitab klasik muktamad tanpa penambahan riwayat dha\'if syadid.',
            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant, height: 1.35),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
