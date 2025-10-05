import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muslimapp/widgets/prayer_dynamic_background.dart';

// Provider to manage the current test prayer period
final testPrayerPeriodProvider = StateProvider<PrayerPeriod?>((ref) => null);

// Helper method to get the next prayer period for testing
PrayerPeriod getNextPrayerPeriod(PrayerPeriod? current) {
  // If null, start with first prayer period
  if (current == null) {
    return PrayerPeriod.fajr;
  }
  
  // Get index of current period and calculate next
  final values = PrayerPeriod.values;
  final currentIndex = values.indexOf(current);
  final nextIndex = (currentIndex + 1) % values.length;
  
  return values[nextIndex];
}

// Get a readable name for the prayer period
String getPrayerPeriodName(PrayerPeriod period) {
  switch (period) {
    case PrayerPeriod.fajr:
      return 'Fajr (Dawn)';
    case PrayerPeriod.sunrise:
      return 'Syuruk (Sunrise)';
    case PrayerPeriod.dhuha:
      return 'Dhuha (Morning)';
    case PrayerPeriod.dhuhr:
      return 'Dhuhr (Noon)';
    case PrayerPeriod.asr:
      return 'Asr (Afternoon)';
    case PrayerPeriod.maghrib:
      return 'Maghrib (Sunset)';
    case PrayerPeriod.isha:
      return 'Isha (Night)';
    case PrayerPeriod.imsak:
      return 'Imsak (Pre-Dawn)';
  }
}