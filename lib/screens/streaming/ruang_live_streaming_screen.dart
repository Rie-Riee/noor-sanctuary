import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class RuangLiveStreamingScreen extends StatefulWidget {
  const RuangLiveStreamingScreen({super.key});

  @override
  State<RuangLiveStreamingScreen> createState() => _RuangLiveStreamingScreenState();
}

class _RuangLiveStreamingScreenState extends State<RuangLiveStreamingScreen> {
  bool _audioOnly = false;
  int _likes = 2410;
  final TextEditingController _commentController = TextEditingController();

  final List<Map<String, String>> _comments = [
    {
      'user': 'Fathimah Azzahra',
      'avatar': 'FA',
      'text': 'Masya Allah penjelasan makna sifat Ar-Rahman sangat menyejukkan hati.',
      'time': 'Baru saja',
    },
    {
      'user': 'Rizky Al-Ghifari',
      'avatar': 'RA',
      'text': 'Alhamdulillah hadir menyimak dari Surabaya, mohon doanya ustadz.',
      'time': '1 mnt',
    },
    {
      'user': 'Khadijah Ummu Maryam',
      'avatar': 'KU',
      'text': 'Jazakallahu khairan ustadz atas faidah tafsir yang begitu mendalam.',
      'time': '2 mnt',
    },
  ];

  void _sendComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _comments.insert(0, {
        'user': 'Anda (Jamaah)',
        'avatar': 'ME',
        'text': text,
        'time': 'Baru saja',
      });
      _commentController.clear();
    });
  }

  void _showInfaqSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Infaq Dakwah Majelis Nabawi',
                style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
              const SizedBox(height: 6),
              Text(
                'Dukung operasional siaran live streaming dakwah sunnah ke seluruh pelosok nusantara.',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [20000, 50000, 100000].map((nominal) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Alhamdulillah, infaq Rp $nominal berhasil disalurkan.')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surfaceContainerLow,
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text('Rp ${nominal ~/ 1000}k'),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ruang Live Majelis Nabawi',
              style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '1.428 Jamaah Terhubung',
                  style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.volunteer_activism_outlined, color: AppColors.primary),
            onPressed: _showInfaqSheet,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              children: [
                // 16:9 Video Player View
                Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    image: _audioOnly
                        ? null
                        : const DecorationImage(
                            image: NetworkImage(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuBB5cx8nfWWVnjwDCN3tdUD--jzB6pAtD_sUKufPK6IVbH93puFCEKXkFCFDNb0I3B9ywEPyrYG8KDrPde8SPvr5e3wMqYrpyImP4loKtBX3d8HocIjoNwcNsP_NCetlzJVNwvvcfw0ksqdzuCIbqUlJaqVDFL8EqXDC2pS-U6DSHf3qcq0KIfe5Xqm9FsdmiFV-W9B5Mkj7Co5uy1taNfox0KwKuQcH60-60nmdbQ',
                            ),
                            fit: BoxFit.cover,
                          ),
                  ),
                  child: Stack(
                    children: [
                      // Dark gradient scrim
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withAlpha(160),
                              Colors.transparent,
                              Colors.black.withAlpha(200),
                            ],
                          ),
                        ),
                      ),
                      // Audio-only replacement visual
                      if (_audioOnly)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.headphones, size: 48, color: AppColors.primaryFixed),
                              const SizedBox(height: 8),
                              Text(
                                'Mode Audio Hemat Kuota Aktif',
                                style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      // Top Bar Overlay
                      Positioned(
                        top: 10,
                        left: 14,
                        right: 14,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(140),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _audioOnly ? 'AUDIO 64kbps' : 'HD 1080p',
                                style: GoogleFonts.plusJakartaSans(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Row(
                              children: [
                                ActionChip(
                                  label: Text(
                                    _audioOnly ? 'Mode Video' : 'Audio Saja',
                                    style: GoogleFonts.plusJakartaSans(fontSize: 10, color: Colors.white),
                                  ),
                                  avatar: Icon(
                                    _audioOnly ? Icons.videocam : Icons.headphones,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  backgroundColor: Colors.black.withAlpha(140),
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  onPressed: () {
                                    setState(() {
                                      _audioOnly = !_audioOnly;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Bottom Overlay Speaker Info
                      Positioned(
                        bottom: 10,
                        left: 14,
                        right: 14,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ustadz Dr. Firanda Andirja, M.A.',
                                    style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                                  ),
                                  Text(
                                    'Kaidah Tafsir Surah Ar-Rahman (Ayat 1-4)',
                                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.white.withAlpha(200)),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'LIVE',
                                style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Scripture Anchor Card
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(14),
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
                          Row(
                            children: [
                              const Icon(Icons.auto_stories, size: 16, color: AppColors.primary),
                              const SizedBox(width: 6),
                              Text(
                                'Rujukan Ayat: QS. Ar-Rahman [55: 1–2]',
                                style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryFixed,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Sedang Disimak',
                              style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.onPrimaryFixed),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'الرَّحْمَٰنُ ﴿١﴾ عَلَّمَ الْقُرْآنَ ﴿٢﴾',
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: AppTheme.quranArabic(fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '"(Tuhan) Yang Maha Pengasih, yang telah mengajarkan Al-Qur\'an."',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),

                // Live Comments Header & List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Obrolan Suci Jamaah',
                        style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface),
                      ),
                      Row(
                        children: [
                          // Reaction Takbir
                          IconButton(
                            icon: const Icon(Icons.star_outline, size: 20, color: AppColors.goldAccent),
                            tooltip: 'Takbir',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Allahu Akbar! ⭐️'), duration: Duration(milliseconds: 800)),
                              );
                            },
                          ),
                          // Reaction Love
                          GestureDetector(
                            onTap: () {
                              setState(() => _likes++);
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.favorite, size: 18, color: Colors.pinkAccent),
                                const SizedBox(width: 4),
                                Text(
                                  '$_likes',
                                  style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Comments List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _comments.length,
                    itemBuilder: (context, idx) {
                      final c = _comments[idx];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: AppColors.surfaceContainerHigh,
                              child: Text(
                                c['avatar']!,
                                style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primary),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLowest,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppColors.hairline),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          c['user']!,
                                          style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                                        ),
                                        Text(
                                          c['time']!,
                                          style: GoogleFonts.plusJakartaSans(fontSize: 9, color: AppColors.secondary),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      c['text']!,
                                      style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Comment Input Bar
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    border: Border(top: BorderSide(color: AppColors.hairline)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          style: GoogleFonts.plusJakartaSans(fontSize: 12),
                          decoration: InputDecoration(
                            hintText: 'Tulis pesan kajian yang santun...',
                            filled: true,
                            fillColor: AppColors.surfaceContainerLow,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSubmitted: (_) => _sendComment(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.send, color: AppColors.primary),
                        onPressed: _sendComment,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
