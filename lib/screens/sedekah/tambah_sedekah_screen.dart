import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/sedekah_entry.dart';
import '../../theme/app_colors.dart';

class TambahSedekahScreen extends StatefulWidget {
  final ValueChanged<SedekahRecord> onSaved;

  const TambahSedekahScreen({super.key, required this.onSaved});

  @override
  State<TambahSedekahScreen> createState() => _TambahSedekahScreenState();
}

class _TambahSedekahScreenState extends State<TambahSedekahScreen> {
  String _selectedCategory = 'Kencleng Subuh Rumahan';
  int _selectedAmount = 25000;
  final TextEditingController _customAmountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController(text: 'Niat ikhlas lillahi ta\'ala');

  final List<String> _categories = [
    'Kencleng Subuh Rumahan',
    'Bantuan Yatim / Dhuafa',
    'Infaq Masjid',
    'Wakaf Quran / Air Bersih',
  ];

  final List<int> _presetAmounts = [10000, 25000, 50000, 100000];

  void _save() {
    int amount = _selectedAmount;
    if (_customAmountController.text.isNotEmpty) {
      amount = int.tryParse(_customAmountController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? _selectedAmount;
    }

    final newRec = SedekahRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: _selectedCategory,
      amount: amount,
      date: DateTime.now(),
      time: 'Baru saja',
      note: _noteController.text.trim().isEmpty ? 'Niat ikhlas lillahi ta\'ala' : _noteController.text.trim(),
    );

    widget.onSaved(newRec);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Catatan sedekah subuh berhasil disimpan! Barokallahu fiik.')),
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
        title: Text(
          'Tambah Catatan Sedekah',
          style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Renungan Fajar Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryFixed.withAlpha(120),
                          AppColors.surfaceContainerLow,
                          AppColors.secondaryContainer.withAlpha(100),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
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
                                const Icon(Icons.wb_twilight, size: 16, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Text(
                                  'Renungan Fajar',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onPrimaryFixedVariant,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.tertiaryFixed,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.lock, size: 12, color: AppColors.tertiary),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Catatan Rahasia',
                                    style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.tertiary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '“Harta tidak akan berkurang karena sedekah.”',
                          style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.onSurface),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'HR. Muslim no. 2588',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Bentuk Sedekah Mandiri
                  Text(
                    'Bentuk Sedekah Mandiri',
                    style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categories.map((cat) {
                      final isSelected = cat == _selectedCategory;
                      return ChoiceChip(
                        selected: isSelected,
                        label: Text(cat),
                        labelStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.onSurface,
                        ),
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surfaceContainerLow,
                        showCheckmark: false,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        onSelected: (v) {
                          if (v) setState(() => _selectedCategory = cat);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 22),

                  // Nominal Sedekah
                  Text(
                    'Nominal Sedekah',
                    style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: _presetAmounts.map((amt) {
                      final isSelected = _selectedAmount == amt && _customAmountController.text.isEmpty;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedAmount = amt;
                                _customAmountController.clear();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: isSelected ? AppColors.primary : AppColors.hairline),
                              ),
                              child: Center(
                                child: Text(
                                  'Rp ${amt ~/ 1000}k',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isSelected ? Colors.white : AppColors.onSurface,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),

                  // Custom Amount Field
                  TextField(
                    controller: _customAmountController,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.plusJakartaSans(fontSize: 13),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.payments_outlined, size: 18, color: AppColors.secondary),
                      hintText: 'Atau masukkan nominal lain (Rp)',
                      filled: true,
                      fillColor: AppColors.surfaceContainerLow,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Secret Note
                  Text(
                    'Catatan Hati / Doa Khusus (Opsional)',
                    style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _noteController,
                    maxLines: 3,
                    style: GoogleFonts.plusJakartaSans(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Tuliskan niat pribadi, doa untuk orang tua, atau permohonan hajat...',
                      filled: true,
                      fillColor: AppColors.surfaceContainerLow,
                      contentPadding: const EdgeInsets.all(14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Simpan Catatan Sedekah Subuh',
                            style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
