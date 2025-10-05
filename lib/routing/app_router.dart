import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muslimapp/models/prayer_model.dart';
import 'package:muslimapp/screens/home_screen.dart';
import 'package:muslimapp/screens/main_navigation_screen.dart';
import 'package:muslimapp/screens/prayer_info_screen.dart';
import 'package:muslimapp/screens/prayer_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const MainNavigationScreen(),
      ),
      GoRoute(
        path: '/prayer/:prayerName',
        name: 'prayerDetails',
        builder: (context, state) {
          final prayerName = state.pathParameters['prayerName']!;
          return PrayerScreen();
        },
      ),
      GoRoute(
        path: '/prayer-info/:prayerId',
        name: 'prayerInfo',
        builder: (context, state) {
          // The Prayer object needs to be passed via extra parameter
          final prayer = state.extra as Prayer;
          return PrayerInfoScreen(prayer: prayer);
        },
      ),
    ],
  );
});