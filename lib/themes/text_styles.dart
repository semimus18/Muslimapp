import 'package:flutter/material.dart';
import 'themes.dart';

class AppTextStyles {
  static TextStyle h1(BuildContext context, PrayerTheme theme) => TextStyle(
        fontSize: _getFontSize(context, 24),
        fontWeight: FontWeight.bold,
        color: theme.text,
        height: 1.3,
      );

  static TextStyle h2(BuildContext context, PrayerTheme theme) => TextStyle(
        fontSize: _getFontSize(context, 20),
        fontWeight: FontWeight.w600,
        color: theme.text,
        height: 1.3,
      );

  static TextStyle body(BuildContext context, PrayerTheme theme) => TextStyle(
        fontSize: _getFontSize(context, 16),
        fontWeight: FontWeight.normal,
        color: theme.text,
        height: 1.5,
      );

  static TextStyle subtitle(BuildContext context, PrayerTheme theme) => TextStyle(
        fontSize: _getFontSize(context, 14),
        fontWeight: FontWeight.w400,
        color: theme.subtext,
        height: 1.4,
      );

  static TextStyle caption(BuildContext context, PrayerTheme theme) => TextStyle(
        fontSize: _getFontSize(context, 12),
        fontWeight: FontWeight.w300,
        color: theme.subtext,
      );

  static TextStyle small(BuildContext context, PrayerTheme theme) => TextStyle(
    fontSize: _getFontSize(context, 10),
    fontWeight: FontWeight.w300,
    color: theme.subtext,
  );

  static TextStyle button(BuildContext context, PrayerTheme theme) => TextStyle(
        fontSize: _getFontSize(context, 16),
        fontWeight: FontWeight.w600,
        color: theme.text,
      );

  // Responsive size helper
  static double _getFontSize(BuildContext context, double baseSize) {
    double width = MediaQuery.of(context).size.width;
    if (width < 360) return baseSize - 2;
    if (width > 411) return baseSize + 2;
    return baseSize;
  }
}

class AppIconSizes {
  static double of(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 360) return 16;  // small phones
    if (width < 480) return 20;  // medium
    return 24;                   // tablets / large
  }

  static double small(BuildContext context) => of(context) * 0.8;
  static double normal(BuildContext context) => of(context);
  static double large(BuildContext context) => of(context) * 1.2;
  
}

class AppImageSizes {
  static double baseSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 360) return 48;     // small phones
    if (width < 480) return 64;     // medium phones
    return 80;                      // tablets / large phones
  }

  static double small(BuildContext context) => baseSize(context) * 0.75;
  static double normal(BuildContext context) => baseSize(context);
  static double large(BuildContext context) => baseSize(context) * 1.25;
  static double xlarge(BuildContext context) => baseSize(context) * 2.00;
}
