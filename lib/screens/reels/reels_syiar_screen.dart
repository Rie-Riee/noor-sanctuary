import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../search/universal_search_sheet.dart';

class ReelsSyiarScreen extends StatefulWidget {
  final int initialIndex;

  const ReelsSyiarScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<ReelsSyiarScreen> createState() => _ReelsSyiarScreenState();
}

class _ReelsSyiarScreenState extends State<ReelsSyiarScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  late int _currentIndex;
  bool _isPlaying = true;
  bool _isMuted = false;
  bool _showPlayPauseOverlay = false;
  IconData _playPauseIcon = Icons.play_arrow;

  // Active top feed tab: 0 = Mengikuti, 1 = Untuk Anda
  int _selectedFeedTab = 1;

  // Double tap heart burst state
  bool _showHeartAnimation = false;
  Offset _heartPosition = Offset.zero;

  // Simulated progress controller for 60s reel
  late AnimationController _progressController;
  late AnimationController _vinylController;

  // User interactions per reel
  final Map<int, bool> _likedReels = {};
  final Map<int, int> _likeCounts = {};
  final Map<int, bool> _savedReels = {};
  final Map<int, int> _savedCounts = {};
  final Map<int, bool> _followedCreators = {};
  final Map<int, bool> _captionExpanded = {};
  final Map<int, List<Map<String, String>>> _reelComments = {};

  // Rich list of Islamic Syiar Reels (TikTok style) with verified Dalil & Hadith references
  final List<Map<String, dynamic>> _reels = [
    {
      'title': 'Ketika Doamu Terasa Lambat Dijawab...',
      'creator': 'Ustzh. Halimah Alaydrus',
      'handle': '@ustadzah.halimah',
      'initials': 'HA',
      'avatarBg': const Color(0xFFC1C5DF),
      'avatarUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuC1zsPAe71QnL0_zxDM3ZA87hqCPfJ-Ajhaq0yTYUF9kScOZiBiIyK7AS72NxJ9cd8wpL3h6ktvDFh_0HSIw-UucUSHy2QB_xlASzHVG4svoOnV3oFx06qUvs2T5sUyS0Njtn5N-u16yk8yxE2c8rQCS72Cu-tm58qOZN7ERPyO0nmdXqQPuopLf8EcO8yL13eAABokwOwF5LhuS8jyQRRt5FECifkZWpKcY7RBgUE',
      'image': 'assets/images/reel_1.png',
      'quote':
          'Ketika Doamu Terasa Lambat Dijawab... Ingatlah bahwa Allah tidak menolak, Dia sedang menata waktu terbaik untuk menjagamu dari ketergesaan nafsu. Jangan berhenti mengetuk pintu langit saat malam hening 🕊️✨',
      'tags': ['#SyiarSanctuary', '#MuhasabahJiwa', '#TadabburQolbu'],
      'dalil': {
        'source': 'HR. Tirmidzi no. 3381 • Hadits Shahih',
        'title': 'Keutamaan Berdoa di Waktu Lapang & Sempit',
        'arabic': 'مَنْ سَرَّهُ أَنْ يَسْتَجِيبَ اللَّهُ لَهُ عِنْدَ الشَّدَائِدِ وَالْكُرَبِ فَلْيُكْثِرِ الدُّعَاءَ فِي الرَّخَاءِ',
        'translation': 'Barangsiapa yang senang doanya dikabulkan oleh Allah saat kesulitan dan kesempitan, maka hendaklah ia memperbanyak doa di waktu lapang.',
        'explanation': 'Doa bukan sekadar pelarian saat musibah tiba, melainkan tali penghubung keimanan yang harus senantiasa terjalin kukuh di kala kita sedang sehat, lapang, dan bahagia.',
      },
      'audio': 'Suara Asli • Ustzh. Halimah Alaydrus — Untaian Mutiara Fajar',
      'likes': 24800,
      'commentsCount': 1200,
      'saves': 8400,
      'shares': 3600,
      'duration': '0:58',
      'currentTime': '00:42',
    },
    {
      'title': 'Adab Menjaga Hati di Ruang Sepi',
      'creator': 'Ust. Hilman Fauzi',
      'handle': '@ustadz.hilmanfauzi',
      'initials': 'HF',
      'avatarBg': const Color(0xFFFDCE73),
      'avatarUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAzMYHUOXTR1QbuHGbaobxIY6z97DGxR80d6Qis-SPBTuXmPk-ytGM5LopnrMTSKH0YG75y4Z3itBwfhe0Yc4bdnb8o3YZB-C5KxCvpP8XtFqqIg4wthKmeD3BUKxOKGvjMPVQ5mdTrieFAxDW98SM_8skamYU1D_xkgdu3BdvPGDDlEEtZu16lXQJLejGCxIldy5x5GoOy1yCR8i4nGT9F5p2DqNC-Q1muakg71S8',
      'image': 'assets/images/reel_2.png',
      'quote':
          'Di kala tak ada mata manusia memandang, di situlah keikhlasan sejati diuji dan dicatat malaikat. Jadikan kesendirianmu sebagai waktu terindah bermunajat kepada Ilahi tanpa kepalsuan riya.',
      'tags': ['#Ikhlas', '#RuangHati', '#KajianSingkat'],
      'dalil': {
        'source': 'HR. Ibnu Majah no. 4245 • Hadits Hasan',
        'title': 'Bahaya Dosa di Ruang Kesendirian (Khilwat)',
        'arabic': 'لَأَعْلَمَنَّ أَقْوَامًا مِنْ أُمَّتِي يَأْتُونَ يَوْمَ الْقِيَامَةِ بِحَسَنَاتٍ أَمْثَالِ جِبَالِ تِهَامَةَ بِيضًا فَيَجْعَلُهَا اللَّهُ عَزَّ وَجَلَّ هَبَاءً مَنْثُورًا',
        'translation': 'Sungguh aku mengetahui ada suatu kaum dari umatku yang datang pada hari kiamat membawa kebaikan sebesar gunung Tihamah yang putih, lalu Allah menjadikannya debu yang berterbangan...',
        'explanation': 'Para ulama menjelaskan bahwa mereka adalah orang yang jika bersendirian dengan larangan-larangan Allah, mereka melanggarnya. Menjaga hati saat sepi adalah puncak keimanan ihsan.',
      },
      'audio': 'Nada Menenangkan • Muhasabah Malam Nabawi',
      'likes': 18500,
      'commentsCount': 890,
      'saves': 5120,
      'shares': 2140,
      'duration': '0:45',
      'currentTime': '00:30',
    },
    {
      'title': 'Sujud Terpanjang dalam Ujian Berat',
      'creator': 'Syaikh Mishary Rashid',
      'handle': '@mishary_alafasy',
      'initials': 'MR',
      'avatarBg': const Color(0xFFD7E6DE),
      'avatarUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCJJLbdWB2aPr9hbc22giLS5bYG3FEVyOAKTshcZ5LZDtUNSU6rkKG5ePhwCzh1nIairRTJKfVuCfb8-t6ivTQUXOL0aY4KrSfvevg1NyEOeJVNOpk1nJcgRmrR-l1kRfP2liHlyHxvNHthyU3E6hJRkpLWVUTi8Cr61ZKsmyCJStDgqn_3SEXpU77Rh8AoZHjKlkyEe65v1UzeINUkMbl4HFudGJmilA0V744lcl8',
      'image': 'assets/images/reel_3.png',
      'quote':
          'Makin dalam kepalamu menyentuh bumi, makin tinggi derajat doamu diangkat ke langit. Di dalam sujud, tiada jarak pemisah antara hamba dan Rabb yang Maha Pengasih lagi Maha Penyayang.',
      'tags': ['#KeajaibanSujud', '#TahajjudCall', '#DoaMustajab'],
      'dalil': {
        'source': 'HR. Muslim no. 482 • Hadits Shahih',
        'title': 'Posisi Terdekat Antara Hamba dan Allah',
        'arabic': 'أَقْرَبُ مَا يَكُونُ الْعَبْدُ مِنْ رَبِّهِ وَهُوَ سَاجِدٌ فَأَكْثِرُوا الدُّعَاءَ',
        'translation': 'Keadaan yang paling dekat antara seorang hamba dengan Rabb-nya adalah ketika ia sedang bersujud, maka perbanyaklah berdoa di dalamnya.',
        'explanation': 'Sujud adalah simbol kepasrahan mutlak di hadapan keagungan Allah. Di sanalah tempat terbaik menumpahkan air mata permohonan dan pengaduan kesusahan hidup.',
      },
      'audio': 'Lantunan Merdu Surah Ar-Rahman • Tilawah Tartil Maqam Nahawand',
      'likes': 42900,
      'commentsCount': 1850,
      'saves': 14200,
      'shares': 6400,
      'duration': '01:12',
      'currentTime': '00:54',
    },
    {
      'title': 'Menata Hati Menghadapi Takdir & Ketetapan Ilahi',
      'creator': 'Ust. Dr. Firanda Andirja',
      'handle': '@ustadz.firanda',
      'initials': 'FA',
      'avatarBg': const Color(0xFFDCEAF5),
      'avatarUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAzMYHUOXTR1QbuHGbaobxIY6z97DGxR80d6Qis-SPBTuXmPk-ytGM5LopnrMTSKH0YG75y4Z3itBwfhe0Yc4bdnb8o3YZB-C5KxCvpP8XtFqqIg4wthKmeD3BUKxOKGvjMPVQ5mdTrieFAxDW98SM_8skamYU1D_xkgdu3BdvPGDDlEEtZu16lXQJLejGCxIldy5x5GoOy1yCR8i4nGT9F5p2DqNC-Q1muakg71S8',
      'image': 'assets/images/kajian_1.png',
      'quote':
          'Dua kenikmatan yang sering kali dilalaikan oleh manusia: kesehatan dan waktu luang. Bersabarlah atas takdir yang terasa pahit di lidah nafsu, karena di baliknya tersimpan madu hikmah abadi.',
      'tags': ['#HaditsShahih', '#TazkiyatunNafs', '#HikmahHidup'],
      'dalil': {
        'source': 'HR. Bukhari no. 6412 • Shahih Bukhari',
        'title': 'Dua Kenikmatan yang Sering Tertipu',
        'arabic': 'نِعْمَتَانِ مَغْبُونٌ فِيهِمَا كَثِيرٌ مِنَ النَّاسِ: الصِّحَّةُ وَالْفَرَاغُ',
        'translation': 'Dua nikmat yang banyak manusia tertipu di dalamnya: kesehatan dan waktu luang.',
        'explanation': 'Manusia kerap kali baru menyadari betapa berharganya nikmat kesehatan dan waktu luang ketika keduanya telah lenyap dari genggaman.',
      },
      'audio': 'Syarah Riyadus Shalihin • Masjid Nabawi Madinah',
      'likes': 31400,
      'commentsCount': 960,
      'saves': 9800,
      'shares': 4200,
      'duration': '0:54',
      'currentTime': '00:38',
    },
    {
      'title': 'Menemukan Ketenangan di Sepertiga Malam',
      'creator': 'Habib Nabiel Al-Musawa',
      'handle': '@habib_nabiel',
      'initials': 'HN',
      'avatarBg': const Color(0xFFE8E0F2),
      'avatarUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDlv78BL2O9XhA_S2znce4xE_OL6IN0Zo4NEEKNA8qZI3M_evM60Ss722TxWi0jKatavNWl171NidqZvWojAtMzPPCHwYfNDPI0JbX871PkxGxUljMljXsZSkdpeMCwxDJQ70LxcrZRSqPcZuxtJlIvnXAWvu65J-Jf8oKljJQ3RQJTlYvI3sqgGtprsan-80WiDKmwWsDuK48oY8TTUQGLLxlj3_ygHUPq8coK_dY',
      'image': 'assets/images/podcast_malam.png',
      'quote':
          'Tetesan air mata yang jatuh karena takut dan cinta kepada Allah di hening malam kelak akan memadamkan kobaran api siksa. Hiasi malammu dengan istighfar pengetuk pintu maghfirah.',
      'tags': ['#QiyamulLail', '#ZikirMalam', '#PenyejukJiwa'],
      'dalil': {
        'source': 'HR. Bukhari no. 1145 & Muslim no. 758',
        'title': 'Turunnya Rahmat Allah di Sepertiga Malam Terakhir',
        'arabic': 'يَنْزِلُ رَبُّنَا تَبَارَكَ وَتَعَالَى كُلَّ لَيْلَةٍ إِلَى السَّمَاءِ الدُّنْيَا حِينَ يَبْقَى ثُلُثُ اللَّيْلِ الآخِرُ فَيَقُولُ: مَنْ يَدْعُونِي فَأَسْتَجِيبَ لَهُ',
        'translation': 'Rabb kita Tabaraka wa Ta\'ala turun setiap malam ke langit dunia ketika tersisa sepertiga malam yang akhir seraya berfirman: Barangsiapa berdoa kepada-Ku, niscaya Aku kabulkan...',
        'explanation': 'Waktu emas di mana doa diijabah secara langsung dan pintu taubat dibuka selebar-lebarnya bagi siapa saja yang mengetuknya dengan keikhlasan qolbu.',
      },
      'audio': 'Untaian Doa Munajat Qolbu • Suasana Rintik Hujan Nabawi',
      'likes': 19800,
      'commentsCount': 620,
      'saves': 6400,
      'shares': 1850,
      'duration': '0:50',
      'currentTime': '00:26',
    },
    {
      'title': 'Merengkuh Ampunan & Rahmat Ramadhan',
      'creator': 'Ust. Adi Hidayat, Lc., M.A.',
      'handle': '@ustadz.adihidayat',
      'initials': 'AH',
      'avatarBg': const Color(0xFFFFDEA4),
      'avatarUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuC1zsPAe71QnL0_zxDM3ZA87hqCPfJ-Ajhaq0yTYUF9kScOZiBiIyK7AS72NxJ9cd8wpL3h6ktvDFh_0HSIw-UucUSHy2QB_xlASzHVG4svoOnV3oFx06qUvs2T5sUyS0Njtn5N-u16yk8yxE2c8rQCS72Cu-tm58qOZN7ERPyO0nmdXqQPuopLf8EcO8yL13eAABokwOwF5LhuS8jyQRRt5FECifkZWpKcY7RBgUE',
      'image': 'assets/images/mosque_hero.png',
      'quote':
          'Jangan biarkan hari-hari Ramadhan berlalu tanpa perubahan akhlak dan peningkatan kualitas sholatmu. Pintu surga terbuka lebar, mari jemput maghfirah-Nya dengan kesungguhan amalan yaumiyah.',
      'tags': ['#Ramadhan1446H', '#TausiyahUAH', '#BulanMaghfirah'],
      'dalil': {
        'source': 'HR. Bukhari no. 38 & Muslim no. 760',
        'title': 'Diampuni Dosa yang Telah Lalu',
        'arabic': 'مَنْ صَامَ رَمَضَانَ إِيمَانًا وَاحْتِسَابًا غُفِرَ لَهُ مَا تَقَدَّمَ مِنْ ذَنْبِهِ',
        'translation': 'Barangsiapa berpuasa di bulan Ramadhan atas dasar iman dan mengharap pahala dari Allah, maka akan diampuni dosa-dosanya yang telah lalu.',
        'explanation': 'Syarat utama meraih ampunan Ramadhan adalah niat yang bersih dilandasi ketauhidan murni dan ihtisab (mengharap balasan hanya dari Allah).',
      },
      'audio': 'Kalam Nasihat Ramadhan Penuh Makna • Audio HQ Studio',
      'likes': 56300,
      'commentsCount': 2400,
      'saves': 21200,
      'shares': 9800,
      'duration': '01:00',
      'currentTime': '00:45',
    },
  ];

  DateTime _lastWheelTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, _reels.length - 1);
    _pageController = PageController(initialPage: _currentIndex);

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 45),
    )..repeat();

    _vinylController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // Initialize mock comments and interaction states
    for (int i = 0; i < _reels.length; i++) {
      _likeCounts[i] = _reels[i]['likes'] as int;
      _likedReels[i] = i == 0; // First reel liked as preview
      _savedReels[i] = false;
      _savedCounts[i] = _reels[i]['saves'] as int;
      _followedCreators[i] = false;
      _captionExpanded[i] = false;
      _reelComments[i] = [
        {
          'name': 'Nurul Mardhiyah',
          'initials': 'NM',
          'comment': 'Jazaakillahu khayran, sangat menampar hati di saat diri sedang rapuh. Mengingatkan kembali arti sabar.',
          'time': '2 jam lalu',
          'likes': '84',
        },
        {
          'name': 'Ahmad Ridho',
          'initials': 'AR',
          'comment': 'Bismillah belajar lebih sabar menanti ketetapan dan jawaban terbaik dari Allah Ta\'ala.',
          'time': '4 jam lalu',
          'likes': '36',
        },
        {
          'name': 'Fatimah Az-Zahra',
          'initials': 'FA',
          'comment': 'Masya Allah adem banget nasihatnya. Izin save dan bagikan ke grup keluarga ya ustadzah.',
          'time': '6 jam lalu',
          'likes': '52',
        },
      ];
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    _vinylController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      _isPlaying = true;
    });
    _progressController.reset();
    _progressController.repeat();
  }

  void _nextPage() {
    if (_currentIndex < _reels.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      _playPauseIcon = _isPlaying ? Icons.play_arrow : Icons.pause;
      _showPlayPauseOverlay = true;
    });
    if (_isPlaying) {
      _progressController.forward();
      _vinylController.repeat();
    } else {
      _progressController.stop();
      _vinylController.stop();
    }
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _showPlayPauseOverlay = false);
    });
  }

  void _handleDoubleTap(TapDownDetails details) {
    final curIdx = _currentIndex;
    setState(() {
      _heartPosition = details.localPosition;
      _showHeartAnimation = true;
      if (!(_likedReels[curIdx] ?? false)) {
        _likedReels[curIdx] = true;
        _likeCounts[curIdx] = (_likeCounts[curIdx] ?? 0) + 1;
      }
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _showHeartAnimation = false);
    });
  }

  void _toggleLike(int index) {
    setState(() {
      final isLiked = _likedReels[index] ?? false;
      _likedReels[index] = !isLiked;
      _likeCounts[index] = (_likeCounts[index] ?? 0) + (!isLiked ? 1 : -1);
    });
  }

  void _toggleSave(int index) {
    setState(() {
      final isSaved = _savedReels[index] ?? false;
      _savedReels[index] = !isSaved;
      _savedCounts[index] = (_savedCounts[index] ?? 0) + (!isSaved ? 1 : -1);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          (_savedReels[index] ?? false) ? 'Disimpan ke Koleksi Favorit Syiar ✨' : 'Dihapus dari Koleksi Favorit',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleFollow(int index) {
    setState(() {
      final isFollowed = _followedCreators[index] ?? false;
      _followedCreators[index] = !isFollowed;
    });
    final creator = _reels[index]['creator'] as String;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text((_followedCreators[index] ?? false) ? 'Mengikuti $creator' : 'Berhenti mengikuti $creator'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ==========================================
  // MODAL 1: BACA DALIL & HADITH SHAHIH
  // ==========================================
  void _showDalilModal(BuildContext context, Map<String, dynamic> dalil) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                left: 22,
                right: 22,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified, size: 14, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          'Sanad Terverifikasi',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: AppColors.onSurfaceVariant),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                dalil['source'] ?? 'Rujukan Dalil',
                style: GoogleFonts.syne(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
              if (dalil['title'] != null)
                Text(
                  dalil['title'] as String,
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.secondary),
                ),
              const SizedBox(height: 16),
              // Arabic Calligraphy Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.hairline),
                ),
                child: Text(
                  dalil['arabic'] ?? '',
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.amiri(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    height: 2.0,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Indonesian Translation
              Text(
                'Terjemahan:',
                style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.secondary),
              ),
              const SizedBox(height: 4),
              Text(
                '"${dalil['translation'] ?? ''}"',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: AppColors.onSurface,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 14),
              // Faedah / Explanation
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh.withAlpha(120),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        dalil['explanation'] ?? '',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          color: AppColors.onSurfaceVariant,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text('Salin Dalil'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: '${dalil['arabic']}\n\n${dalil['translation']}\n(${dalil['source']})'));
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Teks dalil dan terjemahan disalin ke papan klip!')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Tutup'),
                    ),
                  ),
                ],
              ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // MODAL 2: KOMENTAR DISKUSI HIKMAH
  // ==========================================
  void _showCommentsModal(int index) {
    final comments = _reelComments[index] ?? [];
    final textController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: AppColors.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Komentar Diskusi Hikmah (${comments.length})',
                        style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20, color: AppColors.onSurfaceVariant),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const Divider(),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 320),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: comments.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (_, cIdx) {
                        final c = comments[cIdx];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.primaryFixed,
                              child: Text(
                                c['initials']!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        c['name']!,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        c['time']!,
                                        style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    c['comment']!,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: AppColors.onSurface,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                const Icon(Icons.favorite_border, size: 14, color: AppColors.outline),
                                const SizedBox(height: 2),
                                Text(
                                  c['likes'] ?? '0',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 9, color: AppColors.outline),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: textController,
                          style: GoogleFonts.plusJakartaSans(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Tulis komentar adem & berfaedah...',
                            hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.outline),
                            filled: true,
                            fillColor: AppColors.surfaceContainerLow,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.send_rounded, size: 18),
                        onPressed: () {
                          if (textController.text.trim().isNotEmpty) {
                            setModalState(() {
                              comments.insert(0, {
                                'name': 'Ummu Rayyan (Anda)',
                                'initials': 'UR',
                                'comment': textController.text.trim(),
                                'time': 'Baru saja',
                                'likes': '1',
                              });
                            });
                            textController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================
  // MODAL 3: BAGIKAN KEBAIKAN
  // ==========================================
  void _showShareModal(int index) {
    final reel = _reels[index];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bagikan Video Syiar',
                  style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildShareOption(Icons.link, 'Salin Tautan', () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tautan video syiar "${reel['title']}" berhasil disalin!')),
                      );
                    }),
                    _buildShareOption(Icons.chat, 'WhatsApp', () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Membuka WhatsApp untuk berbagi hikmah...')),
                      );
                    }),
                    _buildShareOption(Icons.camera_alt, 'Story IG', () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Menyiapkan format 9:16 untuk Instagram Story...')),
                      );
                    }),
                    _buildShareOption(Icons.send, 'Telegram', () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Membuka Telegram...')),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShareOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primaryFixed,
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(height: 6),
          Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  String _formatNumber(int num) {
    if (num >= 1000) {
      return '${(num / 1000).toStringAsFixed(1)}k';
    }
    return '$num';
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 650;

    return Scaffold(
      backgroundColor: Colors.black,
      body: CallbackShortcuts(
        bindings: <ShortcutActivator, VoidCallback>{
          const SingleActivator(LogicalKeyboardKey.arrowDown): _nextPage,
          const SingleActivator(LogicalKeyboardKey.arrowUp): _previousPage,
          const SingleActivator(LogicalKeyboardKey.space): _togglePlayPause,
          const SingleActivator(LogicalKeyboardKey.escape): () => Navigator.pop(context),
        },
        child: Focus(
          autofocus: true,
          child: Listener(
            onPointerSignal: (pointerSignal) {
              if (pointerSignal is PointerScrollEvent) {
                final now = DateTime.now();
                if (now.difference(_lastWheelTime).inMilliseconds > 400) {
                  _lastWheelTime = now;
                  if (pointerSignal.scrollDelta.dy > 10) {
                    _nextPage();
                  } else if (pointerSignal.scrollDelta.dy < -10) {
                    _previousPage();
                  }
                }
              }
            },
            child: Stack(
              children: [
                // Desktop Ambient Blurred Backdrop
                if (isDesktop)
                  Positioned.fill(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            _reels[_currentIndex]['image'] as String,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withAlpha(220),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Main TikTok Vertical Container
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isDesktop ? 480 : double.infinity,
                      maxHeight: double.infinity,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(isDesktop ? 28 : 0),
                      child: Stack(
                        children: [
                          // 1. Scrollable PageView with Mouse Drag Support (TikTok Vertical Swipe)
                          ScrollConfiguration(
                            behavior: const MaterialScrollBehavior().copyWith(
                              dragDevices: {
                                PointerDeviceKind.touch,
                                PointerDeviceKind.mouse,
                                PointerDeviceKind.trackpad,
                                PointerDeviceKind.stylus,
                              },
                            ),
                            child: PageView.builder(
                              controller: _pageController,
                              scrollDirection: Axis.vertical,
                              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                              itemCount: _reels.length,
                              onPageChanged: _onPageChanged,
                              itemBuilder: (context, index) {
                                return _buildReelPage(index);
                              },
                            ),
                          ),

                          // Desktop Up / Down Reel Navigation Controls
                          if (isDesktop) ...[
                            if (_currentIndex > 0)
                              Positioned(
                                right: 16,
                                top: 76,
                                child: FloatingActionButton.small(
                                  heroTag: 'prev_reel_fab',
                                  backgroundColor: Colors.black.withAlpha(160),
                                  foregroundColor: Colors.white,
                                  onPressed: () => _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  ),
                                  child: const Icon(Icons.keyboard_arrow_up, size: 24),
                                ),
                              ),
                            if (_currentIndex < _reels.length - 1)
                              Positioned(
                                right: 16,
                                bottom: 100,
                                child: FloatingActionButton.small(
                                  heroTag: 'next_reel_fab',
                                  backgroundColor: Colors.black.withAlpha(160),
                                  foregroundColor: Colors.white,
                                  onPressed: () => _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  ),
                                  child: const Icon(Icons.keyboard_arrow_down, size: 24),
                                ),
                              ),
                          ],

                          // 2. TOP BAR OVERLAY: Back, Mengikuti / Untuk Anda Tabs, Search
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: SafeArea(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withAlpha(190),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Back Button
                                    GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withAlpha(45),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.arrow_back_ios_new,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),

                                    // Dynamic Tab Switcher: Mengikuti / Untuk Anda
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Tab: Mengikuti
                                        GestureDetector(
                                          onTap: () {
                                            setState(() => _selectedFeedTab = 0);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            child: Text(
                                              'Mengikuti',
                                              style: GoogleFonts.syne(
                                                fontSize: 14,
                                                fontWeight: _selectedFeedTab == 0 ? FontWeight.w700 : FontWeight.w500,
                                                color: _selectedFeedTab == 0 ? Colors.white : Colors.white70,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        // Tab: Untuk Anda with Glowing Dot
                                        GestureDetector(
                                          onTap: () {
                                            setState(() => _selectedFeedTab = 1);
                                          },
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                child: Text(
                                                  'Untuk Anda',
                                                  style: GoogleFonts.syne(
                                                    fontSize: 14,
                                                    fontWeight: _selectedFeedTab == 1 ? FontWeight.w800 : FontWeight.w500,
                                                    color: _selectedFeedTab == 1 ? Colors.white : Colors.white70,
                                                    shadows: _selectedFeedTab == 1
                                                        ? [const Shadow(color: Colors.black54, blurRadius: 4)]
                                                        : null,
                                                  ),
                                                ),
                                              ),
                                              if (_selectedFeedTab == 1)
                                                Container(
                                                  width: 6,
                                                  height: 6,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.primaryFixed,
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: AppColors.primaryFixed.withAlpha(200),
                                                        blurRadius: 8,
                                                        spreadRadius: 1,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              else
                                                const SizedBox(height: 6),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Search & Mute Action Buttons
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() => _isMuted = !_isMuted);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(_isMuted ? 'Suara dimatikan (Mute)' : 'Suara aktif (Unmute)'),
                                                duration: const Duration(seconds: 1),
                                                behavior: SnackBarBehavior.floating,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withAlpha(45),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              _isMuted ? Icons.volume_off : Icons.volume_up,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () => showUniversalSearch(context),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withAlpha(45),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.search,
                                              color: Colors.white,
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // 3. Play/Pause Animated Pulse Indicator Overlay
                          if (_showPlayPauseOverlay)
                            Center(
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: _showPlayPauseOverlay ? 1.0 : 0.0,
                                child: Container(
                                  width: 68,
                                  height: 68,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(50),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white.withAlpha(90), width: 1.5),
                                  ),
                                  child: Icon(_playPauseIcon, color: Colors.white, size: 38),
                                ),
                              ),
                            ),

                          // 4. Double Tap Heart Burst Animation
                          if (_showHeartAnimation)
                            Positioned(
                              left: _heartPosition.dx - 45,
                              top: _heartPosition.dy - 45,
                              child: TweenAnimationBuilder<double>(
                                tween: Tween<double>(begin: 0.4, end: 1.3),
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.elasticOut,
                                builder: (context, scale, child) {
                                  return Transform.scale(
                                    scale: scale,
                                    child: const Icon(
                                      Icons.favorite_rounded,
                                      color: Colors.redAccent,
                                      size: 90,
                                      shadows: [
                                        Shadow(color: Colors.black54, blurRadius: 16),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),

                          // 5. Glowing Bottom Timeline Scrub Bar
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: _buildBottomScrubBar(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Desktop Quick Navigation Chevron Buttons
                if (isDesktop) ...[
                  if (_currentIndex > 0)
                    Positioned(
                      top: MediaQuery.of(context).size.height / 2 - 60,
                      right: (MediaQuery.of(context).size.width - 480) / 4,
                      child: _buildDesktopNavButton(
                        icon: Icons.keyboard_arrow_up_rounded,
                        tooltip: 'Video Sebelumnya (Panah Atas)',
                        onTap: _previousPage,
                      ),
                    ),
                  if (_currentIndex < _reels.length - 1)
                    Positioned(
                      top: MediaQuery.of(context).size.height / 2 + 10,
                      right: (MediaQuery.of(context).size.width - 480) / 4,
                      child: _buildDesktopNavButton(
                        icon: Icons.keyboard_arrow_down_rounded,
                        tooltip: 'Video Berikutnya (Panah Bawah / Scroll)',
                        onTap: _nextPage,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopNavButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(40),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withAlpha(60)),
              boxShadow: const [
                BoxShadow(color: Colors.black38, blurRadius: 10),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // SINGLE REEL PAGE CONTENT
  // ==========================================
  Widget _buildReelPage(int index) {
    final reel = _reels[index];
    final isLiked = _likedReels[index] ?? false;
    final likeCount = _likeCounts[index] ?? (reel['likes'] as int);
    final isSaved = _savedReels[index] ?? false;
    final saveCount = _savedCounts[index] ?? (reel['saves'] as int);
    final isFollowed = _followedCreators[index] ?? false;
    final isExpanded = _captionExpanded[index] ?? false;
    final comments = _reelComments[index] ?? [];

    return GestureDetector(
      onTap: _togglePlayPause,
      onDoubleTapDown: _handleDoubleTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Video Visual Artwork
          Image.asset(
            reel['image'] as String,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              color: AppColors.primary,
              child: const Center(
                child: Icon(Icons.videocam_off, color: Colors.white54, size: 48),
              ),
            ),
          ),

          // Cinematic Ambient Gradient Overlays for Readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withAlpha(180),
                  Colors.transparent,
                  Colors.black.withAlpha(60),
                  AppColors.primary.withAlpha(240),
                ],
                stops: const [0.0, 0.25, 0.55, 1.0],
              ),
            ),
          ),

          // Tap stage zone (empty middle transparent area for gestures)
          Positioned.fill(child: Container(color: Colors.transparent)),

          // LOWER SECTION: LEFT CAPTION & RIGHT ACTIONS
          Positioned(
            left: 16,
            right: 14,
            bottom: 38, // Above timeline scrub bar
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Left Column: Creator Information, Insightful Caption, Dalil Chip & Audio
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Creator Header & Verification Badge & Follow Pill
                      Row(
                        children: [
                          Text(
                            reel['handle'] as String,
                            style: GoogleFonts.syne(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.verified, color: AppColors.secondaryFixed, size: 15),
                          const SizedBox(width: 6),
                          const Text('•', style: TextStyle(color: Colors.white60, fontSize: 12)),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () => _toggleFollow(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: isFollowed
                                    ? AppColors.primaryFixed.withAlpha(220)
                                    : Colors.white.withAlpha(50),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isFollowed ? AppColors.primaryFixed : Colors.white.withAlpha(80),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                isFollowed ? 'Mengikuti' : 'Ikuti',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: isFollowed ? AppColors.primary : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Video Caption / Spiritual Wisdom
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _captionExpanded[index] = !isExpanded;
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reel['quote'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: Colors.white.withAlpha(240),
                                height: 1.4,
                                shadows: const [Shadow(color: Colors.black87, blurRadius: 4)],
                              ),
                              maxLines: isExpanded ? 6 : 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isExpanded ? 'ciutkan' : 'selengkapnya',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryFixed,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Thematic Spiritual Tags
                      Wrap(
                        spacing: 6,
                        children: (reel['tags'] as List<String>).map((t) {
                          return Text(
                            t,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondaryFixed,
                              shadows: const [Shadow(color: Colors.black87, blurRadius: 4)],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),

                      // Interactive Hadith / Dalil Chip
                      if (reel['dalil'] != null)
                        GestureDetector(
                          onTap: () => _showDalilModal(context, reel['dalil'] as Map<String, dynamic>),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer.withAlpha(200),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(color: Colors.black26, blurRadius: 6),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.auto_stories,
                                  color: AppColors.primaryFixed,
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    'Rujukan: ${(reel['dalil'] as Map<String, dynamic>)['source']} • Ketuk baca dalil',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.onPrimaryContainer,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_forward_ios, size: 9, color: AppColors.onPrimaryContainer),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),

                      // Audio Sound Track Pill with Marquee Feeling
                      Row(
                        children: [
                          const Icon(Icons.music_note, color: Colors.white70, size: 14),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              reel['audio'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                color: Colors.white.withAlpha(210),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),

                // Right Column: Vertical Action Bar (Icons & Counts)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Creator Avatar with Glow & Quick Follow '+'
                    GestureDetector(
                      onTap: () => _toggleFollow(index),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.primaryFixed,
                                  Colors.white,
                                  AppColors.secondaryFixed,
                                ],
                              ),
                              boxShadow: const [
                                BoxShadow(color: Colors.black45, blurRadius: 8),
                              ],
                            ),
                            child: CircleAvatar(
                              backgroundColor: reel['avatarBg'] as Color,
                              child: Text(
                                reel['initials'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -5,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: isFollowed ? Colors.green : AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 1.5),
                              ),
                              child: Icon(
                                isFollowed ? Icons.check : Icons.add,
                                color: Colors.white,
                                size: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Action 1: Like (Suka)
                    GestureDetector(
                      onTap: () => _toggleLike(index),
                      child: Column(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(isLiked ? 60 : 45),
                              shape: BoxShape.circle,
                            ),
                            child: AnimatedScale(
                              scale: isLiked ? 1.2 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                color: isLiked ? Colors.redAccent : Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _formatNumber(likeCount),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Action 2: Comments (Komentar Diskusi Hikmah)
                    GestureDetector(
                      onTap: () => _showCommentsModal(index),
                      child: Column(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(45),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.mode_comment,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${comments.length}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Action 3: Bookmark / Simpan Faedah
                    GestureDetector(
                      onTap: () => _toggleSave(index),
                      child: Column(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(45),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isSaved ? Icons.bookmark : Icons.bookmark_border,
                              color: isSaved ? AppColors.secondaryFixed : Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _formatNumber(saveCount),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Action 4: Share (Bagikan Kebaikan)
                    GestureDetector(
                      onTap: () => _showShareModal(index),
                      child: Column(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(45),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _formatNumber(reel['shares'] as int),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Rotating Vinyl Audio Hub
                    RotationTransition(
                      turns: _vinylController,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF1E1E26),
                          border: Border.all(color: Colors.white.withAlpha(120), width: 1.5),
                          boxShadow: const [
                            BoxShadow(color: Colors.black54, blurRadius: 6),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.graphic_eq,
                            size: 16,
                            color: AppColors.primaryFixed,
                          ),
                        ),
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

  // ==========================================
  // SCRUB BAR / BOTTOM TIMELINE PROGRESS
  // ==========================================
  Widget _buildBottomScrubBar() {
    final curReel = _reels[_currentIndex];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withAlpha(200),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                curReel['currentTime'] ?? '00:42',
                style: GoogleFonts.spaceGrotesk(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryFixed,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'AUDIO JERNIH',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: AppColors.primaryFixed,
                    ),
                  ),
                ],
              ),
              Text(
                curReel['duration'] ?? '00:58',
                style: GoogleFonts.spaceGrotesk(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Glowing Interactive Progress Track
          AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // Base background bar
                  Container(
                    width: double.infinity,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(50),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Buffered bar
                  FractionallySizedBox(
                    widthFactor: 0.85,
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(70),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  // Active Glowing Progress Bar
                  FractionallySizedBox(
                    widthFactor: _progressController.value,
                    child: Container(
                      height: 3.5,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primaryFixed, AppColors.secondaryFixed],
                        ),
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryFixed.withAlpha(180),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
