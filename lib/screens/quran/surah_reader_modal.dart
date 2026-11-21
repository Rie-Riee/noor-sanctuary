import 'package:flutter/material.dart';
import '../../data/quran_dataset.dart';
import 'mushaf_reader_screen.dart';

void showSurahReaderModal(BuildContext context, SurahModel surah) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => MushafReaderScreen(surah: surah),
    ),
  );
}
