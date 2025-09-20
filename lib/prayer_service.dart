import 'package:flutter/material.dart';
import 'prayer_model.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class PrayerData {
  final String location;
  final List <Prayer> dailyPrayers;

  PrayerData({required this.location,required this.dailyPrayers});
}

Color _colorFromHex(String hexColor){
  hexColor = hexColor.replaceAll("#", "");
  return Color(int.parse('FF$hexColor',radix: 16));
}

TimeOfDay _timeFromString(String timeStr){
  final parts = timeStr.split(':');
  return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  
}

Future<PrayerData> loadPrayerTimes() async{
  final String jsonString = await rootBundle.loadString('assets/data/prayer_times.json');
  final Map<String,dynamic> jsonMap = await json.decode(jsonString);
  final String location = jsonMap['location'];
  final List<dynamic> prayersJson = jsonMap['prayers'];
  final List<Prayer> dailyPrayers = prayersJson.map((p){
    final List<Color> colors = (p['colors'] as List<dynamic>).map((hex) => _colorFromHex(hex as String)).toList();
    return Prayer(
      name: p['name'],
      time: _timeFromString(p['time']),
      icon: p['icon'],
      colors: colors
    );
  }).toList();
  return PrayerData(location: location,dailyPrayers: dailyPrayers);
}


Prayer getNextPrayer(TimeOfDay currentTime, List<Prayer> dailyPrayers){
  for(final prayer in dailyPrayers){
    final prayerTotalMinutes = prayer.time.hour * 60 + prayer.time.minute;
    final currentTotalMinutes = currentTime.hour * 60 + currentTime.minute;

    if(currentTotalMinutes <prayerTotalMinutes){
      return prayer;
    }
  }
  return dailyPrayers.first;
}