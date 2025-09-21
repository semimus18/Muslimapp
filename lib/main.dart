import 'dart:async';
import 'package:flutter/material.dart';
import 'package:muslimapp/screens/home_screen.dart';
import 'package:muslimapp/themes/themes.dart'; // Import fail tema kita
import 'package:muslimapp/widgets/glassmorphic_container.dart';
import 'services/prayer_service.dart';
import 'models/zone_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muslimapp/providers/zone_provider.dart';
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
  DateTime _currentTime = DateTime.now();
  Timer? _timer;
  late final Future<PrayerModel.PrayerData> _prayerDataFuture;

  @override
  void initState() {
    super.initState();
    final initialZone = ref.read(zoneProvider);
    _prayerDataFuture = loadPrayerTimes(zoneCode: initialZone);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) { // Amalan baik: pastikan widget masih wujud
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onZoneChanged(String? newZoneCode) {
    if (newZoneCode != null && newZoneCode != ref.read(zoneProvider)) {
      ref.read(zoneProvider.notifier).setZone(newZoneCode);
      setState(() {
        
        // Panggil semula API dengan zon baru
        _prayerDataFuture = loadPrayerTimes(zoneCode: newZoneCode);
      });
    }
  }

  // Fungsi yang dikemas kini: Lebih mudah dibaca dan lebih selamat
  AppTheme _getCurrentTheme(List<PrayerModel.Prayer> prayers) {
    final now = TimeOfDay.fromDateTime(_currentTime);
    
    // Fungsi untuk membandingkan masa dengan selamat
    bool isAfter(TimeOfDay time) => now.hour > time.hour || (now.hour == time.hour && now.minute >= time.minute);

    // Dapatkan waktu solat dari senarai untuk perbandingan yang tepat
    final timeFajr = prayers.firstWhere((p) => p.name == 'Fajr').time;
    final timeDhuhr = prayers.firstWhere((p) => p.name == 'Dhuhr').time;
    final timeAsr = prayers.firstWhere((p) => p.name == 'Asr').time;
    final timeMaghrib = prayers.firstWhere((p) => p.name == 'Maghrib').time;
    final timeIsha = prayers.firstWhere((p) => p.name == 'Isha').time;

    if (isAfter(timeFajr) && !isAfter(timeDhuhr)) return AppThemes.fajr;
    if (isAfter(timeDhuhr) && !isAfter(timeAsr)) return AppThemes.dhuhr;
    if (isAfter(timeAsr) && !isAfter(timeMaghrib)) return AppThemes.asr;
    if (isAfter(timeMaghrib) && !isAfter(timeIsha)) return AppThemes.maghrib;
    if (isAfter(timeIsha)) return AppThemes.isha;

    // Untuk waktu antara tengah malam dan sebelum Subuh
    return AppThemes.night;
  }

  @override
  Widget build(BuildContext context) {
    final selectedZoneCode = ref.watch(zoneProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: Scaffold(
        body: FutureBuilder<PrayerModel.PrayerData>(
          future: _prayerDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                color: Colors.blueGrey[900],
                child: const Center(child: CircularProgressIndicator(color: Colors.white)),
              );
            }

            if (snapshot.hasError) {
              // ... (bahagian ralat kekal sama)
              return Container(
                color: Colors.red[900],
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Ralat memuatkan data: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }

            if (snapshot.hasData) {
              final prayerData = snapshot.data!;
              // Hantar senarai solat ke _getCurrentTheme
              final AppTheme currentTheme = _getCurrentTheme(prayerData.dailyPrayers);
              final AppTheme backgroundTheme = AppThemes.bground;
              final currentTimeOfDay = TimeOfDay.fromDateTime(_currentTime);
              final nextPrayer = getNextPrayer(currentTimeOfDay, prayerData.dailyPrayers);

              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: backgroundTheme.backgroundGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child:GlassmorphicContainer(
                  borderRadius: 0,
                  blur: 2,
                  padding: const EdgeInsets.all(0),
                  child: HomeScreen(
                  textColor: currentTheme.textColor,
                  nextPrayer: nextPrayer,
                  dailyPrayers: prayerData.dailyPrayers,
                  location: prayerData.location,
                  // BARU: Hantar senarai zon, zon terpilih, dan fungsi callback
                  allZones: esolatZones,
                  selectedZoneCode: selectedZoneCode,
                  onZoneChanged: _onZoneChanged,
                ),
                ),
                
              );
            }

            return const Center(child: Text('Sesuatu yang tidak dijangka berlaku.'));
          },
        ),
      ),
    );
  }
}