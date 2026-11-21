class SedekahRecord {
  final String id;
  final String category;
  final int amount;
  final DateTime date;
  final String time;
  final String note;
  final bool isVerified;

  const SedekahRecord({
    required this.id,
    required this.category,
    required this.amount,
    required this.date,
    required this.time,
    required this.note,
    this.isVerified = true,
  });

  static List<SedekahRecord> get sampleRecords => [
    SedekahRecord(
      id: '1',
      category: 'Kencleng Subuh Rumahan',
      amount: 25000,
      date: DateTime.now(),
      time: '05:15 WIB',
      note: 'Niat ikhlas lillahi ta\'ala untuk keberkahan keluarga',
      isVerified: true,
    ),
    SedekahRecord(
      id: '2',
      category: 'Bantuan Yatim / Dhuafa',
      amount: 50000,
      date: DateTime.now().subtract(const Duration(days: 1)),
      time: '05:22 WIB',
      note: 'Paket sarapan dhuafa sekitar lingkungan',
      isVerified: true,
    ),
    SedekahRecord(
      id: '3',
      category: 'Infaq Masjid',
      amount: 20000,
      date: DateTime.now().subtract(const Duration(days: 2)),
      time: '05:08 WIB',
      note: 'Infaq kotak amal subuh Masjid Al-Ikhlas',
      isVerified: true,
    ),
  ];
}
