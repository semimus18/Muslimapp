import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muslimapp/models/prayer_model.dart' as PrayerModel;
import 'package:muslimapp/providers/location_zone_provider.dart';
import 'package:muslimapp/providers/time_provider.dart';
import 'package:muslimapp/providers/zone_provider.dart';
import 'package:muslimapp/services/prayer_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hijri/digits_converter.dart';
import 'package:hijri/hijri_array.dart';
import 'package:hijri/hijri_calendar.dart';

// Import fail utiliti yang kita cipta secara manual
import '../util/hijri_util.dart';

part 'prayer_provider.g.dart';

// PROVIDER UNTUK DATA WAKTU SOLAT
@Riverpod(keepAlive: true)
class PrayerData extends _$PrayerData {
  @override
  Future<PrayerModel.PrayerData> build() async {
    print("🕌 PrayerData provider build() called");
    final autoZoneAsync = ref.watch(smartZoneProvider);
    print("🕌 smartZoneProvider state: $autoZoneAsync");

  return await autoZoneAsync.maybeWhen(
    data: (zone) async {
      print("🕌 PrayerData: Got zone data: ${zone.code}");
      try {
        print("zone.code"+zone.code);
        final prayerData = await loadPrayerTimes(zoneCode: zone.code);
        print("🕌 PrayerData: Successfully loaded prayer times");
        return prayerData;
      } catch (e) {
        print("Error loading prayer times: $e");
        print("🕌 PrayerData: Using fallback due to error");
        return _createFallbackPrayerData();
      }
    },
    orElse: () async {
      print("🕌 PrayerData: Using fallback due to orElse");
      return _createFallbackPrayerData();
    },
    loading: () async {
      print("🕌 PrayerData: Using fallback due to loading");
      return _createFallbackPrayerData();
    },
    error: (err, stack) async {
      print("Prayer provider error: $err");
      print("🕌 PrayerData: Using fallback due to error");
      return _createFallbackPrayerData();
    },
  );
  }

  // Create fallback prayer data when location or zone is not available
  PrayerModel.PrayerData _createFallbackPrayerData() {
    print("🕌 Creating fallback prayer data");
    // Default prayer times (approximate for Malaysia)
    final fallbackPrayers = [
      PrayerModel.Prayer(
        name: 'Subuh',
        time: const TimeOfDay(hour: 5, minute: 30),
        icon: '🌅',
        colors: [Colors.indigo.shade400, Colors.purple.shade300],
        title: 'Subuh',
        translation: 'Dawn Prayer',
      ),
      PrayerModel.Prayer(
        name: 'Syuruk',
        time: const TimeOfDay(hour: 7, minute: 0),
        icon: '☀️',
        colors: [Colors.orange.shade400, Colors.yellow.shade300],
        title: 'Syuruk',
        translation: 'Sunrise',
      ),
      PrayerModel.Prayer(
        name: 'Zohor',
        time: const TimeOfDay(hour: 13, minute: 0),
        icon: '🌞',
        colors: [Colors.blue.shade400, Colors.cyan.shade300],
        title: 'Zohor',
        translation: 'Noon Prayer',
      ),
      PrayerModel.Prayer(
        name: 'Asar',
        time: const TimeOfDay(hour: 16, minute: 30),
        icon: '🌤️',
        colors: [Colors.amber.shade400, Colors.orange.shade300],
        title: 'Asar',
        translation: 'Afternoon Prayer',
      ),
      PrayerModel.Prayer(
        name: 'Maghrib',
        time: const TimeOfDay(hour: 19, minute: 15),
        icon: '🌇',
        colors: [Colors.deepOrange.shade400, Colors.red.shade300],
        title: 'Maghrib',
        translation: 'Sunset Prayer',
      ),
      PrayerModel.Prayer(
        name: 'Isyak',
        time: const TimeOfDay(hour: 20, minute: 30),
        icon: '🌙',
        colors: [Colors.indigo.shade600, Colors.purple.shade400],
        title: 'Isyak',
        translation: 'Night Prayer',
      ),
    ];

    return PrayerModel.PrayerData(
      dailyPrayers: fallbackPrayers,
      location: 'Malaysia', // Default location
    );
  }
}

// PROVIDER UNTUK TARIKH HIJRIAH (GUNA KOD MANUAL)
@riverpod
String hijriDate(HijriDateRef ref) {
  // final now = DateTime.now();
  // final prayerDataAsync = ref.watch(prayerDataProvider);

  // if (prayerDataAsync.isLoading) {
  //   return '...';
  // }
  // if (prayerDataAsync.hasError) {
  //   return 'Ralat Tarikh';
  // }

  // final prayerData = prayerDataAsync.value!;

  // // Cari waktu maghrib dari dailyPrayers
  // final maghribPrayer = prayerData.dailyPrayers.firstWhere(
  //   (p) => p.name.toLowerCase() == 'maghrib',
  //   orElse: () => prayerData.dailyPrayers[0],
  // );
  // // Gabungkan tarikh hari ini dengan waktu maghrib
  // final maghribTime = DateTime(
  //   now.year,
  //   now.month,
  //   now.day,
  //   maghribPrayer.time.hour,
  //   maghribPrayer.time.minute,
  // );

  // // Jika sudah lepas maghrib, tambah 1 hari pada Gregorian sebelum convert
  // DateTime gregorianForHijri = now;
  // if (now.isAfter(maghribTime)) {
  //   gregorianForHijri = now.add(const Duration(days: 1));
  // }
  // var hijriDate = HijriDate.fromGregorian(gregorianForHijri);
  // return hijriDate.toFormat("dd MMMM yyyy");
  // Custom Malay month names for display
  var msLocale = [
    'Muharram',
    'Safar',
    'Rabiulawal',
    'Rabiulakhir',
    'Jamadilawal',
    'Jamadilakhir',
    'Rejab',
    'Syaban',
    'Ramadhan',
    'Syawal',
    'Zulkaedah',
    'Zulhijjah'
  ];
  // You can use msLocale manually when displaying the month name
  // Example usage:
  var hijriDate = HijriCalendar.now();
  var monthName = msLocale[hijriDate.hMonth - 1];
  return "${hijriDate.hDay} $monthName ${hijriDate.hYear}H";
}