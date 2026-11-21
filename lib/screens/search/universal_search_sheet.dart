import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../data/quran_dataset.dart';
import '../quran/surah_reader_modal.dart';
import '../compass/qibla_compass_screen.dart';
import '../modules/tasbih_dialog.dart';
import '../ai_chat/tanya_ustadz_chat_screen.dart';
import '../sedekah/jurnal_sedekah_screen.dart';
import '../masjid/rute_masjid_screen.dart';
import '../dzikir/dzikir_pagi_petang_screen.dart';
import '../streaming/detail_jadwal_majelis_screen.dart';
import '../notification/pusat_notifikasi_screen.dart';
import '../sisterhood/sisterhood_screen.dart';
import '../kids/kids_sanctuary_screen.dart';

enum SearchCategory { all, quran, media, habits, tools }

class SearchItem {
  final String id;
  final String title;
  final String subtitle;
  final String categoryName;
  final SearchCategory category;
  final IconData icon;
  final String? badge;
  final VoidCallback onTap;

  const SearchItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.categoryName,
    required this.category,
    required this.icon,
    this.badge,
    required this.onTap,
  });
}

void showUniversalSearch(BuildContext context, {Function(int tabIndex)? onNavigateTab}) {
  final isDesktop = MediaQuery.of(context).size.width >= 850;

  if (isDesktop) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(120),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680, maxHeight: 720),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: UniversalSearchContent(onNavigateTab: onNavigateTab),
            ),
          ),
        );
      },
    );
  } else {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: Container(
            color: AppColors.surfaceContainerLowest,
            child: SafeArea(
              bottom: true,
              top: false,
              child: UniversalSearchContent(
                onNavigateTab: onNavigateTab,
              ),
            ),
          ),
        );
      },
    );
  }
}

class UniversalSearchContent extends StatefulWidget {
  final ScrollController? scrollController;
  final Function(int tabIndex)? onNavigateTab;

  const UniversalSearchContent({
    super.key,
    this.scrollController,
    this.onNavigateTab,
  });

  @override
  State<UniversalSearchContent> createState() => _UniversalSearchContentState();
}

