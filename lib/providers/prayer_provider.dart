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
  final currentTimeAsync = ref.watch(currentTimeProvider);

  return currentTimeAsync.when(
    data: (now) {
      // 1. Guna fungsi dari fail utiliti kita
      var hijriDate = HijriDate.fromGregorian(now);
      
      // 2. Formatkan tarikh kepada String
      return hijriDate.toFormat("dd MMMM yyyy");
    },
    loading: () => '...',
    error: (err, stack) => 'Ralat Tarikh',
  );
}