class HadithItem {
  final String title;
  final String narrator;
  final String arabic;
  final String translation;
  final String explanation;

  const HadithItem({
    required this.title,
    required this.narrator,
    required this.arabic,
    required this.translation,
    required this.explanation,
  });
}

class DoaItem {
  final String title;
  final String category;
  final String arabic;
  final String latin;
  final String translation;
  final String reference;

  const DoaItem({
    required this.title,
    required this.category,
    required this.arabic,
    required this.latin,
    required this.translation,
    required this.reference,
  });
}

class AsmaulHusnaItem {
  final int number;
  final String arabic;
  final String latin;
  final String meaning;

  const AsmaulHusnaItem({
    required this.number,
    required this.arabic,
    required this.latin,
    required this.meaning,
  });
}

class KisahNabiItem {
  final String name;
  final String title;
  final String era;
  final String summary;
  final String keyLesson;

  const KisahNabiItem({
    required this.name,
    required this.title,
    required this.era,
    required this.summary,
    required this.keyLesson,
  });
}

class TajwidRuleItem {
  final String ruleName;
  final String category;
  final String letters;
  final String description;
  final String exampleArabic;
  final String exampleExplanation;

  const TajwidRuleItem({
    required this.ruleName,
    required this.category,
    required this.letters,
    required this.description,
    required this.exampleArabic,
    required this.exampleExplanation,
  });
}

class IslamicDataRepository {
  static const List<HadithItem> sampleHadiths = [
    HadithItem(
      title: 'Keberkahan Infak Subuh',
      narrator: 'HR. Bukhari no. 1442 & Muslim no. 1010',
      arabic: 'مَا مِنْ يَوْمٍ يُصْبِحُ الْعِبَادُ فِيهِ إِلاَّ مَلَكَانِ يَنْزِلاَنِ فَيَقُولُ أَحَدُهُمَا: اللَّهُمَّ أَعْطِ مُنْفِقًا خَلَفًا',
      translation: 'Tidak ada suatu hari pun di mana hamba-hamba Allah memasuki waktu pagi melainkan turun dua malaikat. Maka salah satu di antaranya berdoa: "Ya Allah, berikanlah ganti keberkahan bagi orang yang berinfak."',
      explanation: 'Menunjukkan keistimewaan memulai hari dengan sedekah dan kepedulian sosial, didoakan khusus oleh para malaikat langit.',
    ),
    HadithItem(
      title: 'Kekayaan Jiwa yang Sejati',
      narrator: 'HR. Bukhari no. 6446 & Muslim no. 1051',
      arabic: 'لَيْسَ الْغِنَى عَنْ كَثْرَةِ الْعَرَضِ، وَلَكِنَّ الْغِنَى غِنَى النَّفْسِ',
      translation: 'Kekayaan itu bukanlah dengan banyaknya harta benda, akan tetapi kekayaan yang sejati adalah kekayaan jiwa (hati yang qanaah).',
      explanation: 'Ketenangan batin diperoleh ketika hati ridho dengan takdir dan rezeki Allah, terbebas dari jerat tamak dunia.',
    ),
    HadithItem(
      title: 'Menuntut Ilmu Adalah Jalan Surga',
      narrator: 'HR. Muslim no. 2699',
      arabic: 'مَنْ سَلَكَ طَرِيقًا يَلْتَمِسُ فِيهِ عِلْمًا سَهَّلَ اللَّهُ لَهُ بِهِ طَرِيقًا إِلَى الْجَنَّةِ',
      translation: 'Barangsiapa yang menempuh suatu jalan dalam rangka menuntut ilmu syar\'i, niscaya Allah memudahkan baginya jalan menuju Surga.',
      explanation: 'Setiap langkah yang kita dedikasikan untuk mempelajari firman Allah dan sunnah Rasulullah bernilai mulia di sisi Allah.',
    ),
  ];

