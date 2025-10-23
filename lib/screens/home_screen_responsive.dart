// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:go_router/go_router.dart';
// import 'package:muslimapp/models/features_model.dart';
// import 'package:muslimapp/models/prayer_model.dart';
// import 'package:muslimapp/models/zone_model.dart';
// import 'package:muslimapp/providers/location_provider.dart';

// import 'package:muslimapp/providers/time_provider.dart';
// import 'package:muslimapp/providers/prayer_provider.dart';
// import 'package:muslimapp/providers/zone_provider.dart';
// import 'package:muslimapp/services/prayer_service.dart';
// import 'package:muslimapp/util/weather_util.dart';
// import 'package:muslimapp/util/responsive_util.dart'; // Import responsive utility
// import 'package:muslimapp/widgets/prayer_dynamic_background.dart';

// import 'package:muslimapp/providers/weather_provider.dart';

// class HomeScreen extends ConsumerWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final dailyPrayersAsync = ref.watch(prayerDataProvider);
//     final selectedZoneCode = ref.watch(zoneProvider);
    
//     final allZones = esolatZones;

//     return dailyPrayersAsync.when(
//       data: (prayerData) {
//         final nextPrayer = getNextPrayer(
//           TimeOfDay.fromDateTime(DateTime.now()),
//           prayerData.dailyPrayers,
//         );
//         final currentPrayer = getCurrentPrayer(
//           TimeOfDay.fromDateTime(DateTime.now()),
//           prayerData.dailyPrayers,
//         );

//         return PrayerDynamicBackground(
//           child: SafeArea(
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 // Get responsive values
//                 final isSmallScreen = constraints.maxWidth < 360;
//                 final padding = context.responsivePadding(mobile: 8, tablet: 12, desktop: 16);
//                 final fontSize = context.responsiveFontSize(mobile: 14, tablet: 16, desktop: 18);
                
//                 return SingleChildScrollView(
//                   child: ConstrainedBox(
//                     constraints: BoxConstraints(
//                       minHeight: constraints.maxHeight,
//                     ),
//                     child: Container(
//                       padding: EdgeInsets.all(padding),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Header dengan info responsive
//                           _buildResponsiveHeader(context, ref, constraints),
                          
//                           const SizedBox(height: 20),
                          
//                           // Prayer cards dengan responsive grid
//                           _buildResponsivePrayerCards(context, prayerData, constraints),
                          
//                           const SizedBox(height: 20),
                          
//                           // Features grid responsive
//                           _buildResponsiveFeatures(context, constraints),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//       loading: () => const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       ),
//       error: (error, stack) => Scaffold(
//         body: Center(
//           child: Text('Error: $error'),
//         ),
//       ),
//     );
//   }

//   /// Build responsive header with weather and location
//   Widget _buildResponsiveHeader(BuildContext context, WidgetRef ref, BoxConstraints constraints) {
//     final currentTime = ref.watch(currentTimeProvider);
//     final currentHijriDate = ref.watch(currentHijriDateProvider);
//     final weatherAsync = ref.watch(weatherProvider);
//     final daerahAsync = ref.watch(daerahProvider);
    
//     final isSmallScreen = constraints.maxWidth < 360;
//     final headerFontSize = context.responsiveFontSize(mobile: 12, tablet: 14, desktop: 16);
//     final iconSize = ResponsiveUtil.getIconSize(constraints.maxWidth, mobile: 16, tablet: 20, desktop: 24);
    
