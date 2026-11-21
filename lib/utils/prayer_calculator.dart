import 'package:flutter/material.dart';

class PrayerTimeEntry {
  final String name;
  final TimeOfDay time;
  final IconData icon;

  const PrayerTimeEntry({
    required this.name,
    required this.time,
    required this.icon,
  });

  String get formattedTime {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class PrayerStatus {
  final String activePrayerName;
  final String nextPrayerName;
  final String nextPrayerTime;
  final Duration remainingToNext;
  final List<PrayerScheduleItem> scheduleItems;

  const PrayerStatus({
    required this.activePrayerName,
    required this.nextPrayerName,
    required this.nextPrayerTime,
    required this.remainingToNext,
    required this.scheduleItems,
  });
}

class PrayerScheduleItem {
  final String name;
  final String time;
  final bool isPassed;
  final bool isActive;
  final bool isNext;
  final IconData statusIcon;

  const PrayerScheduleItem({
    required this.name,
    required this.time,
    required this.isPassed,
    required this.isActive,
    required this.isNext,
    required this.statusIcon,
  });
}

class RealPrayerService {
  // Standard daily prayer times for Jakarta / WIB (Waktu Indonesia Barat)
  static final List<PrayerTimeEntry> standardTimes = [
    const PrayerTimeEntry(name: 'Subuh', time: TimeOfDay(hour: 4, minute: 38), icon: Icons.wb_twilight),
    const PrayerTimeEntry(name: 'Syuruq', time: TimeOfDay(hour: 5, minute: 55), icon: Icons.wb_sunny_outlined),
    const PrayerTimeEntry(name: 'Dzuhur', time: TimeOfDay(hour: 11, minute: 52), icon: Icons.light_mode),
    const PrayerTimeEntry(name: 'Ashar', time: TimeOfDay(hour: 15, minute: 18), icon: Icons.wb_cloudy_outlined),
    const PrayerTimeEntry(name: 'Maghrib', time: TimeOfDay(hour: 17, minute: 58), icon: Icons.nights_stay_outlined),
    const PrayerTimeEntry(name: 'Isya', time: TimeOfDay(hour: 19, minute: 9), icon: Icons.dark_mode),
  ];

  static PrayerStatus calculateStatus(DateTime now) {
    // 5 primary prayers (Subuh, Dzuhur, Ashar, Maghrib, Isya)
    final fivePrayers = standardTimes.where((p) => p.name != 'Syuruq').toList();

    DateTime prayerDateTime(PrayerTimeEntry entry, {int dayOffset = 0}) {
      return DateTime(
        now.year,
        now.month,
        now.day + dayOffset,
        entry.time.hour,
        entry.time.minute,
      );
    }

    int activeIdx = -1;
    int nextIdx = -1;
    Duration remaining = Duration.zero;

    // Check where 'now' falls among the prayers
    final subuhToday = prayerDateTime(fivePrayers[0]);
    final dzuhurToday = prayerDateTime(fivePrayers[1]);
    final asharToday = prayerDateTime(fivePrayers[2]);
    final maghribToday = prayerDateTime(fivePrayers[3]);
    final isyaToday = prayerDateTime(fivePrayers[4]);

    if (now.isBefore(subuhToday)) {
      activeIdx = 4; // Still Isya of yesterday
      nextIdx = 0; // Next is Subuh today
      remaining = subuhToday.difference(now);
    } else if (now.isBefore(dzuhurToday)) {
      activeIdx = 0; // Subuh
      nextIdx = 1; // Dzuhur
      remaining = dzuhurToday.difference(now);
    } else if (now.isBefore(asharToday)) {
      activeIdx = 1; // Dzuhur
      nextIdx = 2; // Ashar
      remaining = asharToday.difference(now);
    } else if (now.isBefore(maghribToday)) {
      activeIdx = 2; // Ashar
      nextIdx = 3; // Maghrib
      remaining = maghribToday.difference(now);
    } else if (now.isBefore(isyaToday)) {
      activeIdx = 3; // Maghrib
      nextIdx = 4; // Isya
      remaining = isyaToday.difference(now);
    } else {
      activeIdx = 4; // Isya
      nextIdx = 0; // Next is Subuh tomorrow
      final subuhTomorrow = prayerDateTime(fivePrayers[0], dayOffset: 1);
      remaining = subuhTomorrow.difference(now);
    }

    if (remaining.isNegative) {
      remaining = Duration.zero;
    }

    final scheduleItems = <PrayerScheduleItem>[];
    for (int i = 0; i < fivePrayers.length; i++) {
      final p = fivePrayers[i];
      final pTime = prayerDateTime(p);
      final isPassed = now.isAfter(pTime);
      final isActive = i == activeIdx;
      final isNext = i == nextIdx;

      IconData icon;
      if (isActive) {
        icon = Icons.access_time_filled;
      } else if (isNext) {
        icon = Icons.notifications_active;
      } else if (isPassed) {
        icon = Icons.check_circle;
      } else {
        icon = Icons.hourglass_empty;
      }

      scheduleItems.add(PrayerScheduleItem(
        name: p.name,
        time: p.formattedTime,
        isPassed: isPassed && !isActive,
        isActive: isActive,
        isNext: isNext,
        statusIcon: icon,
      ));
    }

    final nextPrayer = fivePrayers[nextIdx];

    return PrayerStatus(
      activePrayerName: fivePrayers[activeIdx].name,
      nextPrayerName: nextPrayer.name,
      nextPrayerTime: nextPrayer.formattedTime,
      remainingToNext: remaining,
      scheduleItems: scheduleItems,
    );
  }

  static String formatClock(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  static String formatDuration(Duration d) {
    final dAbs = d.isNegative ? d.abs() : d;
    final h = dAbs.inHours.toString().padLeft(2, '0');
    final m = (dAbs.inMinutes % 60).toString().padLeft(2, '0');
    final s = (dAbs.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}
