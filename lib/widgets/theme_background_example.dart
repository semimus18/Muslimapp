// This is an example of how to use the ThemeBlurredBackgrounds with your PrayerDynamicBackground

// In your PrayerDynamicBackground widget, you can use it like this:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muslimapp/providers/prayer_provider.dart';
import 'package:muslimapp/themes/themes.dart';
import 'package:muslimapp/widgets/theme_blurred_backgrounds.dart';

/*
Example usage:

Widget _buildBackgroundForPeriod(PrayerPeriod period) {
  AppTheme theme;
  
  // Select theme based on prayer period
  switch (period) {
    case PrayerPeriod.isha:
      theme = AppThemes.isha;
      break;
    case PrayerPeriod.fajr:
      theme = AppThemes.fajr;
      break;
    case PrayerPeriod.dhuhr:
      theme = AppThemes.dhuhr;
      break;
    // ... other cases
  }
  
  return Stack(
    children: [
      // Theme-based blurred backgrounds
      ThemeBlurredBackgrounds(theme: theme),
      
      // Your additional effects for each period
      if (period == PrayerPeriod.isha)
        _buildNightSkyEffects(),
      else if (period == PrayerPeriod.fajr) 
        _buildDawnEffects(),
      // ... other custom effects
    ],
  );
}
*/

// Example component of how to use ThemeGradientBackground with child content
class PrayerBackgroundExample extends StatelessWidget {
  final Widget child;
  final AppTheme theme;
  
  const PrayerBackgroundExample({
    Key? key,
    required this.child,
    required this.theme,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ThemeGradientBackground(
      theme: theme,
      child: child,
    );
  }
}