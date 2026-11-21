import 'package:flutter/material.dart';

class PrayerSchedule {
  final String name;
  final String time;
  final IconData statusIcon;
  final bool isPassed;
  final bool isActive;
  final bool isNext;

  const PrayerSchedule({
    required this.name,
    required this.time,
    required this.statusIcon,
    this.isPassed = false,
    this.isActive = false,
    this.isNext = false,
  });

  static List<PrayerSchedule> get sampleSchedule => const [
    PrayerSchedule(
      name: 'Subuh',
      time: '04:38',
      statusIcon: Icons.check_circle,
      isPassed: true,
    ),
    PrayerSchedule(
      name: 'Dzuhur',
      time: '11:52',
      statusIcon: Icons.check_circle,
      isPassed: true,
    ),
    PrayerSchedule(
      name: 'Ashar',
      time: '15:18',
      statusIcon: Icons.access_time_filled,
      isActive: true,
    ),
    PrayerSchedule(
      name: 'Maghrib',
      time: '17:58',
      statusIcon: Icons.notifications_active,
      isNext: true,
    ),
    PrayerSchedule(
      name: 'Isya',
      time: '19:09',
      statusIcon: Icons.hourglass_empty,
    ),
  ];
}
