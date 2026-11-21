import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import 'ai_tartil_evaluation_screen.dart';

class TajwidTracingScreen extends StatefulWidget {
  const TajwidTracingScreen({super.key});

  @override
  State<TajwidTracingScreen> createState() => _TajwidTracingScreenState();
}

class _TajwidTracingScreenState extends State<TajwidTracingScreen> {
  int _selectedTopTab = 0; // 0: Iqra 1-6 Berjenjang, 1: Pusat Tracing & Makhraj
  int _selectedJilidIndex = 0; // 0 to 5 (Iqra 1 to 6)
  int _selectedExampleIndex = 0;
  int _selectedLetterIndex = 6; // Kha (خ)
  final List<Offset> _drawnPoints = [];
  bool _showComparisonMatrix = false;

  // Data 6 Jilid Iqra Lengkap
  final List<Map<String, dynamic>> _jilidData = [
    {
      'jilid': 1,
      'title': 'Iqra 1 : Huruf Tunggal & Fathah',
      'level': 'Tingkat Pemula / Dasar',
      'badge': 'Huruf Tunggal',
      'color': const Color(0xFF6366F1), // Indigo
      'bgLight': const Color(0xFFEEF2FF),
      'progress': 0.64,
      'progressText': '18 dari 28 Huruf Terkuasai',
      'coreDifference': 'Huruf masih berdiri sendiri (tunggal/tidak bersambung) dan HANYA menggunakan satu tanda bunyi yaitu Fathah (bunyi vokal "a"). Tidak ada bacaan panjang (mad) dan tidak ada tanda mati (sukun).',
      'goldenRules': [
        'Langsung dibaca bunyinya (A - Ba - Ta), tidak boleh dieja (Alif - Ba - Ta).',
        'Dibaca pendek, tegas, dan cepat (1 harakat / 1 ketukan). Tidak boleh dipanjangkan atau diayun.',
        'Makhraj huruf harus tepat dan tidak boleh tertukar (seperti Ha halus vs Kha ngorok, Ta vs Tha).'
      ],
      'examples': [
        {'arabic': 'اَ بَ تَ', 'latin': 'A - Ba - Ta', 'rule': 'Pendek tegas 1 ketukan tanpa mad', 'makhraj': 'Alif (tenggorokan bawah), Ba (dua bibir), Ta (ujung lidah ketemu pangkal gigi seri atas).'},
        {'arabic': 'جَ حَ خَ', 'latin': 'Ja - Ha - Kha', 'rule': 'Perbedaan desisan tenggorokan', 'makhraj': 'Ja (tengah lidah), Ha halus (tengah tenggorokan), Kha (tenggorokan atas).'},
        {'arabic': 'دَ رَ زَ', 'latin': 'Da - Ra - Za', 'rule': 'Huruf yang tidak bisa disambung ke depan', 'makhraj': 'Da (ujung lidah), Ra (ujung lidah getar), Za (ujung lidah gigi seri bawah).'},
        {'arabic': 'سَ شَ صَ', 'latin': 'Sa - Sya - Sha', 'rule': 'Perbedaan tebal (istila\') dan tipis (istifal)', 'makhraj': 'Sa (desir tipis), Sya (menyebar di tengah lidah), Sha (tebal terangkat pangkal lidah).'},
      ],
    },
    {
      'jilid': 2,
      'title': 'Iqra 2 : Huruf Sambung & Mad 2 Harakat',
      'level': 'Tingkat Pemula Lanjutan',
      'badge': 'Huruf Sambung & Mad',
      'color': const Color(0xFF0EA5E9), // Sky blue
      'bgLight': const Color(0xFFF0F9FF),
      'progress': 0.25,
      'progressText': '8 dari 30 Halaman Diselesaikan',
      'coreDifference': 'Huruf mulai disambung menjadi 2-3 kata dengan bentuk berbeda di AWAL, TENGAH, dan AKHIR. Mulai dikenalkan konsep bacaan panjang (Mad Thabi\'i 2 harakat) dengan tanda Alif atau Fathah Berdiri.',
      'goldenRules': [
        'Bedakan dengan sangat teliti antara bacaan PENDEK (1 ketuk) dan PANJANG (2 ketuk / ayunan alif).',
        'Pahami perubahan kepala dan badan huruf ketika disambung (seperti Ba/Ta/Tsa/Nun/Ya yang kepalanya mirip).',
        'Jangan memanjangkan huruf yang seharusnya pendek, dan jangan memendekkan huruf yang ada alifnya.'
      ],
      'examples': [
        {'arabic': 'بَا - تَا - ثَا', 'latin': 'Baa - Taa - Tsaa', 'rule': 'Mad Thabi\'i berfathah diikuti Alif (panjang 2 ketukan)', 'makhraj': 'Diayun sepanjang satu alif (2 ketukan teratur).'},
        {'arabic': 'خَاتَمَ', 'latin': 'Khaa - Ta - Ma', 'rule': 'Kha panjang 2 ketuk, Ta dan Ma pendek 1 ketuk', 'makhraj': 'Perhatikan jeda panjang pendeknya: Khaa-ta-ma (bukan Kha-ta-ma).'},
        {'arabic': 'جَعَلَ vs جَاعَلَ', 'latin': 'Ja\'ala vs Jaa\'ala', 'rule': 'Latihan kontras: Semua pendek vs huruf awal panjang', 'makhraj': 'Kunci kehati-hatian agar tidak merubah arti ayat.'},
        {'arabic': 'سَافَرَ', 'latin': 'Saa - Fa - Ra', 'rule': 'Huruf Sin bersambung di awal + alif mad', 'makhraj': 'Gigi Sin terlihat 3 lekukan lalu disambung Alif tegak.'},
      ],
    },
    {
      'jilid': 3,
      'title': 'Iqra 3 : Kasrah, Dhammah, & Mad Wawu/Ya',
      'level': 'Tingkat Menengah',
      'badge': 'Kasrah & Dhammah',
      'color': const Color(0xFF10B981), // Emerald
      'bgLight': const Color(0xFFECFDF5),
      'progress': 0.0,
      'progressText': 'Terkunci • Selesaikan Iqra 2',
      'coreDifference': 'Dikenalkannya dua tanda harakat baru: Kasrah (ـِ vokal "i") dan Dhammah (ـُ vokal "u"). Mad panjang juga berkembang menjadi Kasrah diikuti Ya\' sukun (ـِيْ / ii) dan Dhammah diikuti Wawu sukun (ـُوْ / uu).',
      'goldenRules': [
        'Bibir dimonyongkan sempurna saat dhammah (ـُ), dan bibir sedikit ditarik ke bawah saat kasrah (ـِ).',
        'Bunyi vokal A, I, U harus murni dan bersih, tidak boleh miring ke e/o (misal: "I" bukan "E", "U" bukan "O").',
        'Konsisten menjaga panjang 2 ketukan pada ketiga jenis mad (aa, ii, uu).'
      ],
      'examples': [
        {'arabic': 'رُسُلُ', 'latin': 'Ru - Su - Lu', 'rule': 'Tiga harakat dhammah berurutan, semua dibaca pendek', 'makhraj': 'Bibir monyong teratur tanpa jeda berlebihan.'},
        {'arabic': 'عَلِمَ', 'latin': '\'A - Li - Ma', 'rule': 'Kombinasi harakat vokal A - I - A', 'makhraj': '\'Ain di tengah tenggorokan, Lam kasrah bersih.'},
        {'arabic': 'فِيْهِ', 'latin': 'Fii - Hi', 'rule': 'Mad Thabi\'i Kasrah + Ya\' sukun (Fii 2 ketukan)', 'makhraj': 'Fii panjang 2 harakat, Hi pendek 1 harakat.'},
        {'arabic': 'يَقُوْلُ', 'latin': 'Ya - Quu - Lu', 'rule': 'Mad Thabi\'i Dhammah + Wawu sukun (Quu 2 ketukan)', 'makhraj': 'Quu tebal di pangkal lidah, diayun 2 ketukan.'},
      ],
    },
    {
      'jilid': 4,
      'title': 'Iqra 4 : Tanwin, Sukun, & Qalqalah',
      'level': 'Tingkat Lanjutan Awal',
      'badge': 'Tanwin & Qalqalah',
      'color': const Color(0xFFF59E0B), // Amber
      'bgLight': const Color(0xFFFEF3C7),
      'progress': 0.0,
      'progressText': 'Terkunci • Selesaikan Iqra 3',
      'coreDifference': 'Mengenalkan tanda TANWIN (Fathatain ـً / an, Kasratain ـٍ / in, Dhammatain ـٌ / un), tanda SUKUN (ـْ huruf mati), HURUF LIN (ـَوْ / au dan ـَيْ / ai), serta getaran PANTULAN QALQALAH (baju di toko: ب ج د ط ق).',
      'goldenRules': [
        'Bunyi sukun dimatikan dengan tegas tanpa mendengung (kecuali Mim dan Nun).',
        'Lima huruf Qalqalah (ب, ج, د, ط, ق) saat sukun WAJIB dipantulkan suaranya secara natural.',
        'Huruf Lin (Wawu/Ya sukun setelah fathah) dibaca lunak mengalir (seperti "Khauf", "Bait").'
      ],
      'examples': [
        {'arabic': 'كِتَابًا', 'latin': 'Ki - Taa - Ban', 'rule': 'Tanwin Fathatain (-an) di akhir kata', 'makhraj': 'Taa mad 2 ketuk, Ban dibaca tegas an.'},
        {'arabic': 'أَبْصَارِهِمْ', 'latin': 'Ab - Saa - Ri - Him', 'rule': 'Qalqalah Sughra pada huruf Ba\' sukun (memantul)', 'makhraj': 'Ab memantul halus: "Eb-shoo-ri-him".'},
        {'arabic': 'خَلَقْنَاهُمْ', 'latin': 'Kha - Laq - Naa - Hum', 'rule': 'Qalqalah Sughra pada huruf Qaf sukun (pantulan tebal)', 'makhraj': 'Laq memantul tebal di pangkal lidah.'},
        {'arabic': 'خَوْفٌ', 'latin': 'Khau - Fun', 'rule': 'Huruf Lin (Wawu sukun lunak) + Tanwin Dhammatain', 'makhraj': 'Khau mengalir lembut tanpa tersendat.'},
      ],
    },
    {
      'jilid': 5,
      'title': 'Iqra 5 : Tasydid, Alif Lam, & Waqaf Dasar',
      'level': 'Tingkat Pra-Qur\'an',
      'badge': 'Tasydid & Waqaf',
      'color': const Color(0xFF8B5CF6), // Purple
      'bgLight': const Color(0xFFF3E8FF),
      'progress': 0.0,
      'progressText': 'Terkunci • Selesaikan Iqra 4',
      'coreDifference': 'Mengenalkan tanda TASYDID / SYADDAH (ـّ penekanan dua huruf kembar), pembedaan ALIF LAM QAMARIYAH (Al dibaca jelas) vs ALIF LAM SYAMSIYAH (Al melebur), GHUNNAH (dengung ditahan), serta cara BERHENTI (Waqaf).',
      'goldenRules': [
        'Huruf bertasydid ditekan kuat seolah ada dua huruf identik beriringan.',
        'Nun dan Mim bertasydid (نّ dan مّ) WAJIB ditahan dengung (Ghunnah) selama 2-3 ketukan dari rongga hidung.',
        'Saat waqaf (berhenti), huruf terakhir dimatikan (sukun), dan ta\' marbuthah (ة) berubah bunyi menjadi Ha sukun (هـْ).'
      ],
      'examples': [
        {'arabic': 'إِنَّ اللّٰهَ', 'latin': 'In - nal - Laa - Ha', 'rule': 'Ghunnah Musyaddadah: Nun tasydid ditahan dengung 2 ketukan', 'makhraj': 'Suara ditahan di pangkal hidung (khaisyum) lalu ditekan ke lafaz jalalah.'},
        {'arabic': 'الْحَمْدُ لِلّٰهِ', 'latin': 'Al - Ham - Du - Lil - Laah', 'rule': 'Alif Lam Qamariyah: Huruf Lam sukun dibaca jelas (Izhar)', 'makhraj': 'Al terbaca terang sebelum huruf Ha.'},
        {'arabic': 'وَالشَّمْسِ', 'latin': 'Wasy - Syam - Si', 'rule': 'Alif Lam Syamsiyah: Lam melebur langsung ke Syin bertasydid', 'makhraj': 'Lam tidak dibaca, langsung melompat ke Syin.'},
        {'arabic': 'رَبِّ الْعَالَمِيْنَ', 'latin': 'Rab - bil - \'Aa - La - Miin', 'rule': 'Tasydid Ba + Alif Lam Qamariyah + Waqaf Mad \'Aridh', 'makhraj': 'Ba ditekan mantap, akhir kata miin boleh dipanjangkan 2-6 ketuk.'},
      ],
    },
    {
      'jilid': 6,
      'title': 'Iqra 6 : Tajwid Lanjutan Menuju Al-Qur\'an',
      'level': 'Tingkat Mahir / Khatam',
      'badge': 'Transisi Mushaf 30 Juz',
      'color': const Color(0xFFD97706), // Amber-Gold
      'bgLight': const Color(0xFFFFFBEB),
      'progress': 0.0,
      'progressText': 'Terkunci • Tahap Wisuda Khatam',
      'coreDifference': 'Materi pamungkas metode Iqro: Hukum Iqlab (ـۢ perubahan nun ke mim), Ikhfa Hakiki (samar dengung), Idgham Bighunnah & Bilaghunnah, Mad Wajib/Jaiz (bendera panjang 4-5 harakat), tanda waqaf Al-Qur\'an, dan Fawatihussuwar (huruf pembuka surat).',
      'goldenRules': [
        'Kuasai hukum nun mati & tanwin (Izhar, Idgham, Iqlab, Ikhfa) secara fasih.',
        'Patuhi tanda mad bendera panjang (ـٓ) dengan menahan 4 hingga 5 ketukan teratur.',
        'Setelah lulus Iqra 6, santri dinyatakan KHATAM dan siap langsung membaca Mushaf Al-Qur\'an 30 Juz dimulai dari Surah Al-Fatihah dan Al-Baqarah.'
      ],
      'examples': [
        {'arabic': 'مِنْ بَعْدِ', 'latin': 'Mim - Ba\' - Di', 'rule': 'Hukum Iqlab: Nun mati bertemu Ba berubah menjadi bunyi Mim samar', 'makhraj': 'Kedua bibir merapat ringan dengan dengung hidung.'},
        {'arabic': 'مِنْ قَبْلِكُمْ', 'latin': 'Ming - Qob - Li - Kum', 'rule': 'Ikhfa Hakiki: Menyamarkan nun mati di pangkal lidah dengan dengung', 'makhraj': 'Suara mendekati makhraj Qaf yang tebal.'},
        {'arabic': 'جَآءَ أَمْرُنَا', 'latin': 'Jaaa\'a - Am - Ru - Naa', 'rule': 'Mad Wajib Muttashil: Huruf mad bertemu hamzah dalam satu kata (4-5 harakat)', 'makhraj': 'Ditarik panjang 4 sampai 5 ketukan sebelum hamzah.'},
        {'arabic': 'الٓمّٓ', 'latin': 'A - Lif - Laaam - Miiim', 'rule': 'Fawatihussuwar (Mad Lazim Harfi 6 harakat)', 'makhraj': 'Huruf Lam dan Mim dipanjangkan maksimal 6 ketukan.'},
      ],
    },
  ];

