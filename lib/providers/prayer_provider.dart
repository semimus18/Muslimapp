import 'dart:async';
import 'package:muslimapp/providers/zone_provider.dart';
import 'package:muslimapp/services/prayer_service.dart'; // Import 'Pekerja'
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Import 'Blueprint' dengan alias yang betul
import 'package:muslimapp/models/prayer_model.dart' as PrayerModel;

part 'prayer_provider.g.dart';

@Riverpod(keepAlive: true)
class PrayerData extends _$PrayerData {
  @override
  Future<PrayerModel.PrayerData> build() async {
    final zone = ref.watch(zoneProvider);
    
    // Panggil 'Pekerja' untuk mendapatkan data
    final prayerData = await loadPrayerTimes(zoneCode: zone);

    // Kembalikan data yang mengikut 'Blueprint'
    return prayerData;
  }
}