import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muslimapp/providers/nav_provider.dart';
import 'package:muslimapp/screens/dhikir_screen.dart';
import 'package:muslimapp/screens/goal_screen.dart';
import 'package:muslimapp/screens/home_screen.dart';
import 'package:muslimapp/screens/prayer_screen.dart';
import 'package:muslimapp/screens/qiblat_screen.dart';

class MainNavigationScreen extends ConsumerWidget{
  const MainNavigationScreen({super.key});

  final List<Widget> _screens = const[
    HomeScreen(),
    PrayerScreen(),
    GoalScreen(),
    QiblatScreen(),
    DhikirScreen(),
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navIndexProvider);
    return Scaffold(
      // Guna IndexedStack untuk simpan state setiap screen bila tukar tab
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => ref.read(navIndexProvider.notifier).state = index,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.access_time_outlined), activeIcon: Icon(Icons.access_time), label: 'Prayer'),
          BottomNavigationBarItem(icon: Icon(Icons.flag_outlined), activeIcon: Icon(Icons.flag), label: 'Goal'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), activeIcon: Icon(Icons.explore), label: 'Qiblat'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), activeIcon: Icon(Icons.menu_book), label: 'Dhikir'),
        ],

        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
        elevation: 5,
      ),
    );
  }
}