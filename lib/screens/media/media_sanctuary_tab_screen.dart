import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/sanctuary_mode.dart';
import '../../theme/app_colors.dart';
import '../search/universal_search_sheet.dart';
import '../reels/reels_syiar_screen.dart';
import 'video_player_detail_screen.dart';
import 'docuseries_detail_screen.dart';

class MediaSanctuaryTabScreen extends StatefulWidget {
  final SanctuaryMode mode;

  const MediaSanctuaryTabScreen({
    super.key,
    this.mode = SanctuaryMode.general,
  });

  @override
  State<MediaSanctuaryTabScreen> createState() => _MediaSanctuaryTabScreenState();
}

class _MediaSanctuaryTabScreenState extends State<MediaSanctuaryTabScreen> {
  int _selectedCategoryIndex = 0;
  bool _isPlayingPodcast = true;
  final double _podcastProgress = 0.42;
  bool _isSpotlightBookmarked = false;

  bool get _isKids => widget.mode == SanctuaryMode.kids;

  final List<String> _kidsCategories = [
    'Semua',
    '✦ Kisah 25 Nabi',
    'Kartun Santri Cilik',
    'Doa & Nasyid Ceria',
    'Petualangan Sirah',
    'Murottal Juz Amma',
  ];

  final List<Map<String, dynamic>> _kidsReels = [
    {
      'title': 'Adab Makan Santri Cilik: Baca Bismillah & Tangan Kanan',
      'speaker': 'Kak Erlan Bercerita',
      'initials': 'KE',
      'duration': '0:48',
      'views': '84k',
      'likes': '19.2k',
      'image': 'assets/images/reel_1.png',
      'quote': 'Rasulullah ﷺ mengajarkan: Ucapkan bismillah, makan dengan tangan kanan, dan ambil yang terdekat.',
    },
    {
      'title': 'Doa Sebelum Tidur Bersuara & Menghalau Mimpi Buruk',
      'speaker': 'Kastari Animation & Nussa',
      'initials': 'KN',
      'duration': '0:55',
      'views': '142k',
      'likes': '38.6k',
      'image': 'assets/images/reel_2.png',
      'quote': 'Bismika Allahumma ahyaa wa amuwt. Tidur tenang dalam perlindungan para malaikat rahmat.',
    },
    {
      'title': 'Belajar Huruf Hijaiyah Ceria: Dari Alif Sampai Ya',
      'speaker': 'Lagu Santri Cilik',
      'initials': 'LS',
      'duration': '1:05',
      'views': '210k',
      'likes': '52.1k',
      'image': 'assets/images/reel_3.png',
      'quote': 'Alif, Ba, Ta, Tsa... Membaca satu huruf Al-Qur\'an mendatangkan sepuluh kebaikan berlipat!',
    },
    {
      'title': 'Kisah Kesabaran Nabi Ayyub \'Alaihissalam',
      'speaker': 'Animasi Sahabat Cilik',
      'initials': 'AC',
      'duration': '0:50',
      'views': '98k',
      'likes': '26.4k',
      'image': 'assets/images/kajian_1.png',
      'quote': 'Selalu bersyukur dan sabar dalam setiap keadaan, Allah pasti memberikan balasan terbaik.',
    },
    {
      'title': 'Murottal Surah Al-Ikhlas Merdu Khusus Anak',
      'speaker': 'Qari Cilik Ahmad',
      'initials': 'QA',
      'duration': '0:42',
      'views': '180k',
      'likes': '47.5k',
      'image': 'assets/images/podcast_malam.png',
      'quote': 'Katakanlah: Dialah Allah, Yang Maha Esa. Nilai pahala membacanya setara sepertiga Al-Qur\'an!',
    },
    {
      'title': 'Senyum Itu Sedekah: Berbagi Ceria dengan Teman',
      'speaker': 'Kak Farhan & Santri Noor',
      'initials': 'KF',
      'duration': '0:52',
      'views': '115k',
      'likes': '31.8k',
      'image': 'assets/images/mosque_hero.png',
      'quote': 'Tersenyum di hadapan saudaramu adalah sedekah termudah yang dicintai Allah.',
    },
  ];

