import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muslimapp/models/prayer_model.dart' as PrayerModel;
import 'package:muslimapp/providers/time_provider.dart';
import 'package:muslimapp/providers/zone_provider.dart';
import 'package:muslimapp/services/prayer_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Import fail utiliti yang kita cipta secara manual
import '../util/hijri_util.dart';

part 'prayer_provider.g.dart';

// PROVIDER UNTUK DATA WAKTU SOLAT
@Riverpod(keepAlive: true)
class PrayerData extends _$PrayerData {
  @override
  Future<PrayerModel.PrayerData> build() async {
    final zone = ref.watch(zoneProvider);
    final prayerData = await loadPrayerTimes(zoneCode: zone);
    return prayerData;
  }
}

// PROVIDER UNTUK TARIKH HIJRIAH (GUNA KOD MANUAL)
@riverpod
String hijriDate(HijriDateRef ref) {
  final now = DateTime.now();
  final prayerDataAsync = ref.watch(prayerDataProvider);

  if (prayerDataAsync.isLoading) {
    return '...';
  }
  if (prayerDataAsync.hasError) {
    return 'Ralat Tarikh';
  }

  final prayerData = prayerDataAsync.value!;

  // Cari waktu maghrib dari dailyPrayers
  final maghribPrayer = prayerData.dailyPrayers.firstWhere(
    (p) => p.name.toLowerCase() == 'maghrib',
    orElse: () => prayerData.dailyPrayers[0],
  );
  // Gabungkan tarikh hari ini dengan waktu maghrib
  final maghribTime = DateTime(
    now.year,
    now.month,
    now.day,
    maghribPrayer.time.hour,
    maghribPrayer.time.minute,
  );

  // Jika sudah lepas maghrib, tambah 1 hari pada Gregorian sebelum convert
  DateTime gregorianForHijri = now;
  if (now.isAfter(maghribTime)) {
    gregorianForHijri = now.add(const Duration(days: 1));
  }
  var hijriDate = HijriDate.fromGregorian(gregorianForHijri);
  return hijriDate.toFormat("dd MMMM yyyy");
}