  static const List<DoaItem> sampleDoas = [
    DoaItem(
      title: 'Doa Memohon Ketenangan Hati & Kelapangan Dada',
      category: 'Pagi & Petang',
      arabic: 'رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي وَاحْلُلْ عُقْدَةً مِنْ لِسَانِي يَفْقَهُوا قَوْلِي',
      latin: "Rabbisyrah lii shadrii wa yassir lii amrii wahlul 'uqdatan min lisaanii yafqahuu qawlii",
      translation: 'Ya Tuhanku, lapangkanlah dadaku, mudahkanlah urusanku, dan lepaskanlah kekakuan dari lidahku, agar mereka mengerti perkataanku.',
      reference: 'QS. Thaha: 25-28',
    ),
    DoaItem(
      title: 'Doa Perlindungan dari Kesedihan & Kegelisahan',
      category: 'Hisnul Muslim',
      arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَالْعَجْزِ وَالْكَسَلِ، وَالْبُخْلِ وَالْجُبْنِ، وَضَلَعِ الدَّيْنِ وَغَلَبَةِ الرِّجَالِ',
      latin: "Allaahumma innii a'uudzu bika minal hammi wal hazan, wal 'ajzi wal kasal, wal bukhli wal jubn, wa dhala'id dayni wa ghalabatir rijaal",
      translation: 'Ya Allah, sesungguhnya aku berlindung kepada-Mu dari rasa gundah dan sedih, dari rasa lemah dan malas, dari sifat kikir dan pengecut, serta dari lilitan utang dan penindasan manusia.',
      reference: 'HR. Bukhari no. 2893',
    ),
    DoaItem(
      title: 'Doa Keluar Rumah Menuju Masjid',
      category: 'Ibadah Harian',
      arabic: 'بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ، لاَ حَوْلَ وَلاَ قُوَّةَ إِلاَّ بِاللَّهِ',
      latin: 'Bismillaahi tawakkaltu \'alallaah, laa hawla wa laa quwwata illaa billaah',
      translation: 'Dengan menyebut nama Allah, aku bertawakal kepada Allah. Tiada daya dan tiada kekuatan melainkan dengan pertolongan Allah.',
      reference: 'HR. Abu Dawud & Tirmidzi',
    ),
  ];

  static const List<AsmaulHusnaItem> sampleAsmaulHusna = [
    AsmaulHusnaItem(number: 1, arabic: 'الرَّحْمَنُ', latin: 'Ar-Rahmaan', meaning: 'Yang Maha Pengasih'),
    AsmaulHusnaItem(number: 2, arabic: 'الرَّحِيمُ', latin: 'Ar-Rahiim', meaning: 'Yang Maha Penyayang'),
    AsmaulHusnaItem(number: 3, arabic: 'الْمَلِكُ', latin: 'Al-Malik', meaning: 'Yang Maha Merajai / Memerintah'),
    AsmaulHusnaItem(number: 4, arabic: 'الْقُدُّوسُ', latin: 'Al-Qudduus', meaning: 'Yang Maha Suci'),
    AsmaulHusnaItem(number: 5, arabic: 'السَّلاَمُ', latin: 'As-Salaam', meaning: 'Yang Maha Memberi Kesejahteraan'),
    AsmaulHusnaItem(number: 6, arabic: 'الْمُؤْمِنُ', latin: "Al-Mu'min", meaning: 'Yang Maha Mengaruniakan Keamanan'),
    AsmaulHusnaItem(number: 7, arabic: 'الْمُهَيْمِنُ', latin: 'Al-Muhaymin', meaning: 'Yang Maha Memelihara'),
    AsmaulHusnaItem(number: 8, arabic: 'الْعَزِيزُ', latin: "Al-'Aziiz", meaning: 'Yang Maha Perkasa'),
    AsmaulHusnaItem(number: 9, arabic: 'الْجَبَّارُ', latin: 'Al-Jabbaar', meaning: 'Yang Maha Memaksa / Berkehendak'),
    AsmaulHusnaItem(number: 10, arabic: 'الْمُتَكَبِّرُ', latin: 'Al-Mutakabbir', meaning: 'Yang Memiliki Segala Kebesaran'),
    AsmaulHusnaItem(number: 11, arabic: 'الْخَالِقُ', latin: 'Al-Khaaliq', meaning: 'Yang Maha Pencipta Semesta'),
    AsmaulHusnaItem(number: 12, arabic: 'الْبَارِئُ', latin: "Al-Baari'", meaning: 'Yang Maha Mengadakan'),
  ];

