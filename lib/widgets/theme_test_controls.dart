import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muslimapp/providers/theme_test_provider.dart';
import 'package:muslimapp/widgets/prayer_dynamic_background.dart';

class ThemeTestControls extends ConsumerWidget {
  const ThemeTestControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the current test period from provider
    final currentTestPeriod = ref.watch(testPrayerPeriodProvider);
    
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Theme Test Panel',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    // Reset to default (null means use automatic detection)
                    ref.read(testPrayerPeriodProvider.notifier).state = null;
                  },
                  tooltip: 'Reset to automatic theme',
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Current theme: ${currentTestPeriod != null ? getPrayerPeriodName(currentTestPeriod) : "Auto (Dhuhr)"}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.color_lens),
                label: const Text('Try Next Theme'),
                onPressed: () {
                  // Set to next prayer period for testing
                  final nextPeriod = getNextPrayerPeriod(currentTestPeriod);
                  ref.read(testPrayerPeriodProvider.notifier).state = nextPeriod;
                },
              ),
            ),
            const SizedBox(height: 8),
            // Show all available themes in a grid
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: PrayerPeriod.values.map((period) {
                final isSelected = currentTestPeriod == period;
                return ActionChip(
                  avatar: isSelected ? const Icon(Icons.check, size: 18) : null,
                  backgroundColor: isSelected 
                      ? Theme.of(context).primaryColor.withOpacity(0.2)
                      : null,
                  label: Text(getPrayerPeriodName(period).split(' ').first),
                  onPressed: () {
                    // Set to specific prayer period
                    ref.read(testPrayerPeriodProvider.notifier).state = period;
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}