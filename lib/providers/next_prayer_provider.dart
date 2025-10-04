import 'package:flutter/material.dart'; // Diperlukan untuk TimeOfDay
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muslimapp/providers/prayer_provider.dart';
import 'package:muslimapp/providers/time_provider.dart';
import 'package:muslimapp/models/prayer_model.dart' as PrayerModel;

// Kelas untuk menyimpan maklumat waktu solat seterusnya
class NextPrayerInfo {
  final String name; // Nama waktu solat (cth: "Asar")
  final DateTime time; // Masa solat dalam format DateTime

  NextPrayerInfo({required this.name, required this.time});
}

// -----------------------------------------------------------------
// PROVIDER UTAMA: Mencari Waktu Solat Seterusnya
// -----------------------------------------------------------------
final nextPrayerProvider = Provider<AsyncValue<NextPrayerInfo>>((ref) {
  final prayerDataAsync = ref.watch(prayerDataProvider);
  final currentTime = ref.watch(currentTimeProvider);

  if (prayerDataAsync is AsyncData<PrayerModel.PrayerData> && currentTime is AsyncData<DateTime>) {
    final prayerData = prayerDataAsync.value!;
    final now = currentTime.value!;

    // 1. Tukar senarai 'dailyPrayers' (yang guna TimeOfDay) kepada senarai dengan DateTime penuh
    final prayerTimesToday = prayerData.dailyPrayers.map((prayer) {
      // Gabungkan tarikh hari ini dengan waktu dari TimeOfDay
      final prayerDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        prayer.time.hour,
        prayer.time.minute,
      );
      return NextPrayerInfo(name: prayer.name, time: prayerDateTime);
    }).toList();

    // 2. Cari waktu solat pertama yang masanya SELEPAS masa sekarang
    for (final prayer in prayerTimesToday) {
      if (prayer.time.isAfter(now)) {
        // Jumpa! Inilah waktu solat seterusnya.
        return AsyncData(prayer);
      }
    }

    // 3. Jika tiada, bermakna waktu solat seterusnya ialah Subuh keesokan harinya.
    if (prayerTimesToday.isNotEmpty) {
      final subuhTomorrow = prayerTimesToday.first.time.add(const Duration(days: 1));
      return AsyncData(NextPrayerInfo(name: 'Subuh (Esok)', time: subuhTomorrow));
    }

    // Jika senarai kosong, pulangkan ralat.
    return AsyncError('Tiada data waktu solat', StackTrace.current);
  }

  if (prayerDataAsync is AsyncError) return AsyncError('Ralat Waktu Solat', StackTrace.current);
  return const AsyncLoading();
});

// -----------------------------------------------------------------
// PROVIDER KEDUA: Mengira Countdown ke Waktu Seterusnya
// -----------------------------------------------------------------
final countdownProvider = Provider<String>((ref) {
  final nextPrayerAsync = ref.watch(nextPrayerProvider);
  final currentTime = ref.watch(currentTimeProvider);

  return nextPrayerAsync.maybeWhen(
    data: (nextPrayerInfo) {
      if (currentTime is AsyncData<DateTime>) {
        final now = currentTime.value!;
        final difference = nextPrayerInfo.time.difference(now);

        // Jika waktu telah berlalu, tunjuk 'Telah Masuk' atau 0
        if (difference.isNegative) {
          return 'Telah Masuk';
        }

        final hours = difference.inHours;
        final minutes = difference.inMinutes.remainder(60);

        if (hours > 0) {
          return '$hours jam ${minutes} minit lagi';
        } else {
          return '$minutes minit lagi';
        }
      }
      return 'Mengira...';
    },
    orElse: () => 'Mengira...',
    loading: () => 'Mengira...',
    error: (err, stack) => 'Ralat',
  );
});