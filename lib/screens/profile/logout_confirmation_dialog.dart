import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/sanctuary_mode.dart';
import '../../theme/app_colors.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  final SanctuaryMode currentMode;
  final VoidCallback onLogout;
  final ValueChanged<SanctuaryMode> onSwitchMode;

  const LogoutConfirmationDialog({
    super.key,
    required this.currentMode,
    required this.onLogout,
    required this.onSwitchMode,
  });

  static Future<void> show(
    BuildContext context, {
    required SanctuaryMode currentMode,
    required VoidCallback onLogout,
    required ValueChanged<SanctuaryMode> onSwitchMode,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Center(
        child: LogoutConfirmationDialog(
          currentMode: currentMode,
          onLogout: onLogout,
          onSwitchMode: onSwitchMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDesktop = screenWidth > 640;

    return Container(
      constraints: BoxConstraints(
        maxWidth: 540,
        maxHeight: screenHeight * 0.9,
      ),
      margin: isDesktop
          ? EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            )
          : null,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: isDesktop
            ? BorderRadius.circular(32)
            : const BorderRadius.vertical(top: Radius.circular(32)),
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
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
          // Drag handle
          Container(
            width: 44,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Logout Confirmation',
                style: GoogleFonts.syne(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 22, color: AppColors.outline),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Shield & Mail Icon
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: AppColors.lavender.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.mark_email_read_outlined, size: 36, color: AppColors.primary),
                Positioned(
                  top: 10,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryFixed,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shield, size: 12, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            'Konfirmasi Keluar • Ganti Akun',
            textAlign: TextAlign.center,
            style: GoogleFonts.syne(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            'Data tilawah, doa tersimpan, dan catatan ibadah Anda tetap aman terenkripsi di Cloud Sanctuary.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppColors.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),

          // Active User Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.hairline),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: currentMode.accountColor,
                  child: Icon(
                    currentMode.accountIcon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            currentMode.accountName,
                            style: GoogleFonts.syne(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              currentMode == SanctuaryMode.kids ? 'Santri Cilik' : 'Aktif',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.green[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        currentMode.accountEmail,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppColors.outline,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.hairline),
                  ),
                  child: const Icon(Icons.verified, size: 16, color: AppColors.goldAccent),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // PILIH RUANG IBADAH • MODE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PILIH RUANG IBADAH • MODE',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: AppColors.outline,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.groups_outlined, size: 13, color: AppColors.outline),
                  const SizedBox(width: 4),
                  Text(
                    '3 Profil Keluarga',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.outline,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 3 Family Profile Cards
          Row(
            children: [
              Expanded(
                child: _buildModeOption(
                  icon: Icons.spa_rounded,
                  title: 'Ummu Rayyan',
                  subtitle: 'Sisterhood',
                  color: AppColors.lavender,
                  isSelected: currentMode == SanctuaryMode.sisterhood,
                  onTap: () {
                    Navigator.pop(context);
                    onSwitchMode(SanctuaryMode.sisterhood);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildModeOption(
                  icon: Icons.face_rounded,
                  title: 'Ahmad Rayyan',
                  subtitle: 'Kids Sanctuary',
                  color: AppColors.mistySage,
                  isSelected: currentMode == SanctuaryMode.kids,
                  onTap: () {
                    Navigator.pop(context);
                    onSwitchMode(SanctuaryMode.kids);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildModeOption(
                  icon: Icons.people_alt_rounded,
                  title: 'Keluarga',
                  subtitle: 'General Mode',
                  color: AppColors.primaryFixed,
                  isSelected: currentMode == SanctuaryMode.general,
                  onTap: () {
                    Navigator.pop(context);
                    onSwitchMode(SanctuaryMode.general);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Button: Ganti Profil Pengguna
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pop(context);
              onSwitchMode(
                currentMode == SanctuaryMode.general
                    ? SanctuaryMode.sisterhood
                    : currentMode == SanctuaryMode.sisterhood
                        ? SanctuaryMode.kids
                        : SanctuaryMode.general,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.switch_account_rounded, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Ganti Profil Pengguna',
                  style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Button: Keluar dari Akun (Logout)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFDE8E8),
              foregroundColor: const Color(0xFFBA1A1A),
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pop(context);
              onLogout();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.logout_rounded, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Keluar dari Akun (Logout)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Batal • Tetap Masuk
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal • Tetap Masuk',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.outline,
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Sync lock footer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 12, color: AppColors.outline),
              const SizedBox(width: 4),
              Text(
                'Tersinkronisasi otomatis dengan Cloud Sanctuary ID',
                style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.outline),
              ),
            ],
          ),
        ],
      ),
    ),
  ),
);
  }

  Widget _buildModeOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Icon(icon, size: 17, color: AppColors.primary),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.syne(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.plusJakartaSans(fontSize: 9, color: AppColors.onSurfaceVariant),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
