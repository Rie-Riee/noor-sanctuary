import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class CatatSiklusScreen extends StatefulWidget {
  final Function(String status, int day)? onSave;

  const CatatSiklusScreen({super.key, this.onSave});

  @override
  State<CatatSiklusScreen> createState() => _CatatSiklusScreenState();
}

class _CatatSiklusScreenState extends State<CatatSiklusScreen> {
  String _selectedStatus = 'haid'; // 'haid', 'suci', 'istihadhah', 'nifas'
  DateTime _selectedDate = DateTime.now();
  String _selectedTime = 'Siang'; // 'Pagi', 'Siang', 'Sore', 'Malam'
  final Set<String> _selectedSymptoms = {'Mood Sensitif'};
  final TextEditingController _notesController = TextEditingController();

  final List<Map<String, dynamic>> _statusOptions = [
    {
      'id': 'haid',
      'title': 'Mulai Haid',
      'subtitle': 'Keluarnya darah bulanan',
      'icon': Icons.water_drop_rounded,
      'color': const Color(0xFFE57373),
    },
    {
      'id': 'suci',
      'title': 'Darah Berhenti',
      'subtitle': 'Mandi Wajib / Thaharah',
      'icon': Icons.bathtub_outlined,
      'color': const Color(0xFF81C784),
    },
    {
      'id': 'istihadhah',
      'title': 'Flek / Istihadhah',
      'subtitle': 'Darah penyakit di luar siklus',
      'icon': Icons.help_outline_rounded,
      'color': const Color(0xFFFFB74D),
    },
    {
      'id': 'nifas',
      'title': 'Masa Nifas',
      'subtitle': 'Pasca melahirkan anak',
      'icon': Icons.shield_outlined,
      'color': const Color(0xFFBA68C8),
    },
  ];

