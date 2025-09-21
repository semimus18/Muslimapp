import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'time_provider.g.dart';

// Provider ini akan menghasilkan (yield) nilai baru setiap saat.
@riverpod
Stream<DateTime> currentTime(CurrentTimeRef ref) {
  // Stream.periodic mencipta satu stream yang mengeluarkan data
  // pada selang masa yang ditetapkan (setiap 1 saat).
  // Setiap kali ia 'tick', kita kembalikan DateTime.now() yang terkini.
  return Stream.periodic(
    const Duration(seconds: 1),
    (_) => DateTime.now(),
  );
}