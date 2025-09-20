import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'prayer_model.dart';

class PrayerData {
  final String location;
  final List<Prayer> dailyPrayers;

  PrayerData({required this.location, required this.dailyPrayers});
}

Color _colorFromHex(String hexColor) {
  hexColor = hexColor.replaceAll("#", "");
  return Color(int.parse('FF$hexColor', radix: 16));
}

TimeOfDay _timeFromString(String timeStr) {
  final parts = timeStr.split(':');
  return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
}

Future<PrayerData> loadPrayerTimes({required String zoneCode}) async {
  final url = Uri.parse('https://www.e-solat.gov.my/index.php?r=esolatApi/takwimsolat&zone=$zoneCode&period=today');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] != 'OK!') {
        throw Exception('API mengembalikan status tidak OK: ${jsonResponse['status']}');
      }

      final List<dynamic> prayerTimesList = jsonResponse['prayerTime'];
      final String location = "Zon: ${jsonResponse['zone']}";

      if (prayerTimesList.isEmpty) {
        throw Exception('Senarai waktu solat dari API adalah kosong.');
      }
      
      final Map<String, dynamic> todayData = prayerTimesList[0];

      // KOD YANG DIPERBETULKAN DAN DISAHKAN
      final List<Map<String, dynamic>> prayerInfo = [
        {'name': 'Fajr', 'key': 'fajr', 'icon': '🌅', 'colors': ["#818CF8", "#A78BFA", "#F472B6"]},
        {'name': 'Dhuhr', 'key': 'dhuhr', 'icon': '☀️', 'colors': ["#FBBF24", "#F97316", "#EF4444"]},
        {'name': 'Asr', 'key': 'asr', 'icon': '🌤️', 'colors': ["#F59E0B", "#EAB308", "#F97316"]},
        {'name': 'Maghrib', 'key': 'maghrib', 'icon': '🌇', 'colors': ["#F97316", "#EF4444", "#EC4899"]},
        {'name': 'Isha', 'key': 'isha', 'icon': '🌙', 'colors': ["#3B82F6", "#6366F1", "#8B5CF6"]},
      ];

      final List<Prayer> dailyPrayers = prayerInfo.map((p) {
        final prayerKey = p['key'] as String;
        return Prayer(
          name: p['name'] as String,
          time: _timeFromString(todayData[prayerKey]),
          icon: p['icon'] as String,
          colors: (p['colors'] as List<String>).map((hex) => _colorFromHex(hex)).toList(),
        );
      }).toList();

      return PrayerData(location: location, dailyPrayers: dailyPrayers);

    } else {
      throw Exception('Gagal memuatkan waktu solat. Kod Status: ${response.statusCode}');
    }
  } catch (e) {
    // Tambah lebih perincian pada ralat untuk penyahpepijatan
    throw Exception('Gagal menyambung atau memproses data: $e');
  }
}

Prayer getNextPrayer(TimeOfDay currentTime, List<Prayer> dailyPrayers) {
  for (final prayer in dailyPrayers) {
    final prayerTotalMinutes = prayer.time.hour * 60 + prayer.time.minute;
    final currentTotalMinutes = currentTime.hour * 60 + currentTime.minute;

    if (currentTotalMinutes < prayerTotalMinutes) {
      return prayer;
    }
  }
  return dailyPrayers.first;
}