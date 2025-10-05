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
  final String title; // Prayer title in malay language
  final String translation; // English translation
  final String description; // Optional description about the prayer

  const Prayer({
    required this.name,
    required this.time,
    required this.icon,
    required this.colors,
    this.title = '', // Default empty string
    this.translation = '', // Default empty string
    this.description = '', // Default empty string
  });
}