  final List<Map<String, dynamic>> _kidsKajianList = [
    {
      'title': 'Kisah Nabi Musa & Laut Merah Terbelah (Animasi 3D)',
      'speaker': 'Kak Erlan & Santri Noor Animation',
      'category': 'Kisah 25 Nabi',
      'tag': 'Animasi 3D',
      'duration': '18:45',
      'features': 'Full HD • Ramah Balita & Anak',
      'image': 'assets/images/kajian_1.png',
    },
    {
      'title': 'Seri Rukun Islam: Mengapa Kita Harus Sholat 5 Waktu?',
      'speaker': 'Kak Erlan & Kastari Santri',
      'category': 'Adab & Ibadah Cilik',
      'tag': 'Edukasi Interaktif',
      'duration': '14:20',
      'features': 'Lembar Aktivitas PDF • Lagu Ceria',
      'image': 'assets/images/ustadzah_kajian.png',
    },
    {
      'title': 'Hafalan Doa Kedua Orang Tua Beserta Arti & Gerakan',
      'speaker': 'Ustadzah Ummu Rayyan',
      'category': 'Hafalan Doa Harian',
      'tag': 'Suara Jernih',
      'duration': '12:10',
      'features': 'Teks Latin & Arab • Bebas Iklan',
      'image': 'assets/images/mosque_hero.png',
    },
  ];

  List<String> get _currentCategories => _isKids ? _kidsCategories : _categories;
  List<Map<String, dynamic>> get _currentReels => _isKids ? _kidsReels : _reels;
  List<Map<String, dynamic>> get _currentKajianList => _isKids ? _kidsKajianList : _kajianList;

  final List<String> _categories = [
    'Semua',
    '✦ Reels Syiar',
    'Kajian Sinematik',
    'Sirah Docuseries',
    'Podcast Qolbu',
    'Murottal Visual',
  ];

  final List<Map<String, dynamic>> _reels = [
    {
      'title': 'Ketika Doamu Terasa Lambat Dijawab',
      'speaker': 'Ustzh. Halimah Alaydrus',
      'initials': 'HA',
      'duration': '0:58',
      'views': '128k',
      'likes': '24.5k',
      'image': 'assets/images/reel_1.png',
      'quote': 'Allah tidak pernah terlambat, Ia hanya mempersiapkan wadah hatimu agar cukup lapang menerima karunia-Nya.',
    },
    {
      'title': 'Adab Menjaga Hati di Ruang Sepi',
      'speaker': 'Ust. Hilman Fauzi',
      'initials': 'HF',
      'duration': '0:45',
      'views': '95k',
      'likes': '18.2k',
      'image': 'assets/images/reel_2.png',
      'quote': 'Di kala tak ada mata manusia memandang, di situlah keikhlasan sejati diuji dan dicatat malaikat.',
    },
    {
      'title': 'Sujud Terpanjang dalam Ujian Berat',
      'speaker': 'Syaikh Mishary Rashid',
      'initials': 'MR',
      'duration': '1:12',
      'views': '210k',
      'likes': '42.9k',
      'image': 'assets/images/reel_3.png',
      'quote': 'Makin dalam kepalamu menyentuh bumi, makin tinggi derajat doamu diangkat ke langit.',
    },
    {
      'title': 'Menata Hati Menghadapi Takdir & Ketetapan Ilahi',
      'speaker': 'Ust. Dr. Firanda Andirja',
      'initials': 'FA',
      'duration': '0:54',
      'views': '88k',
      'likes': '31.4k',
      'image': 'assets/images/kajian_1.png',
      'quote': 'Dua kenikmatan yang sering kali dilalaikan oleh manusia: kesehatan dan waktu luang.',
    },
    {
      'title': 'Menemukan Ketenangan di Sepertiga Malam',
      'speaker': 'Habib Nabiel Al-Musawa',
      'initials': 'HN',
      'duration': '0:50',
      'views': '67k',
      'likes': '19.8k',
      'image': 'assets/images/podcast_malam.png',
      'quote': 'Tetesan air mata yang jatuh karena takut dan cinta kepada Allah di hening malam kelak akan memadamkan siksa.',
    },
    {
      'title': 'Merengkuh Ampunan & Rahmat Ramadhan',
      'speaker': 'Ust. Adi Hidayat, Lc., M.A.',
      'initials': 'AH',
      'duration': '1:00',
      'views': '175k',
      'likes': '56.3k',
      'image': 'assets/images/mosque_hero.png',
      'quote': 'Jangan biarkan hari-hari Ramadhan berlalu tanpa peningkatan kualitas sholat dan taubatmu.',
    },
  ];

