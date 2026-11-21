import 'package:flutter/material.dart';

enum NotificationCategory {
  all,
  sholat,
  sunnah,
  kajian,
  system;

  String get label {
    switch (this) {
      case NotificationCategory.all:
        return 'Semua';
      case NotificationCategory.sholat:
        return 'Waktu Sholat';
      case NotificationCategory.sunnah:
        return 'Amalan Sunnah';
      case NotificationCategory.kajian:
        return 'Kajian & Live';
      case NotificationCategory.system:
        return 'Pemberitahuan Sistem';
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationCategory.all:
        return Icons.notifications;
      case NotificationCategory.sholat:
        return Icons.mosque;
      case NotificationCategory.sunnah:
        return Icons.spa;
      case NotificationCategory.kajian:
        return Icons.live_tv;
      case NotificationCategory.system:
        return Icons.tune;
    }
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final NotificationCategory category;
  final bool isRead;
  final String? actionLabel;
  final String? actionRoute;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.category,
    this.isRead = false,
    this.actionLabel,
    this.actionRoute,
  });

  static List<NotificationItem> get sampleList => [
    const NotificationItem(
      id: '1',
      title: 'Persiapan Menuju Dzuhur (11:52 WIB)',
      subtitle: 'Tersisa 11 menit. Murottal penyejuk kalbu telah siap diputar untuk menenangkan hati.',
      time: '11:41 WIB',
      category: NotificationCategory.sholat,
      actionLabel: 'Buka Murottal Pemanasan',
      actionRoute: 'murottal',
    ),
    const NotificationItem(
      id: '2',
      title: 'Live Majelis Nabawi Sedang Berlangsung',
      subtitle: 'Ustadz Dr. Firanda Andirja: "Bedah Tafsir Surah Ar-Rahman". 1.428 jamaah telah terhubung.',
      time: '10:00 WIB',
      category: NotificationCategory.kajian,
      actionLabel: 'Masuk Live Streaming',
      actionRoute: 'streaming',
    ),
    const NotificationItem(
      id: '3',
      title: 'Sedekah Subuh & Shalat Dhuha Hari Ini',
      subtitle: 'Alhamdulillah, kencleng subuh tercatat. Waktu utama Dhuha berlangsung hingga 11:35 WIB.',
      time: '06:30 WIB',
      category: NotificationCategory.sunnah,
      actionLabel: 'Buka Jurnal Sedekah',
      actionRoute: 'sedekah',
    ),
    const NotificationItem(
      id: '4',
      title: 'Masjid Terdekat Menyelenggarakan Jamaah',
      subtitle: 'Masjid Raya Al-Ikhlas (350m • 4 menit berjalan kaki). Saf ber-AC dan tempat wudhu luas.',
      time: 'Kemarin',
      category: NotificationCategory.sholat,
      actionLabel: 'Lihat Rute Masjid',
      actionRoute: 'masjid',
    ),
  ];
}
