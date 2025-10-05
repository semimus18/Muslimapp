import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/prayer_model.dart';


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
      final String location = "${jsonResponse['zone']}";

      if (prayerTimesList.isEmpty) {
        throw Exception('Senarai waktu solat dari API adalah kosong.');
      }
      
      final Map<String, dynamic> todayData = prayerTimesList[0];

      // KOD YANG DIPERBETULKAN DAN DISAHKAN
      final List<Map<String, dynamic>> prayerInfo = [
        {
          'name': 'Fajr',
          'key': 'fajr',
          'icon': '🌅',
          'colors': ["#818CF8", "#A78BFA", "#F472B6"],
          'title': 'Subuh',
          'translation': 'Dawn',
          'description': 'Solat sebelum matahari terbit, ditandai dengan kehadiran fajar'
        },
        {
          'name': 'Dhuhr',
          'key': 'dhuhr',
          'icon': '☀️',
          'colors': ["#FBBF24", "#F97316", "#EF4444"],
          'title': 'Zohor',
          'translation': 'Noon',
          'description': 'Solat tengahari selepas matahari mencapai titik tertinggi di langit'
        },
        {
          'name': 'Asr',
          'key': 'asr',
          'icon': '🌤️',
          'colors': ["#F59E0B", "#EAB308", "#F97316"],
          'title': 'Asar',
          'translation': 'Afternoon',
          'description': 'Solat petang, apabila bayang-bayang objek menjadi sama panjang dengannya'
        },
        {
          'name': 'Maghrib',
          'key': 'maghrib',
          'icon': '🌇',
          'colors': ["#F97316", "#EF4444", "#EC4899"],
          'title': 'Maghrib',
          'translation': 'Sunset',
          'description': 'Solat selepas matahari terbenam, menandakan tamatnya waktu siang'
        },
        {
          'name': 'Isha',
          'key': 'isha',
          'icon': '🌙',
          'colors': ["#3B82F6", "#6366F1", "#8B5CF6"],
          'title': 'Isyak',
          'translation': 'Night',
          'description': 'Solat malam, apabila syafak merah telah hilang'
        },
      ];

      final List<Prayer> dailyPrayers = prayerInfo.map((p) {
        final prayerKey = p['key'] as String;
        return Prayer(
          name: p['name'] as String,
          time: _timeFromString(todayData[prayerKey]),
          icon: p['icon'] as String,
          colors: (p['colors'] as List<String>).map((hex) => _colorFromHex(hex)).toList(),
          title: p['title'] as String,
          translation: p['translation'] as String,
          description: p['description'] as String,
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

// Dapatkan waktu solat seterusnya
Prayer getNextPrayer(TimeOfDay currentTime, List<Prayer> dailyPrayers) {
  for (final prayer in dailyPrayers) {
    final prayerTotalMinutes = prayer.time.hour * 60 + prayer.time.minute;
    final currentTotalMinutes = currentTime.hour * 60 + currentTime.minute;

    if (currentTotalMinutes < prayerTotalMinutes) {
      return prayer;
    }
  }
  return dailyPrayers.first; // Kembali ke Fajr untuk hari berikutnya
}

// Dapatkan waktu solat semasa
Prayer getCurrentPrayer(TimeOfDay currentTime, List<Prayer> dailyPrayers) {
  // Salin senarai untuk operasi kita
  final prayers = List<Prayer>.from(dailyPrayers);
  
  // Tambah satu solat selepas Isha yang sama dengan Fajr untuk hari berikutnya
  // untuk menangani waktu antara Isha hari ini dan Fajr hari esok
  final nextDayFajr = Prayer(
    name: 'Next Fajr',
    time: TimeOfDay(hour: dailyPrayers.first.time.hour + 24, minute: dailyPrayers.first.time.minute),
    icon: dailyPrayers.first.icon,
    colors: dailyPrayers.first.colors,
    title: dailyPrayers.first.title,
    translation: dailyPrayers.first.translation,
    description: dailyPrayers.first.description,
  );
  prayers.add(nextDayFajr);
  
  // Cari waktu solat semasa dengan mencari waktu solat seterusnya
  // dan mengambil yang sebelumnya
  for (int i = 0; i < prayers.length; i++) {
    final prayerTotalMinutes = prayers[i].time.hour * 60 + prayers[i].time.minute;
    final currentTotalMinutes = currentTime.hour * 60 + currentTime.minute;
    
    if (currentTotalMinutes < prayerTotalMinutes) {
      // Pulangkan waktu solat sebelumnya sebagai waktu solat semasa
      // Jika ini adalah waktu solat pertama, pulangkan waktu solat terakhir
      return i > 0 ? dailyPrayers[i - 1] : dailyPrayers.last;
    }
  }
  
  // Jika semua waktu solat sudah berlalu, waktu solat semasa adalah yang terakhir
  return dailyPrayers.last;
}

// Struktur untuk menyimpan maklumat mengenai waktu solat semasa dan seterusnya
class PrayerTimingInfo {
  final Prayer currentPrayer;     // Waktu solat semasa
  final Prayer nextPrayer;        // Waktu solat seterusnya
  final int minutesToNext;        // Minit ke waktu solat seterusnya
  final double progressPercent;   // Peratusan kemajuan dalam waktu semasa (0-100)

  PrayerTimingInfo({
    required this.currentPrayer,
    required this.nextPrayer,
    required this.minutesToNext,
    required this.progressPercent,
  });
}

// Dapatkan maklumat lengkap waktu solat semasa dan seterusnya
PrayerTimingInfo getPrayerTimingInfo(TimeOfDay currentTime, List<Prayer> dailyPrayers) {
  // Salin senarai dan tambah Fajr hari seterusnya
  final prayers = List<Prayer>.from(dailyPrayers);
  
  final nextDayFajr = Prayer(
    name: 'Next Fajr',
    time: TimeOfDay(hour: dailyPrayers.first.time.hour + 24, minute: dailyPrayers.first.time.minute),
    icon: dailyPrayers.first.icon,
    colors: dailyPrayers.first.colors,
    title: dailyPrayers.first.title,
    translation: dailyPrayers.first.translation,
    description: dailyPrayers.first.description,
  );
  prayers.add(nextDayFajr);
  
  // Dapatkan minit semasa
  final currentTotalMinutes = currentTime.hour * 60 + currentTime.minute;
  
  // Cari waktu solat semasa dan seterusnya
  Prayer currentPrayer = prayers.last;
  Prayer nextPrayer = prayers.first;
  int currentPrayerIndex = -1;
  
  for (int i = 0; i < prayers.length; i++) {
    final prayerTotalMinutes = prayers[i].time.hour * 60 + prayers[i].time.minute;
    
    if (currentTotalMinutes < prayerTotalMinutes) {
      // Waktu solat seterusnya ditemui
      nextPrayer = prayers[i];
      
      // Waktu solat semasa adalah yang sebelumnya
      currentPrayerIndex = i - 1;
      if (currentPrayerIndex >= 0) {
        currentPrayer = prayers[currentPrayerIndex];
      } else {
        // Sebelum solat pertama, jadi waktu solat semasa ialah yang terakhir dari hari sebelumnya
        currentPrayer = dailyPrayers.last;
        currentPrayerIndex = dailyPrayers.length - 1;
      }
      break;
    }
  }
  
  // Kira minit ke waktu solat seterusnya
  final nextPrayerTotalMinutes = nextPrayer.time.hour * 60 + nextPrayer.time.minute;
  final minutesToNext = nextPrayerTotalMinutes - currentTotalMinutes;
  
  // Kira peratusan kemajuan dalam waktu semasa
  double progressPercent = 0;
  if (currentPrayerIndex >= 0) {
    final currentPrayerStart = currentPrayer.time.hour * 60 + currentPrayer.time.minute;
    final totalInterval = nextPrayerTotalMinutes - currentPrayerStart;
    final elapsedTime = currentTotalMinutes - currentPrayerStart;
    
    if (totalInterval > 0) {
      progressPercent = (elapsedTime / totalInterval) * 100;
      progressPercent = progressPercent.clamp(0, 100); // Pastikan dalam julat 0-100
    }
  }
  
  // Sesuaikan balik ke senarai asal jika perlu
  if (nextPrayer.name == 'Next Fajr') {
    nextPrayer = dailyPrayers.first;
  }
  
  return PrayerTimingInfo(
    currentPrayer: currentPrayer,
    nextPrayer: nextPrayer,
    minutesToNext: minutesToNext,
    progressPercent: progressPercent,
  );
}