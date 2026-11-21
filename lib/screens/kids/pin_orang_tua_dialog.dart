import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class PinOrangTuaScreen extends StatefulWidget {
  final VoidCallback onSuccess;

  const PinOrangTuaScreen({super.key, required this.onSuccess});

  @override
  State<PinOrangTuaScreen> createState() => _PinOrangTuaScreenState();
}

class _PinOrangTuaScreenState extends State<PinOrangTuaScreen> {
  final String _correctPin = '8251';
  String _enteredPin = '';
  bool _hasError = false;

  void _onKeyPress(String key) {
    if (_enteredPin.length < 4) {
      setState(() {
        _enteredPin += key;
        _hasError = false;
      });

      if (_enteredPin.length == 4) {
        _verifyPin();
      }
    }
  }

  void _onBackspace() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _hasError = false;
      });
    }
  }

  void _onClear() {
    setState(() {
      _enteredPin = '';
      _hasError = false;
    });
  }

  void _verifyPin() {
    if (_enteredPin == _correctPin || _enteredPin == '1234') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN Bunda terverifikasi. Akses orang tua terbuka!')),
      );
      Navigator.pop(context);
      widget.onSuccess();
    } else {
      setState(() {
        _hasError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PIN salah. Silakan coba kembali atau gunakan 8251.'),
          backgroundColor: AppColors.error,
        ),
      );
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) _onClear();
      });
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
          'Izin & Kontrol Orang Tua',
          style: GoogleFonts.syne(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.primary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          children: [
            // Shield & Family Circle
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.lavender.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.shield_outlined, size: 40, color: AppColors.primary),
                  Positioned(
                    bottom: 12,
                    right: 14,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.family_restroom, size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              'Izin Orang Tua (Parental Gate)',
              textAlign: TextAlign.center,
              style: GoogleFonts.syne(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 6),

            // Linked Parent Info Chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.lavender.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_pin, size: 14, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    'Akun Tertaut: Ummu Rayyan (Aisyah)',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Subtitle
            Text(
              'Kids Mode diproteksi agar ananda tetap aman di zona santri cilik. Masukkan 4 digit PIN Orang Tua untuk keluar atau mengatur batasan.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppColors.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'PIN Default: 1234 atau 8251',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),

            // PIN Dots Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(4, (index) {
                  final isFilled = index < _enteredPin.length;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _hasError
                          ? AppColors.error
                          : isFilled
                              ? AppColors.primary
                              : AppColors.outlineVariant,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),

            // Numpad Grid
            Column(
              children: [
                _buildNumpadRow([
                  _buildNumpadButton('1', 'SANCTUARY'),
                  _buildNumpadButton('2', 'ABC'),
                  _buildNumpadButton('3', 'DEF'),
                ]),
                const SizedBox(height: 12),
                _buildNumpadRow([
                  _buildNumpadButton('4', 'GHI'),
                  _buildNumpadButton('5', 'JKL'),
                  _buildNumpadButton('6', 'MNO'),
                ]),
                const SizedBox(height: 12),
                _buildNumpadRow([
                  _buildNumpadButton('7', 'PQRS'),
                  _buildNumpadButton('8', 'TUV'),
                  _buildNumpadButton('9', 'WXYZ'),
                ]),
                const SizedBox(height: 12),
                _buildNumpadRow([
                  _buildActionNumpadButton('HAPUS', onTap: _onClear),
                  _buildNumpadButton('0', '+'),
                  _buildIconNumpadButton(Icons.backspace_outlined, onTap: _onBackspace),
                ]),
              ],
            ),
            const SizedBox(height: 20),

            // Biometric Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.powderBlue,
                foregroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sensor biometrik (Fingerprint/FaceID) terverifikasi!')),
                );
                Navigator.pop(context);
                widget.onSuccess();
              },
              icon: const Icon(Icons.fingerprint_rounded, size: 20),
              label: Text(
                'Gunakan Biometrik (Fingerprint / Face ID)',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 10),

            // Lupa PIN
            TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kode OTP pemulihan dikirim ke WhatsApp Bunda (+62 812-3456-7890).')),
                );
              },
              icon: const Icon(Icons.restore_rounded, size: 14, color: AppColors.outline),
              label: Text(
                'Lupa PIN Orang Tua? Pulihkan via WhatsApp/Email',
                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.outline),
              ),
            ),
            const SizedBox(height: 12),

            // Proteksi Penuh Info Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.hairline),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_user_outlined, size: 22, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Proteksi Penuh Kids Sanctuary',
                          style: GoogleFonts.syne(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Kids Sanctuary dirancang tanpa iklan, tanpa tautan luar bebas, dan sepenuhnya dalam pantauan orang tua.',
                          style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.onSurfaceVariant, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildNumpadRow(List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: children.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: c))).toList(),
    );
  }

  Widget _buildNumpadButton(String number, String letters) {
    return GestureDetector(
      onTap: () => _onKeyPress(number),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.hairline),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              number,
              style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
            Text(
              letters,
              style: GoogleFonts.plusJakartaSans(fontSize: 8.5, fontWeight: FontWeight.w600, color: AppColors.outline),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionNumpadButton(String label, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildIconNumpadButton(IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
      ),
    );
  }
}
