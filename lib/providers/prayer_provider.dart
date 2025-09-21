import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri_calendar/hijri_calendar.dart';
import 'package:muslimapp/models/prayer_model.dart' as PrayerModel;
import 'package:muslimapp/providers/time_provider.dart';
import 'package:muslimapp/providers/zone_provider.dart';
import 'package:muslimapp/services/prayer_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Import pakej intl
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

part 'prayer_provider.g.dart';

// -----------------------------------------------------------------
// PROVIDER UNTUK DATA WAKTU SOLAT (Async)
// -----------------------------------------------------------------
@Riverpod(keepAlive: true)
class PrayerData extends _$PrayerData {
  @override
  Future<PrayerModel.PrayerData> build() async {
    // Inisialisasi data lokal untuk intl di sini.
    await initializeDateFormatting('ms_MY', null);
    
    final zone = ref.watch(zoneProvider);
    final prayerData = await loadPrayerTimes(zoneCode: zone);
    return prayerData;
  }
}

// -----------------------------------------------------------------
// PROVIDER TARIKH HIJRIAH MENGGUNAKAN PAKEJ 'intl' YANG STABIL
// -----------------------------------------------------------------
@riverpod
String hijriDate(HijriDateRef ref) {
  final currentTimeAsync = ref.watch(currentTimeProvider);

  return currentTimeAsync.when(
    data: (now) {
      try {
        // 1. Tukar tarikh Gregorian semasa ke Hijri menggunakan kelas yang betul
        var hijriDate = HijriCalendarConfig.fromGregorian(now);
        
        // 2. Formatkan tarikh kepada String.
        // Berdasarkan struktur pakej ini, kita perlu membina String secara manual.
        return "${hijriDate.hDay} ${hijriDate.getLongMonthName()} ${hijriDate.hYear}H";
      } catch (e) {
        return 'Ralat Tarikh';
      }
    },
    loading: () => '...',
    error: (err, stack) => 'Ralat Tarikh',
  );
}