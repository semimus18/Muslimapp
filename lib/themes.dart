import 'package:flutter/material.dart';

// Ini adalah 'blueprint' untuk setiap tema.
// Setiap tema MESTI ada warna latar belakang dan warna teks.
class AppTheme {
  final List<Color> backgroundGradient;
  final Color textColor;

  const AppTheme({
    required this.backgroundGradient,
    required this.textColor,
  });
}

// Ini adalah kelas statik yang memegang semua definisi tema kita.
// Ia seperti objek 'AppThemes' dalam kod React anda.
class AppThemes {
  static const AppTheme fajr = AppTheme(
    backgroundGradient: [Color(0xFF818CF8), Color(0xFFC4B5FD)], // indigo-400, violet-300
    textColor: Color(0xFF312E81), // indigo-900
  );

  static const AppTheme morning = AppTheme(
    backgroundGradient: [Color(0xFF67E8F9), Color(0xFFF0ABFC)], // cyan-300, fuchsia-300
    textColor: Color(0xFF0E7490), // cyan-800
  );

  static const AppTheme dhuhr = AppTheme(
    backgroundGradient: [Color(0xFF38BDF8), Color(0xFF67E8F9)], // lightBlue-400, cyan-300
    textColor: Color(0xFF0369A1), // lightBlue-800
  );

  static const AppTheme asr = AppTheme(
    backgroundGradient: [Color(0xFFFBBF24), Color(0xFFF87171)], // amber-400, red-400
    textColor: Color(0xFFB45309), // amber-700
  );

  static const AppTheme maghrib = AppTheme(
    backgroundGradient: [Color(0xFFF97316), Color(0xFFF43F5E)], // orange-500, rose-500
    textColor: Color(0xFF9A3412), // orange-800
  );

  static const AppTheme isha = AppTheme(
    backgroundGradient: [Color(0xFF1E3A8A), Color(0xFF4338CA)], // blue-900, indigo-700
    textColor: Color(0xFFDBEAFE), // blue-100
  );

  // Tema 'default' untuk waktu malam
  static const AppTheme night = AppTheme(
    backgroundGradient: [Color(0xFF1E3A8A), Color(0xFF4338CA)],
    textColor: Color(0xFFDBEAFE),
  );
}