import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/notification_item.dart';
import '../../theme/app_colors.dart';
import '../murottal/murottal_pemanasan_screen.dart';
import '../streaming/ruang_live_streaming_screen.dart';
import '../sedekah/jurnal_sedekah_screen.dart';
import '../masjid/rute_masjid_screen.dart';

class PusatNotifikasiScreen extends StatefulWidget {
  const PusatNotifikasiScreen({super.key});

  @override
  State<PusatNotifikasiScreen> createState() => _PusatNotifikasiScreenState();
}

class _PusatNotifikasiScreenState extends State<PusatNotifikasiScreen> {
  NotificationCategory _selectedCat = NotificationCategory.all;
  final List<NotificationItem> _items = List.from(NotificationItem.sampleList);

  void _markAllRead() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Semua notifikasi telah ditandai sudah dibaca.')),
    );
  }

  void _handleAction(String route) {
    if (route == 'murottal') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const MurottalPemanasanScreen()));
    } else if (route == 'streaming') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const RuangLiveStreamingScreen()));
    } else if (route == 'sedekah') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const JurnalSedekahScreen()));
    } else if (route == 'masjid') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const RuteMasjidScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _items.where((i) {
      if (_selectedCat == NotificationCategory.all) return true;
      return i.category == _selectedCat;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pusat Pengingat Ibadah',
          style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton.icon(
            onPressed: _markAllRead,
            icon: const Icon(Icons.done_all, size: 16),
            label: Text(
              'Tandai Semua',
              style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Narrative
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kabar & Waktu Ibadah',
                        style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Menjaga ketenangan batin dalam ritme hari dengan pengingat yang tertata.',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),

                // Category Pills (Horizontal Scroll)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    children: NotificationCategory.values.map((cat) {
                      final isSelected = cat == _selectedCat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          selected: isSelected,
                          avatar: Icon(
                            cat.icon,
                            size: 14,
                            color: isSelected ? Colors.white : AppColors.primary,
                          ),
                          label: Text(cat.label),
                          labelStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : AppColors.onSurface,
                          ),
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.surfaceContainerLow,
                          showCheckmark: false,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          onSelected: (v) {
                            if (v) setState(() => _selectedCat = cat);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10),

                // List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: filtered.length,
                    itemBuilder: (context, idx) {
                      final item = filtered[idx];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: AppColors.hairline),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withAlpha(8),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceContainerLow,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(item.category.icon, size: 16, color: AppColors.primary),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      item.category.label,
                                      style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.secondary),
                                    ),
                                  ],
                                ),
                                Text(
                                  item.time,
                                  style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.secondary),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.title,
                              style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.subtitle,
                              style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.onSurfaceVariant, height: 1.4),
                            ),
                            if (item.actionLabel != null && item.actionRoute != null) ...[
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton.icon(
                                  onPressed: () => _handleAction(item.actionRoute!),
                                  icon: const Icon(Icons.arrow_forward, size: 14),
                                  label: Text(item.actionLabel!),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.surfaceContainerLow,
                                    foregroundColor: AppColors.primary,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    textStyle: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
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