  static const List<KisahNabiItem> sampleKisahNabi = [
    KisahNabiItem(
      name: 'Nabi Yusuf AS',
      title: 'Puncak Kesabaran, Maaf, dan Takwil Mimpi',
      era: 'Negeri Kan\'an & Mesir Kuno',
      summary: 'Kisah terlengkap dalam satu surah (Ahsanul Qashash). Dari sumur pengkhianatan hingga istana Mesir, mengajarkan kesabaran atas fitnah nafsu dan kemuliaan memaafkan saudara.',
      keyLesson: 'Kesabaran indah (shabr jamil) dan tawakal selalu berbuah kemuliaan yang tak terduga.',
    ),
    KisahNabiItem(
      name: 'Nabi Ibrahim AS',
      title: 'Khalilullah & Pelopor Tauhid Murni',
      era: 'Babilonia, Ur Kasdim, & Lembah Makkah',
      summary: 'Menghancurkan berhala ketundukan semu, selamat dari kobaran api Namrud, serta keikhlasan puncak saat menyembelih anak terkasih Ismail atas perintah Allah.',
      keyLesson: 'Kepasrahan total kepada Allah melahirkan generasi pewaris risalah Islam.',
    ),
    KisahNabiItem(
      name: 'Nabi Muhammad SAW',
      title: 'Rahmatan Lil \'Alamin & Penutup Para Nabi',
      era: 'Makkah Al-Mukarramah & Madinah Al-Munawwarah',
      summary: 'Membawa risalah terakhir Al-Qur\'an, menyatukan kabilah yang berpecah menjadi ummatan wahidah, serta menyempurnakan akhlak mulia manusia.',
      keyLesson: 'Keteladanan hidup terbaik dalam setiap dimensi: spiritual, keluarga, dan sosial.',
    ),
  ];

  static const List<TajwidRuleItem> sampleTajwid = [
    TajwidRuleItem(
      ruleName: 'Ikhfa Haqiqi',
      category: 'Hukum Nun Mati / Tanwin',
      letters: 'ت، ث، ج، د، ذ، ز، س، ش، ص، ض، ط، ظ، ف، ق، ك (15 Huruf)',
      description: 'Membaca samar antara Idzhar dan Idgham disertai dengungan (Ghunnah) sepanjang 2 harakat saat Nun Sukun bertemu salah satu huruf di atas.',
      exampleArabic: 'مِنْ قَبْلُ • أَنْفُسَكُمْ',
      exampleExplanation: 'Bunyi nun disamarkan menuju makhraj qaf atau fa dengan dengungan lembut.',
    ),
    TajwidRuleItem(
      ruleName: 'Idgham Bighunnah',
      category: 'Hukum Nun Mati / Tanwin',
      letters: 'ي، ن، م، و (YAMNU)',
      description: 'Memasukkan suara Nun Sukun atau Tanwin ke dalam huruf sesudahnya dengan disertai dengung (Ghunnah) 2 harakat.',
      exampleArabic: 'مَنْ يَقُولُ • مِنْ مَالٍ',
      exampleExplanation: 'Suara nun melebur penuh ke dalam ya atau mim dengan dengungan terasa di rongga hidung.',
    ),
    TajwidRuleItem(
      ruleName: 'Qalqalah Kubra & Sughra',
      category: 'Sifat Huruf Pantul',
      letters: 'ق، ط، ب، ج، د (QATHBU JADIN)',
      description: 'Memantulkan bunyi huruf saat sukun asli di tengah kata (Sughra) atau karena waqaf di akhir ayat (Kubra).',
      exampleArabic: 'قُلْ هُوَ اللَّهُ أَحَدٌ ﴿١﴾',
      exampleExplanation: 'Huruf Dal di akhir kata dipantulkan dengan jelas dan kuat saat diwaqafkan.',
    ),
  ];
}
