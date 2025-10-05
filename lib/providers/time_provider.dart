
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'time_provider.g.dart';

// Provider ini hanya update bila hari berubah (setiap 24 jam)
@riverpod
Stream<DateTime> currentDate(StreamProviderRef<DateTime> ref) async* {
  // Yield nilai pertama (tarikh hari ini)
  DateTime now = DateTime.now();
  yield DateTime(now.year, now.month, now.day);

  while (true) {
    // Kira masa ke tengah malam seterusnya
    now = DateTime.now();
    DateTime nextMidnight = DateTime(now.year, now.month, now.day + 1);
    Duration wait = nextMidnight.difference(now);
    await Future.delayed(wait);
    yield DateTime(nextMidnight.year, nextMidnight.month, nextMidnight.day);
  }
}

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