  final List<Map<String, dynamic>> _kajianList = [
    {
      'title': 'Menata Hati Menghadapi Takdir & Ketetapan Ilahi',
      'speaker': 'Ust. Dr. Firanda Andirja, Lc., M.A.',
      'category': 'Tazkiyatun Nafs',
      'tag': 'Sanad Sahih',
      'duration': '38:20',
      'features': 'Resume Tersedia • 1080p Full HD',
      'image': 'assets/images/kajian_1.png',
    },
    {
      'title': 'Fiqih Muamalah: Meraih Keberkahan Finansial Tanpa Riba',
      'speaker': 'Ust. Dr. Erwandi Tarmizi, M.A.',
      'category': 'Seri Ekonomi Syariah',
      'tag': 'Muamalah',
      'duration': '52:14',
      'features': 'Ringkasan PDF • Audio HQ',
      'image': 'assets/images/ustadzah_kajian.png',
    },
    {
      'title': 'Tafsir Surah Ar-Rahman: Merengkuh Kasih Sayang Ilahi',
      'speaker': 'Ustadz Dr. Firanda Andirja, Lc., M.A.',
      'category': 'Tafsir Tematik',
      'tag': 'Streaming Nabawi',
      'duration': '01:15:00',
      'features': 'Akses Bebas Biaya • Diktat PDF',
      'image': 'assets/images/mosque_hero.png',
    },
  ];

