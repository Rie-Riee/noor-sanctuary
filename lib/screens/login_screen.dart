import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/sanctuary_mode.dart';
import '../theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final Function(SanctuaryMode mode)? onLoginSuccessWithMode;
  final VoidCallback onGoToRegister;
  final VoidCallback onBack;

  const LoginScreen({
    super.key,
    required this.onLoginSuccess,
    this.onLoginSuccessWithMode,
    required this.onGoToRegister,
    required this.onBack,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifierController = TextEditingController(text: 'aisyah@sanctuary.id');
  final _passwordController = TextEditingController(text: '••••••••');
  bool _obscurePassword = true;
  bool _rememberMe = true;
  SanctuaryMode _selectedProfileMode = SanctuaryMode.sisterhood;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        title: Text(
          'Login',
          style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.person, size: 18, color: AppColors.onPrimary),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  // Hero Greeting
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceContainerLow,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(15),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.spa, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Kembali Menuju Ketenangan',
                    style: GoogleFonts.syne(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Masuk ke akun Sanctuary untuk melanjutkan catatan ibadah, mutaba\'ah, dan hafalan yang tersimpan aman di cloud.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                      height: 1.45,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Login Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.hairline),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(10),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Quick Account Selector
                        Text(
                          'Pilih Akun / Profil Masuk Cepat:',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildAccountChip(
                                label: 'Ummu Rayyan (Bunda)',
                                email: 'aisyah@sanctuary.id',
                                mode: SanctuaryMode.sisterhood,
                                icon: Icons.spa_rounded,
                              ),
                              const SizedBox(width: 8),
                              _buildAccountChip(
                                label: 'Ahmad Rayyan (Anak)',
                                email: 'ahmad@sanctuary.id',
                                mode: SanctuaryMode.kids,
                                icon: Icons.face_rounded,
                              ),
                              const SizedBox(width: 8),
                              _buildAccountChip(
                                label: 'Keluarga Rayyan (Umum)',
                                email: 'keluarga@sanctuary.id',
                                mode: SanctuaryMode.general,
                                icon: Icons.people_alt_rounded,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Identifier field
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Alamat Email / No. WhatsApp',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurface,
                              ),
                            ),
                            Text(
                              'Aman & Terverifikasi',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _identifierController,
                          style: GoogleFonts.plusJakartaSans(fontSize: 13),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.alternate_email, size: 18, color: AppColors.secondary),
                            hintText: 'contoh: aisyah@sanctuary.id',
                            filled: true,
                            fillColor: AppColors.surfaceContainerLow,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Password field
                        Text(
                          'Kata Sandi',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: GoogleFonts.plusJakartaSans(fontSize: 13),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline, size: 18, color: AppColors.secondary),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                size: 18,
                                color: AppColors.secondary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            hintText: 'Masukkan kata sandi rahasia',
                            filled: true,
                            fillColor: AppColors.surfaceContainerLow,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Remember & Forgot
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    activeColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    onChanged: (v) {
                                      setState(() {
                                        _rememberMe = v ?? false;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Ingat Saya',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Tautan reset kata sandi telah dikirim ke email.')),
                                );
                              },
                              child: Text(
                                'Lupa Kata Sandi?',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (widget.onLoginSuccessWithMode != null) {
                                widget.onLoginSuccessWithMode!(_selectedProfileMode);
                              } else {
                                widget.onLoginSuccess();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryContainer,
                              foregroundColor: AppColors.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Masuk ke Sanctuary',
                                  style: GoogleFonts.syne(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      children: [
                        const Expanded(child: Divider(color: AppColors.surfaceContainerHigh)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'atau masuk lebih cepat',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: AppColors.surfaceContainerHigh)),
                      ],
                    ),
                  ),

                  // Fast OAuth Buttons
                  OutlinedButton.icon(
                    onPressed: widget.onLoginSuccess,
                    icon: const Icon(Icons.g_mobiledata, size: 24, color: Colors.blue),
                    label: Text(
                      'Masuk dengan Akun Google',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      side: const BorderSide(color: AppColors.hairline),
                      backgroundColor: AppColors.surfaceContainerLowest,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: widget.onLoginSuccess,
                    icon: const Icon(Icons.chat, size: 18, color: Colors.green),
                    label: Text(
                      'Masuk dengan WhatsApp OTP',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      side: const BorderSide(color: AppColors.hairline),
                      backgroundColor: AppColors.surfaceContainerLowest,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Register switch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Belum memiliki akun? ',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.onSurfaceVariant),
                      ),
                      GestureDetector(
                        onTap: widget.onGoToRegister,
                        child: Text(
                          'Daftar Baru',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountChip({
    required String label,
    required String email,
    required SanctuaryMode mode,
    required IconData icon,
  }) {
    final isSelected = _selectedProfileMode == mode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedProfileMode = mode;
          _identifierController.text = email;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.hairline,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : AppColors.primary,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
