import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum SanctuaryMode {
  general,
  sisterhood,
  kids;

  String get title {
    switch (this) {
      case SanctuaryMode.general:
        return 'General Sanctuary';
      case SanctuaryMode.sisterhood:
        return 'Sisterhood Sanctuary';
      case SanctuaryMode.kids:
        return 'Kids Sanctuary';
    }
  }

  String get badge {
    switch (this) {
      case SanctuaryMode.general:
        return 'Universal';
      case SanctuaryMode.sisterhood:
        return 'Muslimah';
      case SanctuaryMode.kids:
        return 'Ceria & Aman';
    }
  }

  String get description {
    switch (this) {
      case SanctuaryMode.general:
        return 'Jadwal sholat presisi, mushaf tadabbur harian, dzikir pagi-petang, serta sunnah harian bagi seluruh keluarga.';
      case SanctuaryMode.sisterhood:
        return 'Fiqih wanita terpercaya, kalkulator siklus thaharah & haidh otomatis, serta lingkaran halaqah tilawah ukhuwah.';
      case SanctuaryMode.kids:
        return 'Belajar Hijaiyah interaktif bersuara, kisah 25 Nabi ilustratif, celengan pahala berhadiah bintang, & proteksi PIN orang tua.';
    }
  }

  String get buttonLabel {
    switch (this) {
      case SanctuaryMode.general:
        return 'Mulai Bersama General Sanctuary';
      case SanctuaryMode.sisterhood:
        return 'Masuk ke Sisterhood Sanctuary';
      case SanctuaryMode.kids:
        return 'Buka Ruang Ceria Kids Sanctuary';
    }
  }

  IconData get icon {
    switch (this) {
      case SanctuaryMode.general:
        return Icons.eco;
      case SanctuaryMode.sisterhood:
        return Icons.local_florist;
      case SanctuaryMode.kids:
        return Icons.stars;
    }
  }

  Color get accentBg {
    switch (this) {
      case SanctuaryMode.general:
        return AppColors.secondaryFixed;
      case SanctuaryMode.sisterhood:
        return AppColors.primaryFixed;
      case SanctuaryMode.kids:
        return AppColors.tertiaryFixed;
    }
  }

  List<String> get features {
    switch (this) {
      case SanctuaryMode.general:
        return ['Adzan Sunnah', 'Mushaf 30 Juz'];
      case SanctuaryMode.sisterhood:
        return ['Siklus Suci', 'Halaqah Online'];
      case SanctuaryMode.kids:
        return ['Belajar Huruf', 'Parent PIN'];
    }
  }

  String get accountName {
    switch (this) {
      case SanctuaryMode.general:
        return 'Keluarga Rayyan';
      case SanctuaryMode.sisterhood:
        return 'Ummu Rayyan';
      case SanctuaryMode.kids:
        return 'Ahmad Rayyan';
    }
  }

  String get accountRole {
    switch (this) {
      case SanctuaryMode.general:
        return 'Akun Utama Keluarga';
      case SanctuaryMode.sisterhood:
        return 'Muslimah Aktif';
      case SanctuaryMode.kids:
        return 'Santri Cilik (Anak)';
    }
  }

  String get accountEmail {
    switch (this) {
      case SanctuaryMode.general:
        return 'keluarga.rayyan@sanctuary.id';
      case SanctuaryMode.sisterhood:
        return 'aisyah.iman@sanctuary.id';
      case SanctuaryMode.kids:
        return 'ahmad.rayyan@sanctuary.id';
    }
  }

  IconData get accountIcon {
    switch (this) {
      case SanctuaryMode.general:
        return Icons.people_alt_rounded;
      case SanctuaryMode.sisterhood:
        return Icons.spa_rounded;
      case SanctuaryMode.kids:
        return Icons.face_rounded;
    }
  }

  Color get accountColor {
    switch (this) {
      case SanctuaryMode.general:
        return AppColors.primary;
      case SanctuaryMode.sisterhood:
        return AppColors.primary;
      case SanctuaryMode.kids:
        return Colors.green;
    }
  }
}
