import 'package:flutter/material.dart';

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