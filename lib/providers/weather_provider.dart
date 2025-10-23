import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// Contoh: Koordinat Kuala Lumpur
const double latitude = 3.139;
const double longitude = 101.6869;

final weatherProvider = FutureProvider<WeatherData>((ref) async {
  final url =
      'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final weather = data['current_weather'];
    return WeatherData(
      temperature: weather['temperature'].toDouble(),
      windspeed: weather['windspeed'].toDouble(),
      weatherCode: weather['weathercode'],
    );
  } else {
    throw Exception('Failed to load weather');
  }
});

class WeatherData {
  final double temperature;
  final double windspeed;
  final int weatherCode;

  WeatherData({
    required this.temperature,
    required this.windspeed,
    required this.weatherCode,
  });
}