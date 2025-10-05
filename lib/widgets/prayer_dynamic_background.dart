import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muslimapp/models/prayer_model.dart';
import 'package:muslimapp/providers/prayer_provider.dart';
// import 'package:muslimapp/services/prayer_service.dart'; // Removed unused import
import 'package:muslimapp/themes/themes.dart';
import 'package:muslimapp/widgets/theme_blurred_backgrounds.dart';

enum PrayerPeriod {
  fajr,
  sunrise,  // maps to syuruk
  dhuha,    // new
  dhuhr,
  asr,
  maghrib,
  isha,
  imsak,    // new
}

class PrayerDynamicBackground extends ConsumerWidget {
  const PrayerDynamicBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyPrayersAsync = ref.watch(prayerDataProvider);
    
    return dailyPrayersAsync.when(
      data: (prayerData) {
        // Determine prayer period based on current time
        final PrayerPeriod currentPrayerPeriod = _getCurrentPrayerPeriod(prayerData.dailyPrayers);
        
        // Get the prayer theme for the current prayer period
        final String themeKey = _getPrayerThemeKey(currentPrayerPeriod);
        final prayerTheme = prayerThemes[themeKey]!;
        
        // Also get the legacy theme for backward compatibility
        final legacyTheme = _getThemeForPeriod(currentPrayerPeriod);
        
        // Stack with gradient background and blurred elements
        return Stack(
          fit: StackFit.expand,
          children: [
            // Base gradient background with new theme colors
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: prayerTheme.background,
                ),
              ),
            ),
            
            // Blurred background circles
            ThemeBlurredBackgrounds(
              theme: legacyTheme,
              prayerTheme: prayerTheme, // Pass the new theme too
            ),
            
            // Child content
            child,
          ],
        );
      },
      loading: () => child,
      error: (_, __) => child,
    );
  }

  // Helper method to get the theme key for a prayer period
  String _getPrayerThemeKey(PrayerPeriod period) {
    switch (period) {
      case PrayerPeriod.fajr:
        return 'fajr';
      case PrayerPeriod.sunrise:
        return 'syuruk'; // Map to syuruk theme
      case PrayerPeriod.dhuha:
        return 'dhuha';
      case PrayerPeriod.dhuhr:
        return 'dhuhr';
      case PrayerPeriod.asr:
        return 'asr';
      case PrayerPeriod.maghrib:
        return 'maghrib';
      case PrayerPeriod.isha:
        return 'isha';
      case PrayerPeriod.imsak:
        return 'imsak';
    }
  }

  // Helper method to get the theme for prayer period
  AppTheme _getThemeForPeriod(PrayerPeriod period) {
    // Get the theme key and convert to AppTheme for backward compatibility
    final themeKey = _getPrayerThemeKey(period);
    return AppTheme.fromPrayerTheme(prayerThemes[themeKey]!);
  }
  
  // Active implementation to dynamically determine the prayer period
  PrayerPeriod _getCurrentPrayerPeriod(List<Prayer> prayers) {
      try {
      final now = DateTime.now();
      final currentTime = now.hour * 60 + now.minute;  // Convert to minutes since midnight

      // Extract prayer times
      final fajrTime = _convertTimeOfDayToMinutes(prayers[0].time);
      final sunriseTime = fajrTime + 60; // Approximate sunrise as 1 hour after Fajr
      final dhuhaTime = sunriseTime + 60; // Approximate dhuha as 1 hour after sunrise
      // Prayer times in minutes since midnight for conditional checks
      final dhuhrMinutes = _convertTimeOfDayToMinutes(prayers[1].time);
      final asrMinutes = _convertTimeOfDayToMinutes(prayers[2].time);
      final maghribMinutes = _convertTimeOfDayToMinutes(prayers[3].time);
      final ishaMinutes = _convertTimeOfDayToMinutes(prayers[4].time);
      final imsakTime = fajrTime - 10; // Imsak is usually 10 minutes before fajr      // No need for TimeOfDay conversion anymore, using minutes directly

      // Determine the current period
      if (currentTime >= imsakTime && currentTime < fajrTime) {
        return PrayerPeriod.imsak;
      } else if (currentTime >= fajrTime && currentTime < sunriseTime) {
        return PrayerPeriod.fajr;
      } else if (currentTime >= sunriseTime && currentTime < dhuhaTime) {
        return PrayerPeriod.sunrise;
      } else if (currentTime >= dhuhaTime && currentTime < dhuhrMinutes) {
        return PrayerPeriod.dhuha;
      } else if (currentTime >= dhuhrMinutes && currentTime < asrMinutes) {
        return PrayerPeriod.dhuhr;
      } else if (currentTime >= asrMinutes && currentTime < maghribMinutes) {
        return PrayerPeriod.asr;
      } else if (currentTime >= maghribMinutes && currentTime < ishaMinutes) {
        return PrayerPeriod.maghrib;
      } else {
        return PrayerPeriod.isha;
      }
    } catch (e) {
      return PrayerPeriod.dhuhr; // Default to dhuhr if there's an error
    }
  }

  int _convertTimeOfDayToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  // _isTimeBetween function removed since we're using direct minute comparisons
  
  // Removed _getPrayerPeriodFromThemeType - not needed anymore
}

// You can add more complex background effects after confirming the basic implementation works
// For now, keeping it simple with just gradient backgrounds