//     return Container(
//       padding: EdgeInsets.all(context.responsivePadding(mobile: 12, tablet: 16, desktop: 20)),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.3),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Column(
//         children: [
//           // Top row: Hijri date and weather
//           if (isSmallScreen)
//             // Stack layout for very small screens
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   currentHijriDate,
//                   style: TextStyle(
//                     fontSize: headerFontSize,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 8),
//                 _buildWeatherInfo(weatherAsync, headerFontSize, iconSize),
//               ],
//             )
//           else
//             // Row layout for normal screens
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Flexible(
//                   flex: 2,
//                   child: Text(
//                     currentHijriDate,
//                     style: TextStyle(
//                       fontSize: headerFontSize,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Flexible(
//                   flex: 1,
//                   child: _buildWeatherInfo(weatherAsync, headerFontSize, iconSize),
//                 ),
//               ],
//             ),
          
//           const SizedBox(height: 8),
          
//           // Bottom row: Location and time
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Flexible(
//                 flex: 3,
//                 child: _buildLocationInfo(daerahAsync, headerFontSize - 2, iconSize - 4),
//               ),
//               Flexible(
//                 flex: 2,
//                 child: Text(
//                   DateFormat('HH:mm:ss').format(currentTime),
//                   style: TextStyle(
//                     fontSize: headerFontSize,
//                     fontWeight: FontWeight.normal,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   /// Build weather information widget
//   Widget _buildWeatherInfo(AsyncValue<dynamic> weatherAsync, double fontSize, double iconSize) {
//     return weatherAsync.when(
//       data: (weather) => Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             "${weather.temperature.toStringAsFixed(0)}°C",
//             style: TextStyle(color: Colors.white, fontSize: fontSize),
//           ),
//           SizedBox(width: iconSize * 0.2),
//           Image.asset(
//             getWeatherAsset(weather.weatherCode),
//             width: iconSize,
//             height: iconSize,
//           ),
//         ],
//       ),
//       loading: () => const SizedBox.shrink(),
//       error: (e, _) => Text('Ralat', style: TextStyle(color: Colors.white, fontSize: fontSize - 2)),
//     );
//   }

//   /// Build location information widget
//   Widget _buildLocationInfo(AsyncValue<String> daerahAsync, double fontSize, double iconSize) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Flexible(
//           child: daerahAsync.when(
//             data: (daerah) => Text(
//               daerah,
//               style: TextStyle(
//                 fontSize: fontSize,
//                 fontWeight: FontWeight.normal,
//                 color: Colors.white
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//             loading: () => Text(
//               'Mencari...',
//               style: TextStyle(fontSize: fontSize, color: Colors.white70),
//             ),
//             error: (e, _) => Text(
//               'Ralat',
//               style: TextStyle(fontSize: fontSize, color: Colors.white70),
//             ),
//           ),
//         ),
//         SizedBox(width: iconSize * 0.2),
//         Icon(
//           Icons.location_pin,
//           size: iconSize,
//           color: Colors.white,
//         ),
//       ],
//     );
//   }

//   /// Build responsive prayer cards
//   Widget _buildResponsivePrayerCards(BuildContext context, dynamic prayerData, BoxConstraints constraints) {
//     final prayers = prayerData.dailyPrayers;
//     final isTablet = constraints.maxWidth > 600;
//     final isSmallScreen = constraints.maxWidth < 360;
    
//     if (isTablet) {
//       // Grid layout for tablets
//       return GridView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//           childAspectRatio: 3.5,
//         ),
//         itemCount: prayers.length,
//         itemBuilder: (context, index) {
//           final prayer = prayers[index];
//           return _buildPrayerCard(prayer, context, constraints);
//         },
//       );
//     } else {
//       // Column layout for phones
//       return Column(
//         children: prayers.map((prayer) => 
//           Padding(
//             padding: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
//             child: _buildPrayerCard(prayer, context, constraints),
//           )
//         ).toList(),
//       );
//     }
//   }

//   /// Build individual prayer card with responsive design
//   Widget _buildPrayerCard(Prayer prayer, BuildContext context, BoxConstraints constraints) {
//     final isSmallScreen = constraints.maxWidth < 360;
//     final fontSize = context.responsiveFontSize(mobile: 14, tablet: 16, desktop: 18);
//     final timeFontSize = context.responsiveFontSize(mobile: 16, tablet: 18, desktop: 20);
    
//     return Container(
//       padding: EdgeInsets.all(context.responsivePadding(mobile: 12, tablet: 16, desktop: 20)),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: Colors.white.withOpacity(0.2)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               prayer.name,
//               style: TextStyle(
//                 fontSize: fontSize,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.white,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Text(
//               prayer.time.format(context),
//               style: TextStyle(
//                 fontSize: timeFontSize,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//               textAlign: TextAlign.right,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Build responsive features grid
//   Widget _buildResponsiveFeatures(BuildContext context, BoxConstraints constraints) {
//     final features = [
//       FeatureModel(icon: Icons.qr_code, label: "QR Code", route: "/qr"),
//       FeatureModel(icon: Icons.book, label: "Al-Quran", route: "/quran"),
//       FeatureModel(icon: Icons.beenhere, label: "Tasbih", route: "/tasbih"),
//       FeatureModel(icon: Icons.location_on, label: "Qiblat", route: "/qiblat"),
//     ];

//     final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
//     final iconSize = ResponsiveUtil.getIconSize(constraints.maxWidth, mobile: 24, tablet: 28, desktop: 32);
//     final fontSize = context.responsiveFontSize(mobile: 12, tablet: 14, desktop: 16);
    
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: crossAxisCount,
//         crossAxisSpacing: 10,
//         mainAxisSpacing: 10,
//         childAspectRatio: 1.2,
//       ),
//       itemCount: features.length,
//       itemBuilder: (context, index) {
//         final feature = features[index];
//         return GestureDetector(
//           onTap: () => context.go(feature.route),
//           child: Container(
//             padding: EdgeInsets.all(context.responsivePadding(mobile: 8, tablet: 12, desktop: 16)),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(15),
//               border: Border.all(color: Colors.white.withOpacity(0.2)),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   feature.icon,
//                   size: iconSize,
//                   color: Colors.white,
//                 ),
//                 SizedBox(height: context.responsivePadding(mobile: 4, tablet: 6, desktop: 8)),
//                 Text(
//                   feature.label,
//                   style: TextStyle(
//                     fontSize: fontSize,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   textAlign: TextAlign.center,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }