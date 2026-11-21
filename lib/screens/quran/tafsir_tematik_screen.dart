import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../data/quran_dataset.dart';

class TafsirTematikScreen extends StatefulWidget {
  final SurahModel? surah;
  final int startingAyah;

  const TafsirTematikScreen({
    super.key,
    this.surah,
    this.startingAyah = 1,
  });

  @override
  State<TafsirTematikScreen> createState() => _TafsirTematikScreenState();
}

class _TafsirTematikScreenState extends State<TafsirTematikScreen> {
  int _selectedTab = 0; // 0: Asbabun Nuzul, 1: Ibnu Katsir, 2: Al-Muyassar, 3: Al-Jalalain
  bool _savedToNotes = false;

  final List<String> _tabs = [
    'Asbabun Nuzul',
    'Tafsir Ibnu Katsir',
    'Tafsir Al-Muyassar',
    'Tafsir Al-Jalalain',
  ];

  @override
  Widget build(BuildContext context) {
    final surah = widget.surah ?? kQuranSurahs.firstWhere(
      (s) => s.number == 78,
      orElse: () => kQuranSurahs.first,
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
          'Tafsir Tematik & Asbabun Nuzul',
          style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.secondary, size: 20),
            tooltip: 'Bagikan Tadabbur',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tautan tafsir tematik disalin ke papan klip.')),
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
            // Surah & Ayah Badge Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryContainer],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(50),
                    blurRadius: 16,
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(40),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Juz ${surah.juz} • Hal. ${surah.page}',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                      Text(
                        surah.arabic,
                        style: AppTheme.quranArabic(fontSize: 24).copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Surah ${surah.name} [Ayat 1-5]',
                    style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tema Utama: Kepastian Berita Agung Hari Kebangkitan & Bantahan Kaum Musyrikin',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tafsir source pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_tabs.length, (index) {
                  final isSelected = _selectedTab == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_tabs[index]),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.surfaceContainerLow,
                      labelStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.onSurface,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.outlineVariant.withAlpha(80),
                      ),
                      onSelected: (val) {
                        setState(() => _selectedTab = index);
                      },
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),

            // Primary Content Card based on tab
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.surfaceContainerHigh),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppColors.primaryFixed,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.auto_stories, color: AppColors.primary, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _selectedTab == 0
                            ? 'Latar Belakang Sebab Turunnya Ayat (Asbabun Nuzul)'
                            : _tabs[_selectedTab],
                        style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  if (_selectedTab == 0) ...[
                    Text(
                      'Diriwayatkan oleh Ibnu Jarir dan Ibnu Abi Hatim dari Al-Hasan Al-Bashri:',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ketika Rasulullah ﷺ diutus membawa risalah tauhid dan mengabarkan tentang hari kebangkitan setelah kematian, orang-orang musyrik Quraisy saling bertanya-tanya dengan nada heran dan mengingkari seraya berkata: "Apakah benar kita akan dibangkitkan kembali setelah tulang-belulang hancur luluh?"\n\nMaka Allah Ta\'ala menurunkan ayat pembuka surah An-Naba\' ini untuk menegur keangkuhan mereka sekaligus menegaskan bahwa Hari Pembalasan adalah "An-Naba\' Al-\'Azhim" (Berita Teramat Agung) yang pasti terjadi tanpa keraguan sedikit pun.',
                      style: GoogleFonts.plusJakartaSans(fontSize: 13, height: 1.6, color: AppColors.onSurface),
                    ),
                  ] else if (_selectedTab == 1) ...[
                    Text(
                      'Ringkasan Tafsir Al-Qur\'an Al-\'Azhim (Ibnu Katsir):',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Firman Allah "Tentang apakah mereka saling bertanya-tanya? Tentang berita yang besar": Maksudnya kaum musyrikin saling mempertanyakan tentang kiamat yang diberitakan oleh Nabi ﷺ. Allah mencela perdebatan mereka karena mereka berselisih: ada yang membenarkan sedikit, namun mayoritas mendustakan secara mutlak.\n\nLalu Allah berfirman "Kalla say\'alamun, tsumma kalla say\'alamun" sebagai ancaman keras yang pasti mereka saksikan sendiri saat kiamat tiba kelak.',
                      style: GoogleFonts.plusJakartaSans(fontSize: 13, height: 1.6, color: AppColors.onSurface),
                    ),
                  ] else if (_selectedTab == 2) ...[
                    Text(
                      'Tafsir Al-Muyassar (Tim Ulama Madinah):',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tentang perkara besar apakah orang-orang kafir itu saling bersoal jawab? Yaitu tentang Al-Qur\'an yang mengabarkan tentang hari kebangkitan. Sekali-kali bukanlah seperti dugaan mereka! Kelak mereka akan mengetahui akibat dari kedustaan mereka tatkala siksaan menimpa mereka di alam barzakh dan hari mahsyar.',
                      style: GoogleFonts.plusJakartaSans(fontSize: 13, height: 1.6, color: AppColors.onSurface),
                    ),
                  ] else ...[
                    Text(
                      'Tafsir Jalalain (Imam Jalaluddin Al-Mahalli & As-Suyuthi):',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '(‘Amma) asal katanya \'an maa (tentang apakah) mereka saling bertanya? Yaitu orang-orang kafir Quraisy bertanya di antara mereka mengenai kenabian dan hari berbangkit. (Kalla) kata teguran keras. (Kelak mereka akan mengetahui) azab yang ditimpakan atas mereka.',
                      style: GoogleFonts.plusJakartaSans(fontSize: 13, height: 1.6, color: AppColors.onSurface),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Card 2: Faedah Tadabbur Tematik
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withAlpha(40)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lightbulb_outline, color: Color(0xFFD97706), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Faedah Tadabbur Tematik',
                        style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildFaedahItem(
                    number: '1',
                    title: 'Berita Agung Bukanlah Dongeng',
                    desc: 'Hari kiamat adalah keniscayaan mutlak. Keraguan manusia sedikit pun tidak akan menghentikan takdir Allah yang sedang bergerak mendekat.',
                  ),
                  const SizedBox(height: 10),
                  _buildFaedahItem(
                    number: '2',
                    title: 'Peringatan Tegas bagi yang Meremehkan',
                    desc: 'Pengulangan kata "Kalla say\'alamun" mendidik jiwa agar tidak lalai menunda taubat sebelum hisab amal ditegakkan.',
                  ),
                  const SizedBox(height: 10),
                  _buildFaedahItem(
                    number: '3',
                    title: 'Solusi Perselisihan Pemikiran Zaman',
                    desc: 'Wahyu Al-Qur\'an adalah kompas kebenaran mutlak penuntun nurani di tengah bisingnya perbedaan opini manusia.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Bottom Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(Icons.share, size: 18),
                    label: Text(
                      'Bagikan Faedah',
                      style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Faedah tadabbur siap dibagikan.')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _savedToNotes ? const Color(0xFF10B981) : AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: Icon(_savedToNotes ? Icons.check : Icons.bookmark_add, size: 18),
                    label: Text(
                      _savedToNotes ? 'Tersimpan di Jurnal' : 'Simpan ke Jurnal',
                      style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    onPressed: () {
                      setState(() => _savedToNotes = true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Berhasil disimpan ke Jurnal Hati & Tadabbur.')),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildFaedahItem({required String number, required String title, required String desc}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: GoogleFonts.plusJakartaSans(fontSize: 12, height: 1.45, color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
