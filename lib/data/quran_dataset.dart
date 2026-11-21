// DATASET & MODEL AL-QUR'AN DIGITAL (NOOR SANCTUARY)

class AyahModel {
  final int number;
  final String arabic;
  final String translation;
  final String? audioUrl;
  final String? tadabburTitle; // "Tadabbur Kalam", "Renungan Hati", "Penyejuk Jiwa", "Peringatan Ruhani"
  final String? tadabburText;
  final String? tajwidAnalysis;

  const AyahModel({
    required this.number,
    required this.arabic,
    required this.translation,
    this.audioUrl,
    this.tadabburTitle,
    this.tadabburText,
    this.tajwidAnalysis,
  });
}

class SurahModel {
  final int number;
  final String name;
  final String arabic;
  final String meaning;
  final String type; // Makkiyah / Madaniyah
  final int ayahsCount;
  final int juz;
  final int page;
  final String? badge; // "Sedang Dibaca (28%)", "Amalan Tidur", "Sunnah Hari Jumat"
  final String? fullAudioUrl;
  final List<AyahModel> ayahs;

  const SurahModel({
    required this.number,
    required this.name,
    required this.arabic,
    required this.meaning,
    required this.type,
    required this.ayahsCount,
    this.juz = 1,
    this.page = 1,
    this.badge,
    this.fullAudioUrl,
    required this.ayahs,
  });
}

class JuzInfoModel {
  final int number;
  final String title;
  final String arabicName;
  final String pageRange;
  final int pageStart;
  final int pageEnd;
  final String surahRange;
  final int totalAyahs;
  final String hizbInfo;
  final String status; // "Selesai", "Sedang Dibaca", "Belum Dibaca"
  final double progress; // 0.0 to 1.0

  const JuzInfoModel({
    required this.number,
    required this.title,
    required this.arabicName,
    required this.pageRange,
    required this.pageStart,
    required this.pageEnd,
    required this.surahRange,
    required this.totalAyahs,
    required this.hizbInfo,
    required this.status,
    required this.progress,
  });
}

final List<JuzInfoModel> kJuzList = [
  const JuzInfoModel(
    number: 1,
    title: 'Juz 1',
    arabicName: 'الم (Alif Lam Mim)',
    pageRange: 'Hal. 1 - 21 • 21 Lembar',
    pageStart: 1,
    pageEnd: 21,
    surahRange: 'QS. Al-Fatihah 1 — QS. Al-Baqarah 141',
    totalAyahs: 148,
    hizbInfo: 'Struktur 2 Hizb • 4 Maqra\'',
    status: 'Selesai',
    progress: 1.0,
  ),
  const JuzInfoModel(
    number: 15,
    title: 'Juz 15',
    arabicName: 'سُبْحَانَ الَّذِي (Subhanalladzi)',
    pageRange: 'Hal. 282 - 301 • Hal 293 saat ini',
    pageStart: 282,
    pageEnd: 301,
    surahRange: 'QS. Al-Isra\' 1 — QS. Al-Kahf 74',
    totalAyahs: 185,
    hizbInfo: 'Hizb 29 & 30 (Pertengahan Al-Qur\'an)',
    status: 'Sedang Dibaca',
    progress: 0.60,
  ),
  const JuzInfoModel(
    number: 30,
    title: 'Juz 30 (Juz \'Amma)',
    arabicName: 'عَمَّ (\'Amma)',
    pageRange: 'Hal. 582 - 604 • 37 Surah Pendek',
    pageStart: 582,
    pageEnd: 604,
    surahRange: 'QS. An-Naba\' 1 — QS. An-Nas 6',
    totalAyahs: 564,
    hizbInfo: 'Hizb 59 & 60 (Penutup Khatam)',
    status: 'Belum Dibaca',
    progress: 0.05,
  ),
];

