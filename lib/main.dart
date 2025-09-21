import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import provider
import 'package:muslimapp/providers/zone_provider.dart';
import 'package:muslimapp/providers/prayer_provider.dart';
import 'package:muslimapp/providers/time_provider.dart'; // 1. IMPORT PROVIDER BARU

// Import UI dan lain-lain
import 'package:muslimapp/screens/home_screen.dart';
import 'package:muslimapp/themes/themes.dart';
import 'package:muslimapp/widgets/glassmorphic_container.dart';
import 'package:muslimapp/services/prayer_service.dart';
import 'package:muslimapp/models/zone_model.dart';
import 'package:muslimapp/models/prayer_model.dart' as PrayerModel;

void main() {
  runApp(const ProviderScope(
      child: IslamVerseApp()
    )
  );
}

class IslamVerseApp extends ConsumerStatefulWidget  {
  const IslamVerseApp({super.key});

  @override
  ConsumerState<IslamVerseApp> createState() => _IslamVerseAppState();
}

class _IslamVerseAppState extends ConsumerState<IslamVerseApp> {
  // DateTime _currentTime = DateTime.now();
  // Timer? _timer;
  // late final Future<PrayerModel.PrayerData> _prayerDataFuture;

  // @override
  // void initState() {
  //   super.initState();
  //   final initialZone = ref.read(zoneProvider);
  //   _prayerDataFuture = loadPrayerTimes(zoneCode: initialZone);
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (mounted) { // Amalan baik: pastikan widget masih wujud
  //       setState(() {
  //         _currentTime = DateTime.now();
  //       });
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   _timer?.cancel();
  //   super.dispose();
  // }

  void _onZoneChanged(String? newZoneCode) {
    if (newZoneCode != null && newZoneCode != ref.read(zoneProvider)) {
      ref.read(zoneProvider.notifier).setZone(newZoneCode);
      // setState(() {
        
      //   // Panggil semula API dengan zon baru
      //   _prayerDataFuture = loadPrayerTimes(zoneCode: newZoneCode);
      // });
    }
  }

  // Fungsi yang dikemas kini: Lebih mudah dibaca dan lebih selamat
  AppTheme _getCurrentTheme(List<PrayerModel.Prayer> prayers) {
    final now = TimeOfDay.fromDateTime(DateTime.now());
    
    if (prayers.isEmpty) return AppThemes.fajr;
    final fajrTime = prayers.firstWhere((p) => p.name == 'Subuh', orElse: () => prayers[0]).time;
    final dhuhrTime = prayers.firstWhere((p) => p.name == 'Zohor', orElse: () => prayers[1]).time;
    final asrTime = prayers.firstWhere((p) => p.name == 'Asar', orElse: () => prayers[2]).time;
    final maghribTime = prayers.firstWhere((p) => p.name == 'Maghrib', orElse: () => prayers[3]).time;
    final ishaTime = prayers.firstWhere((p) => p.name == 'Isyak', orElse: () => prayers[4]).time;
    double toDouble(TimeOfDay t) => t.hour + t.minute / 60.0;
    final nowDouble = toDouble(now);
    if (nowDouble >= toDouble(fajrTime) && nowDouble < toDouble(dhuhrTime)) return AppThemes.fajr;
    if (nowDouble >= toDouble(dhuhrTime) && nowDouble < toDouble(asrTime)) return AppThemes.dhuhr;
    if (nowDouble >= toDouble(asrTime) && nowDouble < toDouble(maghribTime)) return AppThemes.asr;
    if (nowDouble >= toDouble(maghribTime) && nowDouble < toDouble(ishaTime)) return AppThemes.maghrib;
    return AppThemes.isha;
  }

  @override
  Widget build(BuildContext context) {
    final selectedZoneCode = ref.watch(zoneProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: Scaffold(
        body: Consumer(
          builder: (context,ref,child){
            final prayerDataAsync = ref.watch(prayerDataProvider);
            final currentTimeAsync = ref.watch(currentTimeProvider);

            return prayerDataAsync.when(
              data: (prayerData){
                final currentTime = currentTimeAsync.valueOrNull ?? DateTime.now();
                final currentTheme = _getCurrentTheme(prayerData.dailyPrayers);
                final backgroundTheme = AppThemes.bground;
                final nextPrayer = getNextPrayer(TimeOfDay.fromDateTime(currentTime), prayerData.dailyPrayers);

                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: backgroundTheme.backgroundGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: GlassmorphicContainer(
                    borderRadius: 0,
                    blur: 2,
                    padding: const EdgeInsets.all(0),
                    child: HomeScreen(
                      textColor: currentTheme.textColor,
                      nextPrayer: nextPrayer,
                      dailyPrayers: prayerData.dailyPrayers,
                      location: prayerData.location,
                      allZones: esolatZones,
                      selectedZoneCode: ref.watch(zoneProvider),
                      onZoneChanged: _onZoneChanged,
                    ), 
                  ),
                );
              }, 
              error: (err, stack) => Container(
                decoration: BoxDecoration(gradient: LinearGradient(colors: AppThemes.bground.backgroundGradient)),
                child: Center(child: Text('Gagal memuatkan data: $err', style: const TextStyle(color: Colors.white))),
              ), 
              loading: ()=> Container(
                decoration: BoxDecoration(gradient: LinearGradient(colors: AppThemes.bground.backgroundGradient)),
                child: const Center(child: CircularProgressIndicator(color: Colors.white)),
              )
            );
          }
        ),
      ),
    );
  }
}