  // 28 Huruf Hijaiyah Data
  final List<Map<String, dynamic>> _letters = [
    {'name': 'Alif', 'arabic': 'ا', 'status': 'Fasih'},
    {'name': 'Ba', 'arabic': 'ب', 'status': 'Fasih'},
    {'name': 'Ta', 'arabic': 'ت', 'status': 'Fasih'},
    {'name': 'Tsa', 'arabic': 'ث', 'status': 'Fasih'},
    {'name': 'Jim', 'arabic': 'ج', 'status': 'Fasih'},
    {'name': 'Ha\'', 'arabic': 'ح', 'status': 'Fasih'},
    {'name': 'Kha', 'arabic': 'خ', 'status': 'Aktif'},
    {'name': 'Dal', 'arabic': 'د', 'status': 'Berikutnya'},
    {'name': 'Dzal', 'arabic': 'ذ', 'status': 'Terkunci'},
    {'name': 'Ra', 'arabic': 'ر', 'status': 'Terkunci'},
    {'name': 'Zai', 'arabic': 'ز', 'status': 'Terkunci'},
    {'name': 'Sin', 'arabic': 'س', 'status': 'Terkunci'},
    {'name': 'Syin', 'arabic': 'ش', 'status': 'Terkunci'},
    {'name': 'Shad', 'arabic': 'ص', 'status': 'Terkunci'},
    {'name': 'Dhad', 'arabic': 'ض', 'status': 'Terkunci'},
    {'name': 'Tha', 'arabic': 'ط', 'status': 'Terkunci'},
    {'name': 'Zha', 'arabic': 'ظ', 'status': 'Terkunci'},
    {'name': 'Ain', 'arabic': 'ع', 'status': 'Terkunci'},
    {'name': 'Ghain', 'arabic': 'غ', 'status': 'Terkunci'},
    {'name': 'Fa', 'arabic': 'ف', 'status': 'Terkunci'},
    {'name': 'Qaf', 'arabic': 'ق', 'status': 'Terkunci'},
    {'name': 'Kaf', 'arabic': 'ك', 'status': 'Terkunci'},
    {'name': 'Lam', 'arabic': 'ل', 'status': 'Terkunci'},
    {'name': 'Mim', 'arabic': 'م', 'status': 'Terkunci'},
    {'name': 'Nun', 'arabic': 'ن', 'status': 'Terkunci'},
    {'name': 'Waw', 'arabic': 'و', 'status': 'Terkunci'},
    {'name': 'Ha', 'arabic': 'هـ', 'status': 'Terkunci'},
    {'name': 'Ya\'', 'arabic': 'ي', 'status': 'Terkunci'},
  ];

