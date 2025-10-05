class HijriDate {
  final int day;
  final int month;
  final int year;

  HijriDate(this.day, this.month, this.year);

  static const List<String> _monthNames = [
    "Muharram", "Safar", "Rabi'ul Awal", "Rabi'ul Akhir",
    "Jamadil Awal", "Jamadil Akhir", "Rejab", "Sya'ban",
    "Ramadan", "Syawal", "Zulkaedah", "Zulhijjah"
  ];

  String toFormat(String format) {
    if (format == "dd MMMM yyyy") {
      final monthName = _monthNames[month - 1];
      return "$day $monthName $year";
    }
    return "$day/$month/$year";
  }

  /// Algoritma ringkas (tabular) untuk penukaran Gregorian ke Hijri
  static HijriDate fromGregorian(DateTime date, {DateTime? maghribTime}) {
    DateTime gregorian = date;
    if (maghribTime != null && date.isAfter(maghribTime)) {
      // Jika sudah lepas maghrib, tambah 1 hari
      gregorian = date.add(const Duration(days: 1));
    }
    int day = gregorian.day;
    int month = gregorian.month;
    int year = gregorian.year;

    // Formula tabular (bukan Umm al-Qura, tapi cukup tepat untuk kegunaan umum)
    int jd = (gregorian.millisecondsSinceEpoch ~/ 86400000) + 2440588;
    int l = jd - 1948440 + 10632;
    int n = ((l - 1) / 10631).floor();
    l = l - 10631 * n + 354;
    int j = (((10985 - l) / 5316).floor()) * (((50 * l) / 17719).floor()) + ((l / 5670).floor()) * (((43 * l) / 15238).floor());
    l = l - (((30 - j) / 15).floor()) * (((17719 * j) / 50).floor()) - ((j / 16).floor()) * (((15238 * j) / 43).floor()) + 29;
    int m = (24 * l / 709).floor();
    int d = l - (709 * m / 24).floor();
    int y = 30 * n + j - 30;

    return HijriDate(d, m, y);
  }
}