class _UniversalSearchContentState extends State<UniversalSearchContent> {
  final TextEditingController _searchController = TextEditingController();
  SearchCategory _selectedCategory = SearchCategory.all;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SearchItem> _buildSearchItems() {
    final List<SearchItem> items = [];

    // 1. Al-Qur'an items
    for (final surah in kQuranSurahs) {
      items.add(
        SearchItem(
          id: 'quran_${surah.number}',
          title: 'Surah ${surah.name} (${surah.arabic})',
          subtitle: '${surah.meaning} • ${surah.ayahsCount} Ayat • ${surah.type}',
          categoryName: 'Al-Qur\'an',
          category: SearchCategory.quran,
          icon: Icons.menu_book,
          badge: 'Juz & Ayat',
          onTap: () {
            Navigator.pop(context);
            showSurahReaderModal(context, surah);
          },
        ),
      );
    }

    // 2. Kajian & Media items
    items.addAll([
      SearchItem(
        id: 'media_reel_1',
        title: 'Ketika Doamu Terasa Lambat Dijawab',
        subtitle: 'Ustzh. Halimah Alaydrus • Reels Renungan Qolbu (0:58)',
        categoryName: 'Kajian & Reels',
        category: SearchCategory.media,
        icon: Icons.play_circle_outline,
        badge: 'Reels Syiar',
        onTap: () {
          Navigator.pop(context);
          if (widget.onNavigateTab != null) {
            widget.onNavigateTab!(4); // Media tab
          }
        },
      ),
      SearchItem(
        id: 'media_reel_2',
        title: 'Adab Menjaga Hati di Ruang Sepi',
        subtitle: 'Ust. Hilman Fauzi • Tazkiyatun Nafs (0:45)',
        categoryName: 'Kajian & Reels',
        category: SearchCategory.media,
        icon: Icons.play_circle_outline,
        badge: 'Reels Syiar',
        onTap: () {
          Navigator.pop(context);
          if (widget.onNavigateTab != null) {
            widget.onNavigateTab!(4);
          }
        },
      ),
      SearchItem(
        id: 'game_sambung_ayat',
        title: 'Sambung Ayat Juz \'Amma',
        subtitle: 'Tebak lanjutan ayat Al-Qur\'an Juz 30 berhadiah barakah poin',
        categoryName: 'Khazanah Games',
        category: SearchCategory.media,
        icon: Icons.military_tech_rounded,
        badge: 'Games Edukatif',
        onTap: () {
          Navigator.pop(context);
          if (widget.onNavigateTab != null) {
            widget.onNavigateTab!(3); // Game tab
          }
        },
      ),
      SearchItem(
        id: 'game_sirah',
        title: 'Petualangan Sirah Nabawiyah',
        subtitle: 'Peta interaktif rute hijrah Rasulullah ﷺ ke Madinah',
        categoryName: 'Khazanah Games',
        category: SearchCategory.media,
        icon: Icons.explore_rounded,
        badge: 'Sirah Quest',
        onTap: () {
          Navigator.pop(context);
          if (widget.onNavigateTab != null) {
            widget.onNavigateTab!(3); // Game tab
          }
        },
      ),
      SearchItem(
        id: 'media_kajian_1',
        title: 'Menata Hati Menghadapi Takdir & Ketetapan Ilahi',
        subtitle: 'Ust. Dr. Firanda Andirja, Lc., M.A. • Sanad Sahih (38:20)',
        categoryName: 'Kajian & Reels',
        category: SearchCategory.media,
        icon: Icons.ondemand_video,
        badge: 'Full Kajian',
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const DetailJadwalMajelisScreen()));
        },
      ),
      SearchItem(
        id: 'media_kajian_2',
        title: 'Fiqih Muamalah: Keberkahan Finansial Tanpa Riba',
        subtitle: 'Ust. Dr. Erwandi Tarmizi, M.A. • Seri Syariah (52:14)',
        categoryName: 'Kajian & Reels',
        category: SearchCategory.media,
        icon: Icons.ondemand_video,
        badge: 'Muamalah',
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const DetailJadwalMajelisScreen()));
        },
      ),
      SearchItem(
        id: 'media_kajian_3',
        title: 'Tafsir Surah Ar-Rahman: Merengkuh Kasih Sayang Ilahi',
        subtitle: 'Kajian Sinematik & Streaming Masjid Nabawi (01:15:00)',
        categoryName: 'Kajian & Reels',
        category: SearchCategory.media,
        icon: Icons.live_tv,
        badge: 'Tafsir',
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const DetailJadwalMajelisScreen()));
        },
      ),
    ]);

    // 3. Amalan & Habits items
    items.addAll([
      SearchItem(
        id: 'habit_sholat_subuh',
        title: 'Sholat Subuh Berjamaah di Masjid',
        subtitle: 'Amalan Fardhu Utama • Pukul 04:38 WIB di Masjid Jami\'',
        categoryName: 'Amalan Yaumiyah',
        category: SearchCategory.habits,
        icon: Icons.task_alt,
        badge: 'Fardhu',
        onTap: () {
          Navigator.pop(context);
          if (widget.onNavigateTab != null) {
            widget.onNavigateTab!(1); // Habits tab
          }
        },
      ),
      SearchItem(
        id: 'habit_dzikir_pagi',
        title: 'Dzikir Pagi Al-Ma\'tsurat',
        subtitle: 'Benteng Diri & Ketenangan • 15 Menit Bacaan Kubra',
        categoryName: 'Amalan Yaumiyah',
        category: SearchCategory.habits,
        icon: Icons.spa,
        badge: 'Dzikir',
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const DzikirPagiPetangScreen()));
        },
      ),
      SearchItem(
        id: 'habit_sholat_dhuha',
        title: 'Sholat Dhuha 4–8 Rakaat',
        subtitle: 'Pembuka Rezeki & Sedekah 360 Persendian • Pukul 07:15 WIB',
        categoryName: 'Amalan Yaumiyah',
        category: SearchCategory.habits,
        icon: Icons.wb_sunny_outlined,
        badge: 'Sunnah',
        onTap: () {
          Navigator.pop(context);
          if (widget.onNavigateTab != null) {
            widget.onNavigateTab!(1);
          }
        },
      ),
      SearchItem(
        id: 'habit_sedekah_subuh',
        title: 'Sedekah Subuh Kencleng',
        subtitle: 'Doa Malaikat di Waktu Pagi • Berbagi Barakah Lillahi Ta\'ala',
        categoryName: 'Amalan Yaumiyah',
        category: SearchCategory.habits,
        icon: Icons.volunteer_activism,
        badge: 'Sosial',
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const JurnalSedekahScreen()));
        },
      ),
      SearchItem(
        id: 'habit_tahajjud',
        title: 'Tahajjud & Witir Sepertiga Malam',
        subtitle: 'Munajat Hening Kalbu • 3–11 Rakaat Sebelum Fajar',
        categoryName: 'Amalan Yaumiyah',
        category: SearchCategory.habits,
        icon: Icons.nightlight_round,
        badge: 'Qiyamul Lail',
        onTap: () {
          Navigator.pop(context);
          if (widget.onNavigateTab != null) {
            widget.onNavigateTab!(1);
          }
        },
      ),
      SearchItem(
        id: 'habit_tilawah',
        title: 'Tilawah Qur\'an 1 Juz',
        subtitle: 'Target Khatam 30 Hari Ramadhan • 20 Halaman per Hari',
        categoryName: 'Amalan Yaumiyah',
        category: SearchCategory.habits,
        icon: Icons.auto_stories,
        badge: 'Tilawah',
        onTap: () {
          Navigator.pop(context);
          if (widget.onNavigateTab != null) {
            widget.onNavigateTab!(2); // Quran tab
          }
        },
      ),
    ]);

    // 4. Jadwal & Interactive Tools
    items.addAll([
      SearchItem(
        id: 'tool_qibla',
        title: 'Arah Kiblat Ka\'bah Presisi (295° NW)',
        subtitle: 'Kompas Navigasi Realtime Kiblat Jakarta & Seluruh Dunia',
        categoryName: 'Fitur Ibadah',
        category: SearchCategory.tools,
        icon: Icons.explore,
        badge: '295° NW',
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const QiblaCompassScreen()));
        },
      ),
      SearchItem(
        id: 'tool_tasbih',
        title: 'Tasbih Digital Kalbu',
        subtitle: 'Penghitung Wirid Khusyuk: Subhanallah, Alhamdulillah, Allahu Akbar',
        categoryName: 'Fitur Ibadah',
        category: SearchCategory.tools,
        icon: Icons.touch_app,
        badge: 'Wirid 33x',
        onTap: () {
          Navigator.pop(context);
          showDialog(context: context, builder: (_) => const TasbihDialog());
        },
      ),
      SearchItem(
        id: 'tool_ai_chat',
        title: 'Tanya Al-Ustadz AI (Fiqih 2.0)',
        subtitle: 'Konsultasi Fiqih, Fatwa Ulama, dan Sanad Hadits Sahih Terverifikasi',
        categoryName: 'Fitur Ibadah',
        category: SearchCategory.tools,
        icon: Icons.smart_toy,
        badge: 'AI Sanad',
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const TanyaUstadzChatScreen()));
        },
      ),
      SearchItem(
        id: 'tool_sedekah',
        title: 'Jurnal Sedekah & Kencleng Digital',
        subtitle: 'Catat Mutaba\'ah Infaq Subuh, Donasi Masjid, dan Zakat Fitrah',
        categoryName: 'Fitur Ibadah',
        category: SearchCategory.tools,
        icon: Icons.account_balance_wallet,
        badge: 'Infaq',
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const JurnalSedekahScreen()));
        },
      ),
      SearchItem(
        id: 'tool_masjid',
        title: 'Rute & Radar Masjid Terdekat',
        subtitle: 'Navigasi GPS ke Masjid Sekitar dengan Jadwal Adzan & Sholat Jamaah',
        categoryName: 'Fitur Ibadah',
        category: SearchCategory.tools,
        icon: Icons.location_on,
        badge: 'Radar GPS',
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const RuteMasjidScreen()));
        },
      ),
      SearchItem(
        id: 'tool_dzikir',
        title: 'Dzikir Pagi & Petang Audio Khusyuk',
        subtitle: 'Teks Arab, Terjemahan, Faedah Sunnah, dan Audio Al-Ma\'tsurat',
        categoryName: 'Fitur Ibadah',
        category: SearchCategory.tools,
        icon: Icons.brightness_6,
        badge: 'Sunnah',
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const DzikirPagiPetangScreen()));
        },
      ),
      SearchItem(
        id: 'tool_sisterhood',
        title: 'Sisterhood Sanctuary (Fiqih Wanita)',
        subtitle: 'Kalkulator Siklus Haid, Masa Suci Thaharah, Fiqih Nifas & Istihadhah',
        categoryName: 'Fitur Ibadah',
        category: SearchCategory.tools,
        icon: Icons.local_florist,
        badge: 'Muslimah',
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SisterhoodScreen()));
        },
      ),
      SearchItem(
        id: 'tool_kids',
        title: 'Kids Sanctuary Ceria (Belajar Huruf & Kuis)',
        subtitle: 'Tracing Huruf Hijaiyah, Kuis Sambung Ayat, & Dongeng 25 Nabi',
        categoryName: 'Fitur Ibadah',
        category: SearchCategory.tools,
        icon: Icons.stars,
        badge: 'Anak Ceria',
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => KidsSanctuaryScreen(
                onExitKidsMode: () => Navigator.pop(context),
              ),
            ),
          );
        },
      ),
      SearchItem(
        id: 'tool_notifikasi',
        title: 'Pusat Notifikasi & Alarm Adzan',
        subtitle: 'Pengaturan Suara Muadzin Makkah/Madinah & Waktu Imsakiyah',
        categoryName: 'Fitur Ibadah',
        category: SearchCategory.tools,
        icon: Icons.notifications_active,
        badge: 'Adzan',
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const PusatNotifikasiScreen()));
        },
      ),
    ]);

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final allItems = _buildSearchItems();
    final cleanQuery = _query.trim().toLowerCase();

    final filteredItems = allItems.where((item) {
      final matchesCategory = _selectedCategory == SearchCategory.all || item.category == _selectedCategory;
      if (!matchesCategory) return false;

      if (cleanQuery.isEmpty) return true;

      final matchTitle = item.title.toLowerCase().contains(cleanQuery);
      final matchSubtitle = item.subtitle.toLowerCase().contains(cleanQuery);
      final matchCategory = item.categoryName.toLowerCase().contains(cleanQuery);
      final matchBadge = (item.badge ?? '').toLowerCase().contains(cleanQuery);

      return matchTitle || matchSubtitle || matchCategory || matchBadge;
    }).toList();

    return Container(
      color: AppColors.surfaceContainerLowest,
      child: Column(
        children: [
          // Drag Handle (Mobile)
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Search Header with Input Box
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 6, 18, 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.hairline),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, color: AppColors.primary, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            autofocus: true,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.onSurface,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Cari surah, ayat, kajian, amalan, atau jadwal...',
                              hintStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.outline),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (val) {
                              setState(() {
                                _query = val;
                              });
                            },
                          ),
                        ),
                        if (_query.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() {
                                _query = '';
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.close_rounded, size: 18, color: AppColors.secondary),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                  child: Text(
                    'Tutup',
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),

          // Category Chips Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                _buildCategoryChip('Semua', SearchCategory.all),
                const SizedBox(width: 8),
                _buildCategoryChip('Al-Qur\'an', SearchCategory.quran),
                const SizedBox(width: 8),
                _buildCategoryChip('Kajian & Reels', SearchCategory.media),
                const SizedBox(width: 8),
                _buildCategoryChip('Amalan Yaumiyah', SearchCategory.habits),
                const SizedBox(width: 8),
                _buildCategoryChip('Fitur Ibadah', SearchCategory.tools),
              ],
            ),
          ),

          const SizedBox(height: 8),
          const Divider(color: AppColors.surfaceContainerHigh, height: 1),

          // Body Content: Either Suggestions or Live Results
          Expanded(
            child: _query.isEmpty
                ? _buildEmptyStateSuggestions()
                : _buildSearchResultsList(filteredItems),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, SearchCategory category) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.hairline,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyStateSuggestions() {
    final popularQueries = [
      'Surah Al-Mulk',
      'Surah Al-Kahfi',
      'Dzikir Pagi Al-Ma\'tsurat',
      'Sholat Dhuha',
      'Kompas Kiblat',
      'Kajian Halimah Alaydrus',
      'Sedekah Subuh',
      'Tanya Ustadz AI',
    ];

    return ListView(
      controller: widget.scrollController,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 30),
      children: [
        // Popular Queries Header
        Row(
          children: [
            const Icon(Icons.trending_up, size: 18, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              'Pencarian Populer & Sunnah Utama',
              style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: popularQueries.map((query) {
            return ActionChip(
              avatar: const Icon(Icons.search, size: 14, color: AppColors.secondary),
              label: Text(query),
              labelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.onSurface),
              backgroundColor: AppColors.surfaceContainerLow,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.hairline)),
              onPressed: () {
                _searchController.text = query;
                setState(() {
                  _query = query;
                });
              },
            );
          }).toList(),
        ),

        const SizedBox(height: 24),

        // Quick Category Navigation Cards
        Row(
          children: [
            const Icon(Icons.grid_view_rounded, size: 18, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              'Akses Cepat Fitur Sanctuary',
              style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2.6,
          children: [
            _buildShortcutTile(
              icon: Icons.menu_book,
              title: 'Al-Qur\'an 30 Juz',
              subtitle: 'Baca mushaf & audio',
              onTap: () {
                setState(() {
                  _selectedCategory = SearchCategory.quran;
                });
              },
            ),
            _buildShortcutTile(
              icon: Icons.task_alt,
              title: 'Target Mutaba\'ah',
              subtitle: 'Evaluasi ibadah',
              onTap: () {
                setState(() {
                  _selectedCategory = SearchCategory.habits;
                });
              },
            ),
            _buildShortcutTile(
              icon: Icons.ondemand_video,
              title: 'Kajian & Syiar',
              subtitle: 'Video ceramah & podcast',
              onTap: () {
                setState(() {
                  _selectedCategory = SearchCategory.media;
                });
              },
            ),
            _buildShortcutTile(
              icon: Icons.explore,
              title: 'Kompas Kiblat',
              subtitle: 'Arah 295° NW presisi',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const QiblaCompassScreen()));
              },
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Tadabbur Inspiration Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.mistySage, AppColors.surfaceContainerLow],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pencarian Cerdas Terintegrasi',
                      style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ketikkan nama surah, ustadz, jenis amalan, atau pertanyaan fiqih untuk menemukan panduan instan.',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, height: 1.4, color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShortcutTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.hairline),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryFixed,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.syne(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultsList(List<SearchItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.search_off_rounded, size: 40, color: AppColors.secondary),
              ),
              const SizedBox(height: 16),
              Text(
                'Tidak Ditemukan Hasil',
                style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onSurface),
              ),
              const SizedBox(height: 6),
              Text(
                'Tidak ada surah, kajian, atau amalan yang cocok dengan "$_query". Coba kata kunci lain atau pilih kategori Semua.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ditemukan ${items.length} hasil untuk "$_query"',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
              if (_selectedCategory != SearchCategory.all)
                GestureDetector(
                  onTap: () => setState(() => _selectedCategory = SearchCategory.all),
                  child: Text(
                    'Semua Kategori',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: widget.scrollController,
            padding: const EdgeInsets.fromLTRB(18, 6, 18, 30),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.hairline),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(4),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            leading: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: AppColors.primaryFixed.withAlpha(150),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, size: 20, color: AppColors.primary),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (item.badge != null) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.badge!,
                      style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ),
                ],
              ],
            ),
            subtitle: Text(
              '${item.categoryName} • ${item.subtitle}',
              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: AppColors.outline),
            onTap: item.onTap,
          ),
        );
      },
    ),
  ),
],
    );
  }
}
