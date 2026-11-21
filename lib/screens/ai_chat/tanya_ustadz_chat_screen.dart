import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class TanyaUstadzChatScreen extends StatefulWidget {
  final String? initialQuestion;

  const TanyaUstadzChatScreen({super.key, this.initialQuestion});

  @override
  State<TanyaUstadzChatScreen> createState() => _TanyaUstadzChatScreenState();
}

class _TanyaUstadzChatScreenState extends State<TanyaUstadzChatScreen> {
  String _selectedMadzhab = 'Syafi\'i';
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _madzhabs = ['Syafi\'i', 'Hanafi', 'Maliki', 'Hanbali'];

  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'time': '09:00 WIB',
      'text':
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ • السلام عليكم ورحمة الله وبركاته\n\n'
          'Ahlan wa sahlan di Layanan Tanya Al-Ustadz AI. Silakan tanyakan masalah fikih ibadah, muamalah, keabsahan hadits, atau perbandingan fatwa ulama madzhab.',
      'fatwa': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialQuestion != null && widget.initialQuestion!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleSendMessage(widget.initialQuestion!);
      });
    }
  }

  void _handleSendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'isUser': true,
        'time': 'Sekarang',
        'text': text,
        'fatwa': null,
      });
    });
    _textController.clear();

    // Generate response
    Future.delayed(const Duration(milliseconds: 600), () {
      String response = '';
      String fatwaSummary = '';

      final lower = text.toLowerCase();
      if (lower.contains('mata') || lower.contains('tetes')) {
        fatwaSummary = 'Obat tetes mata TIDAK MEMBATALKAN PUASA menurut fatwa mayoritas ulama kontemporer dan mu\'tamad.';
        response =
            'Mata bukanlah saluran terbuka (manfad maftuh) menuju lambung (jauf). Meskipun terkadang rasa obat terasa di tenggorokan, itu melalui pori-pori halus, bukan karena saluran makan dan minum. Oleh karena itu, ibadah puasa tetap sah sempurna (Kitab Majmu\' Fatawa Ibnu Taimiyyah & Fatwa Darul Ifta).';
      } else if (lower.contains('flek') || lower.contains('haid')) {
        fatwaSummary = 'Flek di luar batas maksimal haid (15 hari) dihukumi ISTIHADHAH.';
        response =
            'Dalam madzhab Imam Asy-Syafi\'i, masa minimal haid adalah sehari semalam (24 jam), dan masa maksimal adalah 15 hari 15 malam. Jika flek keluar setelah melewati 15 hari atau keluar pada masa suci murni, maka dihukumi darah istihadhah (penyakit). Wajib mandi thaharah, wajib berwudhu setiap hendak sholat, dan tetap wajib sholat serta puasa (Kitab Fathul Qarib Al-Mujib).';
      } else if (lower.contains('safar') || lower.contains('puasa')) {
        fatwaSummary = 'Musafir diperbolehkan rukhshah berbuka, namun berpuasa lebih utama jika tidak memberatkan.';
        response =
            'Berdasarkan QS. Al-Baqarah: 184, bagi yang safar sejauh 2 marhalah (±85 km) dengan safar mubah, dibolehkan tidak berpuasa dan mengganti (qadha) di hari lain. Menurut jumhur ulama madzhab Syafi\'i, berpuasa lebih afdhal selama tidak membahayakan fisik.';
      } else {
        fatwaSummary = 'Kaidah Fiqih Menurut Madzhab $_selectedMadzhab:';
        response =
            'Setiap perkara ibadah mahdhah dibangun di atas dalil syar\'i (tauqifiyyah). Sedangkan dalam muamalah dan adat, hukum asalnya adalah mubah kecuali ada dalil yang melarang. Untuk pertanyaan "$text", hendaknya merujuk pada kitab fiqih mu\'tamad madzhab $_selectedMadzhab dengan bimbingan ustadz ahli.';
      }

      if (mounted) {
        setState(() {
          _messages.add({
            'isUser': false,
            'time': 'Baru saja',
            'text': response,
            'fatwa': fatwaSummary,
          });
        });

        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Al-Ustadz Syariah AI',
                  style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.tertiaryFixed,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Mu\'tamad',
                    style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.tertiary),
                  ),
                ),
              ],
            ),
            Text(
              'Dewan Fiqih Kontemporer • Rujukan Kitab Kuning',
              style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Column(
              children: [
                // Madzhab Selector Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: AppColors.surfaceContainerLowest,
                  child: Row(
                    children: [
                      Text(
                        'Rujukan Madzhab: ',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.secondary),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _madzhabs.map((m) {
                              final isSelected = m == _selectedMadzhab;
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: ChoiceChip(
                                  selected: isSelected,
                                  label: Text('Imam $m'),
                                  labelStyle: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.white : AppColors.onSurface,
                                  ),
                                  selectedColor: AppColors.primary,
                                  backgroundColor: AppColors.surfaceContainerLow,
                                  showCheckmark: false,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  onSelected: (v) {
                                    if (v) setState(() => _selectedMadzhab = m);
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Quick Topic Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Row(
                    children: [
                      'Obat tetes mata saat puasa?',
                      'Hukum flek darah di luar haid?',
                      'Puasa musafir jarak jauh',
                      'Shalat Jama\' & Qashar',
                      'Zakat tabungan emas',
                    ].map((topic) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ActionChip(
                          label: Text(topic),
                          labelStyle: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                          backgroundColor: AppColors.secondaryContainer.withAlpha(160),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          onPressed: () => _handleSendMessage(topic),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Messages List
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _messages.length,
                    itemBuilder: (context, idx) {
                      final msg = _messages[idx];
                      final isUser = msg['isUser'] as bool;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Align(
                          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isUser ? AppColors.primary : AppColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(20),
                                  topRight: const Radius.circular(20),
                                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                                  bottomRight: Radius.circular(isUser ? 4 : 20),
                                ),
                                border: isUser ? null : Border.all(color: AppColors.hairline),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(6),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!isUser) ...[
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor: AppColors.primaryContainer,
                                          child: const Icon(Icons.mosque, color: Colors.white, size: 14),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Al-Ustadz AI (Madzhab $_selectedMadzhab)',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                  if (msg['fatwa'] != null) ...[
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                        color: AppColors.tertiaryFixed.withAlpha(120),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.verified, size: 16, color: AppColors.tertiary),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              msg['fatwa'] as String,
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.onTertiaryFixed,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  Text(
                                    msg['text'] as String,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: isUser ? Colors.white : AppColors.onSurface,
                                      height: 1.45,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      msg['time'] as String,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 9,
                                        color: isUser ? Colors.white70 : AppColors.secondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Chat Input Bar
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
                          controller: _textController,
                          style: GoogleFonts.plusJakartaSans(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Tanyakan hukum syar\'i atau konsultasi fikih...',
                            filled: true,
                            fillColor: AppColors.surfaceContainerLow,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                          ),
                          onSubmitted: _handleSendMessage,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.send, size: 18),
                        onPressed: () => _handleSendMessage(_textController.text),
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