  void _openReelViewer([int index = 0]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReelsSyiarScreen(initialIndex: index),
      ),
    );
  }

  void _showUploadModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Unggah Syiar Kreatif',
                  style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
                Text(
                  'Bagikan video pendek, cuplikan tausiyah, atau rekaman audio tilawah',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.secondary),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.primaryFixed, shape: BoxShape.circle),
                    child: const Icon(Icons.videocam, color: AppColors.primary),
                  ),
                  title: const Text('Video Singkat (Reels 60 Detik)'),
                  subtitle: const Text('Format MP4, orientasi vertikal 9:16'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pilih file video dari galeri perangkat Anda.')),
                    );
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.secondaryFixed, shape: BoxShape.circle),
                    child: const Icon(Icons.audiotrack, color: AppColors.onSecondaryFixed),
                  ),
                  title: const Text('Audio Tilawah / Murottal Mandiri'),
                  subtitle: const Text('Format MP3 / M4A berkualitas tinggi'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pilih rekaman audio MP3 dari memori perangkat.')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 850;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: (isDesktop && !Navigator.canPop(context))
          ? null
          : AppBar(
              title: Row(
                children: [
                  Text(
                    _isKids ? 'Khazanah Media Anak' : 'Khazanah Media',
                    style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _isKids ? AppColors.tertiaryFixed : AppColors.primaryFixed,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _isKids ? '✦ Ruang Ceria Santri' : '✦ Video & Audio',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: _isKids ? AppColors.onTertiaryFixed : AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search_rounded, color: AppColors.primary),
                  tooltip: 'Pencarian Universal',
                  onPressed: () => showUniversalSearch(context),
                ),
              ],
            ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 1280 : 620),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                isDesktop ? 36 : 16,
                isDesktop ? 20 : 12,
                isDesktop ? 36 : 16,
                isDesktop ? 40 : 170, // 170px prevents bottom dock clipping
              ),
              child: isDesktop
                  // DESKTOP RESPONSIVE 2-COLUMN VIEW
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column (flex: 58): Spotlight Cinema Banner & Reels
                        Expanded(
                          flex: 58,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCategoryFilterTrack(),
                              const SizedBox(height: 20),
                              _buildSpotlightCinemaBanner(),
                              const SizedBox(height: 24),
                              _buildReelsSection(),
                              const SizedBox(height: 24),
                              _buildUploadBanner(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 28),
                        // Right Column (flex: 42): Curated Kajian & Night Podcast Player
                        Expanded(
                          flex: 42,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildNightPodcastCard(),
                              const SizedBox(height: 24),
                              _buildKajianListSection(),
                            ],
                          ),
                        ),
                      ],
                    )
                  // MOBILE SINGLE COLUMN VERTICAL FLOW
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCategoryFilterTrack(),
                        const SizedBox(height: 16),
                        _buildSpotlightCinemaBanner(),
                        const SizedBox(height: 24),
                        _buildReelsSection(),
                        const SizedBox(height: 24),
                        _buildKajianListSection(),
                        const SizedBox(height: 24),
                        _buildNightPodcastCard(),
                        const SizedBox(height: 20),
                        _buildUploadBanner(),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 1. CATEGORY FILTER TRACK
  // ==========================================
  Widget _buildCategoryFilterTrack() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _currentCategories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, idx) {
          final isSelected = _selectedCategoryIndex == idx;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedCategoryIndex = idx);
              if (idx == 1) {
                _openReelViewer(0);
              } else if (idx == 2) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const VideoPlayerDetailScreen()));
              } else if (idx == 3) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const DocuseriesDetailScreen()));
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(40),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  _currentCategories[idx],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ==========================================
  // 2. FEATURED CINEMA SPOTLIGHT BANNER
  // ==========================================
  Widget _buildSpotlightCinemaBanner() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const DocuseriesDetailScreen()));
      },
      child: Container(
        width: double.infinity,
        height: 380,
      decoration: BoxDecoration(
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
        child: Stack(
          children: [
            // Background Artwork
            Positioned.fill(
              child: Image.asset(
                'assets/images/media_spotlight.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
                errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/mosque_hero.png', fit: BoxFit.cover),
              ),
            ),
            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.primary.withAlpha(120),
                      AppColors.primary.withAlpha(245),
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(60),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.stars, color: Colors.amber, size: 13),
                            const SizedBox(width: 4),
                            Text(
                              _isKids ? 'ANIMASI SPESIAL ANAK • EPS 05' : 'EXCLUSIVE DOCUSERIES • EPS 04',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(80),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _isKids ? 'HD CERIA' : '4K HDR',
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isKids
                        ? 'Petualangan Bahtera Nabi Nuh & Pelangi Keimanan'
                        : 'Jejak Peradaban Hijrah: Cahaya di Tengah Madinah',
                    style: GoogleFonts.syne(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _isKids
                        ? 'Kisah penuh hikmah Nabi Nuh \'alaihissalam membangun bahtera besar dan menyelamatkan orang beriman serta hewan dari banjir bandang.'
                        : 'Menelusuri napak tilas persaudaraan Muhajirin & Anshar dengan rekonstruksi visual lanskap bersejarah secara mendalam.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      color: Colors.white.withAlpha(220),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Icon(Icons.schedule, color: Colors.white70, size: 13),
                      const SizedBox(width: 2),
                      Text(_isKids ? '24 Menit' : '42 Menit', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.white70)),
                      const Text(' • ', style: TextStyle(color: Colors.white54)),
                      Icon(_isKids ? Icons.face : Icons.person, color: Colors.white70, size: 13),
                      const SizedBox(width: 2),
                      Text(_isKids ? 'Kak Erlan Bercerita' : 'Ust. Salim A. Fillah', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.white70)),
                      const Text(' • ', style: TextStyle(color: Colors.white54)),
                      Text(
                        _isKids ? 'Khusus Santri Cilik' : 'Bebas Iklan',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.tertiaryFixed),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.play_arrow, size: 18),
                          label: Text(_isKids ? 'Tonton Cerita ✦' : 'Tonton Sekarang'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 4,
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const DocuseriesDetailScreen()));
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        style: IconButton.styleFrom(backgroundColor: Colors.white.withAlpha(50)),
                        icon: Icon(_isSpotlightBookmarked ? Icons.bookmark : Icons.bookmark_border, color: Colors.white),
                        onPressed: () {
                          setState(() => _isSpotlightBookmarked = !_isSpotlightBookmarked);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(_isSpotlightBookmarked ? 'Disimpan ke daftar putar.' : 'Dihapus dari daftar putar.')),
                          );
                        },
                      ),
                      IconButton(
                        style: IconButton.styleFrom(backgroundColor: Colors.white.withAlpha(50)),
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Tautan dokumenter disalin!')),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  // ==========================================
  // 3. REELS SYIAR 60 DETIK SECTION
  // ==========================================
  Widget _buildReelsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome, size: 14, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        _isKids ? 'Video Cilik 60 Detik' : 'Syiar 60 Detik',
                        style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _isKids
                        ? 'Kartun adab, doa & akhlak santri'
                        : 'Renungan qolbu vertikal berfaedah',
                    style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.secondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () => _openReelViewer(0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Lihat Semua', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  const SizedBox(width: 2),
                  const Icon(Icons.arrow_forward_ios, size: 10, color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _currentReels.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, idx) {
              final reel = _currentReels[idx];
              return GestureDetector(
                onTap: () => _openReelViewer(idx),
                child: Container(
                  width: 165,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(reel['image'] as String, fit: BoxFit.cover),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withAlpha(80),
                                  Colors.transparent,
                                  AppColors.primary.withAlpha(230),
                                ],
                                stops: const [0.0, 0.4, 1.0],
                              ),
                            ),
                          ),
                        ),
                        // Top info
                        Positioned(
                          top: 10,
                          left: 10,
                          right: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: Colors.black.withAlpha(80), borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  children: [
                                    const Icon(Icons.schedule, size: 10, color: Colors.white),
                                    const SizedBox(width: 3),
                                    Text(reel['duration'] as String, style: const TextStyle(color: Colors.white, fontSize: 9.5)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: Colors.black.withAlpha(80), borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  children: [
                                    const Icon(Icons.visibility, size: 10, color: Colors.white),
                                    const SizedBox(width: 3),
                                    Text(reel['views'] as String, style: const TextStyle(color: Colors.white, fontSize: 9.5)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Bottom text
                        Positioned(
                          bottom: 12,
                          left: 12,
                          right: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reel['title'] as String,
                                style: GoogleFonts.syne(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white, height: 1.25),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 9,
                                    backgroundColor: AppColors.secondaryFixed,
                                    child: Text(reel['initials'] as String, style: const TextStyle(fontSize: 7.5, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      reel['speaker'] as String,
                                      style: GoogleFonts.plusJakartaSans(fontSize: 9.5, color: Colors.white70),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 4. KAJIAN PILIHAN PEKAN INI SECTION
  // ==========================================
  Widget _buildKajianListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      _isKids ? 'Serial Kartun Santri' : 'Kajian Pilihan',
                      style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _isKids ? AppColors.tertiaryFixed : AppColors.secondaryFixed,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _isKids ? 'Anak Sholeh' : 'Tadabbur',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: _isKids ? AppColors.onTertiaryFixed : AppColors.onSecondaryFixed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            IconButton(
              icon: const Icon(Icons.tune, size: 18, color: AppColors.secondary),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 10),
        ..._currentKajianList.map((kajian) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VideoPlayerDetailScreen(
                    title: kajian['title'] as String,
                    speaker: kajian['speaker'] as String,
                    category: kajian['category'] as String,
                    duration: kajian['duration'] as String,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.hairline),
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      width: 100,
                      height: 85,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(kajian['image'] as String, fit: BoxFit.cover),
                          ),
                          Positioned.fill(
                            child: Container(color: Colors.black.withAlpha(50)),
                          ),
                          Center(
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: const Icon(Icons.play_arrow, size: 18, color: AppColors.primary),
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(color: Colors.black.withAlpha(160), borderRadius: BorderRadius.circular(4)),
                              child: Text(kajian['duration'] as String, style: const TextStyle(color: Colors.white, fontSize: 8.5)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Text details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                              decoration: BoxDecoration(color: AppColors.tertiaryFixed, borderRadius: BorderRadius.circular(6)),
                              child: Text(
                                kajian['tag'] as String,
                                style: GoogleFonts.plusJakartaSans(fontSize: 8.5, fontWeight: FontWeight.w700, color: AppColors.onTertiaryFixed),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              kajian['category'] as String,
                              style: GoogleFonts.plusJakartaSans(fontSize: 9.5, color: AppColors.secondary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          kajian['title'] as String,
                          style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurface, height: 1.25),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          kajian['speaker'] as String,
                          style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.onSurfaceVariant),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          kajian['features'] as String,
                          style: GoogleFonts.plusJakartaSans(fontSize: 9.5, color: AppColors.secondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ==========================================
  // 5. PODCAST TADABBUR MALAM PLAYER CARD
  // ==========================================
  Widget _buildNightPodcastCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryContainer,
            Color(0xFF2B3044),
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(40),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(_isKids ? Icons.auto_stories : Icons.bedtime, size: 16, color: AppColors.primaryFixed),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _isKids ? 'DONGENG TIDUR SANTRI' : 'TADABBUR MALAM',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                          color: AppColors.primaryFixed,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(35),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer, size: 11, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      'Sleep: 30m',
                      style: GoogleFonts.plusJakartaSans(fontSize: 9.5, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 58,
                  height: 58,
                  child: Image.asset('assets/images/podcast_malam.png', fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isKids
                          ? 'Kisah Burung Pipit Yang Terjaga & Pelajaran Sabar'
                          : 'Bisikan Doa Penghantar Tidur (Al-Mulk & Dzikir)',
                      style: GoogleFonts.syne(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _isKids
                          ? 'Kak Erlan Bercerita (Narasi Audio Ramah Anak)'
                          : 'Suara Merdu Maqam Bayati Khusyu',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.primaryFixed),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _isKids
                          ? '15 Menit • Menenangkan Hati Sebelum Lelap'
                          : '24 Menit • Gelombang Theta Relaksasi',
                      style: GoogleFonts.plusJakartaSans(fontSize: 9.5, color: Colors.white60),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _podcastProgress,
              minHeight: 5,
              backgroundColor: Colors.white.withAlpha(40),
              color: AppColors.primaryFixed,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('09:48', style: GoogleFonts.spaceGrotesk(fontSize: 9.5, color: Colors.white60)),
              Text('24:00', style: GoogleFonts.spaceGrotesk(fontSize: 9.5, color: Colors.white60)),
            ],
          ),
          const SizedBox(height: 10),
          // Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.shuffle, color: AppColors.primaryFixed, size: 20),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.replay_10, color: Colors.white, size: 22),
                onPressed: () {},
              ),
              GestureDetector(
                onTap: () {
                  setState(() => _isPlayingPodcast = !_isPlayingPodcast);
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: Icon(
                    _isPlayingPodcast ? Icons.pause : Icons.play_arrow,
                    color: AppColors.primary,
                    size: 26,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.forward_30, color: Colors.white, size: 22),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.volume_up, color: AppColors.primaryFixed, size: 20),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 6. SYIAR KREATIF & UPLOAD BANNER
  // ==========================================
  Widget _buildUploadBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: AppColors.tertiaryFixed, shape: BoxShape.circle),
            child: const Icon(Icons.auto_awesome, color: AppColors.onTertiaryFixed, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isKids ? 'Celengan Kreasi Santri Cilik' : 'Syiar Kreatif & Ruang Berbagi',
                  style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
                Text(
                  _isKids
                      ? 'Kirimkan gambar mewarnai, rekaman hafalan juz amma, atau nasyid anak Anda'
                      : 'Bagikan cuplikan hikmah atau audio doa tanpa distraksi iklan',
                  style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              elevation: 0,
            ),
            onPressed: _showUploadModal,
            child: Text(_isKids ? 'Kirim Karya' : 'Unggah', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
