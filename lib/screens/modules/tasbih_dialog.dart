import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class TasbihDialog extends StatefulWidget {
  const TasbihDialog({super.key});

  @override
  State<TasbihDialog> createState() => _TasbihDialogState();
}

class _TasbihDialogState extends State<TasbihDialog> {
  int _count = 0;
  int _target = 33;
  int _laps = 0;
  String _currentDzikir = 'Subhanallah (سُبْحَانَ اللَّهِ)';

  final List<String> _dzikirOptions = [
    'Subhanallah (سُبْحَانَ اللَّهِ)',
    'Alhamdulillah (الْحَمْدُ لِلَّهِ)',
    'Allahu Akbar (اللَّهُ أَكْبَرُ)',
    'Laa ilaaha illallah (لَا إِلٰهَ إِلَّا اللَّهُ)',
    'Astaghfirullah (أَسْتَغْفِرُ اللَّهَ)',
  ];

  void _increment() {
    HapticFeedback.lightImpact();
    setState(() {
      _count++;
      if (_target > 0 && _count >= _target) {
        _laps++;
        _count = 0;
        HapticFeedback.heavyImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Target $_target Dzikir tercapai! Alhamdulillah (Putaran ke-$_laps)'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
  }

  void _reset() {
    setState(() {
      _count = 0;
      _laps = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = _target > 0 ? (_count / _target).clamp(0.0, 1.0) : 0.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 420,
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppColors.hairline),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(20),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.blushPink,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.all_inclusive, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tasbih Digital',
                          style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.primary),
                        ),
                        Text(
                          'Haptic Counter & Target',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.secondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Dropdown Dzikir
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _currentDzikir,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                  items: _dzikirOptions
                      .map((d) => DropdownMenuItem(
                            value: d,
                            child: Text(
                              d,
                              style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                            ),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _currentDzikir = val;
                        _count = 0;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Big Interactive Circular Button
            GestureDetector(
              onTap: _increment,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Circular Progress Indicator
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      backgroundColor: AppColors.surfaceContainerLow,
                      color: AppColors.primary,
                    ),
                  ),
                  // Inner Press Target
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.surfaceContainerLowest,
                          AppColors.blushPink.withAlpha(120),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(20),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$_count',
                          style: GoogleFonts.syne(
                            fontSize: 44,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'Target: $_target',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Laps & Target chips
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Putaran: $_laps',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.onSecondaryContainer),
                  ),
                ),
                const SizedBox(width: 8),
                for (final t in [33, 99, 100]) ...[
                  GestureDetector(
                    onTap: () => setState(() => _target = t),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _target == t ? AppColors.primary : AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$t',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _target == t ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
              ],
            ),
            const SizedBox(height: 20),

            // Reset & Close
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh, size: 16),
                    label: Text(
                      'Ulang',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.secondary,
                      side: const BorderSide(color: AppColors.hairline),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _increment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(
                      'Ketuk Tasbih',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  }
}
