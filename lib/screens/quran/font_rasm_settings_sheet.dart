import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class FontRasmSettingsSheet extends StatefulWidget {
  final double currentFontSize;
  final String currentFontFamily;
  final String currentRasm;
  final bool coloredTajwid;
  final ValueChanged<double>? onFontSizeChanged;
  final ValueChanged<String>? onFontFamilyChanged;
  final ValueChanged<String>? onRasmChanged;
  final ValueChanged<bool>? onTajwidToggled;

  const FontRasmSettingsSheet({
    super.key,
    this.currentFontSize = 26.0,
    this.currentFontFamily = 'Uthmanic Hafs',
    this.currentRasm = "Rasm 'Utsmani Madinah",
    this.coloredTajwid = true,
    this.onFontSizeChanged,
    this.onFontFamilyChanged,
    this.onRasmChanged,
    this.onTajwidToggled,
  });

  static Future<void> show(
    BuildContext context, {
    double currentFontSize = 26.0,
    String currentFontFamily = 'Uthmanic Hafs',
    String currentRasm = "Rasm 'Utsmani Madinah",
    bool coloredTajwid = true,
    ValueChanged<double>? onFontSizeChanged,
    ValueChanged<String>? onFontFamilyChanged,
    ValueChanged<String>? onRasmChanged,
    ValueChanged<bool>? onTajwidToggled,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => FontRasmSettingsSheet(
        currentFontSize: currentFontSize,
        currentFontFamily: currentFontFamily,
        currentRasm: currentRasm,
        coloredTajwid: coloredTajwid,
        onFontSizeChanged: onFontSizeChanged,
        onFontFamilyChanged: onFontFamilyChanged,
        onRasmChanged: onRasmChanged,
        onTajwidToggled: onTajwidToggled,
      ),
    );
  }

  @override
  State<FontRasmSettingsSheet> createState() => _FontRasmSettingsSheetState();
}

class _FontRasmSettingsSheetState extends State<FontRasmSettingsSheet> {
  late double _fontSize;
  late String _fontFamily;
  late String _rasm;
  late bool _coloredTajwid;

  @override
  void initState() {
    super.initState();
    _fontSize = widget.currentFontSize;
    _fontFamily = widget.currentFontFamily;
    _rasm = widget.currentRasm;
    _coloredTajwid = widget.coloredTajwid;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDesktop = screenWidth > 640;

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 580,
          maxHeight: screenHeight * 0.9,
        ),
        margin: isDesktop
            ? EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              )
            : null,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: isDesktop
              ? BorderRadius.circular(32)
              : const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: isDesktop
              ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(40),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  )
                ]
              : null,
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              top: 16,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          // Handle bar
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.format_size, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Preferensi Font & Rasm',
                    style: GoogleFonts.syne(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.secondary, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 1. Ukuran Font Slider
          Text(
            'Ukuran Font Arab (${_fontSize.toInt()} px)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text('A-', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.secondary)),
              Expanded(
                child: Slider(
                  value: _fontSize,
                  min: 20.0,
                  max: 36.0,
                  divisions: 8,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.surfaceContainerHigh,
                  onChanged: (val) {
                    setState(() => _fontSize = val);
                    widget.onFontSizeChanged?.call(val);
                  },
                ),
              ),
              Text('A+', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 14),

          // 2. Jenis Font
          Text(
            'Khat & Font Arab',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildChoiceChip(
                label: 'Uthmanic Hafs',
                selected: _fontFamily == 'Uthmanic Hafs',
                onSelected: () {
                  setState(() => _fontFamily = 'Uthmanic Hafs');
                  widget.onFontFamilyChanged?.call('Uthmanic Hafs');
                },
              ),
              _buildChoiceChip(
                label: 'IndoPak Naskh',
                selected: _fontFamily == 'IndoPak Naskh',
                onSelected: () {
                  setState(() => _fontFamily = 'IndoPak Naskh');
                  widget.onFontFamilyChanged?.call('IndoPak Naskh');
                },
              ),
              _buildChoiceChip(
                label: 'Amiri Standar',
                selected: _fontFamily == 'Amiri Standar',
                onSelected: () {
                  setState(() => _fontFamily = 'Amiri Standar');
                  widget.onFontFamilyChanged?.call('Amiri Standar');
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 3. Standar Rasm
          Text(
            'Standar Rasm',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildChoiceChip(
                  label: "Rasm 'Utsmani Madinah",
                  selected: _rasm == "Rasm 'Utsmani Madinah",
                  onSelected: () {
                    setState(() => _rasm = "Rasm 'Utsmani Madinah");
                    widget.onRasmChanged?.call("Rasm 'Utsmani Madinah");
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildChoiceChip(
                  label: 'Standar Kemenag RI',
                  selected: _rasm == 'Standar Kemenag RI',
                  onSelected: () {
                    setState(() => _rasm = 'Standar Kemenag RI');
                    widget.onRasmChanged?.call('Standar Kemenag RI');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 4. Tajwid Berwarna Switch
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.palette_outlined, color: AppColors.primary, size: 20),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Panduan Tajwid Berwarna',
                          style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                        ),
                        Text(
                          'Ikhfa, Ghunnah, Mad Wajib, Qalqalah',
                          style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary),
                        ),
                      ],
                    ),
                  ],
                ),
                Switch(
                  value: _coloredTajwid,
                  activeTrackColor: AppColors.primary,
                  onChanged: (val) {
                    setState(() => _coloredTajwid = val);
                    widget.onTajwidToggled?.call(val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Save button
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Terapkan Preferensi',
                style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceChip({required String label, required bool selected, required VoidCallback onSelected}) {
    return InkWell(
      onTap: onSelected,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.outlineVariant.withAlpha(80),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? Colors.white : AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}
