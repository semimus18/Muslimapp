import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muslimapp/models/prayer_model.dart';

// Enum untuk jenis tema
enum ThemeType {
  auto, // Tema automatik berdasarkan waktu solat semasa
  fajr,
  dhuhr, 
  asr,
  maghrib,
  isha,
}

// Provider untuk jenis tema
final themeTypeProvider = StateProvider<ThemeType>((ref) {
  return ThemeType.auto; // Default: auto (ikut waktu solat semasa)
});

// Fungsi untuk mendapatkan nama tema
String getThemeTypeName(ThemeType type) {
  switch (type) {
    case ThemeType.auto:
      return 'Auto';
    case ThemeType.fajr:
      return 'Subuh';
    case ThemeType.dhuhr:
      return 'Zohor';
    case ThemeType.asr:
      return 'Asar';
    case ThemeType.maghrib:
      return 'Maghrib';
    case ThemeType.isha:
      return 'Isyak';
  }
}

// Fungsi untuk mendapatkan Prayer berdasarkan ThemeType
Prayer? getPrayerByThemeType(ThemeType type, List<Prayer> dailyPrayers) {
  if (dailyPrayers.isEmpty) {
    return null;
  }
  
  switch (type) {
    case ThemeType.auto:
      return null; // Akan guna current prayer
    case ThemeType.fajr:
      return dailyPrayers.firstWhere((p) => p.name == 'Fajr', orElse: () => dailyPrayers.first);
    case ThemeType.dhuhr:
      return dailyPrayers.firstWhere((p) => p.name == 'Dhuhr', orElse: () => dailyPrayers.first);
    case ThemeType.asr:
      return dailyPrayers.firstWhere((p) => p.name == 'Asr', orElse: () => dailyPrayers.first);
    case ThemeType.maghrib:
      return dailyPrayers.firstWhere((p) => p.name == 'Maghrib', orElse: () => dailyPrayers.first);
    case ThemeType.isha:
      return dailyPrayers.firstWhere((p) => p.name == 'Isha', orElse: () => dailyPrayers.first);
  }
}