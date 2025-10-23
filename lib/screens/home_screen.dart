import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:muslimapp/models/features_model.dart';
import 'package:muslimapp/models/prayer_model.dart';
import 'package:muslimapp/providers/location_provider.dart';
import 'package:muslimapp/providers/location_zone_provider.dart';
import 'package:muslimapp/providers/next_prayer_provider.dart';

import 'package:muslimapp/providers/prayer_provider.dart';
import 'package:muslimapp/services/prayer_service.dart';
import 'package:muslimapp/themes/text_styles.dart';
import 'package:muslimapp/themes/themes.dart';
import 'package:muslimapp/util/weather_util.dart';
import 'package:muslimapp/widgets/prayer_dynamic_background.dart';

import 'package:muslimapp/providers/weather_provider.dart'; // import provider
import 'package:muslimapp/util/glow_util.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyPrayersAsync = ref.watch(prayerDataProvider);

    return dailyPrayersAsync.when(
      data: (prayerData) {
        final nextPrayer = getNextPrayer(
          TimeOfDay.fromDateTime(DateTime.now()),
          prayerData.dailyPrayers,
        );
        final currentPrayer = getCurrentPrayer(
          TimeOfDay.fromDateTime(DateTime.now()),
          prayerData.dailyPrayers,
        );

        final theme = prayerThemes['isha']!;
        return PrayerDynamicBackground(
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    // Use transparent container to make sure background is visible
                    child: Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildHeader(context,ref,theme),
                            const SizedBox(height: 8),
                            _buildNextPrayerCard(context, nextPrayer, currentPrayer, ref,prayerData.dailyPrayers,theme),
                            const SizedBox(height: 32),
                            // _buildDailyPrayerList(context, prayerData.dailyPrayers, nextPrayer),
                            // const SizedBox(height: 24),
                            Text(
                              'Features',
                              style: AppTextStyles.h1(context,theme)
                            ),
                            const SizedBox(height: 10),
                            _buildFeaturesList(),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Gagal memuatkan data: $err')),
    );
  }

  Widget _buildHeader(BuildContext context,WidgetRef ref, PrayerTheme theme) {
    // final currentTimeAsync = ref.watch(currentTimeProvider);
    // final currentTime = currentTimeAsync.valueOrNull ?? DateTime.now();
    // final formattedTime = DateFormat('HH:mm:ss').format(currentTime);

    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          "Muslim App",
          style: AppTextStyles.h1(context,theme),
        ),
      ],
    );
  }

  Widget _buildNextPrayerCard(BuildContext context, Prayer nextPrayer, Prayer currentPrayer, WidgetRef ref,List<Prayer> dailyPrayers,PrayerTheme theme) {
    final formattedTime = '${nextPrayer.time.hour.toString().padLeft(2, '0')}:${nextPrayer.time.minute.toString().padLeft(2, '0')}';
    final currentHijriDate = ref.watch(hijriDateProvider);
    final weatherAsync = ref.watch(weatherProvider);
    
    // 🎯 REACTIVE LOCATION: Auto-updates when location changes
    final daerahStreamAsync = ref.watch(daerahStreamProvider);
    
    // 🕌 AUTO PRAYER ZONE: Automatically selects prayer zone based on location
    final autoZoneAsync = ref.watch(smartZoneProvider);
    
    final countdownPrayer = ref.watch(countdownProvider); 
    return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              context.go('/prayer-info/${nextPrayer.name}', extra: nextPrayer);
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: currentPrayer.colors,  // Menggunakan warna dari prayer semasa
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
          child: Column(
            children: [
              // Baris untuk judul
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currentHijriDate,
                    style: AppTextStyles.body(context,theme).copyWith(
                    fontWeight: FontWeight.bold),
                  ),
                  weatherAsync.when(
                    data: (weather) => Row(
                      children: [
                        Text(
                          "${weather.temperature.toStringAsFixed(1)}°C",
                          style: AppTextStyles.body(context,theme).copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 4),
                        Image.asset(
                          getWeatherAsset(weather.weatherCode),
                          width: AppIconSizes.normal(context),
                          height: AppIconSizes.normal(context),
                        ),// tukar ikut weatherCode jika mahu
                      ],
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (e, _) => const Text('Ralat Cuaca', style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
              const SizedBox(height: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                          Icons.location_pin,
                          size: AppIconSizes.small(context),
                          color: Colors.white,
                        ),
                        const SizedBox(height: 4),
                      
                      // 🎯 REACTIVE LOCATION DISPLAY - Auto updates when location changes
                      daerahStreamAsync.when(
                        data: (daerah) => Text(
                          daerah,
                          style: AppTextStyles.caption(context,theme),
                        ),
                        loading: () => Row(
                          children: [
                            SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.7)),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text('Mencari lokasi...',
                              style: AppTextStyles.caption(context,theme),
                            ),
                          ],
                        ),
                        error: (e, _) => Text(
                          'Ralat lokasi',
                          style: AppTextStyles.caption(context,theme).copyWith(
                            color: Colors.red.withOpacity(0.8),
                          ),
                        ),
                      ),
 
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                        )
                    ]
                           
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Text(
                      "Waktu seterusnya",
                      style: AppTextStyles.body(context,theme),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${nextPrayer.name} - $formattedTime",
                      style: AppTextStyles.h1(context,theme),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      countdownPrayer,
                      style: AppTextStyles.body(context,theme),
                    ),
                          ],
                  ),
              ),
              
              const SizedBox(height: 16),  
              _buildDailyPrayerList(context, dailyPrayers, nextPrayer,theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyPrayerList(BuildContext context, List<Prayer> dailyPrayers, Prayer nextPrayer, PrayerTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: dailyPrayers.map((prayer) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  // Navigasi ke skrin maklumat solat yang baru
                  context.go('/prayer-info/${prayer.name}', extra: prayer);
                },
                child: _buildPrayerItem(prayer, nextPrayer,context,theme),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPrayerItem(Prayer prayer, Prayer nextPrayer, BuildContext context, PrayerTheme theme) {
    final isNext = prayer.name == nextPrayer.name;
    final hour = prayer.time.hour.toString().padLeft(2, '0');
    final minute = prayer.time.minute.toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: isNext ? const Color.fromARGB(255, 156, 245, 164).withOpacity(0.85) : Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        boxShadow: isNext ? createGlowEffect(color: Colors.greenAccent) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Image.asset(
                          prayer.icon,
                          width: AppIconSizes.large(context),
                          height: AppIconSizes.large(context),
                        ),//
          Text(
            prayer.name,
            style: AppTextStyles.small(context,theme).copyWith(
              // fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
              color: isNext ? Colors.black : Colors.white,
            ), 
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '$hour:$minute',
            style: AppTextStyles.small(context,theme).copyWith(
              // fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
              color: isNext ? Colors.black : Colors.white,
            ), 
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    final List<Feature> features = [
      const Feature(icon: Icons.menu_book, label: "Doa"),
      const Feature(icon: Icons.book, label: "Al-Quran"),
      const Feature(icon: Icons.explore, label: "Kiblat"),
      const Feature(icon: Icons.access_time, label: "Haji"),
      const Feature(icon: Icons.menu_book, label: "Tasbih"),
      const Feature(icon: Icons.book, label: "Halal Finder"),
      const Feature(icon: Icons.explore, label: "Meditation"),
      const Feature(icon: Icons.access_time, label: "Mathurat"),
    ];
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        mainAxisSpacing: 18,
        crossAxisSpacing: 18,
        children: features.map((feature) {
          return _buildFeatureIcon(feature.icon, feature.label);
        }).toList(),
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 28),
        const SizedBox(height: 8),
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}