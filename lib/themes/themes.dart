import 'package:flutter/material.dart';

// Legacy AppTheme class for backward compatibility
class AppTheme {
  final List<Color> backgroundGradient;
  final Color textColor;

  const AppTheme({
    required this.backgroundGradient,
    required this.textColor,
  });
  
  // Helper method to convert from PrayerTheme
  factory AppTheme.fromPrayerTheme(PrayerTheme prayerTheme) {
    return AppTheme(
      backgroundGradient: prayerTheme.background,
      textColor: prayerTheme.text,
    );
  }
}

// New enhanced PrayerTheme with more styling options
class PrayerTheme {
  final String name;
  final List<Color> background;
  final List<Color> cardBg;
  final List<Color> accent;
  final List<Color> secondary;
  final Color text;
  final Color subtext;
  final String icon;

  const PrayerTheme({
    required this.name,
    required this.background,
    required this.cardBg,
    required this.accent,
    required this.secondary,
    required this.text,
    required this.subtext,
    required this.icon,
  });
}

// Map of prayer themes by prayer name key
const Map<String, PrayerTheme> prayerThemes = {
  'imsak': PrayerTheme(
    name: 'Pre-Dawn',
    background: [Color(0xFF312E81), Color(0xFF581C87), Color(0xFF0F172A)], // indigo-900, purple-900, slate-900
    cardBg: [Color(0xFF1E293B), Color(0xFF3730A3)], // slate-800/90, indigo-800/80
    accent: [Color(0xFF818CF8), Color(0xFFA21CAF)], // indigo-400, purple-500
    secondary: [Color(0xFF8B5CF6), Color(0xFFA21CAF)], // violet-400, purple-400
    text: Colors.white,
    subtext: Color(0xFFC7D2FE), // indigo-200
    icon: '🌌',
  ),
  'fajr': PrayerTheme(
    name: 'Dawn',
    background: [Color(0xFFFFEDD5), Color(0xFFFBCFE8), Color(0xFFF3E8FF)], // orange-100, pink-100, purple-100
    cardBg: [Color(0xFFFDFDFD), Color(0xFFFFF7ED)], // white/95, orange-50/80
    accent: [Color(0xFFF59E42), Color(0xFFF472B6)], // orange-500, pink-500
    secondary: [Color(0xFFF472B6), Color(0xFFF43F5E)], // pink-400, rose-500
    text: Color(0xFF7C2D12), // orange-900
    subtext: Color(0xFF9A3412), // orange-700
    icon: '🌅',
  ),
  'syuruk': PrayerTheme(
    name: 'Sunrise',
    background: [Color(0xFFFFFBEB), Color(0xFFFFF7ED), Color(0xFFFEF3C7)], // yellow-50, orange-50, amber-100
    cardBg: [Color(0xFFFDFDFD), Color(0xFFFFFBEB)], // white/95, yellow-50/80
    accent: [Color(0xFFF59E42), Color(0xFFF59E42)], // yellow-500, orange-500
    secondary: [Color(0xFFFBBF24), Color(0xFFF59E42)], // amber-400, orange-500
    text: Color(0xFF78350F), // yellow-900
    subtext: Color(0xFFB45309), // yellow-700
    icon: '🌄',
  ),
  'dhuha': PrayerTheme(
    name: 'Morning',
    background: [Color(0xFFFEF3C7), Color(0xFFFFFBEB), Color(0xFFFFEDD5)], // amber-50, yellow-50, orange-50
    cardBg: [Color(0xFFFDFDFD), Color(0xFFFEF3C7)], // white/95, amber-50/80
    accent: [Color(0xFFFBBF24), Color(0xFFF59E42)], // amber-500, yellow-500
    secondary: [Color(0xFFF87171), Color(0xFFEF4444)], // red-400, red-500
    text: Color(0xFF78350F), // amber-900
    subtext: Color(0xFFB45309), // amber-700
    icon: '🌞',
  ),
  'dhuhr': PrayerTheme(
    name: 'Noon',
    background: [Color(0xFFF0F9FF), Color(0xFFDBEAFE), Color(0xFFECFEFF)], // sky-50, blue-50, cyan-50
    cardBg: [Color(0xFFFDFDFD), Color(0xFFF0F9FF)], // white/95, sky-50/80
    accent: [Color(0xFF0EA5E9), Color(0xFF3B82F6)], // sky-500, blue-500
    secondary: [Color(0xFF60A5FA), Color(0xFF06B6D4)], // blue-400, cyan-500
    text: Color(0xFF0C4A6E), // sky-900
    subtext: Color(0xFF0369A1), // sky-700
    icon: '☀️',
  ),
  'asr': PrayerTheme(
    name: 'Afternoon',
    background: [Color(0xFFFFF7ED), Color(0xFFFEF3C7), Color(0xFFFFFBEB)], // orange-50, amber-50, yellow-50
    cardBg: [Color(0xFFFDFDFD), Color(0xFFFFF7ED)], // white/95, orange-50/80
    accent: [Color(0xFFF59E42), Color(0xFFFBBF24)], // orange-500, amber-500
    secondary: [Color(0xFFFBBF24), Color(0xFFFDE68A)], // amber-400, yellow-500
    text: Color(0xFF7C2D12), // orange-900
    subtext: Color(0xFF9A3412), // orange-700
    icon: '🌤️',
  ),
  'maghrib': PrayerTheme(
    name: 'Sunset',
    background: [Color(0xFFFFE4E6), Color(0xFFFFEDD5), Color(0xFFF3E8FF)], // rose-100, orange-100, pink-100
    cardBg: [Color(0xFFFDFDFD), Color(0xFFFFF1F9)], // white/95, rose-50/80
    accent: [Color(0xFFF43F5E), Color(0xFFF59E42)], // rose-500, orange-500
    secondary: [Color(0xFFF472B6), Color(0xFFF43F5E)], // pink-400, rose-500
    text: Color(0xFF881337), // rose-900
    subtext: Color(0xFFBE185D), // rose-700
    icon: '🌆',
  ),
  'isha': PrayerTheme(
    name: 'Night',
    background: [Color(0xFF1E293B), Color(0xFF1E40AF), Color(0xFF312E81)], // slate-800, blue-900, indigo-900
    cardBg: [Color(0xFF1E293B), Color(0xFF1E3A8A)], // slate-800/90, blue-800/80
    accent: [Color(0xFF60A5FA), Color(0xFF6366F1)], // blue-400, indigo-500
    secondary: [Color(0xFF818CF8), Color(0xFFA21CAF)], // indigo-400, purple-500
    text: Colors.white,
    subtext: Color(0xFFBFDBFE), // blue-200
    icon: '🌙',
  ),
};

// Class for backward compatibility with existing code
class AppThemes {
  // Map prayer themes to AppTheme for backward compatibility
  static AppTheme get fajr => AppTheme.fromPrayerTheme(prayerThemes['fajr']!);
  static AppTheme get morning => AppTheme.fromPrayerTheme(prayerThemes['dhuha']!);
  static AppTheme get dhuhr => AppTheme.fromPrayerTheme(prayerThemes['dhuhr']!);
  static AppTheme get asr => AppTheme.fromPrayerTheme(prayerThemes['asr']!);
  static AppTheme get maghrib => AppTheme.fromPrayerTheme(prayerThemes['maghrib']!);
  static AppTheme get isha => AppTheme.fromPrayerTheme(prayerThemes['isha']!);
  static AppTheme get night => AppTheme.fromPrayerTheme(prayerThemes['isha']!); // Reuse isha for night
  
  // Default background theme
  static const AppTheme bground = AppTheme(
    backgroundGradient: [Color.fromARGB(255, 204, 237, 241), Color.fromARGB(255, 243, 231, 245)],
    textColor: Color(0xFFDBEAFE),
  );
}