  final List<String> _symptomOptions = [
    'Nyeri Perut (Dismenore)',
    'Mood Sensitif',
    'Lelah Berlebih',
    'Sakit Kepala',
    'Normal / Tenang',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _handleSave() {
    widget.onSave?.call(_selectedStatus, 4);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Catatan siklus thaharah berhasil diperbarui & disimpan aman!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2027),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Catat Siklus Thaharah',
          style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SISTERHOOD MODE banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lavender.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.hairline),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.hairline),
                    ),
                    child: const Icon(Icons.lock_rounded, size: 18, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'SISTERHOOD MODE',
                              style: GoogleFonts.syne(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(color: AppColors.outline, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Privasi Terjaga',
                              style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Pencatatan siklus suci, darah haid, nifas, dan flek (istihadhah) terverifikasi kaidah Fiqih Syafi\'i dengan perlindungan enkripsi lokal.',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant, height: 1.35),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Status yang Dialami Hari Ini
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status yang Dialami Hari Ini',
                  style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
                Text(
                  'Pilih salah satu',
                  style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.outline),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 2x2 Grid Status
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.25,
              ),
              itemCount: _statusOptions.length,
              itemBuilder: (context, idx) {
                final opt = _statusOptions[idx];
                final isSelected = _selectedStatus == opt['id'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedStatus = opt['id'] as String),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected ? (opt['color'] as Color).withValues(alpha: 0.15) : AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? (opt['color'] as Color) : AppColors.hairline,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: (opt['color'] as Color).withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(opt['icon'] as IconData, size: 20, color: opt['color'] as Color),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle_rounded, size: 20, color: AppColors.primary),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              opt['title'] as String,
                              style: GoogleFonts.syne(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              opt['subtitle'] as String,
                              style: GoogleFonts.plusJakartaSans(fontSize: 9.5, color: AppColors.outline),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Waktu & Tanggal Mulai
            Text(
              'Waktu & Tanggal Mulai',
              style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.hairline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tanggal Masuk
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TANGGAL MASUK',
                                style: GoogleFonts.plusJakartaSans(fontSize: 8.5, fontWeight: FontWeight.w800, color: AppColors.outline),
                              ),
                              Text(
                                'Hari ini, ${_selectedDate.day} ${_monthName(_selectedDate.month)} ${_selectedDate.year}',
                                style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: _pickDate,
                          child: Text(
                            'Ubah',
                            style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  Text(
                    'Perkiraan Waktu Keluar Darah',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 8),

                  // Pagi, Siang, Sore, Malam
                  Row(
                    children: [
                      _buildTimeOption('Pagi', Icons.wb_twilight_outlined),
                      const SizedBox(width: 8),
                      _buildTimeOption('Siang', Icons.wb_sunny_outlined),
                      const SizedBox(width: 8),
                      _buildTimeOption('Sore', Icons.wb_sunny),
                      const SizedBox(width: 8),
                      _buildTimeOption('Malam', Icons.nightlight_round_outlined),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Gejala Fisik & Keluhan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Gejala Fisik & Keluhan',
                  style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
                Text(
                  'Multi-pilihan',
                  style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.outline),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _symptomOptions.map((sym) {
                final isSelected = _selectedSymptoms.contains(sym);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedSymptoms.remove(sym);
                      } else {
                        _selectedSymptoms.add(sym);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? AppColors.primary : AppColors.hairline),
                    ),
                    child: Text(
                      sym,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.primary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Panduan Fiqih Nisa
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFFCCD5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.menu_book_rounded, size: 18, color: Color(0xFFBA1A1A)),
                      const SizedBox(width: 8),
                      Text(
                        'Panduan Fiqih Nisa (Status Sholat & Puasa)',
                        style: GoogleFonts.syne(fontSize: 12.5, fontWeight: FontWeight.w700, color: const Color(0xFFBA1A1A)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tidak diwajibkan sholat dan puasa selama darah haid keluar. Ganti puasa (qadha) setelah suci, sedangkan sholat gugur tanpa qadha (HR. Bukhari & Muslim).',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: const Color(0xFF5F2120), height: 1.4),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Membuka rujukan bab Thaharah Kitab Al-Yaqut An-Nafis fi Madzhab Ibni Idris...')),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          'Rujukan Fiqih Al-Yaqut An-Nafis',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFFBA1A1A)),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_rounded, size: 13, color: Color(0xFFBA1A1A)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Catatan Pribadi & Pengamatan
            Text(
              'Catatan Pribadi & Pengamatan',
              style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.hairline),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    style: GoogleFonts.plusJakartaSans(fontSize: 12.5),
                    decoration: InputDecoration(
                      hintText: 'Tuliskan catatan khusus warna darah (kehitaman/merah/kekuningan), durasi, atau referensi medis dokter...',
                      hintStyle: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.outline),
                      border: InputBorder.none,
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.lock_outline, size: 12, color: AppColors.outline),
                          const SizedBox(width: 4),
                          Text(
                            'Tersimpan lokal & aman',
                            style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline),
                          ),
                        ],
                      ),
                      Text(
                        '${_notesController.text.length}/250',
                        style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Insight Siklus Anda
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.lavender,
                    child: const Icon(Icons.insights_rounded, size: 20, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Insight Siklus Anda',
                          style: GoogleFonts.syne(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                        Text(
                          'Rata-rata siklus suci: 23 hari',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.hairline),
                    ),
                    child: Text(
                      'Teratur',
                      style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700, color: Colors.green[800]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              onPressed: _handleSave,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bookmark_add_outlined, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Simpan Catatan Siklus',
                    style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Secondary Button
            TextButton.icon(
              style: TextButton.styleFrom(
                minimumSize: const Size.fromHeight(46),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Menampilkan grafik riwayat siklus 6 bulan terakhir...')),
                );
              },
              icon: const Icon(Icons.auto_graph_rounded, size: 16, color: AppColors.primary),
              label: Text(
                'Lihat Riwayat & Grafik Siklus Sebelumnya',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeOption(String label, IconData icon) {
    final isSelected = _selectedTime == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTime = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, size: 18, color: isSelected ? Colors.white : AppColors.primary),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const names = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return names[month - 1];
  }
}
