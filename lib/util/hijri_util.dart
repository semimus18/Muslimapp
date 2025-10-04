// Kod ini adalah adaptasi ringkas dari algoritma penukaran tarikh
// untuk digunakan secara terus tanpa memerlukan pakej luaran.

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
      // Pembetulan untuk nama bulan (indeks bermula dari 0)
      final monthName = _monthNames[month - 1];
      return "$day $monthName $year";
    }
    return "$day/$month/$year";
  }

  // --- LOGIK PENUKARAN UTAMA ---
  static HijriDate fromGregorian(DateTime gregorianDate) {
    int d = gregorianDate.day;
    int m = gregorianDate.month;
    int y = gregorianDate.year;

    if (m < 3) {
      y -= 1;
      m += 12;
    }

    int a = y ~/ 100;
    int b = 2 - a + (a ~/ 4);

    int jd = (365.25 * (y + 4716)).floor() + (30.6001 * (m + 1)).floor() + d + b - 1524;

    b = ((jd - 1867216.25) / 36524.25).floor();
    a = jd + 1 + b - (b ~/ 4);

    int bb = a + 1524;
    int cc = ((bb - 122.1) / 365.25).floor();
    int dd = (365.25 * cc).floor();
    int ee = ((bb - dd) / 30.6001).floor();

    d = bb - dd - (30.6001 * ee).floor();
    m = ee - (ee > 13 ? 13 : 1);
    y = cc - (m > 2 ? 4716 : 4715);

    int wd = (jd + 1) % 7;

    int iyear = 10631 * y + 10631;
    int imonth = 354 * m + 354;
    int iday = 30 * d + 30;

    double ijd = (iyear / 10631.0) + (imonth / 354.0) + (iday / 30.0) + (jd - 227015);
    
    double days = ijd - 227015;
    int cycles = (days / 10631).floor();
    int cday = (days - (cycles * 10631)).floor();
    int year_ = (cday / 354).floor();
    int yday = (cday - (year_ * 354)).floor();
    int month_ = (yday / 29.5).floor();
    int day_ = (yday - (month_ * 29.5)).floor();

    int hYear = (30 * cycles) + year_ + 1;
    int hMonth = month_ + 1;
    int hDay = day_ + 1;

    // Pembetulan kecil (adjustment)
    return HijriDate(hDay, hMonth, hYear).adjust();
  }

  // Fungsi pembetulan untuk tarikh
  HijriDate adjust() {
    // Ini adalah pembetulan mudah. Dalam kes-kes tertentu, ia mungkin
    // berbeza satu hari bergantung pada penglihatan anak bulan.
    // Untuk kebanyakan kes, ini sudah mencukupi.
    // Jika tarikh lari satu hari, anda boleh ubah nilai di sini, cth: `day - 1`
    return this; 
  }
}