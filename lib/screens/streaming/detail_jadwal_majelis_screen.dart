import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import 'ruang_live_streaming_screen.dart';

class DetailJadwalMajelisScreen extends StatefulWidget {
  const DetailJadwalMajelisScreen({super.key});

  @override
  State<DetailJadwalMajelisScreen> createState() => _DetailJadwalMajelisScreenState();
}

class _DetailJadwalMajelisScreenState extends State<DetailJadwalMajelisScreen> {
  bool _calendarSynced = false;
  bool _reminder15Min = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 850;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: (isDesktop && !Navigator.canPop(context))
          ? null
          : AppBar(
              leading: Navigator.canPop(context)
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    )
                  : null,
              title: Text(
                'Detail Jadwal Majelis',
                style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tautan kajian berhasil disalin ke clipboard!')),
                    );
                  },
                ),
              ],
            ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 1240 : 620),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                isDesktop ? 36 : 20,
                isDesktop ? 24 : 16,
                isDesktop ? 36 : 20,
                isDesktop ? 40 : 130, // 130px prevents mobile floating dock overlap
              ),
              child: isDesktop
                  // DESKTOP RESPONSIVE 2-COLUMN VIEW
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column (flex: 55): Hero Banner & CTA
                        Expanded(
                          flex: 55,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildHeroBanner(),
                              const SizedBox(height: 20),
                              _buildEnterStreamCTA(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Right Column (flex: 45): Speaker Info, Ticket & Sync Settings
                        Expanded(
                          flex: 45,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSpeakerCard(),
                              const SizedBox(height: 14),
                              _buildVirtualTicket(),
                              const SizedBox(height: 20),
                              Text(
                                'Pengingat & Berkas Kajian',
                                style: GoogleFonts.notoSerif(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
                              ),
                              const SizedBox(height: 12),
                              _buildCalendarSyncTile(),
                              _buildReminderTile(),
                              _buildDiktatDownloadCard(),
                            ],
                          ),
                        ),
                      ],
                    )
                  // MOBILE SINGLE COLUMN FLOW
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeroBanner(),
                        const SizedBox(height: 20),
                        _buildSpeakerCard(),
                        const SizedBox(height: 14),
                        _buildVirtualTicket(),
                        const SizedBox(height: 22),
                        Text(
                          'Pengingat & Berkas Kajian',
                          style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.onSurface),
                        ),
                        const SizedBox(height: 12),
                        _buildCalendarSyncTile(),
                        _buildReminderTile(),
                        _buildDiktatDownloadCard(),
                        const SizedBox(height: 28),
                        _buildEnterStreamCTA(),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      height: 230,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryContainer,
            AppColors.primary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(30),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative Arch Overlay
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.mosque,
              size: 160,
              color: Colors.white.withAlpha(20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(220),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'STREAMING RESMI MASJID NABAWI',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer.withAlpha(200),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '20:00 WIB',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tafsir Surah Ar-Rahman',
                      style: GoogleFonts.notoSerif(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Merengkuh Kasih Sayang Ilahi di Tengah Badai Hidup',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: Colors.white.withAlpha(220),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Countdown Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(230),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.schedule, size: 16, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            'Mulai dalam 07j : 15m : 40d',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeakerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primaryContainer,
            child: const Icon(Icons.school, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ustadz Dr. Firanda Andirja, Lc., M.A.',
                  style: GoogleFonts.notoSerif(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                ),
                Text(
                  'Kurator Majelis Ilmu Nabawi',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const Icon(Icons.verified, color: AppColors.primary, size: 22),
        ],
      ),
    );
  }

  Widget _buildVirtualTicket() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.tertiaryFixed,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.confirmation_number, size: 18, color: AppColors.onTertiaryFixed),
              const SizedBox(width: 8),
              Text(
                'Akses Terdaftar Bebas Biaya',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onTertiaryFixed,
                ),
              ),
            ],
          ),
          Text(
            'Tautan Siap',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.onTertiaryFixed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSyncTile() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.secondaryFixed,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.event_available, color: AppColors.onSecondaryFixed, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sinkronisasi Kalender Ponsel',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Tersimpan di Google / Apple Calendar',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                ),
              ],
            ),
          ),
          Switch(
            value: _calendarSynced,
            activeTrackColor: AppColors.primary,
            onChanged: (v) => setState(() => _calendarSynced = v),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderTile() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.primaryFixed,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_active, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifikasi 15 Menit Sebelum',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Kirim alarm & peringatan adab',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Switch(
            value: _reminder15Min,
            activeTrackColor: AppColors.primary,
            onChanged: (v) => setState(() => _reminder15Min = v),
          ),
        ],
      ),
    );
  }

  Widget _buildDiktatDownloadCard() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mengunduh Diktat PDF Surah Ar-Rahman (4.2 MB)...')),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.hairline),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.download_for_offline, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lembar Diktat & Ringkasan PDF',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Bahan telaah mandiri • 4.2 MB',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.secondary),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.secondary),
          ],
        ),
      ),
    );
  }

  Widget _buildEnterStreamCTA() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RuangLiveStreamingScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.live_tv, size: 20),
            const SizedBox(width: 10),
            Text(
              'Masuk Ruang Siaran Langsung',
              style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