final List<SurahModel> kQuranSurahs = [
  // 1. Al-Fatihah
  const SurahModel(
    number: 1,
    name: 'Al-Fatihah',
    arabic: 'الفاتحة',
    meaning: 'Pembukaan',
    type: 'Makkiyah',
    ayahsCount: 7,
    juz: 1,
    page: 1,
    badge: 'Ummul Kitab',
    fullAudioUrl: 'https://server8.mp3quran.net/afs/001.mp3',
    ayahs: [
      AyahModel(
        number: 1,
        arabic: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        translation: 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.',
        tadabburTitle: 'Pondasi Keberkahan',
        tadabburText: 'Memulai setiap ucapan dan perbuatan dengan Nama Allah menghadirkan penjagaan Ilahi dan menghalau bisikan keburukan.',
        audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/001001.mp3',
      ),
      AyahModel(
        number: 2,
        arabic: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        translation: 'Segala puji bagi Allah, Tuhan seluruh alam.',
        tadabburTitle: 'Hakikat Syukur',
        tadabburText: 'Pujian mutlak yang menyadarkan hamba bahwa tiada setetes nikmat pun melainkan bersumber dari Sang Maha Pemelihara alam semesta.',
        audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/001002.mp3',
      ),
      AyahModel(
        number: 3,
        arabic: 'الرَّحْمَٰنِ الرَّحِيمِ',
        translation: 'Yang Maha Pengasih, Maha Penyayang.',
        tadabburTitle: 'Rahmat Yang Luas',
        tadabburText: 'Rahmat-Nya meliputi seluruh makhluk di dunia dan dikhususkan untuk hamba-hamba beriman di akhirat kelak.',
        audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/001003.mp3',
      ),
      AyahModel(
        number: 4,
        arabic: 'مَالِكِ يَوْمِ الدِّينِ',
        translation: 'Pemilik hari pembalasan.',
        tadabburTitle: 'Keadilan Mutlak',
        tadabburText: 'Mengingatkan kita akan hari ketika seluruh kekuasaan fana runtuh, dan hanya keputusan Allah yang berlaku seadil-adilnya.',
        audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/001004.mp3',
      ),
      AyahModel(
        number: 5,
        arabic: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
        translation: 'Hanya kepada Engkaulah kami menyembah dan hanya kepada Engkaulah kami memohon pertolongan.',
        tadabburTitle: 'Ikrar Tauhid',
        tadabburText: 'Puncak ketundukan seorang muslim: melepaskan ketergantungan pada makhluk dan bersandar sepenuhnya kepada Allah Ta\'ala.',
        audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/001005.mp3',
      ),
      AyahModel(
        number: 6,
        arabic: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
        translation: 'Tunjukilah kami jalan yang lurus,',
        tadabburTitle: 'Doa Utama',
        tadabburText: 'Hidayah adalah bekal paling bernilai di dunia. Doa yang senantiasa diulang dalam setiap rakaat shalat untuk istiqamah.',
        audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/001006.mp3',
      ),
      AyahModel(
        number: 7,
        arabic: 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
        translation: '(yaitu) jalan orang-orang yang telah Engkau beri nikmat kepadanya; bukan (jalan) mereka yang dimurkai, dan bukan (pula jalan) mereka yang sesat.',
        tadabburTitle: 'Teladan Salafus Shalih',
        tadabburText: 'Jalan para nabi, shiddiqin, syuhada, dan shalihin, bukan jalan mereka yang berilmu tanpa amal atau beramal tanpa ilmu.',
        audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/001007.mp3',
      ),
    ],
  ),

  // 2. Al-Baqarah
  const SurahModel(
    number: 2,
    name: 'Al-Baqarah',
    arabic: 'البقرة',
    meaning: 'Sapi Betina',
    type: 'Madaniyyah',
    ayahsCount: 286,
    juz: 1,
    page: 2,
    badge: 'Puncak Al-Qur\'an',
    fullAudioUrl: 'https://server8.mp3quran.net/afs/002.mp3',
    ayahs: [
      AyahModel(
        number: 1,
        arabic: 'الم',
        translation: 'Alif Lam Mim.',
        tadabburTitle: 'Huruf Muqatha\'ah',
        tadabburText: 'Tanda keagungan mukjizat Kalamullah yang menunjukkan kelemahan akal manusia memahami rahasia Ilahi melainkan dengan petunjuk-Nya.',
      ),
      AyahModel(
        number: 2,
        arabic: 'ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِّلْمُتَّقِينَ',
        translation: 'Kitab (Al-Qur\'an) ini tidak ada keraguan padanya; petunjuk bagi mereka yang bertakwa,',
        tadabburTitle: 'Sumber Petunjuk Mutlak',
        tadabburText: 'Kitab suci yang bersih dari segala cacat dan keraguan, menjadi pelita abadi bagi hamba yang takut dan taat pada Rabb-nya.',
      ),
      AyahModel(
        number: 186,
        arabic: 'وَإِذَا سَأَلَكَ عِبَادِي عَنِّي فَإِنِّي قَرِيبٌ ۖ أُجِيبُ دَعْوَةَ الدَّاعِ إِذَا دَعَانِ',
        translation: 'Dan apabila hamba-hamba-Ku bertanya kepadamu (Muhammad) tentang Aku, maka sesungguhnya Aku adalah dekat. Aku mengabulkan permohonan orang yang berdoa apabila dia berdoa kepada-Ku...',
        tadabburTitle: 'Kedekatan Doa & Tawakkal',
        tadabburText: 'Tiada perantara antara seorang hamba dengan Tuhannya. Ketika lisan basah dengan munajat tulus, pintu pertolongan Allah terbuka seketika.',
      ),
      AyahModel(
        number: 255,
        arabic: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ',
        translation: 'Allah, tidak ada tuhan selain Dia. Yang Mahahidup, Yang terus-menerus mengurus (makhluk-Nya), tidak mengantuk dan tidak tidur...',
        tadabburTitle: 'Ayat Kursi: Keagungan Asma Allah',
        tadabburText: 'Ayat teragung dalam Al-Qur\'an yang menegakkan pondasi tauhid, perlindungan dari segala mara bahaya syaitan dan jin.',
      ),
    ],
  ),

  // 18. Al-Kahf
  const SurahModel(
    number: 18,
    name: 'Al-Kahf',
    arabic: 'الكهف',
    meaning: 'Penghuni Gua',
    type: 'Makkiyah',
    ayahsCount: 110,
    juz: 15,
    page: 293,
    badge: 'Sedang Dibaca (28%)',
    fullAudioUrl: 'https://server8.mp3quran.net/afs/018.mp3',
    ayahs: [
      AyahModel(
        number: 1,
        arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَنزَلَ عَلَىٰ عَبْدِهِ الْكِتَابَ وَلَمْ يَجْعَل لَّهُ عِوَجًا',
        translation: 'Segala puji bagi Allah yang telah menurunkan Kitab (Al-Qur\'an) kepada hamba-Nya dan Dia tidak menjadikannya bengkok;',
        tadabburTitle: 'Lurus Tanpa Cela',
        tadabburText: 'Al-Qur\'an adalah pedoman yang lurus, tidak condong pada kebatilan, menjadi benteng utama dari fitnah zaman dan Dajjal.',
      ),
      AyahModel(
        number: 10,
        arabic: 'إِذْ أَوَى الْفِتْيَةُ إِلَى الْكَهْفِ فَقَالُوا رَبَّنَا آتِنَا مِن لَّدُنكَ رَحْمَةً وَهَيِّئْ لَنَا مِنْ أَمْرِنَا رَشَدًا',
        translation: '(Ingatlah) ketika pemuda-pemuda itu berlindung ke dalam gua lalu mereka berdoa, "Ya Tuhan kami, berikanlah rahmat kepada kami dari sisi-Mu dan sempurnakanlah petunjuk bagi kami dalam urusan kami."',
        tadabburTitle: 'Doa Menghadapi Keterasingan',
        tadabburText: 'Teladan pemuda bertauhid yang memilih menyelamatkan aqidah daripada kemewahan dunia, diselamatkan Allah dengan cara luar biasa.',
      ),
    ],
  ),

  // 36. Ya-Sin
  const SurahModel(
    number: 36,
    name: 'Ya-Sin',
    arabic: 'يس',
    meaning: 'Yasin',
    type: 'Makkiyah',
    ayahsCount: 83,
    juz: 22,
    page: 440,
    badge: 'Jantung Al-Qur\'an',
    fullAudioUrl: 'https://server8.mp3quran.net/afs/036.mp3',
    ayahs: [
      AyahModel(
        number: 1,
        arabic: 'يس',
        translation: 'Yaa Siin.',
      ),
      AyahModel(
        number: 2,
        arabic: 'وَالْقُرْآنِ الْحَكِيمِ',
        translation: 'Demi Al-Qur\'an yang penuh hikmah,',
      ),
      AyahModel(
        number: 3,
        arabic: 'إِنَّكَ لَمِنَ الْمُرْسَلِينَ',
        translation: 'sungguh, engkau (Muhammad) adalah salah seorang dari rasul-rasul,',
      ),
    ],
  ),

  // 55. Ar-Rahman
  const SurahModel(
    number: 55,
    name: 'Ar-Rahman',
    arabic: 'الرحمن',
    meaning: 'Maha Pengasih',
    type: 'Madaniyyah',
    ayahsCount: 78,
    juz: 27,
    page: 531,
    badge: 'Pengantin Al-Qur\'an',
    fullAudioUrl: 'https://server8.mp3quran.net/afs/055.mp3',
    ayahs: [
      AyahModel(
        number: 1,
        arabic: 'الرَّحْمَٰنُ',
        translation: '(Allah) Yang Maha Pengasih,',
      ),
      AyahModel(
        number: 2,
        arabic: 'عَلَّمَ الْقُرْآنَ',
        translation: 'Yang telah mengajarkan Al-Qur\'an.',
      ),
      AyahModel(
        number: 13,
        arabic: 'فَبِأَيِّ آلَاءِ رَبِّكُمَا تُكَذِّبَانِ',
        translation: 'Maka nikmat Tuhanmu yang manakah yang kamu dustakan?',
      ),
    ],
  ),

  // 56. Al-Waqi'ah
  const SurahModel(
    number: 56,
    name: 'Al-Waqi\'ah',
    arabic: 'الواقعة',
    meaning: 'Hari Kiamat',
    type: 'Makkiyah',
    ayahsCount: 96,
    juz: 27,
    page: 534,
    badge: 'Pencegah Kefakiran',
    fullAudioUrl: 'https://server8.mp3quran.net/afs/056.mp3',
    ayahs: [
      AyahModel(
        number: 1,
        arabic: 'إِذَا وَقَعَتِ الْوَاقِعَةُ',
        translation: 'Apabila terjadi hari kiamat,',
      ),
      AyahModel(
        number: 2,
        arabic: 'لَيْسَ لِوَقْعَتِهَا كَاذِبَةٌ',
        translation: 'terjadinya tidak dapat didustakan (pasti terjadi).',
      ),
    ],
  ),

  // 67. Al-Mulk
  const SurahModel(
    number: 67,
    name: 'Al-Mulk',
    arabic: 'الملك',
    meaning: 'Kerajaan',
    type: 'Makkiyah',
    ayahsCount: 30,
    juz: 29,
    page: 562,
    badge: 'Amalan Tidur',
    fullAudioUrl: 'https://server8.mp3quran.net/afs/067.mp3',
    ayahs: [
      AyahModel(
        number: 1,
        arabic: 'تَبَارَكَ الَّذِي بِيَدِهِ الْمُلْكُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ',
        translation: 'Mahasuci Allah yang di tangan-Nyalah segala kerajaan, dan Dia Mahakuasa atas segala sesuatu.',
        tadabburTitle: 'Kedaulatan Mutlak',
        tadabburText: 'Hanya di tangan Allah segala urusan dunia dan akhirat. Membaca surah ini setiap malam menjadi pelindung dari adzab kubur.',
      ),
      AyahModel(
        number: 2,
        arabic: 'الَّذِي خَلَقَ الْمَوْتَ وَالْحَيَاةَ لِيَبْلُوَكُمْ أَيُّكُمْ أَحْسَنُ عَمَلًا',
        translation: 'Yang menciptakan mati dan hidup, untuk menguji kamu, siapa di antara kamu yang lebih baik amalnya.',
        tadabburTitle: 'Tujuan Penciptaan',
        tadabburText: 'Hidup dan mati diciptakan bukan untuk banyak-banyakan harta, melainkan untuk menguji siapa yang amalnya paling ikhlas dan sesuai sunnah.',
      ),
    ],
  ),

  // 78. An-Naba' (Surah Unggulan dalam Desain Mockup)
  const SurahModel(
    number: 78,
    name: 'An-Naba\'',
    arabic: 'النبأ',
    meaning: 'Berita Besar',
    type: 'Makkiyah',
    ayahsCount: 40,
    juz: 30,
    page: 582,
    badge: 'Awal Juz \'Amma',
    fullAudioUrl: 'https://server8.mp3quran.net/afs/078.mp3',
    ayahs: [
      AyahModel(
        number: 1,
        arabic: 'عَمَّ يَتَسَآءَلُونَ',
        translation: 'Tentang apakah mereka saling bertanya-tanya?',
        tadabburTitle: 'Tadabbur Kalam',
        tadabburText: 'Pertanyaan pembuka yang mengguncang kesadaran nurani kaum musyrikin Quraisy akan kepastian Hari Pembalasan yang mutlak.',
        tajwidAnalysis: 'عَمَّ (Ghunnah Musyaddadah), يَتَسَآءَلُونَ (Mad Wajib Muttashil 4-5 Harakat)',
        audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/078001.mp3',
      ),
      AyahModel(
        number: 2,
        arabic: 'عَنِ النَّبَإِ الْعَظِيمِ',
        translation: 'Tentang berita yang besar (hari kebangkitan).',
        tadabburTitle: 'Renungan Hati',
        tadabburText: 'An-Naba\' Al-\'Azhim adalah peristiwa kebangkitan agung ketika seluruh rahasia dan amalan manusia dibuka seadil-adilnya di hadapan Sang Maha Kuasa.',
        tajwidAnalysis: 'النَّبَإِ (Ghunnah Musyaddadah & Alif Lam Syamsiyyah), الْعَظِيمِ (Alif Lam Qamariyyah & Mad \'Aridh Lissukun)',
        audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/078002.mp3',
      ),
      AyahModel(
        number: 3,
        arabic: 'الَّذِي هُمْ فِيهِ مُخْتَلِفُونَ',
        translation: 'yang dalam hal itu mereka berselisih.',
        tadabburTitle: 'Penyejuk Jiwa',
        tadabburText: 'Keraguan duniawi tak pernah mengubah ketetapan Ilahi. Kembalikan keyakinan hati pada wahyu agar langkah tidak goyah dalam perselisihan zaman.',
        tajwidAnalysis: 'هُمْ فِيهِ (Idzhar Syafawi), مُخْتَلِفُونَ (Mad \'Aridh Lissukun)',
        audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/078003.mp3',
      ),
      AyahModel(
        number: 4,
        arabic: 'كَلَّا سَيَعْلَمُونَ',
        translation: 'Sekali-kali tidak! Kelak mereka akan mengetahui,',
        tadabburTitle: 'Peringatan Ruhani',
        tadabburText: 'Penegasan tegas bahwa segala yang mereka ingkari niscaya tersingkap dengan nyata tanpa keraguan sedikit pun.',
        tajwidAnalysis: 'كَلَّا (Mad Thabi\'i), سَيَعْلَمُونَ (Mad \'Aridh Lissukun)',
        audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/078004.mp3',
      ),
      AyahModel(
        number: 5,
        arabic: 'ثُمَّ كَلَّا سَيَعْلَمُونَ',
        translation: 'kemudian sekali-kali tidak! Kelak mereka akan mengetahui.',
        tadabburTitle: 'Ketegasan Peringatan',
        tadabburText: 'Pengulangan peringatan Ilahi untuk menghujamkan rasa takut dan taubat sebelum tiba saatnya tirai hisab dibuka.',
        tajwidAnalysis: 'ثُمَّ (Ghunnah Musyaddadah Mim Bertasydid)',
        audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/078005.mp3',
      ),
    ],
  ),

  // 79. An-Nazi'at
  const SurahModel(
    number: 79,
    name: 'An-Nazi\'at',
    arabic: 'النازعات',
    meaning: 'Malaikat yang Mencabut',
    type: 'Makkiyah',
    ayahsCount: 46,
    juz: 30,
    page: 583,
    fullAudioUrl: 'https://server8.mp3quran.net/afs/079.mp3',
    ayahs: [
      AyahModel(
        number: 1,
        arabic: 'وَالنَّازِعَاتِ غَرْقًا',
        translation: 'Demi (malaikat-malaikat) yang mencabut (nyawa) dengan keras,',
      ),
    ],
  ),

  // 80. 'Abasa
  const SurahModel(
    number: 80,
    name: '\'Abasa',
    arabic: 'عبس',
    meaning: 'Bermuka Masam',
    type: 'Makkiyah',
    ayahsCount: 42,
    juz: 30,
    page: 585,
    fullAudioUrl: 'https://server8.mp3quran.net/afs/080.mp3',
    ayahs: [
      AyahModel(
        number: 1,
        arabic: 'عَبَسَ وَتَوَلَّىٰ',
        translation: 'Dia (Muhammad) berwajah masam dan berpaling,',
      ),
    ],
  ),

  // 81. At-Takwir
  const SurahModel(
    number: 81,
    name: 'At-Takwir',
    arabic: 'التكوير',
    meaning: 'Menggulung',
    type: 'Makkiyah',
    ayahsCount: 29,
    juz: 30,
    page: 586,
    badge: 'Lancar',
    fullAudioUrl: 'https://server8.mp3quran.net/afs/081.mp3',
    ayahs: [
      AyahModel(
        number: 1,
        arabic: 'إِذَا الشَّمْسُ كُوِّرَتْ',
        translation: 'Apabila matahari digulung,',
      ),
    ],
  ),

  // 82. Al-Infitar
  const SurahModel(
    number: 82,
    name: 'Al-Infitar',
    arabic: 'الانفطار',
    meaning: 'Terbelah',
    type: 'Makkiyah',
    ayahsCount: 19,
    juz: 30,
    page: 587,
    badge: '96% AI',
    fullAudioUrl: 'https://server8.mp3quran.net/afs/082.mp3',
    ayahs: [
      AyahModel(
        number: 1,
        arabic: 'إِذَا السَّمَاءُ انفَطَرَتْ',
        translation: 'Apabila langit terbelah,',
      ),
    ],
  ),

  // 93. Ad-Dhuha
  const SurahModel(
    number: 93,
    name: 'Ad-Dhuha',
    arabic: 'الضحى',
    meaning: 'Waktu Dhuha',
    type: 'Makkiyah',
    ayahsCount: 11,
    juz: 30,
    page: 596,
    badge: 'Mutqin',
    fullAudioUrl: 'https://server8.mp3quran.net/afs/093.mp3',
    ayahs: [
      AyahModel(
        number: 1,
        arabic: 'وَالضُّحَىٰ',
        translation: 'Demi waktu dhuha (ketika matahari naik sepenggalah),',
      ),
      AyahModel(
        number: 2,
        arabic: 'وَاللَّيْلِ إِذَا سَجَىٰ',
        translation: 'dan demi malam apabila telah sunyi,',
      ),
      AyahModel(
        number: 3,
        arabic: 'مَا وَدَّعَكَ رَبُّكَ وَمَا قَلَىٰ',
        translation: 'Tuhanmu tidak meninggalkan engkau (Muhammad) dan tidak (pula) membencimu,',
      ),
    ],
  ),

  // 94. Al-Insyirah
  const SurahModel(
    number: 94,
    name: 'Al-Insyirah',
    arabic: 'الانشراح',
    meaning: 'Kelapangan',
    type: 'Makkiyah',
    ayahsCount: 8,
    juz: 30,
    page: 596,
    badge: 'Mutqin',
    fullAudioUrl: 'https://server8.mp3quran.net/afs/094.mp3',
    ayahs: [
      AyahModel(
        number: 1,
        arabic: 'أَلَمْ نَشْرَحْ لَكَ صَدْرَكَ',
        translation: 'Bukankah Kami telah melapangkan dadamu (Muhammad)?',
        audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/094001.mp3',
      ),
      AyahModel(
        number: 2,
        arabic: 'وَوَضَعْنَا عَنكَ وِزْرَكَ',
        translation: 'dan Kami pun telah menurunkan bebanmu darimu,',
        audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/094002.mp3',
      ),
      AyahModel(
        number: 3,
        arabic: 'الَّذِي أَنقَضَ ظَهْرَكَ',
        translation: 'yang memberatkan punggungmu,',
        audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/094003.mp3',
      ),
      AyahModel(
        number: 4,
        arabic: 'وَرَفَعْنَا لَكَ ذِكْرَكَ',
        translation: 'dan Kami tinggikan bagimu sebutan (nama)-mu.',
        audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/094004.mp3',
      ),
      AyahModel(
        number: 5,
        arabic: 'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا',
        translation: 'Maka sesungguhnya beserta kesulitan ada kemudahan,',
        audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/094005.mp3',
      ),
      AyahModel(
        number: 6,
        arabic: 'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
        translation: 'sesungguhnya beserta kesulitan itu ada kemudahan.',
        audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/094006.mp3',
      ),
      AyahModel(
        number: 7,
        arabic: 'فَإِذَا فَرَغْتَ فَانصَبْ',
        translation: 'Maka apabila engkau telah selesai (dari suatu urusan), tetaplah bekerja keras (untuk urusan yang lain),',
        audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/094007.mp3',
      ),
      AyahModel(
        number: 8,
        arabic: 'وَإِلَىٰ رَبِّكَ فَارْغَب',
        translation: 'dan hanya kepada Tuhanmulah engkau berharap.',
        audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/094008.mp3',
      ),
    ],
  ),

  // 112. Al-Ikhlas
  const SurahModel(
    number: 112,
    name: 'Al-Ikhlas',
    arabic: 'الإخلاص',
    meaning: 'Keesaan Allah',
    type: 'Makkiyah',
    ayahsCount: 4,
    juz: 30,
    page: 604,
    badge: 'Mutqin',
    fullAudioUrl: 'https://server8.mp3quran.net/afs/112.mp3',
    ayahs: [
      AyahModel(
        number: 1,
        arabic: 'قُلْ هُوَ اللَّهُ أَحَدٌ',
        translation: 'Katakanlah (Muhammad), "Dialah Allah, Yang Maha Esa."',
        audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/112001.mp3',
      ),
      AyahModel(
        number: 2,
        arabic: 'اللَّهُ الصَّمَدُ',
        translation: 'Allah tempat meminta segala sesuatu.',
        audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/112002.mp3',
      ),
      AyahModel(
        number: 3,
        arabic: 'لَمْ يَلِدْ وَلَمْ يُولَدْ',
        translation: '(Allah) tidak beranak dan tidak pula diperanakkan,',
        audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/112003.mp3',
      ),
      AyahModel(
        number: 4,
        arabic: 'وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ',
        translation: 'dan tidak ada sesuatu yang setara dengan Dia.',
        audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/112004.mp3',
      ),
    ],
  ),

  // 113. Al-Falaq
  const SurahModel(
    number: 113,
    name: 'Al-Falaq',
    arabic: 'الفلق',
    meaning: 'Waktu Subuh',
    type: 'Makkiyah',
    ayahsCount: 5,
    juz: 30,
    page: 604,
    badge: 'Mutqin',
    fullAudioUrl: 'https://server8.mp3quran.net/afs/113.mp3',
    ayahs: [
      AyahModel(
        number: 1,
        arabic: 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ',
        translation: 'Katakanlah, "Aku berlindung kepada Tuhan yang menguasai subuh (fajar),',
      ),
    ],
  ),

  // 114. An-Nas
  const SurahModel(
    number: 114,
    name: 'An-Nas',
    arabic: 'الناس',
    meaning: 'Manusia',
    type: 'Makkiyah',
    ayahsCount: 6,
    juz: 30,
    page: 604,
    badge: 'Mutqin',
    fullAudioUrl: 'https://server8.mp3quran.net/afs/114.mp3',
    ayahs: [
      AyahModel(
        number: 1,
        arabic: 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ',
        translation: 'Katakanlah, "Aku berlindung kepada Tuhannya manusia,',
      ),
    ],
  ),
];
