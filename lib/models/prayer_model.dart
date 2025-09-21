import 'package:flutter/material.dart';

class PrayerData {
  final List<Prayer> dailyPrayers;
  final String location;

  PrayerData({
    required this.dailyPrayers,
    required this.location,
  });
}

class Prayer {
  final String name;
  final TimeOfDay time;
  final String icon;
  final List<Color> colors;

  const Prayer({
    required this.name,
    required this.time,
    required this.icon,
    required this.colors,
  });
}