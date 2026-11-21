import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/islamic_content.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

enum KnowledgeModuleType {
  kisahNabi,
  hadits,
  asmaulHusna,
  generatorMutiara,
  silsilahSanad,
  doaHarian,
  tajwidVisual;

  String get title {
    switch (this) {
      case KnowledgeModuleType.kisahNabi:
        return 'Kisah 25 Sirah Nabawi';
      case KnowledgeModuleType.hadits:
        return 'Ensiklopedia Hadits Shahih';
      case KnowledgeModuleType.asmaulHusna:
        return 'Al-Asma\'ul Husna';
      case KnowledgeModuleType.generatorMutiara:
        return 'Generator Kartu Mutiara';
      case KnowledgeModuleType.silsilahSanad:
        return 'Pohon Silsilah Sanad';
      case KnowledgeModuleType.doaHarian:
        return 'Kumpulan Doa Harian';
      case KnowledgeModuleType.tajwidVisual:
        return 'Tajwid Visual & Makharij';
    }
  }

  String get subtitle {
    switch (this) {
      case KnowledgeModuleType.kisahNabi:
        return 'Tarikh, Keteladanan Akhlak, & Manuskrip Sahabat';
      case KnowledgeModuleType.hadits:
        return 'Bukhari & Muslim Sanad Terverifikasi Mu\'tamad';
      case KnowledgeModuleType.asmaulHusna:
        return '99 Nama Agung & Audio Talaqqi Khusyu\'';
      case KnowledgeModuleType.generatorMutiara:
        return 'Desain Kartu Ayat & Hadits Story 9:16 Siap Bagikan';
      case KnowledgeModuleType.silsilahSanad:
        return 'Visualisasi Isnad Transmisi & Rantai Rawi Tsiqah';
      case KnowledgeModuleType.doaHarian:
        return 'Hisnul Muslim & Munajat Ma\'tsur Pilihan';
      case KnowledgeModuleType.tajwidVisual:
        return 'Hukum Nun Sukun, Mad, & Sifat Huruf';
    }
  }

  IconData get icon {
    switch (this) {
      case KnowledgeModuleType.kisahNabi:
        return Icons.history_edu;
      case KnowledgeModuleType.hadits:
        return Icons.menu_book;
      case KnowledgeModuleType.asmaulHusna:
        return Icons.stars;
      case KnowledgeModuleType.generatorMutiara:
        return Icons.auto_awesome;
      case KnowledgeModuleType.silsilahSanad:
        return Icons.account_tree;
      case KnowledgeModuleType.doaHarian:
        return Icons.self_improvement;
      case KnowledgeModuleType.tajwidVisual:
        return Icons.hearing;
    }
  }

  Color get color {
    switch (this) {
      case KnowledgeModuleType.kisahNabi:
        return AppColors.mistySage;
      case KnowledgeModuleType.hadits:
        return AppColors.powderBlue;
      case KnowledgeModuleType.asmaulHusna:
        return AppColors.softPeriwinkle;
      case KnowledgeModuleType.generatorMutiara:
        return AppColors.lavender;
      case KnowledgeModuleType.silsilahSanad:
        return AppColors.secondaryContainer;
      case KnowledgeModuleType.doaHarian:
        return AppColors.blushPink;
      case KnowledgeModuleType.tajwidVisual:
        return AppColors.surfaceContainerHigh;
    }
  }
}

class CommunityStoryItem {
  final String title;
  final String category;
  final String author;
  final String reference;
  final String excerpt;
  final String fullContent;
  final String status;
  final String readTime;

  CommunityStoryItem({
    required this.title,
    required this.category,
    required this.author,
    required this.reference,
    required this.excerpt,
    required this.fullContent,
    this.status = 'Terverifikasi Sanad',
    this.readTime = '5 mnt baca',
  });
}

class SanadNode {
  final int id;
  final String title;
  final String name;
  final String era;
  final String jarhGrade;
  final String dhabithLevel;
  final String bio;
  final String teachers;
  final String students;
  final IconData icon;

  const SanadNode({
    required this.id,
    required this.title,
    required this.name,
    required this.era,
    required this.jarhGrade,
    required this.dhabithLevel,
    required this.bio,
    required this.teachers,
    required this.students,
    required this.icon,
  });
}

class KnowledgeModuleSheet extends StatefulWidget {
  final KnowledgeModuleType initialType;

  const KnowledgeModuleSheet({
    super.key,
    required this.initialType,
  });

  @override
  State<KnowledgeModuleSheet> createState() => _KnowledgeModuleSheetState();
}

class _KnowledgeModuleSheetState extends State<KnowledgeModuleSheet> {
  late KnowledgeModuleType _activeType;
  String _searchQuery = '';

  // ---------------- Kisah 25 Nabi State ----------------
  String _selectedStoryCategory = 'Semua Kisah';
  final Set<String> _bookmarkedStories = {'Nabi Yusuf AS', 'Khadijah binti Khuwailid'};
  String? _audioPlayingStory;

  final List<CommunityStoryItem> _communityStories = [
    CommunityStoryItem(
      title: 'Maryam binti Imran — Simbol Kesucian & Keteguhan Menghadapi Ujian Kaumnya',
      category: 'Wanita Mulia Surga',
      author: 'Maryam Al-Kindi',
      reference: 'Tafsir Ibnu Katsir Juz 16, Surat Maryam',
      excerpt: 'Meneladani keheningan dan tawakal mutlak ibunda Nabi Isa AS tatkala menanggung amanah risalah di bawah pohon kurma.',
      fullContent: 'Kisah keteguhan Sayyidah Maryam merupakan inspirasi tertinggi bagi setiap jiwa mukminah saat menghadapi ujian prasangka manusia...',
      status: 'Terverifikasi Mu\'tamad',
      readTime: '6 mnt baca',
    ),
    CommunityStoryItem(
      title: 'Shalahuddin Al-Ayyubi — Pembebas Baitul Maqdis yang Lembut Hati pada Musuh',
      category: 'Peradaban & Hikmah Klasik',
      author: 'Ahmad Fatih',
      reference: 'An-Nawadir As-Sulthaniyyah lil Qadhi Ibnu Syaddad',
      excerpt: 'Membuktikan keluhuran peradaban Islam di medan perang melalui pengampunan massal dan keadilan syari\'ah.',
      fullContent: 'Tatkala bala tentara Shalahuddin memasuki Yerusalem, tidak ada setetes darah pun yang ditumpahkan tanpa hak...',
      status: 'Terverifikasi Mu\'tamad',
      readTime: '8 mnt baca',
    ),
  ];

  // ---------------- Hadits Shahih State ----------------
  String _selectedHadithKitab = 'Semua';
  String _selectedHadithTopic = 'Semua';
  bool _faedahAccordionOpen = true;
  bool _isHadithAudioPlaying = false;

  final List<Map<String, dynamic>> _customSubmittedHadiths = [];