  @override
  Widget build(BuildContext context) {
    final currentJilid = _jilidData[_selectedJilidIndex];

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
          'Kurikulum Iqra 1-6 & Tracing',
          style: GoogleFonts.syne(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.primary),
        ),
        actions: [
          IconButton(
            tooltip: 'Tabel Pembeda 6 Jilid',
            icon: const Icon(Icons.table_chart_outlined, color: AppColors.primary, size: 22),
            onPressed: () {
              setState(() => _showComparisonMatrix = !_showComparisonMatrix);
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: AppColors.secondary, size: 20),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryFixed,
              child: const Icon(Icons.person, size: 18, color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Tab Toggle: Iqra Berjenjang vs Tracing & Makhraj
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _selectedTopTab = 0),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                          color: _selectedTopTab == 0 ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_stories, size: 16, color: _selectedTopTab == 0 ? Colors.white : AppColors.secondary),
                            const SizedBox(width: 6),
                            Text(
                              'Iqra 1-6 Berjenjang',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: _selectedTopTab == 0 ? FontWeight.w700 : FontWeight.w500,
                                color: _selectedTopTab == 0 ? Colors.white : AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _selectedTopTab = 1),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                          color: _selectedTopTab == 1 ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.draw, size: 16, color: _selectedTopTab == 1 ? Colors.white : AppColors.secondary),
                            const SizedBox(width: 6),
                            Text(
                              'Papan Tracing & Makhraj',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: _selectedTopTab == 1 ? FontWeight.w700 : FontWeight.w500,
                                color: _selectedTopTab == 1 ? Colors.white : AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Horizontal Iqra 1 to 6 Volume Selector Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pilih Jenjang Jilid Iqra:',
                  style: GoogleFonts.syne(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    setState(() => _showComparisonMatrix = !_showComparisonMatrix);
                  },
                  icon: Icon(
                    _showComparisonMatrix ? Icons.visibility_off_outlined : Icons.compare_arrows_rounded,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    _showComparisonMatrix ? 'Tutup Peta' : 'Peta Beda Jilid',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 6 Chips Horizontal Scroll
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_jilidData.length, (idx) {
                  final jilid = _jilidData[idx];
                  final isSelected = _selectedJilidIndex == idx;
                  final Color jColor = jilid['color'] as Color;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedJilidIndex = idx;
                          _selectedExampleIndex = 0;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? jColor : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? jColor : AppColors.hairline,
                            width: isSelected ? 1.5 : 1,
                          ),
                          boxShadow: isSelected
                              ? [BoxShadow(color: jColor.withAlpha(50), blurRadius: 8, offset: const Offset(0, 3))]
                              : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white.withAlpha(60) : jColor.withAlpha(30),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${jilid['jilid']}',
                                  style: GoogleFonts.syne(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: isSelected ? Colors.white : jColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Iqra ${jilid['jilid']}',
                                  style: GoogleFonts.syne(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: isSelected ? Colors.white : AppColors.onSurface,
                                  ),
                                ),
                                Text(
                                  jilid['badge'] as String,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.white.withAlpha(220) : AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 18),

            // Optional: Comparison Matrix Card (Peta Perbedaan 6 Jilid Iqra)
            if (_showComparisonMatrix) ...[
              _buildComparisonMatrixView(),
              const SizedBox(height: 18),
            ],

            // Content based on selected Top Tab
            if (_selectedTopTab == 0) ...[
              // 1. DETAIL JILID TERPILIH & PEMBEDANYA
              _buildJilidDetailCard(currentJilid),
              const SizedBox(height: 16),

              // 2. CONTOH BACAAN PRAKTIK & PANDUAN TAJWID
              _buildInteractiveExamplesSection(currentJilid),
              const SizedBox(height: 16),

              // 3. KAIDAH EMAS MEMBACA METODE IQRO ASLI
              _buildGoldenRulesCard(currentJilid),
              const SizedBox(height: 16),

              // 4. UJIAN & SYARAT KENAIKAN JILID
              _buildJilidAdvancementCard(currentJilid),
            ] else ...[
              // TAB 1: PUSAT TRACING & MAKHRAJ HURUF LENGKAP
              _buildFullTracingSection(),
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // VIEW: DETAIL JILID TERPILIH & APA PEMBEDANYA
  // =========================================================================
  Widget _buildJilidDetailCard(Map<String, dynamic> jilid) {
    final Color jColor = jilid['color'] as Color;
    final Color bgLight = jilid['bgLight'] as Color;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.hairline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: bgLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: jColor.withAlpha(60)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified, size: 14, color: jColor),
                    const SizedBox(width: 5),
                    Text(
                      jilid['level'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: jColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFD97706), size: 13),
                    const SizedBox(width: 4),
                    Text(
                      '36 Bintang',
                      style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700, color: const Color(0xFFB45309)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Text(
            jilid['title'] as String,
            style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary),
          ),
          const SizedBox(height: 8),

          // Progress bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(jilid['progressText'] as String, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary)),
              Text('${((jilid['progress'] as double) * 100).toInt()}%', style: GoogleFonts.syne(fontSize: 12, fontWeight: FontWeight.w700, color: jColor)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: jilid['progress'] as double,
              backgroundColor: AppColors.surfaceContainerHigh,
              valueColor: AlwaysStoppedAnimation<Color>(jColor),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 16),

          // Core Difference Banner (Ciri Khas & Pembeda Jilid Ini)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: bgLight,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: jColor.withAlpha(40)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.psychology_outlined, size: 18, color: jColor),
                    const SizedBox(width: 8),
                    Text(
                      'CIRI KHAS & PEMBEDA JILID INI',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: jColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  jilid['coreDifference'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.onSurface,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // VIEW: CONTOH BACAAN PRAKTIK INTERAKTIF
  // =========================================================================
  Widget _buildInteractiveExamplesSection(Map<String, dynamic> jilid) {
    final List examples = jilid['examples'] as List;
    final selectedExample = examples[_selectedExampleIndex];
    final Color jColor = jilid['color'] as Color;

    return Container(
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
              Text(
                'Latihan Bacaan Khas Jilid ${jilid['jilid']}',
                style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_selectedExampleIndex + 1} dari ${examples.length}',
                  style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.secondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Main Display Card for Selected Example
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (jilid['bgLight'] as Color).withAlpha(160),
                  AppColors.surfaceContainerLowest,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: jColor.withAlpha(50)),
            ),
            child: Column(
              children: [
                Text(
                  selectedExample['arabic'] as String,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: AppTheme.quranArabic(fontSize: 36).copyWith(
                    color: AppColors.primary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  selectedExample['latin'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: jColor,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: jColor.withAlpha(40)),
                  ),
                  child: Text(
                    selectedExample['rule'] as String,
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  selectedExample['makhraj'] as String,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary, height: 1.35),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Quick Selector Chips for 4 Examples
          Row(
            children: List.generate(examples.length, (i) {
              final isCur = _selectedExampleIndex == i;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedExampleIndex = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isCur ? jColor : AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          examples[i]['arabic'] as String,
                          style: AppTheme.quranArabic(fontSize: 14).copyWith(
                            color: isCur ? Colors.white : AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 14),

          // Action buttons: Audio Talaqqi & AI Test
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: jColor),
                    foregroundColor: jColor,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Audio Talaqqi Qari: "${selectedExample['arabic']}" (${selectedExample['latin']})'),
                        backgroundColor: jColor,
                      ),
                    );
                  },
                  icon: const Icon(Icons.volume_up_rounded, size: 18),
                  label: Text('Dengarkan Qari', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: jColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AiTartilEvaluationScreen()),
                    );
                  },
                  icon: const Icon(Icons.mic_none_rounded, size: 18),
                  label: Text('Uji AI Tartil Mic', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // VIEW: 3 KAIDAH EMAS METODE IQRO
  // =========================================================================
  Widget _buildGoldenRulesCard(Map<String, dynamic> jilid) {
    final List rules = jilid['goldenRules'] as List;
    final Color jColor = jilid['color'] as Color;

    return Container(
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
            children: [
              const Icon(Icons.lightbulb_rounded, color: Color(0xFFF59E0B), size: 20),
              const SizedBox(width: 8),
              Text(
                '3 Kaidah Emas Membaca (Iqra ${jilid['jilid']})',
                style: GoogleFonts.syne(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(rules.length, (idx) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: jColor.withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${idx + 1}',
                        style: GoogleFonts.syne(fontSize: 10.5, fontWeight: FontWeight.w800, color: jColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      rules[idx] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // =========================================================================
  // VIEW: KARTU UJIAN & SYARAT KENAIKAN JILID
  // =========================================================================
  Widget _buildJilidAdvancementCard(Map<String, dynamic> jilid) {
    final int nextJilid = (jilid['jilid'] as int) < 6 ? (jilid['jilid'] as int) + 1 : 6;
    final bool isLastJilid = (jilid['jilid'] as int) == 6;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryFixed.withAlpha(100),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withAlpha(40)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isLastJilid ? Icons.workspace_premium_rounded : Icons.school_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLastJilid ? 'Wisuda Khataman Iqra Menuju Qur\'an' : 'Syarat Kenaikan ke Iqra $nextJilid',
                  style: GoogleFonts.syne(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
                const SizedBox(height: 2),
                Text(
                  isLastJilid
                    ? 'Setelah menuntaskan Iqra 6, ananda dinyatakan khatam dan siap memulai tilawah Mushaf Al-Qur\'an 30 Juz secara tartil.'
                    : 'Tuntaskan bacaan seluruh modul Iqra ${jilid['jilid']} tanpa kesalahan tempo panjang-pendek untuk membuka segel Jilid $nextJilid.',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // VIEW: MATRIKS PERBANDINGAN 6 JILID IQRA
  // =========================================================================
  Widget _buildComparisonMatrixView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primary.withAlpha(60)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 12,
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
                  const Icon(Icons.table_chart_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Peta Perbedaan 6 Jilid Iqra',
                    style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primary),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18, color: AppColors.secondary),
                onPressed: () => setState(() => _showComparisonMatrix = false),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Ketahui tahapan belajar dari huruf tunggal hingga membaca mushaf Al-Qur\'an secara utuh:',
            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
          ),
          const SizedBox(height: 14),

          // Table Rows
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 14,
              horizontalMargin: 8,
              headingRowColor: WidgetStateProperty.all(AppColors.surfaceContainerLow),
              columns: [
                DataColumn(label: Text('Jilid', style: GoogleFonts.syne(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary))),
                DataColumn(label: Text('Fokus Materi', style: GoogleFonts.syne(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary))),
                DataColumn(label: Text('Pembeda Utama', style: GoogleFonts.syne(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary))),
                DataColumn(label: Text('Contoh Kata', style: GoogleFonts.syne(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary))),
              ],
              rows: _jilidData.map((j) {
                final int num = j['jilid'] as int;
                final isCurrent = _selectedJilidIndex == (num - 1);

                return DataRow(
                  color: isCurrent ? WidgetStateProperty.all((j['bgLight'] as Color).withAlpha(120)) : null,
                  cells: [
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: j['color'] as Color,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Iqra $num',
                          style: GoogleFonts.syne(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        j['badge'] as String,
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                    ),
                    DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 180),
                        child: Text(
                          num == 1 ? 'Huruf tunggal lepas, fathah saja'
                              : num == 2 ? 'Huruf sambung & Mad 2 ketuk'
                              : num == 3 ? 'Kasrah & Dhammah (vokal i & u)'
                              : num == 4 ? 'Tanwin, Sukun & Qalqalah pantul'
                              : num == 5 ? 'Tasydid, Alif Lam & Waqaf dasar'
                              : 'Tajwid lengkap, mad bendera, siap mushaf',
                          style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.onSurfaceVariant),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        (j['examples'][0]['arabic'] as String),
                        style: AppTheme.quranArabic(fontSize: 16).copyWith(color: j['color'] as Color),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // VIEW: TAB 1 TRACING CANVAS & MAKHRAJ
  // =========================================================================
  Widget _buildFullTracingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Papan Tracing Huruf Ceria
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.primary.withAlpha(60)),
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
                      Text(
                        'Papan Tracing Huruf Ceria',
                        style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                      Text(
                        'Ikuti arah goresan nomor 1 lalu 2',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Tersambung Haptic',
                      style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF065F46)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Qari cilik audio trigger
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.record_voice_over, color: AppColors.primary, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Syaikh Qari Cilik: "Kho"',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.primary),
                        ),
                      ],
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        minimumSize: Size.zero,
                      ),
                      icon: const Icon(Icons.volume_up, size: 14),
                      label: Text('Dengarkan', style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700)),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Pelafalan contoh: "Kha / Kho"')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Interactive Tracing Box
              GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    final RenderBox renderBox = context.findRenderObject() as RenderBox;
                    _drawnPoints.add(renderBox.globalToLocal(details.globalPosition));
                  });
                },
                child: Container(
                  height: 170,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF9FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        'خَ',
                        style: AppTheme.quranArabic(fontSize: 110).copyWith(
                          color: AppColors.primary.withAlpha(30),
                        ),
                      ),
                      Positioned(
                        top: 24,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryFixed,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Titik Atas',
                            style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 40,
                        top: 60,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          child: Text('1 →', style: GoogleFonts.plusJakartaSans(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w700)),
                        ),
                      ),
                      CustomPaint(
                        painter: _DrawingPainter(points: _drawnPoints),
                        size: Size.infinite,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Buttons underneath canvas
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.secondary,
                        side: const BorderSide(color: AppColors.outlineVariant),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: Text('Tulis Ulang', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700)),
                      onPressed: () => setState(() => _drawnPoints.clear()),
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
                      icon: const Icon(Icons.mic, size: 16),
                      label: Text('Periksa AI Mic', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AiTartilEvaluationScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Makhraj Huruf Santun
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.surfaceContainerHigh),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.record_voice_over, color: AppColors.primary, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'MAKHRAJ HURUF SANTUN',
                    style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Tempat Keluar Huruf Kha (خ) : Adna\' Halq (Tenggorokan Atas)',
                style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
              const SizedBox(height: 4),
              Text(
                'Terletak di bagian tenggorokan paling atas dekat pangkal lidah. Suara menghasilkan desiran gesekan halus (khiri-khiri) yang lembut dan berbobot tanpa harus tercekik.',
                style: GoogleFonts.plusJakartaSans(fontSize: 11.5, height: 1.45, color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Peta 28 Huruf Hijaiyah
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Peta 28 Huruf Hijaiyah',
              style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
            Text(
              '6 Fasih • 1 Aktif',
              style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF10B981)),
            ),
          ],
        ),
        const SizedBox(height: 10),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.95,
          ),
          itemCount: _letters.length,
          itemBuilder: (context, index) {
            final item = _letters[index];
            final isCurrent = index == _selectedLetterIndex;
            final isFasih = item['status'] == 'Fasih';

            return InkWell(
              onTap: () {
                setState(() => _selectedLetterIndex = index);
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  color: isCurrent
                      ? AppColors.primary
                      : (isFasih ? const Color(0xFFECFDF5) : AppColors.surfaceContainerLowest),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isCurrent
                        ? AppColors.primary
                        : (isFasih ? const Color(0xFFA7F3D0) : AppColors.surfaceContainerHigh),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['arabic']!,
                      style: AppTheme.quranArabic(fontSize: 22).copyWith(
                        color: isCurrent ? Colors.white : (isFasih ? const Color(0xFF065F46) : AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['name']!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isCurrent ? Colors.white : AppColors.onSurface,
                      ),
                    ),
                    Text(
                      item['status']!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        color: isCurrent ? Colors.white70 : (isFasih ? const Color(0xFF059669) : AppColors.secondary),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<Offset> points;
  _DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6.0;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
