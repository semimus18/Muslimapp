import 'package:flutter/material.dart';

String getWeatherAsset(int weatherCode) {
  if (weatherCode == 0) return 'weather/sunny.png';
  if ([1,2,3].contains(weatherCode)) return 'weather/cloudy.png';
  if ([45,48].contains(weatherCode)) return 'weather/fog.png';
  if ([51,53,55,61,63,65,80,81,82].contains(weatherCode)) return 'weather/rain.png';
  if ([71,73,75,77,85,86].contains(weatherCode)) return 'weather/snow.png';
  if ([95,96,99].contains(weatherCode)) return 'weather/thunder.png';
  return 'weather/unknown.png';
}