  // ---------------- Asmaul Husna State ----------------
  String _selectedAsmaulCategory = 'Semua (99)';
  final Set<int> _memorizedAsmaul = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24};
  int _arRahmanDzikirCount = 0;
  bool _isPlayingTalaqqiAll = false;
  int _talaqqiCurrentNumber = 1;

  // ---------------- Generator Kartu Mutiara State ----------------
  int _selectedQuoteIndex = 0;
  String _quoteAspectRatio = '9:16';
  String _quotePalette = 'Ethereal';
  double _quoteFontSize = 18.0;
  TextAlign _quoteAlignment = TextAlign.center;

  final List<Map<String, String>> _quotePresets = [
    {
      'surah': 'QS. Yusuf: 92',
      'theme': 'Puncak Maaf & Kelapangan Hati',
      'arabic': 'لَا تَثْرِيبَ عَلَيْكُمُ الْيَوْمَ ۖ يَغْفِرُ اللَّهُ لَكُمْ ۖ وَهُوَ أَرْحَمُ الرَّاحِمِينَ',
      'translation': '"Pada hari ini tidak ada cercaan terhadap kamu, mudah-mudahan Allah mengampuni kamu, dan Dia Maha Penyayang di antara para penyayang."',
      'contemplation': 'Memaafkan bukan berarti melupakan, melainkan membebaskan qolbu dari kepahitan dendam.',
    },
    {
      'surah': 'QS. Yusuf: 18',
      'theme': 'Sabar yang Indah (Shabr Jamil)',
      'arabic': 'فَصَبْرٌ جَمِيلٌ ۖ وَاللَّهُ الْمُسْتَعَانُ عَلَىٰ مَا تَصِفُونَ',
      'translation': '"Maka kesabaran yang baik itulah (kesabaranku). Dan Allah sajalah tempat memohon pertolongan terhadap apa yang kamu ceritakan."',
      'contemplation': 'Sabar jamil adalah sabar tanpa keluh kesah kepada makhluk, hanya berserah seutuhnya pada Rabbul \'Alamin.',
    },
    {
      'surah': 'QS. Al-Insyirah: 5-6',
      'theme': 'Kemudahan Bersama Kesulitan',
      'arabic': 'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا ﴿٥﴾ إِنَّ مَعَ الْعُسْرِ يُسْرًا ﴿٦﴾',
      'translation': '"Maka sesungguhnya beserta kesulitan ada kemudahan. Sesungguhnya beserta kesulitan ada kemudahan."',
      'contemplation': 'Satu kesulitan tidak akan pernah mampu mengalahkan dua kemudahan yang telah Allah janjikan.',
    },
    {
      'surah': 'HR. Muslim #2564',
      'theme': 'Integritas Qolbu & Amal',
      'arabic': 'إِنَّ اللَّهَ لَا يَنْظُرُ إِلَىٰ صُوَرِكُمْ وَأَمْوَالِكُمْ وَلَٰكِنْ يَنْظُرُ إِلَىٰ قُلُوبِكُمْ وَأَعْمَالِكُمْ',
      'translation': '"Sesungguhnya Allah tidak melihat kepada rupa dan harta kalian, melainkan Dia memandang kepada hati dan amalan kalian."',
      'contemplation': 'Pandangan Allah menembus ke kedalaman niat, bukan polesan lahiriah yang fana.',
    },
  ];

  // ---------------- Silsilah Sanad State ----------------
  int _selectedSanadNodeIndex = 1; // Umar bin Al-Khattab RA
  final List<SanadNode> _sanadChain = const [
    SanadNode(
      id: 0,
      title: 'Sumber Risalah',
      name: 'Rasulullah ﷺ',
      era: 'Madinah Al-Munawwarah (11 H)',
      jarhGrade: 'Ma\'shum (Terjaga dari Khilaf)',
      dhabithLevel: 'Kebenaran Mutlak Wahyu',
      bio: 'Nabi dan Rasul terakhir yang menyampaikan sunnah dan wahyu Al-Qur\'an secara sempurna.',
      teachers: 'Malaikat Jibril AS (dari Allah SWT)',
      students: 'Seluruh Shahabat Ridwanullahi \'Alaihim',
      icon: Icons.brightness_high,
    ),
    SanadNode(
      id: 1,
      title: 'Shahabat Nabi',
      name: 'Umar bin Al-Khattab RA',
      era: 'Khalifah Rasyid II (23 H)',
      jarhGrade: 'Shahabat Kulluhum \'Udul (Keadilan Mutlak)',
      dhabithLevel: 'Hafalan Kuat & Faruq Pemisah Haq-Bathil',
      bio: 'Amirul Mukminin yang meriwayatkan hadits utama niat langsung di atas mimbar Nabi di Madinah.',
      teachers: 'Rasulullah SAW',
      students: '\'Alqamah bin Waqqash, Ibnu Umar, Ibnu Abbas',
      icon: Icons.shield,
    ),
    SanadNode(
      id: 2,
      title: 'Tabi\'in Senior',
      name: '\'Alqamah bin Waqqash Al-Laitsi',
      era: 'Madinah (Wafat ~70 H)',
      jarhGrade: 'Tsiqah Thabt (Kredibel & Sangat Teliti)',
      dhabithLevel: 'Imam Hujjah Kalangan Madinah',
      bio: 'Tokoh tabi\'in utama yang mendengar langsung khutbah Umar tentang niat tanpa perantara.',
      teachers: 'Umar bin Al-Khattab, Aisyah RA, Mu\'awiyah',
      students: 'Muhammad bin Ibrahim At-Taimi, Az-Zuhri',
      icon: Icons.psychology,
    ),
    SanadNode(
      id: 3,
      title: 'Tabi\'in Pertengahan',
      name: 'Muhammad bin Ibrahim At-Taimi',
      era: 'Madinah (Wafat 120 H)',
      jarhGrade: 'Tsiqah Ma\'mun (Terpercaya & Kokoh)',
      dhabithLevel: 'Mutqin (Akurasi Tinggi)',
      bio: 'Menjadi satu-satunya jalur periwayatan yang meneruskan riwayat niat dari \'Alqamah pada zamannya.',
      teachers: '\'Alqamah bin Waqqash, Jabir bin Abdillah',
      students: 'Yahya bin Sa\'id Al-Anshari, Malik bin Anas',
      icon: Icons.school,
    ),
    SanadNode(
      id: 4,
      title: 'Atba\'ut Tabi\'in',
      name: 'Yahya bin Sa\'id Al-Anshari',
      era: 'Madinah & Kufah (Wafat 143 H)',
      jarhGrade: 'Imam Kebangkitan Hadits (Tsiqah Hujjah)',
      dhabithLevel: 'Dhabith Mutlaq (Presisi Tinggi)',
      bio: 'Qadhi Madinah yang meriwayatkan hadits niat ke lebih dari 200 rawi generasi berikutnya.',
      teachers: 'Muhammad bin Ibrahim At-Taimi, Anas bin Malik',
      students: 'Sufyan Ats-Tsauri, Sufyan bin \'Uyainah, Malik',
      icon: Icons.gavel,
    ),
    SanadNode(
      id: 5,
      title: 'Guru Imam Bukhari',
      name: 'Al-Humaidi (Abdullah bin Az-Zubair)',
      era: 'Makkah Al-Mukarramah (Wafat 219 H)',
      jarhGrade: 'Faqih Makkah & Tsiqah Thabt',
      dhabithLevel: 'Hafidz Mutqin Ashab As-Sunnah',
      bio: 'Pemberi riwayat hadits pertama nomor 1 dalam Shahih Bukhari dari jalur Sufyan bin \'Uyainah.',
      teachers: 'Sufyan bin \'Uyainah, Fudhail bin \'Iyadh',
      students: 'Imam Al-Bukhari, Abu Zur\'ah Ar-Razi',
      icon: Icons.menu_book,
    ),
    SanadNode(
      id: 6,
      title: 'Al-Mukharrij (Penyusun Kitab)',
      name: 'Imam Abu Abdillah Muhammad bin Ismail Al-Bukhari',
      era: 'Bukhara & Naisabur (194 - 256 H)',
      jarhGrade: 'Amirul Mukminin fil Hadits',
      dhabithLevel: 'Puncak Kedhabithan Dunia Islam',
      bio: 'Menyeleksi 600.000 hadits dengan kriteria sanad bersambung, liqa\' (pertemuan nyata), dan perawi \'adil dhabith.',
      teachers: 'Al-Humaidi, Ahmad bin Hanbal, Ishaq bin Rahawaih',
      students: 'Imam Muslim, Imam At-Tirmidzi, Imam An-Nasa\'i',
      icon: Icons.verified,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _activeType = widget.initialType;
  }

  void _copyToClipboard(String text, String message) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 32 : 12,
        vertical: isDesktop ? 24 : 12,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isDesktop ? 960 : 640,
          maxHeight: isDesktop ? 860 : MediaQuery.of(context).size.height * 0.94,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppColors.hairline),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(28),
              blurRadius: 40,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Column(
            children: [
              // ---------------- TOP APP BAR ----------------
              _buildTopHeader(),

              // ---------------- HORIZONTAL TAB SELECTOR ----------------
              _buildTabSelector(),

              const Divider(color: AppColors.surfaceContainerHigh, height: 1),

              // ---------------- MAIN CONTENT VIEW ----------------
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isDesktop ? 24 : 16),
                  child: _buildActiveTabContent(isDesktop),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // TOP HEADER
  // ===========================================================================
  Widget _buildTopHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: const Border(bottom: BorderSide(color: AppColors.hairline)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _activeType.color,
              shape: BoxShape.circle,
            ),
            child: Icon(_activeType.icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        _activeType.title,
                        style: GoogleFonts.syne(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryFixed,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Verifikasi Mu\'tamad',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  _activeType.subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Action Buttons depending on tab
          if (_activeType == KnowledgeModuleType.kisahNabi)
            ElevatedButton.icon(
              icon: const Icon(Icons.add_circle, size: 16),
              label: const Text('Tulis Cerita'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                textStyle: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700),
                elevation: 1,
              ),
              onPressed: _openSubmitStoryModal,
            )
          else if (_activeType == KnowledgeModuleType.hadits)
            ElevatedButton.icon(
              icon: const Icon(Icons.rate_review, size: 16),
              label: const Text('+ Kontribusi Hadits'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                textStyle: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700),
                elevation: 1,
              ),
              onPressed: _openSubmitHadithModal,
            ),
          const SizedBox(width: 6),
          IconButton(
            tooltip: 'Tutup',
            icon: const Icon(Icons.close, color: AppColors.secondary, size: 22),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // HORIZONTAL TAB SELECTOR
  // ===========================================================================
  Widget _buildTabSelector() {
    return Container(
      color: AppColors.surfaceContainerLow.withAlpha(120),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: KnowledgeModuleType.values.map((t) {
            final isSelected = t == _activeType;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _activeType = t;
                    _searchQuery = '';
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.hairline,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withAlpha(35),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        t.icon,
                        size: 14,
                        color: isSelected ? AppColors.onPrimary : AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        t.name == 'kisahNabi'
                            ? 'Kisah 25 Nabi'
                            : t.name == 'hadits'
                                ? 'Hadits Shahih'
                                : t.name == 'asmaulHusna'
                                    ? 'Asmaul Husna'
                                    : t.name == 'generatorMutiara'
                                        ? 'Generator 9:16'
                                        : t.name == 'silsilahSanad'
                                            ? 'Silsilah Sanad'
                                            : t.name == 'doaHarian'
                                                ? 'Doa Harian'
                                                : 'Tajwid Visual',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isSelected ? AppColors.onPrimary : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ===========================================================================
  // CONTENT SWITCHER
  // ===========================================================================
  Widget _buildActiveTabContent(bool isDesktop) {
    switch (_activeType) {
      case KnowledgeModuleType.kisahNabi:
        return _buildKisahNabiView(isDesktop);
      case KnowledgeModuleType.hadits:
        return _buildHaditsView(isDesktop);
      case KnowledgeModuleType.asmaulHusna:
        return _buildAsmaulHusnaView(isDesktop);
      case KnowledgeModuleType.generatorMutiara:
        return _buildGeneratorMutiaraView(isDesktop);
      case KnowledgeModuleType.silsilahSanad:
        return _buildSilsilahSanadView(isDesktop);
      case KnowledgeModuleType.doaHarian:
        return _buildDoaHarianView();
      case KnowledgeModuleType.tajwidVisual:
        return _buildTajwidVisualView();
    }
  }

  // ===========================================================================
  // 1. KISAH 25 NABI & SIRAH VIEW (Faithful to Stitch Design)
  // ===========================================================================
  Widget _buildKisahNabiView(bool isDesktop) {
    final categories = [
      'Semua Kisah',
      '25 Nabi & Rasul',
      'Kisah Sahabat',
      'Wanita Mulia Surga',
      'Peradaban & Hikmah Klasik',
      'Kisah Komunitas',
    ];

    final filteredNabi = IslamicDataRepository.sampleKisahNabi.where((k) {
      final matchesSearch = k.name.toLowerCase().contains(_searchQuery) ||
          k.title.toLowerCase().contains(_searchQuery) ||
          k.summary.toLowerCase().contains(_searchQuery);
      if (!matchesSearch) return false;
      if (_selectedStoryCategory == '25 Nabi & Rasul') return true;
      if (_selectedStoryCategory == 'Kisah Komunitas') return false;
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Editorial Sanctuary Intro Card
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Edisi Khazanah Ruhani',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.verified, size: 14, color: AppColors.tertiary),
                  const SizedBox(width: 4),
                  Text(
                    'Kurasi Sanad & Tarikh',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Kisah Para Nabi & Hikmah Islam',
                style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
              const SizedBox(height: 6),
              Text(
                'Menelusuri keteladanan agung 25 Nabi, kemuliaan shahabat, shahabiyah, dan jejak peradaban yang berakar dari riwayat mu\'tamad.',
                style: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: AppColors.onSurfaceVariant, height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Verification & Ethical Submission Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.tertiaryFixed,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.policy, color: AppColors.tertiary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Panduan Integritas Kisah Islami',
                      style: GoogleFonts.syne(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.onTertiaryFixed),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Setiap tulisan dari kontributor ditelaah oleh asatidzah berpedoman pada kitab mu\'tabar (Tarikh Ath-Thabari & Al-Bidayah wan-Nihayah).',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onTertiaryFixed.withAlpha(200), height: 1.35),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _openStandarSanadModal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Standar Sanad & Mu\'tamad',
                            style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward, size: 12, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Search Bar & Filter Chips
        TextField(
          onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
          style: GoogleFonts.plusJakartaSans(fontSize: 12),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.secondary),
            hintText: 'Cari nama Nabi, kisah sahabat, atau tema hikmah...',
            filled: true,
            fillColor: AppColors.surfaceContainerLow,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 12),

        // Horizontal Category Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((c) {
              final isSel = _selectedStoryCategory == c;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(c),
                  selected: isSel,
                  onSelected: (val) => setState(() => _selectedStoryCategory = c),
                  labelStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                    color: isSel ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                  ),
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surfaceContainerLow,
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 18),

        // FEATURED SPOTLIGHT CARD: Nabi Yusuf AS
        if (_selectedStoryCategory == 'Semua Kisah' || _selectedStoryCategory == '25 Nabi & Rasul')
          _buildSpotlightNabawiCard(),

        const SizedBox(height: 18),

        // Curated Stories List
        Text(
          'Kisah Teladan Utama',
          style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
        ),
        const SizedBox(height: 10),
        Column(
          children: filteredNabi.map((k) => _buildKisahNabiCard(k)).toList(),
        ),

        const SizedBox(height: 20),

        // Community Verified Highlights Strip
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.groups, size: 18, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  'Karya Komunitas Terkurasi (${_communityStories.length} Naskah)',
                  style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ],
            ),
            InkWell(
              onTap: _openSubmitStoryModal,
              child: Text(
                '+ Kirim Naskah',
                style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          children: _communityStories.map((cs) => _buildCommunityStoryCard(cs)).toList(),
        ),

        const SizedBox(height: 24),

        // Bottom Prominent CTA: Kirimkan Naskah Cerita Islami
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.verified_user, size: 18),
            label: const Text('Kirimkan Naskah Cerita Islami (Review 2x24 Jam)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              textStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
              elevation: 2,
            ),
            onPressed: _openSubmitStoryModal,
          ),
        ),
      ],
    );
  }

  Widget _buildSpotlightNabawiCard() {
    final isBookmarked = _bookmarkedStories.contains('Nabi Yusuf AS');
    final isPlaying = _audioPlayingStory == 'Nabi Yusuf AS';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header image / ambient gradient banner
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryContainer],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(40),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '⭐ Spotlight Nabawi • 8 Menit Baca',
                        style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          if (isBookmarked) {
                            _bookmarkedStories.remove('Nabi Yusuf AS');
                          } else {
                            _bookmarkedStories.add('Nabi Yusuf AS');
                          }
                        });
                      },
                    ),
                  ],
                ),
                Text(
                  'Nabi Yusuf \'Alaihissalam',
                  style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Puncak Keindahan Akhlak, Ujian Syahwat, & Kemenangan Maaf',
                  style: GoogleFonts.plusJakartaSans(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
                const SizedBox(height: 6),
                Text(
                  'Kisah terbaik (Ahsanul Qashash) tentang kesabaran dalam sumur pengkhianatan saudara, keteguhan hati menolak rayuan Zulaikha di kamar tertutup, hingga tahta Mesir yang diiringi sujud syukur keluarga.',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.onSurfaceVariant, height: 1.45),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.headphones, size: 16),
                        label: Text(isPlaying ? 'Jeda Narasi' : 'Dengarkan Narasi (Audio)'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          textStyle: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                        onPressed: () {
                          setState(() {
                            _audioPlayingStory = isPlaying ? null : 'Nabi Yusuf AS';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.share_outlined, size: 20, color: AppColors.secondary),
                      onPressed: () => _copyToClipboard(
                        'Kisah Nabi Yusuf AS - Ahsanul Qashash di Noor Sanctuary',
                        'Tautan kisah berhasil disalin!',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKisahNabiCard(KisahNabiItem k) {
    final isBookmarked = _bookmarkedStories.contains(k.name);
    final isPlaying = _audioPlayingStory == k.name;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.mistySage,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.history_edu, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      k.name,
                      style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                    Text(
                      k.era,
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  size: 18,
                  color: isBookmarked ? AppColors.primary : AppColors.secondary,
                ),
                onPressed: () {
                  setState(() {
                    if (isBookmarked) {
                      _bookmarkedStories.remove(k.name);
                    } else {
                      _bookmarkedStories.add(k.name);
                    }
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            k.title,
            style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.onSurface),
          ),
          const SizedBox(height: 4),
          Text(
            k.summary,
            style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.onSurfaceVariant, height: 1.4),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.mistySage.withAlpha(120),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline, size: 15, color: AppColors.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Hikmah: ${k.keyLesson}',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: Icon(isPlaying ? Icons.pause : Icons.volume_up_outlined, size: 14),
                label: Text(isPlaying ? 'Jeda Audio' : 'Audio Riwayat'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  textStyle: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  setState(() {
                    _audioPlayingStory = isPlaying ? null : k.name;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityStoryCard(CommunityStoryItem cs) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  cs.category,
                  style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.tertiaryFixed,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified, size: 11, color: AppColors.tertiary),
                    const SizedBox(width: 3),
                    Text(
                      cs.status,
                      style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.onTertiaryFixed),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            cs.title,
            style: GoogleFonts.syne(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(
            cs.excerpt,
            style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.onSurfaceVariant, height: 1.35),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Penulis: ${cs.author} • Rujukan: ${cs.reference}',
                style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // MODAL: FORM KONTRIBUSI CERITA & TARIKH (The Key Feature User Requested)
  // ===========================================================================
  void _openSubmitStoryModal() {
    final titleController = TextEditingController();
    final refController = TextEditingController();
    final contentController = TextEditingController();
    String selectedCategory = '25 Nabi & Rasul';
    bool isAgreed = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.88,
              ),
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.verified_user, color: AppColors.primary, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              'Kirimkan Kisah Islami',
                              style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Syarat Ketat Ringkas
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.priority_high, size: 16, color: AppColors.error),
                              const SizedBox(width: 4),
                              Text(
                                'Syarat Wajib Publikasi Manuskrip:',
                                style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '• Merujuk kitab muktabar (Tarikh Thabari, Al-Bidayah wan-Nihayah, Siyar A\'lam Nubala).\n• Nol unsur cerita khayalan, fiktif, atau israiliyyat mungkar.\n• Tim kurasi asatidzah akan meninjau sanad & redaksi dalam 2x24 jam.',
                            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Input Judul Kisah
                    Text(
                      'Judul Kisah',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: titleController,
                      style: GoogleFonts.plusJakartaSans(fontSize: 12.5),
                      decoration: InputDecoration(
                        hintText: 'Contoh: Kesetiaan Abu Bakar Ash-Siddiq di Gua Tsur',
                        filled: true,
                        fillColor: AppColors.surfaceContainerLow,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Kategori & Sumber Kitab
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kategori Tokoh',
                                style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedCategory,
                                    isExpanded: true,
                                    style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.onSurface),
                                    items: [
                                      '25 Nabi & Rasul',
                                      'Khulafaur Rasyidin',
                                      'Shahabiyah & Wanita Surga',
                                      'Ulama & Pejuang Tarikh',
                                    ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                                    onChanged: (val) {
                                      if (val != null) setModalState(() => selectedCategory = val);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sumber Kitab Mu\'tamad',
                                style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: refController,
                                style: GoogleFonts.plusJakartaSans(fontSize: 12),
                                decoration: InputDecoration(
                                  hintText: 'Kitab & juz/halaman',
                                  filled: true,
                                  fillColor: AppColors.surfaceContainerLow,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Multiline Naskah
                    Text(
                      'Naskah / Ulasan Hikmah',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: contentController,
                      maxLines: 4,
                      style: GoogleFonts.plusJakartaSans(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: 'Tuliskan kisah dengan tutur santun, menyentuh, dan berpedoman pada keabsahan tarikh...',
                        filled: true,
                        fillColor: AppColors.surfaceContainerLow,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Checkbox Syariat
                    Row(
                      children: [
                        Checkbox(
                          value: isAgreed,
                          activeColor: AppColors.primary,
                          onChanged: (val) => setModalState(() => isAgreed = val ?? false),
                        ),
                        Expanded(
                          child: Text(
                            'Saya bersaksi naskah ini bebas dari riwayat bathil dan plagiat.',
                            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.send, size: 16),
                        label: const Text('Kirim untuk Review 2x24 Jam'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          textStyle: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700),
                        ),
                        onPressed: () {
                          if (titleController.text.trim().isEmpty || contentController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Harap lengkapi judul dan naskah cerita!')),
                            );
                            return;
                          }
                          if (!isAgreed) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Harap centang persetujuan bebas riwayat bathil!')),
                            );
                            return;
                          }

                          setState(() {
                            _communityStories.insert(
                              0,
                              CommunityStoryItem(
                                title: titleController.text.trim(),
                                category: selectedCategory,
                                author: 'Ummu Rayyan (Anda)',
                                reference: refController.text.trim().isEmpty ? 'Rujukan Mu\'tamad' : refController.text.trim(),
                                excerpt: contentController.text.trim().length > 100
                                    ? '${contentController.text.trim().substring(0, 100)}...'
                                    : contentController.text.trim(),
                                fullContent: contentController.text.trim(),
                                status: 'Menunggu Review (2x24 Jam)',
                                readTime: '5 mnt baca',
                              ),
                            );
                          });

                          Navigator.pop(ctx);
                          _copyToClipboard('', 'Jazakallahu khair! Naskah Anda telah masuk antrean moderasi Syar\'i.');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ===========================================================================
  // MODAL: STANDAR MODERASI SYAR'I
  // ===========================================================================
  void _openStandarSanadModal() {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: AppColors.surfaceContainerLowest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 540,
              maxHeight: MediaQuery.of(ctx).size.height * 0.88,
            ),
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Standar Moderasi Syar\'i',
                        style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '4 Pilar Verifikasi Manuskrip Noor Sanctuary:',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                  const SizedBox(height: 10),
                  _buildRuleItem('1. Rujukan Mu\'tabar', 'Wajib menyertakan kutipan dari kitab tarikh primer: Tarikh Ath-Thabari, Al-Bidayah wan-Nihayah Ibnu Katsir, atau Siyar A\'lam An-Nubala Adz-Dzahabi.'),
                  _buildRuleItem('2. Filtrasi Israiliyyat', 'Menolak mutlak cerita dongeng tambahan atau kisah israiliyyat yang bertentangan dengan kemuliaan (ishmatul anbiya) para nabi.'),
                  _buildRuleItem('3. Presisi Redaksi', 'Menjaga adab penulisan terhadap para Nabi, Shahabat Ridwanullahi \'Alaihim, dan Ummul Mukminin.'),
                  _buildRuleItem('4. Review Dewan Asatidzah', 'Semua naskah komunitas melalui peninjauan ganda maksimal 2x24 jam sebelum tanda terverifikasi disematkan.'),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Saya Pahami'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRuleItem(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: '$title: ',
                style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                children: [
                  TextSpan(
                    text: desc,
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.normal, color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 2. ENSIKLOPEDIA HADITS SHAHIH VIEW (Faithful to Stitch Design)
  // ===========================================================================
  Widget _buildHaditsView(bool isDesktop) {
    final kutubList = ['Semua', 'Shahih Bukhari', 'Shahih Muslim', 'Sunan Abu Dawud', 'Jami\' At-Tirmidzi', 'Riyadhus Shalihin'];
    final topicTags = ['Semua', 'Niat & Ikhlas', 'Akhlak Mulia', 'Sholat & Thaharah', 'Muamalah', 'Kesabaran & Ridha'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Editorial Curation Guarantee Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dewan Pakar Hadits Sanctuary',
                      style: GoogleFonts.syne(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                    Text(
                      'Ketat 100% verifikasi takhrij sanad & matan sebelum publikasi ke ruang ikhtiar.',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSecondaryContainer, height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Kutubut Tis'ah Horizontal Filter Track
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: kutubList.map((k) {
              final isSel = _selectedHadithKitab == k;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(k),
                  selected: isSel,
                  onSelected: (val) => setState(() => _selectedHadithKitab = k),
                  labelStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                    color: isSel ? AppColors.onPrimary : AppColors.primary,
                  ),
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surfaceContainerLow,
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 10),

        // Quick Topic Tags
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: topicTags.map((t) {
              final isSel = _selectedHadithTopic == t;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ActionChip(
                  label: Text(t),
                  onPressed: () => setState(() => _selectedHadithTopic = t),
                  backgroundColor: isSel ? AppColors.primaryContainer : AppColors.surfaceContainerLowest,
                  labelStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                    color: isSel ? AppColors.onPrimaryContainer : AppColors.secondary,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // PRIMARY FEATURED HADITH CARD: HR. Bukhari #1 & Muslim #1907
        _buildFeaturedHadithCard(),

        const SizedBox(height: 16),

        // Secondary Hadiths from Data Repository & User Submissions
        ...IslamicDataRepository.sampleHadiths.map((h) => _buildSecondaryHadithCard(h)),
        ..._customSubmittedHadiths.map((h) => _buildCustomHadithCard(h)),

        const SizedBox(height: 20),

        // Rigorous Contribution Invitation Card (Crucial Feature)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.shield_outlined, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Sistem Kontribusi Terverifikasi',
                    style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Ajukan hadits shahih beserta nomor takhrij kitab primer untuk dikurasi Dewan Pakar dalam 24 jam.',
                style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.rate_review, size: 16),
                  label: const Text('+ Ajukan Hadits Baru (Formulir Takhrij)'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    textStyle: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700),
                  ),
                  onPressed: _openSubmitHadithModal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedHadithCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.hairline),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(16),
            blurRadius: 20,
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.powderBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Shahih Bukhari #1 • Muslim #1907',
                      style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Bab Niat',
                      style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w600, color: AppColors.secondary),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 18, color: AppColors.secondary),
                onPressed: () => _copyToClipboard(
                  'إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ\n"Sesungguhnya setiap amalan tergantung pada niatnya..." (HR. Bukhari #1)',
                  'Matan dan terjemahan hadits berhasil disalin!',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Arabic Matan Frame
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ، وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى، فَمَنْ كَانَتْ هِجْرَتُهُ إِلَى اللَّهِ وَرَسُولِهِ فَهِجْرَتُهُ إِلَى اللَّهِ وَرَسُولِهِ، وَمَنْ كَانَتْ هِجْرَتُهُ لِدُنْيَا يُصِيبُهَا أَوِ امْرَأَةٍ يَنْكِحُهَا فَهِجْرَتُهُ إِلَى مَا هَاجَرَ إِلَيْهِ',
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: AppTheme.quranArabic(fontSize: 19),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '"Innamal a\'maalu bin-niyyaat, wa innamaa likullimri\'in maa nawaa..."',
            style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontStyle: FontStyle.italic, color: AppColors.secondary),
          ),
          const SizedBox(height: 6),
          Text(
            '"Sesungguhnya setiap amalan tergantung pada niatnya, dan sesungguhnya setiap orang akan mendapatkan sesuai apa yang dia niatkan..."',
            style: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: AppColors.onSurface, height: 1.4),
          ),
          const SizedBox(height: 12),

          // Action Row: Audio Syarah & Link to Pohon Sanad
          Row(
            children: [
              ElevatedButton.icon(
                icon: Icon(_isHadithAudioPlaying ? Icons.pause : Icons.play_arrow, size: 16),
                label: Text(_isHadithAudioPlaying ? 'Jeda Syarah' : 'Audio Syarah (3m)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  textStyle: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                ),
                onPressed: () => setState(() => _isHadithAudioPlaying = !_isHadithAudioPlaying),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.account_tree, size: 15),
                label: const Text('Lihat Pohon Sanad'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  textStyle: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                ),
                onPressed: () {
                  setState(() => _activeType = KnowledgeModuleType.silsilahSanad);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Expandable Faedah Hadits Accordion
          InkWell(
            onTap: () => setState(() => _faedahAccordionOpen = !_faedahAccordionOpen),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.menu_book, size: 15, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      'Faedah & Pelajaran Fiqih Hadits',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ],
                ),
                Icon(_faedahAccordionOpen ? Icons.expand_less : Icons.expand_more, size: 18, color: AppColors.primary),
              ],
            ),
          ),
          if (_faedahAccordionOpen) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFaedahPoint('1. Niat sebagai pembeda:', 'Niat membedakan antara perbuatan ibadah murni dengan rutinitas adat kebiasaan sehari-hari.'),
                  _buildFaedahPoint('2. Keikhlasan mutlak:', 'Pahala amal akhirat hanya terwujud apabila ditujukan murni mencari ridha Allah semata.'),
                  _buildFaedahPoint('3. Bahaya riya\':', 'Hijrah atau amal yang tercampur pamrih duniawi kehilangan nilai ukhrawi di sisi Allah.'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFaedahPoint(String header, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          text: '$header ',
          style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
          children: [
            TextSpan(
              text: body,
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.normal, color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryHadithCard(HadithItem h) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                h.title,
                style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppColors.powderBlue, borderRadius: BorderRadius.circular(10)),
                child: Text('Shahih', style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(12)),
            child: Text(
              h.arabic,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: AppTheme.quranArabic(fontSize: 17),
            ),
          ),
          const SizedBox(height: 8),
          Text('"${h.translation}"', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.verified, size: 13, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(h.narrator, style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.secondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomHadithCard(Map<String, dynamic> h) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                h['kitab'] as String,
                style: GoogleFonts.syne(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppColors.tertiaryFixed, borderRadius: BorderRadius.circular(10)),
                child: Text(
                  h['status'] as String,
                  style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.onTertiaryFixed),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(h['matan'] as String, textAlign: TextAlign.right, textDirection: TextDirection.rtl, style: AppTheme.quranArabic(fontSize: 17)),
          const SizedBox(height: 6),
          Text('"${h['terjemah']}"', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }

  // ===========================================================================
  // MODAL: FORM KONTRIBUSI HADITS BARU
  // ===========================================================================
  void _openSubmitHadithModal() {
    final kitabController = TextEditingController();
    final noController = TextEditingController();
    final matanController = TextEditingController();
    final terjemahController = TextEditingController();
    bool isAgreed = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.rate_review, color: AppColors.primary, size: 22),
                            const SizedBox(width: 8),
                            Text('Ajukan Hadits Baru', style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary)),
                          ],
                        ),
                        IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(16)),
                      child: Text(
                        'Pastikan hadits bersumber dari Kutubus Sittah dengan matan harakat lengkap dan sanad yang jelas.',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSecondaryContainer),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: kitabController,
                            style: GoogleFonts.plusJakartaSans(fontSize: 12),
                            decoration: InputDecoration(
                              labelText: 'Nama Kitab Rujukan',
                              hintText: 'Contoh: Shahih Bukhari',
                              filled: true,
                              fillColor: AppColors.surfaceContainerLow,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: noController,
                            style: GoogleFonts.plusJakartaSans(fontSize: 12),
                            decoration: InputDecoration(
                              labelText: 'No. Hadits / Bab',
                              hintText: 'Contoh: No. 1442',
                              filled: true,
                              fillColor: AppColors.surfaceContainerLow,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: matanController,
                      maxLines: 2,
                      textDirection: TextDirection.rtl,
                      style: AppTheme.quranArabic(fontSize: 16),
                      decoration: InputDecoration(
                        labelText: 'Matan Arab Lengkap',
                        hintText: 'Tuliskan lafadz matan bahasa Arab...',
                        filled: true,
                        fillColor: AppColors.surfaceContainerLow,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: terjemahController,
                      maxLines: 3,
                      style: GoogleFonts.plusJakartaSans(fontSize: 12),
                      decoration: InputDecoration(
                        labelText: 'Terjemahan Bahasa Indonesia',
                        hintText: 'Terjemahan standar Kemenag RI / ulama mu\'tabar...',
                        filled: true,
                        fillColor: AppColors.surfaceContainerLow,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: isAgreed,
                          activeColor: AppColors.primary,
                          onChanged: (val) => setModalState(() => isAgreed = val ?? false),
                        ),
                        Expanded(
                          child: Text(
                            'Saya bersaksi mengutip hadits ini secara presisi dari naskah mu\'tamad.',
                            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                        onPressed: () {
                          if (kitabController.text.trim().isEmpty || matanController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lengkapi rujukan kitab & matan hadits!')));
                            return;
                          }
                          if (!isAgreed) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Harap centang amanah ilmiah!')));
                            return;
                          }

                          setState(() {
                            _customSubmittedHadiths.insert(0, {
                              'kitab': '${kitabController.text.trim()} #${noController.text.trim()}',
                              'matan': matanController.text.trim(),
                              'terjemah': terjemahController.text.trim(),
                              'status': 'Antrean Kurasi Dewan Pakar',
                            });
                          });

                          Navigator.pop(ctx);
                          _copyToClipboard('', 'Jazakallahu khair! Manuskrip hadits diajukan untuk verifikasi.');
                        },
                        child: const Text('Kirim Manuskrip Hadits'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ===========================================================================
  // 3. ASMAUL HUSNA 99 VIEW (Faithful to Stitch Design)
  // ===========================================================================
  Widget _buildAsmaulHusnaView(bool isDesktop) {
    final categories = ['Semua (99)', 'Kasih Sayang', 'Kekuasaan & Kerajaan', 'Pengampun & Penjaga', 'Pemberi Rezeki'];

    final list = IslamicDataRepository.sampleAsmaulHusna.where((a) {
      return a.latin.toLowerCase().contains(_searchQuery) || a.meaning.toLowerCase().contains(_searchQuery);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Indikator Hafalan & Dzikir Barakah Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.auto_stories, color: AppColors.onPrimaryContainer, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${_memorizedAsmaul.length} ',
                                style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary),
                              ),
                              Text(
                                '/ 99 Dihafal',
                                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.onSurfaceVariant),
                              ),
                            ],
                          ),
                          Text(
                            'Tingkat Barakah: Al-Muta\'allim',
                            style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.secondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${((_memorizedAsmaul.length / 99) * 100).toStringAsFixed(1)}%',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: _memorizedAsmaul.length / 99,
                  minHeight: 8,
                  backgroundColor: AppColors.surfaceContainerHigh,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${99 - _memorizedAsmaul.length} Nama Tersisa', style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.secondary)),
                  Text('Target: 3 Nama / Pekan', style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.primary)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Pemutar Talaqqi Murottal 99 Audio Suite
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primaryFixed,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(_isPlayingTalaqqiAll ? Icons.pause_circle_filled : Icons.play_circle_fill, size: 30, color: AppColors.primary),
                    onPressed: () => setState(() => _isPlayingTalaqqiAll = !_isPlayingTalaqqiAll),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isPlayingTalaqqiAll ? 'Memutar: 0$_talaqqiCurrentNumber. Ar-Rahman' : 'Talaqqi Murottal 99 Nama',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                      Text(
                        'Syaikh Mishary Rashid Al-Afasy',
                        style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.onPrimaryFixedVariant),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous, size: 20, color: AppColors.primary),
                    onPressed: () {
                      setState(() {
                        if (_talaqqiCurrentNumber > 1) _talaqqiCurrentNumber--;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next, size: 20, color: AppColors.primary),
                    onPressed: () {
                      setState(() {
                        if (_talaqqiCurrentNumber < 99) _talaqqiCurrentNumber++;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Category Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((c) {
              final isSel = _selectedAsmaulCategory == c;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(c),
                  selected: isSel,
                  onSelected: (val) => setState(() => _selectedAsmaulCategory = c),
                  labelStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                    color: isSel ? AppColors.onPrimary : AppColors.primary,
                  ),
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surfaceContainerLow,
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // CARD UNGGULAN HARI INI: 01. AR-RAHMAN
        _buildFeaturedAsmaulCard(),

        const SizedBox(height: 18),

        // 2-COLUMN GRID ASMAUL HUSNA SELANJUTNYA
        Text(
          'Untaian Nama Agung Berikutnya',
          style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop ? 3 : 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: isDesktop ? 1.6 : 1.3,
          ),
          itemCount: list.length,
          itemBuilder: (context, idx) {
            final item = list[idx];
            final isHafal = _memorizedAsmaul.contains(item.number);

            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isHafal ? AppColors.surfaceContainerLowest : AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isHafal ? AppColors.primary.withAlpha(60) : AppColors.hairline,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: AppColors.softPeriwinkle,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${item.number}',
                            style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (isHafal) {
                              _memorizedAsmaul.remove(item.number);
                            } else {
                              _memorizedAsmaul.add(item.number);
                            }
                          });
                        },
                        child: Icon(
                          isHafal ? Icons.check_circle : Icons.check_circle_outline,
                          size: 16,
                          color: isHafal ? AppColors.primary : AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    item.arabic,
                    style: AppTheme.quranArabic(fontSize: 19),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    item.latin,
                    style: GoogleFonts.syne(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    item.meaning,
                    style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.onSurfaceVariant),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 20),

        // Fitur Kuis & Latihan Menghafal Interaktif
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.tertiaryFixed,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.quiz, color: AppColors.tertiary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Uji Kemampuan Hafalan Asmaul Husna',
                    style: GoogleFonts.syne(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.onTertiaryFixed),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '10 Soal Latihan Mandiri: Tebak Lafadz Arab, Makna, & Urutan Nama Agung.',
                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onTertiaryFixed.withAlpha(200)),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow, size: 16),
                  label: const Text('Mulai Kuis Hafalan (10 Soal)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: _openAsmaulQuizDialog,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedAsmaulCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.hairline),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(14),
            blurRadius: 18,
            offset: const Offset(0, 6),
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('01. Nama Agung Utama', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ),
              IconButton(
                icon: const Icon(Icons.volume_up, size: 18, color: AppColors.primary),
                onPressed: () => _copyToClipboard('Ar-Rahman (الرَّحْمٰنُ)', 'Audio Talaqqi Ar-Rahman diputar!'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'الرَّحْمٰنُ',
            style: AppTheme.quranArabic(fontSize: 34),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Ar-Rahmaan',
            style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
          ),
          Text(
            'Maha Pengasih kepada seluruh makhluk di alam semesta tanpa terkecuali.',
            style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Fadhilah Dzikir Box & Interactive Tasbih Counter
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fadhilah Dzikir 100x ba\'da sholat:', style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    Text('Menenangkan gejolak hati & mengundang rahmat Ilahi.', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary)),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _arRahmanDzikirCount = (_arRahmanDzikirCount + 1) % 101;
                    });
                  },
                  child: Text('Dzikir: $_arRahmanDzikirCount / 100', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openAsmaulQuizDialog() {
    int currentQ = 0;
    int score = 0;
    final questions = [
      {'q': 'Arti dari nama "Al-Malik" adalah...', 'options': ['Yang Maha Merajai', 'Yang Maha Penyayang', 'Yang Maha Mengetahui', 'Yang Maha Adil'], 'correct': 0},
      {'q': 'Lafadz Arab dari "Al-Quddus" adalah...', 'options': ['الْمَلِكُ', 'الْقُدُّوسُ', 'السَّلاَمُ', 'الْمُؤْمِنُ'], 'correct': 1},
      {'q': 'Asmaul Husna ke-5 adalah...', 'options': ['As-Salam', 'Al-Mu\'min', 'Al-Muhaimin', 'Al-\'Aziz'], 'correct': 0},
    ];

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setQuizState) {
            final isFinished = currentQ >= questions.length;
            return Dialog(
              backgroundColor: AppColors.surfaceContainerLowest,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 440,
                  maxHeight: MediaQuery.of(context).size.height * 0.88,
                ),
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: isFinished
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.military_tech, size: 48, color: AppColors.primary),
                            const SizedBox(height: 10),
                            Text('Alhamdulillah!', style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary)),
                            const SizedBox(height: 6),
                            Text('Skor Anda: $score / ${questions.length}', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Selesai'),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Soal ${currentQ + 1} dari ${questions.length}', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.secondary)),
                                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(questions[currentQ]['q'] as String, style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary)),
                            const SizedBox(height: 14),
                            ...List.generate((questions[currentQ]['options'] as List<String>).length, (i) {
                              final opt = (questions[currentQ]['options'] as List<String>)[i];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                  onPressed: () {
                                    if (i == (questions[currentQ]['correct'] as int)) score++;
                                    setQuizState(() => currentQ++);
                                  },
                                  child: Text(opt, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.onSurface)),
                                ),
                              );
                            }),
                          ],
                        ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ===========================================================================
  // 4. GENERATOR KARTU MUTIARA 9:16 VIEW (Faithful to Stitch Design)
  // ===========================================================================
  Widget _buildGeneratorMutiaraView(bool isDesktop) {
    final quote = _quotePresets[_selectedQuoteIndex];

    Color cardBg;
    Color textColor;
    Color subColor;

    switch (_quotePalette) {
      case 'Velvet Night':
        cardBg = const Color(0xFF1E2235);
        textColor = const Color(0xFFFAF8FF);
        subColor = const Color(0xFFBAC8D3);
        break;
      case 'Parchment':
        cardBg = const Color(0xFFF7F3E9);
        textColor = const Color(0xFF3E3628);
        subColor = const Color(0xFF7A6B53);
        break;
      case 'Emerald Rawdah':
        cardBg = const Color(0xFF1B332A);
        textColor = const Color(0xFFFAF8FF);
        subColor = const Color(0xFFD7E6DE);
        break;
      case 'Ethereal':
      default:
        cardBg = AppColors.surfaceContainerLowest;
        textColor = AppColors.primary;
        subColor = AppColors.onSurfaceVariant;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Preset selector chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(_quotePresets.length, (idx) {
              final isSel = idx == _selectedQuoteIndex;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(_quotePresets[idx]['theme']!),
                  selected: isSel,
                  onSelected: (val) => setState(() => _selectedQuoteIndex = idx),
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surfaceContainerLow,
                  labelStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                    color: isSel ? AppColors.onPrimary : AppColors.primary,
                  ),
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 16),

        // Live Canvas Preview & Studio Controls
        isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 55,
                    child: _buildQuotePreviewCard(quote, cardBg, textColor, subColor),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 45,
                    child: _buildStudioControls(),
                  ),
                ],
              )
            : Column(
                children: [
                  _buildQuotePreviewCard(quote, cardBg, textColor, subColor),
                  const SizedBox(height: 16),
                  _buildStudioControls(),
                ],
              ),
      ],
    );
  }

  Widget _buildQuotePreviewCard(Map<String, String> quote, Color cardBg, Color textColor, Color subColor) {
    double aspectRatioVal = _quoteAspectRatio == '9:16'
        ? 9 / 16
        : _quoteAspectRatio == '1:1'
            ? 1.0
            : 16 / 9;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360, maxHeight: 520),
        child: AspectRatio(
          aspectRatio: aspectRatioVal,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.hairline),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Tag
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: textColor.withAlpha(30),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        quote['surah']!,
                        style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700, color: textColor),
                      ),
                    ),
                  ],
                ),

                // Center Body
                Column(
                  children: [
                    Text(
                      quote['arabic']!,
                      textAlign: _quoteAlignment,
                      textDirection: TextDirection.rtl,
                      style: AppTheme.quranArabic(fontSize: _quoteFontSize + 3),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 40,
                      height: 1.5,
                      color: textColor.withAlpha(80),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      quote['translation']!,
                      textAlign: _quoteAlignment,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: _quoteFontSize - 5,
                        fontStyle: FontStyle.italic,
                        color: textColor,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),

                // Footer Watermark
                Column(
                  children: [
                    Text(
                      quote['contemplation']!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(fontSize: 9.5, color: subColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'NOOR SANCTUARY • KHAZANAH RUHANI',
                      style: GoogleFonts.spaceGrotesk(fontSize: 8.5, letterSpacing: 1.5, color: subColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStudioControls() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Rasio Aspek', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
          const SizedBox(height: 6),
          Row(
            children: ['9:16', '1:1', '16:9'].map((r) {
              final isSel = _quoteAspectRatio == r;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  label: Text(r == '9:16' ? 'Story (9:16)' : r == '1:1' ? 'Feed (1:1)' : 'Banner'),
                  selected: isSel,
                  onSelected: (val) => setState(() => _quoteAspectRatio = r),
                  selectedColor: AppColors.primary,
                  labelStyle: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: isSel ? AppColors.onPrimary : AppColors.primary),
                  showCheckmark: false,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          Text('Palet Nuansa', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: ['Ethereal', 'Velvet Night', 'Parchment', 'Emerald Rawdah'].map((p) {
              final isSel = _quotePalette == p;
              return ChoiceChip(
                label: Text(p),
                selected: isSel,
                onSelected: (val) => setState(() => _quotePalette = p),
                selectedColor: AppColors.primary,
                labelStyle: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: isSel ? AppColors.onPrimary : AppColors.primary),
                showCheckmark: false,
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          Text('Ukuran & Perataan Teks', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
          const SizedBox(height: 6),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, size: 18, color: AppColors.primary),
                onPressed: () {
                  if (_quoteFontSize > 14) setState(() => _quoteFontSize -= 2);
                },
              ),
              Text('${_quoteFontSize.toInt()} pt', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, size: 18, color: AppColors.primary),
                onPressed: () {
                  if (_quoteFontSize < 28) setState(() => _quoteFontSize += 2);
                },
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.format_align_left, size: 18, color: _quoteAlignment == TextAlign.left ? AppColors.primary : AppColors.secondary),
                onPressed: () => setState(() => _quoteAlignment = TextAlign.left),
              ),
              IconButton(
                icon: Icon(Icons.format_align_center, size: 18, color: _quoteAlignment == TextAlign.center ? AppColors.primary : AppColors.secondary),
                onPressed: () => setState(() => _quoteAlignment = TextAlign.center),
              ),
              IconButton(
                icon: Icon(Icons.format_align_right, size: 18, color: _quoteAlignment == TextAlign.right ? AppColors.primary : AppColors.secondary),
                onPressed: () => setState(() => _quoteAlignment = TextAlign.right),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.share, size: 15),
                  label: const Text('Status WA'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => _copyToClipboard('Kartu Mutiara Hikmah siap dibagikan ke WhatsApp Status!', 'Siap dibagikan ke WhatsApp Status!'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.copy, size: 15),
                  label: const Text('Salin Teks'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => _copyToClipboard(
                    '${_quotePresets[_selectedQuoteIndex]['surah']}\n${_quotePresets[_selectedQuoteIndex]['arabic']}\n${_quotePresets[_selectedQuoteIndex]['translation']}',
                    'Kutipan mutiara disalin ke papan klip!',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 5. POHON SILSILAH SANAD VIEW (Faithful to Stitch Design)
  // ===========================================================================
  Widget _buildSilsilahSanadView(bool isDesktop) {
    final selectedNode = _sanadChain[_selectedSanadNodeIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Reference Header Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.account_tree, color: AppColors.onPrimaryContainer, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rantai Sanad Hadits Pertama (HR. Bukhari #1)',
                      style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onPrimaryContainer),
                    ),
                    Text(
                      'Menampilkan jalur transmisi tsiqah dari Rasulullah ﷺ hingga Imam Al-Bukhari.',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onPrimaryContainer.withAlpha(200)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Interactive Tree Flow Nodes
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(_sanadChain.length, (idx) {
              final node = _sanadChain[idx];
              final isSel = idx == _selectedSanadNodeIndex;

              return Row(
                children: [
                  InkWell(
                    onTap: () => setState(() => _selectedSanadNodeIndex = idx),
                    borderRadius: BorderRadius.circular(18),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSel ? AppColors.primary : AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSel ? AppColors.primary : AppColors.hairline,
                          width: isSel ? 2 : 1,
                        ),
                        boxShadow: isSel
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withAlpha(40),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        children: [
                          Icon(node.icon, size: 20, color: isSel ? AppColors.onPrimary : AppColors.primary),
                          const SizedBox(height: 4),
                          Text(
                            node.title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                              color: isSel ? AppColors.onPrimary.withAlpha(200) : AppColors.secondary,
                            ),
                          ),
                          Text(
                            node.name.length > 18 ? '${node.name.substring(0, 16)}...' : node.name,
                            style: GoogleFonts.syne(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: isSel ? AppColors.onPrimary : AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (idx < _sanadChain.length - 1)
                    Container(
                      width: 20,
                      height: 2,
                      color: AppColors.secondaryContainer,
                    ),
                ],
              );
            }),
          ),
        ),
        const SizedBox(height: 16),

        // Dynamic Selected Rawi Detail Card (Jarh wa Ta'dil Analysis)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.powderBlue, borderRadius: BorderRadius.circular(10)),
                        child: Text(selectedNode.title, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      ),
                      const SizedBox(height: 4),
                      Text(selectedNode.name, style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      Text(selectedNode.era, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: AppColors.tertiaryFixed, shape: BoxShape.circle),
                    child: const Icon(Icons.verified, color: AppColors.tertiary, size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Jarh wa Ta'dil Matrix
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(14)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Keadilan (\'Adalah)', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary)),
                          Text(selectedNode.jarhGrade, style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(14)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Kekuatan Hafalan (Dhabith)', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary)),
                          Text(selectedNode.dhabithLevel, style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Text('Biografi & Peran Periwayatan:', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
              const SizedBox(height: 4),
              Text(selectedNode.bio, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.onSurfaceVariant, height: 1.4)),
              const SizedBox(height: 10),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text('Guru: ${selectedNode.teachers}', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary)),
                  ),
                  Expanded(
                    child: Text('Murid: ${selectedNode.students}', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // 6. DOA HARIAN VIEW
  // ===========================================================================
  Widget _buildDoaHarianView() {
    final list = IslamicDataRepository.sampleDoas.where((d) {
      return d.title.toLowerCase().contains(_searchQuery) ||
          d.translation.toLowerCase().contains(_searchQuery) ||
          d.category.toLowerCase().contains(_searchQuery);
    }).toList();

    return Column(
      children: list.map((d) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(d.title, style: GoogleFonts.syne(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.lavender, borderRadius: BorderRadius.circular(10)),
                    child: Text(d.category, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primary)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(14)),
                child: Text(d.arabic, textAlign: TextAlign.right, textDirection: TextDirection.rtl, style: AppTheme.quranArabic(fontSize: 18)),
              ),
              const SizedBox(height: 8),
              Text(d.latin, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.secondary)),
              const SizedBox(height: 6),
              Text('"${d.translation}"', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.onSurfaceVariant)),
              const SizedBox(height: 8),
              Text(d.reference, style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ===========================================================================
  // 7. TAJWID VISUAL VIEW
  // ===========================================================================
  Widget _buildTajwidVisualView() {
    final list = IslamicDataRepository.sampleTajwid.where((t) {
      return t.ruleName.toLowerCase().contains(_searchQuery) ||
          t.description.toLowerCase().contains(_searchQuery) ||
          t.category.toLowerCase().contains(_searchQuery);
    }).toList();

    return Column(
      children: list.map((t) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(t.ruleName, style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(10)),
                    child: Text(t.category, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primary)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text('Huruf: ${t.letters}', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.secondary)),
              const SizedBox(height: 4),
              Text(t.description, style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.onSurfaceVariant, height: 1.35)),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(14)),
                child: Column(
                  children: [
                    Text(t.exampleArabic, style: AppTheme.quranArabic(fontSize: 18), textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    Text(t.exampleExplanation, style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontStyle: FontStyle.italic, color: AppColors.secondary), textAlign: TextAlign.center),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
